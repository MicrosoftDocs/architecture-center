#requires -Version 7.0

[CmdletBinding()]
param(
    [Parameter()]
    [string]$DocsRoot = (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath "docs"),

    [Parameter()]
    [string]$OutputPath = "article-metadata.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

try {
    if (-not (Get-Command -Name ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
        Import-Module -Name powershell-yaml -ErrorAction Stop | Out-Null
    }
}
catch {
    throw "The 'powershell-yaml' module is required. Install it with: Install-Module -Name powershell-yaml"
}

# docfx update-cycle resolution helpers.
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'modules/AacDocfxMetadata.psm1') -Force

function Get-RelativeDocsPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DocsRootPath,

        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    return [System.IO.Path]::GetRelativePath($DocsRootPath, $FilePath).Replace('\', '/')
}

function Get-ArticleFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DocsRootPath
    )

    return Get-ChildItem -Path $DocsRootPath -Recurse -File | Where-Object {
        (
            ($_.Extension -eq '.yml' -and $_.Name -notmatch '^(toc(\.experimental)?|.*context)\.yml$') -or
            ($_.Extension -eq '.md' -and $_.Name -notlike '*-content.md')
        ) -and
        ($_.FullName -notmatch '[\\/]includes[\\/]')
    }
}

function Read-MarkdownFrontMatter {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $text = Get-Content -Path $Path -Raw
    $pattern = '^(?:\uFEFF)?---\s*\r?\n(?<fm>.*?)\r?\n---\s*(?:\r?\n|$)'
    $match = [regex]::Match($text, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)

    if (-not $match.Success) {
        return @{}
    }

    $parsed = ConvertFrom-Yaml -Yaml $match.Groups['fm'].Value -ErrorAction Stop

    $map = @{}
    if ($parsed -is [System.Collections.IDictionary]) {
        foreach ($key in $parsed.Keys) {
            $value = $parsed[$key]
            if ($null -ne $value -and ($value -is [string] -or $value -is [ValueType])) {
                $map[[string]$key] = [string]$value
            }
        }
    }

    return $map
}

function Read-YamlTopLevelMetadata {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $map = @{}
    $yamlContent = Get-Content -Path $Path -Raw
    $yamlObject = ConvertFrom-Yaml -Yaml $yamlContent -ErrorAction Stop

    if (-not $yamlObject) {
        return $map
    }

    if ($yamlObject -is [System.Collections.IDictionary]) {
        foreach ($key in $yamlObject.Keys) {
            $value = $yamlObject[$key]
            $isScalar = ($value -is [string] -or $value -is [ValueType])
            if (-not $map.ContainsKey([string]$key) -and $null -ne $value -and $isScalar) {
                $map[[string]$key] = [string]$value
            }
        }
    }
    else {
        foreach ($property in $yamlObject.PSObject.Properties) {
            $isScalar = ($property.Value -is [string] -or $property.Value -is [ValueType])
            if (-not $map.ContainsKey($property.Name) -and $null -ne $property.Value -and $isScalar) {
                $map[$property.Name] = [string]$property.Value
            }
        }
    }

    $metadataNode = $null
    if ($yamlObject -is [System.Collections.IDictionary] -and $yamlObject.Contains('metadata')) {
        $metadataNode = $yamlObject['metadata']
    }
    elseif ($yamlObject.PSObject.Properties.Name -contains 'metadata') {
        $metadataNode = $yamlObject.metadata
    }

    if ($metadataNode -is [System.Collections.IDictionary]) {
        foreach ($key in $metadataNode.Keys) {
            $value = $metadataNode[$key]
            if ($null -ne $value -and ($value -is [string] -or $value -is [ValueType])) {
                # Metadata block values should win for docs YAML article files.
                $map[[string]$key] = [string]$value
            }
        }
    }
    elseif ($metadataNode) {
        foreach ($property in $metadataNode.PSObject.Properties) {
            if ($null -ne $property.Value -and ($property.Value -is [string] -or $property.Value -is [ValueType])) {
                # Metadata block values should win for docs YAML article files.
                $map[$property.Name] = [string]$property.Value
            }
        }
    }

    return $map
}

