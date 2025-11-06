[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

To address business transformations like acquisitions or divestitures, teams need to plan for the separation or joining of their cloud workloads from an existing Microsoft Entra tenant to a new tenant. This article describes how to define and implement a cross-tenant workload migration strategy.

## Architecture

:::image type="complex" border="false" source="../media/cross-tenant-migration-strategy.svg" alt-text="Diagram that shows a cross-tenant migration architecture." lightbox="../media/cross-tenant-migration-strategy.svg":::
   This diagram outlines a resource migration process. First the Azure Resource Manager template and configuration files are extracted and stored in a source code repository or configuration repository. Then those files are deployed to target resource groups in a new tenant. A temporary subscription, known as a sidecar subscription, is created in the original tenant to hold backups and cloned data service resources. Resources are then cloned by using tools like Azure Data Factory or AzCopy. After the resources are cloned, the subscription is moved to the new tenant. Finally, the resources are migrated or restored in their target groups before the temporary subscription is deleted.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/cross-tenant-migration-strategy.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Prepare the infrastructure and configuration artifacts:

   1. Extract the Azure Resource Manager template and configuration artifacts and store them in a source code repository or configuration repository. This step conforms with infrastructure as code practices and helps ensure that the migrated resources have the same resource deployment definition. It also facilitates deployment automation.

   1. Deploy both the infrastructure and configuration artifacts to the target resource group or groups in the new tenant subscription.

1. Create a sidecar subscription in the existing tenant to host cloned data service resources and backups of virtual machines (VMs). Most organizations have a cloud platform team or subscription vending process that can create this subscription.

1. Clone the resources by using a tool like Azure Data Factory, AzCopy for data migration, or native backup and restore capabilities.

1. Move the subscription to the new tenant.

1. Either move the resources to the target resource group or migrate data to the pre-created resources in the target resource group. Alternatively, restore VMs from the backups. Your implementation plan should describe the provisioning method.

1. Delete the sidecar subscription.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service. Your Microsoft Entra tenant represents your organization and helps you manage an instance of cloud services for your internal and external guests.  In this architecture, it manages organizational identity and access across tenants, which enables secure migration and resource isolation.

- An [Azure subscription](/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) is a logical container for resources. Each Azure resource is associated with only one subscription. Creating a subscription is the first step in Azure adoption. In this architecture, subscriptions are used to organize and isolate resources, and are moved between tenants during migration.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) provides developer services that can help your teams plan work, collaborate on code development, and build and deploy applications. In this architecture, it supports infrastructure as code (IaC) and automates resource deployment in the target tenant.

- [Azure Backup](/azure/backup/backup-overview) is a service for backing up and restoring data in Azure. In this architecture, it ensures data protection and enables recovery during the migration process.

- The [Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. It provides [continuous deployment](/azure/app-service/deploy-continuous-deployment) and other DevOps capabilities. In this architecture, it supports platform as a service (PaaS) compute workloads that are recreated in the target tenant by using DevOps processes.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed and intelligent relational database service. You can use SQL Database to create a high-performance data storage layer for modern cloud applications. In this architecture, it serves as a data service that's backed up and restored during tenant migration because of limitations in direct movement.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and durable cloud storage solution for various data objects in the cloud. In this architecture, it stores configuration artifacts and data backups used during migration.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a software as a service (SaaS) analytics platform that unifies data integration, data engineering, data warehousing, real-time analytics, data science, and business intelligence. In this architecture, it provides an enterprise-scale analytics platform across migrated workloads by consolidating data pipelines, storage (OneLake), and analytical compute in the target tenant.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service for accelerating and managing the machine learning project life cycle. In this architecture, it's part of the PaaS compute resources that are recreated in the target tenant.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is a unified analytics platform for building, deploying, sharing, and maintaining data solutions. In this architecture, it supports scalable data engineering and is recreated in the target tenant.

- [Azure AI services](/azure/ai-services/what-are-ai-services) are cloud-based AI services that can help developers build cognitive intelligence into applications, even without AI or data science skills or knowledge. In this architecture, AI services enhance migrated applications with cognitive intelligence.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed NoSQL and relational database service. In this architecture, it's a data service that's backed up and restored during migration.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service. In this architecture, it supports real-time data processing across tenants.

- [Azure Key Vault](/azure/key-vault/general/overview) is a PaaS service for securely storing and accessing secrets. In this architecture, it's a resource that's recreated in the target tenant to maintain secure access.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. It provides full control over operating systems, storage, and applications without owning physical infrastructure. In this architecture, VMs are backed up and restored in the target tenant to preserve custom logic and configurations.

- [Resource groups](/azure/azure-resource-manager/management/manage-resource-groups-cli) are logical containers for Azure resources. In this architecture, they organize resources before and after migration to maintain structure and manageability.

## Scenario details

To address business transformations like acquisitions or divesture, the transitioning workload team, including developers, architects, operations, and technical decision makers, needs to plan for the separation and joining of their cloud workloads from an existing Microsoft Entra tenant to a new Microsoft Entra tenant. This planning can help ensure that all data and application services are reliably migrated, secured, and isolated to their respective business boundaries.

If your workload exists in a single subscription, in many cases you can use the built-in subscription-move feature to transfer the entire subscription to a new Microsoft Entra tenant. However, because most divestiture organization workloads are intertwined with retaining organization workloads before the split, achieving migration readiness requires a different approach.

In this scenario, a healthcare company that has multiple global business units wants to divest a business. To divest, they need to define and implement a cross-directory workload migration strategy.

To begin, the company classifies workload resources into three categories. One group includes compute resources managed by using PaaS. A second group includes data services that require both PaaS and IaaS support. The final group includes compute resources managed by using IaaS. For each resource type, they use the following approaches.

- For PaaS, or compute, resources that run based on logic and configuration, recreate these resources in the target tenant. Use DevOps processes.

  PaaS compute resources include Key Vault, Machine Learning, Azure Data Factory, and Azure Databricks.

- For PaaS and IaaS, or data service, resources that store data, relocate Azure subscriptions from one Microsoft Entra tenant to another. Move these resources to the new tenant via a sidecar subscription. You need to carefully evaluate the resources before you move them. For example, an Azure SQL database with Microsoft Entra authentication integration enabled can't be moved in its existing state. Use backup and restore instead. This process removes all Azure role-based access control (Azure RBAC) assignments. After the resource is moved to the new tenant, you need to restore those Azure RBAC assignments.

  PaaS and IaaS data include services like Azure SQL Database, Azure Data Lake Storage, and Azure Cosmos DB.

- For IaaS, or compute, resources that provide hosting for customized logic, create backups and restore the resources in the target environment.

  IaaS compute include resources like Virtual Machines hosting applications or databases.

### Potential use cases

- Organizational divestiture and acquisition
- Internal organization spin-offs
- Investing natively in Azure and moving away from a service provider model

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Lalit Patel](https://www.linkedin.com/in/lalit-r-patel-5108a/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure RBAC documentation](/azure/role-based-access-control)
- [Migrate an Azure subscription](/azure/cost-management-billing/manage/billing-subscription-transfer#transfer-a-subscription-to-another-azure-ad-tenant-account)
- [Query to list affected resources when transferring an Azure subscription](/azure/governance/resource-graph/samples/samples-by-category?tabs=azure-cli#list-impacted-resources-when-transferring-an-azure-subscription)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [Azure Backup documentation](/azure/backup)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Secure identity with Zero Trust](/security/zero-trust/deploy/identity)

## Related resource

- [Continuous integration and continuous delivery baseline architecture with Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
