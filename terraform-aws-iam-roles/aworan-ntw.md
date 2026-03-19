Perfect — this is where it starts to feel like **real internal architecture documentation**, not templates.

Below are **two fully rewritten sections**, both grounded in:

* your transcript realities (Windchill confusion, Harris dependency, scattered docs, no inventory clarity)
* Bose Product Security operating model
* HSM (Thales), CyberArk, partitions, jump box, etc.
* the push toward a **self-service key management platform**

---

# 1. Service Engagement Model (Bose-Specific)

---

# Service Engagement Model

## Purpose

The Service Engagement Model defines how engineering teams at Bose interact with the Product Security team for all cryptographic and HSM-related activities.

Today, a significant portion of key management work happens through:

* direct Slack / Teams messages
* tribal knowledge (“ask Harris”)
* undocumented steps
* unclear ownership paths

This creates friction, delays, and operational risk — especially when:

* onboarding new engineers
* responding to incidents
* troubleshooting key-related issues
* trying to scale operations

The goal of this model is to transition Bose Product Security from:

> reactive, person-dependent support
> to
> a structured, governed, and eventually self-service cryptographic platform

---

## Current-State Reality (Observed Challenges)

From current operations:

* Engineers do not know **where to request access (e.g., Windchill confusion)**
* Access to HSM, CyberArk, or partitions is inconsistent
* Requests often start informally:

  * “Hey, do you know who owns this key?”
* No consistent intake process for:

  * key creation
  * rotation
  * revocation
* Approval flows are implicit, not documented
* Execution depends on:

  * who is available
  * who knows the system

This is not scalable and introduces **single points of failure**.

---

## Target Operating Model

The engagement model establishes a structured lifecycle:

```text
Request → Validate → Approve → Execute → Verify → Document
```

Every cryptographic operation must follow this flow.

---

## Engagement Channels (Bose-Specific)

### 1. Primary: Ticket-Based Requests (Jira)

All cryptographic operations must be initiated via Jira.

This ensures:

* traceability
* approval tracking
* audit readiness
* visibility across the team

Slack/Teams should not be used to initiate work — only to coordinate.

---

### 2. Secondary: Teams / Slack

Used for:

* clarifications
* coordination
* troubleshooting

Not a system of record.

---

### 3. Future: Key Management Portal

Planned capability:

* self-service key requests
* automated approvals
* real-time key visibility

This model is being designed to support that transition.

---

## Supported Request Types (Bose Context)

---

### 1. Key Creation Request

Triggered when a team needs a new key for:

* a new product launch
* new feature (e.g., OTA, pairing)
* integration (e.g., Spotify, Fast Pair)

#### Required Inputs

* Business Unit (Automotive / Consumer)
* Product Name
* Use Case (Secure Boot, OTA, etc.)
* Environment (Dev / Prod)
* Key Type (RSA, ECC, etc.)
* Justification

---

### 2. Key Rotation Request

Triggered by:

* expiration timelines
* compliance requirements
* risk mitigation

#### Bose Reality Gap

Currently:

* rotation schedules are not consistently tracked
* ownership is not always clear

This model enforces:

* proactive rotation tracking
* defined ownership accountability

---

### 3. Key Revocation Request

Triggered by:

* suspected compromise
* incorrect usage
* product deprecation

This is **critical priority**.

---

### 4. Partition / Access Request

Used when access is required for:

* Thales HSM
* CyberArk credentials
* jump box
* related systems

#### Current Problem

As seen in transcript:

> “How do I get access? Nobody knows.”

This model fixes that by requiring:

* defined request path
* defined approval
* defined provisioning

---

### 5. Consultation / Design Request

Used when teams need guidance on:

* integrating with HSM
* designing cryptographic workflows
* meeting security requirements

---

### 6. Incident Response Request

Triggered when:

* key compromise is suspected
* system failures occur
* authentication breaks

This must bypass normal flow and escalate immediately.

---

## Request Workflow Lifecycle (Bose Execution)

---

### Step 1: Request Submission

Engineer submits Jira ticket with:

* use case
* product context
* required operation

Incomplete requests are rejected.

---

### Step 2: Validation

Product Security validates:

* correct use case classification
* completeness
* feasibility

---

### Step 3: Approval

Approvals depend on:

| Scenario        | Approval Required              |
| --------------- | ------------------------------ |
| Dev Key         | Engineering Owner              |
| Prod OTA Key    | Engineering + Product Security |
| Secure Boot Key | Strict multi-approval          |

---

### Step 4: Execution

Performed via:

* HSM access (via jump box)
* CyberArk credentials
* approved runbooks

---

### Step 5: Validation

Must confirm:

* key exists in correct partition
* metadata recorded
* downstream systems updated

---

### Step 6: Documentation

Critical step — often skipped today.

Must include:

* key catalog update
* runbook linkage
* ownership assignment

---

## Roles & Responsibilities (Bose Reality)

### Requestor (Engineer)

* initiates request
* provides business context

---

### Product Security (You / Team)

