# Script to fix IDE warnings

Write-Host "Fixing IDE warnings..." -ForegroundColor Cyan

# 1. Clean Flutter
Write-Host "`n[1] Running flutter clean..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "  Done" -ForegroundColor Green

# 2. Update dependencies
Write-Host "`n[2] Getting dependencies..." -ForegroundColor Yellow
flutter pub get | Out-Null
Write-Host "  Done" -ForegroundColor Green

# 3. Clean VS Code cache
Write-Host "`n[3] Cleaning VS Code cache..." -ForegroundColor Yellow
if (Test-Path ".vscode") {
    Remove-Item ".vscode" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  Removed .vscode folder" -ForegroundColor Green
}

# 4. Recreate .vscode settings
Write-Host "`n[4] Creating fresh .vscode settings..." -ForegroundColor Yellow
New-Item -Path ".vscode" -ItemType Directory -Force | Out-Null
@"
{
  "dart.analysisExcludedFolders": [
    "**/_deprecated/**",
    "**/build/**",
    "**/.dart_tool/**"
  ],
  "dart.lineLength": 120,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "[dart]": {
    "editor.rulers": [120],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": false
  }
}
"@ | Out-File -FilePath ".vscode\settings.json" -Encoding UTF8
Write-Host "  Created .vscode/settings.json" -ForegroundColor Green

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Done! Now:" -ForegroundColor Green
Write-Host "  1. Close VS Code completely" -ForegroundColor White
Write-Host "  2. Reopen the project" -ForegroundColor White
Write-Host "  3. Wait for Dart Analysis to complete" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
