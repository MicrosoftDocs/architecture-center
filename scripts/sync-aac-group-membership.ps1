#requires -Version 7.0
<#
.SYNOPSIS
    Reconciles an Entra group's membership against the current set of article
    authors (ms.author values) in the docs.

    This script only manages group membership. It never changes Entra group
    ownership.

.DESCRIPTION
    1. Runs the article-metadata generator to produce a fresh CSV.
    2. Reads the distinct ms.author aliases from that CSV (the desired members).
    3. Reads the current members of the target group.
    4. Computes who should be added (authors not in the group) and who should be
       removed (members who are no longer article authors).
    5. Honors a do-not-add list (never add these) and a do-not-remove list
       (never remove these).
    6. Prints the planned changes and requires explicit approval before applying.

.NOTES
    Requires Azure CLI (az) with an authenticated session that can manage the group.
#>
[CmdletBinding()]
param(
    # Mail alias of the Entra group to reconcile.
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$GroupAlias = 'mslearn-aac-article-owners',

    # Aliases that must never be added (it is fine if they are already members).
    [Parameter()]
    [string[]]$DoNotAdd = @('pnp', 'anaharris'),

    # Additional aliases to never remove, beyond the group owners (who are
    # always protected). Defaults to none.
    [Parameter()]
    [string[]]$DoNotRemove = @(),

    # Show the plan and exit without prompting or making changes.
    [Parameter()]
    [switch]$WhatIf
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$DocsRoot = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'docs'

function Test-AzCliAvailable {
    $null = Get-Command az -ErrorAction Stop
}

function Test-AzLogin {
    $null = az account show --output json | ConvertFrom-Json
}

function ConvertTo-Alias {
    param([Parameter(Mandatory = $true)][string]$Value)
    # Normalize an alias or UPN to a lowercase alias (text before any '@').
    return ($Value -split '@')[0].Trim().ToLowerInvariant()
}

function Invoke-MetadataExport {
    param([Parameter(Mandatory = $true)][string]$DocsRootPath)

    $exportScript = Join-Path -Path $PSScriptRoot -ChildPath 'export-article-metadata.ps1'
    $outputPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "aac-article-metadata-$([System.Guid]::NewGuid().ToString('N')).csv"
    & $exportScript -DocsRoot $DocsRootPath -OutputPath $outputPath | Out-Null
    return $outputPath
}

function Get-DesiredMemberAlias {
    param([Parameter(Mandatory = $true)][string]$CsvPath)

    return Import-Csv -Path $CsvPath |
        Select-Object -ExpandProperty ms_author |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { ConvertTo-Alias -Value $_ } |
        Sort-Object -Unique
}

function Get-GroupMember {
    param([Parameter(Mandatory = $true)][string]$TargetGroupId)

    $members = az ad group member list --group $TargetGroupId --query "[?userPrincipalName!=null].{id:id, upn:userPrincipalName}" --output json | ConvertFrom-Json
    return $members | ForEach-Object {
        [PSCustomObject]@{
            Id = $_.id
            Upn = $_.upn
            Alias = ConvertTo-Alias -Value $_.upn
        }
    }
}

function Get-GroupOwnerAlias {
    param([Parameter(Mandatory = $true)][string]$TargetGroupId)

    $owners = az ad group owner list --group $TargetGroupId --query "[?userPrincipalName!=null].userPrincipalName" --output json | ConvertFrom-Json
    return $owners |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object { ConvertTo-Alias -Value $_ }
}

function Resolve-AuthorToUser {
    param([Parameter(Mandatory = $true)][string]$Alias)

    $user = az ad user show --id "$Alias@microsoft.com" --query "{id:id, upn:userPrincipalName}" --output json 2>$null | ConvertFrom-Json
    if ($user -and $user.id) {
        return [PSCustomObject]@{ Id = $user.id; Upn = $user.upn; Alias = $Alias }
    }
    return $null
}

function Test-GroupMembership {
    param(
        [Parameter(Mandatory = $true)][string]$TargetGroupId,
        [Parameter(Mandatory = $true)][string]$MemberId
    )

    $result = az ad group member check --group $TargetGroupId --member-id $MemberId --output json | ConvertFrom-Json
    return [bool]$result.value
}

function Resolve-Group {
    param([Parameter(Mandatory = $true)][string]$Alias)

    $group = az ad group list --filter "mailNickname eq '$Alias'" --query "[0].{id:id, name:displayName}" --output json 2>$null | ConvertFrom-Json
    if (-not $group -or [string]::IsNullOrWhiteSpace($group.id)) {
        throw "No Entra group found with mail alias '$Alias'. Verify the alias is correct."
    }
    return [PSCustomObject]@{ Id = $group.id; Name = $group.name }
}

Test-AzCliAvailable
Test-AzLogin

$group = Resolve-Group -Alias $GroupAlias
$GroupId = $group.Id

# Group owners are never removed, regardless of authorship. Union them with the
# do-not-remove list passed in.
$ownerAliases = @(Get-GroupOwnerAlias -TargetGroupId $GroupId)
$effectiveDoNotRemove = @($DoNotRemove) + $ownerAliases | Sort-Object -Unique

Write-Information ''
Write-Information "Group       : $($group.Name) ($GroupId)"
Write-Information "Group alias : $GroupAlias"
Write-Information "Docs root   : $DocsRoot"
Write-Information "Do-not-add  : $(($DoNotAdd | Sort-Object) -join ', ')"
Write-Information "Do-not-rmv  : $($effectiveDoNotRemove -join ', ')"
Write-Information ''

$doNotAddSet = @{}
foreach ($a in $DoNotAdd) { $doNotAddSet[(ConvertTo-Alias -Value $a)] = $true }
$doNotRemoveSet = @{}
foreach ($r in $effectiveDoNotRemove) { $doNotRemoveSet[(ConvertTo-Alias -Value $r)] = $true }

Write-Information 'Generating article metadata...'
$csvPath = Invoke-MetadataExport -DocsRootPath $DocsRoot
try {
    $desiredAliases = Get-DesiredMemberAlias -CsvPath $csvPath
}
finally {
    Remove-Item -Path $csvPath -ErrorAction SilentlyContinue
}

$desiredSet = @{}
foreach ($alias in $desiredAliases) { $desiredSet[$alias] = $true }

Write-Information 'Reading current group members...'
$members = @(Get-GroupMember -TargetGroupId $GroupId)
$memberSet = @{}
foreach ($member in $members) { $memberSet[$member.Alias] = $member }

# Authors that are not currently members and are not on the do-not-add list.
$addCandidates = $desiredAliases | Where-Object {
    -not $memberSet.ContainsKey($_) -and -not $doNotAddSet.ContainsKey($_)
}

$toAdd = New-Object System.Collections.Generic.List[object]
$unresolvable = New-Object System.Collections.Generic.List[string]
foreach ($alias in $addCandidates) {
    $user = Resolve-AuthorToUser -Alias $alias
    if ($user) { $toAdd.Add($user) } else { $unresolvable.Add($alias) }
}
$toAdd = @($toAdd | Sort-Object Alias)
$unresolvable = @($unresolvable | Sort-Object)

# Members that are no longer article authors and are not on the do-not-remove list.
$toRemove = @($members | Where-Object {
    -not $desiredSet.ContainsKey($_.Alias) -and -not $doNotRemoveSet.ContainsKey($_.Alias)
} | Sort-Object Alias)

# Only authors. Exclude do-not-add
# Authors from desired, and exclude members that are not authors from group.
$desiredCounted = @($desiredAliases | Where-Object { -not $doNotAddSet.ContainsKey($_) })
$memberAuthors = @($members | Where-Object { $desiredSet.ContainsKey($_.Alias) })

Write-Information ''
Write-Information '================ PLANNED CHANGES ================'
Write-Information "Desired members     : $($desiredCounted.Count)"
Write-Information "Current members     : $($memberAuthors.Count)"
Write-Information ''

Write-Information "ADD ($($toAdd.Count)):"
if ($toAdd.Count -gt 0) {
    $toAdd | ForEach-Object { Write-Information "  + $($_.Alias)  ($($_.Upn))" }
}
else {
    Write-Information '  (none)'
}

Write-Information ''
Write-Information "REMOVE ($($toRemove.Count)):"
if ($toRemove.Count -gt 0) {
    $toRemove | ForEach-Object { Write-Information "  - $($_.Alias)  ($($_.Upn))" }
}
else {
    Write-Information '  (none)'
}

if ($unresolvable.Count -gt 0) {
    Write-Information ''
    Write-Information "SKIPPED - authors that could not be resolved to a user, not added ($($unresolvable.Count)):"
    $unresolvable | ForEach-Object { Write-Information "  ? $_" }
}
Write-Information '================================================='
Write-Information ''

if ($toAdd.Count -eq 0 -and $toRemove.Count -eq 0) {
    Write-Information 'No changes required.'
    return
}

if ($WhatIf) {
    Write-Information 'WhatIf specified; no changes applied.'
    return
}

$response = Read-Host 'Apply these changes? Type "yes" to proceed'
if ($response -ne 'yes') {
    Write-Information 'Aborted; no changes applied.'
    return
}

Write-Information ''
Write-Information 'Applying changes...'
foreach ($user in $toAdd) {
    az ad group member add --group $GroupId --member-id $user.Id --output none
    $verified = Test-GroupMembership -TargetGroupId $GroupId -MemberId $user.Id
    if ($verified) {
        Write-Information "  added   $($user.Alias)  (verified)"
    }
    else {
        Write-Warning "  add FAILED to verify for $($user.Alias) ($($user.Upn))"
    }
}
foreach ($member in $toRemove) {
    az ad group member remove --group $GroupId --member-id $member.Id --output none
    $stillMember = Test-GroupMembership -TargetGroupId $GroupId -MemberId $member.Id
    if (-not $stillMember) {
        Write-Information "  removed $($member.Alias)  (verified)"
    }
    else {
        Write-Warning "  remove FAILED to verify for $($member.Alias) ($($member.Upn))"
    }
}
Write-Information 'Done.'
