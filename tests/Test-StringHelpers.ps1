function Get-StringAfterFirst([string] $source, [string] $value)
{
    return $(Get-StringAfter $source $value $true)
}

function Get-StringAfterLast([string] $source, [string] $value)
{
    return $(Get-StringAfter $source $value $false)
}

function Get-StringBeforeFirst([string] $source, [string] $value)
{
    return $(Get-StringBefore $source $value $false)
}

function Get-StringBeforeLast([string] $source, [string] $value)
{
    return $(Get-StringBefore $source $value $true)
}

function Get-StringChopStart([string] $source, [string] $value)
{
    if ($null -eq $source)
    {
        return $null
    }

    ## TODO: Use 'CurrentCultureIgnoreCase'?
    if ($null -ne $value -and $source.StartsWith($value))
    {
        return $source.Substring($value.Length)
    }

    return $source
}

function Get-StringChopEnd([string] $source, [string] $value)
{
    if ($null -eq $source)
    {
        return $null
    }

    if ($null -ne $value -and $source.EndsWith($value))
    {
        return $source.Substring(0, $source.Length - $value.Length)
    }

    return $source
}

function Get-StringStartsWith([string] $source, [string[]] $values)
{
    if ($null -eq $source -or $null -eq $values)
    {
        return $false
    }
    
    $count = @($values | Where-Object { $null -ne $_ -and $_.StartsWith($source) }).Count
    return $($count -gt 0)
}

function Get-StringEndsWith([string] $source, [string[]] $values)
{
    if ($null -eq $source -or $null -eq $values)
    {
        return $false
    }

    $count = @($values | Where-Object { $null -ne $_ -and $_.EndsWith($source) }).Count
    return $($count -gt 0)
}

function Get-StringMustStartWith([string] $source, [string] $value)
{
    return $(if ($source.StartsWith($value)) { $source } else { "$value$source" })
}

function Get-StringMustEndWith([string] $source, [string] $value)
{
    if ($null -eq $source)
    {
        return $null
    }

    return $(if ($source.EndsWith($value)) { $source } else { "$source$value" })
}

function Get-StringClip([string] $source, [int] $size)
{
    if ($null -eq $source)
    {
        return $null
    }

    if ($source.Length -gt $size)
    {
        $source = $source.Substring(0, $size)
    }

    return $source
}

function Get-StringAfter([string] $source, [string] $value, [bool] $afterFirst)
{
    if ($source -eq $null)
    {
        return $null
    }

    if ($value -eq $null)
    {
        return ''
    }

    $index = if($afterFirst) { $source.IndexOf($value) } else { $source.LastIndexOf($value) }

    if ($index -eq -1 -or $source.Length -eq 0 -or $value.Length -eq 0)
    {
        return ''
    }

    return $source.Substring($index + $value.Length)
}

function Get-StringBefore([string] $source, [string] $value, [bool] $beforeLast)
{
    if ($null -eq $source)
    {
        return $null
    }

    if ($null -eq $value)
    {
        return ''
    }

    $index = if ($beforeLast) { $source.LastIndexOf($value) } else { $source.IndexOf($value) }

    if ($index -eq -1 -or $source.Length -eq 0 -or $value.Length -eq 0)
    {
        return ''
    }

    return $source.Substring(0, $index)
}
