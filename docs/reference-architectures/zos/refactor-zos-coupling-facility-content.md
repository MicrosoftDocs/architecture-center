This architecture shows how Azure can provide scale-out performance and high availability that is similar to IBM z/OS mainframe systems with Coupling Facilities (CFs).

## Architecture

### Mainframe architecture

The following diagram shows the architecture of an IBM z/OS mainframe system with Coupling Facility and Parallel Sysplex:

:::image type="content" source="media/refactor-zos-coupling-facility-1.svg" alt-text="Diagram showing IBM z/OS mainframe architecture with Coupling Facility and Parallel Sysplex components." lightbox="media/refactor-zos-coupling-facility-1.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/refactor-zos-coupling-facility.vsdx) of this architecture.*

#### Workflow

- Input travels into the mainframe over TCP/IP, using standard mainframe protocols like TN3270 and HTTPS **(A)**.
- Receiving applications can be either batch or online systems **(B)**. Batch jobs can spread or clone across multiple CECs that share data in the data tier. The online tier can spread a logical CICS region across multiple CECs by using Parallel Sysplex CICS or CICSPlex.
- COBOL, PL/I, Assembler, or compatible applications (**C**) run in the Parallel Sysplex-enabled environment, such as a CICSPlex.
- Other application services (**D**) can also use shared memory across a CF.
- Parallel Sysplex-enabled data services like Db2 (**E**) allow for scale-out data storage in a shared environment.
- Middleware and utility services like MQSeries, management, and printing (**F**) run on z/OS in each CEC.
- Logical partitions (LPARs) on each CEC (**G**) run z/OS. Other operating environments like z/VM or other engines like zIIP or IFL might also exist.
- A CEC connects via the CF (**H**) to shared memory and state.
- The CF (**I**) is a physical device that connects multiple CECs to share memory.

### Azure architecture

The next diagram shows how Azure services can provide similar functionality and performance to z/OS mainframes with Parallel Sysplex and CFs:

:::image type="content" source="media/refactor-zos-coupling-facility-2.svg" alt-text="Diagram showing how the IBM z/OS mainframe components can map to Azure capabilities." lightbox="media/refactor-zos-coupling-facility-2.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/refactor-zos-coupling-facility.vsdx) of this architecture.*

#### Workflow

1. Input comes from remote clients via Express Route, or from other Azure applications. In either case, TCP/IP is the primary connection to the system.

   A web browser to access Azure system resources replaces terminal emulation for demand and online users. Users access web-based applications over TLS port 443. Web applications' presentation layers can remain virtually unchanged, to minimize end user retraining. Or you can update the web application presentation layer with modern user experience frameworks.

   For admin access to the Azure Virtual Machines (VMs), [Azure Bastion](/azure/bastion/bastion-overview) hosts maximize security by minimizing open ports.

1. In Azure, access to the application compute clusters is through [Azure Load Balancer](/azure/load-balancer/load-balancer-overview), allowing for scale-out compute resources to process the input work.

1. The type of application compute cluster to use depends on whether the application runs on VMs or in a container cluster like Kubernetes. Usually, mainframe system emulation for applications written in PL/I or COBOL use VMs, while applications refactored to Java or .NET use containers. Some mainframe system emulation software can also support deployment in containers.

1. Application servers, such as Tomcat for Java or CICS/IMS transaction processing monitor for COBOL, receive the input, and share application state and data using Azure Cache for Redis or Remote Direct Memory Access (RDMA). This capability is similar to CF for mainframes.

1. Data services in the application clusters allow for multiple connections to persistent data sources. These data sources can include platform-as-a-service (PaaS) data services like [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) and Azure Cosmos DB, databases on VMs like Oracle or Db2, or Big Data repositories like Databricks and Azure Data Lake. Application data services can also connect to streaming data analytics services like Kafka and Azure Stream Analytics.

   Azure PaaS data services provide scalable and highly available data storage that multiple compute resources in a cluster can share. These services can also be geo-redundant.

1. The application servers host various application programs based on language, such as Java classes in Tomcat, or COBOL programs with CICS verbs in CICS emulation VMs.

1. Data services use a combination of high-performance storage on Ultra or Premium solid-state disks (SSDs), file storage on Azure NetApp Files or [Azure Files](/azure/storage/files/storage-files-introduction), and standard blob, archive, and backup storage that can be locally redundant or geo-redundant.

1. Azure Blob storage is a common landing zone for external data sources.

1. Azure Data Factory ingests and synchronizes data from multiple internal and external data sources.

1. Azure Site Recovery provides DR for the VM and container cluster components.

### Components

- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute) extends your on-premises networks into the Microsoft cloud over a private connection that a connectivity partner provides. With ExpressRoute, you can establish connections to cloud services like Azure and Office 365.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion) is a fully managed PaaS that you provision inside your virtual network. Bastion provides secure and seamless RDP and SSH connectivity to the VMs in your virtual network directly from the Azure portal over TLS.

