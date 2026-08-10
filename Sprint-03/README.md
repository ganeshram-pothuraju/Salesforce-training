# Salesforce Training – Day 3

## Project Overview

Day 3 focused on implementing Salesforce business requirements using **declarative automation tools** instead of custom code.

The implementation covered **Record-Triggered Flows** and **Validation Rules**, with a focus on following Salesforce's **Clicks Before Code** approach.

---

## Tasks Completed

### Block 1 – Record-Triggered Flows

Implemented the following automation requirements using Record-Triggered Flows.

#### Flow 1 – Auto Populate Application Date

- **Type:** Before-Save Record-Triggered Flow
- **Purpose:** Automatically populate the Application Date when a new Application record is created.

#### Flow 2 – Send Email Notification

- **Type:** After-Save Record-Triggered Flow
- **Purpose:** Automatically send an email notification to the Placement Officer when a student submits a new Application record.

#### Flow 3 – Create Offer Letter

- **Type:** After-Save Record-Triggered Flow
- **Purpose:** Automatically create an Offer Letter record when the Application Status changes to `Selected`.

---

### Block 2 – Validation Rules

Implemented validation rules to enforce business requirements and maintain data quality.

#### Validation Rule 1 – CGPA Eligibility Check

Prevents students from applying when their CGPA is below the minimum CGPA required for the selected Job.

#### Validation Rule 2 – Application Date Validation

Prevents students from submitting an Application after the Job's Closing Date.

#### Validation Rule 3 – Mandatory Fields Validation

Ensures required fields such as:

- Student
- Job
- Status

are populated before an Application record can be saved.

---

### Block 3 – Requirement Analysis

Analyzed the requirements to determine whether each business rule should be implemented using:

- Record-Triggered Flows
- Validation Rules
- Apex

For this project, all requirements were successfully implemented using Salesforce's declarative tools, so Apex was not required.

---

## Solution Selection

### Why Flow?

Flows were selected for process automation requirements such as:

- Automatically updating fields
- Sending email notifications
- Creating related records
- Reducing manual work

This follows Salesforce's **Clicks Before Code** approach by using declarative automation whenever possible.

---

### Why Validation Rules?

Validation Rules were used to enforce data quality and prevent invalid records from being saved.

They are suitable for requirements such as:

- Eligibility checks
- Date validation
- Required field validation
- Preventing invalid user input

---

### Why Apex Was Not Used?

Apex was not required because the given requirements could be completely implemented using Flows and Validation Rules.

Using declarative tools made the solution:

- Simpler
- Easier to maintain
- Easier to modify
- More aligned with Salesforce best practices

---

## Scenarios Where Apex Would Be Required

Apex may be required when requirements involve more complex logic, such as:

- Calculating placement rankings using multiple criteria.
- Processing large volumes of related records.
- Performing complex cross-object validations.
- Integrating Salesforce with external systems.
- Implementing logic that cannot be efficiently achieved using Flow.

---

## Skills Practiced

- Record-Triggered Flows
- Before-Save Flows
- After-Save Flows
- Validation Rules
- Business Requirement Analysis
- Declarative Salesforce Development
- Clicks Before Code
- Salesforce Automation

---

## Learning Outcomes

After completing Day 3, I understood:

- How to convert business requirements into Salesforce automation.
- When to use Flows for process automation.
- How Validation Rules enforce data quality.
- How to choose declarative tools over Apex when appropriate.
- When complex requirements require Apex.
- The importance of selecting the simplest suitable Salesforce solution.
