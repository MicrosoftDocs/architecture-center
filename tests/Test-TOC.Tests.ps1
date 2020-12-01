$here = $global:herePath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here\Test-MyRepo.ps1"

. "$here\Test-Helpers.ps1"
. "$here\Test-TOC.ps1"
. "$here\Test-Words.ps1"

Describe "Test-TOC" -Tags "TOC" {

    It "No TOC items are orphaned or duplicated" {
        Test-MatchTocToFiles $(Get-TocFilePath) $(Get-TocFilesToIgnore) | Should -Be 0
    }
}

Describe "Test-TocExternalLinks" -Tags @("Links", "LongRunning") {

    It "All TOC external links are valid" {
        # Test-ExternalLinks $(Get-TocFilePath) | Should -Be 0

        $files = Get-ContentFiles $(Get-ExcludedSubfolders)
        Test-AllMatches $files '' LinkValidation `
            | Should -Be 0
    }
}

Describe "Test-SpecificLinks" -Tag "Links" {
    
    It "Broken link is invalid" {
        $uri = "https://docs.microsoft.com/azure/BROKEN/guide/technology-choices/compute-decision-tree"
        Test-Uri $uri | Should -Be -1
    }

    It "EN-US link is invalid" {
        $uri = "https://docs.microsoft.com/en-us/powerapps/maker"
        Test-Uri $uri | Should -Be -1
    }

    It "Querystring redirect link is valid" {
        $uri = "https://docs.microsoft.com/azure/devops/project/feedback"
        Test-Uri $uri | Should -Be 200
    }

    It "Expected trailing slash link is valid" {
        $uri = "https://docs.microsoft.com/powerapps/maker"
        Test-Uri $uri | Should -Be 200
    }

    It "Docs link is valid" {
        $uri = "https://docs.microsoft.com/azure/architecture"
        Test-Uri $uri | Should -Be 200
    }

    It "External link is valid" {
        $uri = "https://guides.github.com/introduction/git-handbook"
        Test-Uri $uri | Should -Be 200
    }

    It "TempTest link is valid" {
        $uri = "https://docs.microsoft.com/azure/devops/project/feedback"
        Test-Uri $uri | Should -Be 200
    }
}
