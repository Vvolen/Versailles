---
name: deep-code-security-review
description: >
  Performs systematic security code review against OWASP Top 10 vulnerabilities
  with structured findings and severity classification. Use when reviewing code
  for security vulnerabilities, auditing pull requests for security issues,
  or performing pre-deployment security assessments on Python, JavaScript, or Go code.
---

# Deep Code Security Review

A rigorous, structured methodology for identifying security vulnerabilities in
application code. This skill applies the OWASP Top 10 (2021) framework combined
with language-specific vulnerability patterns to produce actionable, prioritized
security findings.

## Instructions

### Phase 1: Threat Surface Mapping (Do This First)

Before reading any code line-by-line, build a mental model of the attack surface:

1. **Identify entry points** — HTTP handlers, API endpoints, CLI argument parsers,
   message queue consumers, file upload handlers, WebSocket handlers.
2. **Trace data flow** — Follow untrusted input from entry points through
   processing logic to output sinks (database queries, HTML rendering, file
   system operations, shell commands, HTTP responses).
3. **Catalog trust boundaries** — Where does data cross from untrusted to trusted
   context? Authentication middleware, input validation layers, serialization
   boundaries.
4. **Inventory sensitive operations** — Database writes, authentication checks,
   authorization gates, cryptographic operations, file system access, external
   API calls.

Output a brief threat surface summary before proceeding:

```
THREAT SURFACE:
- Entry points: [list endpoints/handlers]
- Data flows: [input → processing → output paths]
- Trust boundaries: [auth middleware, validation layers]
- Sensitive ops: [DB writes, auth checks, crypto, file I/O]
```

### Phase 2: Priority-Ordered OWASP Review

Review in this exact order — it reflects real-world exploit frequency and impact:

#### Priority 1: Injection (A03:2021) — CHECK FIRST

**What to look for:**
- SQL queries constructed with string concatenation or f-strings
- Shell commands built from user input
- LDAP queries with unescaped input
- NoSQL query objects constructed from request data
- ORM raw query methods with interpolated values

**Python — Vulnerable vs. Secure:**

```python
# ❌ VULNERABLE: SQL injection via string formatting
def get_user(username):
    query = f"SELECT * FROM users WHERE name = '{username}'"
    cursor.execute(query)

# ✅ SECURE: Parameterized query
def get_user(username):
    cursor.execute("SELECT * FROM users WHERE name = %s", (username,))
```

```python
# ❌ VULNERABLE: Command injection
def convert_file(filename):
    os.system(f"convert {filename} output.pdf")

# ✅ SECURE: Use subprocess with argument list (no shell=True)
def convert_file(filename):
    subprocess.run(["convert", filename, "output.pdf"], check=True)
```

**JavaScript — Vulnerable vs. Secure:**

```javascript
// ❌ VULNERABLE: NoSQL injection
app.post('/login', (req, res) => {
  db.users.find({ username: req.body.username, password: req.body.password });
});

// ✅ SECURE: Type-check and sanitize
app.post('/login', (req, res) => {
  if (typeof req.body.username !== 'string' || typeof req.body.password !== 'string') {
    return res.status(400).json({ error: 'Invalid input' });
  }
  const username = req.body.username.slice(0, 128);
  db.users.find({ username, password: hashPassword(req.body.password) });
});
```

**Go — Vulnerable vs. Secure:**

```go
// ❌ VULNERABLE: SQL injection
func GetUser(db *sql.DB, name string) (*User, error) {
    row := db.QueryRow("SELECT * FROM users WHERE name = '" + name + "'")
    // ...
}

// ✅ SECURE: Parameterized query
func GetUser(db *sql.DB, name string) (*User, error) {
    row := db.QueryRow("SELECT * FROM users WHERE name = $1", name)
    // ...
}
```

**Heuristic:** Search for these patterns: `f"SELECT`, `f"INSERT`, `f"UPDATE`,
`f"DELETE`, `"SELECT * FROM " +`, `os.system(`, `exec(`, `eval(`,
`subprocess.run(.*shell=True`, `.raw(`, `$where`, `db.command(`.

