---
title: Build and deploy a model using Azure Synapse Analytics
description: Build and deploy a machine learning model using Azure Synapse Analytics with a publicly available dataset.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: article
ms.date: 01/22/2022
ms.author: tdsp
ms.custom:
  - devx-track-python
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Build and deploy a model using Azure Synapse Analytics

In this tutorial, we walk you through building and deploying a machine learning model using Azure Synapse Analytics for a publicly available dataset -- the [NYC Taxi Trips](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page) dataset. The binary classification model constructed predicts whether or not a tip is paid for a trip.  Models include multiclass classification (whether or not there is a tip) and regression (the distribution for the tip amounts paid).

The procedure follows the [Team Data Science Process (TDSP)](/azure/machine-learning/team-data-science-process/) workflow. We show how to set up a data science environment, how to load the data into Azure Synapse Analytics, and how to use either Azure Synapse Analytics or a Jupyter Notebook to explore the data and engineer features to model. We then show how to build and deploy a model with Azure Machine Learning.

## <a name="dataset"></a>The NYC Taxi Trips dataset

The NYC Taxi Trip data consists of about 20 GB of compressed CSV files (~48 GB uncompressed), recording more than 173 million individual trips and the fares paid for each trip. Each trip record includes the pickup and dropoff locations and times, anonymized hack (driver's) license number, and the medallion (taxi's unique ID) number. The data covers all trips in the year 2013 and is provided in the following two datasets for each month:

1. The **trip_data.csv** file contains trip details, such as number of passengers, pickup and dropoff points, trip duration, and trip length. Here are a few sample records:

`medallion,hack_license,vendor_id,rate_code,store_and_fwd_flag,pickup_datetime,dropoff_datetime,passenger_count,trip_time_in_secs,trip_distance,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude`

`89D227B655E5C82AECF13C3F540D4CF4,BA96DE419E711691B9445D6A6307C170,CMT,1,N,2013-01-01 15:11:48,2013-01-01 15:18:10,4,382,1.00,-73.978165,40.757977,-73.989838,40.751171`

`0BD7C8F5BA12B88E0B67BED28BEA73D8,9FD8F69F0804BDB5549F40E9DA1BE472,CMT,1,N,2013-01-06 00:18:35,2013-01-06 00:22:54,1,259,1.50,-74.006683,40.731781,-73.994499,40.75066`

`0BD7C8F5BA12B88E0B67BED28BEA73D8,9FD8F69F0804BDB5549F40E9DA1BE472,CMT,1,N,2013-01-05 18:49:41,2013-01-05 18:54:23,1,282,1.10,-74.004707,40.73777,-74.009834,40.726002`

`DFD2202EE08F7A8DC9A57B02ACB81FE2,51EE87E3205C985EF8431D850C786310,CMT,1,N,2013-01-07 23:54:15,2013-01-07 23:58:20,2,244,.70,-73.974602,40.759945,-73.984734,40.759388`

`DFD2202EE08F7A8DC9A57B02ACB81FE2,51EE87E3205C985EF8431D850C786310,CMT,1,N,2013-01-07 23:25:03,2013-01-07 23:34:24,1,560,2.10,-73.97625,40.748528,-74.002586,40.747868`

2. The **trip_fare.csv** file contains details of the fare paid for each trip, such as payment type, fare amount, surcharge and taxes, tips and tolls, and the total amount paid. Here are a few sample records:

`medallion, hack_license, vendor_id, pickup_datetime, payment_type, fare_amount, surcharge, mta_tax, tip_amount, tolls_amount, total_amount`

`89D227B655E5C82AECF13C3F540D4CF4,BA96DE419E711691B9445D6A6307C170,CMT,2013-01-01 15:11:48,CSH,6.5,0,0.5,0,0,7`

`0BD7C8F5BA12B88E0B67BED28BEA73D8,9FD8F69F0804BDB5549F40E9DA1BE472,CMT,2013-01-06 00:18:35,CSH,6,0.5,0.5,0,0,7`

`0BD7C8F5BA12B88E0B67BED28BEA73D8,9FD8F69F0804BDB5549F40E9DA1BE472,CMT,2013-01-05 18:49:41,CSH,5.5,1,0.5,0,0,7`

`DFD2202EE08F7A8DC9A57B02ACB81FE2,51EE87E3205C985EF8431D850C786310,CMT,2013-01-07 23:54:15,CSH,5,0.5,0.5,0,0,6`

`DFD2202EE08F7A8DC9A57B02ACB81FE2,51EE87E3205C985EF8431D850C786310,CMT,2013-01-07 23:25:03,CSH,9.5,0.5,0.5,0,0,10.5`

The **unique key** used to join trip\_data and trip\_fare is composed of the following three fields:

* medallion,
* hack\_license and
* pickup\_datetime.

## <a name="mltasks"></a>Address three types of prediction tasks

We formulate three prediction problems based on the *tip\_amount* to illustrate three kinds of modeling tasks:

1. **Binary classification**: To predict whether or not a tip was paid for a trip, that is, a *tip\_amount* that is greater than $0 is a positive example, while a *tip\_amount* of $0 is a negative example.
2. **Multiclass classification**: To predict the range of tip paid for the trip. We divide the *tip\_amount* into five bins or classes:

`Class 0 : tip_amount = $0`

`Class 1 : tip_amount > $0 and tip_amount <= $5`

`Class 2 : tip_amount > $5 and tip_amount <= $10`

`Class 3 : tip_amount > $10 and tip_amount <= $20`

`Class 4 : tip_amount > $20`

3. **Regression task**: To predict the amount of tip paid for a trip.

## <a name="setup"></a>Set up the Azure data science environment for advanced analytics

To set up your Azure Data Science environment, follow these steps.

**Create your own Azure blob storage account**

