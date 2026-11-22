# Disables the Win+L workstation-lock shortcut so SUPER+L can reach GlazeWM
# (focus-right in the HJKL scheme). The OS intercepts lwin+l otherwise.
# Lock your session with Ctrl+Alt+L instead (bound in config.yaml).
#
# Run:  powershell -ExecutionPolicy Bypass -File unlock-win-l.ps1
# Undo: set the value to 0 (or delete it) and re-run.

$Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
$Name = 'DisableLockWorkstation'

if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}
New-ItemProperty -Path $Path -Name $Name -Value 1 -PropertyType DWORD -Force | Out-Null

Write-Host 'Win+L lock disabled. SUPER+L will now reach GlazeWM.'
Write-Host 'Sign out/in (or reboot) for it to take full effect.'
