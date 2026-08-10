# Placement Management System – Business Logic with Apex

## Project Overview

This sprint focused on implementing **business logic for the Placement Management System using Apex**.

Instead of only storing Salesforce records, the application now evaluates business rules before processing student applications.

The implementation follows a **service-oriented architecture**, where each Apex class is responsible for a specific business area.

---

## Technologies Used

- Salesforce CRM
- Apex
- SOQL
- DML
- Developer Console

---

## Service Classes

### StudentService

Responsible for student-related business operations:

- Student Registration
- Profile Updates
- Academic Verification
- Placement Status Management

---

### JobService

Responsible for job-related operations:

- Job Creation
- Eligibility Management
- Job Publishing
- Closing Expired Jobs

---

### ApplicationService

Responsible for application processing:

- Receiving Applications
- Preventing Duplicate Applications
- Validating Student Eligibility
- Saving Valid Applications
- Returning Meaningful Feedback

---

## Business Workflow

```text
Student
   │
   ▼
Lightning Web Component
   │
   ▼
ApplicationService
   │
   ▼
Eligibility Validation
   │
   ▼
Salesforce Database
   │
   ▼
Confirmation Message
