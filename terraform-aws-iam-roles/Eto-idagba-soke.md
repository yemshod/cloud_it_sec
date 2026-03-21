

---

# 1. HSM Platform Overview (Bose-Specific)

---

# HSM Platform Overview

## Purpose

The Hardware Security Module (HSM) platform is the **cryptographic trust backbone** for Bose Product Security.

It is responsible for:

* generating cryptographic keys
* securely storing private keys
* executing cryptographic operations (signing, encryption)
* enforcing access control at the hardware level

At Bose, this platform underpins:

* secure boot
* OTA firmware signing
* ecosystem integrations (Fast Pair, etc.)
* DRM / HDCP
* internal platform trust

---

## Platform Components (Bose Reality)

### 1. Thales HSM

The core cryptographic engine.

Responsibilities:

* key generation (RSA, ECC, symmetric)
* key storage (non-exportable private keys)
* cryptographic operations
* partition isolation

---

### 2. HSM Partitions

Partitions are logical containers that:

* isolate keys
* enforce access control
* separate environments / products

#### Current Issue

We can see:

> “Partition has 200 keys”

But cannot answer:

* which product?
* which use case?
* who owns them?

This is a major visibility gap.

---

### 3. CyberArk (Credential Management)

Used to store:

* Crypto Officer credentials
* Partition Owner credentials
* privileged access secrets

#### Critical Dependency

Without CyberArk access:

* no HSM operations can be performed
* engineers are blocked

---

### 4. EC2 Jump Box (Operational Entry Point)

Used as the access layer to:

* connect to HSM
* execute commands
* run scripts

#### Reality from Transcript

Access validation is inconsistent:

> “Do you have access to the jump box?”

This must be standardized.

---

### 5. Thales Portal / Support Interface

Used for:

* managing HSM environment
* troubleshooting
* support tickets

#### Current Problem

> Login issues → no visibility → operational blockage

This represents a **platform-level risk**.

---

## Access Model (Bose Reality)

Roles typically include:

| Role             | Responsibility           |
| ---------------- | ------------------------ |
| Platform Officer | Infrastructure control   |
| Crypto Officer   | Key lifecycle management |
| Crypto User      | Limited usage            |

---

### Critical Observation

Access today is:

* inconsistent
* not fully documented
* dependent on individuals

This creates:

* onboarding delays
* operational bottlenecks
* risk during incidents

---

## Known Gaps (From Transcript)

### 1. Single Point of Failure

> Harris holds most knowledge

### 2. Documentation Fragmentation

* spread across Confluence
* not discoverable

### 3. Access Friction

* unclear onboarding path
* inconsistent provisioning

### 4. No Inventory Visibility

* keys exist, but not mapped

---

## Target State

The HSM platform should evolve into:

* fully documented
* inventory-driven
* runbook-backed
* automation-ready
* not dependent on individuals

---

# 2. Runbooks (Bose-Specific, Operational Level)

---

# Runbook: Key Creation

---

## Purpose

To generate a new cryptographic key within the Thales HSM environment and register it within the Bose Key Inventory.

---

## Preconditions

* Jira ticket approved
* Use case defined (e.g., OTA, Secure Boot)
* CyberArk access validated
* Jump box access confirmed
* Partition identified

---

## Step 1: Access Jump Box

```bash
ssh <jump-box>
```

---

## Step 2: Retrieve Credentials from CyberArk

* Access CyberArk portal
* Retrieve:

  * Crypto Officer credentials
  * Partition credentials

---

## Step 3: Authenticate to HSM

```bash
hsm login --partition <partition-name> --user crypto_officer
```

---

## Step 4: Generate Key

Example (RSA):

```bash
generateKeyPair --type RSA --size 2048 --label <key-name>
```

---

## Step 5: Validate Key Creation

```bash
listKeys --partition <partition-name>
```

Confirm:

* key exists
* correct label
* correct type

---

## Step 6: Register in Key Inventory

Mandatory:

* Use case
* Product
* Owner
* Rotation policy
* Partition

---

## Step 7: Notify Stakeholders

* Requestor
* Product team
* Security team

---

## Failure Conditions

| Failure            | Action                   |
| ------------------ | ------------------------ |
| Auth failure       | Validate CyberArk creds  |
| Partition issue    | Confirm partition access |
| Key creation fails | Retry / escalate         |

---

# Runbook: Key Rotation

---

## Purpose

To replace an existing key while maintaining operational continuity.

---

## Preconditions

* Rotation triggered (policy or risk)
* Owner identified
* dependent systems known

---

## Step 1: Identify Existing Key

* confirm key in inventory
* confirm dependencies

---

## Step 2: Generate Replacement Key

Follow **Key Creation Runbook**

---

## Step 3: Update Dependent Systems

Examples:

* firmware signing pipeline
* OTA systems
* partner systems

---

## Step 4: Validate New Key

* test signing
* test verification
* confirm integration

---

## Step 5: Deprecate Old Key

```bash
disableKey <key-id>
```

---

## Step 6: Update Inventory

* mark old key as deprecated
* update rotation timestamp

---

## Bose-Specific Risk

If rotation is done incorrectly:

* OTA updates fail
* devices reject firmware
* production outages

---

# Runbook: Key Revocation

---

## Purpose

To immediately disable a compromised or invalid key.

---

## Trigger Scenarios

* suspected compromise
* incorrect usage
* incident response

---

## Step 1: Identify Key

* from inventory
* confirm partition

