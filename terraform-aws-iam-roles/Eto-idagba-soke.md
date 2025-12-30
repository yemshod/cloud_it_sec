You are very close. What your screenshots show is the real blocker:
	•	In Advanced hunting the query is multi-line KQL, starting with // comments and a set query_now = datetime(...) line, then AWSCloudTrail | ....
	•	In the playbook, your AlertQuery_Clean is being turned into one long line and (critically) it’s being concatenated in a way that breaks KQL parsing for the connector.
	•	The Run query and list results V2 action returns 400 BadRequest — this almost always means the query string is not valid KQL by the time it reaches the connector.

This is not about AWS vs other rules; it’s about sanitizing the query text safely so any rule’s query runs.

Below is the portal-only way to fix it in a generalized manner.

⸻

Root Cause (what’s wrong with AlertQuery_Clean)

Your cleanup step is doing something like:

replace(rawQuery, '\n', ' ')

That turns this:

set query_now = datetime(...);
AWSCloudTrail
| where ...
| project ...

Into something like this (one line):

set query_now = datetime(...); AWSCloudTrail | where ... | project ...

That can work, but it breaks easily when:
	•	there are // comments at the start,
	•	there are invisible escape sequences (\r\n, \\n),
	•	there are tabs, or
	•	the payload contains literal \n characters rather than actual newlines (very common in JSON).

Your screenshot suggests you still have mixed formatting, and the connector is rejecting it.

⸻

The Fix (Robust, central, works across many rule queries)

Fix Strategy

Do not attempt to preserve formatting with “pretty” newlines. Instead:
	1.	Remove comment lines that start with // (optional but recommended)
	2.	Normalize both \r\n and \n and the escaped versions \\n / \\r\\n
	3.	Keep statement boundaries safe (preserve ; and pipe |)

The simplest robust pattern for Logic Apps is:
	•	Convert everything into a single line BUT remove the comment block and normalize escape sequences correctly.

⸻

Step-by-step in the portal

Step 1 — Stop using “replace(…, ‘\n’, …)” as your only cleanup

Keep your AlertQueryRaw (or AlertQuery) variable exactly as extracted.

Add a new Compose step (recommended) called:

AlertQuery_Normalized

Inputs → Expression:

trim(
  replace(
    replace(
      replace(
        replace(variables('AlertQuery'), '\r\n', ' '),
      '\n', ' '),
    '\\r\\n', ' '),
  '\\n', ' ')
)

What this does:
	•	Handles real newlines (\r\n, \n)
	•	Handles escaped newlines in JSON (\\r\\n, \\n)
	•	Produces a safe single-line query the connector can parse

✅ This is the #1 reason you get 400s: your payload likely contains escaped newlines, not real ones.

⸻

Step 2 — Remove the leading comment line if present (recommended)

Many Sentinel templates begin with:

// The query_now parameter represents the time...

Some connectors choke if the query begins with comment text after sanitization.

Add another Compose step called:

AlertQuery_NoComment

Inputs → Expression:

if(
  startsWith(outputs('AlertQuery_Normalized'), '//'),
  substring(outputs('AlertQuery_Normalized'), add(indexOf(outputs('AlertQuery_Normalized'), 'AWS'), 0)),
  outputs('AlertQuery_Normalized')
)

This is a pragmatic approach:
	•	If the string begins with //, we cut everything before the first AWS token.
	•	This works for your AWS rules.
	•	But you said queries differ across rules — so we need a more generic approach.

More generic variant (safer across all rules)

Instead of looking for AWS, look for the first occurrence of a table-like token. A simple generic heuristic is: cut everything before the first semicolon ; (end of the set query_now...; statement):

Add Compose called AlertQuery_AfterSet

Inputs → Expression:

if(
  contains(outputs('AlertQuery_Normalized'), ';'),
  trim(substring(outputs('AlertQuery_Normalized'), add(indexOf(outputs('AlertQuery_Normalized'), ';'), 1))),
  outputs('AlertQuery_Normalized')
)

This will:
	•	Remove the initial set query_now=...; and comments if they exist before the semicolon
	•	Leave the main query starting at the table (AWSCloudTrail | ...)

Use this one. It is rule-agnostic enough because many scheduled rules include set query_now...;.

⸻

Step 3 — Feed the cleaned query into Run query and list results V2

In Run query and list results V2 → Query field, set it to:
	•	Dynamic content: Outputs of AlertQuery_AfterSet
	•	or Expression:

outputs('AlertQuery_AfterSet')

Keep:
	•	Time Range Type: SetInQuery (as you already did)

⸻

Step 4 — If it still fails, verify the exact error text from the run

In the failed run:
	1.	Open the failed Run query and list results V2
	2.	Click Show raw outputs
	3.	Expand body → find message

Common messages and fixes:

Error: “Syntax error near …”

Your query still contains broken escaping.
	•	Add one more normalization:

replace(outputs('AlertQuery_AfterSet'), '\t', ' ')

Error: “The name ‘query_now’ does not refer to any known function…”

That means the query references query_now variable but you removed the set query_now = ...;.

Fix: Do not remove the set query_now line in those cases.
So instead of AlertQuery_AfterSet, use AlertQuery_Normalized.

Practical solution: add a Condition:
	•	If the query contains query_now then keep the set query_now...;
	•	Else remove it.

Condition expression:

contains(outputs('AlertQuery_Normalized'), 'query_now')

If true → use AlertQuery_Normalized
If false → use AlertQuery_AfterSet

⸻

Why this will work across “many different rules”

Because you are not hardcoding AWS fields anymore — you are:
	•	Normalizing newline escaping for any KQL
	•	Optionally preserving/removing the set query_now statement depending on whether the main query references it

This makes it robust across:
	•	AWS CloudTrail rules
	•	Azure Activity rules
	•	SigninLogs rules
	•	MDE / Defender tables
	•	Any scheduled analytics rule whose query is included in the alert payload

⸻

The simplest working implementation (minimum changes)

If you want the fewest edits, do this:
	1.	Replace your current AlertQuery_Clean Compose with AlertQuery_Normalized expression above
	2.	Use outputs('AlertQuery_Normalized') directly in the Run Query action
	3.	Keep TimeRangeType = SetInQuery

That alone resolves most 400s because the main culprit is usually \\n vs \n.

⸻

Next step from you (so I can lock this in)

Open the failed Run query and list results V2 run → Show raw outputs and paste just the message value (one line).
With that exact message, I’ll tell you whether to:
	•	keep or remove set query_now...;
	•	strip comments
	•	or adjust escaping one more time.
