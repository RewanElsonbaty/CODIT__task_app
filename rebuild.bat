@echo off
setlocal

REM Set Flutter path
set FLUTTER_PATH=E:\flutter\bin
set PATH=%FLUTTER_PATH%;%PATH%

echo ========================================
echo FAST Rebuild - CODIT Project
echo ========================================
echo.

echo [0/5] Deep cleaning...
if exist "build" rd /s /q "build"
if exist "android\.gradle" rd /s /q "android\.gradle"
if exist "android\.kotlin" rd /s /q "android\.kotlin"
if exist "android\app\build" rd /s /q "android\app\build"
if exist "android\build" rd /s /q "android\build"
if exist ".dart_tool\flutter_build" rd /s /q ".dart_tool\flutter_build"
echo Deep clean completed!
echo.

echo [1/4] Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: flutter pub get failed
    pause
    exit /b %errorlevel%
)
echo.

echo [2/4] Running code generation...
call dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo ERROR: build_runner failed
    pause
    exit /b %errorlevel%
)
echo.

echo [3/4] Generating localizations...
call flutter gen-l10n
if %errorlevel% neq 0 (
    echo ERROR: gen-l10n failed
    pause
    exit /b %errorlevel%
)
echo.

echo [4/4] Building Android app...
call flutter build apk --debug
if %errorlevel% neq 0 (
    echo ERROR: build failed
    pause
    exit /b %errorlevel%
)
echo.

echo ========================================
echo Build completed successfully!
echo ========================================
pause