---

## Step 2: Immediate Disable

```bash
revokeKey <key-id>
```

---

## Step 3: Notify Stakeholders

* Product Security
* Engineering teams
* Leadership (if critical)

---

## Step 4: Impact Assessment

* which products affected?
* OTA impact?
* ecosystem impact?

---

## Step 5: Replacement (if required)

* generate new key
* reconfigure systems

---

## Step 6: Incident Documentation

* timeline
* root cause
* remediation

---

## Bose-Specific Criticality

This is a **business continuity function**.

---

# 3. Governance Model (Bose-Specific)

---

# Governance

## Purpose

To enforce structured, secure, and auditable management of cryptographic assets across Bose.

---

## Current Problem

From transcript:

* no consistent approval model
* unclear ownership
* undocumented workflows

---

## Approval Model (Bose)

| Operation       | Approval Required      |
| --------------- | ---------------------- |
| Dev Key         | Engineering            |
| Prod OTA Key    | Engineering + Security |
| Secure Boot Key | Multi-level approval   |
| Revocation      | Security immediate     |

---

## Role Definitions

### Product Security

* owns cryptographic policy
* approves high-risk actions
* defines standards

---

### Engineering Teams

* request keys
* own product integration

---

### HSM SME (Current)

* executes operations
* holds deep knowledge

---

### Target State

No single SME dependency.

---

## Rotation Standards

| Key Type         | Rotation          |
| ---------------- | ----------------- |
| Secure Boot      | Rare (controlled) |
| OTA              | Periodic          |
| Integration Keys | Partner-defined   |

---

## Audit Requirements

All actions must log:

* who
* what
* when
* why

---

## Exception Handling

Exceptions must include:

* documented reason
* security approval
* expiration review

---

## Bose-Specific Governance Goal

Move from:

> “who knows how to do this?”

to:

> “this is the defined process anyone can follow”

---

# Final Thought (Important)

What you now have is:

* platform documentation
* operational procedures
* governance model

This is exactly what your manager was hinting at when he said:

> “This is the keys to the kingdom”

---



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


# 1. Business Unit Mapping

---

## Purpose

Business Unit Mapping establishes a **top-level classification layer** that ties every cryptographic asset to a Bose organizational domain.

At Bose, this is critical because:

* cryptographic usage differs significantly between **Automotive vs Consumer**
* lifecycle expectations, risk tolerance, and compliance requirements vary
* ownership boundaries are often unclear without BU context

Without this mapping, keys become:

> “floating technical artifacts” instead of business-aligned assets

---

## Bose Business Units (Cryptographic Context)

### 1. Automotive

#### Description

Supports cryptographic needs for Bose systems embedded in vehicles.

#### Typical Use Cases

* Secure Boot (ECU systems)
* Firmware signing (vehicle updates)
* OEM integrations
* Device authentication within vehicle ecosystems

#### Risk Profile

* **Safety-critical**
* Long lifecycle (years)
* High regulatory and OEM dependency

---

### 2. Consumer Electronics

#### Description

Supports Bose retail products:

* headphones
* speakers
* soundbars

#### Typical Use Cases

* OTA firmware updates
* Fast Pair / Bluetooth pairing
* mobile app integrations
* DRM / media playback

#### Risk Profile

* High scale (millions of devices)
* Customer experience impact
* Frequent updates

---

### 3. Platform / Cloud Services

#### Description

Internal and backend systems supporting Bose products.

#### Typical Use Cases

* service-to-service authentication
* API signing
* token validation
* internal automation (Tines, pipelines)

#### Risk Profile

* Operational reliability
* Internal trust boundaries

---

### 4. Partner / Ecosystem Integrations

#### Description

External service integrations.

#### Examples

* Spotify
* Google Fast Pair
* DRM/HDCP ecosystems

#### Risk Profile

* Contractual obligations
* SLA dependencies
* external audit/compliance

---

## Required Mapping Rule

Every key must map to:

```text
Business Unit → Product → Use Case
```

No exceptions.

---

## Example (Bose Context)

| Key Name        | Business Unit |
| --------------- | ------------- |
| AutoBootKey-A1  | Automotive    |
| OTAKey-C1       | Consumer      |
| SpotifyAuthKey  | Partner       |
| InternalMTLSKey | Platform      |

---

## Problem This Solves

* eliminates ambiguity in ownership
* enables risk-based prioritization
* improves reporting (e.g., “how many automotive secure boot keys?”)

---

# 2. Product Mapping (WITH CHIPSET REQUIREMENT)

---

## Purpose

Product Mapping ties each key to a **specific Bose product AND its hardware trust anchor (chipset)**.

This is critical because:

> cryptographic trust is not just software — it is anchored in hardware

---

## Why Chipset Mapping Matters

At Bose:

* keys are validated against hardware trust anchors
* different chipsets have different:

  * secure storage capabilities
  * cryptographic acceleration
  * provisioning methods

Without chipset mapping:

* you cannot fully understand trust boundaries
* you cannot properly assess compromise impact
* you cannot support manufacturing or provisioning workflows

---

## Required Mapping Fields

| Field                | Description              |
| -------------------- | ------------------------ |
| Product Name         | Device or system         |
| Business Unit        | Automotive / Consumer    |
| Use Case             | Secure Boot, OTA, etc.   |
| Chipset              | Hardware security anchor |
| Key Storage Location | HSM / Device / Hybrid    |
| Provisioning Method  | Factory / OTA / Embedded |

