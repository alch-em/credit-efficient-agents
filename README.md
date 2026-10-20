# Credit-Efficient Agents

**Make Claude Code and OpenAI Codex spend effort on implementation—not repeated exploration.**

A free, open-source set of **global agent instructions**, a **PowerShell installer**, and **reusable task/handoff templates**. Designed for developers using both Claude Code and Codex, but the principles are useful for other coding agents too.

> [!IMPORTANT]
> This toolkit is a workflow, **not a token optimizer or billing integration**. Savings vary by repository, model, task, and how you write briefs. It does not guarantee a particular percentage or prevent all usage charges. Never sacrifice security, correctness, or necessary tests to save tokens.

## What changes?

| Without a focused brief | With this workflow |
| --- | --- |
| Agent repeatedly surveys the whole repository | Agent starts with a supplied, **verified** file/function map |
| Same architecture discussed in each session | Research and decisions are settled before implementation |
| Agent rereads unchanged files and rediscovers tools | Targeted reads and known tools are reused |
| Builds/test suites repeated unnecessarily | Focused tests during coding; required full suite/build at final validation |
| Long context is carried to unrelated tasks | Minimal handoff and new session for new task |

## Quick start — Windows PowerShell

**Requirements:** Claude Code and/or OpenAI Codex already installed; PowerShell on Windows. No external dependencies, network requests, or administrator rights required by the installer.

1. Download this repository (GitHub **Code → Download ZIP**), extract it, and open **PowerShell** inside the `credit-efficient-agents` folder.
2. Preview the destinations **without modifying anything**:

   ```powershell
   .\Install-GlobalRules.ps1 -DryRun
   ```

3. Inspect [`SHARED_RULES.md`](SHARED_RULES.md) and [`Install-GlobalRules.ps1`](Install-GlobalRules.ps1). Install only if you agree:

   ```powershell
   .\Install-GlobalRules.ps1
   ```

4. Your global agent instructions are now appended to:

   | Agent | User-level instruction file |
   | --- | --- |
   | Claude Code | `~/.claude/CLAUDE.md` |
   | Codex | `~/.codex/AGENTS.md` |

5. Restart **new agent sessions** so they pick up the updated instructions. Open these files to confirm your existing rules are intact and to review any conflicts.

**Already installed?** Running the installer again skips files containing the marked block. To update the policy, first remove the old marked section manually, review the new policy, then reinstall. Backups are created for files that existed before an install; new destination files do not have a prior backup.

> If PowerShell blocks scripts, see [Windows script execution help](docs/TROUBLESHOOTING.md). Do not blindly bypass security policy. Read and trust the script before choosing an appropriate execution option.

## macOS, Linux, and WSL (manual setup)

The included PowerShell installer targets Windows user paths. For manual setup, open [`SHARED_RULES.md`](SHARED_RULES.md), then **append** its full contents to the relevant file (create it if missing):

- Claude Code: `~/.claude/CLAUDE.md`
- Codex: `~/.codex/AGENTS.md`

Back up existing files first. Do **not** replace their contents. Run setup separately for each operating system/user environment (for example, Windows vs WSL or a remote server). The marked section makes later removal easy.

## Daily workflow

1. **Research first.** Ask a planning assistant (or do the research yourself) to inspect your project and provide the real filenames, functions, dependencies, acceptance criteria, and relevant test commands. **Never invent verified paths.**
2. **Make one small task.** Fill out [`TASK_TEMPLATE.md`](TASK_TEMPLATE.md). Give your coding agent the specific scope and confirmed map.
3. **Implement and validate.** Use focused tests while changing code. At the end, run the required full regression suite and production build once, if appropriate for your project. Re-run checks when changes could invalidate them; don't skip needed security checks.
4. **Handoff when needed.** Use [`SESSION_HANDOFF.md`](SESSION_HANDOFF.md) at meaningful checkpoints or when switching agents.
5. **Review changes.** Humans approve commits, pushes, restarts, production changes, and secrets updates separately.

### Copy-and-paste task example

