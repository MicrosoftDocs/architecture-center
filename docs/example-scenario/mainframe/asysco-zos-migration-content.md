This article describes how [Avanade's Automated Migration Technology](https://www.avanade.com/solutions/cloud-and-application-services/amt) (AMT) migrates an IBM z/OS mainframe system to the Azure cloud. The AMT framework converts proprietary IBM z/OS mainframe applications into native .NET applications that run on Windows Server OS virtual machines (VMs). On-premises mainframe resources migrate to cost-effective, scalable, secure Azure infrastructure as a service (IaaS) and platform as a service (PaaS) environments.

## Architecture

:::image type="content" source="./media/avanade-zos-migration.svg" alt-text="Diagram showing how Avanade AMT migration maps z/OS mainframe components to Azure capabilities." lightbox="./media/avanade-zos-migration.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/avanade-amt-zos-migration.vsdx) of this architecture.*

## Workflow

The preceding diagram shows how the typical components of an IBM z/OS mainframe system can map and migrate to Azure capabilities.

1. A web browser to access Azure resources replaces standard mainframe protocols like HTTPS and [TN3270 terminal emulation](https://en.wikipedia.org/wiki/3270_emulator) for demand and online users. Users access web-based applications over a private Azure ExpressRoute connection through Transport Layer Security (TLS) port 443.

1. For security and performance, this solution deploys all Azure resources in an Azure Virtual Network, with a network security group to help manage traffic.

1. For admin access to the Azure VMs, Azure Bastion hosts maximize security by minimizing open ports.

1. AMT converts mainframe presentation loads to VM server farms. Two sets of two VMs run the web and application layers. The VMs use Premium SSD or Ultra managed disks with Accelerated Networking for high performance.

   Azure Load Balancer fronts the VMs running the web and application layers in an *active-active* arrangement to spread query traffic.

   Presentation layer code runs in IIS and uses ASP.NET to maintain the z/OS mainframe user-interface screens. You can leave web applications' presentation layers unchanged, to minimize user retraining, or you can update the presentation layers with modern user experience frameworks.

1. Server farms are built to accommodate the converted mainframe batch and transaction loads with scale set capability to handle workload peaks. An Azure Load Balancer fronts the Transaction servers to distribute the traffic in an active-active arrangement across the server farm.

1.	The mainframe application code is converted to either .NET C# or Java artifacts. ; tThis migrated code runs on the Transaction servers to provide the current business logic.

1.	AMT Transform automates the migration of all DB2, IMS, Adabas, VSAM files, hierarchical, network, relational databases, and schemas to modern databases and file handling.

    AMT Transform converts Job Control Language (JCL) and Rexx scripts to PowerShell (.NET C#) or Python, or Java. Azure Private Link provides a private, direct connection from the Azure VMs to the databases.


1. Workload automation, scheduling, reporting, and system monitoring functions that are Azure-capable can keep their current platforms. This example uses AMT Control Center for operations.

   The system can support printers and other legacy system output devices if they have IP addresses connected to the Azure network.

1. Azure Site Recovery mirrors the Azure VMs to a secondary Azure region for quick failover and disaster recovery in case of Azure datacenter failure.

### Components

- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) extends your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. You can use ExpressRoute to establish connections to cloud services like Azure and Microsoft 365.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed platform as a service (PaaS) that you provision inside your virtual network. Azure Bastion provides secure and seamless Remote Desktop Protocol (RDP) and secure shell (SSH) connectivity to the VMs in your virtual network directly from the Azure portal over TLS.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) provides on-demand, scalable computing resources that give you the flexibility of virtualization without having to buy and maintain physical hardware.

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for Azure private networks. With Virtual Network, Azure resources like VMs can securely communicate with each other, the internet, and on-premises networks. An Azure Virtual Network is similar to a traditional network on premises, but with Azure infrastructure benefits like scalability, availability, and isolation.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface) let Azure VMs communicate with internet, Azure, and on-premises resources. You can add several network interface cards to one Azure VM, so child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure Managed Disks](/azure/virtual-machines/windows/managed-disks-overview) provides block-level storage volumes that Azure manages on Azure VMs. The available types of disks are Ultra disks, Premium solid-state drives (SSDs), Standard SSDs, and Standard hard disk drives (HDDs).

- [Azure Files](/azure/storage/files/storage-files-introduction) offers fully managed file shares in an Azure Storage account that are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently, and access files via the industry standard Server Message Block (SMB) protocol.

- [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) is a fully managed PaaS database engine that is always running on the latest stable version of SQL Server and patched OS, with 99.99% availability. SQL Database handles most database management functions like upgrading, patching, backups, and monitoring without user involvement. These PaaS capabilities let you focus on business critical, domain-specific database administration and optimization.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) uses replication, failover, and recovery processes to help keep your applications running during planned and unplanned outages.

