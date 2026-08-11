# External Recruitment Gateway

## Chapter 12 – Salesforce to External Recruitment Integration

## Overview

The **External Recruitment Gateway** is an integration module within the Placement Management System. Its purpose is to connect Salesforce with an external recruitment application.

Whenever a student's application reaches the **Selected** status, Salesforce prepares the candidate information and sends it to the external recruitment platform through a **REST API callout**.

The integration uses the following Salesforce and integration concepts:

* Apex
* Queueable Apex
* HTTP Callouts
* REST APIs
* JSON
* Named Credentials
* Error Handling
* Integration Status Tracking
* Retry Processing
* Idempotency
* Duplicate Prevention

---

# 1. Business Requirement

The Placement Management System maintains student applications and their selection details in Salesforce.

After a student is selected for a particular job, the external recruitment platform also needs the student's information. Therefore, Salesforce must communicate the selected candidate's details to the external system.

The integration is responsible for:

1. Identifying when an application changes to **Selected**.
2. Collecting the required candidate and job information.
3. Creating the API request.
4. Sending the candidate details to the external recruitment system.
5. Reading and processing the API response.
6. Updating the integration status in Salesforce.
7. Recording useful information when an error occurs.
8. Retrying suitable temporary failures.
9. Avoiding duplicate candidate creation during repeated processing.

---

# 2. Integration Architecture

The overall integration flow is:

```text
Application
     |
     | Status changes to Selected
     v
Application Trigger
     |
     v
Service Layer
     |
     v
Queueable Apex
     |
     v
Named Credential
     |
     v
REST API Callout
     |
     v
External Recruitment Platform
     |
     v
HTTP Response
     |
     +-------------------+
     |                   |
     v                   v
  Success              Failure
     |                   |
     v                   v
Update Status       Error Handling
  as Success             |
                         v
                  Integration Status
                         |
                         v
                       Retry
```

## Why Queueable Apex?

The external recruitment application does not need to respond before the Salesforce transaction finishes.

For this reason, the API communication is handled asynchronously using **Queueable Apex**.

This approach prevents the Salesforce user's transaction from being unnecessarily dependent on the response time or availability of the external application.

---

# 3. API Definition

## HTTP Method

```text
POST
```

## Resource

```text
/candidates
```

The external API endpoint should not be directly written inside Apex. Instead, Salesforce uses a **Named Credential** to manage the endpoint and authentication configuration.

For example:

```text
callout:Recruitment_API/candidates
```

This keeps the endpoint configuration separate from the application logic.

---

# 4. Candidate Request Data

The external recruitment system receives the information required to identify and process the selected candidate.

The request can contain:

* Student Id
* Student Name
* Email
* Branch
* CGPA
* Job Id
* Company
* Job Role
* Selection Date

## Sample Request

```json
{
    "studentId": "S101",
    "name": "Student Name",
    "email": "student@example.com",
    "branch": "CSE",
    "cgpa": 8.7,
    "jobId": "J101",
    "company": "ABC Technologies",
    "role": "Software Engineer",
    "selectionDate": "2026-08-11"
}
```

The JSON payload should be produced through Apex serialization instead of manually concatenating strings.

---

# 5. Successful API Response

The external system can return a successful HTTP response such as:

```text
200 OK
```

or:

```text
201 Created
```

A possible response body is:

```json
{
    "success": true,
    "externalCandidateId": "EXT101"
}
```

When the external system successfully accepts the candidate:

```text
Integration Status = Success
```

If the external system provides a candidate identifier, Salesforce can store that value in the application record for future reference.

---

# 6. Handling HTTP Errors

Different HTTP status codes indicate different types of problems.

| HTTP Code | Description                         | Salesforce Action                      |
| --------- | ----------------------------------- | -------------------------------------- |
| 200       | Request completed successfully      | Set status to Success                  |
| 201       | Candidate/resource created          | Set status to Success                  |
| 204       | Successful response without content | Treat as success when applicable       |
| 400       | Invalid request                     | Record failure and review request data |
| 401       | Authentication problem              | Record authentication failure          |
| 403       | Access not permitted                | Record authorization failure           |
| 404       | Requested resource unavailable      | Record integration failure             |
| 500       | External server failure             | Record error and consider retry        |

The integration should classify errors rather than treating every HTTP failure identically.

---

# 7. Salesforce Implementation

The main Apex classes can be organized as follows:

```text
CandidateSyncService.cls
CandidateSyncQueueable.cls
```

When a trigger-handler pattern is used, the project can also contain:

