---
title: Migrate mainframe applications to Azure with TmaxSoft OpenFrame
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 09/18/2020
description: Find out how to migrate IBM zSeries mainframe applications to Azure. Learn how to use TmaxSoft OpenFrame for this task. Understand the lift and shift approach.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - mainframe
  - migration
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/media/migrate-mainframe-application-to-azure.png
---

# Migrate mainframe applications to Azure with TmaxSoft OpenFrame

TmaxSoft OpenFrame is a popular mainframe rehosting solution that makes it easy to lift existing IBM zSeries mainframe assets and shift them to Microsoft Azure. This lift-and-shift operation uses a no-code approach. It takes an existing application, as is. Then it quickly migrates the app to a zSeries mainframe emulation environment on Azure.

This reference architecture illustrates how the TmaxSoft OpenFrame solution runs on Azure. The approach consists of two virtual machines (VMs) running Linux in an active-active configuration. An Azure Load Balancer distributes incoming traffic between the VMs. Running on the VMs is OpenFrame emulation software, which provides a zSeries runtime and facilities. Working with the OpenFrame software is an Azure SQL Database. This modernized database layer includes built-in business continuity features.

## Potential use cases

Many scenarios can benefit from lift and shift. Possibilities include the following cases:

- Businesses seeking to modernize infrastructure and escape the high costs, limitations, and rigidness associated with mainframes.
- Organizations opting to move mainframe workloads to the cloud without the side effects of a complete redevelopment.
- Mainframe customers who need to migrate mission-critical applications while maintaining continuity with existing applications.
- Teams looking for the horizontal and vertical scalability that Azure offers.
- Businesses that favor solutions offering disaster recovery options.

## Architecture

:::image type="complex" source="../media/migrate-mainframe-application-to-azure.png" alt-text="Architecture diagram illustrating lift and shift. The implementation migrates mainframe applications to Azure. It includes VMs and a database." border="false":::
   At the center of the diagram are two virtual machines. Labeled boxes indicate that OpenFrame software runs on the machines, and each box represents a different type of software. These programs migrate applications to Azure and handle transaction processes. They also manage batch programs and provide security. A load balancer is pictured above the virtual machines. Arrows show that it distributes incoming traffic between the machines. Below the virtual machines, a file sharing system is pictured, and to the right is a database. From arrows, it's clear that the virtual machines communicate with the file share and the database. A dotted line surrounds all these components. Outside that line are on-premises users, Azure users, and disaster recovery services. Arrows show the users interacting with the system.
:::image-end:::

1. On-premises users interact with [OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace] applications by using 3270 WebTerminal, OFManager, and OFStudio:

   - The web application 3270 WebTerminal runs in browsers like Edge or Internet Explorer. This app connects users with [Customer Information Control System (CICS)][CICS] programs and [Information Management System - Data Communications (IMS-DC)][IMS-DC] applications. By providing access to these 3270 terminal online screens, the 3270 WebTerminal app eliminates the need for TN3270 terminal emulation software.
   - [OFManager][Lift and shift] provides tools for executing, monitoring, and managing batch workloads. This web application also monitors and manages datasets and security systems.
   - [OFStudio][Lift and shift] provides an IDE for programming, debugging, and maintaining applications.

   Azure ExpressRoute creates private connections between Azure and the on-premises infrastructure.

1. Transport Layer Security (TLS) connections that use port 443 provide access to web-based applications:
   - After migration, the web application presentation layer remains virtually unchanged. As a result, end users require minimal retraining. Alternatively, the web application presentation layer can be updated to align with UX goals.
   - [Azure VM Bastion hosts][What is Azure Bastion] work to maximize security. When giving administrators access to VMs, these hosts minimize the number of open ports.
   - OpenFrame provides middleware integration. For instance, this functionality works with web services and [message queues (MQs)][Message queues].

1. The TmaxSoft solution uses two VMs. Each one runs an application server, and an Azure Load Balancer manages approaching traffic. OpenFrame supports both active-active and active-passive configurations.
1. [OpenFrame language compilers][Tmax OpenFrame documentation] migrate COBOL, Assembler, PL/I, Easytrieve, and other mainframe applications to Azure by recompiling the source.
1. [OpenFrame Online][Tmax OpenFrame documentation] provides tools and commands that replace CICS, IMS-DC, Application Development and Maintenance (ADM), and Application Infrastructure and Middleware (AIM) technologies.
1. [OpenFrame Batch][Tmax OpenFrame documentation] provides tools for managing batch programs that replace the job entry subsystem (JES). By supporting native Job Control Language (JCL) syntax and batch utilities, OpenFrame Batch minimizes code updates.
1. [Tivoli Access Control Facility (TACF)][TACF] Security provides authentication and authorization features in OpenFrame by extracting and migrating mainframe security rules.
1. [UnixODBC (Open Database Connectivity)][UnixODBC] connection drivers communicate with relational database management systems (RDBMSs). Examples include Azure SQL Database, Microsoft SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL.
1. Azure File Share is mounted on the Linux server VMs. As a result, COBOL programs have easy access to the Azure Files repository for file processing. Load modules and various log files also use Azure File Share.
1. OpenFrame can integrate with any RDBMS. Examples include Azure SQL Database, SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL. OpenFrame uses ODBC connection drivers to communicate with installed databases.
1. Azure Site Recovery provides disaster recovery (DR) for the virtual machine components.

