---
name: skill-architect-meta-skill
description: >
  Teaches agents how to design, write, and validate high-quality SKILL.md files
  that reliably achieve 15%+ performance improvement over baseline. Use when
  creating new agent skills, improving existing skill files, evaluating skill
  quality before promotion, or deciding whether a reusable skill is warranted
  versus one-off instructions.
---

# Skill Architect Meta-Skill

A meta-skill for creating skills. This teaches agents the craft of writing
SKILL.md instruction files that actually improve agent performance — not
just vague advice documents, but precision-engineered behavioral modifications
that measurably change how an agent approaches a specific task class.

## Instructions

### Step 0: Determine If a Skill Is Needed

Before writing a skill, answer these gatekeeping questions:

**Create a skill when ALL of these are true:**
1. The task is **recurring** — it will be needed more than 3 times
2. The task has a **learnable structure** — there are specific steps, heuristics,
   or patterns that improve outcomes
3. **Baseline performance is inadequate** — an agent without the skill makes
   systematic, predictable errors on this task type
4. The improvement is **transferable** — the skill helps across different instances
   of the task, not just one specific case
5. The knowledge is **non-obvious** — an agent wouldn't naturally do this without
   the instruction

**Do NOT create a skill when:**
- The task is one-off (use a one-time prompt instead)
- The improvement is domain-knowledge, not methodology (write documentation instead)
- The task is simple enough that a 2-sentence instruction suffices (put it inline)
- The existing skill can be modified rather than creating a new one

**Decision matrix:**

```
Is it recurring? ──NO──→ One-off prompt
       │YES
Has learnable structure? ──NO──→ Not skill-able (needs tool/API instead)
       │YES
Baseline fails predictably? ──NO──→ Skill won't show 15% improvement
       │YES
Improvement transferable? ──NO──→ Task-specific prompt
       │YES
       └──→ CREATE A SKILL
```

---

### Step 1: Target — Define What Success Looks Like

Before writing a single instruction, define the skill's target precisely:

1. **Task class definition:** What specific type of task does this skill address?
   ```
   ❌ Bad: "Code review"
   ✅ Good: "Security-focused code review targeting OWASP Top 10 in web applications"
   ```

2. **Baseline failure analysis:** How does an agent currently fail at this task?
   List the top 3–5 systematic errors:
   ```
   Baseline failure 1: Misses SQL injection in ORM raw query methods
   Baseline failure 2: Reports severity without considering exploitability
   Baseline failure 3: Provides generic remediation instead of specific code fixes
   ```

3. **Success criteria:** What does a skilled agent do differently?
   ```
   Success: Identifies 90%+ of OWASP Top 10 vulnerabilities with correct severity
   Success: Provides working remediation code, not just descriptions
   Success: Produces structured output that integrates with issue trackers
   ```

4. **Measurement method:** How will the 15% improvement be measured?
   ```
   Metric: Vulnerability detection rate (true positives / total vulnerabilities)
   Baseline: 62% detection rate without skill
   Target: 80%+ detection rate with skill (≥29% relative improvement)
   Measurement: Run against 20 code samples with known vulnerabilities
   ```

**Target Checkpoint:**
```
[ ] Task class is specific and bounded
[ ] 3–5 baseline failures identified
[ ] Success criteria are measurable
[ ] Measurement method defined
[ ] 15% improvement is plausible (not already near ceiling)
```

---

### Step 2: Scope — Draw Boundaries

Scope determines what the skill includes AND excludes. Both are critical.

**Scoping rules:**

1. **One skill = one task class.** Don't combine "security review" and "performance
   optimization" into one skill. Each skill should address a single, coherent
   capability.

2. **Depth over breadth.** A skill that deeply covers 5 vulnerability types beats
   one that shallowly lists 50.

3. **Define explicit boundaries:**
   ```
   IN SCOPE:
   - Server-side code in Python, JavaScript, Go
   - OWASP Top 10 vulnerability categories
   - Web application code (HTTP handlers, API endpoints)

   OUT OF SCOPE:
   - Client-side JavaScript security (separate skill)
   - Infrastructure/DevOps security (separate skill)
   - Mobile application security (separate skill)
   - Languages other than Python, JavaScript, Go
   ```

