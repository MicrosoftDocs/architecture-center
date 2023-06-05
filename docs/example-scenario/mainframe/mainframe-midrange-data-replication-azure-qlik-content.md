This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

> [!Note]
> Pronounce "Qlik" like "click".

## Architecture

:::image type="content" source="media/mainframe-midrange-data-replication-azure-qlik.png" alt-text="Architecture for data migration to Azure by using Qlik" lightbox="media/mainframe-midrange-data-replication-azure-qlik.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1875751-PR-3888-mainframe-midrange-data-replication-azure-qlik.vsdx) of this architecture.*

### Workflow

1. **Host agent:** The Host agent on the on-premises system captures change log information from Db2, IMS, and VSAM data stores, and passes it to the Qlik Replication server.
1. **Replication server:** The Qlik Replication server software passes the change log information to Kafka and Azure Event Hubs. Qlik in this example is on-premises, but it could instead be deployed on a virtual machine in Azure.
1. **Stream ingestion:** Kafka and Event Hubs provide message brokers  to receive and store change log information.
1. **Kafka Connect:** The Kafka Connect API is used to get data from Kafka for updating Azure data stores such as Azure Data Lake Storage, Azure Databricks,  and Azure Synapse Analytics.
1. **Data Lake Storage:** Data Lake Storage is a staging area for the change log data.
1. **Databricks:** Databricks processes the change log data and updates the corresponding files on Azure.
1. **Azure data services:** Azure provides a variety of efficient data storage services. Prominent among these are:
   - Relational databases services:
     - SQL Server on Azure Virtual Machines
     - Azure SQL Database
     - Azure SQL Managed Instance
     - Azure Database for PostgreSQL
     - Azure Database for MariaDB
     - Azure Database for MySQL

     There are many factors to consider when making a choice: type of workload, cross-database queries, two-phase commit requirements, ability to access the file system, amount of data, required throughput, latency, and so on.

   - **Azure non-relational database services:** Azure Cosmos DB, a NoSQL database, provides quick response, automatic scalability, and guaranteed speed at any scale.
   - **Azure Synapse Analytics:** Synapse Analytics is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. With it, you can query data by using either serverless or dedicated resources at scale.

### Components

The solution uses the components that are listed in the following subsections.

#### Networking and identity

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into cloud services offered by Microsoft over a private connection from a connectivity provider. With ExpressRoute, you can establish connections to cloud services such as Microsoft Azure and Office 365.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is an identity and access management service that can synchronize with an on-premises active directory.

#### Application

- [Azure Event Hubs](https://azure.microsoft.com/services/event-hubs) is a big data streaming platform and event ingestion service that can store Db2, IMS, and VSAM change data messages. It can receive and process millions of messages per second. Data sent to an event hub can be transformed and stored by using a real-time analytics provider or a custom adapter.
- [Apache Kafka](https://kafka.apache.org) is an open-source distributed event streaming platform that's used for high-performance data pipelines, streaming analytics, data integration, and mission-critcal applications. It can be easily integrated with Qlik data integration to store Db2 change data.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) Azure Data Lake Storage provides a data lake for storing the processed on-premises change log data..
- [Azure Databricks](https://azure.microsoft.com/services/databricks) is a cloud-based data engineering tool that's based on Apache Spark. It can process and transform massive quantities of data. You can explore the data by using machine learning models. Jobs can be written in R, Python, Java, Scala, and Spark SQL.

#### Storage

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service with open-source APIs for MongoDB and Cassandra. A possible application is to migrate mainframe non-tabular data to Azure.

#### Monitoring

- [Azure Monitor](https://azure.microsoft.com/services/monitor) delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes these features:
  - Application Insights, for analyzing and presenting telemetry.
  - Monitor Logs, which collects and organizes log and performance data from monitored resources. Data from different sources such as platform logs from Azure services, log and performance data from virtual machines agents, and usage and performance data from applications can be consolidated into a single workspace to be analyzed together. Analysis uses a sophisticated query language that's capable of quickly analyzing millions of records.
  - Log Analytics, which can query Monitor logs. A powerful query language allows you to join data from multiple tables, aggregate large sets of data, and perform complex operations with minimal code.

### Alternatives

- The diagram shows Qlik installed on-premises, a recommended best practice to keep it close to the on-premises data sources. An alternative is to install Qlik in the cloud on an Azure virtual machine.
- Qlik Data Integration can deliver directly to Databricks without going through Kafka or an event hub.
- Qlik Data integration can't replicate directly to Azure Cosmos DB, but you can integrate Azure Cosmos DB with an event hub by using event-sourcing architecture.

## Scenario details

Many organizations use mainframe and midrange systems to run demanding and critical workloads. Most applications use one or more databases, and most databases are shared by many applications, often on multiple systems. In such an environment, modernizing to the cloud means that on-premises data must be provided to cloud-based applications. Therefore, data replication becomes an important modernization tactic.

The [Qlik](https://www.qlik.com/microsoft) Data Integration platform includes Qlik Replication, which does data replication. It uses change data capture (CDC) to replicate on-premises data stores in real time to Azure. The change data can come from Db2, IMS, and VSAM change logs. This replication technique eliminates inconvenient batch bulk loads. This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

> [!Note]
> Pronounce "Qlik" like "click".

### Potential use cases

This solution may be appropriate for:

- Hybrid environments that require replication of data changes from a mainframe or midrange system to Azure databases.
- Online database migration from Db2 to an Azure SQL database with little downtime.
- Data replication from various on-premises data stores to Azure for consolidation and analysis.

## Considerations

Incorporate the following pillars of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) for a highly available and secure system:

### Availability

- Qlik Data Integration can be configured in a high-availability cluster.
- The Azure database services support zone redundancy and can be designed to fail over to a secondary node in case of an outage or during a maintenance window.

### Scalability

Databricks, Data Lake Storage, and other Azure databases have auto-scaling capabilities. For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

### Security

- ExpressRoute provides a private and efficient connection to Azure from on-premises, but you could instead use [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal).
- Azure resources can be authenticated by using Azure AD. Permissions can be managed by role-based access control (RBAC).
- Database services in Azure support various security options such as:
  - Data Encryption at rest.
  - Dynamic data masking.
  - Always-encrypted database.
- For general guidance on designing secure solutions, see the [Azure Security Documentation](/azure/security).

### Resiliency

- You can combine Monitor's Application Insights and Log Analytics features to monitor the health of Azure resources. You can set alerts so that you can manage proactively.
- For guidance on resiliency in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost optimization

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Next steps

- [Qlik Data Integration platform](https://www.qlik.com/us/data-integration/data-integration-platform)
- [Unleash New Azure Analytics Initiatives (PDF data sheet)](https://www.qlik.com/us/-/media/files/resource-library/global-us/direct/datasheets/ds-qlik-mainframe-integration-for-azure-en.pdf)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Azure Event Hubs — A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [Introduction to the core Azure Storage services](/azure/storage/common/storage-introduction)
- [What is Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [What is Application Insights?](/azure/azure-monitor/app/app-insights-overview)
- [Azure Monitor Logs overview](/azure/azure-monitor/logs/data-platform-logs)
- [Log queries in Azure Monitor](/azure/azure-monitor/logs/log-query-overview)
- [Contact us (select to create email)](mailto:mainframedatamod@microsoft.com)

### Related resources

- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Re-engineer mainframe batch applications on Azure](reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)