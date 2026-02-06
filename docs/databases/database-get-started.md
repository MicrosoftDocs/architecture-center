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

:::image type="complex" border="false" source=".media/data-service-classifications.png" alt-text="Diagram that shows the analytics solution journey on Azure." lightbox="media/data-service-classifications.png":::
   Diagram that contrasts relational database management system (RDBMS) and big data solutions. 
:::image-end:::

*Apache®, Apache Cassandra®, and the Hadoop logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

Azure database solutions include traditional relational database management systems (RDBMS and OLTP), big data and analytics workloads (including OLAP), and NoSQL workloads. Refer to the [architectures](#explore-database-architectures-and-guides) provided in this section to find real-world solutions that you can build in Azure.


## Explore database architectures and guides

The articles in this section include solution ideas, fully developed architectures, and guidance that address database scenarios on Azure. Solution ideas demonstrate implementation patterns and possibilities to consider. Architectures can be deployed and expanded to production-grade solutions. Guides help you make important decisions about how you use database technologies in Azure.

### Database architecture guides

**Technology choices** - These articles help you choose the best database technologies for your needs:

- [Prepare to choose a data store in Azure](../guide/technology-choices/data-stores-getting-started.md)
- [Understand data store models](../data-guide/technology-choices/understand-data-store-models.md)
- [Big data storage](../data-guide/technology-choices/data-storage.md)
- [Search data store](../data-guide/technology-choices/search-options.md)
- [Vector search](../guide/technology-choices/vector-search.md)
- [Pipeline orchestration](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)
- [Data transfer options](../data-guide/scenarios/data-transfer.md)

**NoSQL**

- [Use the Transactional Outbox pattern](../databases/guide/transactional-outbox-cosmos.yml)
- [Run Apache Cassandra](../databases/guide/cassandra.md)

**Data processing**

- [OLAP solutions](../data-guide/relational-data/online-analytical-processing.md)
- [OLTP solutions](../data-guide/relational-data/online-transaction-processing.md)
- [ETL guide](../data-guide/relational-data/etl.yml)
- [Data lakes](../data-guide/scenarios/data-lake.md)
- [Big data architectures](../databases/guide/big-data-architectures.md)

**Data governance**

- [Data obfuscation with Delphix](../databases/guide/data-obfuscation-with-delphix-in-azure-data-factory.yml)
- [Data scrambling for SAP with Delphix](../databases/guide/data-scrambling-for-sap-using-delphix-and-azure-data-factory.yml)
- [Collection structure for a federated Purview catalog](../guide/data/collection-structure-federated-catalog.md)

### Database architectures

**Data warehouse**

- [DataOps for modern data warehouse](../databases/architecture/dataops-mdw.yml)
- [Greenfield lakehouse on Microsoft Fabric](../example-scenario/data/greenfield-lakehouse-fabric.yml)

**Azure Data Factory**

- [Medallion lakehouse with Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-index.yml)
- [Azure Data Factory baseline architecture](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml)
- [Azure Data Factory enterprise hardened architecture](../databases/architecture/azure-data-factory-enterprise-hardened.yml)
- [Azure Data Factory mission critical architecture](../databases/architecture/azure-data-factory-mission-critical.yml)

**NoSQL**

- [Deploy MongoDB Atlas on Azure](../databases/architecture/mongodb-atlas-baseline.md)
- [Analyze MongoDB Atlas data](../databases/architecture/azure-synapse-analytics-integrate-mongodb-atlas.yml)

**Mainframe**

- [Replicate and sync mainframe data](../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe data replication with Connect](../example-scenario/mainframe/mainframe-replication-precisely-connect.yml)
- [Mainframe data replication with Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)
- [Mainframe data replication with RDRS](../example-scenario/mainframe/mainframe-data-replication-azure-rdrs.yml)
- [Migrate mainframe data tier to Azure with mLogica LIBER*IRIS](../example-scenario/mainframe/mainframe-data-replication-azure-data-platform.yml)
- [Modernize mainframe midrange data](../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch apps](../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Rehost IMS DC and IMS DB](../example-scenario/mainframe/rehost-ims-raincode-imsql.yml)
- [Implement SMA OpCon in Azure](../example-scenario/integration/sma-opcon-azure.yml)

**Relational**

- [Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)
- [SAP deployment using an Oracle database](../example-scenario/apps/sap-production.yml)

**Big data**

- [Microsoft Fabric deployment patterns](../analytics/architecture/fabric-deployment-patterns.yml)

### Database solution ideas

**Relational**

- [Migrate an Oracle database to Azure](../databases/idea/topic-migrate-oracle-azure.yml)
- [Migrate an Oracle database to an Azure virtual machine](../databases/idea/migrate-oracle-azure-iaas.yml)
- [Migrate an Oracle database to OD@A Exadata Database Service](../databases/idea/migrate-oracle-odaa-exadata.yml)
- [Cross-region resiliency for SQL TDE with Azure Key Vault Managed HSM](../solution-ideas/articles/secure-sql-managed-instance-managed-hardware-security-module.yml)

**NoSQL**

- [Minimal storage – change feed replication](../databases/idea/minimal-storage-change-feed-replicate-data.yml)


## Learn about databases on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure database technologies. The platform offers videos, tutorials, and hands-on labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for database implementations on Azure:

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


## Organizational readiness

Organizations that are beginning their cloud adoption can use the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) for proven guidance designed to accelerate cloud adoption. For cloud-scale analytics and data management guidance, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