4. **Time boundary:** How long should applying this skill take? If a skill takes
   60 minutes to fully apply but the typical task budget is 10 minutes, it is
   scoped too broadly.

---

### Step 3: Instructions — The Core of the Skill

This is where most skill authors fail. Instructions must be **specific, ordered,
and actionable** — not vague advice.

#### The Instruction Quality Spectrum

```
LEVEL 1 (Useless):
"Review code carefully for security issues."
→ No specific methodology, no prioritization, no output format

LEVEL 2 (Weak):
"Check for SQL injection, XSS, and authentication issues. Report findings."
→ Lists topics but provides no methodology for checking

LEVEL 3 (Adequate):
"Check for SQL injection by searching for string concatenation in SQL queries.
Look for patterns like f'SELECT...{var}' and '... + userInput + ...'.
Report each finding with file, line, and severity."
→ Specific patterns but limited to one technique

LEVEL 4 (Good):
"Check for SQL injection using this priority list:
1. Search for raw SQL with string interpolation (f-strings, .format, +)
2. Check ORM raw/extra methods for unparameterized queries
3. Look for dynamic table/column names from user input
4. Check stored procedures called with string-built parameters

For each finding, produce:
- File:line reference
- Vulnerable code snippet
- Severity (use exploitability × impact matrix)
- Remediation with corrected code"
→ Ordered checklist, multiple techniques, structured output

LEVEL 5 (Excellent):
[Level 4 content PLUS]
- Concrete examples showing vulnerable vs. secure code
- Decision trees for ambiguous cases
- Common false positive patterns to ignore
- Integration with the overall review workflow
→ Complete behavioral specification with examples and edge cases
```

**Every instruction in your skill should be Level 4 or 5.**

#### Instruction Design Patterns

1. **Ordered Checklists** — When the task has a natural sequence:
   ```
   Step 1: Map the attack surface (list entry points)
   Step 2: Trace data flow from input to output
   Step 3: Check each flow against vulnerability patterns
   Step 4: Classify severity using the impact matrix
   Step 5: Write remediation for each finding
   ```

2. **Decision Trees** — When the task requires judgment:
   ```
   Is the input from an external user?
   ├── YES → Is it validated before use?
   │   ├── YES → Is the validation sufficient? (check bypass patterns)
   │   └── NO → Flag as potential vulnerability
   └── NO → Is it from a trusted internal service?
       ├── YES → Lower severity, but still verify
       └── NO → Treat as external input
   ```

3. **Pattern Libraries** — When the task involves recognition:
   ```
   VULNERABLE PATTERNS (search for these):
   - f"SELECT * FROM {table}"    → SQL injection
   - os.system(f"cmd {input}")   → Command injection
   - eval(user_data)             → Code injection

   SAFE PATTERNS (these are OK):
   - cursor.execute("SELECT * FROM users WHERE id = %s", (id,))
   - subprocess.run(["cmd", input], shell=False)
   ```

4. **Output Templates** — When the task produces structured output:
   ```
   For each finding, produce exactly this format:
   ### Finding: [SHORT_TITLE]
   | Severity | [CRITICAL/HIGH/MEDIUM/LOW] |
   | Location | [file:line]                |
   | Description | [what and why]          |
   | Remediation | [specific code fix]     |
   ```

---

### Step 4: Examples — Show, Don't Just Tell

Examples are the highest-leverage part of a skill. Agents learn patterns more
effectively from examples than from abstract instructions.

#### What makes a good example:

1. **Complete context** — Show the full scenario, not just a snippet
2. **Input AND output** — Show what the agent receives AND what it should produce
3. **Reasoning visible** — Show WHY the output is what it is
4. **Edge cases** — Include at least one tricky/ambiguous case
5. **Contrast pairs** — Show a bad output next to a good output for the same input

#### Example template:

```markdown
### Example: [Scenario Name]

**Input:**
[What the agent is given — code, data, question, context]

**Expected Output:**
[What the agent should produce — analysis, code, answer]

**Why This Output:**
[Explanation of the reasoning that leads to this output]

**Common Mistake:**
[What an unskilled agent would produce instead, and why it's wrong]
```

#### Minimum example count by skill complexity:

