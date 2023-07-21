The high volume of transactions for mainframe applications creates a large volume of data. Azure offers a compelling target for mainframe modernization and data migration. Azure relational and NoSQL databases provide scalability, high availability, and ease of maintenance that meets or exceeds that of mainframe environments. If you want to retire a mainframe workload and retain the data in a low-cost storage, Azure provides options.

Migrating workloads from mainframe to Azure as a part of application replatforming or refactoring typically requires data migration at scale. [mLogica's LIBER*IRIS](https://www.mlogica.com/products/liber-m-mainframe-modernization) provides a proven solution for bulk data migration from a mainframe to Azure. The solution operates at scale for migrating enterprise workloads. This article shows how to migrate IBM z/OS mainframe data with high fidelity to Azure.

*mLogica LIBER\*IRIS and its logos are trademarks of its company. No endorsement is implied by the use of these marks.*

## Architecture

The following diagram shows how mLogica LIBER*IRIS integrates with Azure components to migrate mainframe data to Azure at scale.

:::image type="content" source="media/mlogica-mainframe-data-migration-architecture.svg" alt-text="Architecture diagram shows the architecture of how mLogica LIBER*IRIS integrates with Azure components to migrate mainframe data." lightbox="media/mlogica-mainframe-data-migration-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mlogica-mainframe-data-migration-architecture.vsdx) of this architecture.*

### Workflow

The steps to migrate mainframe data to Azure are as follows:

1. Copy data definition language (DDL) files, database description (DBD) files, copybooks, data layouts, and other data description artifacts to an Azure Linux virtual machine configured with the mLogica data migration service tools using FTPS over a secure Azure site-to-site virtual private network (VPN) or Azure ExpressRoute.
2. The mLogica Liber*IRIS data migration cluster generates data extraction scripts to run on the mainframe.
3. Use FTPS over the VPN to transfer the data extraction scripts to the mainframe. The FTPS connection converts ASCII to the mainframe EBCDIC format.
4. The extracted scripts run on the mainframe. They export data from multiple sources into *sequential files*, where all packed decimal data is unpacked. They generate the SQL *load scripts* used to load the data into the target database.
5. The sequential files and load scripts are transferred by using binary SFTP to Azure Blob Storage. Mainframe data is still in EBCDIC format at this point.
6. The mLogica data migration service runs the load scripts to convert EBCDIC to ASCII. The scripts write errors during load to Azure Storage. To reduce costs, you can use two storage accounts: store data files on a hot access tier and log files on a cold access tier.
7. The scripts load the ASCII converted data from sequential files into the target Azure relational database. The load scripts include DDL commands to create tables and other objects and SQL queries to load the data into those objects. Scale the load process horizontally across a cluster to maximize throughput, as needed. Execution logs and detailed exception logs are stored in Azure Blob Storage for further analysis.
8. The mLogica Liber*IRIS data migration service runs the load scripts to transform data from relational file format to NoSQL database format. You can load this NoSQL data to Azure Cosmos DB by using the Azure Cosmos DB SQL API.

### Components

- Networking and Identity

  - [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute) lets you extend your on-premises networks into Azure over a private connection by using a connectivity provider.
  - [Azure VPN Gateway](https://azure.microsoft.com/products/vpn-gateway) is a virtual network gateway used to send encrypted traffic between an Azure virtual network and an on–premises location over the internet.
  - [Azure Active Directory (Azure AD)](https://azure.microsoft.com/products/active-directory) is an identity and access management service that can be synchronized with an on-premises directory.

- Application

  - [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) provides on–demand, scalable computing resources. The mLogica data migration cluster runs on Azure Linux virtual machines optimized for network performance.

- Storage

  - [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) offers a highly available, encrypted-at-rest, cost-efficient, high-capacity storage facility. It enables direct binary SFTP traffic from the mainframe. Blob Storage can mount containers on Linux virtual machines by using NFS.
  - [Azure SQL](https://azure.microsoft.com/products/azure-sql), [Azure Database for PostgreSQL](https://azure.microsoft.com/products/postgresql), and [Azure Database for MySQL](https://azure.microsoft.com/products/mysql) are fully managed platform as a service (PaaS) services for SQL Server, PostgreSQL, and MySQL. They provide high-performance, highly available options for mainframe relational data, emulated non-relational data, and emulated Virtual Storage Access Method (VSAM) data.
  - [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db) is an Azure NoSQL database. Use it to migrate non-relational mainframe sources like Information Management System (IMS), Integrated Database Management System (IDMS), and adaptable database system (ADABAS).

- Monitoring

  - [Azure Monitor](https://azure.microsoft.com/products/monitor) delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments.
  - [Application Insight](/azure/azure-monitor/app/app-insights-overview) receives application telemetry to analyze and present.
  - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) is a feature of Azure Monitor that collects and organizes log and performance data from monitored resources. This feature can consolidate data from multiple sources into a single workspace. These sources include platform logs from Azure services, log and performance data from virtual machine agents, and usage and performance data from applications. Analyze these sources together by using a sophisticated query language, which is capable of quickly analyzing millions of records.
  - [Log Analytics](/azure/azure-monitor/log-query/log-query-overview) is a feature of Azure Monitor. Log queries help you use the data collected in Azure Monitor Logs and mLogica load script execution logs, which are stored in Blob Storage. A powerful query language allows you to join data from multiple tables, aggregate large sets of data, and perform complex operations.

### Potential use cases

There are two key use cases for this example workload:

- Workload replatforming or refactoring

  Move all mainframe data related to the workload from a mainframe to Azure. This data includes databases, like Db2, IMS, and IDMS, and files.

- Archival

  Retire mainframe workload and retain the data in a low-cost Azure storage solution.

### Recommendations

Follow these general recommendations unless you have a specific requirement that overrides them:

- To reduce network latency, create all Azure resources mentioned in this scenario in one region.
- Instead of sending a single large file from the mainframe to Azure, split data into multiple files and send them in parallel.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

#### Resiliency

Use Azure Monitor and [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor the mLogica data migration cluster. Set up alerts for proactive management.

For more information about resiliency in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

#### Availability

This example workflow describes mainframe-to-Azure data migration to replatform, refactor, or archive a workload. This task is discrete, performed a few times during a month-long project. Although high availability isn't required in this scenario, you can design the mLogica data migration cluster to provide high availability.

Azure database services support zone redundancy. You can configure them to fail over if there's an outage or during a maintenance window.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview). For general guidance on designing secure solutions, see the [Azure security documentation](/azure/security).

Database services in Azure support various security options:

- Data encryption at rest using [transparent data encryption](/sql/relational-databases/security/encryption/transparent-data-encryption)
- Data encryption in transit using [TLS](/azure/azure-sql/database/security-overview#transport-layer-security-encryption-in-transit)
- Data encryption while processing using [Always Encrypted with secure enclaves](/sql/relational-databases/security/encryption/always-encrypted-enclaves)

You can control authentication and access control on the mLogica data migration cluster by using Azure AD. You can configure Azure resources for authentication and authorization using Azure AD and role-based access control.

Data transferred between the mLogica data migration cluster and the mainframe is encrypted in transit by using TLS. TLS certificates can be stored in [Azure Key Vault](https://azure.microsoft.com/products/key-vault) for enhanced security. Data transferred from the mainframe to Azure Blob Storage is encrypted in transit using SSH.

The mainframe data and load scripts are temporarily stored in Azure Blob Storage. They're encrypted at rest. Data is deleted from Azure Blob Storage after the migration is complete.

This example workflow uses Azure ExpressRoute or [site-to-site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal) for a private and efficient connection to Azure from your on-premises environment.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Here are some cost optimization possibilities:

- [Azure SQL Database serverless](https://azure.microsoft.com/products/azure-sql/database) automatically scales, pauses, and resumes compute resources based upon your workload activity, so that you only pay for the resources you consume.

- Use lifecycle policy to move data between access tiers in Azure storage.

- In Azure storage, if there's no access for a period of time, move your data from a hotter access tier to a cooler one. You can also move data from a cooler access tier to an archive access tier.

- Use [Azure Advisor](https://azure.microsoft.com/products/advisor) to find underused resources. Get recommendations on how to reconfigure or consolidate resources to reduce your spending.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of using Azure components for this solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Azure DevOps can be used for re-engineering mainframe applications on Azure during every phase of software development and team collaboration. Azure DevOps provides these services:

- [Azure Boards](https://azure.microsoft.com/products/devops/boards). Agile planning, work item tracking, visualization, and reporting.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines). A language, platform, and cloud independent continuous integration/continuous delivery (CI/CD) platform with support for containers or Kubernetes.
- [Azure Repos](https://azure.microsoft.com/products/devops/repos). Cloud-hosted private Git repositories.
- [Azure Artifacts](https://azure.microsoft.com/products/devops/artifacts). Integrated package management with support for Maven, npm, Python, and NuGet package feeds from public or private sources.
- [Azure Test Plans](https://azure.microsoft.com/products/devops/test-plans). An integrated planned and exploratory testing solution.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

If you're migrating multiple large independent datasets, deploy the mLogica data migration cluster on multiple virtual machines to maximize data loading speed.

You can upload multiple data sets in parallel from the mainframe to Blob Storage.

[Azure SQL DB serverless](/azure/azure-sql/database/serverless-tier-overview?view=azuresql) provides an option for autoscaling based on workload. Other Azure databases can be scaled up and down using automation to meet the workload demands. For more information, see [Autoscaling](/azure/architecture/best-practices/auto-scaling).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

[Sandip Khandelwal](https://www.linkedin.com/in/sandip-khandelwal-64326a7) | Senior Engineering Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [Azure Database Migration Guides](https://learn.microsoft.com/data-migration).

For more information, contact [Azure Data Engineering - Mainframe & Midrange Modernization](mailto:datasqlninja@microsoft.com).

- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [mLogica LIBER*IRIS](https://www.mlogica.com/products/liber-m-mainframe-modernization)
- [Quickstart: Create a Linux virtual machine in the Azure portal](/azure/virtual-machines/linux/quick-create-portal)
- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

## Related resources

- [Azure data architecture guide](../../data-guide/index.md)
- [Azure data platform end-to-end](../dataplate2e/data-platform-end-to-end.yml)
- [Modernize mainframe and midrange data](/azure/architecture/example-scenario/mainframe/modernize-mainframe-data-to-azure)
- [Rehost Adabas & Natural applications in Azure](rehost-adabas-software-ag.yml)
- [Rehost a general mainframe on Azure](mainframe-rehost-architecture-azure.yml)