* When you provision your own Azure blob storage, choose a geo-location for your Azure blob storage in or as close as possible to **South Central US**, which is where the NYC Taxi data is stored. The data will be copied using AzCopy from the public blob storage container to a container in your own storage account. The closer your Azure blob storage is to South Central US, the faster this task (Step 4) will be completed.
* To create your own Azure Storage account, follow the steps outlined at [About Azure Storage accounts](/azure/storage/common/storage-account-create). Be sure to make notes on the values for following storage account credentials as they will be needed later in this walkthrough.

  * **Storage Account Name**
  * **Storage Account Key**
  * **Container Name** (which you want the data to be stored in the Azure blob storage)

**Provision your Azure Synapse Analytics instance.** Follow the documentation at [Create and query an Azure Synapse Analytics in the Azure portal](/azure/synapse-analytics/sql-data-warehouse/create-data-warehouse-portal) to provision a Azure Synapse Analytics instance. Make sure that you make notations on the following Azure Synapse Analytics credentials that will be used in later steps.

* **Server Name**: \<server Name>.database.windows.net
* **SQLDW (Database) Name**
* **Username**
* **Password**

**Install Visual Studio and SQL Server Data Tools.** For instructions, see [Getting started with Visual Studio 2019 for Azure Synapse Analytics](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-install-visual-studio).

**Connect to your Azure Synapse Analytics with Visual Studio.** For instructions, see steps 1 & 2 in [Connect to SQL Analytics in Azure Synapse Analytics](/azure/synapse-analytics/sql/connect-overview).

> [!NOTE]
> Run the following SQL query on the database you created in your Azure Synapse Analytics (instead of the query provided in step 3 of the connect topic,) to **create a master key**.
>
>

```sql
BEGIN TRY
       --Try to create the master key
    CREATE MASTER KEY
END TRY
BEGIN CATCH
       --If the master key exists, do nothing
END CATCH;
```

**Create an Azure Machine Learning workspace under your Azure subscription.** For instructions, see [Create an Azure Machine Learning workspace](/azure/machine-learning/classic/create-workspace).

## <a name="getdata"></a>Load the data into Azure Synapse Analytics

Open a Windows PowerShell command console. Run the following PowerShell commands to download the example SQL script files that we share with you on GitHub to a local directory that you specify with the parameter *-DestDir*. You can change the value of parameter *-DestDir* to any local directory. If *-DestDir* does not exist, it will be created by the PowerShell script.

> [!NOTE]
> You might need to **Run as Administrator** when executing the following PowerShell script if your *DestDir* directory needs Administrator privilege to create or to write to it.
>
>

```azurepowershell
$source = "https://raw.githubusercontent.com/Azure/Azure-MachineLearning-DataScience/master/Misc/SQLDW/Download_Scripts_SQLDW_Walkthrough.ps1"
$ps1_dest = "$pwd\Download_Scripts_SQLDW_Walkthrough.ps1"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($source, $ps1_dest)
.\Download_Scripts_SQLDW_Walkthrough.ps1 –DestDir 'C:\tempSQLDW'
```

After successful execution, your current working directory changes to *-DestDir*. You should be able to see screen like below:

![Current working directory changes][19]

In your *-DestDir*, execute the following PowerShell script in administrator mode:

```azurepowershell
./SQLDW_Data_Import.ps1
```

When the PowerShell script runs for the first time, you will be asked to input the information from your Azure Synapse Analytics and your Azure blob storage account. When this PowerShell script completes running for the first time, the credentials you input will have been written to a configuration file SQLDW.conf in the present working directory. The future run of this PowerShell script file has the option to read all needed parameters from this configuration file. If you need to change some parameters, you can choose to input the parameters on the screen upon prompt by deleting this configuration file and inputting the parameters values as prompted or to change the parameter values by editing the SQLDW.conf file in your *-DestDir* directory.

> [!NOTE]
> In order to avoid schema name conflicts with those that already exist in your Azure Azure Synapse Analytics, when reading parameters directly from the SQLDW.conf file, a 3-digit random number is added to the schema name from the SQLDW.conf file as the default schema name for each run. The PowerShell script may prompt you for a schema name: the name may be specified at user discretion.
>
>

This **PowerShell script** file completes the following tasks:

* **Downloads and installs AzCopy**, if AzCopy is not already installed

  ```azurepowershell
  $AzCopy_path = SearchAzCopy
  if ($AzCopy_path -eq $null){
         Write-Host "AzCopy.exe is not found in C:\Program Files*. Now, start installing AzCopy..." -ForegroundColor "Yellow"
      InstallAzCopy
      $AzCopy_path = SearchAzCopy
  }
      $env_path = $env:Path
      for ($i=0; $i -lt $AzCopy_path.count; $i++){
          if ($AzCopy_path.count -eq 1){
              $AzCopy_path_i = $AzCopy_path
          } else {
              $AzCopy_path_i = $AzCopy_path[$i]
          }
          if ($env_path -notlike '*' +$AzCopy_path_i+'*'){
              Write-Host $AzCopy_path_i 'not in system path, add it...'
              [Environment]::SetEnvironmentVariable("Path", "$AzCopy_path_i;$env_path", "Machine")
              $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
              $env_path = $env:Path
          }
  ```

* **Copies data to your private blob storage account** from the public blob with AzCopy

  ```azurepowershell
  Write-Host "AzCopy is copying data from public blob to yo storage account. It may take a while..." -ForegroundColor "Yellow"
  $start_time = Get-Date
  AzCopy.exe /Source:$Source /Dest:$DestURL /DestKey:$StorageAccountKey /S
  $end_time = Get-Date
  $time_span = $end_time - $start_time
  $total_seconds = [math]::Round($time_span.TotalSeconds,2)
  Write-Host "AzCopy finished copying data. Please check your storage account to verify." -ForegroundColor "Yellow"
  Write-Host "This step (copying data from public blob to your storage account) takes $total_seconds seconds." -ForegroundColor "Green"
  ```

