The Infinite i suite is from Microsoft partner Infinite Corporation. The architecture described here uses it to migrate System i workloads to Azure. It converts RPG and COBOL source code to object code that runs natively on x86 virtual machines (VMs). Application screens and interactions work as before, thus minimizing user retraining. After migration, you maintain programs as usual by making changes to the source code.

## Architecture

:::image type="content" source="media/ibm-system-i-azure-infinite-i.svg" alt-text="This architecture uses Infinite i to migrate System i workloads to Azure." lightbox="media/ibm-system-i-azure-infinite-i.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1828025-PR-2852-ibm-system-i-azure-infinite-i.vsdx) of this architecture.*

### Workflow

1. TN5250 web terminal emulation provides user access to Azure over an SSL/TLS encrypted connection.
1. Azure ExpressRoute provides a dedicated high-speed connection between on-premises and Azure resources.
1. Infinite i application servers run the migrated workloads. Each server runs in its own Microsoft Azure Virtual Machines VM. The architecture uses two or more VMs for high availability, and Azure Load Balancer controls inbound and outbound network traffic. Infinite i supports an active-passive configuration (one active VM, one standby VM).
1. The compilers translate System i source code to 64-bit object code that runs on Azure x86 VMs.
1. An Infinite i internal database emulates the behavior of a DB2/400 database, including features such as physical files, logical files, multi-member files, joins, triggers, referential integrity, commitment control, and journaling. When an application runs on Azure, it accesses data as it did in the AS/400 environment, with no code changes required. Infinite i provides internal database connectors (ODBC and JDBC) for connecting to physical and logical files in the internal database.
1. Azure Files provides file shares to implement Infinite i files. Mounting a file share on the Azure VM gives programs direct access to the files. The file share also holds load modules and log files.
1. Instead of the internal database that step 5 describes, you can migrate the DB2/400 database to a standard SQL database. The database options are: SQL Server, Azure SQL, Oracle, and MySQL. These options support the same features as the internal database. When Infinite i migrates the database, it creates a database schema that maps physical files to tables and logical files to views.
1. Azure Site Recovery provides disaster recovery.

### Components

