---
title: Move data to a SQL Server virtual machine
description: Move data from flat files or from on-premises SQL Server to SQL Server on Azure VM.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: article
ms.date: 01/04/2022
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Move data to SQL Server on an Azure virtual machine

This article outlines the options for moving data either from flat files (CSV or TSV formats) or from an on-premises SQL Server to SQL Server on an Azure virtual machine. These tasks for moving data to the cloud are part of the Team Data Science Process.

For a topic that outlines the options for moving data to an Azure SQL Database for Machine Learning, see [Move data to an Azure SQL Database for Azure Machine Learning](move-sql-azure.md).

The following table summarizes the options for moving data to SQL Server on an Azure virtual machine.

| <b>SOURCE</b> | <b>DESTINATION: SQL Server on Azure VM</b> |
| --- | --- |
| <b>Flat File</b> |1. <a href="#insert-tables-bcp">Command-line bulk copy utility (BCP) </a><br> 2. <a href="#insert-tables-bulkquery">Bulk Insert SQL Query </a><br> 3. <a href="#sql-builtin-utilities">Graphical Built-in Utilities in SQL Server</a> |
| <b>On-Premises SQL Server</b> |1. <a href="#deploy-a-sql-server-database-to-a-microsoft-azure-vm-wizard">Deploy a SQL Server Database to a Microsoft Azure VM wizard</a><br> 2. <a href="#export-flat-file">Export to a flat File </a><br> 3. <a href="#sql-migration">SQL Database Migration Wizard </a> <br> 4. <a href="#sql-backup">Database back up and restore </a><br> |

This document assumes that SQL commands are executed from SQL Server Management Studio or Visual Studio Database Explorer.