* **Loads data using Polybase (by executing LoadDataToSQLDW.sql) to your Azure Synapse Analytics** from your private blob storage account with the following commands.

  * Create a schema

    ```sql
    EXEC (''CREATE SCHEMA {schemaname};'');
    ```

  * Create a database scoped credential

    ```sql
    CREATE DATABASE SCOPED CREDENTIAL {KeyAlias}
    WITH IDENTITY = ''asbkey'' ,
    Secret = ''{StorageAccountKey}''
    ```

  * Create an external data source for an Azure Storage blob

    ```sql
    CREATE EXTERNAL DATA SOURCE {nyctaxi_trip_storage}
    WITH
    (
        TYPE = HADOOP,
        LOCATION =''wasbs://{ContainerName}@{StorageAccountName}.blob.core.windows.net'',
        CREDENTIAL = {KeyAlias}
    )
    ;

    CREATE EXTERNAL DATA SOURCE {nyctaxi_fare_storage}
    WITH
    (
        TYPE = HADOOP,
        LOCATION =''wasbs://{ContainerName}@{StorageAccountName}.blob.core.windows.net'',
        CREDENTIAL = {KeyAlias}
    )
    ;
    ```

  * Create an external file format for a csv file. Data is uncompressed and fields are separated with the pipe character.

    ```sql
    CREATE EXTERNAL FILE FORMAT {csv_file_format}
    WITH
    (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS
        (
            FIELD_TERMINATOR ='','',
            USE_TYPE_DEFAULT = TRUE
        )
    )
    ;
    ```

  * Create external fare and trip tables for NYC taxi dataset in Azure blob storage.

    ```sql
    CREATE EXTERNAL TABLE {external_nyctaxi_fare}
    (
        medallion varchar(50) not null,
        hack_license varchar(50) not null,
        vendor_id char(3),
        pickup_datetime datetime not null,
        payment_type char(3),
        fare_amount float,
        surcharge float,
        mta_tax float,
        tip_amount float,
        tolls_amount float,
        total_amount float
    )
    with (
        LOCATION    = ''/nyctaxifare/'',
        DATA_SOURCE = {nyctaxi_fare_storage},
        FILE_FORMAT = {csv_file_format},
        REJECT_TYPE = VALUE,
        REJECT_VALUE = 12
    )

      CREATE EXTERNAL TABLE {external_nyctaxi_trip}
      (
             medallion varchar(50) not null,
             hack_license varchar(50)  not null,
             vendor_id char(3),
             rate_code char(3),
             store_and_fwd_flag char(3),
             pickup_datetime datetime  not null,
             dropoff_datetime datetime,
             passenger_count int,
             trip_time_in_secs bigint,
             trip_distance float,
             pickup_longitude varchar(30),
             pickup_latitude varchar(30),
             dropoff_longitude varchar(30),
             dropoff_latitude varchar(30)
      )
      with (
          LOCATION    = ''/nyctaxitrip/'',
          DATA_SOURCE = {nyctaxi_trip_storage},
          FILE_FORMAT = {csv_file_format},
          REJECT_TYPE = VALUE,
          REJECT_VALUE = 12
      )
    ```

    - Load data from external tables in Azure blob storage to Azure Synapse Analytics

      ```sql
      CREATE TABLE {schemaname}.{nyctaxi_fare}
      WITH
      (
          CLUSTERED COLUMNSTORE INDEX,
          DISTRIBUTION = HASH(medallion)
      )
      AS
      SELECT *
      FROM   {external_nyctaxi_fare}
      ;

      CREATE TABLE {schemaname}.{nyctaxi_trip}
      WITH
      (
          CLUSTERED COLUMNSTORE INDEX,
          DISTRIBUTION = HASH(medallion)
      )
      AS
      SELECT *
      FROM   {external_nyctaxi_trip}
      ;
      ```

    - Create a sample data table (NYCTaxi_Sample) and insert data to it from selecting SQL queries on the trip and fare tables. (Some steps of this walkthrough need to use this sample table.)

      ```sql
      CREATE TABLE {schemaname}.{nyctaxi_sample}
      WITH
      (
          CLUSTERED COLUMNSTORE INDEX,
          DISTRIBUTION = HASH(medallion)
      )
      AS
      (
          SELECT t.*, f.payment_type, f.fare_amount, f.surcharge, f.mta_tax, f.tolls_amount, f.total_amount, f.tip_amount,
          tipped = CASE WHEN (tip_amount > 0) THEN 1 ELSE 0 END,
          tip_class = CASE
                  WHEN (tip_amount = 0) THEN 0
                  WHEN (tip_amount > 0 AND tip_amount <= 5) THEN 1
                  WHEN (tip_amount > 5 AND tip_amount <= 10) THEN 2
                  WHEN (tip_amount > 10 AND tip_amount <= 20) THEN 3
                  ELSE 4
              END
          FROM {schemaname}.{nyctaxi_trip} t, {schemaname}.{nyctaxi_fare} f
          WHERE datepart("mi",t.pickup_datetime) = 1
          AND t.medallion = f.medallion
          AND   t.hack_license = f.hack_license
          AND   t.pickup_datetime = f.pickup_datetime
          AND   pickup_longitude <> ''0''
          AND   dropoff_longitude <> ''0''
      )
      ;
      ```

The geographic location of your storage accounts affects load times.

> [!NOTE]
> Depending on the geographical location of your private blob storage account, the process of copying data from a public blob to your private storage account can take about 15 minutes, or even longer,and the process of loading data from your storage account to your Azure Azure Synapse Analytics could take 20 minutes or longer.
>
>

