That error is clear and expected:

“Self reference is not supported when updating the value of variable ‘AlertQuery’.”

In Logic Apps, you cannot Set variable AlertQuery = replace(AlertQuery, …) because that references itself in the same Set action. You must either:
	•	write the transformed value into a different variable, or
	•	avoid variables entirely and use a Compose step, or
	•	perform the replace directly where you use the query.

Below are the clean portal steps to fix it (choose one; I recommend Option A).

⸻

Option A (Recommended): Use Compose instead of “Set variable”

This is the simplest and most reliable.

A1) Keep your existing “Initialize variable AlertQuery” (optional)

You can keep it, but you won’t “Set variable” again.

A2) Add a Compose to “clean” the query
	1.	Under your Initialize variable AlertQuery, click + New step
	2.	Search Compose
	3.	Select Data Operations → Compose
	4.	Name it: AlertQuery_Clean
	5.	In Inputs, click Expression and paste:

replace(variables('AlertQuery'), '\n', ' ')

This converts the literal \n sequences to spaces (good enough for KQL execution).

If you want actual newlines instead of spaces, use spaces first. It avoids designer quirks and still runs fine.

A3) Use the Compose output in “Run query and list results V2”
	1.	Open your Azure Monitor Logs – Run query and list results V2 action
	2.	In the Query field, use:
	•	Dynamic content → Outputs from AlertQuery_Clean
	•	or Expression:

outputs('AlertQuery_Clean')

✅ This eliminates self-reference completely.

⸻

Option B: Use a second variable (if you prefer variables)

If you want to keep everything as variables:

B1) Initialize two variables
	1.	Initialize variable

	•	Name: AlertQueryRaw
	•	Type: String
	•	Value:

coalesce(body('Parse_JSON')?['ExtendedProperties']?['Query'], '')

	2.	Initialize variable

	•	Name: AlertQueryClean
	•	Type: String
	•	Value: leave blank for now (or set to empty string)

B2) Set the second variable from the first

Add Set variable:
	•	Name: AlertQueryClean
	•	Value (Expression):

replace(variables('AlertQueryRaw'), '\n', ' ')

Then in Run query and list results V2, set Query to:

variables('AlertQueryClean')

✅ No self reference.

⸻

Option C: No variables at all (fastest)

Skip variables completely and run this directly inside the query field:
	1.	Open Run query and list results V2
	2.	In Query, click Expression and paste:

replace(coalesce(body('Parse_JSON')?['ExtendedProperties']?['Query'], ''), '\n', ' ')

This is the most compact, but harder to troubleshoot later. Option A is cleaner operationally.

⸻

After fixing this, your pipeline should be:
	1.	Sentinel trigger
	2.	Parse JSON
	3.	Initialize variable AlertQuery (optional)
	4.	Compose AlertQuery_Clean ✅
	5.	Run query and list results V2 (using cleaned query) ✅
	6.	Select (From = value)
	7.	Create HTML table
	8.	Send email (embed HTML table)

⸻

Two quick sanity checks (avoid the next failure)

1) The extracted query must not be empty

Add a Condition before running logs query:

Condition expression:

greater(length(outputs('AlertQuery_Clean')), 0)

If false: send an email saying “No query found in alert payload”.

2) Ensure the query is valid KQL

Some alert payloads include extra quoting or escaped characters. If the logs action still fails, the next fix is to strip double quotes or decode JSON escaping—but don’t do that until you confirm the actual failure message from the run history.

⸻

If you paste the exact expression you currently put in your failing Set variable step, I can tell you which of the above options matches your current layout with the fewest edits.

%%%%%%%%%^^^^^^^


You are seeing the raw alert payload (SecurityAlert-style JSON). That payload contains the KQL query text and the query start/end time, but it does not include the row set (“Query results”) itself.

To email the AWS-specific rows (the same thing you see under Related events → Query results), you must do this in the playbook:
	1.	Extract the KQL query from the alert payload (it’s already in your JSON under ExtendedProperties)
	2.	Run that KQL again using Azure Monitor Logs – Run query and list results (V2)
	3.	Convert the returned value array to an HTML table
	4.	Insert that table into the email

Below is the portal-only, step-by-step implementation.

⸻

What in your raw JSON matters

In your screenshot, these are the fields you should leverage:
	•	ExtendedProperties → contains:
	•	Query  (this is the KQL used by the rule)
	•	Query Start Time UTC
	•	Query End Time UTC
	•	sometimes DataSources, Query Period, etc.

This Query is the exact logic that produces the AWS rows, such as:
	•	AWSCloudTrail table
	•	EventName == "CreateAccessKey"
	•	projections like UserIdentityPrincipalId, EventSource, etc.

⸻

Centralized Playbook Design (works for ALL rules)

You will not hardcode AWS logic per rule. Instead you will:
	•	Dynamically run whatever query the alert used
	•	Then email the result set (table)

This scales across your many analytics rules.

⸻

Step-by-step in Logic Apps Designer (Portal)

Step 1 — Parse the alert payload

