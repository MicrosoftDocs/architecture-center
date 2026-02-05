---
title: Database architecture design
description: Get an overview of Azure database technologies, guidance offerings, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: anaharris
ms.date: 02/04/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Database architecture design

Data is at the heart of every application, and choosing the right database solution is one of the most important architectural decisions you'll make. Azure provides a comprehensive portfolio of database services spanning relational databases, NoSQL databases, in-memory caches, and managed database instances. Whether you're building transactional applications, analytical workloads, or globally distributed systems, Azure database services offer the performance, scalability, and reliability your organization needs.

Selecting the right database depends on your data model, consistency requirements, query patterns, and operational preferences. Key considerations include data structure (relational vs. non-relational), transaction requirements, scalability needs, and the level of management overhead you want to handle. Azure's database portfolio spans fully managed platform as a service (PaaS) offerings, infrastructure as a service (IaaS) options, and specialized services for specific workload patterns.


## Architecture

![Diagram that contrasts relational database management system (RDBMS) and big data solutions.](_images/data-service-classifications.png)

*Apache®, Apache Cassandra®, and the Hadoop logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

Azure database solutions include traditional relational database management systems (RDBMS and OLTP), big data and analytics workloads (including OLAP), and NoSQL workloads. Refer to the [architectures](#explore-database-architectures-and-guides) provided in this section to find real-world solutions that you can build in Azure.


## Explore database architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use database technologies in Azure. You can also review solution ideas, which give you a taste of what is possible as you plan your database implementation.

###  Guides

- [Choose a data store](../../guide/technology-choices/data-stores-getting-started.md) - Decision tree and guidance for selecting the right data store.
- [Understand data store models](../data-guide/technology-choices/understand-data-store-models.md) - Learn about the different data store models and their use cases.
- [Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md) - Guidance on selecting the right analytical data store.
- [OLTP solutions](../data-guide/relational-data/online-transaction-processing.md) - Design patterns for online transaction processing.
- [OLAP solutions](../data-guide/relational-data/online-analytical-processing.md) - Design patterns for online analytical processing.
- [ETL guide](../data-guide/relational-data/etl.yml) - Best practices for extract, transform, and load processes.
- [Data lakes](../data-guide/scenarios/data-lake.md) - Design and implement data lake architectures.
- [Big data architectures](guide/big-data-architectures.md) - Patterns for handling large-scale data processing.

### Relational databases

Azure provides managed relational database services for SQL Server, PostgreSQL, MySQL, and MariaDB workloads:

#### Architectures

- [DataOps for modern data warehouse](architecture/dataops-mdw.yml) - Implement DataOps practices for data warehousing.
- [Greenfield lakehouse on Microsoft Fabric](../example-scenario/data/greenfield-lakehouse-fabric.yml) - Build a modern lakehouse architecture from scratch.
- [Data warehousing and analytics](../example-scenario/data/data-warehouse.yml) - Integrate data from multiple sources into a unified analytics platform.

#### Solution ideas

- [Migrate an Oracle database to Azure](idea/topic-migrate-oracle-azure.yml) - Options for migrating Oracle workloads to Azure.
- [Migrate an Oracle database to an Azure virtual machine](idea/migrate-oracle-azure-iaas.yml) - Run Oracle databases on Azure IaaS.
- [Migrate an Oracle database to OD@A Exadata Database Service](idea/migrate-oracle-odaa-exadata.yml) - Use Oracle Database@Azure for Exadata workloads.
- [Cross-region resiliency for SQL TDE with Azure Key Vault Managed HSM](../solution-ideas/articles/secure-sql-managed-instance-managed-hardware-security-module.yml) - Implement cross-region encryption key management.

### NoSQL databases

Azure Cosmos DB and other NoSQL solutions provide flexible schemas and horizontal scalability for modern applications:

#### Architectures

- [Deploy MongoDB Atlas on Azure](architecture/mongodb-atlas-baseline.md) - Production-ready MongoDB deployment on Azure.
- [Analyze MongoDB Atlas data](architecture/azure-synapse-analytics-integrate-mongodb-atlas.yml) - Integrate MongoDB data with Azure Synapse Analytics.

#### Guides

- [Use the Transactional Outbox pattern](guide/transactional-outbox-cosmos.yml) - Implement reliable messaging with Azure Cosmos DB.
- [Run Apache Cassandra](guide/cassandra.md) - Deploy and manage Cassandra clusters on Azure.
- [Nonrelational data and NoSQL](../data-guide/big-data/non-relational-data.yml) - Understand NoSQL data patterns and use cases.

#### Solution ideas

- [Minimal storage – change feed replication](idea/minimal-storage-change-feed-replicate-data.yml) - Replicate data using Azure Cosmos DB change feed.

### Azure Data Factory architectures

Azure Data Factory provides cloud-scale data integration and orchestration:

- [Medallion lakehouse with Azure Data Factory](architecture/azure-data-factory-on-azure-landing-zones-index.yml) - Implement a medallion architecture for data lakes.
- [Azure Data Factory baseline architecture](architecture/azure-data-factory-on-azure-landing-zones-baseline.yml) - Production-ready baseline for Data Factory deployments.
- [Azure Data Factory enterprise hardened architecture](architecture/azure-data-factory-enterprise-hardened.yml) - Enhanced security and compliance configurations.
- [Azure Data Factory mission critical architecture](architecture/azure-data-factory-mission-critical.yml) - High availability patterns for critical workloads.

### Data governance

- [Data obfuscation with Delphix](guide/data-obfuscation-with-delphix-in-azure-data-factory.yml) - Mask sensitive data in development environments.
- [Data scrambling for SAP with Delphix](guide/data-scrambling-for-sap-using-delphix-and-azure-data-factory.yml) - Protect SAP data during testing.
- [Collection structure for a federated Purview catalog](../guide/data/collection-structure-federated-catalog.md) - Organize data governance across the enterprise.


## Learn about databases on Azure

If you're new to databases on Azure, the best place to learn more is with [Microsoft Learn](/training/?WT.mc_id=learnaka), a free, online training platform. You'll find videos, tutorials, and hands-on learning for specific products and services, plus learning paths based on your job role, such as developer or data analyst.

Here are some resources to get you started:

- [Explore Azure database and analytics services](/training/modules/azure-database-fundamentals/)
- [Choose a data storage approach in Azure](/training/modules/choose-storage-approach-in-azure/)
- [Deploy Azure SQL Database](/training/modules/deploy-azure-sql-database/)
- [Secure your Azure SQL Database](/training/modules/secure-your-azure-sql-database/)
- [Design your migration to Azure](/training/modules/design-your-migration-to-azure/)
- [Browse Azure database modules](/training/browse/?products=azure&terms=database)

### Learning paths by role

- **Data engineer**: [Azure Data Fundamentals: Explore relational data in Azure](/training/paths/azure-data-fundamentals-explore-relational-data/)
- **Database administrator**: [Azure SQL fundamentals](/training/paths/azure-sql-fundamentals/)
- **Developer**: [Work with Azure Cosmos DB](/training/paths/work-with-nosql-data-in-azure-cosmos-db/)
- **Solutions architect**: [Design a data platform solution](/training/paths/design-data-platform-solutions/)


## Organizational readiness

If your organization is new to the cloud, the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) can help you get started. This collection of documentation and best practices offers proven guidance from Microsoft designed to accelerate your cloud adoption journey. For more information on cloud-scale analytics and data management, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

