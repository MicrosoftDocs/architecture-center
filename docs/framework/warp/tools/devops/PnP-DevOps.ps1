<# Instructions to use this script
PnP-DevOps.ps1 <url to project in Azure Devops>

example: PnP-DevOps.ps1 https://dev.azure.com/demo-org/demo-project

#>
#Get PAT from a keys.txt file
Get-Content keys.txt | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

#get the Azure Devops project URL and re-create it here.
$uri=[uri]$args[0]
$UriOrganization = $uri.scheme +"://" + $uri.Host +"/" + $uri.segments[1]

#Grab the project name from the dev-ops url given in the command line.
$projectname = $uri.segments[-1].Trim("/")
$projectname = $projectname +"/"

#Get the working directory from the script
$workingDirectory = $PSScriptRoot

#Get the WAF report via a system dialog
Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "CSV (*.csv)| *.csv"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

$inputfile = Get-FileName $workingDirectory
$inputfilename = Split-Path $inputfile -leaf
$content = get-content $inputfile

$ExistingDevopsWI = New-Object System.Collections.ArrayList
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }
$result = $null

$reportDate = Get-Date -Format "MM-dd-yyyy HH.mm.s"
$tableStart = $content.IndexOf("Category,Link-Text,Link,Priority,ReportingCategory,ReportingSubcategory,Weight,Context")
$tableEnd = $content.IndexOf("-----------,,,,,") - 1
$csv = $content[$tableStart..$tableEnd] | Out-File  "$workingDirectory\$reportDate.csv"
$DevOpsList = Import-Csv -Path "$workingDirectory\$reportDate.csv"

#we ask the end user if they are ready to put data into their ticket system.
Write-Output "This script is using the WAF report:" $inputfilename
Write-Host "This script will insert data into Azure DevOps org:" $UriOrganization.Trim("/")"."
Write-Host "This will insert" (Get-Content "$workingDirectory\$reportDate.csv").Length "items into the" $projectname.Trim("/") "project."
Write-Host "We are using the Azure DevOps token that starts with "$AzureDevOpsPAT.substring(0, 5)
$confirmation = Read-Host "Ready? [y/n]"
while($confirmation -ne "y")
{
    if ($confirmation -eq 'n') {exit}
    $confirmation = Read-Host "Ready? [y/n]"
}

<#
List of allowed values for Categories
General
Application Design
Health Modelling & Monitoring
Capacity & Service Availability Planning
Application Platform Availability
Data Platform Availability
Networking & Connectivity
Scalability & Performance
Security & Compliance
Operational Procedures
Deployment & Testing
Operational Model & DevOps
Compute
Data
Hybrid
Storage
Messaging
Networking
Identity & Access Control
Performance Testing
Troubleshooting
SAP
Efficiency and Sizing
Governance


$data = Get-Content -Path "C:\categories.json" | ConvertFrom-Json
foreach($category in $data)
{
    Write-Host "CATEGORY: $($category.title)" -ForegroundColor Green
    foreach($subcategory in $category.subCategories)
    {
        $($subcategory.title)
    }
}
#>

$EpicRelationshipStringBuilder = @'
{"rel": "System.LinkTypes.Hierarchy-Reverse", "url": "EPICURLPLACEHOLDER", "attributes": {"comment": "Making a new link for the dependency"}}
'@

$EpicRelations = [pscustomobject]@{
"General" = "";
"Application Design" = "";
"Health Modelling & Monitoring" = "";
"Capacity & Service Availability Planning" = "";
"Application Platform Availability" = "";
"Data Platform Availability" = "";
"Networking & Connectivity" = "";
"Scalability & Performance" = "";
"Security & Compliance" = "";
"Operational Procedures" = "";
"Deployment & Testing" = "";
"Operational Model & DevOps" = "";
"Compute" = "";
"Data" = "";
"Hybrid" = "";
"Storage" = "";
"Messaging" = "";
"Networking" = "";
"Identity & Access Control" = "";
"Performance Testing" = "";
"Troubleshooting" = "";
"SAP" = "";
"Efficiency and Sizing" = "";
"Governance" = "";
"Uncategorized" = "";
}

#endregion

#region Clean the uncategorized data

foreach($lineData in $DevOpsList)
{
    if(!$lineData.ReportingCategory)
    {
        $lineData.ReportingCategory = "Uncategorized"
    }
}

