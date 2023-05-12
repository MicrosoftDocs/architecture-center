This article describes how to use Model9 Manager to send mainframe data directly to Azure Blob Storage as part of a mainframe modernization migration.

You can use Model9 Shield together with Azure Blob Storage as an alternative to virtual tape library (VTL) to back up data in a faster and more cost-effective way.

Model9 Gravity transforms mainframe data that's transferred to Azure Blob Storage into open formats that can feed into other Azure services.

*Apache®, [Kafka](https://kafka.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="media/model9-mainframe-midrange-data-archive-azure.png" alt-text="Diagram that shows an architecture for migrating mainframe data to the cloud." lightbox="media/model9-mainframe-midrange-data-archive-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/model9-mainframe-midrange-data-archive-azure.vsdx) of this architecture.*

### Workflow

1.	The Model9 agent acts as an interface for data migration between z/OS and Azure. 
2.	The Model9 agent sends the data, which is encrypted, to Azure Blob Storage over TCP/IP.
3.	 Model9 management server manages Model9 policies, activities, and storage.
4.	Model9 Gravity transforms mainframe data in Azure Blob Storage into open formats that can be used by Azure services.

### Components

This solution uses the following components.

#### Model9 cloud data platform components

The main components of Model9 cloud data platform are:

- **Model9 agent**. A Java-based application that runs as a started task on one or more z/OS logical partitions (LPARs). It reads and writes data directly from and to Azure Blob Storage over TCP/IP. The Model9 agent can run on zIIP engines, which dramatically reduces general CPU consumption.

- **Model9 management server**. A web application that runs in a Docker container. It manages the web UI and the communication with z/OS agents. It provides a way for you to define several types of policies for data protection, migration, and data archival.

- **Lifecycle management engine**. A Java-based application that runs on-premises on a z/OS LPAR and deletes expired data both from the object storage and from z/OS.

- **Data management command-line interface (CLI)**. A CLI that runs on z/OS LPAR. You can use it to perform backup, restore, archive, recall, and delete resource-based actions to and from Azure Blog Storage.

- **Gravity**. A Docker-based application that supports the transformation of Model9 managed objects into an open format that gets processed by AI, business intelligence, and machine learning applications. The data can be transformed either to a CSV or JSON file, or directly to Azure Database for SQL.

#### Networking and identity

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends your on-premises networks into cloud services that are offered by Microsoft over a private connection from a connectivity provider. With ExpressRoute, you can establish connections to cloud components such as Azure services and Microsoft 365.

- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) is a specific type of virtual network gateway that sends encrypted traffic between Azure Virtual Network and an on-premises location over the public internet.

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is an identity and access management service that synchronizes with an on-premises active directory.

#### Application

- [Apache Kafka](https://kafka.apache.org) is an open-source distributed event-streaming platform that's used for high-performance data pipelines, streaming analytics, data integration, and business-critical applications.

#### Storage

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is part of the Azure SQL family and is built on the cloud. This service offers all the benefits of a fully managed and evergreen platform as a service (PaaS). Azure SQL Database also provides AI-powered, automated features that optimize performance and durability. Serverless compute and Hyperscale storage options automatically scale resources on demand.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is a fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql) is a fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance) is an intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has nearly 100 percent compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a fast and flexible cloud data warehouse that helps you scale, compute, and store elastically and independently, with a massively parallel processing architecture.

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a cloud storage solution that includes object, file, disk, queue, and table storage. Services include hybrid storage solutions and tools for transferring, sharing, and backing up data.

#### Analysis and reporting

- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. By using Power BI, you can connect to hundreds of data sources, simplify data preparation, and drive ad hoc analysis. You can produce beautiful reports, then publish them for your organization to consume on the web, and across mobile devices.

#### Monitoring

