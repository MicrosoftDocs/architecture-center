---
title: "CAF: Migrate assets"
description: Migrate assets
author: matticusau
ms.author: mlavery
ms.date: 4/4/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-new"
---

# Migrate assets

This guide focuses on the **rehost** (also called **lift-and-shift****) migration methodology. It moves the current state to the chosen cloud provider with minimal changes to the overall architecture.

In this phase of the journey, you use the output of the assess phase to initiate the migration of the environment. This guide help identify the appropriate tools to reach a "done state", such as native tools, third party tools, and project Management tools.

# [Native migration tools](#tab/Tools)

The following sections describe the native Azure tools available to perform or assist with a migration.

## Azure Site Recovery

The Azure Site Recovery service can manage the migration of on-premises resources to Azure. It can also manage and orchestrate disaster recovery of on-premises machines and Azure VMs for business continuity and disaster recovery (BCDR) purposes.

### Migrate using the Azure Site Recovery service

To use Azure Site Recovery to migrate resources:

> [!TIP]
> Depending on your scenario, these steps may differ slightly.

1. In the Azure Portal, click **Create a resource > Management Tools > Backup and Site Recovery**.
1. Complete the wizard to create a **Recovery Services vault** resource.
1. In the Resource menu, click **Site Recovery > Prepare Infrastructure > Protection goal**.
1. In **Protection goal**, select what you want to migrate.
    1. **VMware:** Select To Azure > Yes, with VMWare vSphere Hypervisor.
    1. **Physical machine:** Select To Azure > Not virtualized/Other.
    1. **Hyper-V:** Select To Azure > Yes, with Hyper-V. If Hyper-V VMs are managed by VMM, select Yes.
1. Set up the source environment as appropriate.
1. Set up the target environment.
    1. Click **Prepare infrastructure > Target**, and select the Azure subscription you want to use.
    1. Specify the Resource Manager deployment model.
    1. Site Recovery checks that you have one or more compatible Azure storage accounts and networks.
1. Set up a replication policy.
1. Enable replication.
1. Run a test migration (test failover).
1. Migrate to Azure (failover).
    1. In **Settings > Replicated items** click the machine > **Failover**.
    1. In **Failover** select a **Recovery Point** to fail over to. Select the latest recovery point.
    1. Configure any encryption key settings as required.
    1. Select **Shut down machine before beginning failover**. Site Recovery will attempt to shutdown virtual machines before triggering the failover. Failover continues even if shutdown fails. You can follow the failover progress on the Jobs page.
    1. Check that the Azure VM appears in Azure as expected.
    1. In **Replicated items**, right-click the VM and choose **Complete Migration**.
1. Perform any post-migration steps as required (see relevant information in this guide).

::: zone target="chromeless"

::: form action="OpenBlade[#create/Microsoft.RecoveryServices]" submitText="Create a Recovery Services vault" :::

::: zone-end

::: zone target="docs"

For more information, see:

- [Migrate on-premises machines to Azure](/azure/site-recovery/migrate-tutorial-on-premises-azure)

::: zone-end

## Azure Database Migration Service

The Azure Database Migration Service is a fully managed service that enables seamless migrations from multiple database sources to Azure data platforms, with minimal downtime (online migrations). The Azure Database Migration Service performs all of the required steps. You can fire and forget your migration projects with peace of mind, knowing that the process takes advantage of best practices recommended by Microsoft.

### Create an Azure Database Migration Service instance

If this is the first time using Azure Database Migration Service, you first need to register the resource provider within your Azure subscription:

1. Select **All Services**, then **Subscriptions**, and choose the target subscription.
1. Select **Resource providers**.
1. Search for `migration`, and then to the right of **Microsoft.DataMigration**, select **Register**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

::: zone-end

Once you have registered the resource provider, you can proceed to create an instance of Azure Database Migration Service.

1. Select **+Create a resource** and search the marketplace for **Azure Database Migration Service**.
1. Complete the **Create Migration Service** wizard, and select **Create**.

The service is now ready to migrate the supported source databases (for example, SQL Server, MySQL, PostgreSQL, or MongoDb).

::: zone target="chromeless"

::: form action="OpenBlade[#create/Microsoft.AzureDMS]" submitText="Create an Azure Database Migration Service instance" :::

::: zone-end

::: zone target="docs"

For more information, see:

- [Azure Database Migration Service overview](/azure/dms/dms-overview)
- [Azure Migrate in the Azure Portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
- [Azure Portal: Create a migration project](https://ms.portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

# [Third-party migration tools](#tab/third-party-tools)

Several third-party migration tools and ISV services can assist you with the migration process. Each offers different benefits and strengths. These tools include:

## Cloudamize

Cloudamize is an ISV service that covers all phases of the migration strategy.

[Learn more](https://www.cloudamize.com)

### Zerto

Zerto provides virtual replication handling both Microsoft Hyper-V and VMWare vSphere environments.

[Learn more](https://www.zerto.com/solutions/use-cases/data-center-migration-software)

### Carbonite

Carbonite provides server and data migration solutions to migrate workloads to, from, or between any physical, virtual, or cloud-based environment.

[Learn More](https://www.carbonite.com/data-protection/data-migration-software)

# [Project management tools](#tab/project-management-tools)

Most organizations already have project management tools. Additionally, most project managers have their own favorite tools and might influence the tool your organization chooses if you don't already have. What really matters is that you **use a project management tool**. Projects that don't effectively plan, track, and manage the project are more susceptible to delays, budget overruns, failures, rejections, and other problems that prevent a successful outcome.

There are many project management tools available. This list shows some tools that might assist you during your project. These tools can be combined to provide broader capabilities.

- [Microsoft Planner](https://tasks.office.com): A simple, visual way to organize teamwork.
- [Microsoft Project](https://products.office.com/project/project-and-portfolio-management-software): Project and Portfolio Management, Resource Capacity Management, Financial Management, Timesheeting and Schedule Management.
- [Microsoft Teams](https://products.office.com/microsoft-teams): Team collaboration and communication tool, as well as integration with Planner and other tools to improve collaboration.

These are certainly not the only tools available. Many other third-party tools are widely used in the project management community.

# [Cost management](#tab/ManageCost)

As you migrate resources to your cloud environment, it is important to perform periodic cost analysis. This helps you avoid unexpected usage charges, since the migration process can place additional usage requirements on your services. You can also resize resources as needed to balance cost and workload (discussed in more detail in the **Optimize and Transform** section).
