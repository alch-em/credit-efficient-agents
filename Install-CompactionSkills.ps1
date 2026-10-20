# Installs optional context-compaction skills without editing existing global rules.
# The runtime configuration is opt-in and never assumes Codex's model window.
[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$EnableClaude50,
    [ValidateRange(1000, 4000000)][int]$CodexContextWindow = 0
)
$ErrorActionPreference = 'Stop'
$skills = @(
  @{ Source = '.claude/skills/context-compaction-manager'; Target = (Join-Path $HOME '.claude/skills/context-compaction-manager') },
  @{ Source = '.agents/skills/context-compaction-manager'; Target = (Join-Path $HOME '.agents/skills/context-compaction-manager') }
)
foreach ($s in $skills) {
    $src = Join-Path $PSScriptRoot $s.Source
    if (!(Test-Path -LiteralPath (Join-Path $src 'SKILL.md'))) { throw "Missing skill: $src" }
    if (Test-Path -LiteralPath $s.Target) {
        Write-Host "SKIP existing skill (review manually): $($s.Target)"
        continue
    }
    if ($DryRun) { Write-Host "WOULD INSTALL SKILL: $($s.Target)"; continue }
    $parent = Split-Path -Parent $s.Target
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    Copy-Item -LiteralPath $src -Destination $s.Target -Recurse -ErrorAction Stop
    Write-Host "INSTALLED SKILL: $($s.Target)"
}
if ($EnableClaude50) {
    $previous = [Environment]::GetEnvironmentVariable('CLAUDE_AUTOCOMPACT_PCT_OVERRIDE','User')
    if ($DryRun) { Write-Host "WOULD SET Claude autocompact override: $previous -> 50" }
    else {
        [Environment]::SetEnvironmentVariable('CLAUDE_AUTOCOMPACT_PCT_OVERRIDE','50','User')
        Write-Host 'SET Claude autocompact override=50 (restart Claude Code)'
    }
}
if ($CodexContextWindow -gt 0) {
    $limit = [math]::Floor($CodexContextWindow / 2)
    $config = Join-Path $HOME '.codex/config.toml'
    if ($DryRun) {
        Write-Host "WOULD CONFIGURE Codex token threshold: $limit in $config"
    } else {
        $parent = Split-Path -Parent $config
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        $current = if (Test-Path -LiteralPath $config) { Get-Content -LiteralPath $config -Raw -Encoding UTF8 } else { '' }
        # For safety, do not attempt a blind TOML rewrite. Root settings must precede the first table.
        $firstTable = [regex]::Match($current, '(?m)^\s*\[\[?')
        $root = if ($firstTable.Success) { $current.Substring(0,$firstTable.Index) } else { $current }
        $tail = if ($firstTable.Success) { $current.Substring($firstTable.Index) } else { '' }
        $matches = [regex]::Matches($current,'(?m)^\s*model_auto_compact_token_limit\s*=')
        if ($matches.Count -gt 1) { throw 'Multiple compaction settings found. Edit manually; no changes made.' }
        if ($matches.Count -eq 1 -and $matches[0].Index -ge $root.Length) {
            throw 'Compaction setting appears inside a TOML table. Edit manually; no changes made.'
        }
        if (Test-Path -LiteralPath $config) {
            $backup = "$config.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss-fffffff')"
            Copy-Item -LiteralPath $config -Destination $backup -ErrorAction Stop
            Write-Host "BACKUP: $backup"
        }
        if ($matches.Count -eq 1) {
            $root = [regex]::Replace($root,'(?m)^\s*model_auto_compact_token_limit\s*=.*$',"model_auto_compact_token_limit = $limit")
        } else {
            $root = "model_auto_compact_token_limit = $limit`r`n" + $root
        }
        Set-Content -LiteralPath $config -Value ($root + $tail) -Encoding UTF8
        Write-Host "SET Codex autocompact token threshold=$limit (restart Codex; validate config)"
    }
}
