--- 
title: Choose an Azure data service
titleSuffix: Azure Architecture Center
description: Use this guide to decide which data service best suits your application.
author: claytonsiemens77
ms.author: csiemens
ms.date: 03/28/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom: fcp
keyword: Azure
categories: databases
products:
 - azure-sql-database
 - azure-cosmos-db
 - azure-database-mysql
 - azure-database-postgresql
 - azure-cache-redis
 - azure-time-series-insights
---

# Review your data options

When you prepare your landing zone environment for your cloud adoption, you need to determine the data requirements for hosting your workloads. Azure database products and services support a wide variety of data storage scenarios and capabilities. How you configure your landing zone environment to support your data requirements depends on your workload governance, technical, and business requirements.

## Identify data services requirements

As part of your landing zone evaluation and preparation, you need to identify the data stores that your landing zone needs to support. The process involves assessing each of the applications and services that make up your workloads to determine their data storage and access requirements. After you identify and document these requirements, you can create policies for your landing zone to control allowed resource types based on your workload needs.

For each application or service you'll deploy to your landing zone environment, use the following guide as a starting point to help you determine the appropriate data store services to use:

### Key questions

Answer the following questions about your workloads to help you make decisions based on the Azure database services decision tree:

- **What is the level of control of the OS and database engine required?** Some scenarios require you to have a high degree of control or ownership of the software configuration and host servers for your database workloads. In these scenarios, you can deploy custom infrastructure as a service (IaaS) virtual machines to fully control the deployment and configuration of data services. If you don't require this level of control, but you're not ready to move to a full platform as a service (PaaS) solution, a managed instance can provide higher compatibility with your on-premises database engine while offering the benefits of a fully managed platform. 
- **Will your workloads use a relational database technology?** If so, what technology do you plan to use? Azure provides managed PaaS database capabilities for [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview), [MySQL](/azure/mysql/overview), [PostgreSQL](/azure/postgresql/overview), and [MariaDB](/azure/mariadb/overview). 
    - Cosmos DB supports [MongoDB](/azure/cosmos-db/mongodb/introduction) and [PostgreSQL](/azure/cosmos-db/postgresql/introduction) APIs to take advantage of the many benefits that Cosmos DB offers, including automatic high availability and instantaneous scalability.
- **Will your workloads use SQL Server?** In Azure, you can have your workloads running in IaaS-based [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/) or on the PaaS-based [Azure SQL Database hosted service](/azure/azure-sql/database/sql-database-paas-overview). Choosing which option to use is primarily a question of whether you want to manage your database, apply patches, and take backups, or if you want to delegate these operations to Azure. In some scenarios, compatibility issues might require the use of IaaS-hosted SQL Server. For more information about how to choose the correct option for your workloads, see [Choose the right SQL Server option in Azure](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview).
- **Will your workloads use key/value database storage?** [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) offers a high-performance cached key/value data storage solution that can power fast, scalable applications. [Azure Cosmos DB](/azure/cosmos-db/introduction) also provides general-purpose key/value storage capabilities.
- **Will your workloads use document or graph data?** [Azure Cosmos DB](/azure/cosmos-db/introduction) is a multi-model database service that supports a wide variety of data types and APIs. Azure Cosmos DB also provides document and graph database capabilities.
    - [MongoDB](/azure/cosmos-db/mongodb/introduction) and [Apache Gremlin](/azure/cosmos-db/gremlin/introduction) are document and graph APIs that are supported by Cosmos DB.
- **Will your workloads use column-family data?** [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) offers a fully managed Apache Cassandra cluster that can extend your existing datacenter(s) into Azure or act as a cloud-only cluster and datacenter.
    - [Apache Cassandra](/azure/cosmos-db/cassandra/introduction) API is also supported by Cosmos DB. See the [product comparison](/azure/managed-instance-apache-cassandra/compare-cosmosdb-managed-instance?source=recommendations) documentation to help guide your decision on the best fit for your workload.
- **Will your workloads require high-capacity data analytics capabilities?** You can use [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) to effectively store and query structured petabyte-scale data. For unstructured big data workloads, you can use [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake/) to store and analyze petabyte-size files and trillions of objects.
- **Will your workloads require search engine capabilities?** You can use [Azure Cognitive Search](/azure/search/search-what-is-azure-search) to build AI-enhanced cloud-based search indexes that can be integrated into your applications.
- **Will your workloads use time series data?** [Azure Time Series Insights](/azure/time-series-insights/time-series-insights-overview) is built to store, visualize, and query large amounts of time series data, such as data generated by IoT devices.

> [!NOTE]
> Learn more about how to assess database options for each of your application or services in the [Azure application architecture guide](./data-store-overview.md).

## Common database scenarios

The following table illustrates a few common use scenario requirements and the recommended database services for handling them:

