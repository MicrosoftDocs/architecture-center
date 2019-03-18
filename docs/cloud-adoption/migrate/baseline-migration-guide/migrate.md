---
title: "CAF: Migrate assets"
description: Migrate assets
author: matticusau
ms.author: mlavery
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-new"
---

# Migrate assets

The following options exist for migrating your solution.

> * **Rehost** - Also known as "lift and shift," a rehost effort moves the current state asset to the chosen cloud provider, with minimal change to overall architecture.
> * **Refactor** - Platform as a Service (PaaS) options can reduce operational costs associated with many applications. It can be prudent to slightly refactor an application to fit a PaaS based model. Refactor also refers to the application development process of refactoring code to allow an application to deliver on new business opportunities.
> * **Rearchitect** - Some aging applications aren't compatible with cloud providers because of the architectural decisions made when the application was built. In these cases, the application may need to be rearchitected prior to transformation.
> * **Rebuild** - In some scenarios, the delta that must be overcome to carry forward an application can be too large to justify further investment and the solution must be rebuilt.
> * **Replace** - Solutions are generally implemented using the best technology and approach available at the time. In some cases, Software as a Service (SaaS) applications can meet all of the functionality required of the hosted application. In these scenarios, a workload could be slated for future replacement, effectively removing it from the transformation effort.

![Infographic of the migration options](../../_images/migration/migration-options.png)

# [Native Migration Tools](#tab/Tools)

Native migrations tools.

## Azure Site Recovery



## Azure Database Migration Service

The Azure Database Migration Service is a fully managed service designed to enable seamless migrations from multiple database sources to Azure data platforms with minimal downtime (online migrations). The Azure Database Migration Service performs all of the required steps. You can fire and forget your migration projects with peace of mind, knowing that the process takes advantage of best practices as determined by Microsoft.

::: zone target="docs"

### Read more

* [Database Migration Service Overview](https://docs.microsoft.com/en-gb/azure/dms/dms-overview)
* [Azure Migrate in the Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
* [Create Migration project in the Azure Portal](https://ms.portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

::: zone target="chromeless"

### Create a Database Migration Service

If this is the first time using the Database Migration Service then you need to first Register the resource provider within your Azure subscription.

1. Select **All Services**, then **Subscriptions** and the target subscription
1. Select **Resource providers**
1. Search for `migration`, and then to the right of **Microsoft.DataMigration**, select **Register**

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

Once you have registered the resource provider, you can proceed to create an instance of the Database Migration Service

1. Select **+Create a resource** and search the marketplace for **Azure Database Migration Service**
1. Complete the **Create Migration Service** wizard, and select **Create**

The migration service is now ready to migrate the supported source databases (e.g. SQL Server, MySQL, PostgreSQL, MongoDb, etc).

::: form action="OpenBlade[#create/Microsoft.AzureDMS]" submitText="Create a Database Migration Service" :::

::: zone-end

# [3rd Party Migration Tools](#tab/3rd-party-tools)

add text

# [Project Management Tools](#tab/project-management-tools)

add text

# [Cost Management](#tab/ManageCost)

As you migration your resources into your cloud environment it is important to perform regular cost analysis. This provides you with an opportunity to avoid an unexpected usage charges as a migration process can place additional usage requirements on your services. You also have the ability to resize resources as needed to balance cost and workload, which is covered in more detail within the **Optimize and Transform** section.
