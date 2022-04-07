---
title: Microsoft partner and third-party scenarios on Azure
description: Review an extensive list of architectures and solutions that use Microsoft partner and third-party solutions.
author: EdPrice-MSFT
ms.author: edprice
ms.date: 04/04/2022 
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-netapp-files
  - azure-database-mariadb
  - azure-database-mysql
  - azure-database-postgresql
categories:
  - ai-machine-learning
  - databases
  - hybrid
  - analytics
  - web
  - iot
  - migration 
  - containers
  - integration 
  - media
  - compute
  - devops
  - management-and-governance
  - blockchain
  - storage
  - mobile
  - security
  - networking
  - windows-virtual-desktop
ms.custom: fcp
---

# Microsoft partner and third-party scenarios on Azure

Microsoft partners make up a community of organizations that work with Microsoft to create innovative solutions for you. Driven by the opportunities of the intelligent cloud, Microsoft is prioritizing investments that support these opportunities.

The [Azure Sponsorship for ISVs program](https://partner.microsoft.com/asset/collection/azure-sponsorship-for-isvs#) helps independent software vendors (ISVs) use Azure services to drive platform innovation and develop new solutions that can accelerate your digital transformation. 

Microsoft is proud to support open-source projects, initiatives, and foundations and contribute to thousands of open-source communities. By using open-source technologies on Azure, you can run applications your way while optimizing your investments. 

Visit [Azure Marketplace](https://azuremarketplace.microsoft.com) to discover, try, and deploy cloud software from Microsoft and Microsoft partners.

This article provides a summary of architectures and solutions that use Azure together with partner and third-party solutions.

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Scenarios featuring open-source technologies on Azure

### Apache

#### Apache Cassandra

|Architecture|Summary|Technology focus|
|--|--|--|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|View guidance for how to separate data partitions to be managed and accessed separately. Understand horizontal, vertical, and functional partitioning strategies. Cassandra is ideally suited to vertical partitioning.|Databases|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multi-access edge compute. Cassandra can be used to support geo-replication.| Hybrid|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)| Build solutions that integrate data from many IoT devices into a comprehensive data analysis architecture to improve and automate decision making. In this scenario, a Cassandra cluster is used to store data.|Analytics|
|[N-tier application with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)|Deploy Linux virtual machines and a virtual network configured for an N-tier architecture with Apache Cassandra.| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml) |Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements. The Azure Cosmos DB Cassandra API is a recommended Azure service.|Databases|
|[Run Apache Cassandra on Azure VMs](../best-practices/cassandra.md)|Examine performance considerations for running Apache Cassandra on Azure virtual machines. Use these recommendations as a baseline to test against your workload.| Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.| Analytics|

#### Apache CouchDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml) |Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application. CouchDB is a recommended document database.|Web

#### Apache Hadoop

|Architecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](../industries/finance/actuarial-risk-analysis-financial-model.yml)|Learn how an actuarial developer can move an existing solution and its supporting infrastructure to Azure. Use Hadoop for data analysis.| Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence. Use Hadoop to store data.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub. Use Hadoop to store data.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. Learn about batch processing languages and automation engines that are well-suited for use with Hadoop. | Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. Azure HDInsight Hadoop clusters can be used for batch processing.| Databases|
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|Learn about Azure data transfer options like Azure Import/Export service, Azure Data Box, Azure Data Factory, and command-line and graphical interface tools. The Hadoop ecosystem provides tools for data transfer.| Databases|
|[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and production version. Azure Data Lake, a Hadoop-compatible file system, stores data.| AI|
|[Data considerations for microservices](../microservices/design/data-considerations.yml)|Learn about managing data in a microservices architecture. View an example that uses Azure Data Lake Store, a Hadoop file system. | Microservices|
|[Extend your on-premises big data investments with HDInsight](../solution-ideas/articles/extend-your-on-premises-big-data-investments-with-hdinsight.yml)|Extend your on-premises big data investments to the cloud. Transform your business by using the advanced analytics capabilities of HDInsight. Hadoop is used as a data store.| Analytics|
|[Extract actionable insights from IoT data](../industries/manufacturing/extract-insights-iot-data.yml)|Extract insights from IoT data by using Azure services. HDInsight, a managed Hadoop service, can be used to process and transform data in cold storage.| Analytics|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about extract-transform-load (ETL) and extract-load-transform (ELT) data transformation pipelines and how to use control flows and data flows. Hadoop can be used as destination data store in ELT processes.| Analytics|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.| Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data. HDInsight makes it easy to process data from Hadoop.| Databases|
|[IoT analyze-and-optimize loops](../example-scenario/iot/analyze-optimize-loop.yml)|Learn about analyze-and-optimize loops, an IoT pattern for generating and applying optimization insights based on an entire business context. Hadoop map-reduce processing can be used to process big data.| IoT|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. CluedIn can take input data from Hadoop.| Databases|
|[Materialized View pattern](../patterns/materialized-view.yml)|Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for your required query operations. Use Hadoop for a big data storage mechanism that supports indexing.| Databases|
|[Predict loan charge-offs with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off. HDInsight supports Hadoop.| Databases|
|[Predictive maintenance for industrial IoT](../solution-ideas/articles/iot-predictive-maintenance.yml)|Connect devices that use the Open Platform Communications Unified Architecture standard to the cloud, and use predictive maintenance to optimize production. Use HDInsight with Hadoop to visually transform data.| IoT|

#### Apache HBase

|Architecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence. Use HBase to store data.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub. Use HBase to store data.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. HBase provides a flexible option for querying structured and semi-structured data.| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. You can use HBase for data presentation in these scenarios.| Databases|
|[Choose a big data storage technology](../data-guide/technology-choices/data-storage.md)|Compare big data storage technology options in Azure. Includes a discussion of HBase on HDInsight.| Databases|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Learn about using HBase for random access and strong consistency for large amounts of unstructured and semi-structured data.| Analytics|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|View guidance for separating data partitions so they can be managed and accessed separately. Understand horizontal, vertical, and functional partitioning strategies. HBase is ideally suited to vertical partitioning.| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements. HBase can be used for columnar and time series data. | Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use HBase as an analytical data store.| Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|Analyze time series data like sensor data, stock prices, clickstream data, or app telemetry for historical trends, real-time alerts, or predictive modeling. In this solution, you can use HBase to store processed data.| Databases|

#### Apache Hive

|Architecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. Hive is useful for batch processing and provides an architecture that's similar to that of a typical relational database management system. | Analytics|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. You can use Hive for batch processing and data presentation in these scenarios.| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|Build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign. Hive is used to store recommendations for how and when to contact each lead. | Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure. Learn about the capabilities of Hive.| Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure. Learn about the capabilities of Hive.| Analytics|
|[Data warehousing in Azure](../data-guide/relational-data/data-warehousing.yml)|Learn about data warehousing in Azure. You can use Hive together with HDInsight for the analytical store layer.| Databases|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about ETL and ELT data transformation pipelines and how to use control flows and data flows. In ELT, you can use Hive to query source data. You can also use it together with Hadoop as a data store.| Databases|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hive, and Apache Spark. | Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data.| Databases|
|[Loan charge-off prediction with HDInsight Spark clusters](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off. Analytics results are stored in Hive tables.| Analytics|
|[Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)|Learn how to combine real-time aircraft data with analytics to create a solution for predictive aircraft engine monitoring and health. Hive scripts provide aggregations on raw events that are archived by Azure Stream Analytics.| Analytics|
|[Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)|Learn how car dealerships, manufacturers, and insurance companies can use Azure to get predictive insights on vehicle health and driving habits. In this solution, Azure Data Factory uses HDInsight to run Hive queries to process and load data.| Analytics|
|[Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)|Build a predictive maintenance solution that monitors aircraft parts in real time and uses analytics to predict the remaining useful life of engine components. Hive scripts provide aggregations on raw events that are archived by Azure Stream Analytics.| Analytics|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Hive as an analytical data store.| Analytics|
|[Scale AI and machine learning initiatives in regulated industries](../example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries.yml)|Learn about scaling Azure AI and machine learning environments that must comply with extensive security policies. Hive is used to store metadata.| AI|

#### Apache JMeter

|Architecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. A custom JMeter solution is used for load testing.|Migration|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline.|Migration|
[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. JMeter is used for load testing.|Migration|
[Scalable cloud applications and SRE](../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)|Build scalable cloud applications by using performance modeling and other principles and practices of site reliability engineering (SRE). JMeter is used for load testing.|Web|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)|Learn about logging, tracing, and monitoring for microservices apps. JMeter is recommended for testing the behavior and performance of services.|Microservices|

#### Apache Kafka
 
|Architecture|Summary|Technology focus|
|--|--|--|
|[Anomaly detector process](../solution-ideas/articles/anomaly-detector-process.yml)|Learn about Anomaly Detector and see how anomaly detection models are selected with time series data. In this architecture, Event Hubs for Kafka can be used as an alternative to running your own Kafka cluster.|Analytics|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for Azure Kubernetes Service (AKS) applications, including Kafka applications.|Containers|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)|Learn about asynchronous messaging options in Azure, including support for Kafka clients.|Integration|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes several open-source libraries that you can reuse. Back-end services in this architecture can connect to Kafka.|Web|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Ingest Kafka data into Azure Data Explorer and examine it by using improvised, interactive, fast queries.|Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)|Use Azure Data Explorer in a hybrid monitoring solution that ingests streamed and batched logs from Kafka and other sources.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Events from Event Hubs for Kafka feed into the system. |Containers|
|[Choose a real-time message ingestion technology](../data-guide/technology-choices/real-time-ingestion.md)|Learn about Kafka, an open-source distributed streaming platform that can be used to build real-time data pipelines and streaming applications.|Databases|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure, including the Kafka streams API.|Analytics|
|[Claim-Check pattern](../patterns/claim-check.yml)|Examine the Claim-Check pattern, which splits a large message into a claim check and a payload to avoid overwhelming a message bus. Learn about an example that uses Kafka for claim-check generation.|Integration|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors. Kafka stores data for analysis.|Containers|
|[Extract actionable insights from IoT data](../industries/manufacturing/extract-insights-iot-data.yml)|Extract insights from IoT data by using Azure services. Kafka on HDInsight is one option for ingesting the data stream.|Serverless|
|[Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)|Create ETL pipelines for batch and streaming data with Azure Databricks to simplify data lake ingestion at any scale. Kafka is one option for ingesting data.|Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)|Learn how to ingest and analyze high volumes of IoT data and generate real-time recommendations and insights. In this solution, Kafka stores data for analysis.|Containers|
|[Integrate Event Hubs with Azure Functions](../serverless/event-hubs-functions/event-hubs-functions.yml)|Learn how to architect, develop, and deploy efficient and scalable code that runs on Azure Functions and responds to Azure Event Hubs events. Learn how events can be persisted in Kafka topics. |Serverless|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a variety of data sources, including Kafka.|Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation supports reporting on the Kafka partitioning strategies used. |Migration|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|Use Qlik Replicate to migrate mainframe and midrange systems to the cloud, or to extend such systems with cloud applications. In this solution, Kafka stores change log information that's used to replicate the data stores. |Mainframe|
|[Partitioning in Event Hubs and Kafka](../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)|Learn about partitioning in Kafka and Event Hubs for Kafka. Learn how many partitions to use in ingestion pipelines and how to assign events to partitions.|Analytics|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. A Kafka scaler is used to detect whether the solution needs to activate or deactivate application deployment.|Serverless|
|[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously. Kafka is recommended for messaging.|Integration|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)|Use a rate limiting pattern to avoid or minimize throttling errors. This pattern can implement Kafka for messaging.|Integration|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Kafka for message ingestion.|Databases|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs. Kafka can be used as a data source.|Mainframe|
|[Scalable order processing](../example-scenario/data/ecommerce-order-processing.yml)|Learn about a highly scalable, resilient architecture for e-commerce order processing. Event messages enter the system via Kafka and other systems.|Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|Analyze time series data like sensor data, stock prices, clickstream data, or app telemetry for historical trends, real-time alerts, or predictive modeling. Kafka for HDInsight can be used for data ingestion.|Databases|

