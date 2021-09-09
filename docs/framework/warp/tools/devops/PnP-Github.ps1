<# Instructions to use this script

1. If you don't already have one, create a GitHub account - https://github.com/
2. Create a new Github Repository if one does not exist - https://docs.github.com/en/github/getting-started-with-github/create-a-repo
3. Add the Github username of the person whose token is being used under $owner
4. Replace the $repository value with the Github repository name that was created in step 2
5. Acquire a personal access token with write access to create issues (Full control of private repositories) - https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
6. Replace the variable $GitHubUserToken with the personal access token generated in step 5
7. Download the csv file generated from PnP and replace the file path to the csv for $CSVInput
8. Set the workingDirectory value in the script to a folder path that includes the scripts, templates and the downloaded csv file from PnP
9. Set the right csv file name on $content value and point it to the downloaded csv file path
10. Ensure the Category Descriptions file exists in the paths shown below before attempting to run 
11. Seeing some exceptions while running the script is expected. Please validate GitHub - As long as milestones and Issues are populated, you should be good to proceed

#>

$GitHubUserToken = ""
$workingDirectory = ""
$content = Get-Content ""
$descriptionsFile = Import-Csv "$workingDirectory\"
$owner = ""
$repository = ""
$AllMilestones = $null
#region Variable Instantiation

$reportDate = Get-Date -Format "MM-dd-yyyy HH.mm.s"
$tableStart = $content.IndexOf("Category,Link-Text,Link,Priority,ReportingCategory,ReportingSubcategory,Weight,Context")
$tableEnd = $content.IndexOf("-----------,,,,,") - 1
$csv = $content[$tableStart..$tableEnd] | Out-File  "$workingDirectory\$reportDate.csv"
$CSVInput = Import-Csv -Path "$workingDirectory\$reportDate.csv"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Headers = @{
Authorization='token '+$GitHubUserToken
}
$AllMilestones = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$owner/$repository/milestones" -Headers $Headers -ContentType "application/json"
$AllIssues = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$owner/$repository/issues?per_page=100&page=1" -Headers $Headers -ContentType "application/json"

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
Uncategorized


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

#endregion

#region Clean the uncategorized data

foreach($lineData in $CSVInput)
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

#Add a new Milestone to GitHub
function New-GithubMilestone 
{
    param(
        [Parameter(Mandatory=$true)][string]$Title,
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)][string]$Owner,
        [Parameter(Mandatory=$true)][string]$Repository,
        [Parameter(Mandatory=$true)]$Headers
    )

    $Body = @{
            title  = $Title
            description   = $Description
        } | ConvertTo-Json


        try 
        {
            $AllMilestones = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$owner/$repository/milestones" -Headers $Headers -ContentType "application/json"
            Start-Sleep -Seconds 3
            if($AllMilestones.title -notcontains $Title)
            {
                $NewMilestone = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$owner/$repository/milestones" -Body $Body -Headers $Headers -ContentType "application/json"
                Start-Sleep -Seconds 3
            }
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Output "New-GithubMilestone: $Title $ErrorMessage $FailedItem"
        }
    
}

#Add a new Issue to GitHub
function New-GithubIssue 
{
    param(
        [Parameter(Mandatory=$true)][string]$Title,
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)]$Label,
        [Parameter(Mandatory=$true)][string]$Owner,
        [Parameter(Mandatory=$true)][string]$Repository,
        [Parameter(Mandatory=$true)][string]$Milestone,
        [Parameter(Mandatory=$true)]$Headers
    )

    $MilestoneID = $($AllMilestones | Where-Object{$_.Title -eq $Milestone} | Select-Object -First 1).Number

    $Body = @{
                title  = "$Title"
                body   = "$Description"
                labels = $Label
                milestone = "$MilestoneID"
            } | ConvertTo-Json

        try 
        {
            if($AllIssues.title -notcontains $Title)
            {
                $NewIssue = Invoke-RestMethod -Method Post -Uri "https://api.github.com/repos/$owner/$repository/issues" -Body $Body -Headers $Headers -ContentType "application/json"
                Start-Sleep -Seconds 3

            }
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Write-Output "New-GitHubIssue: $ErrorMessage $FailedItem"
        }

    
}

#region GitHub Management

Write-Output "Checking for existing categories in Github and adding the missing ones as Milestones"

foreach($content in $CSVInput)
{
    $pillar  = $content.Category
    if($AllMilestones.title -notcontains $("$pillar - " + $content.ReportingCategory))
    {
        $categoryDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq $pillar -and $content.ReportingCategory.Contains($_.Category)}).Description
        if(!$categoryDescription)
        {
            $categoryDescription = "Uncategorized"
        }
        New-GithubMilestone -Title $("$pillar - " + $content.ReportingCategory) -Description $categoryDescription -Owner $owner -Repository $repository -Headers $Headers
        $AllMilestones = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$owner/$repository/milestones" -Headers $Headers -ContentType "application/json"
    }      
}

Write-Output "Attempting Github Import for all Issues"

foreach($Issue in $CSVInput)
{   
    $labels = New-Object System.Collections.ArrayList
    if($Issue.category)
    {
        $labels.Add($Issue.category) | Out-Null
    }

    if($Issue.ReportingCategory)
    {
        $labels.Add($Issue.ReportingCategory) | Out-Null
    }

    if($Issue.ReportingsubCategory)
    {
        $labels.Add($Issue.ReportingsubCategory) | Out-Null 
    }  
    
    $recAdded = $false
    foreach($recom in $RecommendationHash)
    {
        if($recom.Name.Trim('.').Contains($Issue.'Link-Text'.Trim('.')))
        {
            $recDescription = "<a href=`"$($Issue.Link)`">$($Issue.'Link-Text')</a>" + "`r`n`r`n" + "<p><b>Why Consider This?</b></p>" + "`r`n`r`n" + $recom.WhyConsiderThis + "`r`n`r`n" + "<p><b>Context</b></p>" + "`r`n`r`n" + $recom.Context + "`r`n`r`n" + "<p><b>Suggested Actions</b></p>" + "`r`n`r`n" + $recom.SuggestedActions + "`r`n`r`n" + "<p><b>Learn More</b></p>" + "`r`n`r`n" + $recom.LearnMore
            $recDescription = $recDescription -replace ' ',' '
            $recDescription = $recDescription -replace '“','"' -replace '”','"'
            New-GithubIssue -Title $Issue.'Link-Text' -Description $recDescription -Label $labels -Owner $owner -Repository $repository -Milestone $($($Issue.category) + " - " + $Issue.ReportingCategory) -Headers $Headers
            $recAdded = $true
        }
    }

    if(!$recAdded)
    {
        $recDescription = "<a href=`"$($Issue.Link)`">$($Issue.'Link-Text')</a>"
        New-GithubIssue -Title $Issue.'Link-Text' -Description $recDescription -Label $labels -Owner $owner -Repository $repository -Milestone $($($Issue.category) + " - " + $Issue.ReportingCategory) -Headers $Headers
    }
    
         
}


#endregion
