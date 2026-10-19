# Focused implementation request

## Goal
[Exactly what must change; measurable acceptance criteria.]

## Verified file/function map
- [path: function — required change]
- [path: function — integration dependency]

## Guardrails
- Implement and test only. Avoid planning documents, broad repo exploration, unrelated refactors, and needless subagents.
- Inspect named files first and only read nearby dependencies as required for correctness.
- Preserve existing interfaces, behavior, and unrelated working-tree changes.
- Never commit, push, deploy, restart, or modify production/secrets without explicit authorization.

## Validation
- Focused tests while coding: [commands]
- Required final regression suite: [command]
- Required final production build: [command]
- Run successful checks once unless a later relevant change warrants rechecking.

## Handoff
Concise summary: files changed, behavior delivered, tests and outcomes, unresolved issues. Stop.
