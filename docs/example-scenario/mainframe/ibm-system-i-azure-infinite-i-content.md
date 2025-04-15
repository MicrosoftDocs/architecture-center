The Infinite i suite is from Microsoft partner Infinite Corporation. The architecture described here uses it to migrate System i workloads to Azure. It converts Report Program Generator (RPG) and common business-oriented language (COBOL) source code to object code that runs natively on x86 virtual machines (VMs). Application screens and interactions work as before, thus minimizing user retraining. After migration, you maintain programs as usual by making changes to the source code.

## Architecture

:::image type="content" source="media/ibm-system-i-azure-infinite-i.svg" alt-text="Diagram of an architecture that uses Infinite i to migrate System i workloads to Azure." lightbox="media/ibm-system-i-azure-infinite-i.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/ibm-system-i-azure-infinite-i.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. TN5250 web terminal emulation provides user access to Azure over a Secure Sockets Layer/Transport Layer Security encrypted connection.

1. Azure ExpressRoute provides a dedicated high-speed connection between on-premises and Azure resources.

1. Infinite i application servers run the migrated workloads. Each server runs in its own VM on Azure Virtual Machines. The architecture uses two or more VMs for high availability, and Azure Load Balancer controls inbound and outbound network traffic. Infinite i supports an active-passive configuration (one active VM, one standby VM).

1. The compilers translate System i source code to 64-bit object code that runs on Azure x86 VMs.

1. An Infinite i internal database emulates the behavior of a DB2/400 database, including features such as physical files, logical files, multiple-member files, joins, triggers, referential integrity, commitment control, and journaling. When an application runs on Azure, it accesses data as it did in the AS/400 environment, with no code changes required. Infinite i provides internal database connectors (ODBC and JDBC) for connecting to physical and logical files in the internal database.

1. Azure Files provides file shares to implement Infinite i files. Mounting a file share on the Azure VM gives programs direct access to the files. The file share also holds load modules and log files.

1. Instead of the internal database that step 5 describes, you can migrate the DB2/400 database to a standard SQL database. The database options are SQL Server, Azure SQL, Oracle, and MySQL. These options support the same features as the internal database. When Infinite i migrates the database, it creates a database schema that maps physical files to tables and logical files to views.

1. Azure Site Recovery provides disaster recovery.

### Components

The architecture uses these components:

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) VMs are on-demand, scalable computing resources that eliminate the maintenance demands of physical hardware. In this architecture, they run the migrated workloads and provide flexibility and scalability. The operating system choices include Windows and Linux.

- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) automate and load-balance VM scaling. These actions simplify application management and increase availability to ensure high availability and performance for the applications.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a secure private network in the cloud. It connects VMs to each other, to the internet, and to on-premises networks. It provides the necessary connectivity for the migrated workloads.

- [Azure Private Link](/azure/private-link/private-link-overview) carries private connections to Azure services. It helps ensure secure communication between components.

- [Azure load balancing services](../../guide/technology-choices/load-balancing-overview.yml) scale VMs for high availability and high performance. This architecture uses [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer), which provides low-latency balancing of traffic among VMs and across multitiered hybrid apps.

- [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage) provides highly durable and high-performance block storage for Azure VMs. It supports various disk storage options to meet performance and durability needs. There are four disk storage options for the cloud: Ultra Disk SSD Managed Disks, Premium SSD Managed Disks, Standard SSD Managed Disks, and Standard HDD Managed Disks.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides simple, secure, and serverless enterprise-grade file shares in the cloud. The shares support access by the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols. Cloud and on-premises deployments of Windows, Linux, and macOS can mount file shares concurrently.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) carries private connections between on-premises infrastructure and Azure datacenters. It helps ensure high-speed and secure connectivity.

- [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) is a family of SQL cloud databases that provide a unified experience for your entire SQL portfolio and a wide range of deployment options from edge to cloud. It provides fully managed database services for the migrated workloads.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database), which is part of the Azure SQL family, is a fully managed platform as a service (PaaS) database engine. It handles most database management functions, such as upgrading, patching, backups, and monitoring, without your involvement. Azure SQL Database always runs on the latest stable version of the SQL Server database engine and patched OS, with 99.99% availability to help ensure high availability and performance.

## Scenario details

You can easily migrate your System i and AS/400 workloads to Azure. The migrated workloads match or improve performance and availability, at a lower cost and with opportunities to modernize.

To migrate your applications, you compile them with the Infinite i suite. After deployment on Infinite i on Azure, the applications run as they did on the System i platform. The Infinite i runtime environment provides everything you need to run jobs and run control language commands in a Linux environment.

There are compilers and translators for these technologies: RPG, RPG/ILE, RPG/Free, COBOL, Control Language Programs (CLP), and Data Description Specifications (DDS).

The Infinite i suite is from Microsoft partner Infinite Corporation. The architecture described here uses it to migrate System i workloads to Azure. It converts RPG and COBOL source code to object code that runs natively on x86 VMs. Application screens and interactions work as before, thus minimizing user retraining. After migration, you maintain programs as usual by making changes to the source code.

The benefits of the Infinite i environment include:

