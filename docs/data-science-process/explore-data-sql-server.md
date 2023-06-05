---
title: Explore data in a SQL Server virtual machine 
description: How to explore data that is stored in a SQL Server VM on Azure using SQL or a programming language like Python.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
ms.date: 01/10/2020
ms.author: tdsp
ms.custom:
  - previous-author=deguhath
  - previous-ms.author=deguhath
  - devx-track-python
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Explore data in a SQL Server virtual machine on Azure

This article covers how to explore data that is stored in a SQL Server VM on Azure. Use SQL or Python to examine the data.

This task is a step in the [Team Data Science Process](overview.yml).

> [!NOTE]
> The sample SQL statements in this document assume that data is in SQL Server. If it isn't, refer to the cloud data science process map to learn how to move your data to SQL Server.
>
>

## <a name="sql-dataexploration"></a>Explore SQL data with SQL scripts
Here are a few sample SQL scripts that can be used to explore data stores in SQL Server.

1. Get the count of observations per day

    `SELECT CONVERT(date, <date_columnname>) as date, count(*) as c from <tablename> group by CONVERT(date, <date_columnname>)`
2. Get the levels in a categorical column

    `select  distinct <column_name> from <databasename>`
3. Get the number of levels in combination of two categorical columns

    `select <column_a>, <column_b>,count(*) from <tablename> group by <column_a>, <column_b>`
4. Get the distribution for numerical columns

    `select <column_name>, count(*) from <tablename> group by <column_name>`

> [!NOTE]
> For a practical example, you can use the [NYC Taxi dataset](https://www.andresmh.com/nyctaxitrips/) and refer to the IPNB titled [NYC Data wrangling using IPython Notebook and SQL Server](https://github.com/Azure/Azure-MachineLearning-DataScience/blob/master/Misc/DataScienceProcess/iPythonNotebooks/machine-Learning-data-science-process-sql-walkthrough.ipynb) for an end-to-end walk-through.
>
>

## <a name="python"></a>Explore SQL data with Python
Using Python to explore data and generate features when the data is in SQL Server is similar to processing data in Azure blob using Python, as documented in [Process Azure Blob data in your data science environment](data-blob.md). Load the data from the database into a pandas DataFrame and then can be processed further. We document the process of connecting to the database and loading the data into the DataFrame in this section.

The following connection string format can be used to connect to a SQL Server database from Python using pyodbc (replace servername, dbname, username, and password with your specific values):

```python
#Set up the SQL Azure connection
import pyodbc    
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=<servername>;DATABASE=<dbname>;UID=<username>;PWD=<password>')
```

The [Pandas library](https://pandas.pydata.org/) in Python provides a rich set of data structures and data analysis tools for data manipulation for Python programming. The following code reads the results returned from a SQL Server database into a Pandas data frame:

```python
# Query database and load the returned results in pandas data frame
data_frame = pd.read_sql('''select <columnname1>, <columnname2>... from <tablename>''', conn)
```

Now you can work with the Pandas DataFrame as covered in the topic [Process Azure Blob data in your data science environment](data-blob.md).

## The Team Data Science Process in action example
For an end-to-end walkthrough example of the Cortana Analytics Process using a public dataset, see [The Team Data Science Process in action: using SQL Server](/azure/architecture/data-science-process/overview).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