---

## Example (Bose-Specific)

| Product            | BU         | Use Case    | Chipset                 | Storage                         |
| ------------------ | ---------- | ----------- | ----------------------- | ------------------------------- |
| Bose Auto System X | Automotive | Secure Boot | NXP / Qualcomm Auto SoC | HSM + Embedded Public Key       |
| Bose QC Headphones | Consumer   | OTA Signing | Qualcomm Audio SoC      | HSM Signing + Device Validation |
| Bose Speaker Gen 3 | Consumer   | Fast Pair   | Nordic / Qualcomm BLE   | Device Identity Key             |
| Bose App Backend   | Platform   | API Auth    | N/A (Cloud)             | HSM                             |

---

## Chipset Categories (Typical at Bose)

### 1. Automotive SoCs

* NXP
* Qualcomm Automotive
* Renesas (possible depending on platform)

Used for:

* secure boot
* firmware validation

---

### 2. Consumer Audio SoCs

* Qualcomm Audio
* Nordic (BLE pairing)
* other embedded processors

Used for:

* OTA validation
* pairing/authentication

---

### 3. Secure Elements / TPM-like Components

Where applicable:

* store device identity
* support cryptographic operations locally

---

## Key Insight

A key is not fully understood unless you know:

```text
Where it is generated (HSM)
+
Where it is validated (chipset)
```

---

## Problem This Solves

* connects software keys to hardware trust
* supports manufacturing workflows
* improves incident impact analysis

---

# 3. Key Type Definitions (Bose-Specific)

---

## Purpose

Key Type Definitions standardize how cryptographic keys are categorized across Bose.

Today, keys are often:

* inconsistently named
* poorly classified
* difficult to distinguish

This section enforces **strict categorization aligned to Bose use cases**.

---

## Core Key Types

---

### 1. Secure Boot Keys

#### Function

Establish root of trust for device startup.

#### Characteristics

* highest sensitivity
* rarely rotated
* tightly controlled

---

### 2. OTA Signing Keys

#### Function

Sign firmware updates.

#### Characteristics

* high usage frequency
* tied to release pipelines
* requires audit logging

---

### 3. Device Identity Keys

#### Function

Authenticate device identity (pairing, ecosystem trust).

#### Examples

* Fast Pair keys
* Bluetooth authentication

---

### 4. DRM / HDCP Keys

#### Function

Enable protected content playback.

#### Characteristics

* externally governed
* compliance-driven

---

### 5. Partner Integration Keys

#### Function

Authenticate Bose systems to external services.

#### Examples

* Spotify credentials
* API signing keys

---

### 6. Internal Platform Keys

#### Function

Support internal infrastructure trust.

#### Examples

* mTLS certs
* service tokens

---

## Key Classification Attributes

Every key must include:

| Attribute     | Example             |
| ------------- | ------------------- |
| Key Type      | OTA Signing         |
| Algorithm     | RSA / ECC           |
| Criticality   | High / Medium / Low |
| Exportability | Non-exportable      |
| Environment   | Prod / Dev          |

---

## Bose-Specific Problem Solved

* eliminates “mystery keys”
* standardizes naming + classification
* improves automation readiness

---

# 4. Ownership Model (VERY IMPORTANT)

---

## Purpose

Defines **who is accountable for each cryptographic asset**.

This is one of the **biggest current gaps** at Bose.

---

## Current Problem (From Transcript)

* unclear ownership
* reliance on individuals
* no backup ownership
* onboarding confusion

---

## Ownership Structure

Every key must have:

---

### 1. Primary Owner (MANDATORY)

* accountable for:

  * lifecycle
  * rotation
  * usage

Typically:

* product engineering team

---

### 2. Secondary Owner (MANDATORY)

* backup for:

  * incidents
  * operational continuity

---

### 3. Product Security (GOVERNANCE OWNER)

* defines policy
* approves high-risk actions
* enforces compliance

---

### 4. Platform / HSM Team

* executes operations
* maintains infrastructure

---

## Ownership Matrix Example

| Key            | Primary Owner  | Secondary  | Security         | Platform |
| -------------- | -------------- | ---------- | ---------------- | -------- |
| OTAKey-C1      | Firmware Team  | DevOps     | Product Security | HSM Team |
| AutoBootKey-A1 | Automotive Eng | Backup Eng | Product Security | HSM Team |
| SpotifyKey     | Platform Team  | App Team   | Product Security | HSM Team |

---

## Non-Negotiable Rules

* No key without owner
* No shared “team ownership” without named individuals
* No orphaned keys
* Ownership must be in inventory

---

## Bose-Specific Risk This Solves

### Before

> “Who owns this key?” → nobody knows

### After

> Immediate accountability + escalation path

---

## Incident Ownership Flow

```text
Key Issue → Owner → Backup → Security Escalation
```

---

## Final Summary (What You Just Built)

You now have:

* Business Alignment → Business Unit Mapping
* Product Context → Product + Chipset Mapping
* Technical Clarity → Key Type Definitions
* Accountability → Ownership Model

---

## Why This Is Powerful

This turns your environment from:

> “We have keys in HSM”

into:

> “We have a governed, mapped, accountable cryptographic system tied to products, hardware, and business”

---

##########################################################

Perfect — this section is where you **anchor everything technically**.

If the previous sections defined *what* and *who*, this section defines:

> **“How the Bose cryptographic system actually works today — including all the flaws we must fix.”**

