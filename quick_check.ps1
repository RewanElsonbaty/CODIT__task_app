Write-Host "Checking imports..." -ForegroundColor Cyan

$dartFiles = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse | Where-Object { $_.FullName -notmatch "_deprecated" }
$missingImports = @()

foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    if (($content -match "StatelessWidget|StatefulWidget|BuildContext") -and ($content -notmatch "import 'package:flutter/material.dart'")) {
        $missingImports += $file.Name
    }
}

if ($missingImports.Count -gt 0) {
    Write-Host "Files missing material import:" -ForegroundColor Red
    $missingImports | ForEach-Object { Write-Host "  - $_" }
} else {
    Write-Host "All imports OK" -ForegroundColor Green
}

Write-Host "`nChecking deprecated folders..." -ForegroundColor Cyan
$deprecatedCount = (Get-ChildItem -Path "lib" -Directory -Recurse | Where-Object { $_.Name -eq "_deprecated" }).Count
Write-Host "Deprecated folders: $deprecatedCount" -ForegroundColor Yellow

Write-Host "`nDone!" -ForegroundColor Green
