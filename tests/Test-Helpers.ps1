# TODO: Investigate extension methods with parameters.
#Update-TypeData -TypeName System.String -MemberType ScriptMethod `
#    -MemberName ChopStart  -Value { return "Text"" }

$here = $global:herePath

. "$here/Test-StringHelpers.ps1"

function Get-HerePath {
    return $global:herePath
}

function Get-DocsPath {
    $path = Resolve-Path (Join-Path $(Get-HerePath) "\..\docs")
    if (-not (Test-Path $path))
    {   
        Write-Host "PATH NOT FOUND: $path"
    }

    return $path
}

function Get-TocFilePath {
    $path = Resolve-Path (Join-Path $(Get-DocsPath) "toc.yml")
    if (-not (Test-Path $path))
    {   
        Write-Host "PATH NOT FOUND: $path"
    }
    
    return $path
}

function Get-RedirectFilePath {
    $path = Resolve-Path (Join-Path $(Get-HerePath) "..\.openpublishing.redirection.json")
    if (-not (Test-Path $path))
    {   
        Write-Host "PATH NOT FOUND: $path"
    }
    
    return $path
}

function Join-Uri([string]$path, [string]$childPath)
{
    $path = (Get-StringMustEndWith $path '/')
    $uri = [System.Uri]::new($path)

    $childPath = (Get-StringChopStart $childPath '/')
    $childPath = (Get-StringMustEndWith $childPath '/')
    
    try
    {
        $uri2 = [System.Uri]::new($uri, $childPath)
    }
    catch
    {
        Write-TestVerbose "CATCH EXCEPTION" 
        $_
    }
    
    return $(Get-StringChopEnd $uri2.ToString() '/')
}

function Get-Subfolders(
    [string[]] $excludedSubfolders,
    [bool] $addRootReference = $false
) {

    $array = (`
        Get-ChildItem ..\docs\* -Directory `
        | ForEach-Object { $_.Name } `
        | Where-Object { $excludedSubfolders -notcontains $_ })
    
    # TODO: Handle the case with all but one subfolder excluded.
    $subfolders = $([System.Collections.ArrayList]$array)

    if ($addRootReference)
    {
        $subfolders.Add("ROOT") | Out-Null
    }

    return $subfolders.ToArray()
}

function Get-ContentFiles([string[]] $excludedSubfolders)
{
    $specificFilesToTest = Get-SpecificFilesToTest
    if ($specificFilesToTest.Count -gt 0)
    {
        $files = $specificFilesToTest | ForEach-Object `
            { Get-Item (Join-Path $(Get-DocsPath) $_) }
    }
    else
    {
        $files = Get-Files @("*.md", "*.yml") $excludedSubfolders
    }
    
    Write-Host "FILE COUNT = $($files.Count)" 
    return $files
}

function Get-Files (
    [string[]] $include,
    [string[]] $excludedSubfolders = @()
)
{
    
    Write-Host "GETTING FILES..."
    $docsPath = Get-DocsPath

    $files = $(Get-ChildItem -Path $docsPath -Include $include -Recurse)

    if ($excludedSubfolders.Count -eq 0)
    {
        return $files
    }

    Write-Host "IGNORING SUBFOLDERS: $($excludedSubfolders)"
    
    $excludedPaths = [System.Collections.ArrayList]::new()
    foreach ($item in $excludedSubfolders)
    {
        $path = Resolve-Path (Join-Path $docsPath $item)
        $excludedPaths.Add($path) | Out-Null
    }
    
    $includedFiles = [System.Collections.ArrayList]::new()

    foreach ($file in $files)
    {
        $included = $true
        foreach ($item in $excludedPaths)
        {
            if ($file.FullName.StartsWith($item))
            {
                Write-TestSuperVerbose "SKIPPING: $($file.FullName)"
                $included = $false
                break
            }
        }

        if ($included)
        {
            $includedFiles.Add($file) | Out-Null
        }
    }

    return $includedFiles
}

function Invoke-ExternalChecker(
    [string] $processName,
    [string] $folder,
    [string] $extension,
    [string] $additionalArguments = ''
)
{
    $commandPath = "$env:APPDATA\npm\$processName.cmd"
    $includePath = if ($folder -eq 'ROOT') { "*.$extension" } else { "$folder\**\*.$extension" }
    $pathToCheck = Join-Path $docsPath $includePath
    $configFile = Join-Path $docsPath ".$processName.json"
    $arguments = "/c $commandPath $pathToCheck -c $configFile $additionalArguments"

    $output = Get-ProcessStream "StandardError" -FileName $env:ComSpec -Args $arguments
    return $output
}

function Get-ProcessStream
{
    Param (
                [Parameter(Mandatory=$true)]$Stream,
                [Parameter(Mandatory=$true)]$FileName,
                $Args
    )
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.RedirectStandardOutput = ($Stream -eq 'StandardOutput')
    $process.StartInfo.RedirectStandardError = ($Stream -eq 'StandardError')
    $process.StartInfo.FileName = $FileName
    if ($Args) { $process.StartInfo.Arguments = $Args }
    
    $process.Start()
    
    if ($Stream -eq "StandardOutput")
    {
        $output = $process.StandardOutput.ReadToEnd()
    }
    elseif ($Stream -eq "StandardError")
    {
        $output = $process.StandardError.ReadToEnd()
    }

    $output
}