#### Priority 2: Broken Access Control (A01:2021)

**What to look for:**
- Missing authorization checks on endpoints
- IDOR (Insecure Direct Object References) — user can access other users' data
  by changing an ID parameter
- Privilege escalation — user can perform admin actions
- Missing function-level access control
- CORS misconfiguration allowing unauthorized origins
- Directory traversal in file serving

```python
# ❌ VULNERABLE: IDOR — no ownership check
@app.route('/api/orders/<order_id>')
def get_order(order_id):
    order = Order.query.get(order_id)
    return jsonify(order.to_dict())

# ✅ SECURE: Verify ownership
@app.route('/api/orders/<order_id>')
@login_required
def get_order(order_id):
    order = Order.query.get_or_404(order_id)
    if order.user_id != current_user.id:
        abort(403)
    return jsonify(order.to_dict())
```

```javascript
// ❌ VULNERABLE: Missing authorization middleware
router.delete('/api/users/:id', async (req, res) => {
  await User.findByIdAndDelete(req.params.id);
  res.json({ success: true });
});

// ✅ SECURE: Role-based access control
router.delete('/api/users/:id', authenticate, authorize('admin'), async (req, res) => {
  await User.findByIdAndDelete(req.params.id);
  res.json({ success: true });
});
```

**Heuristic:** For every endpoint that accesses a resource by ID, ask: "Can user
A access user B's resource by changing this ID?" If the answer is unclear, flag it.

#### Priority 3: Cryptographic Failures (A02:2021)

**What to look for:**
- Passwords stored in plaintext or with weak hashing (MD5, SHA1 without salt)
- Hardcoded secrets, API keys, or encryption keys in source code
- Use of deprecated algorithms (DES, RC4, MD5 for integrity)
- Missing TLS enforcement
- Sensitive data in logs, error messages, or URLs
- Weak random number generation for security tokens

```python
# ❌ VULNERABLE: Weak password hashing
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# ✅ SECURE: Purpose-built password hashing
import bcrypt
hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))
```

```python
# ❌ VULNERABLE: Hardcoded secret
JWT_SECRET = "my-super-secret-key-12345"

# ✅ SECURE: Environment-sourced secret with validation
JWT_SECRET = os.environ.get("JWT_SECRET")
if not JWT_SECRET or len(JWT_SECRET) < 32:
    raise RuntimeError("JWT_SECRET must be set and at least 32 characters")
```

```go
// ❌ VULNERABLE: Weak random for tokens
import "math/rand"
token := fmt.Sprintf("%d", rand.Int63())

// ✅ SECURE: Cryptographic random
import "crypto/rand"
b := make([]byte, 32)
if _, err := rand.Read(b); err != nil {
    return "", err
}
token := base64.URLEncoding.EncodeToString(b)
```

**Heuristic:** Search for: `md5`, `sha1`, `DES`, `RC4`, `math/rand`, `random.random`,
`SECRET`, `PASSWORD`, `API_KEY`, `TOKEN` in source files (excluding tests).

#### Priority 4: Cross-Site Scripting — XSS (A03:2021 subset)

**What to look for:**
- User input rendered in HTML without escaping
- `innerHTML`, `document.write()`, `v-html`, `dangerouslySetInnerHTML`
- Template engines with auto-escaping disabled
- URL parameters reflected in page content
- Stored user content (comments, profiles) rendered to other users

```javascript
// ❌ VULNERABLE: Reflected XSS
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${req.query.q}</h1>`);
});

// ✅ SECURE: Escape output
import escapeHtml from 'escape-html';
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${escapeHtml(req.query.q)}</h1>`);
});
```

```javascript
// ❌ VULNERABLE: DOM-based XSS
document.getElementById('output').innerHTML = userProvidedData;

// ✅ SECURE: Use textContent
document.getElementById('output').textContent = userProvidedData;
```

