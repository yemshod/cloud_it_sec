| # | Control Title/Description | Tools | Justification |
|----|---------------------------|--------|---------------|
| 1 | Account Management – Define types of users, roles, and access. | Keychain RBD, Workday, Entra ID | Keychain RBD is used to submit access requests; Entra ID aligns users to proper groups and roles; Workday syncs user identities and employment metadata. |
| 2 | Identifier Management – Manage user identifiers by uniquely identifying individuals and devices. | Workday, MSFT Entra ID, Ping | Workday provides employee identity; Entra ID assigns and manages unique user IDs; Ping facilitates federation and identity brokering. |
| 3 | Authenticator Management – Manage authenticators (e.g., passwords, keys, tokens). | Keychain RBD, Workday, Entra ID, CyberArk | Keychain initiates requests; Entra ID manages user credentials; CyberArk stores and rotates privileged secrets securely. |
| 4 | Authenticator Feedback – Obscure feedback of authentication failure causes. | AWS Native Login Pages, Ping, Entra ID | Tools suppress detailed login error messages, preventing enumeration of valid usernames or authentication methods. |
| 5 | Cryptographic Protection – Use cryptographic methods to protect confidentiality and integrity. | Vormetric/VMC, AWS KMS | Vormetric and AWS KMS provide encryption for data-at-rest and in-transit using FIPS-validated cryptographic modules. |
| 6 | Incident Response Policy – Define incident response roles, plans, and responsibilities. | Process Related | Policy defines how teams detect, respond, and recover from security incidents, ensuring clear ownership and response strategy. |
| 7 | Incident Handling – Assign responsibilities for identifying and handling incidents. | ServiceNow IR Module, MSFT Sentinel | Incidents are triaged and tracked through ServiceNow; Sentinel correlates and raises alerts based on defined rules. |
| 8 | Incident Reporting – Report incidents to authorities or stakeholders as required. | Proofpoint, Azure Lighthouse, Splunk ES | Proofpoint flags DLP/breach events; Lighthouse and Splunk alert security owners who then engage reporting workflows. |
| 9 | System Use Notification – Notify users of monitoring or consent banners. | Login Banners (GPO), Azure Conditional Access | Conditional Access policies or GPOs enforce login banners with consent and acceptable use statements. |
| 10 | Session Lock – Automatically lock sessions after inactivity. | GPO, Intune Policy, AWS IAM Session TTLs | GPO and Intune enforce workstation inactivity locks; IAM TTL policies auto-expire sessions to reduce session hijack risks. |
| # | Control Title/Description | Tools | Justification |
|----|---------------------------|--------|---------------|
| 11 | Session Termination – Automatically terminate sessions after defined timeouts or logouts. | GPO, Intune, Entra ID, AWS IAM | Session policies terminate idle sessions to reduce risk of unauthorized access through stale sessions. |
| 12 | Least Privilege – Grant users only the access necessary to perform their roles. | Entra ID, AWS IAM, Workday, FAM | Access is scoped based on job function; IAM and FAM enforce RBAC/ABAC principles via group/role assignments. |
| 13 | Privileged Access Management – Restrict, monitor, and manage privileged accounts. | CyberArk, Entra ID PIM, AWS IAM, Keychain RBD | CyberArk manages secrets and access workflows; PIM enforces just-in-time access; Keychain initiates privilege request approvals. |
| 14 | Audit Logs – Generate, protect, and retain audit logs for critical events. | Splunk, AWS CloudTrail, Azure Monitor, Entra ID Logs | Logs are collected centrally; integrity is preserved using encryption and access controls; retained per policy. |
| 15 | Log Review – Regularly review audit logs to identify suspicious behavior. | Splunk ES, Azure Sentinel, AWS GuardDuty | Logs are analyzed using correlation rules, threat intel, and anomaly detection to detect malicious activity. |
| 16 | Access Control for Audit Logs – Restrict access to audit logs. | IAM Policies, Role-Based Access, S3 Bucket Policies | Logs are access-controlled using fine-grained IAM policies; only authorized auditors can view them. |
| 17 | Time Stamps – Ensure audit records have synchronized time sources. | NTP, CloudWatch, Azure Time Sync | All systems use common, trusted time sources to ensure consistency of audit log timestamps. |
| 18 | Protection of Audit Logs – Prevent unauthorized access, deletion, or modification of logs. | S3 Object Lock, Immutable Logs, Splunk Archival | Object lock and WORM policies ensure logs can’t be modified once written; Splunk archives protect log history. |
| 19 | Monitoring and Detection – Continuously monitor system activity for anomalies. | Splunk, Azure Sentinel, AWS GuardDuty, Prisma Cloud | Tools perform real-time monitoring, correlation, and alerting on unusual system or user behavior. |
| 20 | Monitoring Tools Protection – Protect integrity and availability of monitoring tools. | IAM Restrictions, Network Segmentation | Monitoring tools are placed in protected environments and access is limited via least privilege. |
| 21 | Vulnerability Management – Identify, report, and mitigate vulnerabilities. | Tenable, Prisma Cloud, Microsoft Defender, AWS Inspector | Regular scans are conducted to identify CVEs and misconfigurations; prioritized remediation is tracked. |
| 22 | Vulnerability Scanning – Scan systems periodically and after changes. | Tenable, Defender for Endpoint, AWS Inspector | Scanning tools identify vulnerabilities at scheduled intervals and after system changes or deployments. |
| 23 | Patch Management – Apply patches in a timely and prioritized manner. | SCCM, WSUS, AWS Systems Manager Patch Manager | Patch cycles are scheduled and tracked; automated tools apply and report on patch levels. |
| 24 | Configuration Management – Manage and baseline system configurations. | Microsoft Intune, AWS Config, Azure Policy | Policies define secure baselines; drifts from baseline are detected and remediated through configuration management. |
| 25 | Change Management – Control changes through formal approval and tracking. | ServiceNow, Jira, Change Request Process | Changes are logged, reviewed, approved, and tracked using structured ITSM workflows. |
| 26 | Baseline Configuration – Establish and maintain secure configurations. | AWS Config, Azure Blueprints, Intune Baselines | Baselines are defined and applied through IaC and policy enforcement to maintain secure posture. |
| 27 | Least Functionality – Disable unused ports, protocols, and services. | Azure Security Center, AWS Security Hub, System Hardening Scripts | Tools detect unnecessary services; hardening guidelines are applied to reduce attack surface. |
| 28 | Information Flow Enforcement – Control data flow within systems and networks. | Firewall Rules, NSGs, VPC Flow Logs | Access control rules restrict which systems can communicate; logs track data flows. |
| 29 | Remote Access – Authorize and secure remote access connections. | VPN, Azure Bastion, AWS Session Manager | Remote access is limited to authorized users and protected via encryption, MFA, and access policies. |
| 30 | Wireless Access – Control and encrypt wireless network access. | WPA2/3, Radius, Network Access Control | Wireless networks enforce authentication, encryption, and device checks before granting access. |
| 31 | Publicly Accessible Content – Limit and protect content exposed to the public. | S3 Public Block, Azure Web App Policies, WAF | Tools ensure only intended resources are publicly available; alerts for misconfigured exposures. |
| 32 | Use of External Systems – Assess and approve external information systems before connection. | Vendor Risk Assessment, VMC, Azure Lighthouse | External system integrations are reviewed, tracked, and monitored for compliance and data protection. |
| 33 | Portable Storage – Restrict use of external storage devices. | Endpoint DLP, USB Control via Intune | Devices enforce block or encryption rules for external drives; monitored for data movement. |
| 34 | Mobile Code – Restrict unauthorized mobile code (e.g., Java, ActiveX). | AppLocker, Ivanti, Defender for Endpoint | Execution of mobile code is limited to signed or approved scripts only. |
| 35 | Voice Over IP – Protect VoIP communications. | TLS/SSL for SIP, VLAN Isolation | VoIP systems use encrypted signaling and network isolation to prevent eavesdropping or tampering. |
| 36 | Email Security – Protect emails from phishing and data leakage. | Proofpoint, Defender for Office365, DKIM/DMARC/SPF | Email traffic is inspected and filtered; spoofing prevention and DLP rules enforced. |
| 37 | Data Loss Prevention – Monitor and protect against unauthorized data transfers. | Microsoft Purview DLP, Proofpoint DLP | Policies scan for sensitive data patterns and block/alert on violations. |
| 38 | Access Enforcement – Enforce access decisions across all systems. | IAM Policies, Entra ID, Ping | Access decisions are enforced through RBAC, ABAC, and SSO federation using defined identity policies. |
| 39 | Separation of Duties – Split critical functions across multiple users. | Workday Role Design, IAM Segregation | Duties are separated by role definitions and access scoping; approvals require multiple personas. |
| 40 | Access Control for Mobile Devices – Enforce security on mobile platforms. | Intune MDM, Apple Business Manager, Android Enterprise | Mobile devices are enrolled, secured, and managed with conditional access and compliance policies. |
| # | Control Title/Description | Tools | Justification |
|----|---------------------------|--------|---------------|
| 41 | Use of External Messaging Platforms – Control and monitor use of external communications. | Proofpoint, Microsoft Purview, Defender for Office 365 | Tools monitor and log data exchanged via email or chat platforms; enforce policy on external sharing. |
| 42 | Security Function Isolation – Isolate security functions to reduce risk of tampering. | Dedicated VMs, VPCs, Admin VLANs | Security tools are deployed in isolated zones to protect them from compromise. |
| 43 | Security Function Protection – Protect security mechanisms from unauthorized changes. | IAM Policies, Role Restrictions, Change Management | Only authorized users can modify critical security settings via enforced IAM or privileged access workflows. |
| 44 | Security Function Verification – Validate security functions are running correctly. | Monitoring Dashboards, Heartbeat Checks, Azure Monitor | Continuous checks validate that security controls (e.g., AV, logging) are running and up to date. |
| 45 | Least Privilege for Security Tools – Security tool access is tightly scoped. | CyberArk, Entra PIM, Least Privilege IAM Policies | Security accounts use just-in-time access and minimal permissions to reduce abuse risk. |
| 46 | Developer Security Training – Train developers on secure coding practices. | LMS, Secure Code Warrior, Code Scanning Findings Review | Training platforms and remediation reviews help developers follow secure design principles. |
| 47 | Code Scanning – Analyze code for security flaws. | GitHub Advanced Security, SonarQube, Wiz Code | Static and dynamic scanners flag vulnerabilities and misconfigurations in CI/CD pipelines. |
| 48 | Configuration Scanning – Analyze deployed infrastructure configurations. | Prisma Cloud, Wiz, AWS Config | Tools scan deployed resources for policy violations, insecure settings, and drift from secure baselines. |
| 49 | Hardening Guidelines – Apply secure configuration baselines to systems. | CIS Benchmarks, Intune, AWS SSM Documents | Systems are configured using hardened templates; compliance monitored continuously. |
| 50 | License Management – Track and manage software licensing. | ServiceNow CMDB, Microsoft Compliance Center | Software inventory and usage are tracked for legal and operational compliance. |
| 51 | Maintenance Tools – Approve and monitor remote admin tools. | Ivanti, JumpCloud, AWS SSM | Only approved tools are used for maintenance and are monitored/logged to detect abuse. |
| 52 | Controlled Maintenance – Log and authorize all maintenance actions. | ServiceNow, Jira, AWS Systems Manager Logs | Maintenance is requested, approved, and recorded through ITSM processes and system logs. |
| 53 | Maintenance Personnel – Screen and authorize maintenance personnel. | Workday, Background Check Systems | Only cleared and designated individuals perform maintenance on critical systems. |
| 54 | Media Protection Policy – Define rules for handling sensitive media. | Process Related, SOPs | Policy dictates encryption, tracking, and approved destruction methods for media. |
| 55 | Media Access – Restrict access to media based on classification. | IAM Access, S3 Bucket Policies, BitLocker | Access is controlled and media encrypted or locked based on sensitivity. |
| 56 | Media Storage – Store media securely when not in use. | Safe Storage Areas, Secure Cabinets, Encrypted Volumes | Physical and logical protections prevent unauthorized access to stored media. |
| 57 | Media Transport – Track and protect media during transfer. | Secure Courier, Audit Logs, Encrypted Drives | Movements are logged and media is encrypted in transit to avoid interception. |
| 58 | Media Sanitization – Properly sanitize or destroy media before reuse or disposal. | Blancco, Degaussers, Destruction Logs | Data-wiping tools or physical destruction methods ensure data is unrecoverable. |
| 59 | Physical Access Authorizations – Define and approve who has access to physical spaces. | Badge Access System, HR Workflow | Access is provisioned and revoked through HR-driven authorization process. |
| 60 | Physical Access Control – Enforce physical security perimeters. | Smart Locks, Mantraps, Security Guards | Only authorized badge holders can enter; multiple barriers restrict unauthorized entry. |
| 61 | Access to Output Devices – Control access to printers, displays, and storage. | Print Release, Badge Authentication, Workspace Zoning | Devices require authentication before use and are placed in secured environments. |
| 62 | Access Control for Transmission – Protect information in transit. | TLS, IPsec, AWS PrivateLink | Data is encrypted during transfer and routed through secure, private paths. |
| 63 | Boundary Protection – Monitor and control network boundaries. | Firewalls, NSGs, NACLs, Azure Firewall | Boundary devices enforce policy on traffic entering/leaving trusted zones. |
| 64 | Trusted Path – Ensure secure user-system communications. | HTTPS, VPN, SSH | Authenticated and encrypted sessions ensure secure interactions with systems. |
| 65 | Cryptographic Key Establishment – Use secure methods to exchange encryption keys. | AWS KMS, Azure Key Vault, TLS Handshake | Keys are exchanged using secure protocols and stored in FIPS-compliant HSMs. |
| 66 | Cryptographic Key Protection – Safeguard encryption keys from unauthorized access. | CyberArk, Key Vault, Secrets Manager | Keys are encrypted, access-logged, and rotated periodically under strict IAM control. |
| 67 | Certificate Management – Issue and manage digital certificates securely. | AWS ACM, Azure Key Vault, Entrust | Certificates are issued, rotated, and revoked through automated lifecycle tools. |
| 68 | Public Key Infrastructure (PKI) – Use PKI to verify identities and encrypt communications. | ADCS, DigiCert, AWS ACM | PKI ensures identity validation and secure communication via trusted certificate chains. |
| 69 | Use of External Cryptography – Validate third-party cryptographic modules. | Vendor Crypto Attestations, Compliance Reviews | Only approved and standards-compliant crypto providers are used for integrations. |
| 70 | Access Control for Cryptographic Keys – Limit access to key management systems. | IAM, Key Vault Policies, CyberArk Roles | Key usage is scoped and governed using IAM roles, audit trails, and role separation. |
| # | Control Title/Description | Tools | Justification |
|----|---------------------------|--------|---------------|
| 71 | Key Recovery – Provide a mechanism for recovering lost encryption keys. | AWS KMS Backup, Azure Key Vault Recovery, CyberArk | Key recovery options allow retrieval or rotation via backup copies or key escrow policies. |
| 72 | Key Revocation – Revoke cryptographic keys when compromised or no longer needed. | AWS KMS Disable/Rotate, Azure Key Vault Revocation | Tools allow immediate key revocation to halt unauthorized access or decryption. |
| 73 | Key Expiration – Set expiration dates on cryptographic keys. | Key Vault Policies, AWS KMS Key Rotation | Automatic expiration or rotation ensures cryptographic hygiene and reduces long-term exposure. |
| 74 | Key Archival – Archive encryption keys for legal and recovery requirements. | CyberArk, Encrypted Key Archives, Azure Key Vault Backup | Archived keys are stored securely for legal hold, compliance, or long-term access. |
| 75 | Random Bit Generation – Use approved sources of randomness in cryptographic functions. | FIPS-validated Crypto Modules | Random number generation is validated to ensure entropy for secure encryption and key generation. |
| 76 | System and Communications Protection Policy – Define expectations for secure communications. | Policy Document | Sets requirements for network segmentation, encryption, logging, and boundary defenses. |
| 77 | Denial of Service Protection – Detect and respond to DoS attempts. | WAF, AWS Shield, Azure DDoS Protection | Services detect and block volumetric and application-layer attacks in real time. |
| 78 | Boundary Defense – Control traffic at the network edge. | Azure Firewall, AWS Network Firewall, Palo Alto | Tools enforce traffic policies between trust zones and external networks. |
| 79 | Transmission Confidentiality – Protect data in transit from unauthorized disclosure. | TLS, IPSec, VPN | All communication channels are encrypted to prevent interception. |
| 80 | Transmission Integrity – Ensure transmitted data has not been altered. | TLS, Hash Validation, End-to-End Encryption | Integrity checks and secure protocols validate message contents during transfer. |
| 81 | Cryptographic Protection of Data at Rest – Encrypt data stored on systems. | AWS S3 SSE, Azure Storage Encryption, Vormetric | Encryption protects data from unauthorized disclosure on lost or stolen media. |
| 82 | Cryptographic Protection of Data in Transit – Encrypt data moving across networks. | TLS, SSH, VPN | Tools protect data in motion between clients, systems, and cloud services. |
| 83 | Protection of Information at Rest – Use encryption, access control, and isolation to protect stored data. | BitLocker, Azure Disk Encryption, S3 Encryption | Combined technical controls ensure confidentiality and integrity of stored data. |
| 84 | Protection of Information in Transit – Secure network communications. | IPsec, HTTPS, Encrypted APIs | Data in transit is protected using modern secure transport protocols. |
| 85 | Separation of User Functions – Isolate functions that can affect system integrity. | IAM Segregation, Role Design, Environment Isolation | Admin, audit, and user roles are separated; dev/test/prod environments isolated. |
| 86 | Protection of System Information – Limit exposure of system-level details. | Banner Configs, Masking, RBAC | Suppresses OS info, software versions, or sensitive logs from unauthorized users. |
| 87 | Confidentiality of Backup Information – Encrypt and restrict access to backups. | AWS Backup Encryption, Azure Recovery Vault, Veeam | Encrypted backups prevent disclosure of sensitive data during transit or storage. |
| 88 | Integrity of Backup Information – Validate backup data integrity. | Hash Checks, Backup Validation Logs | Regularly tested backups verify that data has not been tampered or corrupted. |
| 89 | Availability of Backup Information – Ensure backups are accessible when needed. | Cross-Region Backups, Cloud Retention Policies | Backup systems maintain high durability and support quick restoration in emergencies. |
| 90 | Availability – Protect systems from disruptions and ensure uptime. | HA Architectures, Auto Scaling, Multi-AZ Deployment | High availability configurations reduce the risk of single-point failures. |
| 91 | Failover – Design systems to switch automatically during outages. | Route 53 Failover, Azure Traffic Manager | DNS and infrastructure-level failover mechanisms ensure resilience. |
| 92 | Redundancy – Deploy redundant components and services. | Active-Passive Clusters, Replication | Services are replicated across zones/regions to ensure availability during disruptions. |
| 93 | Communications Protection – Control and monitor network communications. | Firewalls, IDS/IPS, NSGs | Controls enforce policy-based segmentation and detection across network flows. |
| 94 | Encryption of Internal Communications – Protect sensitive internal communication paths. | VPC Peering with Encryption, mTLS | Internal service-to-service traffic is encrypted to reduce internal threat exposure. |
| 95 | Availability of Communication Paths – Monitor and maintain uptime of critical links. | Route Monitoring, SLA Alerts | Availability is tracked and alerts issued if key paths are down or degraded. |
| 96 | Integrity of Communication Paths – Detect and protect against unauthorized alteration. | MAC Checks, Secure Hash, Encrypted Tunnels | Cryptographic checks validate communication contents over trusted paths. |
| 97 | Public Key Infrastructure Management – Secure lifecycle of PKI components. | ADCS, DigiCert, Entrust | PKI authorities and issuing workflows are protected with RBAC, logging, and signing controls. |
| 98 | Distribution of Public Keys – Share public keys securely and prevent tampering. | Certificate Pinning, PKI Portals | PKI distribution uses secure, trusted channels to deliver public certificates. |
| 99 | Revocation of Public Keys – Invalidate certificates that are no longer valid. | CRL, OCSP, Certificate Management Tools | Revocation lists and real-time checks stop use of invalid keys. |
| 100 | Confidentiality of Cryptographic Keys – Protect secrets from unauthorized access. | CyberArk, Key Vault, Secrets Manager | Secrets are encrypted, monitored, and restricted with strict IAM and vaulting policies. |
| # | Control Title/Description | Tools | Justification |
|----|---------------------------|--------|---------------|
| 101 | Integrity of Cryptographic Keys – Ensure keys are not altered or substituted. | Key Vaults, HSMs, CyberArk | Hardware-backed key storage enforces integrity and prevents tampering through controlled generation and access. |
| 102 | Availability of Cryptographic Keys – Ensure keys are available when needed. | Key Redundancy, Vault Replication | Keys are highly available through cloud-native resilience and fault-tolerant key vaults. |
| 103 | Confidentiality of Non-Cryptographic Information – Restrict access to sensitive metadata. | IAM Policies, Tags, Access Control Lists | Non-crypto-sensitive metadata (e.g., config, env vars) is scoped through identity-based access control. |
| 104 | Integrity of Non-Cryptographic Information – Prevent tampering of supporting data. | Hashing, Audit Trails | Supporting system configuration is version-controlled, hashed, and audited. |
| 105 | Availability of Non-Cryptographic Information – Ensure supporting info is not lost. | Config Backup, GitOps, Replicated Metadata Stores | Configuration data is backed up and replicated across zones or source-controlled repositories. |
| 106 | Confidentiality of System Configuration – Restrict who can view system config. | RBAC, Entra ID, AWS IAM Policies | Only privileged roles can view sensitive system configuration details. |
| 107 | Integrity of System Configuration – Ensure config files are not altered. | Config Drift Detection (AWS Config, Azure Policy), Source Control | Config is monitored and enforced through continuous compliance scanning. |
| 108 | Availability of System Configuration – Maintain system config during disruptions. | Git Backup, IaC Modules, Version Control | IaC stores configurations to be reapplied during system failure or re-provisioning. |
| 109 | Confidentiality of User Data – Protect PII and sensitive data. | Purview, Macie, DLP, Encryption | User data is encrypted, classified, and access-logged to meet privacy and regulatory requirements. |
| 110 | Integrity of User Data – Prevent data tampering. | Checksums, Secure APIs, Logging | Input validation, hashing, and tamper-evident logging protect user data. |
| 111 | Availability of User Data – Ensure user data is accessible during outages. | Backups, DR Strategies, Multi-Region Storage | Replication and failover ensure continued access to user-generated content. |
| 112 | Confidentiality of System Output – Prevent leakage of sensitive logs or debug info. | Log Redaction, Obfuscation, Role Filtering | Output is filtered to mask or exclude sensitive data fields. |
| 113 | Integrity of System Output – Ensure outputs are trustworthy and unmodified. | Secure Logging, Validation Layers | Logs and outputs are hash-verified or immutably stored to detect unauthorized changes. |
| 114 | Availability of System Output – Preserve output availability. | Log Archival, SIEM, Redundant Export | Logs and results are stored across high-availability systems and accessible for audit. |
| 115 | Confidentiality of System Logs – Restrict access to logs. | Log Access Policies, Encryption | Logs are encrypted and scoped to specific SOC or audit roles. |
| 116 | Integrity of System Logs – Protect logs from tampering. | Immutable Storage, S3 Object Lock | Logs are written-once-read-many (WORM) to prevent alteration. |
| 117 | Availability of System Logs – Ensure access to logs for investigation. | Cold Storage, Long-Term Retention | Logs are retained for compliance periods and replicated across tiers. |
| 118 | Confidentiality of Security Attributes – Restrict who can view RBAC/ABAC tags. | Tag Policies, IAM, Azure Purview | Security attributes tied to classification or access control are protected from general visibility. |
| 119 | Integrity of Security Attributes – Prevent unauthorized changes to access metadata. | Tag Locking, Approval Workflows | Tags and attributes driving access control are governed via policy and audit workflows. |
| 120 | Availability of Security Attributes – Ensure access classification is consistently available. | Replicated Metadata Stores | ABAC tags and security labels are replicated and version-controlled. |
| 121 | Confidentiality of Security Policy – Limit access to security control configurations. | Git Repos with IAM, Role Restrictions | Security controls and rule sets are restricted to authorized roles and encrypted in transit. |
| 122 | Integrity of Security Policy – Protect from unauthorized changes. | Change Review Workflows, Merge Approval | Security policies are version-controlled and require approval for changes. |
| 123 | Availability of Security Policy – Ensure policy is enforced during failure. | Policy Replication, Edge Caching | Policy engines are resilient and can apply enforcement even during controller outages. |
| 124 | Confidentiality of System Documentation – Protect architecture diagrams, SOPs. | SharePoint with RBAC, Confluence, Rights Management | Documents are encrypted and access controlled to relevant personnel. |
| 125 | Integrity of System Documentation – Protect against document tampering. | Version Control, SharePoint Revision Logs | Documents are versioned and locked down with access logs. |
| 126 | Availability of System Documentation – Ensure documentation is accessible. | Geo-Redundant Storage, Backup, Search Indexing | Docs are hosted with multi-zone redundancy for high availability. |
| 127 | Confidentiality of Metadata – Secure sensitive metadata from exposure. | Metadata Encryption, IAM Restrictions | Metadata that might reveal system patterns or sensitive insights is restricted. |
| 128 | Integrity of Metadata – Prevent unauthorized modifications. | Audit Trails, Config Monitoring | Metadata changes are logged and flagged if deviating from expected baselines. |
| 129 | Availability of Metadata – Ensure metadata is accessible for operations. | Replicated Metadata Stores, Caching | Metadata is stored and accessible in multiple locations. |
| 130 | Confidentiality of Audit Logs – Restrict access to audit trails. | S3 Bucket Policies, Role Segmentation | Audit logs are encrypted and accessible only to audit/compliance roles. |
| 131 | Integrity of Audit Logs – Prevent unauthorized modification. | Immutable Logs, Signed Entries | WORM storage and hash-based signing preserve audit log integrity. |
| 132 | Availability of Audit Logs – Retain logs for forensic analysis. | Tiered Retention Policies | Logs are archived in cold storage for compliance and investigation needs. |
| 133 | Confidentiality of Operational Data – Secure telemetry, monitoring, and flow data. | Log Encryption, Flow Log Restriction | Monitoring data is protected to avoid lateral movement or leak risks. |
| 134 | Integrity of Operational Data – Protect against tampering of metrics or events. | Signed Logs, Alerts for Anomalies | Systems verify telemetry and detect anomalies or missing metrics. |
| 135 | Availability of Operational Data – Maintain continuous access to monitoring data. | SIEM Redundancy, Alerting SLA | Monitoring platforms are resilient and alerts operate even during ingestion issues. |
| 136 | Confidentiality of Software – Protect proprietary software and source. | Code Repository Access Controls | Source code is stored in private repos with RBAC and monitored for exfiltration. |
| 137 | Integrity of Software – Ensure deployed code is not modified. | Code Signing, CI/CD Pipeline Integrity Checks | Software is signed and validated before execution or deployment. |
| 138 | Availability of Software – Ensure software services are resilient. | Auto Scaling, Multi-Zone Deployment | App services are deployed redundantly to ensure uptime. |
| 139 | Confidentiality of Firmware – Prevent unauthorized disclosure of firmware. | Vendor Encryption, Firmware Signing | Firmware is signed and encrypted to prevent tampering or reverse engineering. |
| 140 | Integrity of Firmware – Validate firmware authenticity and integrity. | Secure Boot, TPM Validation | Devices verify firmware hashes and signatures before boot. |
| 141 | Availability of Firmware – Ensure firmware can be recovered during failure. | Backup Firmware Images | Devices retain fallback firmware or cloud provisioning options. |
| 142 | Confidentiality of BIOS/UEFI – Protect firmware config from unauthorized access. | BIOS Passwords, Physical Lockdown | Admin access to BIOS is password-protected or physically restricted. |
| 143 | Integrity of BIOS/UEFI – Detect unauthorized BIOS changes. | Secure Boot, BIOS Checksums | BIOS is verified at boot against known-good signatures. |
| 144 | Availability of BIOS/UEFI – Ensure recovery from failed firmware update. | Dual BIOS, Rollback Capabilities | Hardware supports fallback images in case of corrupted primary BIOS. |
| 145 | Confidentiality of Platform Configuration – Secure system-level settings. | GPO, Azure Policy, AWS SSM | System settings are enforced and restricted via platform configuration controls. |
| 146 | Integrity of Platform Configuration – Enforce authorized baseline. | CIS Scans, AWS Config Rules | Deviations are flagged and corrected automatically or manually. |
| 147 | Availability of Platform Configuration – Ensure baseline configs are recoverable. | IaC Templates, Versioned Config Storage | Platforms can be rehydrated with pre-approved config sets. |
| 148 | Confidentiality of Boot Process – Prevent unauthorized boot interception. | Secure Boot, BitLocker Preboot | Bootloaders and drives are protected via integrity and encryption checks. |
| 149 | Integrity of Boot Process – Validate boot chain. | TPM, Secure Boot Chains | Firmware, bootloader, OS kernel are verified with signed checks. |
| 150 | Availability of Boot Process – Ensure successful system boot. | Resilient Firmware, Redundant OS Partitions | Boot partitions are protected or redundant to reduce failures. |
| 151 | Confidentiality of Runtime State – Protect system memory and processes. | ASLR, Memory Encryption, Container Isolation | Memory contents are obfuscated and isolated during runtime. |
| 152 | Integrity of Runtime State – Detect unauthorized changes in memory. | Runtime Protection, EDR | Tools monitor for memory injection or runtime tampering. |
| 153 | Availability of Runtime State – Ensure continued system operation. | Watchdog Timers, Auto-Heal Services | Systems auto-recover or alert on degraded states. |
| 154 | Confidentiality of Applications – Protect app components from unauthorized access. | AppArmor, Container Runtime Controls | Apps are sandboxed and runtime permissions scoped. |
| 155 | Integrity of Applications – Detect tampered app code. | Binary Signing, Container Image Scanning | Applications are signed and validated pre- and post-deployment. |
| 156 | Availability of Applications – Ensure app resilience. | Load Balancers, Auto Scale | Apps auto-scale and use HA endpoints to remain available. |
| 157 | Test Case: Placeholder Row | None | Example row with no tool mapping — left blank for testing or row indexing. |