Below is a **fully Bose-specific, operationally accurate, and architecturally grounded write-up** for:

* HSM Platform / Architecture Overview
* Partitions Inventory
* Access Models
* Existing Automation
* Known Gaps / Risks

---

# Current-State Environment

---

# 1. HSM Platform / Architecture Overview

## Purpose

The HSM platform at Bose serves as the **central trust authority** for all cryptographic operations supporting Product Security.

It is not just an infrastructure component — it is the system responsible for protecting:

* firmware trust (secure boot)
* software integrity (OTA signing)
* ecosystem authentication (Fast Pair, mobile integrations)
* licensed content protection (DRM/HDCP)
* internal service trust

All private keys used for these functions are expected to be generated and stored within the HSM boundary.

---

## Bose Current Architecture (As Implemented Today)

At a high level, the architecture follows this operational flow:

```text
Engineer → Jump Box → HSM CLI/API → HSM Partition → Key Operations
                        ↓
                   CyberArk (Credentials)
```

---

### Core Components

---

### 1. Thales HSM (Primary Trust Anchor)

This is the core cryptographic system responsible for:

* generating keys (RSA, ECC, symmetric)
* storing private keys (non-exportable)
* performing signing operations
* enforcing partition-level isolation

#### Reality at Bose

* Keys are actively being used across multiple product lines
* Partition-level segmentation exists
* However, visibility into **what exists inside partitions is limited**

---

### 2. HSM Partitions (Logical Segmentation)

Partitions are used to:

* separate product domains
* isolate cryptographic operations
* enforce role-based access

#### Current Behavior

We can:

* list partitions
* count keys

But we **cannot easily answer**:

* what keys belong to which product
* what use case they serve
* who owns them

---

### 3. EC2 Jump Box (Operational Entry Point)

All operational interaction with the HSM occurs through:

* a controlled EC2 jump box
* CLI-based interaction

#### Observed Challenge

From onboarding experience:

> Access to the jump box is not standardized or clearly documented

This introduces:

* onboarding delays
* operational friction
* reliance on informal guidance

---

### 4. CyberArk (Credential Control)

CyberArk stores:

* Crypto Officer credentials
* Partition Owner credentials
* privileged access secrets

#### Dependency

Without CyberArk:

* no HSM access
* no key operations
* no recovery capability

---

### 5. Thales Portal / Support Layer

Used for:

* support tickets
* system visibility
* vendor interaction

#### Critical Issue Observed

> Inability to log into Thales portal → complete operational blockage

This represents a **single point of failure at the platform level**.

---

## Architectural Observations

### What Works

* Strong cryptographic boundary (HSM)
* Partition-based isolation
* Secure credential storage (CyberArk)

---

### What Does NOT Work (Yet)

* No centralized visibility of key usage
* No mapping between keys and products
* No standardized operational interface
* Over-reliance on manual execution

---

## Target State (Direction)

The current architecture must evolve into:

* **Inventory-driven** (not partition-count driven)
* **API-driven** (not CLI-only)
* **Documented and discoverable**
* **Decoupled from individual knowledge**

---

# 2. Partitions Inventory

---

## Purpose

The Partitions Inventory provides a **structured view of all HSM partitions**, including:

* what they contain
* what they support
* who owns them

Today, Bose lacks this clarity.

---

## Current-State Reality

We can identify:

* partition names
* approximate key counts

But we cannot confidently answer:

* “Which partition supports Automotive secure boot?”
* “Which partition is used for OTA signing?”
* “Which partition is near capacity due to which product?”

---

## Required Partition Inventory Model

Each partition must be documented with:

| Field            | Description            |
| ---------------- | ---------------------- |
| Partition Name   | Logical identifier     |
| Environment      | Dev / Test / Prod      |
| Business Unit    | Automotive / Consumer  |
| Use Cases        | Secure Boot, OTA, etc. |
| Key Count        | Total keys             |
| Key Breakdown    | By use case            |
| Primary Owner    | Responsible team       |
| Access Roles     | Crypto Officer / User  |
| Threshold Limits | e.g., 95 key alert     |
| Runbooks         | Linked procedures      |

---

## Example (Bose-Specific)

| Partition       | BU         | Use Case     | Keys | Owner               |
| --------------- | ---------- | ------------ | ---- | ------------------- |
| Auto-Part-A     | Automotive | Secure Boot  | 120  | Automotive Security |
| Consumer-Part-B | Consumer   | OTA          | 150  | Firmware Team       |
| Partner-Part-C  | Partner    | Spotify/Auth | 40   | Platform Team       |

---

## Critical Bose Issue

From transcript:

> “We know partitions and counts, but not what’s inside”

This is the core problem this section solves.

---

## Required Capability

For each partition, we must be able to answer:

* What keys are inside?
* What products depend on them?
* What happens if this partition fails?

---

# 3. Access Models

---

## Purpose

Defines how engineers access:

* HSM
* partitions
* credentials
* supporting systems

---

## Current-State (Bose Reality)

Access is:

* inconsistent
* not centrally documented
* dependent on who you ask

Example:

> “How do I get Windchill access?” → nobody knows

This reflects a broader issue across systems.

---

## Required Access Layers

---

### 1. Infrastructure Access

* EC2 Jump Box access
* controlled via IAM / internal access systems

---

### 2. Credential Access

* CyberArk vault access
* required for:

  * Crypto Officer credentials
  * partition authentication

---

### 3. HSM Access

* role-based (Crypto Officer, User)
* partition-specific

