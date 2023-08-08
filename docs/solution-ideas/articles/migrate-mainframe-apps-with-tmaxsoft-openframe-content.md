[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

*Lift and shift*, also known as *rehosting*, is the process of mainframe migration to produce an exact copy of an application, workload, and all associated data from one environment to another. Mainframe applications can be migrated from on-premises to public or private cloud.

TmaxSoft OpenFrame is a rehosting solution that makes it easy to lift-and-shift existing IBM zSeries mainframe applications to Microsoft Azure, using a no-code approach. TmaxSoft quickly migrates an existing application, as is, to a zSeries mainframe emulation environment on Azure.

This article illustrates how the TmaxSoft OpenFrame solution runs on Azure. The approach consists of two virtual machines (VMs) running Linux in an [active-active][Active-active definition] configuration. An Azure Load Balancer distributes incoming traffic between the VMs. OpenFrame emulation software runs on the VMs and provides a zSeries runtime and facilities. Working with the OpenFrame software is an Azure SQL Database. This modernized database layer includes built-in business continuity features.

## Potential use cases

Many scenarios can benefit from TmaxSoft OpenFrame lift and shift. Possibilities include the following cases:

- Businesses seeking to modernize infrastructure and escape the high costs, limitations, and rigidity associated with mainframes.
- Organizations opting to move IBM zSeries mainframe workloads to the cloud without the side effects of a complete redevelopment.
- IBM zSeries mainframe customers who need to migrate mission-critical applications while maintaining continuity with other on-premises applications.
- Teams looking for the horizontal and vertical scalability that Azure offers.
- Businesses that favor solutions offering disaster recovery options.

## Architecture

The following diagram shows the patient record creation request flow:

:::image type="content" alt-text="Architecture diagram showing a lift and shift implementation that migrates IBM zSeries mainframes to Azure." source="../media/migrate-mainframe-application-to-azure.svg" lightbox="../media/migrate-mainframe-application-to-azure.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/migrate-mainframe-application-to-azure.vsdx) of this architecture.*

   At the center of the diagram are two virtual machines. Labeled boxes indicate that TmaxSoft OpenFrame software runs on the machines, and each box represents a different type of software. These programs migrate applications to Azure and handle transaction processes. They also manage batch programs and provide security. A load balancer is pictured above the virtual machines. Arrows show that it distributes incoming traffic between the machines. Below the virtual machines, a file sharing system is pictured, and to the right is a database. From arrows, it's clear that the virtual machines communicate with the file share and the database. A dotted line surrounds all these components. Outside that line are on-premises users, Azure users, and disaster recovery services. Arrows show the users interacting with the system.
:::image-end:::

1. On-premises users interact with [OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace] applications by using 3270 WebTerminal, OFManager, and OFStudio:

   - The web application 3270 WebTerminal runs in browsers. This app connects users with [Customer Information Control System (CICS)][CICS] and [Information Management System - Data Communications (IMS-DC)][IMS-DC] applications. By providing access to these 3270 terminal screens, the 3270 WebTerminal app eliminates the need for TN3270 terminal emulation software.
   - [OFManager][Lift and shift] provides tools for executing, monitoring, and managing batch workloads. This web application also monitors and manages datasets and security systems.
   - [OFStudio][Lift and shift] provides an IDE for programming, debugging, and maintaining applications.

1. Azure ExpressRoute creates private connections between the on-premises infrastructure and Azure. Transport Layer Security (TLS) connections that use port 443 provide access to web-based applications:
   - After migration, the web application presentation layer remains virtually unchanged. As a result, end users require minimal retraining. Alternatively, the web application presentation layer can be updated to align with UX goals.
   - [Azure Bastion hosts][What is Azure Bastion] work to maximize security. While giving administrators access to VMs, these hosts minimize the number of open ports.
   - OpenFrame provides middleware integration. For instance, this functionality works with web services and [message queues (MQs)][Message queues].

1. The TmaxSoft solution uses two VMs. Each one runs an application server, and an Azure Load Balancer manages approaching traffic. OpenFrame supports both [active-active][Active-active definition] and [active-passive][Active-passive definition] configurations.
1. [OpenFrame language compilers][Tmax OpenFrame documentation] migrate COBOL, Assembler, PL/I, Easytrieve, and other mainframe applications to Azure by recompiling the source.
1. [OpenFrame Online][Tmax OpenFrame documentation] provides tools and commands that replace CICS, IMS-DC, Application Development and Maintenance (ADM), and Application Infrastructure and Middleware (AIM) technologies.
1. [OpenFrame Batch][Tmax OpenFrame documentation] provides tools for managing batch programs that replace the job entry subsystem (JES). OpenFrame Batch minimizes code updates by supporting native Job Control Language (JCL) syntax and batch utilities.
1. Tmax Access Control Facility (TACF) Security provides authentication and authorization features in OpenFrame by extracting and migrating mainframe security rules.
1. [UnixODBC (Open Database Connectivity)][UnixODBC] connection drivers communicate with relational database management systems (RDBMSs). Examples include Azure SQL Database, Microsoft SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL.
1. Azure File Share is mounted on the Linux server VMs. As a result, COBOL programs have easy access to the Azure Files repository for file processing. Load modules and various log files also use Azure File Share.
1. OpenFrame can integrate with any RDBMS. Examples include Azure SQL Database, SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL. OpenFrame uses ODBC connection drivers to communicate with installed databases.
1. Azure Site Recovery provides disaster recovery (DR) for the virtual machine components.

### Components

- [Azure ExpressRoute][Azure ExpressRoute] extends on-premises networks into the Microsoft cloud by using a connectivity provider. ExpressRoute establishes private connections to Microsoft cloud services like [Microsoft Azure][What is Azure] and [Microsoft 365][What is Microsoft 365].

- [Azure Bastion][What is Azure Bastion] provides secure and seamless [Remote Desktop Protocol (RDP)][RDP] and [Secure Shell (SSH)][SSH] connectivity to VMs in a network. Instead of using a public IP address, users connect to the VMs directly from the Azure portal.

- [Azure Load Balancer][Azure Load Balancer] operates at layer four of the [Open Systems Interconnection (OSI)][OSI model] model. As the single point of contact for clients, Load Balancer distributes inbound traffic to back-end pool instances. It directs traffic according to configured load-balancing rules and health probes. The back-end pool instances can be Azure VMs or instances in a virtual machine scale set.

- [Azure VMs][Azure Virtual Machines] are one of several types of on-demand, scalable computing resources that are available with Azure. An Azure VM provides the flexibility of virtualization. But it eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.

- [Azure Virtual Networks][Azure Virtual Networks] are the fundamental building blocks for private networks in Azure. These networks provide a way for many types of Azure resources, such as Azure VMs, to securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a data center. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.

- [Azure Files Storage Accounts and Azure File Shares][Azure Files] are fully managed file shares in the cloud. Azure file shares are accessible via the industry standard [Server Message Block (SMB)][SMB protocol] protocol. They can be mounted concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares.

- [Azure SQL Database][Azure SQL Database] is an intelligent, scalable relational database service built for the cloud. With AI-powered, automated features, Azure SQL Database handles database management functions like upgrading, patching, backups, and monitoring.

- [Azure Site Recovery][Azure Site Recovery] provides replication, failover, and recovery processes to help keep applications running during outages.

## Next steps

- Contact [legacy2azure@microsoft.com][Email address for information on migrating legacy systems to Azure] for more information.
- See [TmaxSoft OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace] on Azure Marketplace.
- Read how to [install TmaxSoft OpenFrame on Azure][Install TmaxSoft OpenFrame on Azure article].

## Related resources
- [Mainframe rehosting on Azure virtual machines][Mainframe rehosting on Azure virtual machines]
- [Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting][Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]
- [Lift, shift, and modernize: proven mainframe modernization strategies that enable digital transformation][Lift and shift]

[Active-active definition]: https://www.webopedia.com/TERM/A/active_active.html
[Active-passive definition]: https://www.jscape.com/blog/active-active-vs-active-passive-high-availability-cluster
[Azure ExpressRoute]: /azure/expressroute/expressroute-introduction
[Azure Load Balancer]: /azure/load-balancer/load-balancer-overview
[Azure Files]: /azure/storage/files/storage-files-introduction
[Azure Site Recovery]: https://azure.microsoft.com/services/site-recovery
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines
[Azure Virtual Networks]: /azure/virtual-network/virtual-networks-overview
[CICS]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zmidtrmg/zmiddle_13.htm
[Email address for information on migrating legacy systems to Azure]: mailto:legacy2azure@microsoft.com
[IMS-DC]: https://www.sawaal.com/mainframe-interview-questions/what-is-ims-db-dc_9366
[Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/tmaxsoft.openframe?tab=Overview
[Install TmaxSoft OpenFrame on Azure article]: /azure/virtual-machines/workloads/mainframe-rehosting/tmaxsoft/install-openframe-azure
[Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]: https://www.tmaxsoft.com/lift-and-shift-me-up-the-benefits-of-mainframe-rehosting
[Lift and shift]: https://www.tmaxsoft.com/wp-content/uploads/TmaSof_eBook_OpenFrame.pdf
[Mainframe rehosting on Azure virtual machines]: /azure/virtual-machines/workloads/mainframe-rehosting/overview
[Message queues]: https://www.ibm.com/cloud/learn/message-queues
[OSI model]: https://www.networkworld.com/article/3239677/the-osi-model-explained-how-to-understand-and-remember-the-7-layer-network-model.html
[RDP]: /troubleshoot/windows-server/remote/understanding-remote-desktop-protocol
[SSH]: https://www.ssh.com/ssh
[SMB protocol]: /openspecs/windows_protocols/ms-smb/f210069c-7086-4dc2-885e-861d837df688
[Tmax OpenFrame documentation]: https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE36tt6
[UnixODBC]: https://en.wikipedia.org/wiki/UnixODBC
[What is Azure]: https://azure.microsoft.com/overview/what-is-azure
[What is Azure Bastion]: /azure/bastion/bastion-overview
[What is Microsoft 365]: https://www.microsoft.com/microsoft-365/what-is-microsoft-365?rtc=1
