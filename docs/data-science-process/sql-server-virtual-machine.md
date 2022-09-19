---
title: Process data in a SQL Server virtual machine on Azure
description: Explore + process data and generate features using Python or SQL in a SQL Server virtual machine on Azure.
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
# Process data in a SQL Server virtual machine on Azure

This document covers how to explore data and generate features for data stored in a SQL Server VM on Azure. This goal may be completed by data wrangling using SQL or by using a programming language like Python.

> [!NOTE]
> The sample SQL statements in this document assume that data is in SQL Server. If it isn't, refer to the cloud data science process map to learn how to move your data to SQL Server.
>
>

## <a name="SQL"></a>Using SQL

We describe the following data wrangling tasks in this section using SQL:

1. [Data Exploration](#sql-dataexploration)
2. [Feature Generation](#sql-featuregen)

### <a name="sql-dataexploration"></a>Data Exploration

Here are a few sample SQL scripts that can be used to explore data stores in SQL Server.

> [!NOTE]
> For a practical example, you can use the [NYC Taxi dataset](https://www.andresmh.com/nyctaxitrips/) and refer to the IPNB titled [NYC Data wrangling using IPython Notebook and SQL Server](https://github.com/Azure/Azure-MachineLearning-DataScience/blob/master/Misc/DataScienceProcess/iPythonNotebooks/machine-Learning-data-science-process-sql-walkthrough.ipynb) for an end-to-end walk-through.
>
>

1. Get the count of observations per day

    `SELECT CONVERT(date, <date_columnname>) as date, count(*) as c from <tablename> group by CONVERT(date, <date_columnname>)`
2. Get the levels in a categorical column

    `select  distinct <column_name> from <databasename>`
3. Get the number of levels in combination of two categorical columns

    `select <column_a>, <column_b>,count(*) from <tablename> group by <column_a>, <column_b>`
4. Get the distribution for numerical columns

    `select <column_name>, count(*) from <tablename> group by <column_name>`

### <a name="sql-featuregen"></a>Feature Generation

In this section, we describe ways of generating features using SQL:

1. [Count based Feature Generation](#sql-countfeature)
2. [Binning Feature Generation](#sql-binningfeature)
3. [Rolling out the features from a single column](#sql-featurerollout)

> [!NOTE]
> Once you generate additional features, you can either add them as columns to the existing table or create a new table with the additional features and primary key, that can be joined with the original table.
>
>

### <a name="sql-countfeature"></a>Count based Feature Generation

The following examples demonstrate two ways of generating count features. The first method uses conditional sum and the second method uses the 'where' clause. These results may then be joined with the original table (using primary key columns) to have count features alongside the original data.

```sql
select <column_name1>,<column_name2>,<column_name3>, COUNT(*) as Count_Features from <tablename> group by <column_name1>,<column_name2>,<column_name3>

select <column_name1>,<column_name2> , sum(1) as Count_Features from <tablename> 
where <column_name3> = '<some_value>' group by <column_name1>,<column_name2> 
```

### <a name="sql-binningfeature"></a>Binning Feature Generation

The following example shows how to generate binned features by binning (using five bins) a numerical column that can be used as a feature instead:

```sql
SELECT <column_name>, NTILE(5) OVER (ORDER BY <column_name>) AS BinNumber from <tablename>
```

### <a name="sql-featurerollout"></a>Rolling out the features from a single column

In this section, we demonstrate how to roll out a single column in a table to generate additional features. The example assumes that there is a latitude or longitude column in the table from which you are trying to generate features.

Here is a brief primer on latitude/longitude location data (resourced from stackoverflow [How to measure the accuracy of latitude and longitude?](https://gis.stackexchange.com/questions/8650/how-to-measure-the-accuracy-of-latitude-and-longitude)). This guidance is useful to understand before including location as one or more features:

* The sign tells us whether we are north or south, east or west on the globe.
* A nonzero hundreds digit tells us that we're using longitude, not latitude!
* The tens digit gives a position to about 1,000 kilometers. It gives us useful information about what continent or ocean we are on.
* The units digit (one decimal degree) gives a position up to 111 kilometers (60 nautical miles, about 69 miles). It can tell you roughly what state, country, or region you're in.
* The first decimal place is worth up to 11.1 km: it can distinguish the position of one large city from a neighboring large city.
* The second decimal place is worth up to 1.1 km: it can separate one village from the next.
* The third decimal place is worth up to 110 m: it can identify a large agricultural field or institutional campus.
* The fourth decimal place is worth up to 11 m: it can identify a parcel of land. It is comparable to the typical accuracy of an uncorrected GPS unit with no interference.
* The fifth decimal place is worth up to 1.1 m: it distinguishes trees from each other. Accuracy to this level with commercial GPS units can only be achieved with differential correction.
* The sixth decimal place is worth up to 0.11 m: you can use this for laying out structures in detail, for designing landscapes, building roads. It should be more than good enough for tracking movements of glaciers and rivers. This can be achieved by taking painstaking measures with GPS, such as differentially corrected GPS.

The location information can be featurized as follows, separating out region, location, and city information. You can also call a REST end point such as Bing Maps API available at [Find a Location by Point](/bingmaps/rest-services/locations/find-a-location-by-point) to get the region/district information.

```sql
select 
    <location_columnname>
    ,round(<location_columnname>,0) as l1        
    ,l2=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 1 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),1,1) else '0' end     
    ,l3=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 2 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),2,1) else '0' end     
    ,l4=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 3 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),3,1) else '0' end     
    ,l5=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 4 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),4,1) else '0' end     
    ,l6=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 5 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),5,1) else '0' end     
    ,l7=case when LEN (PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1)) >= 6 then substring(PARSENAME(round(ABS(<location_columnname>) - FLOOR(ABS(<location_columnname>)),6),1),6,1) else '0' end     
from <tablename>
```

These location-based features can be further used to generate additional count features as described earlier.

> [!TIP]
> You can programmatically insert the records using your language of choice. You may need to insert the data in chunks to improve write efficiency (for an example of how to do this using pyodbc, see [A HelloWorld sample to access SQLServer with python](https://code.google.com/p/pypyodbc/wiki/A_HelloWorld_sample_to_access_mssql_with_python)).
> Another alternative is to insert data in the database using the [BCP utility](/sql/tools/bcp-utility).
>
>

### <a name="sql-aml"></a>Connecting to Azure Machine Learning

The newly generated feature can be added as a column to an existing table or stored in a new table and joined with the original table for machine learning. Features can be generated or accessed if already created, using the [Import Data][import-data] module in Azure Machine Learning as shown below:

![azureml readers][1]

## <a name="python"></a>Using a programming language like Python

Using Python to explore data and generate features when the data is in SQL Server is similar to processing data in Azure blob using Python as documented in [Process Azure Blob data in your data science environment](data-blob.md). Load the data from the database into a pandas data frame for more processing. We document the process of connecting to the database and loading the data into the data frame in this section.

The following connection string format can be used to connect to a SQL Server database from Python using pyodbc (replace servername, dbname, username, and password with your specific values):

```python
#Set up the SQL Azure connection
import pyodbc    
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=<servername>;DATABASE=<dbname>;UID=<username>;PWD=<password>')
```

The [Pandas library](https://pandas.pydata.org/) in Python provides a rich set of data structures and data analysis tools for data manipulation for Python programming. The code below reads the results returned from a SQL Server database into a Pandas data frame:

```python
# Query database and load the returned results in pandas data frame
data_frame = pd.read_sql('''select <columnname1>, <columnname2>... from <tablename>''', conn)
```

Now you can work with the Pandas data frame as covered in the article [Process Azure Blob data in your data science environment](data-blob.md).

## Azure Data Science in Action Example

For an end-to-end walkthrough example of the Azure Data Science Process using a public dataset, see [Azure Data Science Process in Action](/azure/architecture/data-science-process/overview).

[1]: ./media/sql-server-virtual-machine/reader-db-featurized-input.png

<!-- Module References -->
[import-data]: /azure/machine-learning/studio-module-reference/import-data