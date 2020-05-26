---
title: Title
titleSuffix: Azure Example Scenarios
description: Description
author: GitHubAlias
ms.date: 03/01/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Oracle database migration

This example provide a reference for decision tree of Oracle database migration, migration path to virtual machine, or Azure managed database(such as: PostgreSQL, SQL Database/Managed Instance), migration guidance and docs relative. 


## Migration Decision Tree

Since restriction of applications (i.e. applicaiton only support Oracle database) or technologies preference, there are some otpions for Oracle database migrate to Azure, refer below migration decision tree:

<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/OracleMigrationDecisionTree.png" />&nbsp;

## Migration Process
Below migration guidance provide Oracle database migrate to Azure Managed Instance and Azure database for PostgreSQL including existing Oracla Database environment assessment, Oracle schemas and objects conversion to SQL or PostgreSQL, and data migration.
<IMG SRC="https://github.com/amberz/amber-fork-architecture-center-pr/blob/Amber-branch/docs/example-scenario/oraclemigrate/images/OracleMigrationProcesstoSQL%26PG.png" />&nbsp;

For Oracle database migrate to Azure virtual Machines(VMs), it's mainly about choose Azure VMs size, Disk type, data migration and how to archive business continuity and disaster recovery requirements. 

## Oracle database discoveries 

### Discovery Oracle environment
Microsoft Data Migration Jumpstart Team maintain Oracle Scripts to run on Oracle Database to evalute how many tables, stored procedures, views, packages etc. in existing Oracle environment, it will give a assessment if the existing Oracle Database is very complex. 

The assessment principles as below table:
<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/AssessmentTable.png" />&nbsp;

Download the [Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx) and run [Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) [Oracle PL\SQL 2](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_v12_Plus.sql) in existing Oracle database. 

For how to run the both tools, see [Assessment guide](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/OraclePre-SSMA%20Query%20Guidance.pptx)


## Migration paths

Oracle database would migrate to Azure Virtual Machines, Azure Database for PostgreSQL, Azure Managed Instance/Azure SQL Database, or direct interconnection between Azure and Oracle Cloud Infrastructure (OCI).

### Scenario 1: Lift/shift to Azure VMs


Azure provide Oracle database images with Bring-Your-Own-License, allow to migrate Oracle Database to Azure Virtual Machines.


Whether Oracle database is certified and supported on Microsoft Azure?

