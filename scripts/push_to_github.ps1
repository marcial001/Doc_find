# Doc-Find: Push monorepo to GitHub
Write-Host "===================================================" -ForegroundColor Green
Write-Host "[Doc-Find] Pushing to GitHub (marcial001/Doc_Find)" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location "$scriptDir/.."

git status -s

Write-Host "`nPushing master branch to origin..." -ForegroundColor Cyan
git push -u origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n===================================================" -ForegroundColor Green
    Write-Host "[Doc-Find] Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host "Repository: https://github.com/marcial001/Doc_Find" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
} else {
    Write-Host "`n[NOTE] If this is a newly created repository on GitHub:" -ForegroundColor Yellow
    Write-Host "1. Create 'Doc_Find' on https://github.com/new (do NOT initialize with README/license)." -ForegroundColor Yellow
    Write-Host "2. Re-run this script and authorize Git Credential Manager in your browser." -ForegroundColor Yellow
}
