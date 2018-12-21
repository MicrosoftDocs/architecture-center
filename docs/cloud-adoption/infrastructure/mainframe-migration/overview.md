---
title: "Mainframe migration: Overview"
description: Migrate applications from mainframe environments to Azure, a proven, highly available, and scalable infrastructure for systems that currently run on mainframes. 
author: njray
ms.date: 12/21/2018
---

# Fusion: Mainframe migration overview

Many companies and organizations benefit from moving some or all their mainframe workloads, applications, and databases to the cloud. Azure provides mainframe-like features at cloud scale without many of the drawbacks typically associated with mainframes.

The term mainframe generally refers to a large computer system. The vast majority of mainframes currently deployed are IBM System Z servers or IBM plug-compatible systems running MVS, DOS, VSE, OS/390, or z/OS. Mainframes continue to be used in many organizations to run vital information systems, as they do have a place in highly-specific industries, such as in large, high-volume, transaction-intensive IT environments.

Migrating to the cloud enables your organization to modernize its infrastructure. You can make mainframe applications, and the value that they provide, available as a workload at any time your organization needs them. Many workloads can be transferred to Azure by making only minor code changes, such as modifying database names. More complex workloads can be migrated in a phased approach.

Many organizations that have implemented Azure are using it for critical workloads. The bottom-line incentives that motivate many migration projects, do so as they typically require move development and test workloads to Azure first. Then after the test workloads are migrated, IT can follow up with DevOps, email, and disaster recovery as a service.

## Intended audience

If you’re considering a cloud migration or the addition of Azure cloud services as an option in your IT environment, this guide is for you.

This information is intended to help IT organizations start the migration conversation. This guide assumes that you may be more familiar with Azure and cloud-based infrastructures than with mainframes. This guide starts with an overview of how mainframes work and continues with various strategies for determining what and how to migrate.

## Mainframe architecture

In the late 1950s, mainframes were designed as scale-up servers to run high-volume online transactions and batch processing. As such, mainframes have software for online transaction forms (sometimes called green screens) and high-performance I/O systems for processing the batch runs.

Mainframes have a reputation for high reliability and availability, and are known for their ability to run huge online transactions and batch jobs. A transaction results from a piece of processing initiated by a single request, typically from a user at a terminal, but could also come from multiple other sources, including webpages, remote workstations, or applications in another information system. A transaction can also be triggered automatically at a predefined time as the following figure shows.

![Components in a typical IBM mainframe architecture](../../_images/mainframe-migration/zOS-architectural-layers.png)

A typical IBM mainframe architecture includes these components:

-   **Front-end system:** Users can initiate transactions from terminals, webpages, or remote workstations. Mainframe applications often have custom user interfaces that can be preserved after migration to Azure. Terminal emulators are still used to access mainframe applications and are also called green screen terminals.

-   **Application tier:** Mainframes typically include Customer Information Control System (CICS), a leading transaction management suite for the IBM z/OS mainframe often used with IBM Information Management System (IMS), a message-based transaction manager. Batch systems handle high-throughput data updates for large volumes of account records.

-   **Code:** The programming languages used by mainframes include COBOL, Fortran, PL/I, and Natural. Job control language (JCL) is used to work with z/OS.

-   **Database tier:** A common relational database management system (DBMS) for z/OS is IBM Db2. It manages data structures called *dbspaces* that contain one or more tables and are assigned to storage pools of physical data sets called *dbextents*. Two important database components are the directory that identifies data locations in the storage pools, and the log that contains a record of operations performed on the database. Various flat-file data formats are supported. Db2 for z/OS typically uses virtual storage access method (VSAM) datasets to store the data.

-   **Management tier:** IBM mainframes include scheduling software such as TWS-OPC, tools for print and output management such as CA-SAR and SPOOL, and a source control system for code. Secure access control for z/OS is handled by Resource Access Control Facility (RACF). A database manager provides access to data in the database and runs in its own partition in a z/OS environment.

-   **LPAR:** Logical partitions, or LPARs, are used to divide compute resources. A physical mainframe is partitioned into multiple LPARs.

-   **z/OS:** A 64-bit operating system that is most commonly used for IBM mainframes.

IBM systems use a transaction monitor such as CICS to track and manage all aspects of a business transaction. CICS manages the sharing of resources, the integrity of data, and prioritization of execution. CICS authorizes users, allocates resources, and passes database requests by the application to a database manager such as IBM Db2.

For more precise tuning, CICS is commonly used with IMS/TM (formerly IMS/Data Communications or IMS/DC). IMS was designed to reduce data redundancy by maintaining a single copy of the data. It complements CICS as a transaction monitor by maintaining state throughout the process and recording business functions in a data store.

## Mainframe operations

The following are typical mainframe operations:

-   **Online** workloads include transaction processing, database management, and connections, and are often implemented using IBM Db2, CICS, and z/OS connectors.

-   **Batch** jobs run without user interaction, typically on a regular schedule such as every weekday morning. Batch jobs can be run on systems based on Windows or Linux by using a JCL emulator such as Micro Focus Enterprise Server or BMC Control-M software.

-   **JCL** is used to specify resources needed to process batch jobs. JCL conveys this information to z/OS through a set of job control statements. Basic JCL contains six types of statements: JOB, ASSGN, DLBL, EXTENT, LIBDEF, and EXEC. A job can contain several EXEC statements (steps), and each step could have several LIBDEF, ASSGN, DLBL, and EXTENT statements.

-   **IPL** (initial program load) refers to loading a copy of the operating system from disk into a processor’s real storage and running it. IPLs are used to recover from downtime. An IPL is like booting the operating system on Windows or Linux VMs.

## Next steps

> [!div class="nextstepaction"]
> [Myths and facts](myths-and-facts.md)
