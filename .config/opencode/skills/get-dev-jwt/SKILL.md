---
name: get-dev-jwt
description: Sign in to local Better Auth and return a bearer JWT token for development use.
metadata:
  scope: local-development
  org: lync
  auth: better-auth
---

## What I do
- Sign in to local Better Auth using the provided dev credentials.
- Reuse the authenticated session cookie to call the token endpoint.
- Extract and return a JWT token suitable for `Authorization: Bearer <token>`.

## Inputs
- `AUTH_BASE_URL` (default: `http://localhost:4000`)
- `DEV_AUTH_EMAIL` (required, no default)
- `DEV_AUTH_PASSWORD` (required, no default)

## Scope gate (required)
- This skill is only for Lync projects.
- Before any auth call, verify current repo/worktree is Lync:
  - repo/worktree path contains `/lync/`, or
  - repo name starts with `lync-`
- If outside Lync, stop and reply exactly: `This skill is restricted to Lync projects.`

## Steps
1. Detect `REPO_ROOT` and `REPO_NAME`.
2. Enforce scope gate (Lync-only).
3. Set `AUTH_BASE_URL="${AUTH_BASE_URL:-http://localhost:4000}"`.
4. If `DEV_AUTH_EMAIL` or `DEV_AUTH_PASSWORD` is missing, prompt user for missing value(s) before continuing.
5. Create a temporary cookie jar file.
6. Sign in:
   - `POST ${AUTH_BASE_URL}/api/auth/sign-in/email`
   - JSON body: `{ "email": "...", "password": "..." }`
   - Persist cookies to cookie jar.
7. Request token using session cookie:
   - `POST ${AUTH_BASE_URL}/api/auth/token`
   - Send cookies from cookie jar.
8. Parse JSON response and extract token in this order:
   - `token`
   - `accessToken`
   - `data.token`
9. Return raw token string first. Then optionally include:
   - `Authorization: Bearer <token>`
   - `export DEV_LLM_BEARER_TOKEN='<token>'`

## Command template
Use this exact shell flow when executing:

```bash
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"; REPO_NAME="$(basename "$REPO_ROOT")"; case "$REPO_ROOT|$REPO_NAME" in *"/lync/"*|*"|lync-"*) ;; *) echo "This skill is restricted to Lync projects." >&2; exit 1 ;; esac; AUTH_BASE_URL="${AUTH_BASE_URL:-http://localhost:4000}"; if [ -z "${DEV_AUTH_EMAIL:-}" ] || [ -z "${DEV_AUTH_PASSWORD:-}" ]; then echo "Missing DEV_AUTH_EMAIL or DEV_AUTH_PASSWORD. Prompt user for missing value(s) before running this command." >&2; exit 2; fi; COOKIE_JAR="$(mktemp)"; SIGNIN_STATUS=$(curl -sS -o /tmp/opencode-signin.json -w "%{http_code}" -c "$COOKIE_JAR" -H "Content-Type: application/json" -X POST "$AUTH_BASE_URL/api/auth/sign-in/email" --data "{\"email\":\"$DEV_AUTH_EMAIL\",\"password\":\"$DEV_AUTH_PASSWORD\"}"); TOKEN_STATUS=$(curl -sS -o /tmp/opencode-token.json -w "%{http_code}" -b "$COOKIE_JAR" -X POST "$AUTH_BASE_URL/api/auth/token" --data ''); TOKEN=$(node -e "const fs=require('node:fs'); const x=JSON.parse(fs.readFileSync('/tmp/opencode-token.json','utf8')); const t=x.token||x.accessToken||x?.data?.token||''; if(!t){process.exit(2)}; process.stdout.write(t)"); rm -f "$COOKIE_JAR"; if [ "$SIGNIN_STATUS" -ge 400 ] || [ "$TOKEN_STATUS" -ge 400 ]; then echo "Failed auth flow (signin=$SIGNIN_STATUS token=$TOKEN_STATUS)" >&2; exit 1; fi; printf "%s" "$TOKEN"
```

## Failure handling
- If sign-in fails, report status code and indicate credentials are likely invalid.
- If token request fails, report status code and mention missing/expired session cookie.
- If token field cannot be found, print token response body and ask for exact token field path.
- If credentials are missing, prompt user for them and retry.
- If project is not Lync, refuse to run.

## Guardrails
- Local development use only.
- Never log credentials.
- Never persist token to git-tracked files.
