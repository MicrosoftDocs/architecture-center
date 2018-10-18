---
title: Java CI/CD using Jenkins and Azure Web Apps 
description: Azure App Service is a fast and simple way to create web apps using Java, Node, PHP or ASP.NET, as well as support for custom language runtimes using Docker. A continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Azure app services allows you to deliver value faster to your customers.
author: adamboeglin
ms.date: 10/18/2018
---
# Java CI/CD using Jenkins and Azure Web Apps 
Azure App Service is a fast and simple way to create web apps using Java, Node, PHP or ASP.NET, as well as support for custom language runtimes using Docker. A continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Azure app services allows you to deliver value faster to your customers.

## Architecture
<img src="media/java-cicd-using-jenkins-and-azure-web-apps.svg" alt='architecture diagram' />

## Data Flow
1. Change application source code
1. Commit code to GitHub
1. Continuous Integration Trigger to Jenkins
1. Jenkins triggers a build job using Azure Container Instances for a dynamic build agent
1. Jenkins builds and stores artifact in Azure Storage
1. Jenkins deploys Java application to Azure Web Apps backed by Azure Database for MySQL
1. Azure App Insights provides metrics on application performance
1. Monitor application and make improvements

## Components
* [Azure Web Apps](href="http://azure.microsoft.com/services/app-service/web/): Quickly create and deploy mission critical Web apps at scale
* [Container Instances](href="http://azure.microsoft.com/services/container-instances/): Easily run containers on Azure without managing servers
* [Azure Database for MySQL](href="http://azure.microsoft.com/services/mysql/): Managed MySQL database service for app developers
* Application Insights
* [Azure DevOps](href="http://azure.microsoft.com/services/devops/): Build and deploy multi-platform apps to get the most from Azure services

## Next Steps
* [Set up continuous integration and deployment to Azure Web Apps with Jenkins](https://docs.microsoft.com/azure/jenkins/java-deploy-webapp-tutorial)
* [Use the Azure Container Agents plug-in for Jenkins for dynamic build agents](https://docs.microsoft.com/azure/jenkins/azure-container-agents-plugin-run-container-as-an-agent)
* [Build a Java and MySQL web app in Azure](https://docs.microsoft.com/azure/app-service/app-service-web-tutorial-java-mysql)
* [Performance monitoring with Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-detect-triage-diagnose)
* [Get the Azure Extension Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-azureextensionpack)