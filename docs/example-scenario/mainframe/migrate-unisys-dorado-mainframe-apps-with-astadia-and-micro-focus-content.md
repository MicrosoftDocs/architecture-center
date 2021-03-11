Unisys Dorado mainframe systems are full-featured operating environments that can scale up vertically to handle mission-critical workloads. But emulating or modernizing these systems into Azure can provide similar or better performance and SLA guarantees. Azure systems also offer added flexibility, reliability, and future capabilities.

This architecture uses emulation technologies from two Microsoft partners, Astadia and Micro Focus. The solution provides an accelerated way to move to Azure because there's no need to:

- Rewrite application code.
- Redesign data architecture or switch from a network-based to a relational-based model.
- Change application screens. Retaining original user experiences minimizes the need for end-user retraining.

## Potential use cases

Many cases can benefit from the Astadia and Micro Focus pattern:

- Businesses with Unisys Dorado mainframe systems that can't modify original source code, such as COBOL, due to compliance factors, prohibitive costs, complexity, or other considerations.
- Organizations looking for approaches to modernizing workloads that offer:

  - A way to lift and shift application layer source code.
  - Modern platform as a service (PaaS) services and capabilities, including:

    - Azure SQL Database with its built-in high availability.
    - Azure Data Factory with its automated, server-less file routing and transformation.

## Architecture

:::image type="complex" source="./media/migrate-unisys-dorado-mainframe-apps-architecture-diagram.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from the Logic Apps icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

1. Transport Layer Security (TLS) connections that use port 443 provide access to web-based applications:

   - After migration, the web application presentation layer remains virtually unchanged. As a result, end users require minimal retraining. Alternatively, you can update the web application presentation layer to align with UX requirements.
   - Azure VM Bastion hosts work to maximize security. When giving administrators access to VMs, these hosts minimize the number of open ports.

1. The solution uses two sets of two VMs:

   - Within each set, one VM runs the web layer, and one runs the application emulation layer.
   - One set of VMs is the primary, active set. The other set is the secondary, passive set.
   - Azure Load Balancer manages approaching traffic. When the active VM set fails, the passive set comes online. The load balancer then routes traffic to that newly activated set.

1. Astadia OpenTS simulates Unisys mainframe screens. This component runs presentation layer code in Internet Information Services (IIS) and uses ASP.NET. OpenTS can either run on its own VM or on the same VM as other Astadia emulation products.

1. OpenMCS is a program from Astadia that emulates:

   - The Unisys Dorado Mainframe Transactional Interface Package (TIP).
   - Other services that Unisys mainframe COBOL programs use.

1. Micro Focus COBOL runs COBOL programs on the Windows server. There's no need to rewrite COBOL code. Micro Focus COBOL can invoke Unisys mainframe facilities through the Astadia emulation components.

1. Astadia OpenDMS emulates the Unisys Dorado mainframe DMS database access technology. With this component, you can *lift and shift* tables and data from relational-based RDMS and network-based DMS databases into Azure SQL Database.

1. Azure Storage Account File Share is mounted on the Windows server VM. COBOL programs then have easy access to the Azure files repository for file processing.

1. With either the Hyperscale or Business Critical service tier, Azure SQL Database provides:

   - High input/output operations per second (IOPS).
   - High uptime SLA.

   Private Link for Azure SQL Database provides a private, direct connection from VMs to Azure SQL Database through the Azure network backbone.

1. Azure Data Factory version 2 (V2) provides data movement pipelines that events trigger. These pipelines move files from external sources into Azure File Storage. Emulated COBOL programs then process the files.

1. Azure Site Recovery provides disaster recovery capabilities. This service mirrors the VMs to a secondary Azure region for quick failover in the rare case of an Azure datacenter failure.

### Legacy architecture

This diagram shows the components that Unisys Sperry OS 1100/2200 mainframe systems typically contain.

