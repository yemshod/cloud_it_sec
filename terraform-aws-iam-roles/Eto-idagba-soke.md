Perfect — thanks for the screenshots. Your flow is well-structured already. We are going to minimally extend it, not redesign it.

Below are exact, portal-clickable steps mapped directly onto your existing actions, using the same naming conventions you already have.

⸻

What we are implementing (aligned to your flow)

You asked for two things:
	1.	Option A
➡️ Only return events that actually caused this alert (time-scoped)
	2.	SOC-grade polish
➡️ Primary event table + compact context summary
➡️ No historical noise
➡️ Reusable for all rules

⸻

PART 1 — Implement Option A (Alert-scoped query)

Your current query problem

Right now:
	•	AlertQuery AfterSet is correct
	•	But it has no time constraint
	•	So Log Analytics returns every historical match

We will:
	•	Derive AlertTime
	•	Inject a TimeGenerated BETWEEN clause
	•	Append it to AlertQuery AfterSet

⸻

STEP 1 — Add AlertTimeUtc (Compose)

📍 Place this immediately after Parse JSON
	1.	Click +
	2.	Data Operations → Compose
	3.	Rename it:
AlertTimeUtc
	4.	Click Expression and paste:

body('Parse_JSON')?['TimeGenerated']

✅ This gives us the precise UTC timestamp of the alert.

⸻

STEP 2 — Add the time-window clause (Compose)

📍 Place this after AlertTimeUtc
	1.	Click +
	2.	Data Operations → Compose
	3.	Rename it:
AlertTimeWindowClause
	4.	Expression:

concat(
  " | where TimeGenerated between (datetime('",
  outputs('AlertTimeUtc'),
  "') - 5m .. datetime('",
  outputs('AlertTimeUtc'),
  "') + 5m)"
)

📌 Why ±5 minutes:
	•	Handles ingestion lag
	•	Prevents historical noise
	•	SOC-approved default

⸻

STEP 3 — Build the final alert-scoped query

📍 Replace the logic of AlertQuery AfterSet

Open AlertQuery AfterSet and set Expression to:

concat(
  outputs('AlertQuery Normalized'),
  outputs('AlertTimeWindowClause')
)

✅ This preserves:
	•	Your query cleanup logic
	•	Your normalization logic
	•	Adds time scoping at the very end (best practice)

⸻

STEP 4 — Update Run query and list results V2

Open Run query and list results V2:

Field	Value
Query	outputs('AlertQuery AfterSet')
Time Range Type	SetInQuery

🚫 Do not set Start / End time here.

✅ Result:
Only events within ±5 minutes of the alert are returned.

⸻

PART 2 — SOC-grade polish

You already have:
	•	Select
	•	Create HTML table
	•	StyledQueryTable
	•	Email formatting

We’ll add one small summary block without disturbing your primary table.

⸻

STEP 5 — Add a Context Summary query

📍 Place this right after AlertQuery AfterSet
	1.	+
	2.	Compose
	3.	Name:
AlertSummaryQuery
	4.	Expression:

concat(
  outputs('AlertQuery AfterSet'),
  " | summarize Events=count(), Accounts=dcount(AWSAccountID), Principals=dcount(UserIdentityPrincipalId) by EventName"
)

📌 This gives SOC:
	•	How many events
	•	How many accounts
	•	How many principals
	•	Grouped by EventName

⸻

STEP 6 — Run the summary query
	1.	+
	2.	Run query and list results V2
	3.	Name it:
Run Alert Summary Query
	4.	Query:

outputs('AlertSummaryQuery')

	5.	Time Range Type:
SetInQuery

⸻

STEP 7 — Format the summary table
	1.	+
	2.	Select
	3.	From:
value (from Run Alert Summary Query)
	4.	Map:

Key	Value
EventName	item()?['EventName']
Events	item()?['Events']
Accounts	item()?['Accounts']
Principals	item()?['Principals']


⸻

STEP 8 — Create + style the summary table
	1.	Create HTML table
	2.	Input: output of the summary Select
	3.	Then add a Compose:
	•	Name: StyledSummaryTable
	•	Expression (same styling trick):

replace(
  replace(
    body('Create_HTML_table_2'),
    '<table>',
    '<table border="1" cellpadding="6" cellspacing="0" width="100%" style="border-collapse:collapse;font-family:Arial;font-size:12pt;">'
  ),
  '<th>',
  '<th style="background-color:#f2f2f2;text-align:left;">'
)


⸻

PART 3 — Final Email Layout (SOC format)

