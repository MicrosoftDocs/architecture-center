[! INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Modern cloud workloads use cloud native security standards and policy driven governance to establish standardization across all environments and maximize the TCO by reducing non-standard operations management.  To meet business transformation like acquisition or divesture the organizational      team including developers, architects, operations, and Technical Business Decision (TDM)s must strategize the separation or joining       of their cloud workloads from existing to a new security (AAD (Azure Active Directory)) tenant     . This ensures all data and application services relying on IaaS or PaaS cloud components are migrated, secured, and isolated to their respective business boundaries.  The built-in subscription move capability allows you to move the entire subscription under new AAD tenant, however in practice most divesture organization workloads are mixed with the retaining organization workloads before the split and the complete isolation requires surgical workload migrations.

## Architecture

![Diagram of the cross-tenant migration architecture.](./images/Cross-TenantMigrationStrategy.png)

*Download a [Visio file](https://arch-center.azureedge.net/Cross-TenantMigrationStrategy.vsdx) of this architecture.* 

### Dataflow

1.
   a Extract the ARM (Azure Resource Manager) template and Configuration artifacts and store it in Source Code/Configuration repository. This step ensures the migrated resources have the same resource deployment definition - Infrastructure as a Code (IaaC). In addition, it facilitates the automation for deployment using devops process

   b Deploy the artifacts (infrastructure, configuration) to the target resource group (s) in the new tenant subscription

2. Create side car subscription in the existing tenant to host cloned data service resources and backups of virtual machines. This step requires “Global Administrator” permissions. Most organizations have an admin team who can take care of creating this subscription and hand it over to developers/architects.

3. Use various tools and methods like Azure Data Factory or Az Copy for data migration or native backup and restore to clone the resources

4. Move the subscription to the new tenant

5. Either move the resources to the target resource group or migrate data to pre-created resources in the target resource group. Implementation plan should detail the provisioning method Or Restore and IaaS VMs (Virtual Machines) from the backups

6. Delete the side car subscription

### Components

* [Azure Active Directory] (https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) is a cloud-based identity and access management service. AAD tenant represents your organization and helps you to manage a specific instance of Microsoft cloud services for your internal and external user
* [Azure Subscription] (https://learn.microsoft.com/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) is a logical container for your resources. Each Azure resource is associated with only one subscription. Creating a subscription is the first step in adopting Azure.
* [Azure DevOps] (https://azure.microsoft.com/services/devops/) provides developer services to support teams to plan work, collaborate on code development, and build and deploy applications.
* [Azure Backup] (https://learn.microsoft.com/azure/backup/) service provides simple, secure, and cost-effective solutions to back up your data and recover it from the Microsoft Azure cloud.
* [Azure App Service] (https://learn.microsoft.com/azure/app-service/overview) is an HTTP-based service for hosting web applications, REST (representational state transfer) APIs (Application Programming Interfaces), and mobile back ends. You can take advantage of its DevOps capabilities, such as continuous deployment, as shown here.
* [Azure SQL Database] (https://learn.microsoft.com/azure/azure-sql/database/sql-database-paas-overview) is a fully managed and intelligent relational database service built for the cloud. With SQL Database, you can create a universally available and high-performance data storage layer for modern cloud applications.
* The [Azure Storage] (https://learn.microsoft.com/azure/storage/common/storage-introduction) platform is Microsoft's cloud storage solution for modern data storage scenarios. Azure Storage offers highly available, massively scalable, durable, and secure storage for various data objects in the cloud.
* [Azure Synapse Analytics] (https://learn.microsoft.com/azure/synapse-analytics/overview-what-is) is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems.
* [Azure Machine Learning] (https://learn.microsoft.com/azure/machine-learning/overview-what-is-azure-machine-learning) is a cloud service for accelerating and managing the machine learning project lifecycle. Machine learning professionals, data scientists, and engineers can use it in their day-to-day workflows: Train and deploy models and manage MLOps.
* [Azure Data Bricks] (https://learn.microsoft.com/azure/databricks/introduction/) Platform provides a unified set of tools for building, deploying, sharing, and maintaining enterprise-grade data solutions at scale.
* [Azure Cognitive Services] (https://learn.microsoft.com/azure/cognitive-services/what-are-cognitive-services) are cloud-based artificial intelligence (AI) services that help developers build cognitive intelligence into applications without having direct AI or data science skills or knowledge.
* [Azure Cosmos DB (databases)] (https://learn.microsoft.com/azure/cosmos-db/introduction) is a fully managed NoSQL and relational database for modern app development. 
* [Azure Event Hub] (https://learn.microsoft.com/azure/event-hubs/event-hubs-about) is a big data streaming platform and event ingestion service
* [Azure Key vault] (https://learn.microsoft.com/azure/key-vault/general/basic-concepts) is a cloud service for securely storing and accessing secrets. 
* [Azure Virtual Machines] (https://learn.microsoft.com/azure/virtual-machines/overview) are one of several types of on-demand, scalable computing resources that Azure offers. Typically, you choose a virtual machine when you need more control over the computing environment than the other choices offer.
* [Resource Groups] (https://learn.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-cli) is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.

## Scenario details

In this scenario, a global healthcare company's multiple global business units were looking to define and execute upon a solid cross-tenant workload migration strategy. The lack of which was the biggest roadblock in the company's priority to divestiture a business to their advantage. 

The proposed strategy starts with categorizing workload resources as PaaS (Compute), PaaS + IaaS (data services) and IaaS (compute).  Following these 3 separate prescriptive approaches, allows for quick migration, security transitions resulting on overall reduced TCO

1. PaaS (Compute) resources that execute based on logic and configuration
   ![Diagram of the cross-tenant migration architecture.](./images/Cross-TenantMigrationStrategy-PaaS-Compute.png)

   Solution: Re-create these resources in the target tenant. Use DevOps processes

2. PaaS + IaaS (Data Services) resources that stores data

![Diagram of the cross-tenant migration architecture.](./images/Cross-TenantMigrationStrategy-PaaS-IaaS-DS.png)

Solution: Azure subscriptions can be re-homed from one Azure AD tenant to another. Move these resources using side-car subscription move to new tenant.  This strategy involves careful evaluation of resources before the move e.g., Azure SQL databases with Azure AD authentication integration enabled cannot be moved as they are. Use backup and restore instead. This process removes all Role-Based Access Control (RBAC) assignments. After the resource is moved to the new tenant those RBAC assignments need to be restored.

3. IaaS (Compute) resources that provides hosting for customized logic e.g., Virtual Machines

   ![Diagram of the cross-tenant migration architecture.](./images/Cross-TenantMigrationStrategy-IaaS-Compute.png)

   Solution: For this type of resource, take backups and restore it in the target environment

### Potential use cases

1. Organizational Divesture and Acquisition
2. Internal Organization spin-off
3. Customers looking to invest natively in Azure away from a Service Provider model

## Next steps

* [Azure RBAC documentation] (https://learn.microsoft.com/azure/role-based-access-control/)
* [Migrate Azure Subscription] (https://learn.microsoft.com/azure/cost-management-billing/manage/billing-subscription-transfer#transfer-a-subscription-to-another-azure-ad-tenant-account)
* [List impacted resources when transferring an Azure subscription] (https://learn.microsoft.com/azure/governance/resource-graph/samples/samples-by-category?tabs=azure-cli#list-impacted-resources-when-transferring-an-azure-subscription)
