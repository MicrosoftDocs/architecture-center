UniKix is a mainframe-rehosting software suite from NTT DATA. UniKix provides a way to run migrated legacy assets on Azure, including:

- IBM CICS transactions.
- IBM IMS applications.
- Batch workloads.
- JCL workloads.

NTT DATA also offers solutions for converting Integrated Database Management System (IDMS), Natural, and related application environments so that they operate within UniKix. The robust, logically threaded NTT DATA engine provides a rich online transaction processing environment (TPE). A complete, native batch processing environment (BPE) supports the migration of batch workloads. The suite also includes:

- A powerful COBOL compiler.
- A streamlined runtime environment.
- A graphical source-level debugger.
- A completely portable indexed file system.

Most mainframe applications are unique and custom-tailored to their business. Universal one-size-fits-all architectures are rare. But this solution outlines an approach for rehosting a mainframe application on Azure. The solution offers high availability and disaster recovery.

## Potential use cases

- Lower total cost of ownership (TCO):

  - Eliminate annual mainframe software licensing fees.
  - Eliminate proprietary hardware costs.

- Accommodate growing workloads and new demands with a simplified IT environment.
- Make rapid migration possible and lower risk by keeping application business logic intact.
- Minimize disruption by reusing existing application development skills and user interfaces.
- Extend and evolve legacy assets on the flexible Azure platform.
- Implement a modern DevOps workflow with NTT DATA tools and select Azure tools.

## Mainframe architecture

![Diagram showing the Original Mainframe Architecture](../media/rehost-mainframe-ntt-data-unikix-original-architecture.png)

:::image type="content" source="media/rehost-mainframe-ntt-data-unikix-original-architecture.png" alt-text="Architecture diagram that shows a mainframe system. Components include middleware, monitoring systems, applications, and data." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mainframe-NTTDATA-azure-rehost.vsdx) of this architecture.*

- On-premises users interact with the mainframe by using TCP/IP (A):

  - Admin users interact through a TN3270 terminal emulator.
  - Web interface users interact via a web browser over TLS 1.3 port 443.

- Mainframes use communication protocols such as LU 6.2, TN3270, FTP, and Sockets (**B**).

- Receiving applications can be either batch or online systems (**C**).

- Mainframe applications are in COBOL, PL.I, Assembler, and 4GL. These languages and compatible ones run in an enabled environment (**D**).

- Mainframes use relational and hierarchical database systems, including network database systems (**E**).

- Common services that run include program execution, I/O operations, error detection, and environment security (**F**).

- Middleware and utility services manage tape storage, queueing, output, and web services within the environment (**G**).

- Operating systems provide an interface between the engine and the software that it runs (**H**).

- Partitions run separate workloads or segregate work types within the environment (**I**).

## NTT DATA UniKix Rehost Azure Architecture

:::image type="content" source="media/rehost-mainframe-ntt-data-unikix-azure-architecture.png" alt-text="Architecture diagram that shows a mainframe system rehosted on Azure by using N T T DATA UniKix." lightbox="media/rehost-mainframe-ntt-data-unikix-azure-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1930988-rehost-mainframe-ntt-data-unikix-azure-architecture.vsdx) of this architecture.*

1. Azure ExpressRoute connects an on-premises corporate network to NTT DATA's UniKix mainframe rehosting doftware suite. Traffic from users and external interfaces that aren't on the Azure platform flows through this ExpressRoute connection to the Azure instances.

1. Azure Load Balancer distributes online transactions across two or more Azure virtual machines (VMs).

1. The application server runs the following NTT DATA products:

   - Transaction Processing Environment (TPE). This environment runs:

     - Rehosted online IBM CICS transactions.
     - IBM IMS/TM applications.
     - Transformed IDMS DC programs.
     - Related resources.

   These workloads run on industry-standard server and operating systems such as Red Hat Linux.

   - Batch Processing Environment (BPE). This environment provides a complete job entry subsystem (JES) environment for the administration, execution, and management of batch workloads.

   - UniKix Secure, which was previously known as Transaction Security Facility (TSF). This external security manager provides role-based access control (RBAC) that's based on security for online TPE–based transactions.

   - NTT DATA COBOL. This technology produces optimized, portable object code that you can deploy in Azure and supports ANSI-85 standard and legacy COBOL dialects.

   - NTT DATA VDSO. This mechanism provides a way to store VSAM key-sequenced data set (KSDS) data in a SQL database rather than local disk files. NTT DATA VDSO supports many database technologies such as SQL Server, DB2, Oracle, and MySQL.

1. Shared sequential files are placed on a Lustre file system or MongoDB.