You will have to decide what do if you have duplicate source and destination files.

> [!NOTE]
> If the .csv files to be copied from the public blob storage to your private blob storage account already exist in your private blob storage account, AzCopy will ask you whether you want to overwrite them. If you do not want to overwrite them, input **n** when prompted. If you want to overwrite **all** of them, input **a** when prompted. You can also input **y** to overwrite .csv files individually.
>
>

![Output from AzCopy][21]

You can use your own data. If your data is in your on-premises machine in your real life application, you can still use AzCopy to upload on-premises data to your private Azure blob storage. You only need to change the **Source** location, `$Source = "http://getgoing.blob.core.windows.net/public/nyctaxidataset"`, in the AzCopy command of the PowerShell script file to the local directory that contains your data.

> [!TIP]
> If your data is already in your private Azure blob storage in your real life application, you can skip the AzCopy step in the PowerShell script and directly upload the data to Azure Azure Synapse Analytics. This will require additional edits of the script to tailor it to the format of your data.
>
>

This PowerShell script also plugs in the Azure Synapse Analytics information into the data exploration example files SQLDW_Explorations.sql, SQLDW_Explorations.ipynb, and SQLDW_Explorations_Scripts.py so that these three files are ready to be tried out instantly after the PowerShell script completes.

After a successful execution, you will see screen like below:

![Output of a successful script execution][20]

## <a name="dbexplore"></a>Data exploration and feature engineering in Azure Synapse Analytics

