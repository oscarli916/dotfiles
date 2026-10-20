---
name: playwright-test
description: "Test frontend changes through Playwright MCP and report the results."
disable-model-invocation: true
---

Test the frontend changes on the current branch using the Playwright MCP browser tools.

Review the branch's commits and diff from its merge-base with the default branch, plus uncommitted changes. Read relevant code to identify affected user flows. Follow any scope the user provides.

Before testing, list the manual frontend checks you will perform, with actions and expected results. Cover the changed behavior and relevant edge cases. If no frontend behavior is affected, say so and stop.

Run the app locally using the project's documented setup. Reuse running services and start any required backend dependencies.

Perform every check through the browser. A check passes only when you observe the expected behavior. Capture screenshots, console messages, or network requests where they help explain a failure. If a prerequisite is missing, mark the check as blocked and continue with the others.

Stop services you started unless the user asks to keep them running.

Finish with a results table accounting for every planned check as passed, failed, or blocked. Include reproduction steps and evidence for failures, and explain blockers. Leave implementation fixes for a separate request.