> [!TIP]
> As an alternative, you can use [Azure Data Factory](https://azure.microsoft.com/services/data-factory/) to create and schedule a pipeline that will move data to a SQL Server VM on Azure. For more information, see [Copy data with Azure Data Factory (Copy Activity)](/azure/data-factory/copy-activity-overview).
>
>

## <a name="prereqs"></a>Prerequisites

This tutorial assumes you have:

* An **Azure subscription**. If you do not have a subscription, you can sign up for a [free trial](https://azure.microsoft.com/pricing/free-trial/).
* An **Azure storage account**. You will use an Azure storage account for storing the data in this tutorial. If you don't have an Azure storage account, see the [Create a storage account](/azure/storage/common/storage-account-create) article. After you have created the storage account, you will need to obtain the account key used to access the storage. See [Manage storage account access keys](/azure/storage/common/storage-account-keys-manage).
* Provisioned **SQL Server on an Azure VM**. For instructions, see [Set up an Azure SQL Server virtual machine as an IPython Notebook server for advanced analytics](/azure/machine-learning/data-science-virtual-machine/overview).
* Installed and configured **Azure PowerShell** locally. For instructions, see [How to install and configure Azure PowerShell](/powershell/azure/).

## <a name="filesource_to_sqlonazurevm"></a> Moving data from a flat file source to SQL Server on an Azure VM

If your data is in a flat file (arranged in a row/column format), it can be moved to SQL Server VM on Azure via the following methods:

1. [Command-line bulk copy utility (BCP)](#insert-tables-bcp)
2. [Bulk Insert SQL Query](#insert-tables-bulkquery)
3. [Graphical Built-in Utilities in SQL Server (Import/Export, SSIS)](#sql-builtin-utilities)

### <a name="insert-tables-bcp"></a>Command-line bulk copy utility (BCP)

BCP is a command-line utility installed with SQL Server and is one of the quickest ways to move data. It works across all three SQL Server variants (On-premises SQL Server, SQL Azure, and SQL Server VM on Azure).

> [!NOTE]
> **Where should my data be for BCP?**
> While it is not required, having files containing source data located on the same machine as the target SQL Server allows for faster transfers (network speed vs local disk IO speed). You can move the flat files containing data to the machine where SQL Server is installed using various file copying tools such as [AZCopy](/azure/storage/common/storage-use-azcopy-v10), [Azure Storage Explorer](https://storageexplorer.com/) or windows copy/paste via Remote Desktop Protocol (RDP).
>
>

1. Ensure that the database and the tables are created on the target SQL Server database. Here is an example of how to do that using the `Create Database` and `Create Table` commands:

    ```sql
    CREATE DATABASE <database_name>

    CREATE TABLE <tablename>
    (
        <columnname1> <datatype> <constraint>,
        <columnname2> <datatype> <constraint>,
        <columnname3> <datatype> <constraint>
    )
    ```

1. Generate the format file that describes the schema for the table by issuing the following command from the command line of the machine where bcp is installed.

    `bcp dbname..tablename format nul -c -x -f exportformatfilename.xml -S servername\sqlinstance -T -t \t -r \n`
1. Insert the data into the database using the bcp command, which should work from the command line when SQL Server is installed on same machine:

    `bcp dbname..tablename in datafilename.tsv -f exportformatfilename.xml -S servername\sqlinstancename -U username -P password -b block_size_to_move_in_single_attempt -t \t -r \n`

> **Optimizing BCP Inserts** Please refer the following article ['Guidelines for Optimizing Bulk Import'](/previous-versions/sql/sql-server-2008-r2/ms177445(v=sql.105)) to optimize such inserts.
>
>

### <a name="insert-tables-bulkquery-parallel"></a>Parallelizing Inserts for Faster Data Movement
If the data you are moving is large, you can speed up things by simultaneously executing multiple BCP commands in parallel in a PowerShell Script.

> [!NOTE]
> **Big data Ingestion**
> To optimize data loading for large and very large datasets, partition your logical and physical database tables using multiple file groups and partition tables. For more information about creating and loading data to partition tables, see [Parallel Load SQL Partition Tables](parallel-load-sql-partitioned-tables.md).
>
>

The following sample PowerShell script demonstrates parallel inserts using bcp:

```powershell
$NO_OF_PARALLEL_JOBS=2

Set-ExecutionPolicy RemoteSigned #set execution policy for the script to execute
# Define what each job does
$ScriptBlock = {
    param($partitionnumber)

    #Explicitly using SQL username password
    bcp database..tablename in datafile_path.csv -F 2 -f format_file_path.xml -U username@servername -S tcp:servername -P password -b block_size_to_move_in_single_attempt -t "," -r \n -o path_to_outputfile.$partitionnumber.txt

    #Trusted connection w.o username password (if you are using windows auth and are signed in with that credentials)
    #bcp database..tablename in datafile_path.csv -o path_to_outputfile.$partitionnumber.txt -h "TABLOCK" -F 2 -f format_file_path.xml  -T -b block_size_to_move_in_single_attempt -t "," -r \n
}

# Background processing of all partitions
for ($i=1; $i -le $NO_OF_PARALLEL_JOBS; $i++)
{
    Write-Debug "Submit loading partition # $i"
    Start-Job $ScriptBlock -Arg $i      
}

# Wait for it all to complete
While (Get-Job -State "Running")
{
    Start-Sleep 10
    Get-Job
}

# Getting the information back from the jobs
Get-Job | Receive-Job
Set-ExecutionPolicy Restricted #reset the execution policy
```

### <a name="insert-tables-bulkquery"></a>Bulk Insert SQL Query

[Bulk Insert SQL Query](/sql/t-sql/statements/bulk-insert-transact-sql) can be used to import data into the database from row/column based files (the supported types are covered in the[Prepare Data for Bulk Export or Import (SQL Server)](/sql/relational-databases/import-export/prepare-data-for-bulk-export-or-import-sql-server)) topic.

Here are some sample commands for Bulk Insert are as below:

1. Analyze your data and set any custom options before importing to make sure that the SQL Server database assumes the same format for any special fields such as dates. Here is an example of how to set the date format as year-month-day (if your data contains the date in year-month-day format):

    ```sql
    SET DATEFORMAT ymd;
    ```
2. Import data using bulk import statements:

    ```sql
    BULK INSERT <tablename>
    FROM
    '<datafilename>'
    WITH
    (
        FirstRow = 2,
        FIELDTERMINATOR = ',', --this should be column separator in your data
        ROWTERMINATOR = '\n'   --this should be the row separator in your data
    )
    ```

### <a name="sql-builtin-utilities"></a>Built-in Utilities in SQL Server

You can use SQL Server Integration Services (SSIS) to import data into SQL Server VM on Azure from a flat file. SSIS is available in two studio environments. For details, see [Integration Services (SSIS) and Studio Environments](/sql/integration-services/integration-services-ssis-development-and-management-tools):

* For details on SQL Server Data Tools, see [Microsoft SQL Server Data Tools](/sql/ssdt/download-sql-server-data-tools-ssdt)
* For details on the Import/Export Wizard, see [SQL Server Import and Export Wizard](/sql/integration-services/import-export-data/import-and-export-data-with-the-sql-server-import-and-export-wizard)

## <a name="sqlonprem_to_sqlonazurevm"></a>Moving Data from on-premises SQL Server to SQL Server on an Azure VM

You can also use the following migration strategies:

1. [Deploy a SQL Server Database to a Microsoft Azure VM wizard](#deploy-a-sql-server-database-to-a-microsoft-azure-vm-wizard)
2. [Export to Flat File](#export-flat-file)
3. [SQL Server Migration Assistant (SSMA)](#sql-migration)
4. [Database back up and restore](#sql-backup)

We describe each of these options below:

### Deploy a SQL Server Database to a Microsoft Azure VM wizard

The **Deploy a SQL Server Database to a Microsoft Azure VM wizard** is a simple and recommended way to move data from an on-premises SQL Server instance to SQL Server on an Azure VM. For detailed steps as well as a discussion of other alternatives, see [Migrate a database to SQL Server on an Azure VM](/azure/azure-sql/virtual-machines/windows/migrate-to-vm-from-sql-server).

### <a name="export-flat-file"></a>Export to Flat File

Various methods can be used to bulk export data from an On-Premises SQL Server as documented in the [Bulk Import and Export of Data (SQL Server)](/sql/relational-databases/import-export/bulk-import-and-export-of-data-sql-server) topic. This document will cover the Bulk Copy Program (BCP) as an example. Once data is exported into a flat file, it can be imported to another SQL server using bulk import.

1. Export the data from on-premises SQL Server to a file using the bcp utility as follows

    `bcp dbname..tablename out datafile.tsv -S    servername\sqlinstancename -T -t \t -t \n -c`
2. Create the database and the table on SQL Server VM on Azure using the `create database` and `create table` for the table schema exported in step 1.
3. Create a format file for describing the table schema of the data being exported/imported. Details of the format file are described in [Create a Format File (SQL Server)](/sql/relational-databases/import-export/create-a-format-file-sql-server).

    Format file generation when running BCP from the SQL Server computer

    `bcp dbname..tablename format nul -c -x -f exportformatfilename.xml -S servername\sqlinstance -T -t \t -r \n`

    Format file generation when running BCP remotely against a SQL Server

    `bcp dbname..tablename format nul -c -x -f  exportformatfilename.xml  -U username@servername.database.windows.net -S tcp:servername -P password  --t \t -r \n`
4. Use any of the methods described in section [Moving Data from File Source](#filesource_to_sqlonazurevm) to move the data in flat files to a SQL Server.

### <a name="sql-migration"></a>SQL Server Migration Assistant (SSMA)

[SQL Server Migration Assistant (SSMA)](https://techcommunity.microsoft.com/t5/microsoft-data-migration/bg-p/MicrosoftDataMigration) provides a user-friendly way to move data between two SQL server instances. It allows the user to map the data schema between sources and destination tables, choose column types and various other functionalities. It uses bulk copy (BCP) under the covers. A screenshot of the welcome screen for SQL Server Migration Assistant (SSMA) is shown below.

![Screenshot of the SQL Server Migration Assistant (SSMA).][2]

### <a name="sql-backup"></a>Database back up and restore

SQL Server supports:

1. [Database back up and restore functionality](/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases) (both to a local file or bacpac export to blob) and [Data Tier Applications](/sql/relational-databases/data-tier-applications/data-tier-applications) (using bacpac).
2. Ability to directly create SQL Server VMs on Azure with a copied database or copy to an existing database in SQL Database. For more information, see [Use the Copy Database Wizard](/sql/relational-databases/databases/use-the-copy-database-wizard).

A screenshot of the Database back up/restore options from SQL Server Management Studio is shown below.

![Screenshot of the SQL Server Import Tool.][1]

## Resources

[Migrate a Database to SQL Server on an Azure VM](/azure/azure-sql/virtual-machines/windows/migrate-to-vm-from-sql-server)

[SQL Server on Azure Virtual Machines overview](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview)

[1]: ./media/move-sql-server-virtual-machine/sql-server-built-in-utilities.png
[2]: ./media/move-sql-server-virtual-machine/addsql-aud.png