**Heuristic:** Search for: `innerHTML`, `outerHTML`, `document.write`,
`dangerouslySetInnerHTML`, `v-html`, `| safe`, `{% autoescape false %}`,
`Markup(`, `noescape`.

#### Priority 5: Security Misconfiguration (A05:2021)

**What to look for:**
- Debug mode enabled in production configurations
- Default credentials in configuration files
- Overly permissive CORS settings (`Access-Control-Allow-Origin: *`)
- Stack traces exposed in error responses
- Unnecessary HTTP methods enabled
- Missing security headers (CSP, HSTS, X-Frame-Options)
- Open cloud storage buckets or database ports

```python
# ❌ VULNERABLE: Debug mode in production config
app = Flask(__name__)
app.config['DEBUG'] = True

# ✅ SECURE: Environment-driven configuration
app = Flask(__name__)
app.config['DEBUG'] = os.environ.get('FLASK_ENV') == 'development'
```

```javascript
// ❌ VULNERABLE: Wildcard CORS
app.use(cors({ origin: '*', credentials: true }));

// ✅ SECURE: Allowlist CORS
const allowedOrigins = ['https://app.example.com', 'https://admin.example.com'];
app.use(cors({
  origin: (origin, callback) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));
```

#### Priority 6: Vulnerable Components (A06:2021)

**What to look for:**
- Outdated dependencies with known CVEs
- Pinned dependency versions that are very old
- Dependencies pulled from untrusted registries
- Lock file inconsistencies

**Heuristic:** Check `package.json`, `requirements.txt`, `go.mod`, `Gemfile` for:
- Dependencies without version pins
- Very old pinned versions (>2 years behind latest)
- Dependencies with fewer than 100 GitHub stars

#### Priority 7: Authentication Failures (A07:2021)

**What to look for:**
- No rate limiting on login endpoints
- No account lockout after failed attempts
- Session tokens that don't expire
- Credentials sent over unencrypted channels
- JWT tokens without expiration (`exp` claim)
- Weak password policies (no minimum length check)

```python
# ❌ VULNERABLE: JWT without expiration
token = jwt.encode({"user_id": user.id}, SECRET)

# ✅ SECURE: JWT with expiration and issuer
token = jwt.encode({
    "user_id": user.id,
    "exp": datetime.utcnow() + timedelta(hours=1),
    "iat": datetime.utcnow(),
    "iss": "myapp"
}, SECRET, algorithm="HS256")
```

#### Priority 8: Data Integrity Failures (A08:2021)

**What to look for:**
- Deserialization of untrusted data (pickle, yaml.load, JSON.parse of user
  input into executable context)
- Missing integrity checks on downloaded files or updates
- CI/CD pipeline injections

```python
# ❌ VULNERABLE: Unsafe deserialization
import pickle
data = pickle.loads(request.data)

# ✅ SECURE: Use safe serialization
import json
data = json.loads(request.data)
# Validate against schema after parsing
```

```python
# ❌ VULNERABLE: Unsafe YAML loading
import yaml
config = yaml.load(user_input)

# ✅ SECURE: Safe YAML loading
import yaml
config = yaml.safe_load(user_input)
```

#### Priority 9: Logging and Monitoring Failures (A09:2021)

**What to look for:**
- No logging on authentication events (login, logout, failed attempts)
- Sensitive data (passwords, tokens, PII) written to logs
- No audit trail for admin actions
- Logs without timestamps or request correlation IDs

```python
# ❌ VULNERABLE: Sensitive data in logs
logger.info(f"User login attempt: {username}, password: {password}")

# ✅ SECURE: Log events without sensitive data
logger.info(f"Login attempt for user: {username}, result: {result}, ip: {request.remote_addr}")
```

#### Priority 10: SSRF — Server-Side Request Forgery (A10:2021)

**What to look for:**
- User-controlled URLs passed to HTTP clients
- URL fetching without allowlist validation
- Internal service URLs constructable from user input

