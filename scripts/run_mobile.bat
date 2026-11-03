@echo off
REM Doc-Find: Run Flutter Mobile Application
echo [Doc-Find] Starting Flutter app on active device / emulator...
cd /d "%~dp0..\apps\mobile"
flutter run