The architecture uses these components:

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) VMs are on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. The operating system choices include Windows and Linux. The VMs are an on-demand and scalable resource.
- [Azure Virtual Machine Scale Sets](https://azure.microsoft.com/en-us/services/virtual-machine-scale-sets/) is automated and load-balanced VM scaling that simplifies management of your applications and increases availability.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [Azure Private Link](https://azure.microsoft.com/en-us/services/private-link/) carries private connections to Azure services.
- [Azure load balancing services](https://azure.microsoft.com/products/azure-load-balancing/) scale VMs for high availability and high performance. This architecture uses [Load Balancer](https://azure.microsoft.com/services/load-balancer/), which provides low-latency balancing of traffic among VMs and across multi-tiered hybrid apps.
- [Azure Disk Storage](https://azure.microsoft.com/en-us/services/storage/disks/) is highly durable and high-performance block storage for Azure VMs. There are four disk storage options for the cloud: Ultra Disk SSD Managed Disks, Premium SSD Managed Disks, Standard SSD Managed Disks, and Standard HDD Managed Disks.
- [Azure Files](https://azure.microsoft.com/services/storage/files/) offers simple, secure, and serverless enterprise-grade file shares in the cloud. The shares support access by the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols. They can be mounted concurrently by cloud and on-premises deployments of Windows, Linux, and macOS.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) carries private connections between on-premises infrastructure and Azure datacenters.
- [Azure SQL](https://azure.microsoft.com/services/azure-sql/) is a family of SQL cloud databases that provides a unified experience for your entire SQL portfolio, and a wide range of deployment options from edge to cloud.
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database/), part of the Azure SQL family, is a fully managed platform as a service (PaaS) database engine. It handles most database management functions, such as upgrading, patching, backups, and monitoring, without your involvement. Azure SQL Database is always running on the latest stable version of the SQL Server database engine and patched OS, with 99.99 percent availability.

## Scenario details

You can easily migrate your System i and AS/400 workloads to Azure. The migrated workloads will match or improve performance and availability, at lower cost and with opportunities to modernize.

To migrate your applications, you compile them with the Infinite i suite. After deployment on Infinite i on Azure, the applications run as they did on the System i platform. The Infinite i runtime environment provides everything you need to run jobs and execute control language commands in a Linux environment.

There are compilers and translators for these technologies: RPG, RPG/ILE, RPG/Free, COBOL, Control Language Programs (CLP), and Data Description Specifications (DDS).

The Infinite i suite is from Microsoft partner Infinite Corporation. The architecture described here uses it to migrate System i workloads to Azure. It converts RPG and COBOL source code to object code that runs natively on x86 virtual machines (VMs). Application screens and interactions work as before, thus minimizing user retraining. After migration, you maintain programs as usual by making changes to the source code.

The benefits of the Infinite i environment include:

- Easy migration of System i workloads to Azure.
- Conversion of tape archives for backup and regulatory compliance.
- Application screens work as before. You have the option of updating the screens to web-based user interfaces.
- The Infinite internal database that holds your data emulates DB2/400. You have the option of migrating to a standard SQL database instead, with minor code changes or none at all.
- Your savings on licensing and maintenance significantly reduces your total cost of ownership.
- On Azure you have faster and lower-cost options for disaster recovery than you have on System i.

### Potential use cases

Use this architecture to easily migrate IBM System i and AS/400 workloads to Azure, and to modernize them and reduce costs.

## Considerations

The following considerations apply to this solution.

### Availability

The architecture accommodates redundancy and disaster recovery for high availability:

- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/)  disaster recovery service protects against major outages by minimizing  downtime and data loss, resulting in low impact recoveries from major failures. The service is dependable, cost-effective, and easy to deploy.
- For more information on various availability options, see [Availability options for Azure Virtual Machines](/azure/virtual-machines/availability).

Take these steps to improve availability:

- Use [Azure Availability Zones](https://azure.microsoft.com/global-infrastructure/availability-zones/) to protect against infrastructure disruptions by eliminating all single points of failure. The SLA for VMs is for 99.99% uptime.
- Use an availability set, which is a grouping of VMs, for redundancy and availability. See [Availability sets overview](/azure/virtual-machines/availability-set-overview) for more information.
- For increased availability, use Virtual Machine Scale Sets to set up a group of load-balanced VMs that make up an Azure Virtual Machine Scale Set.
- [Azure load balancing services](https://azure.microsoft.com/products/azure-load-balancing/) provide scaling for high availability and high performance.

### Operations

- The Infinite i deployment methodology calls for converting and testing workloads before migrating them to the Azure platform.
- When you move workloads to Azure, you can use Azure services such as Availability Zones, scale sets, and [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/).
- Azure DevOps can help manage the migration.
- Consider using [Azure Resource Manager templates (ARM templates)](https://azure.microsoft.com/services/arm-templates/) for scripted deployment, and for monitoring and alerting capabilities.

### Performance

- Azure services, including VMs, scale to meet desired performance.
- The Infinite i migration design process considers the performance characteristics of the workloads running on System i, and selects the right configuration of Azure services for the desired performance on Azure.
- Infinite i can take advantage of Azure scale sets to add capacity as needed.
- The architecture is designed to accommodate parallel processing of independent transactions.
- For this architecture, Premium SSDs or Ultra Disk SSDs are usually a good choice.

### Security

- Infinite i migrates the System i user-based access roles to Azure.
- The Infinite i runtime environment provides the same level of security on Azure as the System i environment provided.
- Azure security best practices can further protect the overall application  environment.

### Cost optimization

The Infinite i solution keeps costs at a minimum to lower your total cost of ownership:

- The migration to Azure eliminates IBM licensing and maintenance costs.
- Linux has lower implementation costs than IBM platforms.
- The autoscale feature of PaaS services does scaling-on-demand to minimize costs.

To estimate the cost of implementing this solution, use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator/).

Here are pricing considerations for specific components:

- [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/) and [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/) depend on your compute capacity.
- For [ExpressRoute](https://azure.microsoft.com/pricing/details/expressroute/), you pay a monthly port fee and outbound data transfer charges.
- [Azure Storage](https://azure.microsoft.com/pricing/details/storage/) costs depend on data redundancy options and volume.
- [Azure Files](https://azure.microsoft.com/pricing/details/storage/files/) pricing depends on many factors: data volume, data redundancy, transaction volume, and the number of file sync servers that you use.
- For Premium SSD or Ultra SSD managed storage disks pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks/).
- There are no upfront costs for [Azure SQL Database](https://azure.microsoft.com/pricing/details/sql-database/single/); you pay for resources as used.
- For [Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery/), you pay for each protected instance.
- These services are free with your Azure subscription, but you pay for usage and traffic:
  - [Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer/).
  - For [Azure Virtual Network](https://azure.microsoft.com/pricing/details/virtual-network), IP addresses carry a nominal charge.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Jonathon Frost](https://www.linkedin.com/in/jjfrost/) | Principal Software Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact <legacy2azure@microsoft.com>.
- Infinite i from partner Infinite Corporation:
  - [Overview](https://www.infinitecorporation.com/infinite-i)
  - [Migrate Legacy Cold Storage AS/400](https://www.infinitecorporation.com/data-migration)
  - [Infinite Cloud: beautiful screens from IBM i / AS400 green screens](https://www.infinitecorporation.com/infinite-cloud)
- Optimizing costs:
  - [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) has information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm).
  - [Checklist - Optimize cost](/azure/architecture/framework/cost/optimize-checklist)
  - [Virtual machines](/azure/architecture/framework/cost/optimize-vm)

## Related resources

- [Understand data store models](../../guide/technology-choices/data-store-overview.md)
- Migrating IBM system workloads:
  - [High-volume batch transaction processing](./process-batch-transactions.yml)
  - [IBM z/OS mainframe migration with Avanade AMT](./asysco-zos-migration.yml)
  - [Micro Focus Enterprise Server on Azure VMs](./micro-focus-server.yml)
  - [Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml)
  - [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
  - [Replicate and sync mainframe data in Azure](../../reference-architectures/migration/sync-mainframe-data-with-azure.yml)
  - [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)
- IBM System i (AS/400) information:
  - [IBM Power Systems Servers: Powering the hybrid enterprise](https://www.ibm.com/it-infrastructure/power)
  - [IBM i: A platform for innovators, by innovators](https://www.ibm.com/it-infrastructure/power/os/ibm-i)
  - [IBM Power System case studies](https://www.ibm.com/power#3137816)
  - [IBM Power Systems: enterprise servers](https://www.ibm.com/it-infrastructure/power/enterprise)
