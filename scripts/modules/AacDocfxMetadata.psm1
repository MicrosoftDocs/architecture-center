Set-StrictMode -Version Latest

function Convert-GlobToRegex {
    <#
    .SYNOPSIS
        Converts a docfx fileMetadata glob pattern to an anchored regular expression.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Pattern
    )

    $normalized = $Pattern.Replace('\', '/')
    $escaped = [regex]::Escape($normalized)
    $escaped = $escaped.Replace('\*\*', '<<<DOUBLESTAR>>>')
    $escaped = $escaped.Replace('\*', '[^/]*')
    $escaped = $escaped.Replace('\?', '[^/]')
    $escaped = $escaped.Replace('<<<DOUBLESTAR>>>', '.*')
    return '^' + $escaped + '$'
}

function Resolve-DocfxUpdateCycle {
    <#
    .SYNOPSIS
        Resolves the ms.update-cycle value for a doc path, preferring the most
        specific matching pattern rule and falling back to the global default.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativeDocPath,

        [Parameter(Mandatory = $true)]
        [string]$GlobalDefault,

        [Parameter(Mandatory = $true)]
        [array]$PatternRules
    )

    $bestValue = $null
    $bestSpecificity = -1
    $path = $RelativeDocPath.Replace('\', '/')

    foreach ($rule in $PatternRules) {
        if ($path -match $rule.Regex) {
            if ($rule.Specificity -ge $bestSpecificity) {
                $bestSpecificity = $rule.Specificity
                $bestValue = $rule.Value
            }
        }
    }

    if ($bestValue) {
        return $bestValue
    }

    return $GlobalDefault
}

function Get-DocfxUpdateCycleConfig {
    <#
    .SYNOPSIS
        Reads ms.update-cycle settings from docfx.json, returning the global
        default and the compiled fileMetadata pattern rules.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$DocsRootPath
    )

    $docfxPath = Join-Path -Path $DocsRootPath -ChildPath 'docfx.json'
    $docfx = Get-Content -Path $docfxPath -Raw | ConvertFrom-Json

    # Schema is fixed: ms.update-cycle always lives under build.globalMetadata and build.fileMetadata.
    $fileMetadata = $docfx.build.fileMetadata.'ms.update-cycle'
    $rules = foreach ($property in $fileMetadata.PSObject.Properties) {
        $pattern = [string]$property.Name
        [PSCustomObject]@{
            Value = [string]$property.Value
            Regex = Convert-GlobToRegex -Pattern $pattern
            Specificity = ($pattern -replace '[\*\?]', '').Length
        }
    }

    return [PSCustomObject]@{
        GlobalDefault = [string]$docfx.build.globalMetadata.'ms.update-cycle'
        PatternRules = @($rules)
    }
}

Export-ModuleMember -Function Convert-GlobToRegex, Resolve-DocfxUpdateCycle, Get-DocfxUpdateCycleConfig
