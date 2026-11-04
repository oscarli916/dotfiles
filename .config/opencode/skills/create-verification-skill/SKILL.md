---
name: create-verification-skill
description: "Use when /create-verification-skill, \"make a control skill for this repo\"."
disable-model-invocation: true
---

# Create a verification skill

Every serious project needs a scripted way to drive the real app and prove behavior: launch it, exercise a feature the way a user would, and capture evidence. This skill generates a project-specific verification skill in the dotfiles repository, installed globally through GNU Stow. Write the output for the next agent, which may have no prior knowledge of the app.

## Output location and installation

Create all generated verification skills in the dotfiles repository:

```bash
DOTFILES="$HOME/personal/dotfiles"
SKILL_DIR="$DOTFILES/.config/opencode/skills/verify-<app>"
INSTALLED_SKILL="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills/verify-<app>"
```

Replace `<app>` with the project's name before using these paths. Keep the target project's root separate from the dotfiles and installed skill directories.

The dotfiles directory is the source of truth. Keep SKILL.md, feature maps, helpers, and references together under `$SKILL_DIR`. Do not create a project-local `.opencode/skills` copy or write directly into the installed configuration directory.

Read the applicable dotfiles AGENTS.md instructions before writing. Inspect an existing destination before modifying it.

Install the skill using GNU Stow. Preview the changes first:

```bash
stow -n -v -t "$HOME" -d "$DOTFILES" .
```

Apply only changes needed to install the generated skill. If the preview includes unrelated changes or conflicts, narrow the operation with ignore options or ask for guidance. Do not adopt or overwrite existing files. When the preview contains only the intended changes, rerun the same command without `-n`.

For a nondefault `XDG_CONFIG_HOME`, adjust the Stow target and package scope so the link lands at `$INSTALLED_SKILL`. Confirm `$INSTALLED_SKILL` is a symlink resolving to `$SKILL_DIR` before running the proof.

Generated helpers must locate the application independently of their own installation directory. Run them from the target project's root and validate the expected project files before starting resources. Use the skill's installation directory only to locate its own helpers and references. Document helper invocations through `$INSTALLED_SKILL`, not a project-local skill path.

## 1. Interview the repo, not the user

Answer these from the codebase and only ask the user what you cannot observe:

- **Surface:** what does a user actually touch? A web UI, a CLI/TUI, a desktop app, an API, a mobile app, a library? A repo can have several; pick the primary one and note the rest.
- **Run:** how does the app start locally? Prefer the repo's own documented dev command (package scripts, Makefile, README quickstart). Note ports, env vars, seed data, auth.
- **Drive:** how can an agent interact with it programmatically? Existing harnesses first — Playwright/Cypress specs, expect scripts, PTY helpers, curl-able endpoints, a debug port. Only then pick a generic recipe: browser/CDP for web and Electron, a tmux/PTY harness for CLI/TUI, plain HTTP for services.
- **Observe:** what evidence can be captured? Screenshots, terminal transcripts, response bodies, logs, exit codes, DB state.
- **Isolate:** can two instances run side by side (ports, data dirs, profiles)? If not, say so in the generated skill: refusing to double-drive a shared instance beats corrupting the user's session.

If the checkout doesn't build or start as-is, fix that first (or report it precisely) before generating; a skill written against a broken base teaches wrong steps. When an irrelevant missing asset blocks startup (a static dir the API never serves, a sample config), the generated skill may create it, clearly marked as verification scaffolding, and remove it in cleanup.

## 2. Generate the skill

Write `$SKILL_DIR/SKILL.md` with YAML frontmatter containing `name: verify-<app>` and a `description` that names the app, its user-facing interface, and when to use the skill. Replace `<app>` with the project's name. Include these sections, grounded in what the interview found, with no placeholders left:

- **Launch:** the exact command that starts the app for verification, and how to tell it's ready (a log line, a prompt). Launch must reach a usable state from an empty data dir, including any migrations and seed data. Ready means usable, not just that a process answers. A database health check can pass while its init scripts are still running. Include teardown. For a short-lived CLI or TUI there is no server to keep alive: launch means build the binary (or install deps) once, then start each drive in its own isolated PTY or tmux session.
- **Doctor:** one read-only check that answers "is this instance worth driving?" — process up, right version/build, port owned by us, auth valid. An agent runs this first whenever anything looks off.
- **Drive:** the harness recipe with real selectors/commands from this repo, not examples. Prefer stable handles (ARIA labels, data attributes, prompt strings, route paths) over coordinates and tab order.
- **Evidence:** what to capture for a proof and where it goes. State the proof standards: exercise the real user path, not internal setters or test-only endpoints; capture the action and the resulting state, not just the final screen; verify side effects (files written, rows inserted, messages sent) alongside what's visible; mocks only where a production boundary already isolates the external system. When the safe path is a dry-run or test mode, verify what it actually skips by observing (files, network, git refs) rather than trusting its name: some dry-runs still touch the network or open a browser.
- **Cleanup:** how to tear down instances the run created. Never kill by process name; kill what you started. Cleanup removes instances and scratch state, never the evidence: proof artifacts survive the teardown, in a location the skill names.
- **Helpers:** any script the skill ships is executable and its invocation is shown in the skill body. A helper the reader has to reverse-engineer is not a helper.

## 3. Seed the feature map

Create `$SKILL_DIR/features/README.md` plus one file per user-facing feature you can identify (aim for the top 3-5 to start, from routes, commands, menus, or docs). Follow the shape in [`references/feature-map-example/`](references/feature-map-example/), with a README index and one file per feature. Each file answers, from the user's point of view: what the feature is, how to reach it, how to drive it with the harness, and what observable end state proves it works. The four H2s are `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`. If the seed data lacks a precondition that a journey needs, the journey reports a failure and the reason goes in that feature's `Gotchas`. Never weaken the journey to make it pass. The map is the project's maintained verification source; a proof that drives one convenient entry point is incomplete when the map lists others.

## 4. Prove the generated skill before handing it over

Install the generated skill through Stow before proving it. Run the documented instructions through `$INSTALLED_SKILL` from the target project's root. Verification must prove the symlinked installation works, not only the files in the dotfiles checkout.

Run its own instructions end to end once: launch, doctor, drive ONE mapped feature (one is enough; the map exists so later runs can cover the rest), capture evidence, clean up. After cleanup, confirm the evidence still exists at the named location — a cleanup that eats the proof fails this step. Fix what fails, and run the generated cleanup after every failed iteration too, so broken attempts don't strand processes and ports. A generated skill that was never executed is a draft, not a deliverable. If you proved it in a stand-in for the real target (a container in place of a fresh VM, a local stack in place of a remote one), list every setup step the stand-in did that the target will not. Those steps stay unverified until a run on the real target covers them.

## 5. Offer the maintenance loop

Point the user at `/maintain-verification-skill` for keeping the map honest as the app changes. Suggest a cadence only if they ask.