* enforces security controls
* approves critical operations
* owns documentation standards

---

### HSM SME (Currently Harris)

* deep system knowledge
* currently a bottleneck

**Goal:** eliminate dependency on single SME

---

### Platform / Ops

* manages infrastructure
* supports access

---

## Key Risk This Model Solves

### Current Risk:

> One person knows everything

### Target State:

> System + documentation enables anyone to operate

---

## Summary

This model ensures:

* no undocumented work
* no hidden knowledge
* no ambiguous ownership
* no dependency on individuals

It transforms Bose Product Security into a **platform-driven organization**.

---

# 2. Key Inventory (Bose-Specific)

---

# Key Inventory

## Purpose

The Key Inventory is the **single source of truth** for all cryptographic assets managed by Bose Product Security.

Today, Bose has:

* visibility into partitions
* visibility into total key counts

But lacks:

* breakdown of keys by product
* mapping of keys to use cases
* ownership clarity
* lifecycle tracking

Example current limitation:

> “This partition has 200 keys… but what are they?”

This inventory solves that problem.

---

## What This Inventory Must Answer

For any key, we should be able to answer:

* What is this key used for?
* Which product depends on it?
* Who owns it?
* Where is it stored?
* When was it created?
* When should it rotate?
* What happens if it breaks?

---

## Key Catalog Structure (Bose Model)

Below is the required schema.

---

### Core Metadata Table

| Field           | Description                          |
| --------------- | ------------------------------------ |
| Key Name        | Human-readable name                  |
| Key ID          | Unique identifier                    |
| Use Case        | Secure Boot / OTA / Fast Pair / etc. |
| Business Unit   | Automotive / Consumer                |
| Product         | Product name                         |
| Environment     | Dev / Test / Prod                    |
| Partition       | HSM partition                        |
| Algorithm       | RSA / ECC                            |
| Key Size        | e.g., 2048                           |
| Owner           | Responsible team                     |
| Created Date    | Timestamp                            |
| Rotation Policy | e.g., Annual                         |
| Last Rotated    | Date                                 |
| Status          | Active / Deprecated                  |
| Runbook         | Link                                 |

---

## Example (Bose-Specific)

| Key Name       | Use Case            | Product             | Partition   | Owner               |
| -------------- | ------------------- | ------------------- | ----------- | ------------------- |
| AutoBootKey-A1 | Secure Boot         | Automotive System X | Partition-A | Automotive Security |
| OTAKey-C1      | OTA Signing         | Headphones Gen 3    | Partition-B | Firmware Team       |
| FastPairKey-G1 | Fast Pair           | Consumer Devices    | Partition-C | Mobile Team         |
| SpotifyAuthKey | Partner Integration | Bose App            | Partition-D | Platform Team       |

---

## Partition Visibility (Fixing Current Gap)

Today:

* we know partitions
* we don’t know contents meaningfully

Inventory must include:

| Partition   | Total Keys | Use Case Breakdown      |
| ----------- | ---------- | ----------------------- |
| Partition-A | 200        | 120 Secure Boot, 80 OTA |
| Partition-B | 150        | OTA + Fast Pair         |

---

## Ownership Model

Every key must have:

* primary owner
* backup owner

No key should exist without ownership.

---

## Lifecycle Tracking

Every key must define:

* creation date
* rotation schedule
* expiration risk
* revocation path

---

## Bose-Specific Problems This Solves

### Problem 1: Threshold Alerts (95 Key Issue)

Today:

> Alert fires → nobody knows what keys are impacted

With inventory:

* immediate breakdown
* clear ownership
* clear remediation

---

### Problem 2: Onboarding

Today:

> “Where do I even start?”

With inventory:

* searchable
* structured
* mapped to use cases

---

### Problem 3: Dependency on Individuals

Today:

> “Ask Harris”

With inventory:

* system-driven visibility

---

## Relationship to Runbooks

Each key entry must link to:

* its runbook
* its workflow
* its operational procedure

---

## Relationship to Future Platform

This inventory becomes:

* backend database for self-service portal
* source for automation workflows
* basis for policy engine

---

## Non-Negotiable Rules

* No key without a use case
* No key without an owner
* No key without lifecycle definition
* No key without documentation

---

## Summary

The Key Inventory transforms Bose from:

> “We have keys in partitions”

to:

> “We understand exactly what every key does, who owns it, and how it is managed”

This is the **foundation** for:

* operational scalability
* audit readiness
* incident response
* automation
* future platform development

---

# What You Just Built (Important)

With these two sections now rewritten:

You are no longer writing documentation.

You are defining:

* a **cryptographic operating model**
* a **platform architecture foundation**
* a **risk reduction strategy**

---

# Next (Highly Recommended)

To complete this at a principal level, next build:

👉 **Runbooks (Create/Rotate/Revoke)** — I can make them extremely detailed and Bose-specific
👉 **HSM Platform Overview** — tie everything to Thales, CyberArk, partitions, jump box
👉 **Governance** — approval model tied to real Bose workflows

Tell me which one you want next.
