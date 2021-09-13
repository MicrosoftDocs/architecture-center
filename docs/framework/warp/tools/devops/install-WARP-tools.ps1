#This script will download a list of files from the proper location to the directory it is running from

#This is the base URL for downloads. Base URL cannot end with a /
$baseURL = "https://rspott.com/WARP"

$workingDirectory = $PSScriptRoot
Write-Host $workingDirectory
#wget $baseURL/files-list.txt -O $workingDirectory/files-list.txt
invoke-WebRequest $baseURL/files-list.txt -OutFile $workingDirectory/files-list.txt


Write-Host "Downloading from: $baseURL"
Write-Host "We will get these files:"
Get-Content $workingDirectory/files-list.txt | ForEach-Object {Write-Host "   $_"}


Get-Content $workingDirectory/files-list.txt | ForEach-Object {Invoke-WebRequest $baseURL/$_ -OutFile $workingDirectory/$(Split-Path $_ -Leaf)}
