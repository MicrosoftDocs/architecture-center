This article describes how to use Precisely Connect to migrate mainframe and midrange systems to Azure. Connect provides real-time data replication from legacy systems to Azure by using change data capture (CDC).

This solution provides data consistency between on-premises mainframe environments and Azure while minimizing the effect on source system performance. The architecture supports various mainframe and midrange data sources and replicates data to Azure targets like Azure SQL Database, Azure Event Hubs, and Microsoft Fabric.

*Apache®, [Spark](https://spark.apache.org), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="complex" source="media/mainframe-midrange-data-replication-azure-precisely.svg" alt-text="Diagram that shows an architecture for migrating mainframe and midrange systems to Azure." lightbox="media/mainframe-midrange-data-replication-azure-precisely.svg" border="false":::
On the left, the on-premises box includes mainframe and midrange data sources like VSAM, Db2, IMS, and files. These sources connect to a box labeled logs (1) and then to a box that includes capture logs, a publisher (2), and a CDC store. A listener (3) and a controller daemon point to this box via dashed arrows. This box and an Azure controller daemon (8) point to the replicator or distributor engine (5) in Azure. The replicator or distributor engine box includes a dispatcher, cache, and nodes. A component in this box points to the on-premises controller daemon via a dashed arrow. The replicator or distributor engine points to Event Hubs (6), to Azure Databricks or Fabric (7), and then to Azure services. The Azure services box includes Azure Data Lake Storage, OneLake, Azure SQL, Azure Database for PostgreSQL, Azure Database for MySQL, Fabric, and Power BI. The on-premises environment has a data gateway and connects to Azure via Azure ExpressRoute (4).
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-midrange-data-replication-azure-precisely.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. A Connect agent component captures change logs by using mainframe or midrange native utilities and caches the logs in temporary storage.
1. For mainframe systems, a publisher component on the mainframe manages data migration.
1. For midrange systems, a listener component manages data migration instead of a publisher. The listener resides on a Windows or Linux machine.
1. The publisher or listener moves the data from on-premises to Azure via Azure ExpressRoute. The publisher or listener handles the commit and rollback of transactions for each unit of work, which maintains the integrity of data.
1. The Connect Replicator Engine captures the data from the publisher or listener and applies it to the target. It distributes data for parallel processing.
1. Event Hubs ingests real-time data changes from the Connect Replicator Engine for near-real-time processing.
1. Azure Databricks or Fabric processes the ingested data. The processed data is stored in Azure targets such as SQL Database, Azure Database for PostgreSQL Flexible Server, Azure Data Lake Storage, or Fabric lakehouses and warehouses for downstream analytics and business intelligence (BI).
1. The Connect Controller Daemon authenticates the request and establishes the socket connection between the publisher or listener and the Replicator Engine.

### Components

This architecture uses the following components.

#### Networking and identity

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks to the Azure cloud platform over a private connection from a connectivity provider. In this architecture, ExpressRoute provides a secure, high-bandwidth connection for replicating mainframe data to Azure.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway service that enables you to create virtual network gateways that send encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, you can use VPN Gateway as an alternative to ExpressRoute to connect mainframe systems to Azure when a private connection isn't available.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is an identity and access management service that can synchronize with on-premises Active Directory. In this architecture, Microsoft Entra ID manages authentication and access control for Connect components that access Azure resources.

#### Storage

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-database-for-mysql) is a managed relational database service that's based on the community edition of the open-source MySQL database engine. In this architecture, Azure Database for MySQL provides a target option for replicated mainframe data.

- [Azure Database for PostgreSQL Flexible Server](/azure/well-architected/service-guides/postgresql) is a fully managed relational database service based on the community edition of the PostgreSQL database engine. In this architecture, Azure Database for PostgreSQL Flexible Server serves as a target database for mainframe data replication.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a platform as a service (PaaS) database engine that's part of the Azure SQL family. It's built for the cloud and provides all the benefits of a managed and evergreen PaaS. SQL Database also provides AI-powered automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand. In this architecture, SQL Database serves as a target database for receiving replicated mainframe data via Open Database Connectivity (ODBC) or native database connections.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) is a cloud database service that provides all the benefits of a managed and evergreen PaaS. SQL Managed Instance has near-complete compatibility with the latest SQL Server Enterprise edition database engine. It also provides a native virtual network implementation that addresses common security concerns. In this architecture, SQL Managed Instance can serve as a target for mainframe data that requires SQL Server compatibility.

- [Azure Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data. In this architecture, Storage provides scalable storage for replicated mainframe data and temporary caching.

- [OneLake](/fabric/onelake/onelake-overview) is the unified data lake for Fabric. In this architecture, OneLake serves as storage for data ingested from Event Hubs. Use OneLake shortcuts to provide zero-copy access to data stored in Data Lake Storage or other cloud storage without duplicating data.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an analytics platform that unifies data movement, data processing, ingestion, transformation, real-time event routing, and report building. In this architecture, Fabric (lakehouses, warehouses, or SQL Database within Fabric) serves as the relational storage destination for analytics and the BI layer.

#### Analysis and reporting

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a group of business analytics tools that can deliver insights throughout your organization. Power BI can connect to hundreds of data sources, simplify data preparation, and drive unplanned analysis. In this architecture, Power BI provides BI capabilities for analyzing replicated mainframe data. Power BI is natively integrated with Fabric for unified analytics.

#### Monitoring

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring service that provides a solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. Features include Application Insights, Azure Monitor Logs, and Log Analytics. In this architecture, Azure Monitor provides monitoring and observability for the Azure services and Azure databases used as targets for the replicated mainframe data.

#### Data integrators

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks) is a unified analytics platform based on Spark that integrates with open-source libraries. It provides a collaborative workspace for running analytics workloads. You can use Python, Scala, R, and SQL languages to build extract, transform, and load (ETL) pipelines and orchestrate jobs. In this architecture, Azure Databricks processes and transforms the replicated mainframe data for consumption by Azure data platform services.