| Skill Complexity | Minimum Examples | Must Include |
|-----------------|------------------|--------------|
| Simple (single technique) | 3 | 1 happy path, 1 edge case, 1 contrast pair |
| Medium (multi-step) | 5 | 2 happy path, 2 edge cases, 1 complex scenario |
| Complex (multi-domain) | 7+ | 3 happy path, 2 edge cases, 2 complex scenarios |

---

### Step 5: Test Cases — Define How to Verify the Skill Works

Every skill needs test cases that can be used in A/B evaluation. A test case is:

```markdown
### Test Case: [Name]

**Setup:** [Context/preconditions]
**Input:** [What is given to the agent]
**Expected behavior:** [What a skilled agent should do]
**Baseline behavior:** [What an unskilled agent typically does]
**Scoring rubric:**
- [Criterion 1]: [points] (what earns full/partial/zero credit)
- [Criterion 2]: [points]
**Pass threshold:** [minimum score out of total]
```

Design test cases to maximize differentiation between skilled and unskilled agents:
- If both skilled and unskilled agents would produce the same output, the test
  case is useless.
- The best test cases target the specific baseline failures you identified in
  Step 1.

---

### The Frontmatter: Writing Effective Triggers

The `description` field in YAML frontmatter is how agents decide whether to
activate this skill. It must contain a "Use when..." clause.

#### Trigger Design Principles

1. **Specific enough to avoid false activations:**
   ```yaml
   # ❌ Too broad — activates on every code task
   description: Helps with code. Use when working with code.

   # ✅ Specific — activates on security review tasks
   description: >
     Performs OWASP Top 10 security review on web application code.
     Use when reviewing code for security vulnerabilities, auditing
     pull requests for security issues, or performing pre-deployment
     security assessments.
   ```

2. **Broad enough to catch relevant tasks:**
   ```yaml
   # ❌ Too narrow — misses most security review requests
   description: >
     Finds SQL injection in Python Flask applications.
     Use when reviewing Flask code for SQL injection.

   # ✅ Appropriately scoped
   description: >
     Performs systematic security review targeting injection, auth,
     XSS, and access control vulnerabilities in Python, JavaScript,
     and Go web applications. Use when reviewing code for security
     vulnerabilities or auditing pull requests for security issues.
   ```

3. **Include the task context, not just the action:**
   ```yaml
   # ❌ Missing context
   description: Reviews code. Use when reviewing code.

   # ✅ Includes context for when to activate
   description: >
     Reviews code for security vulnerabilities using OWASP methodology.
     Use when performing security audits, reviewing PRs with security
     implications, or assessing code before deployment to production.
   ```

---

### Common Anti-Patterns in Skill Design

#### Anti-Pattern 1: The Fortune Cookie Skill

```markdown
# Be A Better Coder
## Instructions
- Write clean code
- Think before you code
- Test everything
```

**Why it fails:** Zero actionable specificity. An agent's behavior is unchanged.

**Fix:** Replace every instruction with a specific technique, pattern, or checklist
that changes what the agent actually does.

#### Anti-Pattern 2: The Encyclopedia Skill

```markdown
# Everything About Security
## Instructions
[4000 lines covering every security topic ever]
```

**Why it fails:** Too long to fit in context. Dilutes the most important patterns
with rarely-relevant information. Agent can't prioritize.

**Fix:** Scope to one task class. A 300-line skill that deeply covers one topic
beats a 3000-line skill that shallowly covers ten.

#### Anti-Pattern 3: The Missing Trigger Skill

```yaml
name: code-helper
description: Helps with code tasks.
```

**Why it fails:** No trigger condition. Will either never activate (if matching
is strict) or always activate (if matching is broad), adding noise to unrelated
tasks.

**Fix:** Write an explicit "Use when..." clause with 2–3 concrete task descriptions.

#### Anti-Pattern 4: The Abstract Theory Skill

```markdown
## Instructions
Understanding the SOLID principles is essential for good code design.
The Single Responsibility Principle states that a class should have...
[explains theory without actionable steps]
```

**Why it fails:** Teaching theory doesn't change behavior. The agent already
"knows" SOLID principles. It needs to know WHEN and HOW to apply them in the
context of a specific task.

**Fix:** Replace theory with concrete decision points:
```markdown
When reviewing a class, check:
1. Does it have >3 public methods that serve different purposes? → Split
2. Does changing requirement X force changes in method Y? → Coupling issue
3. Can you describe what the class does without using "and"? → If not, split
```

