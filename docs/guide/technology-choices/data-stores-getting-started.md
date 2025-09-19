--- 
title: Getting Started with Choosing a Data Store
description: Learn how to choose the right Azure data store for your workloads by evaluating functional, performance, cost, and security requirements.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/02/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: fcp
keyword: Azure
---

# Getting started with choosing a data store

When you prepare your landing zone environment for your cloud adoption, you need to determine the data requirements for hosting your workloads. Azure database products and services support various data storage scenarios and capabilities. How you configure your landing zone environment to support your data requirements depends on your workload governance, technical, and business requirements.

## Identify data services requirements

As part of your landing zone evaluation and preparation, you need to identify the data stores that your landing zone needs to support. This process involves assessing each of the applications and services that make up your workloads to determine their data storage and access requirements. After you identify and document these requirements, you can create policies for your landing zone to control allowed resource types based on your workload needs.

For each application or service that you deploy to your landing zone environment, use the following information as a starting point to help you determine the appropriate data store services to use.

### ✅ Functional requirements

Consider the nature of your data and how you plan to use it:

- **Data format:** Structured (tables), semi-structured (JSON, XML, and key-value), or unstructured (images and documents)

- **Purpose:** Online transactional processing (OLTP) for transactional data, online analytical processing (OLAP) for complex, ad-hoc data analysis
- **Search needs:** Indexing capability, full-text search capability
- **Specialized:** Vector stores for highly dimensional data, graph databases for highly interconnected data
- **Data relationships:** Need for joins, graph traversal, or hierarchical structures
- **Consistency model:** Strong, eventual, or configurable consistency
- **Schema flexibility:** Schema-on-write (rigid) versus schema-on-read (flexible)
- **Concurrency needs:** Optimistic versus pessimistic locking, high-write scenarios
- **Data life cycle:** Short-lived versus long-term archival, hot versus cold data
- **Data movement:** Extract, tranform, and load (ETL) or extract, load, and tranform (ELT) requirements, integration with pipelines

### ⚙️ Nonfunctional requirements

Evaluate performance and scalability expectations:

- **Latency and throughput:** Real-time versus batch processing
- **Scalability:** Vertical versus horizontal scaling, global distribution
- **Reliability and availability:** Service-level agreemnt (SLA) requirements, failover strategies
- **Limits:** Storage size, throughput caps, partitioning constraints

### 💰 Cost and management considerations

Factor in operational overhead and budget:

- **Managed versus self-hosted:** Platform as a service (PaaS) versus infrastructure as a service (IaaS) trade-offs
- **Region availability:** Data residency and compliance needs
- **Cost optimization:** Use of tiered storage, partitioning, and caching
- **Licensing and portability:** Vendor lock-in, open-source compatibility

### 🔐 Security and governance

Ensure alignment with organizational policies:

- **Encryption:** At rest and in transit
- **Authentication and authorization:** Role-based access, identity integration
- **Auditing and monitoring:** Activity logs, alerts, and diagnostics
- **Networking:** Private endpoints, firewall rules, virtual network integration

### 👩‍💻 DevOps and team readiness

Assess your team's ability to support and evolve the solution:

- **Skill sets:** Familiarity with query languages, SDKs, and tooling
- **Client support:** Language bindings, driver availability
- **Tooling integration:** Continuous integration and continuous delivery (CI/CD) pipelines, observability tools

## Key questions

Answer the following questions about your workloads to make decisions based on the Azure database services decision tree:

- **What is the level of control of the OS and database engine required?** Some scenarios require you to have a high degree of control or ownership of the software configuration and host servers for your database workloads. In these scenarios, you can deploy custom IaaS virtual machines (VMs) to fully control the deployment and configuration of data services. You might not need this level of control, but maybe you're not ready to move to a full PaaS solution. In that case, a managed instance can provide higher compatibility with your on-premises database engine while providing the benefits of a managed platform.

- **Will your workloads use a relational database technology?** If so, what technology do you plan to use? Azure provides managed PaaS database capabilities for [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview), [MySQL](/azure/mysql/overview), and [PostgreSQL](/azure/postgresql/overview).
    
    Azure Cosmos DB supports [MongoDB](/azure/cosmos-db/mongodb/introduction) and [PostgreSQL](/azure/cosmos-db/postgresql/introduction) APIs, which provides benefits such as automatic high availability and instantaneous scalability.
