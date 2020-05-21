$here = $global:herePath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here\Test-MyRepo.ps1"

. "$here\Test-Expressions.ps1"
. "$here\Test-Helpers.ps1"
. "$here\Test-LocalPaths.ps1"
. "$here\Test-Words.ps1"
. "$here\Test-TOC.ps1"

Describe "Test-PageContent" -Tags "Content" {

    BeforeAll {
        $files = Get-ContentFiles $(Get-ExcludedSubfolders)
    }

    It "All known phrases are cased properly" {
        
        Test-AllMatches $files $(Get-CasingExpressions) WordsWithCasing `
            | Should -Be 0

    }

    It "All terms are valid" {
        
        Test-AllMatches $files $(Get-InvalidTermExpressions) Words `
            | Should -Be 0
    }
    
    It "All punctuation style is correct" {

        Test-AllMatches $files $(Get-PunctuationExpressions) Verbatim `
            | Should -Be 0

    }

    It "All markdown formatting is correct" {

        Test-AllMatches $files $(Get-FormattingExpressions) Verbatim `
            | Should -Be 0

    }

    AfterAll {
        $files = $null
    }
}

Describe "Test-PageLinks" -Tag @("Links", "LongRunning") {

    BeforeAll {
        $files = Get-ContentFiles $(Get-ExcludedSubfolders)
    }

    It "All local links exist" {

        Test-AllLocalPaths $files | Should -Be 0
    }

    It "All links are well-formed" {

        Test-AllMatches $files $(Get-MalformedLinkExpressions) Verbatim `
            | Should -Be 0
    }

    It "All external page links are valid" {
        
        Test-AllMatches $files '' LinkValidation `
            | Should -Be 0
    }

    AfterAll {
        $files = $null
    }
}

Describe Test-LinkTitles -Tag @("Review") {
    
    It "Link titles should match" {
        
        $files = Get-ContentFiles $(Get-ExcludedSubfolders)
        $expression = "\[(?<name>.*)]\(?<value>$(Get-RegexForUrl))"
        #TODO Test-AllMatches $files $expression 
    }

}

Describe "Test-OneExpression" -Tags @("Review") {

    It "Testing one expression" {
        $files = @( $(Get-Item "C:\Repos_Fork\cloud-adoption-framework-pr\docs\getting-started\team\cloud-adoption.md"))
        #$expression = "(?s)# Step.*Accountable.*Deliverable.*Guidance"

        $files = Get-ContentFiles $(Get-ExcludedSubfolders)
        $expression = "(?s)# Step[^\*]*?Accountable"

        Test-AllMatches $files @($expression) Verbatim `
           | Should -Be 0
    }
}
