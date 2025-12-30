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
