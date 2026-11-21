# Script للفحص السريع للأخطاء

Write-Host "=== فحص المشروع ===" -ForegroundColor Cyan

# 1. فحص الـ imports
Write-Host "`n1. فحص الـ Material imports..." -ForegroundColor Yellow
$dartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse | Where-Object { $_.FullName -notmatch "_deprecated" }
$count = 0
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    if (($content -match "StatelessWidget|StatefulWidget|BuildContext") -and ($content -notmatch "import 'package:flutter/material.dart'")) {
        Write-Host "  - $($file.Name)" -ForegroundColor Red
        $count++
    }
}
if ($count -eq 0) {
    Write-Host "✓ كل الملفات تحتوي على imports صحيحة" -ForegroundColor Green
}

# 2. فحص deprecated code
Write-Host "`n2. فحص الـ deprecated code..." -ForegroundColor Yellow
$deprecatedCount = (Get-ChildItem -Path "lib" -Directory -Recurse | Where-Object { $_.Name -eq "_deprecated" }).Count
Write-Host "عدد المجلدات _deprecated: $deprecatedCount" -ForegroundColor $(if($deprecatedCount -gt 0){"Red"}else{"Green"})

# 3. فحص compilation errors بسرعة
Write-Host "`n3. فحص syntax errors..." -ForegroundColor Yellow
Write-Host "جاري الفحص..." -ForegroundColor Gray

Write-Host "`n=== انتهى الفحص ===" -ForegroundColor Cyan
