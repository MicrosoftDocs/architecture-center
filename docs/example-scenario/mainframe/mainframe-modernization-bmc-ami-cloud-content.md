Organizations can modernize their mainframe systems to take advantage of the benefits of cloud computing. The integration of mainframe data with cloud platforms enhances scalability, performance, and cost efficiency.

BMC Automated Mainframe Intelligence (AMI) Cloud provides a solution that transfers mainframe data directly to Azure Blob Storage. This service automates key steps in the migration and modernization journey.

*Apache®, [Kafka](https://kafka.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Key benefits

- **Cost-effective backup:** Use BMC AMI Cloud with Blob Storage as an efficient alternative to virtual tape libraries to help ensure faster and more economical data backups. This shift reduces costs and improves backup and recovery times, which are essential for business continuity.

- **Data transformation:** BMC AMI Cloud Analytics converts mainframe data into open formats that are compatible with various Azure services. Open formats enhance data usability and integration. This process is crucial for organizations that intend to use advanced analytics, AI, and machine learning tools on their legacy data.

- **Data protection:** BMC AMI Cloud Vault provides immutable, air-gapped copies of mainframe data in Azure Storage. It protects data by providing versioning, locking, immutability, and encryption. It also provides threat protection and complies with regulatory requirements for data retention.

## Architecture

:::image type="complex" border="false" source="media/bmc-ami-cloud-mainframe-midrange-data-archive-azure.svg" alt-text="Diagram that shows an architecture for migrating mainframe data to the cloud." lightbox="media/bmc-ami-cloud-mainframe-midrange-data-archive-azure.svg":::
   The diagram shows the integration of BMC AMI Cloud with Azure. It also shows secure data transfer, transformation, storage, and analytics integration between mainframe and Azure services. Mainframe systems transfer encrypted and compressed data via BMC AMI Cloud agents to Blob Storage over Transmission Control Protocol/Internet Protocol (TCP/IP). The architecture includes BMC AMI Cloud Management Server for policy and agent management, a life cycle management engine for automated data retention, and a command-line interface (CLI) for data operations. Data in Blob Storage is transformed by BMC AMI Cloud Analytics into open formats for use with Azure services (Azure SQL, Azure Database for MySQL, Azure Database for PostgreSQL, and Kafka) and Microsoft Fabric (which contains OneLake and Power BI). A double-sided arrow connects the Azure services section to Microsoft Fabric, and OneLake shortcuts provide connectivity from Microsoft Fabric back to Azure Blob Storage. Connectivity options include Azure ExpressRoute and Azure VPN Gateway. Microsoft Entra ID provides identity and access management.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/bmc-ami-cloud-mainframe-midrange-data-archive-azure.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. The BMC AMI Cloud agent starts a z/OS task that sends encrypted and compressed mainframe data to Blob Storage over Transmission Control Protocol/Internet Protocol (TCP/IP). This process helps ensure secure and efficient data transfer without the need for intermediate storage, which reduces latency and potential points of failure.

1. BMC AMI Cloud Management Server, a Docker-based web application, administers the cloud agents. It manages policies, activities, and storage to help ensure cohesive data management.

1. BMC AMI Cloud Analytics transforms mainframe data stored in Blob Storage into formats optimized for AI, business intelligence (BI), and machine learning applications. It supports conversion to CSV and JSON and allows direct integration with Microsoft databases. This capability supports a wide range of analytical and operational use cases.

### Components

Every component of BMC AMI Cloud Data is designed to optimize various aspects of the data migration and management process:

- BMC AMI Cloud agent is a Java-based application that runs as a started task on one or more z/OS logical partitions (LPARs). It reads and writes data directly to and from Blob Storage over TCP/IP. The BMC AMI Cloud agent uses the zIIP engine, which significantly reduces general CPU consumption. This optimization enhances mainframe performance and reduces cost. You can use multiple agents to increase scalability and resilience. In this architecture, BMC AMI Cloud agent serves as the primary data transfer mechanism that securely moves mainframe data to Storage.

- BMC AMI Cloud Management Server is a web application that runs in a Docker container that manages the web user interface (UI) and communication with z/OS agents. It provides a way to define policies for data protection, data migration, and data archival. These policies help ensure that data management aligns with organizational requirements and compliance standards. For high availability, deploy this application on Azure Virtual Machines within your virtual network. In this architecture, BMC AMI Cloud Management Server acts as the central control plane for managing data migration policies and monitoring agent activities.

- The life cycle management engine is a Java-based application that runs on-premises on a z/OS LPAR. It removes expired data from both object storage and z/OS. This process automates data life cycle management and helps ensure that storage resources are used efficiently. In this architecture, the life cycle management engine automates data retention policies to optimize storage costs and support compliance.

- The data management command-line interface (CLI) is a CLI that runs on z/OS LPARs. Users can perform backup, restore, archive, recall, and delete actions to and from Blob Storage by using the CLI. The CLI provides flexibility and control over data management tasks and enables integration with existing workflows and scripts. In this architecture, the data management CLI provides administrators with direct command-line control over data operations between mainframe and Storage.

- BMC AMI Cloud Analytics is a Docker-based application that transforms BMC AMI Cloud-managed objects into open formats that AI, BI, and machine learning applications can process. It lets organizations extract value from their mainframe data by making it available to modern analytical tools. In this architecture, BMC AMI Cloud Analytics integrates mainframe data with Azure analytics services by converting it into formats compatible with modern data platforms.

#### Networking and identity

Secure and reliable connectivity between on-premises mainframe systems and Azure cloud services is crucial for the success of any modernization effort.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that provides a private and reliable connection to Azure services. This connection delivers superior performance and enhanced security compared to public internet connections. In this architecture, ExpressRoute helps you transfer mainframe data from on-premises environments to Azure via a private connection. This approach is ideal for organizations that have stringent data sovereignty requirements.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that sends encrypted traffic between Azure Virtual Network and on-premises locations over the public internet. In this architecture, you can deploy VPN Gateway for scenarios where you can't use a dedicated private connection to transfer the mainframe data to Azure.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that synchronizes with on-premises directories. It supports single sign-on (SSO) and multifactor authentication to enhance both security and user experience. In this architecture, Microsoft Entra ID helps ensure secure authentication and access control for BMC AMI Cloud components. You can manage and administer the permissions by using Azure role-based access control (Azure RBAC).

#### Databases and storage

The mainframe data is migrated to Storage through the BMC AMI Cloud agent. You can integrate the data in Storage with any of the following Microsoft database services by using BMC AMI Cloud Analytics.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is a managed, relational database service that's based on the community edition of the open-source PostgreSQL database engine. You can use Azure Database for PostgreSQL to focus on application innovation instead of database management. You can also scale your workload efficiently and with minimal operational overhead. In this architecture, you can integrate mainframe data with Azure Database for PostgreSQL through BMC AMI Cloud Analytics.

- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed, relational database service that's based on the community edition of the open-source MySQL database engine. In this architecture, you can integrate mainframe data with Azure Database for MySQL through BMC AMI Cloud Analytics.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a managed, scalable database service that has AI-powered features for performance and durability optimization. It supports serverless compute and Hyperscale storage options and automatically scales resources on demand. In this architecture, you can integrate mainframe data in Storage with SQL Database by using BMC AMI Cloud Analytics.

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is an intelligent, scalable cloud database service that provides all the benefits of a managed and evergreen platform as a service (PaaS). SQL Managed Instance provides near-complete compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns. In this architecture, you can integrate mainframe data with SQL Managed Instance through BMC AMI Cloud Analytics.

- [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) is an end-to-end data analytics platform that unifies data movement, data science, real-time analytics, and BI into a single software as a service (SaaS) experience. In this architecture, Fabric enables advanced analytics and BI by integrating mainframe data transformed in Azure into a unified data platform.

  Each Fabric tenant is automatically provisioned with a single logical data lake, known as OneLake. OneLake is a unified data lake built on Azure Data Lake Storage that supports both structured and unstructured data.

  You can use [shortcuts](/fabric/onelake/onelake-shortcuts) to integrate mainframe data with a Fabric lakehouse or warehouse for advanced analytics and data warehousing through BMC AMI Cloud Analytics.

- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud storage solution that includes object, file, disk, queue, and table storage. Azure Storage supports hybrid storage solutions and provides tools for data transfer, sharing, and backup. It also provides scalable backup and archival solutions for the migrated mainframe data. In this architecture, Storage serves as the primary destination for mainframe data transferred by BMC AMI Cloud agents.

#### Analysis and monitoring

Effective monitoring and analysis are essential for maintaining the health and performance of cloud-based systems:

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring service that provides a solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes features like Application Insights, Azure Monitor Logs, and Log Analytics. These features enable proactive monitoring and problem resolution. In this architecture, you can monitor and analyze the metrics during data migration from the mainframe to Storage by using Azure Monitor.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a group of business analytics tools that connect to hundreds of data sources, which simplifies data preparation and drives unplanned analysis.

  In this architecture, Power BI serves as the analytical layer. It connects to mainframe-migrated data distributed across storage and database systems. Through [Data Lake Storage](/fabric/onelake/create-adls-shortcut) or [Blob Storage](/fabric/onelake/create-blob-shortcut) shortcuts, Power BI uses [Direct Lake](/fabric/fundamentals/direct-lake-overview) mode to build high-performance semantic models that deliver near real-time insights directly from the data lake. In parallel, data migrated to Azure databases can be consumed by using DirectQuery or Import modes. This dual-query approach provides flexibility to balance performance, scale, and freshness. After these semantic models are established, interactive reports and dashboards can be developed by using live connections, which enables consistent, governed access to data across the organization.

## Implementation alternatives

You can choose between on-premises and cloud deployment options based on your specific needs and constraints:

- **On-premises deployment:** You can install BMC AMI Cloud Management Server on-premises on z/OS Container Extensions (zCX) or on a Linux virtual instance. This installation provides flexibility for organizations that have regulatory or latency requirements.

- **Data transformation service:** BMC AMI Cloud Analytics can operate externally to the mainframe in an on-premises environment. It can also be deployed in the cloud by using server instances or container services, which enhances resource usage and performance.

## Use cases

This architecture is suitable for various use cases:

- **Mainframe data availability:** Make mainframe data available to Azure data services, AI, machine learning, analytics, and BI tools.
  
- **Data protection:** Back up and archive mainframe data to Blob Storage to help ensure data availability and durability.
  
- **Direct data integration:** Enable mainframe applications to write and read data directly to and from Blob Storage to optimize workflows and reduce latency.
  
- **Cybersecurity:** Protect mainframe data against cyberattacks by creating an immutable third copy in Azure to enhance data security and compliance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan/) | Senior Engineering Architect

Other contributors:

- [Pratim Dasgupta](https://www.linkedin.com/in/pratimdasgupta/) | Senior Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architect Manager
- [Raphael Sayegh](https://www.linkedin.com/in/raphael-sayegh/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [BMC AMI Cloud data management for mainframe](https://www.bmc.com/it-solutions/bmc-ami-cloud.html)
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Introduction to Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [What is Azure Database for PostgreSQL?](/azure/postgresql/flexible-server/service-overview)
- [What is Azure Database for MySQL?](/azure/mysql/flexible-server/overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- For more information, contact the [Mainframe Data Modernization team](mailto:mainframedatamod@microsoft.com).

## Related resources

- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Reengineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data to Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
