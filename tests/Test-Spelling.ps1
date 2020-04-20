$here = $global:herePath

. "$here\Test-Helpers.ps1"

function Test-Spelling(
    [string] $docsPath,
    [string[]] $subfolders)
{
    Copy-SpellingDictionary "$docsPath\.."

    $count = 0
    foreach ($item in $subfolders)
    {
        Write-Host "Checking: $item"
        $output = Invoke-ExternalChecker 'cspell' $item '*' '--exclude *.svg'
        
        $expression = "Issues found: (?<issues>[0-9]*) in "
        $matches = ([regex]$expression).Matches($output)
        if ($matches.Count -gt 0)
        {
            $count += $matches.Groups[1].Value
        }
        else
        {
            throw "Unexpected process output: '$output'"
        }
    }

    return $count
} 

function Copy-SpellingDictionary(
    [String] $repoPath)
{
    $stream = New-Object System.IO.StreamReader "$repoPath\.vscode\settings.json"

    $text = $stream.ReadToEnd()

    $stream.Close()

    $text = $text.Replace('"cSpell.enabled": true,', '')
    $text = $text.Replace('cSpell.', '')

    Set-Content -Path "$repoPath\docs\.cspell.json" -Value $text.ToString()
}
