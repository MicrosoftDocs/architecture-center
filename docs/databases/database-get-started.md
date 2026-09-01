---
title: Get Started with Database Architecture Design
description: Learn about database architecture design on Azure, including technology choices, solution ideas, and reference architectures for your workloads.
author: anaharris-ms
ms.author: pnp
ms.date: 03/05/2026
ms.topic: concept-article
ms.custom: arb-data
ms.subservice: category-get-started
ai-usage: ai-assisted
---

# Get started with database architecture design

Data is central to all applications. One of your most important architectural decisions is choosing the right database solution. Azure provides a comprehensive portfolio of database services that span relational databases, NoSQL databases, in-memory caches, and managed database instances. Whether you build transactional applications, analytical workloads, or globally distributed systems, Azure database services provide the performance, scalability, and reliability that your organization needs.

The right database for your scenario depends on your data model, consistency requirements, query patterns, and operational preferences. Key considerations include data structure like relational versus nonrelational, transaction requirements, scalability needs, and your desired level of management overhead. The Azure database portfolio spans fully managed platform as a service (PaaS) offerings, infrastructure as a service (IaaS) options, and specialized services for specific workload patterns.

## Architecture

:::image type="complex" border="false" source="media/get-started-databases.svg" alt-text="Diagram that shows the database solution journey on Azure." lightbox="media/get-started-databases.svg":::
   Architecture diagram of an Azure workload within a virtual network. Client traffic enters through network ingress services like Azure Front Door, Azure Application Gateway, or Azure Load Balancer and reaches a compute layer. The workload uses managed Azure database services, including relational databases such as Azure SQL, Azure Database for MySQL, Azure SQL virtual machine (VM), and Azure Database for PostgreSQL, and NoSQL services like Azure Cosmos DB, Azure Managed Instance for Apache Cassandra, Azure Managed Redis, and Azure DocumentDB. The architecture also includes private endpoints, user-defined routes (UDRs), network security groups (NSGs), virtual private network (VPN) or Azure ExpressRoute connectivity, and platform services such as managed identities, Azure Monitor, Azure Data Factory, Microsoft Entra ID, and Azure DNS.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/databases-get-started-diagram.vsdx) of this architecture.*

*Apache®, Apache Cassandra®, and the Hadoop logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

The previous diagram demonstrates a typical basic or baseline database implementation. For real-world solutions that you can build in Azure, see [Database architectures](#database-architectures).

Azure database solutions include traditional relational database management systems (RDBMS) and online transaction processing (OLTP) systems, big data and analytics workloads including online analytical processing (OLAP) systems, and NoSQL workloads. To find real-world solutions that you can build in Azure, see [Database architectures](#explore-database-architectures-and-guides).

## Explore database architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These articles can help you decide how to use database technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your database proof-of-concept (POC) development.

[!INCLUDE [database-get-started](../includes/database-get-started-include.md)]

## Learn about databases on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure database technologies. The platform offers videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for database implementations on Azure:

- [Explore Azure database and analytics services](/training/paths/azure-fundamentals-describe-azure-architecture-services/)
- [Choose a data storage approach in Azure](/azure/storage/common/storage-account-overview)
- [Deploy Azure SQL Database](/training/modules/deploy-paas-solutions-with-azure-sql/)
- [Secure your Azure SQL Database](/training/paths/secure-your-cloud-data/)
- [Design your migration to Azure](/data-migration/sql-server/database/guide)
- [Browse Azure database modules](/training/browse/?products=azure&terms=database)

### Learning paths by role

- **Data engineer:** [Azure data fundamentals: Explore relational data in Azure](/training/paths/azure-data-fundamentals-explore-relational-data/)
- **Database administrator:** [Implement scalable database solutions by using Azure SQL](/training/courses/dp-300t00)
- **Developer:** [Plan and implement Azure Cosmos DB for NoSQL](/training/paths/plan-implement-azure-cosmos-db-sql-api/)

For more role-based training, [browse other learning paths](/training/browse/?resource_type=learning%20path).

## Organizational readiness

Organizations that are beginning their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) for proven guidance designed to accelerate cloud adoption. For guidance on creating an executive strategy for a unified data platform, see [Executive strategy for unifying your data](/azure/cloud-adoption-framework/data/executive-strategy-unify-data-platform).

To help ensure the quality of your database solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For database-specific guidance, see the following Well-Architected Framework service guides:

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db)
- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database)