- [Azure Monitor](https://azure.microsoft.com/services/monitor) delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It contains the Application Insights, Azure Monitor Logs, and Azure Log Analytics features.

- Model9 supports monitoring the status and results of all activities via the **Activities** page in the Model9 UI. For more information, see [Monitoring Activities](https://docs.model9.io/user-and-administrator-guide/monitoring-activities).

### Alternatives

- Instead of installing the Model9 management server in the cloud on Azure Virtual Network, you can install it on-premises. On a Linux or z/Linux OS, you can also install the management server on z/OS Container Extensions (zCX).

- Model9 data transformation service runs externally to the mainframe in an on-premises environment. This setup saves expensive mainframe resources. You can also deploy on the cloud by using either a server instance or container services.

- ExpressRoute provides a private and efficient connection to Azure from on-premises, but you can also use [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal).

## Scenario details

Mainframe data that's stored in physical or virtual tape libraries is critical for customers. As this data grows, its volume can require a significant amount of storage. The data can then become more demanding to maintain on-premises. You can easily migrate this data to Azure storage and use it for AI, business intelligence, machine learning, and analytics applications. Azure storage carries several unique benefits over traditional on-premises storage approaches, and includes data management services, scalability, performance, reliability, and security.

Model9 provides an end-to-end suite of cloud data management solutions for mainframes that solves the migration problem — elegantly, cost effectively, and with no application changes. Based on a unique, proven technology, Model9 solutions migrate mainframe data by using secure and expedited technology to access the Azure cloud.

Model9 solutions are designed to save expensive mainframe CPU resources by using the mainframe zIIP engines and to connect the mainframe data to Azure cloud storage. Cloud applications can use the migrated data in Azure storage services. This article outlines a solution for migrating mainframe data to the cloud. Besides Model9, the solution's core components include Azure storage and database services.

### Potential use cases

Model9 offers a suite of services that are based on the Model9 cloud data platform. These services are suitable for the following use cases:

- Make mainframe data available to Azure data services, AI, machine learning, analytics, and business intelligence tools.

- Protect mainframe data with backup and archive to Azure Blob Storage.

- Have mainframe applications write and read data directly to and from Blob Storage.

- Protect mainframe data against cyberattacks by creating an immutable third copy in Azure.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Deploy Model9 cloud data manager in the cloud on Azure Virtual Machines, and on the customer's virtual network for superior availability.

- Deploy an agent in each z/OS LPAR to allow better availability across the systems complex (*sysplex*), or the mainframe cluster.

- Combine the Application Insights and Log Analytics features of Monitor to stay informed about the health of Azure resources.

- For guidance on resiliency in Azure, see [Design reliable Azure applications](/azure/architecture/framework/resiliency/app-design).
Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Authenticate Azure resources by using Azure AD. Manage permissions by using role-based access control (RBAC).

- Model9 uses the z/OS Security Authorization Facility (SAF) for authentication of actions. The traffic between the Model9 agent and Azure Blob Storage is encrypted. 

- The security options in Azure database services are:

    * Data encryption at rest.
    * Dynamic data masking.
    * Always-encrypted database.

- For general guidance on designing secure solutions, see [Azure security documentation](/azure/security).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Use multiple agents to increase scalability and throughput on all the LPARs within the same sysplex.

- Use multiple transformation instances behind a load balancer to increase scalability and performance.

- Blob Storage is a scalable system for storing backups, archival data, secondary data files, and other unstructured digital objects.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan/) | Senior Engineering Architect

Other contributors:

* [Pratim Dasgupta](https://www.linkedin.com/in/pratimdasgupta/) | Senior Engineering Architect 
* [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architect Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Model9 Cloud data management for Mainframe](https://model9.io)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Introduction to Azure data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Azure Database for PostgreSQL?](/azure/postgresql/overview)
- [What is Azure Database for MySQL?](/azure/mysql/overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- For more information, contact [Mainframe Modernization](mailto:mainframedatamod@microsoft.com)

## Related resources

- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)