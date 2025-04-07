Organizations can modernize their mainframe systems to take advantage of the benefits of cloud computing. The integration of mainframe data with cloud platforms enhances scalability, performance, and cost efficiency.

BMC AMI Cloud provides a solution that transfers mainframe data directly to Azure Blob Storage. This service streamlines the migration and modernization journey for organizations.

*Apache®, [Kafka](https://kafka.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Key benefits

- **Cost-effective backup.** Use BMC AMI Cloud and Blob Storage as an efficient alternative to virtual tape libraries to help ensure faster and more economical data backups. This shift reduces costs and improves backup and recovery times, which are essential for business continuity.

- **Data transformation.** BMC AMI Cloud Analytics converts mainframe data into open formats that are compatible with various Azure services. Open formats enhance data usability and integration. This process is crucial for organizations that aim to use advanced analytics, AI, and machine learning tools on their legacy data.

- **Data protection.** BMC AMI Cloud Vault provides immutable, air-gapped copies of mainframe data in Azure storage. It protects data by providing versioning, locking, immutability, and encryption. It also provides threat protection and complies with regulatory requirements for data retention.

## Architecture

:::image type="content" source="media/bmc-ami-cloud-mainframe-midrange-data-archive-azure.svg" lightbox="media/bmc-ami-cloud-mainframe-midrange-data-archive-azure.svg" alt-text="Diagram that shows an architecture for migrating mainframe data to the cloud." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/bmc-ami-cloud-mainframe-midrange-data-archive-azure.vsdx) of this architecture.*

### Workflow

The architecture of BMC AMI Cloud integration with Azure includes several components. Each component plays an important role in the data migration and transformation process.

1. The BMC AMI Cloud agent starts a z/OS task that sends encrypted and compressed mainframe data to Blob Storage over Transmission Control Protocol/Internet Protocol (TCP/IP). This process helps ensure secure and efficient data transfer without the need for intermediate storage, which reduces latency and potential points of failure.

1. BMC AMI Cloud Management Server, a Docker-based web application, administers the cloud agents. It manages policies, activities, and storage, which helps ensure seamless data management.

1. BMC AMI Cloud Analytics converts mainframe data that's stored in Blob Storage into formats that are suitable for AI, business intelligence, and machine learning applications. BMC AMI Cloud Analytics supports conversion to CSV and JSON, and enables direct integration with Azure Databases. This capability supports a wide range of analytical and operational use cases.

## Components

Each component of BMC AMI Cloud Data is designed to optimize various aspects of the data migration and management process:

- **BMC AMI Cloud agent** is a Java-based application that runs as a started task on one or more z/OS logical partitions (LPARs). It reads and writes data directly to and from Blob Storage over TCP/IP. The BMC AMI Cloud agent uses the zIIP engine, which significantly reduces general CPU consumption. This optimization enhances mainframe performance and lowers cost. You can use multiple agents to increase scalability and resilience.

- **BMC AMI Cloud Management Server** is a web application that runs in a Docker container that manages the web UI and communication with z/OS agents. It provides a way to define policies for data protection, data migration, and data archival. These policies help ensure that data management aligns with organizational requirements and compliance standards. For superior availability, deploy this application on Azure Virtual Machines within your virtual network.

- The **lifecycle management engine** is a Java-based application that runs on-premises on a z/OS LPAR. It deletes expired data from object storage and z/OS. This process automates data lifecycle management and helps ensure that storage resources are used efficiently.

- The **data management command-line interface (CLI)** is a CLI that runs on z/OS LPARs. Users can perform backup, restore, archive, recall, and delete actions to and from Blob Storage by using the CLI. The CLI provides flexibility and control over data management tasks and enables integration with existing workflows and scripts.

- **BMC AMI Cloud Analytics** is a Docker-based application that transforms BMC AMI Cloud-managed objects into open formats that AI, business intelligence, and machine learning applications can process. This capability allows organizations to unlock the value of their mainframe data by making it accessible to modern analytical tools.

### Networking and identity

Secure and reliable connectivity between on-premises mainframe systems and Azure cloud services is crucial for the success of any modernization effort.

- **[Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute)** provides a private and reliable connection to Azure services. This connection delivers superior performance and enhanced security compared to public internet connections. It helps you transfer mainframe data from on-premises environments to Azure via a private connection. This service is ideal for organizations that have stringent data sovereignty requirements.

