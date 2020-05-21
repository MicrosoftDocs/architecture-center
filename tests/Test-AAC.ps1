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
        # 'guide/index.md'
    )
}

function Get-ExcludedSubfolders
{
    return @(
        '_bread',
        '_images',
        'aws-professional',
        # 'best-practices',
        'browse',
        'building-blocks',
        # 'checklist',
        'data-guide',
        'databricks-monitoring',
        'example-scenario',
        'framework',
        'guide',
        'high-availability',
        'includes',
        'microservices',
        'multitenant-identity',
        'networking',
        'patterns',
        'performance',
        'reference-architectures',
        'reliability',
        'resiliency',
        'resources',
        'serverless',
        'service-fabric',
        'solution-ideas',
        'topics'
    )
}

function Get-UrlPrefixesToIgnore {
    return @(
        "https://aka.ms",
        "https://adventure-works.com",
        "<endoflist>"
    )
}

function Get-TocFilesToIgnore {
    return @(
        # "guide/index.md"
    )
}

function Get-MyDomain { 
    return 'https://docs.microsoft.com'
}

function Get-MyRootUrl {
    return '/azure/architecture'
}

function Get-MyTocUrl {
    $path = (Join-Uri $(Get-MyDomain) $(Get-MyRootUrl)) 
    $path = (Join-Uri $path 'toc.json')
    return $path
}
