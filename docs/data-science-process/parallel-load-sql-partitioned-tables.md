---
title: Parallel bulk data import in SQL partition tables
description: Build partitioned tables for fast parallel bulk importing of data to a SQL Server database.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: article
ms.date: 01/10/2020
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Build and optimize tables for fast parallel import of data into SQL Server on an Azure VM

This article describes how to build partitioned tables for fast parallel bulk importing of data to a SQL Server database. For big data loading/transfer to a SQL database, importing data to the SQL database and subsequent queries can be improved by using *Partitioned Tables and Views*.

## Create a new database and a set of filegroups

* [Create a new database](/sql/t-sql/statements/create-database-transact-sql), if it doesn't exist already.
* Add database filegroups to the database, which holds the partitioned physical files.
* This can be done with [CREATE DATABASE](/sql/t-sql/statements/create-database-transact-sql) if new or [ALTER DATABASE](/sql/t-sql/statements/alter-database-transact-sql-set-options) if the database exists already.
* Add one or more files (as needed) to each database filegroup.

  > [!NOTE]
  > Specify the target filegroup, which holds data for this partition and the physical database file name(s) where the filegroup data is stored.
  >
  >

The following example creates a new database with three filegroups other than the primary and log groups, containing one physical file in each. The database files are created in the default SQL Server Data folder, as configured in the SQL Server instance. For more information about the default file locations, see [File Locations for Default and Named Instances of SQL Server](/sql/sql-server/install/file-locations-for-default-and-named-instances-of-sql-server).

```sql
   DECLARE @data_path nvarchar(256);
   SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);

   EXECUTE ('
      CREATE DATABASE <database_name>
         ON  PRIMARY 
        ( NAME = ''Primary'', FILENAME = ''' + @data_path + '<primary_file_name>.mdf'', SIZE = 4096KB , FILEGROWTH = 1024KB ), 
         FILEGROUP [filegroup_1] 
        ( NAME = ''FileGroup1'', FILENAME = ''' + @data_path + '<file_name_1>.ndf'' , SIZE = 4096KB , FILEGROWTH = 1024KB ), 
         FILEGROUP [filegroup_2] 
        ( NAME = ''FileGroup2'', FILENAME = ''' + @data_path + '<file_name_2>.ndf'' , SIZE = 4096KB , FILEGROWTH = 1024KB ), 
         FILEGROUP [filegroup_3] 
        ( NAME = ''FileGroup3'', FILENAME = ''' + @data_path + '<file_name_3>.ndf'' , SIZE = 102400KB , FILEGROWTH = 10240KB ) 
         LOG ON 
        ( NAME = ''LogFileGroup'', FILENAME = ''' + @data_path + '<log_file_name>.ldf'' , SIZE = 1024KB , FILEGROWTH = 10%)
    ')
```

## Create a partitioned table

To create partitioned table(s) according to the data schema, mapped to the database filegroups created in the previous step, you must first create a partition function and scheme. When data is bulk imported to the partitioned table(s), records are distributed among the filegroups according to a partition scheme, as described below.

### 1. Create a partition function

[Create a partition function](/sql/t-sql/statements/create-partition-function-transact-sql) This function defines the range of values/boundaries to be included in each individual partition table, for example, to limit partitions by month(some\_datetime\_field) in the year 2013:

```sql
   CREATE PARTITION FUNCTION <DatetimeFieldPFN>(<datetime_field>)  
      AS RANGE RIGHT FOR VALUES (
         '20130201', '20130301', '20130401',
         '20130501', '20130601', '20130701', '20130801',
         '20130901', '20131001', '20131101', '20131201' )
```

### 2. Create a partition scheme

[Create a partition scheme](/sql/t-sql/statements/create-partition-scheme-transact-sql). This scheme maps each partition range in the partition function to a physical filegroup, for example:

```sql
      CREATE PARTITION SCHEME <DatetimeFieldPScheme> AS  
        PARTITION <DatetimeFieldPFN> TO (
        <filegroup_1>, <filegroup_2>, <filegroup_3>, <filegroup_4>,
        <filegroup_5>, <filegroup_6>, <filegroup_7>, <filegroup_8>,
        <filegroup_9>, <filegroup_10>, <filegroup_11>, <filegroup_12> )
```

To verify the ranges in effect in each partition according to the function/scheme, run the following query:

```sql
   SELECT psch.name as PartitionScheme,
            prng.value AS PartitionValue,
            prng.boundary_id AS BoundaryID
   FROM sys.partition_functions AS pfun
   INNER JOIN sys.partition_schemes psch ON pfun.function_id = psch.function_id
   INNER JOIN sys.partition_range_values prng ON prng.function_id=pfun.function_id
   WHERE pfun.name = <DatetimeFieldPFN>
```

### 3. Create a partition table

[Create partitioned table](/sql/t-sql/statements/create-table-transact-sql)(s) according to your data schema, and specify the partition scheme and constraint field used to partition the table, for example:

