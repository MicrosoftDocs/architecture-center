---
title: Business Central as a Service on Azure
titleSuffix: Azure Example Scenarios
description: Building Dynamics 365 Business Central as a private service in countries where SaaS is not available.
author: altotovi
ms.date: 06/04/2020
ms.category:
  - databases
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
social_image_url: /azure/architecture/example-scenario/apps/media/architecture-bc-azure.png
---

# Building Business Central as a Service on Azure

In situation when Dynamics 365 Business Central SaaS is not available in all countries, it is important to offer clients similar model Business Central on Azure. Partners can build their own architecture where they can deploy Business Central and clients can use this SMB ERP solution as a service using the most of benefits of using Business Central as a cloud solution. This example shows how to establish the production environment for Business Central in partner private Azure environment.

## Architecture

![Architecture diagram for deploying Business Central on Azure](./media/architecture-bc-azure.png)

This scenario demonstrates provisioning completely environment ready for adding new tenant databases for new customers as well as new demo tenants.
Completely environment except customer database will be built only once and it allow usage for many different customers. For new customer, partner just need to deploy new customer database and to [mount](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/mount-dismount-tenant) it.
The data flows through the scenario as follows:

1. Customers login using web browser, device (phone or tablet) or through API to access the Dynamics 365 Business Central.
2. Virtual Machine as a middle-tier, provides [Web Server Components](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/web-server-overview) and plays roles as [NST Server](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/configure-server-instance), connecting customers with databases. One Virtual Machine can be used for multiple customers as partner needs to provide just different Business Central Server Instance with different ports numbers for each of customers. Using this model, supporting will be much easier as partner need to support only one server, plus one more as security option. With Azure Load balancer, system will scale applications and create highly available services.
3. The application and business data reside in separate databases, both using Azure SQL for its databases. App database will be in one single database (S0 will be enough to run application database). Partner maintains the application centrally without affecting the various tenants that use the application. Tenant databases will be placed in Azure Elastic Database Pool (for beginning, S4 pool with 200 DTU’s will be enough). Each tenant database contains the business data for one or more specific companies from one client and does not contain all of the application metadata. If customers require more power, it is easy to change service tier on Azure SQL and Elastic Database Pool.

To provide better performances, all resources will be in one resource Group. All external services (Azure Machine Learning, Power Apps, Power Automate and Power BI) will communicate directly with NST Server through exposed API’s and OData web services.

## Resource group

[A resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal) is a container that holds related resources for an Azure solution. The resource group can include all the resources for the solution, or only those resources that you want to manage as a group. You decide how you want to allocate resources to resource groups based on what makes the most sense for your organization. Generally, add resources that share the same lifecycle to the same resource group so you can easily deploy, update, and delete them as a group.

## Virtual machine

[Azure Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview) is one of several types of on-demand, scalable computing resources that Azure offers. Typically, you choose a virtual machine when you need more control over the computing environment than the other choices offer. Virtual machine is necessary for middle-tier services in Business Central architecture. Partner can choose between many different types of virtual machines with various number of CPU’s, memory...

## Azure SQL

[Azure SQL Database] (https://docs.microsoft.com/en-us/azure/azure-sql/database/sql-database-paas-overview) is a fully managed Platform as a Service (PaaS) Database Engine that handles most of the database management functions such as upgrading, patching, backups, and monitoring without user involvement. Azure SQL Database is always running on the latest stable version of SQL Server Database Engine and patched OS with 99.99% availability. PaaS capabilities that are built into Azure SQL Database enables you to focus on the domain-specific database administration and optimization activities that are critical for your business.
To choose the right database option, the best way is to choose one of the service tiers. You can choose Standard or Premium service tier with different numbers of [DTU’s](https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-dtu-single-databases#standard-service-tier).
If you are not experienced with deploying Azure SQL databases, you can find more information [here](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/deploy-database-azure-sql-database).

## Elastic Database Pool

[Azure SQL Database elastic pools](https://docs.microsoft.com/en-us/azure/azure-sql/database/elastic-pool-overview) are a simple, cost-effective solution for managing and scaling multiple databases that have varying and unpredictable usage demands. The databases in an elastic pool are on a single server and share a set number of resources at a set price. Elastic pools in Azure SQL Database enable SaaS developers to optimize the price performance for a group of databases within a prescribed budget while delivering performance elasticity for each database.
Similarly with standard Azure SQL, you can choose different tiers and different number of [DTU’s](https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-dtu) for your elastic database pool.

## Azure Load Balancer

With [Azure Load Balancer](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview), you can scale your applications and create highly available services. Load balancer supports both inbound and outbound scenarios. Load balancer provides low latency and high throughput and scales up to millions of flows for all TCP and UDP applications.

## Cost considerations

Very important fact is that partner doesn’t need each virtual machine per each customer. It can significantly reduce costs for middle-tier service (VM).
There are various options for VM sizes depending on the usage and workload. When you just start with your architecture, you don’t need powerful VM as you will probably have one or two databases. You need to track performances and to increase power when it needs.
For app database you can take the smallest Azure SQL as S0 or eventually S1. The same situation is with Azure Elastic Database Pool where you have various options and you need to start with smallest as it is easy scalable.

<!-- links -->

[Mounting a tenant database against the specified Business Central Server instance]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/mount-navtenant?view=businesscentral-ps-16
[Mounting a tenant database on the specified Business Central Server instance]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/mount-navtenantdatabase?view=businesscentral-ps-16
[Creating a normal tenant in a specific tenant database]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/new-navtenant?view=businesscentral-ps-16
[Creating a new Business Central Server instance]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/new-navserverinstance?view=businesscentral-ps-16
[Changing the service state of a Business Central Server instance]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/set-navserverinstance?view=businesscentral-ps-16
[Staring a server instance]: https://docs.microsoft.com/en-us/powershell/module/microsoft.dynamics.nav.management/start-navserverinstance?view=businesscentral-ps-16
