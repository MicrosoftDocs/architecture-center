$here = $global:herePath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here\Test-StringHelpers.ps1"

Describe Test-StringHelpers -Tag @("LongRunning") {

    BeforeAll {
        $testValue = 'One;;Two;;Three;;Four'
    }

    It "String helpers should work" {
        $i = 1
        Get-StringBeforeFirst $testValue ';;' | Should -Be 'One'
        Get-StringBeforeLast $testValue ';;' | Should -Be 'One;;Two;;Three'
        Get-StringAfterFirst $testValue  ';;' | Should -Be 'Two;;Three;;Four'
        Get-StringAfterLast $testValue  ';;' | Should -Be 'Four'
        Get-StringChopStart $testValue 'One' | Should -Be ';;Two;;Three;;Four'
        Get-StringChopStart $testValue 'Four' | Should -Be $testValue
        Get-StringChopEnd $testValue 'One' | Should -Be $testValue
        Get-StringChopEnd $testValue 'Four' | Should -Be 'One;;Two;;Three;;'
        Get-StringMustStartWith $testValue 'One;;' | Should -Be $testValue
        Get-StringMustStartWith $testValue 'Zero;;' | Should -Be "Zero;;$testValue"
        Get-StringMustEndWith $testValue ';;Four' | Should -Be $testValue
        Get-StringMustEndWith $testValue ';;Five' | Should -Be "$testValue;;Five"
    }
}