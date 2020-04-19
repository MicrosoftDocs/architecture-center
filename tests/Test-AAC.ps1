function Write-TestVerbose ([string] $output) {
    Write-Host $output      # Comment out this line to prevent verbose logging.
}

function Write-TestSuperVerbose ([string] $output)
{
    # Write-Host $output     # Comment out this line to prevent extremely verbose logging.
}

function Get-SpecificFilesToTest
{
    return @(
        # 'innovate\best-practices\data-dms.md'
        # 'getting-started\manage-costs.md',
        # 'reference/networking-vdc.md'    
    )
}

function Get-ExcludedSubfolders
{
    return @(
        # 'organize/archive'
        '_bread',
        '_images',
        'solution-ideas'
        #,
        # 'getting-started',
        # 'organize'
    )
}

function Get-MyDomain { 
    return 'https://docs.microsoft.com'
}

function Get-MyRootUrl {
    return '/azure/cloud-adoption-framework'
}

function Get-MyTocUrl {
    $path = (Join-Uri $(Get-MyDomain) $(Get-MyRootUrl)) 
    $path = (Join-Uri $path 'toc.json')
    return $path
}

function Get-UrlPrefixesToIgnore {
    return @(
        "aka.ms",
        "https://youtube.com"
    )
}

function Get-TocFilesToIgnore {
    return @(
        ## TODOBACKLOG: Split data classification into two files using INCLUDEs.
        "govern/policy-compliance/data-classification.md",
        "migrate/azure-migration-guide/prerequisites.md",
        "migrate/azure-migration-guide/secure-and-manage.md",
        "reference/migration-with-enterprise-scaffold.md"
    )
}
