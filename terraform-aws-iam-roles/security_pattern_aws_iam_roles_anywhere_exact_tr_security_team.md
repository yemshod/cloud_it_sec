# Security Pattern: AWS IAM Roles Anywhere

**Owner:** ExactTR Security Architecture (ExactTR-Sec)

**Version:** 1.0  
**Last Updated:** 2025-11-10 (America/Chicago)

---

## 1) Purpose & Scope
Establish a hardened, auditable pattern for enabling X.509 client-certificate based access to AWS roles via **IAM Roles Anywhere** (IRA) for ExactTR Security Team workflows (human and non‑human), across multi‑account AWS organizations. This pattern covers architecture, controls, least-privilege design, PKI governance, onboarding/runbooks, monitoring & detection, incident response, and compliance mapping.

**In‑scope:**
- Access for laptops, build agents, scanners, and secured servers that must call AWS APIs without long‑lived access keys.  
- Security/Ops automations (e.g., forensics collectors, break‑glass in controlled contexts, inventory/exporters, read‑only discovery tools).  
- All AWS accounts in the ExactTR Organization, except sandbox by default unless explicitly enrolled.

**Out‑of‑scope:**
- End-user SSO access (handled by Identity Center/OIDC/SAML).  
- Service-to-service identity in compute planes that can natively use IAM Roles (EC2, ECS, EKS, Lambda) without IRA.

---

## 2) Design Principles
1. **No long‑lived keys**: Replace access keys with short‑lived role sessions minted from client TLS certificates.  
2. **Separation of Duties (SoD)**: PKI lifecycle admins ≠ role/profile admins ≠ consumers.  
3. **Attestation over trust**: Enforce device & issuer constraints via certificate policy OIDs, SANs, and IRA conditions.  
4. **Explicit scoping**: Profiles/roles are account-, environment-, and purpose-scoped; default‑deny with minimal session duration.  
5. **Observable by design**: Every create/update/delete emits CloudTrail events → EventBridge → detections & tickets.  
6. **Revocation-first posture**: CRL/OCSP and issuer rotation are routine; emergency revocation is automated.  
7. **Recoverability**: Break‑glass channels are isolated, audited, and tested.

---

## 3) Reference Architecture
```
[ExactTR PKI] ──(CA/CRL/OCSP)──▶ [Trust Anchor(s) in IRA]
                                     │
                                     ├──▶ [Profile: sec-readonly] ──▶ [Role: ExactTR-SecurityReadOnly]
                                     ├──▶ [Profile: sec-ir-playbook] ──▶ [Role: ExactTR-IR-AcquireEvidence]
                                     ├──▶ [Profile: sec-breakglass] ──▶ [Role: ExactTR-BreakGlass]
                                     └──▶ [Profile: sec-ci-agent] ──▶ [Role: ExactTR-CI-ArtifactScan]

[Client Hosts]
  ├─ Analyst Laptops (MDM-enrolled, disk‑encrypted)
  ├─ Build/Scan Runners (self‑hosted, hardened)
  └─ Forensics Jump Host (privileged enclave)

Flow: Client presents mTLS X.509 to "rolesanywhere.amazonaws.com" → IRA validates chain to Trust Anchor + CRL/OCSP → CreateSession → STS issues short‑lived creds bound to target Role via Profile constraints/conditions → AWS API.
```

**Key Components**
- **Trust Anchors:** Reference CAs (ACM PCA or external CA).  
- **Profiles:** Bind one or more IAM roles to a set of trust anchors; control session duration & session tagging.  
- **IAM Roles:** Trust policy allows `rolesanywhere.amazonaws.com` with restrictive conditions (account, profile ARN, tags, cert attributes).  
- **Certificates:** Client certs w/ policy OIDs, device/user bindings in SAN/Subject, short validity (≤ 90 days; preferred ≤ 30).  
- **CRL/OCSP:** Mandatory; low TTL (≤ 15 min publishing cadence for high‑risk issuers).

---

## 4) Trust Model & Constraints
- **Issuer Constraints:** Only ExactTR‑approved CAs (Trust Anchors). Sub‑CAs used for environment tiers (Prod/Non‑Prod).  
- **Subject/SAN Encoding:**
  - `CN` → device ID or workload ID (not personal name).  
  - `SAN email` → user UPN (for accountability).  
  - `SAN URI` → structured device identity: `urn:exacttr:device:<mdm-id>` or workload: `urn:exacttr:workload:<app-id>`.
  - `SAN DirName`/OID → environment, department, clearance tier.
