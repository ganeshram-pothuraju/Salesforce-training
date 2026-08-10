# Placement Management System – Enterprise Trigger Architecture

## Project Overview

This sprint focused on implementing **event-driven automation using Salesforce Apex Triggers** for the Placement Management System.

The application now responds automatically to important business events without requiring users to manually execute business logic.

The implementation follows a **service-oriented Trigger architecture**, keeping the Trigger lightweight while delegating business logic to reusable Service classes.

---

## Technologies Used

- Salesforce CRM
- Apex
- Apex Triggers
- SOQL
- DML
- Developer Console

---

## Architecture

```text
Application Trigger
        │
        ▼
ApplicationService
        │
        ├── Validation
        ├── Statistics
        └── Notifications