```text
ApplicationTrigger.trigger
ApplicationTriggerHandler.cls
```

## CandidateSyncService

The service class contains the business-level integration logic.

Its responsibilities include:

* Preparing the synchronization request.
* Coordinating the candidate synchronization process.
* Passing the required application information to the asynchronous job.

## CandidateSyncQueueable

The Queueable class handles the asynchronous callout process.

It should implement:

```apex
Queueable
Database.AllowsCallouts
```

This allows the integration request to execute outside the original Salesforce transaction while still permitting HTTP communication with the external system.

---

# 8. Named Credential Configuration

Salesforce uses a **Named Credential** for the external recruitment API.

Example:

```text
Recruitment_API
```

Apex can reference the configured endpoint using:

```apex
callout:Recruitment_API
```

## Benefits of Named Credentials

Using Named Credentials provides several advantages:

* Better security
* Easier maintenance
* Centralized configuration
* Easier credential rotation
* Separation of credentials from application logic

Sensitive information such as passwords, API keys, access tokens, and other secrets should never be stored directly inside Apex or committed to GitHub.

---

# 9. Authentication and Authorization

## Authentication

Authentication establishes the identity of the system making the API request.

Examples include:

* Username/password-based credentials
* OAuth authentication
* Other supported authentication mechanisms

The exact mechanism depends on the external recruitment platform.

## Authorization

Authorization determines what an authenticated system is permitted to access or perform.

Therefore, the Salesforce integration must have the necessary permissions to communicate with the external recruitment platform.

---

# 10. Integration Status Tracking

The Salesforce application record should maintain the current state of the external synchronization.

A field such as:

```text
Integration Status
```

can be used.

Possible values include:

```text
Pending
Success
Failed
Retry
```

## Additional Tracking Fields

The following fields can provide better visibility:

```text
Integration Error
External Candidate Id
Integration Attempts
```

For example:

```text
Integration Status: Failed

Integration Error:
External server returned HTTP 500.

Integration Attempts:
2
```

This information allows administrators to understand the integration state directly from Salesforce instead of depending only on Apex debug logs.

---

# 11. Error Management

The integration should handle both HTTP-level errors and Apex exceptions.

## HTTP 400 – Bad Request

```text
Bad Request
```

This normally indicates that the request contains invalid or incomplete information.

The request data should be reviewed before attempting another request.

## HTTP 401 – Authentication Failure

```text
Authentication Failure
```

The Named Credential and authentication configuration should be checked.

## HTTP 500 – External Server Error

```text
External Server Error
```

This may represent a temporary problem in the external system. Depending on the retry rules, this type of failure can be retried.

## Callout Exception

If Salesforce encounters an exception while performing the callout, the integration should:

1. Capture the exception.
2. Mark the integration as failed.
3. Store meaningful error information.
4. Apply the retry strategy when appropriate.

---

# 12. Retry Mechanism

Temporary integration failures may be retried.

For example:

```text
Attempt 1
   |
   v
HTTP 500
   |
   v
Failure
   |
   v
Retry
   |
   v
Attempt 2
   |
   v
HTTP 201
   |
   v
Success
```

However, every failure should not automatically result in another request.

For example:

```text
401 Authentication Failure
```

should normally be investigated and corrected instead of repeatedly retrying the same request.

Retry processing should mainly target failures that are likely to be temporary.

---

# 13. Idempotency and Duplicate Protection

External API requests can occasionally be processed more than once.

For example:

```text
Salesforce
     |
     | Request
     v
External System
     |
     | Candidate created
     |
     X Response lost
```

Salesforce may interpret the missing response as a failure and send the request again.

If the external system does not recognize the repeated request, the same candidate could be created twice.

To avoid this, the integration should use a unique business identifier such as:

```text
Application Id
```

or another suitable external reference/idempotency key.

Example:

```json
{
    "applicationId": "APP001",
    "studentId": "S101",
    "name": "Student Name"
}
```

The external application can use this identifier to determine whether the same business operation has already been processed.

---

# 14. Synchronous and Asynchronous Processing

The candidate synchronization process uses:

```text
Asynchronous Processing
```

## Reason

The user does not need to wait for the external recruitment system to complete its processing.

The Salesforce transaction can finish first:

```text
Application → Selected
```

The integration then continues in the background:

```text
Queueable Apex
       |
       v
External Recruitment API
```

This separates the Salesforce business transaction from the external communication process.

---

# 15. Complete Integration Flow

## Step 1 – Application Exists

A student application is available in Salesforce.

Initially:

```text
Application Status = Applied
```

## Step 2 – Application Is Selected

