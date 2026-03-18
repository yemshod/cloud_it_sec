Got it — this is exactly the right push. What you had before was **technically correct but not contextualized to Bose’s reality**.

Below is a **rewritten, fully contextualized version** that reflects:

* the **actual problems in your transcript** (tribal knowledge, Harris dependency, scattered Confluence, unclear ownership)
* the **Bose product ecosystem (automotive, consumer, OTA, partnerships like Spotify, Fast Pair, etc.)**
* the **HSM reality (Thales, partitions, CyberArk, jump boxes, thresholds like the 95 key alert)**
* the **goal of building toward a self-service key management system**

This now reads like something **written by someone inside Bose Product Security**, not a generic template.

---

# Supported Use Cases

## Purpose

Cryptographic Services within the Bose Product Security team exists to support **real product and platform trust requirements**, not abstract cryptographic theory.

At Bose, cryptographic keys are directly tied to:

* how devices boot and establish trust
* how firmware is signed and delivered to customers
* how automotive and consumer products integrate into ecosystems
* how licensed content is protected
* how partner platforms (e.g., Google Fast Pair, Spotify, DRM ecosystems) trust Bose devices

Today, one of the major challenges we face is that while these cryptographic operations exist and are actively used, **they are not consistently documented, categorized, or mapped to their actual business and product use cases**.

As a result:

* we know keys exist in partitions, but not always *what they are for*
* we can see counts (e.g., “200 keys in a partition”), but not *distribution or purpose*
* onboarding engineers struggle to understand **which key supports which product or workflow**
* operational knowledge is still partially **person-dependent (e.g., reliance on Harris)**

This section defines the **actual use cases that Bose Product Security supports**, grounded in how keys are used across automotive, consumer, and platform integrations.

This is the foundation for:

* building a **true key inventory (not just a list of keys)**
* creating **use-case-specific runbooks**
* enabling **future automation and self-service key management**
* eliminating reliance on tribal knowledge

---

## Why Use-Case Definition Matters at Bose

Today, keys inside the HSM environment are often treated as:

> “keys in partitions”

But that abstraction breaks down quickly in practice.

At Bose:

* A **secure boot key for an automotive system** is fundamentally different from
  a **Spotify integration key**
* A **Google Fast Pair key** has different lifecycle requirements than
  an **OTA firmware signing key**
* A **DRM/HDCP key** may be governed by external licensing constraints, unlike
  internal platform authentication keys

Yet today, these distinctions are not consistently captured.

This creates real operational problems:

* When a threshold alert fires (e.g., 95-key limit), we don’t know:

  * which products are impacted
  * which keys are critical vs low risk
* When someone asks:

  > “What are these 200 keys in this partition?”
  > we cannot answer confidently without digging through scattered docs
* When onboarding new engineers:

  * they don’t know where to look (Confluence is fragmented)
  * they don’t know who owns what
  * they rely on Slack/Teams or specific individuals

Defining use cases properly allows us to:

* map keys to **actual product behavior**
* create **targeted runbooks instead of generic instructions**
* enforce **use-case-specific governance**
* support **faster troubleshooting and incident response**
* prepare for a **self-service key management platform**

---

## Bose-Specific Use Case Categories

The following use cases reflect how cryptographic keys are actually used across Bose Product Security.

---

## 1. Secure Boot (Root of Trust for Devices)

### Overview (Bose Context)

Secure boot is the **root of trust** for Bose devices across both:

* automotive systems
* consumer devices (headphones, speakers, etc.)

When a device powers on, it verifies firmware using embedded public keys that correspond to private signing keys controlled by Product Security.

If this fails, the device must not boot.

This is not theoretical — this is **what prevents compromised firmware from running on Bose devices in the field**.

---

### What Exists Today (Reality)

* Keys exist in HSM partitions
* Some naming conventions (e.g., patterns like “Pearl”) exist but are not consistently understood
* Documentation exists, but is **scattered across personal Confluence spaces (e.g., Harris’ pages)**
* Not all engineers can clearly map:

  * key → product → use case → lifecycle

---

### Cryptographic Assets

* RSA/ECC signing key pairs
* Public keys embedded in firmware or bootloaders
* HSM-protected private keys (non-exportable)

---

### Operational Characteristics

* Extremely restricted access (should be Crypto Officer controlled)
* Must be tightly integrated with firmware signing processes
* Requires strict validation before production use
* Should never depend on a single individual to operate

---

### Bose-Specific Risk

If these keys are compromised:

* unauthorized firmware could be signed
* devices could run malicious code
* product trust is broken at the root level

This is truly **“keys to the kingdom”** in the literal sense.

---

## 2. OTA Firmware Signing (Release & Field Updates)

### Overview (Bose Context)

Bose products rely on OTA updates for:

* bug fixes
* feature updates
* security patches

These updates are signed using cryptographic keys stored in HSMs.

Devices validate updates before installation.

---

### Current Reality

* Keys are used regularly in release pipelines
* Integration with build/release systems exists but is not fully standardized
* Rotation policies are not always clearly defined or documented
* Runbooks for update signing workflows are not centralized

---

### Cryptographic Assets

* Signing key pairs (often SHA-based signing workflows)
* Release certificates
* Integration into CI/CD pipelines