- **Policy OIDs:** Embed OIDs such as `1.2.840.113612.100.1.1` (example) signaling conformance to ExactTR issuance policy; gate in IAM conditions.
- **Device Posture:** Certificates issued only to MDM‑compliant hosts (FileVault/BitLocker on, EDR on, firewall on, kernel version N‑1).  
- **Network Egress:** Allowlisted egress to AWS IRA endpoints; TLS 1.2+ only; proxy inspection bypass for certificate pinning.

---

## 5) Secure Configuration (Authoritative)
### 5.1 Trust Anchor
- Use **ACM PCA** for internal sub‑CA per environment. Import external CA only with formal attestation.
- Enable CRL publishing (S3 private + SSE‑S3 or KMS CMK; bucket policy restricts principal to AWS RA service + SecOps tooling).
- Document and enforce OCSP responder if available.

### 5.2 Profiles (examples)
- `sec-readonly`  
  - Session duration: **900s (15m)** default; max 1h; session tags `Env`, `Purpose`, `Owner` enforced.  
  - Bound Roles: `ExactTR-SecurityReadOnly` (org‑wide read‑only views for inventory, Config, SecurityHub, GuardDuty, CloudTrail Lookup).
- `sec-ir-playbook`  
  - Session duration: **900s**; KMS permissions scoped to IR buckets/keys; S3 access to evidence vaults; Systems Manager get‑only.  
- `sec-breakglass`  
  - Disabled by default; enabled only via Change record with time‑boxed window; session limited to 900s; requires dual control (M of N) certificate + explicit approval tag on profile.