#### Apache MapReduce

|Architecture|Summary|Technology focus|
|--|--|--|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)|Learn about asynchronous messaging options in Azure. You can use MapReduce to generate reports on events captured by Event Hubs.|Integration|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. You can use MapReduce for batch processing and to provide functionality for parallel operations in these scenarios.|Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Learn about technologies for big data batch processing in Azure, including HDInsight with MapReduce.|Analytics|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.|Analytics|
|[Geode pattern](../patterns/geodes.yml)|Deploy back-end services into a set of geographical nodes, each of which can service any client request in any region. This pattern occurs in big data architectures that use MapReduce to consolidate results across machines.|Databases|
|[Minimize coordination](../guide/design-principles/minimize-coordination.yml)|Follow these recommendations to improve scalability by minimizing coordination between application services. Use MapReduce to split work into independent tasks.|Databases|

#### Apache NiFi

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. This tool sends alerts and displays health and performance information in dashboards.|Analytics|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)|Automate data flows with Apache NiFi on Azure. Use a scalable, highly available solution to move data into the cloud or storage and between cloud systems.|Analytics|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)|Use Azure Data Explorer and NiFi in a hybrid monitoring solution that ingests streamed and batched logs from diverse sources.|Analytics|

#### Apache Oozie

|Architecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. Use Oozie to initiate data copy operations.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. You can use Oozie for orchestration in these scenarios.|Databases|
|[Choose a data pipeline orchestration technology](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)|Learn about the key orchestration capabilities of Oozie.|Databases|
|[Data warehousing in Azure](../data-guide/relational-data/data-warehousing.yml)|Learn about data warehousing in Azure. You can use Oozie for data orchestration in this solution. |Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Oozie to manage batch workflows for captured real-time data. |Databases|

#### Apache Solr

|Architecture|Summary|Technology focus|
|--|--|--|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs. Learn about the key capabilities of HDInsight with Solr.|Databases|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)|Learn how free-form text processing can support search by producing useful, actionable data from large amounts of text. You can use HDInsight with Solr to create a search index. |Databases|

#### Apache Spark

|Architecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](../industries/finance/actuarial-risk-analysis-financial-model.yml)|Learn how an actuarial developer can move an existing solution and its supporting infrastructure to Azure. Use Spark for data analysis or to speed up processing by distributing result aggregation.|Analytics|
|[Advanced analytics](../solution-ideas/articles/advanced-analytics-on-big-data.yml)|Learn how you can combine any data at any scale with custom machine learning and get near real-time data analytics on streaming services. Use Spark pools to clean and transform structureless datasets and combine them with structured data.|Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence. Use Spark to store data.|AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub. Use Spark to store data.|AI|
|[Analytics end-to-end with Azure Synapse](../example-scenario/dataplate2e/data-platform-end-to-end.yml)|Learn how to use Azure Data Services to build a modern analytics platform capable of handling the most common data challenges. The Spark Pools analytics engine is available from Azure Synapse workspaces. |Analytics|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. The Spark engine supports batch processing programs written in a range of languages.|Databases|
|[Batch scoring of Spark on Azure Databricks](../reference-architectures/ai/batch-scoring-databricks.yml)|Build a scalable solution for batch scoring an Apache Spark classification model.|AI|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)|Use confidential computing on Kubernetes to run big data analytics with Spark inside confidential containers that are protected by Intel Software Guard Extensions.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. You can use Spark for batch or stream processing and as an analytical data store.|Databases|
|[Build a content-based recommendation system](../example-scenario/ai/scalable-personalization-with-content-based-recommendation-system.yml)|Create content-based recommendation systems that can deliver personalized recommendations to your customers by using Spark, Azure Machine Learning, and Azure Databricks.|Analytics|
|[Build cloud-native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud-native applications with Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Cache for Redis. Analyze your data by using Azure Synapse, with natively integrated Spark for big data processing and machine learning.|Containers|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|Build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign.|Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure, including options for implementing Spark.|Analytics|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure, including options for implementing Spark.|Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure. Learn about the capabilities of Azure Synapse Spark pools.|Analytics|
|[Customer 360 with Azure Synapse and Dynamics 365 Customer Insights](../example-scenario/analytics/synapse-customer-insights.yml)|Build an end-to-end Customer 360 solution by using Azure Synapse Analytics and Dynamics 360 Customer Insights. This solution uses Azure Synapse Spark clusters, which can be scaled up and down automatically.|Analytics|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models. Azure Databricks provides managed Spark clusters.|AI|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about extract-transform-load (ETL) and extract-load-transform (ELT) data transformation pipelines and how to use control flows and data flows. In ELT, you can use Spark to query source data. You can also use it together with Hadoop as a data store.|Databases|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.|Analytics|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)|Build solutions that integrate data from many IoT devices into a comprehensive data analysis architecture to improve and automate decision making. Spark is used to run batch jobs that analyze the data.|Analytics|
|[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)|Learn how to use Azure Cosmos DB to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance. Azure Databricks, running Spark Streaming, processes event data from devices. |IoT|
|[Loan charge-off predictions with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off.|Databases|
|[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)|Learn about many models machine learning in Azure.|AI|
|[Microsoft machine learning products](../data-guide/technology-choices/data-science-and-machine-learning.md)|Compare options for building, deploying, and managing your machine learning models, including the Azure Databricks Spark-based analytics platform and MMLSpark. |AI|
|[Modern data warehouse for small and medium businesses](../example-scenario/data/small-medium-data-warehouse.yml)|Use Azure Synapse, Azure SQL Database, and Azure Data Lake Storage to modernize SMB legacy and on-premises data. Tools in the Azure Synapse workspace can use Spark compute capabilities to process data.|Analytics|
|[Natural language processing technology](../data-guide/technology-choices/natural-language-processing.yml)|Choose a natural language processing service for sentiment analysis, topic and language detection, key phrase extraction, and document categorization. Learn about the key capabilities of Azure HDInsight with Spark.|AI|
|[Observability patterns and metrics](../databricks-monitoring/databricks-observability.yml)|Learn how to use observability patterns and metrics to improve the processing performance of a big data system by using Azure Databricks. The Azure Databricks monitoring library streams Spark events and Spark Structured Streaming metrics from jobs.|Databases|
|[Real-time analytics on big data architecture](../solution-ideas/articles/real-time-analytics.yml)|Get deep-learning analytics and insights from live streaming data. Run advanced analytics on IoT device data and website clickstream logs in near real time. Apache Spark pools clean, transform, and analyze the streaming data and combine it with structured data.|Analytics|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Spark for an analytical data store and Spark Streaming for stream processing.|Analytics|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Spark, Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)|Ingest and process millions of streaming events per second by using Kafka, Storm, and Spark Streaming.|Databases|

#### Apache Sqoop

|Architecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting. Use Sqoop jobs to copy data.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. In these scenarios, you can use Sqoop to automate orchestration workflows.|Databases
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|Learn about data transfer options like Azure Import/Export, Data Box, and Sqoop.|Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Oozie and Sqoop to manage batch workflows for captured real-time data. |Databases|

#### Apache Storm

|Architecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence. Use Storm to store data.|AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub. Use Storm to store data.|AI|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems. In these scenarios, you can use Storm for stream processing.|Databases|
[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure, including HDInsight with Storm.|Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data. HDInsight makes it easy to process data from Storm.|Databases|
|[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)|Learn how to use Azure Cosmos DB to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance. In this architecture, you can use Storm on HDInsight for streaming analytics.|IoT|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. In this scenario, you can use Storm for stream processing.|Databases|

#### Apache ZooKeeper

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)|Automate data flows with NiFi on Azure. Use a scalable, highly available solution to move data into the cloud or storage and between cloud systems. In this solution, NiFi uses ZooKeeper to coordinate the flow of data.|Analytics|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications. In this architecture, ZooKeeper provides cluster coordination.|Analytics|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)|Use a rate limiting pattern to avoid or minimize throttling errors. In this scenario, you can use ZooKeeper to create a system that grants temporary leases to capacity. |Integration|

### BeeGFS

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure infrastructure as a service (IaaS) by following the architecture and design guidance in an example scenario. BeeGFS can be used for back-end storage.|Media|
|[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM. BeeGFS is used as an orchestrated parallel file service.|Compute|

### Chef

|Architecture|Summary|Technology focus|
|--|--|--|
|[Building blocks for autonomous-driving simulation environments](../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)|Simulate the behavior of autonomous-driving vehicles. Chef is used to create reusable images that serve as building blocks in the simulation.|Containers|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application. In this scenario, you can use Chef to implement infrastructure as code or infrastructure as a service.|DevOps
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. In this scenario, you can use Chef to implement infrastructure as code.|Management|

### CNCF

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](../hybrid/arc-hybrid-kubernetes.yml)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments. This architecture uses CNCF-certified Kubernetes clusters.|Hybrid|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Multi-cloud blockchain distributed ledger technology (DLT)](../example-scenario/blockchain/multi-cloud-blockchain.yml)|See how the open-source Blockchain Automation Framework (BAF) and Azure Arc-enabled Kubernetes work with multiparty DLTs to build a cross-cloud blockchain solution. This architecture uses CNCF-certified Kubernetes clusters.|Blockchain|

### Elastic

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to Elasticsearch deployments.|Containers|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure, including Elasticsearch.|Databases|
|[Elastic Workplace Search on Azure](../solution-ideas/articles/elastic-workplace-search.yml)|Learn how to deploy Elastic Workplace Search to streamline search for your documents and data.|Integration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS. In this architecture, you can use Elasticsearch for cluster monitoring.|Containers|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS, including using Elasticsearch.|Containers|
|[Monitoring and diagnostics guidance](../best-practices/monitoring.yml)|Learn about storing instrumentation data by using technologies like Elasticsearch.|Management|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)|Learn how free-form text processing can support search by producing useful, actionable data from large amounts of text. Includes information about using Elasticsearch to create a search index.|Databases|

### GlusterFS

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure IaaS by following the architecture and design guidance in an example scenario. GlusterFS can be used as a storage solution.|Media|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. GlusterFS is implemented for a highly available file share.|SAP|

### Grafana

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. Grafana is used to display data and send alerts.|Analytics|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, fast queries. Use Grafana to build near real-time analytics dashboards.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Grafana is a core component for providing monitoring and observability in this solution.|Migration|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. Grafana is recommended as a platform for logging and metrics.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF. Grafana provides a dashboard for application metrics.|Containers|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS. Grafana displays visualization of infrastructure and application metrics.|DevOps|
|[Content Delivery Network analytics](../solution-ideas/articles/content-delivery-network-azure-data-explorer.yml)|View an architecture pattern that demonstrates low-latency high-throughput ingestion for large volumes of Azure Content Delivery Network logs for building near real-time analytics dashboards. Grafana can be used to build the dashboards.|Analytics|
|[Enterprise monitoring with Azure Monitor](../example-scenario/monitoring/enterprise-monitoring.yml)|See an enterprise monitoring solution that uses Azure Monitor to collect and manage data from cloud, on-premises, and hybrid resources. Grafana can be used to build a dashboard for exploring and sharing the data.|DevOps|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices. Use Grafana to build analytics dashboards.|Analytics|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation supports use of Grafana for observability on solution components.|Migration|
|[Long-term security log retention with Azure Data Explorer](../example-scenario/security/security-log-retention-azure-data-explorer.yml)|Store security logs in Azure Data Explorer on a long-term basis. Minimize costs and easily access the data. Use Grafana to build near real-time analytics dashboards.|Analytics|
|[Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](../hybrid/azure-arc-sql-server.yml)|Learn how to use Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multi-cloud environments. Use Grafana dashboards for monitoring.|Databases|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Grafana provides monitoring.|SAP|
|[Web application monitoring on Azure](../reference-architectures/app-service-web-app/app-monitoring.yml)|Learn about the monitoring services you can use on Azure by reviewing a reference architecture that uses a dataflow model for use with multiple data sources. Use Azure Monitor Data Source for Grafana to consolidate Azure Monitor and Application Insights metrics.|Web|

### InfluxDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. MonitoFi uses local instances of InfluxDB to provide real-time monitoring and alerts. |Analytics|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS. Includes information about using InfluxDB for metrics when data rates trigger throttling.|Microservices|

### Jenkins

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to CI systems like Jenkins.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. A custom Jenkins-based solution is used for CI/CD.|Migration|
|[Building blocks for autonomous-driving simulation environments](../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)|Simulate the behavior of autonomous-driving vehicles. Jenkins can be used for CI/CD.|Compute|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application. This article focuses on Azure DevOps, but you can use Jenkins as an alternative.|DevOps|
|[DevTest Image Factory](../solution-ideas/articles/dev-test-image-factory.yml)|Create, maintain, and distribute custom images by using Image Factory, an automated image development and management solution in Azure DevTest Labs. Jenkins is used with GitHub for source code control.|DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. This article focuses on Azure DevOps, but you can use Jenkins as an alternative.|Management|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)|When you develop apps, use a continuous integration and continuous deployment (CI/CD) pipeline to automatically push changes to Azure virtual machines.|DevOps|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)|Create web apps in Azure App Service. Use the CI/CD pipeline to deliver value to customers faster.|DevOps|
|[MLOps for Python with Azure Machine Learning](../reference-architectures/ai/mlops-python.yml)|Implement a continuous integration (CI), continuous delivery (CD), and retraining pipeline for an AI application by using Azure DevOps and Azure Machine Learning. This solution can be easily adapted for Jenkins.|AI|
|[Run a Jenkins server on Azure](../example-scenario/apps/jenkins.yml)|Learn about the architecture and the considerations to take into account when you install and configure Jenkins.|DevOps|

### Jupyter

