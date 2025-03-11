[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

To address business transformations like acquisitions or divesture, teams need to plan for the separation or joining of their cloud workloads from an existing security Microsoft Entra ID tenant to a new tenant. This article describes how to define and implement a cross-tenant workload migration strategy.

## Architecture

:::image type="complex" border="false" source="../media/cross-tenant-migration-strategy.svg" alt-text="Diagram that shows a cross-tenant migration architecture." lightbox="../media/cross-tenant-migration-strategy.svg":::
   This diagram outlines a resource migration process. First the Azure Resource Manager template and configuration files are extracted and stored in a source code repository or configuration repository. Then those files are deployed to target resource groups in a new tenant. A temporary subscription, known as a sidecar subscription, is created in the original tenant to hold backups and cloned data service resources. Resources are then cloned by using tools like Azure Data Factory or AzCopy. After the resources are cloned, the subscription is moved to the new tenant. Finally, the resources are migrated or restored in their target groups before the temporary subscription is deleted.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/cross-tenant-migration-strategy.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1.
    a. Extract the Azure Resource Manager template and configuration artifacts and store them in a source code repository or configuration repository. This step conforms with infrastructure as code practices and helps ensure that the migrated resources have the same resource deployment definition. It also facilitates deployment automation.

    b. Deploy both the infrastructure and configuration artifacts to the target resource group or groups in the new tenant subscription.

2. Create a sidecar subscription in the existing tenant to host cloned data service resources and backups of virtual machines (VMs). Most organizations have a cloud platform team or subscription vending process that can create this subscription.

3. Clone the resources by using a tool like Azure Data Factory, AzCopy for data migration, or native backup and restore.

4. Move the subscription to the new tenant.

5. Either move the resources to the target resource group or migrate data to the pre-created resources in the target resource group. Alternatively, restore VMs from the backups. Your implementation plan should describe the provisioning method.

6. Delete the sidecar subscription.

### Components

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) is a cloud-based identity and access management service. Your Microsoft Entra tenant represents your organization and helps you manage an instance of cloud services for your internal and external guests.

- [An Azure subscription](/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) is a logical container for your resources. Each Azure resource is associated with only one subscription. Creating a subscription is the first step in Azure adoption.

- [Azure DevOps](https://azure.microsoft.com/products/devops) provides developer services that can help your teams plan work, collaborate on code development, and build and deploy applications.

- [Azure Backup](https://azure.microsoft.com/products/backup) provides cost-effective solutions for backing up your data and recovering it from Azure.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. It provides [continuous deployment](/azure/app-service/deploy-continuous-deployment) and other DevOps capabilities.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed and intelligent relational database service that's built for the cloud. You can use SQL Database to create a high-performance data storage layer for modern cloud applications.

- The [Azure Storage](https://azure.microsoft.com/products/category/storage) platform is the Microsoft cloud solution for modern data storage scenarios. Azure Storage provides highly available, massively scalable, durable storage for various data objects in the cloud.

- [Azure Synapse Analytics](https://azure.microsoft.com/products/synapse-analytics) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems.

- [Azure Machine Learning](/azure/well-architected/service-guides/azure-machine-learning) is a cloud service for accelerating and managing the machine learning project lifecycle. Machine learning professionals, data scientists, and engineers can use it in their day-to-day workflows.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) provides a unified set of tools that you can use to build, deploy, share, and maintain enterprise-grade data solutions at scale.

- [Azure AI services](https://azure.microsoft.com/products/ai-services/) is a set of cloud-based AI services that can help developers build cognitive intelligence into applications, even if they don't have AI or data science skills or knowledge.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL and relational database for modern app development.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service.

- [Azure Key Vault](https://azure.microsoft.com/products/key-vault) is a cloud service that you can use to provide access to secrets and store them with enhanced security.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is one of several types of on-demand, scalable computing resources that Azure provides. You typically use a VM when you need more control over the computing environment than other choices provide.

- [Resource groups](/azure/azure-resource-manager/management/manage-resource-groups-cli) are logical containers for Azure resources. Resource groups are used to organize all resources that are related to this architecture.

## Scenario details

Modern cloud workloads use cloud-native security standards and policy-driven governance to establish standardization across environments and maximize total cost of ownership (TCO) by reducing nonstandard operations management. To address business transformations like acquisitions or divesture, the organizational team, including developers, architects, operations, and technical decision makers, needs to plan for the separation or joining of their cloud workloads from an existing tenant to a new security Microsoft Entra ID tenant. This planning can help ensure that all data and application services that rely on infrastructure as a service (IaaS) or platform as a service (PaaS) cloud components are migrated, secured, and isolated to their respective business boundaries.

You can use the built-in subscription-move feature to transfer the entire subscription to a new Microsoft Entra tenant. Because most divestiture organization workloads are intertwined with retaining organization workloads before the split, achieving complete isolation requires more detailed workload migrations.

In this scenario, a healthcare company that has multiple global business units wants to divest a business. To divest, they need to define and implement a cross-tenant workload migration strategy.

To begin, the company should classify workload resources into three categories. One group includes compute resources managed by using PaaS. A second group includes data services that require both PaaS and IaaS support. The final group includes compute resources managed by using IaaS. There are three approaches, one for each of these resource types. These approaches provide a quick, enhanced-security migration that can result in reduced TCO.

- PaaS, or compute, resources that run based on logic and configuration

   ![Diagram that shows the components of the PaaS solution.](../media/paas-compute.png)

  **Solution:** Re-create these resources in the target tenant. Use DevOps processes.

- PaaS and IaaS, or data services, resources that store data

   ![Diagram that shows the components of the PaaS and IaaS solution.](../media/paas-iaas.png)

   **Solution:** Azure subscriptions can be relocated from one Microsoft Entra tenant to another. Move these resources to the new tenant via a sidecar subscription. You need to carefully evaluate the resources before you move them. For example, Azure SQL databases with Microsoft Entra authentication integration enabled can't be moved as they are. Use backup and restore instead. This process removes all role-based access control (RBAC) assignments. After the resource is moved to the new tenant, you need to restore those RBAC assignments.

- IaaS, or compute, resources such as VMs that provide hosting for customized logic

   ![Diagram that shows the components of the IaaS solution.](../media/iaas-compute.png)

   **Solution:** For this type of resource, take backups and restore the resources in the target environment.

### Potential use cases

- Organizational divesture and acquisition
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
- [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Azure Backup documentation](/azure/backup)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Microsoft security best practices for identity and access management](/security/compass/identity)

## Related resource

- [Continuous integration and continuous delivery baseline architecture with Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
