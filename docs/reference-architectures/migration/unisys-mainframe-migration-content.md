This article describes how to use [Avanade Automated Migration Technology (AMT)](https://www.avanade.com/en-us/solutions/cloud-and-application-services/amt) to migrate Unisys Master Control Program (MCP) source code and emulated MCP systems to the Azure cloud.

You can use the AMT framework to convert proprietary Unisys mainframe application source code and emulated MCP applications based on the following configurations:

| Primary source code | Target operating system (OS) | Target runtime |
|:--------------:|:-----------:|:------------:|
| COBOL | Windows or Linux| .NET C# or Java|
| XGEN | Windows or Linux| .NET C# or Java |
| LINC/AB Suite|Windows|.NET C#|

Use an on-premises Unisys mainframe and emulated MCP resources to migrate to cost-effective, scalable, secure Azure infrastructure as a service (IaaS) and platform as a service (PaaS) environments.

## Legacy architecture

:::image type="content" source="./media/unisys-components.svg" alt-text="Diagram that shows Unisys Burroughs MCP or Unisys Sperry OS 1100/2200 mainframe components." lightbox="./media/unisys-components.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/unisys-components.vsdx) of this architecture.*

### Workflow

A. On-premises administrator users interact with the mainframe via a terminal emulator (MCP systems) or a UTS terminal emulator (OS 1100/2200 systems).

B. On-premises web interface users can interact via a web browser over Transport Layer Security (TLS) 1.3 port 443. Mainframes use communication standards like IPv4, IPv6, SSL/TLS, Telnet, FTP, and sockets.

   Loosely coupled integrated middleware includes web services, MOM, WebSphere MQ, and MSMQ. Environment integrators include Java, .NET, Tuxedo, and packages like SAP. Middleware that provides direct data access includes ODBC, JDBC, and JCA connectors, and XML providers.

C. Application servers do batch processing and handle transactions via COMS Transaction Management Server for MCP or High Volume/Transaction Interface Packages (TIP/HVTIP) for OS 2200.

D. Applications for MCP are written in COBOL, C, PASCAL, ALGOL, RPG, or WFL. For OS 2200, applications are in COBOL, Fortran, C, MASM, SSG, PASCAL, UCOBOL, or ECL (2200).

E. Database management systems are XA-compliant. MCP uses hierarchical DMSII database systems, and OS 2200 uses network-based DMSII or relational database systems.

F. File facilities include the Common Internet File System (CIFS) protocol, sequential files, flat files, keyed input/output (I/O) files, and virtual tape files.

G. A dedicated server handles operations and monitoring.

H. A printer subsystem manages on-premises printers.

## Azure architecture

:::image type="content" source="./media/avanade-unisys-migration.svg" alt-text="Diagram that shows how Unisys mainframe components can map to Azure capabilities." lightbox="./media/avanade-unisys-migration.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/avanade-unisys-migration.vsdx) of this architecture.*

### Workflow

1. A web browser accesses Azure resources. This method replaces standard mainframe protocols like T27 terminal emulation for demand and online users. Users access web-based applications over a private Azure ExpressRoute connection by using TLS port 443 **(A)**. For security and performance, this solution deploys all Azure resources in an Azure virtual network, with a network security group to help manage traffic. For administrator access to the Azure virtual machines (VMs), Azure Bastion hosts maximize security by minimizing open ports.

1. AMT converts Unisys mainframe and emulated MCP presentation workloads to run on Azure Virtual Machine Scale Sets. These VMs run original web and application layers. The VMs use Premium SSD or Ultra Disk Storage with accelerated networking for high performance. Azure Load Balancer load balances traffic to the VMs. The VMs run the web and application layers in an active-active arrangement to spread query traffic. Presentation layer code runs in the web presentation service and uses the AMT framework to provide the Unisys user-interface screens **(B)**. The original presentation layers are migrated functionally unchanged to minimize user retraining. The presentation layers are updated with a web based modern user experience framework.

1. Server farms are built to accommodate the converted mainframe batch and transaction workloads. Virtual Machine Scale Sets handles workload peaks **(C)**. A load balancer fronts the transaction servers. It distributes the traffic in an active-active arrangement and spreads transaction traffic across the server farm.

1. The mainframe application code **(D)** is converted to either .NET, C#, or Java artifacts. This migrated code runs on the transaction servers to provide the current business logic.

1. Legacy database structures **(E)** can be migrated to modern databases, which take advantage of the high availability (HA) and disaster recovery (DR) capabilities that Azure provides. Avanade AMT data migration tools can convert DMSII and RDMS schemas to modern databases. Azure Private Link provides a private, direct connection from the VMs to the databases.

1. File structures **(F)** map to Azure structured file or blob storage data constructs. Features like Azure automatic failover group replication can provide data protection.

1. Workload automation, scheduling, reporting, and system monitoring systems **(G)** that are compatible with Azure can keep their current platforms. These platforms include Unisys Operations Sentinel and SMA OpCon. Avanade AMT Control Center can also perform these tasks.

1. Azure Site Recovery HA/DR capabilities mirror the VMs to a secondary Azure region for quick failover if there's an Azure datacenter failure.

1. The system can support printers **(H)** and other legacy system output devices if they have IP addresses connected to the Azure network.

### Components

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides on-demand, scalable computing resources. Virtual Machines gives you the flexibility of virtualization without requiring you to buy and maintain physical hardware.

- [Virtual networks](/azure/well-architected/service-guides/virtual-network) are the fundamental building blocks for Azure private networks. Virtual networks let Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. Although a virtual network is similar to a traditional on-premises network, it offers the added Azure infrastructure benefits, such as scalability, availability, and isolation.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface) let VMs communicate with the internet, Azure, and on-premises resources. You can add several network interface cards to one VM so that child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure managed disks](/azure/virtual-machines/disks-types) are block-level storage volumes that Azure manages on Virtual Machines. The types of disks are Ultra Disk Storage, Premium SSD, and Standard SSD. This architecture works best with Premium SSD or Ultra Disk Storage.

