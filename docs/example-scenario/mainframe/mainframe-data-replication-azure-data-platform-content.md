Mainframe applications generate high volumes of transactional data. Azure is a suitable platform for modernizing these workloads and migrating their data. Azure relational and NoSQL databases provide scalability, high availability, and ease of maintenance that meets or exceeds mainframe environments. If you plan to retire a mainframe workload and keep the data in low-cost storage, Azure provides several storage options.

Migrating workloads from a mainframe to Azure as a part of application replatforming or refactoring typically requires data migration at scale. [mLogica LIBER*IRIS](https://www.mlogica.com/products/liber-m-mainframe-modernization) provides a proven solution for bulk data migration from a mainframe to Azure. The solution operates at scale for migrating enterprise workloads. This article describes how to migrate IBM z/OS mainframe data to Azure with high fidelity.

## Architecture

The following diagram shows how mLogica LIBER*IRIS integrates with Azure components to migrate mainframe data to Azure at scale.

:::image type="complex" source="./media/mlogica-mainframe-data-migration-architecture.svg" alt-text="Diagram that shows the architecture of how mLogica LIBER*IRIS integrates with Azure components to migrate mainframe data." lightbox="./media/mlogica-mainframe-data-migration-architecture.svg" border="false":::
  The diagram shows a secure connection from the mainframe environment to Azure over Azure ExpressRoute or site-to-site VPN. The diagram also shows an mLogica LIBER*IRIS migration cluster on Azure Linux virtual machines (VMs) that receives metadata files, generates extraction scripts, and returns scripts to the mainframe. The mainframe transfers extracted sequential files and SQL load scripts to Azure Blob Storage over Secure File Transfer Protocol (SFTP). The cluster transforms data from EBCDIC to ASCII and loads data into Azure SQL, Azure Database for PostgreSQL, Azure Database for MySQL, and Azure Cosmos DB. Azure Monitor, Application Insights, and Log Analytics collect telemetry and execution logs.
:::image-end:::

*mLogica LIBER\*IRIS and its logos are trademarks of its company. No endorsement is implied by the use of these marks.*

*Download a [Visio file](https://arch-center.azureedge.net/mlogica-mainframe-data-migration-architecture.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Copy data definition language (DDL) files, database description (DBD) files, copybooks, data layouts, and other data description artifacts to an Azure Linux virtual machine (VM) that runs mLogica data migration service tools. Use File Transfer Protocol Secure (FTPS) over a secure Azure site-to-site virtual private network (VPN) or Azure ExpressRoute.

1. The mLogica LIBER*IRIS data migration cluster generates data extraction scripts to run on the mainframe.

1. Use FTPS over the VPN to transfer the data extraction scripts to the mainframe. The FTPS connection converts ASCII to the mainframe EBCDIC format.

1. The extracted scripts run on the mainframe. They export data from multiple sources into sequential files, where all packed decimal data is unpacked. They generate the SQL load scripts used to load the data into the target database.

1. The system transfers the sequential files and load scripts to Azure Blob Storage by using binary Secure File Transfer Protocol (SFTP). Mainframe data remains in EBCDIC format at this step.

1. The mLogica data migration service runs the load scripts to convert EBCDIC to ASCII. The scripts write errors during load to Azure Storage. To reduce costs, you can use two storage accounts. Store data files on a hot access tier and log files on a cold access tier.

1. The scripts load the ASCII-converted data from sequential files into the target Azure relational database. The load scripts include DDL commands to create tables and other objects and SQL queries to load the data into those objects. Scale the load process horizontally across a cluster to maximize throughput as needed. Execution logs and detailed exception logs are stored in Blob Storage for further analysis.

1. The mLogica LIBER*IRIS data migration service runs the load scripts to transform data from relational file format to NoSQL database format. You can load this NoSQL data to Azure Cosmos DB by using the Azure Cosmos DB SQL API.

### Components

This solution uses the following components.

#### Networking and identity

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a virtual network gateway that sends encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, VPN Gateway provides an alternative to ExpressRoute for secure connectivity between the mainframe environment and Azure.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends on-premises networks into Azure through a connectivity provider. In this architecture, ExpressRoute provides a secure private connection to transfer data definition files and extraction scripts between the mainframe and Azure.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is an identity and access management service that can sync with an on-premises directory. In this architecture, Microsoft Entra ID provides authentication and access control for the mLogica data migration cluster and Azure resources.

#### Compute

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides on-demand, scalable computing resources. In this architecture, the mLogica data migration cluster runs on Azure Linux VMs optimized for network performance.

#### Databases and storage

- [Azure SQL](/azure/azure-sql/), [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql), and [Azure Database for MySQL](/azure/well-architected/service-guides/azure-database-for-mysql) are fully managed platform as a service (PaaS) services for SQL Server, PostgreSQL, and MySQL respectively. In this architecture, these services provide high-performance, highly available options for mainframe relational data, emulated nonrelational data, and emulated Virtual Storage Access Method (VSAM) data.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that provides low latency and elastic scalability. In this architecture, it migrates nonrelational mainframe sources like Information Management System (IMS), Integrated Database Management System (IDMS), and Adaptable Database System (ADABAS).

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud storage service that provides highly available, encrypted-at-rest, cost-efficient, high-capacity storage. In this architecture, Blob Storage supports direct binary SFTP traffic from the mainframe and can mount containers on Linux VMs by using NFS 3.0 to store sequential files and load scripts.

#### Monitoring

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring platform that collects, analyzes, and acts on telemetry from cloud and on-premises environments. In this architecture, Azure Monitor monitors the mLogica data migration cluster and sets up alerts for proactive management.

  - [Application Insights](/azure/well-architected/service-guides/application-insights) is an Azure Monitor feature that monitors application performance by collecting and analyzing telemetry. In this architecture, Application Insights monitors the mLogica data migration cluster for performance insights and diagnostics.

  - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) is an Azure Monitor feature that collects and organizes log and performance data from monitored resources. In this architecture, Azure Monitor Logs consolidates data from multiple sources into a single workspace, including platform logs from Azure services, log and performance data from VM agents, and usage and performance data from applications.

  - [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is an Azure Monitor feature that runs log queries to help you use the data collected in Azure Monitor Logs. In this architecture, Log Analytics analyzes mLogica load script execution logs that Blob Storage stores. It uses a query language to join data from multiple tables, aggregate large sets of data, and perform complex operations.

## Scenario details

This article describes how you can use the mLogica product to perform bulk data migration from a mainframe system to Azure.

### Potential use cases

This example workload supports two key use cases:

- **Workload replatforming or refactoring:** Move all mainframe data related to the workload from a mainframe to Azure. This data includes databases, like Db2, IMS, and IDMS, and files.

- **Archival:** Retire mainframe workload and retain the data in a low-cost Azure storage solution.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Follow these general recommendations unless you have a specific requirement that overrides them:

- Create all Azure resources for this scenario in a single region to reduce network latency.

- Split data into multiple files and send them to Azure in parallel, rather than sending a single large file from the mainframe.

- Use Azure Monitor and [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor the mLogica data migration cluster. Set up alerts for proactive management.


#### Availability

This example workflow describes mainframe-to-Azure data migration to replatform, refactor, or archive a workload. You typically run this discrete task a few times during a month-long project. This scenario doesn't require high availability, but you can design the mLogica data migration cluster to provide high availability.

Azure database services support zone redundancy. You can set up failover for outages and maintenance windows.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist). For general guidance on designing secure solutions, see the [Azure security documentation](/azure/security).

Database services in Azure support various security options:

- Data encryption at rest by using [transparent data encryption (TDE)](/sql/relational-databases/security/encryption/transparent-data-encryption)
  
- Data encryption in transit by using [Transport Layer Security (TLS)](/azure/azure-sql/database/security-overview#transport-layer-security-encryption-in-transit)

- Data encryption during processing by using [Always Encrypted with secure enclaves](/sql/relational-databases/security/encryption/always-encrypted-enclaves)

You can control authentication and access control on the mLogica data migration cluster by using Microsoft Entra ID. You can set up Azure resources for authentication and authorization by using Microsoft Entra ID and role-based access control (RBAC).

TLS encrypts data in transit between the mLogica data migration cluster and the mainframe. You can store TLS certificates in [Azure Key Vault](https://azure.microsoft.com/products/key-vault) for enhanced security. Secure Shell (SSH) encrypts data in transit from the mainframe to Blob Storage.

The mainframe data and load scripts are temporarily stored in Blob Storage, where they're encrypted at rest. Data is deleted from Blob Storage after the migration completes.

This example workflow uses ExpressRoute or [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal) for a private and efficient connection to Azure from your on-premises environment.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Scale, pause, and resume compute resources by using [Azure SQL Database serverless](https://azure.microsoft.com/products/azure-sql/database). It automatically adjusts compute based on workload activity so that you pay only for the resources that you use.

- Use a lifecycle management policy to move data between access tiers in Azure Blob Storage.

  Move data from a hotter access tier to a cooler one when no one accesses it for a period of time. You can also move data from a cooler access tier to an archive access tier.

- Use [Azure Advisor](https://azure.microsoft.com/products/advisor) to find underused resources. Get recommendations on how to reconfigure or consolidate resources to reduce your spending.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate Azure component costs for this solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

You can use Azure DevOps to reengineer mainframe applications on Azure during every phase of software development and team collaboration. Azure DevOps provides these services:

- [Azure Boards](https://azure.microsoft.com/products/devops/boards): Agile planning, work item tracking, visualization, and reporting.

- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines): A language, platform, and cloud-independent continuous integration and continuous delivery (CI/CD) platform that supports containers or Kubernetes.

- [Azure Repos](https://azure.microsoft.com/products/devops/repos): Cloud-hosted private Git repositories.

- [Azure Artifacts](https://azure.microsoft.com/products/devops/artifacts): Integrated package management that supports Maven, npm, Python, and NuGet package feeds from public or private sources.

- [Azure Test Plans](https://azure.microsoft.com/products/devops/test-plans): An integrated planned and exploratory testing solution.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Use the following recommendations to improve performance efficiency:

- Deploy the mLogica data migration cluster on multiple VMs if you migrate multiple large independent datasets to maximize data loading speed. You can upload multiple datasets in parallel from the mainframe to Blob Storage.

- Consider [SQL Database serverless](/azure/azure-sql/database/serverless-tier-overview) for workload-based autoscaling. You can scale other Azure databases up and down by using automation to meet your workload demands. For more information, see [Autoscaling](../../best-practices/auto-scaling.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Sandip Khandelwal](https://www.linkedin.com/in/sandip-khandelwal-64326a7) | Principal Engineering Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [Azure database migration guides](/data-migration).

For more information, contact [Azure Data Engineering - Mainframe & Midrange Modernization](mailto:datasqlninja@microsoft.com).

- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Introduction to Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [mLogica LIBER*IRIS](https://www.mlogica.com/products/liber-m-mainframe-modernization)
- [Quickstart: Create a Linux VM in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- [VMs in Azure](/azure/virtual-machines/overview)
- [Azure Cosmos DB overview](/azure/cosmos-db/overview)

## Related resources

- [Analytics end-to-end with Microsoft Fabric](../dataplate2e/data-platform-end-to-end.yml)
- [Modernize mainframe and midrange data](modernize-mainframe-data-to-azure.yml)
- [Rehost ADABAS and Natural applications in Azure](rehost-adabas-software-ag.yml)