Oracle and Microsoft published [Oracle database is certified and supported on Microsoft Azure](https://www.oracle.com/cloud/azure-interconnect-faq.html)

#### License
When using Hyper-Threading Technology enabled Azure virtual Machines, Oracle database count two vCPUs as equivalent to one Oracle Processor license. Refer [Licensing Oracle Software in the Cloud Computing Environment](http://www.oracle.com/us/corporate/pricing/cloud-licensing-070579.pdf) for details. 


#### Create Oracle database
To create Oracle database to Azure Virtual Machine, refer [Oracle VM images and their deployment on Microsoft Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-vm-solutions) to gain step-by-step creation guidance.  

#### Backup stragety
For Oracle database backup stragety, besices using Oracle Recovery Manager (RMAN) to back up the database with full backup, differential backup, Azure backup provide Oracle virtual Machine snapshot as  virtual Machine backup. Rfer [Backup strategy for Oracle database](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-backup-recovery)


#### Business continuity and disaster recovery
For business continuity and disaster recovery, allow to deploy Oracle Data Guard with Fast-Start Failover (FSFO) for database availability, Oracle Data Guard Far Sync for zero data loss protection, Golden gate for multi-master or active-active mode on Azure availability set or availability zone depends on SLA requirements. Refer below docs about: <br />
[How to install and deploy data guard on Azure virtual machines](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/configure-oracle-dataguard) <br />
[How to install and deploy golden gate on Azure virtul machines](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/configure-oracle-golden-gate)<br />
[Refer architecutre for Oracle database on Azure virtual machines](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/oracle-reference-architecture)<br />


Oracle Real Application Cluster (RAC) alone cannot be used in Azure, leveraging FlashGrid SkyCluster can host RAC on Azure. 

For Oracle RAC in Azure with FlashGrid SkyCluster, refer [Oracle RAC in Azure with FlashGrid SkyCluster](https://www.flashgrid.io/oracle-rac-in-azure/) as reference architecture, [SkyCluster for Oracle RAC](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/flashgrid-inc.flashgrid-skycluster) provide Azure SkyCluster for Oracle RAC image. 


### Scenaio 2: Refactor

If prefer managed service on Azure and have legacy Oracle code, Azure offer Azure database migration service to allow Oracle database easily migrate Azure database for PostgreSQL. 

#### Prerequisites
* Azure Subscritpion is required, refer [How to create Azure subscription](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription) to create a new subscritpion if doesn't exist. 
* Provision Azure Data Migration Service(DMS), refer [Create DMS using Azure portal](https://docs.microsoft.com/en-us/azure/dms/quickstart-create-data-migration-service-portal) about how to create DMS on Azure.

#### Why migrate to PostgreSQL
* Azure database for PostgreSQL provide built-in business continuity and disaster recovery capacibity. Refer [How to create PostgreSQL read replica](https://docs.microsoft.com/en-us/azure/postgresql/concepts-read-replicas) to improve PostgreSQL database reliability. 

* Azure provide Azure Data Migration Service to allow easily to migrate to PostgreSQL online.  


#### Migration tools

Oracle Assessment script:
[Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx), 
[Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) 


Oracle schema conversition:
[Ora2PG](http://ora2pg.darold.net)
Oracle data online migration:
[Microsoft Data Migration Service](https://docs.microsoft.com/en-us/azure/dms/tutorial-oracle-azure-postgresql-online)


### Assessment migration complexity 

Ora2Pg allow to run below command to get migration complexity assessment. 
`ora2pg -t SHOW_REPORT --estimate_cost`


The output of the schema assessment as below:
<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/OracletoPGMigrationLevel.png" />&nbsp;


## Oracle Objects conversion and Data migration

Convert Oracle table, stored procedures, packages and other database objects to Postgres compatible by using ora2pg, then starting a migration pipeline in Azure Database Migration Service.

### Convert Oracle objects 
[How to install ora2pg on Windows/Linux](https://github.com/microsoft/DataMigrationTeam/blob/master/Whitepapers/Steps%20to%20Install%20ora2pg%20on%20Windows%20and%20Linux.pdf)
[How to convert Oracle schema to PostgreSQL using Ora2PG](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20PostgreSQL%20Migration%20Cookbook.pdf). 


### Online migrate data

DMS provide online migration to reduce downtime window, refer [How to online migrate Oracle data](https://docs.microsoft.com/en-us/azure/dms/tutorial-oracle-azure-postgresql-online#create-a-dms-instance) for online data migration. 



### Workaround list

Below is workaround list when migrating Oracle database to PostgreSQL:
<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/OracletoPGWorkaroundList.png" />&nbsp;

Refer [Oracle migrate to PostgreSQL workaround list](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20Database%20for%20PostgreSQL%20Migration%20Workarounds.pdf) to get detailed scripts. 


### Rearchitect

If comfortable to manage MSSQL, Azure managed instance(MI) is a good options given it's Microsoft 1st party relational database on Azure. 

#### Why migrate to Azure MI
* Azure Managed Instance provide built-in [business continuity and disaster recovery capability](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-business-continuity)
* Azure Managed Instance offer [Enterprise security](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-security-overview) and stability. 
* Microsoft provide SQL Server Migration Assistant allow Oracle database convert objects and migrate data to MI for free.


To download the SSMA for Oracle,refer to downlad the latest version [Microsoft SQL Server Migration Assistant for Oracle](https://aka.ms/ssmafororacle)

#### Migration guidance 
For whole project migration, refer [Oracle Database migrate to Azure Managed Instance](https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Oracle%20Database%20migrate%20to%20MI.md)


## Migration tools

Oracle Assessment script:
[Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx), 
[Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) 

Oracle schema and data migration:
[Microsoft SQL Server Migration Assistant for Oracle](https://aka.ms/ssmafororacle)


## Oracle objects Conversion Principles
Below table describes how SSMA tool convert Oracle objects to SQL objects. 
<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/SchemaConversionPrinciples1.png" />
<IMG SRC="https://github.com/amberz/Azure-Data-Services-Practices/blob/master/Migrate%20Oracle%20Database%20to%20Azure/Images/SchemaConversionPrinciples2.png" />&nbsp;

For more information, see [Schema conversion](https://docs.microsoft.com/en-us/sql/ssma/mysql/converting-mysql-databases-mysqltosql?view=sql-server-ver15)


## Oracle Objects conversion and Data migration
After installed SSMA, create report to convert Oracle Schema and migrate data to Managed Instance
For step-by-step guide, see [SSMA Migration guide](https://docs.microsoft.com/en-us/sql/ssma/oracle/sql-server-linux-convert-from-oracle?view=sql-server-ver15)



## Post tasks after migration

After the whole migration, you can uninstall the client components to remove ssma_oracle schema. 

Note, you should not uninstall the extension pack from SQL Server unless your migrated databases no longer use functions in the ssma_oracle schema of the sysdb database.

For more information, see [Removing SSMA for Oracle Components](https://docs.microsoft.com/en-us/sql/ssma/oracle/removing-ssma-for-oracle-components-oracletosql?view=sql-server-ver15)


### Cross-cloud connectivity

To support multi-cloud experience, Microsoft and Oracle provide direct interconnection between Azure and Oracle Cloud Infrastructure (OCI) through ExpressRoute and FastConnect.It allows applications hosted on Azure and Oracle database hosted on Oracle Cloud Infrastructure (OCI) with low latency, high throughput by connecting an ExpressRoute circuit in Microsoft Azure with a FastConnect circuit in OCI. 

#### Certify applications

Refer [those certified applications by Oracle](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/configure-azure-oci-networking) to run in Azure.

#### How to configure cross-cloud connectivity
For more information about how to configure cross-cloud connectivity from Azure to OCI, see [Set up a direct interconnection between Azure and Oracle Cloud Infrastructure](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/oracle/configure-azure-oci-networking).