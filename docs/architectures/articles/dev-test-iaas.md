---
title: Dev-Test deployment for testing IaaS solutions
description: This architecture represents how to configure your infrastructure for development and testing of a standard IaaS-based SaaS system.
author: adamboeglin
ms.date: 10/18/2018
---
# Dev-Test deployment for testing IaaS solutions
This architecture represents how to configure your infrastructure for development and testing of a standard IaaS-based SaaS system.
This solution is built on the Azure managed services: Azure DevOps, Azure DevTest Labs, Virtual Machines and Application Insights. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/dev-test-iaas.svg" alt='architecture diagram' />

## Components
* [Azure DevOps](http://azure.microsoft.com/services/devops/) manages the development process.
* The [Microsoft Release Management](https://www.visualstudio.comhttp://azure.microsoft.com/docs/release/getting-started/configure-agents) build and release agents deploy the Azure Resource Manager template and associated code to the various environments.
* [Azure DevOps resource groups](https://www.visualstudio.comhttp://azure.microsoft.com/docs/release/getting-started/configure-agents) are used to define all the services required to deploy the solution into a dev-test or production environment.
* [Azure DevTest Labs](href="http://azure.microsoft.com/services/devtest-lab/): Azure Dev-Test Labs manages all of the virtual machines used in the development and test environments.
* [Virtual Machines](href="http://azure.microsoft.com/services/virtual-machines/): Virtual machines are used to deploy all of the products used in the solution. Staging slots swap pre-production and production versions.
* Application Insights: Application Insights monitors the web application during development and test runs, and then monitors the full production system when its released.

## Next Steps
* [Set up Azure DevOps](https://www.visualstudio.com/docs/setup-admin/get-started)
* [Configure Microsoft Release Management agents](https://www.visualstudio.com/docs/release/getting-started/configure-agents)
* [Deploy using Azure Resource Groups](https://github.com/Microsoft/vsts-tasks/tree/master/Tasks/DeployAzureResourceGroup)
* [Create a lab in Azure DevTest Labs](https://docs.microsoft.com/api/Redirect/documentation/articles/devtest-lab-create-lab/)
* [Create your first Windows virtual machine in the Azure portal](https://docs.microsoft.com/api/Redirect/documentation/articles/virtual-machines-windows-hero-tutorial/)
* [Set up Application Insights for ASP.NET](https://docs.microsoft.com/api/Redirect/documentation/articles/app-insights-asp-net/)