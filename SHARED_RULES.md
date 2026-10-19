<!-- CREDIT-EFFICIENT-WORKFLOW:START -->
## Credit-efficient execution rules
- Act as an implementer and tester for the approved task. Do not redo architecture, broad planning, or repository surveys already supplied in the task brief.
- Inspect only named files, relevant symbols, and dependencies needed for correctness. If a path is stale, perform narrow discovery rather than guessing.
- Avoid re-reading unchanged files, re-discovering known tools or skills, speculative refactors, unnecessary subagents, and verbose command output.
- Preserve existing behavior, public APIs, user-facing copy, tests, and unrelated working-tree changes unless the task explicitly requires changes.
- Prefer focused tests during implementation. Run the required full regression suite and production build **once at the end**; rerun only checks affected by subsequent fixes. Never skip necessary security or correctness checks.
- Do not commit, push, deploy, restart services, alter production, or change secrets without explicit user authorization.
- Report only: modified files, completed behavior, tests/results, risks/blockers, and any work not verified.
- If a supplied instruction conflicts with evidence from the code, verify and report the mismatch; correctness and security take precedence over credit savings.
<!-- CREDIT-EFFICIENT-WORKFLOW:END -->
