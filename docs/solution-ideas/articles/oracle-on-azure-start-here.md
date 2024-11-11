---
title: Oracle on Azure architecture design
titleSuffix: Azure Architecture Center
description: Learn about sample architectures, solutions, and guides that can help you explore Oracle workloads on Azure.
author: kisshetty
ms.author: kishetty
ms.date: 11/12/2024
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

Oracle on Azure provides two principal technology platform options:

- [Oracle on Azure Virtual Machines](/azure/virtual-machines/workloads/oracle/). Run Oracle databases and enterprise applications, such as Siebel, PeopleSoft, JD Edwards, E-Business Suite, or customized WebLogic Server applications on Azure infrastructure. You can use Oracle Linux, Red Hat Enterprise Linux (RHEL), or another supported operating system. There are multiple VMs and storage options available.

- [Oracle Database@Azure](/azure/oracle/oracle-db/database-overview). You can use Oracle Database@Azure to run Oracle Exadata infrastructure in Azure. Oracle Exadata is a high-performance database platform. Oracle Database@Azure supports tools, such as Oracle Real Application Clusters (RAC) and Oracle Data Guard. Oracle enterprise applications such as Siebel, PeopleSoft, JD Edwards, E-Business Suite, or customized WebLogic Server applications run on Azure VMs and can connect to Oracle Database@Azure.

In addition to Oracle databases, Azure also supports:

- [WebLogic Server integrated with Azure services](/azure/virtual-machines/workloads/oracle/oracle-weblogic). WebLogic Server (WLS) can be deployed in Azure in several different predefined configurations.
- [Accelerate your cloud adoption with Microsoft and Oracle](/azure/cloud-adoption-framework/scenarios/oracle-iaas/). Run your Oracle Database and enterprise applications on Azure and Oracle Cloud.

- [Java on Azure](https://azure.microsoft.com/resources/developers/java/). Run Java EE applications with Oracle WebLogic Server on Azure Kubernetes Service (AKS) with solutions validated by Microsoft and Oracle.

- [Linux virtual machines in Azure](https://azure.microsoft.com/services/virtual-machines/linux/#overview). Use preconfigured solutions from Oracle and host Java application servers with Oracle WebLogic on Azure virtual machines (VMs).

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

- [SAP deployment on Azure using an Oracle database](../../example-scenario/apps/sap-production.yml). Learn about a set of proven practices for running SAP NetWeaver with Oracle Database in Azure, with high availability.
- [Data migration scenario](/azure/virtual-machines/workloads/oracle/oracle-migration). Find options to migrate data as part of database migration.
- [Perfomance best practices](/azure/virtual-machines/workloads/oracle/oracle-performance-best-practice). Host Oracle Database on Azure VMs and learn about storage options.
- [Partner storage offering](/azure/virtual-machines/workloads/oracle/oracle-third-party-storage). Host Oracle Database on Azure VMs with storage solutions from a partner.

## Oracle on Azure architectures

The articles in this section describe architectures for deploying Oracle applications on Azure and integrating services on Azure with services on OCI.

- [Architectures to deploy Oracle applications on Azure](/azure/virtual-machines/workloads/oracle/oracle-oci-applications). This article describes recommended architectures for deploying Oracle E-Business Suite, JD Edwards EnterpriseOne, and PeopleSoft in cross-cloud configurations or entirely on Azure.
- [Reference architectures for Oracle Database Enterprise Edition on Azure](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture). This article provides detailed information about deploying Oracle Database Enterprise Edition on Azure and using Oracle Data Guard for disaster recovery.

## Stay current with Oracle on Azure

To stay informed about Oracle on Azure, check Azure updates and the Azure blog.

> [!div class="nextstepaction"]
> [Check Azure updates for news about Oracle on Azure](https://azure.microsoft.com/updates/?query=Oracle)

> [!div class="nextstepaction"]
> [Check Microsoft Azure Blog for posts about Oracle on Azure](https://azure.microsoft.com/search/blog/?q=Oracle)

## Additional resources

The following articles provide additional support for implementing Oracle on Azure:

- [Overview of Oracle Applications and solutions on Azure](/azure/virtual-machines/workloads/oracle/oracle-overview). This article introduces capabilities to run Oracle solutions by using Azure infrastructure.

- [Oracle VM images and their deployment on Microsoft Azure](/azure/virtual-machines/workloads/oracle/oracle-vm-solutions). This article provides information about Oracle solutions based on virtual machine images published by Oracle in the Azure Marketplace.


