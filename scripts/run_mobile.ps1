# Doc-Find: Run Flutter Mobile App
$ErrorActionPreference = "Stop"
Write-Host "[Doc-Find] Starting Flutter app on active device / emulator..." -ForegroundColor Cyan
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptDir/../apps/mobile"
flutter run