- [Azure Files](/azure/well-architected/service-guides/azure-files) offers fully managed file shares in your Azure Storage account that are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently and access files via the industry standard Server Message Block (SMB) protocol.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to cloud services like Azure and Microsoft 365.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed PaaS that you provision inside your virtual network. Azure Bastion provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity to the VMs in your virtual network over TLS from the Azure portal.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed PaaS database engine that runs on the latest stable version of SQL Server and patched OS, with 99.99% availability. SQL Database handles most database management functions like upgrading, patching, backups, and monitoring without user involvement. These PaaS capabilities let you focus on business-critical, domain-specific database administration and optimization.

- [Private Link](/azure/private-link/private-link-overview) for SQL Database provides a private, direct connection that's isolated to the Azure networking backbone from the Azure VMs to SQL Database.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) uses replication, failover, and recovery processes to help keep your applications running during planned and unplanned outages.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer/reliability) provides Layer-4 load balancing for cloud services and VMs. Load Balancer supports TCP/UDP-based protocols such as HTTP, HTTPS, and SMTP and distributes traffic across healthy instances.

## Scenario details

This solution transforms proprietary legacy applications, infrastructure, business logic, and processes to standardized, benchmarked cloud technologies to help promote agile DevOps principles and practices and align with today's productivity norm. Transform legacy applications and infrastructures to provide unified business and IT alignment.

Unisys ClearPath mainframe systems are full-featured operating environments that can scale up vertically to handle mission-critical workloads. ClearPath mainframe models include Dorado, which runs legacy Sperry 1100/2200, and Libra, which runs legacy Burroughs A Series/MCP. Emulating, converting, or modernizing these systems into Azure can provide similar or better performance and service-level agreement (SLA) guarantees, while taking advantage of Azure flexibility, reliability, and future capabilities.