| If you want to | Use this |
|---|---|
| Build apps that scale with managed and intelligent SQL database in the cloud | [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) |
| Modernize SQL Server applications with a managed, always-up-to-date SQL instance in the cloud | [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql&preserve-view=true) |
| Migrate your SQL workloads to Azure while maintaining complete SQL Server compatibility and operating system-level access | [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresql&preserve-view=true) |
| Build scalable, secure, and fully managed enterprise-ready apps on open-source PostgreSQL, scale out single-node PostgreSQL with high performance, or migrate PostgreSQL and Oracle workloads to the cloud | [Azure Database for PostgreSQL](/azure/postgresql/overview) |
| Deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MySQL database service, or migrate MySQL workloads to the cloud | [Azure Database for MySQL](/azure/mysql/overview) |
| Deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MariaDB database service | [Azure Database for MariaDB](/azure/mariadb/overview) |
| Build applications with guaranteed low latency and high availability anywhere, at any scale, or migrate Cassandra, MongoDB, Gremlin, and other NoSQL workloads to the cloud | [Azure Cosmos DB](/azure/cosmos-db/introduction) |
| Modernize existing Cassandra data clusters and apps, and enjoy flexibility and freedom with managed instance service | [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) |
| Build a fully managed elastic data warehouse that has security at every level of scale at no extra cost | [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) |
| Power fast, scalable applications with an open-source-compatible in-memory data store | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |

## Database feature comparison

The following table illustrates features available in Azure database services

|                  |Azure SQL DB |Azure SQL Managed Instance |Azure Database for PostgreSQL |Azure Database for MySQL |Azure Database for MariaDB |Azure Managed Instance for Apache Cassandra |Azure Cosmos DB |Azure Cache for Redis |Azure Cosmos DB for MongoDB |Azure Cosmos DB for Gremlin
|------------------|---------|--------|--------|--------|--------|--------|--------|--------|--------|--------|
|**Database Type**|Relational |Relational |Relational |Relational | Relational |NoSQL |NoSQL |In-Memory |NoSQL |Graph
|**Data Model**|Relational  |Relational |Relational |Relational | Relational |Multi-Model: Document, Wide-column, Key-Value, Graph |Wide-column |Key-Value |Document |Graph
|**Distributed Multi-Master Writes**|No |No |No |No |No |Yes |Yes |Yes (Enterprise and Flash tiers only) |Yes |Yes
|**VNet connectivity support**|VNet service endpoint |Native VNet implementation |VNet injection (flexible server only) |VNet injection (flexible server only) |VNet service endpoint |Native VNet implementation |VNet service endpoint |VNet injection (Premium, Enterprise, Flash tiers only) |VNet service endpoint |VNet service endpoint

> [!NOTE]
> [Private link service](/azure/private-link/private-link-service-overview) simplifies networking design to allow Azure services to communicate over private networking and is supported for all Azure database services.  In the case of Managed Instance database services, these instances are deployed in VNets, which negates the need to deploy [private endpoints](/azure/private-link/create-private-endpoint-portal?tabs=dynamic-ip) for them.

## Regional availability

Azure lets you deliver services at the scale you need to reach your customers and partners, **wherever they are**. A key factor in planning your cloud deployment is to determine what Azure region will host your workload resources.

Most database services are generally available in most Azure regions. But there are a few regions, mostly targeting governmental customers, that support only a subset of these products. Before you decide which regions you will deploy your database resources to, we recommend that you refer to the [regions page](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=data-factory,sql-server-stretch-database,redis-cache,database-migration,sql-data-warehouse,postgresql,mariadb,cosmos-db,mysql,sql-database) to check the latest status of regional availability.

To learn more about Azure global infrastructure, see the [Azure regions page](https://azure.microsoft.com/global-infrastructure/geographies/). You can also view [products available by region](https://azure.microsoft.com/global-infrastructure/services/?regions=all&products=all) for specific details about the overall services that are available in each Azure region.

## Data residency and compliance requirements

Legal and contractual requirements that are related to data storage often will apply to your workloads. These requirements might vary based on the location of your organization, the jurisdiction of the physical assets that host your data stores, and your applicable business sector. Components of data obligations to consider include data classification, data location, and the respective responsibilities for data protection under the shared responsibility model. For help with understanding these requirements, see the white paper [achieving compliant data residency and security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure/).

Part of your compliance efforts might include controlling where your database resources are physically located. Azure regions are organized into groups called geographies. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies/) ensures that data residency, sovereignty, compliance, and resiliency requirements are honored within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, you must deploy your storage resources to regions in a compliant Azure geography.

## Establish controls for database services

When you prepare your landing zone environment, you can establish controls that limit what data stores users can deploy. Controls can help you manage costs and limit security risks while still allowing developers and IT teams to deploy and configure resources that are needed to support your workloads.

After you identify and document your landing zone's requirements, you can use [Azure Policy](/azure/governance/policy/overview) to control the database resources that you allow users to create. Controls can take the form of allowing or denying the creation of [database resource types](/azure/azure-sql/database/policy-reference?view=azuresql&preserve-view=true). For example, you might restrict users to creating only Azure SQL Database resources. You can also use policy to control the allowable options when a resource is created, like restricting what SQL Database SKUs can be provisioned allowing only specific versions of SQL Server to be installed on an IaaS VM. For more information, see [Azure Policy built-in policy definitions](/azure/governance/policy/samples/built-in-policies).

Policies can be scoped to resources, resource groups, subscriptions, and management groups. You can include your policies in [Azure blueprint](/azure/governance/blueprints/overview) definitions and apply them repeatedly throughout your cloud estate.

## Next steps

- Review [database security best practices](/azure/azure-sql/database/security-best-practice)
- Review a comparison of [Azure SQL deployment options](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview)
