---
title: Dev-Test deployment for testing PaaS solutions
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: This architecture represents how to configure your infrastructure for development and testing of a standard PaaS-style system.
ms.custom: acom-architecture, devops, 'https://azure.microsoft.com/solutions/architecture/dev-test-paas/'
ms.service: architecture-center
ms.category:
  - devops
  - databases
  - developer-tools
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/dev-test-paas.png
---

# Dev-Test deployment for testing PaaS solutions

[!INCLUDE [header_file](../header.md)]

This architecture represents how to configure your infrastructure for development and testing of a standard PaaS-style system.

This solution is built on the Azure managed services: [Azure DevOps](https://azure.microsoft.com/services/devops), [Azure SQL Database](https://azure.microsoft.com/services/sql-database), [Azure Cache for Redis](https://azure.microsoft.com/services/cache) and Application Insights. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture diagram](../media/dev-test-paas.png)
*Download an [SVG](../media/dev-test-paas.svg) of this architecture.*

## Components

* [Azure DevOps](https://azure.microsoft.com/services/devops) manage the development process.
* The [Microsoft Release Management](https://www.visualstudio.com/docs/release/getting-started/configure-agents) build and release agents deploy the Azure Resource Manager template and associated code to the various environments.
* [Resource Groups](https://www.visualstudio.com/docs/release/getting-started/configure-agents): AzureDevOps resource groups are used to define all the services required to deploy the solution into a dev-test or production environment.
* [Web Apps](https://azure.microsoft.com/services/app-service/web): A web app runs the website and is deployed to all environments. Staging slots are used to swap pre-production and production versions.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database) maintains data for the website. Copies are deployed in the dev, test, and production environments.
* [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is used in each environment to improve performance of the website.
* Application Insights: Application Insights monitors the web application during development and test runs, and then monitors the full production system when it's released.

## Next steps

* [Set up Azure DevOps](https://www.visualstudio.com/docs/setup-admin/get-started)
* [Configure Microsoft Release Management agents](https://www.visualstudio.com/docs/release/getting-started/configure-agents)
* [Deploy using Azure Resource Groups](https://github.com/microsoft/azure-pipelines-tasks/tree/master/Tasks/AzureResourceGroupDeploymentV2)
* [Deploy an ASP.NET web app to Azure App Service, using Visual Studio](https://docs.microsoft.com/azure/app-service/app-service-web-get-started-dotnet-framework)
* [SQL Database tutorial: Create a SQL database in minutes by using the Azure portal](https://docs.microsoft.com/azure/sql-database/sql-database-single-database-get-started?tabs=azure-portal)
* [How to create a web app with Azure Cache for Redis](https://docs.microsoft.com/azure/azure-cache-for-redis/cache-web-app-howto)
* [Set up Application Insights for ASP.NET](https://docs.microsoft.com/azure/azure-monitor/app/asp-net)
