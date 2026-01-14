This article describes how to migrate IBM System i workloads to Azure by using Infinite i. Infinite i converts Report Program Generator (RPG) and common business-oriented language (COBOL) source code to object code that runs natively on x86 virtual machines (VMs). Application screens and interactions work as before, minimizing the need for user retraining. After migration, you can maintain and update programs by modifying the original source code as usual.

## Architecture

:::image type="complex" source="media/ibm-system-i-azure-infinite-i.svg" alt-text="Diagram of an architecture that uses Infinite i to migrate System i workloads to Azure." lightbox="media/ibm-system-i-azure-infinite-i.svg" border="false":::
   A dotted line divides the diagram into two sections, on-premises and Azure. The workflow begins in the on-premises section. A double-sided arrow connects a user icon and an Azure ExpressRoute icon. In the next step, a double-sided arrow connects the ExpressRoute icon and an Azure Load Balancer icon that's on the Azure side of the diagram. Another line shows how users from Azure systems can access this connection via a peered virtual network. Two arrows connect Load Balancer to icons that represent an Infinite i active application server and an Infinite i passive application server. A box for each server contains smaller boxes that represent technologies like RBG, COBOL, and SQL, data files, data, job, and message queues, an internal database, and an Azure Files SMB 3.0 mount. Arrows connect each Azure Files SMB 3.0 mount to an Azure Files file share in an Azure storage account. Another arrow connects the active server box and Azure SQL databases in the primary region. Arrows from these databases to databases in a secondary region represent automatic failover capabilities. An Azure Site Recovery icon represents disaster recovery capabilities for the components in the Azure section of the diagram.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/ibm-system-i-azure-infinite-i.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. TN5250 web terminal emulation provides user access to Azure over a Secure Sockets Layer/Transport Layer Security encrypted connection.

1. Azure ExpressRoute provides a dedicated high-speed connection between on-premises and Azure resources.

1. Azure Load Balancer distributes incoming TN5250 traffic across two Infinite i app servers (active and standby) in the virtual network. Azure-based clients connect via a peered virtual network. The following table describes the supported configurations:

   | Model | Support | Details |
   |---|---|---|
   | Active/Passive | Yes | We recommend this model. It uses replication and failover across availability zones. |
   | Active/Active (Load Balancer) | No | This model isn't supported because of database and session state constraints. |
   | Multiple VMs (Azure Virtual Machine Scale Sets) | Limited | Use this model for infrastructure deployment only. Don't use it for workload scaling. |
   | Clustered database back end | No | This model isn't compatible with Infinite i's current architecture. |

1. The Infinite i compilers translate the System i source code (RPG and COBOL) into 64-bit object code to run on Azure x86 VMs. The runtime interprets CL, CMD, and SQL.

1. Infinite i includes an internal database that emulates DB2/400 features such as physical files, logical files, multiple-member files, joins, triggers, referential integrity, commitment control, and journaling. When an application runs on Azure, it accesses data as it did in the AS/400 environment with no code changes required. Infinite i provides internal database connectors like Open Database Connectivity (ODBC) and Java Database Connectivity (JDBC) to connect to physical and logical files in the internal database.

1. Azure Files provides file shares to implement Infinite i files. Mounting a file share on the Azure VM gives programs direct access to the files. The file share also holds load modules and log files.

1. Instead of the internal database that step 5 describes, you can migrate the DB2/400 database to a standard SQL database. The database options are SQL Server, Azure SQL, Oracle, and MySQL. These options support the same features as the internal database. When Infinite i migrates the database, it creates a database schema that maps physical files to tables and logical files to views.

1. Azure Site Recovery provides disaster recovery.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) VMs are on-demand, scalable computing resources that eliminate the maintenance demands of physical hardware. In this architecture, they run the migrated workloads and provide flexibility and scalability. The operating system choices include Windows and Linux.

- [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) automates and load-balances VM scaling. These actions simplify application management and increase availability to ensure high availability and performance for the applications.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a secure private network in the cloud. It connects VMs to each other, to the internet, and to on-premises networks. It provides the necessary connectivity for the migrated workloads.

- [Azure Private Link](/azure/private-link/private-link-overview) carries private connections to Azure services. It helps ensure secure communication between components.

- [Azure load balancing services](../../guide/technology-choices/load-balancing-overview.md) scale VMs for high availability and high performance. This architecture uses [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer), which provides low-latency balancing of traffic among VMs and across multitiered hybrid apps.

- [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage) provides highly durable and high-performance block storage for Azure VMs. It supports various disk storage options to meet performance and durability needs. There are three disk storage options for the cloud: Azure Ultra Disk Storage, Azure Premium SSD, and Azure Standard SSD.

- [Azure Files](/azure/well-architected/service-guides/azure-files) provides simple, secure, and serverless enterprise-grade file shares in the cloud. The shares support access by the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols. Cloud and on-premises deployments of Windows, Linux, and macOS can mount file shares concurrently.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) carries private connections between on-premises infrastructure and Azure datacenters. It helps ensure high-speed and secure connectivity.

- [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) is a family of SQL cloud databases that provide a unified experience for your entire SQL portfolio and a wide range of deployment options from the edge to the cloud. It provides fully managed database services for migrated workloads.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database), which is part of the Azure SQL family, is a fully managed platform as a service (PaaS) database engine. It handles most database management functions, such as upgrading, patching, backups, and monitoring, without your involvement. SQL Database always runs on the latest stable version of the SQL Server database engine and patched OS, with 99.99% availability to help ensure high availability and performance.