|Architecture|Summary|Technology focus|
|--|--|--|
[Automated Jupyter notebooks for diagnostics](../example-scenario/data/automating-diagnostic-jupyter-notebook.yml)|Learn how to automate diagnostic or routine notebooks by using an Azure serverless architecture.|DevOps|
[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, fast queries. Jupyter Notebook is used to connect to Azure Data Explorer. |Analytics|
[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)|Learn how to choose the best services for building an end-to-end machine learning pipeline. Includes information about using Jupyter Notebook for the experimentation phase.|AI|
[Choose a data analytics and reporting technology](../data-guide/technology-choices/analysis-visualizations-reporting.md)|Evaluate big-data analytics technology options for Azure, including Jupyter Notebook.|Databases|
[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to use Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and production version. Azure Machine Learning provides a hosted Jupyter Notebook environment. |AI|
[Data analysis in an Azure industrial IoT analytics solution](../guide/iiot-guidance/iiot-data.yml)|View an Azure industrial IoT (IIoT) analytics solution. Use visualization, data trends, dashboards, schematic views, and Jupyter Notebook.|IoT|
[DevOps for quantum computing](../guide/quantum/devops-for-quantum-computing.yml)|Learn about DevOps requirements for quantum-based apps. You can use Jupyter Notebook to develop quantum components.|DevOps|
[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices. Analyze data that's stored in Azure Data Explorer by using Jupyter Notebook.|Analytics|
[Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../example-scenario/mlops/mlops-technical-paper.yml)|Learn how to apply the MLOps maturity model to implement a machine learning solution for predicting product shipping levels. Initial experimental models are developed in Jupyter Notebook. |AI|
[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)|Learn about many models machine learning in Azure. Azure Machine Learning provides a hosted Jupyter Notebook environment.|AI|
[Precision medicine pipeline with genomics](../example-scenario/precision-medicine/genomic-analysis-reporting.yml)|Build a precision medicine pipeline for genomic analysis and reporting. Use Microsoft Genomics for efficient secondary and tertiary analysis. Jupyter Notebook is used to annotate Microsoft Genomics output, merge output files with other data, and analyze data.|Analytics|
[Tune hyperparameters for machine learning models in Python](../reference-architectures/ai/training-python-models.yml)|Learn recommended practices for tuning hyperparameters (training parameters) of scikit-learn and deep-learning machine learning models in Python. A Jupyter widget is used to monitor the progress of hyperparameter tuning runs.|AI|

### KEDA

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Functions in a hybrid environment](../hybrid/azure-functions-hybrid.yml)|View an architecture that illustrates how to use Azure Functions from on-premises virtual machines. KEDA provides event-driven scale in Kubernetes clusters.|Serverless|
|[AKS in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)|View a serverless event-driven architecture that runs on AKS with a KEDA scaler. The solution ingests and processes a stream of data and writes the results to a database.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. KEDA is used to scale a service that processes funds transfers. |Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. In this scenario, you can use KEDA to scale event-driven workloads.|Containers|
|[Integrate Event Hubs with Azure Functions](../serverless/event-hubs-functions/event-hubs-functions.yml)|Learn how to architect, develop, and deploy efficient and scalable code that runs on Azure Functions and responds to Azure Event Hubs events. KEDA scaler for Event Hubs can be used for Kubernetes hosted apps.|Serverless|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. Includes an architecture for KEDA scaling. |Serverless|

### Kubernetes

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable, highly secure  Azure Kubernetes Service (AKS) microservices architecture that builds on recommended AKS microservices baseline architectures and implementations.|Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](../hybrid/arc-hybrid-kubernetes.yml)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments.|Hybrid|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)|View a serverless event-driven architecture that runs on AKS with a KEDA scaler. The solution ingests and processes a stream of data and writes the results to a database.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. The solution uses Kubernetes clusters.|Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)|Use confidential computing on Kubernetes to run big data analytics with Spark inside confidential containers that are protected by Intel Software Guard Extensions.|Analytics|
|[Build a CI/CD pipeline for microservices on Kubernetes](../microservices/ci-cd-kubernetes.yml)|Learn about building a CI/CD pipeline for deploying microservices to AKS.|Microservices|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Choose a bare-metal Kubernetes-at-the-edge platform option](../operator-guides/aks/choose-bare-metal-kubernetes.yml)|Find the best option for configuring Kubernetes clusters at the edge.|Containers|
|[Choose a Kubernetes-at-the-edge compute option](../operator-guides/aks/choose-kubernetes-edge-compute-option.md)|Learn about trade-offs for various options that are available for extending compute on the edge.|Containers|
|[Choose an Azure multiparty computing service](../guide/technology-choices/multiparty-computing-service.yml)|Decide which multiparty computing services to use for your solution. Includes information about using Kubernetes to manage containers.|Blockchain|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Container orchestration for microservices](../microservices/design/orchestration.yml)|Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health. Review options for microservices container orchestration, including AKS.|Microservices|
|[Create a CI/CD pipeline for AI apps using Azure Pipelines, Docker, and Kubernetes](../data-science-process/ci-cd-flask.yml)|Create a continuous integration and continuous delivery pipeline for AI applications by using Docker and Kubernetes.|AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)|Learn how to use Kubernetes to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications.|Analytics|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)|See a GitOps solution for an AKS cluster. This solution provides full audit capabilities, policy enforcement, and early feedback.|Containers|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)|Learn how to ingest and analyze high volumes of IoT data and generate real-time recommendations and insights.|Containers|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS.|Containers|
|[Microservices with AKS and Azure DevOps](../solution-ideas/articles/microservices-with-aks.yml)|Learn how AKS simplifies the deployment and management of microservices-based architecture.|Containers|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud. Includes an architecture for Kubernetes Event-driven Autoscaler (KEDA) scaling.|Serverless|
|[High security DevOps for AKS](../solution-ideas/articles/secure-devops-for-kubernetes.yml)|Implement DevOps with Kubernetes on Azure to balance speed and security and to deliver code faster.|Containers|
|[Use Application Gateway Ingress Controller with a multitenant AKS cluster](../example-scenario/aks-agic/aks-agic.yml)|Learn how to use the Application Gateway Ingress Controller with your AKS cluster to expose microservice-based applications to the internet.|Containers|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)|Deploy an AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Help protect the inbound and outbound traffic by using Azure Firewall.|Containers|

### Lustre

