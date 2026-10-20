# Automatic context compaction for Claude Code and Codex

**Goal:** optional early compaction at 50% context consumption. This is an experiment, not a proven credit-savings percentage. A skill does not run a continuous watcher; native agent runtimes perform compaction after configuration.

## Claude Code

Claude Code supports an override measured in *percentage of the configured auto-compaction window*. In Windows PowerShell:

```powershell
[Environment]::SetEnvironmentVariable('CLAUDE_AUTOCOMPACT_PCT_OVERRIDE', '50', 'User')
[Environment]::GetEnvironmentVariable('CLAUDE_AUTOCOMPACT_PCT_OVERRIDE', 'User')
```

Restart Claude Code. Use `/context` to monitor usage. Check for conflicts with `DISABLE_AUTO_COMPACT`, `DISABLE_COMPACT`, and `CLAUDE_CODE_AUTO_COMPACT_WINDOW` if the behavior is different than expected. Do not assume the setting took effect simply because it exists.

To remove the override: `[Environment]::SetEnvironmentVariable('CLAUDE_AUTOCOMPACT_PCT_OVERRIDE', $null, 'User')`.

## Codex

The user config file is `~/.codex/config.toml`. Read your active model's **verified** context window first. Codex's `model_auto_compact_token_limit` is a token count, not a percentage. For example, if your actual Codex model supports **200000 tokens**, an illustrative 50% threshold is:

```toml
model_auto_compact_token_limit = 100000
```

If the **actual Codex** model instead supports 1M tokens, the equivalent would be 500000. These numbers are **examples only**. The Claude Code /context screenshot cannot establish Codex's window. Back up `config.toml` and edit only this root-level key; never replace existing model/provider/MCP settings. If this key already exists, update it in place rather than duplicating it. Recheck if you change models. Confirm support using the installed Codex version.

## Skills

- Repo-local Codex skill: `.agents/skills/context-compaction-manager/SKILL.md`
- Repo-local Claude Code skill: `.claude/skills/context-compaction-manager/SKILL.md`

To make them available **globally**, copy the respective skill folder into `~/.agents/skills/context-compaction-manager` (Codex) and `~/.claude/skills/context-compaction-manager` (Claude Code), reviewing existing destinations before replacing anything. Installing a skill does not itself set native compaction options.

## Evaluation

Compare comparable implementations at 50% and 70%; track successful results, context/usage as provided by the tools, re-reading costs, and compaction frequency. Compaction may consume tokens and is not equivalent to credit or subscription usage reduction.

Official references:
- https://code.claude.com/docs/en/env-vars
- https://developers.openai.com/codex/config-reference
- https://developers.openai.com/blog/skills-agents-sdk