```text
Goal: Fix the broken channel picker search without changing permission behavior.
Verified file/function map:
- src/ui/ChannelPicker.tsx: ChannelPicker — add a searchable filter.
- src/ui/ChannelPicker.test.tsx: picker tests — cover 100+ options.
Guardrails:
- Inspect these files first; expand scope only for a necessary dependency.
- Preserve existing permissions and selected values.
- Do not commit, push, deploy, restart, or change secrets.
Validation:
- Focused: npm test -- ChannelPicker
- Final: npm test and npm run build (once after implementation)
Handoff: changed files, behavior, results, risks.
```

*The example paths and commands are illustrative, **not verified against your repository**.*

## Files

| File | Purpose |
| --- | --- |
| [`SHARED_RULES.md`](SHARED_RULES.md) | Small marked global instruction block for both agents |
| [`Install-GlobalRules.ps1`](Install-GlobalRules.ps1) | Windows append-only installer with dry-run and backups |
| [`Uninstall-GlobalRules.ps1`](Uninstall-GlobalRules.ps1) | Removes only the marked block; backs up existing files first |
| [`TASK_TEMPLATE.md`](TASK_TEMPLATE.md) | Bounded implementation prompt |
| [`SESSION_HANDOFF.md`](SESSION_HANDOFF.md) | Small context handoff between sessions/tools |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | Installation, updates, script policies, and conflicts |
| [`docs/MEASURE_SAVINGS.md`](docs/MEASURE_SAVINGS.md) | How to evaluate usage fairly |

## Optional: 50% context-compaction skills

Two small, on-demand skills are included for Claude Code and Codex:

- [Claude Code skill](.claude/skills/context-compaction-manager/SKILL.md)
- [Codex skill](.agents/skills/context-compaction-manager/SKILL.md)

These are **workflow skills**, not autonomous daemons. The underlying tools must implement compaction. To install both skills globally from an extracted checkout, first preview:

```powershell
.\Install-CompactionSkills.ps1 -DryRun -EnableClaude50
```

Then run `.\Install-CompactionSkills.ps1 -EnableClaude50` to install both skills and opt into Claude's 50% threshold. The installer **does not change Codex's config unless** you provide the verified context window for your actual Codex model, e.g. `-CodexContextWindow 200000` for a confirmed 200K model (which sets a 100K token threshold). Do not reuse Claude's 1M window for Codex without checking.

Existing skill directories are preserved rather than overwritten. Codex config is backed up before changes. Restart affected agents after installing. For prerequisites, caveats, manual rollback, and measurement, read [Automatic context compaction](docs/AUTO_COMPACTION.md).

## Claude Code tips

Use `/context` to identify context overhead, `/compact` for a continuing long task, and `/clear` when switching to an unrelated task. Avoid mechanically running these commands when not needed. Command support may vary by installed version.

## Uninstall

Preview:

```powershell
.\Uninstall-GlobalRules.ps1 -DryRun
```

Remove just this project's marked policy (preserving any other instructions):

```powershell
.\Uninstall-GlobalRules.ps1
```

For macOS/Linux/WSL, manually delete the section from `<!-- CREDIT-EFFICIENT-WORKFLOW:START -->` through `<!-- CREDIT-EFFICIENT-WORKFLOW:END -->` (inclusive), leaving other content intact. See [troubleshooting](docs/TROUBLESHOOTING.md).

## Safety and privacy

The scripts edit **only user-level instruction files**, not your project repos, credentials, system services, or agent configurations beyond those files. They don't send data to a network endpoint. However, global agent instructions can affect how agents behave across projects, so review them before installing. **User/project-specific rules and safety-critical validation may override these suggestions.**

## Contributing

Suggestions, bug reports, docs fixes, and supported-platform installers are welcome. Read [`CONTRIBUTING.md`](CONTRIBUTING.md). Contributions should retain safe defaults, explicitly distinguish tested behavior from examples, and avoid unverified savings claims.

## License

MIT — see [`LICENSE`](LICENSE).
