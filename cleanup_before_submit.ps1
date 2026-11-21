# Script لتنظيف المشروع قبل التسليم

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cleanup Script - CODIT Task" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. حذف مجلدات deprecated
Write-Host "`n[1] Removing deprecated folders..." -ForegroundColor Yellow
$deprecated = Get-ChildItem -Path "lib" -Directory -Recurse | Where-Object { $_.Name -eq "_deprecated" }
$count = $deprecated.Count
if ($count -gt 0) {
    foreach ($folder in $deprecated) {
        Write-Host "  Removing: $($folder.FullName)" -ForegroundColor Gray
        Remove-Item -Path $folder.FullName -Recurse -Force
    }
    Write-Host "  Removed $count folders" -ForegroundColor Green
} else {
    Write-Host "  No deprecated folders found" -ForegroundColor Green
}

# 2. تنظيف ملفات build
Write-Host "`n[2] Cleaning build files..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Path "build" -Recurse -Force
    Write-Host "  Cleaned build folder" -ForegroundColor Green
}

# 3. تنظيف ملفات مؤقتة
Write-Host "`n[3] Cleaning temporary files..." -ForegroundColor Yellow
$tempFiles = @(
    "*.log",
    "*.txt",
    "*.ps1"
)
foreach ($pattern in $tempFiles) {
    $files = Get-ChildItem -Path "." -Filter $pattern | Where-Object { 
        $_.Name -notmatch "README|CHANGELOG|LICENSE" 
    }
    foreach ($file in $files) {
        Write-Host "  Removing: $($file.Name)" -ForegroundColor Gray
        Remove-Item $file.FullName -Force
    }
}
Write-Host "  Cleaned temp files" -ForegroundColor Green

# 4. flutter clean
Write-Host "`n[4] Running flutter clean..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "  Flutter clean completed" -ForegroundColor Green

# 5. flutter pub get
Write-Host "`n[5] Running flutter pub get..." -ForegroundColor Yellow
flutter pub get | Out-Null
Write-Host "  Dependencies updated" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Cleanup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Run: flutter analyze" -ForegroundColor White
Write-Host "  2. Run: flutter test" -ForegroundColor White
Write-Host "  3. Test the app manually" -ForegroundColor White
Write-Host "  4. Commit and push to GitHub" -ForegroundColor White
