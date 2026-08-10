# Salesforce Developer Bridge Program – Day 11

## LWC Architecture

## Project Overview

Day 11 focused on building **scalable and maintainable Lightning Web Component (LWC) applications**.

The sprint covered component communication, form handling, Lightning Data Service, reactive data, validation, reusable components, and UI state management.

The objective was to move beyond individual components and understand how multiple LWCs can work together as a structured application.

---

## Topics Covered

### Component Communication

- Parent-to-Child communication using `@api`
- Child-to-Parent communication using Custom Events
- Event contracts
- Event `detail` data

### Lightning Base Components

Practiced using Salesforce Lightning Base Components to build consistent and reusable user interfaces.

### Form Validation

Implemented and understood:

- Client-side validation
- Server-side validation
- Required field validation
- Handling validation errors

### Lightning Data Service

Worked with **Lightning Data Service (LDS)** to access and manage Salesforce records without unnecessary Apex code.

### Reactive Data

Learned how reactive properties and data updates allow components to automatically reflect changes in the Salesforce UI.

### UI State Management

Handled different application states, including:

- Loading State
- Success State
- Empty State
- Error State

### Reusable Components

Designed components with reusable responsibilities instead of placing all functionality inside a single component.

This approach helps avoid **God Components** and improves maintainability.

---

## Application Architecture

```text
StudentPortal
│
├── StudentSummary
│
├── StudentProfile
│
├── EligibleJobs
│   └── JobCard
│
├── MyApplications
│   └── ApplicationCard
│
└── OfferSummary
    └── StatusBadge
