param (
    [string]$docsPath = ''
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\Test-Constants.ps1"

function Test-NextSteps([String] $docsPath)
{
    # if ($docsPath.Trim().Length -eq 0)
    if (-not (Test-Path $docsPath))
    {
        throw "Invalid path '$docsPath'."
    }
    
    $tocFile = "$docsPath\toc.yml"

    [System.Collections.Queue]$toc = Read-FlatTocAsQueue $tocFile

    $ignore = $false
    $url = ''
    $relativeUrl = ''
    $ignoreDirective = '<!-- test:ignoreNextStep -->'

    while ($toc.Count -gt 0)
    {
        $item = $toc.Dequeue()
        
        $name = $item[0]
        $href = $item[1]
        Write-Host "NAME: $name :: $href"

        if ($href.StartsWith("http"))
        {
            ## TODO: Test URL.
        }
        else
        {
            $testTocUrl = (resolve-path (join-path $docsPath $href)).Path
            $testContentUrl = if ($url.Length -gt 0) { (resolve-path $url).Path } else { '' }

            if ($ignore -eq $false -and $relativeUrl.Length -gt 0 -and (-not $testTocUrl -eq $testContentUrl))
            {
                Write-Host "***THROW: Next Step doesn't match the TOC: $filePath"
            }

            $filePath = (resolve-path (join-path $docsPath $href)).Path
            $c = Get-Content $filePath
            $i = $c.Count

            if ($c[$i - 1] -eq $ignoreDirective)
            {
                $ignore = $true
                continue
            }

            $blankLine1 = $c[$i] 
            $urlLine = $c[$i - 1]
            $divLine = $c[$i - 2]
            $blankLine2 = $c[$i - 3]
            $lastParagraphLine = $c[$i - 4]

            if ($blankLine1.Length -gt 0)
            {
                throw "Last line not blank: $filePath"
            }

            $expression = "\> \[.*\]\((.*)\)"
            
            $matches = ([regex]$expression).Matches($urlLine)
            if ($matches.Count -eq 1)
            {
                $relativeUrl = $($matches[0].Captures[0].Groups[1].Value)
                $thisFolder = $filePath.Substring(0, $filePath.LastIndexOf('\') + 1)
                if ($relativeUrl.StartsWith('http'))
                {
                    Write-Host "***THROW: Unexpected HTTP path [$relativeUrl] for next step in: $filePath"
                }
                else
                {
                    $url = (resolve-path (join-path $thisFolder $relativeUrl)).Path
                    if ((test-path $url) -eq $false)
                    {
                         Write-Host "***THROW: File [$url] not found as specified in: $filePath"
                    }
                }
            }
            elseif ($matches.Count -ne 1) 
            {
                Write-Host "***THROW: Next step not included in file: $filePath"
            }
            elseif ($divLine -ne '> [!div class="nextstepaction"]')
            {
                Write-Host "***THROW: Invalid format for nextstepaction div: $filePath"
            }
            elseif ($blankLine2.Length -gt 0)
            {
                Write-Host "***THROW: Preceding line not blank: $filePath"
            }

            $ignore = ($lastParagraphLine -eq $ignoreDirective)
        }
    }
}

function Read-FlatTocAsQueue
{
    [OutputType([System.Collections.Queue])]
    Param (
        [parameter(Mandatory=$true)]
        [String] $tocFile
    )

    $tocQ = New-Object System.Collections.Queue

    $reader = [System.IO.File]::OpenText($tocFile)

    $name = ''
    $href = ''

    while($null -ne ($line = $reader.ReadLine())) {
        
        $trimmedLine = $line.Replace(' - ', '').Trim()

        if ($trimmedLine -eq '') {
            continue
        }

        if ($trimmedLine.StartsWith("name: "))
        {
            $name = $trimmedLine.Substring(6)
        }
        elseif ($trimmedLine.StartsWith("href: "))
        {
            $href = $trimmedLine.Substring(6)
        }

        if ($name -ne '' -and $href -ne '')
        {
            $tocQ.Enqueue(@($name, $href))
            $name = ''
            $href = ''
        }
    }

    return $tocQ
}

Test-NextSteps $docsPath
return


# $regexForUrl = Get-RegexForUrl

# $text = Get-Content $tocFile

# $hits = ([regex]$regexForUrl).Matches($text)

# if ($hits.Count -gt 0)
# {
#     for ($i = 0; $i -lt $hits.Groups.Count; $i++)
#     {
#         $value = $hits.Groups[$i].Value.Replace('href: ', '')
#         $uri = $value.Replace('https://docs.microsoft.com/', 'https://docs.microsoft.com/en-us/')
        
#         try
#         {
#             $request = Invoke-WebRequest $uri -MaximumRedirection 0 -ErrorAction Ignore

#             if ($request.StatusCode -ne 200)
#             {
#                 Write-Host "$($request.StatusCode): $value"
#             }
#             else
#             {
#             }
#         }
#         catch
#         {
#             Write-Host "EXCEPTION: $value"
#         }
#     }
# }
