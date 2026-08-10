# Placement Management System – Business Transaction Service

## Project Overview

This sprint focused on implementing a complete **business transaction using Salesforce Apex, SOQL, and DML** for the Placement Management System.

The application retrieves relevant business information, validates eligibility rules, prevents duplicate applications, creates application records, and updates application status.

---

## Technologies Used

- Salesforce CRM
- Apex
- SOQL
- DML
- Developer Console

---

## Custom Objects

### Student

Stores student information required for placement eligibility.

**Fields:**

- Student Name
- CGPA
- Branch
- Backlogs
- Email

---

### Job

Stores available placement opportunities and their eligibility requirements.

**Fields:**

- Job Title
- Minimum CGPA
- Eligible Branch
- Maximum Backlogs
- Application Deadline

---

### Application

Stores job applications submitted by students.

**Fields:**

- Student (Lookup)
- Job (Lookup)
- Status
- Interview Date

---

## Apex Service

### `PlacementApplicationService`

The service class handles the complete application transaction.

**Methods:**

- `getStudent()`
- `getJob()`
- `checkDuplicate()`
- `validateEligibility()`
- `createApplication()`
- `updateApplicationStatus()`
- `submitApplication()`

---

## Business Flow

```text
Student clicks Apply
        │
        ▼
Retrieve Student
        │
        ▼
Retrieve Job
        │
        ▼
Check Duplicate
        │
        ▼
Validate Eligibility
        │
        ▼
Create Application
        │
        ▼
Return Success Message