To help assure the quality of your database solution on Azure, we recommend following the [Azure Well-Architected Framework (WAF)](/azure/well-architected/). WAF provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions.

For database-specific guidance, see the Azure Well-Architected Framework service guides for:

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db)
- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database)


## Path to production

[Choosing a data store](../guide/technology-choices/data-stores-getting-started.md) is a foundational decision when implementing databases on Azure. Understanding the different [data store models](../data-guide/technology-choices/understand-data-store-models.md) enables you to select the appropriate technology for your workload requirements.

Key decision points include:

- **Data model**: Choose between relational, document, key-value, graph, or columnar data models based on your data structure and query patterns.

- **Consistency requirements**: Determine whether you need strong consistency (ACID transactions) or can work with eventual consistency for better scalability.

- **Scalability**: Evaluate whether vertical scaling (larger instances) or horizontal scaling (distributed data) better fits your growth needs.

- **Managed vs. self-managed**: Decide between fully managed PaaS services, managed instances, or IaaS deployments based on operational requirements.

To view different architecture styles for database solutions, see [architectures](#database-architectures).


## Best practices

Review these best practices when designing your database solutions:

| Best practice | Description |
|---------------|-------------|
| [Transactional Outbox pattern with Azure Cosmos DB](../databases/guide/transactional-outbox-cosmos.yml) | Learn how to use the Transactional Outbox pattern for reliable messaging and guaranteed delivery of events. |
| [Distribute your data globally with Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally) | To achieve low latency and high availability, some applications need to be deployed in datacenters that are close to their users. |
| [Security in Azure Cosmos DB](/azure/cosmos-db/database-security) | Security best practices help prevent, detect, and respond to database breaches. |
| [Continuous backup with point-in-time restore in Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction) | Learn about Azure Cosmos DB point-in-time restore feature. |
| [Achieve high availability with Azure Cosmos DB](/azure/cosmos-db/high-availability) | Azure Cosmos DB provides multiple features and configuration options to achieve high availability. |
| [High availability for Azure SQL Database and SQL Managed Instance](/azure/azure-sql/database/high-availability-sla) | The database shouldn't be a single point of failure in your architecture. |


## Stay current with databases

Azure database services are evolving to address modern data challenges. Stay informed about the latest updates and planned features.

Get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/?category=databases).

To stay current with key database services, see:

- [What's new in Azure SQL Database](/azure/azure-sql/database/doc-changes-updates-release-notes-whats-new)
- [What's new in Azure Database for PostgreSQL](/azure/postgresql/flexible-server/release-notes)
- [What's new in Azure Database for MySQL](/azure/mysql/flexible-server/whats-new)


## Additional resources

Databases is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Many organizations need a hybrid approach to databases because they have workloads running both on-premises and in the cloud. Azure provides services to extend your database platforms across environments:

- [Azure Arc-enabled PostgreSQL](/azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale) - Run Azure-managed PostgreSQL on your infrastructure.
- [Azure hybrid and multicloud patterns](/azure/architecture/hybrid/hybrid-start-here) - Connect on-premises databases to cloud services.

Key hybrid database scenarios:

- [Azure Arc hybrid management for SQL Server](../hybrid/azure-arc-sql-server.yml) - Use Azure Arc to manage SQL Server across environments.
- [Hybrid architecture design](../hybrid/hybrid-start-here.md) - Connect on-premises environments to Azure.

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
