$here = $global:herePath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here\Test-MyRepo.ps1"

. "$here\Test-Helpers.ps1"
. "$here\Test-Spelling.ps1"

Describe "Test-Spelling" -Tags "Spelling" {

    It "Shouldn't have spelling errors" {
        
        $subfolders = Get-Subfolders $(Get-ExcludedSubfolders) $true
        Test-Spelling $(Get-DocsPath) $subfolders `
            | Should -Be 0
    }
}


## TODO: TESTS TO ADD

## Describe "Test-Breadcrumbs" {}

## Describe "Test-NextSteps" {}

## Inconsistent link descriptions for the same URL

## External link description doesn't match external URL's H1

## Enable MyRepo-Expressions to add to existing rules.

## Identify unused images

## No malformed tables