- [Fabric](/fabric/fundamentals/microsoft-fabric-overview) is an end-to-end AI-powered analytics platform that operates on a managed Spark compute platform. In this architecture, Fabric Spark ingests and transforms replicated mainframe data to make it analytics-ready for consumption by downstream Azure data platform and Fabric services.

- [Event Hubs](/azure/well-architected/service-guides/azure-event-hubs) is a real-time data ingestion service that can process millions of events per second. You can ingest data from multiple sources and use it for real-time analytics, and scale Event Hubs based on the volume of data. In this architecture, the Connect Replicator Engine pushes real-time change data from Connect into Event Hubs, which ingests it for near real-time processing and analytics.

- [Precisely Connect](https://www.precisely.com/product/precisely-connect/connect) is a data integration platform that can integrate data from multiple sources and provide real-time replication to Azure. You can use it to replicate data without making changes to your application. Connect can also improve the performance of ETL jobs. In this architecture, Connect serves as the primary data replication engine that captures and migrates mainframe data to Azure in real time. You can provision it from the [Azure Marketplace](https://marketplace.microsoft.com/product/saas/syncsort.dmx?tab=overview).

## Scenario details

You can use various strategies to migrate mainframe and midrange systems to Azure. Data migration plays a key role in this process. Organizations typically start with an initial bulk data migration from mainframe or midrange systems to the Azure data platform. After the initial migration, in a hybrid cloud architecture, you must establish ongoing data replication between mainframe or midrange systems and the Azure data platform to keep the data synchronized. To maintain the integrity of the data, you need real-time replication for business-critical applications. Connect can support the initial batch migration and long-term replication. Use CDC for real-time changes or batch ingestion for periodic transfers.

Precisely Connect supports the following mainframe and midrange data sources:

- Db2 for z/OS
- Db2 for Linux, UNIX, and Windows (LUW)
- Db2 for i (AS/400)
- IBM Information Management System (IMS)
- IBM Virtual Storage Access Method (VSAM)
- Files and copybooks

Connect converts the data into a consumable format and streams it into Event Hubs for low-latency ingestion. Azure Databricks or Fabric then processes the ingested data in near real time for downstream consumption and storage in Azure targets. These targets include SQL Database, Azure Database for PostgreSQL Flexible Server, Azure Database for MySQL Flexible Server, Data Lake Storage, and Fabric (Fabric lakehouses, Fabric warehouses, or SQL databases in Fabric). Together, this end-to-end pipeline — from CDC capture through Event Hubs ingestion to Databricks or Fabric processing — enables near real-time data availability for analytics and operational workloads. Precisely Connect also supports scalability based on data volume and customer requirements. It replicates data without affecting performance or straining the network.

### Potential use cases

- Data replication from mainframe and midrange data sources to the Azure data platform
- In a hybrid cloud architecture, data sync between mainframe or midrange systems and the Azure data platform
- Near real-time analytics on Azure, based on operational data from mainframe or midrange systems
- Migration of data from mainframe or midrange systems to Azure without requiring modifications to the source applications

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Use [Azure Monitor](/azure/azure-monitor/overview) to monitor the health and performance of Event Hubs, Azure Databricks, and target Azure databases. Use the [Monitor hub in Fabric](/fabric/admin/monitoring-hub) to monitor Fabric jobs. Configure alerts to enable proactive management during both initial data migration and ongoing near real-time replication.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Replicating data to Azure and processing in Azure services can be less expensive than maintaining data in a mainframe system.
- Use the cost analysis view in Cost Management to analyze spending. For a starting point, see the [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/a1568e2307cd4aed998b46f0a57950f2). Adjust it to match your workload.
- To optimize costs, you can use Azure Databricks to resize your cluster via autoscaling. This approach can be less expensive than a fixed configuration.
- Azure Advisor provides recommendations for optimizing performance and cost management.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Precisely Connect can scale based on the volume of data, and optimize data replication.
- The Connect Replicator Engine can distribute data for parallel processing. You can balance distribution based on the ingestion of workloads.
- SQL Database serverless can scale automatically based on the volume of workloads.
- Event Hubs can scale based on throughput units and the number of partitions. Determine the partition count based on the expected peak throughput of your CDC workload.

For more information, see [Autoscaling best practices in Azure](../../best-practices/auto-scaling.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan) | Senior Engineering Architect

Other contributor:

- [Gyani Sinha](https://www.linkedin.com/in/gyani-sinha/) | Senior Solution Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [CDC with Precisely Connect](https://www.precisely.com/resource-center/productsheets/change-data-capture-with-connect)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)

## Related resources

- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data to Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
