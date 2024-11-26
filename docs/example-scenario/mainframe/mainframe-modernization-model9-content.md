In today's rapidly evolving technological landscape, modernizing mainframe systems is crucial for organizations to leverage the benefits of cloud computing. The integration of mainframe data with cloud platforms offers enhanced scalability, performance, and cost efficiency

BMC AMI Cloud provides a robust solution for transferring mainframe data directly to Azure Blob Storage, facilitating a seamless migration and modernization journey.

*Apache®, [Kafka](https://kafka.apache.org/), and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

### Key Benefits

- **Cost-Effective Backup:** Utilize BMC AMI Cloud and Azure Blob Storage as an efficient alternative to virtual tape libraries (VTL), ensuring faster and more economical data backups. This shift not only reduces costs but also improves backup and recovery times, essential for business continuity.
- **Data Transformation:** BMC AMI Cloud Analytics converts mainframe data into open formats compatible with various Azure services, enhancing data usability and integration. This transformation is vital for organizations aiming to employ advanced analytics, AI, and machine learning tools on their legacy data.
- **Data Protection:** BMC AMI Cloud vault provides immutable copies of mainframe data in Azure storage and air gapped. It protects data by versioning, locking, immutability and encryption. It provides cyber threat protection and complies with regulatory requirements for data retention.

### Architecture

:::image type="content" source="media/model9-mainframe-midrange-data-archive-azure.png" alt-text="Diagram that shows an architecture for migrating mainframe data to the cloud." lightbox="media/model9-mainframe-midrange-data-archive-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/model9-mainframe-midrange-data-archive-azure.vsdx) of this architecture.*

### Architecture Workflow

The architecture of BMC AMI Cloud integration with Azure encompasses several components, each playing a pivotal role in the data migration and transformation process. Understanding these components is essential for effective implementation and optimization.

1.	**BMC AMI Cloud Agent:** This is a z/OS started task that sends encrypted and compressed mainframe data to Azure Blob Storage over TCP/IP. It ensures secure and efficient data transfer without the need for intermediate storage, thus reducing latency and potential points of failure.
2.	**BMC AMI Cloud Management Server:** This server manages policies, activities, and storage, ensuring seamless data management. It is a Docker-based web application that facilitates the administration of multiple agents and policies from a centralized interface.
3.	**BMC AMI Cloud Analytics:** This component transforms mainframe data stored in Azure Blob Storage into formats suitable for AI, business intelligence, and machine learning applications. It supports conversion to CSV, JSON, or direct integration with Azure Databases, enabling a wide range of analytical and operational use cases.


### Components

Each component of the BMC AMI Cloud Data is designed to optimize various aspects of the data migration and management process:

- **BMC AMI Cloud Agent:** A Java-based application that runs as a started task on one or more z/OS logical partitions (LPARs). It reads and writes data directly to and from Azure Blob Storage over TCP/IP. The BMC AMI Cloud Agent utilizes the zIIP engines, which dramatically reduces general CPU consumption, thereby optimizing mainframe performance and cost.

- **BMC AMI Cloud Management Server:** A web application running in a Docker container that manages the web UI and communication with z/OS agents. It provides a way to define policies for data protection, migration, and archival, ensuring that data management aligns with organizational requirements and compliance standards.

- **Lifecycle management engine:** A Java-based application that runs on-premises on a z/OS LPAR. It deletes expired data from both object storage and z/OS, automating data lifecycle management and ensuring that storage resources are used efficiently.

- **Data management command-line interface (CLI):** This command-line interface runs on z/OS LPARs and allows users to perform backup, restore, archive, recall, and delete actions to and from Azure Blob Storage. The CLI provides flexibility and control over data management tasks, enabling integration with existing workflows and scripts.

- **BMC AMI Cloud Analytics:** A Docker-based application that transforms BMC AMI Cloud-managed objects into open formats that can be processed by AI, business intelligence, and machine learning applications. This capability allows organizations to unlock the value of their mainframe data by making it accessible to modern analytical tools.

### Networking and identity

Ensuring secure and reliable connectivity between on-premises mainframe systems and Azure cloud services is crucial for the success of any modernization effort:

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) provides a private, reliable connection to Azure services, offering superior performance and security compared to public internet connections. It is ideal for organizations with stringent data sovereignty and compliance requirements.

- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) sends encrypted traffic between Azure Virtual Network and on-premises locations over the public internet. This solution is suitable for scenarios where a dedicated private connection is not feasible.

- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory) synchronizes with on-premises Active Directory for identity and access management. Azure AD supports single sign-on (SSO) and multi-factor authentication (MFA), enhancing security and user experience.

### Storage

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database): A fully managed, scalable database service with AI-powered features for performance and durability optimization. It supports serverless compute and Hyperscale storage options, automatically scaling resources on demand.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql): A fully managed relational database service that's based on the community edition of the open-source PostgreSQL database engine. With this service, you can focus on application innovation instead of database management. You can also scale your workload quickly and easily.

- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql): A fully managed relational database service that's based on the community edition of the open-source MySQL database engine.

- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/managed-instance): An intelligent, scalable cloud database service that offers all the benefits of a fully managed and evergreen PaaS. SQL Managed Instance has nearly 100 percent compatibility with the latest SQL Server (Enterprise Edition) database engine. This service also provides a native virtual network implementation that addresses common security concerns.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics): A fast and flexible cloud data warehouse that helps you scale, compute, and store elastically and independently, with a massively parallel processing architecture.

- [Azure Storage](https://azure.microsoft.com/product-categories/storage): A comprehensive cloud storage solution that includes object, file, disk, queue, and table storage. Azure Storage supports hybrid storage solutions and offers tools for data transfer, sharing, and backup.

### Analysis and monitoring

Effective monitoring and analysis are essential for maintaining the health and performance of cloud-based systems:

- [Power BI](https://powerbi.microsoft.com): A suite of business analytics tools that connect to hundreds of data sources, simplifying data preparation and driving ad hoc analysis. Power BI allows users to create interactive reports and dashboards, providing insights throughout the organization.
  
- [Azure Monitor](https://azure.microsoft.com/en-us/products/monitor): Delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It includes features such as Application Insights, Azure Monitor Logs, and Azure Log Analytics, enabling proactive monitoring and issue resolution.

### Implementation Alternatives

Organizations can choose between on-premises and cloud deployment options based on their specific needs and constraints:

- **On-Premises Deployment:** BMC AMI Cloud Management Server can be installed on-premises on z/OS Container Extensions (zCX) or on a Linux virtual instance, offering flexibility for organizations with regulatory or latency requirements.
 
- **Data Transformation Service:** AMI Cloud Analytics service can run externally to the mainframe in an on-premises environment or be deployed in the cloud using server instances or container services, optimizing resource usage and performance.

### Use Cases

BMC AMI Cloud offers a suite of services that are suitable for various use cases:

- **Mainframe Data Accessibility:** Make mainframe data available to Azure data services, AI, machine learning, analytics, and business intelligence tools.
  
- **Data Protection:** Backup and archive mainframe data to Azure Blob Storage, ensuring data availability and durability.
  
- **Direct Data Integration:** Enable mainframe applications to write and read data directly to and from Blob Storage, streamlining workflows and reducing latency.
  
- **Cybersecurity:** Protect mainframe data against cyberattacks by creating an immutable third copy in Azure, enhancing data security and compliance.

### Considerations

Implementing BMC AMI Cloud solutions involves several key considerations aligned with the Azure Well-Architected Framework:

- **Cost Optimization:** Use the Azure pricing calculator to estimate the cost of implementing this solution, focusing on reducing unnecessary expenses and improving operational efficiencies.
  
- **Reliability:** Deploy BMC AMI Cloud Server on Azure Virtual Machines and on the customer's virtual network for superior availability. Use multiple agents and Analytics instances to increase scalability and resilience.
  
- **Security:** Authenticate Azure resources using Azure AD and manage permissions with role-based access control (RBAC). Ensure encrypted data transmission between the BMC AMI Cloud agent and Azure Blob Storage.
  
- **Performance Efficiency:** Scale operations with multiple agents and transformation instances, and leverage Azure Blob Storage for scalable backup and archival solutions.

### Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Seetharaman Sankaran](https://www.linkedin.com/in/seetharamsan/) | Senior Engineering Architect

Other contributors:

- [Pratim Dasgupta](https://www.linkedin.com/in/pratimdasgupta/) | Senior Engineering Architect
- [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architect Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

### Next steps

- [BMC AMI Cloud data management for Mainframe](https://www.bmc.com/it-solutions/bmc-ami-cloud.html)
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

### Related resources

- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
- [Re-engineer mainframe batch applications on Azure](../../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)
- [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Mainframe file replication and sync on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
