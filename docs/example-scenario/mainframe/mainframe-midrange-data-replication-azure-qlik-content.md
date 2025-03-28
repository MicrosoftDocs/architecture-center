This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

> [!Note]
> Pronounce "Qlik" like "click".

*Apache® and Apache Kafka® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/mainframe-midrange-data-replication-azure-qlik.svg" alt-text="Architecture for data migration to Azure by using Qlik." lightbox="media/mainframe-midrange-data-replication-azure-qlik.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-midrange-data-replication-azure-qlik.vsdx) of this architecture.*

### Workflow

1. **Host agent:** The Host agent on the on-premises system captures change log information from Db2, IMS (Information Management System), and VSAM (virtual storage access method) data stores, and passes it to the Qlik Replication server.
1. **Replication server:** The Qlik Replication server software passes the change log information to Kafka and Azure Event Hubs. Qlik in this example is on-premises, but it could instead be deployed on a virtual machine in Azure.
1. **Stream ingestion:** Kafka and Event Hubs provide message brokers  to receive and store change log information.
1. **Kafka Connect:** The Kafka Connect API is used to get data from Kafka for updating Azure data stores such as Azure Data Lake Storage, Azure Databricks,  and Azure Synapse Analytics.
1. **Data Lake Storage:** Data Lake Storage is a staging area for the change log data.
1. **Databricks:** Databricks processes the change log data and updates the corresponding files on Azure.
1. **Azure data services:** Azure provides various efficient data storage services including:
   - Relational databases services:
     - SQL Server on Azure Virtual Machines
     - Azure SQL Database
     - Azure SQL Managed Instance
     - Azure Database for PostgreSQL
     - Azure Database for MySQL
     - Azure Cosmos DB

     There are many factors to consider when choosing a data storage service: type of workload, cross-database queries, two-phase commit requirements, ability to access the file system, amount of data, required throughput, latency, and so on.

   - **Azure non-relational database services**: Azure Cosmos DB, a NoSQL database, provides quick response, automatic scalability, and guaranteed speed at any scale.
   - **Azure Synapse Analytics**: Synapse Analytics is an analytics service that brings together data integration, enterprise data warehousing, and big data analytics. With it, you can query data by using either serverless or dedicated resources at scale.
   - **Microsoft Fabric**: Microsoft Fabric is an all-in-one analytics solution for enterprises. It covers everything from data movement to data science, Real-Time Analytics, and business intelligence. It offers a comprehensive suite of services, including data lake, data engineering, and data integration.

### Components

This architecture consists of several Azure cloud services and is divided into four categories of resources: networking and identity, application, storage, and monitoring. The services for each and their roles are described in the following sections.

#### Networking and identity

When designing application architecture, it's crucial to prioritize networking and identity components to ensure security, performance, and manageability during interactions over public internet or private connections.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into cloud services offered by Microsoft over a private connection from a connectivity provider. With ExpressRoute, you can establish connections to cloud services such as Microsoft Azure and Office 365.
- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that can synchronize with an on-premises active directory.

#### Application

Azure offers managed services intended to support the secure, scalable, and efficient deployment of applications. The application tier services cited in the architecture can contribute to achieving optimal application architecture.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service that can store Db2, IMS, and VSAM change data messages. It can receive and process millions of messages per second. Data sent to an event hub can be transformed and stored by using a real-time analytics provider or a custom adapter.
- [Apache Kafka](https://kafka.apache.org) is an open-source distributed event streaming platform that's used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications. It can be easily integrated with Qlik data integration to store Db2 change data.
- [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) Azure Data Lake Storage provides a data lake for storing the processed on-premises change log data.
- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is a cloud-based data engineering tool built on Apache Spark. It can process and transform massive quantities of data. You can explore the data by using machine learning models. Jobs can be written in R, Python, Java, Scala, and Spark SQL.

#### Storage and Database

The architecture addresses scalable and secure cloud storage as well as managed databases for flexible and intelligent data management.

- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](/azure/well-architected/service-guides/azure-files), [Azure Table Storage](/azure/storage/tables/table-storage-overview), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is often an effective tool for migrating mainframe workloads.
- [Azure SQL](/azure/azure-sql/) is a family of SQL cloud databases that provides flexible options for application migration, modernization, and development. The family includes:
  - [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)
  - [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability)
  - [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework)
  - [Azure SQL Edge](/azure/azure-sql-edge/overview)
- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service with open-source APIs for MongoDB and Cassandra. A possible application is to migrate mainframe nontabular data to Azure.
- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed, intelligent, and scalable PostgreSQL that has native connectivity with Azure services.
- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed, scalable MySQL database.
- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service with open-source APIs for MongoDB and Cassandra. A possible application is to migrate mainframe nontabular data to Azure.

#### Monitoring

The monitoring tools provide comprehensive data analysis and valuable insights into application performance.

- [Azure Monitor](/azure/azure-monitor/overview) delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes:
  - Application Insights, for analyzing and presenting telemetry.
  - Monitor Logs, which collects and organizes log and performance data from monitored resources. Data from sources like Azure platform logs, VM agents, and application performance can be combined into one workspace for analysis. The query language used allows for analysis of your records.
  - Log Analytics, which can query Monitor logs. A powerful query language lets you join data from multiple tables, aggregate large sets of data, and perform complex operations with minimal code.

### Alternatives

- The diagram shows Qlik installed on-premises, a recommended best practice to keep it close to the on-premises data sources. An alternative is to install Qlik in the cloud on an Azure virtual machine.
- Qlik Data Integration can deliver directly to Databricks without going through Kafka or an event hub.
- Qlik Data integration can't replicate directly to Azure Cosmos DB, but you can integrate Azure Cosmos DB with an event hub by using event-sourcing architecture.

## Scenario details

Many organizations use mainframe and midrange systems to run demanding and critical workloads. Most applications use shared databases, often across multiple systems. In such an environment, modernizing to the cloud means that on-premises data must be provided to cloud-based applications. Therefore, data replication becomes an important modernization tactic.

The [Qlik](https://www.qlik.com/products/technology/qlik-microsoft-azure-migration) Data Integration platform includes Qlik Replication, which does data replication. It uses change data capture (CDC) to replicate on-premises data stores in real time to Azure. The change data can come from Db2, IMS, and VSAM change logs. This replication technique eliminates inconvenient batch bulk loads. This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

### Potential use cases

This solution might be appropriate for:

- Hybrid environments that require replication of data changes from a mainframe or midrange system to Azure databases.
- Online database migration from Db2 to an Azure SQL database with little downtime.
- Data replication from various on-premises data stores to Azure for consolidation and analysis.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Qlik Data Integration can be configured in a high-availability cluster.
- The Azure database services support zone redundancy and can be designed to fail over to a secondary node if there is an outage or during a maintenance window.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Azure ExpressRoute provides a private and efficient connection to Azure from on-premises, but you could instead use [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal).
- Azure resources can be authenticated by using Microsoft Entra ID, and permissions are managed through role-based access control.
- Azure Database services support various security options, such as:
  - Data Encryption at rest.
  - Dynamic data masking.
  - Always-encrypted database.
- For general guidance on designing secure solutions, see the [Azure Security Documentation](/azure/security).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- You can combine Monitor's Application Insights and Log Analytics features to monitor the health of Azure resources. You can set alerts so that you can manage proactively.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Databricks, Data Lake Storage, and other Azure databases have autoscaling capabilities. For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Qlik Data Integration platform](https://www.qlik.com/us/data-integration/data-integration-platform)
- [Unleash New Azure Analytics Initiatives (PDF data sheet)](https://pages.qlik.com/rs/049-DKK-796/images/MSFT081021_TG_Azure-Mainframe-Data_Datasheet-US_V2.pdf)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Azure Event Hubs—A big data streaming platform and event ingestion service](/azure/event-hubs/event-hubs-about)
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
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
