---
title: Migrate mainframe applications to Azure
titleSuffix: Azure Solution Ideas
author: JKirsch1
ms.date: 09/16/2020
description: Learn how GitHub tools make security practices an integral part of DevOps while maintaining efficiency. See how to use these tools within an Azure framework.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - mainframe
  - migration
ms.subservice: solution-idea
ms.author: v-jenkir
social_image_url: /azure/architecture/solution-ideas/media/migrate-mainframe-application-to-azure.png
---

# Migrate mainframe applications to Azure

TmaxSoft OpenFrame is a popular mainframe rehosting solution that makes it easy to lift existing IBM zSeries mainframe assets and shift them to Microsoft Azure. This lift-and-shift operation uses a no-code approach. It takes an existing application, as is. It then quickly migrates the app to a zSeries mainframe emulation environment on Azure.

This reference architecture illustrates how the TmaxSoft OpenFrame solution runs on Azure. The approach consists of two virtual machines (VMs) running Linux in an active-active configuration. An Azure Load Balancer distributes incoming traffic between the VMs. These VMs then run OpenFrame emulation software to provide the zSeries facilities and application emulation runtime. An Azure SQL Database works with the OpenFrame software, providing a modernized database layer that includes built-in business continuity features.

## Potential use cases

Many scenarios can benefit from lift-and-shift. Possibilities include the following cases:

- Businesses seeking to modernize infrastructure and escape drawbacks associated with mainframes, such as high costs, limitations, and rigidness.
- Organizations opting to move their mainframe workloads to the cloud without the side-effects of a complete redevelopment.
- Mainframe customers who need to migrate mission-critical applications while maintaining continuity with existing applications.
- Teams looking for the horizontal and vertical scalability that Azure offers.
- Businesses that favor solutions offering disaster recovery options.

## Architecture

:::image type="complex" source="../media/migrate-mainframe-application-to-azure.png" alt-text="Architecture diagram highlighting the security checks that run in various GitHub and Azure components in a GitHub DevSecOps environment." border="false":::
   Architecture diagram highlighting security checks that run in a GitHub DevSecOps environment. After Azure AD authenticates developers, Codespaces run security scans. GitHub Actions then test security and encrypt sensitive data. In production, Azure Policy, Azure Security Center, and Azure Monitor evaluate deployed software for risks.
:::image-end:::

1. Users interact with OpenFrame applications by using OFManager, 3270 WebTerminal and OFStudio:

   - OFManager provides tools for executing, monitoring, and managing batch workloads. This web application also monitors and manages datasets and security systems.
   - The web application 3270 WebTerminal runs in browsers like Edge or Internet Explorer. This app provides a way to access 3270 terminal online screens, or Customer Information Control System (CICS) Information Management System - Data Communications (IMS-DC) screens. The 3270 WebTerminal app eliminates the need for TN3270 terminal emulation software.
   - OFStudio provides an IDE for programming, debugging, and maintaining applications.

1. Users access OpenFrame web-based applications through TLS connections that use port 443. After migration, the web application presentation layer remains virtually unchanged. As a result, end users require minimal retraining. Alternatively, the web application presentation layer can be outfitted with modern UX frameworks if user requirements necessitate updates. Azure virtual machine Bastion hosts can maximize security by minimizing open ports when giving administrators access to virtual machines. OpenFrame provides middleware integration, for use with Web Services and message queues (MQs), for example.
1. The TmaxSoft solution uses two virtual machines, with each one running an application server. An Azure Load Balancer manages traffic approaching the virtual machines. OpenFrame supports both active-active and active-passive configurations.
1. OpenFrame language compilers migrate COBOL, PL/I, Assembler, Easytrieve, and other mainframe applications to Azure by recompiling the source.
1. OpenFrame Online provides tools and commands that replace CICS, IMS-DC, Application Development and Maintenance (ADM), and Application Infrastructure and Middleware (AIM) technologies.
1. OpenFrame Batch provides tools for managing batch programs that replace the job entry subsystem (JES). By supporting native Job Control Language (JCL) syntax and batch utilities, OpenFrame Batch minimizes the need to update code.
1. Tivoli Access Control Facility (TACF) Security provides authentication and authorization features in OpenFrame by extracting and migrating mainframe security rules.
1. UnixODBC (Open Database Connectivity) connection drivers establish connectivity and communication with relational database management systems (RDBMSs), such as Microsoft SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL.
1. Azure File Share is mounted on the Linux server virtual machines. As a result, COBOL programs have easy access to the Azure Files repository for file processing. Load modules and various log files also use Azure File Share.
1. OpenFrame can integrate with any RDBMS. Examples include SQL Server, Oracle, Db2 LUW, Tibero, Postgres, and MySQL. OpenFrame uses ODBC connection drivers to communicate with the installed database.
1. The solution uses Azure Site Recovery (ASR) for disaster recovery (DR) of the virtual machine components.

## Components

- [Azure Virtual Machines][Azure Virtual Machines]: one of several types of on-demand, scalable computing resources that are available with Azure. An Azure VM provides the flexibility of virtualization without the need to buy and maintain physical hardware. Azure VMs offer a choice of operating systems that includes Windows and Linux.
- [Azure Virtual Network][Azure Virtual Network]: the fundamental building block for a private network in Azure. By using this network, many types of Azure resources, such as Azure Virtual Machines, can securely communicate with each other, the internet, and on-premises networks. While similar to a traditional network operating in a data center, an Azure virtual network also provides the additional benefits of Azure's infrastructure, such as scalability, availability, and isolation.
- [Azure Files Storage Accounts and Azure File Shares][Azure Files]: offer fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments. Windows, Linux, and macOS clients can access these file shares.
- [Azure ExpressRoute][Azure ExpressRoute]: extends on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. ExpressRoute can establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.
- [Azure Load Balancer][Azure Load Balancer]: operates at layer four of the Open Systems Interconnection (OSI) model. It's the single point of contact for clients. Load Balancer distributes inbound flows that arrive at the load balancer's front end to backend pool instances. These flows are according to configured load balancing rules and health probes. The backend pool instances can be Azure Virtual Machines or instances in a virtual machine scale set.

## Next steps

- Contact legacy2azure@microsoft.com for more information.
- Go to the Microsoft commercial marketplace for more information about [TmaxSoft OpenFrame][Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace].
- Read the TmaxSoft OpenFrame Installation.

## Related resources

[Azure ExpressRoute]: https://docs.microsoft.com/azure/expressroute/expressroute-introduction
[Azure Load Balancer]: https://docs.microsoft.com/azure/load-balancer/load-balancer-overview
[Azure Storage Accounts / File Shares]: https://docs.microsoft.com/azure/storage/files/storage-files-introduction
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines/
[Azure Virtual Networks]: https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview
[Information about TmaxSoft OpenFrame on the Microsoft commercial marketplace]: https://azuremarketplace.microsoft.com/marketplace/apps/tmaxsoft.openframe?tab=Overview
[Install TmaxSoft OpenFrame on Azure article]: https://docs.microsoft.com/azure/virtual-machines/workloads/mainframe-rehosting/tmaxsoft/install-openframe-azure