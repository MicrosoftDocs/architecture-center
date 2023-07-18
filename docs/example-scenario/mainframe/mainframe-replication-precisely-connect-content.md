This article describes how to use Precisely Connect to migrate mainframe and midrange systems to Azure.

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/mainframe-midrange-data-replication-azure-precisely1.svg" alt-text="Diagram that shows an architecture for migrating mainframe and midrange systems to Azure." lightbox="media/mainframe-midrange-data-replication-azure-precisely1.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-midrange-data-replication-azure-precisely1.vsdx) of this architecture.*


### Workflow

1.	A Connect agent component captures change logs by using mainframe or midrange native utilities and caches the logs in temporary storage.
2.	For mainframe systems, a publisher component on the mainframe manages data migration.
3.	For midrange systems, in place of the publisher, a listener component manages data migration. It's located on either a Windows or Linux machine.
4.	The publisher or listener moves the data from on-premises to Azure via an enhanced-security connection. The publisher or listener handles the commit and rollback of transactions for each unit of work, maintaining the integrity of data.
5.	The Connect Replicator Engine captures the data from the publisher or listener and applies it to the target. It distributes data for parallel processing.
6.	The target is a database that receives the changes via ODBC or ingests the changes via Azure Event Hubs. 
7.	The changed data is consumed by Azure Databricks and applied to Azure data platform services.
8.	The Connect Controller Daemon authenticates the request and establishes the socket connection between the publisher or listener and the Replicator Engine.

### Components

#### Networking and identity

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks to Azure cloud services over a private connection from a connectivity provider. 
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) enables you to create virtual network gateways that send encrypted traffic between an Azure virtual network and an on-premises location over the public internet.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is an identity and access management service that synchronizes with on-premises Active Directory.

#### Storage

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is part of the Azure SQL family. It's built for the cloud and provides all the benefits of a fully managed and evergreen platform as a service (PaaS). SQL Database also provides AI-powered automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine. 
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.
- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has nearly 100 percent compatibility with the latest SQL Server Enterprise edition database engine. It also provides a native virtual network implementation that addresses common security concerns.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a fast and flexible cloud data warehouse that helps you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

#### Analysis and reporting

- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that can deliver insights throughout your organization. By using Power BI, you can connect to hundreds of data sources, simplify data preparation, and drive ad hoc analysis.

#### Monitoring

- [Azure Monitor](https://azure.microsoft.com/services/monitor) provides a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. Features include Application Insights, Azure Monitor Logs, and Log Analytics.

#### Data integrators

- [Precisely Connect](https://www.precisely.com/product/precisely-connect/connect) can integrate data from multiple sources and provide real-time replication to Azure. You can use it to replicate data without making changes to your application. Connect can also improve the performance of extract, transform, load (ETL) jobs.
- [Azure Databricks](https://azure.microsoft.com/products/databricks) is based on Apache Spark and integrates with open-source libraries. It provides a unified platform for running analytics workloads. You can use Python, Scala, R, and SQL languages to frame ETL pipelines and orchestrate jobs.
- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) is a real-time ingestion service that can process millions of records per second. You can ingest data from multiple sources and use it for real-time analytics. You can easily scale Event Hubs based on the volume of data.  

## Scenario details

 You can use various strategies to migrate mainframe and midrange systems to Azure. Data migration plays a key role in this process. In a hybrid cloud architecture, data needs to be replicated between mainframe or midrange systems and the Azure data platform. To maintain the integrity of the data, you need real-time replication for business-critical applications. Precisely Connect can help you replicate data from mainframe and midrange data sources to the Azure data platform in real time by using change data capture (CDC) or by using batch ingestion.

Precisely Connect supports various mainframe and midrange data sources, including Db2 z/OS, Db2 LUW, Db2 for i, IMS, VSAM, files, and copybooks. It migrates them to Azure targets, like SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL, Azure Data Lake Storage, and Azure Synapse Analytics, without affecting applications. It also supports scalability based on data volume and customer requirements. It replicates data without affecting performance or straining the network. 

### Potential use cases

This solution applies to the following scenarios:

- Data replication from mainframe and midrange data sources to the Azure data platform.
- In a hybrid cloud architecture, data sync between mainframe or midrange systems and the Azure data platform.
- Near real-time analytics on Azure, based on operational data from mainframe or midrange systems. 
- Migration of data from mainframe or midrange systems to Azure without affecting applications.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Use [Azure Monitor](https://azure.microsoft.com/services/monitor) and [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor your data migration. Set up alerts for proactive management. For more information about reliability in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). 

- Replicating data to Azure and processing it in Azure services can be more cost effective than maintaining it in a mainframe system.
- The Cost Management tool in the Azure portal provides a cost analysis view that can help you analyze your spending.
- You can use Azure Databricks to resize your cluster with autoscaling to optimize costs. Doing so can be less expensive than using a fixed configuration.
- Azure Advisor provides recommendations to optimize performance and cost management.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Precisely Connect can scale based on the volume of data and optimize data replication.
- The Connect Replicator Engine can distribute data for parallel processing. You can balance distribution based on the ingestion of workloads.
- SQL Database serverless can scale automatically based on the volume of workloads.
- Event Hubs can scale based on throughput units and the number of partitions.

For more information, see [Autoscaling best practices in Azure](../../best-practices/auto-scaling.md).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan) | Senior Engineering Architect

Other contributor:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Change Data Capture with Connect](https://www.precisely.com/resource-center/productsheets/change-data-capture-with-connect)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Contact Mainframe Data Modernization Engineering at Microsoft](mailto:mainframedatamod@microsoft.com)

## Related resources

- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data on Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
