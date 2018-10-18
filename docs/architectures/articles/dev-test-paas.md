---
title: Dev-Test deployment for testing PaaS solutions
description: This architecture represents how to configure your infrastructure for development and testing of a standard PaaS-style system.
author: adamboeglin
ms.date: 10/18/2018
---
# Dev-Test deployment for testing PaaS solutions
This architecture represents how to configure your infrastructure for development and testing of a standard PaaS-style system.
This solution is built on the Azure managed services: Azure DevOps, Azure SQL Database, Redis Cache and Application Insights. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/dev-test-paas.svg" alt='architecture diagram' />

## Components
* [Azure DevOps](http://azure.microsoft.com/services/devops/) manage the development process.
* The [Microsoft Release Management](https://www.visualstudio.comhttp://azure.microsoft.com/docs/release/getting-started/configure-agents) build and release agents deploy the Azure Resource Manager template and associated code to the various environments.
* [Resource Groups](https://www.visualstudio.comhref="http://azure.microsoft.com/docs/release/getting-started/configure-agents): AzureDevOps resource groups are used to define all the services required to deploy the solution into a dev-test or production environment.
* [Web Apps](href="http://azure.microsoft.com/services/app-service/web/): A web app runs the website and is deployed to all environments. Staging slots are used to swap pre-production and production versions.
* [Azure SQL Database](http://azure.microsoft.com/services/sql-database/) maintains data for the website. Copies are deployed in the dev, test, and production environments.
* [Redis Cache](http://azure.microsoft.com/services/cache/) is used in each environment to improve performance of the website.
* Application Insights: Application Insights monitors the web application during development and test runs, and then monitors the full production system when its released.

## Next Steps
* [Set up Azure DevOps](https://www.visualstudio.com/docs/setup-admin/get-started)
* [Configure Microsoft Release Management agents](https://www.visualstudio.com/docs/release/getting-started/configure-agents)
* [Deploy using Azure Resource Groups](https://github.com/Microsoft/vsts-tasks/tree/master/Tasks/AzureResourceGroupDeployment)
* [Deploy an ASP.NET web app to Azure App Service, using Visual Studio](https://docs.microsoft.com/api/Redirect/documentation/articles/web-sites-dotnet-get-started/)
* [SQL Database tutorial: Create a SQL database in minutes by using the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/sql-database-get-started/)
* [How to create a web app with Redis Cache](https://docs.microsoft.com/api/Redirect/documentation/articles/cache-web-app-howto/)
* [Set up Application Insights for ASP.NET](https://docs.microsoft.com/api/Redirect/documentation/articles/app-insights-asp-net/)