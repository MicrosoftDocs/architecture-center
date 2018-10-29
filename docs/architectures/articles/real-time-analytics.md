---
title: Real Time Analytics on Big Data Architecture 
description: Get deep learning analytics and insights live from streaming data. Review logs from website clickstream in near real-time for advanced analytics processing.
author: adamboeglin
ms.date: 10/29/2018
---
# Real Time Analytics on Big Data Architecture 
Get insights from live streaming data with ease. Capture data continuously from any IoT device, or logs from website clickstreams, and process it in near-real time.

## Architecture
<img src="media/real-time-analytics.svg" alt='architecture diagram' />

## Data Flow
1. Easily ingest live streaming data for an application using Apache Kafka cluster in Azure HDInsight.
1. Bring together all your structured data using Azure Data Factory to Azure Blob Storage.
1. Take advantage of Azure Databricks to clean, transform, and analyze the streaming data, and combine it with structured data from operational databases or data warehouses.
1. Use scalable machine learning/deep learning techniques, to derive deeper insights from this data using Python, R or Scala, with inbuilt notebook experiences in Azure Databricks.
1. Leverage native connectors between Azure Databricks and Azure SQL Data Warehouse to access and move data at scale.
1. Build analytical dashboards and embedded reports on top of Azure Data Warehouse to share insights within your organization and use Azure Analysis Services to serve this data to thousands of users.
1. Power users take advantage of the inbuilt capabilities of Azure Databricks and Azure HDInsight to perform root cause determination and raw data analysis.
1. Take the insights from Azure Databricks to Cosmos DB to make them accessible through real time apps.

## Components
* Azure [SQL Data Warehouse](http://azure.microsoft.com/services/sql-data-warehouse/) is the fast, flexible and trusted cloud data warehouse that lets you scale, compute and store elastically and independently, with a massively parallel processing architecture.
* Azure [Data Factory](http://azure.microsoft.com/services/data-factory/) is a hybrid data integration service that allows you to create, schedule and orchestrate your ETL/ELT workflows.
* [Azure Blob storage](http://azure.microsoft.com/services/storage/blobs/) is a Massively scalable object storage for any type of unstructured dataimages, videos, audio, documents, and moreeasily and cost-effectively.
* [Azure Databricks](http://azure.microsoft.com/services/databricks/) is a fast, easy, and collaborative Apache Spark-based analytics platform.
* Azure [HDInsight](http://azure.microsoft.com/services/hdinsight/) is a fully managed, full spectrum open-source analytics service for popular open-source frameworks such as Hadoop, Spark, Hive, LLAP, Kafka, Storm, R & more.
* [Azure Cosmos DB](http://azure.microsoft.com/services/cosmos-db/) is a globally distributed, multi-model database service. Then learn how to replicate your data across any number of Azure regions and scale your throughput independent from your storage.
* [Azure Analysis Services](http://azure.microsoft.com/services/analysis-services/) is an enterprise grade analytics as a service that lets you govern, deploy, test, and deliver your BI solution with confidence.
* [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that deliver insights throughout your organization. Connect to hundreds of data sources, simplify data prep, and drive ad hoc analysis. Produce beautiful reports, then publish them for your organization to consume on the web and across mobile devices.

## Next Steps
* [SQL Data Warehouse Documentation](https://docs.microsoft.com/azure/sql-data-warehouse/)
* [Azure Data Factory V2 Preview Documentation](https://docs.microsoft.com/azure/data-factory/)
* [Introduction to object storage in Azure](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction/)
* [Azure Databricks Documentation](https://docs.microsoft.com/azure/azure-databricks/)
* [Azure HDInsight Documentation](https://docs.microsoft.com/azure/hdinsight/)
* [Azure Cosmos DB Documentation](https://docs.microsoft.com/azure/cosmos-db/)
* [Analysis Services Documentation](https://docs.microsoft.com/azure/analysis-services/)
* [Power BI Documentation](https://docs.microsoft.com/power-bi/)