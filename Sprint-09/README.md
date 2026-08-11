# Sprint 9 – Asynchronous Apex

## Project Overview

Sprint 8 focused on implementing asynchronous processing in Salesforce using Future Methods, Queueable Apex, Batch Apex, and Scheduled Apex.

The objective was to move non-essential and long-running operations to background processing while keeping user transactions fast, responsive, and scalable.

---

## Sprint Objectives

- Understand synchronous and asynchronous processing.
- Identify operations suitable for background processing.
- Implement Future Methods and Queueable Apex.
- Process large datasets using Batch Apex.
- Automate recurring operations using Scheduled Apex.
- Design reliable and scalable asynchronous workflows.

---

## Implementation Tasks

### Engineering Sprint 19 – Queueable Apex

Implemented Queueable Apex for background processing.

- Separated synchronous and asynchronous operations.
- Designed a Queueable job for post-offer processing.
- Passed only required record IDs to the background job.
- Queued background processing after successful transactions.
- Improved application responsiveness.

---

### Engineering Sprint 20 – Queueable Chaining

Implemented chained Queueable jobs for sequential processing.

- Designed a Queueable job chain.
- Processed external synchronization first.
- Triggered notification processing after successful synchronization.
- Applied the Single Responsibility Principle.
- Considered duplicate execution and failure handling.

**Workflow:**

```text
Main Transaction
       │
       ▼
Synchronization Job
       │
       ▼
Notification Job