---

### 4. Application/System Access

* Thales portal
* supporting systems (Windchill, etc.)

---

## Target Access Model

Access must be:

* request-driven (Jira)
* role-based
* time-bound where possible
* auditable

---

## Bose-Specific Gap

* onboarding friction
* unclear access pathways
* inconsistent privilege distribution

---

# 4. Existing Automation

---

## Purpose

Defines current automation supporting HSM operations.

---

## Current Automation (Observed)

### 1. Threshold Alerts

Example:

> 95-key threshold alert

#### Problem

* alert exists
* context does not

We don’t know:

* which keys triggered it
* which product is impacted

---

### 2. Key Naming Patterns

Example:

* naming conventions like “Pearl”

#### Problem

* not standardized
* not documented
* meaning not universally understood

---

### 3. Partial Workflow Automation

* some processes automated via scripts or tools (e.g., Tines)
* not consistently applied

---

## Current Limitation

Automation is:

* reactive
* fragmented
* not inventory-driven

---

## Target Automation Direction

* key lifecycle automation
* inventory-driven alerts
* self-service workflows
* automated reporting

---

# 5. Known Gaps / Risks

---

## 1. Single Point of Failure (CRITICAL)

### Current State

* HSM knowledge concentrated in one individual (Harris)

### Risk

* operational delays
* inability to respond quickly
* high dependency risk

---

## 2. Lack of Key Visibility

### Current State

* keys exist but are not mapped

### Risk

* cannot assess impact
* cannot manage lifecycle
* cannot support incidents effectively

---

## 3. Fragmented Documentation

### Current State

* information exists but is scattered
* not discoverable

### Risk

* onboarding inefficiency
* inconsistent operations

---

## 4. Undefined Ownership

### Current State

* unclear ownership for many keys

### Risk

* no accountability
* delayed response during incidents

---

## 5. Access Friction

### Current State

* unclear access process
* onboarding delays

### Risk

* operational bottlenecks
* productivity loss

---

## 6. Limited Automation

### Current State

* manual execution dominates

### Risk

* human error
* slow scaling
* inconsistent execution

---

## 7. No Use-Case Alignment

### Current State

* keys are not categorized by purpose

### Risk

* improper governance
* incorrect lifecycle handling

---

## Final Summary

The current Bose HSM environment is:

* **functionally operational**
* **cryptographically sound at the hardware level**
* but **operationally immature in visibility, governance, and scalability**

The key issues are not with the HSM itself, but with:

* lack of structured inventory
* lack of centralized documentation
* lack of standardized workflows
* dependency on individuals

---

## What This Section Enables

This section becomes the foundation for:

* Key Inventory
* Runbooks
* Governance
* Automation
* Future self-service platform

---

## Strategic Insight

This is the real takeaway your manager is driving toward:

> Bose does not have a cryptographic problem
> Bose has an **operational maturity problem around cryptography**


###########################################################################


Good — this is exactly the right next move.

What your manager is implicitly expecting (without saying it directly) is:

> “Can you **visualize this mess into something structured and intuitive** so people can finally understand it?”

That’s what these diagrams do. And if you place these into Confluence properly, this becomes **high-visibility work**.

Below are **3 Bose-specific diagrams** you can directly recreate in:

* Confluence (Draw.io / Gliffy)
* Lucidchart
* PowerPoint (if needed)

I’ll give you:

1. **HSM Architecture Diagram**
2. **Operational Workflow Diagram**
3. **Ownership & Responsibility Model**

---

# 1. HSM Architecture Diagram (Bose Current-State)

## Purpose

Shows how Bose currently interacts with HSM, including:

* Jump box dependency
* CyberArk dependency
* Partition structure
* Lack of abstraction layer

---

## Diagram (Text Blueprint)

```text
                    +---------------------------+
                    |   Bose Engineering Teams  |
                    | (Firmware / Platform /    |
                    |  Automotive / Consumer)   |
                    +------------+--------------+
                                 |
                                 | (Manual Access / Requests)
                                 v
                    +---------------------------+
                    |       EC2 Jump Box        |
                    | (Operational Entry Point) |
                    +------------+--------------+
                                 |
                                 | (CLI / Scripts)
                                 v
                    +---------------------------+
                    |       Thales HSM          |
                    |  (Cryptographic Engine)   |
                    +------------+--------------+
                                 |
          +----------------------+----------------------+
          |                      |                      |
          v                      v                      v
+----------------+   +----------------+   +----------------+
| Partition A    |   | Partition B    |   | Partition C    |
| (Automotive)   |   | (Consumer)     |   | (Partners)     |
+----------------+   +----------------+   +----------------+

                                 ^
                                 |
                    +---------------------------+
                    |        CyberArk           |
                    | (Credential Management)   |
                    +---------------------------+

                                 |
                                 v
                    +---------------------------+
                    |   Thales Support Portal   |
                    | (Currently unstable access)|
                    +---------------------------+
```

---

## Bose-Specific Callouts (Add These in Diagram Notes)

Add these annotations in Confluence:

* ❗ “Jump Box is required for all operations — no API abstraction exists”
* ❗ “CyberArk is a hard dependency for all privileged operations”
* ❗ “Partition contents are not fully visible or classified”
* ❗ “No centralized key catalog exists”

---

# 2. Key Management Operational Workflow Diagram

## Purpose

Shows how work actually flows today vs what it should become.

---

## Current-State Workflow (Reality)

