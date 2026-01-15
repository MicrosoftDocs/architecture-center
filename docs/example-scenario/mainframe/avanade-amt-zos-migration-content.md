This article describes how [Avanade's Automated Migration Technology (AMT)](https://www.avanade.com/solutions/cloud-and-application-services/amt) migrates an IBM z/OS mainframe system to the Azure cloud. The Avanade AMT framework converts proprietary IBM z/OS mainframe applications into native .NET applications that run on Windows Server OS or Linux OS virtual machines (VMs). On-premises mainframe resources migrate to cost-effective, scalable, secure Azure infrastructure as a service (IaaS) and platform as a service (PaaS) environments.

## Architecture

:::image type="content" source="./media/avanade-amt-zos-migration.svg" alt-text="Diagram showing how Avanade AMT migration maps z/OS mainframe components to Azure capabilities." lightbox="./media/avanade-amt-zos-migration.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/avanade-amt-zos-migration.vsdx) of this architecture.*

## Workflow

The preceding diagram shows how the typical components of an IBM z/OS mainframe system can map and migrate to Azure capabilities.

1. A web browser accesses Azure resources, which replaces standard mainframe protocols like HTTPS and [TN3270 terminal emulation](https://wikipedia.org/wiki/3270_emulator). Users access web-based applications over a private Azure ExpressRoute connection through Transport Layer Security (TLS) port 443.

1. For security and performance, this solution deploys all Azure resources in an Azure virtual network. A network security group helps manage traffic.

1. Azure Bastion limits the number of open ports to provide maximum security for administrators when they access Azure VMs.

1. Avanade AMT converts mainframe presentation loads to VM server farms. Two sets of two VMs run the web and application layers. The VMs use Premium SSD or Ultra Disk Storage with accelerated networking for high performance.

   Azure Load Balancer fronts these VMs in an *active-active* arrangement to spread query traffic.

   Presentation layer code runs in Internet Information Services (IIS) and uses ASP.NET to maintain the z/OS mainframe user interface screens. You can leave web applications' presentation layers unchanged, to minimize user retraining, or you can update the presentation layers with modern user experience frameworks.

1. Server farms use scale set capabilities to accommodate the converted mainframe batch loads and transaction loads. The server farms handle workload peaks. An Azure load balancer fronts the transaction servers to distribute the traffic in an active-active arrangement across the server farm.

1. The mainframe application code is converted to either .NET C# or Java artifacts. This migrated code runs on the transaction servers to provide the current business logic.

1. Avanade AMT Transform automates the migration of database management systems (IBM Db2, IMS, Adabas), databases (hierarchical, network, relational), VSAM files, and schemas to modern databases and file handling.

    Avanade AMT Transform converts Job Control Language (JCL) and Rexx scripts to PowerShell (.NET C#), Python, or Java. Azure Private Link provides a private, direct connection from the Azure VMs to the databases.

1. Workload automation, scheduling, reporting, and system monitoring functions that are compatible with Azure can keep their current platforms. This example uses Avanade AMT Control Center for operations.

   The system can support printers and other legacy system output devices if they have IP addresses that are connected to the Azure network.

1. Azure Site Recovery mirrors the Azure VMs to a secondary Azure region for quick failover and disaster recovery (DR) if there's an Azure datacenter failure.

### Components

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed PaaS that provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity to VMs over TLS. In this architecture, Azure Bastion eliminates the need for public IP addresses on VMs and provides access to Azure VMs for administrators.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service that provides file shares in an Azure Storage account that can be accessed from the cloud or on-premises. In this architecture, Azure Files provides shared storage capabilities for the migrated mainframe applications and supports the file handling requirements after the conversion from VSAM files.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are block-level storage volumes that Azure manages for Azure VMs, including Ultra Disk Storage, Premium SSD, and Azure Standard SSD. In this architecture, Azure managed disks provide high-performance storage for the VMs that run the converted mainframe applications, with Premium SSD or Ultra Disk Storage options for optimal performance.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed PaaS database engine that handles most database management functions like upgrading, patching, backups, and monitoring. In this architecture, SQL Database serves as the modern database platform for migrated mainframe data. It replaces IBM Db2, IMS, Adabas, and other legacy database systems.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a compute service that provides on-demand, scalable computing resources with the flexibility of virtualization. In this architecture, Virtual Machines host the converted mainframe applications, running as server farms for web and application layers, and transaction servers for business logic processing.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for Azure private networks that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, Virtual Network provides the network infrastructure and isolation for all Azure resources, with network security groups managing traffic flow.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into the Microsoft cloud over a private connection. In this architecture, ExpressRoute provides a private connection for users to access web-based applications through TLS port 443.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer 4 load balancing service that distributes inbound traffic based on rules and health probe results. In this architecture, Load Balancer fronts the VM server farms in an active-active arrangement to distribute query traffic and transaction loads across multiple servers for high availability and scalability.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery service that uses replication, failover, and recovery processes to help keep applications running during outages. In this architecture, Site Recovery mirrors the Azure VMs to a secondary Azure region for quick failover and disaster recovery if an Azure datacenter failure occurs.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface) are networking components that provide communication between Azure VMs and the internet, Azure resources, and on-premises resources. In this architecture, virtual network interfaces enable connectivity for the VMs that host the converted mainframe applications and allow multiple network interface cards for each VM for dedicated network access.

## Scenario details

An Avanade AMT migration provides several benefits. For example, you can:

- Modernize infrastructure to prevent the high costs, limitations, and rigidity of mainframes.

- Move mainframe workloads to the cloud to prevent the necessity of a complete redevelopment.
- Migrate mission-critical applications to the cloud to maintain continuity with on-premises mainframe applications.
- Provide flexible horizontal and vertical scalability.
- Provide high-availability (HA) and DR capabilities.

This solution transforms proprietary legacy applications, infrastructures, business logic, and processes into standardized, benchmarked cloud technologies to help promote agile DevOps principles and practices that are today's productivity norm. Transform legacy applications and infrastructures to provide unified business and IT alignment.

Use the Avanade AMT framework to quickly move resources to Azure without rewriting application code or redesigning data architecture. The migration framework converts legacy code to .NET C# or Java, while maintaining the source code layout in its original form. You don't have to change application user interfaces and interactions, which minimizes the need for user retraining.

### Potential use cases

The Avanade AMT framework supports several methodologies to move your workloads to Azure:

- *Whole system conversion*: You can convert and move the entire mainframe system to Azure at one time, which reduces interim mainframe maintenance and facility support costs. You should carefully consider and manage this approach because all processes, such as application conversion, data migration, and testing, must align for a smooth transition.

- *Phased application transition*: You can move applications from the mainframe to Azure gradually, eventually completing a full transition. You can save money on individual applications. You can also learn about the conversion for each application, and apply those lessons to subsequent conversions.

- *Resource optimization with phased transition*: If your goal is to release resources on the mainframe, the phased method can provide more processing cycles on the mainframe because you convert and migrate applications to Azure. This method results in a more complex migration due to various factors, including setting up temporary interfaces to the mainframe and decoupling complex code. You can retire the mainframe after all migration phases are complete.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Use Site Recovery to mirror the Azure VMs to a secondary Azure region for quick failover and DR if there's an Azure datacenter failure.

- Use [Azure automatic failover group replication](/azure/azure-sql/database/failover-group-sql-db) to manage database replication and failover to another region.
- Use [Load Balancer](/azure/load-balancer) to build resiliency into this solution. If one presentation or transaction server fails, the other servers behind the load balancer take on the workload.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use Azure [network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) to manage traffic between Azure resources.

- Use [Private Link](/azure/azure-sql/database/private-endpoint-overview) to provide a private, direct connection that's isolated to the Azure networking backbone from the Azure VMs to SQL Database.
- Use [Azure Bastion](/azure/bastion/bastion-overview) to limit the number of open ports, which maximizes admin access security. Bastion provides secure and seamless secure RDP and SSH connectivity over TLS from the Azure portal to VMs in the virtual network.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Turn off VMs when you don't need them, and script schedules for known usage patterns to optimize Azure Reserved Virtual Machine Instances. Avanade AMT in Azure runs on Windows or Linux VMs, which optimizes costs.

- Ensure that you use only one VM instance with Site Recovery if your VMs within server sets are duplicates. With Site Recovery, you pay for each protected instance.
- To estimate and calculate costs for your implementation of this solution, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Take advantage of scaling capabilities. Avanade AMT has proven single-application scalability that's equivalent to at least 28,000 million instructions per second (MIPS) or 3,300 million service units (MSUs).

- Use [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) so each set of servers can scale out to provide more throughput.
- Use the SQL Database hyperscale tier or business-critical tier for high input/output operations per second (IOPS) and high-uptime service-level agreements (SLAs). For pricing information, see [SQL Database pricing](https://azure.microsoft.com/pricing/details/azure-sql-database/single).
- Use SSD or Ultra Disk Storage for best performance. For pricing information, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Philip Brooks](https://www.linkedin.com/in/philipbbrooks/) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, [contact the Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).
- Visit the [Avanade website](https://www.avanade.com).
- Review [the CIO's guide to mainframe modernization](https://www.avanade.com/en/solutions/cloud-and-application-services/mainframe-modernization-guide).
- Learn about [MIPS equivalent sizing for IBM CICS COBOL applications](https://techcommunity.microsoft.com/t5/azure-global/mips-equivalent-sizing-for-ibm-cics-cobol-applications-migrated/ba-p/731665).