## Components

- [Azure ExpressRoute][Azure ExpressRoute]: a product that extends on-premises networks into the Microsoft cloud. By using a connectivity provider, ExpressRoute establishes private connections to Microsoft cloud services like [Microsoft Azure][What is Azure] and [Microsoft 365][What is Microsoft 365].
- [Azure Load Balancer][Azure Load Balancer]: a load balancer that operates at layer four of the [Open Systems Interconnection (OSI)][OSI model] model. As the single point of contact for clients, Load Balancer distributes inbound traffic to back-end pool instances. It directs traffic according to configured load-balancing rules and health probes. The back-end pool instances can be Azure VMs or instances in a virtual machine scale set.
- [Azure VMs][Azure Virtual Machines]: one of several types of on-demand, scalable computing resources that are available with Azure. An Azure VM provides the flexibility of virtualization. But it eliminates the maintenance demands of physical hardware. Azure VMs offer a choice of operating systems, including Windows and Linux.
- [Azure Virtual Networks][Azure Virtual Networks]: the fundamental building blocks for private networks in Azure. These networks provide a way for many types of Azure resources, such as Azure VMs, to securely communicate with each other, the internet, and on-premises networks. An Azure virtual network is like a traditional network operating in a data center. But an Azure virtual network also provides scalability, availability, isolation, and other benefits of Azure's infrastructure.
- [Azure Files Storage Accounts and Azure File Shares][Azure Files]: fully managed file shares in the cloud. Azure file shares are accessible via the industry standard [Server Message Block (SMB)][SMB protocol] protocol. They can be mounted concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares.
- [Azure SQL Database][Azure SQL Database]: an intelligent, scalable relational database service built for the cloud. With AI-powered, automated features, Azure SQL Database handles database management functions like upgrading, patching, backups, and monitoring.
- [Azure Site Recovery][Azure Site Recovery]: an implementation of disaster recovery as a service (DRaaS). Azure Site Recovery provides replication, failover, and recovery processes to help keep applications running during outages.

## Next steps

- Contact [legacy2azure@microsoft.com][Email address for information on migrating legacy systems to Azure] for more information.
- See [TmaxSoft OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace] on Azure Marketplace.
- Read how to install [TmaxSoft OpenFrame on Azure][Install TmaxSoft OpenFrame on Azure article].

## Related resources
- [Mainframe rehosting on Azure virtual machines][Mainframe rehosting on Azure virtual machines]
- [Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting][Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]
- [Lift, shift, and modernize: proven mainframe modernization strategies that enable digital transformation][Lift and shift]

[Azure ExpressRoute]: https://docs.microsoft.com/azure/expressroute/expressroute-introduction
[Azure Load Balancer]: https://docs.microsoft.com/azure/load-balancer/load-balancer-overview
[Azure Files]: https://docs.microsoft.com/azure/storage/files/storage-files-introduction
[Azure Site Recovery]: https://azure.microsoft.com/services/site-recovery/
[Azure SQL Database]: https://azure.microsoft.com/services/sql-database/
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines/
[Azure Virtual Networks]: https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview
[CICS]: https://www.ibm.com/support/knowledgecenter/zosbasics/com.ibm.zos.zmidtrmg/zmiddle_13.htm
[Email address for information on migrating legacy systems to Azure]: mailto:legacy2azure@microsoft.com
[IMS-DC]: https://www.sawaal.com/mainframe-interview-questions/what-is-ims-db-dc_9366
[Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/tmaxsoft.openframe?tab=Overview
[Install TmaxSoft OpenFrame on Azure article]: https://docs.microsoft.com/azure/virtual-machines/workloads/mainframe-rehosting/tmaxsoft/install-openframe-azure
[Lift-and-Shift Me Up: The Benefits of Mainframe Rehosting]: https://www.tmaxsoft.com/lift-and-shift-me-up-the-benefits-of-mainframe-rehosting/
[Lift and shift]: https://www.tmaxsoft.com/wp-content/uploads/TmaSof_eBook_OpenFrame.pdf
[Mainframe rehosting on Azure virtual machines]: https://docs.microsoft.com/azure/virtual-machines/workloads/mainframe-rehosting/overview
[Message queues]: https://www.ibm.com/cloud/learn/message-queues
[OSI model]: https://www.networkworld.com/article/3239677/the-osi-model-explained-how-to-understand-and-remember-the-7-layer-network-model.html
[SMB protocol]: https://docs.microsoft.com/openspecs/windows_protocols/ms-smb/f210069c-7086-4dc2-885e-861d837df688
[TACF]: http://ps-2.kev009.com/rs6000/redbook-cd/sg245140.pdf
[Tmax OpenFrame documentation]: https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE36tt6
[UnixODBC]: https://en.wikipedia.org/wiki/UnixODBC
[What is Azure]: https://azure.microsoft.com/overview/what-is-azure/
[What is Azure Bastion]: https://docs.microsoft.com/azure/bastion/bastion-overview
[What is Microsoft 365]: https://www.microsoft.com/microsoft-365/what-is-microsoft-365?rtc=1