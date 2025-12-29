Understood. The correct pattern for a single centralized playbook that works for all Sentinel analytics rules is:
	1.	Trigger on any Sentinel alert (or incident)
	2.	Read the alert’s metadata (display name, severity, entities, analytics rule name)
	3.	Pull the query results for that specific alert in a generic way
	4.	Render to a consistent HTML template
	5.	Send email

The key design decision is how you fetch the “Related events / Query results” generically across all rules.

There are two practical portal-only options.

⸻

Option 1 (Recommended): Use the alert’s “related events” records instead of re-running KQL

This is the most universal approach because it does not require knowing each rule’s KQL or table schema.

Why it works

When Sentinel generates an alert, it also writes alert context into Sentinel tables (AlertEvidence / SecurityAlert / related records depending on connector and schema). You can query those tables by SystemAlertId and pull the evidence/related events that Sentinel already tied to the alert.

High-level flow
	•	Trigger: “When a response to an Azure Sentinel alert is triggered”
	•	Extract: SystemAlertId (or Alert id)
	•	Query Log Analytics: fetch related records using that id
	•	Build HTML table
	•	Email

Step-by-step (Portal)

1) Create ONE playbook and attach it globally
	1.	Sentinel → Automation
	2.	Automation rules → Create
	3.	Trigger: When alert is created (or incident created)
	4.	Condition: (optional) severity, product, etc.
	5.	Action: Run playbook
	6.	Select your centralized playbook
	7.	Save

Now every alert triggers the same playbook.

2) Logic App: Use alert ID as correlation key
In the playbook designer:
	1.	Trigger: Microsoft Sentinel – When a response to an Azure Sentinel alert is triggered
	2.	Add Parse JSON (so you can reliably reference fields)
	3.	Add Compose called AlertId
	•	set it to the field that represents the alert identifier, typically:
	•	SystemAlertId (best if present)
	•	or the “Alert ID” shown in the alert blade

3) Query Sentinel tables for evidence/related events
Add Azure Monitor Logs – Run query and list results against the SAME workspace.

Use a query pattern like this (you will adjust slightly based on which tables your workspace uses; see validation steps below):

Candidate Query A (common):

SecurityAlert
| where SystemAlertId == "{ALERT_ID}"
| project TimeGenerated, AlertName, Severity, ProviderName, ProductName, Entities, ExtendedProperties

Candidate Query B (evidence-focused):

AlertEvidence
| where SystemAlertId == "{ALERT_ID}"
| project TimeGenerated, EntityType, EvidenceRole, EvidenceDirection, Evidence
| order by TimeGenerated desc

Then:
	•	“Select” to flatten fields
	•	“Create HTML table”
	•	Email

How to validate which table you have (portal-only)

In Sentinel → Logs, run these quick checks:
	1.	Do you have SecurityAlert?

SecurityAlert | take 5

	2.	Do you have AlertEvidence?

AlertEvidence | take 5

	3.	If not, check “ASIM / SecurityAlert” alternatives:

search in (*) "SystemAlertId"
| take 20

Once you confirm which table exists, your centralized playbook becomes stable.

Benefit: one logic works for all rules.
Tradeoff: you get “evidence/related” context, which may not be identical to the analytic rule’s raw result grid, but it’s often better for email.

⸻

Option 2: Re-run the analytic query dynamically (harder, but closest to Sentinel “Query results”)

This tries to reproduce the exact Related events → Query results output by re-running KQL—but generically.

There are two sub-approaches:

2A) Maintain one “email projection query” per rule (scalable with mapping)

You keep a small mapping table (key/value) of:
	•	AnalyticsRuleName → EmailQuery

Central playbook:
	•	Looks at AlertDisplayName / AnalyticsRuleId
	•	Finds the corresponding KQL snippet
	•	Runs it
	•	Produces the table

Benefit: very high fidelity (looks like the grid).
Tradeoff: you still manage a mapping as rules grow/ change.

2B) Attempt to extract the rule KQL from alert payload and run it

Sometimes Sentinel includes the query in ExtendedProperties or alert payload (you may have seen “Query: …” in your raw email JSON).

Benefit: no mapping table.
Tradeoff: not reliable across all rule types; payload fields differ; some queries are long; some rely on parameters.

⸻

What I recommend for your requirement

For “one playbook for many rules,” prioritize:

Recommended design

Central playbook runs for all alerts and always sends:
	1.	Alert summary (name, severity, time, workspace, MITRE, entities)
	2.	Evidence / Related entities table (universal)
	3.	Optional: “Top N related raw logs” if the rule is from a known family (e.g., AWS CloudTrail) using a generic query.

This gives you consistency across all alerts without brittle per-rule logic.

⸻

Concrete implementation: Central playbook template you can deploy now

A) Build one consistent email layout (HTML)

Email sections:
	1.	Header (Alert Display Name + Severity)
	2.	Key fields table (Alert ID, Analytics rule name, Start/End time, Incident link)
	3.	Entities summary (principal / IP / resource)
	4.	Evidence table (from AlertEvidence or SecurityAlert entities)
	5.	Footer (Sentinel links)

B) Centralized evidence query

Once you confirm table availability, you’ll use one of these stable queries:

If AlertEvidence exists:
	•	Use SystemAlertId join to AlertEvidence and render rows.

If only SecurityAlert exists:
	•	Use Entities and ExtendedProperties and render a simplified table.

⸻

Portal steps to attach this playbook to ALL analytics rules (cleanest)

Instead of attaching playbook per rule:
	1.	Sentinel → Automation → Automation rules
	2.	Create
	3.	Trigger: When alert is created
	4.	Conditions: (optional) e.g. exclude “Informational”, exclude test rules, etc.
	5.	Action: Run playbook
	6.	Pick the centralized playbook
	7.	Save

Now it’s centrally enforced and scalable.

⸻

One critical dependency you must confirm (so the “related events table” works)

In your workspace logs, confirm whether you have:
	•	AlertEvidence table
	•	and whether your alert payload includes SystemAlertId

If you answer these two (just “yes/no”):
	1.	Does AlertEvidence | take 5 return rows?
	2.	In the alert JSON, do you see SystemAlertId?

…then I will give you the exact KQL + exact Logic App “From” paths and Select mappings so your table renders correctly every time.

If you don’t want to check anything and want the best default:
	•	Implement the automation rule for all alerts
	•	In the playbook, run SecurityAlert query by SystemAlertId
	•	Render HTML table for Entities + ExtendedProperties
That will work in most Sentinel environments even when AlertEvidence is not present.
