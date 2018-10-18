---
title: CI/CD for Azure Web Apps
description: Azure Web Apps is a fast and simple way to create web apps using ASP.NET, Java, Node.js, or PHP. Deliver value faster to your customers with a continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Web Apps.
author: adamboeglin
ms.date: 10/18/2018
---
# CI/CD for Azure Web Apps
Azure Web Apps is a fast and simple way to create web apps using ASP.NET, Java, Node.js, or PHP. Deliver value faster to your customers with a continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Web Apps.

## Architecture
<img src="media/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps.svg" alt='architecture diagram' />

## Data Flow
1. Change application source code.
1. Commit application code and Web Apps web.config file.
1. Continuous integration triggers application build and unit tests.
1. Continuous deployment trigger orchestrates deployment of application artifacts with environment-specific parameters.
1. Deployment to Web Apps.
1. Azure Application Insights collects and analyzes health, performance, and usage data.
1. Review health, performance, and usage information.
1. Update backlog item.

## Components
* Application Insights: Detect, triage, and diagnose issues in your web apps and services.
* [Web Apps](href="http://azure.microsoft.com/services/app-service/web/): Quickly create and deploy mission critical Web apps at scale.
* [Azure DevOps](href="http://azure.microsoft.com/services/devops/): Services for teams to share code, track work, and ship software.
* [Visual Studio](https://www.visualstudio.com/vs/azure/): A creative launch pad for viewing and editing code,  then debugging, building, and publishing apps for Android, iOS, Windows, the web, and the cloud.

## Next Steps
* [Performance monitoring with Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-detect-triage-diagnose)
* [Use Azure DevOps to deploy to an Azure Web App](https://docs.microsoft.com/vsts/build-release/apps/cd/azure/aspnet-core-to-azure-webapp)
* [Git on Azure DevOps](https://docs.microsoft.com/vsts/git/gitquickstart?tabs=visual-studio)
* [Deploy to Azure Web Apps using Visual Studio and Azure DevOps](https://docs.microsoft.com/vsts/build-release/apps/cd/deploy-docker-webapp)