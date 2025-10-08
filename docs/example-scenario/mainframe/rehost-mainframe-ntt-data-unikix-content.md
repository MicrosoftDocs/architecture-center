UniKix is a mainframe-rehosting software suite from NTT DATA. This suite provides a way to run migrated legacy assets on Azure. Example assets include IBM CICS transactions, IBM IMS applications, batch workloads, and JCL workloads. This article outlines a solution for rehosting mainframe applications on Azure. Besides UniKix, the solution's core components include Azure ExpressRoute, Azure Site Recovery, and Azure storage and database services.

## Mainframe architecture

The following diagram shows a legacy mainframe system before it's rehosted to the cloud:

:::image type="content" source="media/rehost-mainframe-ntt-data-unikix-original-architecture.svg" alt-text="Architecture diagram that shows a mainframe system. Components include middleware, monitoring systems, applications, and data." lightbox="media/rehost-mainframe-ntt-data-unikix-original-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/rehost-mainframe-ntt-data-unikix-azure-architecture.vsdx) of this architecture.*

### Workflow

- On-premises users interact with the mainframe by using TCP/IP (**A**):

  - Admin users interact through a TN3270 terminal emulator.
  - Web interface users interact via a web browser over TLS 1.3 port 443.

- Mainframes use communication protocols such as LU 6.2, TN3270, FTP, Sockets, and UTS to receive input (**B**).

- Batch and online applications process the input (**C**).

- Mainframe applications are in COBOL, PL/I, Assembler, 4GL, and Fortran. These languages and compatible ones run in an enabled environment (**D**).

- Mainframes use hierarchical, network, and relational databases (**E**).

- Services perform tasks for the applications. Services that typically run include program execution, I/O operations, error detection, and protection. (**F**).

- Middleware and utility services manage tasks like tape storage, queueing, output, and web support (**G**).

- Operating systems provide an interface between the engine and the software that it runs (**H**).

- Partitions run separate workloads or segregate work types within the environment (**I**).

## Azure architecture

:::image type="content" source="media/rehost-mainframe-ntt-data-unikix-azure-architecture.svg" alt-text="Architecture diagram that shows a mainframe system rehosted on Azure by using NTT DATA UniKix." lightbox="media/rehost-mainframe-ntt-data-unikix-azure-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/rehost-mainframe-ntt-data-unikix-azure-architecture.vsdx) of this architecture.*

### Workflow

1. ExpressRoute connects an on-premises corporate network to NTT DATA's UniKix mainframe rehosting software suite. Traffic from users and external interfaces that aren't on the Azure platform flows through this ExpressRoute connection to the Azure instances.

1. Azure Load Balancer distributes online transactions across two or more Azure virtual machines (VMs). Port 4444 is used to connect with x3270. For a single-host alternative, see [Alternatives](#alternatives).

1. The application server runs the following NTT DATA products:

   - TPE. This environment runs:

     - Rehosted online IBM CICS transactions.
     - IBM IMS/TM applications.
     - Transformed IDMS DC programs.
     - Related resources.

     These workloads run on industry-standard servers and operating systems such as Red Hat Linux.

   - BPE. This environment provides a complete job entry subsystem (JES) environment for the administration, execution, and management of batch workloads.

   - UniKix Secure, which was previously known as Transaction Security Facility (TSF). This external security manager provides role-based access control that's based on security for online TPE-based transactions.

   - NTT DATA COBOL. This technology produces optimized, portable object code that you can deploy in Azure. NTT DATA COBOL supports ANSI-85 standard and legacy COBOL dialects.

   - NTT DATA VDSO. This mechanism provides a way to store VSAM key-sequenced dataset (KSDS) data in a SQL database rather than local disk files. NTT DATA VDSO supports many database technologies such as SQL Server, DB2, Oracle, and MySQL.

1. Azure managed disks provide storage for shared files.

1. UniKix Secure uses Microsoft Entra ID to provide authentication. This security manager replaces security systems like Resource Access Control Facility (RACF), Access Control Facility 2 (ACF2), and Top Secret.

1. The solution stores database tables and, optionally, VSAM files, in Azure SQL Database. This data is replicated to another Azure region for disaster recovery purposes.

1. Site Recovery replicates the Azure production application VMs. This replication helps ensure business continuity by keeping business apps and workloads running during outages.

1. The second Azure region mirrors the configuration of the primary Azure region for disaster recovery.
  
### Components

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends on-premises networks into Azure over a private, dedicated fiber connection from a connectivity provider. ExpressRoute establishes connections to Microsoft cloud services like Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, high-bandwidth connectivity between the on-premises corporate network and the UniKix mainframe rehosting environment that runs on Azure.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) is a networking service that distributes incoming traffic to compute resource clusters. You can define rules and other criteria to distribute the traffic. In this architecture, Load Balancer distributes online transactions across multiple Azure VMs that run the UniKix application server components to ensure high availability and performance.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a cloud computing service that provides many sizes and types of on-demand, scalable computing resources. With Azure VMs, you get the flexibility of virtualization without having to buy and maintain physical hardware. In this architecture, Virtual Machines hosts the NTT DATA UniKix application server components including transaction processing environment (TPE) for CICS transactions and batch processing environment (BPE) for batch processing workloads.

- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a cloud storage service that provides scalable, secure cloud storage for all your data, applications, and workloads. In this architecture, Azure Storage provides persistent storage for the rehosted mainframe applications and data through multiple storage options:

  - [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage service that provides scalable and secure object storage. It can manage large amounts of unstructured data, such as archives and data lakes. Blob Storage is a good fit for high-performance computing, machine learning, and cloud-native workloads. In this architecture, Blob Storage stores backup data, archives, and other unstructured data for the rehosted mainframe applications.

  - [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage) is a high-performance, durable block storage service for business-critical applications. Azure managed disks are block-level storage volumes that are managed by Azure on Azure VMs. The available types of disks are Azure Ultra Disk Storage, Azure Premium SSD, and Azure Standard SSD. In this architecture, Azure Disk Storage provides high-performance persistent storage for the UniKix application server VMs by using either Premium SSD or Ultra Disk Storage.

  - [Azure Files](/azure/well-architected/service-guides/azure-files) is a managed file share service that provides fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Cloud and on-premises Windows, Linux, and macOS deployments can mount Azure Files file shares concurrently. In this architecture, Azure Files provides shared file storage for the UniKix applications and enables file sharing between multiple VM instances.

- [Azure databases](/sql/relational-databases/databases/databases) are a collection of database services that provide a choice of fully managed relational and NoSQL databases to fit modern application needs. Automated infrastructure management provides scalability, availability, and security. In this architecture, Azure databases provide the data storage layer for the rehosted mainframe applications and replace the hierarchical and network databases from the original mainframe environment.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a platform as a service (PaaS) database engine that runs on the latest stable version of SQL Server and a patched operating system. Automated functionality includes upgrading, patching, backups, and monitoring. In this architecture, SQL Database provides the relational database platform for storing converted mainframe data and supporting the UniKix application workloads.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery service that mirrors Azure VMs to a secondary Azure region. If the primary datacenter fails, the secondary region provides quick failover and disaster recovery. In this architecture, Site Recovery replicates the Azure production application VMs to ensure business continuity by keeping the UniKix applications and workloads running during outages.

### Alternatives

- Sometimes scaling isn't possible, due to licensing constraints or your application's design. In those cases, you can mirror the mainframe setup with a single host.
- For disaster recovery, the solution replicates the SQL Server data to another region. As another option, you can use the Always On availability groups feature of SQL Server as a disaster recovery solution.
- In some scenarios, some of the solution's components and workflows are optional or interchangeable.

## Scenario details

UniKix is a mainframe-rehosting software suite from NTT DATA. This suite provides a way to run migrated legacy assets on Azure. Example assets include IBM CICS transactions, IBM IMS applications, batch workloads, and JCL workloads.

The NTT DATA software offers many useful features:

- A means for converting Integrated Database Management System (IDMS), Natural, and other application environments so that they operate within UniKix
- A robust, logically threaded NTT DATA engine that provides a rich online transaction processing environment (TPE)
- A complete, native batch processing environment (BPE)
- A powerful COBOL compiler
- A streamlined runtime environment
- A graphical source-level debugger
- A portable indexed file system

By using UniKix to rehost mainframe applications, you can take advantage of these features. You can also:

- Avoid licensing fees for mainframe software.
- Reduce infrastructure maintenance and operating costs.
- Minimize risk and disruption by retaining existing user interfaces and business logic.
- Modernize your IT environment.
- Capitalize on Azure solutions for scalability, high availability, and disaster recovery.
- Implement a modern DevOps workflow with NTT DATA tools and select Azure tools.

This article outlines a solution for rehosting mainframe applications on Azure. Besides UniKix, the solution's core components include Azure ExpressRoute, Azure Site Recovery, and Azure storage and database services.

## Potential use cases

Industries that use mainframes can benefit from UniKix rehosting solutions. The following sectors that process large volumes of transactions on a daily basis are possibilities:

- Banking and finance
- Insurance
- Healthcare
- The military and government
- E-commerce and retail

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The solution uses Site Recovery to mirror Azure VMs to a secondary Azure region. If the primary datacenter fails, the secondary region provides quick failover and disaster recovery.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This solution uses an Azure network security group to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Azure provides cost optimization by running on VMs. You can turn off the VMs when not in use, and script a schedule for known usage patterns. For more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm), see the [Azure Well-Architected Framework](/azure/well-architected/).

- For managed disks, the VMs in this solution use either Premium SSD or Ultra Disk Storage. For more information about disk options and pricing, see [Managed disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

- To estimate the cost of implementing this solution, use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Richard Berry](https://www.linkedin.com/in/richardberryjr) | Senior Program Manager

Other contributors:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Program Manager
- [Jonathon Frost](https://www.linkedin.com/in/jjfrost) | Principal Program Manager

## Next steps

- For more information about rehosting on Azure, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- For more information about using NTT DATA software for rehosting, contact [NTTReHost.Cloud@nttdata.com](mailto:NTTReHost.Cloud@nttdata.com).
- To see how to deploy UniKix in Azure, see these resources:

  - [Deploying NTT DATA UniKix in Azure, Part 1](https://techcommunity.microsoft.com/t5/azure-global/deploying-ntt-data-unikix-in-azure-part-1-deploying-the-vm/ba-p/775840)
  - [Deploying NTT DATA UniKix in Azure, Part 2](https://techcommunity.microsoft.com/t5/azure-global/deploying-ntt-data-unikix-in-azure-part-2-configure-tpe-and/ba-p/779142)

- To learn more about components in the solution, see these articles:

  - [Azure ExpressRoute](/azure/expressroute/expressroute-introduction)
  - [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
  - [Introduction to Azure managed disks](/azure/virtual-machines/managed-disks-overview)
  - [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
  - [About Site Recovery](/azure/site-recovery/site-recovery-overview)

## Related resources

- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Move mainframe compute to Azure](/azure/virtual-machines/workloads/mainframe-rehosting/concepts/mainframe-compute-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [General mainframe refactor to Azure](./general-mainframe-refactor.yml)
- [AIX UNIX on-premises to Azure Linux migration](../unix-migration/migrate-aix-azure-linux.yml)
