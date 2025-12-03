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
   - After migration, the web application presentation layer remains with minimal changes. As a result, users require minimal retraining. Alternatively, the presentation layer can be updated to align with UX goals.
   - [Azure Bastion hosts][What is Azure Bastion] work to maximize security. While giving administrators access to VMs, these hosts minimize the number of open ports.
   - OpenFrame provides middleware integration. For instance, this functionality works with web services and [message queues (MQs)][Message queues].

1. The TmaxSoft solution uses two VMs. Each one runs an application server, and an Azure Load Balancer manages approaching traffic. OpenFrame supports both [active-active][Active-active definition] and [active-passive][Active-passive definition] configurations.
1. OpenFrame language compilers migrate [COBOL](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/compilers/index_of_cobol_4.html), [Assembler](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/compilers/index_of_asm_4.html), [PL/I](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/compilers/index_of_pli_3.html), Easytrieve, and other mainframe applications to Azure by recompiling the source.
1. OpenFrame Online provides tools and commands that replace [CICS](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/mvs_components/index_of_osc_7.1.html), [IMS-DC](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/mvs_components/index_of_osi_7.2.html), Application Development and Maintenance (ADM), and Application Infrastructure and Middleware (AIM) technologies.
1. [OpenFrame Batch](https://docs.tmaxsoft.com/en/tmaxsoft_docs/main/openframe/mvs_components/index_of_batch_mvs_7.1.html) provides tools for managing batch programs that replace the job entry subsystem (JES). OpenFrame Batch minimizes code updates by supporting native Job Control Language (JCL) syntax and batch utilities.
1. Tmax Access Control Facility (TACF) Security provides authentication and authorization features in OpenFrame by extracting and migrating mainframe security rules.
1. [UnixODBC (Open Database Connectivity)][UnixODBC] connection drivers communicate with relational database management systems (RDBMSs). Examples include Azure SQL Database, Microsoft SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL.
1. Azure File Share is mounted on the Linux server VMs. As a result, COBOL programs have easy access to the Azure Files repository for file processing. Load modules and various log files also use Azure File Share.
1. OpenFrame can integrate with any RDBMS. Examples include Azure SQL Database, SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL. OpenFrame uses ODBC connection drivers to communicate with installed databases.
1. Azure Site Recovery provides disaster recovery (DR) for the virtual machine components.

### Components

- [ExpressRoute][Azure ExpressRoute] is a service that creates private connections between on-premises infrastructure and Microsoft cloud services like [Microsoft Azure][What is Azure] and [Microsoft 365][What is Microsoft 365]. In this architecture, ExpressRoute ensures secure and reliable connectivity between existing systems and Azure-hosted OpenFrame applications.

- [Azure Bastion][What is Azure Bastion] is a managed platform that provides secure [Remote Desktop Protocol (RDP)][RDP] and [Secure Shell (SSH)][SSH] access to VMs without exposing them to the public internet. In this architecture, Azure Bastion enhances security by allowing administrators to manage VMs directly from the Azure portal instead of using public IP addresses.

- [Load Balancer][Azure Load Balancer] is a load balancing service that distributes incoming traffic across multiple back-end resources. It operates at layer 4 of the [Open Systems Interconnection (OSI)][OSI model] model. Load Balancer directs traffic according to configured load balancing rules and health probes. In this architecture, it ensures high availability and scalability by routing traffic between the two active-active Linux VMs that run OpenFrame.

- [Azure Virtual Machines][Azure Virtual Machines] is an infrastructure as a service (IaaS) offering that provides scalable compute resources. It provides full control over operating systems, storage, and applications without owning physical infrastructure. In this architecture, VMs host the TmaxSoft OpenFrame software, which provides the runtime environment for migrated mainframe applications.

- [Azure Virtual Network][Azure Virtual Networks] is a networking service in Azure that enables secure communication between Azure resources, the internet, and on-premises networks. In this architecture, it connects all components, including VMs, databases, and file shares, while maintaining isolation and scalability.

- [Azure Files storage accounts and Azure file shares][Azure Files] are managed file shares in the cloud. Azure file shares can be accessed via the industry standard [Server Message Block (SMB)][SMB protocol] protocol. They can be mounted concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares. In this architecture, Azure Files stores COBOL program files, load modules, and logs, which enables file access from the Linux VMs.

- [Azure SQL Database][Azure SQL Database] is a managed relational database engine that automates upgrading, patching, backups, and monitoring. In this architecture, it serves as the modernized data layer for OpenFrame applications, which supports transactional and analytical workloads.

- [Azure Site Recovery][Azure Site Recovery] is a disaster recovery service that replicates and recovers workloads during outages. In this architecture, it provides recovery capabilities for the VM components to help maintain business continuity.

## Next steps

- For more information, contact [legacy2azure@microsoft.com][Email address for information on migrating legacy systems to Azure].
- See [TmaxSoft OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace] on Azure Marketplace.
- Read how to [install TmaxSoft OpenFrame on Azure][Install TmaxSoft OpenFrame on Azure article].

## Related resources

- [Mainframe rehosting on Azure virtual machines][Mainframe rehosting on Azure virtual machines]
- [Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting][Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]
- [Lift, shift, and modernize: proven mainframe modernization strategies that enable digital transformation][Lift and shift]

[Active-active definition]: https://www.webopedia.com/TERM/A/active_active.html
[Active-passive definition]: https://www.jscape.com/blog/active-active-vs-active-passive-high-availability-cluster
[Azure ExpressRoute]: /azure/well-architected/service-guides/azure-expressroute
[Azure Load Balancer]: /azure/well-architected/service-guides/azure-load-balancer
[Azure Files]: /azure/well-architected/service-guides/azure-files
[Azure Site Recovery]: /azure/site-recovery/site-recovery-overview
[Azure SQL Database]: /azure/well-architected/service-guides/azure-sql-database
[Azure Virtual Machines]: /azure/well-architected/service-guides/virtual-machines
[Azure Virtual Networks]: /azure/well-architected/service-guides/virtual-network
[CICS]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zmidtrmg/zmiddle_13.htm
[Email address for information on migrating legacy systems to Azure]: mailto:legacy2azure@microsoft.com
[IMS-DC]: https://www.sawaal.com/mainframe-interview-questions/what-is-ims-db-dc_9366
[Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/tmaxsoft.openframe?tab=Overview
[Install TmaxSoft OpenFrame on Azure article]: /azure/virtual-machines/workloads/mainframe-rehosting/tmaxsoft/install-openframe-azure
[Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]: https://www.tmaxsoft.com/en/press/view?seq=262
[Lift and shift]: https://www.tmaxsoft.com/wp-content/uploads/TmaSof_eBook_OpenFrame.pdf
[Mainframe rehosting on Azure virtual machines]: /azure/virtual-machines/workloads/mainframe-rehosting/overview
[Message queues]: https://www.ibm.com/cloud/learn/message-queues
[OSI model]: https://www.networkworld.com/article/964816/the-osi-model-explained-and-how-to-easily-remember-its-7-layers.html
[RDP]: /troubleshoot/windows-server/remote/understanding-remote-desktop-protocol
[SSH]: https://www.ssh.com/ssh
[SMB protocol]: /openspecs/windows_protocols/ms-smb/f210069c-7086-4dc2-885e-861d837df688
[UnixODBC]: https://en.wikipedia.org/wiki/UnixODBC
[What is Azure]: /azure/
[What is Azure Bastion]: /azure/bastion/bastion-overview
[What is Microsoft 365]: /microsoft-365/
