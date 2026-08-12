public class CandidateSyncQueueable
    implements Queueable, Database.AllowsCallouts {

    private Id applicationId;

    public CandidateSyncQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        Application__c application;

        try {

            /*
             * 1. Query Application
             *
             * IMPORTANT:
             * Replace the fields below if your org uses
             * different API names.
             */

            application = [
                SELECT
                    Id,
                    Status__c,
                    Student__c,
                    Job__c,
                    Integration_Status__c,
                    External_Candidate_Id__c
                FROM Application__c
                WHERE Id = :applicationId
                LIMIT 1
            ];

            /*
             * 2. Idempotency Check
             *
             * If the candidate has already been successfully
             * sent, do not send it again.
             */

            if (application.Integration_Status__c == 'Sent') {
                return;
            }

            /*
             * 3. Mark integration as Pending
             */

            application.Integration_Status__c = 'Pending';
            application.Last_Integration_Attempt__c = System.now();

            update application;

            /*
             * 4. Build Candidate Data
             *
             * Replace these values with the actual Student
             * and Job relationship fields in your org.
             */

            Map<String, Object> candidate =
                buildCandidateData(application);

            /*
             * 5. Convert candidate data to JSON
             */

            String requestBody =
                JSON.serialize(candidate);

            /*
             * 6. Create HTTP Request
             */

            HttpRequest request =
                new HttpRequest();

            /*
             * Named Credential:
             *
             * Recruitment_API
             */

            request.setEndpoint(
                'callout:Recruitment_API/candidates'
            );

            request.setMethod('POST');

            request.setHeader(
                'Content-Type',
                'application/json'
            );

            request.setBody(requestBody);

            /*
             * 7. Send HTTP Request
             */

            Http http = new Http();

            HttpResponse response =
                http.send(request);

            /*
             * 8. Process Response
             */

            processResponse(
                application,
                response
            );

        } catch (Exception e) {

            /*
             * Unexpected Apex error
             */

            updateFailure(
                applicationId,
                'Unexpected Error: ' + e.getMessage()
            );
        }
    }

    /*
     * Build candidate JSON data
     */

    private static Map<String, Object> buildCandidateData(
        Application__c application
    ) {

        Map<String, Object> candidate =
            new Map<String, Object>();

        /*
         * These are placeholders based on the Sprint 11
         * candidate contract.
         *
         * Replace them with your actual Student__c
         * and Job__c relationships.
         */

        candidate.put(
            'applicationId',
            application.Id
        );

        candidate.put(
            'studentId',
            String.valueOf(application.Student__c)
        );

        candidate.put(
            'jobId',
            String.valueOf(application.Job__c)
        );

        return candidate;
    }

    /*
     * Process external API response
     */

    private static void processResponse(
        Application__c application,
        HttpResponse response
    ) {

        Integer statusCode =
            response.getStatusCode();

        String responseBody =
            response.getBody();

        /*
         * Success
         */

        if (
            statusCode == 200 ||
            statusCode == 201 ||
            statusCode == 204
        ) {

            application.Integration_Status__c =
                'Sent';

            application.Integration_Error__c =
                null;

            /*
             * If API returns an external candidate ID,
             * parse it here.
             */

            if (
                statusCode != 204 &&
                String.isNotBlank(responseBody)
            ) {

                try {

                    Map<String, Object> responseData =
                        (Map<String, Object>)
                        JSON.deserializeUntyped(
                            responseBody
                        );

                    if (
                        responseData.containsKey(
                            'candidateId'
                        )
                    ) {

                        application.External_Candidate_Id__c =
                            String.valueOf(
                                responseData.get(
                                    'candidateId'
                                )
                            );
                    }

                } catch (Exception e) {

                    // Response was successful,
                    // but response body could not be parsed.
                }
            }
        }

        /*
         * Bad Request
         */

        else if (statusCode == 400) {

            application.Integration_Status__c =
                'Failed';

            application.Integration_Error__c =
                '400 Bad Request: ' +
                responseBody;
        }

        /*
         * Authentication Failure
         */

        else if (statusCode == 401) {

            application.Integration_Status__c =
                'Failed';

            application.Integration_Error__c =
                '401 Authentication Failure: ' +
                responseBody;
        }

        /*
         * Authorisation Failure
         */

        else if (statusCode == 403) {

            application.Integration_Status__c =
                'Failed';

            application.Integration_Error__c =
                '403 Forbidden: ' +
                responseBody;
        }

        /*
         * Server Error
         *
         * Potentially retryable
         */

        else if (statusCode == 500) {

            application.Integration_Status__c =
                'Retry Required';

            application.Integration_Error__c =
                '500 Server Error: ' +
                responseBody;
        }

        /*
         * Unexpected Response
         */

        else {

            application.Integration_Status__c =
                'Failed';

            application.Integration_Error__c =
                'Unexpected HTTP ' +
                statusCode +
                ': ' +
                responseBody;
        }

        update application;
    }

    /*
     * Handle unexpected Apex errors
     */

    private static void updateFailure(
        Id applicationId,
        String errorMessage
    ) {

        Application__c application = [
            SELECT
                Id,
                Integration_Status__c,
                Integration_Error__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Integration_Status__c =
            'Failed';

        application.Integration_Error__c =
            errorMessage;

        application.Last_Integration_Attempt__c =
            System.now();

        update application;
    }
}
