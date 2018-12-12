---
title: "Mainframe Migration: Mainframe Application Migration"
description: Migrate applications from mainframe environments to Azure, a proven, highly available, and scalable infrastructure for systems that currently run on mainframes. 
author: njray
ms.date: 12/08/2018
---

# Fusion: Mainframe application migration

When migrating applications from mainframe environments to Azure, most teams follow a pragmatic approach: reuse wherever possible, and then start a phased deployment where the application is rewritten or replaced.

Application migration typically involves one or more of the following strategies:

-   **Rehost.** You can move existing code, programs, and applications from the mainframe and recompile the code to run in a mainframe emulator hosted in a cloud instance. This approach typically starts with moving an application to a cloud-based emulator, and then migrating the database to a cloud-based database. Some engineering and refactoring are required along with data and file conversions.

    Another options is to rehost using a traditional hosting provider. One of the principal benefits of the cloud is outsourcing infrastructure management. Find a datacenter provider that can host your mainframe workloads for you. This model may buy time, reduce vendor lock-in, and produce interim cost savings.

-   **Retire.** Any applications that are no longer needed should be retired before migration.

-   **Rebuild.** Some organizations choose to completely rewrite programs using more modern techniques. Given the added cost and complexity of this approach, it’s not as common as lift-and-shift. Often, after that type of migration, it makes sense to begin replacing modules and code using code transformation engines.

-   **Replace.** This approach replaces mainframe functionality with equivalent features in the cloud. Software as a service (SaaS) is one option—that is, using a solution created specifically for an enterprise concern, such as finance, human resources, manufacturing, or enterprise resource planning. In addition, many industry-specific apps are now available to solve the problem that a custom mainframe solution was needed for decades ago.

Begin by planning which workloads to migrate initially, and then determine the requirements for moving associated applications, legacy codebases, and databases.

## Mainframe emulation in Azure

Azure cloud services can emulate traditional mainframe environments, enabling you to reuse existing mainframe code and applications. Common server components that you can emulate include online transaction process (OLTP), batch, and data ingestion systems.

### OLTP systems

Many mainframes have OLTP systems that process thousands or millions of updates for huge numbers of users. These applications often use transaction process and screen-form handling software, such as CICS, IMS, and TIP. 

When moving these applications to Azure, emulators for mainframe transaction processing (TP) monitors are available to run as IaaS VMs on Azure. The screen handling and form functionality can also be implemented by web servers. This approach can be combined with database APIs, such as ADO, ODBC, and JDBC for data access and transactions.

### Time-constrained batch updates

Many mainframe systems perform monthly or annual updates of millions of account records, such as those used in banking, insurance, and government. Mainframes handle these types of workloads by offering high throughput data handling systems. Mainframes batch jobs are typically serial in nature and depend on the IOPS provided by the mainframe backbone for performance. 

Cloud-based batch environments use parallel compute and high speed networks for performance. To optimize batch performance, Azure provides various compute, storage, and networking options.

### Data ingestion systems

