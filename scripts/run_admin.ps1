# Doc-Find: Run Admin Web Dashboard (Vite / Vue 3)
$ErrorActionPreference = "Stop"
Write-Host "[Doc-Find] Starting Vue 3 Admin Dashboard on http://localhost:5173..." -ForegroundColor Cyan
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptDir/../apps/admin"
npm run dev