#### Anti-Pattern 5: The Copy-Paste Skill

A skill that simply restates official documentation (e.g., copying the OWASP
Top 10 descriptions verbatim).

**Why it fails:** The agent likely already has this information in its training
data. A skill should add methodology, not just facts.

**Fix:** Transform reference material into actionable procedures with agent-specific
techniques (search patterns, decision trees, output templates).

---

### Side-by-Side: Bad Skill vs. Good Skill

**BAD SKILL:**

```yaml
---
name: test-writing
description: Helps write tests.
---

# Test Writing

## Instructions
Write good tests. Tests should:
- Cover edge cases
- Be readable
- Run fast
- Test one thing each

## Examples
Here is a test:
def test_add():
    assert add(1, 2) == 3

## Guidelines
- Use descriptive names
- Avoid flaky tests
```

**Problems:** No trigger, vague instructions, single trivial example, generic
guidelines, no structured output, no methodology.

---

**GOOD SKILL:**

```yaml
---
name: boundary-value-test-design
description: >
  Designs test cases using boundary value analysis and equivalence partitioning
  to maximize defect detection with minimal test count. Use when writing unit
  tests for functions with numeric ranges, string length constraints, collection
  size limits, date ranges, or any input with defined boundaries.
---

# Boundary Value Test Design

## Instructions

### Step 1: Identify Input Boundaries
For each input parameter, find:
- Minimum valid value (MIN)
- Maximum valid value (MAX)
- Just below minimum (MIN-1)
- Just above maximum (MAX+1)
- Nominal value (middle of range)

### Step 2: Generate Boundary Test Cases
For each boundary, create tests for:
| Test Point | Purpose |
|------------|---------|
| MIN-1      | Verify rejection of below-minimum |
| MIN        | Verify acceptance of minimum |
| MIN+1      | Verify acceptance of just-above-minimum |
| NOM        | Verify normal operation |
| MAX-1      | Verify acceptance of just-below-maximum |
| MAX        | Verify acceptance of maximum |
| MAX+1      | Verify rejection of above-maximum |

### Step 3: Apply Equivalence Partitioning
Group inputs into equivalence classes:
- Valid class: [MIN, MAX]
- Invalid below: (-∞, MIN)
- Invalid above: (MAX, +∞)
- Special values: 0, -1, empty, null, MAX_INT

## Examples

### Example 1: Age Validation Function

**Function signature:** validate_age(age: int) -> bool  (valid: 0–150)

**Generated tests:**
def test_age_below_minimum():
    assert validate_age(-1) == False    # MIN-1

def test_age_at_minimum():
    assert validate_age(0) == True      # MIN

def test_age_above_minimum():
    assert validate_age(1) == True      # MIN+1

def test_age_nominal():
    assert validate_age(30) == True     # NOM

def test_age_below_maximum():
    assert validate_age(149) == True    # MAX-1

def test_age_at_maximum():
    assert validate_age(150) == True    # MAX

def test_age_above_maximum():
    assert validate_age(151) == False   # MAX+1

def test_age_special_values():
    assert validate_age(None) == False  # null
    assert validate_age(-999) == False  # extreme negative
```

---

### Quality Checklist Before Publishing

Run through this checklist before marking a skill as ready for evaluation:

```
SKILL QUALITY CHECKLIST:

Frontmatter:
[ ] name is lowercase, alphanumeric + hyphens, 1–64 chars
[ ] description is 1–1024 chars
[ ] description includes "Use when..." trigger clause
[ ] trigger is specific enough to avoid false activation
[ ] trigger is broad enough to catch relevant tasks

Instructions:
[ ] Every instruction is Level 4+ (specific, ordered, actionable)
[ ] Instructions follow a clear sequence or decision tree
[ ] Patterns include both "what to look for" and "what to do about it"
[ ] Output format is explicitly defined with a template
[ ] No vague advice ("be careful", "consider", "think about")

Examples:
[ ] Minimum 3 examples (5+ for complex skills)
[ ] Examples show complete input → output scenarios
[ ] At least 1 edge case example
[ ] At least 1 contrast pair (bad vs. good output)
[ ] Examples cover different sub-domains of the skill

Guidelines:
[ ] Guidelines are actionable, not generic
[ ] Priority ordering is explicit (what to do first)
[ ] Common pitfalls are documented with fixes
[ ] Scope boundaries are clear (what is NOT covered)

Estimating 15% Improvement:
[ ] Baseline failures are documented and specific
[ ] Skill directly addresses each baseline failure
[ ] Test cases differentiate skilled from unskilled performance
[ ] Expected improvement is realistic (not ceiling-limited)
```