## Best practices

Review the following best practices when you design your database solutions.

| Best practice | Description |
|---------------|-------------|
| [The Transactional Outbox pattern with Azure Cosmos DB](../databases/guide/transactional-out-box-cosmos.md) | Learn how to use the Transactional Outbox pattern for reliable messaging and guaranteed event delivery. |
| [Distribute your data globally by using Azure Cosmos DB](/azure/cosmos-db/distribute-data-globally) | To achieve low latency and high availability, some applications must be deployed in datacenters that are close to their users. |
| [Security in Azure Cosmos DB](/azure/cosmos-db/security) | Security best practices help prevent, detect, and respond to database breaches. |
| [Continuous backup with point-in-time restore (PITR) in Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction) | Learn about Azure Cosmos DB PITR. |
| [Achieve high availability by using Azure Cosmos DB](/azure/reliability/reliability-cosmos-db) | Azure Cosmos DB provides multiple features and configuration options to achieve high availability. |
| [High availability for Azure SQL Database and Azure SQL Managed Instance](/azure/azure-sql/database/high-availability-sla-local-zone-redundancy) | The database shouldn't be a single point of failure in your architecture. |

## Stay current with databases

Azure database services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/?category=databases).

To stay current with key database services, see the following articles:

- [What's new in Azure SQL Database](/azure/azure-sql/database/doc-changes-updates-release-notes-whats-new)
- [What's new in Azure Database for PostgreSQL](/azure/postgresql/release-notes/release-notes)
- [What's new in Azure Database for MySQL](/azure/mysql/release-notes/release-notes-2026)

## Other resources

Databases is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

### Hybrid and multicloud

Most organizations need a hybrid approach to databases because they have workloads that run both on-premises and in the cloud. Organizations typically [extend on-premises database solutions to the cloud](/azure/architecture/databases/guide/hybrid-on-premises-and-cloud). To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/hybrid-connectivity-options).

- [Azure Arc-enabled PostgreSQL](/azure/azure-arc/data/what-is-azure-arc-enabled-postgresql): Run Azure-managed PostgreSQL on your infrastructure.
- [Azure hybrid and multicloud patterns](/azure/architecture/hybrid/hybrid-start-here): Connect on-premises databases to cloud services.

Review the following key hybrid database scenarios:

- [Azure Arc hybrid management for SQL Server](../hybrid/azure-arc-sql-server.yml): Use Azure Arc to manage SQL Server across environments.
- [Hybrid architecture design](../hybrid/hybrid-start-here.md): Connect on-premises environments to Azure.

### Mainframe data modernization

Organizations that use legacy mainframe systems can modernize their data workloads by migrating to Azure database services. Azure provides multiple migration patterns and replication strategies to help you transition mainframe data while maintaining business continuity.

- [Modernize mainframe midrange data](../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml): Migrate legacy data sources to modern platforms.
- [Replicate and sync mainframe data](../reference-architectures/migration/sync-mainframe-data-with-azure.yml): Keep mainframe and cloud data synchronized.
- [Mainframe data replication by using Connect](../example-scenario/mainframe/mainframe-replication-precisely-connect.yml): Use Precisely Connect for data replication.
- [Mainframe data replication by using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml): Replicate data by using Qlik technologies.

### Analytics integration

For analytics workloads that depend on well-architected database foundations, see the following articles:

- [Analytics architecture design](../analytics/analytics-get-started.md): See an overview of analytics solutions on Azure.
- [Data warehousing and analytics](../example-scenario/data/data-warehouse.yml): Integrate databases with analytics platforms.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure database options to other cloud services:

- [Relational database technologies on Azure and AWS](../aws-professional/databases.md): Compare Azure and AWS database services.
- [Google Cloud to Azure services comparison: Data platform](../gcp-professional/services.md#data-platform): Compare Azure and Google Cloud database services.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Mohit Agarwal](https://www.linkedin.com/in/mohitagarwal01/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*
