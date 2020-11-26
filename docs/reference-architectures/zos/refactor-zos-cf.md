---
title: Refactor IBM z/OS Mainframe Coupling Facility to Azure
titleSuffix: Azure Reference Architectures
description: Learn about options for using the Asysco Automated Migration Technology (AMT) Framework to migrate Unisys mainframe workloads to Azure.
author: doodlemania2
ms.date: 11/25/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Refactor IBM z/OS mainframe CF to Azure

This architecture shows how Azure services can provide similar scale-out performance and high availability to IBM z/OS mainframe systems that use Coupling Facilities (CFs).

CFs are physical devices that connect multiple mainframe servers or Central Electronics Complexes (CECs) to share memory, allowing for scale-out performance for various systems. Applications written in languages like COBOL and PL/I seamlessly take advantage of these tightly coupled scale-out features.

DB2 databases and CICS servers use CFs with a mainframe subsystem called Parallel Sysplex to combine data sharing and parallel computing. Parallel Sysplex allows a cluster of up to 32 systems to share a workload for high performance, high availability, and disaster recovery.

Mainframe CFs with Parallel Sysplex are typically deployed in the same datacenter, with close proximity between the CECs, but can also be implemented between datacenters.

Azure can provide similar scale-out performance with shared data and high availability. Azure compute clusters share memory through data caching mechanisms like Azure Cache for Redis, and use scalable data technologies like Azure SQL Database and Azure Cosmos DB.

Azure can implement availability sets and groups, combined with geo-redundant capabilities, to extend scale-out compute and high availability to distributed Azure datacenters.

## Architecture

The following diagram shows original z/OS CF architecture:

- Input travels over TCP/IP, including TN3270 and HTTP(S), into the mainframe using standard mainframe protocols **(A)**.
- Receiving applications **(B)** can be either batch or online systems. Batch jobs can be spread or cloned across multiple CECs that share data in the data tier. The online tier using Parallel Sysplex CICS, or CICSPlex, can spread a logical CICS region across multiple CECs.
- COBOL, PL/I, Assembler, or compatible languages (**C**) run in the Parallel Sysplex-enabled environment, such as a CICSPlex.
- Other application services (**D**) can also use shared memory across a CF.
- Parallel Sysplex-enabled data services like DB2 (**E**) allow for scale-out data scaling in a shared environment.
- Middleware and utility services like MQSeries, management, and printing (**F**) run on z/OS in each CEC.
- Logical partitions (LPARs) on each CEC (**G**) run z/OS. Other operating environments like z/VM or other engines like zIIP or IFL might also exist.
- A CEC connects via the CF (**H**) to shared memory and state.
- The CF (**I**) is a physical device that connects multiple CECs to share memory.

The next diagram shows how Azure services can provide similar functionality and performance to z/OS mainframes with Parallel Sysplex and CFs:

1.	Input will typically come either via Express Route from remote clients, or by other applications currently running Azure.  In either case, TCP/IP connections will be the primary means of connection to the system.  User access provided over TLS port 443 for accessing web-based applications.  Web-based Applications presentation layer can be kept virtually unchanged to minimize end user retraining.  Alternatively, the web application presentation layer can be updated with modern UX frameworks as requirements necessitate.  Further, for admin access to the VMs, Azure VM Bastion hosts can be used to maximize security by minimizing open ports. etc.

2.	Once in Azure, access to the application compute clusters will be done using an Azure Load balancer.  This approach allows for scale out compute resources to process the input work.  Both level 7 (application level) and level 4 (network protocol level) load balancers are available.  The type to use will depend on how the application input reaches the entry point of the compute cluster.

3.	Applications compute clusters – This will depend on whether the application support virtual machines in a compute cluster, or the application runs in a container that can be deployed in a container compute cluster, such as Kubernetes.  Typically, mainframe system emulation for applications written in PL/I or COBOL use virtual machines, while applications refactored to Java or .NET use containers.  Note, that some mainframe system emulation software can also support deployment in containers.

4.	Application servers, such as Tomcat for Java or TP monitor (CICS/IMS) for COBOL receive the input in the compute clusters, and share application state and data using Redis Cache or RDMA (Remote Direct Memory Access)

5.	Data services in the application clusters allow for multiple connections to persistent data sources.  These data source can include PaaS data services such as Azure SQL DB and Cosmos DB, databases on VMs, such as Oracle or Db2, or Big Data repositories such as Databricks and Azure Data Lake.  Application data services can also connect to streaming data services such as Kafka and Azure Stream Analytics.

6.	The application servers host that various application programs based on the language’s capability, such as Java classes in Tomcat or COBOL programs with CICS verbs in CICS emulation VMs.

7.	Data services use a combination of high-performance storage (ultra/premium SSD), file storage (NetApp/Azure files) and standards storage (Blob, archive, backup) that can be either local redundant or geo-redundant depending on the usage.

8.	Azure PaaS data services provide scalable and highly available data storage that can be shared across multiple compute resources in a cluster.  These can also be geo-redundant.

9.	Azure Data Factory allows for data ingestion and synchronization with multiple data sources both within Azure and from external sources. Azure Blob storage is a common landing zone for external data sources.

10.	Azure Site Recovery (ASR) used for Disaster Recovery of the VM and container cluster components.

## Components
•	Azure Virtual Machines - Azure Virtual Machines (VM) is one of several types of on-demand, scalable computing resources that Azure offers.  An Azure VM gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it.  With Azure VMs, you have a choice of operating system which includes both Windows and Linux.
•	Azure Kubernetes Service (AKS) – Used for implementing Kubernetes container-based compute clusters.
•	Redis Cache – Used to share data and state between compute resources.
•	Azure SQL – PaaS data services for SQL Server in Azure
•	Cosmos DB – Azure PaaS service for NoSQL database.
•	Azure PostreSQL DB – Azure PaaS service for PostrgeSQL database
•	Azure Databricks – Azure Big Data Spark PaaS service
•	RDMA on Azure – Remote Direct Memory Access services on Azure
•	Azure Stream Analytics – Azure based streaming service
•	Azure Virtual Networks - Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.
•	Azure Virtual Network Interface Cards - A network interface enables an Azure Virtual Machine to communicate with internet, Azure, and on-premises resources.  As shown in this architecture, you can add additional network interface cards to the same Azure VM, which allows the Solaris child-VMs to have their own dedicated network interface device and IP address.
•	Azure SSD Managed Disk - Azure managed disks are block-level storage volumes that are managed by Azure and used with Azure Virtual Machines.  The available types of disks are ultra disks, premium solid-state drives (SSD), standard SSDs, and standard hard disk drives (HDD).  For this architecture, we recommend either Premium SSDs or Ultra Disk SSDs.
•	Azure Storage Accounts / File Shares - Azure Files offers fully managed file shares in the cloud that are accessible via the industry standard Server Message Block (SMB) protocol. Azure file shares can be mounted concurrently by cloud or on-premises deployments of Windows, Linux, and macOS.
•	Azure ExpressRoute - ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.
•	Azure Load Balancer - Azure Load Balancer operates at layer four of the Open Systems Interconnection (OSI) model. It's the single point of contact for clients. Load Balancer distributes inbound flows that arrive at the load balancer's front end to backend pool instances. These flows are according to configured load balancing rules and health probes. The backend pool instances can be Azure Virtual Machines or instances in a virtual machine scale set.

