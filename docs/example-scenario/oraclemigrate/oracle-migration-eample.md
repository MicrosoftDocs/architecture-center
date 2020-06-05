---
title: Oracle database migration
titleSuffix: Azure Example Scenarios
description: Description
author: amberz
ms.author: demar
ms.date: 06/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Oracle database migration

This example provide a reference for decision tree of Oracle database migration, migration path to virtual machine, or Azure managed database(such as: PostgreSQL, SQL Database/Managed Instance), migration guidance and docs relative.

## Migration Decision Tree

Since restriction of applications (i.e. application only support Oracle database) or technologies preference, there are some options for Oracle database migrate to Azure, refer below migration decision tree:

![](media/oracle-migration-decision-tree.png)

## Migration Process
Below migration guidance provide Oracle database migrate to Azure Managed Instance and Azure database for PostgreSQL including existing Oracla Database environment assessment, Oracle schemas and objects conversion to SQL or PostgreSQL, and data migration.

![](media/oracle-migration-process-to-sql-pg.png)

For Oracle database migrate to Azure virtual Machines(VMs), it's mainly about choose Azure VMs size, Disk type, data migration and how to archive business continuity and disaster recovery requirements.

## Oracle database discoveries

### Discovery Oracle environment

Microsoft Data Migration Jumpstart Team maintain Oracle Scripts to run on Oracle Database to evaluate how many tables, stored procedures, views, packages etc. in existing Oracle environment, it will give a assessment if the existing Oracle Database is very complex.

The assessment principles as below table:

| | Simple | Medium | Large | Complex | Custom |
|-| ------ | ------ | ----- | ------- | ------ |
| Number of Tables in schema | <500 | 501-1000 | 1001-2000 | 2001-3000 | >3000 |
| Total number of SP, Trigger, Functions, Views | <100 | 101-200 | 201-400 | 401-800 | >800 |
| Collection Types per schema | <10 | 11-20 | 21-40 | 41-80 | >80 |
| Packages per schema | <10 | 11-25 | 26-50 | 51-100 | >100 |
| Schema Data Size | <10GB | 11-75 GB | 76-500GB | 501-2000 | >2000 |

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

### Scenaio 2: Refactor

If prefer managed service on Azure and have legacy Oracle code, Azure offer Azure database migration service to allow Oracle database easily migrate Azure database for PostgreSQL.

#### Prerequisites

* Azure Subscritpion is required, refer [How to create Azure subscription](/azure/cost-management-billing/manage/create-subscription) to create a new subscritpion if doesn't exist. 
* Provision Azure Data Migration Service(DMS), refer [Create DMS using Azure portal](/azure/dms/quickstart-create-data-migration-service-portal) about how to create DMS on Azure.

#### Why migrate to PostgreSQL

* Azure database for PostgreSQL provide built-in business continuity and disaster recovery capacibity. Refer [How to create PostgreSQL read replica](/azure/postgresql/concepts-read-replicas) to improve PostgreSQL database reliability.

* Azure provide Azure Data Migration Service to allow easily to migrate data to PostgreSQL online.  

### Assessment migration complexity

Ora2Pg allow to run below command to get migration complexity assessment.

```sql
ora2pg -t SHOW_REPORT --estimate_cost
```

The output of the schema assessment as below:

```dotnetcli
Migration levels:

    A - Migration that might be run automatically

    B - Migration with code rewrite and a human-days cost up to 5 days

    C - Migration with code rewrite and a human-days cost above 5 days

Technical levels:

    1 = trivial: no stored functions and no triggers

    2 = easy: no stored functions but with triggers, no manual rewriting

    3 = simple: stored unctions and/or triggers no manual rewriting

    4 = manual: no stored functions but with triggers or views with code rewriting

    5 = difficulty: stored functions and/or triggers with code rewriting
```

#### Migration tools

Oracle database discoveries script:

* [Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx)
* [Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql)
* [Oracle PL\SQL 2](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_v12_Plus.sql)

Assessment of Oracle database migration complexity