### 5.3 IAM Role Trust Policy (template)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TrustRolesAnywhere",
      "Effect": "Allow",
      "Principal": { "Service": "rolesanywhere.amazonaws.com" },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": { "aws:SourceAccount": "<ACCOUNT_ID>" },
        "ArnEquals": { "aws:SourceArn": "arn:aws:rolesanywhere:<REGION>:<ACCOUNT_ID>:profile/<PROFILE_ID>" },
        "ForAllValues:StringLike": { "aws:RequestTag/Env": ["prod","nonprod"] }
      }
    }
  ]
}
```
> **Note:** Adjust conditions to also constrain trust anchors and certificate attributes (see §5.4). Apply `sts:TagSession` constraints via permission boundary on profiles if applicable.

### 5.4 Fine‑Grained Conditions (recommendations)
- Gate on profile & account: `aws:SourceAccount`, `aws:SourceArn` (profile ARN).
- Gate on **certificate identity** via IRA condition keys (map to tags at session issuance):
  - Require `aws:RequestTag/Owner`, `aws:RequestTag/Purpose`, `aws:RequestTag/DeviceID` to match allowed patterns.  
  - Enforce regex for `DeviceID`/`AppID` (`^urn:exacttr:(device|workload):[a-z0-9-]{8,32}$`).  
- Deny if tag `BreakGlass` != `Approved-<ChangeID>`.
- Permission Boundaries on target roles to restrict data‑plane APIs beyond assumed policies when needed.

### 5.5 Session Duration
- Default: 15 minutes; Max: 60 minutes for CI/agent profiles; 15 minutes for human/IR.

### 5.6 Certificate Policy
- **Validity:** ≤ 30 days (prefer 14 for high‑risk personas).  
- **Key Algorithm:** ECDSA P‑256 or P‑384; RSA 3072 acceptable for compatibility.  
- **Key Protection:** Private keys in platform secure enclave/TPM; forbid exportable keys.
- **Revocation:** Immediate CRL publish on MDM non‑compliance, device loss, termination, or compromise; CRL delta every ≤ 15 min.

---

## 6) Guardrails (Organization Level)
- **SCPs**:  
  1. Deny `rolesanywhere:*` management in member accounts except from **Security Tooling account** via specific role.  
  2. Deny `iam:UpdateAssumeRolePolicy` that removes `SourceArn`/`SourceAccount` conditions for roles tagged `ExactTR-Managed`.  
  3. Deny creation of profiles not matching naming standard `^sec-(readonly|ir-|breakglass|ci-)`.
- **AWS Config** (managed + custom rules):  
  - `EXACTTR-IAM-ROLE-TRUST-LIMITED-TO-RA` (custom): verify `Principal.Service == rolesanywhere.amazonaws.com` AND required conditions present.  
  - `EXACTTR-IRA-PROFILE-TAG-STANDARDS`: ensure profiles have owner/custodian tags.  
  - `EXACTTR-CRL-RECENCY`: check CRL last update ≤ 30 min.
- **Identity Center**: Map human personas to certificate issuance groups; break‑glass outside IC with separate approval path.

---

## 7) Monitoring, Detection & Response
**Telemetry:**
- **CloudTrail** (all regions, org trail) for events: `CreateTrustAnchor`, `UpdateTrustAnchor`, `DeleteTrustAnchor`, `ImportCrl`, `CreateProfile`, `UpdateProfile`, `DeleteProfile`, `EnableProfile`, `DisableProfile`, `TagResource`, `UntagResource`, `CreateSession` (data event).  
- **EventBridge** rules route mgmt events to: Splunk → Notable (ExactTR‑Sec), Slack/PagerDuty for break‑glass enablement.

**Detections (examples):**
- Profile enablement outside change window → **High**.  
- New trust anchor or CRL disabled → **Critical**.  
- `CreateSession` spikes per DeviceID/AppID anomaly → **Medium**.  
- Role assumption from geo/IP not in allowlist proxies → **High**.  
- `CreateSession` with stale CRL timestamp → **High**.

**Response Playbooks:**
1. **Cert/Key compromise**: Revoke cert → publish CRL delta → disable affected profile → deny list DeviceID via session tag blocklist → IR ticket.  
2. **Unauthorized profile/role change**: SCP freeze (deny changes) → revert via IaC → audit CloudTrail actors → SEV2 incident.  
3. **Break‑glass misuse**: Immediate disable + access log review, rotate evidence KMS grants; post‑mortem within 24h.

---

## 8) Onboarding & Runbooks
### 8.1 PKI Setup (once per environment)
1. Provision ACM PCA Sub‑CA; set CRL S3 bucket (private, versioned, KMS).  
2. Define certificate template (policy OIDs, SANs).  
3. Create Trust Anchor in IRA (pointing to CA cert chain).  
4. Automate CA health checks (CRL freshness, signer expiry alerts at 90/60/30/7 days).

### 8.2 Profile & Role Creation (per use case)
1. Create IAM role policy with least privilege.  
2. Apply trust policy template (§5.3) with profile/anchor constraints.  
3. Create IRA Profile; bind role(s); set session duration; enforce required session tags.  
4. Register in inventory CMDB (Owner, Purpose, Data Domains, Environments).  
5. IaC: Terraform module (see §10) to standardize; PR approval by Security Architecture.

### 8.3 Consumer Enrollment
1. Verify persona group membership (Identity Center/AD).  
2. Issue client cert on MDM‑managed device (non‑exportable key).  
3. Distribute IRA bootstrap (region, profile ARN, trust anchor ARN) and `aws_signing_helper`/`rolesanywhere` client.  
4. Test `CreateSession` with read‑only profile; validate session tags & CloudTrail entry.

### 8.4 Rotation
- **Certificates**: Auto‑renew at 50% lifetime; random jitter ±10%.  
- **Trust Anchor/CA**: Yearly key rotation; overlapping CAs; dual‑anchor profiles during migration.  
- **Roles/Policies**: Quarterly review; remove unused permissions; check Access Analyzer findings.

---

## 9) Least‑Privilege Reference Policies (snippets)
### 9.1 Allow IRA client to get a session only via specific anchors/profiles
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CreateSessionLimited",
      "Effect": "Allow",
      "Action": ["rolesanywhere:CreateSession"],
      "Resource": [
        "arn:aws:rolesanywhere:<REGION>:<ACCOUNT_ID>:trust-anchor/<TA_ID>",
        "arn:aws:rolesanywhere:<REGION>:<ACCOUNT_ID>:profile/<PROFILE_ID>"
      ],
      "Condition": {
        "StringEquals": {"aws:PrincipalAccount": "<ACCOUNT_ID>"}
      }
    }
  ]
}
```

### 9.2 Security Read‑Only role (example services)
- `securityhub:Get*`, `securityhub:Describe*`, `securityhub:List*`  
- `guardduty:Get*|List*|Describe*`  
- `config:BatchGet*|Get*|Describe*|List*`  
- `ec2:Describe*`, `iam:GenerateServiceLastAccessedDetails`, `cloudtrail:LookupEvents` (scoped by resource where possible).

