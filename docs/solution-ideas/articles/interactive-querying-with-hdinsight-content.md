[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Perform fast, interactive SQL like queries at scale over structured or unstructured data with Apache Hive LLAP on Azure HDInsight.

## Architecture

![Architecture Diagram](../media/interactive-querying-with-hdinsight.png)
*Download an [SVG](../media/interactive-querying-with-hdinsight.svg) of this architecture.*

### Dataflow

1. Move data between Azure cloud or any other non Azure cloud using Azure Data Factory
1. Create a data landing zone using Azure Data Lake Gen2 service, which is also the primary storage account for the Azure HDInsights hadoop cluster
1. Run ELT procedures using Azure Data Factory or Hive to transform incoming data in HDFS
1. Create external tables in Hive using this data in HDFS
1. Use Power BI to interpret this data and create new visualizations

### Components

* [Azure Data Factory](/azure/data-factory/introduction) is a hybrid data integration service that allows you to create, schedule and orchestrate your ETL/ELT workflows.
* [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a set of capabilities such as file system semantics, and file-level security dedicated to big data analytics built on Azure Blob storage.
* [Azure HDInsight](/azure/hdinsight/hdinsight-overview) makes it easy, fast, and cost-effective to process massive amounts of data. You can use the most popular open-source frameworks such as Hadoop, Spark, Hive, LLAP, Kafka, Storm, R, and more.
* [Power BI](/power-bi/fundamentals/power-bi-overview) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive adhoc analysis.

## Next steps

* [Create a data pipeline to derive sales insights in Azure HDInsight](/azure/hdinsight/hdinsight-sales-insights-etl) build an end-to-end data pipeline that performs extract, transform, and load (ETL) operations.
* [Visualize Apache Hive data with Microsoft Power BI](/azure/hdinsight/hadoop/apache-hadoop-connect-hive-power-bi) learn how to connect Microsoft Power BI Desktop to Azure HDInsight using ODBC and visualize Apache Hive data.
* [Apache Hive and HiveQL on Azure HDInsight](/azure/hdinsight/hadoop/hdinsight-use-hive) is a data warehouse system for Apache Hadoop. Hive enables data summarization, querying, and analysis of data. Hive queries are written in HiveQL, which is a query language similar to SQL.