```text
Engineer
   |
   v
Slack / Teams Message
   |
   v
Find the “Right Person” (e.g., Harris)
   |
   v
Manual Execution on Jump Box
   |
   v
Key Created / Modified
   |
   v
Partial / No Documentation
```

---

## Problems (Label These in Diagram)

* ❗ No standardized intake
* ❗ Person-dependent execution
* ❗ No audit trail
* ❗ No inventory update

---

## Target-State Workflow (What YOU Are Building)

```text
Engineer
   |
   v
Jira Request (Structured Input)
   |
   v
Validation (Use Case + Metadata)
   |
   v
Approval (Eng + Product Security)
   |
   v
Execution (Runbook / Automation)
   |
   v
Key Created in HSM
   |
   v
Key Inventory Updated
   |
   v
Audit + Notification
```

---

## Add This Label (Important for Leadership)

> “Transition from **person-driven cryptography** → **process-driven platform**”

---

# 3. Ownership & Responsibility Model Diagram

## Purpose

This directly solves the biggest issue in your transcript:

> “Who owns this?” → Nobody knows

---

## Diagram

```text
                    +----------------------+
                    |   Product Security   |
                    | (Governance Owner)   |
                    +----------+-----------+
                               |
        +----------------------+----------------------+
        |                                             |
        v                                             v
+------------------------+              +------------------------+
|   Engineering Owner    |              |   Secondary Owner      |
| (Primary Responsibility)|              | (Backup Responsibility)|
+-----------+------------+              +-----------+------------+
            |                                           |
            +-------------------+-----------------------+
                                |
                                v
                    +---------------------------+
                    |     Cryptographic Key     |
                    |  (HSM Partition Object)   |
                    +---------------------------+
                                |
                                v
                    +---------------------------+
                    |     HSM Platform Team     |
                    | (Execution / Infra Layer) |
                    +---------------------------+
```

---

## Bose-Specific Labels to Add

* ❗ “No key should exist without Primary + Secondary owner”
* ❗ “Product Security enforces policy, not execution dependency”
* ❗ “Eliminates reliance on single SME (e.g., Harris)”

---

# 4. (Optional but HIGH IMPACT) Key Inventory Flow Diagram

This one will **really impress your manager**.

---

## Diagram

```text
        HSM Partitions
              |
              v
     Key Discovery Process
              |
              v
     Key Classification
   (Use Case Mapping)
              |
              v
     Business Unit Mapping
              |
              v
     Product + Chipset Mapping
              |
              v
     Ownership Assignment
              |
              v
     Key Catalog (Source of Truth)
              |
              v
     Runbooks + Automation
```

---

## Label This Clearly

> “This is the foundation for the future Key Management Portal”

---

# How to Place This in Confluence (Important)

### Structure

Under:

**Current-State Environment**

* Add: *HSM Architecture Diagram*

Under:

**Service Engagement Model**

* Add: *Workflow Diagram*

Under:

**Key Inventory**

* Add: *Ownership Model Diagram*

---


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Perfect — this is exactly the level that moves you from **documentation → architecture leadership**.

I’ll give you **two deliverables**:

1. **Future-State Key Management Portal Architecture (AWS KMS-style but Bose-specific)**
2. **Color-coded Confluence-ready diagram layout with annotations (what to actually draw + how to present it)**

---

# 1. Future-State Key Management Portal (Bose-Specific, AWS KMS Style)

## 🎯 Objective

Move Bose from:

> Manual, person-dependent HSM operations
> ➡️
> Centralized, API-driven, self-service cryptographic platform

---

## 🔷 High-Level Architecture

```text
        +--------------------------------------------------+
        |              Bose Engineering Teams              |
        | (Firmware / Automotive / Consumer / Platform)    |
        +---------------------+----------------------------+
                              |
                              v
        +--------------------------------------------------+
        |      Key Management Portal (Self-Service UI)      |
        |  - Request Keys                                  |
        |  - View Inventory                                |
        |  - Trigger Rotation                              |
        +---------------------+----------------------------+
                              |
                              v
        +--------------------------------------------------+
        |        API Gateway / Service Layer               |
        |  - Authentication (SSO)                          |
        |  - Request Validation                            |
        |  - Routing                                      |
        +---------------------+----------------------------+
                              |
      +-----------------------+------------------------+
      |                       |                        |
      v                       v                        v
+--------------+     +------------------+     +------------------+
| Policy Engine|     | Workflow Engine  |     | Key Catalog DB   |
|              |     | (Jira/Tines)     |     | (Source of Truth)|
+------+-------+     +---------+--------+     +---------+--------+
       |                       |                        |
       +-----------+-----------+------------------------+
                   |
                   v
        +--------------------------------------------------+
        |       HSM Integration Layer (Abstraction)         |
        |   - No direct CLI exposure                       |
        |   - Standardized API calls                       |
        +---------------------+----------------------------+
                              |
                              v
        +--------------------------------------------------+
        |                Thales HSM                        |
        |   (Partitions / Keys / Crypto Operations)        |
        +--------------------------------------------------+
```

---

## 🔑 Bose-Specific Enhancements (THIS is what makes it strong)

### 🔹 1. No Direct HSM Access

* Engineers **never touch jump box directly**
* Everything goes through:

  * Portal
  * APIs

👉 Eliminates:

* human error
* inconsistent execution
* dependency on SMEs

---

### 🔹 2. Key Catalog is Central Brain