:::image type="complex" source="./media/migrate-unisys-dorado-mainframe-apps-original-architecture.png" alt-text="Architecture diagram showing how to use Logic Apps to respond to A P I calls by updating or accessing S Q L Server." border="false":::
   The diagram contains two boxes, one for Azure components, and one for on-premises components. Outside the Azure box is a data file labeled J S O N. An arrow points from the J S O N file into an A P I Management icon that's inside the Azure box. A second arrow points from the A P I Management icon to a Logic Apps icon that's also inside the Azure box. A third arrow points from the Logic Apps icon to an on-premises data gateway icon that's between the two boxes. A fourth arrow points from the gateway to a SQL Server icon that's inside the on-premises box. A final arrow points from the SQL Server icon to a person outside the on-premises box.
:::image-end:::

- On-premises users interact with the mainframe (**A**):

  - Admin users interact through a UTS terminal emulator.
  - Web interface users interact via a web browser over TLS 1.3 port 443.

  Mainframes use communication standards like IPv4, IPv6, SSL/TLS, Telnet, FTP, and sockets. In Azure, web browsers replace legacy terminal emulation. On-demand and online users access system resources through these web browsers.

- Mainframe applications are in COBOL, Fortran, C, MASM, SSG, PASCAL, UCOBOL, and ECL (**B**). In Azure, Micro Focus COBOL recompiles COBOL and other legacy application code to .NET. Micro Focus can also maintain and reprocess original base code whenever that code changes. This architecture doesn't require any changes in the original source code.

- Mainframe batch and transaction loads run on application servers (**C**). For transactions, these servers use Transaction Interface Packages (TIPs) or High Volume TIPs (HVTIPs). In the new architecture:

  - Server topologies handle batch and transaction workloads.
  - An Azure load balancer routes traffic to the server sets.
  - Azure Site Recovery can provide High Availability (HA) and Disaster Recovery (DR) capabilities.

- A dedicated server handles workload automation, scheduling, reporting, and system monitoring (**D**). These functions retain the same platforms in Azure.

- A printer subsystem manages on-premises printers.

- Database management systems (**E**) follow the eXtended Architecture (XA) specification. Mainframes use relational database systems like RDMS and network-based database systems like DMS II and DMS. The new architecture migrates legacy database structures to Azure SQL Database, which provides DR and HA capabilities.

- Mainframe file structures like CIFS, flat files, and virtual tape map easily to Azure data constructs within structured files or blob storage (**F**). Azure Data Factory provides a modern PaaS data transformation service that fully integrates with this architecture pattern.

### Components

This architecture uses the following components:

- [Azure VMs][What is a virtual machine?] are on-demand, scalable computing resources. An Azure VM provides the flexibility of virtualization but eliminates the maintenance demands of physical hardware.

- [Virtual Network][What is Azure Virtual Network?] is the fundamental building block for private networks in Azure. Through Virtual Network, Azure resources like virtual machines (VMs) can securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a datacenter. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.

- [Azure Virtual Network interface cards][Create, change, or delete a network interface] provide a way for VMs to communicate with the internet, Azure, and on-premises resources. As this architecture shows, you can add additional network interface cards to the same VM. With this setup, the Solaris child VMs can have their own dedicated network interface device and IP address.

- [Azure SSD managed disks][Introduction to Azure managed disks] are block-level storage volumes that Azure manages. VMs use these disks. Available types include ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD). Premium SSDs or Ultra Disk SSDs work best with this architecture.

- [Azure Files][What is Azure Files?] is a service that's part of [Azure Storage][Introduction to the core Azure Storage services]. Azure Files offers fully managed file shares in the cloud. Azure file shares are accessible via the industry standard Server Message Block (SMB) protocol. You can mount these file shares concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares.

- [Azure ExpressRoute][What is Azure ExpressRoute?] extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to Microsoft cloud services like Microsoft Azure and Microsoft 365.

- [Azure SQL Database][What is Azure SQL Database?] is a fully managed platform as a service (PaaS) database engine. With AI-powered, automated features, Azure SQL Database handles database management functions like upgrading, patching, backups, and monitoring. Azure SQL Database offers 99.99 percent availability and runs on the latest stable version of the SQL Server database engine and patched operating system. Because Azure SQL Database offers built-in PaaS capabilities, you can focus on domain-specific database administration and optimization activities that are critical for your business.

