# Set the window title
$host.UI.RawUI.WindowTitle = "GradleMCP | Setting up project"

Write-Host "Make sure you have ran minecraft 1.8.8 through default launcher or this WILL FAIL"
$userInput = Read-Host "Do you want to continue? (Y/N)"

# Check if the user wants to continue
if ($userInput -ne 'Y' -and $userInput -ne 'y') {
    exit
}

# Delete and or Create Temp directory
$tempPath = "temp"

if (Test-Path $tempPath -PathType Container) {
    Remove-Item -Path $tempPath -Force -Recurse
}

$ProgressPreference = 'SilentlyContinue'

New-Item -ItemType Directory -Path $tempPath | Out-Null
Write-Host "> Creating Temp Directory"
Set-Location $tempPath

# Download MCP ZIP file
Write-Host "> Downloading MCP"
$url = 'http://www.modcoderpack.com/files/mcp918.zip'
$outputFile = 'mcp.zip'
Invoke-WebRequest -Uri $url -OutFile $outputFile

# Unzip MCP
Write-Host "> Unzipping MCP"
Expand-Archive -Path $outputFile -DestinationPath 'mcp'
Remove-Item -Path $outputFile
Set-Location 'mcp'
Remove-Item -Path "jars\*" -Force -Recurse

# Decompileing MCP
Write-Host "> Decompiling MCP"
Write-Host ""
& ".\runtime\bin\python\python_mcp" ".\runtime\decompile.py"
Write-Host ""

# Organizeing Source Code 
Write-Host "> Organizeing Source Code"
Set-Location "src"

    # Create directory "main/resources"
    New-Item -ItemType Directory -Name "main/resources" | Out-Null

    # Rename minecraft to java & move it into main
    Rename-Item -Path "minecraft" -NewName "java"
    Move-Item -Path "java" -Destination "main/" -Force
    Remove-Item "main/java/Start.java" -Force

    # CD out of the tree & move source code to new location
    Set-Location "../../../"
    Move-Item -Path "temp/mcp/src/" -Destination "./" -Force

    # Create .run & copy over workspace stuff & remove libraries as its unneeded
    New-Item -ItemType Directory -Name ".run" | Out-Null
    Copy-Item -Path "temp/mcp/jars/assets" -Destination ".run/assets" -Force -Recurse
    Copy-Item -Path "temp/mcp/jars/versions/1.8.8/1.8.8-natives" -Destination ".run/bin/natives" -Force -Recurse
    Remove-Item -Path ".run/assets/skins" -Force -Recurse

# Unpacking jar for assets
Write-Host "> Unpacking jar"
Copy-Item -Path "temp/mcp/jars/versions/1.8.8/1.8.8.jar" -Destination "temp" -Force
Set-Location "temp"
Rename-Item -Path "1.8.8.jar" -NewName "1.8.8.zip"
Expand-Archive -Path "1.8.8.zip" -DestinationPath "1.8.8"
Set-Location "../"

# Copy assets
Write-Host "> Copying assets"
Move-Item -Path "temp/1.8.8/assets" -Destination "src/main/resources/" -Force
Move-Item -Path "temp/1.8.8/pack.png" -Destination "src/main/resources/" -Force
Move-Item -Path "temp/1.8.8/log4j2.xml" -Destination "src/main/resources/" -Force

Write-Host "____________________________________"

    Write-Host "> Downloading Gradle"
    Invoke-WebRequest -Uri 'http://gradlemcp-cdn.000webhostapp.com/gradlew' -OutFile 'gradlew'
    Invoke-WebRequest -Uri 'http://gradlemcp-cdn.000webhostapp.com/gradlew.bats' -OutFile 'gradlew.bat'

Write-Host ""

#Cleanup
Write-Host "> Cleaning up"
Remove-Item "temp" -Force -Recurse

Write-Host "____________________________________"
Write-Host ""
Write-Host "> Complete!"

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')