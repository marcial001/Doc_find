@echo off
REM Doc-Find: Run Admin Web Dashboard (Vite / Vue 3)
echo [Doc-Find] Starting Vue 3 Admin Dashboard on http://localhost:5173...
cd /d "%~dp0..\apps\admin"
npm run dev
