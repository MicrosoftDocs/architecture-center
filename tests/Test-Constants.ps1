function Get-RegexForUrl
{
    $regexForUrlPath = Get-StringChopStart $(Get-RegexForUrlPath) '(?i)'
    return "(?i)$(Get-RegexForDomainName)$regexForUrlPath"
}

function Get-RegexForDocsUrl
{
    $regexForUrlPath = Get-StringChopStart $(Get-RegexForUrlPath) '(?i)'
    return "(?i)https?://docs\.microsoft\.com/$regexForUrlPath"
}

function Get-RegexForDomainName
{
    return '(?i)https?://[a-zA-Z0-9-\.]*/?'
}

function Get-RegexForUrlPath
{
    return '(?i)[a-zA-Z0-9/\-:\.&=_%\+\?#,]*'
}

function Get-RegexForImagePath
{
    return '(?i)[a-zA-Z0-9\/\-:\.&=_%\+]*\.(png|jpg|svg)'
}

function Get-RegexForWordBoundaryPrefix
{
    return '[^\.\/]'
}

function Get-RegexForWordBoundarySuffix
{
    return '[^-0-9\.]'
}

function Get-RegexForIgnoredTerms
{
    return "<!-- cSpell:ignore [A-Za-z' ]* -->"
}

function Get-FileContents(
    [System.IO.FileInfo] $file
)
{
    $text = Get-Content -Path $file.FullName -Raw
    return $text
}
