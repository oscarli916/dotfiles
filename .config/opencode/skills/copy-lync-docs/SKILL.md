---
name: copy-lync-docs
description: Copy docs/spec files from one Lync project to another Lync project with safety checks.
metadata:
  scope: local-development
  org: lync
  operation: file-copy
---

## What I do
- Copy LLM-generated specs and docs from the current project to another project.
- Default source is `docs/` and all nested files.
- Preserve source-relative paths in destination.
- Support dry-run previews and optional overwrite mode.

## Inputs
- `DEST_PROJECT_PATH` (required): absolute or relative path to destination project.
- `SOURCE_GLOB` (optional, default: `docs/**/*`): file pattern within source repo.
- `OVERWRITE` (optional, default: `false`): `true` to replace existing destination files.
- `DRY_RUN` (optional, default: `true`): `true` to preview copy plan without writing files.

## Scope gate (required)
- This skill is only for Lync projects.
- Validate source and destination projects before any file write:
  - Source repo name starts with `lync-`.
  - Destination repo name starts with `lync-`.
  - Both source and destination are git repositories.
- If either project fails scope checks, stop and reply exactly:
  - `This skill is restricted to lync* projects.`

## Steps
1. Detect source repo root and name (`SRC_ROOT`, `SRC_REPO_NAME`).
2. Resolve destination path and detect destination repo root and name (`DST_ROOT`, `DST_REPO_NAME`).
3. Enforce scope gate for both projects (`lync-*` and git repo).
4. Set defaults:
   - `SOURCE_GLOB="${SOURCE_GLOB:-docs/**/*}"`
   - `OVERWRITE="${OVERWRITE:-false}"`
   - `DRY_RUN="${DRY_RUN:-true}"`
5. Enumerate matching source files (files only).
6. Build copy plan preserving relative paths from `SRC_ROOT` to `DST_ROOT`.
7. Safety checks:
   - Ensure source and destination are not the same path.
   - Ensure at least one file matched.
   - Ensure each destination path resolves under `DST_ROOT`.
8. Print preview table: `SOURCE -> DESTINATION`.
9. If `DRY_RUN=true`, exit after preview with summary.
10. If `DRY_RUN=false`, create destination directories and copy files:
    - if destination exists and `OVERWRITE=false`, skip and count skip.
    - if destination exists and `OVERWRITE=true`, replace and count overwrite.
11. Print summary: copied/skipped/overwritten/error counts.

## Command template
Use this exact shell flow when executing:

```bash
DEST_PROJECT_PATH="${DEST_PROJECT_PATH:-}"; if [ -z "$DEST_PROJECT_PATH" ]; then echo "Missing DEST_PROJECT_PATH" >&2; exit 2; fi; SRC_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"; if [ -z "$SRC_ROOT" ]; then echo "This skill is restricted to lync* projects." >&2; exit 1; fi; SRC_REPO_NAME="$(basename "$SRC_ROOT")"; DST_INPUT="$DEST_PROJECT_PATH"; DST_ABS="$(python3 -c 'import os,sys; print(os.path.abspath(sys.argv[1]))' "$DST_INPUT")"; if [ ! -d "$DST_ABS" ]; then echo "Destination path does not exist: $DST_ABS" >&2; exit 2; fi; DST_ROOT="$(git -C "$DST_ABS" rev-parse --show-toplevel 2>/dev/null || true)"; if [ -z "$DST_ROOT" ]; then echo "This skill is restricted to lync* projects." >&2; exit 1; fi; DST_REPO_NAME="$(basename "$DST_ROOT")"; case "$SRC_REPO_NAME|$DST_REPO_NAME" in lync-*'|'lync-*) ;; *) echo "This skill is restricted to lync* projects." >&2; exit 1 ;; esac; SOURCE_GLOB="${SOURCE_GLOB:-docs/**/*}"; OVERWRITE="${OVERWRITE:-false}"; DRY_RUN="${DRY_RUN:-true}"; SRC_REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$SRC_ROOT")"; DST_REAL="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$DST_ROOT")"; if [ "$SRC_REAL" = "$DST_REAL" ]; then echo "Source and destination are the same project." >&2; exit 2; fi; mapfile -t FILES < <(python3 - "$SRC_ROOT" "$SOURCE_GLOB" <<'PY'
import glob, os, sys
root = sys.argv[1]
pattern = sys.argv[2]
paths = sorted(glob.glob(os.path.join(root, pattern), recursive=True))
for p in paths:
    if os.path.isfile(p):
        print(os.path.realpath(p))
PY
); if [ "${#FILES[@]}" -eq 0 ]; then echo "No files matched SOURCE_GLOB=$SOURCE_GLOB" >&2; exit 3; fi; copied=0; skipped=0; overwritten=0; errors=0; echo "Copy plan:"; for src in "${FILES[@]}"; do rel="${src#"$SRC_REAL"/}"; dst="$DST_REAL/$rel"; case "$dst" in "$DST_REAL"/*) ;; *) echo "Unsafe destination path: $dst" >&2; exit 4 ;; esac; echo "$src -> $dst"; done; if [ "$DRY_RUN" = "true" ]; then echo "Dry run complete: ${#FILES[@]} file(s) planned."; exit 0; fi; for src in "${FILES[@]}"; do rel="${src#"$SRC_REAL"/}"; dst="$DST_REAL/$rel"; dstdir="$(dirname "$dst")"; mkdir -p "$dstdir" || { errors=$((errors+1)); continue; }; if [ -e "$dst" ]; then if [ "$OVERWRITE" = "true" ]; then cp "$src" "$dst" && overwritten=$((overwritten+1)) || errors=$((errors+1)); else skipped=$((skipped+1)); fi; else cp "$src" "$dst" && copied=$((copied+1)) || errors=$((errors+1)); fi; done; echo "Done: copied=$copied skipped=$skipped overwritten=$overwritten errors=$errors"
```

## Usage examples
- Preview copy all docs:
  - `DEST_PROJECT_PATH=../lync-payments DRY_RUN=true`
- Copy all docs without overwrite:
  - `DEST_PROJECT_PATH=../lync-payments DRY_RUN=false OVERWRITE=false`
- Copy only markdown specs and overwrite:
  - `DEST_PROJECT_PATH=../lync-payments SOURCE_GLOB='docs/specs/**/*.md' DRY_RUN=false OVERWRITE=true`

## Failure handling
- Missing `DEST_PROJECT_PATH`: report and stop.
- Invalid destination path: report and stop.
- Source/destination not `lync-*` git repos: refuse and print `This skill is restricted to lync* projects.`
- No matching files: report and stop.
- Unsafe destination path (path traversal): report and stop.
- Per-file copy errors: continue and report in final summary.

## Guardrails
- Local development use only.
- Never copy files outside destination repo root.
- Never run destructive git commands.
- Default to `DRY_RUN=true` and `OVERWRITE=false` for safety.