> Use Access Analyzer & IAM Policy Simulator to validate blast radius.

---

## 10) Terraform/IaC Standard (module outline)
```
modules/
  rolesanywhere/
    - trust_anchor.tf         # data "aws_acmpca_certificate_authority" + aws_rolesanywhere_trust_anchor
    - profile.tf              # aws_rolesanywhere_profile with required tags, session duration, role ARNs
    - role.tf                 # aws_iam_role with trust policy template and inputs
    - crl.tf                  # s3 bucket + policy + acmpca_certificate_authority CRL config
    - outputs.tf              # profile ARN, trust anchor ARN

examples/
  - sec_readonly_profile/
  - sec_ir_playbook/

policies/
  - iam_role_trust_policy.json.tmpl
  - readonly_policy.json
  - ir_acquire_evidence.json
```
**Pipelines:** Pre‑commit checks (tflint, tfsec, checkov), OPA/Rego policy gates for trust policy structure, codeowner approvals.

---

## 11) Logging, Storage & Data Protection
- **S3 Buckets (CRLs, logs):** SSE‑KMS (dedicated CMK), bucket keys enabled, access points restricted by VPC endpoint; lifecycle: retain ≥ 400 days.
- **KMS:** Key policies owned by Security; grants for IR tooling; rotation annually.
- **Splunk/Wiz/Prisma:** Forward IRA logs; detections as in §7.

---

## 12) Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Private key theft on endpoint | Medium | High | Non‑exportable keys, EDR, short cert life, CRL fast publish, device posture checks |
| Mis‑scoped role trust policy | Medium | High | IaC templates, OPA gates, SCP deny on missing conditions, quarterly review |
| CRL outage/staleness | Low | High | Health checks + on‑call; multi‑region S3; delta CRL every ≤15 min |
| Break‑glass abuse | Low | Critical | Dual‑control enablement, time‑boxed profiles, separate audit log, pager alerts |
| Rogue CA import | Low | High | SCP deny outside Security account; change board approval; EventBridge alerts |

---

## 13) Compliance Mapping (indicative)
- **CIS AWS Foundations 1.5**: 1.1–1.5 logging; 1.14 no long‑lived keys; 1.20 strong identity; 3.x IAM LP.  
- **NIST 800‑53 Rev5**: AC‑2/AC‑3/AC‑6/AC‑17, IA‑2/IA‑5, CM‑5, AU‑2/AU‑6, SI‑4.  
- **CMMC v2**: AC.L1‑3.1.1, IA.L2‑3.5.1/3.5.3, AU.L2‑3.3.1/3.3.3.

---

## 14) Operational Checklists
**Daily**
- EventBridge queue empty of IRA critical alerts  
- CRL recency < 30 min

**Weekly**
- Access Analyzer findings = 0 for IRA roles  
- Any new `CreateSession` principals reviewed

**Monthly**
- Certificate issuance & revocation stats; unused profiles disabled  
- Validate break‑glass drill (tabletop or live)

---

## 15) Appendices
### A) Example `aws_signing_helper` usage
```bash
aws_signing_helper credential-process \
  --certificate /var/lib/exacttr/certs/device.crt \
  --private-key file:///var/lib/exacttr/keys/device.key \
  --trust-anchor-arn arn:aws:rolesanywhere:<REGION>:<ACCOUNT_ID>:trust-anchor/<TA_ID> \
  --profile-arn arn:aws:rolesanywhere:<REGION>:<ACCOUNT_ID>:profile/<PROFILE_ID> \
  --role-arn arn:aws:iam::<ACCOUNT_ID>:role/ExactTR-SecurityReadOnly \
  --duration-seconds 900
```

### B) Break‑Glass Governance (summary)
- Separate CA and trust anchor  
- Profile disabled by default; enable only with `ChangeID` tag + approval  
- EventBridge → PagerDuty; post‑use rotation & review within 24h

### C) Decision Log
- Adopt ACM PCA over external CA for revocation control and automation.  
- Enforce ≤ 30‑day cert validity; standardize OIDs & SAN schemas.  
- Org‑level SCP to centralize IRA governance.

---

> **This document is authoritative for design/controls; deviations require a recorded exception with compensating controls and expiry.**

