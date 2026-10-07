<#
.SYNOPSIS
Rebuilds the gitignored .agents/skills discovery shim on Windows.

.DESCRIPTION
Creates one junction per skill folder in .agents/skills so tools find each
skill as .agents/skills/<name>/SKILL.md. Sources are .team_manifest/skills and
.local_manifest/skills (whichever exist). Safe to re-run; run it again after
adding, renaming, or removing a skill, and after every clone.
#>
$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$shim = Join-Path $root '.agents\skills'
$sources = @('.team_manifest\skills', '.local_manifest\skills') |
  ForEach-Object { Join-Path $root $_ } | Where-Object { Test-Path -LiteralPath $_ }

if (-not (Test-Path -LiteralPath (Join-Path $root '.local_manifest'))) {
  throw ".local_manifest is missing or is a dangling link under $root"
}

function Test-IsLink($item) {
  [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

# Collect first so a duplicate name aborts before anything is changed.
$skills = @()
foreach ($src in $sources) {
  foreach ($dir in Get-ChildItem -LiteralPath $src -Directory) {
    $skillFile = Join-Path $dir.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile)) {
      Write-Warning "Skipping $($dir.FullName): no SKILL.md"
      continue
    }
    $declared = Get-Content -LiteralPath $skillFile -TotalCount 20 |
      Select-String -Pattern '^name:\s*["'']?([^"''\s]+)' | Select-Object -First 1
    if ($declared -and $declared.Matches[0].Groups[1].Value -ne $dir.Name) {
      Write-Warning "${skillFile}: name '$($declared.Matches[0].Groups[1].Value)' does not match folder '$($dir.Name)'; tools may not load it"
    }
    $skills += [pscustomobject]@{ Name = $dir.Name; Path = $dir.FullName }
  }
}

$dupes = $skills | Group-Object Name | Where-Object { $_.Count -gt 1 }
if ($dupes) {
  $dupes | ForEach-Object {
    Write-Error "Duplicate skill '$($_.Name)': $(($_.Group.Path) -join ', ')" -ErrorAction Continue
  }
  throw 'Skill folder names must be unique across .team_manifest and .local_manifest.'
}

New-Item -ItemType Directory -Force -Path $shim | Out-Null

# Remove only links this script owns: legacy local/team, manifest targets, or dangling.
foreach ($item in Get-ChildItem -LiteralPath $shim -Force) {
  if (-not (Test-IsLink $item)) { continue }
  $target = [string]($item.Target | Select-Object -First 1)
  $owned = $item.Name -in 'local', 'team' -or
    $target -match '[\\/]\.(team|local)_manifest[\\/]skills' -or
    -not (Test-Path -LiteralPath $item.FullName)
  if ($owned) { [IO.Directory]::Delete($item.FullName, $false) }
}

foreach ($skill in $skills) {
  $link = Join-Path $shim $skill.Name
  if (Test-Path -LiteralPath $link) {
    Write-Warning "Skipping $($skill.Name): $link already exists and is not a manifest link"
    continue
  }
  New-Item -ItemType Junction -Path $link -Target $skill.Path | Out-Null
  Write-Host "linked $($skill.Name) -> $($skill.Path)"
}

Write-Host "Done: $($skills.Count) skill(s) found."