1. UniKix Secure uses Azure Active Directory (Azure AD) to provide authentication. This security manager replaces security systems like Resource Access Control Facility (RACF), Access Control Facility 2 (ACF2), and Top Secret.

1. The solution stores database tables and optionally, VSAM files, in SQL Server. This data is replicated to another Azure region for disaster recovery (DR) purposes.

1. Azure Site Recovery replicates the production application Azure VMs. Site Recovery also provides a way to test DR plans that doesn't impact production.

1. The second Azure region mirrors the configuration of the primary Azure region for DR purposes.
  
## Components

This example features the following Azure components. Several of these components and workflows are interchangeable or optional depending on your scenario.

- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) extends on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365.

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) distributes incoming traffic to compute resource clusters. You can define rules and other criteria to distribute the traffic.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) offers many sizes and types of on-demand, scalable computing resources. With Azure VMs, you get the flexibility of virtualization without having to buy and maintain physical hardware.

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) offers scalable, secure cloud storage for all your data, applications, and workloads:

  - Azure Disk Storage is high-performance, durable block storage for business-critical applications. Azure managed disks are block-level storage volumes that are managed by Azure on Azure VMs. The available types of disks are ultra disks, premium SSDs, standard SSDs, and standard hard disk drives (HDDs). This architecture uses either premium SSDs or ultra disk SSDs.
  - Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments can mount Azure Files file shares concurrently.
  - Azure Blob Storage provides scalable and secure object storage. It can manage large amounts of unstructured data, such as archives and data lakes. Blob Storage is a good fit for high-performance computing, machine learning, and cloud-native workloads.

- [Azure databases](https://azure.microsoft.com/product-categories/databases/) offer a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed platform as a service (PaaS) database engine. SQL Database runs on the latest stable version of SQL Server and a patched operating system. Automated functionality includes upgrading, patching, backups, and monitoring. Because SQL Database offers built-in PaaS capabilities, you can focus on domain-specific, business-critical database administration and optimization.

- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) mirrors Azure VMs to a secondary Azure region for quick failover and disaster recovery during datacenter failures.

## Considerations

The following considerations, based on the [Azure Well-Architected Framework](../../framework/index.md), apply to this solution:

### Availability

The architecture uses Azure Site Recovery to mirror Azure VMs to a secondary Azure region for quick failover and disaster recovery during datacenter failures. Azure auto-failover group replication provides data protection by managing the database replication and failover to the secondary region.

### Operations

By refactoring legacy systems, you can take advantage of cloud-computing benefits. You can adopt DevOps and agile working principles, which provide full flexibility in development and production deployment options.

### Resiliency

- Azure Load Balancer provides built-in resiliency in this solution. By using health probes and rules, Load Balancer monitors the status of the back-end pool. If one presentation or transaction server fails, Load Balancer runs workloads on other servers.
- Use availability sets and geo-redundant storage for increased resiliency.

### Security

- This solution uses an Azure network security group to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- Private Link provides private, direct connections between Azure VMs and Azure services. These connections are isolated to the Azure networking backbone.

- Azure Bastion maximizes administrative access security by minimizing open ports. Bastion provides secure and seamless RDP and SSH connectivity to virtual network VMs. Instead of using a public IP address, users connect to the VMs directly from the Azure portal over TLS.

## Pricing

Azure avoids unnecessary costs by identifying the correct number of resource types, analyzing spending over time, and scaling to meet business needs without overspending.

- Azure provides cost optimization by running on VMs. You can turn off the VMs when not in use, and script a schedule for known usage patterns. See the [Azure Well-Architected Framework](../../framework/index.md) for more information about cost optimization for [VM instances](../../framework/cost/optimize-vm.md).

- The VMs in this architecture use either premium SSDs or ultra disk SSDs. For more information about disk options and pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- SQL Database optimizes costs with serverless compute and Hyperscale storage resources that automatically scale. For more information about SQL Database options and pricing, see [Azure SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single).

Use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing this solution.

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Contact [NTTReHost.Cloud@nttdata.com](mailto:NTTReHost.Cloud@nttdata.com) for more information.

## Related resources

- See NTT DATA UniKix solution on Azure Marketplace(https://azuremarketplace.microsoft.com/en-us/marketplace/apps/nttdata.unikix).
- Read Deploying NTT DATA UniKix in Azure, Part 1 (https://techcommunity.microsoft.com/t5/azure-global/deploying-ntt-data-unikix-in-azure-part-1-deploying-the-vm/ba-p/775840) and Part 2 (https://techcommunity.microsoft.com/t5/azure-global/deploying-ntt-data-unikix-in-azure-part-2-configure-tpe-and/ba-p/779142).
