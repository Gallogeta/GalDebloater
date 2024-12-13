# Download the ZIP file to the system's temporary directory
$tempDir = [Environment]::GetEnvironmentVariable("TEMP")
$zipFile = Join-Path $tempDir "Win11Debloat-master.zip"
$downloadUrl = "https://github.com/Gallogeta/Debloater/blob/main/Win11Debloat-master.zip"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
} catch {
    Write-Warning "Failed to download the ZIP file: $($_.Exception.Message)"
    exit 1
}

# Unzip the downloaded file
try {
    Expand-Archive $zipFile -DestinationPath $tempDir
} catch {
    Write-Warning "Failed to extract the ZIP file: $($_.Exception.Message)"
    Remove-Item $zipFile
    exit 1
}

# Run the "Run.bat" script from the extracted directory
$scriptPath = Join-Path $tempDir "Win11Debloat-master\Run.bat"
try {
    Start-Process -FilePath $scriptPath -Wait
} catch {
    Write-Warning "Failed to run the script: $($_.Exception.Message)"
    Remove-Item $zipFile -Recurse
    exit 1
}

# Clean up the temporary files
Remove-Item $zipFile -Recurse
