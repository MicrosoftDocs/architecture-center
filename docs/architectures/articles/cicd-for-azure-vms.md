---
title: CI/CD for Azure VMs 
description: Azure is a world-class cloud for hosting virtual machines running Windows or Linux. Whether you use ASP.NET, Java, Node.js, or PHP to develop applications, youll need a continuous integration and continuous deployment (CI/CD) pipeline to push changes to these virtual machines automatically.
author: adamboeglin
ms.date: 10/18/2018
---
# CI/CD for Azure VMs 
Azure is a world-class cloud for hosting virtual machines running Windows or Linux. Whether you use ASP.NET, Java, Node.js, or PHP to develop applications, youll need a continuous integration and continuous deployment (CI/CD) pipeline to push changes to these virtual machines automatically.
Azure DevOps provides the CI/CD pipeline, starting with a Git repository for managing your application source code and infrastructure code (ARM templates), a Build system for producing packages and other build artifacts, and a Release Management system for setting up a pipeline to deploy your changes through dev, test, and production environments. The pipeline uses ARM templates to provision or update your infrastructure as necessary in each environment, and then deploys the updated build. You can also use Azure Dev/Test labs to automatically tear down test resources that are not in use.

## Architecture
<img src="media/cicd-for-azure-vms.svg" alt='architecture diagram' />

## Data Flow
1. Change application source code
1. Commit Application Code and Azure Resource Manager (ARM) Template
1. Continuous integration triggers application build and unit tests
1. Continuous deployment trigger orchestrates deployment of application artifacts with environment specific parameters
1. Deployment to QA environment
1. Deployment to staging environment
1. Deployment to production environment
1. Application Insights collects and analyses health, performance and usage data
1. Review health, performance and usage information
1. Update backlog item

## Components
* [Virtual Machines](href="http://azure.microsoft.com/services/virtual-machines/): Provision Windows and Linux virtual machines in seconds
* [Azure DevTest Labs](href="http://azure.microsoft.com/services/devtest-lab/): Quickly create environments using reusable templates and artifacts
* Application Insights
* [Azure DevOps](href="http://azure.microsoft.com/services/devops/): Build and deploy multi-platform apps to get the most from Azure services

## Next Steps
* [Use Azure DevOps to Deploy to a Windows Virtual Machine](https://docs.microsoft.com/vsts/build-release/apps/cd/deploy-webdeploy-iis-deploygroups)
* [Use Azure DevOps to manage a virtual machine in Azure DevTest Labs](https://docs.microsoft.com/vsts/build-release/apps/cd/azure/deploy-provision-devtest-lab)
* [Performance monitoring with Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-detect-triage-diagnose)
* [Git on Azure DevOps](https://docs.microsoft.com/vsts/git/gitquickstart?tabs=visual-studio)