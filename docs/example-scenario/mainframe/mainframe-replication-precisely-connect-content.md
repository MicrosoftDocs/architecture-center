 You can use various strategies to migrate mainframe and midrange systems to the Azure platform. Data migration plays a key role in this process. In a hybrid cloud architecture, data needs to be replicated between mainframe or midrange systems and the Azure data platform. To maintain the integrity of the data, you need real-time replication for business-critical applications. Precisely Connect can help you replicate data from mainframe and midrange data sources to the Azure data platform in real time by using change data capture (CDC) or by using batch ingestion.

Precisely Connect supports various mainframe and midrange data sources, including Db2 z/OS, Db2 LUW, Db2 for i, IMS, VSAM, files, and copybooks. It migrates them to Azure targets, like Azure SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL, Azure Data Lake Storage, and Azure Synapse Analytics, without affecting applications. It also supports scalability based on data volume and customer requirements. It replicates data without affecting performance or straining the network. 

### Potential use cases

This solution applies to the following scenarios:

- Data replication from mainframe and midrange data sources the to Azure data platform.
- In a hybrid cloud architecture, data sync between mainframe or midrange systems and the Azure data platform.
- Near real-time analytics on Azure, based on operational data from mainframe or midrange systems. 
- Migration of data from mainframe or midrange systems to Azure without affecting applications.

## Architecture

diagram

link 

### Workflow 

1.	An agent captures change logs by using mainframe or midrange native utilities and caches the logs in temporary storage.
2.	For mainframe systems, a publisher on the mainframe manages data migration.
3.	For midrange systems, in place of the publisher, a listener manages data migration. It's located on either a Windows or Linux machine.
4.	The publisher or listener moves the data from on-premises to the Azure platform via an enhanced-security connection. It handles the commit and rollback of transactions for each unit of work, maintaining the integrity of data.
5.	A replicator engine captures the data from the publisher or listener and applies it to the target. It distributes data for parallel processing.
6.	The target is a database that receives the changes via ODBC or ingests the changes via Azure Event Hubs. 
7.	The changed data is consumed by Azure Databricks and applied to Azure data platform services.
8.	Controller Daemon acts as authenticating service for the request and establish the socket connection between publisher/listener and replicator. 

Components

Networking and identity

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into cloud services that are offered by Microsoft over a private connection from a connectivity provider. With ExpressRoute, you can establish connections to cloud components such as Azure services and Microsoft 365.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) is a specific type of virtual network gateway that sends encrypted traffic between Azure Virtual Network and an on-premises location over the public internet.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is an identity and access management service that synchronizes with an on-premises active directory.

Storage

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is part of the Azure SQL family and is built on the cloud. This service offers all the benefits of a fully managed and evergreen platform as a service (PaaS). Azure SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.
- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has nearly 100 percent compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.
- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a fast and flexible cloud data warehouse that helps you scale, compute, and store elastically and independently, with a massively parallel processing architecture.
- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

Analysis and reporting

- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. By using Power BI, you can connect to hundreds of data sources, simplify data preparation, and drive ad hoc analysis. You can produce beautiful reports, then publish them for your organization to consume on the web, and across mobile devices.

Monitoring

- [Azure Monitor](https://azure.microsoft.com/services/monitor) delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It contains the Application Insights, Azure Monitor Logs, and Azure Log Analytics features.

Data integrators

- [Precisely Connect](https://www.precisely.com/product/precisely-connect/connect) can integrate data from multiple sources and provide real time replication to Azure. Data can be replicated without making changes to the application and can increase performance in ETL jobs.
- [Azure Databricks](https://azure.microsoft.com/products/databricks) is based on Apache Spark and integrate with open-source libraries. It provides a unified platform to run analytics workload and manages cloud infrastructure. Python, Scala, R, and SQL languages can be used to frame Extract, Transform, Load (ETL) pipelines and orchestrate jobs.
- [Azure Event Hubs]() is a real time ingestion service and can process millions of records per second. Data can be ingested from multiple sources and can be used for real time analytics. It can be easily scalable based on the volume of data.  

Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Sustainability

- Precisely Connect can scale based on the data volume and optimize data replication.
- Replicator can distribute data for parallel processing and can be balanced based on ingestion of workloads.
- Azure SQL Database Serverless can scale automatically based on the volume of workloads.
- Azure Event hub can scale based on throughput units and number of partitions.

For more information, see [Autoscaling best practices in Azure](../../best-practices/auto-scaling.md).

Resiliency

Use [Azure Monitor](https://azure.microsoft.com/services/monitor) and [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor the data migration. Set up alerts for proactive management. For more information about resiliency in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). 

- Replicating and processing data to Azure Data services could reduce the cost, instead of maintaining it in mainframe.
- Cost management tool in Azure portal will provide cost analysis view and it will help us to analyze the organization spending.
- Azure Databricks can resize the cluster with autoscaling, and it can optimize cost compared with fixed configuration.
- Azure Advisor provides recommendations to optimize performance and cost management.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:
- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan) | Senior Engineering Architect

## Next steps
- Change Data Capture with Connect
- What is Azure ExpressRoute?
- What is VPN Gateway?
- What is Azure SQL Database
- Contact us (select to create email)

## Related resources

- Modernize mainframe and midrange data
- Re-engineer mainframe batch applications on Azure
- Replicate and sync mainframe data in Azure
- Mainframe access to Azure databases
- Mainframe file replication and sync on Azure