- **[Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways)** sends encrypted traffic between Azure Virtual Network and on-premises locations over the public internet. You can deploy this solution for scenarios where you can't use a dedicated private connection to transfer the mainframe data to Azure.

- **[Microsoft Entra ID](/entra/fundamentals/whatis)** synchronizes with Windows Server Active Directory for identity and access management. Microsoft Entra ID supports single sign-on and multifactor authentication, which enhances security and user experience. It helps ensure encrypted data transmission between the BMC AMI Cloud agent and Blob Storage. You can manage and administer the permissions by using role-based access control.

### Databases and storage

The mainframe data is migrated to Azure Storage through the BMC AMI Cloud agent. You can integrate the data in Storage with any of the following Azure database services by using BMC AMI Cloud Analytics.

- **[Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework)** is a fully managed, scalable database service that has AI-powered features for performance and durability optimization. It supports serverless compute and Hyperscale storage options, automatically scaling resources on demand.

- **[Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql)** is a fully managed, relational database service that's based on the community edition of the open-source PostgreSQL database engine. You can use Azure Database for PostgreSQL to focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- **[Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization)** is a fully managed, relational database service that's based on the community edition of the open-source MySQL database engine.

- **[Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability)** is an intelligent, scalable cloud database service that provides all the benefits of a fully managed and evergreen platform as a service. SQL Managed Instance offers near-complete compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.

- **[Azure Synapse Analytics](/azure/synapse-analytics/overview-what-is)** is a fast and flexible cloud data warehouse that helps you scale, compute, and store data elastically and independently, with a massively parallel processing architecture.

- **[Storage](/azure/well-architected/service-guides/storage-accounts/reliability)** is a comprehensive cloud storage solution that includes object, file, disk, queue, and table storage. Storage supports hybrid storage solutions and provides tools for data transfer, sharing, and backup. It also provides scalable backup and archival solutions for the migrated mainframe data.

### Analysis and monitoring

Effective monitoring and analysis are essential for maintaining the health and performance of cloud-based systems:

- **[Power BI](/power-bi/fundamentals/power-bi-overview)** is a suite of business analytics tools that connect to hundreds of data sources, which simplifies data preparation and drives improvised analysis. Power BI can access the migrated data in Storage or Azure databases to create interactive reports that provide insights and dashboards.
  
- **[Azure Monitor](/azure/azure-monitor/)** provides a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes features such as Application Insights, Azure Monitor Logs, and Log Analytics. These features enable proactive monitoring and problem resolution. You can monitor and analyze the metrics during data migration from the mainframe to Storage by using Azure Monitor.

### Implementation alternatives

You can choose between on-premises and cloud deployment options based on your specific needs and constraints:

- **On-premises deployment.** You can install BMC AMI Cloud Management Server on-premises on z/OS Container Extensions (zCX) or on a Linux virtual instance. This installation provides flexibility for organizations that have regulatory or latency requirements.

- **Data transformation service.** BMC AMI Cloud Analytics can operate externally to the mainframe in an on-premises environment. It can also be deployed in the cloud by using server instances or container services, which enhances resource usage and performance.

## Use cases

This architecture is suitable for various use cases.

- **Mainframe data accessibility:** Make mainframe data available to Azure data services, AI, machine learning, analytics, and business intelligence tools.
  
- **Data protection:** Back up and archive mainframe data to Blob Storage to help ensure data availability and durability.
  
- **Direct data integration:** Enable mainframe applications to write and read data directly to and from Blob Storage to streamline workflows and reduce latency.
  
- **Cybersecurity:** Protect mainframe data against cyberattacks by creating an immutable third copy in Azure to enhance data security and compliance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan/) | Senior Engineering Architect

Other contributors:
- [Pratim Dasgupta](https://www.linkedin.com/in/pratimdasgupta/) | Senior Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architect Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [BMC AMI Cloud data management for mainframe](https://www.bmc.com/it-solutions/bmc-ami-cloud.html)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Introduction to Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-introduction)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Azure Synapse Analytics?](/azure/synapse-analytics/overview-what-is)
- [What is Azure Database for PostgreSQL?](/azure/postgresql/overview)
- [What is Azure Database for MySQL?](/azure/mysql/overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- For more information, contact the [Mainframe Data Modernization team](mailto:mainframedatamod@microsoft.com)

## Related resources

- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
