# CODIT-TASK - Push to GitHub Script
# Run this script after creating the repository on GitHub

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CODIT-TASK - Push to GitHub" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Get GitHub username
$username = Read-Host "Enter your GitHub username (default: rawanelsenbaty)"
if ([string]::IsNullOrWhiteSpace($username)) {
    $username = "rawanelsenbaty"
}

Write-Host ""
Write-Host "Using username: $username" -ForegroundColor Green
Write-Host ""

# Ask for repository name
$repoName = Read-Host "Enter repository name (default: CODIT-TASK)"
if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "CODIT-TASK"
}

Write-Host ""
Write-Host "Repository: $repoName" -ForegroundColor Green
Write-Host ""

# Ask for remote type
Write-Host "Choose authentication method:" -ForegroundColor Cyan
Write-Host "1. HTTPS (requires token)" -ForegroundColor White
Write-Host "2. SSH (requires SSH key setup)" -ForegroundColor White
$choice = Read-Host "Enter choice (1 or 2, default: 1)"
if ([string]::IsNullOrWhiteSpace($choice)) {
    $choice = "1"
}

# Build remote URL
if ($choice -eq "2") {
    $remoteUrl = "git@github.com:$username/$repoName.git"
    Write-Host ""
    Write-Host "Using SSH: $remoteUrl" -ForegroundColor Green
} else {
    $remoteUrl = "https://github.com/$username/$repoName.git"
    Write-Host ""
    Write-Host "Using HTTPS: $remoteUrl" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Executing Git Commands..." -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Change to project directory
Set-Location "e:\flutter_projects\CODIT-TASK"

# Remove existing remote if exists
Write-Host "1. Removing existing remote (if any)..." -ForegroundColor White
git remote remove origin 2>$null

# Add new remote
Write-Host "2. Adding remote origin..." -ForegroundColor White
git remote add origin $remoteUrl

# Verify remote
Write-Host "3. Verifying remote..." -ForegroundColor White
git remote -v

# Rename branch to main
Write-Host "4. Renaming branch to main..." -ForegroundColor White
git branch -M main

# Push to GitHub
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

git push -u origin main

# Check result
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
    Write-Host "  SUCCESS! ✓" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository URL: https://github.com/$username/$repoName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Visit your repository" -ForegroundColor White
    Write-Host "2. Add topics: flutter, dart, clean-architecture" -ForegroundColor White
    Write-Host "3. Add a description" -ForegroundColor White
    Write-Host "4. Enable Issues & Discussions" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Red
    Write-Host "  ERROR!" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "1. Repository doesn't exist on GitHub yet" -ForegroundColor White
    Write-Host "   → Create it first at: https://github.com/new" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Authentication failed" -ForegroundColor White
    Write-Host "   → Use Personal Access Token instead of password" -ForegroundColor White
    Write-Host "   → Or use GitHub Desktop" -ForegroundColor White
    Write-Host ""
    Write-Host "3. SSH key not configured" -ForegroundColor White
    Write-Host "   → Switch to HTTPS or setup SSH key" -ForegroundColor White
    Write-Host ""
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