|Architecture|Summary|Technology focus|
|--|--|--|
[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure IaaS by following the architecture and design guidance in an example scenario. Lustre can be used as a storage solution.|Media|
[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM. Lustre is used as an orchestrated parallel file service.|Compute|
[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. In this scenario, Lustre is a recommended option for permanent storage.|Compute|

### MariaDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Core startup stack architecture](../example-scenario/startups/core-startup-stack.yml)|Review the components of a simple core startup stack architecture. Azure Database for MariaDB is one recommended relational database.|Startup|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|Use Qlik Replicate to migrate mainframe and midrange systems to the cloud, or to extend such systems with cloud applications. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. Store data in Azure Database for MariaDB.|Mainframe|
|[Modernize mainframe and midrange data](../reference-architectures/migration/modernize-mainframe-data-to-azure.yml)|Learn how to modernize IBM mainframe and midrange data and see how to use a data-first approach to migrate this data to Azure. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Replicate and sync mainframe data in Azure](../reference-architectures/migration/sync-mainframe-data-with-azure.yml)|Replicate data while modernizing mainframe and midrange systems. Sync on-premises data with Azure data during modernization. Azure Database for MariaDB is one recommended relational database.|Mainframe|
|[Scalable and secure WordPress on Azure](../example-scenario/infrastructure/wordpress.yml)|Learn how to use Content Delivery Network and other Azure services to deploy a highly scalable and highly secure installation of WordPress. In this scenario, MariaDB is used as a data store.|Web|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for MariaDB is one example of a relational database.|Databases|

### MLflow

|Architecture|Summary|Technology focus|
|--|--|--|
|[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)|Learn how to choose the best services for building an end-to-end machine learning pipeline, from experimentation to deployment. Includes information about using MLflow for tracking and versioning.|AI|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models.|AI|
|[Determine customer lifetime value and churn with Azure AI services](../example-scenario/ai/customer-lifecycle-churn.yml)|Learn how to create a solution for predicting customer lifetime value and churn by using Azure Machine Learning. The solution demonstrates how to use MLflow to track machine learning experiments.|AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)|Learn how to use Kubernetes to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications. Includes a proof-of-concept that illustrates how to train an MLflow model for employee attrition on Azure Databricks.|Analytics|
|[Modern analytics architecture with Azure Databricks](../solution-ideas/articles/azure-databricks-modern-analytics-architecture.yml)|Create a modern analytics architecture with Azure Databricks, Data Lake Storage, and other Azure services. Unify data, analytics, and AI workloads at any scale. MLflow manages parameter, metric, and machine learning model tracking.|Analytics|
|[Orchestrate MLOps on Azure Databricks using Databricks notebooks](../reference-architectures/ai/orchestrate-mlops-azure-databricks.yml)|Learn about an approach to MLOps that involves running model training and batch scoring on Azure Databricks by using Azure Databricks notebooks for orchestration. MLflow manages the machine learning lifecycle.|AI|
|[Population health management for healthcare](../solution-ideas/articles/population-health-management-for-healthcare.yml)|Use population health management to improve clinical and health outcomes and reduce costs. The Azure Machine Learning native support for MLflow is used to log experiments, store models, and deploy models.|AI|

### Moodle

|Architecture|Summary|Technology focus|
|--|--|--|
[Moodle deployment with Azure NetApp Files](../example-scenario/file-storage/moodle-azure-netapp-files.yml)|Deploy Moodle with Azure NetApp Files for a resilient solution that offers high-throughput, low-latency access to scalable shared storage.|Storage|

### MySQL

|Architecture|Summary|Technology focus|
|--|--|--|
[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run MySQL database workloads.|Containers|
[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS. MySQL is used to store expense reports.|Containers|
[Build web and mobile applications with MySQL and Redis](../solution-ideas/articles/webapps.yml)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution, inspired by PayMe, for e-commerce platforms and more.|Web|
|[Digital marketing using Azure Database for MySQL](../solution-ideas/articles/digital-marketing-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to engage with customers around the world with personalized digital marketing experiences.|Databases|
|[Finance management apps with Azure Database for MySQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to store critical data with high security and provide users with high-value analytics and insights on aggregated data.|Databases|
| [Gaming using Azure Database for MySQL](../solution-ideas/articles/gaming-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL for gaming solutions so that databases scale elastically during traffic bursts and deliver low-latency multi-player experiences.|Databases|
|[IBM z/OS online transaction processing on Azure](../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml)|Migrate a z/OS online transaction processing (OLTP) workload to an Azure application that's cost-effective, responsive, scalable, and adaptable. The data layer can include Azure implementations of MySQL databases.|Mainframe|
|[Intelligent apps using Azure Database for MySQL](../solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)|Use App Service to create web apps backed by Azure Database for MySQL. Use the CI/CD pipeline to deliver value to customers faster.|DevOps|
|[Lift and shift to containers with AKS](../solution-ideas/articles/migrate-existing-applications-with-aks.yml)|Migrate existing applications to containers in AKS. Use Open Service Broker for Azure to access databases like Azure Database for MySQL.|Containers|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. Store data in Azure Database for MySQL.|Mainframe|
|[Microservices with AKS](../solution-ideas/articles/microservices-with-aks.yml)|Learn how AKS simplifies the deployment and management of microservices-based architecture. Use Azure Database for MySQL to store and retrieve information used by the microservices.|Containers|
|[Online transaction processing (OLTP)](../data-guide/relational-data/online-transaction-processing.md)|Learn about atomicity, consistency, and other features of OLTP, which manages transactional data and supports querying. Azure Database for MySQL is one Azure data store that meets the requirements for OLTP.|Databases|
|[Retail and e-commerce using Azure Database for MySQL](../solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to build highly secure, scalable e-commerce solutions that meet customer and business demands.|Databases|
|[Scalable apps using Azure Database for MySQL](../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Security considerations for highly sensitive IaaS apps in Azure](../reference-architectures/n-tier/high-security-iaas.yml)|Learn about VM security, encryption, NSGs, perimeter networks (also known as DMZs), access control, and other security considerations for highly sensitive IaaS and hybrid apps. A common replication scenario for IaaS architectures uses MySQL Replication. |Security|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, MySQL, and Redis components.|Analytics|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for MySQL is one example of a relational database.|Databases|

### PostgreSQL

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run PostgreSQL database workloads.|Containers|
|[Azure Database for PostgreSQL intelligent apps](../solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Build a telehealth system on Azure](../example-scenario/apps/telehealth-system.yml)|Learn how to build a telehealth system that connects a professional healthcare organization to its remote patients. Azure Database for PostgreSQL stores user and device-related data.|Databases|
|[Build cloud-native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud-native applications with Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Cache for Redis.|Containers|
|[Data cache](../solution-ideas/articles/data-cache-with-redis-cache.yml)|Store and share database query results, session states, static contents, and more by using a common cache-aside pattern. This solution works with data stored in Azure Database for PostgreSQL and other databases.|Databases|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors. Processed data is stored in Azure Database for PostgreSQL.|Containers|
|[Digital campaign management](../solution-ideas/articles/digital-marketing-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to engage with customers around the world with personalized digital marketing experiences.|Databases|
|[Finance management apps using Azure Database for PostgreSQL](../solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to store critical data with high security and provide users with high-value analytics and insights on aggregated data.|Databases|
|[Geospatial data processing and analytics](../example-scenario/data/geospatial-data-processing-analytics-azure.yml)|Collect, process, and store geospatial data by using managed Azure services. Make the data available through web apps. Visualize, explore, and analyze the data. In this solution, Azure Database for PostgreSQL stores GIS data.|Analytics|
|[IBM z/OS online transaction processing on Azure](../example-scenario/mainframe/ibm-zos-online-transaction-processing-azure.yml)|Migrate a z/OS OLTP workload to an Azure application that's cost-effective, responsive, scalable, and adaptable. The data layer can include Azure Database for PostgreSQL.|Mainframe|
|[Integrate IBM mainframe and midrange message queues with Azure](../example-scenario/mainframe/integrate-ibm-message-queues-azure.yml)|Learn about a data-first approach to middleware integration that enables IBM message queues. This approach supports Azure Database for PostgreSQL.|Mainframe|
|[Mainframe file replication and sync on Azure](../solution-ideas/articles/mainframe-azure-file-replication.yml)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure. PostgreSQL is the main database for a common AIML use case. |Mainframe|
|[Online transaction processing (OLTP)](../data-guide/relational-data/online-transaction-processing.md)|Learn about atomicity, consistency, and other features of OLTP, which manages transactional data and supports querying. Azure Database for PostgreSQL is one Azure data store that meets the requirements for OLTP.|Databases|
|[Oracle database migration: Refactor](../example-scenario/oracle-migrate/oracle-migration-refactor.yml)|Refactor your Oracle database by using Azure Database Migration Service, and move it to PostgreSQL.|Migration|
|[Overview of Oracle database migration](../example-scenario/oracle-migrate/oracle-migration-overview.yml)|Learn about Oracle database migration paths and the methods you can use to migrate your schema to SQL or PostgreSQL.|Migration|
|[Retail and e-commerce using Azure Database for PostgreSQL](../solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to build highly secure and scalable e-commerce solutions that meet customer and business demands.|Databases|
|[Scalable apps using Azure Database for PostgreSQL](../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-postgresql.yml)|Use Azure Database for PostgreSQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Understand data store models](../guide/technology-choices/data-store-overview.md)|Learn about the high-level differences between the various data storage models found in Azure data services. Azure Database for PostgreSQL is one example of a relational database.|Databases|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](../example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure.yml)|Learn an approach for rehosting mainframe legacy applications in Azure by using the LzLabs SDM platform. This architecture uses PostgreSQL IaaS. |Mainframe|

### Prometheus

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. Astra Trident provides a rich set of Prometheus metrics that you can use to monitor provisioned storage.|Containers|
|[Architecture of an AKS regulated cluster for PCI-DSS 3.2.1](../reference-architectures/containers/aks-pci/aks-pci-ra-code-assets.yml)|Learn about an architecture for an AKS cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard. Prometheus metrics are used in monitoring.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Prometheus is a core component for monitoring test results.|Migration|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster. Azure Monitor, the recommended monitoring tool, can be used to visualize Prometheus metrics.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF. Prometheus captures application metrics. |Containers|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation supports use of Prometheus for observability on solution components. |Migration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS. Prometheus can be used for cluster monitoring.|Containers|
|[Monitor a microservices app in AKS](../microservices/logging-monitoring.yml)|Learn best practices for monitoring a microservices application that runs on AKS. Includes information about using Prometheus for metrics when data rates trigger throttling.|Containers|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Prometheus provides monitoring. |SAP|

### PyTorch

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run AI and machine learning components like PyTorch.|Containers|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Azure Databricks uses pre-installed, optimized machine learning frameworks, including PyTorch. |AI|
|[Machine learning in IoT Edge vision](../guide/iot-edge-vision/machine-learning.yml)|Learn about machine learning data and models in Azure IoT Edge vision AI solutions. Includes information about PyTorch.|IoT|
|[Real-time scoring of machine learning models](../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)|Deploy Python machine learning models as web services to make real-time predictions by using Azure Machine Learning and AKS. Learn about an image classification scenario that uses PyTorch.|AI|

### RabbitMQ

|Architecture|Summary|Technology focus|
|--|--|--|
[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes a reference architecture and several published open-source libraries that you can reuse. RabbitMQ is used as a message broker. |Web|
[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously. RabbitMQ is recommended for messaging.|Integration|

### Red Hat

|Architecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](../example-scenario/unix-migration/migrate-aix-azure-linux.yml)|Migrate an on-premises IBM AIX system and web application to a highly available, highly secure Red Hat Enterprise Linux solution in Azure.|Mainframe|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Azure Red Hat OpenShift is used for autoscaling tests. |Containers|
|[Container orchestration for microservices](../microservices/design/orchestration.yml)|Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health. Review options for microservices container orchestration, including Azure Red Hat OpenShift.|Microservices|
|[JBoss deployment with Red Hat on Azure](../solution-ideas/articles/jboss-deployment-red-hat.yml)|Learn how the Red Hat JBoss Enterprise Application Platform (JBoss EAP) streamlines and simplifies the development and deployment of a range of applications.|Containers|
|[Run a Linux VM on Azure](../reference-architectures/n-tier/linux-vm.yml)|Learn best practices for running a Linux virtual machine on Azure. Azure supports many popular Linux distributions, including Red Hat Enterprise.|Compute|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high-availability, scale-up environment that supports disaster recovery. Use Red Hat Enterprise Linux in multi-node configurations. For high availability, use a Pacemaker cluster on Red Hat Enterprise Linux. |SAP|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Learn proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. Red Hat Enterprise Linux is used for a high availability SAP Central Services cluster.|SAP|
|[SAS on Azure](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. SAS supports Red Hat 7 and later.|Compute|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](../example-scenario/finance/swift-alliance-messaging-hub.yml)|Run SWIFT AMH on Azure. This messaging solution helps financial institutions securely and efficiently bring new services to market. A key component, the AMH node, runs on JBoss Enterprise Application Platform (EAP) on Red Hat Enterprise Linux. |Networking|
|[SWIFT\'s AMH with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. Use this messaging solution with the Alliance Connect Virtual networking solution, which also runs on Azure. A key component, the AMH node, runs on JBoss EAP on Red Hat Enterprise Linux. |Networking|

### Redis

|Architecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Azure Cache for Redis is used in a Publish-Subscribe messaging pattern for bank transactions. |Containers|
|[Build cloud-native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud-native applications with Azure Cosmos DB, Azure Database for PostgreSQL, and Azure Cache for Redis.|Containers|
|[Build web and mobile applications with MySQL and Redis](../solution-ideas/articles/webapps.yml)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution, inspired by PayMe, for e-commerce platforms and more.|Web|
|[COVID-19 safe solutions with IoT Edge](../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)|Create a COVID-19 safe environment that monitors social distance, mask/PPE use, and occupancy requirements with CCTVs and Azure IoT Edge, Azure Stream Analytics, and Azure Machine Learning. Redis is used to store cloud data for analytics and visualization.|IoT|
|[Data cache](../solution-ideas/articles/data-cache-with-redis-cache.yml)| Azure Cache for Redis provides a cost-effective solution to scale read and write throughput of your data tier. Store and share database query results, session states, static contents, and more by using a common cache-aside pattern.|Databases|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors. Azure Cache for Redis is used to cache processed data.|Containers|
|[DevTest and DevOps for PaaS solutions](../solution-ideas/articles/dev-test-paas.yml)|Combine Azure platform as a service (PaaS) resources with DevTest and DevOps practices to support rapid iteration cycles and reduced overhead. Azure Cache for Redis provides an in-memory data store that's provisioned by Terraform.|DevOps|
|[Digital marketing using Azure Database for MySQL](../solution-ideas/articles/digital-marketing-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL and Azure Cache for Redis to engage with customers around the world with personalized digital marketing experiences.|Databases|
|[Messaging](../solution-ideas/articles/messaging.yml)|Learn how Azure Cache for Redis routes real-time messages in publish and subscribe systems.|Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements. Azure Cache for Redis can be used to store key-value pairs.|Databases|
|[Personalized offers](../solution-ideas/articles/personalized-offers.yml)|Build intelligent marketing systems that provide customer-tailored content by using machine learning models that analyze data from multiple sources. Azure Cache for Redis is used to provide pre-computed product affinities for customers.|AI|
|[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously. In this pattern, Redis can be used for messaging.|Integration|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)|Use a rate limiting pattern to avoid or minimize throttling errors. In this scenario, you can use Redis/Redsync to create a system that grants temporary leases to capacity.|Integration|
|[Re-engineer mainframe batch applications on Azure](../example-scenario/mainframe/reengineer-mainframe-batch-apps-azure.yml)|Use Azure services to re-engineer mainframe batch applications. This architecture change can reduce costs and improve scalability. You can use Azure Cache for Redis to speed up a re-engineered application.|Mainframe|
|[Scalable Sitecore marketing website](../solution-ideas/articles/digital-marketing-sitecore.yml)|Learn how the Sitecore Experience Platform (XP) provides the data, integrated tools, and automation you need to engage customers throughout an iterative lifecycle. In this solution, Sitecore's session state is managed by Azure Cache for Redis.|Web|
|[Scalable web apps with Azure Redis Cache](../solution-ideas/articles/scalable-web-apps.yml)|Improve app performance by using Azure Cache for Redis to improve responsiveness and handle increasing loads with fewer web-compute resources.|Web|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml)|Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application. Semi-static data is stored in Azure Cache for Redis.|Web|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|

### SUSE

|Architecture|Summary|Technology focus|
|--|--|--|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high availability, small-scale production environment of SAP BW/4HANA on Azure. Azure is certified to run SAP BW/4HANA on SUSE Linux Enterprise.|SAP|
|[SAP deployment in Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability. In this architecture, SUSE SBD can be used as part of a mechanism to automate failovers. |SAP|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability, scale-up environment that supports disaster recovery on Azure. For high availability, use a Pacemaker cluster on SUSE Linux Enterprise Server. |SAP|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability. SUSE Linux Enterprise Server is used for a high availability SAP Central Services cluster.|SAP|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation.|SAP|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. SAS supports SUSE Linux Enterprise Server (SLES) 12.2.|Compute|

### TensorFlow

|Architecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run AI and machine learning components like TensorFlow.|Containers|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models. Azure Databricks uses pre-installed, optimized machine learning frameworks, including TensorFlow.|AI|
|[Distributed training, deep learning models](../reference-architectures/ai/training-deep-learning.yml)|Learn how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs. In this scenario, TensorFlow is used to train a CNN model.|AI|
|[Machine learning in IoT Edge vision](../guide/iot-edge-vision/machine-learning.yml)|Learn about machine learning data and models in Azure IoT Edge vision AI solutions. Includes information about TensorFlow.|IoT|
|[Real-time scoring of machine learning models](../reference-architectures/ai/real-time-scoring-machine-learning-models.yml)|Deploy Python machine learning models as web services to make real-time predictions by using Azure Machine Learning and AKS. Learn about an image classification scenario that uses TensorFlow.|AI|
|[Vision classifier model with Azure Cognitive Services Custom Vision](../example-scenario/dronerescue/vision-classifier-model-with-custom-vision.yml)|Create an image classifier with a solution architecture that includes Microsoft AirSim Drones simulator, Azure Cognitive Services Custom Vision, and TensorFlow.|AI|

### Terraform

|Architecture|Summary|Technology focus|
|--|--|--|
|[Architectural approaches for the deployment and configuration of multitenant solutions](../guide/multitenant/approaches/deployment-configuration.yml)|Learn about approaches to consider when you deploy and configure a multitenant solution. Terraform is recommended for automation.|Multitenancy|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes a reference architecture and several published open-source libraries that you can reuse. Terraform is used to deploy Azure instances. |Web|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Terraform is used for load testing.|Migration|
|[Deployment Stamps pattern](../patterns/deployment-stamp.yml)|Learn about the Deployment Stamps pattern, which deploys many independent copies of application components. Terraform is recommended for deployment.|Networking|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application. In this architecture, Terraform can be used for deployment.|DevOps|
|[DevOps in a hybrid environment](../solution-ideas/articles/devops-in-a-hybrid-environment.yml)|Learn about an implementation of DevOps that manages cloud and on-premises environments in tandem. Terraform is used to manage infrastructure as code.|DevOps|
|[DevSecOps in Azure](../solution-ideas/articles/devsecops-in-azure.yml)|Learn about DevSecOps, a solution that incorporates security best practices from the beginning of development. Terraform is used to manage infrastructure as code.|DevOps|
|[DevTest and DevOps for PaaS solutions](../solution-ideas/articles/dev-test-paas.yml)|Combine Azure PaaS resources with DevTest and DevOps practices to support rapid iteration cycles and reduced overhead. Terraform provisions and modifies resources for the environments.|DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code. The scenario described uses Terraform for infrastructure as code.|Management|
|[Gridwich cloud media system](../reference-architectures/media-services/gridwich-architecture.yml)|Learn about a stateless action execution workflow that ingests, processes, and delivers media assets using Terraform Sandwiches and Event Grid Sandwiches.|Media|
|[Gridwich CI/CD pipeline](../reference-architectures/media-services/gridwich-cicd.yml)|Learn about the guiding principles and considerations for the Gridwich continuous CD/CD pipeline, including information about Terraform.|Media|
|[Gridwich keys and secrets management](../reference-architectures/media-services/maintain-keys.yml)|Learn about the two types of keys Gridwich uses, and logic apps that add, change, or rotate the keys. Terraform is used in an app that rotates or adds third-party keys.|Media|
|[Gridwich Media Services setup and scaling](../reference-architectures/media-services/media-services-setup-scale.yml)|Learn how Gridwich uses Azure Media Services V2 and V3 APIs to set up authentication and authorization, and how to scale Media Services resources for media processing. A Terraform file is used in the authentication and authorization process.|Media|
|[Gridwich pipeline-generated admin scripts](../reference-architectures/media-services/run-admin-scripts.yml)|Learn about Gridwich pipeline-generated admin scripts and how to run them. The pipelines use Terraform to generate and publish the scripts. |Media
|[Gridwich variable flow](../reference-architectures/media-services/variable-group-terraform-flow.yml)|Learn how Gridwich converts Azure Pipelines pipeline variable group variables to Terraform variables.|Media|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)|When you develop apps, use a continuous integration and continuous deployment (CI/CD) pipeline to automatically push changes to Azure virtual machines.|DevOps|
|[JMeter implementation for a load-testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline. The implementation uses JMeter and Terraform to provision and remove the required infrastructure.|Migration|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation. Terraform is used to deploy the SAP infrastructure into Azure.|SAP|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)|Deploy an AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Help protect inbound and outbound traffic by using Azure Firewall.|Containers|
|[Virtual network integrated serverless microservices](../example-scenario/integrated-multiservices/virtual-network-integration.yml)|Learn about an end-to-end solution for health records management that uses Azure Functions microservices integrated with other services via a virtual network. Terrraform automates all code and infrastructure deployments.|Security|

### Umbraco

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital marketing using Azure Database for MySQL](../solution-ideas/articles/digital-marketing-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to engage with customers around the world with personalized digital marketing experiences. Azure App Service supports Umbraco.|Databases|
|[Scalable Umbraco CMS web app](../solution-ideas/articles/medium-umbraco-web-app.yml)|Run an Umbraco content management system on the Web Apps feature of App Service. Use Azure managed services for a high availability environment.|Web|
|[Simple digital marketing website](../solution-ideas/articles/digital-marketing-smb.yml)|Use an Azure-based content management system to easily maintain messaging on your website in real time, from a browser, with no coding skills. Umbraco manages content and deploys it to the website.|Web|

### WordPress

|Architecture|Summary|Technology focus|
|--|--|--|
|[Digital marketing using Azure Database for MySQL](../solution-ideas/articles/digital-marketing-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL to engage with customers around the world with personalized digital marketing experiences. This solution uses Azure App Service, which supports WordPress.|Databases|
|[Scalable and secure WordPress on Azure](../example-scenario/infrastructure/wordpress.yml)|Learn how to use Azure Content Delivery Network and other Azure services to deploy a highly scalable and highly secure installation of WordPress.|Web|

## Scenarios featuring third-party technologies on Azure

### Advanced

|Architecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs.|Mainframe|

### Asysco

|Architecture|Summary|Technology focus|
|--|--|--|
|[IBM z/OS mainframe migration with Asysco](../example-scenario/mainframe/asysco-zos-migration.yml)|Learn how to use the Asysco Automated Migration Technology (AMT) framework to migrate IBM z/OS mainframe workloads to Azure.|Mainframe|
|[Unisys mainframe migration with Asysco](../reference-architectures/migration/unisys-mainframe-migration.yml)|Learn options for using the AMT framework to migrate Unisys mainframe workloads to Azure.|Mainframe|

### Astadia

|Architecture|Summary|Technology focus|
|--|--|--|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](../example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus.yml)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|

### CluedIn

|Architecture|Summary|Technology focus|
|--|--|--|
|[Master Data Management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations.|Databases|
|[Migrate master data services to Azure with CluedIn and Azure Purview](../reference-architectures/data/migrate-master-data-services-with-cluedin.yml)|Use CluedIn to migrate your master data services solution to Azure by using CluedIn and Azure Purview.|Databases|

### Confluent

|Architecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance. Kafka is used with Confluent Schema Registry for streaming.|Migration|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency. Kafka, which is available via ConfluentCloud, is recommended for real-time message ingestion.  |Databases|

### Couchbase

|Architecture|Summary|Technology focus|
|--|--|--|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multi-access edge compute. Couchbase can provide IaaS services that support geo-replication.|Hybrid|

### Double-Take

|Architecture|Summary|Technology focus|
|--|--|--|
|[SMB disaster recovery with Azure Site Recovery](../solution-ideas/articles/disaster-recovery-smb-azure-site-recovery.yml)|Learn how small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using Azure Site Recovery or Double-Take DR.|Management|
|[SMB disaster recovery with Double-Take DR](../solution-ideas/articles/disaster-recovery-smb-double-take-dr.yml)|Learn how small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using a partner solution like Double-Take DR.|Management|

### Episerver

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable Episerver marketing website](../solution-ideas/articles/digital-marketing-episerver.yml)|Run multi-channel digital marketing websites on one platform. Start and stop campaigns on demand. Manage site and campaign performance by using Episerver.|Web|

### Gremlin

|Architecture|Summary|Technology focus|
|--|--|--|
|[Build web and mobile applications](../solution-ideas/articles/webapps.yml)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution, inspired by PayMe, for e-commerce platforms and more. The Gremlin API is used to store graphical data in Azure Cosmos DB.|Web|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use technologies like Kafka, Kubernetes, Gremlin, PostgreSQL, and Redis components.|Analytics|

### Infinite i

|Architecture|Summary|Technology focus|
|--|--|--|
|[IBM System i (AS/400) to Azure using Infinite i](../example-scenario/mainframe/ibm-system-i-azure-infinite-i.yml)|Use Infinite i to easily migrate your IBM System i (AS/400) workloads to Azure. You can lower costs, improve performance, improve availability, and modernize.|Mainframe|

### LzLabs

|Architecture|Summary|Technology focus|
|--|--|--|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](../example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure.yml)|Learn an approach for rehosting mainframe legacy applications in Azure by using the LzLabs SDM platform.|Mainframe|

### Micro Focus

|Architecture|Summary|Technology focus|
|--|--|--|
|[Micro Focus Enterprise Server on Azure VMs](../example-scenario/mainframe/micro-focus-server.yml)|Optimize, modernize, and streamline IBM z/OS mainframe applications by using Micro Focus Enterprise Server 6.0 on Azure VMs.|Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](../example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus.yml)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|


### MongoDB

|Architecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable, highly secure AKS microservices architecture that builds on recommended AKS microservices baseline architectures and implementations. In this architecture, Azure Cosmos DB stores data by using the open-source Azure Cosmos DB API for MongoDB. |Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications. This solution applies to systems that run MongoDB database workloads.|Containers|
|[Core startup stack architecture](../example-scenario/startups/core-startup-stack.yml)|Review the components of a simple core startup stack architecture. MongoDB is recommended for uses cases that require a NoSQL database.|Startup|
|[COVID-19 safe solutions with IoT Edge](../solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection.yml)|Create a COVID-19 safe environment that monitors social distance, mask/PPE use, and occupancy requirements with CCTVs and IoT Edge, Stream Analytics, and Azure Machine Learning. MongoDB is used to store cloud data for Power BI analytics and visualizations.|IoT|
|[Data considerations for microservices](../microservices/design/data-considerations.yml)|Learn about managing data in a microservices architecture. The MongoDB API is used with Azure Cosmos DB in an example scenario.|Microservices|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multiaccess edge compute. MongoDB can provide IaaS services that support geo-replication.|Hybrid|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml)|Use the proven practices in this reference architecture to improve scalability and performance in an App Service web application. MongoDB is recommended for non-relational data. |Web|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, MongoDB, PostgreSQL, and Redis components.|Analytics|
|[Virtual network integrated serverless microservices](../example-scenario/integrated-multiservices/virtual-network-integration.yml)|Learn about an end-to-end solution for health records management that uses Azure Functions microservices integrated with other services via a virtual network. In this solution, microservices store data in Azure Cosmos DB, using the MongoDB Node.js driver.|Security|

### NetApp

|Architecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](../example-scenario/unix-migration/migrate-aix-azure-linux.yml)|Migrate an on-premises IBM AIX system and web application to a highly available, highly secure Red Hat Enterprise Linux solution in Azure. Azure NetApp Files provides shared NAS.|Mainframe|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Storage|
|[SAP workload development and test settings](../example-scenario/apps/sap-dev-test.yml)|Learn how to establish non-production development and test environments for SAP NetWeaver in a Windows or Linux environment on Azure. Azure NetApp Files is recommended for storage of SAP executables and HANA data and logs.|SAP|
|[Enterprise file shares with disaster recovery](../example-scenario/file-storage/enterprise-file-shares-disaster-recovery.yml)|Learn how to implement resilient NetApp file shares. Failure of the primary Azure region causes automatic failover to the secondary Azure region.|Storage|
|[FSLogix for the enterprise](../example-scenario/wvd/windows-virtual-desktop-fslogix.yml)|Learn how to build virtual desktop infrastructure solutions at enterprise scale by using FSLogix. Azure NetApp Files is recommended for storing profiles.  |Hybrid|
|[General mainframe refactor to Azure](../example-scenario/mainframe/general-mainframe-refactor.yml)|Learn how to refactor mainframe applications to run more cost-effectively and efficiently on Azure. Azure NetApp Files is recommended for file storage. |Mainframe|
|[Moodle deployment with Azure NetApp Files](../example-scenario/file-storage/moodle-azure-netapp-files.yml)|Deploy Moodle with Azure NetApp Files for a resilient solution that offers high-throughput, low-latency access to scalable shared storage.|Storage|
|[Multiple forests with AD DS and Azure AD](../example-scenario/wvd/multi-forest.yml)|Learn how to create multiple Active Directory forests with Azure Virtual Desktop. Azure NetApp Files is one recommended storage solution for the scenario.|Virtual Desktop|
|[Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for Oracle Database workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|
|[Refactor mainframe computer systems that run Adabas & Natural](../example-scenario/mainframe/refactor-adabas-aks.yml)|Learn how to modernize mainframe computer systems that run Adabas & Natural and move them to the cloud. Azure NetApp Files is used to store persistent data.|Mainframe|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high-availability, small-scale production environment of SAP BW/4HANA on Azure. Azure NetApp Files is used by a high-availability cluster for shared file storage. |SAP|
|[SAP deployment in Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|SAP|
|[SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability scale-up environment that supports disaster recovery.|SAP|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Learn proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability.|SAP|
|[SAP system on Oracle Database](../example-scenario/apps/sap-on-oracle.yml)|Examine deployment patterns for SAP systems on Oracle Database that align with the pillars of the Azure Well-Architected Framework. The reference architecture uses Azure NetApp Files for NFS shared storage requirements.|SAP|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. Includes recommendations for using Azure NetApp Files.|Compute|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](../example-scenario/file-storage/sql-server-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for SQL Server workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|

### Oracle

|Architecture|Summary|Technology focus|
|--|--|--|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. CluedIn takes input from on-premises accessible systems like Oracle.|Databases|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)|Migrate IBM zSeries mainframe applications to Azure. Use a no-code approach that TmaxSoft OpenFrame provides. OpenFrame can integrate with RDBMSs like Oracle.|Mainframe|
|[Oracle Database migration to Azure](../solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure.yml)|Migrate an Oracle database and its applications to Azure. Use Oracle Active Data Guard for the database, and use Azure Load Balancer for the application tier.|Oracle|
|[Oracle Database migration: Cross-cloud connectivity](../example-scenario/oracle-migrate/oracle-migration-cross-cloud.yml)|Create a connection between your existing Oracle database and your Azure applications.|Oracle|
|[Oracle Database migration: Lift and shift](../example-scenario/oracle-migrate/oracle-migration-lift-shift.yml)|Lift and shift your Oracle database from an Oracle environment to Azure Virtual Machines.|Oracle|
|[Oracle Database migration: Refactor](../example-scenario/oracle-migrate/oracle-migration-refactor.yml)|Refactor your Oracle database by using Azure Database Migration Service, and move it to PostgreSQL.|Oracle|
|[Oracle Database migration: Rearchitect](../example-scenario/oracle-migrate/oracle-migration-rearchitect.yml)|Rearchitect your Oracle database by using Azure SQL Managed Instance.|Oracle|
|[Oracle Database with Azure NetApp Files](../example-scenario/file-storage/oracle-azure-netapp-files.yml)|Implement a high-bandwidth, low-latency solution for Oracle Database workloads. Use Azure NetApp Files to get enterprise-scale performance and to reduce costs.|Storage|
|[Overview of Oracle Database migration](../example-scenario/oracle-migrate/oracle-migration-overview.yml)|Learn about Oracle Database migration paths and the methods you can use to migrate your schema to SQL or PostgreSQL.|Oracle|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs. Use Oracle databases on VMs for persistent data.|Mainframe|
|[Run Oracle databases on Azure](../solution-ideas/articles/reference-architecture-for-oracle-database-on-azure.yml)|Use a canonical architecture to achieve high availability for Oracle Database Enterprise Edition on Azure.|Oracle|
|[Run SAP NetWeaver in Windows on Azure](../reference-architectures/sap/sap-netweaver.yml)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability. Oracle is one recommended database.|SAP|
|[SAP deployment on Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|Oracle|
|[SAP system on Oracle Database](../example-scenario/apps/sap-on-oracle.yml)|Examine deployment patterns for SAP systems on Oracle Database that align with the pillars of the Azure Well-Architected Framework.|Oracle|
|[Security considerations for highly sensitive IaaS apps in Azure](../reference-architectures/n-tier/high-security-iaas.yml)|Learn about VM security, encryption, NSGs, perimeter networks (also known as DMZs), access control, and other security considerations for highly sensitive IaaS and hybrid apps. A common replication scenario for IaaS architectures uses Oracle Active Data Guard. |Security|
|[SWIFT\'s Alliance Access on Azure](../example-scenario/finance/swift-alliance-access-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access on Azure. An Alliance Access component contains an embedded Oracle database.|Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual on Azure](../example-scenario/finance/swift-alliance-access-vsrx-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access with Alliance Connect Virtual on Azure. An Alliance Access component contains an embedded Oracle database.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. This messaging solution helps financial institutions securely and efficiently bring new services to market. A key component, the AMH node, runs an Oracle database.|Networking|

### Postman

|Architecture|Summary|Technology focus|
|--|--|--|
|[Design APIs for microservices](../microservices/design/api-design.yml)|Learn about good API design in a microservices architecture. IDLs used to define APIs can be consumed by API testing tools like Postman.|Microservices|
|[Gridwich local development environment setup](../reference-architectures/media-services/set-up-local-environment.yml)|Set up a local development environment to work with Gridwich. Postman is an optional component in the configuration.|Media|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)|Learn about logging, tracing, and monitoring for microservices apps.|Microservices|

### Profisee

|Architecture|Summary|Technology focus|
|--|--|--|
|[Data governance with Profisee and Azure Purview](../reference-architectures/data/profisee-master-data-management-purview.yml)|Integrate Profisee master data management with Azure Purview to build a foundation for data governance and management.|Databases|
|[Master data management with Profisee and Azure Data Factory](../reference-architectures/data/profisee-master-data-management-data-factory.yml)|Integrate Profisee master data management with Data Factory to deliver high quality, trusted data for Azure Synapse and all analytics applications. Postman is recommended for synthetic logging.|Databases|

### Qlik

|Architecture|Summary|Technology focus|
|--|--|--|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|Learn how Qlik Replication is a valuable tool for migrating mainframe and midrange systems to the cloud, or for extending such systems with cloud applications.|Mainframe|

### Raincode

|Architecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications to Azure with Raincode compilers](../reference-architectures/app-modernization/raincode-reference-architecture.yml)|Learn how the Raincode COBOL compiler modernizes mainframe legacy applications.|Mainframe|

### SAP

|Architecture|Summary|Technology focus|
|--|--|--|
|[Add a mobile front end to a legacy app](../solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.yml)|Learn about a solution that uses Azure SQL Database and SAP to consolidate data from multiple business systems and surface it through web and mobile front ends. |Mobile|
|[Custom mobile workforce app](../solution-ideas/articles/custom-mobile-workforce-app.yml)|Learn about a mobile workforce app architecture that uses Active Directory to secure corporate data from an SAP back-end system.|Mobile|
|[Development and test environments for SAP workloads on Azure](../example-scenario/apps/sap-dev-test.yml)|Learn how to establish non-production development and test environments for SAP NetWeaver in a Windows or Linux environment on Azure.|SAP|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations. CluedIn takes input from on-premises accessible systems like SAP.|Databases|
|[Multitier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)|Learn how to create a resilient multitier web application built for high availability and disaster recovery on Azure. Common scenarios include any mission-critical application that runs on Windows or Linux, including applications like SAP. |Networking|
|[Run SAP BW/4HANA with Linux VMs](../reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines.yml)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high availability small-scale production environment of SAP BW/4HANA on Azure.|SAP|
|[Run SAP HANA for Linux VMs in scale-up systems](../reference-architectures/sap/run-sap-hana-for-linux-virtual-machines.yml)|Learn proven practices for running SAP HANA in a high availability scale-up environment that supports disaster recovery.|SAP|
|[Run SAP HANA Large Instances](../reference-architectures/sap/hana-large-instances.yml)|Learn proven practices for running SAP HANA in a high availability environment on Azure Large Instances.|SAP|
|[Run SAP NetWeaver in Windows on Azure](../reference-architectures/sap/sap-netweaver.yml)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability.|SAP|
|[SAP deployment on Azure using an Oracle database](../example-scenario/apps/sap-production.yml)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|SAP|
|[SAP on Azure architecture design](../reference-architectures/sap/sap-overview.yml)|Review a set of guiding tenets to help ensure the quality of SAP workloads that run on Azure.|SAP|
|[SAP NetWeaver on SQL Server](../solution-ideas/articles/sap-netweaver-on-sql-server.yml)|Build an SAP landscape on NetWeaver by using Azure Virtual Machines to host SAP applications and a SQL Server database.|SAP|
|[SAP S/4HANA for Large Instances](../solution-ideas/articles/sap-s4-hana-on-hli-with-ha-and-dr.yml)|With large SAP HANA instances, use Azure Virtual Machines, OS clustering, and NFS storage for scalability, performance, high reliability, and disaster recovery.|SAP|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability.|SAP|
|[SAP system on Oracle Database](../example-scenario/apps/sap-on-oracle.yml)|Examine deployment patterns for SAP systems on Oracle Database that align with the pillars of the Azure Well-Architected Framework.|SAP|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation.|SAP|

### SAS

|Architecture|Summary|Technology focus|
|--|--|--|
|[SAS on Azure architecture](../guide/sas/sas-overview.yml)|Learn how to run SAS analytics products on Azure. See guidelines for designing and implementing cloud solutions for SAS Viya and SAS Grid.|Compute|

### Sitecore

|Architecture|Summary|Technology focus|
|--|--|--|
|[Scalable Sitecore marketing website](../solution-ideas/articles/digital-marketing-sitecore.yml)|Learn how the Sitecore Experience Platform (XP) provides the data, integrated tools, and automation you need to engage customers throughout an iterative lifecycle.|Web|

### Skytap

|Architecture|Summary|Technology focus|
|--|--|--|
|[Migrate AIX workloads to Skytap on Azure](../example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap.yml)|Learn now to migrate AIX logical partitions (LPARs) to Skytap on Azure.|Mainframe|
|[Migrate IBM i series to Azure with Skytap](../example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap.yml)|Learn how to use the native IBM i backup and recovery services with Azure components.|Mainframe|

### Software AG

|Architecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe computer systems that run Adabas & Natural](../example-scenario/mainframe/refactor-adabas-aks.yml)|Learn how to modernize mainframe computer systems that run Adabas & Natural and move them to the cloud.|Mainframe|

### Stromasys

|Architecture|Summary|Technology focus|
|--|--|--|
|[Stromasys Charon-SSP Solaris emulator on Azure VMs](../solution-ideas/articles/solaris-azure.yml)|Learn how the Charon-SSP cross-platform hypervisor emulates legacy Sun SPARC systems on industry standard x86-64 computer systems and VMs.|Mainframe|


### SWIFT

|Architecture|Summary|Technology focus|
|--|--|--|
|[SWIFT\'s Alliance Access on Azure](../example-scenario/finance/swift-alliance-access-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access on Azure.|Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual on Azure](../example-scenario/finance/swift-alliance-access-vsrx-on-azure.yml)|View a reference architecture for deploying and running SWIFT Alliance Access with Alliance Connect Virtual on Azure.|Networking|
|[SWIFT Alliance Cloud on Azure](../example-scenario/finance/swift-alliance-cloud-on-azure.yml)|Deploy Azure infrastructure for SWIFT Alliance Cloud.|Networking|
|[SWIFT Alliance Connect on Azure](../example-scenario/finance/swift-on-azure-srx.yml)|View a series of articles about SWIFT Alliance Connect components that can be deployed on Azure.|Security|
|[SWIFT Alliance Connect Virtual on Azure](../example-scenario/finance/swift-on-azure-vsrx.yml)|View a series of articles about SWIFT Alliance Connect Virtual components that can be deployed on Azure.|Security|
|[SWIFT Alliance Lite2 on Azure](../example-scenario/finance/swift-alliance-lite2-on-azure.yml)|Deploy SWIFT Alliance Lite2 on Azure. Migrate an existing deployment from on-premises or create a new deployment.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](../example-scenario/finance/swift-alliance-messaging-hub.yml)|Run SWIFT AMH on Azure. This messaging solution helps financial institutions securely and efficiently bring new services to market.|Networking|
|[SWIFT\'s AMH with Alliance Connect Virtual](../example-scenario/finance/swift-alliance-messaging-hub-vsrx.yml)|Run SWIFT AMH on Azure. Use this messaging solution with the Alliance Connect Virtual networking solution, which also runs on Azure.|Networking|

### Syncier

|Architecture|Summary|Technology focus|
|--|--|--|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)|View a GitOps solution for an AKS cluster. This solution provides full audit capabilities, policy enforcement, and early feedback. Syncier Security Tower provides an overview of all AKS clusters and helps manage policies. |Containers|

### TmaxSoft

|Architecture|Summary|Technology focus|
|--|--|--|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml)|Migrate IBM zSeries mainframe applications to Azure. Use a no-code approach that TmaxSoft OpenFrame provides.|Mainframe|

### Unisys

|Architecture|Summary|Technology focus|
|--|--|--|
|[Unisys ClearPath Forward mainframe rehost to Azure using Unisys virtualization](../example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost.yml)|Use virtualization technologies from Unisys and Azure to migrate from a Unisys ClearPath Forward Libra (legacy Burroughs A Series/MCP) mainframe.|Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia and Micro Focus](../example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus.yml)|Migrate Unisys Dorado mainframe systems by using Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|
|[Unisys mainframe migration with Asysco](../reference-architectures/migration/unisys-mainframe-migration.yml)|Learn options for using the AMT framework to migrate Unisys mainframe workloads to Azure.|Mainframe|

## Related resources
- [Scenarios featuring Microsoft on-premises technologies](../guide/on-premises-microsoft-technologies.md)
- [Architecture for startups](../guide/startups/startup-architecture.md)
- [Azure and Power Platform scenarios](../solutions/power-platform-scenarios.md)
- [Azure and Microsoft 365 scenarios](../solutions/microsoft-365-scenarios.md)
- [Azure and Dynamics 365 scenarios](../solutions/dynamics-365-scenarios.md)
- [Azure for AWS professionals](../aws-professional/index.md)
- [Azure for Google Cloud professionals](../gcp-professional/index.md)
