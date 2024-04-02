This article describes how [Avanade's Automated Migration Technology (AMT)](https://www.avanade.com/en-us/solutions/cloud-and-application-services/amt) migrates Unisys Master Control Program (MCP) source code and emulated MCP systems to the Azure cloud.

The AMT framework converts proprietary Unisys mainframe application source code and emulated MCP applications based on the following chart:

| **Primary source code** | **Target operating system** | **Target runtime** |
|:--------------:|:-----------:|:------------:|
| COBOL | Windows or Linux| .NET C# or Java|
| XGEN | Windows or Linux| .NET C# or Java |
| LINC/ABSuite|Windows|.NET C#|

On-premises Unisys mainframe and emulated MCP resources migrate to cost-effective, scalable, secure Azure infrastructure as a service (IaaS) and platform as a service (PaaS) environments.

## Legacy architecture

:::image type="content" source="./media/unisys-components.svg" alt-text="Diagram that shows Unisys Burroughs MCP or Unisys Sperry OS 1100/2200 mainframe components." lightbox="./media/unisys-components.svg" border="false":::

_Figure 1. Typical components of Unisys Burroughs MCP or Unisys Sperry OS 1100/2200 mainframe systems._

### Workflow

- On-premises administrator users interact with the mainframe through Terminal Emulator (MCP systems) or UTS Terminal Emulator (OS 1100/2200 systems) (**A**). On-premises web interface users can interact via a web browser over TLS 1.3 port 443 (**B**). Mainframes use communication standards like IPv4, IPv6, SSL/TLS, Telnet, FTP, and Sockets.

- Loosely coupled integrated middleware includes web services, MOM, WebSphere MQ, and MSMQ. Environment integrators include Java, .NET, Tuxedo, and packages like SAP. Other middleware includes direct data access via ODBC, JDBC, and JCA connectors, and XML providers.

- Application servers (**C**) do batch processing and handle transactions through COMS Transaction Management server for MCP, or High Volume/Transaction Interface Packages (TIP/HVTIP) for OS 2200.

- Applications (**D**) for MCP are written in COBOL, C, PASCAL, ALGOL, RPG, or WFL. For OS 2200, applications are in COBOL, Fortran, C, MASM, SSG, PASCAL, UCOBOL, or ECL (2200).

- Database management systems (**E**) are XA-compliant. MCP uses hierarchical DMS II database systems, and OS 2200 uses network-based DMS II or relational database systems.

- File facilities (**F**) include CIFS (Common Internet File System), sequential, flat files, keyed IO, and virtual tape files.

- A dedicated server handles operations and monitoring (**G**).

- A printer subsystem (**H**) manages on-premises printers.

## Azure Architecture

_Figure 2. How the Unisys mainframe components map and migrate to Azure capabilities._

:::image type="content" source="./media/avanade-unisys-migration.svg" alt-text="Diagram that shows how Unisys mainframe components can map to Azure capabilities." lightbox="./media/avanade-unisys-migration.svg" border="false":::

### Workflow

1. A web browser to access Azure resources replaces standard mainframe protocols like T27 terminal emulation for demand and online users. Users access web-based applications over a private Azure ExpressRoute connection by using Transport Layer Security (TLS) port 443 **(A)**. For security and performance, this solution deploys all Azure resources in an Azure Virtual Network, with a network security group to help manage traffic. For administrator access to the Azure Virtual Machines (VMs), Azure Bastion hosts maximize security by minimizing open ports.

1. AMT converts Unisys mainframe and emulated MCP presentation workloads to run on Azure Virtual Machine Scale Sets. These virtual machines (VMs) run original web and application layers. The Virtual Machines use Premium SSD or Ultra managed disks with Accelerated Networking for high performance. Azure Load Balancer load balances traffic to the Virtual Machines. The Virtual Machines run the web and application layers in an active-active arrangement to spread query traffic. Presentation layer code runs in the web presentation service and uses the AMT framework to provide the Unisys user-interface screens **(B)**. The original presentation layers are migrated functionally unchanged to minimize user retraining. The presentation layers are updated with a web based modern user experience framework.

1. Server farms are built to accommodate the converted mainframe batch and transaction workloads. Virtual Machine Scale Sets capability to handle workload peaks **(C)**. A Load Balancer fronts the transaction servers. It distributes the traffic in active-active arrangement and spreads transaction traffic across the server farm.

1. The mainframe application code **(D)** is converted to either .NET, C#, or Java artifacts. This migrated code runs on the Transaction servers to provide the current business logic.

1. Legacy database structures **(E)** can be migrated to modern databases, which take advantage of the high availability (HA) and disaster recovery (DR) capabilities that Azure provides. Avanade AMT data migration tools can convert DMSII and RDMS schemas to modern Databases. Azure Private Link provides a private, direct connection from the Virtual Machines to the Databases.

1. File structures **(F)** map easily to Azure structured file or blob storage data constructs. Features like Azure auto-failover group replication can provide data protection.

1. Workload automation, scheduling, reporting, and system monitoring systems **(G)** that are Azure-capable can keep their current platforms. These platforms include Unisys Operations Sentinel and SMA OpCon. Avanade AMT Control Center can also perform these tasks.

1. Azure Site Recovery HA/DR capabilities mirror the Virtual Machines to a secondary Azure region for quick failover if there's Azure datacenter failure.

1. The system can support printers **(H)** and other legacy system output devices if they have IP addresses connected to the Azure network.

### Components

- [Virtual Machines](https://azure.microsoft.com/services/virtual-machines) provides on-demand, scalable computing resources. Virtual Machines gives you the flexibility of virtualization without requiring you to buy and maintain physical hardware.

- [Virtual networks](https://azure.microsoft.com/products/virtual-network) are the fundamental building blocks for Azure private networks. Virtual networks let Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. Although a virtual network is similar to a traditional on-premises network, it offers the added benefits of Azure's infrastructure, such as scalability, availability, and isolation.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface?tabs=azure-portal) let VMs communicate with internet, Azure, and on-premises resources. You can add several network interface cards to one Virtual Machine so that child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure managed disks](https://azure.microsoft.com/products/storage/disks) are block-level storage volumes that Azure manages on Virtual Machines. The available types of disks are ultra disks, premium solid-state drives (SSDs), standard SSDs, and standard hard disk drives (HDDs). This architecture works best with Premium SSDs or Ultra Disk SSDs.

- [Azure Files](https://azure.microsoft.com/products/storage/files) offers fully managed file shares in your Azure Storage Account that are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently and access files via the industry standard Server Message Block (SMB) protocol.

- [ExpressRoute](https://azure.microsoft.com/products/expressroute) lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to cloud services like Azure and Office 365.

- [Azure Bastion](https://azure.microsoft.com/products/azure-bastion) is a fully managed PaaS that you provision inside your virtual network. Azure Bastion provides secure and seamless RDP and SSH connectivity to the VMs in your virtual network directly from the Azure portal over TLS.

- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database) is a fully managed PaaS database engine that runs on the latest stable version of SQL Server and patched OS, with 99.99% availability. SQL Database handles most database management functions like upgrading, patching, backups, and monitoring without user involvement. These PaaS capabilities let you focus on business critical, domain-specific database administration and optimization.

- [Private Link](https://azure.microsoft.com/products/private-link) for SQL Database provides a private, direct connection that's isolated to the Azure networking backbone from the Virtual Machines to SQL Database.

- [Site Recovery](https://learn.microsoft.com/en-us/azure/site-recovery/site-recovery-overview) uses replication, failover, and recovery processes to help keep your applications running during planned and unplanned outages.

- [Load Balancer](https://azure.microsoft.com/en-us/solutions/load-balancing-with-azure/) offers highly available and scalable apps in minutes with built-in application load balancing for cloud services and VMs. Load Balancer supports TCP/UDP-based protocols such as HTTP, HTTPS, and SMTP. With Load Balancer, you can provide a better customer experience to automatically scale your increasing app traffic. You won't need to reconfigure or manage the load balancer.

## Scenario details

The transformation of proprietary legacy applications, infrastructure, business logic, and processes to standardized, benchmarked cloud technologies helps promote agile DevOps principles and practices that are today's productivity norm. The transformation of legacy applications and infrastructures leads to unified business and IT alignment.

Unisys ClearPath mainframe systems are full-featured operating environments that can scale up vertically to handle mission-critical workloads. ClearPath mainframe models include Dorado, which runs Legacy Sperry 1100/2200, and Libra, which runs Legacy Burroughs A Series/MCP. Emulating, converting, or modernizing these systems into Azure can provide similar or better performance and service-level agreement (SLA) guarantees, while taking advantage of Azure flexibility, reliability, and future capabilities.

The Avanade Automated Migration Technology (AMT) Framework allows an accelerated move into Azure without rewriting application code or redesigning data architecture. The framework converts legacy code to C#, while maintaining the source code in its original form. Application user interfaces and interactions can be virtually unchanged, minimizing the need for end user retraining.

Avanade AMT Transform automates the migration of the complete mainframe ecosystem to Azure by converting:

- COBOL application code to AMT COBOL, or directly to .NET C# or Java.
- XGEN application code directly to .NET C# or Java.
- LINC / ABSuite application code directly to .NET C#.
- Unisys databases, whether hierarchical, network, or relational, to Azure modern databases.
- WFL/ECL scripts to Windows PowerShell (.NET C#), Python, or Java.
- All binary and indexed flat files.

### Potential use cases

The AMT Framework supports several options to move client workloads to Azure:

- _Whole system conversion_: One migration method is to convert and move the entire mainframe system to Azure at once, saving interim mainframe maintenance and facility support costs. You should carefully consider and manage this approach because all processes, such as application conversion, data migration, and testing, must align for a smooth transition. This approach should be carefully considered and managed as all processes, like application conversion, data migration, and testing must align for a smooth transition.
- _Phased application transition_: A second methodology is to move applications from the mainframe to Azure using a phased approach with complete transition as the ultimate goal. This approach provides savings per application and lessons learned when converting each application can help with subsequent conversions.
- _Resource optimization with phased transition_: If the goal is to release resources on the mainframe, the phased method can provide more processing cycles on the mainframe as the applications are converted and migrated to Azure. This method results in a more complex migration due to varying factors. These factors include setting up temporary interfaces to the mainframe and decoupling complex code. You can retire the mainframe after all migration phases are complete.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar]( /azure/well-architected/reliability/). Follow these reliability recommendations:
- Use [Site Recovery](https://azure.microsoft.com/en-us/products/site-recovery/) to mirror the Virtual Machines to a secondary Azure region for quick failover and DR if there's Azure datacenter failure.
- Use [Azure auto-failover group replication](https://learn.microsoft.com/en-us/azure/azure-sql/database/failover-group-sql-db?view=azuresql) to manage database replication and failover to another region.
- Use [Load Balancer](https://azure.microsoft.com/en-us/solutions/load-balancing-with-azure/) to build resiliency into this solution. If one presentation or transaction server fails, the other servers behind the load balancer take on the workload.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview). Follow these security recommendations:

- Use Azure network security groups (NSGs) to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- Use [Private Link for SQL Database](/azure/azure-sql/database/private-endpoint-overview) to provide a private, direct connection isolated to the Azure networking backbone from the Virtual Machines to SQL Database.

- Use [Azure Bastion](/azure/bastion/bastion-overview) to maximize administrator access security by minimizing open ports. Azure Bastion provides secure and seamless secure RDP and SSH connectivity over TLS from the Azure portal to virtual machines in the virtual network.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost-optimization/). Follow these cost optimization recommendations:

- You can optimize use of reserved instances by turning off VMs when they aren't needed and script schedules for known usage patterns. Avanade AMT in Azure runs on Windows or Linux VMs, which makes cost optimization easier.

- Ensure only one instance is involved in Site Recovery if your VMs within server sets are duplicates. With Site Recovery, you pay for each protected instance.

To estimate and calculate costs for your implementation of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/performance-efficiency).

- Avanade AMT has proven single-application scalability equivalent to at least 28,000 MIPS (Million Instructions Per Second).

- Use Virtual Machine Scale Sets so each set of servers can scale out to provide more throughput. For information, see [Virtual Machine Scale Sets](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview).

- Use SQL Database uses hyperscale or business critical tiers for high input/output operations per second (IOPS) and high uptime SLAs. For pricing information, see [SQL Database pricing](https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/single/).

- Use Premium SSD or Ultra Managed Disks for the best performance. For pricing information, see [Managed Disks pricing](https://azure.microsoft.com/en-us/pricing/details/managed-disks/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Visit the [Avanade CIO’s guide](https://www.avanade.com/en/solutions/cloud-and-application-services/amt) to mainframe modernization Automated Migration Technology | Avanade.
- Visit the [Avanade website](https://www.avanade.com/en-us).
- See the [Microsoft Azure Well-Architected Framework](https://www.avanade.com/en-us) for more information about cost optimization for Virtual Machines instances.

## Related resources

Explore related resources:

- [Unisys ClearPath Forward MCP mainframe rehost to Azure using Unisys virtualization](../../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)
- [Unisys ClearPath Forward OS 2200 enterprise server virtualization on Azure](../../mainframe/virtualization-of-unisys-clearpath-forward-os-2200-enterprise-server-on-azure.yml)
- [SMA OpCon in Azure](../../solution-ideas/articles/sma-opcon-azure.yml)
- [High-volume batch transaction processing](../../example-scenario/mainframe/process-batch-transactions.yml)
- [Mainframe file replication and synchronization on Azure](../../solution-ideas/articles/mainframe-azure-file-replication.yml)
- [Mainframe access to Azure databases](../../solution-ideas/articles/mainframe-access-azure-databases.yml)
- [Replicate and synchronization mainframe data in Azure](./sync-mainframe-data-with-azure.yml)
- [Unlock legacy data with Azure Stack](../../solution-ideas/articles/unlock-legacy-data.yml)
- [Modernize mainframe & midrange data](../../example-scenario/mainframe/modernize-mainframe-data-to-azure.yml)
