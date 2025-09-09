This article describes how to use Precisely Connect to migrate mainframe and midrange systems to Azure.

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/mainframe-midrange-data-replication-azure-precisely.svg" alt-text="Diagram that shows an architecture for migrating mainframe and midrange systems to Azure." lightbox="media/mainframe-midrange-data-replication-azure-precisely.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-midrange-data-replication-azure-precisely.vsdx) of this architecture.*

### Workflow

1. A Connect agent component captures change logs by using mainframe or midrange native utilities and caches the logs in temporary storage.
2. For mainframe systems, a publisher component on the mainframe manages data migration.
3. For midrange systems, in place of the publisher, a listener component manages data migration. It's located on either a Windows or Linux machine.
4. The publisher or listener moves the data from on-premises to Azure via an enhanced-security connection. The publisher or listener handles the commit and rollback of transactions for each unit of work, maintaining the integrity of data.
5. The Connect Replicator Engine captures the data from the publisher or listener and applies it to the target. It distributes data for parallel processing.
6. The target is a database that receives the changes via ODBC or ingests the changes via Azure Event Hubs.
7. The changed data is consumed by Azure Databricks and applied to Azure data platform services.
8. The Connect Controller Daemon authenticates the request and establishes the socket connection between the publisher or listener and the Replicator Engine.

### Components

This architecture uses the following components.

#### Networking and identity

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks to the Azure cloud platform over a private connection from a connectivity provider. In this architecture, Azure ExpressRoute provides a secure, high-bandwidth connection for replicating mainframe data to Azure.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) enables you to create virtual network gateways that send encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, Azure VPN Gateway can be used as an alternative to ExpressRoute for connecting mainframe systems to Azure when a private connection isn't available.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that can synchronize with on-premises Active Directory. In this architecture, Microsoft Entra ID manages authentication and access control for Precisely Connect components accessing Azure resources.

#### Storage

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is part of the Azure SQL family. It's built for the cloud and provides all the benefits of a fully managed and evergreen platform as a service (PaaS). SQL Database also provides AI-powered automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand. In this architecture, Azure SQL Database serves as a target database for receiving replicated mainframe data via ODBC or native database connections.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine. In this architecture, Azure Database for PostgreSQL can serve as an alternative target database for mainframe data replication.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine. In this architecture, Azure Database for MySQL provides another target option for replicated mainframe data.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has nearly 100 percent compatibility with the latest SQL Server Enterprise edition database engine. It also provides a native virtual network implementation that addresses common security concerns. In this architecture, Azure SQL Managed Instance can serve as a target for mainframe data requiring SQL Server compatibility.

- [Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is) is a limitless analytics service that brings together data integration, data warehousing, and data analytics. It helps you scale, compute, and store data elastically and independently, with a massively parallel processing architecture. In this architecture, Azure Synapse Analytics serves as the data warehouse destination for large-scale mainframe data analytics.

- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data. In this architecture, Azure Storage provides scalable storage for replicated mainframe data and temporary caching.

#### Analysis and reporting

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a suite of business analytics tools that can deliver insights throughout your organization. By using Power BI, you can connect to hundreds of data sources, simplify data preparation, and drive ad hoc analysis. In this architecture, Power BI provides business intelligence capabilities for analyzing replicated mainframe data.

#### Monitoring

- [Azure Monitor](/azure/azure-monitor/overview) provides a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. Features include Application Insights, Azure Monitor Logs, and Log Analytics. In this architecture, Azure Monitor provides monitoring and observability for the data replication process and Azure resources.

#### Data integrators

- [Precisely Connect](https://www.precisely.com/product/precisely-connect/connect) can integrate data from multiple sources and provide real-time replication to Azure. You can use it to replicate data without making changes to your application. Connect can also improve the performance of extract, transform, load (ETL) jobs. In this architecture, Precisely Connect serves as the primary data replication engine that captures and migrates mainframe data to Azure in real time.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is a unified analytics platform based on Apache Spark that integrates with open-source libraries. It provides a collaborative workspace for running analytics workloads. You can use Python, Scala, R, and SQL languages to build ETL pipelines and orchestrate jobs. In this architecture, Azure Databricks processes and transforms the replicated mainframe data for consumption by Azure data platform services.

- [Azure Event Hubs](/azure/well-architected/service-guides/event-hubs) is a real-time data ingestion service that can process millions of events per second. You can ingest data from multiple sources and use it for real-time analytics. You can easily scale Event Hubs based on the volume of data. In this architecture, Azure Event Hubs ingests real-time data changes from Precisely Connect for immediate processing and analytics.

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

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Use [Azure Monitor](https://azure.microsoft.com/services/monitor) and [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor your data migration. Set up alerts for proactive management. For more information about reliability in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Replicating data to Azure and processing it in Azure services can be more cost effective than maintaining it in a mainframe system.
- The Cost Management tool in the Azure portal provides a cost analysis view that can help you analyze your spending.
- You can use Azure Databricks to resize your cluster with autoscaling to optimize costs. Doing so can be less expensive than using a fixed configuration.
- Azure Advisor provides recommendations to optimize performance and cost management.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

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
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)