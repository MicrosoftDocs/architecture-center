<# Instructions to use this script

double click the script'
#>


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




#region Validate input values

$content = Get-Content "$WAFReport"
$templatePresentation = "$workingDirectory\PnP_PowerPointReport_Template.pptx"
$descriptionsFile = Import-Csv "$workingDirectory\WAF Category Descriptions.csv"

#endregion

$title = "Well-Architected [pillar] Assessment"
$reportDate = Get-Date -Format "MM-dd-yyyy HH.mm.s"
#$tableStart = $content.IndexOf("Title,Description,Link-Text,Link,Priority,Category,Subcategory,Weight")
$tableStart = $content.IndexOf("Category,Link-Text,Link,Priority,ReportingCategory,ReportingSubcategory,Weight,Context")
$EndStringIdentifier = $content | Where-Object{$_.Contains("--,,")} | Select-Object -Unique -First 1
$tableEnd = $content.IndexOf($EndStringIdentifier) - 1
$csv = $content[$tableStart..$tableEnd] | Out-File  "$workingDirectory\$reportDate.csv"
$data = Import-Csv -Path "$workingDirectory\$reportDate.csv"
$data | % { $_.Weight = [int]$_.Weight }
$pillars = $data.Category | Select-Object -Unique


#region CSV Calculations

$costDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq "Cost Optimization" -and $_.Category -eq "Survey Level Group"}).Description
$operationsDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq "Operational Excellence" -and $_.Category -eq "Survey Level Group"}).Description
$performanceDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq "Performance Efficiency" -and $_.Category -eq "Survey Level Group"}).Description
$reliabiltyDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq "Reliability" -and $_.Category -eq "Survey Level Group"}).Description
$securityDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq "Security" -and $_.Category -eq "Survey Level Group"}).Description

function Get-PillarInfo($pillar)
{
    if($pillar.Contains("Cost Optimization"))
    {
        return [pscustomobject]@{"Pillar" = $pillar; "Score" = $costScore; "Description" = $costDescription}
    }
    if($pillar.Contains("Reliability"))
    {
        return [pscustomobject]@{"Pillar" = $pillar; "Score" = $reliabiltyScore; "Description" = $reliabiltyDescription}
    }
    if($pillar.Contains("Operational Excellence"))
    {
        return [pscustomobject]@{"Pillar" = $pillar; "Score" = $operationsScore; "Description" = $operationsDescription}
    }
    if($pillar.Contains("Performance Efficiency"))
    {
        return [pscustomobject]@{"Pillar" = $pillar; "Score" = $performanceScore; "Description" = $performanceDescription}
    }
    if($pillar.Contains("Security"))
    {
        return [pscustomobject]@{"Pillar" = $pillar; "Score" = $securityScore; "Description" = $securityDescription}
    }
}

$overallScore = ""
$costScore = ""
$operationsScore = ""
$performanceScore = ""
$reliabiltyScore = ""
$securityScore = ""

