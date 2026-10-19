# Remove only the marked credit-efficient policy block; preserve other global instructions.
# This script makes timestamped backups before each actual modification.
param([switch]$DryRun)
$ErrorActionPreference = 'Stop'
$startMarker = '<!-- CREDIT-EFFICIENT-WORKFLOW:START -->'
$endMarker = '<!-- CREDIT-EFFICIENT-WORKFLOW:END -->'
$targets = @(
    (Join-Path $HOME '.claude/CLAUDE.md'),
    (Join-Path $HOME '.codex/AGENTS.md')
)
foreach ($path in $targets) {
    if (!(Test-Path -LiteralPath $path)) { Write-Host "SKIP missing: $path"; continue }
    $old = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $starts = ([regex]::Matches($old, [regex]::Escape($startMarker))).Count
    $ends = ([regex]::Matches($old, [regex]::Escape($endMarker))).Count
    if ($starts -eq 0 -and $ends -eq 0) { Write-Host "SKIP not installed: $path"; continue }
    if ($starts -ne 1 -or $ends -ne 1) { throw "Malformed or duplicate marked blocks in $path. Review manually." }
    $pattern = '(?s)' + [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
    if (![regex]::IsMatch($old, $pattern)) { throw "Invalid marker order in $path. Review manually." }
    if ($DryRun) { Write-Host "WOULD REMOVE marked policy: $path"; continue }
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss-fffffff'
    Copy-Item -LiteralPath $path -Destination "$path.backup-$timestamp" -ErrorAction Stop
    $new = [regex]::Replace($old, $pattern, '', 1)
    $new = $new.TrimEnd("`r", "`n")
    if ($new.Length -gt 0) { $new += "`r`n" }
    Set-Content -LiteralPath $path -Value $new -Encoding UTF8 -NoNewline
    Write-Host "REMOVED marked policy: $path"
}