- Easy migration of System i workloads to Azure.
 
- Conversion of tape archives for backup and regulatory compliance.

- Application screens that work as before. You have the option of updating the screens to web-based user interfaces.

- An Infinite internal database that holds your data and emulates DB2/400. You have the option of migrating to a standard SQL database instead, with minor code changes or none at all.

- Savings on licensing and maintenance that significantly reduces your total cost of ownership.

- Faster and lower-cost options for disaster recovery on Azure than on System i.

### Potential use cases

- Easily migrate IBM System i and AS/400 workloads to Azure.

- Modernize System i and AS/400 workloads and reduce costs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture accommodates redundancy and disaster recovery for high availability:

- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery) disaster recovery service protects against major outages by minimizing downtime and data loss. These actions enable low-impact recoveries from major failures. The service is dependable, cost-effective, and easy to deploy.

- For more information, see [Availability options for Azure Virtual Machines](/azure/virtual-machines/availability).

To improve availability, take the following steps:

- Use [Azure availability zones](https://azure.microsoft.com/explore/global-infrastructure/availability-zones) to protect against infrastructure disruptions by eliminating all single points of failure. The SLA for VMs is for 99.99% uptime.

- Use an availability set, which is a grouping of VMs, for redundancy and availability. For more information, see [Availability sets overview](/azure/virtual-machines/availability-set-overview).

- Use Virtual Machine Scale Sets to set up a group of load-balanced VMs that make up an Azure virtual machine scale set. This approach increases availability.

- Use [Azure load balancing services](https://azure.microsoft.com/solutions/load-balancing-with-azure), which provide scaling for high availability and high performance.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Infinite i migrates the System i user-based access roles to Azure.

- The Infinite i runtime environment provides the same level of security on Azure that the System i environment provided.

- Azure security best practices can further protect the overall application environment.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The Infinite i solution keeps costs at a minimum to lower your total cost of ownership:

- The migration to Azure eliminates IBM licensing and maintenance costs.

- Linux has lower implementation costs than IBM platforms.

- The autoscale feature of PaaS services scales on demand to minimize costs.

To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

Here are pricing considerations for specific components:

- [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows) and [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux) depend on your compute capacity.

- For [ExpressRoute](https://azure.microsoft.com/pricing/details/expressroute), you pay a monthly port fee and outbound data transfer charges.

- [Azure Blob Storage](https://azure.microsoft.com/pricing/details/storage/blobs) costs depend on data redundancy options and volume.

- [Azure Files](https://azure.microsoft.com/pricing/details/storage/files) pricing depends on several factors, including data volume, data redundancy, transaction volume, and the number of file sync servers that you use.

- For Premium SSD or Ultra SSD managed storage disks pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- There are no upfront costs for [Azure SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single). You pay for resources as you use them.

- For [Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery), you pay for each protected instance.

- These services are free with your Azure subscription, but you pay for usage and traffic:

  - [Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer).

  - For [Azure Virtual Network](https://azure.microsoft.com/pricing/details/virtual-network), IP addresses carry a nominal charge.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- The Infinite i deployment methodology calls for converting and testing workloads before migrating them to the Azure platform.

- When you move workloads to Azure, you can use Azure services such as availability zones, scale sets, and [Site Recovery](https://azure.microsoft.com/products/site-recovery).

- Azure DevOps can help manage the migration.

- Consider using [Azure Resource Manager templates](https://azure.microsoft.com/products/arm-templates) for scripted deployment and for monitoring and alerting capabilities.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Azure services, including VMs, scale to meet desired performance.

- The Infinite i migration design process considers the performance characteristics of the workloads running on System i and selects the right configuration of Azure services for the desired performance on Azure.

- Infinite i can take advantage of Azure scale sets to add capacity as needed.

- The architecture is designed to accommodate parallel processing of independent transactions.

- For this architecture, Premium SSDs or Ultra Disk SSDs are usually a good choice.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

 - Philip Brooks | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact <legacy2azure@microsoft.com>.

- See the [Microsoft Azure Well-Architected Framework](/azure/well-architected) recommendations for [optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs)

- Infinite i from partner Infinite Corporation:

  - [Overview](https://www.infinitecorporation.com/infinite-i)
  - [Migrate legacy cold storage AS/400](https://www.infinitecorporation.com/data-migration)
  - [Infinite Cloud: Beautiful screens from IBM i and AS400 green screens](https://www.infinitecorporation.com/infinite-cloud)

- IBM System i (AS/400) information:

  - [IBM Power systems servers](https://www.ibm.com/power)
  - [IBM i: An operating system for IMB Power servers](https://www.ibm.com/products/ibm-i)
  - [Enterprise server solutions](https://www.ibm.com/servers)

## Related resources

- [Understand data store models](../../guide/technology-choices/data-store-overview.md)

- Migrate IBM system workloads:

  - [High-volume batch transaction processing](./process-batch-transactions.yml)
  - [IBM z/OS mainframe migration with Avanade AMT](./avanade-amt-zos-migration.yml)
  - [Refactor an IBM z/OS mainframe coupling facility to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml)
  - [Replicate and sync mainframe data to Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
