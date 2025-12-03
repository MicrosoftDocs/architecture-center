This article describes an architecture that uses Azure services to provide scale-out performance and high availability that's similar to IBM z/OS mainframe systems with coupling facilities (CFs).

## Mainframe architecture

The following diagram shows the architecture of an IBM z/OS mainframe system with coupling facility and Parallel Sysplex components:

:::image type="content" source="media/refactor-zos-coupling-facility-1.svg" alt-text="Diagram that shows IBM z/OS mainframe architecture with coupling facility and Parallel Sysplex components." lightbox="media/refactor-zos-coupling-facility-1.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/refactor-zos-coupling-facility.vsdx) of this architecture.*

### Workflow

- Input travels into the mainframe over Transmission Control Protocol/Internet Protocol (TCP/IP) via standard mainframe protocols, like TN3270 and Hypertext Transfer Protocol Secure (HTTPS) **(A)**.

- Batch processing or online transaction processing applications receive the input **(B)**. Batch jobs can spread or clone across multiple central electronics complexes (CECs) that share data in the data tier. The online tier can spread a logical Customer Information Control System (CICS) region across multiple CECs via Parallel Sysplex CICS or CICSPlex.
- Common Business Oriented Language (COBOL), PL/I, Assembler, or compatible applications (**C**) run in the Parallel Sysplex-enabled environment, such as a CICSPlex environment.
- Other application services (**D**) can also use shared memory across a CF.
- Parallel Sysplex-enabled data services, like IBM Db2 (**E**), provide scale-out data storage in a shared environment.
- Middleware and utility services, like MQSeries, management, and printing services (**F**), run on z/OS in each CEC.
- Logical partitions (LPARs) on each CEC (**G**) run z/OS. An architecture might also have other operating environments, like IBM z/VM, or other engines, like IBM z Integrated Information Processor (zIIP) or Integrated Facility for Linux (IFL).
- A CEC connects via the CF (**H**) to shared memory and state.
- The CF (**I**) is a physical device that connects multiple CECs to shared memory.

## Azure architecture

The following diagram shows Azure services that provide similar functionality and performance to z/OS mainframes with Parallel Sysplex and CFs.

:::image type="content" source="media/refactor-zos-coupling-facility-2.svg" alt-text="Diagram that shows how the IBM z/OS mainframe components can map to Azure capabilities." lightbox="media/refactor-zos-coupling-facility-2.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/refactor-zos-coupling-facility-azure-services.vsdx) of this architecture.*

### Workflow

1. Remote clients send input via Azure ExpressRoute or from other Azure applications. In both cases, TCP/IP is the primary connection to the system.

   A web browser accesses Azure system resources, which replaces terminal emulation for demand users and online users. Users access web-based applications over Transport Layer Security (TLS) port 443. To minimize user retraining, web applications' presentation layers can remain with minimal changes. Or you can update the presentation layer with modern user experience frameworks.

   (**1a**) For enhanced security, Microsoft Entra ID can enable and enforce authentication and authorization.

1. In Azure, access to the application compute clusters goes through [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) so that scale-out compute resources can process the input work.

1. The type of application compute cluster that's used depends on whether the application runs on virtual machines (VMs) or in a container cluster like Kubernetes. Usually, mainframe system emulation for applications that are written in PL/I or COBOL use VMs. Applications that are refactored to Java or .NET use containers. Some mainframe system emulation software also supports deployment in containers.

1. Application servers, such as Tomcat for Java or such as CICS or information management system (IMS) transaction processing monitor for COBOL, receive the input and share application state and data via Azure Cache for Redis or Remote Direct Memory Access (RDMA). This capability is similar to CF for mainframes.

1. Data services are in the application clusters so that persistent data sources can receive multiple connections. These data sources can include platform as a service (PaaS) data solutions like [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) and Azure Cosmos DB, databases on VMs like Oracle Database or IBM Db2, or Big Data repositories like Azure Databricks and Azure Data Lake Storage. Application data services can also connect to streaming data analytics services, like Apache Kafka and Azure Stream Analytics.

   Azure PaaS data services provide scalable and highly available data storage that multiple compute resources in a cluster can share. These services can also be geo-redundant.

1. The application servers host various application programs based on the language, such as Java classes in Tomcat or COBOL programs with CICS verbs in CICS emulation VMs.

1. Data services use a combination of high-performance storage on Azure Ultra Disk Storage or Azure Premium SSD, file storage on Azure NetApp Files or [Azure Files](/azure/storage/files/storage-files-introduction), and standard blob, archive, and backup storage that can be locally redundant or geo-redundant.

1. Azure Blob Storage is a common landing zone for external data sources.

1. Azure Data Factory ingests and synchronizes data from multiple internal and external data sources.

1. Azure Site Recovery provides disaster recovery (DR) for the VM components and container cluster components.

