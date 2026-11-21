# CODIT Project Runner
$ErrorActionPreference = "Stop"

# Set Flutter path
$env:PATH = "E:\flutter\bin;$env:PATH"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CODIT Project - Quick Run" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if dependencies are installed
if (-not (Test-Path "pubspec.lock")) {
    Write-Host "[1/2] Installing dependencies..." -ForegroundColor Yellow
    & flutter pub get
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to get dependencies" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    Write-Host ""
}

# Run the app
Write-Host "[2/2] Starting app..." -ForegroundColor Yellow
& flutter run

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
