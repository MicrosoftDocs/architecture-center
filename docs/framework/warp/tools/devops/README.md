---
title: DevOps Tooling for Well-Architected Recommendation Process
description: Instructions for using theDevOps Tooling for Well-Architected Recommendation Process
author: rspott
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

There are 4 sections to this document:

1. Preparation
1. Reporting
1. Place findings into an Azure Dev Ops project.
1. Importing to GitHub

## Preparation

### Download and prepare your environment for all of the scripts

1. Create a directory for the import scripts to be used.

1. Right-click on this [link](https://rspott.com/WARP/install-WARP-tools.ps1) and save the installation script in the directory you created.

1. Right-click on the downloaded file, select Properties, then check ‘Unblock’

1. Run the script file to download the rest of required files.

1. For each .ps1 files downloaded: right-click on the file, select Properties, then check ‘Unblock’

1. Place the .csv file created via the web-assessment into the directory directory with the files that have been downloaded.

### Test your environment and the script

1. Right click and run the _.\GenerateWAFReport.ps1_ script.

1. Choose the saved demo WAF file:

    _Azure_Well_Architected_Review_Feb_01_2010_8_00_00_AM.csv_

1. A PowerPoint file will be created in the same directory with this name:

    _PnP\_PowerPointReport\_Template_mmm-dd-yyyy hh.mm.ss.pptx_

1. Examine this PowerPoint file for auto-generated slides after slide 8.

1. If these slides are created in this deck then your environment is properly setup and you may move on.

## Reporting

### Create a customer presentation PowerPoint deck using PowerShell

1. Right click and run the _.\GenerateWAFReport.ps1_ script.

1. Choose the WAF file saved from the earlier assessment.

1. A PowerPoint file will be created in the same directory with this name:

    _PnP\_PowerPointReport\_Template_mm-dd-yyyy hh.mm.ss.pptx_

1. Examine this PowerPoint file for auto-generated slides after slide 8.

## Place findings into an Azure Dev Ops project

1. Create or log into an Azure DevOps Organization.

    - If an organization does not exist, follow these steps in this [link](/azure/devops/organizations/accounts/create-organization?view=azure-devops).

1. Note the Organization URI.

    Example: `https://dev.azure.com/contoso/`

1. Go to the project being used for this effort.

    - If a project does not exist in the Azure DevOps Organization then create new project using the steps in this [link](/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page).
    - Take care to ensure that "Agile" Process is selected under advanced when this project is created.

1. Note the URI created by this action.

    Example: `https://dev.azure.com/contoso/WARP-work`

1. Create or acquire a personal access token with read-write access to create DevOps Work Items using this [link](/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)

1. Place this token into the keys.txt file in the proper location.

1. Open a command prompt to your PowerShell environment and run the following command: `PnP-DevOps.ps1 <url to project in Azure Devops>`

    Example: `PnP-DevOps.ps1 https://dev.azure.com/demo-org/demo-project`

    - When prompted, choose the WAF file saved from the earlier assessment.
    - The PowerShell script will present a prompt to make sure you are ready to perform the import.
    - Choose Y to continue.

        ```powershell
        This script is using the WAF report: Azure\_Well\_Architected\_Review mmm-dd-yyyy hh.mm.ss_AM.csv`
        This script will insert data into Azure DevOps org: <orgname>
        This will insert XXX items into the <projectname> project.
        We are using the Azure DevOps token that starts with abcde
        Ready? [y/n]
        ```

1. The script will then import the items into Azure DevOps.

1. After running the script, navigate to Backlogs in DevOps and select the Epics filter on the top right to view the categorized list of items

1. Seeing some exceptions while running the script is expected.

1. Please validate DevOps.

    - As long as Epics and Features are populated, you should be good to proceed

## Place findings into a Github repository

1. Acquire a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) with write access to create issues.

    - Permissions should be Full control of private repositories

1. Add this personal access token to the keys.txt file as GitHubUserToken

1. Add the Github username of the person whose token is being used to the keys.txt file as $owner

1. Replace the $repository value with the Github repository name

    `Example: https://github.com/contoso/WAF-repository`

    - The value would be WAF-repository

1. Right click and run the PnP-Github.ps1 script

1. Choose the WAF file saved from the earlier assessment.

    - Seeing some exceptions while running the script are expected.

1. Please validate GitHub

    - You should see milestones and issues populated with data.
