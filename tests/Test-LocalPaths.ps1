$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here/Test-Constants.ps1"
. "$here/Test-StringHelpers.ps1"

function Test-AllLocalPaths(
    [System.IO.FileInfo[]] $files
    )
{
    $count = 0

    foreach ($file in $files) {
        try {
            Write-TestSuperVerbose "Testing local paths in $($file.FullName)"
            $result = Test-LocalPaths $file
            $count += $result
        }
        catch {
            Write-Host "Test-AllLocalPaths: EXCEPTION IN $($file.FullName)"
        }
    }

    return $count
}

function Test-LocalPaths([System.IO.FileSystemInfo] $file)
{
    $expressions = @(
        "\([a-zA-Z0-9-\/\._]*\.(md|yml|png|jpg|svg)[\)#]",
        "\[[a-zA-Z0-9-\/\._]*\]: [a-zA-Z0-9-\/\.:_]*",
        "<a href=""\.[a-zA-Z0-9-\/\._]*",
        "<img src=""\.[a-zA-Z0-9-\/\._]*",
        "redirect_url"": ""https:\/\/docs.microsoft.com\/azure\/cloud-adoption-framework\/.*""",
        "href: [a-zA-Z0-9-\/\._]*\.md"
    )

    $text = Get-FileContents $file
    $count = 0

    foreach ($expression in $expressions) {
        
        if ($expression.Trim().Length -gt 0) {

            $matches = [regex]::new($expression).Matches($text)

            foreach ($match in $matches) {   
                
                $relativePath = $match.Value
                $relativePath = Get-StringChopStart $relativePath "<a href="""
                $relativePath = Get-StringChopStart $relativePath "<img src="""
                
                if ($relativePath.StartsWith("["))
                {
                    if ((-not $relativePath.Contains("/")))
                    {
                        continue
                    }

                    $linkName = $relativePath.Substring(0, $relativePath.IndexOf(":"))
                    $selection = ($text | select-string -Pattern $linkName.Replace('[', '\[').Replace(']', '\]') -AllMatches)
                    if ($selection.Matches.Count -lt 2)
                    {
                        Write-Host "ORPHANED LINK IN $($file.FullName):  $linkName"
                        $count++
                    }

                    if ($relativePath.Contains("https:"))
                    {
                        continue
                    }

                    $relativePath = $relativePath.Substring($relativePath.IndexOf(":") + 2)
                }
                elseif ($relativePath.StartsWith('(') -and ($relativePath.EndsWith(')') -or $relativePath.EndsWith('#') ))
                {
                    $relativePath = $($relativePath.Substring(1, $relativePath.Length - 2))
                }
                elseif ($relativePath.StartsWith('redirect_url'))
                {
                    $relativePath = $($relativePath.Substring(74, $relativePath.Length - 75)) + ".md"
                }
                
                $relativePath = Get-StringChopStart $relativePath 'href: '
                $relativePath = Get-StringChopStart $relativePath '"'

                $absolutePath = join-path $($file.DirectoryName) $relativePath

                try
                {
                    Write-TestSuperVerbose "TESTING PATH IN '$($file.Name)': $absolutePath"
                    if ((test-path $absolutePath) -eq $false)
                    {
                        Write-Host "COULDN'T FIND IN $($file.FullName):  $absolutePath" 
                        $count++
                    }
                }
                catch
                {
                    throw $_
                }
            }
        }
    }

    return $count
}
