@echo off
setlocal

REM Set Flutter path
set FLUTTER_PATH=E:\flutter\bin
set PATH=%FLUTTER_PATH%;%PATH%

echo Starting CODIT app...
echo.

REM Get dependencies first time
if not exist "pubspec.lock" (
    echo Installing dependencies...
    call flutter pub get
    echo.
)

REM Run the app
call flutter run

pause