---

### Operational Characteristics

* High frequency usage compared to secure boot
* Requires coordination with release engineering
* Needs strong auditability (who signed what, when)
* Requires fast response in case of compromise

---

### Bose-Specific Risk

* A compromised OTA key could push malicious updates to all devices
* A failed key could block product updates entirely
* Recovery requires coordinated re-signing and device trust management

---

## 3. Ecosystem Authentication (Fast Pair, Device Pairing, Platform Trust)

### Overview (Bose Context)

Bose devices integrate with external ecosystems such as:

* Google Fast Pair
* Mobile companion apps
* Platform-level pairing/authentication flows

These rely on cryptographic identity and trust relationships.

---

### Current Reality

* Keys exist for these integrations but are not always clearly categorized
* Ownership between Product Security, firmware, and platform teams is not always explicit
* Some keys may not even be tracked in HSM consistently

---

### Cryptographic Assets

* ECC/RSA identity keys
* Platform-issued credentials
* Device authentication material

---

### Operational Characteristics

* Often tied to external requirements (Google, mobile OS, etc.)
* Requires coordination across:

  * firmware
  * mobile
  * cloud services
* Lifecycle expectations vary by ecosystem

---

### Bose-Specific Risk

* Devices may fail to pair or authenticate
* Ecosystem integrations (e.g., Fast Pair) could break
* Customer experience degradation

---

## 4. DRM / HDCP / Licensed Content Protection

### Overview (Bose Context)

Bose products that support protected media must comply with:

* HDCP requirements
* DRM ecosystem constraints

These are often externally governed.

---

### Current Reality

* Keys exist but are not always clearly mapped in inventory
* Documentation may be tied to projects rather than centralized
* Lifecycle and compliance constraints are not always visible to all engineers

---

### Cryptographic Assets

* HDCP keys
* DRM certificates
* Partner-issued credentials

---

### Operational Characteristics

* Strict handling requirements (often externally defined)
* Limited operational flexibility
* May require coordination with vendors or licensing bodies

---

### Bose-Specific Risk

* Loss of ability to play protected content
* Compliance violations with partners
* Certification failures

---

## 5. Partner Integrations (Spotify, External APIs, Services)

### Overview (Bose Context)

Bose integrates with external services such as:

* Spotify
* other platform/service providers

These integrations rely on cryptographic trust mechanisms.

---

### Current Reality

* Keys may be:

  * partially tracked
  * inconsistently documented
  * not clearly tied to owners or renewal cycles
* Ownership ambiguity is common

---

### Cryptographic Assets

* API signing keys
* service authentication keys
* partner-issued credentials

---

### Operational Characteristics

* External dependency (cannot fully control lifecycle)
* Requires tracking:

  * expiration dates
  * partner requirements
  * renewal processes

---

### Bose-Specific Risk

* Integration failures (e.g., Spotify not working)
* Service outages
* escalation across multiple teams without clear ownership

---

## 6. Internal Platform & Automation Keys

### Overview (Bose Context)

These keys support internal systems such as:

* automation workflows (e.g., Tines)
* internal services
* signing within pipelines
* service-to-service authentication

---

### Current Reality

* Some keys are tracked in HSM, others may not be
* Lifecycle is often less strictly governed
* Ownership is distributed across teams

---

### Cryptographic Assets

* mTLS certificates
* internal signing keys
* automation-related credentials

---

### Operational Characteristics

* higher frequency usage
* shorter lifecycles
* more automation opportunities

---

### Bose-Specific Risk

* internal service failures
* automation breakdowns
* increased operational burden

---

## Cross-Cutting Bose-Specific Observations

Based on current state (from transcript):

### 1. Lack of Central Visibility

We know partitions and counts, but not full breakdown by use case.

### 2. Documentation Exists but Is Fragmented

* buried in personal spaces
* not discoverable from main Product Security page

### 3. Knowledge Is Not Transferable

* onboarding is slow
* engineers rely on individuals instead of documentation

### 4. No Clear Use-Case Mapping Today

* keys are not consistently tied to product/business purpose

---

## Relationship to the Broader Initiative

This use-case model is not theoretical — it directly drives:

### Key Inventory

Every key must map to one of these use cases.

### Runbooks

Each use case must have:

* step-by-step procedure
* validated execution

### Governance

Different use cases = different approval and lifecycle requirements.

### Future Platform

The self-service portal will expose:

* “Request OTA signing key”
* not “Create key in partition”

---

## Summary

At Bose, cryptographic keys are not just technical artifacts — they are directly tied to:

* product trust
* firmware integrity
* ecosystem integration
* customer experience
* business continuity

The current challenge is not that these capabilities don’t exist —
it is that they are **not structured, discoverable, or consistently understood across the team**.

By defining supported use cases in a Bose-specific context, we:

* eliminate ambiguity
* reduce dependency on individuals
* enable faster onboarding and troubleshooting
* improve operational resilience
* create the foundation for a **self-service key management system**

---

If you want, next I can:

👉 Rewrite **Service Engagement Model in this same Bose-specific tone**
👉 Or build the **Key Inventory section with actual table schema + examples based on your environment**

Both will elevate this to **Principal-level documentation**.
