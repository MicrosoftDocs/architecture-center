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

This guide focuses on the **Rehost** ("lift and shift") migration methodology which moves the current state to the chosen cloud provider, with minimal change to overall architecture.

In this phase of the journey you utilize the output of the assess phase to initiate the migration of the environment. This guide helps with identifying the appropriate tools to reach "done state", including Native tools, 3rd Party tools, and Project Management tools.

# [Native Migration Tools](#tab/Tools)

Azure provides a number of native tools which can perform the migration, or assist with stages of the migration. The following sections outline the various tools available.

## Azure Site Recovery

Azure Site Recovery service can not only be used to manage and orchestrate disaster recovery of on-premises machines and Azure VMs for the purposes of business continuity and disaster recovery (BCDR). You can also use Site Recovery to manage migration of on-premises machines to Azure.

### Migrate to Azure with Site Recovery service

The following steps outline the process to use Site Recovery service to migrate:

[!TIP]
Depending on your scenario, the exact steps may differ slightly.

1. In the Azure Portal, click **Create a resource > Management Tools > Backup and Site Recovery**
1. Complete the wizard to create a **Recovery Services vault** resource
1. In the Resource Menu, click **Site Recovery > Prepare Infrastructure > Protection goal**
1. In **Protection goal**, select what you want to migrate.
    1. **VMware**: Select To Azure > Yes, with VMWare vSphere Hypervisor.
    1. **Physical machine**: Select To Azure > Not virtualized/Other.
    1. **Hyper-V**: Select To Azure > Yes, with Hyper-V. If Hyper-V VMs are managed by VMM, select Yes.
1. Set up the source environment as appropriate
1. Set up the target environment
    1. Click **Prepare infrastructure > Target**, and select the Azure subscription you want to use.
    1. Specify the Resource Manager deployment model.
    1. Site Recovery checks that you have one or more compatible Azure storage accounts and networks.
1. Set up a replication policy
1. Enable replication
1. Run a test migration (test failover)
1. Migrate to Azure (failover)
    1. In **Settings > Replicated items** click the machine > **Failover**.
    1. In **Failover** select a **Recovery Point** to fail over to. Select the latest recovery point.
    1. Configure any encryption key settings as required
    1. Select **Shut down machine before beginning failover**. Site Recovery will attempt to shutdown virtual machines before triggering the failover. Failover continues even if shutdown fails. You can follow the failover progress on the Jobs page.
    1. Check that the Azure VM appears in Azure as expected.
    1. In **Replicated items**, right-click the VM > **Complete Migration**.
1. Perform any post migration steps as required (see relevant information in this guide)

::: zone target="chromeless"

::: form action="OpenBlade[#create/Microsoft.RecoveryServices]" submitText="Create a Recovery Services vault" :::

::: zone-end

::: zone target="docs"

Additional information can be found in the following resources:

* [Migrate on-premises machines to Azure](https://docs.microsoft.com/en-gb/azure/site-recovery/migrate-tutorial-on-premises-azure)

::: zone-end

## Azure Database Migration Service

The Azure Database Migration Service is a fully managed service designed to enable seamless migrations from multiple database sources to Azure data platforms with minimal downtime (online migrations). The Azure Database Migration Service performs all of the required steps. You can fire and forget your migration projects with peace of mind, knowing that the process takes advantage of best practices as determined by Microsoft.

### Create a Database Migration Service

If this is the first time using the Database Migration Service then you need to first Register the resource provider within your Azure subscription.

1. Select **All Services**, then **Subscriptions** and the target subscription
1. Select **Resource providers**
1. Search for `migration`, and then to the right of **Microsoft.DataMigration**, select **Register**

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

::: zone-end

Once you have registered the resource provider, you can proceed to create an instance of the Database Migration Service

1. Select **+Create a resource** and search the marketplace for **Azure Database Migration Service**
1. Complete the **Create Migration Service** wizard, and select **Create**

The migration service is now ready to migrate the supported source databases (e.g. SQL Server, MySQL, PostgreSQL, MongoDb, etc).

::: zone target="chromeless"

::: form action="OpenBlade[#create/Microsoft.AzureDMS]" submitText="Create a Database Migration Service" :::

::: zone-end

::: zone target="docs"

Additional information can be found in the following resources:

* [Database Migration Service Overview](https://docs.microsoft.com/en-gb/azure/dms/dms-overview)
* [Azure Migrate in the Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
* [Create Migration project in the Azure Portal](https://ms.portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

# [3rd Party Migration Tools](#tab/3rd-party-tools)

Several 3rd Party migration tools and ISV services exist to assist you with the migration process. Each offers different benefits and focus areas. The following are just a selection available:

### Cloudamize

Cloudamize is an ISV service which covers all phases of the migration strategy.

[Learn more](https://www.cloudamize.com/)

### Zerto

Zerto provides virtual replication handling both Microsoft Hyper-V and VMWare vSphere environments.

[Learn more](https://www.zerto.com/solutions/use-cases/data-center-migration-software/)

### Carbonite

Cabonite - Server and data migration solutions to migrate workloads to, from or between any physical, virtual or cloud-based environment.

[Learn More](https://www.carbonite.com/data-protection/data-migration-software)

# [Project Management Tools](#tab/project-management-tools)

Most organizations already have project management tools within their business. In addition most Project Managers have personal favorites which may influence which tool your organization chooses should you not have an existing tool. The most important decision is that you choose to **use a project management tool**. Projects that do not use a sufficient tool to plan, track and manage the project are typically always more susceptible to delays, budget blow outs, failures, rejections, and other issues that prevent a successful outcome.

There are many project management tools available but the following is a list which may assist you during your project. These tools do not need to be used in isolation, and may be used in combination for enhanced benefits:

> * [Microsoft Planner](https://tasks.office.com/) - A simple, visual way to organize teamwork.
> * [Microsoft Project](https://products.office.com/en-us/project/project-and-portfolio-management-software) - Project and Portfolio Management, Resource Capacity Management, Financial Management, Timesheeting and Schedule Management
> * [Microsoft Teams](https://products.office.com/en-us/microsoft-teams) - Team collaboration and communication tool, as well as integration with Planner and other tools to improve collaboration

This list is certainly not the only tools available, as there are many 3rd party tools widely used within the community to perform Project Management.

# [Cost Management](#tab/ManageCost)

As you migration your resources into your cloud environment it is important to perform regular cost analysis. This provides you with an opportunity to avoid an unexpected usage charges as a migration process can place additional usage requirements on your services. You also have the ability to resize resources as needed to balance cost and workload, which is covered in more detail within the **Optimize and Transform** section.