In Send an email (V2) → Body (Code View):

<h2>Microsoft Sentinel Alert</h2>

<table border="1" cellpadding="6" cellspacing="0" width="100%" style="border-collapse:collapse;">
  <tr><td><b>Alert</b></td><td>@{body('Parse_JSON')?['AlertDisplayName']}</td></tr>
  <tr><td><b>Severity</b></td><td>@{body('Parse_JSON')?['Severity']}</td></tr>
  <tr><td><b>Technique</b></td><td>@{body('Parse_JSON')?['Techniques']}</td></tr>
</table>

<br/>

<h3>Primary Events (Alert Window ±5m)</h3>
@{outputs('StyledQueryTable')}

<br/>

<h3>Context Summary</h3>
@{outputs('StyledSummaryTable')}


⸻

What you now have (architecturally correct)

✅ Alert-scoped queries (no historical noise)
✅ SOC-friendly primary evidence
✅ Lightweight context for triage
✅ One playbook usable across all Sentinel rules
✅ No rule-specific hardcoding
✅ No KQL duplication

This is production-grade Sentinel automation.

⸻

Optional next upgrades (when you’re ready)
	•	Severity-colored headers (red/amber/green)
	•	Auto-expand window if 0 results
	•	Attach CSV for full context
	•	“View in Sentinel” deep link
	•	MITRE technique enrichment (T1098 → name)

If you want, tell me which one you want next and I’ll layer it cleanly on top of this without breaking anything.

+++++++++++++++


You already have everything you need—the only reason the Query Results section is not showing as a bordered “grid table” like the top summary is because Create HTML table outputs a plain HTML table with minimal styling, and Outlook renders it with little/no borders by default.

To make the Query Results render like the top table, you have two solid portal-only options:

⸻

Option 1 (Recommended): Wrap the Create HTML table output and inject table styling

This keeps your existing “Create HTML table” action and simply adds borders + padding + border-collapse.

Step-by-step

Step 1 — Add a Compose after “Create HTML table”
	1.	Under Create HTML table, click + New step
	2.	Choose Data Operations → Compose
	3.	Name it: StyledQueryTable

Step 2 — In Compose, paste this Expression

Click inside Inputs → Expression and paste:

replace(
  replace(
    body('Create_HTML_table'),
    '<table>',
    '<table border="1" cellpadding="6" cellspacing="0" width="100%" style="border-collapse:collapse;font-family:Arial;font-size:12pt;">'
  ),
  '<th>',
  '<th style="background-color:#f2f2f2;text-align:left;">'
)

What this does:
	•	Forces borders/cellpadding/cellspacing like your summary table
	•	Adds a light header background so it looks “report-ready”

Step 3 — Update your Send Email body

Replace the current Query Results insertion:

From:

@{body('Create_HTML_table')}

To:

@{outputs('StyledQueryTable')}

✅ Result: the Query Results block becomes a true bordered table like the top one.

⸻

Option 2: Skip “Create HTML table” and build the table yourself (more control)

Use this only if you want perfect formatting control (column order, custom widths, etc.). Option 1 is usually enough.

⸻

Extra polish (highly recommended in SOC emails)

A) Limit the query table to N rows (avoid huge emails)

In your KQL add at the end:

| take 20

B) Prevent long values from blowing out the layout

Outlook is weak with CSS, but you can at least reduce wrapping by ensuring only the necessary columns are included (which you already did). If you must include long IDs, consider shortening:

Example KQL:

| extend PrincipalShort = substring(UserIdentityPrincipalId, 0, 25)
| project TimeGenerated, EventName, AWSAccountID, PrincipalShort


⸻

Quick validation checklist

After you implement Option 1:
	•	The Query Results table has borders (grid)
	•	Headers are shaded
	•	Summary table and Query table look consistent

⸻

If you want, I can also give you a single standardized email template that works across all alert types (AWS, Azure, identity, etc.) with consistent formatting, severity color banding, and a “View in Sentinel” link.


ggggggggggggggg

You are not doing anything “wrong” with the logic—your playbook is now producing the table correctly. The remaining issue is email rendering behavior:
	•	In your Send email (V2) action, you are composing HTML (<h2>, <table>, etc.)
	•	But the email you receive shows the HTML tags as literal text (the <h2> and <table> are not being rendered), while the HTML table output (“Query Results”) is being rendered as a table.

That mismatch happens when Outlook/Logic Apps is treating the body as plain text / partially sanitized HTML.

Below is what is happening and the exact portal steps to fix it permanently.

⸻

