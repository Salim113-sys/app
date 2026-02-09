# DeepSeek Local Critic (Ollama)

## Purpose
Use a local DeepSeek-R1 model (via Ollama) as a strict code-review critic for Daily Reset, with no API key and no cloud dependency.

## Safety
- Bind Ollama to loopback only: `127.0.0.1:11434`.
- Do not expose Ollama on `0.0.0.0`.
- Do not paste secrets, tokens, credentials, or personal data into prompts.
- Keep all requests local via `http://127.0.0.1:11434`.

Loopback-only check:

```powershell
netstat -ano | Select-String ":11434"
```

Expected listener:

```text
TCP    127.0.0.1:11434    0.0.0.0:0    LISTENING
```

If needed, restart Ollama in loopback-only mode:

```powershell
Get-Process ollama -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
$env:OLLAMA_HOST = "127.0.0.1:11434"
Start-Process -FilePath "C:\Users\NORD EST\AppData\Local\Programs\Ollama\ollama.exe" -ArgumentList "serve" -WindowStyle Hidden
```

## How To Use

### A) Ollama Chat UI (copy/paste template)
Model:
- Prefer: `deepseek-r1:8b` (if RAM allows)
- Fallback: `deepseek-r1:7b`

System prompt:

```text
You are a strict senior code reviewer for the Daily Reset Flutter app.
Primary goal: find correctness and stability risks, not style nits.

Review priorities (highest to lowest):
1) ProviderNotFoundException risks from unsafe provider lookups.
2) use_build_context_synchronously risks (context usage after await).
3) Missing try/finally around UI busy flags (_isResetting/isLoading) that can leave UI stuck.
4) Duplicate or conflicting notification cancellation paths (including accidental global cancel behavior).
5) Nullability misuse (implicit null assumptions, nullable provider usage, unsafe casts, missing guards).

Rules:
- Report only code-proven issues.
- Give file path + function + exact line references when possible.
- For each finding: severity (High/Medium/Low), why it is a bug/risk, minimal fix.
- If no findings, explicitly say "No proven issues found" and list residual risks/tests to run.
- Do not propose refactors or new features outside the review scope.
```

User prompt template (diff review):

```text
Review this diff with the system rules above.

Scope:
- Reset/clear flows
- Notification cancellation
- Provider lifecycle safety

Diff:
<PASTE DIFF HERE>

Output format:
1) Findings (ordered by severity)
2) Suggested minimal patch notes
3) Regression tests to add/run
```

User prompt template (single function review):

```text
Review this function with the system rules above.

File: <path>
Function: <name>
Code:
<PASTE FUNCTION HERE>

Output format:
1) Findings (ordered by severity)
2) Minimal safe edits
3) Quick validation checklist
```

### B) HTTP API examples

#### curl (Windows `curl.exe`)

```bash
curl.exe http://127.0.0.1:11434/api/tags
```

```bash
curl.exe -X POST http://127.0.0.1:11434/api/chat ^
  -H "Content-Type: application/json" ^
  -d "{\"model\":\"deepseek-r1:7b\",\"stream\":false,\"messages\":[{\"role\":\"system\",\"content\":\"You are a strict senior code reviewer...\"},{\"role\":\"user\",\"content\":\"Review this function...\"}]}"
```

#### PowerShell Invoke-RestMethod

```powershell
Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:11434/api/tags" | ConvertTo-Json -Depth 8
```

```powershell
$body = @{
  model = "deepseek-r1:7b"
  stream = $false
  messages = @(
    @{
      role = "system"
      content = "You are a strict senior code reviewer..."
    },
    @{
      role = "user"
      content = "Review this function..."
    }
  )
} | ConvertTo-Json -Depth 8

Invoke-RestMethod -Method Post `
  -Uri "http://127.0.0.1:11434/api/chat" `
  -ContentType "application/json" `
  -Body $body | ConvertTo-Json -Depth 8
```

## Review Templates

### Template: Review a Diff

```text
[CONTEXT]
Project: Daily Reset (Flutter)
Area: <reset/notifications/providers/etc>

[ASK]
Audit this diff for correctness/stability only.
Reject style-only suggestions.

[DIFF]
<paste diff>

[REQUIRED OUTPUT]
1) Findings (severity + file + line + explanation)
2) Minimal change recommendation per finding
3) Tests/commands to validate fix
```

### Template: Review a Single Function

```text
[CONTEXT]
Project: Daily Reset (Flutter)
File: <path>
Function: <name>

[CODE]
<paste function>

[ASK]
Find crash vectors and state consistency bugs only.
Focus on provider safety, context-after-await, try/finally busy flags, notification cancel duplication, nullability.

[REQUIRED OUTPUT]
1) Findings (severity + exact code location)
2) Minimal safe edits
3) Verification checklist
```