* [Ora2PG](http://ora2pg.darold.net)

Oracle schema conversition:

* [Ora2PG](http://ora2pg.darold.net)

Oracle data online migration:

* [Microsoft Data Migration Service](/azure/dms/tutorial-oracle-azure-postgresql-online)

#### Oracle Objects conversion and Data migration

Convert Oracle tables, stored procedures, packages and other database objects to Postgres compatible by using ora2pg, then starting a migration pipeline in Azure Database Migration Service.

##### Convert Oracle objects

Install ore2pg on Azure Virtual Machine, refer [How to install ora2pg on Windows/Linux](https://github.com/microsoft/DataMigrationTeam/blob/master/Whitepapers/Steps%20to%20Install%20ora2pg%20on%20Windows%20and%20Linux.pdf)

Connect to Ora2pg to convert schemas, refer [How to convert Oracle schema to PostgreSQL using Ora2PG](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20PostgreSQL%20Migration%20Cookbook.pdf).

##### Online migrate data

DMS provide online migration to reduce downtime, refer [How to online migrate Oracle data](/azure/dms/tutorial-oracle-azure-postgresql-online#create-a-dms-instance) for online data migration.

##### Workaround list

Below is workaround list when migrating Oracle database to PostgreSQL, refer [Oracle migrate to PostgreSQL workaround list](https://github.com/Microsoft/DataMigrationTeam/blob/master/Whitepapers/Oracle%20to%20Azure%20Database%20for%20PostgreSQL%20Migration%20Workarounds.pdf) to get detailed scripts.

| Oracle | PostgreSGL |
| ------ | ---------- |
| Database Link | Foreign Data Wrapper |
| External Table | Foreign Table |
| Synonym | View / Set search_path |
| Global Temporary Table | Unlogged Table / Temp Table |
| Virtual column | View / Function / Trigger |
| Connected by | With Recursive |
| Reverse Index | Functional Index |
|Index Organized Table (IOT) | Cluster the table according to an Index |

### Scenario 3: Rearchitect

If comfortable to manage MSSQL, Azure managed instance(MI) is a good options given it's Microsoft 1st party relational database on Azure.

#### Why migrate to Azure MI

* Azure Managed Instance provide built-in [business continuity and disaster recovery capability](/azure/sql-database/sql-database-business-continuity)
* Azure Managed Instance offer [Enterprise security](/azure/sql-database/sql-database-security-overview) and stability. 
* Microsoft provide SQL Server Migration Assistant for Oracle allow to ealy convert Oracle objects and migrate data to MI for free.

To download the SSMA for Oracle, downlad the latest version [Microsoft SQL Server Migration Assistant for Oracle](https://aka.ms/ssmafororacle)

#### Migration tools

Oracle database discoveries script:
[Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx), 
[Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) 
[Oracle PL\SQL 2](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_v12_Plus.sql)

Oracle schema and data migration:
[Microsoft SQL Server Migration Assistant for Oracle](https://aka.ms/ssmafororacle)

#### Oracle objects Conversion Principles

Below table describes how SSMA tool convert Oracle objects to SQL objects.

| Oracle Objects | Resulting SQL Server Objects |
| -------------- | ---------------------------- |
| Functions | If the function can be directly converted to Transact-SQL, SSMA creates a function.<br>In some cases, the function must be converted to a stored procedure. In this case, SSMA creates a stored procedure and a function that calls the stored procedure. |
| Procedures | If the procedure can be directly converted to Transact-SQL, SSMA creates a stored procedure. <br> In some cases a stored procedure must be called in an autonomous transaction. In this case, SSMA creates two stored procedures: one that implements the procedure, and another that is used for calling the implementing stored procedure. |
| Packages | SSMA creates a set of stored procedures and functions that are unified by similar object names. |
| Sequences | SSMA creates sequence objects (SQL Server 2012 or SQL Server 2014) or emulates Oracle sequences. |
| Tables with dependent objects such as indexes and triggers | SSMA creates tables with dependent objects. |
| View with dependent objects, such as triggers | SSMA creates views with dependent objects. |
| Materialized Views | **SSMA creates indexed views on SQL server with some exceptions. Conversion will fail if the materialized view includes one or more of the following constructs**:<br><br><code>User-defined function<br><br>Non deterministic field / function / expression in SELECT, WHERE or GROUP BY clauses<br><br>Usage of Float column in SELECT*, WHERE or GROUP BY clauses (special case of previous issue)<br><br>Custom data type (incl. nested tables)<br><br>COUNT(distinct &lt;field&gt;)<br><br>FETCH<br>OUTER joins (LEFT, RIGHT, or FULL)<br>Subquery, other view<br>OVER, RANK, LEAD, LOG<br>MIN, MAX<br>UNION, MINUS, INTERSECT<br>HAVING</code> |
| Trigger | **SSMA creates triggers based on the following rules**:<br><br><code>BEFORE triggers are converted to INSTEAD OF triggers.<br><br>AFTER triggers are converted to AFTER triggers.<br><br>INSTEAD OF triggers are converted to INSTEAD OF triggers. Multiple INSTEAD OF triggers defined on the same operation are combined into one trigger.<br><br>Row-level triggers are emulated using cursors.<br><br>Cascading triggers are converted into multiple individual triggers. </code>|
| Synonyms | **Synonyms are created for the following object types**:<br><br><code>Tables and object tables<br>Views and object views<br>Stored procedures<br>Functions<code>**Synonyms for the following objects are resolved and replaced by direct object references**:<br><br></code>Sequences<br><br>Packages<br><br>Java class schema objects<br><br>User-defined object types<br>Synonyms for another synonym cannot be migrated and will be marked as errors.<br><br>Synonyms are not created for Materialized views.</code> |
| User Defined Types | **SSMA does not provide support for conversion of user defined types. User Defined Types, including its usage in PL/SQL programs are marked with special conversion errors guided by the following rules**:<br><br><code>Table column of a user defined type is converted to VARCHAR(8000).<br><br>Argument of user defined type to a stored procedure or function is converted to VARCHAR(8000).<br>Variable of user defined type in PL/SQL block is converted to VARCHAR(8000).<br><br>Object Table is converted to a Standard table.<br> Object view is converted to a Standard view.</code>|

For more information, see [Schema conversion](/sql/ssma/mysql/converting-mysql-databases-mysqltosql?view=sql-server-ver15)

#### Oracle Objects conversion and Data migration

After installed SSMA, create report to convert Oracle Schema and migrate data to Managed Instance
For step-by-step guide, see [SSMA Migration guide](/sql/ssma/oracle/sql-server-linux-convert-from-oracle?view=sql-server-ver15)

#### Post tasks after migration

After the whole migration, uninstall the client components to remove ssma_oracle schema.

Note, you should not uninstall the extension pack from SQL Server unless your migrated databases no longer use functions in the ssma_oracle schema of the sysdb database.

For more information, refer [Removing SSMA for Oracle Components](/sql/ssma/oracle/removing-ssma-for-oracle-components-oracletosql?view=sql-server-ver15)

### Scenario 4: Cross-cloud connectivity

To support multi-cloud experience, Microsoft and Oracle provide direct interconnection between Azure and Oracle Cloud Infrastructure (OCI) through ExpressRoute and FastConnect. It allows applications hosted on Azure and Oracle database hosted on Oracle Cloud Infrastructure (OCI) with low latency, high throughput by connecting an ExpressRoute circuit in Microsoft Azure with a FastConnect circuit in OCI.

#### Certify applications

For which Oracle applications are certified by Oracle and supported direct interconnection, refer [those certified applications by Oracle](/azure/virtual-machines/workloads/oracle/configure-azure-oci-networking) to run in Azure.

#### How to configure cross-cloud connectivity
Refer [Set up a direct interconnection between Azure and Oracle Cloud Infrastructure](/azure/virtual-machines/workloads/oracle/configure-azure-oci-networking) to gain step-by-step configurations.
