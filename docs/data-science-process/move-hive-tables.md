---
title: Create Hive tables and load data from Blob storage
description: Use Hive queries to create Hive tables and load data from Azure Blob Storage. Partition Hive tables and use the Optimized Row Columnar (ORC) formatting to improve query performance.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: article
ms.date: 12/16/2021
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Create Hive tables and load data from Azure Blob Storage

This article presents generic Hive queries that create Hive tables and load data from Azure Blob Storage. Some guidance is also provided on partitioning Hive tables and on using the Optimized Row Columnar (ORC) formatting to improve query performance.

## Prerequisites
This article assumes that you have:

* Created an Azure Storage account. If you need instructions, see [About Azure Storage accounts](/azure/storage/common/storage-introduction).
* Provisioned a customized Hadoop cluster with the HDInsight service.  If you need instructions, see [Setup Clusters in HDInsight](/azure/hdinsight/hdinsight-hadoop-provision-linux-clusters).
* Enabled remote access to the cluster, logged in, and opened the Hadoop Command-Line console. If you need instructions, see [Manage Apache Hadoop clusters](/azure/hdinsight/hdinsight-administer-use-portal-linux).

## Upload data to Azure Blob Storage
If you created an Azure virtual machine by following the instructions provided in [Set up an Azure virtual machine for advanced analytics](/azure/machine-learning/data-science-virtual-machine/overview), this script file should have been downloaded to the *C:\\Users\\\<user name\>\\Documents\\Data Science Scripts* directory on the virtual machine. These Hive queries only require that you provide a data schema and Azure Blob Storage configuration in the appropriate fields to be ready for submission.

We assume that the data for Hive tables is in an **uncompressed** tabular format, and that the data has been uploaded to the default (or to an additional) container of the storage account used by the Hadoop cluster.

If you want to practice on the **NYC Taxi Trip Data**, you need to:

