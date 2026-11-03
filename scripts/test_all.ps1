# Doc-Find: Run Complete Monorepo Test Suite
$ErrorActionPreference = "Stop"

Write-Host "===================================================" -ForegroundColor Green
Write-Host "[Doc-Find] Running Complete Monorepo Test Suite" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "`n[1/3] Testing Backend API (services/api)..." -ForegroundColor Cyan
Set-Location "$scriptDir/../services/api"
& ".\.venv\Scripts\pytest.exe" --cov=src -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Backend tests failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n[2/3] Testing Admin Web Dashboard (apps/admin)..." -ForegroundColor Cyan
Set-Location "$scriptDir/../apps/admin"
npm run test
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Admin dashboard tests failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n[3/3] Testing Flutter Mobile App (apps/mobile)..." -ForegroundColor Cyan
Set-Location "$scriptDir/../apps/mobile"
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Flutter mobile tests failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n===================================================" -ForegroundColor Green
Write-Host "[Doc-Find] ALL MONOREPO TEST SUITES PASSED! (188+ Tests)" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Set-Location "$scriptDir/.."