- **Will your workloads use SQL Server?** In Azure, your workloads can run on IaaS-based [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/) or on the PaaS-based [SQL Database hosted service](/azure/azure-sql/database/sql-database-paas-overview). Your choice depends on whether you want to manage your database, apply patches, and take backups, or delegate these operations to Azure. Some scenarios require IaaS-hosted SQL Server because of capatability requirements. For more information, see [Choose the right SQL Server option in Azure](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview).
- **Will your workloads use key-value database storage?** [Azure Managed Redis](/azure/redis/overview)** is a managed in-memory data store based on the latest Redis Enterprise version. It provides low latency and high throughput. [Azure Cosmos DB](/azure/cosmos-db/introduction) also provides key-value storage capabilities.
- **Will your workloads use document or graph data?** [Azure Cosmos DB](/azure/cosmos-db/introduction) is a multimodel database service that supports various data types and APIs. Azure Cosmos DB also provides document and graph database capabilities.
    
    [MongoDB](/azure/cosmos-db/mongodb/introduction) and [Apache Gremlin](/azure/cosmos-db/gremlin/introduction) are document and graph APIs that Azure Cosmos DB supports.
- **Will your workloads use column-family data?** [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) provides a managed Apache Cassandra cluster that can extend your existing datacenters into Azure or serve as a cloud-only cluster and datacenter.
    
    Azure Cosmos DB also supports the [Apache Cassandra](/azure/cosmos-db/cassandra/introduction) API. To help determine the best fit for your workload, see the [product comparison](/azure/managed-instance-apache-cassandra/compare-cosmosdb-managed-instance?source=recommendations).
