$here = $global:herePath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here\Test-MyRepo.ps1"

. "$here\Test-Helpers.ps1"
. "$here\Test-Markdown.ps1"

Describe "Test-Markdown" -Tags "Markdown" {

    It "Shouldn't have markdownlint errors" {

        $subfolders = Get-Subfolders $(Get-ExcludedSubfolders) $true
        Test-Markdown $(Get-DocsPath) $subfolders `
            | Should -Be 0
    }
}
