$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here/Test-Constants.ps1"

function Test-AllMatches {
    [CmdletBinding()]    
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]] $files,
        [string[]] $expressions,
        [ValidateSet('Words', 'WordsWithCasing', 'Verbatim', 'LinkValidation', 'PotentialIssues')]
        [string] $validationType,
        [bool] $forceSuccess = $false
    )

    $useWordBoundaries = $false
    $ignoreUrlContents = $false
    $requireCasingMatch = $false
    $testLinks = $false

    switch -Exact ($validationType)
    {
        'Words' 
        { 
            $useWordBoundaries = $true
            $ignoreUrlContents = $true
            break 
        }
        'WordsWithCasing' 
        { 
            $useWordBoundaries = $true
            $ignoreUrlContents = $true
            $requireCasingMatch = $true
            break 
        }
        'Verbatim'
        { 
            break 
        }
        'LinkValidation' 
        { 
            $testLinks = $true
            break 
        }
        Default { throw "validationType is invalid"}
    }

    $count = 0
    
    foreach ($file in $files)
    {
        $result = Test-Match $file $expressions `
            -UseWordBoundaries $useWordBoundaries `
            -IgnoreUrlContents $ignoreUrlContents `
            -RequireCasingMatch $requireCasingMatch `
            -TestLinks $testLinks

        $count += $result
    }

    if ($forceSuccess)
    {
        return 0
    }

    return $count
}

function Test-Match(
    [System.IO.FileInfo] $file, 
    [string[]] $expressions,
    [bool] $useWordBoundaries, 
    [bool] $ignoreUrlContents,
    [bool] $requireCasingMatch,
    [bool] $testLinks
    )
{
    $count = 0
    $text = Get-FileContents $file
    
    if ($testLinks)
    {
        $expressions = @($(Get-RegexForUrl))
        Write-TestVerbose "Testing links for: $($file.FullName)"
    }
    else
    {
        if ($ignoreUrlContents)
        {
            $text = Remove-Urls $text 
            $text = Remove-ImagePaths $text
        }

        $text = Remove-NonbreakingSpaces $text
        # TODO: $text = Remove-Html $text   -- &nbsp, <br>, etc.
    }

    foreach ($originalExpression in $expressions) {
    
        if ($originalExpression.Trim().Length -gt 0) {

            $expression = $originalExpression
            if ($expression.EndsWith('$') -and (-not $expression.EndsWith('\r?$')))
            {
                # Handle nonstandard .NET processing of $ (endline) character.
                $expression = "$($expression.Substring(0, $expression.Length - 1))\r?$"
                Write-TestSuperVerbose "FIXED EXPRESSION: $expression"
            }

            if ($useWordBoundaries)
            {
                $expression = "(?i)\b$originalExpression\b"
            }
            elseif ($requireCasingMatch) 
            {
                # TODO: Don't flag capitalization at the beginning of a sentence.
                $expression = "(?i)\b$originalExpression\b"
            }
            
            $options = [Text.RegularExpressions.RegexOptions]::Multiline
            $matches = [regex]::new($expression, $options).Matches($text)

            foreach ($match in $matches) {
            
                if ($testLinks)
                {
                    $uri = $match.Value

                    Write-TestSuperVerbose $uri
                    $result = Test-Uri $uri
                    
                    if ($result -ne 200)
                    {
                        Write-Host "RESULT in $($file.Name): $result - $uri"
                        $count++
                    }
                }
                elseif ($requireCasingMatch)
                {
                    if (-not ($match.Value -clike $originalExpression))
                    {
                        Write-Host "Case mismatch '$($match.Value)' in $($file.FullName)"
                        $count++
                    }
                }
                elseif ($useWordBoundaries)
                {
                    $ignoredTermsMatches = [regex]::new($(Get-RegexForIgnoredTerms), $options).Matches($text)
                    $ignoredTerms = if ($ignoredTermsMatches.Count -gt 0) { $ignoredTermsMatches.Groups[0].Value } else { "" }

                    if ($ignoredTerms -notlike "* $($match.Value) *")
                    {
                        Write-MatchInfo $file.FullName $expression $match.Value
                    }
                    else 
                    {
                        Write-TestSuperVerbose "Ignored match '$($match.Value)' found in $($file.FullName)"
                    }
                }
                else
                {
                    Write-MatchInfo $file.FullName $expression $match.Value
                    $count++
                }
            }
        }
    }

    return $count
}

function Write-MatchInfo(
    [string] $fileName, 
    [string] $expression, 
    [string] $value)
{
    if ($value.Length -gt 100)
    {
        $value = "$($value.Substring(0,100))..."
    }
    
    Write-Host "Match found in $fileName"
    Write-Host "    EXPRESSION: $expression"
    Write-Host "    VALUE: $value"
}

function Remove-Urls(
    [string]$text) 
{
    $token = "replace-url-match"
    $result = $text
    $matches = [regex]::new($(Get-RegexForUrl)).Matches($text)

    foreach ($match in $matches)
    {
        $result = $result.Replace("$($match.Value)", $token)
    }

    $regex = Get-StringChopStart $(Get-RegexForUrlPath) '(?i)' 
    $expression = "(?i)$token/$regex"

    do {
        $text = $result 
        $matches = [regex]::new($expression).Matches($text)

        foreach ($match in $matches)
        {
            $result = $result.Replace("$($match.Value)", $token)
        }
    } while ($matches.Count -gt 0)

    return $result
}

function Remove-ImagePaths(
    [string]$text) 
{
    return Remove-Matches $(Get-RegexForImagePath) $text
}

function Remove-NonbreakingSpaces(
    [string]$text
)
{
    return Remove-Matches "&nbsp;" $text
}
function Remove-Matches(
    [string] $expression,
    [string] $text
)
{
    $result = $text
    $matches = [regex]::new($expression).Matches($text)

    foreach ($match in $matches)
    {
        $result = $result.Replace($match.Value, "")
    }

    return $result
}