- **Will your workloads require high-capacity data analytics capabilities?** [Microsoft Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an enterprise-ready, end-to-end analytics platform. It unifies data movement, data processing, ingestion, transformation, real-time event routing, and report building.
- **Will your workloads require search engine capabilities?** You can use [Azure AI Search](/azure/search/search-what-is-azure-search) to build AI-enhanced cloud-based search indexes that can integrate into your applications.
- **Will your workloads use time series data?** [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) is a managed, high-performance, big data analytics platform that analyzes high volumes of data in near real time.

> [!NOTE]
> For more information about how to assess database options for each of your applications or services, see [Azure application architecture guide](./data-store-overview.md).

## Common database scenarios

The following table lists common use-scenario requirements and the recommended database services to handle them.

| Your goal | Recommended database service |
|---|---|
| Build apps that scale with a managed and intelligent SQL database in the cloud. | [SQL Database](/azure/azure-sql/database/sql-database-paas-overview) |
| Modernize SQL Server applications with a managed, up-to-date SQL instance in the cloud. | [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresqland&preserve-view=true) |
| Migrate your SQL workloads to Azure while maintaining complete SQL Server compatibility and operating system-level access. | [SQL Server on Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview?view=azuresqland&preserve-view=true) |
| Build scalable, managed enterprise-ready apps on open-source PostgreSQL, scale out single-node PostgreSQL with high performance, or migrate PostgreSQL and Oracle workloads to the cloud. | [Azure Database for PostgreSQL](/azure/postgresql/overview) |
| Deliver high availability and elastic scaling to open-source mobile and web apps with a managed community MySQL database service, or migrate MySQL workloads to the cloud. | [Azure Database for MySQL](/azure/mysql/overview) |
| Build applications with guaranteed low latency and high availability anywhere, at any scale, or migrate Cassandra, MongoDB, Gremlin, and other NoSQL workloads to the cloud. | [Azure Cosmos DB](/azure/cosmos-db/introduction) |
| Modernize existing Cassandra data clusters and apps, and gain flexibility with a managed instance service. | [Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/introduction) |
| Build a managed elastic data warehouse that has security at every level of scale at no extra cost. | [Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) |
| Deliver fast, scalable applications by using an open-source-compatible in-memory data store. | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |

## Database feature comparison

The following table lists features available in Azure database services.

|  Feature         | SQL Database | SQL Managed Instance | Azure Database for PostgreSQL | Azure Database for MySQL | Azure Managed Instance for Apache Cassandra | Azure Cosmos DB | Azure Cache for Redis | Azure Cosmos DB for MongoDB | Azure Cosmos DB for Gremlin |
|------------------|---------|--------|--------|--------|--------|--------|--------|--------|--------|
|Database type|Relational |Relational |Relational |Relational |NoSQL |NoSQL |In-memory |NoSQL |Graph
|Data model|Relational |Relational |Relational |Relational |Multimodel: Document, wide-column, key-value, graph |Wide-column |Key-value |Document |Graph |
|Distributed multiprimary writes|No |No |No |No |Yes |Yes |Yes (Enterprise and Flash tiers only) |Yes |Yes |
|Virtual network connectivity support|Virtual network service endpoint |Native virtual network implementation |Virtual network injection (flexible server only) |Virtual network injection (flexible server only) |Native virtual network implementation |Virtual network service endpoint |Virtual network injection (Premium, Enterprise, and Flash tiers only) |Virtual network service endpoint |Virtual network service endpoint |

> [!NOTE]
> [Azure Private Link service](/azure/private-link/private-link-service-overview) simplifies networking design by enabling Azure services to communicate over private networking. All Azure database services support Azure Private Link service. For managed instance database services, these instances are deployed in virtual networks, so you don't need to deploy [private endpoints](/azure/private-link/create-private-endpoint-portal) for them.

## Regional availability

Azure helps you deliver services at the scale needed to reach customers and partners anywhere. When you plan your cloud deployment, determine the Azure region to host your workload resources.

Most Azure regions support most database services. A few regions support only a subset of these products, but they mostly target governmental customers. Before you decide which regions to deploy your database resources to, see [Products available by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/) to check the latest status of regional availability.

For more information about Azure global infrastructure, see [Azure geographies](https://azure.microsoft.com/global-infrastructure/geographies/).

## Data residency and compliance requirements

Legal and contractual requirements related to data storage often apply to workloads. These requirements might vary based on the location of your organization, the jurisdiction of the physical assets that host your data stores, and your applicable business sector. Consider the following components of data obligations:

- Data classification
- Data location
- Responsibilities for data protection under the shared responsibility model

For information about these requirements, see [Achieve compliant data residency and security with Azure](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure/).

Part of your compliance efforts might include controlling where your database resources are physically located. Azure regions are organized into groups called *geographies*. An [Azure geography](https://azure.microsoft.com/global-infrastructure/geographies/) honors data residency, sovereignty, compliance, and resiliency requirements within geographical and political boundaries. If your workloads are subject to data sovereignty or other compliance requirements, you must deploy your storage resources to regions in a compliant Azure geography.

## Establish controls for database services

When you prepare your landing zone environment, you can establish controls that limit the data stores that users can deploy. Controls can help you manage costs and limit security risks. Developers and IT teams can still deploy and configure resources that support your workloads.

After you identify and document your landing zone's requirements, you can use [Azure Policy](/azure/governance/policy/overview) to control the database resources that you allow users to create. Controls can allow or deny the creation of [database resource types](/azure/azure-sql/database/policy-reference?view=azuresqland&preserve-view=true).

For example, you might restrict users to creating only SQL Database resources. Use policies to control the options that users can select when they create resources. For example, you can restrict SQL Database SKUs that users can provision by allowing only specific versions of SQL Server to be installed on an IaaS VM. For more information, see [Azure Policy built-in policy definitions](/azure/governance/policy/samples/built-in-policies).

You can apply policies to resources, resource groups, subscriptions, and management groups. Include your policies in [Azure Blueprints](/azure/governance/blueprints/overview) definitions, and apply them repeatedly throughout your cloud estate.

## Next steps

- [Understand data models](../../data-guide/technology-choices/understand-data-store-models.md)

Use the following articles to choose a specialized data store:

- [Choose a big data storage technology in Azure](/azure/architecture/data-guide/technology-choices/data-storage)
- [Choose a search data store in Azure](/azure/architecture/data-guide/technology-choices/search-options)
- [Choose an Azure service for vector search](/azure/architecture/guide/technology-choices/vector-search)
