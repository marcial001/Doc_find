# Doc-Find: Run Backend FastAPI Service (Uvicorn)
$ErrorActionPreference = "Stop"
Write-Host "[Doc-Find] Starting FastAPI backend on http://localhost:8000..." -ForegroundColor Cyan
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptDir/../services/api"

if (-not (Test-Path ".venv/Scripts/uvicorn.exe")) {
    Write-Host "[ERROR] Virtual environment not found in services/api/.venv" -ForegroundColor Red
    exit 1
}

& ".\.venv\Scripts\uvicorn.exe" src.main:app --reload --host 0.0.0.0 --port 8000