The placement team changes the status:

```text
Applied → Selected
```

## Step 3 – Status Change Is Detected

Salesforce automation identifies the transition to the **Selected** state.

## Step 4 – Integration Job Is Queued

The Queueable Apex job is submitted.

Example:

```apex
System.enqueueJob(
    new CandidateSyncQueueable(applicationId)
);
```

## Step 5 – Retrieve Required Data

The Queueable Apex class retrieves the required:

* Student information
* Application information
* Job information

## Step 6 – Build JSON Payload

Apex converts the candidate information into the required JSON structure.

## Step 7 – Perform Callout

The request is sent through the configured Named Credential.

## Step 8 – External Processing

The external recruitment system receives and processes the candidate.

## Step 9 – Receive Response

Salesforce receives the HTTP response.

## Step 10 – Update Integration Status

The application record is updated according to the response:

```text
Success
```

or:

```text
Failed
```

---

# 16. Reliability Considerations

The integration should be designed with reliability in mind.

## 16.1 Failure Isolation

A failure in the external recruitment platform should not incorrectly change the actual Salesforce business result.

For example:

```text
Student Selection = Selected
```

can remain true even when:

```text
External Integration = Failed
```

These represent two different business states.

The student can remain selected while the external synchronization is handled separately.

---

## 16.2 Observability

The system should maintain useful integration information such as:

```text
Integration Status
Integration Error
External Candidate Id
Integration Attempts
```

This provides administrators with visibility into the synchronization process.

---

## 16.3 Retry

Temporary external failures should be eligible for retry according to the defined retry rules.

---

## 16.4 Idempotency

Repeated requests for the same business transaction should not produce duplicate candidate records.

---

## 16.5 Secure Configuration

Endpoint and authentication details should be managed through Named Credentials instead of being embedded in Apex.

---

# 17. Testing Approach

The integration should be tested using Apex test classes and mocked HTTP responses.

The important test cases include the following.

## Test Case 1 – Successful Request

Simulate:

```text
HTTP 200
```

Expected result:

```text
Integration Status = Success
```

---

## Test Case 2 – Candidate Creation

Simulate:

```text
HTTP 201
```

Expected result:

```text
Integration Status = Success
External Candidate Id = Populated
```

---

## Test Case 3 – Invalid Request

Simulate:

```text
HTTP 400
```

Expected result:

```text
Integration Status = Failed
Integration Error = Populated
```

---

## Test Case 4 – Authentication Failure

Simulate:

```text
HTTP 401
```

Expected result:

```text
Integration Status = Failed
```

---

## Test Case 5 – External Server Error

Simulate:

```text
HTTP 500
```

Expected result:

```text
Integration Status = Failed
```

The request should also be evaluated against the retry rules.

---

## Test Case 6 – Callout Exception

Simulate a callout exception.

Verify that:

* The exception is handled.
* Integration status is updated.
* Error details are recorded correctly.

---

## Test Case 7 – Duplicate Request

Process the same application more than once.

Verify that the selected business identifier/idempotency mechanism prevents duplicate candidate creation.

---

# 18. Salesforce Project Structure

A possible Salesforce project structure is:

```text
external-recruitment-gateway/
│
├── README.md
│
└── force-app/
    └── main/
        └── default/
            │
            ├── classes/
            │   ├── CandidateSyncQueueable.cls
            │   ├── CandidateSyncQueueable.cls-meta.xml
            │   ├── CandidateSyncService.cls
            │   ├── CandidateSyncService.cls-meta.xml
            │   └── CandidateSyncQueueableTest.cls
            │
            ├── triggers/
            │   ├── ApplicationTrigger.trigger
            │   └── ApplicationTrigger.trigger-meta.xml
            │
            └── objects/
                └── Application__c/
```

The exact Salesforce object and field API names depend on the implementation of the Placement Management System.

---

# 19. Development Sprints

## Sprint 32 – Basic External Integration

### Goal

Create the initial connection between Salesforce and the external recruitment platform.

### Tasks

* Define the REST API contract.
* Identify the request fields.
* Define the expected response structure.
* Configure the Named Credential.
* Create the Queueable Apex class.
* Implement the HTTP POST request.
* Serialize candidate information into JSON.
* Handle successful responses.
* Handle HTTP errors.

### Expected Flow

```text
Salesforce
    ↓
Queueable Apex
    ↓
Named Credential
    ↓
REST API
    ↓
External Recruitment Platform
```

---

# Sprint 33 – Integration Reliability

### Goal

Improve the integration so that it can handle failures and repeated requests reliably.

