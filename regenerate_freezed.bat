@echo off
echo ========================================
echo   Regenerating Freezed Files
echo ========================================
echo.
echo This will take 3-5 minutes. Please wait...
echo.

echo Step 1: Cleaning...
call flutter clean
echo.

echo Step 2: Getting dependencies...
call flutter pub get
echo.

echo Step 3: Running build_runner...
echo (This is the longest step - please be patient)
call dart run build_runner build --delete-conflicting-outputs
echo.

echo ========================================
echo   Done!
echo ========================================
echo.
echo Now you can run: flutter run
pause