### Components

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into the Microsoft cloud over a private connection that a connectivity partner provides. With ExpressRoute, you can establish connections to cloud services like Azure and Microsoft 365.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed PaaS that you provision inside your virtual network. Azure Bastion provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity to the VMs in your virtual network directly from the Azure portal over TLS.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) distributes inbound flows from the load balancer's front end to the back-end pool instances, according to configured load-balancing rules and health probes. The back-end pool instances can be Azure VMs or instances in a virtual machine scale set. Load Balancer is the single point of contact for clients.

  Load Balancer operates at Layer 4 of the Open Systems Interconnection model. Both Level 7 application level and Level 4 network protocol level load balancers are available. The type that you should use depends on how the application input reaches the compute cluster's entry point.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides on-demand, scalable computing resources that give you the flexibility of virtualization. Azure VMs give you a choice of operating systems, including Windows and Linux.

  Most Azure high-performance computing VM sizes feature a network interface for [RDMA connectivity](/azure/virtual-machines/sizes-hpc#rdma-capable-instances).

- [Azure virtual networks](/azure/well-architected/service-guides/virtual-network) are the fundamental building blocks for Azure private networks. Use virtual networks so that Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is similar to a traditional on-premises network but with the benefits of Azure infrastructure scalability, availability, and isolation.

  Virtual network interfaces enable communication between Azure VMs and the internet, Azure resources, and on-premises resources. You can add several network interface cards to one Azure VM so that child VMs can have their own dedicated network interface devices and IP addresses. That configuration is similar to this architecture.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a fully managed Kubernetes service that you can use to deploy and manage containerized applications in container-based compute clusters.

- [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) is a fully managed, in-memory cache that improves the performance and scalability of data-intensive architectures. This architecture uses Azure Cache for Redis to share data and state between compute resources.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed PaaS database engine that runs the latest stable version of SQL Server and patched OS, with 99.99% availability. SQL Database handles upgrading, patching, backups, monitoring, and most other database management functions without user involvement. These PaaS capabilities let you focus on business-critical, domain-specific database administration and optimization.

- [Azure Private Link](/azure/private-link/private-link-overview) for SQL Database provides a private, direct connection from Azure VMs to SQL Database that only uses the Azure networking backbone.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is an Azure PaaS service for NoSQL databases.

- [Azure Database for PostgreSQL](/azure/well-architected/service-guides/postgresql) is an Azure PaaS service for PostgreSQL databases.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages on Azure VMs. The available types of disks include Ultra Disk Storage, Premium SSD, and Standard SSD. This architecture works best with Premium SSDs or Ultra Disk Storage.

- [Data Factory](/azure/data-factory/introduction) is a fully managed, serverless data integration solution that you can use to ingest, prepare, and transform data at scale.

- [Azure Files](/azure/well-architected/service-guides/azure-files) offers fully managed file shares in an Azure Storage account that are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently and access files via the industry-standard Server Message Block (SMB) protocol.

- [Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) is an Azure-based analytics service that you can use to stream data.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is an Apache Spark PaaS service for Big Data analytics.

-	[Microsoft Entra ID](/entra/fundamentals/whatis) is a Microsoft cloud-based identity and access management solution that connects people to their apps, devices, and data.

## Scenario details

CFs are physical devices that connect multiple mainframe servers or CECs to shared memory so that systems can scale out to increase performance. Applications that are written in languages like COBOL and PL/I use these tightly coupled scale-out features.

IBM Db2 databases and CICS servers can use CFs with a mainframe subsystem called Parallel Sysplex that combines data sharing and parallel computing. Parallel Sysplex enables a cluster of up to 32 systems to share workloads, which provides high performance, high availability, and DR. Mainframe CFs with Parallel Sysplex typically reside in the same datacenter, with close proximity between the CECs, but can also extend across datacenters.

Azure resources can provide similar scale-out performance with shared data and high availability. Azure compute clusters share memory through data caching mechanisms, like Azure Cache for Redis, and use scalable data technologies, like SQL Database and Azure Cosmos DB. To extend scale-out compute and high availability to distributed Azure datacenters, Azure can implement availability sets and availability groups and combine them with geo-redundant capabilities.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Availability

This architecture uses [Site Recovery](https://azure.microsoft.com/services/site-recovery) to mirror Azure VMs to a secondary Azure region for quick failover and DR if an Azure datacenter fails.

#### Resiliency

The load balancers create resiliency in this solution. If one presentation or transaction server fails, other servers behind the load balancer can run the workloads.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- This solution uses an Azure network security group (NSG) to manage traffic between Azure resources. For more information, see [NSGs](/azure/virtual-network/network-security-groups-overview).

- [Private Link for SQL Database](/azure/azure-sql/database/private-endpoint-overview) provides a private, direct connection that's isolated to the Azure networking backbone from the Azure VMs to SQL Database.

- [Azure Bastion](/azure/bastion/bastion-overview) minimizes open ports, which maximizes administrator access security. Azure Bastion provides RDP and SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

- Microsoft Entra ID is a unified security platform that integrates with most Azure services.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- In SQL Database, use the [Hyperscale or Business Critical](/azure/azure-sql/database/service-tiers-general-purpose-business-critical) SQL Database tiers for high input/output operations per second and a high-uptime SLA.

- This architecture works best with Premium SSDs or Ultra Disk SSDs. For more information, see [Managed disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

You can scale out the server sets to provide more throughput. For more information, see [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview).

## Next steps

- For more information, contact [the Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).
- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction)
- [Azure Bastion](/azure/bastion/bastion-overview)
- [Azure Load Balancer](/azure/load-balancer/load-balancer-overview)
- [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview)
- [Azure Virtual Networks](/azure/virtual-network/virtual-networks-overview)
- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [Mainframe migration overview](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/)
- [Mainframe rehosting on Azure VMs](/azure/virtual-machines/workloads/mainframe-rehosting/overview)

## Related resources

- [IBM z/OS online transaction processing on Azure](../../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml)
- [Integrate IBM mainframe and midrange message queues with Azure](../../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml)
