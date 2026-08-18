#requires -Version 7.0
<#
.SYNOPSIS
    Builds an email-ready report of articles that have expired or will expire
    during a target month, plus a BCC list of the article owners (ms.author).

    This script never sends email. It produces content for a manual mail merge:
    an HTML table to paste into the email body and a semicolon-delimited BCC
    list to paste into the BCC line.

.DESCRIPTION
    1. Runs export-article-metadata.ps1 to produce a fresh metadata CSV.
    2. Determines the target month as today plus two months.
    3. Selects articles whose expiry month is at or before the target month
       (already expired, or expiring during the target month).
    4. Fills the email template at templates/expiry-email.html and writes a
       self-contained HTML file with the article table and the BCC list, and
       prints a summary plus the BCC line to the console.

.PARAMETER OutputPath
    Path of the HTML file to write. Defaults to
    'expiring-articles-<yyyy-MM>.html' in the current directory.

.NOTES
    Requires the powershell-yaml module (used by export-article-metadata.ps1).
    The email body lives in templates/expiry-email.html. Edit the wording there;
    placeholders ({{Subject}}, {{TargetLabel}}, {{NextMonthLabel}}, {{TableRows}},
    {{Cc}}, {{Bcc}}) are filled in by this script.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$emailDomain = 'microsoft.com'

# The report always targets two months from today.
$monthsAhead = 2

# Owner aliases to exclude from the report and the BCC list. Add more as needed.
$ignoredOwners = @('pnp')

function ConvertTo-Alias {
    param([Parameter(Mandatory = $true)][string]$Value)
    # Normalize an alias or UPN to a lowercase alias (text before any '@').
    return ($Value -split '@')[0].Trim().ToLowerInvariant()
}

function Get-MonthKey {
    # Convert a year and month to a single comparable integer.
    param(
        [Parameter(Mandatory = $true)][int]$Year,
        [Parameter(Mandatory = $true)][int]$Month
    )
    return ($Year * 12) + ($Month - 1)
}

