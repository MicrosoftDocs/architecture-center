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
# Oracle Database migrate to Azure SQL Database/Managed Instance scenario

## Migration Process

The migration guide will includes existing Oracle Database environment assessment, Oracle schema and objects conversion to SQL, and data migration. For whole migration process, refer below migration process:
![images/OratoSQLMigrationProcess.png]

## Migration tools

Oracle Assessment script:
[Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx), 
[Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) 

Oracle schema and data migration:
[Microsoft SQL Server Migration Assistant for Oracle](https://aka.ms/ssmafororacle)

## Assessment

Oracle_PreSSMA Script( provided by Data Migration Jumpstart Team) can run on Oracle Database to evaluate how many tables, stored procedures, views, packages etc. in existing Oracle environment, it will give a assessment if the existing Oracle Database is very complex. 

The assessment principles as below table:
![images/AssessmentTable.png]

Download the [Assessment Calculator Template](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Customer%20Assessment%20CalculatorTemplate2.xlsx) and run [Oracle PL\SQL](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/Oracle_PreSSMA_Pre_v12.sql) in existing Oracle database. 

For how to run the both tools, see [Assessment guide](https://github.com/microsoft/DataMigrationTeam/blob/master/Oracle%20Inventory%20Script%20Artifacts/Oracle%20Inventory%20Script%20Artifacts/OraclePre-SSMA%20Query%20Guidance.pptx)

## Objects Conversion Principles
Below table describes how SSMA tool convert Oracle objects to SQL objects. 
![images/SchemaConversionPrinciples1.png]
![images/SchemaConversionPrinciples2.png]

For more information, see [Schema conversion](https://docs.microsoft.com/en-us/sql/ssma/mysql/converting-mysql-databases-mysqltosql?view=sql-server-ver15)

## Oracle Objects conversion and Data migration
After installed SSMA, create report to convert Oracle Schema and migrate data to SQL Database or Managed Instance
For step-by-step guide, see [SSMA Migration guide](https://docs.microsoft.com/en-us/sql/ssma/oracle/sql-server-linux-convert-from-oracle?view=sql-server-ver15)

## Post tasks after migration

After the whole migration, you can uninstall the client components to remove ssma_oracle schema.

Note, you should not uninstall the extension pack from SQL Server unless your migrated databases no longer use functions in the ssma_oracle schema of the sysdb database.

For more information, see [Removing SSMA for Oracle Components](https://docs.microsoft.com/en-us/sql/ssma/oracle/removing-ssma-for-oracle-components-oracletosql?view=sql-server-ver15)