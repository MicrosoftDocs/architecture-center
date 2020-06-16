---
title: Oracle database migration - Lift and Shift
titleSuffix: Azure Example Scenarios
description: Description
author: amberz
ms.date: 06/12/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Oracle database migration - Lift and Shift

Azure provide Oracle database images with Bring-Your-Own-License, allow to migrate Oracle Database to Azure Virtual Machines.

![](media/lift-shift-azure-vms.png)

Whether Oracle database is certified and supported on Microsoft Azure?

Oracle and Microsoft published [Oracle database is certified and supported on Microsoft Azure](https://www.oracle.com/cloud/azure-interconnect-faq.html)

#### License

When using Hyper-Threading Technology enabled Azure virtual Machines, Oracle database count two vCPUs as equivalent to one Oracle Processor license. Refer [Licensing Oracle Software in the Cloud Computing Environment](http://www.oracle.com/us/corporate/pricing/cloud-licensing-070579.pdf) for details.

#### Create Oracle database

To create Oracle database to Azure Virtual Machine, refer [Oracle VM images and their deployment on Microsoft Azure](https://docs.microsoft.com/azure/virtual-machines/workloads/oracle/oracle-vm-solutions) to gain step-by-step creation guidance.  

#### Backup stragety

For Oracle database backup stragety, besices using Oracle Recovery Manager (RMAN) to back up the database with full backup, differential backup, Azure backup provide Oracle virtual Machine snapshot as  virtual Machine backup. Rfer [Backup strategy for Oracle database](/azure/virtual-machines/workloads/oracle/oracle-backup-recovery)

#### Business continuity and disaster recovery

For business continuity and disaster recovery, allow to deploy Oracle Data Guard with Fast-Start Failover (FSFO) for database availability, Oracle Data Guard Far Sync for zero data loss protection, Golden gate for multi-master or active-active mode on Azure availability set or availability zone depends on SLA requirements. Refer below docs about:

[How to install and deploy data guard on Azure virtual machines](/azure/virtual-machines/workloads/oracle/configure-oracle-dataguard)

[How to install and deploy golden gate on Azure virtul machines](/azure/virtual-machines/workloads/oracle/configure-oracle-golden-gate)

[Refer architecutre for Oracle database on Azure virtual machines](/azure/virtual-machines/workloads/oracle/oracle-reference-architecture)

Oracle Real Application Cluster (RAC) alone cannot be used in Azure, leveraging FlashGrid SkyCluster can host RAC on Azure.

For Oracle RAC in Azure with FlashGrid SkyCluster, refer [Oracle RAC in Azure with FlashGrid SkyCluster](https://www.flashgrid.io/oracle-rac-in-azure/) as reference architecture, [SkyCluster for Oracle RAC](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/flashgrid-inc.flashgrid-skycluster) provide Azure SkyCluster for Oracle RAC image.