```sql
   CREATE TABLE <table_name> ( [include schema definition here] )
        ON <TablePScheme>(<partition_field>)
```

For more information, see [Create Partitioned Tables and Indexes](/sql/relational-databases/partitions/create-partitioned-tables-and-indexes).

## Bulk import the data for each individual partition table

* You may use BCP, BULK INSERT, or other methods such as [Microsoft Data Migration](https://techcommunity.microsoft.com/t5/microsoft-data-migration/bg-p/MicrosoftDataMigration). The example provided uses the BCP method.

* [Alter the database](/sql/t-sql/statements/alter-database-transact-sql-set-options) to change transaction logging scheme to BULK_LOGGED to minimize overhead of logging, for example:

   ```sql
      ALTER DATABASE <database_name> SET RECOVERY BULK_LOGGED
   ```

* To expedite data loading, launch the bulk import operations in parallel. For tips on expediting bulk importing of big data into SQL Server databases, see [Load 1 TB in less than 1 hour](/archive/blogs/sqlcat/load-1tb-in-less-than-1-hour).

The following PowerShell script is an example of parallel data loading using BCP.

```powershell
# Set database name, input data directory, and output log directory
# This example loads comma-separated input data files
# The example assumes the partitioned data files are named as <base_file_name>_<partition_number>.csv
# Assumes the input data files include a header line. Loading starts at line number 2.

$dbname = "<database_name>"
$indir  = "<path_to_data_files>"
$logdir = "<path_to_log_directory>"

# Select authentication mode
$sqlauth = 0

# For SQL authentication, set the server and user credentials
$sqlusr = "<user@server>"
$server = "<tcp:serverdns>"
$pass   = "<password>"

# Set number of partitions per table - Should match the number of input data files per table
$numofparts = <number_of_partitions>

# Set table name to be loaded, basename of input data files, input format file, and number of partitions
$tbname = "<table_name>"
$basename = "<base_input_data_filename_no_extension>"
$fmtfile = "<full_path_to_format_file>"

# Create log directory if it does not exist
New-Item -ErrorAction Ignore -ItemType directory -Path $logdir

# BCP example using Windows authentication
$ScriptBlock1 = {
   param($dbname, $tbname, $basename, $fmtfile, $indir, $logdir, $num)
   bcp ($dbname + ".." + $tbname) in ($indir + "\" + $basename + "_" + $num + ".csv") -o ($logdir + "\" + $tbname + "_" + $num + ".txt") -h "TABLOCK" -F 2 -C "RAW" -f ($fmtfile) -T -b 2500 -t "," -r \n
}

# BCP example using SQL authentication
$ScriptBlock2 = {
   param($dbname, $tbname, $basename, $fmtfile, $indir, $logdir, $num, $sqlusr, $server, $pass)
   bcp ($dbname + ".." + $tbname) in ($indir + "\" + $basename + "_" + $num + ".csv") -o ($logdir + "\" + $tbname + "_" + $num + ".txt") -h "TABLOCK" -F 2 -C "RAW" -f ($fmtfile) -U $sqlusr -S $server -P $pass -b 2500 -t "," -r \n
}

# Background processing of all partitions
for ($i=1; $i -le $numofparts; $i++)
{
   Write-Output "Submit loading trip and fare partitions # $i"
   if ($sqlauth -eq 0) {
      # Use Windows authentication
      Start-Job -ScriptBlock $ScriptBlock1 -Arg ($dbname, $tbname, $basename, $fmtfile, $indir, $logdir, $i)
   } 
   else {
      # Use SQL authentication
      Start-Job -ScriptBlock $ScriptBlock2 -Arg ($dbname, $tbname, $basename, $fmtfile, $indir, $logdir, $i, $sqlusr, $server, $pass)
   }
}

Get-Job

# Optional - Wait till all jobs complete and report date and time
date
While (Get-Job -State "Running") { Start-Sleep 10 }
date
```

## Create indexes to optimize joins and query performance

* If you extract data for modeling from multiple tables, create indexes on the join keys to improve the join performance.
* [Create indexes](/sql/t-sql/statements/create-index-transact-sql) (clustered or non-clustered) targeting the same filegroup for each partition, for example:

  ```sql
  CREATE CLUSTERED INDEX <table_idx> ON <table_name>( [include index columns here] )
      ON <TablePScheme>(<partition)field>)

  --  or,

  CREATE INDEX <table_idx> ON <table_name>( [include index columns here] )
      ON <TablePScheme>(<partition)field>)
  ```

  > [!NOTE]
  > You may choose to create the indexes before bulk importing the data. Index creation before bulk importing slows down the data loading.
  >
  >

## Advanced Analytics Process and Technology in Action Example

For an end-to-end walkthrough example using the Team Data Science Process with a public dataset, see [Team Data Science Process in Action: using SQL Server](/azure/architecture/data-science-process/overview).