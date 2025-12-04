[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

During business transformations like acquisitions or divestitures, organizations might migrate cloud workloads from an existing Microsoft Entra tenant to a new tenant. Teams must plan how to separate or join their cloud workloads. This article describes how to define and implement a cross-tenant workload migration strategy that maintains security boundaries and ensures business continuity.

## Architecture

:::image type="complex" border="false" source="../media/cross-tenant-migration-strategy.svg" alt-text="Diagram that shows a cross-tenant migration architecture." lightbox="../media/cross-tenant-migration-strategy.svg":::
This diagram outlines a resource migration process. First the Azure Resource Manager template (ARM template) and configuration files are extracted and stored in a source code repository or configuration repository. Then those files are deployed to target resource groups in a new tenant. A temporary subscription, known as a sidecar subscription, is created in the original tenant to hold backups and cloned data service resources. Resources are then cloned by using tools like Azure Data Factory or AzCopy. After the resources are cloned, the subscription is moved to the new tenant. Finally, the resources are migrated or restored in their target groups before the temporary subscription is deleted.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/cross-tenant-migration-strategy.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Prepare the infrastructure and configuration artifacts:

   1. Extract the Azure Resource Manager template (ARM template) and configuration artifacts and store them in a source code repository or configuration repository. This step conforms with infrastructure as code (IaC) practices and helps ensure that the migrated resources have the same resource deployment definition. It also facilitates deployment automation.

   1. Deploy both the infrastructure and configuration artifacts to the target resource group or groups in the new tenant subscription.

1. Create a sidecar subscription in the existing tenant to host cloned data service resources and backups of virtual machines (VMs). Most organizations have a cloud platform team or subscription vending process that can create this subscription.

1. Clone the resources by using a tool like Azure Data Factory, AzCopy for data migration, or native backup and restore capabilities.

1. Move the subscription to the new tenant.

1. Either move the resources to the target resource group or migrate data to the precreated resources in the target resource group. Alternatively, restore VMs from the backups. Your implementation plan should describe the provisioning method.

1. Delete the sidecar subscription.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service. Your Microsoft Entra tenant represents your organization and helps you manage an instance of cloud services for your internal and external guests. In this architecture, Microsoft Entra ID manages organizational identity and access across tenants, which enables secure migration and resource isolation.

- An [Azure subscription](/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) is a logical container for resources. Each Azure resource is associated with only one subscription. In this architecture, subscriptions organize and isolate resources, and you move them between tenants during migration.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a cloud platform that provides developer tools to help teams plan, collaborate on code, and build and deploy applications. In this architecture, it supports IaC and automates resource deployment in the target tenant.

- [Azure Backup](/azure/backup/backup-overview) is a service that backs up and restores data in Azure. In this architecture, it ensures data protection and enables recovery during the migration process.

- The [Web Apps feature of Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) hosts web applications, REST APIs, and mobile back ends. It provides [continuous deployment](/azure/app-service/deploy-continuous-deployment) and other DevOps capabilities. In this architecture, it supports platform as a service (PaaS) compute workloads that you re-create in the target tenant by using DevOps processes.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed and intelligent relational database service. You can use SQL Database to create a high-performance data storage layer for modern cloud applications. In this architecture, it serves as a data service that's backed up and restored during tenant migration because of limitations in direct movement.

- [Azure Storage](/azure/storage/common/storage-introduction) is a scalable and durable cloud storage solution for various data objects in the cloud. In this architecture, it stores configuration artifacts and data backups used during migration.

- [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is a software as a service (SaaS) analytics platform that unifies data integration, data engineering, data warehousing, real-time analytics, data science, and business intelligence. In this architecture, it provides an enterprise-scale analytics platform across migrated workloads by consolidating data pipelines, storage (OneLake), and analytical compute in the target tenant.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a service that helps manage the machine learning project life cycle. In this architecture, it's part of the PaaS compute resources that you re-create in the target tenant.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is a unified analytics platform that builds, deploys, shares, and maintains data solutions. In this architecture, it supports scalable data engineering, and you re-create it in the target tenant.

- [Azure AI services](/azure/ai-services/what-are-ai-services) are cloud-based AI services that can help developers build cognitive intelligence into applications, even without AI or data science skills or knowledge. In this architecture, AI services enhance migrated applications with cognitive intelligence.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed NoSQL and relational database service. In this architecture, it serves as a data service that's backed up and restored during migration.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service. In this architecture, it supports real-time data processing across tenants.

- [Azure Key Vault](/azure/key-vault/general/overview) is a PaaS service that securely stores and provides access to secrets. In this architecture, it's a resource that you re-create in the target tenant to maintain secure access.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. It provides control over operating systems, storage, and applications without the need to own physical infrastructure. In this architecture, VMs are backed up and restored in the target tenant to preserve custom logic and configurations.

- [Resource groups](/azure/azure-resource-manager/management/manage-resource-groups-cli) are logical containers for Azure resources. In this architecture, they organize resources before and after migration to maintain structure and manageability.

## Scenario details

To address business transformations like acquisitions or divesture, the transitioning workload team must plan how to separate or join their cloud workloads from an existing Microsoft Entra tenant to a new Microsoft Entra tenant. The workload team includes developers, architects, operations, and technical decision-makers. This plan helps ensure that the team reliably migrates, secures, and isolates all data and application services to their respective business boundaries.

If your workload exists in a single subscription, you can often use the built-in subscription-move feature to transfer the entire subscription to a new Microsoft Entra tenant. But most divestiture organization workloads intertwine with retaining organization workloads before the split, so you must use a different approach to prepare for migration.

In this scenario, a healthcare company that has multiple global business units wants to divest a business. To divest, they need to define and implement a cross-directory workload migration strategy.

To begin, the company classifies workload resources into three categories. One group includes compute resources managed by using PaaS. A second group includes data services that require both PaaS and IaaS support. The final group includes compute resources managed by using IaaS. For each resource type, they use the following approaches:

- For PaaS, or compute, resources that run based on logic and configuration, they re-create these resources in the target tenant by using DevOps processes.

  PaaS compute resources include Key Vault, Machine Learning, Azure Data Factory, and Azure Databricks.

- For PaaS and IaaS, or data service, resources that store data, they relocate Azure subscriptions from one Microsoft Entra tenant to another. The company moves these resources to the new tenant via a sidecar subscription. They must carefully evaluate the resources before they move them. For example, they can't move an Azure SQL database with Microsoft Entra authentication integration enabled in its existing state. The company uses backup and restore instead. This process removes all Azure role-based access control (Azure RBAC) assignments. After they move the resource to the new tenant, they need to restore those Azure RBAC assignments.

  PaaS and IaaS data include services like SQL Database, Azure Data Lake Storage, and Azure Cosmos DB.

- For IaaS, or compute, resources that provide hosting for customized logic, the company creates backups and restores the resources in the target environment.

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
- [List affected resources when you transfer an Azure subscription](/azure/governance/resource-graph/samples/samples-by-category#list-impacted-resources-when-transferring-an-azure-subscription)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [Azure Backup documentation](/azure/backup)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Secure identity with Zero Trust](/security/zero-trust/deploy/identity)

## Related resource

- [Continuous integration and continuous delivery (CI/CD) baseline architecture that uses Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
