@echo off
REM Doc-Find: Run Backend FastAPI Service (Uvicorn)
echo [Doc-Find] Starting FastAPI backend on http://localhost:8000...
cd /d "%~dp0..\services\api"
if not exist ".venv\Scripts\uvicorn.exe" (
    echo [ERROR] Virtual environment not found in services\api\.venv.
    pause
    exit /b 1
)
".venv\Scripts\uvicorn.exe" src.main:app --reload --host 0.0.0.0 --port 8000
