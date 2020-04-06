---
title: Hybrid CI/CD
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Easily implement the practice of CI/CD by using a consistent set of development tools and processes across the Azure public cloud and on-premises Azure Stack environments.
ms.custom: acom-architecture, CI/CD, Azure CI/CD, Continuous Integration And Continuous Deployment, devops, Azure DevOps, Microsoft DevOps, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/hybrid-ci-cd/'
ms.service: architecture-center
ms.category:
  - devops
  - hybrid
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/hybrid-ci-cd.png
---

# Hybrid CI/CD

[!INCLUDE [header_file](../header.md)]

Implementing a continuous integration/continuous development (CI/CD) approach to deploying applications becomes difficult when on-premises applications are built and operated in different ways than cloud applications. Having a consistent set of development tools and processes across the Azure public cloud and on-premises Azure Stack environments makes it far easier for organizations to implement a practice of CI/CD. Apps and services deployed the right way in Azure and Azure Stack are essentially interchangeable and can run in either location.

## Architecture

![Architecture diagram](../media/hybrid-ci-cd.png)
*Download an [SVG](../media/hybrid-ci-cd.svg) of this architecture.*

## Data Flow

1. Engineer makes changes to application code and ARM template.
1. Code and ARM template are checked into Azure DevOps Git.
1. Continuous integration triggers application build and unit tests.
1. Continuous deployment trigger orchestrates deployment of application artifacts with environment-specific parameters.
1. Deployment to App Service on both Azure and Azure Stack.

## Components

* [Azure Stack](https://azure.microsoft.com/overview/azure-stack) is a hybrid cloud platform that lets you use Azure services on-premises
* Step-by-step guidance: Step-by-step guidance
* [Azure DevOps](https://azure.microsoft.com/services/devops): Build and deploy multi-platform apps to get the most from Azure services
* [Web Apps](https://azure.microsoft.com/services/app-service/web): Quickly create and deploy mission critical Web apps at scale.

## Next steps

* [Azure Stack User Documentation](https://docs.microsoft.com/azure/azure-stack/user)
* [Deploy apps to Azure and Azure Stack](https://docs.microsoft.com/azure/azure-stack/user/azure-stack-solution-pipeline)
* [Azure DevOps](https://azure.microsoft.com/services/devops)
* [Use Azure DevOps to deploy to an Azure Web App](https://docs.microsoft.com/vsts/build-release/apps/cd/azure/aspnet-core-to-azure-webapp)