Use the Avanade AMT framework to move to Azure without rewriting application code or redesigning data architecture. The framework converts legacy code to C#, while maintaining the source code in its original form. You don't have to change application user interfaces and interactions. This approach minimizes the need for end user retraining.

Avanade AMT Transform automates the migration of the complete mainframe ecosystem to Azure by converting:

- COBOL application code to AMT COBOL, or directly to .NET C# or Java.
- XGEN application code directly to .NET C# or Java.
- LINC / AB Suite application code directly to .NET C#.
- Unisys databases, whether hierarchical, network, or relational, to Azure modern databases.
- WFL/ECL scripts to Windows PowerShell (.NET C#), Python, or Java.
- All binary and indexed flat files.

### Potential use cases

The AMT framework supports several options to move client workloads to Azure:

- *Whole system conversion*: One migration method is to convert and move the entire mainframe system to Azure at once, saving interim mainframe maintenance and facility support costs. You should carefully consider and manage this approach because all processes, such as application conversion, data migration, and testing, must align to reduce disruption during the transition.
- *Phased application transition*: A second methodology is to move applications from the mainframe to Azure using a phased approach with complete transition as the ultimate goal. You can save money on individual applications. You can also learn about the conversion for each application and apply those lessons to subsequent conversions.
- *Resource optimization with phased transition*: If the goal is to release resources on the mainframe, the phased method can provide more processing cycles on the mainframe because you convert and migrate applications to Azure. This method results in a more complex migration due to varying factors, including setting up temporary interfaces to the mainframe and decoupling complex code. You can retire the mainframe after all migration phases are complete.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Use [Site Recovery](https://azure.microsoft.com/products/site-recovery/) to mirror the VMs to a secondary Azure region for quick failover and DR if there's an Azure datacenter failure.
- Use [Azure automatic failover group replication](/azure/azure-sql/database/failover-group-sql-db) to manage database replication and failover to another region.
- Use [Load Balancer](https://azure.microsoft.com/solutions/load-balancing-with-azure/) to build resiliency into this solution. If one presentation or transaction server fails, the other servers behind the load balancer take on the workload.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use Azure network security groups (NSGs) to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- Use [Private Link for SQL Database](/azure/azure-sql/database/private-endpoint-overview) to provide a private, direct connection that's isolated to the Azure networking backbone from the VMs to SQL Database.

- Use [Azure Bastion](/azure/bastion/bastion-overview) to maximize administrator access security by minimizing open ports. Azure Bastion provides RDP and SSH connectivity over TLS from the Azure portal to VMs in the virtual network.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- You can optimize Azure Reserved Virtual Machine Instances by turning off VMs when they aren't needed and scripting schedules for known usage patterns. Avanade AMT in Azure runs on Windows or Linux VMs, which optimizes costs.

- Ensure that you use only one VM instance with Site Recovery if your VMs within server sets are duplicates. With Site Recovery, you pay for each protected instance.

- To estimate and calculate costs for your implementation of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Avanade AMT has proven single-application scalability that's equivalent to at least 28,000 million instructions per second (MIPS).

- Use Virtual Machine Scale Sets so each set of servers can scale out to provide more throughput. For more information, see [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

- SQL Database has hyperscale or business-critical tiers for high input/output operations per second (IOPS) and high uptime SLAs. For pricing information, see [SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single/).

- Use Premium SSD or Ultra Disk Storage for the best performance. For pricing information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, [contact the Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).
- Visit the [Avanade CIO's guide](https://www.avanade.com/solutions/cloud-and-application-services/amt).
- Visit the [Avanade website](https://www.avanade.com).
- For more information about cost optimization for Virtual Machines instances, see the [Microsoft Azure Well-Architected Framework](/azure/well-architected/cost-optimization).

## Related resources

Explore related resources:

- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)
- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [High-volume batch transaction processing](../../example-scenario/mainframe/process-batch-transactions.yml)
- [Mainframe file replication and synchronization on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Replicate and synchronization mainframe data in Azure](./sync-mainframe-data-with-azure.yml)
- [Modernize mainframe and midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
