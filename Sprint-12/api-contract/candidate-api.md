# Candidate API Contract

## Endpoint

POST /candidates

## Purpose

Send selected candidate information from Salesforce to the external recruitment system.

## Request

```json
{
  "studentId": "STU10045",
  "name": "priyanka",
  "email": "priyanka@gmailcom",
  "branch": "IT",
  "cgpa": 9.13,
  "jobId": "JOB1007",
  "company": "KSquare",
  "role": "Salesforce Developer",
  "selectionDate": "2026-08-11"
}
