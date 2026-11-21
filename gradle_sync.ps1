# Set Java Home
$env:JAVA_HOME = "C:\Java\jdk-17.0.13+11"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Gradle Sync Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nJava Version:" -ForegroundColor Yellow
java -version

Write-Host "`n1. Stopping Gradle Daemon..." -ForegroundColor Yellow
cd android
./gradlew --stop

Write-Host "`n2. Running Gradle Tasks..." -ForegroundColor Yellow
./gradlew tasks --warning-mode all 2>&1 | Select-Object -Last 30

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Gradle Sync Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nNow try 'flutter run' or sync in Android Studio" -ForegroundColor Cyan