To help assure the quality of your database solution on Azure, we recommend following the [Azure Well-Architected Framework (WAF)](/azure/well-architected/). WAF provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

For database-specific guidance, see the Azure Well-Architected Framework service guides for:

- [Azure Cosmos DB](/azure/well-architected/service-guides/azure-cosmos-db)
- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database)


## Path to production

Knowing how to [choose a data store](../../guide/technology-choices/data-stores-getting-started.md) is one of the first decisions you need to make in your database journey on Azure. Understanding the different [data store models](../data-guide/technology-choices/understand-data-store-models.md) helps you select the right technology for your workload.

Key decision points include:

- **Data model**: Choose between relational, document, key-value, graph, or columnar data models based on your data structure and query patterns.

- **Consistency requirements**: Determine whether you need strong consistency (ACID transactions) or can work with eventual consistency for better scalability.

- **Scalability**: Evaluate whether vertical scaling (larger instances) or horizontal scaling (distributed data) better fits your growth needs.

- **Managed vs. self-managed**: Decide between fully managed PaaS services, managed instances, or IaaS deployments based on operational requirements.

To view different architecture styles for database solutions, see [architectures](#explore-database-architectures-and-guides).


## Best practices

Review these best practices when designing your database solutions:

| Best practice | Description |
|---------------|-------------|
| [Transactional Outbox pattern with Azure Cosmos DB](guide/transactional-outbox-cosmos.yml) | Learn how to use the Transactional Outbox pattern for reliable messaging and guaranteed delivery of events. |
| [Distribute your data globally with Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally) | To achieve low latency and high availability, some applications need to be deployed in datacenters that are close to their users. |
| [Security in Azure Cosmos DB](/azure/cosmos-db/database-security) | Security best practices help prevent, detect, and respond to database breaches. |
| [Continuous backup with point-in-time restore in Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction) | Learn about Azure Cosmos DB point-in-time restore feature. |
| [Achieve high availability with Azure Cosmos DB](/azure/cosmos-db/high-availability) | Azure Cosmos DB provides multiple features and configuration options to achieve high availability. |
| [High availability for Azure SQL Database and SQL Managed Instance](/azure/azure-sql/database/high-availability-sla) | The database shouldn't be a single point of failure in your architecture. |

### Technology choices

There are many options for database technologies in Azure. These articles help you choose the best technologies for your needs:

- [Choose a data store](../../guide/technology-choices/data-stores-getting-started.md)
- [Choose an analytical data store in Azure](../data-guide/technology-choices/analytical-data-stores.md)
- [Choose a data analytics technology in Azure](../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Choose a batch processing technology in Azure](../data-guide/technology-choices/batch-processing.md)
- [Choose a big data storage technology in Azure](../data-guide/technology-choices/data-storage.md)
- [Choose a data pipeline orchestration technology in Azure](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)
- [Choose a search data store in Azure](../data-guide/technology-choices/search-options.md)
- [Choose a stream processing technology in Azure](../data-guide/technology-choices/stream-processing.md)


## Stay current with databases

Azure database services are evolving to address modern data challenges. Stay informed about the latest updates and planned features.

Get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/?category=databases).