* Every operation:

  * reads from catalog
  * writes to catalog

👉 This solves your current problem:

> “We don’t know what keys exist or what they’re for”

---

### 🔹 3. Policy Engine (CRITICAL)

Enforces rules like:

* Secure Boot keys → require Product Security approval
* OTA keys → require dual approval
* Dev keys → auto-approved

👉 This replaces:

> “tribal approval logic”

---

### 🔹 4. Workflow Engine (Tines / Jira)

Handles:

* approvals
* notifications
* execution orchestration

👉 This replaces:

> Slack messages + manual coordination

---

### 🔹 5. HSM Abstraction Layer

This is **the biggest architectural leap**

Instead of:

```text
Engineer → Jump Box → CLI → HSM
```

You get:

```text
Portal → API → HSM Service → HSM
```

👉 This is exactly how AWS KMS works.

---

# 2. Color-Coded Confluence Diagram (How You Should Draw It)

This is what makes your work **executive-friendly and visually powerful**.

---

## 🎨 Color Legend (USE THIS EXACTLY)

| Color     | Meaning                           |
| --------- | --------------------------------- |
| 🔵 Blue   | User / Interaction Layer          |
| 🟢 Green  | Control Plane (logic, governance) |
| 🟡 Yellow | Data / Metadata Layer             |
| 🔴 Red    | Sensitive / Secure Boundary       |
| 🟣 Purple | Integration / External Systems    |

---

## 🔷 Layered Diagram Layout

---

### 🔵 Layer 1 — User Layer

```text
[ Blue ]
Bose Engineers
(Firmware / Automotive / Consumer / Platform)
```

---

### 🔵 Layer 2 — Interface

```text
[ Blue ]
Key Management Portal
(Self-Service UI)
```

---

### 🟢 Layer 3 — Control Plane

```text
[ Green ]
API Gateway

[ Green ]
Policy Engine

[ Green ]
Workflow Engine (Jira / Tines)
```

---

### 🟡 Layer 4 — Data Layer

```text
[ Yellow ]
Key Catalog Database
```

👉 Add annotation:

> “Single Source of Truth for all keys”

---

### 🟣 Layer 5 — Integration Layer

```text
[ Purple ]
HSM Integration Service
```

👉 Label:

> “Abstracts Thales complexity — no direct CLI usage”

---

### 🔴 Layer 6 — Secure Boundary

```text
[ Red Box Boundary ]

Thales HSM
- Partitions
- Private Keys
- Crypto Operations
```

👉 Label clearly:

> “PRIVATE KEYS NEVER LEAVE THIS BOUNDARY”

---

## 🧠 Annotations to Add (VERY IMPORTANT)

Place these as callouts in the diagram:

---

### 🔴 Callout 1 (Big One)

> “Eliminates single point of failure (no dependency on Harris)”

---

### 🟡 Callout 2

> “Key Catalog enables full visibility across Bose products”

---

### 🟢 Callout 3

> “Policy-driven approvals replace manual decision making”

---

### 🔵 Callout 4

> “Engineers interact with a platform, not infrastructure”

---

# 3. Before vs After (Add This Slide — HIGH IMPACT)

---

## 🔻 Current State

```text
Engineer → Slack → Find SME → Jump Box → CLI → HSM
```

---

## 🔺 Future State

```text
Engineer → Portal → API → Policy → Workflow → HSM
```

---

## Add This Caption

> “Transitioning Bose Product Security from reactive operations to a scalable cryptographic platform”

---

===========================================================================================================

Excellent — this is the **most operationally critical section** of your entire documentation.

This is where your work moves from **architecture → execution discipline**.

Below is a **Confluence-ready, Bose-specific, highly operational runbook suite** aligned to:

* Thales HSM
* CyberArk
* Jump Box access
* Partition-based model
* Real gaps (no visibility, SME dependency, inconsistent validation)

---

# Keys Runbooks

---

# 1. Key Creation

---

## Purpose

To securely generate a new cryptographic key within the Bose HSM environment and ensure it is:

* properly classified (use case, product, BU)
* securely stored (non-exportable within HSM)
* fully documented (Key Inventory)
* validated for operational use

---

## Scope

Applies to all key creation requests across:

* Automotive (Secure Boot, ECU)
* Consumer (OTA, Fast Pair)
* Platform (mTLS, APIs)
* Partner Integrations (Spotify, DRM)

---

## Preconditions

Before execution:

* ✅ Jira request submitted and approved
* ✅ Use case defined (e.g., OTA Signing, Secure Boot)
* ✅ Business Unit + Product identified
* ✅ Partition identified
* ✅ CyberArk access confirmed
* ✅ Jump Box access validated

---

## Execution Steps

### Step 1 — Access Jump Box

```bash
ssh <bose-hsm-jumpbox>
```

---

### Step 2 — Retrieve Credentials (CyberArk)

* Login to CyberArk
* Retrieve:

  * Crypto Officer credentials
  * Partition credentials

---

### Step 3 — Authenticate to HSM

```bash
hsm login --partition <partition-name> --user crypto_officer
```

---

### Step 4 — Generate Key

Example (RSA):

```bash
generateKeyPair --type RSA --size 2048 --label <BU-Product-UseCase-KeyName>
```

Naming must follow:

```text
<BU>-<Product>-<UseCase>-<Env>-<Version>
```

---

### Step 5 — Validate Key Creation

```bash
listKeys --partition <partition-name>
```

Confirm:

* key exists
* correct label
* correct type