In this section, we perform data exploration and feature generation by running SQL queries against Azure Synapse Analytics directly using **Visual Studio Data Tools**. All SQL queries used in this section can be found in the sample script named *SQLDW_Explorations.sql*. This file has already been downloaded to your local directory by the PowerShell script. You can also retrieve it from [GitHub](https://raw.githubusercontent.com/Azure/Azure-MachineLearning-DataScience/master/Misc/SQLDW/SQLDW_Explorations.sql). But the file in GitHub does not have the Azure Synapse Analytics information plugged in.

Connect to your Azure Synapse Analytics using Visual Studio with the Azure Synapse Analytics login name and password and open up the **SQL Object Explorer** to confirm the database and tables have been imported. Retrieve the *SQLDW_Explorations.sql* file.

> [!NOTE]
> To open a Parallel Data Warehouse (PDW) query editor, use the **New Query** command while your PDW is selected in the **SQL Object Explorer**. The standard SQL query editor is not supported by PDW.
>
>

Here are the types of data exploration and feature generation tasks performed in this section:

* Explore data distributions of a few fields in varying time windows.
* Investigate data quality of the longitude and latitude fields.
* Generate binary and multiclass classification labels based on the **tip\_amount**.
* Generate features and compute/compare trip distances.
* Join the two tables and extract a random sample that will be used to build models.

### Data import verification

These queries provide a quick verification of the number of rows and columns in the tables populated earlier using Polybase's parallel bulk import,

-- Report number of rows in table <nyctaxi_trip> without table scan

   ```sql
   SELECT SUM(rows) FROM sys.partitions WHERE object_id = OBJECT_ID('<schemaname>.<nyctaxi_trip>')
   ```

-- Report number of columns in table <nyctaxi_trip>

   ```sql
   SELECT COUNT(*) FROM information_schema.columns WHERE table_name = '<nyctaxi_trip>' AND table_schema = '<schemaname>'
   ```

**Output:** You should get 173,179,759 rows and 14 columns.

### Exploration: Trip distribution by medallion

This example query identifies the medallions (taxi numbers) that completed more than 100 trips within a specified time period. The query would benefit from the partitioned table access since it is conditioned by the partition scheme of **pickup\_datetime**. Querying the full dataset will also make use of the partitioned table and/or index scan.

```sql
SELECT medallion, COUNT(*)
FROM <schemaname>.<nyctaxi_fare>
WHERE pickup_datetime BETWEEN '20130101' AND '20130331'
GROUP BY medallion
HAVING COUNT(*) > 100
```

**Output:** The query should return a table with rows specifying the 13,369 medallions (taxis) and the number of trips completed in 2013. The last column contains the count of the number of trips completed.

### Exploration: Trip distribution by medallion and hack_license

This example identifies the medallions (taxi numbers) and hack_license numbers (drivers) that completed more than 100 trips within a specified time period.

```sql
SELECT medallion, hack_license, COUNT(*)
FROM <schemaname>.<nyctaxi_fare>
WHERE pickup_datetime BETWEEN '20130101' AND '20130131'
GROUP BY medallion, hack_license
HAVING COUNT(*) > 100
```

**Output:** The query should return a table with 13,369 rows specifying the 13,369 car/driver IDs that have completed more that 100 trips in 2013. The last column contains the count of the number of trips completed.

### Data quality assessment: Verify records with incorrect longitude and/or latitude

This example investigates if any of the longitude and/or latitude fields either contain an invalid value (radian degrees should be between -90 and 90), or have (0, 0) coordinates.

```sql
SELECT COUNT(*) FROM <schemaname>.<nyctaxi_trip>
WHERE pickup_datetime BETWEEN '20130101' AND '20130331'
AND  (CAST(pickup_longitude AS float) NOT BETWEEN -90 AND 90
OR    CAST(pickup_latitude AS float) NOT BETWEEN -90 AND 90
OR    CAST(dropoff_longitude AS float) NOT BETWEEN -90 AND 90
OR    CAST(dropoff_latitude AS float) NOT BETWEEN -90 AND 90
OR    (pickup_longitude = '0' AND pickup_latitude = '0')
OR    (dropoff_longitude = '0' AND dropoff_latitude = '0'))
```

**Output:** The query returns 837,467 trips that have invalid longitude and/or latitude fields.

### Exploration: Tipped vs. not tipped trips distribution

This example finds the number of trips that were tipped vs. the number that were not tipped in a specified time period (or in the full dataset if covering the full year as it is set up here). This distribution reflects the binary label distribution to be later used for binary classification modeling.

```sql
SELECT tipped, COUNT(*) AS tip_freq FROM (
  SELECT CASE WHEN (tip_amount > 0) THEN 1 ELSE 0 END AS tipped, tip_amount
  FROM <schemaname>.<nyctaxi_fare>
  WHERE pickup_datetime BETWEEN '20130101' AND '20131231') tc
GROUP BY tipped
```

**Output:** The query should return the following tip frequencies for the year 2013: 90,447,622 tipped and 82,264,709 not-tipped.

### Exploration: Tip class/range distribution

This example computes the distribution of tip ranges in a given time period (or in the full dataset if covering the full year). This distribution of  label classes will be used later for multiclass classification modeling.

```sql
SELECT tip_class, COUNT(*) AS tip_freq FROM (
    SELECT CASE
        WHEN (tip_amount = 0) THEN 0
        WHEN (tip_amount > 0 AND tip_amount <= 5) THEN 1
        WHEN (tip_amount > 5 AND tip_amount <= 10) THEN 2
        WHEN (tip_amount > 10 AND tip_amount <= 20) THEN 3
        ELSE 4
    END AS tip_class
FROM <schemaname>.<nyctaxi_fare>
WHERE pickup_datetime BETWEEN '20130101' AND '20131231') tc
GROUP BY tip_class
```

**Output:**

| tip_class | tip_freq |
| --- | --- |
| 1 |82230915 |
| 2 |6198803 |
| 3 |1932223 |
| 0 |82264625 |
| 4 |85765 |

### Exploration: Compute and compare trip distance

This example converts the pickup and dropoff longitude and latitude to SQL geography points, computes the trip distance using SQL geography points difference, and returns a random sample of the results for comparison. The example limits the results to valid coordinates only using the data quality assessment query covered earlier.

```sql
/****** Object:  UserDefinedFunction [dbo].[fnCalculateDistance] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type IN ('FN', 'IF') AND name = 'fnCalculateDistance')
  DROP FUNCTION fnCalculateDistance
GO

-- User-defined function to calculate the direct distance  in mile between two geographical coordinates.
CREATE FUNCTION [dbo].[fnCalculateDistance] (@Lat1 float, @Long1 float, @Lat2 float, @Long2 float)

RETURNS float
AS
BEGIN
      DECLARE @distance decimal(28, 10)
      -- Convert to radians
      SET @Lat1 = @Lat1 / 57.2958
      SET @Long1 = @Long1 / 57.2958
      SET @Lat2 = @Lat2 / 57.2958
      SET @Long2 = @Long2 / 57.2958
      -- Calculate distance
      SET @distance = (SIN(@Lat1) * SIN(@Lat2)) + (COS(@Lat1) * COS(@Lat2) * COS(@Long2 - @Long1))
      --Convert to miles
      IF @distance <> 0
      BEGIN
        SET @distance = 3958.75 * ATAN(SQRT(1 - POWER(@distance, 2)) / @distance);
      END
      RETURN @distance
END
GO

SELECT pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude,
dbo.fnCalculateDistance(pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude) AS DirectDistance
FROM <schemaname>.<nyctaxi_trip>
WHERE datepart("mi",pickup_datetime)=1
AND CAST(pickup_latitude AS float) BETWEEN -90 AND 90
AND CAST(dropoff_latitude AS float) BETWEEN -90 AND 90
AND pickup_longitude != '0' AND dropoff_longitude != '0'
```

### Feature engineering using SQL functions

Sometimes SQL functions can be an efficient option for feature engineering. In this walkthrough, we defined a SQL function to calculate the direct distance between the pickup and dropoff locations. You can run the following SQL scripts in **Visual Studio Data Tools**.

Here is the SQL script that defines the distance function.

```sql
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type IN ('FN', 'IF') AND name = 'fnCalculateDistance')
  DROP FUNCTION fnCalculateDistance
GO

-- User-defined function calculate the direct distance between two geographical coordinates.
CREATE FUNCTION [dbo].[fnCalculateDistance] (@Lat1 float, @Long1 float, @Lat2 float, @Long2 float)

RETURNS float
AS
BEGIN
      DECLARE @distance decimal(28, 10)
      -- Convert to radians
      SET @Lat1 = @Lat1 / 57.2958
      SET @Long1 = @Long1 / 57.2958
      SET @Lat2 = @Lat2 / 57.2958
      SET @Long2 = @Long2 / 57.2958
      -- Calculate distance
      SET @distance = (SIN(@Lat1) * SIN(@Lat2)) + (COS(@Lat1) * COS(@Lat2) * COS(@Long2 - @Long1))
      --Convert to miles
      IF @distance <> 0
      BEGIN
        SET @distance = 3958.75 * ATAN(SQRT(1 - POWER(@distance, 2)) / @distance);
      END
      RETURN @distance
END
GO
```

Here is an example to call this function to generate features in your SQL query:

-- Sample query to call the function to create features

   ```sql
SELECT pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude, dbo.fnCalculateDistance(pickup_latitude, pickup_longitude, dropoff_latitude, dropoff_longitude) AS DirectDistance FROM <schemaname>.<nyctaxi_trip> WHERE datepart("mi",pickup_datetime)=1 AND CAST(pickup_latitude AS float) BETWEEN -90 AND 90 AND CAST(dropoff_latitude AS float) BETWEEN -90 AND 90 AND pickup_longitude != '0' AND dropoff_longitude != '0'
   ```

**Output:** This query generates a table (with 2,803,538 rows) with pickup and dropoff latitudes and longitudes and the corresponding direct distances in miles. Here are the results for first three rows:

| (Row number) | pickup_latitude | pickup_longitude | dropoff_latitude | dropoff_longitude | DirectDistance |
| --- | --- | --- | --- | --- | --- |
| 1 |40.731804 |-74.001083 |40.736622 |-73.988953 |.7169601222 |
| 2 |40.715794 |-74,010635 |40.725338 |-74.00399 |.7448343721 |
| 3 |40.761456 |-73.999886 |40.766544 |-73.988228 |0.7037227967 |

### Prepare data for model building

The following query joins the **nyctaxi\_trip** and **nyctaxi\_fare** tables, generates a binary classification label **tipped**, a multi-class classification label **tip\_class**, and extracts a sample from the full joined dataset. The sampling is done by retrieving a subset of the trips based on pickup time.  This SQL query may be copied then pasted for direct data ingestion from the SQL Database instance in Azure. The query excludes records with incorrect (0, 0) coordinates.

```sql
SELECT t.*, f.payment_type, f.fare_amount, f.surcharge, f.mta_tax, f.tolls_amount,     f.total_amount, f.tip_amount,
    CASE WHEN (tip_amount > 0) THEN 1 ELSE 0 END AS tipped,
    CASE WHEN (tip_amount = 0) THEN 0
        WHEN (tip_amount > 0 AND tip_amount <= 5) THEN 1
        WHEN (tip_amount > 5 AND tip_amount <= 10) THEN 2
        WHEN (tip_amount > 10 AND tip_amount <= 20) THEN 3
        ELSE 4
    END AS tip_class
FROM <schemaname>.<nyctaxi_trip> t, <schemaname>.<nyctaxi_fare> f
WHERE datepart("mi",t.pickup_datetime) = 1
AND   t.medallion = f.medallion
AND   t.hack_license = f.hack_license
AND   t.pickup_datetime = f.pickup_datetime
AND   pickup_longitude != '0' AND dropoff_longitude != '0'
```

When you are ready to proceed to Azure Machine Learning, you may either:

1. Save the final SQL query to extract and sample the data and copy-paste the query directly [into a notebook in Azure Machine Learning](/azure/machine-learning/samples-notebooks), or
2. Persist the sampled and engineered data you plan to use for model building in a new Azure Synapse Analytics table and access that table [through a datastore in Azure Machine Learning](/azure/machine-learning/concept-data#connect-to-storage-with-datastores).

## <a name="ipnb"></a>Data exploration and feature engineering in the notebook

In this section, we will perform data exploration and feature generation using both Python and SQL queries against the Azure Synapse Analytics created earlier. A sample  notebook named **SQLDW_Explorations.ipynb** and a Python script file **SQLDW_Explorations_Scripts.py** have been downloaded to your local directory. They are also available on [GitHub](https://github.com/Azure/Azure-MachineLearning-DataScience/tree/master/Misc/SQLDW). These two files are identical in Python scripts. The Python script file is provided to you in case you would like to use Python without a notebook. These two sample Python files were designed under **Python 2.7**.

The needed Azure Synapse Analytics information in the sample Jupyter Notebook and the Python script file downloaded to your local machine has been plugged in by the PowerShell script previously. They are executable without any modification.

If you have already set up an Azure Machine Learning workspace, you can directly upload the sample  Notebook to the AzureML Notebooks area.  For directions on uploading a notebook, see [Run Jupyter Notebooks in your workspace](/azure/machine-learning/how-to-run-jupyter-notebooks)

Note: In order to run the sample Jupyter Notebook or the Python script file, the following Python packages are needed.

- pandas
- numpy
- matplotlib
- pyodbc
- PyTables

When building advanced analytical solutions on Azure Machine Learning with large data, here is the recommended sequence:

* Read in a small sample of the data into an in-memory data frame.
* Perform some visualizations and explorations using the sampled data.
* Experiment with feature engineering using the sampled data.
* For larger data exploration, data manipulation and feature engineering, use Python to issue SQL Queries directly against the Azure Synapse Analytics.
* Decide the sample size to be suitable for Azure Machine Learning model building.

The followings are a few data exploration, data visualization, and feature engineering examples. More data explorations can be found in the sample Jupyter Notebook and the sample Python script file.

### Initialize database credentials

Initialize your database connection settings in the following variables:

```sql
SERVER_NAME=<server name>
DATABASE_NAME=<database name>
USERID=<user name>
PASSWORD=<password>
DB_DRIVER = <database driver>
```

### Create database connection
Here is the connection string that creates the connection to the database.

```sql
CONNECTION_STRING = 'DRIVER={'+DRIVER+'};SERVER='+SERVER_NAME+';DATABASE='+DATABASE_NAME+';UID='+USERID+';PWD='+PASSWORD
conn = pyodbc.connect(CONNECTION_STRING)
```

### Report number of rows and columns in table <nyctaxi_trip>

```sql
nrows = pd.read_sql('''
    SELECT SUM(rows) FROM sys.partitions
    WHERE object_id = OBJECT_ID('<schemaname>.<nyctaxi_trip>')
''', conn)

print 'Total number of rows = %d' % nrows.iloc[0,0]

ncols = pd.read_sql('''
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_name = ('<nyctaxi_trip>') AND table_schema = ('<schemaname>')
''', conn)

print 'Total number of columns = %d' % ncols.iloc[0,0]
```

* Total number of rows = 173179759
* Total number of columns = 14

### Report number of rows and columns in table <nyctaxi_fare>

```sql
nrows = pd.read_sql('''
    SELECT SUM(rows) FROM sys.partitions
    WHERE object_id = OBJECT_ID('<schemaname>.<nyctaxi_fare>')
''', conn)

print 'Total number of rows = %d' % nrows.iloc[0,0]

ncols = pd.read_sql('''
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_name = ('<nyctaxi_fare>') AND table_schema = ('<schemaname>')
''', conn)

    print 'Total number of columns = %d' % ncols.iloc[0,0]
```

* Total number of rows = 173179759
* Total number of columns = 11

### Read-in a small data sample from the Azure Synapse Analytics Database

```sql
t0 = time.time()

query = '''
    SELECT TOP 10000 t.*, f.payment_type, f.fare_amount, f.surcharge, f.mta_tax,
        f.tolls_amount, f.total_amount, f.tip_amount
    FROM <schemaname>.<nyctaxi_trip> t, <schemaname>.<nyctaxi_fare> f
    WHERE datepart("mi",t.pickup_datetime) = 1
    AND   t.medallion = f.medallion
    AND   t.hack_license = f.hack_license
    AND   t.pickup_datetime = f.pickup_datetime
'''

df1 = pd.read_sql(query, conn)

t1 = time.time()
print 'Time to read the sample table is %f seconds' % (t1-t0)

print 'Number of rows and columns retrieved = (%d, %d)' % (df1.shape[0], df1.shape[1])
```

Time to read the sample table is 14.096495 seconds. Number of rows and columns retrieved = (1000, 21).

### Descriptive statistics

Now you are ready to explore the sampled data. We start with looking at some descriptive statistics for the **trip\_distance** (or any other fields you choose to specify).

```sql
df1['trip_distance'].describe()
```

### Visualization: Box plot example

Next we look at the box plot for the trip distance to visualize the quantiles.

```sql
df1.boxplot(column='trip_distance',return_type='dict')
```

![Box plot output][1]

### Visualization: Distribution plot example

Plots that visualize the distribution and a histogram for the sampled trip distances.

```sql
fig = plt.figure()
ax1 = fig.add_subplot(1,2,1)
ax2 = fig.add_subplot(1,2,2)
df1['trip_distance'].plot(ax=ax1,kind='kde', style='b-')
df1['trip_distance'].hist(ax=ax2, bins=100, color='k')
```

![Distribution plot output][2]

### Visualization: Bar and line plots

In this example, we bin the trip distance into five bins and visualize the binning results.

```sql
trip_dist_bins = [0, 1, 2, 4, 10, 1000]
df1['trip_distance']
trip_dist_bin_id = pd.cut(df1['trip_distance'], trip_dist_bins)
trip_dist_bin_id
```

We can plot the above bin distribution in a bar or line plot with:

```sql
pd.Series(trip_dist_bin_id).value_counts().plot(kind='bar')
```

![Bar plot output][3]

and

```sql
pd.Series(trip_dist_bin_id).value_counts().plot(kind='line')
```

![Line plot output][4]

### Visualization: Scatterplot examples

We show scatter plot between **trip\_time\_in\_secs** and **trip\_distance** to see if there is any correlation

```sql
plt.scatter(df1['trip_time_in_secs'], df1['trip_distance'])
```

![Scatterplot output of relationship between time and distance][6]

Similarly we can check the relationship between **rate\_code** and **trip\_distance**.

```sql
plt.scatter(df1['passenger_count'], df1['trip_distance'])
```

![Scatterplot output of relationship between code and distance][8]

### Data exploration on sampled data using SQL queries in Jupyter notebook

In this section, we explore data distributions using the sampled data that is persisted in the new table we created above. Similar explorations may be performed using the original tables.

#### Exploration: Report number of rows and columns in the sampled table

```sql
nrows = pd.read_sql('''SELECT SUM(rows) FROM sys.partitions WHERE object_id = OBJECT_ID('<schemaname>.<nyctaxi_sample>')''', conn)
print 'Number of rows in sample = %d' % nrows.iloc[0,0]

ncols = pd.read_sql('''SELECT count(*) FROM information_schema.columns WHERE table_name = ('<nyctaxi_sample>') AND table_schema = '<schemaname>'''', conn)
print 'Number of columns in sample = %d' % ncols.iloc[0,0]
```

#### Exploration: Tipped/not tripped Distribution

```sql
query = '''
SELECT tipped, count(*) AS tip_freq
    FROM <schemaname>.<nyctaxi_sample>
    GROUP BY tipped
    '''

    pd.read_sql(query, conn)
```

#### Exploration: Tip class distribution

```sql
query = '''
    SELECT tip_class, count(*) AS tip_freq
    FROM <schemaname>.<nyctaxi_sample>
    GROUP BY tip_class
'''

tip_class_dist = pd.read_sql(query, conn)
```

#### Exploration: Plot the tip distribution by class

```sql
tip_class_dist['tip_freq'].plot(kind='bar')
```

![Plot #26][26]

#### Exploration: Daily distribution of trips

```sql
query = '''
    SELECT CONVERT(date, dropoff_datetime) AS date, COUNT(*) AS c
    FROM <schemaname>.<nyctaxi_sample>
    GROUP BY CONVERT(date, dropoff_datetime)
'''

pd.read_sql(query,conn)
```

#### Exploration: Trip distribution per medallion

```sql
query = '''
    SELECT medallion,count(*) AS c
    FROM <schemaname>.<nyctaxi_sample>
    GROUP BY medallion
'''

pd.read_sql(query,conn)
```

#### Exploration: Trip distribution by medallion and hack license

```sql
query = '''select medallion, hack_license,count(*) from <schemaname>.<nyctaxi_sample> group by medallion, hack_license'''
pd.read_sql(query,conn)
```

#### Exploration: Trip time distribution

```sql
query = '''select trip_time_in_secs, count(*) from <schemaname>.<nyctaxi_sample> group by trip_time_in_secs order by count(*) desc'''
pd.read_sql(query,conn)
```

#### Exploration: Trip distance distribution

```sql
query = '''select floor(trip_distance/5)*5 as tripbin, count(*) from <schemaname>.<nyctaxi_sample> group by floor(trip_distance/5)*5 order by count(*) desc'''
pd.read_sql(query,conn)
```

#### Exploration: Payment type distribution

```sql
query = '''select payment_type,count(*) from <schemaname>.<nyctaxi_sample> group by payment_type'''
pd.read_sql(query,conn)
```

#### Verify the final form of the featurized table

```sql
query = '''SELECT TOP 100 * FROM <schemaname>.<nyctaxi_sample>'''
pd.read_sql(query,conn)
```

## <a name="mlmodel"></a>Build models in Azure Machine Learning

We are now ready to proceed to model building and model deployment in [Azure Machine Learning](/azure/machine-learning/). The data is ready to be used in any of the prediction problems identified earlier, namely:

1. **Binary classification**: To predict whether or not a tip was paid for a trip.
2. **Multiclass classification**: To predict the range of tip paid, according to the previously defined classes.
3. **Regression task**: To predict the amount of tip paid for a trip.

To begin the modeling exercise, log in to your **Azure Machine Learning workspace**. If you have not yet created a machine learning workspace, see [Create the workspace](/azure/machine-learning/quickstart-create-resources#create-the-workspace).

1. To get started with Azure Machine Learning, see [What is Azure Machine Learning?](/azure/machine-learning/overview-what-is-azure-machine-learning)
2. Sign in to [the Azure portal](https://portal.azure.com).
3. The Machine Learning Home page provides a wealth of information, videos, tutorials, links to the Modules Reference, and other resources. For more information about Azure Machine Learning, see the [Azure Machine Learning Documentation Center](/azure/machine-learning/).

A typical training experiment consists of the following steps:

1. Create an authoring resource (notebook or designer, for example).
2. Get the data into Azure Machine Learning.
3. Pre-process, transform, and manipulate the data as needed.
4. Generate features as needed.
5. Split the data into training/validation/testing datasets(or have separate datasets for each).
6. Select one or more machine learning algorithms depending on the learning problem to solve. For example, binary classification, multiclass classification, regression.
7. Train one or more models using the training dataset.
8. Score the validation dataset using the trained model(s).
9. Evaluate the model(s) to compute the relevant metrics for the learning problem.
10. Tune the model(s) and select the best model to deploy.

In this exercise, we have already explored and engineered the data in Azure Synapse Analytics, and decided on the sample size to ingest in Azure Machine Learning. Here is the procedure to build one or more of the prediction models:

1. Get the data into Azure Machine Learning.  For details, see [Data ingestion options for Azure Machine Learning workflows](/azure/machine-learning/concept-data-ingestion)
2. Connect to Synapse Analytics.  For details, see [Link Azure Synapse Analytics and Azure Machine Learning workspaces and attach Apache Spark pools](/azure/machine-learning/how-to-link-synapse-ml-workspaces)


> [!IMPORTANT]
> In the modeling data extraction and sampling query examples provided in previous sections, **all labels for the three modeling exercises are included in the query**. An important (required) step in each of the modeling exercises is to **exclude** the unnecessary labels for the other two problems, and any other **target leaks**. For example, when using binary classification, use the label **tipped** and exclude the fields **tip\_class**, **tip\_amount**, and **total\_amount**. The latter are target leaks since they imply the tip paid.
>

## <a name="mldeploy"></a>Deploy models in Azure Machine Learning

When your model is ready, you can easily deploy it as a web service directly from the model stored in the experiment run.  For details on the options for deployment, see [Deploy machine learning models to Azure](/azure/machine-learning/how-to-deploy-and-where)

## Summary

To recap what we have done in this walkthrough tutorial, you have created an Azure data science environment, worked with a large public dataset, taking it through the Team Data Science Process, all the way from data acquisition to model training, and then to the deployment of an Azure Machine Learning web service.

### License information

This sample walkthrough and its accompanying scripts and notebook(s) are shared by Microsoft under the MIT license. Check the LICENSE.txt file in the directory of the sample code on GitHub for more details.

## References

- [NYC Taxi and Limousine Commission Research and Statistics](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

[1]: ./media/sqldw-walkthrough/sql-walkthrough-26-1.png
[2]: ./media/sqldw-walkthrough/sql-walkthrough-28-1.png
[3]: ./media/sqldw-walkthrough/sql-walkthrough-35-1.png
[4]: ./media/sqldw-walkthrough/sql-walkthrough-36-1.png
[5]: ./media/sqldw-walkthrough/sql-walkthrough-39-1.png
[6]: ./media/sqldw-walkthrough/sql-walkthrough-42-1.png
[7]: ./media/sqldw-walkthrough/sql-walkthrough-44-1.png
[8]: ./media/sqldw-walkthrough/sql-walkthrough-46-1.png
[9]: ./media/sqldw-walkthrough/sql-walkthrough-71-1.png
[10]: ./media/sqldw-walkthrough/azure-ml-train.png
[11]: ./media/sqldw-walkthrough/azure-ml-publish.png
[12]: ./media/sqldw-walkthrough/ssms-connect.png
[13]: ./media/sqldw-walkthrough/execute-script.png
[15]: ./media/sqldw-walkthrough/sql-default-dirs.png
[16]: ./media/sqldw-walkthrough/bulk-import.png
[19]: ./media/sqldw-walkthrough/ps-download-scripts.png
[20]: ./media/sqldw-walkthrough/ps-load-data.png
[21]: ./media/sqldw-walkthrough/azcopy-overwrite.png
[26]: ./media/sqldw-walkthrough/tip-class-hist-1.png

<!-- Module References -->
[edit-metadata]: /azure/machine-learning/studio-module-reference/edit-metadata
[select-columns]: /azure/machine-learning/studio-module-reference/select-columns-in-dataset
[import-data]: /azure/machine-learning/studio-module-reference/import-data
