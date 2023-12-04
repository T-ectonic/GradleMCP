# Set the window title
$host.UI.RawUI.WindowTitle = "GradleMCP | Setting up gradle wrapper"


Write-Host "We recommend keeping this so you don't need to bloat your repo with Gradle"
Write-Host "It is alot better to force people make there own gradle wrapper files"
for ($i = 1; $i -le 20; $i++) {
Write-Host ""
}
$userInput = Read-Host "Do you already have gradlew, gradlew.bat files? (Y/N)"

# Check if the user wants to continue
if ($userInput -ne 'Y' -and $userInput -ne 'y') {
    exit
}

Write-Host "> Downloading Gradle"
Invoke-WebRequest -Uri 'http://gradlemcp-cdn.000webhostapp.com/gradlew' -OutFile 'gradlew'
Invoke-WebRequest -Uri 'http://gradlemcp-cdn.000webhostapp.com/gradlew.bats' -OutFile 'gradlew.bat'