for($i=3; $i -le 8; $i++)
{
    if($Content[$i].Contains("overall"))
    {
        $overallScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
    if($Content[$i].Contains("Cost Optimization"))
    {
        $costScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
    if($Content[$i].Contains("Reliability"))
    {
        $reliabiltyScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
    if($Content[$i].Contains("Operational Excellence"))
    {
        $operationsScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
    if($Content[$i].Contains("Performance Efficiency"))
    {
        $performanceScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
    if($Content[$i].Contains("Security"))
    {
        $securityScore = $Content[$i].Split(',')[2].Trim("'").Split('/')[0]
    }
}

#endregion



#region Instantiate PowerPoint variables
Add-type -AssemblyName office
$application = New-Object -ComObject powerpoint.application
$application.visible = [Microsoft.Office.Core.MsoTriState]::msoTrue
$slideType = “microsoft.office.interop.powerpoint.ppSlideLayout” -as [type]
$presentation = $application.Presentations.open($templatePresentation)
$titleSlide = $presentation.Slides[8]
$summarySlide = $presentation.Slides[9]
$detailSlide = $presentation.Slides[10]

#endregion

#region Clean the uncategorized data

foreach($lineData in $data)
{
    if(!$lineData.ReportingCategory)
    {
        $lineData.ReportingCategory = "Uncategorized"
    }
}

#endregion

foreach($pillar in $pillars)
{
 $pillarData = $data | Where-Object{$_.Category -eq $pillar}
 $pillarInfo = Get-PillarInfo -pillar $pillar
 # Edit title & date on slide 1
 $slideTitle = $title.Replace("[pillar]",$pillar.substring(0,1).toupper()+$pillar.substring(1).tolower())
 $newTitleSlide = $titleSlide.Duplicate()
 $newTitleSlide.MoveTo($presentation.Slides.Count)
 $newTitleSlide.Shapes[3].TextFrame.TextRange.Text = $slideTitle
 $newTitleSlide.Shapes[4].TextFrame.TextRange.Text = $newTitleSlide.Shapes[4].TextFrame.TextRange.Text.Replace("[Report_Date]",$reportDate)

 # Edit Executive Summary Slide

 #Add logic to get overall score
 $newSummarySlide = $summarySlide.Duplicate()
 $newSummarySlide.MoveTo($presentation.Slides.Count)
 $newSummarySlide.Shapes[4].TextFrame.TextRange.Text = $pillarInfo.Score
 $newSummarySlide.Shapes[5].TextFrame.TextRange.Text = $pillarInfo.Description

 $CategoriesList = New-Object System.Collections.ArrayList
 $categories = ($pillarData | Sort-Object -Property "Weight" -Descending).ReportingCategory | Select-Object -Unique
 foreach($category in $categories)
 {
    $categoryWeight = ($pillarData | Where-Object{$_.ReportingCategory -eq $category}).Weight | Measure-Object -Sum
    $categoryScore = $categoryWeight.Sum/$categoryWeight.Count
    $CategoriesList.Add([pscustomobject]@{"Category" = $category; "CategoryScore" = $categoryScore}) | Out-Null
 }

 $CategoriesList = $CategoriesList | Sort-Object -Property CategoryScore -Descending

 $counter = 9 #Shape count for the slide to start adding scores
 foreach($category in $CategoriesList)
 {
    if($category.Category -ne "Uncategorized")
    {
        try
        {
            #$newSummarySlide.Shapes[8] #Domain 1 Icon
            $newSummarySlide.Shapes[$counter].TextFrame.TextRange.Text = $category.CategoryScore.ToString("#")
            $newSummarySlide.Shapes[$counter+1].TextFrame.TextRange.Text = $category.Category
            $counter = $counter + 3
        }
        catch{}
    }
 }

 #Remove the boilerplate placeholder text if categories < 8
 if($categories.Count -lt 8)
 {
     for($k=$newSummarySlide.Shapes.count; $k -gt $counter-1; $k--)
     {
        try
        {
         $newSummarySlide.Shapes[$k].Delete()
         <#$newSummarySlide.Shapes[$k].Delete()
         $newSummarySlide.Shapes[$k+1].Delete()#>
         }
         catch{}
     }
 }

 # Edit new category summary slide

 foreach($category in $CategoriesList.Category)
 {
    $categoryData = $pillarData | Where-Object{$_.ReportingCategory -eq $category -and $_.Category -eq $pillar}
    $categoryDataCount = ($categoryData | measure).Count
    $categoryWeight = ($pillarData | Where-Object{$_.ReportingCategory -eq $category}).Weight | Measure-Object -Sum
    $categoryScore = $categoryWeight.Sum/$categoryWeight.Count
    $categoryDescription = ($descriptionsFile | Where-Object{$_.Pillar -eq $pillar -and $categoryData.ReportingCategory.Contains($_.Category)}).Description
    $y = $categoryDataCount
    $x = 5
    if($categoryDataCount -lt 5)
    {
        $x = $categoryDataCount
    }

    $newDetailSlide = $detailSlide.Duplicate()
    $newDetailSlide.MoveTo($presentation.Slides.Count)

    $newDetailSlide.Shapes[1].TextFrame.TextRange.Text = $category
    $newDetailSlide.Shapes[4].TextFrame.TextRange.Text = $categoryScore.ToString("#")
    $newDetailSlide.Shapes[5].TextFrame.TextRange.Text = $categoryDescription
    $newDetailSlide.Shapes[8].TextFrame.TextRange.Text = "Top $x out of $y recommendations:"
    $newDetailSlide.Shapes[9].TextFrame.TextRange.Text = ($categoryData | Sort-Object -Property "Link-Text" -Unique | Sort-Object -Property Weight -Descending | Select-Object -First $x).'Link-Text' -join "`r`n`r`n"
    $sentenceCount = $newDetailSlide.Shapes[9].TextFrame.TextRange.Sentences().count
    
    for($k=1; $k -le $sentenceCount; $k++)
     {
         if($newDetailSlide.Shapes[9].TextFrame.TextRange.Sentences($k).Text)
         {
            try
            {
                $recommendationObject = $categoryData | Where-Object{$newDetailSlide.Shapes[9].TextFrame.TextRange.Sentences($k).Text.Contains($_.'Link-Text')}
                $newDetailSlide.Shapes[9].TextFrame.TextRange.Sentences($k).ActionSettings(1).HyperLink.Address = $recommendationObject.Link
            }
            catch{}
         }
     }    
 }

 }

 $titleSlide.Delete()
 $summarySlide.Delete()
 $detailSlide.Delete()
 $presentation.SavecopyAs(“$workingDirectory\PnP_PowerPointReport_Template_$reportDate.pptx”)
 $presentation.Close()


$application.quit()
$application = $null
[gc]::collect()
[gc]::WaitForPendingFinalizers()