To stay current with key database services, see:

- [What's new in Azure SQL Database](/azure/azure-sql/database/doc-changes-updates-release-notes-whats-new)
- [What's new in Azure Cosmos DB](/azure/cosmos-db/whats-new)
- [What's new in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/release-notes)
- [What's new in Azure Database for MySQL](/azure/mysql/flexible-server/whats-new)


## Additional resources

Databases is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to databases because they have workloads running both on-premises and in the cloud. Azure provides services to extend your database platforms across environments:

- [Azure Arc-enabled SQL Server](/azure/azure-arc/sql-server/overview) - Extend Azure services to SQL Server instances running anywhere.
- [Azure Arc-enabled PostgreSQL](/azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale) - Run Azure-managed PostgreSQL on your infrastructure.
- [Unified hybrid and multicloud operations](guide/hybrid-on-premises-and-cloud.md) - Connect on-premises databases to cloud services.

Key hybrid database scenarios:

- [Optimize administration of SQL Server instances](../hybrid/azure-arc-sql-server.yml) - Use Azure Arc to manage SQL Server across environments.
- [Choose a hybrid network architecture](../reference-architectures/hybrid-networking/index.yml) - Connect on-premises environments to Azure.

### Mainframe data modernization

Modernize mainframe data tier workloads to Azure:

- [Modernize mainframe midrange data](../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml) - Migrate legacy data sources to modern platforms.
- [Replicate and sync mainframe data](../reference-architectures/migration/sync-mainframe-data-with-azure.yml) - Keep mainframe and cloud data synchronized.
- [Mainframe data replication with Connect](../example-scenario/mainframe/mainframe-replication-precisely-connect.yml) - Use Precisely Connect for data replication.
- [Mainframe data replication with Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml) - Replicate data using Qlik technologies.

### Analytics integration

For analytics workloads that depend on robust database foundations, see:

- [Analytics architecture design](../solution-ideas/articles/analytics-get-started.md) - Overview of analytics solutions on Azure.
- [Data warehousing and analytics](../example-scenario/data/data-warehouse.yml) - Integrate databases with analytics platforms.


## AWS or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure database options to other cloud services:

- [Relational database technologies on Azure and AWS](../aws-professional/databases.md) - Compare Azure and AWS database services.
- [Google Cloud to Azure services comparison - Data platform](../gcp-professional/services.md#data-platform) - Compare Azure and Google Cloud database services.


## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Mohit Agarwal](https://www.linkedin.com/in/mohitagarwal01/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*


## Related resources

- [Adatum Corporation scenario for cloud-scale analytics in Azure](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/architectures/reference-architecture-adatum)
- [Lamna Healthcare scenario for data management and analytics in Azure](/azure/cloud-adoption-framework/scenarios/data-management/architectures/reference-architecture-lamna)
- [Relecloud scenario for data management and analytics in Azure](/azure/cloud-adoption-framework/scenarios/data-management/architectures/reference-architecture-relecloud)