```python
# ❌ VULNERABLE: SSRF via user-controlled URL
@app.route('/fetch')
def fetch_url():
    url = request.args.get('url')
    response = requests.get(url)
    return response.content

# ✅ SECURE: URL allowlist + validation
from urllib.parse import urlparse

ALLOWED_HOSTS = {'api.example.com', 'cdn.example.com'}

@app.route('/fetch')
def fetch_url():
    url = request.args.get('url')
    parsed = urlparse(url)
    if parsed.hostname not in ALLOWED_HOSTS:
        abort(403, "Host not allowed")
    if parsed.scheme not in ('http', 'https'):
        abort(403, "Scheme not allowed")
    response = requests.get(url, timeout=5)
    return response.content
```

### Phase 3: Cross-Cutting Concerns

After the OWASP-ordered review, check these cross-cutting patterns:

1. **Path Traversal** — Any file path constructed from user input:
   ```python
   # ❌ path = f"/uploads/{request.args['filename']}"
   # ✅ path = safe_join("/uploads", request.args['filename'])
   ```

2. **Race Conditions** — TOCTOU (Time of Check, Time of Use) in file ops or
   permission checks:
   ```python
   # ❌ Check then act (race condition)
   if os.path.exists(filepath):
       os.remove(filepath)
   # ✅ Act and handle error
   try:
       os.remove(filepath)
   except FileNotFoundError:
       pass
   ```

3. **Error Handling** — Catch-all exception handlers that swallow security-relevant
   errors:
   ```python
   # ❌ Swallows auth errors
   try:
       verify_token(token)
   except Exception:
       pass  # silently continues as if authenticated
   ```

4. **Mass Assignment** — Accepting all request fields into model updates:
   ```python
   # ❌ user.update(**request.json)
   # ✅ user.update(name=data['name'], email=data['email'])
   ```

5. **Timing Attacks** — String comparison on secrets:
   ```python
   # ❌ if token == expected_token:
   # ✅ if hmac.compare_digest(token, expected_token):
   ```

### Phase 4: Produce Structured Findings

## Output Format

For each finding, produce this structured report:

```markdown
### Finding: [SHORT_TITLE]

| Field          | Value                                         |
|----------------|-----------------------------------------------|
| **Severity**   | CRITICAL / HIGH / MEDIUM / LOW / INFO         |
| **OWASP**      | A01–A10 category                              |
| **CWE**        | CWE-XXX identifier                            |
| **Location**   | file:line_number                              |
| **Confidence** | HIGH / MEDIUM / LOW                           |

**Description:**
[What the vulnerability is and why it matters]

**Vulnerable Code:**
```[lang]
[exact code snippet]
```

**Remediation:**
```[lang]
[fixed code snippet]
```

**Impact:**
[What an attacker could achieve by exploiting this]
```

### Severity Classification System

Use this matrix — both dimensions must be considered:

| | Easy to Exploit | Moderate | Hard to Exploit |
|---|---|---|---|
| **High Impact** (data breach, RCE, full account takeover) | CRITICAL | HIGH | HIGH |
| **Medium Impact** (partial data access, privilege escalation) | HIGH | MEDIUM | MEDIUM |
| **Low Impact** (information disclosure, minor DoS) | MEDIUM | LOW | LOW |

**Definitions:**
- **CRITICAL** — Exploitable remotely, no authentication needed, high impact.
  Fix immediately.
- **HIGH** — Exploitable with some prerequisites, significant impact.
  Fix within 24 hours.
- **MEDIUM** — Requires specific conditions, moderate impact.
  Fix within 1 week.
- **LOW** — Unlikely to be exploited, minimal impact.
  Fix within 1 month.
- **INFO** — Best practice recommendation, no immediate risk.
  Address during next refactor.

## Examples

### Example 1: Full Review of a Flask API Endpoint

