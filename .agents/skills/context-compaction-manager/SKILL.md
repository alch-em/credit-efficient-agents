---
name: context-compaction-manager
description: Manage Codex conversation context and compaction for long coding tasks; verify actual context-window size, set or inspect auto-compaction configuration, preserve concise handoffs, and benchmark token usage. Use when configuring automatic compaction, investigating growing context, or transferring an unfinished implementation between sessions.
---

# Context Compaction Manager — Codex

1. Automatic compaction is controlled by the Codex runtime, **not** by instructions inside a skill. Do not claim this skill autonomously monitors context or triggers compaction.
2. Before changing configuration, inspect the active model and its real context window. Never assume Claude's 1M context window is also Codex's. Ask for the actual window if unavailable; never guess.
3. The Codex user config is `~/.codex/config.toml`. Its `model_auto_compact_token_limit` is an **absolute token count**, not a percentage. For a 50% target, compute floor(confirmed_context_window * 0.5). If the chosen model changes, recalculate.
4. Back up the existing config, preserve its unrelated keys/tables and all user overrides, and preview edits before saving. Do not overwrite the whole TOML file. Configuration changes require user approval.
5. At meaningful checkpoints, preserve the exact task goal, current branch/working-tree state, edited paths, remaining steps, important decisions, tests already passed/failed, and security constraints in a short handoff. Refer to repository `SESSION_HANDOFF.md` when available.
6. After compaction, read the handoff, then inspect only missing code dependencies rather than restarting broad repository exploration.
7. Benchmark 50% against a less aggressive threshold (for example 70%) on comparable tasks. Record quality and total consumption, including recap and re-read costs. Do not promise measured savings without data.
8. Never skip correctness checks or perform deployment, commits, pushes, restarts, or secret modifications without explicit approval.

References:
- https://developers.openai.com/codex/config-reference
- https://developers.openai.com/blog/skills-agents-sdk
