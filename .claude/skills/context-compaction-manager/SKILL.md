---
name: context-compaction-manager
description: Optimize Claude Code long-session context by checking context usage, configuring the supported 50% autocompact threshold, creating small task handoffs, and comparing token savings. Use when users request automatic compaction, context troubleshooting, or safe continuation after compaction.
---

# Context Compaction Manager — Claude Code

1. Use `/context` (when available) to inspect usage. Context percentage measures consumed **context window**, not subscription credits.
2. Claude Code supports `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50` to request an earlier auto-compaction threshold. This is a runtime environment setting; instructions inside a skill cannot implement an automatic context watcher. Check version support and verify observed behavior.
3. On Windows PowerShell, configure persistently with:
   `[Environment]::SetEnvironmentVariable("CLAUDE_AUTOCOMPACT_PCT_OVERRIDE", "50", "User")`
   Restart Claude Code for the new process to inherit it. Verify the saved variable; this alone does not prove it triggered.
4. Check `DISABLE_AUTO_COMPACT`, `DISABLE_COMPACT`, and `CLAUDE_CODE_AUTO_COMPACT_WINDOW` only if actual behavior disagrees with the configured threshold. Do not silently modify other settings.
5. Before manual `/compact`, summarize active objective, verified file/function map, edited files, test results, outstanding blockers, and constraints. Use `/clear` for unrelated tasks rather than compacting irrelevant history.
6. After compaction, preserve accuracy: inspect only missing details and dependencies, not the entire repository.
7. Compare 50% vs 70% in real workloads before claiming savings. Excessive compaction may cause context-recovery work and lose useful detail.
8. Never alter production, restart services, commit, push, or modify secrets without user approval.

Reference: https://code.claude.com/docs/en/env-vars
