---
title: Oracle on Azure architecture design
titleSuffix: Azure Architecture Center
description: Learn about sample architectures, solutions, and guides that can help you explore Oracle workloads on Azure.
author: kisshetty
ms.author: kishetty
ms.date: 08/31/2022
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
categories:
  - databases
products:
  - azure
  - azure-virtual-machines
---

# Oracle on Azure architecture design

Microsoft and Oracle have partnered to enable customers to deploy Oracle Database & applications on Azure cloud. You can run your Oracle Database and enterprise applications on Oracle Linux, Windows Server, and other supported operating systems on Azure. In addition to Oracle databases, Azure also supports:

- WebLogic Server integrated with Azure services
- Applications on Oracle Linux and WebLogic Server
- Options for high availability and for disaster recovery
- Options for backing up Oracle workloads

The co-location of Oracle Database & Oracle Applications on Azure enables you to migrate and run mission-critical enterprise workloads with minimal latency and best of both worlds (OCI & Azure).

Azure provides a wide range of services to support Oracle on Azure. Following are some of the key services:

- [Accelerate your cloud adoption with Microsoft and Oracle](https://azure.microsoft.com/solutions/oracle/). Run your Oracle Database and enterprise applications on Azure and Oracle Cloud.

- [Java on Azure](https://azure.microsoft.com/resources/developers/java/). Run Java EE applications with Oracle WebLogic Server on Azure Kubernetes Service (AKS) with solutions validated by Microsoft and Oracle.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux/#overview). Use preconfigured solutions from Oracle and host Java application servers with Oracle WebLogic on Azure virtual machines (VMs).

## Introduction to Oracle on Azure
Oracle on Azure adoption scenarios provide two principal technology platform options:
- [Oracle on Azure Virtual Machines](https://learn.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/): Run Oracle databases and enterprise applications, such as Siebel, PeopleSoft, JD Edwards, E-Business Suite, or customized WebLogic Server applications on Azure infrastructure. You can use an Oracle Linux image, Red Hat Enterprise Linux (RHEL), or another endorsed operating system. There are multiple VMs and storage options available.
-	[Oracle Database@Azure](https://learn.microsoft.com/en-us/azure/oracle/oracle-db/oracle-database-what-is-new): You can use Oracle Database@Azure to run Oracle Exadata infrastructure in Azure. Oracle Exadata is a high-performance database platform. Oracle Database@Azure supports tools, such as Oracle Real Application Clusters (RAC) and Oracle Data Guard. Oracle enterprise applications such as Siebel, PeopleSoft, JD Edwards, E-Business Suite, or customized WebLogic Server applications run on Azure VMs and can connect to Oracle Database@Azure.

## Path to production

The following sections can help you on the path to production for Oracle on Azure:

- [Database migration and deployment](#database-migration-and-deployment)
- [Backup and recovery of databases and workloads](#backup-and-recovery-of-databases-and-workloads)
- [WebLogic Server](#weblogic-server)

### Database migration and deployment

The following articles describe how to run an Oracle database on Azure and connect to an Oracle database that's running in on OCI.

- [Oracle database migration to Azure](./reference-architecture-for-oracle-database-migration-to-azure.yml). This solution idea describes how to migrate an Oracle database to Azure by using Oracle Active Data Guard and Azure Load Balancer. This solution allows you to gradually migrate your application tier in multiple steps.

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

- [SAP deployment on Azure using an Oracle database](../../example-scenario/apps/sap-production.yml). This reference architecture shows a set of proven practices for running SAP NetWeaver with Oracle Database on Azure, with high availability.

- [Deploy Oracle Datbase on Azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/oracle-iaas/). This article describes Azure landing zone architecture for Oracle Database on Azure, both IaaS & Exadata Service.

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

