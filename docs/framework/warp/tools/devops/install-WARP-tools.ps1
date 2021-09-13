#This script will download a list of files from the proper location to the directory it is running from

#This is the base URL for downloads.
$baseURL = https://github.com/JoeyBarnes/architecture-center-pr/blob/warp-guidance-rework/docs/framework/warp/tools/devops/

$workingDirectory = $PSScriptRoot

wget $baseURL/files-list.txt -OutFile $workingDirectory/files-list.txt

$files = Get-Content -Path $workingDirectory/files-list.txt

ForEach ($file in $files) {
    Write-Host downloading $file
    wget $baseURL/$file -OutFile $workingDirectory/$file
    }