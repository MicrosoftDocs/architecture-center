$here = $global:herePath

. "$here\Test-Helpers.ps1"

function Test-Markdown(
    [string] $docsPath,
    [string[]] $subfolders)
{
    $count = 0
    foreach ($item in $subfolders)
    {
        Write-Host "Checking: $item"
        $output = Invoke-ExternalChecker 'markdownlint' $item 'md'

        $expression = " MD[0-9][0-9][0-9]"
        $matches = ([regex]$expression).Matches($output)
        $count += $matches.Count
    }

    return $count
}