### Tasks

* Create Integration Status tracking.
* Add Integration Error information.
* Store External Candidate Id.
* Track Integration Attempts.
* Handle different failure types.
* Define retry rules.
* Implement duplicate prevention.
* Implement idempotency.
* Improve administrator visibility.
* Increase test coverage.

### Expected Result

The integration should work not only during a successful API request but also behave correctly when the external system is unavailable or returns an error.

---

# Sprint 34 – Integration Architecture

## Integration A – Immediate Verification

When the user requires an immediate response from an external system, synchronous processing can be used.

```text
LWC
 ↓
Apex
 ↓
External API
 ↓
Response
 ↓
LWC
```

---

## Integration B – Candidate Synchronization

Candidate synchronization can be handled asynchronously.

```text
Trigger
 ↓
Service
 ↓
Queueable
 ↓
Callout
 ↓
External Recruitment System
```

---

## Integration C – Large Data Synchronization

For a large scheduled synchronization process, Batch Apex can be combined with Scheduled Apex.

```text
Scheduled Apex
      ↓
Batch Apex
      ↓
External Integration
      ↓
Error Handling
      ↓
Retry
```

---

# 20. Important Concepts

This integration demonstrates knowledge of the following concepts:

* API
* REST API
* HTTP
* GET
* POST
* PUT
* PATCH
* DELETE
* HTTP Request
* HTTP Response
* HTTP Status Codes
* JSON
* Apex Callouts
* HttpRequest
* Http
* HttpResponse
* Queueable Apex
* Named Credentials
* Authentication
* Authorization
* Auth Providers
* Error Handling
* Retry Mechanisms
* Idempotency
* Duplicate Prevention
* Salesforce Connect
* External Objects
* Point-to-Point Integration
* Middleware
* Synchronous Integration
* Asynchronous Integration
* Scheduled Apex
* Batch Apex

---

# 21. Interview Questions

## What is an API?

An API defines a way for two different software systems to exchange information and interact with each other.

## What is a REST API?

A REST API is an API architecture that uses HTTP operations such as GET, POST, PUT, PATCH, and DELETE to communicate between applications. Data is commonly exchanged using JSON.

## What is an Apex Callout?

An Apex callout is an HTTP request initiated from Salesforce to communicate with an external system.

## Why is Queueable Apex used?

Queueable Apex allows integration work to execute asynchronously. This prevents the Salesforce transaction from having to wait for the external system.

## Why should Named Credentials be used?

Named Credentials provide a secure and centralized way to configure external endpoints and authentication details without hard-coding sensitive information into Apex.

## What is the difference between Authentication and Authorization?

Authentication answers:

```text
Who are you?
```

Authorization answers:

```text
What are you allowed to access or perform?
```

## What is Idempotency?

Idempotency ensures that processing the same business request multiple times does not unintentionally produce duplicate results.

## Why maintain Integration Status?

Integration status allows Salesforce administrators to identify whether the external synchronization is:

```text
Pending
Success
Failed
Retry
```

It also provides visibility into integration problems without requiring administrators to inspect debug logs.

## When should an integration be synchronous?

Synchronous processing is appropriate when the user needs the external system's response immediately before continuing the business process.

## When should an integration be asynchronous?

Asynchronous processing is suitable when the external communication can happen in the background and the user does not need to wait for the result.

## What is Middleware?

Middleware is a software layer positioned between systems that can perform tasks such as:

* Routing
* Data transformation
* Orchestration
* Monitoring
* Retry processing
* System-to-system communication

---

# 22. Final Result

The **External Recruitment Gateway** establishes a reliable communication mechanism between the Salesforce Placement Management System and an external recruitment platform.

The final processing flow is:

```text
                 SALESFORCE
                     |
                     v
             Placement System
                     |
                     v
                 Application
                     |
                     v
              Status = Selected
                     |
                     v
                  Trigger
                     |
                     v
                  Service
                     |
                     v
              Queueable Apex
                     |
                     v
              Named Credential
                     |
                     v
                 REST API
                     |
                     v
       External Recruitment System
                     |
                     v
              HTTP Response
                 /       \
                /         \
           Success       Failure
              |             |
              v             v
           Success        Failed
                            |
                            v
                          Retry
                            |
                            +-------> Success
```

The implementation demonstrates how Salesforce can communicate with external applications while keeping business logic, asynchronous processing, authentication, error handling, retry processing, and duplicate prevention as separate concerns.

The resulting design provides a structured and maintainable approach for synchronizing selected student candidates with an external recruitment platform.

