This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

> [!NOTE]
> Pronounce "Qlik" like "click."

*Apache® and Apache Kafka® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" source="media/mainframe-midrange-data-replication-azure-qlik.svg" alt-text="Diagram of an architecture that uses Qlik to migrate data to Azure." lightbox="media/mainframe-midrange-data-replication-azure-qlik.svg" border="false":::
   The diagram shows the process to migrate on-premises data to Azure. The diagram is divided into two main sections, on-premises datacenter and Azure, that are connected by Azure ExpressRoute. In the on-premises datacenter section, arrows represent how the host agent captures change log information from Db2, IMS, and VSAM data stores and passes it to the Qlik replication server. An arrow represents how the replication server passes data to stream ingestion services, like Kafka and Azure Event Hubs, in the Azure section of the diagram. Another arrow shows how the replication server passes data directly to Azure data services, like Azure SQL, Azure Data Lake Storage, Azure Synapse Analytics, and Microsoft Fabric. Arrows show how data can also pass from stream ingestion services to Data Lake Storage, Azure Databricks, or other Azure data services.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-midrange-data-replication-azure-qlik.vsdx) of this architecture.*

### Workflow

1. **Host agent:** The host agent on the on-premises system captures change log information from Db2, Information Management System (IMS), and Virtual Storage Access Method (VSAM) data stores and passes it to the Qlik replication server.

1. **Replication server:** The Qlik replication server software passes the change log information to Kafka and Azure Event Hubs. In this example, Qlik is on-premises, but you can deploy it on a virtual machine in Azure.

1. **Stream ingestion:** Kafka and Event Hubs provide message brokers to receive and store change log information.

1. **Kafka Connect:** The Kafka Connect API receives data from Kafka to update Azure data stores like Azure Data Lake Storage, Azure Databricks, and Azure Synapse Analytics.

1. **Data Lake Storage:** Data Lake Storage is a staging area for the change log data.

1. **Azure Databricks:** Azure Databricks processes the change log data and updates the corresponding files on Azure.

1. **Azure data services:** Azure provides the following efficient data storage services.

   - **Relational databases services:**

     - SQL Server on Azure Virtual Machines
     - Azure SQL Database
     - Azure SQL Managed Instance
     - Azure Database for PostgreSQL
     - Azure Database for MySQL
     - Azure Cosmos DB

     There are many factors to consider when you choose a data storage service. Consider the type of workload, cross-database queries, two-phase commit requirements, the ability to access the file system, amount of data, required throughput, and latency.

   - **Azure nonrelational database services:** Azure Cosmos DB, a NoSQL database, provides quick response, automatic scalability, and guaranteed speed at any scale.

   - **Azure Synapse Analytics:** Azure Synapse Analytics is an analytics service that combines data integration, enterprise data warehousing, and big data analytics. Use it to query data by using either serverless or dedicated resources at scale.

   - **Microsoft Fabric:** Microsoft Fabric is an all-in-one analytics solution for enterprises. It covers everything from data movement to data science, real-time analytics, and business intelligence. It provides a comprehensive suite of services, including data lake, data engineering, and data integration.

### Components

This architecture consists of several Azure cloud services and is divided into four categories of resources: networking and identity, application, storage, and monitoring. The following sections describe the services for each resource and their roles.

#### Networking and identity

When you design application architecture, it's crucial to prioritize networking and identity components to help ensure security, performance, and manageability during interactions over the public internet or private connections.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into cloud services provided by Microsoft over a private connection from a connectivity provider. Use ExpressRoute to establish connections to cloud services such as Azure and Microsoft 365.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a specific type of virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that can synchronize with an on-premises active directory.

#### Application

Azure provides managed services that support more secure, scalable, and efficient application deployment. This architecture uses application tier services that can help you optimize your application architecture.

