---
title: DevOps Tooling for Well-Architected Recommendation Process
description: Instructions for using theDevOps Tooling for Well-Architected Recommendation Process
author: JoeyBarnes
ms.date: 09/09/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - guide
keywords:
  - "Well-Architected Recommendation Process"
  - "Azure Well-Architected Recommendation Process"
  - "WARP"
  - "Well architected recommendation process"
  - 'Tooling'
products:
  - azure-devops
categories:
  - devops
---

# DevOps Tooling for Well-Architected Recommendation Process

## Overview
there are 3 sections to this document:

1. Preperation 
2. Reporting
2. Place findings into an Azure Dev Ops project.
3. Importing to GitHub

## Preparation

### Download and prepare your environment for all of the scripts. 
1. Create a directory for the import scripts to be used.
2. Download the install script from [here](https://github.com/JoeyBarnes/architecture-center-pr/blob/warp-guidance-rework/docs/framework/warp/tools/devops/install-WARP-tools.ps1), place it in the directory you created and run the script.
3. The script will download all the needed files.
4. For each .ps1 files downloaded: right-click on the file, select Properties, then check ‘Unblock’
5. Place the .csv file created via the web-assessment into the directory directory with the files that have been downloaded.

### Test your environment and the script. 

1. Right click and run the .\GenerateWAFReport.ps1 script. 
2. Choose the saved demo WAF file: 
3. Azure_Well_Architected_Review_Feb_01_2010_8_00_00_AM.csv 
4. A PowerPoint file will be created in the same directory with this name: 
 1. PnP\_PowerPointReport\_Template_mmm-dd-yyyy hh.mm.ss.pptx
 2. Examine this PowerPoint file for auto-generated slides after slide 8. 
 3. If these slides are created in this deck then your environment is properly setup and you may move on. 

## Reporting

### Create a customer presentation PowerPoint deck using PowerShell. 

1. Right click and run the .\GenerateWAFReport.ps1 script. 
2. Choose the WAF file saved from the earlier assessment. 
3. A PowerPoint file will be created in the same directory with this name: 
4. PnP\_PowerPointReport\_Template_mm-dd-yyyy hh.mm.ss.pptx 
5. Examine this PowerPoint file for auto-generated slides after slide 8. 

## Place findings into an Azure Dev Ops project. 

1. Create or log into an Azure DevOps Organization. 
2. If an organization does not exist, follow these steps in this [link](http://a.https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops). 
3. Note the Organization URI.
 1. Example: https://dev.azure.com/contoso/
2. Go to the project being used for this effort. 
6. [If a project does not exist in the Azure DevOps Organization then create new project using the steps in this link. ](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page)
7. Take care to ensure that "Agile" Process is selected under advanced when this project is created.
10. Note the URI created by this action.
 11. Example: https://dev.azure.com/contoso/WARP-work
12. Create or acquire a personal access token with read-write access to create DevOps Work Items using this [link](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)
13. Place this token into the keys.txt file in the proper location. 
14. Open a command prompt to your PowerShell environment and run the following command: 
15. PnP-DevOps.ps1 <url to project in Azure Devops>
 1. example:
 `PnP-DevOps.ps1 https://dev.azure.com/demo-org/demo-project`
16. When prompted, choose the WAF file saved from the earlier assessment. 
17. The PowerShell script will present a prompt to make sure you are ready to perform the import.
18. Choose Y to continue.
 - `This script is using the WAF report: Azure\_Well\_Architected\_Review mmm-dd-yyyy hh.mm.ss_AM.csv`
 - `This script will insert data into Azure DevOps org: <orgname>`
 - `This will insert XXX items into the <projectname> project.`
 - `We are using the Azure DevOps token that starts with abcde`
 - `Ready? [y/n]`
23. The script will then import the items into Azure DevOps. 
24. After running the script, navigate to Backlogs in DevOps and select the Epics filter on the top right to view the categorized list of items
25. Seeing some exceptions while running the script is expected.
26. Please validate DevOps
27. As long as Epics and Features are populated, you should be good to proceed 


## Place findings into a Github repository. 

1. [Acquire a personal access token with write access to create issues](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
2. Permissions should be Full control of private repositories
3. Add this personal access token to the keys.txt file as GitHubUserToken
4. Add the Github username of the person whose token is being used to the keys.txt file as $owner
5. Replace the $repository value with the Github repository name
6. example: https://github.com/contoso/WAF-repository
7. The value would be WAF-respository
8. Right click and run the PnP-Github.ps1 script
9. Choose the WAF file saved from the earlier assessment.
10. Seeing some exceptions while running the script are expected.
11. Please validate GitHub
 - You should see milestones and issues populated with data. 