function Get-LiveUrl {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DocsRootPath,

        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    $relative = Get-RelativeDocsPath -DocsRootPath $DocsRootPath -FilePath $FilePath
    if ($relative.EndsWith('.md')) {
        $urlPath = $relative.Substring(0, $relative.Length - 3)
    }
    elseif ($relative.EndsWith('.yml')) {
        $urlPath = $relative.Substring(0, $relative.Length - 4)
    }
    else {
        $urlPath = $relative
    }
    return "https://learn.microsoft.com/azure/architecture/$urlPath"
}

function ConvertTo-MsDate {
    param(
        [Parameter(Mandatory = $true)]
        [string]$MsDate
    )

    $parsed = [datetime]::MinValue
    if ([datetime]::TryParseExact($MsDate.Trim(), 'M/d/yyyy', [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)) {
        return $parsed
    }

    return $null
}

function Get-ExpiryMonthYear {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$MsDate,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$MsUpdateCycle
    )

    if ([string]::IsNullOrWhiteSpace($MsDate) -or [string]::IsNullOrWhiteSpace($MsUpdateCycle)) {
        return ""
    }

    if ($MsUpdateCycle -notmatch '^(?<days>\d+)-days$') {
        return ""
    }

    $startDate = ConvertTo-MsDate -MsDate $MsDate
    if ($null -eq $startDate) {
        return ""
    }

    $days = [int]$matches['days']
    $expiryDate = $startDate.AddDays($days)
    return $expiryDate.ToString('MM-yyyy')
}

function Get-ArticleMetadataRow {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$File,

        [Parameter(Mandatory = $true)]
        [string]$DocsRootPath,

        [Parameter(Mandatory = $true)]
        [psobject]$UpdateCycleConfig
    )

    $metadata = if ($File.Extension -eq '.md') {
        Read-MarkdownFrontMatter -Path $File.FullName
    }
    else {
        Read-YamlTopLevelMetadata -Path $File.FullName
    }

    $title = if ($metadata.ContainsKey('title')) { $metadata['title'] } else { "" }
    $msDate = if ($metadata.ContainsKey('ms.date')) { $metadata['ms.date'] } else { "" }
    $relativeDocPath = Get-RelativeDocsPath -DocsRootPath $DocsRootPath -FilePath $File.FullName
    $updateCycle = if ($metadata.ContainsKey('ms.update-cycle')) {
        $metadata['ms.update-cycle']
    }
    else {
        Resolve-DocfxUpdateCycle -RelativeDocPath $relativeDocPath -GlobalDefault $UpdateCycleConfig.GlobalDefault -PatternRules $UpdateCycleConfig.PatternRules
    }

    return [PSCustomObject]@{
        ms_author = if ($metadata.ContainsKey('ms.author')) { $metadata['ms.author'] } else { "" }
        title = $title
        live_url = Get-LiveUrl -DocsRootPath $DocsRootPath -FilePath $File.FullName
        ms_date = $msDate
        ms_update_cycle = $updateCycle
        expiry_month_year = Get-ExpiryMonthYear -MsDate $msDate -MsUpdateCycle $updateCycle
    }
}

$resolvedDocsRoot = (Resolve-Path -Path $DocsRoot).Path
$updateCycleConfig = Get-DocfxUpdateCycleConfig -DocsRootPath $resolvedDocsRoot
$outputFile = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath
}
else {
    Join-Path -Path (Get-Location) -ChildPath $OutputPath
}

$files = Get-ArticleFile -DocsRootPath $resolvedDocsRoot

$rows = foreach ($file in $files) {
    Get-ArticleMetadataRow -File $file -DocsRootPath $resolvedDocsRoot -UpdateCycleConfig $updateCycleConfig
}

$rows |
    Sort-Object -Property @(
        @{ Expression = {
                if ([string]::IsNullOrWhiteSpace($_.expiry_month_year)) {
                    [datetime]::MaxValue
                }
                else {
                    [datetime]::ParseExact($_.expiry_month_year, 'MM-yyyy', [System.Globalization.CultureInfo]::InvariantCulture)
                }
            }
        },
        @{ Expression = { $_.ms_author } },
        @{ Expression = { $_.title } }
    ) |
    Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Information "Exported $($rows.Count) article rows to $outputFile" -InformationAction Continue