- Azure Load Balancer offers highly available and scalable apps in minutes with built-in application load balancing for cloud services and virtual machines.  Load Balancer supports TCP/UDP-based protocols such as HTTP, HTTPS, and SMTP. With Azure Load Balancer you can provide a better customer experience to automatically scale your increasing app traffic.  You won't need to reconfigure or manage the load balancer.

### Alternatives

The AMT Framework supports several methodologies to move client workloads to Azure:

- Whole system converstion: One migration method is to convert and move the entire mainframe system to Azure at once, saving interim mainframe maintenance and facility support costs. This approach carries some risk because all processes, like application conversion, data migration, and testing, must align for a smooth transition.

- Phased application transition: A second methodology is to move applications from the mainframe to Azure gradually, with complete transition as the ultimate goal. This provides savings per application, and lessons learned to convert each application can help with subsequent conversions.

- Resource optimization with phased transition: If releasing resources on the mainframe is a goal, the phased method can provide more processing cycles on the mainframe as the applications are converted and migrated to Azure. This method results in a more complex migration due to varying factors. These factors include temporary interfaces to the mainframe and decoupling complex code. Once all migration phases are completed, the mainframe can be retired.

## Scenario details

Transforming proprietary legacy applications, infrastructures, business logic, and processes to standardized, benchmarked cloud technologies promotes agile DevOps principles and practices that are today's productivity norm. The transformation of legacy applications and infrastructures leads to more unified business and IT alignment.

[Avanade's Automated Migration Technology](https://www.avanade.com/solutions/cloud-and-application-services/amt) (AMT) migrates an IBM z/OS mainframe system to the Azure cloud. The AMT framework converts proprietary IBM z/OS mainframe applications into native .NET applications that run on Windows Server OS or Linux OS virtual machines (VMs). On-premises mainframe resources migrate to cost-effective, scalable, secure Azure infrastructure-as-a-service (IaaS) and platform-as-a-service (PaaS) environments.

The Avanade Automated Migration Technology (AMT) Framework allows an accelerated move into Azure without rewriting application code or redesigning data architecture. The migration framework converts legacy code to .NET C# or Java, while maintaining the source code layout in its original form. Application user interfaces and interactions can remain unchanged, minimizing the need for user retraining.

### Potential use cases

Many scenarios can benefit from Avanade AMT migration. Possibilities include the following cases:

- Modernizing infrastructure to avoid the high costs, limitations, and rigidity of mainframes.
- Moving mainframe workloads to the cloud without the side effects of a complete redevelopment.
- Migrating mission-critical applications to the cloud while maintaining continuity with on-premises mainframe applications.
- Implementing flexible horizontal and vertical scalability.
- Deploying high availability (HA) and disaster recovery (DR) capabilities.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Use Azure Site Recovery to mirror the Azure VMs to a secondary Azure region for quick failover and DR if there's Azure datacenter failure. 
- Use Azure autofailover group replication to manage database replication and failover to another region. 
- Use Azure Load Balancer to build resiliency into this solution. If one presentation or transaction server fails, the other servers behind the load balancer take on the workload. 

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use Azure network security groups (NSGs) to manage traffic between Azure resources. For more information, see Network security groups.
- Use Private Link to provide a private, direct connection isolated to the Azure networking backbone from the Azure VMs to Azure Database.
- Use Azure Bastion to maximize admin access security by minimizing open ports. Bastion provides secure and seamless secure RDP and SSH connectivity over TLS from the Azure portal to VMs in the virtual network.


### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Optimize costs use of reserved instances by turning off VMs when they are not needed and script schedules for known usage patterns. Avanade AMT in Azure runs on Windows or Linux VMs, making cost optimization easier.
- Ensure only one instance is involved in Site Recovery if your VMs within server sets are duplicates. With Azure Site Recovery, you pay for each protected instance.
- To estimate and calculate costs for your implementation of this solution, use the Azure pricing calculator.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

•	Avanade AMT has proven single-application scalability equivalent to at least 28,000 MIPS (Million Instructions Per Second) / 3,300 MSU’s (Million Service Units).
•	Scale out each set of servers to provide more throughput. For information, see Virtual machine scale sets.
•	Use Azure SQL Database hyperscale or business critical tiers in this solution, for high input/output operations per second (IOPS) and high uptime SLA. For pricing information, see Azure SQL Database pricing.
Use SSD or Ultra Managed Disks.  For pricing information, see Managed Disks pricing.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- Visit the Avanade CIO’s guide to mainframe modernization Automated Migration Technology | Avanade.
- Visit the Avanade website.

- See the blog post [MIPS Equivalent Sizing for IBM CICS COBOL Applications Migrated to Microsoft Azure](https://techcommunity.microsoft.com/t5/azure-global/mips-equivalent-sizing-for-ibm-cics-cobol-applications-migrated/ba-p/731665).

## Related resources

- [Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml).