- [Event Hubs](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service that can store Db2, IMS, and VSAM change data messages. It can receive and process millions of messages per second. Data sent to an event hub can be transformed and stored by using a real-time analytics provider or a custom adapter.

- [Apache Kafka](https://kafka.apache.org) is an open-source distributed event streaming platform that's used for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications. It can be easily integrated with Qlik data integration to store Db2 change data.

- [Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) provides a data lake for storing the processed on-premises change log data.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is a cloud-based data engineering tool built on Apache Spark. It can process and transform massive quantities of data. You can explore the data by using machine learning models. Jobs can be written in R, Python, Java, Scala, and Spark SQL.

#### Storage and databases

This architecture addresses scalable and more secure cloud storage as well as managed databases for flexible and intelligent data management.

- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a set of massively scalable and more secure cloud services for data, apps, and workloads. It includes [Azure Files](/azure/well-architected/service-guides/azure-files), [Azure Table Storage](/azure/storage/tables/table-storage-overview), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues). Azure Files is an effective tool for migrating mainframe workloads.

- [Azure SQL](/azure/azure-sql/) is a family of SQL cloud databases that provides flexible options for application migration, modernization, and development. This family includes:

  - [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)
  - [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability)
  - [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework)
  - [Azure SQL Edge](/azure/azure-sql-edge/overview)

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that has open-source APIs for MongoDB and Cassandra. You can use it to migrate mainframe nontabular data to Azure.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed, intelligent, and scalable PostgreSQL that has native connectivity with Azure services.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed, scalable MySQL database.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that has open-source APIs for MongoDB and Cassandra. You can use it to migrate mainframe nontabular data to Azure.

#### Monitoring

The monitoring tools provide comprehensive data analysis and valuable insights into application performance.

- [Azure Monitor](/azure/azure-monitor/overview) is a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes:

  - Application Insights, for analyzing and presenting telemetry.

  - Azure Monitor Logs, which collects and organizes log and performance data from monitored resources. You can combine data from sources like Azure platform logs, virtual machine agents, and application performance into one workspace for analysis. The query language enables analysis of your records.

  - Log Analytics, which can query Azure Monitor Logs. A powerful query language lets you join data from multiple tables, aggregate large sets of data, and perform complex operations with minimal code.

### Alternatives

- The preceding diagram shows Qlik installed on-premises. This approach is a recommended best practice to keep Qlik close to the on-premises data sources. An alternative is to install Qlik in the cloud on an Azure virtual machine.

- Qlik Data Integration can deliver directly to Azure Databricks without going through Kafka or an event hub.

- Qlik Data Integration can't replicate directly to Azure Cosmos DB, but you can integrate Azure Cosmos DB with an event hub by using event-sourcing architecture.

## Scenario details

Many organizations use mainframe and midrange systems to run demanding and critical workloads. Most applications use shared databases, often across multiple systems. In this environment, modernizing to the cloud means that on-premises data must be provided to cloud-based applications. Therefore, data replication becomes an important modernization tactic.

The [Qlik](https://www.qlik.com/products/technology/qlik-microsoft-azure-migration) Data Integration platform includes Qlik Replicate, which does data replication. It uses change data capture to replicate on-premises data stores in real time to Azure. The change data can come from Db2, IMS, and VSAM change logs. This replication technique eliminates inconvenient batch bulk loads. This solution uses an on-premises instance of Qlik to replicate on-premises data sources to Azure in real time.

### Potential use cases

This solution might be appropriate for:

- Hybrid environments that require replication of data changes from a mainframe or midrange system to Azure databases.

- Online database migration from Db2 to an Azure SQL database with little downtime.

- Data replication from various on-premises data stores to Azure for consolidation and analysis.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Qlik Data Integration can be configured in a high-availability cluster.

- The Azure database services support zone redundancy and can be designed to fail over to a secondary node during a maintenance window or if an outage occurs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- ExpressRoute provides a private and efficient connection to Azure from on-premises, but you can use [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal) instead.

- Azure resources can be authenticated by using Microsoft Entra ID, and permissions are managed through role-based access control.

- Azure database services support various security options, such as:

  - Data encryption at rest.

  - Dynamic data masking.

  - Always-encrypted databases.

- For more information, see [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your implementation.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You can combine Application Insights and Log Analytics features to monitor the health of Azure resources. You can set alerts so that you can manage problems proactively.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure Databricks, Data Lake Storage, and other Azure databases have autoscaling capabilities. For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.* 

Principal authors:

- [Nithish Aruldoss](https://www.linkedin.com/in/nithish-aruldoss-b4035b2b) | Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Qlik Data Integration platform](https://www.qlik.com/us/data-integration/data-integration-platform)
- [Unleash new Azure analytics initiatives (PDF data sheet)](https://pages.qlik.com/rs/049-DKK-796/images/MSFT081021_TG_Azure-Mainframe-Data_Datasheet-US_V2.pdf)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis)
- [Event Hubs: A real-time data streaming platform with native Apache Kafka support](/azure/event-hubs/event-hubs-about)
- [Introduction to Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [Introduction to Storage](/azure/storage/common/storage-introduction)
- [What is Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
- [Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Introduction to Application Insights with OpenTelemetry](/azure/azure-monitor/app/app-insights-overview)
- [Azure Monitor Logs overview](/azure/azure-monitor/logs/data-platform-logs)
- [Log queries in Azure Monitor](/azure/azure-monitor/logs/log-query-overview)
- [Contact us (select to create email)](mailto:mainframedatamod@microsoft.com)

### Related resources

- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Re-engineer mainframe batch applications on Azure](reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
