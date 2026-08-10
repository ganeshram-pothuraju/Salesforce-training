
# Salesforce Developer Bridge Program – Day 2

## Project Overview

Day 2 focused on building **scalable and production-ready Salesforce applications** by introducing Apex Collections, Governor Limits, Bulkification, Asynchronous Apex, and Lightning Web Component communication.

The objective was to progress from writing functional Apex code to developing solutions that are **efficient, reusable, and scalable**.

---

## Technologies Used

- Salesforce CRM
- Apex
- SOQL
- Apex Triggers
- Apex Collections
- Asynchronous Apex
- Lightning Web Components (LWC)

---

## Tasks Completed

### Block 1 – Apex Collections

Implemented and practiced:

- Lists
- Sets
- Maps
- Collection Iteration
- Record Lookup
- Duplicate Record Removal

---

### Block 2 – Governor Limits & Bulkification

Studied important Salesforce platform limits, including:

- SOQL Query Limits
- DML Statement Limits
- CPU Time
- Heap Size

Implemented and compared:

- Non-Bulkified Trigger
- Bulkified Trigger

The implementation demonstrated how bulkification helps Apex code handle multiple records efficiently while staying within Salesforce Governor Limits.

---

### Block 3 – Asynchronous Apex

Implemented asynchronous processing using:

- `@future` Methods

Practiced:

- Background Processing
- Apex Jobs
- Future Method Execution

Also compared different asynchronous Apex approaches:

- Future Apex
- Queueable Apex
- Batch Apex

---

### Block 4 – Lightning Web Components

Implemented communication between Lightning Web Components using:

#### Parent → Child Communication

- `@api` properties
- Public methods

#### Child → Parent Communication

- Custom Events
- Event handling

---

## Skills Practiced

- Apex Collections
- Governor Limits
- Apex Bulkification
- Future Methods
- Queueable Apex
- Batch Apex
- Asynchronous Apex
- LWC Component Communication
- Custom Events
- `@api`

---

## Best Practices Followed

- Avoid SOQL queries inside loops.
- Perform bulk DML operations.
- Use Maps for efficient record lookup.
- Design Apex code to handle multiple records.
- Keep Lightning Web Components reusable.
- Separate responsibilities between components.
- Design solutions with scalability in mind.

---

## Learning Outcomes

After completing Day 2, I understood:

- Why Salesforce enforces Governor Limits.
- How Bulkification improves Apex performance and scalability.
- How Lists, Sets, and Maps simplify Apex data processing.
- When to use Future, Queueable, and Batch Apex.
- How asynchronous Apex handles long-running or background processes.
- How Lightning Web Components communicate with each other.
- How to design Salesforce applications for scalability and maintainability.
