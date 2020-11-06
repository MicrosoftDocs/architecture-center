---
title: Unisys mainframe migration to Azure
titleSuffix: Azure Reference Architectures
description: Learn about options for using the Asysco Automated Migration Technology (AMT) Framework to migrate Unisys mainframe workloads to Azure.
author: doodlemania2
ms.date: 11/03/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Migrate Unisys mainframe systems to Azure

Unisys ClearPath Dorado (Legacy Sperry 1100/2200) and Libra (Legacy Burroughs A Series/MCP) computer systems are fully featured mainframe operating environments that can scale up vertically to handle mission critical workloads. Emulating, converting, or modernizing these systems into Azure can provide similar or improved performance and SLA guarantees while taking advantage of Azure flexibility, reliability, and future capabilities.

This article describes the conversion technologies that Microsoft partner Asysco's Automated Migration Technology (AMT) Framework uses to convert Unisys mainframe workflows to Azure. The AMT Framework allows an accelerated move into Azure without rewriting application code or redesigning data architecture from network-based to relational-based. The framework converts legacy code to C#, while maintaining the source code in its original form. Application user interfaces and interactions can be virtually unchanged, minimizing the need for end-user retraining.

Asysco AMT Transform automates the migration of the complete mainframe ecosystem, by converting:
- Transaction application code to AMT COBOL or directly to C#/.NET. AMT maintains the original code structure to use as a baseline or for future edits.
- All databases, whether hierarchical, network or relational, to Azure SQL Server.
- WFL/ECL scripts to Windows PowerShell or to open-source Visual Basic scripts.
- All binary or indexed flat files.

## Potential use cases

The AMT Framework can support several methodologies to move client workloads to Azure:

- One method is to convert and move the entire mainframe system to Azure at once, saving interim mainframe maintenance and facility support costs. This method carries some risk because all processes, like application conversion, data migration, and testing, must align to allow a smooth transition.

- A second methodology is to move applications from the mainframe to Azure gradually, with complete transition as the ultimate goal. This tactic provides savings per application, and lessons learned converting each application can help with subsequent conversions. Modernizing each application on its own schedule can be more relaxed than converting everything at once.
  
  This stepped method can also provide more processing cycles on the mainframe as applications convert to Azure. Eventually, starvation of the mainframe as applications convert to Azure can highlight the need to retire the mainframe.

## Architecture

The following diagrams show typical components of Unisys Burroughs MCP or Unisys Sperry OS 1100/2200 mainframe systems.
 
![Diagram showing Unisys Burroughs MCP or Unisys Sperry OS 1100/2200 mainframe components.](media/unisys-components.png)

The second diagram shows how these Unisys mainframe components can migrate and map to Azure capabilities.

![Diagram showing how Unisys mainframe components can map to Azure capabilities.](media/unisys-migration.png)

1. A web browser to access Azure system resources replaces the Legacy UTS and Burroughs terminal emulation for demand and online users (**A**). Users access web-based applications over TLS port 443. For admin access to the Azure virtual machines (VMs), Azure Bastion hosts can maximize security by minimizing open ports.
   
2. Running the presentation layer code in IIS and utilizing ASP.NET maintains the Unisys mainframe user-interface screens (**B**). The applications' presentation layers can remain virtually unchanged, to minimize end user retraining. Alternatively, you can update the web application presentation layer with modern user experience frameworks as required.
   
   The AMT Framework converts COBOL and other legacy application code (**C**) to C#/.NET. If code needs changing or editing, AMT can maintain and reprocess the original code, or you can edit the converted C# code directly to advance the code base to new standards.
   
3. The AMT Framework converts mainframe batch and transaction loads (**D**) to sufficient server farms to handle the work.
   
   This solution uses two sets of two VMs running the web and application layers, fronted by Azure Load Balancers in *active-active* arrangements to spread query and transaction traffic.
   
4. Legacy database structures like DMS II, DMS, and RDMS (**E**) can migrate to Azure SQL Database, with the high availability (HA) and disaster recovery (DR) capabilities that Azure provides. Asysco data migration tools can convert DMS and RDMS schemas to SQL.
   
   Private Link for Azure SQL Database provides a private, direct connection isolated to the Azure networking backbone from the Azure VM to the Azure SQL Database.
   
5. File structures like CIFS, flat files, or virtual tape (**F**) map easily to Azure structured file or blob storage data constructs. Features like Azure Auto Failover Group Replication can provide data protection.
   
6. Workload automation, scheduling, reporting, and system monitoring functions (**G**) that are Azure-capable can keep their current platforms. These platforms include Unisys Operations Sentinel and SMA OpCon. Asysco AMT Control Center can also serve these functions.
   
7. Azure Site Recovery HA/DR capabilities mirror the Azure VMs to a secondary Azure region for quick failover in case of Azure datacenter failure.
   
8. The system can support printers and other legacy system output devices if they have IP addresses connected to the Azure network.

## Components

- Azure Virtual Machines are on-demand, scalable computing resources that give you the flexibility of virtualization without having to buy and maintain physical hardware.
  
- Azure Virtual Networks are the fundamental building blocks for Azure private networks. Virtual networks let Azure resources like VMs securely communicate with each other, the internet, and on-premises networks. An Azure Virtual Network is similar to a traditional network in your own datacenter, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.
  
- Azure Virtual Network Interface Cards enable Azure VMs to communicate with internet, Azure, and on-premises resources. As shown in this architecture, you can add additional network interface cards to the same Azure VM, allowing child VMs to have their own dedicated network interface devices and IP addresses.
  
- Azure SSD Managed Disks are block-level storage volumes that are managed by Azure and used with Azure VMs. The available types of disks are ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD). For this architecture, we recommend either Premium SSDs or Ultra Disk SSDs.
  
- Azure Storage Account File Shares offer fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.
  
- Azure ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.
  
- Azure SQL Database is a fully managed platform as a service (PaaS) database engine. SQL Database handles most database management functions like upgrading, patching, backups, and monitoring without user involvement. Azure SQL Database is always running on the latest stable version of the SQL Server database engine and patched OS with 99.99% availability. PaaS capabilities built into Azure SQL Database let you focus on business critical, domain-specific database administration and optimization.

## Considerations

### Availability
Azure Site Recovery.

### Pricing
Azure SQL Database should use either Hyperscale or Business Critical Tiers for high IOPS and high uptime SLA.

### Resiliency
Resiliency is built into this solution due to the Load Balancers. If one presentation or transaction server fails, the other server behind the Load Balancer shoulders the workload.

### Scalability
You can scale out the server sets to provide more throughput.

### Security

Network security group.

Features like Azure Auto Failover Group Replication can provide data protection.

## Next steps

For more information, please contact legacy2azure@microsoft.com.
