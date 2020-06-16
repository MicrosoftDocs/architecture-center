---
title: Oracle database migration - Refactor
titleSuffix: Azure Example Scenarios
description: Description
author: amberz
ms.date: 06/12/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Oracle database migration - Refactor

If prefer managed service on Azure and have legacy Oracle code, Azure offer Azure database migration service to allow Oracle database easily migrate Azure database for PostgreSQL.

![](media/refactor.png)

#### Prerequisites

* Azure Subscritpion is required, refer [How to create Azure subscription](/azure/cost-management-billing/manage/create-subscription) to create a new subscritpion if doesn't exist. 
* Provision Azure Data Migration Service(DMS), refer [Create DMS using Azure portal](/azure/dms/quickstart-create-data-migration-service-portal) about how to create DMS on Azure.

#### Why migrate to PostgreSQL

* Azure database for PostgreSQL provide built-in business continuity and disaster recovery capacity. Refer [How to create PostgreSQL read replica](/azure/postgresql/concepts-read-replicas) to improve PostgreSQL database reliability.

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