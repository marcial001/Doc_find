@echo off
REM Doc-Find: Push monorepo to GitHub
echo ===================================================
echo [Doc-Find] Pushing to GitHub (marcial001/Doc_Find)
echo ===================================================

cd /d "%~dp0.."
echo Checking git status...
git status -s

echo.
echo Pushing master branch to origin...
git push -u origin master
if %errorlevel% neq 0 (
    echo.
    echo [NOTE] If this is a newly created repository on GitHub:
    echo 1. Ensure you created the repository "Doc_Find" at https://github.com/new
    echo 2. If prompted, complete the GitHub sign-in prompt in your browser.
    pause
    exit /b 1
)

echo.
echo ===================================================
echo [Doc-Find] Successfully pushed to GitHub!
echo https://github.com/marcial001/Doc_Find
echo ===================================================
pause