Given this code:
```python
@app.route('/api/documents/<doc_id>')
def get_document(doc_id):
    query = f"SELECT * FROM documents WHERE id = '{doc_id}'"
    result = db.execute(query).fetchone()
    if result:
        return send_file(f"/documents/{result['filename']}")
    return "Not found", 404
```

**Findings produced:**

1. **SQL Injection** — Severity: CRITICAL, CWE-89 — `doc_id` interpolated into
   SQL query. Remediation: use parameterized query.
2. **Broken Access Control** — Severity: HIGH, CWE-284 — No authentication or
   authorization check. Any user can access any document.
3. **Path Traversal** — Severity: HIGH, CWE-22 — `result['filename']` used
   directly in file path. Attacker could store `../../etc/passwd` as filename.

### Example 2: Review Summary Format

```markdown
# Security Review Summary

**Scope:** api/ directory (12 files, 847 lines)
**Date:** 2026-04-02
**Reviewer:** Agent (deep-code-security-review skill)

## Statistics
| Severity | Count |
|----------|-------|
| CRITICAL | 1     |
| HIGH     | 3     |
| MEDIUM   | 5     |
| LOW      | 2     |
| INFO     | 4     |

## Critical Findings (Immediate Action Required)
1. [Finding title] — [file:line] — [one-line description]

## High Findings (Fix Within 24h)
1. ...

## Recommendations
- [ ] Enable parameterized queries project-wide
- [ ] Add authentication middleware to all /api/ routes
- [ ] Implement Content-Security-Policy header
```

### Example 3: When to Escalate

Escalate to human review when:
- You find evidence of intentional backdoors (hardcoded credentials that look
  deliberately placed, unusual network calls)
- Cryptographic implementations are custom-built rather than using standard libraries
- The codebase handles financial transactions, medical data, or authentication
  for >10,000 users
- You find vulnerabilities that appear to already be exploited (suspicious log entries,
  unexplained admin accounts)

## Guidelines

1. **Always start with Phase 1** (threat surface mapping). Without understanding
   data flow, you will miss injection points that span multiple files.

2. **Follow the priority order.** Injection and Broken Access Control account for
   the majority of real-world breaches. Don't spend time on logging issues before
   checking for SQL injection.

3. **Check the OWASP category, not just the pattern.** A regex search for `eval(`
   catches obvious injection but misses template injection, ORM misuse, and
   indirect code execution.

4. **Report what you actually found, not what might theoretically exist.** Each
   finding must reference a specific file and line number with the actual
   vulnerable code.

5. **Provide working remediation code.** Don't just say "use parameterized queries" —
   show the exact fix for the exact code you found.

6. **Consider the application context.** An internal admin tool with 3 users has
   different risk tolerance than a public-facing API. Adjust severity accordingly,
   but document the assumption.

7. **Don't ignore test files entirely.** Test files can reveal: (a) what security
   measures developers think they have, (b) test credentials that may match
   production, (c) security tests that are actually disabled.

8. **False positive management.** If you determine a pattern is not exploitable due
   to surrounding context (e.g., the input is validated upstream), note it as INFO
   with explanation rather than omitting it. This shows review completeness.

9. **Dependency review is supplementary.** Note outdated dependencies but don't
   let dependency analysis consume more than 10% of your review time. Focus on
   first-party code.

10. **One finding per issue.** Don't combine "SQL injection AND missing auth" into
    a single finding. Each vulnerability gets its own structured entry for
    trackability.


---

## Security Report — deep-code-security-review-2026-04-02.md
**Date:** 2026-04-03
**Result:** ❌ FAILED / QUARANTINED
**Security Score:** 0/100

### Reputation Check
- Score: 50/100
- Note: No URL found in skill file

### Static Analysis Findings
- 🚨 CRITICAL: References sensitive credential names
- 🚨 CRITICAL: Uses eval() (dangerous code execution)
- 🚨 CRITICAL: Uses exec() (dangerous code execution)

### Verdict
- Critical issues: 3
- Warnings: 0
- Moved to quarantine for human review