What’s happening (root cause)

In Send an email (V2) you inserted:
	•	your own HTML (<h2>…</h2><table …>…</table>)
	•	plus the Create HTML table output (which is already HTML)

But Outlook is rendering:
	•	your typed HTML as literal text
	•	while still rendering the Create HTML table output as a table

This is typical when the email action is in a mode that escapes/sanitizes pasted HTML inside the rich editor, especially if:
	•	you pasted HTML while the designer is in “rich text mode”
	•	or the connector is sending the message as plain text except for the injected HTML-table output token

⸻

Fix (Portal): Force the email body to be pure HTML

Step 1 — Switch Send email body editor into “Code view”

In the Send an email (V2) action:
	1.	Click inside the Body field
	2.	On the right side of that editor toolbar, click the </> icon (HTML/Code view)

If you don’t see </>:
	•	Expand the editor (top-right “maximize” icon) or
	•	scroll the toolbar to the far right

✅ When in code view, you should see raw HTML without the UI trying to format it.

⸻

Step 2 — Remove any HTML that was entered in rich-text mode

Still inside code view:
	1.	Select everything currently in the Body
	2.	Delete it entirely

This matters because when HTML is inserted in rich text mode, Logic Apps can store it as escaped text.

⸻

Step 3 — Paste a clean HTML template in code view

Paste this exact template:

<html>
  <body style="font-family: Arial, sans-serif; font-size: 12pt;">
    <h2>Microsoft Sentinel Alert</h2>

    <table border="1" cellpadding="6" cellspacing="0" width="100%" style="border-collapse: collapse;">
      <tr>
        <td><b>Alert</b></td>
        <td>@{triggerBody()?['AlertDisplayName']}</td>
      </tr>
      <tr>
        <td><b>Severity</b></td>
        <td>@{triggerBody()?['Severity']}</td>
      </tr>
      <tr>
        <td><b>Technique</b></td>
        <td>@{triggerBody()?['Techniques']}</td>
      </tr>
    </table>

    <br />

    <h3>Query Results (AWS Related Events)</h3>

    @{body('Create_HTML_table')}

  </body>
</html>

Important notes
	•	The dynamic tokens you used (Body AlertDisplayName, etc.) are fine; I used expressions to make it explicit.
	•	The key change is: paste the HTML only in code view.

⸻

Fix (if your dynamic fields are not from triggerBody)

In your screenshot, the tokens show as:
	•	Body AlertDisplayName
	•	Body Severity
	•	Body Techniques
That suggests you are pulling from Parse JSON output, not directly triggerBody.

If that’s your case, use:

<td>@{body('Parse_JSON')?['AlertDisplayName']}</td>

and same for Severity/Techniques.

⸻

Fix #2: Ensure you are using the correct email action

Make sure you are using:

✅ Office 365 Outlook – Send an email (V2)

Not:
	•	“Send an email notification”
	•	SMTP action
	•	Gmail action
	•	Outlook.com “Send an email”

Those can escape HTML.

⸻

Fix #3 (Common): “HTML” is being escaped because you inserted dynamic tokens incorrectly

In Logic Apps, the safest way is:
	•	Use your static HTML (typed/pasted in code view)
	•	Insert dynamic content tokens outside of angle brackets
	•	Do not wrap tokens inside quotes unless needed

Example good:

<td>@{body('Parse_JSON')?['Severity']}</td>

Example risky:

<td>"@{...}"</td>


⸻

Why your Query Results table rendered but your header didn’t

Because the Create HTML table action generates a full HTML <table> block in a way the connector trusts.
But your manually typed/pasted HTML was stored as escaped characters, so it printed verbatim.

Once you paste in code view, both will render consistently.

⸻

Verification checklist (fast)

After you apply the fix:
	1.	Save
	2.	Trigger a test alert
	3.	Confirm in the email:
	•	No <h2> tags visible
	•	Header looks like a title, not raw text
	•	The small “Alert summary” table renders as a table
	•	Query Results renders as a table

⸻

Optional improvement (recommended)

Your query results table is wide, so Outlook will wrap/clip. You can make it more readable by constraining and adding scroll style (Outlook support varies), or you can:
	•	reduce columns in your Select step
	•	or attach a CSV

If you want the cleanest SOC output, I recommend:
	•	Keep only 6–10 columns in email
	•	Attach full CSV for everything else

⸻

If you tell me which connector action you are using exactly (the header of the action card), I can confirm whether it supports raw HTML fully and give you the exact “code view” placement for your current dynamic tokens.