---

### Step 6 — Register in Key Inventory (MANDATORY)

Update:

* Business Unit
* Product
* Use Case
* Owner (Primary + Secondary)
* Partition
* Rotation Policy

---

### Step 7 — Notify Stakeholders

* Requestor
* Product Team
* Product Security

---

## Failure Handling

| Issue                    | Action                        |
| ------------------------ | ----------------------------- |
| HSM login failure        | Validate CyberArk credentials |
| Partition not accessible | Verify access request         |
| Key generation failure   | Retry / escalate              |

---

## Bose-Specific Notes

* No key creation outside HSM
* No undocumented keys
* No ad-hoc naming

---

# 2. Key Rotation

---

## Purpose

To replace an existing key without disrupting:

* firmware validation
* OTA updates
* ecosystem integrations

---

## Trigger Conditions

* scheduled rotation
* compliance requirement
* security concern

---

## Preconditions

* ✅ Key exists in inventory
* ✅ Owner identified
* ✅ Dependencies documented

---

## Execution Steps

---

### Step 1 — Identify Existing Key

* confirm key ID
* confirm use case
* identify impacted systems

---

### Step 2 — Generate New Key

Follow **Key Creation Runbook**

---

### Step 3 — Update Dependent Systems

Examples:

* OTA signing pipeline
* firmware build system
* partner integrations

---

### Step 4 — Validation Testing

* sign test artifact
* verify device acceptance
* confirm system compatibility

---

### Step 5 — Deprecate Old Key

```bash
disableKey <key-id>
```

---

### Step 6 — Update Inventory

* mark old key as deprecated
* record rotation date

---

## Bose-Specific Risk

Improper rotation may result in:

* devices rejecting firmware
* OTA update failures
* production outages

---

# 3. Key Revocation

---

## Purpose

To immediately disable a key due to:

* compromise
* misuse
* incident response

---

## Trigger Conditions

* suspected compromise
* unauthorized usage
* security alert

---

## Execution Steps

---

### Step 1 — Identify Key

* retrieve from inventory
* confirm partition

---

### Step 2 — Immediate Revocation

```bash
revokeKey <key-id>
```

---

### Step 3 — Notify Stakeholders

* Product Security
* Engineering teams
* Leadership (if critical)

---

### Step 4 — Impact Assessment

* affected products
* OTA implications
* ecosystem dependencies

---

### Step 5 — Replacement (if required)

* generate new key
* reconfigure systems

---

### Step 6 — Incident Documentation

* timeline
* root cause
* remediation

---

## Bose-Specific Criticality

This is a **Tier-1 incident workflow**.

---

# 4. Partition Management

---

## Purpose

To manage HSM partitions including:

* creation
* access control
* capacity management

---

## Key Activities

---

### Partition Creation

* define:

  * Business Unit
  * Use Case
* assign ownership

---

### Partition Access

* managed via CyberArk
* role-based:

  * Crypto Officer
  * Crypto User

---

### Capacity Monitoring

Example:

* 95-key threshold alert

---

## Bose-Specific Problem

Today:

> Alerts fire → no context → no clear action

---

## Required Action

Each partition must include:

* key breakdown
* ownership
* use case mapping

---

# 5. Incident Response (IRP)

---

## Purpose

To respond to cryptographic incidents affecting:

* key integrity
* system trust
* product security

---

## Incident Types

* key compromise
* HSM access failure
* signing failure
* unauthorized key usage

---

## Response Flow

```text
Detect → Contain → Revoke → Replace → Recover → Document
```

---

## Execution Steps

---

### Step 1 — Detection

* alert (threshold, anomaly)
* engineer report

---

### Step 2 — Containment

* isolate affected partition
* restrict access

---

### Step 3 — Revocation

* revoke impacted keys

---

### Step 4 — Recovery

* generate replacement keys
* restore services

---

### Step 5 — Communication

* notify stakeholders
* escalate if needed

---

### Step 6 — Post-Incident Review

* root cause
* gaps
* improvements

---

## Bose-Specific Gap

* no standardized IRP today
* response depends on individuals

---

# 6. Break-Glass Recovery

---

## Purpose

To enable emergency access when:

* CyberArk unavailable
* HSM access blocked
* SME unavailable

---

## Conditions

* system outage
* critical incident

---

## Process

---

### Step 1 — Approval

* Product Security + Leadership

---

### Step 2 — Emergency Access

* use break-glass credentials
* restricted logging required

---

### Step 3 — Execute Required Action

* key revocation
* recovery

---

### Step 4 — Audit

* full logging
* post-event review

---

## Bose Risk

Without this:

> Total operational shutdown during incidents

---

# 7. Validation Procedures

---

## Purpose

To ensure every operation is:

* correct
* reproducible
* usable by others

---

## Key Principle (From Transcript)

> “Documentation is not valid until others can execute it”

---

## Validation Steps

---

### Step 1 — Peer Execution

* another engineer executes runbook

---

### Step 2 — Step Verification

* no assumptions
* no missing steps

---

### Step 3 — Output Validation

* key works as expected
* system integration verified

---

### Step 4 — Team Sign-Off

* collective approval
* thumbs-up validation

---

## Bose-Specific Goal

Move from:

> “I documented it”

to:

> “Anyone can execute it successfully”

---

# Final Summary

This runbook suite establishes:

* **repeatable execution**
* **elimination of tribal knowledge**
* **audit-ready processes**
* **incident readiness**

---



