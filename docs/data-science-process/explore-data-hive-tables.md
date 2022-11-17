---
title: Explore data in Hive tables with Hive queries
description: Use sample Hive scripts that are used to explore data in Hive tables in an HDInsight Hadoop cluster.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: conceptual
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
# Explore data in Hive tables with Hive queries

This article provides sample Hive scripts that are used to explore data in Hive tables in an HDInsight Hadoop cluster.

This task is a step in the [Team Data Science Process](overview.yml).

## Prerequisites
This article assumes that you have:

* Created an Azure storage account. If you need instructions, see [Create an Azure Storage account](/azure/storage/common/storage-account-create)
* Provisioned a customized Hadoop cluster with the HDInsight service. If you need instructions, see [Customize Azure HDInsight Hadoop Clusters for Advanced Analytics](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql).
* The data has been uploaded to Hive tables in Azure HDInsight Hadoop clusters. If it has not, follow the instructions in [Create and load data to Hive tables](move-hive-tables.md) to upload data to Hive tables first.
* Enabled remote access to the cluster. If you need instructions, see [Access the Head Node of Hadoop Cluster](/azure/hdinsight/spark/apache-spark-jupyter-spark-sql).
* If you need instructions on how to submit Hive queries, see [How to Submit Hive Queries](move-hive-tables.md#submit)

## Example Hive query scripts for data exploration
1. Get the count of observations per partition
    `SELECT <partitionfieldname>, count(*) from <databasename>.<tablename> group by <partitionfieldname>;`
2. Get the count of observations per day
    `SELECT to_date(<date_columnname>), count(*) from <databasename>.<tablename> group by to_date(<date_columnname>);`
3. Get the levels in a categorical column  
    `SELECT  distinct <column_name> from <databasename>.<tablename>`
4. Get the number of levels in combination of two categorical columns
    `SELECT <column_a>, <column_b>, count(*) from <databasename>.<tablename> group by <column_a>, <column_b>`
5. Get the distribution for numerical columns  
    `SELECT <column_name>, count(*) from <databasename>.<tablename> group by <column_name>`
6. Extract records from joining two tables

    ```hiveql
    SELECT
        a.<common_columnname1> as <new_name1>,
        a.<common_columnname2> as <new_name2>,
        a.<a_column_name1> as <new_name3>,
        a.<a_column_name2> as <new_name4>,
        b.<b_column_name1> as <new_name5>,
        b.<b_column_name2> as <new_name6>
    FROM
        (
        SELECT <common_columnname1>,
            <common_columnname2>,
            <a_column_name1>,
            <a_column_name2>,
        FROM <databasename>.<tablename1>
        ) a
        join
        (
        SELECT <common_columnname1>,
            <common_columnname2>,
            <b_column_name1>,
            <b_column_name2>,
        FROM <databasename>.<tablename2>
        ) b
        ON a.<common_columnname1>=b.<common_columnname1> and a.<common_columnname2>=b.<common_columnname2>
    ```

## Additional query scripts for taxi trip data scenarios
Examples of queries that are specific to NYC Taxi Trip Data scenarios are also provided in [GitHub repository](https://github.com/Azure/Azure-MachineLearning-DataScience/tree/master/Misc/DataScienceProcess/DataScienceScripts). These queries already have data schema specified and are ready to be submitted to run.  The NYC Taxi Trip data is available through [Azure Open Datasets](/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets) or from the source [TLC Trip Record Data](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Mark Tabladillo](https://www.linkedin.com/in/marktab/) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*
