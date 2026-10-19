# Installs an additive marked policy into current user's Claude Code and Codex global instruction files.
# Never overwrites existing content. Creates timestamped backups for existing files.
# Run explicitly from a trusted PowerShell session; no installations, network requests, or services involved.
param([switch]$DryRun)
$ErrorActionPreference = 'Stop'
$snippetPath = Join-Path $PSScriptRoot 'SHARED_RULES.md'
$snippet = Get-Content -LiteralPath $snippetPath -Raw -Encoding UTF8
$targets = @(
    (Join-Path $HOME '.claude/CLAUDE.md'),
    (Join-Path $HOME '.codex/AGENTS.md')
)
foreach ($path in $targets) {
    if (Test-Path -LiteralPath $path) {
        $existing = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        $hasStart = $existing.Contains('<!-- CREDIT-EFFICIENT-WORKFLOW:START -->')
        $hasEnd = $existing.Contains('<!-- CREDIT-EFFICIENT-WORKFLOW:END -->')
        if ($hasStart -ne $hasEnd) { throw "Incomplete marked block in $path. Review manually." }
        if ($hasStart) { Write-Host "SKIP already present: $path"; continue }
    }
    if ($DryRun) { Write-Host "WOULD APPEND: $path"; continue }
    $parent = Split-Path -Path $path -Parent
    if (!(Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path -LiteralPath $path) {
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss-fffffff'
        Copy-Item -LiteralPath $path -Destination "$path.backup-$timestamp" -ErrorAction Stop
        $old = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        Set-Content -LiteralPath $path -Value ($old.TrimEnd() + "`r`n`r`n" + $snippet) -Encoding UTF8
    } else {
        Set-Content -LiteralPath $path -Value $snippet -Encoding UTF8
    }
    Write-Host "INSTALLED: $path"
}