function ConvertFrom-ExpiryMonthYear {
    # Parse an 'MM-yyyy' expiry string into a DateTime (first of the month), or
    # $null if it is blank or malformed.
    param([Parameter(Mandatory = $true)][AllowEmptyString()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $parsed = [datetime]::MinValue
    if ([datetime]::TryParseExact($Value.Trim(), 'MM-yyyy', [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)) {
        return $parsed
    }
    return $null
}

function Invoke-MetadataExport {
    $exportScript = Join-Path -Path $PSScriptRoot -ChildPath 'export-article-metadata.ps1'
    $outputPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "aac-article-metadata-$([System.Guid]::NewGuid().ToString('N')).csv"
    & $exportScript -OutputPath $outputPath | Out-Null
    return $outputPath
}

function ConvertTo-HtmlText {
    # Minimal HTML escaping for text placed inside table cells.
    param([Parameter(Mandatory = $true)][AllowEmptyString()][string]$Value)
    return $Value.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;')
}

$today = Get-Date
$targetDate = $today.AddMonths($monthsAhead)
$currentKey = Get-MonthKey -Year $today.Year -Month $today.Month
$targetKey = Get-MonthKey -Year $targetDate.Year -Month $targetDate.Month
$targetLabel = $targetDate.ToString('MMMM yyyy')
$nextMonthLabel = $today.AddMonths(1).ToString('MMMM yyyy')

if (-not $OutputPath) {
    $OutputPath = "expiring-articles-$($targetDate.ToString('yyyy-MM')).html"
}
$outputFile = if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath
}
else {
    Join-Path -Path (Get-Location) -ChildPath $OutputPath
}

Write-Information ''
Write-Information "Target month : $targetLabel (two months out)"
Write-Information 'Generating article metadata...'

$csvPath = Invoke-MetadataExport
try {
    $allRows = Import-Csv -Path $csvPath
}
finally {
    Remove-Item -Path $csvPath -ErrorAction SilentlyContinue
}

# Keep only articles that have expired or expire at or before the target month.
$selected = foreach ($row in $allRows) {
    $expiry = ConvertFrom-ExpiryMonthYear -Value $row.expiry_month_year
    if ($null -eq $expiry) { continue }

    $rowKey = Get-MonthKey -Year $expiry.Year -Month $expiry.Month
    if ($rowKey -gt $targetKey) { continue }

    $owner = ConvertTo-Alias -Value $row.ms_author
    if ($ignoredOwners -contains $owner) { continue }

    [PSCustomObject]@{
        Title = $row.title
        Url = $row.live_url
        Owner = $owner
        Expiry = $expiry
        ExpiryLabel = $expiry.ToString('MMM yyyy')
        Status = if ($rowKey -lt $currentKey) { 'Expired' } else { 'Expiring' }
    }
}

$selected = @($selected | Sort-Object -Property Owner, Expiry, Title)

if ($selected.Count -eq 0) {
    Write-Information "No articles have expired or expire on or before $targetLabel."
    return
}

# Distinct owners for the BCC line.
$bccAliases = @(
    $selected |
        Select-Object -ExpandProperty Owner |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Sort-Object -Unique
)
$bccLine = ($bccAliases | ForEach-Object { "$_@$emailDomain" }) -join '; '

# Static CC recipients (the Azure Architecture Center owners sending this).
$ccLine = (@('chkittel', 'coxford', 'csiemens') | Sort-Object | ForEach-Object { "$_@$emailDomain" }) -join '; '

$subject = "Microsoft Learn compliance notice: You're required to refresh your article"

# Build the article rows with inline styles so the table survives a copy/paste into Outlook.
$cellStyle = 'border:1px solid #ccc;padding:6px 10px;text-align:left;vertical-align:top;'
$cellStyleRight = $cellStyle.Replace('text-align:left', 'text-align:right')

$rowsHtml = foreach ($item in $selected) {
    $titleText = ConvertTo-HtmlText -Value $item.Title
    $urlText = ConvertTo-HtmlText -Value $item.Url
    $ownerText = ConvertTo-HtmlText -Value $item.Owner
    @"
      <tr>
        <td style="$cellStyle"><a href="$urlText">$titleText</a></td>
        <td style="$cellStyle">$ownerText</td>
        <td style="$cellStyleRight">$($item.ExpiryLabel)</td>
        <td style="$cellStyle">$($item.Status)</td>
      </tr>
"@
}

# Load the email template and fill in the tokens. Replacement is literal text
# (no expression evaluation), so the template file can't execute code.
$templatePath = Join-Path -Path $PSScriptRoot -ChildPath 'templates/expiry-email.html'
if (-not (Test-Path -Path $templatePath)) {
    throw "Email template not found: $templatePath"
}

$tokens = @{
    Subject        = ConvertTo-HtmlText -Value $subject
    TargetLabel    = $targetLabel
    NextMonthLabel = $nextMonthLabel
    TableRows      = ($rowsHtml -join "`n")
    Cc             = $ccLine
    Bcc            = $bccLine
}

$html = Get-Content -Path $templatePath -Raw
foreach ($token in $tokens.GetEnumerator()) {
    $html = $html.Replace("{{$($token.Key)}}", $token.Value)
}

# Fail loudly if the template references a token the script doesn't supply.
$unresolved = @([regex]::Matches($html, '\{\{[^}]+\}\}') | ForEach-Object { $_.Value } | Sort-Object -Unique)
if ($unresolved.Count -gt 0) {
    throw "Unresolved template token(s): $($unresolved -join ', ')"
}

Set-Content -Path $outputFile -Value $html -Encoding UTF8

$expiredCount = @($selected | Where-Object Status -eq 'Expired').Count
$expiringCount = @($selected | Where-Object Status -eq 'Expiring').Count

Write-Information ''
Write-Information "Articles selected : $($selected.Count)  (expired: $expiredCount, expiring: $expiringCount)"
Write-Information "Distinct owners   : $($bccAliases.Count)"
Write-Information "HTML report       : $outputFile"
Write-Information ''
Write-Information 'Open the HTML report in a browser. It contains the subject, the email body, and the BCC list. Copy each into the matching field of your email.'