#endregion

function Get-RecommendationsFromContentService
{
param(
[parameter (Mandatory=$true, position=1)]
[string]$contentservice
)
    try
    {            
        $ContentServiceResult = Invoke-RestMethod -Method Get -uri $($ContentServiceUri + "$contentservice\") -Headers $ContentServiceHeader
        foreach($row in $ContentServiceResult)
        {
                $listItem = [pscustomobject]@{
                    "Assessment" = $row.Assessment;
                    "ID" = $row.Id;
                    "Name" = $row.Name;
                    "WhyConsiderThis" = $row.WhyConsiderThis;
                    "Context" = $row.Context;
                    "LearnMore" = $row.LearnMore;
                    "HowToTroubleshoot" = $row.HowToTroubleshoot;
                    "SuggestedActions" = $row.SuggestedActions;
                    "Score" = $row.Score;
                    "Impact" = $row.Impact;
                    "Effort" = $row.Effort;
                    "Probability" = $row.Probability;
                    "Weight" = $row.Weight;
                    "FocusArea" = $row.FocusArea;
                    "FocusAreaId" = $row.FocusAreaId;
                    "ActionArea" = $row.ActionArea;
                    "ActionAreaId" = $row.ActionAreaId;
                }
                if(!$RecommendationHash.Contains($listItem))
                {
                $RecommendationHash.Add($listItem) | Out-Null
                }
        }
    }
    catch{Write-Output "Exception in calling content service for $contentservice : " + $Error[0].Exception.ToString()}
}

#ContentService
#$ContentServiceHeader = @{'Ocp-Apim-Subscription-Key'= ''}
#$ContentServiceUri = "https://serviceshub-api-prod.azure-api.net/content/contentdefinition/v1.0/"
#$RecommendationHash = New-Object System.Collections.ArrayList
#Get-RecommendationsFromContentService -contentservice "ASOCA"
$RecommendationHash = Get-Content "$workingDirectory\WASA.json" | ConvertFrom-Json


#Search DevOps for existing Epics for each WAF Category & Create a relationship mapping to link these epics to work items
function Create-EpicsforFocusArea
{
#Iterate entire devops issues
<#
$body = "{
  `"query`": `"Select * From WorkItems Where [System.TeamProject] = @project AND [Work Item Type] = 'Epic' AND [State] <> 'Closed' AND [State] <> 'Removed' AND [Title] = 'Availability and Business Continuity' OR [Title] = 'Business/IT Alignment' OR [Title] = 'Change and Configuration Management' OR [Title] = 'Operations and Monitoring' OR [Title] = 'Performance and Scalability' OR [Title] = 'Security and Compliance' OR [Title] = 'Upgrade, Migration and Deployment'`"
}"

$getQueryUri = $UriOrganization + $projectname + "_apis/wit/wiql?api-version=6.0-preview.2"
$AllEpics = Invoke-RestMethod -Uri $getQueryUri -Method POST -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader -Body $body
#>

$body = "{
  `"query`": `"SELECT
    [System.Id],
    [System.WorkItemType],
    [System.Title],
    [System.AssignedTo],
    [System.State],
    [System.Tags]
FROM workitems
WHERE
    [System.TeamProject] = @project
    AND [System.WorkItemType] = 'Epic'
    AND [System.State] <> ''`"}"

$getQueryUri = $UriOrganization + $projectname + "_apis/wit/wiql?api-version=6.0-preview.2"
$AllEpics = Invoke-RestMethod -Uri $getQueryUri -Method POST -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader -Body $body

$ExistingFocusAreas = [pscustomobject]@{
"General" = $false;
"Application Design" = $false;
"Health Modelling & Monitoring" = $false;
"Capacity & Service Availability Planning" = $false;
"Application Platform Availability" = $false;
"Data Platform Availability" = $false;
"Networking & Connectivity" = $false;
"Scalability & Performance" = $false;
"Security & Compliance" = $false;
"Operational Procedures" = $false;
"Deployment & Testing" = $false;
"Operational Model & DevOps" = $false;
"Compute" = $false;
"Data" = $false;
"Hybrid" = $false;
"Storage" = $false;
"Messaging" = $false;
"Networking" = $false;
"Identity & Access Control" = $false;
"Performance Testing" = $false;
"Troubleshooting" = $false;
"SAP" = $false;
"Efficiency and Sizing" = $false;
"Governance" = $false;
"Uncategorized" = $false;
}

try
{
#Gather details per devops item
if($AllEpics.workItems.Count -gt 0)
{
    Write-Output "There are $($AllEpics.workItems.Count) Epics in DevOps"
    foreach($epic in $AllEpics.workItems.id)
    {
        $getEpicQueryUri = $UriOrganization + $projectname + "_apis/wit/workitems/" + $epic + "?api-version=6.0-preview.2"
        $EpicworkItem = Invoke-RestMethod -Uri $getEpicQueryUri -Method GET -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader
        if($EpicworkItem.fields.'System.Title' -eq "General")
        {
            $ExistingFocusAreas.General = $true;
            $EpicRelations.General = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Application Design")
        {
            $ExistingFocusAreas.'Application Design' = $true
            $EpicRelations.'Application Design' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Health Modelling & Monitoring")
        {
            $ExistingFocusAreas.'Health Modelling & Monitoring' = $true
            $EpicRelations.'Health Modelling & Monitoring' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Capacity & Service Availability Planning")
        {
            $ExistingFocusAreas.'Capacity & Service Availability Planning' = $true
            $EpicRelations.'Capacity & Service Availability Planning' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Application Platform Availability")
        {
            $ExistingFocusAreas.'Application Platform Availability' = $true
            $EpicRelations.'Application Platform Availability' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Data Platform Availability")
        {
            $ExistingFocusAreas.'Data Platform Availability' = $true
            $EpicRelations.'Data Platform Availability' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Networking & Connectivity")
        {
            $ExistingFocusAreas.'Networking & Connectivity' = $true
            $EpicRelations.'Networking & Connectivity' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Scalability & Performance")
        {
            $ExistingFocusAreas.'Scalability & Performance' = $true
            $EpicRelations.'Scalability & Performance' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Security & Compliance")
        {
            $ExistingFocusAreas.'Security & Compliance' = $true
            $EpicRelations.'Security & Compliance' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Operational Procedures")
        {
            $ExistingFocusAreas.'Operational Procedures' = $true
            $EpicRelations.'Operational Procedures' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Deployment & Testing")
        {
            $ExistingFocusAreas.'Deployment & Testing' = $true
            $EpicRelations.'Deployment & Testing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Operational Model & DevOps")
        {
            $ExistingFocusAreas.'Operational Model & DevOps' = $true
            $EpicRelations.'Operational Model & DevOps' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Compute")
        {
            $ExistingFocusAreas.Compute = $true
            $EpicRelations.Compute = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Data")
        {
            $ExistingFocusAreas.Data = $true
            $EpicRelations.Data = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Hybrid")
        {
            $ExistingFocusAreas.Hybrid = $true
            $EpicRelations.Hybrid = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Storage")
        {
            $ExistingFocusAreas.Storage = $true
            $EpicRelations.Storage = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Messaging")
        {
            $ExistingFocusAreas.Messaging = $true
            $EpicRelations.Messaging = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Networking")
        {
            $ExistingFocusAreas.Networking = $true
            $EpicRelations.Networking = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Identity & Access Control")
        {
            $ExistingFocusAreas.'Identity & Access Control' = $true
            $EpicRelations.'Identity & Access Control' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Performance Testing")
        {
            $ExistingFocusAreas.'Performance Testing' = $true
            $EpicRelations.'Performance Testing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Troubleshooting")
        {
            $ExistingFocusAreas.Troubleshooting = $true
            $EpicRelations.Troubleshooting = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "SAP")
        {
            $ExistingFocusAreas.SAP = $true
            $EpicRelations.SAP = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Efficiency and Sizing")
        {
            $ExistingFocusAreas.'Efficiency and Sizing' = $true
            $EpicRelations.'Efficiency and Sizing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Governance")
        {
            $ExistingFocusAreas.Governance = $true
            $EpicRelations.Governance = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Uncategorized")
        {
            $ExistingFocusAreas.Uncategorized = $true
            $EpicRelations.Uncategorized = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
    }
}

    if(!$ExistingFocusAreas.General)
    {
        Create-EpicInDevOps -FocusAreaToCreate "General"
    }
    if(!$ExistingFocusAreas.'Application Design')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Application Design"
    }
    if(!$ExistingFocusAreas.'Health Modelling & Monitoring')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Health Modelling & Monitoring"
    }
    if(!$ExistingFocusAreas.'Capacity & Service Availability Planning')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Capacity & Service Availability Planning"
    }
    if(!$ExistingFocusAreas.'Application Platform Availability')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Application Platform Availability"
    }
    if(!$ExistingFocusAreas.'Data Platform Availability')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Data Platform Availability"
    }
    if(!$ExistingFocusAreas.'Networking & Connectivity')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Networking & Connectivity"
    }
    if(!$ExistingFocusAreas.'Scalability & Performance')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Scalability & Performance"
    }
    if(!$ExistingFocusAreas.'Security & Compliance')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Security & Compliance"
    }
    if(!$ExistingFocusAreas.'Operational Procedures')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Operational Procedures"
    }
    if(!$ExistingFocusAreas.'Deployment & Testing')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Deployment & Testing"
    }
    if(!$ExistingFocusAreas.'Operational Model & DevOps')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Operational Model & DevOps"
    }
    if(!$ExistingFocusAreas.'Compute')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Compute"
    }
    if(!$ExistingFocusAreas.'Data')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Data"
    }
    if(!$ExistingFocusAreas.'Hybrid')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Hybrid"
    }
    if(!$ExistingFocusAreas.'Storage')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Storage"
    }
    if(!$ExistingFocusAreas.'Messaging')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Messaging"
    }
    if(!$ExistingFocusAreas.'Networking')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Networking"
    }
    if(!$ExistingFocusAreas.'Identity & Access Control')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Identity & Access Control"
    }
    if(!$ExistingFocusAreas.'Performance Testing')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Performance Testing"
    }
    if(!$ExistingFocusAreas.'Troubleshooting')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Troubleshooting"
    }
    if(!$ExistingFocusAreas.'SAP')
    {
        Create-EpicInDevOps -FocusAreaToCreate "SAP"
    }
    if(!$ExistingFocusAreas.'Efficiency and Sizing')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Efficiency and Sizing"
    }
    if(!$ExistingFocusAreas.'Governance')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Governance"
    }
    if(!$ExistingFocusAreas.'Uncategorized')
    {
        Create-EpicInDevOps -FocusAreaToCreate "Uncategorized"
    }
    
    Map-ExistingFocusAreasforLinks

}
catch
{
    Write-Output "Error while querying devops for work items: " + $Error[0].Exception.ToString()
}

}

#Build and map the epic relationship URIs
function Map-ExistingFocusAreasforLinks
{

#Iterate entire devops issues
$body = "{
  `"query`": `"SELECT
    [System.Id],
    [System.WorkItemType],
    [System.Title],
    [System.AssignedTo],
    [System.State],
    [System.Tags]
FROM workitems
WHERE
    [System.TeamProject] = @project
    AND [System.WorkItemType] = 'Epic'
    AND [System.State] <> ''`"}"

$getQueryUri = $UriOrganization + $projectname + "_apis/wit/wiql?api-version=6.0-preview.2"
$AllEpics = Invoke-RestMethod -Uri $getQueryUri -Method POST -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader -Body $body

$ExistingFocusAreas = [pscustomobject]@{
"General" = $false;
"Application Design" = $false;
"Health Modelling & Monitoring" = $false;
"Capacity & Service Availability Planning" = $false;
"Application Platform Availability" = $false;
"Data Platform Availability" = $false;
"Networking & Connectivity" = $false;
"Scalability & Performance" = $false;
"Security & Compliance" = $false;
"Operational Procedures" = $false;
"Deployment & Testing" = $false;
"Operational Model & DevOps" = $false;
"Compute" = $false;
"Data" = $false;
"Hybrid" = $false;
"Storage" = $false;
"Messaging" = $false;
"Networking" = $false;
"Identity & Access Control" = $false;
"Performance Testing" = $false;
"Troubleshooting" = $false;
"SAP" = $false;
"Efficiency and Sizing" = $false;
"Governance" = $false;
"Uncategorized" = $false;
}
if($AllEpics.workItems.Count -gt 0)
{
    Write-Output "There are $($AllEpics.workItems.Count) Epics in DevOps. Mapping these to create parent child links between Issues"
    foreach($epic in $AllEpics.workItems.id)
    {
        $getEpicQueryUri = $UriOrganization + $projectname + "_apis/wit/workitems/" + $epic + "?api-version=6.0-preview.2"
        $EpicworkItem = Invoke-RestMethod -Uri $getEpicQueryUri -Method GET -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader
        if($EpicworkItem.fields.'System.Title' -eq "General")
        {
            $ExistingFocusAreas.General = $true;
            $EpicRelations.General = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Application Design")
        {
            $ExistingFocusAreas.'Application Design' = $true
            $EpicRelations.'Application Design' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Health Modelling & Monitoring")
        {
            $ExistingFocusAreas.'Health Modelling & Monitoring' = $true
            $EpicRelations.'Health Modelling & Monitoring' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Capacity & Service Availability Planning")
        {
            $ExistingFocusAreas.'Capacity & Service Availability Planning' = $true
            $EpicRelations.'Capacity & Service Availability Planning' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Application Platform Availability")
        {
            $ExistingFocusAreas.'Application Platform Availability' = $true
            $EpicRelations.'Application Platform Availability' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Data Platform Availability")
        {
            $ExistingFocusAreas.'Data Platform Availability' = $true
            $EpicRelations.'Data Platform Availability' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Networking & Connectivity")
        {
            $ExistingFocusAreas.'Networking & Connectivity' = $true
            $EpicRelations.'Networking & Connectivity' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Scalability & Performance")
        {
            $ExistingFocusAreas.'Scalability & Performance' = $true
            $EpicRelations.'Scalability & Performance' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Security & Compliance")
        {
            $ExistingFocusAreas.'Security & Compliance' = $true
            $EpicRelations.'Security & Compliance' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Operational Procedures")
        {
            $ExistingFocusAreas.'Operational Procedures' = $true
            $EpicRelations.'Operational Procedures' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Deployment & Testing")
        {
            $ExistingFocusAreas.'Deployment & Testing' = $true
            $EpicRelations.'Deployment & Testing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Operational Model & DevOps")
        {
            $ExistingFocusAreas.'Operational Model & DevOps' = $true
            $EpicRelations.'Operational Model & DevOps' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Compute")
        {
            $ExistingFocusAreas.Compute = $true
            $EpicRelations.Compute = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Data")
        {
            $ExistingFocusAreas.Data = $true
            $EpicRelations.Data = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Hybrid")
        {
            $ExistingFocusAreas.Hybrid = $true
            $EpicRelations.Hybrid = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Storage")
        {
            $ExistingFocusAreas.Storage = $true
            $EpicRelations.Storage = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Messaging")
        {
            $ExistingFocusAreas.Messaging = $true
            $EpicRelations.Messaging = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Networking")
        {
            $ExistingFocusAreas.Networking = $true
            $EpicRelations.Networking = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Identity & Access Control")
        {
            $ExistingFocusAreas.'Identity & Access Control' = $true
            $EpicRelations.'Identity & Access Control' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Performance Testing")
        {
            $ExistingFocusAreas.'Performance Testing' = $true
            $EpicRelations.'Performance Testing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Troubleshooting")
        {
            $ExistingFocusAreas.Troubleshooting = $true
            $EpicRelations.Troubleshooting = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "SAP")
        {
            $ExistingFocusAreas.SAP = $true
            $EpicRelations.SAP = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Efficiency and Sizing")
        {
            $ExistingFocusAreas.'Efficiency and Sizing' = $true
            $EpicRelations.'Efficiency and Sizing' = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Governance")
        {
            $ExistingFocusAreas.Governance = $true
            $EpicRelations.Governance = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
        elseif($EpicworkItem.fields.'System.Title' -eq "Uncategorized")
        {
            $ExistingFocusAreas.Uncategorized = $true
            $EpicRelations.Uncategorized = $EpicRelationshipStringBuilder.Replace("EPICURLPLACEHOLDER",$EpicworkItem.url)
        }
    }
}

}

#Create the Epic in DevOps per category/focus area
function Create-EpicInDevOps
{
param(
[parameter (Mandatory=$true)]
[string]$FocusAreaToCreate
)
$body = "[
  {
    `"op`": `"add`",
    `"path`": `"/fields/System.Title`",
    `"value`": `"$($FocusAreaToCreate)`"
  }
]"
if($DevOpsList.Reportingcategory -contains $FocusAreaToCreate)
{
    $postIssueUri = $Uriorganization + $projectname + "_apis/wit/workitems/$" + "Epic" + "?api-version=5.1"
    $workItem = Invoke-RestMethod -Uri $postIssueUri -Method POST -ContentType "application/json-patch+json" -Headers $AzureDevOpsAuthenicationHeader -Body $body
}

}

#Loop through DevOps and add Features for every recommendation in the csv
function Insert-DevOpsList
{
if($DevOpsList)
{
    Write-Output "Fetching existing DevOps Work Items"
    Get-AllDevOpsWorkItems
    $AllRecommendations = $ExistingDevopsWI.fields.'System.Title'
    foreach($devopsItem in $DevOpsList)
    {
        try
        {
            #Check if exists by ID or Title Name
            if($AllRecommendations -ne $null -and $AllRecommendations.Contains($devopsItem.'Link-Text'))
            {
                Write-Output "Work Item already exists with this recommendation name $($devopsItem.'Link-Text')"
                #IF EXISTS
                #Determine if any update has been made
                #Update DevOps
            }
            else
            {
                #IF NOT EXISTS
                #Add Relationship
                $linkedItem = "";

                if($devopsItem.ReportingCategory -eq "General")
                {
                    $linkedItem = $EpicRelations.General
                }
                elseif($devopsItem.ReportingCategory -eq "Application Design")
                {
                    $linkedItem = $EpicRelations.'Application Design'
                }
                elseif($devopsItem.ReportingCategory -eq "Health Modelling & Monitoring")
                {
                    $linkedItem = $EpicRelations.'Health Modelling & Monitoring'
                }
                elseif($devopsItem.ReportingCategory -eq "Capacity & Service Availability Planning")
                {
                    $linkedItem = $EpicRelations.'Capacity & Service Availability Planning'
                }
                elseif($devopsItem.ReportingCategory -eq "Application Platform Availability")
                {
                    $linkedItem = $EpicRelations.'Application Platform Availability'
                }
                elseif($devopsItem.ReportingCategory -eq "Data Platform Availability")
                {
                    $linkedItem = $EpicRelations.'Data Platform Availability'
                }
                elseif($devopsItem.ReportingCategory -eq "Networking & Connectivity")
                {
                    $linkedItem = $EpicRelations.'Networking & Connectivity'
                }
                elseif($devopsItem.ReportingCategory -eq "Scalability & Performance")
                {
                    $linkedItem = $EpicRelations.'Scalability & Performance'
                }
                elseif($devopsItem.ReportingCategory -eq "Security & Compliance")
                {
                    $linkedItem = $EpicRelations.'Security & Compliance'
                }
                elseif($devopsItem.ReportingCategory -eq "Operational Procedures")
                {
                    $linkedItem = $EpicRelations.'Operational Procedures'
                }
                elseif($devopsItem.ReportingCategory -eq "Deployment & Testing")
                {
                    $linkedItem = $EpicRelations.'Deployment & Testing'
                }
                elseif($devopsItem.ReportingCategory -eq "Operational Model & DevOps")
                {
                    $linkedItem = $EpicRelations.'Operational Model & DevOps'
                }
                elseif($devopsItem.ReportingCategory -eq "Compute")
                {
                    $linkedItem = $EpicRelations.Compute
                }
                elseif($devopsItem.ReportingCategory -eq "Data")
                {
                    $linkedItem = $EpicRelations.Data
                }
                elseif($devopsItem.ReportingCategory -eq "Hybrid")
                {
                    $linkedItem = $EpicRelations.Hybrid
                }
                elseif($devopsItem.ReportingCategory -eq "Storage")
                {
                    $linkedItem = $EpicRelations.Storage
                }
                elseif($devopsItem.ReportingCategory -eq "Messaging")
                {
                    $linkedItem = $EpicRelations.Messaging
                }
                elseif($devopsItem.ReportingCategory -eq "Networking")
                {
                    $linkedItem = $EpicRelations.Networking
                }
                elseif($devopsItem.ReportingCategory -eq "Identity & Access Control")
                {
                    $linkedItem = $EpicRelations.'Identity & Access Control'
                }
                elseif($devopsItem.ReportingCategory -eq "Performance Testing")
                {
                    $linkedItem = $EpicRelations.'Performance Testing'
                }
                elseif($devopsItem.ReportingCategory -eq "Troubleshooting")
                {
                    $linkedItem = $EpicRelations.Troubleshooting
                }
                elseif($devopsItem.ReportingCategory -eq "SAP")
                {
                    $linkedItem = $EpicRelations.SAP
                }
                elseif($devopsItem.ReportingCategory -eq "Efficiency and Sizing")
                {
                    $linkedItem = $EpicRelations.'Efficiency and Sizing'
                }
                elseif($devopsItem.ReportingCategory -eq "Governance")
                {
                    $linkedItem = $EpicRelations.Governance
                }
                elseif($devopsItem.ReportingCategory -eq "Uncategorized")
                {
                    $linkedItem = $EpicRelations.Uncategorized
                }
                else
                {
                    Write-Host "Category not found $($devopsItem.ReportingCategory)"
                }

                $Priority = "4"
                $Risk = "1 - High"
                if($devopsItem.Weight -gt 80)
                {
                    $Priority = "1"
                    $Risk = "1 - High"
                }
                elseif($devopsItem.Weight -gt 60)
                {
                    $Priority = "2"
                    $Risk = "1 - High"
                }
                elseif($devopsItem.Weight -gt 30)
                {
                    $Priority = "3"
                    $Risk = "2 - Medium"
                }
                else
                {
                    $Priority = "4"
                    $Risk = "3 - Low"
                }

                if($devopsItem.'Link-Text'.Contains("Define security playbooks which help to understand, investigte and respond to security incidents."))
                {
                    Write-Output "Error"
                }

                $recAdded = $false
                foreach($recom in $RecommendationHash)
                {
                    if($recom.Name.Trim('.').Contains($devopsItem.'Link-Text'.Trim('.')))
                    {
                        $recDescription = "<a href=`"$($devopsItem.Link)`">$($devopsItem.'Link-Text')</a>" + "`r`n`r`n" + "<p><b>Why Consider This?</b></p>" + "`r`n`r`n" + $recom.WhyConsiderThis + "`r`n`r`n" + "<p><b>Context</b></p>" + "`r`n`r`n" + $recom.Context + "`r`n`r`n" + "<p><b>Suggested Actions</b></p>" + "`r`n`r`n" + $recom.SuggestedActions + "`r`n`r`n" + "<p><b>Learn More</b></p>" + "`r`n`r`n" + $recom.LearnMore
                        $recDescription = $recDescription -replace ' ',' '
                        $recDescription = $recDescription -replace '“','"' -replace '”','"'
                        Insert-NewIssueToDevOps -Title $devopsItem.'Link-Text' -Effort $devopsItem.Weight -Tags $devopsItem.Category -Priority $Priority -BusinessValue $devopsItem.Weight -TimeCriticality $devopsItem.Weight -Risk $Risk -Description $($recDescription | Out-String | ConvertTo-Json) -linkedItem $linkedItem
                        $recAdded = $true
                    }
                }

                if(!$recAdded)
                {
                    $recDescription = "<a href=`"$($devopsItem.Link)`">$($devopsItem.'Link-Text')</a>"
                    Insert-NewIssueToDevOps -Title $devopsItem.'Link-Text' -Effort $devopsItem.Weight -Tags $devopsItem.Category -Priority $Priority -BusinessValue $devopsItem.Weight -TimeCriticality $devopsItem.Weight -Risk $Risk -Description $($recDescription | Out-String | ConvertTo-Json) -linkedItem $linkedItem
                }
                #$recDescription = $recommendation.WhyConsiderThis + "`r`n`r`n" + $recommendation.Context + "`r`n`r`n" + $recommendation.SuggestedActions + "`r`n`r`n" + $recommendation.LearnMore
                #$recDescription = "<a href=`"$($devopsItem.Link)`">$($devopsItem.'Link-Text')</a>"
                #Insert-NewIssueToDevOps -Title $devopsItem.'Link-Text' -Effort $devopsItem.Weight -Tags $devopsItem.Category -Priority $Priority -BusinessValue $devopsItem.Weight -TimeCriticality $devopsItem.Weight -Risk $Risk -Description $($recDescription | Out-String | ConvertTo-Json) -linkedItem $linkedItem

            }
        }
        catch
        {
           Write-Output "Could not insert item to devops: " + $Error[0].Exception.ToString()
        }
    }
}
}

#Retrieve all work items from DevOps
function Get-AllDevOpsWorkItems
{

#Iterate entire devops issues
$body = "{
  `"query`": `"Select * From WorkItems Where [Work Item Type] = 'Feature' AND [State] <> 'Closed' AND [State] <> 'Removed' AND [System.TeamProject] = @project order by [Microsoft.VSTS.Common.Priority] asc, [System.CreatedDate] desc`"
}"

$getQueryUri = $UriOrganization + $projectname + "_apis/wit/wiql?api-version=6.0-preview.2"
$AllWI = Invoke-RestMethod -Uri $getQueryUri -Method POST -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader -Body $body

try
{
#Gather details per devops item
if($AllWI.workItems.Count -gt 0)
{
    foreach($wi in $AllWI.workItems.id)
    {
        $getWIQueryUri = $UriOrganization + $projectname + "_apis/wit/workitems/" + $wi + "?api-version=6.0-preview.2"
        $workItem = Invoke-RestMethod -Uri $getWIQueryUri -Method GET -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader
        $ExistingDevopsWI.Add($workItem) | Out-Null
    }
}
else
{
    Write-Output "There are no work items of type Issue in DevOps yet"
}
}
catch
{
    Write-Output "Error while querying devops for work items: " + $Error[0].Exception.ToString()
}

}

#Insert Feature into DevOps
function Insert-NewIssueToDevOps($Title,$Effort,$Tags,$Priority,$BusinessValue,$TimeCriticality,$Risk,$Description,$linkedItem)
{
   
    if($Title -eq "" -or $Title -eq $null){$Title="NA"}
    if($Effort -eq "" -or $Effort -eq $null){$Effort="0"}
    if($Tags -eq "" -or $Tags -eq $null){$Tags="NA"}
    if($Priority -eq "" -or $Priority -eq $null){$Priority="4"}
    if($BusinessValue -eq "" -or $BusinessValue -eq $null){$BusinessValue="0"}
    if($TimeCriticality -eq "" -or $TimeCriticality -eq $null){$TimeCriticality="0"}
    if($Risk -eq "" -or $Risk -eq $null){$Risk="3 - Low"}
    if($Description -eq "" -or $Description -eq $null){$Description="NA"}

    $Issuebody = "[
  {
    `"op`": `"add`",
    `"path`": `"/fields/System.Title`",
    `"value`": `"$($Title)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/Microsoft.VSTS.Scheduling.Effort`",
    `"value`": `"$($Effort)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/Microsoft.VSTS.Common.Priority`",
    `"value`": `"$($Priority)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/System.Tags`",
    `"value`": `"$($Tags)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/Microsoft.VSTS.Common.BusinessValue`",
    `"value`": `"$($BusinessValue)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/Microsoft.VSTS.Common.TimeCriticality`",
    `"value`": `"$($TimeCriticality)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/Microsoft.VSTS.Common.Risk`",
    `"value`": `"$($Risk)`"
  },
  {
    `"op`": `"add`",
    `"path`": `"/fields/System.Description`",
    `"value`": $Description
  },
  {
    `"op`": `"add`",
    `"path`": `"/relations/-`",
    `"value`": $linkedItem
  }        
]"
    try
    {
    $postIssueUri = $UriOrganization + $projectname + "_apis/wit/workitems/$" + "Feature?api-version=5.1"
    $workItem = Invoke-RestMethod -Uri $postIssueUri -Method POST -ContentType "application/json-patch+json" -Headers $AzureDevOpsAuthenicationHeader -Body $Issuebody
    }
    catch
    {
        Write-Output "Exception while creating work item: $($Issuebody)" + $Error[0].Exception.ToString() 
    }
}



#region DevOps Management

Write-Output "Checking for existing categories in DevOps and adding the missing ones as Epics"
Create-EpicsforFocusArea

Write-Output "Attempting DevOps Import for all Issues"
Insert-DevOpsList

#endregion
