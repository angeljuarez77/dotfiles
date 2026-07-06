# dnvim — portable Neovim via Docker (Windows PowerShell)
# Usage: dnvim [file...]
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$NvimArgs
)

$ErrorActionPreference = "Stop"

$Image = if ($env:DNVIM_IMAGE) { $env:DNVIM_IMAGE } else { "angeljuarez77/dnvim:latest" }
$Puid = if ($env:PUID) { $env:PUID } else { "1000" }
$Pgid = if ($env:PGID) { $env:PGID } else { "1000" }

function Get-RestArgs([string[]]$All) {
  if ($All.Count -le 1) { return @() }
  return $All[1..($All.Count - 1)]
}

function Get-AbsPath([string]$Path) {
  $expanded = [Environment]::ExpandEnvironmentVariables(
    $Path.Replace('~', $env:USERPROFILE)
  )

  if (Test-Path -LiteralPath $expanded) {
    return (Resolve-Path -LiteralPath $expanded).Path
  }

  $parent = Split-Path -Parent $expanded
  $leaf = Split-Path -Leaf $expanded

  if (-not $parent) {
    $parent = (Get-Location).Path
  }
  elseif (Test-Path -LiteralPath $parent) {
    $parent = (Resolve-Path -LiteralPath $parent).Path
  }
  else {
    $parent = (Get-Location).Path
  }

  return (Join-Path $parent $leaf)
}

function Find-Workspace([string]$Dir) {
  $prev = $ErrorActionPreference
  $ErrorActionPreference = "SilentlyContinue"
  $root = & git -C $Dir rev-parse --show-toplevel 2>$null
  $ErrorActionPreference = $prev

  if ($LASTEXITCODE -eq 0 -and $root) {
    return $root
  }
  return $Dir
}

$Workspace = $null
$ResolvedArgs = @()

if (-not $NvimArgs -or $NvimArgs.Count -eq 0) {
  $Workspace = (Get-Location).Path
}
else {
  $first = $NvimArgs[0]

  if ($first.StartsWith("-") -or $first.StartsWith("+")) {
    $Workspace = (Get-Location).Path
    $ResolvedArgs = $NvimArgs
  }
  elseif ((Test-Path -LiteralPath $first) -or (Test-Path -LiteralPath (Join-Path (Get-Location) $first))) {
    $localAbs = Get-AbsPath $first

    if (Test-Path -LiteralPath $localAbs -PathType Container) {
      $Workspace = Find-Workspace $localAbs
      $rel = $localAbs.Substring($Workspace.Length).TrimStart('\', '/')
      if (-not $rel) { $rel = "." }
      $ResolvedArgs = @(,$rel) + (Get-RestArgs $NvimArgs)
    }
    else {
      $parent = Split-Path -Parent $localAbs
      $Workspace = Find-Workspace $parent
      $rel = $localAbs.Substring($Workspace.Length).TrimStart('\', '/')
      if (-not $rel) { $rel = Split-Path -Leaf $localAbs }
      $ResolvedArgs = @(,$rel) + (Get-RestArgs $NvimArgs)
    }
  }
  else {
    $parent = Get-AbsPath (Split-Path -Parent $first)
    $Workspace = Find-Workspace $parent
    $rel = $parent.Substring($Workspace.Length).TrimStart('\', '/')
    $leaf = Split-Path -Leaf $first

    if ($rel) {
      $ResolvedArgs = @(,"$rel/$leaf".Replace('\', '/')) + (Get-RestArgs $NvimArgs)
    }
    else {
      $ResolvedArgs = @(,$leaf) + (Get-RestArgs $NvimArgs)
    }
  }
}

$Workspace = Get-AbsPath $Workspace

$dockerArgs = @(
  "run", "--rm", "-it",
  "--pull", "missing",
  "-e", "PUID=$Puid",
  "-e", "PGID=$Pgid",
  "-e", "DNVIM_CONTAINER=1",
  "-v", "${Workspace}:/workspace",
  "-w", "/workspace",
  $Image,
  "nvim"
) + $ResolvedArgs

& docker @dockerArgs
exit $LASTEXITCODE
