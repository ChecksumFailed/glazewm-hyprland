# Sets NoWinKeys=1 (disables Windows' built-in Win-key shortcuts so GlazeWM
# can own SUPER+number etc.). Needs elevation because HKCU\...\Policies is
# ACL-locked to Administrators/SYSTEM on this machine.
#
# Run elevated:  powershell -ExecutionPolicy Bypass -File apply-win-key-fixes.ps1
# Revert:        set NoWinKeys to 0 (or delete it), restart Explorer.

$ErrorActionPreference = 'Stop'
$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$log = Join-Path $PSScriptRoot 'win-key-fixes-backup.txt'

"user: $env:USERDOMAIN\$env:USERNAME" | Set-Content $log
"time: $(Get-Date -Format o)" | Add-Content $log

if (-not (Test-Path $path)) {
    New-Item -Path $path -Force | Out-Null
    "prior: (key did not exist)" | Add-Content $log
} else {
    $prior = Get-ItemProperty -Path $path -Name NoWinKeys -ErrorAction SilentlyContinue
    if ($null -ne $prior) {
        "prior: NoWinKeys = $($prior.NoWinKeys)" | Add-Content $log
    } else {
        "prior: NoWinKeys not set" | Add-Content $log
    }
}

New-ItemProperty -Path $path -Name NoWinKeys -Value 1 -PropertyType DWORD -Force | Out-Null
"now:   NoWinKeys = $((Get-ItemProperty -Path $path -Name NoWinKeys).NoWinKeys)" | Add-Content $log

# Refresh the policy for the running shell without a full sign-out.
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) {
    Start-Process explorer
}
"explorer restarted" | Add-Content $log
