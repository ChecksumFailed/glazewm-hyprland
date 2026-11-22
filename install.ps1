#Requires -Version 5.1
<#
.SYNOPSIS
  Installs GlazeWM + Zebar + Flow Launcher and copies the Hyprland-flavored
  config from this repo into place.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install.ps1

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install.ps1 -NoWinKeys
  Also disables Windows' built-in Win-key shortcuts so SUPER+number etc.
  reach GlazeWM. Needs admin.

.NOTES
  - GlazeWM itself must run elevated (its manifest requires admin). If you
    have no local admin rights (corporate laptop), this setup cannot run.
  - Existing configs are backed up with a timestamp before being replaced.
  - -UnlockWinL disables the Win+L lock shortcut. Don't do this on a work
    machine (lock compliance); Ctrl+Alt+L is bound to lock instead.
#>
param(
    [switch]$SkipApps,
    [switch]$NoWinKeys,
    [switch]$UnlockWinL
)

$ErrorActionPreference = 'Stop'
$repoRoot = $PSScriptRoot
$glzrRoot = Join-Path $HOME '.glzr'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Backup-IfExists([string]$Path) {
    if (Test-Path $Path) {
        $backup = "$Path.$stamp.bak"
        Copy-Item $Path $backup
        Write-Host "  backed up -> $backup"
    }
}

Write-Host "==> GlazeWM Hyprland config installer" -ForegroundColor Cyan

# ---- 1. Apps via winget ----
if (-not $SkipApps) {
    $apps = @(
        @{ Id = 'glzr-io.glazewm'; Name = 'GlazeWM' },
        @{ Id = 'glzr-io.zebar'; Name = 'Zebar' },
        @{ Id = 'Flow-Launcher.Flow-Launcher'; Name = 'Flow Launcher' }
    )
    foreach ($app in $apps) {
        Write-Host "==> Installing $($app.Name) ($($app.Id))" -ForegroundColor Cyan
        # winget exits non-zero when the package is already present; tolerate it.
        winget install --id $app.Id --silent --accept-package-agreements --accept-source-agreements
    }
} else {
    Write-Host "==> Skipping app installs (-SkipApps)" -ForegroundColor Yellow
}

# ---- 2. Config files ----
Write-Host "==> Copying config files to $glzrRoot" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$glzrRoot\glazewm\scripts", "$glzrRoot\zebar" | Out-Null

Backup-IfExists "$glzrRoot\glazewm\config.yaml"
Copy-Item "$repoRoot\glazewm\config.yaml" "$glzrRoot\glazewm\config.yaml"

Copy-Item "$repoRoot\glazewm\scripts\*.ps1" "$glzrRoot\glazewm\scripts\" -Force
Copy-Item "$repoRoot\glazewm\HYPRLAND-CHEATSHEET.md" "$glzrRoot\glazewm\" -Force

Backup-IfExists "$glzrRoot\zebar\settings.json"
Copy-Item "$repoRoot\zebar\settings.json" "$glzrRoot\zebar\settings.json"

if (Test-Path "$glzrRoot\zebar\hypr-bar") {
    Remove-Item "$glzrRoot\zebar\hypr-bar" -Recurse -Force
}
Copy-Item "$repoRoot\zebar\hypr-bar" "$glzrRoot\zebar\hypr-bar" -Recurse

# ---- 3. Optional Windows tweaks (need admin) ----
foreach ($tweak in @(
    @{ On = $NoWinKeys;  Script = 'apply-win-key-fixes.ps1'; What = 'NoWinKeys (free the SUPER key)' },
    @{ On = $UnlockWinL; Script = 'unlock-win-l.ps1';       What = 'DisableLockWorkstation (SUPER+L)' }
)) {
    if ($tweak.On) {
        Write-Host "==> Applying $($tweak.What)" -ForegroundColor Cyan
        if (Test-Admin) {
            & (Join-Path "$glzrRoot\glazewm\scripts" $tweak.Script)
        } else {
            Start-Process powershell -Verb RunAs -Wait -ArgumentList `
                '-ExecutionPolicy', 'Bypass', '-File', (Join-Path "$glzrRoot\glazewm\scripts" $tweak.Script)
        }
    }
}

# ---- 4. Start Zebar ----
if (-not (Get-Process zebar -ErrorAction SilentlyContinue)) {
    Start-Process 'zebar'
    Write-Host "==> Zebar started" -ForegroundColor Cyan
}

# ---- 5. Next steps ----
Write-Host ""
Write-Host "Done. Next steps:" -ForegroundColor Green
Write-Host "  1. Start GlazeWM (it must run elevated)."
Write-Host "  2. Tray -> GlazeWM -> 'Run on system startup'."
Write-Host "  3. Reload config: SUPER+SHIFT+R (or Alt+Shift+R if still on defaults)."
Write-Host "  4. Flow Launcher: change its hotkey off ALT+Space (that's the scratchpad bind)."
Write-Host "  5. Keybinds: .glzr\glazewm\HYPRLAND-CHEATSHEET.md"
Write-Host ""
Write-Host "Work laptop notes:" -ForegroundColor Yellow
Write-Host "  - No local admin => GlazeWM won't run (manifest requires elevation)."
Write-Host "  - Group Policy may override the NoWinKeys tweak. If SUPER+number opens"
Write-Host "    taskbar apps again, unpin everything from the taskbar as a workaround."
Write-Host "  - Skip -UnlockWinL on work machines (lock compliance)."
