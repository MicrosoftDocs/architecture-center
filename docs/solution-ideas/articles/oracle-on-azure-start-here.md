---
title: Oracle on Azure architecture design
titleSuffix: Azure Architecture Center
description: Learn about sample architectures, solutions, and guides that can help you explore Oracle workloads on Azure.
author: EdPrice-MSFT
ms.author: architectures
ms.date: 08/25/2022
ms.topic: conceptual 
ms.service: architecture-center
ms.subservice: azure-guide
categories:
  - databases
products:
  - azure
  - azure-virtual-machines
---

# Oracle on Azure architecture design

Microsoft and Oracle have partnered to enable customers to deploy Oracle applications in the cloud. You can run your Oracle Database and enterprise applications on Oracle Linux, Windows Server, and other supported operating systems in Azure. Microsoft and Oracle’s cloud interoperability enables you to migrate and run mission-critical enterprise workloads across Microsoft Azure and Oracle Cloud Infrastructure. You can deploy Oracle applications on Azure with their back-end databases in Azure or on Oracle Cloud Infrastructure (OCI).

Azure provides a wide range of services to support Oracle on Azure. Following are some of the key services: 

- [Accelerate your cloud adoption with Microsoft and Oracle](https://azure.microsoft.com/solutions/oracle/). Run your Oracle Database and enterprise applications on Azure and Oracle Cloud.
- [Java on Azure](https://azure.microsoft.com/resources/developers/java/). Run Java EE applications with Oracle WebLogic Server on Azure Kubernetes Service (AKS) with solutions validated by Microsoft and Oracle.
- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux/#overview). Use preconfigured solutions from Oracle and host Java application servers with Oracle WebLogic on Azure virtual machines (VMs).


## Introduction to Oracle on Azure

Azure can support SAP workloads that depend on Oracle software, as described in the following Learn modules:

- [Explore Azure for SAP databases](/learn/modules/explore-azure-databases)
- [Implement high availability for SAP workloads in Azure](/learn/modules/implement-high-availability-for-sap-workloads-azure)
- [Perform backups and restores for SAP workloads on Azure](/learn/modules/perform-backups-restores)

## Path to production

- [Run Oracle databases on Azure](./reference-architecture-for-oracle-database-on-azure.yml). This solution idea illustrates a canonical architecture to achieve high availability for your Oracle Database Enterprise Edition in Azure.

- [Oracle database migration: Lift and shift](../../example-scenario/oracle-migrate/oracle-migration-lift-shift.yml). If you're properly licensed to use Oracle software, you're allowed to migrate Oracle databases to Azure Virtual Machines (VMs).

- [Oracle database migration to Azure](./reference-architecture-for-oracle-database-migration-to-azure.yml). This solution idea describes how to migrate an Oracle database to Azure by using Oracle Active Data Guard.

- [SAP deployment on Azure using an Oracle database](../../example-scenario/apps/sap-production.yml). This reference architecture shows a set of practices for running SAP NetWeaver with Oracle Database on Azure.

- [Oracle Database with Azure NetApp Files](../../example-scenario/file-storage/oracle-azure-netapp-files.yml). This example scenario describes a high-bandwidth, low-latency solution for Oracle Database workloads.

- [Host a Murex MX.3 workload on Azure](../../example-scenario/finance/murex-mx3-azure.yml). This example workload provides details for running Murex MX.3 workloads on various databases, including Oracle databases.

- [Oracle database migration: Cross-cloud connectivity](../../example-scenario/oracle-migrate/oracle-migration-cross-cloud.yml). This example scenario describe creation of an interconnection between Azure and Oracle Cloud Infrastructure (OCI) by using Azure ExpressRoute and FastConnect.

- [Overview of Oracle Applications and solutions on Azure](/azure/virtual-machines/workloads/oracle/oracle-overview). This article introduces capabilities to run Oracle solutions on Linux VMs in Azure infrastructure.

- [Design and implement an Oracle database in Azure](/azure/virtual-machines/workloads/oracle/oracle-design). This article describes how to size an Oracle workload to run in Azure and decide on the best architecture solution for optimal performance.

- [Oracle Database in Azure Linux VM backup strategies](/azure/virtual-machines/workloads/oracle/oracle-database-backup-strategies). This article describes strategies for backing up Oracle databases that run on Azure.

- [Back up and recover an Oracle Database on an Azure Linux VM using Azure Files](/azure/virtual-machines/workloads/oracle/oracle-database-backup-azure-storage). This article demonstrates backing up an Oracle database by using Oracle RMAN and Azure Files.

- [Back up and recover an Oracle Database on an Azure Linux VM using Azure Backup](/azure/virtual-machines/workloads/oracle/oracle-database-backup-azure-backup). This article demonstrates using Azure Backup to create snapshots of the VM disks, which include the database files and fast recovery area.

- 

- [Overview of Oracle Applications and solutions on Azure](/azure/virtual-machines/workloads/oracle/oracle-overview). This article introduces capabilities to run Oracle solutions using Azure infrastructure.

- [Disaster recovery for an Oracle Database 12c database in an Azure environment](/azure/virtual-machines/workloads/oracle/oracle-disaster-recovery). This article describes disaster recovery scenarios for an Oracle 12c database that running on Azure.

- [What are solutions for running Oracle WebLogic Server on Azure Virtual Machines?](/azure/virtual-machines/workloads/oracle/oracle-weblogic). This article describes solutions for running Oracle WebLogic Server (WLS) on Azure virtual machines.

- [What are solutions for running Oracle WebLogic Server on the Azure Kubernetes Service?](/azure/virtual-machines/workloads/oracle/weblogic-aks). This article describes solutions for running Oracle WebLogic Server (WLS) on the Azure Kubernetes Service (AKS).

## Best practices

- [Connectivity to Oracle Cloud Infrastructure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers-oci). This article describes methods for integrating an Azure landing zone architecture with Oracle Cloud Infrastructure (OCI).

## Oracle on Azure architectures

- [Architectures to deploy Oracle applications on Azure](/azure/virtual-machines/workloads/oracle/oracle-oci-applications). This article describes recommended architectures for deploying Oracle E-Business Suite, JD Edwards EnterpriseOne, and PeopleSoft in cross-cloud configurations or entirely on Azure.

- [Oracle application solutions integrating Microsoft Azure and Oracle Cloud Infrastructure](/azure/virtual-machines/workloads/oracle/oracle-oci-overview). This article describes how to partition a multi-tier application to run the database tier on Oracle Cloud Infrastructure (OCI) and the application and other tiers on Microsoft Azure.

- [Reference architectures for Oracle Database Enterprise Edition on Azure](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture). This article provides detailed information about deploying Oracle Database Enterprise Edition on Azure and using Oracle Data Guard for disaster recovery.

- [Oracle database migration to Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure)

- [Overview of Oracle database migration](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-overview)
- [Oracle database migration: Cross-cloud connectivity](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-cross-cloud)
- [Oracle database migration: Lift and shift](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-lift-shift)
- [Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)
- [Run Oracle databases on Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-on-azure)
- [SAP deployment on Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)

## Stay current with Oracle on Azure

## Additional resources

### Example solutions
