---
title: "Migrate assets"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Migrate assets
author: matticusau
ms.author: mlavery
ms.date: 08/08/2019
ms.topic: conceptual
ms.service: cloud-adoption-framework
ms.subservice: migrate
ms.custom: fasttrack-new, AQC
ms.localizationpriority: high
---

# Migrate assets (infrastructure, apps, and data)

In this phase of the journey, you use the output of the assess phase to initiate the migration of the environment. This guide helps identify the appropriate tools to reach a "done state", including native tools, third-party tools, and project management tools.

# [Native migration tools](#tab/Tools)

The following sections describe the native Azure tools available to perform or assist with migration. For information on choosing the right tools to support your migration efforts, see the [Cloud Adoption Framework's Migration tools decision guide](../../decision-guides/migrate-decision-guide/index.md).

## Azure Migrate

Azure Migrate delivers a unified and extensible migration experience. Azure Migrate provides a one-stop, dedicated experience to track your migration journey across the phases of assessment and migration to Azure. It provides you the option to use the tools of your choice and track the progress of migration across these tools.

Azure Migrate provides the following functionality:

1. Enhanced assessment and migration capabilities:
    - Hyper-V assessments.
    - Improved VMware assessment.
    - Agentless migration of VMware virtual machines to Azure.
1. Unified assessment, migration, and progress tracking.
1. Extensible approach with ISV integration (such as Cloudamize).

To perform a migration using Azure Migrate follow these steps:

1. Search for Azure Migrate under **All services**. Select **Azure Migrate** to continue.
1. Select **Add a tool** to start your migration project.
1. Select the subscription, resource group, and geography to host the migration.
1. Select **Select assessment tool** > **Azure Migrate: Server Assessment** >  **Next**.
1. Select **Review + add tool(s)**, and verify the configuration. Click **Add tool(s)** to initiate the job to create the migration project and register the selected solutions.

<!-- TODO: TBA -->

### Read more

- [Azure Migrate tutorial - Migrate physical or virtualized servers to Azure](/azure/migrate/tutorial-migrate-physical-virtual-machines)

## Azure Site Recovery

The Azure Site Recovery service can manage the migration of on-premises resources to Azure. It can also manage and orchestrate disaster recovery of on-premises machines and Azure VMs for business continuity and disaster recovery (BCDR) purposes.

The following steps outline the process to use Site Recovery to migrate:

> [!TIP]
> Depending on your scenario, these steps may differ slightly. For more information, see the [Migrate on-premises machines to Azure](/azure/site-recovery/migrate-tutorial-on-premises-azure) article.

### Prepare Azure Site Recovery service

1. In the Azure portal, select **+Create a resource > Management Tools > Backup and Site Recovery**.
1. If you haven't yet created a recovery vault, complete the wizard to create a **Recovery Services vault** resource.
1. In the **Resource** menu, select **Site Recovery > Prepare Infrastructure > Protection goal**.
1. In **Protection goal**, select what you want to migrate.
    1. **VMware:** Select **To Azure > Yes, with VMware vSphere Hypervisor**.
    1. **Physical machine:** Select **To Azure > Not virtualized/Other**.
    1. **Hyper-V:** Select **To Azure > Yes, with Hyper-V**. If Hyper-V VMs are managed by VMM, select **Yes**.

### Configure migration settings

1. Set up the source environment as appropriate.
1. Set up the target environment.
    1. Click **Prepare infrastructure > Target**, and select the Azure subscription you want to use.
    1. Specify the Resource Manager deployment model.
    1. Site Recovery checks that you have one or more compatible Azure storage accounts and networks.
1. Set up a replication policy.
1. Enable replication.
1. Run a test migration (test failover).

### Migrate to Azure using failover

1. In **Settings > Replicated items** select the machine > **Failover**.
1. In **Failover** select a **Recovery Point** to fail over to. Select the latest recovery point.
1. Configure any encryption key settings as required.
1. Select **Shut down machine before beginning failover**. Site Recovery will attempt to shut down virtual machines before triggering the failover. Failover continues even if shutdown fails. You can follow the failover progress on the Jobs page.
1. Check that the Azure VM appears in Azure as expected.
1. In **Replicated items**, right-click the VM and choose **Complete Migration**.
1. Perform any post-migration steps as required (see relevant information in this guide).

::: zone target="chromeless"

::: form action="Create[#create/Microsoft.RecoveryServices]" submitText="Create a Recovery Services vault" :::

::: zone-end

::: zone target="docs"

For more information, see:

- [Migrate on-premises machines to Azure](/azure/site-recovery/migrate-tutorial-on-premises-azure)

::: zone-end

## Azure Database Migration Service

The Azure Database Migration Service is a fully managed service that enables seamless migrations from multiple database sources to Azure data platforms, with minimal downtime (online migrations). The Azure Database Migration Service performs all of the required steps. You can initiate your migration projects with the assurance that the process takes advantage of best practices recommended by Microsoft.

### Create an Azure Database Migration Service instance

If this is the first time using Azure Database Migration Service, you need to register the resource provider for your Azure subscription:

1. Select **All services**, then **Subscriptions**, and choose the target subscription.
1. Select **Resource providers**.
1. Search for `migration`, and then to the right of **Microsoft.DataMigration**, select **Register**.

::: zone target="chromeless"

::: form action="OpenBlade[#blade/Microsoft_Azure_Billing/SubscriptionsBlade]" submitText="Go to Subscriptions" :::

::: zone-end

After you register the resource provider, you can create an instance of Azure Database Migration Service.

1. Select **+Create a resource** and search the marketplace for **Azure Database Migration Service**.
1. Complete the **Create Migration Service** wizard, and select **Create**.

The service is now ready to migrate the supported source databases (for example, SQL Server, MySQL, PostgreSQL, or MongoDb).

::: zone target="chromeless"

::: form action="Create[#create/Microsoft.AzureDMS]" submitText="Create an Azure Database Migration Service instance" :::

::: zone-end

::: zone target="docs"

For more information, see:

- [Azure Database Migration Service overview](/azure/dms/dms-overview)
- [Create an instance of the Azure Database Migration Service](/azure/dms/quickstart-create-data-migration-service-portal)
- [Azure Migrate in the Azure portal](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/HierarchyBlade)
- [Azure portal: Create a migration project](https://portal.azure.com/#create/Microsoft.AzureMigrate)

::: zone-end

## Data Migration Assistant

The Data Migration Assistant (DMA) helps you upgrade to a modern data platform by detecting compatibility issues that can affect database functionality in your new version of SQL Server or Azure SQL Database. DMA recommends performance and reliability improvements for your target environment and allows you to move your schema, data, and uncontained objects from your source server to your target server.

> [!NOTE]
> For large migrations (in terms of number and size of databases), we recommend that you use the Azure Database Migration Service, which can migrate databases at scale.
>

To get started with the Data Migration Assistant follow these steps.

1. Download and Install the Data Migration Assistant from the [Microsoft Download Center](https://www.microsoft.com/download/details.aspx?id=53595).
1. Create an assessment by clicking the **New (+)** icon and select the **Assessment** project type.
1. Set the source and target server type. Click **Create**.
1. Configure the assessment options as required (recommend all defaults).
1. Add the databases to assess.
1. Click **Next** to start the assessment.
1. View results within the Data Migration Assistant tool set.

For an enterprise, we recommend following the approach outlined in [Assess an enterprise and consolidate assessment reports with DMA](/sql/dma/dma-consolidatereports) to assess multiple servers, combine the reports and then use provided Power BI reports to analyze the results.

For more information, including detailed usage steps, see:

- [Data Migration Assistant overview](/sql/dma/dma-overview)
- [Assess an enterprise and consolidate assessment reports with DMA](/sql/dma/dma-consolidatereports)
- [Analyze consolidated assessment reports created by Data Migration Assistant with Power BI](/sql/dma/dma-powerbiassesreport)

## SQL Server Migration Assistant

Microsoft SQL Server Migration Assistant (SSMA) is a tool designed to automate database migration to SQL Server from Microsoft Access, DB2, MySQL, Oracle, and SAP ASE. The general concept is to collect, assess, and then review with these tools, however, due to the variances in the process for each of the source systems we recommend reviewing the detailed [SQL Server Migration Assistant documentation](/sql/ssma/sql-server-migration-assistant).

For more information, see:

- [SQL Server Migration Assistant overview](/sql/ssma/sql-server-migration-assistant)

## Database Experimentation Assistant

Database Experimentation Assistant (DEA) is a new A/B testing solution for SQL Server upgrades. It will assist in evaluating a targeted version of SQL for a given workload. Customers who are upgrading from previous SQL Server versions (SQL Server 2005 and above) to any new version of the SQL Server can use these analysis metrics.

The Database Experimentation Assistant contains the following workflow activities:

- **Capture:** The first step of SQL Server A/B testing is to capture a trace on your source server. The source server usually is the production server.
- **Replay:** The second step of SQL Server A/B testing is to replay the trace file that was captured to your target servers. Then, collect extensive traces from the replays for analysis.
- **Analysis:** The final step is to generate an analysis report by using the replay traces. The analysis report can help you gain insight about the performance implications of the proposed change.

For more information, see:

- [Overview of Database Experimentation Assistant](/sql/dea/database-experimentation-assistant-overview)

# [Third-party migration tools](#tab/third-party-tools)

Several third-party migration tools and ISV services can assist you with the migration process. Each offers different benefits and strengths. These tools include:

## Cloudamize

Cloudamize is an ISV service that covers all phases of the migration strategy.

[Learn more](https://www.cloudamize.com)

## Zerto

Zerto provides virtual replication handling both Microsoft Hyper-V and VMware vSphere environments.

[Learn more](https://www.zerto.com/solutions/use-cases/data-center-migration-software)

## Carbonite

Carbonite provides server and data migration solutions to migrate workloads to, from, or between any physical, virtual, or cloud-based environment.

[Learn More](https://www.carbonite.com/data-protection/data-migration-software)

## Movere

Movere is a discovery solution that provides the data and insights needed to plan cloud migrations and continuously optimize, monitor, and analyze IT environments with confidence.

[Learn more](https://www.movere.io)

Visit the [Azure Migration Center](https://azure.microsoft.com/migration/support) to discover organizations offering ready-to-use partner technology solutions to fit your migration scenarios and learn more about additional third-party migration tools and support services.

# [Project management tools](#tab/project-management-tools)

Projects that aren't tracked and managed are more likely to run into problems. To ensure a successful outcome, we think it's important that you use a project management tool. There are many different tools available and project managers in your organization may already have a favorite. Microsoft offers the following project management tools, which can work together to provide broader capabilities:

- [Microsoft Planner](https://tasks.office.com): A simple, visual way to organize teamwork.
- [Microsoft Project](https://products.office.com/project/project-and-portfolio-management-software): Project and Portfolio Management, Resource Capacity Management, Financial Management, Timesheet and Schedule Management.
- [Microsoft Teams](https://products.office.com/microsoft-teams): Team collaboration and communication tool. Teams also integrates Planner and other tools to improve collaboration.
- [Azure DevOps](https://dev.azure.com): Using Azure DevOps, you can manage your infrastructure as code or use the work items and boards to perform project management. As you mature, your organization can take advantage of the CI/CD capabilities.

These are not the only tools available. Many other third-party tools are widely used in the project management community.

## Set up for DevOps

As you migrate into cloud technologies this presents a great opportunity to set up your organization for DevOps and CI/CD. Even if your organization is only managing infrastructure, as you begin to manage your infrastructure as code and use the industry patterns and practices for DevOps you can begin to increase your agility through CI/CD pipelines, therefore allowing you to adapt to change, growth, release, and even recovery scenarios faster.

[Azure DevOps](https://dev.azure.com) provides all of the required functionality and integration with Azure, On-premises, or even other clouds. Find out more [here](https://azure.microsoft.com/services/devops). For a guided training, see [CI and CD with Azure DevOps - Quickstart](https://microsoft.github.io/PartsUnlimited/pandp/200.1x-PandP-CICDQuickstartwithVSTS.html).

# [Cost management](#tab/ManageCost)

As you migrate resources to your cloud environment, it's important to perform periodic cost analysis. This helps you avoid unexpected usage charges, since the migration process can place additional usage requirements on your services. You can also resize resources as needed to balance cost and workload (discussed in more detail in the **[Optimize and Transform](optimize-and-transform.md)** section).
