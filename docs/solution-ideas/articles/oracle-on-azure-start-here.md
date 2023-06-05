---
title: Oracle on Azure architecture design
titleSuffix: Azure Architecture Center
description: Learn about sample architectures, solutions, and guides that can help you explore Oracle workloads on Azure.
author: martinekuan
ms.author: martinek
ms.date: 08/31/2022
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

Microsoft and Oracle have partnered to enable customers to deploy Oracle applications in the cloud. You can run your Oracle Database and enterprise applications on Oracle Linux, Windows Server, and other supported operating systems in Azure. In addition to Oracle databases, Azure also supports:

- WebLogic Server integrated with Azure services
- Applications on Oracle Linux and WebLogic Server
- Options for high availability and for disaster recovery
- Options for backing up Oracle workloads

The interoperability of Microsoft and Oracle’s cloud services enables you to migrate and run mission-critical enterprise workloads across Microsoft Azure and Oracle Cloud Infrastructure (OCI).

Azure provides a wide range of services to support Oracle on Azure. Following are some of the key services:

- [Accelerate your cloud adoption with Microsoft and Oracle](https://azure.microsoft.com/solutions/oracle/). Run your Oracle Database and enterprise applications on Azure and Oracle Cloud.

- [Java on Azure](https://azure.microsoft.com/resources/developers/java/). Run Java EE applications with Oracle WebLogic Server on Azure Kubernetes Service (AKS) with solutions validated by Microsoft and Oracle.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux/#overview). Use preconfigured solutions from Oracle and host Java application servers with Oracle WebLogic on Azure virtual machines (VMs).

## Introduction to Oracle on Azure

If you're new to Azure, the best place to start learning about Azure is Microsoft Learn. This free online platform provides interactive training for Microsoft products and more.

If you have an SAP workload that depends on an Oracle database, the Learn modules in the following table can help you understand what Azure has to offer for Oracle databases and SAP.

- [Explore Azure for SAP databases](/training/modules/explore-azure-databases). This module explores SAP databases on Azure and best practices for Azure for SAP workloads, including recommendations from Oracle.

- [Implement high availability for SAP workloads in Azure](/training/modules/implement-high-availability-for-sap-workloads-azure). This module explores high availability and disaster recovery support of Azure for SAP workloads, including use of Oracle Data Guard for high availability of Oracle databases that support SAP workloads.

- [Perform backups and restores for SAP workloads on Azure](/training/modules/perform-backups-restores). This module explores backup and restoration of Azure VMs and examines the steps and considerations in backing up and restoring SAP workloads on Azure, including the Oracle databases that support them.

> [!div class="nextstepaction"]
> [Search Learn for current offerings about Oracle](/search/?terms=Oracle&category=Learn)

## Path to production

The following sections can help you on the path to production for Oracle on Azure:

- [Database migration and deployment](#database-migration-and-deployment)
- [Backup and recovery of databases and workloads](#backup-and-recovery-of-databases-and-workloads)
- [WebLogic Server](#weblogic-server)

### Database migration and deployment

The following articles describe how to run an Oracle database on Azure and connect to an Oracle database that's running in on OCI.

- [Oracle database migration to Azure](./reference-architecture-for-oracle-database-migration-to-azure.yml). This solution idea describes how to migrate an Oracle database to Azure by using Oracle Active Data Guard and Azure Load Balancer. This solution allows you to gradually migrate your application tier in multiple steps.

- [Oracle database migration: Cross-cloud connectivity](../../example-scenario/oracle-migrate/oracle-migration-cross-cloud.yml). This example scenario describes creation of an interconnection between Azure and OCI to allow applications that are hosted on Azure to communicate with an Oracle database that's hosted on OCI.

- [Design and implement an Oracle database in Azure](/azure/virtual-machines/workloads/oracle/oracle-design). This article describes how to size an Oracle workload to run in Azure and decide on the best architecture solution for optimal performance.

### Backup and recovery of databases and workloads

The articles in this section describe methods of backing up and recovering Oracle databases by using Azure resources.

- [Oracle Database in Azure Linux VM backup strategies](/azure/virtual-machines/workloads/oracle/oracle-database-backup-strategies). This article describes strategies for backing up Oracle databases that run on Azure.

- [Back up and recover an Oracle Database on an Azure Linux VM using Azure Files](/azure/virtual-machines/workloads/oracle/oracle-database-backup-azure-storage). This article demonstrates backing up an Oracle database that's running on a VM by using Oracle RMAN and Azure Files.

- [Back up and recover an Oracle Database on an Azure Linux VM using Azure Backup](/azure/virtual-machines/workloads/oracle/oracle-database-backup-azure-backup). This article demonstrates using Azure Backup to create snapshots of the VM disks, which include the database files and fast recovery area. Azure Backup can take full-disk snapshots, which are stored in Recovery Services Vault, that are suitable as backups.

### WebLogic Server

The articles in this section can help you decide on a solution for running Oracle WebLogic Server on Azure and help you prepare for migration.

- [What are solutions for running Oracle WebLogic Server on Azure Virtual Machines?](/azure/virtual-machines/workloads/oracle/oracle-weblogic) This article describes solutions for running Oracle WebLogic Server (WLS) on Azure VMs.

- [What are solutions for running Oracle WebLogic Server on the Azure Kubernetes Service?](/azure/virtual-machines/workloads/oracle/weblogic-aks) This article describes solutions for running Oracle WebLogic Server (WLS) on the Azure Kubernetes Service (AKS).

- [Migrate WebLogic Server applications to Azure Virtual Machines](/azure/developer/java/migration/migrate-weblogic-to-virtual-machines). This guide describes what you should be aware of when you want to migrate an existing WebLogic application to run on Azure VMs.

## Best practices

The articles in this section can help you identify and select the services and configurations that will best support your solutions for Oracle on Azure.

- [SAP deployment on Azure using an Oracle database](../../example-scenario/apps/sap-production.yml). This reference architecture shows a set of proven practices for running SAP NetWeaver with Oracle Database in Azure, with high availability.

- [Connectivity to Oracle Cloud Infrastructure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers-oci). This article describes methods for integrating an Azure landing zone architecture with Oracle Cloud Infrastructure (OCI).

## Oracle on Azure architectures

The articles in this section describe architectures for deploying Oracle applications on Azure and integrating services on Azure with services on OCI.

- [Architectures to deploy Oracle applications on Azure](/azure/virtual-machines/workloads/oracle/oracle-oci-applications). This article describes recommended architectures for deploying Oracle E-Business Suite, JD Edwards EnterpriseOne, and PeopleSoft in cross-cloud configurations or entirely on Azure.

- [Oracle application solutions integrating Microsoft Azure and Oracle Cloud Infrastructure](/azure/virtual-machines/workloads/oracle/oracle-oci-overview). This article describes how to partition a multi-tier application to run the database tier on Oracle Cloud Infrastructure (OCI) and the application and other tiers on Microsoft Azure.

- [Reference architectures for Oracle Database Enterprise Edition on Azure](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture). This article provides detailed information about deploying Oracle Database Enterprise Edition on Azure and using Oracle Data Guard for disaster recovery.

## Stay current with Oracle on Azure

To stay informed about Oracle on Azure, check Azure updates and the Microsoft Azure blog.

> [!div class="nextstepaction"]
> [Check Azure updates for news about Oracle on Azure](https://azure.microsoft.com/updates/?query=Oracle)

> [!div class="nextstepaction"]
> [Check Microsoft Azure Blog for posts about Oracle on Azure](https://azure.microsoft.com/search/blog/?q=Oracle)

## Additional resources

The following articles provide additional support for implementing Oracle on Azure:

- [Overview of Oracle Applications and solutions on Azure](/azure/virtual-machines/workloads/oracle/oracle-overview). This article introduces capabilities to run Oracle solutions by using Azure infrastructure.

- [Oracle VM images and their deployment on Microsoft Azure](/azure/virtual-machines/workloads/oracle/oracle-vm-solutions). This article provides information about Oracle solutions based on virtual machine images published by Oracle in the Azure Marketplace.

- [Oracle application solutions integrating Microsoft Azure and Oracle Cloud Infrastructure](/azure/virtual-machines/workloads/oracle/oracle-oci-overview).  Microsoft and Oracle provide low-latency, high-throughput, cross-cloud connectivity between Azure and OCI, allowing you to partition a multi-tier application across both cloud services.

### Example solutions

Following are some additional solution ideas that might be helpful:

- [Run Oracle databases on Azure](./reference-architecture-for-oracle-database-on-azure.yml). This solution idea illustrates a canonical architecture to achieve high availability for your Oracle Database Enterprise Edition in Azure by using Azure Load Balancers or Application Gateways.

- [Oracle database migration: Lift and shift](../../example-scenario/oracle-migrate/oracle-migration-lift-shift.yml). If you're properly licensed to use Oracle software, you're allowed to migrate Oracle databases to Azure Virtual Machines (VMs).
