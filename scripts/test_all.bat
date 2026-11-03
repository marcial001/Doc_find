@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo [Doc-Find] Running Complete Monorepo Test Suite
echo ===================================================

echo [1/3] Testing Backend API (services/api)...
cd /d "%~dp0..\services\api"
".venv\Scripts\pytest.exe" --cov=src -q
if %errorlevel% neq 0 (
    echo [ERROR] Backend tests failed!
    exit /b 1
)

echo.
echo [2/3] Testing Admin Web Dashboard (apps/admin)...
cd /d "%~dp0..\apps\admin"
call npm run test
if %errorlevel% neq 0 (
    echo [ERROR] Admin dashboard tests failed!
    exit /b 1
)

echo.
echo [3/3] Testing Flutter Mobile App (apps/mobile)...
cd /d "%~dp0..\apps\mobile"
call flutter test
if %errorlevel% neq 0 (
    echo [ERROR] Flutter mobile tests failed!
    exit /b 1
)

echo.
echo ===================================================
echo [Doc-Find] ALL MONOREPO TEST SUITES PASSED!
echo ===================================================
cd /d "%~dp0.."