## Considerations


### Availability considerations


### Scalability considerations



### Security considerations


## Pricing

To estimate the cost of implementing this solution, use the [Azure pricing calculator][Pricing calculator].

- Calculate VM needs based on your traffic hours, load, and storage requirements. This solution helps you [optimize VM costs][Virtual machines] by:

  - Turning off VMs that aren't in use.
  - Scripting a schedule for known usage patterns.

- Azure services like Virtual Network, Load Balancer, and Azure Bastion are free with your Azure subscription. You pay for usage and traffic.
- Azure Site Recovery charges per protected instance.
- For Premium SSD or Ultra managed storage disks pricing, see [Managed Disks pricing][Managed Disks pricing].
- With Azure Hybrid Benefit, you can use your on-premises SQL Server licenses for Azure SQL Database. For more information, see the Azure Hybrid Benefit FAQ.
- See [Azure Private Link pricing][Azure Private Link pricing] to estimate costs associated with Private Link.
- For costs related to ExpressRoute, see [Azure ExpressRoute pricing][Azure ExpressRoute pricing].
- For Internet Information Services software plan charges, see [Internet Information Services pricing][Internet Information Services pricing].




## Next steps

- Contact [legacy2azure@microsoft.com][Email address for information on migrating legacy systems to Azure] for more information.
- See the [Azure Friday tech talk with Astadia on mainframe modernization][Azure is the new mainframe].

## Related resources

- [Mainframe rehosting on Azure virtual machines][Mainframe rehosting on Azure virtual machines]
- Related reference architectures:

  - [Unisys mainframe migration to Azure using Asysco][Unisys mainframe migration]
  - [Micro Focus Enterprise Server on Azure VMs][Micro Focus Enterprise Server on Azure VMs]
  - [Modernize mainframe & midrange data][Modernize mainframe & midrange data]
  - [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame][Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]

[Azure ExpressRoute pricing]: https://azure.microsoft.com/pricing/details/expressroute/
[Azure Hybrid Benefit]: https://azure.microsoft.com/pricing/hybrid-benefit/
[Azure Hybrid Benefit FAQ]: https://azure.microsoft.com/pricing/hybrid-benefit/faq/
[Azure is the new mainframe]: https://channel9.msdn.com/Shows/Azure-Friday/Azure-is-the-new-mainframe/
[Azure Private Link pricing]: https://azure.microsoft.com/pricing/details/private-link/
[Create, change, or delete a network interface]: /azure/virtual-network/virtual-network-network-interface
[Email address for information on migrating legacy systems to Azure]: mailto:legacy2azure@microsoft.com
[Internet Information Services pricing]: https://azuremarketplace.microsoft.com/marketplace/apps/cloudwhizsolutions.internet-information-server-with-windows-2019-cw?tab=PlansAndPrice
[Introduction to Azure managed disks]: /azure/virtual-machines/managed-disks-overview
[Introduction to the core Azure Storage services]: /azure/storage/common/storage-introduction
[Mainframe rehosting on Azure virtual machines]: /azure/virtual-machines/workloads/mainframe-rehosting/overview
[Managed Disks pricing]: https://azure.microsoft.com/pricing/details/managed-disks/
[Micro Focus Enterprise Server on Azure VMs]: azure/architecture/example-scenario/mainframe/micro-focus-server
[Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame]: /azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe
[Modernize mainframe & midrange data]: /azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure
[Pricing calculator]: https://azure.microsoft.com/pricing/calculator/
[Unisys mainframe migration]: /azure/architecture/reference-architectures/migration/unisys-mainframe-migration
[Virtual machines]: https://docs.microsoft.com/azure/architecture/framework/cost/optimize-vm
[What is Azure ExpressRoute?]: /azure/expressroute/expressroute-introduction
[What is Azure Files?]: /azure/storage/files/storage-files-introduction
[What is Azure SQL Database?]: /azure/azure-sql/database/sql-database-paas-overview
[What is Azure Virtual Network?]: /azure/virtual-network/virtual-networks-overview
[What is a virtual machine?]: https://azure.microsoft.com/overview/what-is-a-virtual-machine/

