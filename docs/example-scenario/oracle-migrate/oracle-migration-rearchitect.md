---
title: Oracle database migration - Rearchitect
titleSuffix: Azure Example Scenarios
description: Description
author: amberz
ms.date: 06/12/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Oracle database migration - Rearchitect

If comfortable to manage MSSQL, Azure managed instance(MI) is a good options given it's Microsoft 1st party relational database on Azure.

![](media/rearchitect.png)

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