Mainframes ingest large batches of data from retail, financial services, manufacturing, and other solutions for processing. On Azure, simple command-line utilities such as [AzCopy](https://docs.microsoft.com/azure/storage/common/storage-use-azcopy) can be used for copying data to and from storage, or a service such as [Azure Data Factory](https://docs.microsoft.com/azure/data-factory/introduction), which can ingest data from disparate data stores to create and schedule data-driven workflows.

In addition to emulation environments, Azure provides platform-as-a-service (PaaS) offerings and analytics services that can enhance existing mainframe environments.

## Migrate OLTP workloads to Azure

Lift-and-shift is the no-code option for migrating existing applications to Azure quickly. Each application is migrated as is, which provides the benefits of the cloud without the risks or costs of making code changes. Using an emulator for mainframe TP monitors on Azure supports this approach.

TP monitors are available from various vendors and run in virtual machines, an infrastructure-as-a-service (IaaS) option on Azure. The following before-and-after diagrams show a migration of an online application backed by IBM Db2, a relational database management system (DBMS), on an IBM z/OS mainframe. Db2 for z/OS uses virtual storage access method (VSAM) files to store the data and Indexed Sequential Access Method (ISAM) for flat files. This architecture also uses CICS for transaction monitoring.

![Lift-and-shift of a mainframe environment to Azure using emulation software](../../_images/mainframe-migration/mainframe-vs-azure.png)

On Azure, emulation environments are used to run the TP manager and the batch jobs that use JCL. In the data tier, Db2 is replaced by [Azure SQL Database](https://docs.microsoft.com/azure/sql-database/sql-database-technical-overview), although Microsoft SQL Server, Db2 LUW, or Oracle Database can also be used. An emulator supports IMS, VSAM, and SEQ. The mainframe’s system management tools are replaced by Azure services, and software from other vendors, that run in VMs.

The screen handling and form entry functionality is commonly implemented using web servers, which can be combined with database APIs, such as ADO, ODBC, and JDBC for data access and transactions. The exact line-up of Azure IaaS components to use depends on the operating system you prefer. For example:

-   Windows–based VMs: Use Internet Information Server (IIS) along with ASP.NET for the screen handling and business logic. Use ADO.NET for data access and transactions.

-   Linux–based VMs: Use the Java-based application servers that are available, such as Apache Tomcat for screen handling and Java-based business functionality. Use JDBC for data access and transactions.

## Migrate batch workloads to Azure

Batch operations in Azure differ from the typical batch environment on mainframes. Mainframe batch jobs are typically serial in nature and depend on the IOPS provided by the mainframe backbone for performance. Cloud-based batch environments use parallel computing and high-speed networks for performance.

To optimize batch performance in Azure, consider the [compute](https://docs.microsoft.com/azure/virtual-machines/windows/overview), [storage](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction), [networking](https://azure.microsoft.com/en-us/blog/maximize-your-vm-s-performance-with-accelerated-networking-now-generally-available-for-both-windows-and-linux/), and [monitoring](https://docs.microsoft.com/azure/azure-monitor/overview) options as follows.

### Compute

-   Use VMs with the highest clock speed. Mainframe applications are often single-threaded, and mainframe CPUs have a very high clock speed.

-   Use VMs with large memory capacity to allow caching of data and application work areas.

-   Use VMs with higher density vCPUs to take advantage of multi-threaded processing if the application supports multiple threads.

-   Consider using parallel processing. Azure easily scales out for parallel processing, delivering more compute power for a batch run.

### Storage

-   Use [Azure Premium SSD](https://docs.microsoft.com/azure/virtual-machines/windows/premium-storage) or [Azure Ultra SSD](https://docs.microsoft.com/azure/virtual-machines/windows/disks-ultra-ssd) for maximum available IOPS.

-   Use striping with multiple disks for more IOPS per storage size.

-   Consider using partitioning for storage to spread IO over multiple Azure storage devices.

### Networking

-   Use [Azure Accelerated Networking](https://docs.microsoft.com/azure/virtual-network/create-vm-accelerated-networking-powershell) to minimize latency.

### Monitoring

-   Use monitoring tools. [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview), [Azure Application Insights](https://docs.microsoft.com/azure/application-insights/app-insights-overview), and even the Azure logs enable administrators to monitor any over-performance of batch runs and help eliminate bottlenecks.

## Migrate development environments

The cloud’s distributed architectures rely on a different set of development tools that provide the advantage of modern practices and programming languages. To ease the transition, you can use a development environment and other tools on Azure designed to emulate IBM z/OS environments. The following list shows options from Microsoft and other vendors:

| Component        | Options on Azure                                                                                                                                  |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| z/OS             | Run Windows, Linux, or UNIX.                                                                                                                      |
| CICS             | Consider the Azure services offered by Micro Focus, Oracle, GT Software (Fujitsu), TmaxSoft, Raincode, and NTT Data. Or rewrite using Kubernetes. |
| IMS              | Consider the Azure services offered by Micro Focus and Oracle.                                                                                    |
| Assembler        | Consider the Azure services from Raincode and TmaxSoft. Alternatively, use COBOL, C, or Java, or map to operating system functions.               |
| JCL              | Use JCL, PowerShell, or other scripting tools.                                                                                                    |
| COBOL            | Use COBOL, C, or Java.                                                                                                                            |
| Natural          | Use Natural, COBOL, C, or Java.                                                                                                                   |
| FORTRAN and PL/I | Use FORTRAN, PL/I, COBOL, C, or Java.                                                                                                             |
| REXX and PL/I    | Use REXX, PowerShell, or other scripting tools.                                                                                                   |

## Migrate databases and data

Application migration usually means rehosting the data tier. SQL Server, open-source, and other relational databases can be migrated to fully managed
solutions on Azure, such as [Azure SQL Database Managed Instance](https://docs.microsoft.com/azure/sql-database/sql-database-managed-instance), [Azure Database Service for PostgreSQL](https://docs.microsoft.com/azure/postgresql/overview), and [Azure Database for MySQL](https://docs.microsoft.com/azure/mysql/overview) with [Azure Database Migration Service](https://docs.microsoft.com/azure/dms/dms-overview).

For example, if the mainframe data tier uses:

-   IBM Db2 or an IMS database, use Azure SQL Database, SQL Server, Db2 LUW, orOracle Database on Azure.

-   VSAM and other flat files, use Indexed Sequential Access Method (ISAM) flat files for Azure SQL, SQL Server, Db2 LUW, or Oracle.

-   Generation Date Groups (GDGs), migrate to files on Azure that use a naming convention and filename extensions that provide similar functionality to GDGs.

The IBM data tier includes several key components that must also be migrated. For example, when you migrate a database, you also migrate a collection of data contained in pools, each containing dbextents, which are z/OS VSAM data sets. Migration must include the directory that identifies data locations in the storage pools. In addition, the migration plan must consider the database log, which contains a record of operations performed on the database. A database can have one, two (dual or alternate), or four (dual and alternate) logs.

Database migration includes these components as well:

-   Database manager. Provides access to data in the database. The database manager runs in its own partition in a z/OS environment.

-   Application requester. Accepts requests from applications before passing them to an application server.

-   Online resource adapter. Includes application requester components for use in CICS transactions.

-   Batch resource adapter. Implements application requester components for z/OS batch applications.

-   Interactive SQL (ISQL). Runs as a CICS application and interface enabling users to enter SQL statements or operator commands.

-   CICS application. Runs under the control of CICS, utilizing available resources and data sources in CICS.

-   Batch application. Runs process logic without interactive communication with users to, for example, produce bulk data updates or generate reports from a database.

## Optimize scale and throughput for Azure

Generally speaking, mainframes scale up, while the cloud scales out. To optimize scale and throughput of mainframe-style applications running on Azure, it is important to look at how a mainframe separates and isolates applications. A z/OS mainframe uses a feature called Logical Partitions (LPARS) to isolate and manage the resources for a specific application on a single instance.

For example, a mainframe might use one LPAR for a CICS region with associated COBOL programs, and a separate LPAR for Db2. Additional LPARs are often used for the development, testing, and staging environments.

On Azure, it’s more common to use separate VMs to serve this purpose. Azure architectures typically deploy VMs for the application tier, a separate set of VMs for the data tier, another set for development, and so on. Each tier of processing can be optimized using the most suitable type of VMs and  features for that environment.

In addition, each tier can also provide appropriate disaster recovery services. For example, production and database VMs might require a hot or warm recovery, while the development and testing VMs support a cold recovery.

The following figure shows a possible Azure deployment using a primary and a secondary site. In the primary site, the production, preproduction, and testing VMs are deployed with high availability. The secondary site is for backup and disaster recovery.

![A possible Azure deployment using a primary and a secondary site](../../_images/mainframe-migration/migration-backup-DR.png)

## Perform a staged mainframe to Azure

Moving solutions from the mainframe to Azure may involve a *staged* migration, where some applications are moved first and others are left on the mainframe temporarily or permanently. This approach typically requires systems that allow applications and databases to interoperate between the mainframe and Azure.

A common scenario is to move an application to Azure while keeping the data used by the application on the mainframe. Some kind of software is used to enable the application in Azure to access data from the mainframe. Fortunately, a wide range of solutions provide integration between Azure and existing mainframe environments, support for hybrid scenarios, and migration over time. Microsoft partners, independent software vendors, and system integrators can help you on your journey.

One option is [Microsoft Host Integration Server](https://docs.microsoft.com/host-integration-server/) (HIS), a solution that provides the Distributed Relational Database Architecture (DRDA) required for applications in Azure to access data in Db2 that remains on the mainframe. Other options for mainframe-to-Azure integration include solutions from IBM, Attunity, Codit, other vendors, and open source options.

## Partner solutions

If you are considering a mainframe migration, our expanding partner ecosystem is available to help you.

Azure provides a proven, highly available, and scalable infrastructure for systems that currently run on mainframes. Some workloads can be migrated with
relative ease. Other workloads that depend on legacy system software, such as CICS and IMS, can be rehosted using partner solutions and migrated to Azure over time. Whatever the choice, a diverse group of partners are available to assist you in optimizing for Azure while maintaining mainframe system software functionality.

For detailed guidance about choosing a partner solution, refer to the [Platform Modernization Alliance](https://www.platformmodernization.org/pages/mainframe.aspx).

## Learn more

For more information, see the following resources:

-   [Get started with Azure](https://docs.microsoft.com/azure/)

-   [Platform Modernization Alliance: Mainframe migration](https://www.platformmodernization.org/pages/mainframe.aspx)

-   [Deploy IBM Db2 pureScale on Azure](https://azure.microsoft.com/resources/deploy-ibm-db2-purescale-on-azure)

-   [Host Integration Server (HIS) documentation](https://docs.microsoft.com/host-integration-server/)