* **download** the 24 NYC Taxi Trip Data files (12 Trip files and 12 Fare files) -- either available through [Azure Open Datasets](/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets) or from the source [TLC Trip Record Data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page),
* **unzip** all files into .csv files, and then
* **upload** them to the default (or appropriate container) of the Azure Storage account; options for such an account appear at [Use Azure Storage with Azure HDInsight clusters](/azure/hdinsight/hdinsight-hadoop-use-blob-storage) topic. The process to upload the .csv files to the default container on the storage account can be found on this [page](/azure/architecture/data-science-process/overview#upload).

## <a name="submit"></a>How to submit Hive queries
Hive queries can be submitted by using:

* [Submit Hive queries through Hadoop Command Line in headnode of Hadoop cluster](#headnode)
* [Submit Hive queries with the Hive Editor](#hive-editor)
* [Submit Hive queries with Azure PowerShell Commands](#ps)

Hive queries are SQL-like. If you are familiar with SQL, you may find the [Hive for SQL Users Cheat Sheet](https://hortonworks.com/wp-content/uploads/2013/05/hql_cheat_sheet.pdf) useful.

When submitting a Hive query, you can also control the destination of the output from Hive queries, whether it be on the screen or to a local file on the head node or to an Azure blob.

### <a name="headnode"></a>Submit Hive queries through Hadoop Command Line in headnode of Hadoop cluster
If the Hive query is complex, submitting it directly in the head node of the Hadoop cluster typically leads to faster turn around than submitting it with a Hive Editor or Azure PowerShell scripts.

Log in to the head node of the Hadoop cluster, open the Hadoop Command Line on the desktop of the head node, and enter command `cd %hive_home%\bin`.

You have three ways to submit Hive queries in the Hadoop Command Line:

* directly
* using `.hql` files
* with the Hive command console

#### Submit Hive queries directly in Hadoop Command Line.
You can run command like `hive -e "<your hive query>;` to submit simple Hive queries directly in Hadoop Command Line. Here is an example, where the red box outlines the command that submits the Hive query, and the green box outlines the output from the Hive query.

![Command to submit Hive query with output from Hive query](./media/move-hive-tables/run-hive-queries-1.png)

#### Submit Hive queries in `.hql` files

When the Hive query is more complicated and has multiple lines, editing queries in command line or Hive command console is not practical. An alternative is to use a text editor in the head node of the Hadoop cluster to save the Hive queries in an `.hql` file in a local directory of the head node. Then the Hive query in the `.hql` file can be submitted by using the `-f` argument as follows:

```console
hive -f "<path to the .hql file>"
```

![Hive query in an `.hql` file](./media/move-hive-tables/run-hive-queries-3.png)

**Suppress progress status screen print of Hive queries**

By default, after Hive query is submitted in Hadoop Command Line, the progress of the Map/Reduce job is printed out on screen. To suppress the screen print of the Map/Reduce job progress, you can use an argument `-S` ("S" in upper case) in the command line as follows:

```console
hive -S -f "<path to the .hql file>"
hive -S -e "<Hive queries>"
```

#### Submit Hive queries in Hive command console.

You can also first enter the Hive command console by running command `hive` in Hadoop Command Line, and then submit Hive queries in Hive command console. Here is an example. In this example, the two red boxes highlight the commands used to enter the Hive command console, and the Hive query submitted in Hive command console, respectively. The green box highlights the output from the Hive query.

![Open Hive command console and enter command, view Hive query output](./media/move-hive-tables/run-hive-queries-2.png)

The previous examples directly output the Hive query results on screen. You can also write the output to a local file on the head node, or to an Azure blob. Then, you can use other tools to further analyze the output of Hive queries.

**Output Hive query results to a local file.** To output Hive query results to a local directory on the head node, you have to submit the Hive query in the Hadoop Command Line as follows:

```console
hive -e "<hive query>" > <local path in the head node>
```

In the following example, the output of Hive query is written into a file `hivequeryoutput.txt` in directory `C:\apps\temp`.

![Screenshot shows the output of the Hive query in a Hadoop Command Line window.](./media/move-hive-tables/output-hive-results-1.png)

**Output Hive query results to an Azure blob**

You can also output the Hive query results to an Azure blob, within the default container of the Hadoop cluster. The Hive query for this is as follows:

```console
insert overwrite directory wasb:///<directory within the default container> <select clause from ...>
```

In the following example, the output of Hive query is written to a blob directory `queryoutputdir` within the default container of the Hadoop cluster. Here, you only need to provide the directory name, without the blob name. An error is thrown if you provide both directory and blob names, such as `wasb:///queryoutputdir/queryoutput.txt`.

![Screenshot shows the previous command in the Hadoop Command Line window.](./media/move-hive-tables/output-hive-results-2.png)

If you open the default container of the Hadoop cluster using Azure Storage Explorer, you can see the output of the Hive query as shown in the following figure. You can apply the filter (highlighted by red box) to only retrieve the blob with specified letters in names.

![Azure Storage Explorer showing output of the Hive query](./media/move-hive-tables/output-hive-results-3.png)

### <a name="hive-editor"></a>Submit Hive queries with the Hive Editor
You can also use the Query Console (Hive Editor) by entering a URL of the form *https:\//\<Hadoop cluster name>.azurehdinsight.net/Home/HiveEditor* into a web browser. You must be logged in the see this console and so you need your Hadoop cluster credentials here.

### <a name="ps"></a>Submit Hive queries with Azure PowerShell Commands
You can also use PowerShell to submit Hive queries. For instructions, see [Submit Hive jobs using PowerShell](/azure/hdinsight/hadoop/apache-hadoop-use-hive-powershell).

## <a name="create-tables"></a>Create Hive database and tables
The Hive queries are shared in the [GitHub repository](https://github.com/Azure/Azure-MachineLearning-DataScience/tree/master/Misc/DataScienceProcess/DataScienceScripts/sample_hive_create_db_tbls_load_data_generic.hql) and can be downloaded from there.

Here is the Hive query that creates a Hive table.

```hiveql
create database if not exists <database name>;
CREATE EXTERNAL TABLE if not exists <database name>.<table name>
(
    field1 string,
    field2 int,
    field3 float,
    field4 double,
    ...,
    fieldN string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '<field separator>' lines terminated by '<line separator>'
STORED AS TEXTFILE LOCATION '<storage location>' TBLPROPERTIES("skip.header.line.count"="1");
```

Here are the descriptions of the fields that you need to plug in and other configurations:

* **\<database name\>**: the name of the database that you want to create. If you just want to use the default database, the query "*create database...*" can be omitted.
* **\<table name\>**: the name of the table that you want to create within the specified database. If you want to use the default database, the table can be directly referred by *\<table name\>* without \<database name\>.
* **\<field separator\>**: the separator that delimits fields in the data file to be uploaded to the Hive table.
* **\<line separator\>**: the separator that delimits lines in the data file.
* **\<storage location\>**: the Azure Storage location to save the data of Hive tables. If you do not specify *LOCATION \<storage location\>*, the database and the tables are stored in *hive/warehouse/* directory in the default container of the Hive cluster by default. If you want to specify the storage location, the storage location has to be within the default container for the database and tables. This location has to be referred as location relative to the default container of the cluster in the format of *'wasb:///\<directory 1>/'* or *'wasb:///\<directory 1>/\<directory 2>/'*, etc. After the query is executed, the relative directories are created within the default container.
* **TBLPROPERTIES("skip.header.line.count"="1")**: If the data file has a header line, you have to add this property **at the end** of the *create table* query. Otherwise, the header line is loaded as a record to the table. If the data file does not have a header line, this configuration can be omitted in the query.

## <a name="load-data"></a>Load data to Hive tables
Here is the Hive query that loads data into a Hive table.

```hiveql
LOAD DATA INPATH '<path to blob data>' INTO TABLE <database name>.<table name>;
```

* **\<path to blob data\>**: If the blob file to be uploaded to the Hive table is in the default container of the HDInsight Hadoop cluster, the *\<path to blob data\>* should be in the format *'wasb://\<directory in this container>/\<blob file name>'*. The blob file can also be in an additional container of the HDInsight Hadoop cluster. In this case, *\<path to blob data\>* should be in the format *'wasb://\<container name>@\<storage account name>.blob.core.windows.net/\<blob file name>'*.

  > [!NOTE]
  > The blob data to be uploaded to Hive table has to be in the default or additional container of the storage account for the Hadoop cluster. Otherwise, the *LOAD DATA* query fails complaining that it cannot access the data.
  >
  >

## <a name="partition-orc"></a>Advanced topics: partitioned table and store Hive data in ORC format
If the data is large, partitioning the table is beneficial for queries that only need to scan a few partitions of the table. For instance, it is reasonable to partition the log data of a web site by dates.

In addition to partitioning Hive tables, it is also beneficial to store the Hive data in the Optimized Row Columnar (ORC) format. For more information on ORC formatting, see <a href="https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC#LanguageManualORC-ORCFiles" target="_blank">Using ORC files improves performance when Hive is reading, writing, and processing data</a>.

### Partitioned table
Here is the Hive query that creates a partitioned table and loads data into it.

```hiveql
CREATE EXTERNAL TABLE IF NOT EXISTS <database name>.<table name>
(field1 string,
...
fieldN string
)
PARTITIONED BY (<partitionfieldname> vartype) ROW FORMAT DELIMITED FIELDS TERMINATED BY '<field separator>'
    lines terminated by '<line separator>' TBLPROPERTIES("skip.header.line.count"="1");
LOAD DATA INPATH '<path to the source file>' INTO TABLE <database name>.<partitioned table name>
    PARTITION (<partitionfieldname>=<partitionfieldvalue>);
```

When querying partitioned tables, it is recommended to add the partition condition in the **beginning** of the `where` clause, which improves the search efficiency.

```hiveql
select
    field1, field2, ..., fieldN
from <database name>.<partitioned table name>
where <partitionfieldname>=<partitionfieldvalue> and ...;
```

### <a name="orc"></a>Store Hive data in ORC format
You cannot directly load data from blob storage into Hive tables that is stored in the ORC format. Here are the steps that the you need to take to load data from Azure blobs to Hive tables stored in ORC format.

Create an external table **STORED AS TEXTFILE** and load data from blob storage to the table.

```hiveql
CREATE EXTERNAL TABLE IF NOT EXISTS <database name>.<external textfile table name>
(
    field1 string,
    field2 int,
    ...
    fieldN date
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '<field separator>'
    lines terminated by '<line separator>' STORED AS TEXTFILE
    LOCATION 'wasb:///<directory in Azure blob>' TBLPROPERTIES("skip.header.line.count"="1");

LOAD DATA INPATH '<path to the source file>' INTO TABLE <database name>.<table name>;
```

Create an internal table with the same schema as the external table in step 1, with the same field delimiter, and store the Hive data in the ORC format.

```hiveql
CREATE TABLE IF NOT EXISTS <database name>.<ORC table name>
(
    field1 string,
    field2 int,
    ...
    fieldN date
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '<field separator>' STORED AS ORC;
```

Select data from the external table in step 1 and insert into the ORC table

```hiveql
INSERT OVERWRITE TABLE <database name>.<ORC table name>
    SELECT * FROM <database name>.<external textfile table name>;
```

> [!NOTE]
> If the TEXTFILE table *\<database name\>.\<external textfile table name\>* has partitions, in STEP 3, the `SELECT * FROM <database name>.<external textfile table name>` command selects the partition variable as a field in the returned data set. Inserting it into the *\<database name\>.\<ORC table name\>* fails since *\<database name\>.\<ORC table name\>* does not have the partition variable as a field in the table schema. In this case, you need to specifically select the fields to be inserted to *\<database name\>.\<ORC table name\>* as follows:
>
>

```hiveql
INSERT OVERWRITE TABLE <database name>.<ORC table name> PARTITION (<partition variable>=<partition value>)
    SELECT field1, field2, ..., fieldN
    FROM <database name>.<external textfile table name>
    WHERE <partition variable>=<partition value>;
```

It is safe to drop the *\<external text file table name\>* when using the following query after all data has been inserted into *\<database name\>.\<ORC table name\>*:

```hiveql
    DROP TABLE IF EXISTS <database name>.<external textfile table name>;
```

After following this procedure, you should have a table with data in the ORC format ready to use.