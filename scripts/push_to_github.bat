@echo off
REM Doc-Find: Push monorepo to GitHub
echo ===================================================
echo [Doc-Find] Pushing to GitHub (marcial001/Doc_find)
echo ===================================================

cd /d "%~dp0.."
echo Checking git status...
git status -s

echo.
echo Pushing master branch to origin...
git push -u origin master
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Push failed. If prompted, complete the sign-in authorization in your browser.
    pause
    exit /b 1
)

echo.
echo ===================================================
echo [Doc-Find] Successfully pushed to GitHub!
echo https://github.com/marcial001/Doc_find
echo ===================================================
pause
