---
title: Azure mainframe and midrange architecture
titleSuffix: Azure Architecture Center
description: An overview of Microsoft's Azure mainframe and midrange architectural concepts and guidance offerings.
author: jjfrost
ms.author: jfrost
ms.date: 06/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
products:
  - azure
ms.custom:
  - overview
  - fcp
---

# Azure mainframe and midrange architecture

Mainframe and midrange  hardware is comprised of a family of systems from various vendors (all with a history and goal of high performance, high throughput, and sometimes high availability). These systems were often _scale-up_ and monolithic, meaning they were a single, large frame with multiple processing units, shared memory, and shared storage.

On the application side, programs were often written in one of two flavors: either transactional or batch. In both cases, there were a variety of programming languages that were used, including COBOL, PL/I, Natural, Fortran, REXX, and so on.  Despite the age and complexity of these systems, there are many migration pathways to Azure.

On the data side, data is usually stored in files and in databases. Mainframe and midrange databases commonly come in a variety of possible structures, such as relational, hierarchical, and network, among others. There are different types of file organizational systems, where some of them can be indexed and can act as a key-value stores. Further, data encoding in mainframes can be different from the encoding usually handled in non-mainframe systems. Therefore, data migrations should be handled with upfront planning. There are many options for migrating to the Azure data platform.

![Mainframe + Midrange Overview](img/main_types.png "Mainframe + Midrange Overview")

## Migrating legacy systems to Azure

In many cases, mainframe, midrange, and other server-based workloads can be replicated in Azure with little to no loss of functionality. Sometimes users do not notice changes in their underlying systems. In other situations, there are options for refactoring and re-engineering the legacy solution into an architecture that is in alignment with the cloud. This is done while still maintaining the same or very similar functionality. The architectures in this content set (plus the additional white papers and other resources provided below) will help guide you through this process.

## Mainframe and midrange concepts

In our mainframe architectures, we use the following terms.

### Mainframes

Mainframes were designed as scale-up servers to run high-volume online transactions and batch processing in the late 1950s. As such, mainframes have software for online transaction forms (sometimes called green screens) and high-performance I/0 systems, for processing the batch runs. Mainframes have a reputation for high reliability and availability, in addition to their ability to run online and batch jobs.

#### Mainframe storage

Part of demystifying mainframes involves decoding various overlapping terms. For example, central storage, real memory, real storage, and main storage generally all refer to storage that is attached directly to the mainframe processor.  Mainframe hardware includes processors and many other devices, such as direct access storage devices (DASDs), magnetic tape drives, and several types of user consoles. Tapes and DASDs are used for system functions and by user programs.

_Types of physical storage:_
* **Central storage**. Located directly on the mainframe processor, it's also known as _processor storage_ or _real storage_. 
* **Auxiliary storage**. Located separately from the mainframe, it includes storage on DASDs, which is also known as _paging storage_.

#### MIPS