---

### Estimating Whether a Skill Will Achieve ≥15% Improvement

Use this framework to predict skill impact before investing in creation:

1. **Identify the baseline failure rate** for the task class. If the agent already
   succeeds 95% of the time, a 15% relative improvement requires going from 95%
   to ~100% — very hard.

2. **Count addressable failures.** Of the failures you identified, how many can
   be fixed with instructions alone (vs. requiring tool access, more context, etc.)?

3. **Calculate theoretical maximum improvement:**
   ```
   Current success rate: 70%
   Failures addressable by skill: 20% (out of 30% failures)
   If skill fixes 75% of addressable failures: 70% + (20% × 75%) = 85%
   Relative improvement: (85% - 70%) / 70% = 21.4% ✓ (above 15%)
   ```

4. **Discount for imperfect skill application.** Real improvement ≈ 60–80% of
   theoretical maximum. Agents don't follow skills perfectly.

5. **Red flags that a skill won't hit 15%:**
   - Baseline is already >90% (ceiling effect)
   - Most failures are due to missing information, not methodology
   - The skill addresses rare edge cases, not common failures
   - Similar instructions already exist in the agent's training data

## Examples

### Example: Deciding Whether to Create a Skill

**Scenario:** An agent frequently writes API documentation that misses error response codes.

**Analysis:**
1. Recurring? YES — API docs are written regularly
2. Learnable structure? YES — there's a checklist of what to include
3. Baseline fails predictably? YES — consistently misses 4xx/5xx responses
4. Transferable? YES — applies to any REST API documentation task
5. Non-obvious? PARTIALLY — the agent "knows" about error codes but doesn't
   systematically check for them

**Decision:** CREATE A SKILL — specifically targeting the systematic inclusion of
error responses, with a checklist and examples.

**Improvement estimate:**
- Current: ~60% of API docs include complete error responses
- Addressable: ~35% (out of 40% failures — some are due to missing API specs)
- Expected: 60% + (35% × 70%) = 84.5%
- Relative improvement: 40.8% ✓ Well above 15%

## Guidelines

1. **Start with Step 0.** Half of all proposed skills should NOT be created.
   The gatekeeping questions save significant effort on skills that won't clear
   the 15% bar.

2. **Spend 40% of your skill-creation time on examples.** Instructions set the
   methodology; examples calibrate the execution. Agents learn more from seeing
   three good examples than reading ten paragraphs of instructions.

3. **Test your skill on the hardest case first.** Write one difficult test case
   and mentally simulate how an agent would apply the skill. If the skill doesn't
   help on the hard case, it won't hit 15% improvement.

4. **Keep skills under 500 lines — except meta-skills.** Context window space is
   precious. If your skill exceeds 500 lines, you are probably combining multiple
   skills. Split it. Meta-skills and comprehensive reference skills may exceed
   this limit when the breadth of coverage justifies the extra context.

5. **Write triggers from the user's perspective.** The "Use when..." clause should
   match how a human would describe the task, not how an agent categorizes it.

6. **Iterate on real failures.** After the first A/B evaluation, analyze where the
   skill still fails. The second version of a skill is almost always better than
   the first because it addresses real failure modes.

7. **Don't duplicate training data.** If the agent already knows something (e.g.,
   "SQL injection is when user input is interpolated into SQL"), don't repeat it
   in the skill. Add methodology and decision procedures that the agent doesn't
   naturally apply.

8. **Version your skills.** Name files with version numbers (`-v1`, `-v2`) so you
   can track which version was evaluated and what changed.

9. **Include negative examples.** Showing what NOT to do is as valuable as showing
   what to do. Contrast pairs are the fastest way to calibrate agent behavior.

10. **The best skills feel like checklists.** If an agent can mechanically follow
    your skill and produce correct output, you've written a good skill. If it
    requires "creativity" or "judgment" that you haven't specified, you have gaps
    to fill.
