This article describes how [Avanade's Automated Migration Technology](https://www.avanade.com/solutions/cloud-and-application-services/amt) (AMT) migrates an IBM z/OS mainframe system to the Azure cloud. The AMT framework converts proprietary IBM z/OS mainframe applications into native .NET applications that run on Windows Server OS virtual machines (VMs). On-premises mainframe resources migrate to cost-effective, scalable, secure Azure infrastructure-as-a-service (IaaS) and platform-as-a-service (PaaS) environments.

## Architecture

:::image type="content" source="media/asysco-zos-migration.svg" alt-text="Diagram showing how Avanade A M T migration maps z/O S mainframe components to Azure capabilities." lightbox="media/asysco-zos-migration.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/asysco-zos-migration.vsdx) of this architecture.*

## Workflow

The preceding diagram shows how the typical components of an IBM z/OS mainframe system can map and migrate to Azure capabilities.

1. A web browser to access Azure resources replaces standard mainframe protocols like HTTPS and [TN3270 terminal emulation](https://en.wikipedia.org/wiki/3270_emulator) for demand and online users. Users access web-based applications over a private Azure ExpressRoute connection through Transport Layer Security (TLS) port 443.

1. For security and performance, this solution deploys all Azure resources in an Azure Virtual Network, with a network security group to help manage traffic.

1. For admin access to the Azure VMs, Azure Bastion hosts maximize security by minimizing open ports.

1. AMT converts mainframe presentation loads to VM server farms. Two sets of two VMs run the web and application layers. The VMs use Premium SSD or Ultra managed disks with Accelerated Networking for high performance.

   Azure Load Balancer fronts the VMs running the web and application layers in an *active-active* arrangement to spread query traffic.

   Presentation layer code runs in IIS and uses ASP.NET to maintain the z/OS mainframe user-interface screens. You can leave web applications' presentation layers unchanged, to minimize user retraining, or you can update the presentation layers with modern user experience frameworks.

1. Mainframe batch and transaction loads convert to sufficient server farms to handle this type of work. Another Azure Load Balancer fronts the transaction servers to distribute the traffic.

1. Application code converts to AMT COBOL or directly to .NET C#. AMT maintains the original code structure to use as a baseline or for future edits. If code needs changing or editing, AMT can maintain and reprocess the original code, or you can edit the converted C# code directly to advance the code base to new standards.

1. AMT automates migrating all DB2, IMS, and IDMS hierarchical, network, or relational databases to Azure SQL. AMT Transform converts DMS and RDMS schemas to SQL, and converts [Job Control Language (JCL)](https://en.wikipedia.org/wiki/Job_Control_Language) and [Rexx](https://en.wikipedia.org/wiki/Rexx) scripts to VBScript or Windows PowerShell. Azure Private Link for Azure SQL Database provides a private, direct connection from the Azure VMs to Azure SQL Database.

   AMT Transform also converts all binary or indexed [Virtual Storage Access Method (VSAM)](https://en.wikipedia.org/wiki/Virtual_Storage_Access_Method), flat files, and virtual tape files to Azure Files storage.

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

### Alternatives

The AMT Framework supports several methodologies to move client workloads to Azure:

- One migration method is to convert and move the entire mainframe system to Azure at once, saving interim mainframe maintenance and facility support costs. This approach carries some risk because all processes, like application conversion, data migration, and testing, must align for a smooth transition.

- A second methodology is to move applications from the mainframe to Azure gradually, with complete transition as the ultimate goal. This tactic provides savings per application, and lessons learned to convert each application can help with subsequent conversions.

Modernizing each application on its own schedule can be more relaxed than converting everything at once. If regaining time on the mainframe is a goal, the stepped method can provide more processing cycles on the mainframe as applications convert to Azure. Eventual starvation of the mainframe can highlight the need to retire the mainframe expense.

## Scenario details

Transforming proprietary legacy applications, infrastructures, and processes to standardized, benchmarked cloud technologies promotes agile DevOps principles and practices that are today's productivity norm. The transformation of legacy applications and infrastructures leads to more unified business and IT alignment.

[Avanade's Automated Migration Technology](https://www.avanade.com/solutions/cloud-and-application-services/amt) (AMT) migrates an IBM z/OS mainframe system to the Azure cloud. The AMT framework converts proprietary IBM z/OS mainframe applications into native .NET applications that run on Windows Server OS virtual machines (VMs). On-premises mainframe resources migrate to cost-effective, scalable, secure Azure infrastructure-as-a-service (IaaS) and platform-as-a-service (PaaS) environments.

AMT provides an accelerated move into Azure without rewriting application code or redesigning data architecture. The migration framework converts legacy code to C#, while maintaining the source code in its original form. Application user interfaces and interactions can remain unchanged, minimizing the need for user retraining.

### Potential use cases

Many scenarios can benefit from Avanade AMT migration. Possibilities include the following cases:

- Modernizing infrastructure to avoid the high costs, limitations, and rigidity of mainframes.
- Moving mainframe workloads to the cloud without the side effects of a complete redevelopment.
- Migrating mission-critical applications to the cloud while maintaining continuity with on-premises mainframe applications.
- Implementing flexible horizontal and vertical scalability.
- Deploying high availability (HA) and disaster recovery (DR) capabilities.

## Considerations

The following considerations apply to this solution:

### Availability

[Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) mirrors the Azure VMs to a secondary Azure region for quick failover and DR if there is Azure datacenter failure. [Azure auto-failover group replication](/azure/azure-sql/database/auto-failover-group-overview) provides data protection by managing the database replication and failover to the secondary region.

### Resiliency

Azure Load Balancer builds resiliency into this solution. If one presentation or transaction server fails, the other servers behind the load balancer take on the workload.

### Scalability

- Avanade AMT has proven single-application scalability equivalent to at least 28,000 million IBM mainframe instructions per second (MIPS).

- Each set of servers can scale out to provide more throughput. For information, see [Virtual machine scale sets](/azure/virtual-machine-scale-sets/overview).

### Security

- This solution uses an Azure network security group to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).

- [Private Link](/azure/azure-sql/database/private-endpoint-overview) provides a private, direct connection isolated to the Azure networking backbone from the Azure VMs to Azure SQL Database.

- [Azure Bastion](/azure/bastion/bastion-overview) maximizes admin access security by minimizing open ports.

### Cost optimization

Azure helps you avoid unnecessary costs by identifying resource needs, analyzing spending over time, and scaling to meet business needs without overspending. Avanade AMT in Azure runs on Windows VMs, which help you optimize costs by turning off VMs when not in use and scripting schedules for known usage patterns.

- Azure services like Virtual Network, Load Balancer, and Azure Bastion are free with your Azure subscription. You pay for usage and traffic.

- With Azure Site Recovery, you pay for each protected instance. If VMs in server sets are clones, only one instance needs to participate in Site Recovery.

- Azure SQL Database uses [hyperscale or business critical](/azure/azure-sql/database/service-tiers-general-purpose-business-critical) tiers in this solution, for high input/output operations per second (IOPS) and high uptime SLA. For pricing information, see [Azure SQL Database pricing](https://azure.microsoft.com/pricing/details/sql-database/single/).

- This solution works best with Premium SSD or Ultra Managed Disks. For pricing information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks/).

To estimate and calculate costs for your implementation of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Philip Brooks](https://www.linkedin.com/in/philipbbrooks) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, please contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).
- See the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) for more information about cost optimization for [VM instances](/azure/architecture/framework/cost/optimize-vm).
- Visit the [Azure Marketplace](https://azuremarketplace.microsoft.com/home) for information about [Asysco AMT GO](https://azuremarketplace.microsoft.com/marketplace/apps/asyscosoftwarebv.amtvmcc_basic_2019_002?tab=Overview).
- See the blog post [MIPS Equivalent Sizing for IBM CICS COBOL Applications Migrated to Microsoft Azure](https://techcommunity.microsoft.com/t5/azure-global/mips-equivalent-sizing-for-ibm-cics-cobol-applications-migrated/ba-p/731665).

## Related resources

- [Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml).
