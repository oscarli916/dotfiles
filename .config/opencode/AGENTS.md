I'm Oscar. I value simple solutions to complex problems.

## Working preferences

- Apply the `unslop` skill to every response.
- Ask for my explicit approval before committing directly to `main`.
- Ask before destructive actions I have not explicitly requested.
- Propose bold ideas when they would meaningfully simplify the work.
- Always use `semantic commit` standard when writing commit messages.

## Coding preferences

- Keep solutions simple. Follow YAGNI unless I ask otherwise.
- Write self-explanatory code with clear names and straightforward structure. Do not add code comments. If code needs an explanation, refactor it until its intent is clear.
- Write focused tests that verify meaningful behavior. Avoid redundant smoke tests and tests that merely confirm deleted features are gone.

## Response formatting

- When linking to local HTML files, use a clickable `file://` URL with the absolute path, such as [report.html](file:///tmp/opencode/report.html).

BAD

> ❌ /tmp/opencode/link-test.html

GOOD

> ✅ file:///tmp/opencode/link-test.html