The measurement of millions of instructions per second (MIPS) provides a constant value of the number of cycles per second, for a given machine. MIPS are used to measure the overall compute power of a mainframe. Mainframe vendors charge customers, based on MIPS usage. Customers can increase mainframe capacity to meet specific requirements. IBM maintains a [processor capacity index](https://www-01.ibm.com/servers/resourcelink/lib03060.nsf/pages/lsprITRzOSv2r1?OpenDocument), which shows the relative capacity across different mainframes.

The table below shows typical MIPS thresholds across small, medium, and large enterprise organizations (SORGs, MORGs, and LORGs).

|Customer size |Typical MIPS usage |
|--------------|-------------------|
|SORG          |Less than 500 MIPS |
|MORG          |500 MIPS to 5,000 MIPS|
|LORG          |More than 5,000 MIPS|

#### Mainframe data

Mainframe data is stored and organized in a variety of ways, from relational and hierarchical databases to high throughput file systems. Some of the common data systems are z/OS Db2 for relational data and IMS DB for hierarchical data. For high throughput file storage, you might see VSAM (IBM Virtual Storage Access Method). The following table provides a mapping of some of the more common mainframe data systems, and their possible migration targets into Azure.

| Data source	|Target platform in Azure|
|---------------|------------------------|
|z/OS Db2 & Db2 LUW |Azure SQL DB, SQL Server on Azure VMs, Db2 LUW on Azure VMs, Oracle on Azure VMs, Azure Database for PostgreSQL|
|IMS DB	            |Azure SQL DB, SQL Server on Azure VMs, Db2 LUW on Azure VMs, Oracle on Azure VMs, Azure Cosmos DB|
|Virtual Storage Access Method (VSAM), Indexed Sequential Access Method (ISAM), other flat files |	Azure SQL DB, SQL Server on Azure VMs, Db2 LUW on Azure VMs, Oracle on Azure VMs, Azure Cosmos DB|
|Generation Date Groups (GDGs)	|Files on Azure using extensions in the naming conventions to provide similar functionality to GDGs|

### Midrange systems, Unix variants, and other legacy systems

Midrange systems and midrange computers are loosely defined terms for a computer system that is more powerful than a general-purpose personal computer, but less powerful than a full-size mainframe computer. In most instances, a midrange computer is employed as a network server, when there are a small to medium number of client systems. The computers generally have multiple processors, a large amount of random access memory (RAM), and large hard drives. Additionally, they usually contain hardware that allows for advanced networking, and ports for connecting to more business-oriented peripherals (such as large-scale data storage devices).

Common systems in this category include AS/400 and the IBM i and p series. Unisys also has a collection of midrange systems.

#### Unix operating system

The Unix operating system was one of the first enterprise-grade operating systems. Unix is the base operating system for Ubuntu, Solaris, and OSes that follow POSIX standards. Unix was developed in the 1970s by Ken Thompson, Dennis Ritchie, and others at AT&T Laboratories. It was originally meant for programmers who are developing software, rather than non-programmers. It was distributed to government organizations and academic institutions, both of which led Unix to being ported to a wider variety of variations and forks, with different specialized functions. Unix and its variants (such as AIX, HP-UX, and Tru64) are commonly found running on legacy systems, such as IBM mainframes, AS/400 systems, Sun Sparc, and DEC hardware-based systems.

#### Other systems

Other legacy systems include the family of systems from Digital Equipment Corporator (DEC), such as the DEC VAX, DEC Alpha, and DEC PDP. The DEC systems initially ran the VAX VMS operating system, then eventually they moved to Unix variants, such as Tru64. Other systems include ones that are based on the PA-RISC architecture, such as the HP-3000 and HP-9000 systems.

#### Midrange data and storage

Midrange data is stored and organized in variety of ways, from relational and hierarchical databases, to high throughput file systems. Some of the common data systems are Db2 for i (for relational data), and IMS DB for hieratical data. The following table provides a mapping of some of the more common mainframe data systems and the possible migration targets into Azure.

|Data source             |Target platform in Azure |
|------------------------|-------------------------|
|Db2 for i   |Azure SQL DB, SQL Server on Azure VMs, Azure Database for PostgreSQL, Db2 LUW on Azure VMs, Oracle on Azure VMs|
|IMS DB      |Azure SQL DB, SQL Server on Azure VMs, Db2 LUW on Azure VMs, Oracle on Azure VMs, Azure Cosmos DB|

#### Endianness

Consider the following details about endianness:

- RISC and x86 processors differ in endianness, a term used to describe how a system stores bytes in computer memory.  
- RISC-based computers are known as big endian systems, because they store the most significant (“big”) value first—that is, in the lowest storage address.  
- Most Linux computers are based on the x86 processor, which are little endian systems, meaning they store the least significant (“little”) value) first.

![Endianness Explained](img/endian.png "Endianness explained")

## High-level architectural types

### Rehost
Often referred to as a lift-and-shift migration, this option doesn't require code changes. You can use it to quickly migrate your existing applications to Azure. Each application is migrated as is, to reap the benefits of the cloud (without the risk and cost that are associated with code changes).

#### Rehost Architectures

| | |
|-|-|
|Stromasys Charon-SSP Solaris emulator on Azure VMs [![Stromasys Charon-SSP Solaris emulator on Azure VMs](img/rehost_solaris.png "Stromasys Charon-SSP Solaris emulator on Azure VMs")](/azure/architecture/solution-ideas/articles/solaris-azure) |Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame [![Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](img/rehost_tmax.png "Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame")](/azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe)|

### Refactor

Refactoring requires minimal changes to applications. This often enables the application architecture to leverage Azure platform as a service (PaaS) and to leverage additional cloud offerings. For example, you could migrate compute components of existing applications to Azure App Service or to Azure Kubernetes Service (AKS).  You could also refactor relational and nonrelational databases into various options, such as Azure SQL Managed Instance, Azure Database for MySQL, Azure Database for PostgreSQL, and Azure Cosmos DB.

#### Refactor Architectures

| | |
|-|-|
|IBM z/OS mainframe migration with Asysco AMT [![IBM z/OS mainframe migration with Asysco AMT](img/refactor_asysco_zos.png)](/azure/architecture/example-scenario/mainframe/asysco-zos-migration)|Micro Focus Enterprise Server on Azure VMs [![Micro Focus Enterprise Server on Azure VMs](img/refactor_microfocus_zos.png)](/azure/architecture/example-scenario/mainframe/micro-focus-server)|
|Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure [![Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](img/refactor_zos_cf.png)](/azure/architecture/reference-architectures/zos/refactor-zos-coupling-facility)|Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus [![Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](img/refactor_astadia_unisys.png)](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)|
|Unisys mainframe migration with Asysco [![Unisys mainframe migration with Asysco](img/refactor_asysco_unisys.png)](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)|IBM System i to Azure using Infinite i [![IBM System i to Azure using Infinite i](img/refactor_infinite_i.png)](/azure/architecture/example-scenario/mainframe/ibm-system-i-azure-infinite-i)|