- [Azure Load Balancer](https://azure.microsoft.com/solutions/load-balancing-with-azure) distributes inbound flows from the load balancer's front end to back-end pool instances, according to configured load-balancing rules and health probes. The back-end pool instances can be Azure VMs or instances in a virtual machine scale set. Load Balancer is the single point of contact for clients.

  Load Balancer operates at layer 4 of the Open Systems Interconnection (OSI) model. Both level 7 application level and level 4 network protocol level load balancers are available. The type to use depends on how the application input reaches the compute cluster's entry point.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) provides on-demand, scalable computing resources that give you the flexibility of virtualization. Azure VMs give you a choice of operating systems, including Windows and Linux.

  Most Azure high-performance computing (HPC) VM sizes feature a network interface for [RDMA connectivity](/azure/virtual-machines/sizes-hpc#rdma-capable-instances).

- [Azure Virtual Networks](https://azure.microsoft.com/products/virtual-network) are the fundamental building blocks for Azure private networks. Virtual networks let Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. An Azure Virtual Network is similar to a traditional on-premises network, but with the benefits of Azure infrastructure scalability, availability, and isolation.

  Virtual network interfaces let Azure VMs communicate with internet, Azure, and on-premises resources. As in this architecture, you can add several network interface cards to one Azure VM, so child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service for deploying and managing containerized applications in container-based compute clusters.

- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed, in-memory cache that improves the performance and scalability of data-intensive architectures. The current architecture uses Azure Cache for Redis to share data and state between compute resources.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed PaaS database engine that always runs the latest stable version of SQL Server and patched OS, with 99.99% availability. SQL Database handles upgrading, patching, backups, monitoring, and most other database management functions without user involvement. These PaaS capabilities let you focus on business critical, domain-specific database administration and optimization.

- [Azure Private Link](https://azure.microsoft.com/products/private-link) for Azure SQL Database provides a private, direct connection from Azure VMs to Azure SQL Database that is isolated to the Azure networking backbone.

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is an Azure PaaS service for NoSQL databases.

- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql) is an Azure PaaS service for PostgreSQL databases.

- [Azure managed disks](https://azure.microsoft.com/products/storage/disks) are block-level storage volumes that Azure manages on Azure VMs. The available types of disks are ultra disks, premium SSDs, standard SSDs, and standard hard disk drives (HDDs). This architecture works best with Premium SSDs or Ultra Disk SSDs.

- [Azure Data Factory](https://azure.microsoft.com/services/data-factory) is a fully managed, serverless data integration solution for ingesting, preparing, and transforming data at scale.

- [Azure Files](https://azure.microsoft.com/products/storage/files) offers fully managed file shares in an Azure Storage Account that are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently, and access files via the industry-standard Server Message Block (SMB) protocol.

- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics) is an Azure-based analytics service for streaming data.

- [Azure Databricks](https://azure.microsoft.com/services/databricks) is an Apache Spark PaaS service for Big Data analytics.

## Scenario details

Coupling Facilities (CFs) are physical devices that connect multiple mainframe servers or Central Electronics Complexes (CECs) with shared memory, letting systems scale out to increase performance. Applications written in languages like COBOL and PL/I seamlessly take advantage of these tightly coupled scale-out features.

IBM Db2 databases and Customer Information Control System (CICS) servers can use CFs with a mainframe subsystem called Parallel Sysplex that combines data sharing and parallel computing. Parallel Sysplex allows a cluster of up to 32 systems to share workloads for high performance, high availability, and disaster recovery (DR). Mainframe CFs with Parallel Sysplex typically reside in the same datacenter, with close proximity between the CECs, but can also extend across datacenters.

Azure resources can provide similar scale-out performance with shared data and high availability. Azure compute clusters share memory through data caching mechanisms like Azure Cache for Redis, and use scalable data technologies like Azure SQL Database and Azure Cosmos DB. Azure can implement availability sets and groups, combined with geo-redundant capabilities, to extend scale-out compute and high availability to distributed Azure datacenters.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

This architecture uses [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery) to mirror Azure VMs to a secondary Azure region for quick failover and DR if an Azure datacenter fails.

### Resiliency

Resiliency is built into this solution because of the Load Balancers. If one presentation or transaction server fails, other servers behind the Load Balancer can run the workloads.

### Scalability

You can scale out the server sets to provide more throughput. For more information, see [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- This solution uses an Azure network security group (NSG) to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- [Private Link for Azure SQL Database](/azure/azure-sql/database/private-endpoint-overview) provides a private, direct connection isolated to the Azure networking backbone from the Azure VMs to Azure SQL Database.

- [Azure Bastion](/azure/bastion/bastion-overview) maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Azure SQL Database should use [Hyperscale or Business Critical](/azure/azure-sql/database/service-tiers-general-purpose-business-critical) SQL Database tiers for high input/output operations per second (IOPS) and high uptime SLA.

- This architecture works best with Premium SSDs or Ultra Disk SSDs. For more information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction)
- [Azure Bastion](/azure/bastion/bastion-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview)
- [Azure Virtual Networks](/azure/virtual-network/virtual-networks-overview)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture)
- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Mainframe rehosting on Azure virtual machines](/azure/virtual-machines/workloads/mainframe-rehosting/overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [IBM z/OS online transaction processing on Azure](/azure/architecture/example-scenario/mainframe/ibm-zos-online-transaction-processing-azure)
- [Integrate IBM mainframe and midrange message queues with Azure](/azure/architecture/example-scenario/mainframe/integrate-ibm-message-queues-azure)
