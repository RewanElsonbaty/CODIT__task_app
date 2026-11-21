$env:JAVA_HOME = "C:\Java\jdk-17.0.13+11"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Output "JAVA_HOME set to: $env:JAVA_HOME"
Write-Output "Java version:"
java -version

Write-Output "`nStopping Gradle daemon..."
cd android
./gradlew --stop

Write-Output "`nBuilding APK..."
cd ..
flutter build apk --debug

Write-Output "`nBuild complete!"
