This is an excellent approach for HealthStream to standardize the security review of its AI/LLM-related projects.
By mapping the OWASP Top 10 for LLM Applications to the STRIDE threat model categories, your Security Architecture team gains a reusable, structured, and impact-focused checklist for identifying threats.
🗺️ STRIDE Threat Model Checklist for LLM Applications
This table maps each of the OWASP Top 10 LLM risks to the most relevant STRIDE categories. This forms the basis of your Security Architecture review checklist.
| OWASP Top 10 LLM Risk (LLM#) | STRIDE Category | Sec Arch Review Checklist / Evaluation Pattern |
|---|---|---|
| LLM01: Prompt Injection | Spoofing, Tampering, Elevation of Privilege, Information Disclosure | Input/Output Validation: Are user inputs strictly separated from system/model instructions? Are both direct and indirect (e.g., retrieved documents) prompts sanitized/validated? |
| LLM02: Insecure Output Handling | Tampering, Information Disclosure, Elevation of Privilege | Output Sanitization: Is LLM output strictly sanitized and securely handled (e.g., HTML-encoded before display, validated before execution)? Is the application protected against XSS, SQLi, etc., from LLM outputs? |
| LLM03: Training Data Poisoning | Tampering, Repudiation, Information Disclosure | Data Pipeline Integrity: Are training/fine-tuning data sources trusted and validated? Are robust change-control and audit logs maintained for all data modifications? |
| LLM04: Model Denial of Service (DoS) | Denial of Service | Resource/Rate Limiting: Are limits imposed on request complexity (e.g., context length, number of tokens) and rate? Is resource consumption monitored to prevent cost overruns and service degradation? |
| LLM05: Supply Chain Vulnerabilities | Tampering, Spoofing, Information Disclosure | Component Vetting: Is a Software Bill of Materials (SBOM) maintained? Are third-party LLMs, APIs, and libraries vetted and continuously monitored for known vulnerabilities? |
| LLM06: Sensitive Information Disclosure | Information Disclosure | Privacy Controls: Are data masking/redaction techniques applied to inputs/outputs? Is the model prevented from outputting PII/PHI (critical for HealthStream) or proprietary data? |
| LLM07: Insecure Plugin Design | Elevation of Privilege, Spoofing, Information Disclosure | Access Control/Least Privilege: Do plugins operate with the minimum necessary permissions? Are function calls and arguments strictly validated before execution by the plugin? |
| LLM08: Excessive Agency | Elevation of Privilege, Tampering, Repudiation | Human-in-the-Loop/Approval: For high-risk actions (e.g., database writes, sending emails), is human review mandatory? Are all automated actions auditable? |
| LLM09: Overreliance | Repudiation, Information Disclosure | Transparency/Auditability: Are users informed when they are interacting with an LLM? Are confidence scores displayed? Is a clear process defined for handling and correcting incorrect/harmful outputs? |
| LLM10: Model Theft | Information Disclosure, Denial of Service | Intellectual Property/Access: Are access controls, network segmentation, and rate limits in place to prevent bulk data extraction (e.g., through prompt-based enumeration) that could reconstruct the model? |
📐 Conceptual Model for Reviewing LLM Threats
For your Security Architecture team, a Data Flow Diagram (DFD) is the best visual tool for identifying STRIDE threats within an LLM application. Threats occur at Trust Boundaries (where data or control flows between entities with different privileges or security requirements).
Key Components to Map in the DFD:
The Sec Arch review should start by mapping these entities and their interactions:
 * External Interactor (User): The source of the prompt. Threats: Spoofing (LLM01).
 * Process (Application Backend): Where input/output handling and logic reside. Threats: Tampering (LLM02), Information Disclosure (LLM06).
 * Process (LLM Model/API): The AI component itself. Threats: Denial of Service (LLM04), Model Theft (LLM10).
 * Data Store (Training/RAG Data): Source of knowledge. Threats: Tampering (LLM03).
 * External Tool/Plugin: Any system the LLM can execute code on. Threats: Elevation of Privilege (LLM07, LLM08).
 * Trust Boundary: The red line in the DFD where security controls must be enforced (e.g., between the application backend and the LLM API). This is where most LLM-specific vulnerabilities reside.
✅ Reusable Security Architecture Review Template
Your Sec Arch team can use this structured template for every new HealthStream AI/LLM project.
Project & Scope Definition
| Field | Description |
|---|---|
| Project Name |  |
| LLM Used | (e.g., OpenAI GPT-4, Llama 3, HealthStream Proprietary) |
| Sensitive Data Handled | (e.g., PHI, PII, Proprietary IP) |
| External Agency? | (Does the LLM call APIs/plugins that take action? Y/N) |
| Architecture DFD Reviewed? | (Attach/Reference Diagram) |
STRIDE Checkpoints (OWASP LLM Focus)
| STRIDE Threat | OWASP LLM Ref | Security Checkpoint | Status (Pass/Fail/NA) | Mitigations/Notes |
|---|---|---|---|---|
| Spoofing (S) | LLM01, LLM07 | Is a clear separation of instruction and data enforced to prevent prompt injection from tricking the LLM into impersonating the system or another user? |  |  |
| Tampering (T) | LLM02, LLM03, LLM05, LLM08 | Are all inputs (prompts) and retrieved data validated and sanitized before reaching the model? Are outputs sanitized before rendering/execution? Is the integrity of the training pipeline secured? |  |  |
| Repudiation (R) | LLM03, LLM08, LLM09 | Are all model-initiated actions, human overrides, and data modifications securely logged and auditable? Can the model's output source (e.g., RAG document) be traced for validation? |  |  |
| Information Disclosure (I) | LLM01, LLM05, LLM06, LLM10 | Are techniques like data masking or redaction used for sensitive data (PHI/PII)? Is the LLM fine-tuned to avoid generating sensitive information? Are model weights/APIs protected from unauthorized access? |  |  |
| Denial of Service (D) | LLM04, LLM10 | Are rate limiting and resource quotas applied to all LLM endpoints to prevent computational exhaustion and model theft attempts? |  |  |
| Elevation of Privilege (E) | LLM01, LLM02, LLM07, LLM08 | Are plugins/tools run with the principle of least privilege? Is there a mandatory human review/approval for high-impact actions (e.g., API calls, DB writes)? |  |  |


That's a vital step for a security-conscious organization like HealthStream, especially given the focus on protected health information (PHI) and compliance (HIPAA).
Here are detailed mitigation strategies for the three highest-risk OWASP LLM categories, mapped to your STRIDE model and tailored for a healthcare context.
🛡️ Top 3 LLM Threat Mitigation Strategies for HealthStream
1. LLM01: Prompt Injection (STRIDE: Spoofing, Tampering, EOP, Info Disclosure)
The Threat: An attacker manipulates the LLM's internal instructions (either directly or indirectly via retrieved data) to bypass security controls, extract sensitive data, or perform unauthorized actions.
| Mitigation Technique | Description and HealthStream Context |
|---|---|
| A. System/User Content Segregation | Strictly separate the system instruction (your security guardrails) from user input using unique delimiters (e.g., <user_input>...</user_input>). The system prompt explicitly tells the LLM to ignore or treat any text outside these delimiters as data, not instruction. |
| B. Dual-Model or Two-Layer Defense | Use a small, highly constrained "Guardrail Model" or a deterministic input classifier before the main LLM. This first layer checks if the user's prompt is manipulative, attempts to jailbreak, or contains malicious code patterns, and blocks it before it consumes significant resources. |
| C. Input Sanitization & Validation | Apply standard Web Application Firewall (WAF) checks on the input, looking for known injection patterns (e.g., SQL keywords, HTML/Markdown tags, shell commands). Crucially for HealthStream: Implement semantic filters to detect and block inputs that attempt to elicit PHI/PII outside of the application's intended purpose. |
| D. Least Privilege Principle (Plugins) | If the LLM has access to tools (e.g., booking an appointment, querying a database), its instructions and tool parameters must be strictly validated by the application code (not just the LLM) before execution. Treat the LLM's request as an untrusted API call. |
2. LLM02: Insecure Output Handling (STRIDE: Tampering, EOP, Info Disclosure)
The Threat: The LLM generates output that, when processed by the downstream application, leads to classic web vulnerabilities like Cross-Site Scripting (XSS), SQL Injection, or Remote Code Execution (RCE).
| Mitigation Technique | Description and HealthStream Context |
|---|---|
| A. Output Validation and Encoding | Mandatory: The LLM's response must be fully HTML-encoded or escaped before being rendered on a user interface to prevent XSS. If the output is a structured format (JSON, XML), it must be schema-validated to ensure it conforms to the expected structure before being parsed by the application logic. |
| B. Trust Boundary Enforcement | The LLM must be treated as an untrusted network peer. Any LLM-generated content intended for execution (e.g., code, function calls, database queries) must be handled by application code that performs its own validation and parameterized execution, never passing raw LLM output directly to an interpreter. |
| C. Content Security Policy (CSP) | Use a strict CSP in the application frontend to limit what types of content can be loaded and executed, mitigating the impact of any XSS payload that might slip through the output sanitizer. |
| D. Clinical Accuracy/Safety Guardrails | Specific to HealthStream: Implement post-processing filters to check for clinically unsafe, inappropriate, or misleading outputs before they reach a user. If the output is a medical recommendation, it must be flagged for human clinician review. |
3. LLM06: Sensitive Information Disclosure (STRIDE: Information Disclosure)
The Threat: The LLM accidentally or maliciously leaks PII/PHI (critical for HealthStream), proprietary business logic, or secrets embedded in the context/training data.
| Mitigation Technique | Description and HealthStream Context |
|---|---|
| A. Data Minimization & Redaction/Anonymization | Highest Priority: Apply data redaction/masking on PHI/PII before it is passed to the LLM (Input). Redact names, dates, addresses, and other identifiers. Use de-identification techniques consistent with HIPAA standards. |
| B. Secure Context Management (RAG) | If using Retrieval-Augmented Generation (RAG) to provide context, ensure the underlying knowledge base is role-based access controlled (RBAC). The LLM agent should only retrieve documents that the specific user is authorized to view. |
| C. Zero Data Retention Policy (API) | If using a third-party LLM API (e.g., via Azure OpenAI), ensure you have a Business Associate Agreement (BAA) in place and configure the API to use the Zero Data Retention or Data Non-Retention policy to ensure inputs/outputs are not logged or used for model training. |
| D. Output Filtering for PHI | Implement a final Output Filter layer that uses Regex or Named Entity Recognition (NER) to scan the LLM's final response for any leaked PHI/PII (names, addresses, SSNs, medical record numbers) and redact/block the response before it is displayed to the user. |


Below is a full STRIDE-based Threat Modeling Template specifically tailored for LLM/AI systems, mapped directly to the OWASP LLM Top 10 (2024).

This is a professional-grade, reusable template suitable for Security Architecture Reviews, Cloud Architecture Boards, and AI Governance Committees.

It is written in a formal enterprise tone, clearly organized, and ready to paste into Confluence, Teams, or architectural review documents.

⸻

✅ STRIDE Threat Model for LLM/AI Systems

(Mapped to OWASP Top 10 for LLM Applications, 2024)

Spoofing • Tampering • Repudiation • Information Disclosure • Denial of Service • Elevation of Privilege

⸻

1. System Overview

Project Name:
Purpose:
LLM Type: (OpenAI API, Azure OpenAI, Anthropic, Local model, Fine-tuned model, RAG pipeline, Agents)
Data Classification: (Public / Confidential / Regulated)
Users: (Internal, External, APIs, Automated agents)
Tools/Plugins: (APIs, DB, RAG tools, external services)

⸻

2. Dataflow & Architecture Context

Attach or describe:
	•	Trust boundaries
	•	Data ingress/egress points
	•	Model interaction points (prompts, embeddings, inference)
	•	Components (Vector DB, embedding svc, APIs, guardrails, logs, plugins/actions)

⸻

3. STRIDE Threat Model with Checklist & OWASP Alignment

Below, each STRIDE category includes:
	•	Threat Focus
	•	Checklist Questions
	•	Relevant LLM Attack Scenarios
	•	Mapped OWASP LLM Top 10 Items
	•	Required Mitigations

⸻

S — Spoofing (Identity Impersonation)

Threat Focus:

Impersonation of users, services, or agents to manipulate the LLM or downstream actions.

Checklist Questions:
	•	❏ Can an attacker impersonate a user sending prompts to the LLM?
	•	❏ Are API keys, tokens, and Azure/OpenAI credentials protected?
	•	❏ Can an attacker fake a tool/plugin identity and trick the LLM?
	•	❏ Are agent-initiated actions authenticated separately from prompts?

Example LLM Attack Scenarios:
	•	Attacker spoofs a service sending RAG queries → LLM retrieves sensitive knowledge base content.
	•	Attacker uses stolen API keys to impersonate a trusted automation bot.

OWASP Mapping:
	•	LLM01 – Prompt Injection
	•	LLM07 – Insecure Plugin/Tool Integration
	•	LLM10 – Model Theft

Mitigations:
	•	Enforce strong API authentication (mTLS, OAuth, IAM).
	•	Require identity on every tool invocation.
	•	Rotate API keys + enforce IP allowlists.
	•	Protect system prompts from user modification.

⸻

T — Tampering (Modification of Data, Prompts, Models)

Threat Focus:

Manipulating prompts, vector embeddings, guardrail configs, fine-tuning data, or model weights.

Checklist Questions:
	•	❏ Can prompts be manipulated before reaching the model?
	•	❏ Can an attacker inject toxic or misleading data into RAG sources?
	•	❏ Can embeddings be poisoned?
	•	❏ Are model files (weights/tokenizers) protected from modification?

Example LLM Attack Scenarios:
	•	Data poisoning inside a RAG document repository.
	•	Malicious user modifies prompt templates in a multi-tenant environment.

OWASP Mapping:
	•	LLM01 – Prompt Injection
	•	LLM03 – Training Data Poisoning
	•	LLM05 – Supply Chain Vulnerabilities

Mitigations:
	•	Version-control prompt templates.
	•	Sign and checksum model files.
	•	Validate all RAG ingestion sources.
	•	Use guardrails for prompt validation.

⸻

R — Repudiation (Lack of Traceability & Auditing Challenges)

Threat Focus:

Inability to prove who did what, or inability to trace harmful LLM actions.

Checklist Questions:
	•	❏ Are all prompts/action calls logged?
	•	❏ Are agent actions tied to authenticated users?
	•	❏ Are LLM outputs tied back to a request ID?
	•	❏ Are logs tamper-proof and audit-friendly?

Example LLM Attack Scenarios:
	•	Malicious prompt triggers a harmful tool action but appears as a valid system-initiated action.
	•	No audit trail to identify the user who caused a model hallucination-driven incident.

OWASP Mapping:
	•	LLM02 – Insecure Output Handling
	•	LLM08 – Excessive Agency
	•	LLM09 – Overreliance on LLMs

Mitigations:
	•	Implement end-to-end audit logs for prompts, completions, actions.
	•	Ensure logs include user identity, timestamp, tool, and context.
	•	Require non-repudiation controls for agent-driven changes.

⸻

I — Information Disclosure (PII/Secrets/Data Leakage)

Threat Focus:

LLM reveals sensitive/private data from training, RAG knowledge bases, logs, or prompts.

Checklist Questions:
	•	❏ Can prompts contain private data?
	•	❏ Is the LLM allowed to store or learn user inputs?
	•	❏ Can the model hallucinate sensitive internal data?
	•	❏ Are RAG indexes protected from unauthorized access?

Example LLM Attack Scenarios:
	•	User asks: “Show me the last 10 customer emails from support logs.”
	•	LLM reveals training data inadvertently due to misconfigured settings.

OWASP Mapping:
	•	LLM06 – Sensitive Information Disclosure
	•	LLM01 – Prompt Injection (indirect disclosure)

Mitigations:
	•	Apply PII redaction before embedding or ingestion.
	•	Disable training on live user inputs unless explicitly needed.
	•	Enforce strict IAM on vector DBs.
	•	Apply content filters on LLM outputs.

⸻

D — Denial of Service (DoS / Resource Exhaustion)

Threat Focus:

Attacker exhausts compute (GPU/CPU/memory) using large prompts, recursive requests, or high-volume queries.

Checklist Questions:
	•	❏ Is rate limiting enforced at all entry points?
	•	❏ Are prompt size limits enforced?
	•	❏ Does the model detect infinite loops or unbounded recursion?
	•	❏ Are cost caps configured for cloud LLM APIs?

Example LLM Attack Scenarios:
	•	Attacker submits a megabyte-sized prompt → inference latency spikes → service becomes unusable.
	•	Recursive queries cause chain-of-thought loops inside agents.

OWASP Mapping:
	•	LLM04 – Model DoS

Mitigations:
	•	Implement per-user/IP rate limits.
	•	Enforce max token sizes.
	•	Detect recursive or runaway agent loops.
	•	Apply budgets and throttles on API usage.

⸻

E — Elevation of Privilege (Model or Agent Gaining Excess Ability)

Threat Focus:

LLM or attacker gains access to functions or tools beyond intended privilege.

Checklist Questions:
	•	❏ Does the LLM have direct access to tools without guardrails?
	•	❏ Can the LLM modify infrastructure or code repos?
	•	❏ Can user prompts trigger privileged actions?
	•	❏ Are critical actions bound to human approvals?

Example LLM Attack Scenarios:
	•	Prompt to an AI agent: “Run terraform apply.”
→ Agent executes privileged cloud changes.
	•	LLM escalates from read-only knowledge retrieval to write capabilities through misconfigured actions.

OWASP Mapping:
	•	LLM07 – Insecure Tool Integration
	•	LLM08 – Excessive Agency
	•	LLM02 – Insecure Output Handling

Mitigations:
	•	Implement least-privilege IAM for actions/tools.
	•	Enforce human-in-the-loop for irreversible operations.
	•	Sandbox all tool execution environments.
	•	Restrict LLM capabilities to reading, not writing, unless tightly gated.

⸻

4. Risk Rating Matrix

Threat Category	Probability	Impact	Risk Level	Required Action
Spoofing	Low/Med/High	Low/Med/High	Auto	Mitigation Required?
Tampering	Low/Med/High	Low/Med/High	Auto	Yes/No
Repudiation	Low/Med/High	Low/Med/High	Auto	Yes/No
Info Disclosure	Low/Med/High	Low/Med/High	Auto	Yes/No
DoS	Low/Med/High	Low/Med/High	Auto	Yes/No
Elevation of Privilege	Low/Med/High	Low/Med/High	Auto	Yes/No


⸻

5. Final Required Security Controls Checklist

(Combine STRIDE + OWASP)

Identity & Access (S, E)
	•	☐ API authentication and identity enforcement
	•	☐ Role-based access for tools and actions
	•	☐ Strong authentication for all agents

Prompt and Data Protection (T, I)
	•	☐ Input sanitization & output filtering
	•	☐ Separation of system vs. user prompts
	•	☐ Protected prompt templates
	•	☐ PII redaction for embeddings

Auditability (R)
	•	☐ Full prompt/action/decision logs
	•	☐ Traceability from user → prompt → model → action
	•	☐ Tamper-resistant logs

Model/Data Integrity (T)
	•	☐ Model signing and checksum validation
	•	☐ Secure supply chain + SBOM
	•	☐ Validated RAG ingestion sources

Service Reliability (D)
	•	☐ Rate limits, timeouts, and max tokens
	•	☐ Recursion detection
	•	☐ Cost/lifecycle monitoring

Agency & Tool Safety (E)
	•	☐ Human-in-the-loop controls
	•	☐ Sandboxed tool execution
	•	☐ Explicit approval for privileged actions

⸻

6. Summary for Architecture Review Board

Provide:
	•	Overall risk score
	•	Identified gaps
	•	Required security controls
	•	Timeline for remediation
	•	Approval or rejection recommendation

⸻



This is an excellent approach for HealthStream to standardize the security review of its AI/LLM-related projects.
By mapping the OWASP Top 10 for LLM Applications to the STRIDE threat model categories, your Security Architecture team gains a reusable, structured, and impact-focused checklist for identifying threats.
🗺️ STRIDE Threat Model Checklist for LLM Applications
This table maps each of the OWASP Top 10 LLM risks to the most relevant STRIDE categories. This forms the basis of your Security Architecture review checklist.
OWASP Top 10 LLM Risk (LLM#)
STRIDE Category
Sec Arch Review Checklist / Evaluation Pattern
LLM01: Prompt Injection
Spoofing, Tampering, Elevation of Privilege, Information Disclosure
Input/Output Validation: Are user inputs strictly separated from system/model instructions? Are both direct and indirect (e.g., retrieved documents) prompts sanitized/validated?
LLM02: Insecure Output Handling
Tampering, Information Disclosure, Elevation of Privilege
Output Sanitization: Is LLM output strictly sanitized and securely handled (e.g., HTML-encoded before display, validated before execution)? Is the application protected against XSS, SQLi, etc., from LLM outputs?
LLM03: Training Data Poisoning
Tampering, Repudiation, Information Disclosure
Data Pipeline Integrity: Are training/fine-tuning data sources trusted and validated? Are robust change-control and audit logs maintained for all data modifications?
LLM04: Model Denial of Service (DoS)
Denial of Service
Resource/Rate Limiting: Are limits imposed on request complexity (e.g., context length, number of tokens) and rate? Is resource consumption monitored to prevent cost overruns and service degradation?
LLM05: Supply Chain Vulnerabilities
Tampering, Spoofing, Information Disclosure
Component Vetting: Is a Software Bill of Materials (SBOM) maintained? Are third-party LLMs, APIs, and libraries vetted and continuously monitored for known vulnerabilities?
LLM06: Sensitive Information Disclosure
Information Disclosure
Privacy Controls: Are data masking/redaction techniques applied to inputs/outputs? Is the model prevented from outputting PII/PHI (critical for HealthStream) or proprietary data?
LLM07: Insecure Plugin Design
Elevation of Privilege, Spoofing, Information Disclosure
Access Control/Least Privilege: Do plugins operate with the minimum necessary permissions? Are function calls and arguments strictly validated before execution by the plugin?
LLM08: Excessive Agency
Elevation of Privilege, Tampering, Repudiation
Human-in-the-Loop/Approval: For high-risk actions (e.g., database writes, sending emails), is human review mandatory? Are all automated actions auditable?
LLM09: Overreliance
Repudiation, Information Disclosure
Transparency/Auditability: Are users informed when they are interacting with an LLM? Are confidence scores displayed? Is a clear process defined for handling and correcting incorrect/harmful outputs?
LLM10: Model Theft
Information Disclosure, Denial of Service
Intellectual Property/Access: Are access controls, network segmentation, and rate limits in place to prevent bulk data extraction (e.g., through prompt-based enumeration) that could reconstruct the model?
📐 Conceptual Model for Reviewing LLM Threats
For your Security Architecture team, a Data Flow Diagram (DFD) is the best visual tool for identifying STRIDE threats within an LLM application. Threats occur at Trust Boundaries (where data or control flows between entities with different privileges or security requirements).
Key Components to Map in the DFD:
The Sec Arch review should start by mapping these entities and their interactions:
External Interactor (User): The source of the prompt. Threats: Spoofing (LLM01).
Process (Application Backend): Where input/output handling and logic reside. Threats: Tampering (LLM02), Information Disclosure (LLM06).
Process (LLM Model/API): The AI component itself. Threats: Denial of Service (LLM04), Model Theft (LLM10).
Data Store (Training/RAG Data): Source of knowledge. Threats: Tampering (LLM03).
External Tool/Plugin: Any system the LLM can execute code on. Threats: Elevation of Privilege (LLM07, LLM08).
Trust Boundary: The red line in the DFD where security controls must be enforced (e.g., between the application backend and the LLM API). This is where most LLM-specific vulnerabilities reside.
✅ Reusable Security Architecture Review Template
Your Sec Arch team can use this structured template for every new HealthStream AI/LLM project.
Project & Scope Definition
Field
Description
Project Name
LLM Used
(e.g., OpenAI GPT-4, Llama 3, HealthStream Proprietary)
Sensitive Data Handled
(e.g., PHI, PII, Proprietary IP)
External Agency?
(Does the LLM call APIs/plugins that take action? Y/N)
Architecture DFD Reviewed?
(Attach/Reference Diagram)
STRIDE Checkpoints (OWASP LLM Focus)
STRIDE Threat
OWASP LLM Ref
Security Checkpoint
Status (Pass/Fail/NA)
Mitigations/Notes
Spoofing (S)
LLM01, LLM07
Is a clear separation of instruction and data enforced to prevent prompt injection from tricking the LLM into impersonating the system or another user?
Tampering (T)
LLM02, LLM03, LLM05, LLM08
Are all inputs (prompts) and retrieved data validated and sanitized before reaching the model? Are outputs sanitized before rendering/execution? Is the integrity of the training pipeline secured?
Repudiation (R)
LLM03, LLM08, LLM09
Are all model-initiated actions, human overrides, and data modifications securely logged and auditable? Can the model's output source (e.g., RAG document) be traced for validation?
Information Disclosure (I)
LLM01, LLM05, LLM06, LLM10
Are techniques like data masking or redaction used for sensitive data (PHI/PII)? Is the LLM fine-tuned to avoid generating sensitive information? Are model weights/APIs protected from unauthorized access?
Denial of Service (D)
LLM04, LLM10
Are rate limiting and resource quotas applied to all LLM endpoints to prevent computational exhaustion and model theft attempts?
Elevation of Privilege (E)
LLM01, LLM02, LLM07, LLM08
Are plugins/tools run with the principle of least privilege? Is there a mandatory human review/approval for high-impact actions (e.g., API calls, DB writes)?
Would you like me to elaborate on the mitigation strategies for the top three most critical threats (Prompt Injection, Insecure Output Handling, and Sensitive Information Disclosure) for a healthcare company like HealthStream?