## Scenario details

Infinite i lets you migrate your System i and AS/400 workloads to Azure. The migrated workloads in Azure maintain or improve performance and availability, reduce costs, and create opportunities for modernization.

After deployment on Infinite i in Azure, the applications run as they did on the System i platform. The Infinite i runtime environment supports job processing and control language commands in a Linux environment.

You use the Infinite i suite to compile your applications. The suite includes compilers and translators for these technologies: RPG, RPG/ILE, RPG/Free, COBOL, Control Language Programs (CLP), and Data Description Specifications (DDS).

The Infinite i environment provides the following benefits:

- Easy migration of System i workloads to Azure.
 
- Conversion of tape archives for backup and regulatory compliance.

- Application screens that work as before. You have the option of updating the screens to web-based user interfaces.

- An Infinite internal database that holds your data and emulates DB2/400. You have the option of migrating to a standard SQL database instead, with minor code changes or none at all.

- Savings on licensing and maintenance that significantly reduces your total cost of ownership.

- Faster and lower-cost options for disaster recovery on Azure compared to System i.

### Potential use cases

- Easily migrate IBM System i and AS/400 workloads to Azure.

- Modernize System i and AS/400 workloads and reduce costs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture accommodates redundancy and disaster recovery for high availability:

- Use [Site Recovery](/azure/site-recovery/site-recovery-overview) for disaster recovery on Azure VMs. It helps protect VMs against major outages by minimizing downtime and data loss. The service is dependable, cost-effective, and easy to deploy.

To improve availability, take the following steps:

- Use [Azure availability zones](/azure/reliability/availability-zones-overview) to protect against infrastructure disruptions by eliminating all single points of failure. The service-level agreement (SLA) for VMs is for 99.99% uptime.

- Use Virtual Machine Scale Sets to set up a group of load-balanced VMs that make up an Azure virtual machine scale set. This approach increases availability.

- For more information, see [Availability options for Virtual Machines](/azure/virtual-machines/availability).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Infinite i migrates the System i user-based access roles to Azure.

- The Infinite i runtime environment provides the same level of security on Azure that the System i environment provided.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The Infinite i solution keeps costs at a minimum to lower your total cost of ownership:

- The migration to Azure eliminates IBM licensing and maintenance costs.

- Linux has lower implementation costs than IBM platforms.

- The autoscale feature of PaaS services scales on demand to minimize costs.

To estimate the cost of implementing this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

Here are pricing considerations for specific components:

- [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows) and [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux) depend on your compute capacity.

- For [ExpressRoute](https://azure.microsoft.com/pricing/details/expressroute), you pay a monthly port fee and outbound data transfer fees.

- [Azure Blob Storage](https://azure.microsoft.com/pricing/details/storage/blobs) costs depend on data redundancy options and volume.

- [Azure Files](https://azure.microsoft.com/pricing/details/storage/files) pricing depends on several factors, including data volume, data redundancy, transaction volume, and the number of file sync servers that you use.

- For Premium SSD or Ultra Disk Storage pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- There are no upfront costs for [SQL Database](https://azure.microsoft.com/pricing/details/azure-sql-database/single). You pay for resources as you use them.

- For [Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery), you pay for each protected instance.

- The following services are free with your Azure subscription, but you pay for usage and traffic:

  - [Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer).

  - For [Virtual Network](https://azure.microsoft.com/pricing/details/virtual-network), IP addresses carry a nominal charge.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- The Infinite i deployment methodology recommends that you convert and test workloads on the original platform before you migrate the code and data to the Azure platform.

- When you move workloads to Azure, use availability zones, scale sets, and [Site Recovery](https://azure.microsoft.com/products/site-recovery) to reduce management overhead for scaling and reliability.

- Consider using [Azure Resource Manager templates](https://azure.microsoft.com/products/arm-templates) for scripted deployment and for monitoring and alerting capabilities.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The Infinite i migration design process considers the performance characteristics of the workloads running on System i and selects the right configuration of Azure services for the desired performance on Azure.

- Infinite i can take advantage of Azure scale sets to add capacity as needed.

- The architecture is designed to accommodate parallel processing by running multiple sets of VMs to the same database. Independent transactions don't rely on each other being serial.

- For this architecture, use Premium SSD or Ultra Disk Storage for improved performance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

 - Philip Brooks | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information about [optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs), see the [Well-Architected Framework](/azure/well-architected) recommendations.

- Infinite i from partner Infinite Corporation:

  - [Overview](https://www.infinitecorporation.com/infinite-i)
  - [Migrate legacy cold storage AS/400](https://www.infinitecorporation.com/data-migration)
  - [Infinite Cloud: Beautiful screens from IBM i and AS/400 green screens](https://www.infinitecorporation.com/infinite-cloud)

- IBM System i (AS/400) information:

  - [IBM Power systems servers](https://www.ibm.com/power)
  - [IBM i: An operating system for IBM Power servers](https://www.ibm.com/products/ibm-i)
  - [Enterprise server solutions](https://www.ibm.com/servers)

## Related resources

- [Understand data store models](../../guide/technology-choices/data-store-overview.md)

- Migrate IBM system workloads:

  - [High-volume batch transaction processing](./process-batch-transactions.yml)
  - [IBM z/OS mainframe migration with Avanade AMT](./avanade-amt-zos-migration.yml)
  - [Replicate and sync mainframe data to Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