You likely already have this, but ensure it exists:
	1.	Open the playbook → Logic app designer
	2.	After the Sentinel trigger, add:
	•	Data Operations → Parse JSON
	3.	Content: choose the trigger body/alert payload
	4.	Schema: generate from a sample (your raw JSON)

You need this so you can reference ExtendedProperties.Query.

⸻

Step 2 — Extract the alert query into a variable

We’ll store the alert’s KQL query text into a variable so we can run it.
	1.	+ New step
	2.	Search Initialize variable
	3.	Choose Variables → Initialize variable
	4.	Configure:
	•	Name: AlertQuery
	•	Type: String
	•	Value: click Expression and use:

coalesce(
  body('Parse_JSON')?['ExtendedProperties']?['Query'],
  body('Parse_JSON')?['ExtendedProperties']?['query'],
  ''
)

Why coalesce: some payloads differ slightly by casing/shape.

⸻

Step 3 — (Optional but recommended) Clean up the query text

Some Sentinel alert payloads store the query with escaped newlines (\n). The Logs action usually still runs it fine, but if it fails, this fixes it.
	1.	+ New step
	2.	Add Variables → Set variable
	3.	Set:
	•	Name: AlertQuery
	•	Value (Expression):

replace(variables('AlertQuery'), '\n', '
')

If your designer won’t allow a literal newline in the expression editor, skip this step initially. Only come back if you see query parsing errors.

⸻

Step 4 — Run the extracted KQL (this creates “Query results” rows)
	1.	+ New step
	2.	Search Run query and list results V2
	3.	Choose Azure Monitor Logs – Run query and list results V2
	4.	Workspace: select your Sentinel Log Analytics workspace
	5.	In Query, click Dynamic content → pick the variable AlertQuery
	•	or click Expression and enter:

variables('AlertQuery')

This is the key point: you are re-running the exact rule query that produced the alert.

⸻

Step 5 — Build the HTML table from the query results

This is the part you already started correctly.

5A) Select
	1.	+ New step
	2.	Data Operations → Select
	3.	From: choose value from Run query and list results V2

Now define the columns you want to show in email.

Because you want “AWS information,” map AWS CloudTrail columns (examples):

Column (Key)	Value (Expression)
TimeGenerated	item()?['TimeGenerated']
EventName	item()?['EventName']
EventSource	item()?['EventSource']
AwsEventId	item()?['AwsEventId']
UserIdentityType	item()?['UserIdentityType']
UserIdentityPrincipalId	item()?['UserIdentityPrincipalId']
UserName	item()?['UserName']
SourceIpAddress	item()?['SourceIpAddress']
AwsRegion	item()?['AwsRegion']

Important: Only include fields that your rule’s KQL actually projects. If a field isn’t present, it shows blank (that’s okay).

5B) Create HTML table
	1.	+ New step
	2.	Data Operations → Create HTML table
	3.	From: Output of Select
	4.	Columns: Automatic

⸻

Step 6 — Send the email with the query results table embedded

Open your existing Send an email (V2).

In the Body, stop inserting raw JSON like “Description / Entities”. Instead use this structure:

<h2>Microsoft Sentinel Alert</h2>

<table border="1" cellpadding="6" cellspacing="0" width="100%">
  <tr><td><b>Alert</b></td><td>@{body('Parse_JSON')?['AlertDisplayName']}</td></tr>
  <tr><td><b>Severity</b></td><td>@{body('Parse_JSON')?['Severity']}</td></tr>
  <tr><td><b>Technique</b></td><td>@{body('Parse_JSON')?['Techniques']}</td></tr>
</table>

<br/>

<h3>Query Results (AWS Related Events)</h3>
@{body('Create_HTML_table')}

Now the email will look like a clean grid, similar to Sentinel’s “Query results.”

⸻

Two common gotchas (and fixes)

Gotcha 1: Some alerts don’t include ExtendedProperties.Query

If the alert payload doesn’t contain the query, your variable becomes empty, and the Logs action fails.

Fix (safe handling):
	•	Add a Condition after Initialize variable AlertQuery:
	•	If length(variables('AlertQuery')) is greater than 0 → run query
	•	Else → send email with a message: “No query found in alert payload.”

Expression for condition:

greater(length(variables('AlertQuery')), 0)

Gotcha 2: Query returns too many columns / messy objects

Fix:
	•	Don’t email the raw query output directly.
	•	Use Select to restrict to the AWS columns you want.

⸻

Why this meets your requirement (one playbook for many rules)
	•	The playbook does not care whether the rule is AWS, Azure, identity, network, etc.
	•	It simply:
	1.	reads the alert’s query,
	2.	reruns it,
	3.	emails the result table.

That is the cleanest centralized approach.

⸻

If you want, I can make this exact for your environment in one pass

Reply with one detail (no extra screenshots needed if you can type it):
	•	In your Parse JSON output, what is the exact path/casing you see for the query?
	•	Is it ExtendedProperties.Query or something like extendedProperties.Query?

Once I have that, I’ll give you the exact expression you should paste so it works first try.



#########%%%%%######
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
