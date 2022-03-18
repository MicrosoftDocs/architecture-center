---
title: Microsoft partner and third-party scenarios on Azure
description: <Write a 100-160 character description that ends with a period and ideally starts with a call to action. This becomes the browse card description.>
author: <contributor's GitHub username. If no GitHub account, use EdPrice-MSFT>
ms.author: <contributor's Microsoft alias. If no alias, use edprice>
ms.date: <publish or major update date - mm/dd/yyyy>
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - <choose 1-5 products from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring#products>
  - <1-5 products>
  - <1-5 products>
categories:
  - <choose at least one category from the list at https://review.docs.microsoft.com/en-us/help/contribute/architecture-center/aac-browser-authoring#azure-categories>
  - <there can be more than one category>
ms.custom: fcp
---

# Microsoft partner and third-party scenarios on Azure

intro 

*Apache®, Apache Ignite, Ignite, and the flame logo are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Scenarios featuring open-source technologies on Azure

### Apache

#### Apache Cassandra

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|View guidance for how to separate data partitions to be managed and accessed separately. Understand horizontal, vertical, and functional partitioning strategies. |Databases|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active-standby mode to achieve high availability and disaster recovery in Azure public multiaccess edge compute.| Hybrid|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)| Build solutions that integrate data from many IoT devices into a comprehensive data analysis architecture to improve and automate decision making.|Analytics|
|[N-tier application with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)|Deploy Linux virtual machines and a virtual network configured for an N-tier architecture with Apache Cassandra in Azure.| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml) |Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements.|Databases|
|[Run Apache Cassandra on Azure VMs](../best-practices/cassandra.md)|Examine performance considerations for running Apache Cassandra on Azure virtual machines. Use these recommendations as a baseline to test against your workload.| Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.| Analytics|

#### Apache CouchDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml) |Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application.|Web

#### Apache Hadoop

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](/azure/architecture/industries/finance/actuarial-risk-analysis-financial-model)|Learn how an actuarial developer can move an existing solution and its supporting infrastructure to Azure.| Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|Build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign.| Databases|
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|Learn about Azure data transfer options like Azure Import/Export service, Azure Data Box, Azure Data Factory, and command-line and graphical interface tools.| Databases|
|[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to user Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and production version.| AI|
|[Data considerations for microservices](/azure/architecture/microservices/design/data-considerations)|Learn about managing data in a microservices architecture. Data integrity and data consistency are critical challenges for microservices.| Microservices|
|[Extend your on-premises big data investments with HDInsight](../solution-ideas/articles/extend-your-on-premises-big-data-investments-with-hdinsight.yml)|Extend your on-premises big data investments to the cloud. Transform your business by using the advanced analytics capabilities of Azure HDInsight.| Analytics|
|[Extract actionable insights from IoT data](/azure/architecture/industries/manufacturing/extract-insights-iot-data)|Extract insights from IoT data by using Azure services.| Analytics|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about extract-transform-load (ETL) and extract-load-transform (ELT) data transformation pipelines and how to use control flows and data flows.| Analytics|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.| Analytics|
|[Gaming using Azure Database for MySQL](../solution-ideas/articles/gaming-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL for gaming solutions so that databases scale elastically during traffic bursts and deliver low-latency multi-player experiences.| Databases|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data.| Databases|
|[IoT analyze and optimize loops](../example-scenario/iot/analyze-optimize-loop.yml)|Learn about analyze and optimize loops, an IoT pattern for generating and applying optimization insights based on an entire business context.| IoT|
|[Leader Election pattern](/azure/architecture/patterns/leader-election)|Learn how to use the Leader Election pattern to coordinate the actions performed by a collection of collaborating task instances in a distributed application.| Analytics|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations.| Databases|
|[Materialized View pattern](/azure/architecture/patterns/materialized-view)|Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for your required query operations.| Databases|
|[Predict loan charge-offs with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off.| Databases|
|[Predictive maintenance for industrial IoT](../solution-ideas/articles/iot-predictive-maintenance.yml)|Connect devices that use the Open Platform Communications Unified Architecture standard to the cloud, and use predictive maintenance to optimize production.| IoT|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)|Ingest and process millions of streaming events per second by using Apache Kafka, Apache Storm, and Apache Spark Streaming.| Databases|

#### Apache HBase

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.| Databases|
|[Choose a big data storage technology](../data-guide/technology-choices/data-storage.md)|Compare big data storage technology options in Azure.| Databases|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure.| Analytics|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|View guidance for separating data partitions so they can be managed and accessed separately. Understand horizontal, vertical, and functional partitioning strategies. | Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key-value pairs, graphs, time series, objects, and other storage models, based on data requirements.| Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.| Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|Analyze time series data like sensor data, stock prices, clickstream data, or app telemetry for historical trends, real-time alerts, or predictive modeling.| Databases|

#### Apache Hive

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.| Analytics|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|Build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign.| Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure.| Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure.| Analytics|
|[Data warehousing in Azure](../data-guide/relational-data/data-warehousing.yml)|Learn about data warehousing in Azure.| Databases|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about ETL and ELT data transformation pipelines and how to use control flows and data flows.| Databases|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.| Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data.| Databases|
|[Loan charge-off prediction with HDInsight Spark clusters](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off.| Analytics|
|[Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)|Learn how to combine real-time aircraft data with analytics to create a solution for predictive aircraft engine monitoring and health.| Analytics|
|[Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)|Learn how car dealerships, manufacturers, and insurance companies can use Azure to get predictive insights on vehicle health and driving habits.| Analytics|
|[Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)|Build a predictive maintenance solution that monitors aircraft parts in real time and uses analytics to predict the remaining useful life of engine components.| Analytics|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.| Analytics|
|[Scale AI and machine learning initiatives in regulated industries](../example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries.yml)|Learn about scaling Azure AI and machine learning environments that must comply with extensive security policies.| AI|

#### Apache JMeter

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline.|Migration|
[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud.|Migration|
[Scalable cloud applications and SRE](../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)|Build scalable cloud applications by using performance modeling and other principles and practices of site reliability engineering (SRE).|Web|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)|Learn about logging, tracing, and monitoring for microservices apps.|Microservices|

#### Apache Kafka
 
|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Anomaly detector process](../solution-ideas/articles/anomaly-detector-process.yml)|Learn about Anomaly Detector and see how anomaly detection models are selected with time series data.|Analytics|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for Azure Kubernetes Service (AKS) applications.|Containers|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)|Learn about asynchronous messaging options in Azure.|Integration|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|Learn about an end-to-end approach for an automotive original equipment manufacturer (OEM). Includes a reference architecture and several published open-source libraries that you can reuse.|Web|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, and fast queries.|Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)|Use Azure Data Explorer in a hybrid monitoring solution that ingests streamed and batched logs from diverse sources.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Containers|
|[Choose a real-time message ingestion technology](../data-guide/technology-choices/real-time-ingestion.md)|Choose an Azure message ingestion store to support message buffering, scale-out processing, reliable delivery, and queuing semantics.|Databases|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure.|Analytics|
|[Claim-Check pattern](../patterns/claim-check.yml)|Examine the Claim-Check pattern, which splits a large message into a claim check and a payload to avoid overwhelming a message bus.|Integration|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors.|Containers|
|[Extract actionable insights from IoT data](../industries/manufacturing/extract-insights-iot-data.yml)|Extract insights from IoT data by using Azure services.|Serverless|
|[Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)|Create ETL pipelines for batch and streaming data with Azure Databricks to simplify data lake ingestion at any scale.|Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)|Learn how to ingest and analyze high volumes of IoT data and generate real-time recommendations and insights.|Containers|
|[Integrate Event Hubs with Azure Functions](../serverless/event-hubs-functions/event-hubs-functions.yml)|Learn how to architect, develop, and deploy efficient and scalable code that runs on Azure Functions and responds to Azure Event Hubs events.|Serverless|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices.|Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline.|Migration|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)|See how Qlik Replicate is a valuable tool for migrating mainframe and midrange systems to the cloud, or for extending such systems with cloud applications.|Mainframe|
|[Partitioning in Event Hubs and Kafka](../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)|Learn about partitioning in Kafka and Event Hubs for Kafka. Learn how many partitions to use in ingestion pipelines and how to assign events to partitions.|Analytics|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud.|Serverless|
|[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)|Learn about the Publisher-Subscriber pattern, which enables an application to announce events to many interested consumers asynchronously.|Integration|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)|Use a rate limiting pattern to avoid or minimize throttling errors.|Integration|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Databases|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)|Learn how to use the automated COBOL refactoring solution from Advanced to modernize your mainframe COBOL applications, run them on Azure, and reduce costs.|Mainframe|
|[Scalable order processing](../example-scenario/data/ecommerce-order-processing.yml)|Learn about a highly scalable, resilient architecture for e-commerce order processing.|Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|Analyze time series data like sensor data, stock prices, clickstream data, or app telemetry for historical trends, real-time alerts, or predictive modeling.|Databases|

#### Apache MapReduce

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)|Learn about asynchronous messaging options in Azure.|Integration|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure.|Analytics|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.|Analytics|
|[Geode pattern](../patterns/geodes.yml)|Deploy backend services into a set of geographical nodes, each of which can service any client request in any region.|Databases|
|[Minimize coordination](../guide/design-principles/minimize-coordination.yml)|Follow these recommendations to improve scalability by minimizing coordination between application services.|Databases|

#### Apache NiFi

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. This tool sends alerts and displays health and performance information in dashboards.|Analytics|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)|Automate data flows with Apache NiFi on Azure. Use a scalable, highly available solution to move data into the cloud or storage and between cloud systems.|Analytics|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)|Use Azure Data Explorer in a hybrid monitoring solution that ingests streamed and batched logs from diverse sources.|Analytics|

#### Apache Oozie

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases|
|[Choose a data pipeline orchestration technology](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)|Choose an Azure data pipeline orchestration technology to automate pipeline orchestration, control flow, and data movement workflows.|Databases|
|[Data warehousing in Azure](../data-guide/relational-data/data-warehousing.yml)|Learn about data warehousing in Azure.|Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Databases|

#### Apache Solr

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs.|Databases|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)|Learn how free-form text processing can support search by producing useful, actionable data from large amounts of text.|Databases|

#### Apache Spark

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](../industries/finance/actuarial-risk-analysis-financial-model.yml)|Learn how an actuarial developer can move an existing solution and its supporting infrastructure to Azure.|Analytics|
|[Advanced analytics](../solution-ideas/articles/advanced-analytics-on-big-data.yml)|Learn how you can combine any data at any scale with custom machine learning and get near real-time data analytics on streaming services.|Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub. Integrate it with your applications for low-latency intelligence.|AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)||AI|
|[Analytics end-to-end with Azure Synapse](../example-scenario/dataplate2e/data-platform-end-to-end.yml)|Learn how to use Azure Data Services to build a modern analytics platform capable of handling the most common data challenges in an organization.|Analytics|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.|Databases|
|[Batch scoring of Spark on Azure Databricks](../reference-architectures/ai/batch-scoring-databricks.yml)|Build a scalable solution for batch scoring an Apache Spark classification model on a schedule using Azure Databricks.|AI|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)|Use confidential computing on Kubernetes to run big data analytics with Apache Spark inside confidential containers that are protected by Intel Software Guard Extensions with data from Azure Data Lake and Azure SQL Database.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases|
|[Build a content-based recommendation system](../example-scenario/ai/scalable-personalization-with-content-based-recommendation-system.yml)|Create content-based recommendation systems that can deliver personalized recommendations to your customers with Azure Machine Learning and Databricks.|Analytics|
|[Build cloud native applications](../solution-ideas/articles/cloud-native-apps.yml)|Learn how to build cloud native applications with Azure Cosmos DB, Azure Database for PostgreSQL and Azure Cache for Redis.|Containers|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)||Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure.|Analytics|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure.|Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure.|Analytics|
|[Customer 360 with Azure Synapse and Dynamics 365 Customer Insights](../example-scenario/analytics/synapse-customer-insights.yml)|Build an end-to-end Customer 360 solution by using Azure Synapse Analytics and Dynamics 360 Customer Insights.|Analytics|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models.|AI|
|[Extract, transform, and load](../data-guide/relational-data/etl.yml)|Learn about extract-transform-load (ETL) and extract-load-transform (ELT) data transformation pipelines and how to use control flows and data flows.|Databases|
|[ETL using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|ETL big data clusters on demand by using HDInsight, Hadoop MapReduce, and Apache Spark.|Analytics|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)||Analytics|
|[IoT using Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)|Learn how to use Azure Cosmos DB to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance.|IoT|
|[Loan charge-off predictions with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|Use HDInsight and machine learning to predict the likelihood of loans getting charged off.|Databases|
|[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)|Many machine learning (ML) problems are too complex for a single ML model to solve. Learn about many models machine learning at scale in Azure with Spark.|AI|
|[Microsoft machine learning products](../data-guide/technology-choices/data-science-and-machine-learning.md)|Compare options for building, deploying, and managing your machine learning models. Decide which Microsoft products to choose for your solution.|AI|
|[Modern data warehouse for small and medium business](../example-scenario/data/small-medium-data-warehouse.yml)|Use Azure Synapse Analytics, SQL Database, and Data Lake Storage to modernize SMB legacy and on-premises data. Easily integrate fused data with other services.|Analytics|
|[Natural language processing technology](../data-guide/technology-choices/natural-language-processing.yml)|Choose a natural language processing service for sentiment analysis, topic and language detection, key phrase extraction, and document categorization.|AI|
|[Observability patterns and metrics](/azure/architecture/databricks-monitoring/databricks-observability)|Learn how to use observability patterns and metrics to improve the processing performance of a big data system using Azure Databricks.|Databases|
|[Real-time analytics on big data architecture](../solution-ideas/articles/real-time-analytics.yml)|Get deep-learning analytics and insights from live streaming data. Run advanced analytics on IoT device data and website clickstream logs in near real time.|Analytics|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Analytics|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)|Ingest and process millions of streaming events per second by using Apache Kafka, Apache Storm, and Apache Spark Streaming.|Databases|

#### Apache Sqoop

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.|Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|Learn about Azure data transfer options like Azure Import/Export service, Data Box, Data Factory, and command-line and graphical interface tools.|Databases|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Databases|

#### Apache Storm

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)||AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Take advantage of edge AI when disconnected from the internet and move your AI models to the edge with a solution that includes Azure Stack Hub.|AI|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases|
[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure.|Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long and Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data.|Databases|
|[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)|Learn how to use Azure Cosmos DB to accommodate diverse and unpredictable IoT workloads without sacrificing ingestion or query performance.|IoT|
|[Real-time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Databases|

#### Apache Zookeeper

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)|Automate data flows with Apache NiFi on Azure. Use a scalable, highly available solution to move data into the cloud or storage and between cloud systems.|Analytics|
|[Helm-based deployments for Apache NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Leader Election pattern](/azure/architecture/patterns/leader-election)|Learn how to use the Leader Election pattern to coordinate the actions performed by a collection of collaborating task instances in a distributed application.|Analytics|
|[Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern)|Use a rate limiting pattern to avoid or minimize throttling errors.|Integration|

### BeeGFS

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure infrastructure-as-a-service (IaaS) by following the architecture and design guidance in an example scenario.|Media|
|[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM.|Compute|

### Chef

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Building blocks for autonomous-driving simulation environments](/azure/architecture/industries/automotive/building-blocks-autonomous-driving-simulation-environments)|Simulate the behavior of autonomous-driving vehicles.|Containers|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application.|DevOps
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code.|Management|

### CNCF

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments.|Hybrid|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Multi-cloud blockchain distributed ledger technology (DLT)](../example-scenario/blockchain/multi-cloud-blockchain.yml)|See how the open-source Blockchain Automation Framework (BAF) and Azure Arc-enabled Kubernetes work with multi-party DLTs to build a cross-cloud blockchain solution.|Blockchain|

### Elastic

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)|Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs.|Databases|
|[Elastic Workplace Search on Azure](../solution-ideas/articles/elastic-workplace-search.yml)|Learn how to deploy Elastic Workplace Search to streamline search for your documents and data.|Integration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS.|Containers|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)|Learn best practices for monitoring a microservices application that runs on AKS.|Containers|
|[Monitoring and diagnostics guidance](../best-practices/monitoring.yml)|Learn how to track how users use your distributed applications and services, trace resource utilization, and monitor health and performance.|Management|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)|Learn how free-form text processing can support search by producing useful, actionable data from large amounts of text.|Databases|

### GlusterFS

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure IaaS by following the architecture and design guidance in an example scenario.|Media|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)|Review proven practices for running SAP S/4HANA in a Linux environment on Azure, with high availability.|SAP|

### Grafana

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](/azure/architecture/guide/data/monitor-apache-nifi-monitofi)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. This tool sends alerts and displays health and performance information in dashboards.|Analytics|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, and fast queries.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Content Delivery Network analytics](../solution-ideas/articles/content-delivery-network-azure-data-explorer.yml)|View an architecture pattern that demonstrates low-latency high-throughput ingestion for large volumes of Content Delivery Network (CDN) logs for building near real-time analytics dashboards.|Analytics|
|[Enterprise monitoring with Azure Monitor](../example-scenario/monitoring/enterprise-monitoring.yml)|See an enterprise monitoring solution that uses Azure Monitor to collect and manage data from cloud, on-premises, and hybrid resources.|DevOps|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices.|Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|Get an overview of an implementation for a scalable cloud load-testing pipeline.|Migration|
|[Long-term security log retention with Azure Data Explorer](../example-scenario/security/security-log-retention-azure-data-explorer.yml)|Store security logs in Azure Data Explorer on a long-term basis. This solution minimizes costs and provides easy access when you need to query the data.|Analytics|
|[Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)|Learn how to use Azure Arc for management, maintenance, and monitoring of SQL Server instances in on-premises and multi-cloud environments.|Databases|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)|Use this solution to bolster productivity and facilitate innovation.|SAP|
|[Web application monitoring on Azure](../reference-architectures/app-service-web-app/app-monitoring.yml)|Learn about the monitoring services you can use on Azure by reviewing a reference architecture that uses a dataflow model for use with multiple data sources.|Web|

### InfluxDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](/azure/architecture/guide/data/monitor-apache-nifi-monitofi)|Monitor deployments of Apache NiFi on Azure by using MonitoFi. This tool sends alerts and displays health and performance information in dashboards.|Analytics|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)|Learn best practices for monitoring a microservices application that runs on AKS.|Microservices|

### Jenkins

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data that's too large or complex for traditional database systems.|Databases|
|[Building blocks for autonomous-driving simulation environments](/azure/architecture/industries/automotive/building-blocks-autonomous-driving-simulation-environments)|Simulate the behavior of autonomous-driving vehicles.|Compute|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)|Build a DevOps CI/CD pipeline for a Node.js web app with Jenkins, Azure Container Registry, AKS, Azure Cosmos DB, and Grafana.|Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)|Build a continuous integration and deployment pipeline for a two-tier .NET web application.|DevOps|
|[DevSecOps with a rolling main branching strategy](../solution-ideas/articles/devsecops-rolling-branch.yml)|Improve developer speed and security with DevSecOps and GitHub by using a shift-left strategy.|DevOps|
|[DevTest Image Factory](../solution-ideas/articles/dev-test-image-factory.yml)|Create, maintain, and distribute custom images with the DevTest Image Factory, an automated image development and management solution from Azure DevTest Labs.|DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)|When you use CI/CD pipelines to automate deployments, apply RBAC not just on the Azure Resource Manager side but also earlier in the process when developers check in code.|Management|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)|When you develop apps, use a continuous integration and continuous deployment (CI/CD) pipeline to automatically push changes to Azure virtual machines.|DevOps|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)|Create web apps in Azure App Service. Use the continuous integration and continuous deployment (CI/CD) pipeline to deliver value to customers faster.|DevOps|
|[MLOps for Python with Azure Machine Learning](../reference-architectures/ai/mlops-python.yml)|Implement a continuous integration (CI), continuous delivery (CD), and retraining pipeline for an AI application using Azure DevOps and Azure Machine Learning.|AI|
|[Run a Jenkins server on Azure](../example-scenario/apps/jenkins.yml)|This scenario explains the architecture and considerations to take into account when installing and configuring Jenkins.|DevOps|

### Jupyter

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Automating diagnostic Jupyter Notebook execution](../example-scenario/data/automating-diagnostic-jupyter-notebook.yml)|Learn now to automate diagnostic or routine notebooks by using an Azure serverless architecture.|DevOps|
[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, and fast queries.|Analytics|
[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)|Learn how to choose the best services for building an end-to-end machine learning pipeline from experimentation to deployment.|AI|
[Choose a data analytics and reporting technology](../data-guide/technology-choices/analysis-visualizations-reporting.md)|Evaluate big data analytics technology options for Azure, including key selection criteria and a capability matrix.|Databases|
[Citizen AI with Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to user Azure Machine Learning and Power Platform to quickly create a machine learning proof of concept and production version.|AI|
[Data analysis in Azure Industrial IoT analytics solution](/azure/architecture/guide/iiot-guidance/iiot-data)|Understand data analysis in an Azure Industrial IoT (IIoT) analytics solution. Use visualization, data trends, dashboards, schematic views, and notebooks.|IoT|
[DevOps for quantum computing](/azure/architecture/guide/quantum/devops-for-quantum-computing)|Learn about DevOps requirements for quantum-based apps. DevOps provides a repeatable, high-quality process for building, deploying, and monitoring software.|DevOps|
[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)|Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices.|Analytics|
[Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../example-scenario/mlops/mlops-technical-paper.yml)|Learn how to apply the machine learning operations (MLOps) maturity model to implement a machine learning solution for predicting product shipping levels.|AI|
[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)||AI|
[Precision medicine pipeline with genomics](../example-scenario/precision-medicine/genomic-analysis-reporting.yml)|Build a precision medicine pipeline for genomic analysis and reporting. Use Microsoft Genomics for efficient secondary and tertiary analysis.|Analytics|
[Tune hyperparameters for ML models in Python](../reference-architectures/ai/training-python-models.yml)|Shows recommended practices for tuning hyperparameters (training parameters) of scikit-learn and deep learning machine learning models in Python.|AI|

### KEDA

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Functions in a hybrid environment](/azure/architecture/hybrid/azure-functions-hybrid)|This reference architecture illustrates Azure Functions being utilized from on-premises virtual machines.|Serverless|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)|A serverless event-driven architecture running on Azure Kubernetes with KEDA scaler that ingests and processes a stream of data, then writes the results to a DB.|Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Integrate Event Hubs with Azure Functions](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)||Serverless|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud.|Serverless|

### Kubernetes

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)|Learn about a scalable, secure AKS microservices architecture that builds on recommended AKS microservices baseline architectures and implementations.|Continers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)|Learn how Azure Arc extends Kubernetes cluster management and configuration across datacenters, edge locations, and multiple cloud environments.|Hybrid|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)||Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)||Analytics|
|[Build a CI/CD pipeline for microservices on Kubernetes](/azure/architecture/microservices/ci-cd-kubernetes)|Learn about building a continuous integration and continuous delivery (CI/CD) pipeline for deploying microservices to AKS.|Microservices|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)|Learn how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
|[Choose a bare-metal Kubernetes at the edge platform option](/azure/architecture/operator-guides/aks/choose-bare-metal-kubernetes)|Find the best available option for your use case when configuring Kubernetes clusters at the edge.|Containers|
|[Choose a Kubernetes at the edge compute option](/azure/architecture/operator-guides/aks/choose-kubernetes-edge-compute-option)|Learn about trade-offs for various options available for extending compute on the edge.|Containers|
|[Choose an Azure multiparty computing service](/azure/architecture/guide/technology-choices/multiparty-computing-service)|Use this chart and other information to decide which multiparty computing services to use for your solution.|Blockchain|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)|Get replicable, manageable clusters of containers by orchestrating the deployment of containers with AKS.|DevOps|
|[Container orchestration for microservices](/azure/architecture/microservices/design/orchestration)|Learn how container orchestration makes it easy to manage complex multi-container microservice deployments, scaling, and cluster health.|Microservices|
|[Create a CI/CD pipeline for AI apps using Azure Pipelines, Docker, and Kubernetes](/azure/architecture/data-science-process/ci-cd-flask)|Create a continuous integration and continuous delivery pipeline for Artificial Intelligence (AI) applications using Docker and Kubernetes.|AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)|Learn how to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications using Databricks and Kubernetes.|Analytics|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)|See a GitOps solution for an AKS cluster. This solution provides full audit capabilities, policy enforcement, and early feedback.|Containers|
|[Helm-based deployments for Apache NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi)|Use Helm charts when you deploy NiFi on AKS. Helm streamlines the process of installing and managing Kubernetes applications.|Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)||Containers|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)|Learn about the infrastructure and DevOps considerations of deploying and running a microservices architecture on AKS.|Containers|
|[Microservices with AKS and Azure DevOps](../solution-ideas/articles/microservices-with-aks.yml)||Containers|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Learn about the patterns and implementations used to transform a banking system for the cloud.|Serverless|
|[Secure DevOps for AKS](../solution-ideas/articles/secure-devops-for-kubernetes.yml)||Containers|
|[Use Application Gateway Ingress Controller (AGIC) with a multi-tenant Azure Kubernetes Service](../example-scenario/aks-agic/aks-agic.yml)|Learn how to use the Application Gateway Ingress Controller (AGIC) with your AKS cluster to expose microservice-based applications to the internet.|Containers|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)|Deploy an AKS cluster in a hub-and-spoke network topology by using Terraform and Azure DevOps. Help protect the inbound and outbound traffic by using Azure Firewall.|Containers|

### Lustre

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)|Learn how to perform image-based modeling on Azure infrastructure-as-a-service (IaaS) by following the architecture and design guidance in an example scenario.|Media|
[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)|Run OPM Flow reservoir simulation and ResInsight visualization software on an Azure HPC compute cluster and visualization VM.|Compute|
[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)|Learn how to run SAS analytics products on Azure. See guidelines for designing and implementing cloud solutions for SAS Viya and SAS Grid that use Azure.|Compute|

### MariaDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Core startup stack architecture](/azure/architecture/example-scenario/startups/core-startup-stack)|See an example and understand the components of a simple core startup stack architecture for an initial MVP or prototype.|Startup|
|[Mainframe and midrange data replication to Azure using Qlik](/azure/architecture/example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik)|See how Qlik Replication is a valuable tool for migrating mainframe and midrange systems to the cloud, or for extending such systems with cloud applications.|Mainframe|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)|Learn about several options for moving, converting, transforming, and storing mainframe and midrange file system data on-premises and in Azure.|Mainframe|
|[Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)|Learn how to modernize IBM mainframe and midrange data and see how to use a data-first approach to migrate this data to Azure.|Mainframe|
|[Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)|Replicate data while modernizing mainframe and midrange systems. Sync on-premises data with Azure data during modernization.|Mainframe|
|[Scalable and secure WordPress on Azure](/azure/architecture/example-scenario/infrastructure/wordpress)|This example shows how to use Azure Content Delivery Network and other Azure services to deploy a highly scalable and secure installation of WordPress.|Web|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)|Learn about the high-level differences between the various data storage models found in Azure data services.|Databases|

### MLflow

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Machine Learning decision guide for optimal tool selection](/azure/architecture/example-scenario/mlops/aml-decision-tree)|Learn how to choose the best services for building an end-to-end machine learning pipeline from experimentation to deployment.|AI|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)|Improve operations by using Azure Databricks, Delta Lake, and MLflow for data science and machine learning. Develop, train, and deploy machine learning models.|AI|
|[Determine customer lifetime value and churn with Azure AI services](/azure/architecture/example-scenario/ai/customer-lifecycle-churn)|Learn how to create a solution for predicting customer lifetime value and churn using Azure Machine Learning.|AI|
|[Employee retention with Databricks and Kubernetes](/azure/architecture/example-scenario/ai/employee-retention-databricks-kubernetes)|Learn how to build, deploy, and monitor a machine learning model for employee attrition that can be integrated with external applications using Databricks and Kubernetes.|Analytics|
|[Modern analytics architecture with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)|Create a modern analytics architecture with Azure Databricks, Data Lake Storage, and other Azure services. Unify data, analytics, and AI workloads at any scale.|Analytics|
|[Orchestrate MLOps on Azure Databricks using Databricks Notebook](/azure/architecture/reference-architectures/ai/orchestrate-mlops-azure-databricks)|This scenario describes an approach to machine learning operations (MLOps) that involves running model training and batch scoring on Azure Databricks using Databricks Notebook as an orchestrator.|AI|
|[Population health management for healthcare](/azure/architecture/solution-ideas/articles/population-health-management-for-healthcare)|Use population health management to improve clinical and health outcomes and reduce costs. Track, monitor, and benchmark data with this tool.|AI|

### Moodle

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files)|Deploy Moodle with Azure NetApp Files for a resilient solution that offers high-throughput, low-latency access to scalable shared storage.|Storage|

### MySQL

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
[Build CNCF projects by using Azure Kubernetes Service](/azure/architecture/example-scenario/apps/build-cncf-incubated-graduated-projects-aks)|This article demonstrates how to conceptualize, architect, build, and deploy an application that uses projects from the CNCF after deployment of AKS.|Containers|
[Build web and mobile applications with MySQL and Redis](/azure/architecture/solution-ideas/articles/webapps)|Build web and mobile applications with an Azure microservices-based architecture. Use this solution inspired by PayMe for Business in e-commerce platforms.|Web|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)|Use Azure Database for MySQL to engage with customers around the world with rich, personalized digital marketing experiences.|Databases|
|[Finance management apps with Azure DB for MySQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql)|Use Azure Database for MySQL to securely store critical data and provide users with high-value analytics and insights over aggregated data.|Databases|
| [Gaming using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/gaming-using-azure-database-for-mysql)|Use Azure Database for MySQL for gaming solutions so that databases scale elastically with traffic bursts and deliver low-latency multi-player experiences.|Databases|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)|Learn how to deploy workloads in active/standby mode to achieve high availability and disaster recovery in Azure public MEC.|Hybrid|
|[IBM z/OS online transaction processing on Azure](/azure/architecture/example-scenario/mainframe/ibm-zos-online-transaction-processing-azure)|Migrate a z/OS online transaction processing (OLTP) workload to an Azure application that is cost-effective, responsive, scalable, and adaptable.|Mainframe|
|[Intelligent apps using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql)|Use Azure Database for MySQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Java CI/CD using Jenkins and Azure Web Apps](/azure/architecture/solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps)|Create web apps in Azure App Service. Use the continuous integration and continuous deployment (CI/CD) pipeline to deliver value to customers faster.|DevOps|
|[Lift and shift to containers with AKS](/azure/architecture/solution-ideas/articles/migrate-existing-applications-with-aks)|Migrate existing applications to containers in AKS. Use Open Service Broker for Azure (OSBA) to access Azure databases.|Containers|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)||Mainframe|
|[Microservices with AKS](/azure/architecture/solution-ideas/articles/microservices-with-aks)|AKS simplifies the deployment and management of microservices-based architecture.|Containers|
|[Online transaction processing (OLTP)](/azure/architecture/data-guide/relational-data/online-transaction-processing)|Learn about atomicity, consistency, and other features of online transaction processing (OLTP), which manages transactional data while supporting querying.|Databases|
|[Retail and e-commerce using Azure MySQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-mysql)|Build secure and scalable e-commerce solutions that meet customer and business demands by using Azure Database for MySQL.|Databases|
|[Scalable apps using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql)|Use Azure Database for MySQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)|Learn about VM security, encryption, NSGs, DMZs, access control, and other security considerations for highly sensitive IaaS and hybrid apps.|Security|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.|Analytics|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)||Databases|

### PostgreSQL

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Azure Database for PostgreSQL intelligent apps](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to develop sophisticated machine learning and visualization apps that provide analytics and information that you can act on.|Databases|
|[Build a telehealth system on Azure](/azure/architecture/example-scenario/apps/telehealth-system)|Learn how to build a telehealth system, using Azure cloud services, that connects a professional healthcare organization to its remote patients.|Databases|
|[Build cloud native applications](/azure/architecture/solution-ideas/articles/cloud-native-apps)|Learn how to build cloud native applications with Azure Cosmos DB, Azure Database for PostgreSQL and Azure Cache for Redis.|Containers|
|[Data cache](/azure/architecture/solution-ideas/articles/data-cache-with-redis-cache)|Store and share database query results, session states, static contents, and more, by using a common cache-aside pattern.|Databases|
|[Data streaming with AKS](/azure/architecture/solution-ideas/articles/data-streaming-scenario)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors.|Containers|
|[Digital campaign management](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to engage with customers around the world with rich, personalized digital marketing experiences.|Databases|
|[Finance management apps using Azure Database for PostgreSQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to securely store critical data and provide users with high-value analytics and insights over aggregated data.|Databases|
|[Geospatial data processing and analytics](/azure/architecture/example-scenario/data/geospatial-data-processing-analytics-azure)|Collect, process, and store geospatial data by using managed Azure services. Make the data available through web apps. Visualize, explore, and analyze the data.|Analytics|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|
|[IBM z/OS online transaction processing on Azure](/azure/architecture/example-scenario/mainframe/ibm-zos-online-transaction-processing-azure)||Mainframe|
|[Integrate IBM mainframe and midrange message queues with Azure](/azure/architecture/example-scenario/mainframe/integrate-ibm-message-queues-azure)|This example describes a data-first approach to middleware integration that enables IBM message queues (MQs).|Mainframe|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)||Mainframe|
|[Online transaction processing (OLTP)](/azure/architecture/data-guide/relational-data/online-transaction-processing)||Databases|
|[Oracle database migration: Refactor](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-refactor)|Refactor your Oracle database with Azure Database Migration Service and move it to PostgreSQL.|Migration|
|[Overview of Oracle database migration](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-overview)|Learn about Oracle database migration paths and the methods you use to migrate your schema to SQL or PostgreSQL.|Migration|
|[Retail and e-commerce using Azure PostgreSQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-postgresql)|Build secure and scalable e-commerce solutions that meet customer and business demands by using Azure Database for PostgreSQL.|Databases|
|[Scalable apps using Azure DB for PostgreSQL](/azure/architecture/solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-postgresql)|Use Azure Database for PostgreSQL to rapidly build engaging, performant, and scalable cross-platform and native apps for iOS, Android, Windows, or Mac.|Mobile|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)||Databases|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](/azure/architecture/example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure)|An approach for rehosting mainframe legacy applications in Azure using the LzLabs Software Defined Mainframe platform.|Mainframe|

### Prometheus

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Architecture of an AKS regulated cluster for PCI-DSS 3.2.1](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-ra-code-assets)|Learn about architectural recommendations and code assets from the accompanying reference implementation.|Containers|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)|View a reference architecture for a baseline infrastructure that deploys an AKS cluster.|Containers|
|[Build CNCF projects by using Azure Kubernetes Service](/azure/architecture/example-scenario/apps/build-cncf-incubated-graduated-projects-aks)||Containers|
|[JMeter implementation for a load testing pipeline](/azure/architecture/example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference)||Migration|
|[Microservices architecture on AKS](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)||Containers|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)|Learn best practices for monitoring a microservices application that runs on AKS.|Containers|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)|Use this solution to bolster productivity and facilitate innovation.|SAP|

### PyTorch

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)||AI|
|[Machine learning in IoT Edge Vision](/azure/architecture/guide/iot-edge-vision/machine-learning)|Learn about machine learning data and models in Azure IoT Edge vision AI solutions.|IoT|
|[Real-time scoring of machine learning models](/azure/architecture/reference-architectures/ai/real-time-scoring-machine-learning-models)|Deploy Python machine learning models as web services to make real-time predictions using Azure Machine Learning and AKS.|AI|

### RabbitMQ

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Automated guided vehicles fleet control](/azure/architecture/example-scenario/iot/automated-guided-vehicles-fleet-control)||Web|
[Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)||Integration|
[Transactional Outbox pattern with Azure Cosmos DB](/azure/architecture/best-practices/transactional-outbox-cosmos)|How to use Azure Cosmos DB, change feed, and Azure Service Bus for reliable messaging and guaranteed delivery of domain events in distributed applications.|Databases|

### Red Hat

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](/azure/architecture/example-scenario/unix-migration/migrate-aix-azure-linux)|Migrate an on-premises IBM AIX system and web application to a highly-available, secure RedHat Enterprise Linux solution in Azure.|Mainframe|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Containers|
|[Container orchestration for microservices](/azure/architecture/microservices/design/orchestration)||Microservices|
|[JBoss deployment with Red Hat on Azure](/azure/architecture/solution-ideas/articles/jboss-deployment-red-hat)|Learn how the Red Hat JBoss Enterprise Application Platform (EAP) streamlines and simplifies the development and deployment of a diverse range of applications.|Containers|
|[Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)|Learn the best practices for running a Linux virtual machine on Azure, which requires some additional components, including networking and storage resources.|Compute|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)|Examine deployment patterns for SAP systems on Oracle Database that align with the pillars of the Azure Well-Architected Framework.|SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub)|Run SWIFT Alliance Messaging Hub (AMH) on Azure. This messaging solution helps financial institutions to securely and efficiently bring new services to market.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub-vsrx)|Run SWIFT Alliance Messaging Hub (AMH) on Azure. Use this messaging solution with the Alliance Connect Virtual networking solution, which also runs on Azure.|Networking|

### Redis

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Containers|
|[Build cloud native applications](/azure/architecture/solution-ideas/articles/cloud-native-apps)||Containers|
|[Build web and mobile applications with MySQL and Redis](/azure/architecture/solution-ideas/articles/webapps)||Web|
|[COVID-19 safe solutions with IoT Edge](/azure/architecture/solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection)|Create a COVID-19 safe environment that monitors social distance, mask/PPE use, and occupancy requirements with CCTVs and Azure IoT Edge, Stream Analytics, and Machine Learning.|IoT|
|[Data cache](/azure/architecture/solution-ideas/articles/data-cache-with-redis-cache)||Databases|
|[Data streaming with AKS](/azure/architecture/solution-ideas/articles/data-streaming-scenario)|Use AKS to easily ingest and process a real-time data stream with millions of data points collected via sensors.|Containers|
|[DevTest and DevOps for PaaS solutions](/azure/architecture/solution-ideas/articles/dev-test-paas)|Combine Azure platform as a service (PaaS) resources with DevTest and DevOps practices to support rapid iteration cycles and reduced overhead.|DevOps|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)|Use Azure Database for MySQL to engage with customers around the world with rich, personalized digital marketing experiences.|Databases|
|[Messaging](/azure/architecture/solution-ideas/articles/messaging)|Azure Cache for Redis routes real-time messages in publish and subscribe systems. It also scales up web communication frameworks like Azure SignalR Service.|Databases|
|[Non-relational data and NoSQL](/azure/architecture/data-guide/big-data/non-relational-data)||Databases|
|[Personalized offers](/azure/architecture/solution-ideas/articles/personalized-offers)|Build intelligent marketing systems that provide customer-tailored content by using machine learning models that analyze data from multiple sources.|AI|
|[Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)||Integration|
|[Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern)|Use a rate limiting pattern to avoid or minimize throttling errors.|Integration|
|[Re-engineer mainframe batch applications on Azure](/azure/architecture/example-scenario/mainframe/reengineer-mainframe-batch-apps-azure)|Use Azure services to re-engineer mainframe batch applications. This architecture change can reduce costs and improve scalability.|Mainframe|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)|Learn about the SAP BW/4HANA application tier and how it&amp;apos;s suitable for a high availability, small-scale production environment of SAP BW/4HANA on Azure.|SAP|
|[Scalable Sitecore marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-sitecore)||Web|
|[Scalable web apps with Azure Redis Cache](/azure/architecture/solution-ideas/articles/scalable-web-apps)|The Sitecore Experience Platform (xP) provides the data, integrated tools, and automation needed to engage customers throughout an iterative life cycle.|Web|
|[Scalable web application](/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)||Web|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Supply chain track and trace](/azure/architecture/solution-ideas/articles/supply-chain-track-and-trace)|Use Azure Blockchain Workbench to build an application for a supply chain that can track assets and trigger remediating events downstream.|IoT|

### SUSE

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)|Learn about the SAP BW/4HANA application tier and how it's suitable for a high availability, small-scale production environment of SAP BW/4HANA on Azure.|SAP|
|[Run SAP HANA Large Instances](/azure/architecture/reference-architectures/sap/hana-large-instances)|Learn proven practices for running SAP HANA in a high availability environment on Azure Large Instances.|SAP|
|[SAP deployment in Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)|Learn proven practices for running SAP on Oracle in Azure, with high availability.|SAP|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)|Proven practices for running SAP HANA in a high-availability, scale-up environment that supports disaster recovery on Azure.|SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)|Use this solution to bolster productivity and facilitate innovation.|SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|

### TensorFlow

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)||AI|
|[Distributed training, deep learning models](/azure/architecture/reference-architectures/ai/training-deep-learning)|This reference architecture shows how to conduct distributed training of deep learning models across clusters of GPU-enabled VMs using Azure Machine Learning.|AI|
|[Machine learning in IoT Edge Vision](/azure/architecture/guide/iot-edge-vision/machine-learning)||IoT|
|[Real-time scoring of machine learning models](/azure/architecture/reference-architectures/ai/real-time-scoring-machine-learning-models)||AI|
|[Vision classifier model with Azure Custom Vision Cognitive Service](/azure/architecture/example-scenario/dronerescue/vision-classifier-model-with-custom-vision)|Create an image classifier with a solution architecture that includes Microsoft AirSim Drone simulator and Azure Custom Vision Cognitive Service.|AI|

### Terraform

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Architectural approaches for the deployment and configuration of multitenant solutions](/azure/architecture/guide/multitenant/approaches/deployment-configuration)|This article describes approaches to consider when deploying and configuring a multitenant solution.|Multitenancy|
|[Automated guided vehicles fleet control](/azure/architecture/example-scenario/iot/automated-guided-vehicles-fleet-control)||Web|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp)|Learn about the Deployment Stamps pattern, which deploys many independent copies (known as stamps, service units, or scale units) of application components.|Networking|
|[Design a CI/CD pipeline using Azure DevOps](/azure/architecture/example-scenario/apps/devops-dotnet-webapp)||DevOps|
|[DevOps in a hybrid environment](/azure/architecture/solution-ideas/articles/devops-in-a-hybrid-environment)|The tools provided in Azure allow for the implementation of a DevOps strategy that capably manages both cloud and on-premises environments in tandem.|DevOps|
|[DevSecOps in Azure](/azure/architecture/solution-ideas/articles/devsecops-in-azure)|Learn about DevSecOps, a solution that utilizes security best practices from the beginning of development.|DevOps|
|[DevTest and DevOps for PaaS solutions](/azure/architecture/solution-ideas/articles/dev-test-paas)||DevOps|
|[End-to-end governance in Azure](/azure/architecture/example-scenario/governance/end-to-end-governance-in-azure)||Management|
|[Gridwich cloud media system](/azure/architecture/reference-architectures/media-services/gridwich-architecture)|Learn about a stateless action execution workflow that ingests, processes, and delivers media assets using Terraform Sandwiches and Event Grid Sandwiches.|Media|
|[Gridwich CI/CD pipeline](/azure/architecture/reference-architectures/media-services/gridwich-cicd)|Learn about the guiding principles and considerations for the Gridwich continuous integration and continuous delivery (CD/CD) pipeline.|Media|
|[Gridwich keys and secrets management](/azure/architecture/reference-architectures/media-services/maintain-keys)|Learn about the two types of keys Gridwich uses, storage keys and third-party keys, and the Logic Apps that add, change, or rotate the keys.|Media|
|[Gridwich Media Services setup and scaling](/azure/architecture/reference-architectures/media-services/media-services-setup-scale)|Learn how Gridwich uses Azure Media Services V2 and V3 SDKs to set up authentication and authorization, and how to scale Media Services resources for media processing.|Media|
|[Gridwich pipeline-generated admin scripts](/azure/architecture/reference-architectures/media-services/run-admin-scripts)|Learn about the Gridwich pipeline-generated admin scripts and how to run them.|Media
|[Gridwich variable flow](/azure/architecture/reference-architectures/media-services/variable-group-terraform-flow)|Learn how Gridwich converts Azure Pipelines pipeline variable group variables to Terraform variables.|Media|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](/azure/architecture/solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview)||DevOps|
|[JMeter implementation for a load testing pipeline](/azure/architecture/example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference)||Migration|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)|Use this solution to bolster productivity and facilitate innovation.|SAP|
|[Use Azure Firewall to help protect an AKS cluster](/azure/architecture/example-scenario/aks-firewall/aks-firewall)||Containers|
|[Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)|Learn about an end-to-end solution for health records management that uses Azure Functions microservices integrated with other services via a virtual network.|Security|

### Umbraco

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)||Databases|
|[Scalable Umbraco CMS web app](/azure/architecture/solution-ideas/articles/medium-umbraco-web-app)|Run an Umbraco content management system on the Web Apps feature of Azure App Service. Use Azure managed services for a high-availability environment.|Web|
|[Simple digital marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-smb)|Use an Azure-based content management system to easily maintain messaging on your website in real time, from a browser, with no coding skills.|Web|

### WordPress

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)||Databases|
|[Scalable and secure WordPress on Azure](/azure/architecture/example-scenario/infrastructure/wordpress)||Web|

## Scenarios featuring third-party technologies on Azure

### Advanced

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications with Advanced](/azure/architecture/example-scenario/mainframe/refactor-mainframe-applications-advanced)||Mainframe|

### Asysco

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[IBM z/OS mainframe migration with Asysco](/azure/architecture/example-scenario/mainframe/asysco-zos-migration)|See how to use the Asysco Automated Migration Technology (AMT) framework to migrate IBM z/OS mainframe workloads to Azure.|Mainframe|
|[Unisys mainframe migration with Asysco](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)|Learn about options for using the Asysco Automated Migration Technology (AMT) Framework to migrate Unisys mainframe workloads to Azure.|Mainframe|

### Astadia

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|

### CluedIn

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Master Data Management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Migrate master data services to Azure with CluedIn and Azure Purview](/azure/architecture/reference-architectures/data/migrate-master-data-services-with-cluedin)|Use CluedIn to migrate your master data services solution to Azure, by using CluedIn and Azure Purview.|Databases|

### Confluent

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)|Use simulated and actual applications and existing workloads to monitor the reaction of a solution infrastructure for scalability and performance.|Migration|
|[Partitioning in Event Hubs and Kafka](/azure/architecture/reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka)||Analytics|
|[Real-time processing](/azure/architecture/data-guide/big-data/real-time-processing)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.|Databases|

### Couchbase

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|

### Double-Take

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[SMB disaster recovery with Azure Site Recovery](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-azure-site-recovery)|Small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using Azure Site Recovery or Double-Take DR.|Management|
|[SMB disaster recovery with Double-Take DR](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-double-take-dr)|Small and medium-sized businesses can inexpensively implement cloud-based disaster recovery solutions by using a partner solution like Double-Take DR.|Management|

### Episerver

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable Episerver marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-episerver)|Run multi-channel digital marketing websites on one platform. Start and stop campaigns on demand. Manage site and campaign performance with Episerver.|Web|

### Gremlin

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Build web and mobile applications](/azure/architecture/solution-ideas/articles/webapps)||Web|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|

### Initinite i

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[IBM System i (AS/400) to Azure using Infinite i](/azure/architecture/example-scenario/mainframe/ibm-system-i-azure-infinite-i)|Use Infinite i to easily migrate your IBM System i (AS/400) workloads to Azure. You can lower costs, improve performance, improve availability, and modernize.|Mainframe|

### LzLabs

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](/azure/architecture/example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure)||Mainframe|

### Micro Focus

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Micro Focus Enterprise Server on Azure VMs](/azure/architecture/example-scenario/mainframe/micro-focus-server)|Optimize, modernize, and streamline IBM z/OS mainframe applications by using Micro Focus Enterprise Server 6.0 on Azure VMs.|Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)|Migrate Unisys Dorado mainframe systems with Astadia and Micro Focus products. Move to Azure without rewriting code, switching data models, or updating screens.|Mainframe|


### MongoDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Advanced AKS microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)||Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Containers|
|[Core startup stack architecture](/azure/architecture/example-scenario/startups/core-startup-stack)||Startup|
|[COVID-19 safe solutions with IoT Edge](/azure/architecture/solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection)||IoT|
|[Data considerations for microservices](/azure/architecture/microservices/design/data-considerations)||Microservices|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|
|[Scalable web application](/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)||Web|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)||Security|

### NetApp

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](/azure/architecture/example-scenario/unix-migration/migrate-aix-azure-linux)||Mainframe|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for AKS applications.|Storage|
|[SAP workload development and test settings](/azure/architecture/example-scenario/apps/sap-dev-test)|Learn how to establish non-production development and test environments for SAP NetWeaver in a Windows or Linux environment on Azure.|SAP|
|[Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery)|Learn how to implement resilient NetApp file shares. Failure of the primary Azure region causes automatic failover to the secondary Azure region.|Storage|
|[FSLogix for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)|Learn to build virtual desktop infrastructure solutions at enterprise scale using Microsoft FSLogix.|Hybrid|
|[General mainframe refactor to Azure](/azure/architecture/example-scenario/mainframe/general-mainframe-refactor)|See how to refactor general mainframe applications to run more cost-effectively and efficiently on Azure.|Mainframe|
|[Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files)||Storage|
|[Multiple forests with AD DS and Azure AD](/azure/architecture/example-scenario/wvd/multi-forest)|This article describes an example workload of creating multiple Active Directory forests with Azure Virtual Desktop.|Virtual Desktop|
|[Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)|Implement a high-bandwidth, low-latency solution for Oracle Database workloads. Use Azure NetApp Files for enterprise-scale performance and reduced costs.|Storage|
|[Refactor mainframe computer systems that run Adabas & Natural](/azure/architecture/example-scenario/mainframe/refactor-adabas-aks)|Learn how to modernize mainframe computer systems that run Adabas &amp; Natural and move them to the cloud.|Mainframe|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[SAP deployment in Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||SAP|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files)|Implement a high-bandwidth, low-latency solution for SQL Server workloads. Use Azure NetApp Files for enterprise-scale performance and reduced costs.|Storage|

### Oracle

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Master data management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](/azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe)|Migrate IBM zSeries mainframe applications to Azure. Use a no-code approach that TmaxSoft OpenFrame offers for this lift and shift operation.|Mainframe|
|[Oracle database migration to Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure)|Migrate an Oracle database and its applications to Azure. Use Oracle Active Data Guard for the database, and use Azure Load Balancer for the application tier.|Oracle|
|[Oracle database migration: Cross-cloud connectivity](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-cross-cloud)|Create a connection between your existing Oracle database and your Azure applications.|Oracle|
|[Oracle database migration: Lift and shift](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-lift-shift)|Lift and shift your Oracle database from an Oracle environment to Azure Virtual Machines.|Oracle|
|[Oracle database migration: Refactor](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-refactor)||Oracle|
 |[Oracle database migration: Rearchitect](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-rearchitect)|Rearchitect your Oracle database with Azure SQL Managed Instance.|Oracle|
|[Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)||Storage|
|[Overview of Oracle database migration](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-overview)||Oracle|
|[Refactor mainframe applications with Advanced](/azure/architecture/example-scenario/mainframe/refactor-mainframe-applications-advanced)||Mainframe|
|[Run Oracle databases on Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-on-azure)|Use a canonical architecture to achieve high availability for Oracle Database Enterprise Edition in Azure.|Oracle|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/reference-architectures/sap/sap-netweaver)|Learn proven practices for running SAP NetWeaver in a Windows environment on Azure, with high availability.|SAP|
|[SAP deployment on Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||Oracle|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||Oracle|
|[Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)||Security|
|[SWIFT\'s Alliance Access in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-on-azure)|This article provides a reference architecture for deploying and running SWIFT Alliance Access on Azure.|Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-vsrx-on-azure)|This article provides a reference architecture for deploying and running SWIFT Alliance Access with Alliance Connect Virtual on Azure.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub-vsrx)||Networking|

### Postman

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Design APIs for microservices](/azure/architecture/microservices/design/api-design)|Learn about good API design in a microservices architecture. APIs should be efficient and have well-defined semantics and versioning schemes.|Microservices|
|[Gridwich local development environment setup](/azure/architecture/reference-architectures/media-services/set-up-local-environment)|Set up a local development environment to work with Gridwich.|Media|
|[Unified logging for microservices apps](/azure/architecture/example-scenario/logging/unified-logging)|Learn about logging, tracing, and monitoring for microservices apps.|Microservices|

### Profisee

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Data governance with Profisee and Azure Purview](/azure/architecture/reference-architectures/data/profisee-master-data-management-purview)|Integrate Profisee master data management with Azure Purview to build a foundation for data governance and management. Produce and deliver high-quality, trusted data.|Databases|
|[Master data management with Profisee and Azure Data Factory](/azure/architecture/reference-architectures/data/profisee-master-data-management-data-factory)|Integrate Profisee master data management with Azure Data Factory to deliver high-quality, trusted data for Azure Synapse, and all analytic applications.|Databases|

### Qlik

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Mainframe and midrange data replication to Azure using Qlik](/azure/architecture/example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik)||Mainframe|

### Raincode

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications to Azure with Raincode compilers](/azure/architecture/reference-architectures/app-modernization/raincode-reference-architecture)|This architecture shows how the Raincode COBOL compiler modernizes mainframe legacy applications.|Mainframe|

### SAP

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Add a mobile front end to a legacy app](/azure/architecture/solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application)|This solution consolidates data from multiple business systems and then surfaces the data through web and mobile front ends. This consolidation helps improve employee productivity and helps speed up decision making.|Mobile|
|[Custom mobile workforce app](/azure/architecture/solution-ideas/articles/custom-mobile-workforce-app)|Learn how the custom mobile workforce management app architecture is built and implemented with a step-by-step diagram that illustrates the integration of Active Directory, SAP, and Azure App Service.|Mobile|
|[Development and test environments for SAP workloads on Azure](/azure/architecture/example-scenario/apps/sap-dev-test)||SAP|
|[Master data management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)|Learn how to create a resilient multitier web application built for high availability and disaster recovery on Azure.|Networking|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[Run SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[Run SAP HANA Large Instances](/azure/architecture/reference-architectures/sap/hana-large-instances)||SAP|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/reference-architectures/sap/sap-netweaver)||SAP|
|[SAP deployment on Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||SAP|
|[SAP on Azure architecture design](/azure/architecture/reference-architectures/sap/sap-overview)|This article describes a set of guiding tenets that are used to help ensure the quality of SAP workloads running on Azure.|SAP|
|[SAP NetWeaver on SQL Server](/azure/architecture/solution-ideas/articles/sap-netweaver-on-sql-server)|Build an SAP landscape on NetWeaver by using Azure Virtual Machines to host SAP applications and a SQL Server database.|SAP|
|[SAP S/4 HANA for Large Instances](/azure/architecture/solution-ideas/articles/sap-s4-hana-on-hli-with-ha-and-dr)|With large SAP HANA instances, use Azure Virtual Machines, OS clustering, and NFS storage for scalability, performance, high reliability, and disaster recovery.|SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)|Use this solution to bolster productivity and facilitate innovation.|SAP|

### SAS

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|

### Sitecore

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable Sitecore marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-sitecore)||Web|

### Skytap

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Migrate AIX workloads to Skytap on Azure](/azure/architecture/example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap)|This example illustrates a migration of AIX logical partitions (LPARs) to Skytap on Azure.|Mainframe|
|[Migrate IBM i series to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap)|This example architecture shows how to use the native IBM i backup and recovery services with Microsoft Azure components.|Mainframe|

### Software AG

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe computer systems that run Adabas & Natural](/azure/architecture/example-scenario/mainframe/refactor-adabas-aks)||Mainframe|

### Stromasys

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Stromasys Charon-SSP Solaris emulator on Azure VMs](/azure/architecture/solution-ideas/articles/solaris-azure)|Charon-SSP cross-platform hypervisor emulates legacy Sun SPARC systems on industry standard x86-64 computer systems and VMs.|Mainframe|


### SWIFT

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[SWIFT\'s Alliance Access in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-on-azure)||Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-vsrx-on-azure)||Networking|
|[SWIFT Alliance Cloud in Azure](/azure/architecture/example-scenario/finance/swift-alliance-cloud-on-azure)|Deploy Azure infrastructure for SWIFT Alliance Cloud.|Networking|
|[SWIFT Alliance Connect in Azure](/azure/architecture/example-scenario/finance/swift-on-azure-srx)|This article is a landing page for all SWIFT Alliance Connect components that can be deployed on Azure.|Security|
|[SWIFT Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-on-azure-vsrx)|This article is a landing page for all SWIFT Alliance Connect Virtual components that can be deployed on Azure.|Security|
|[SWIFT Alliance Lite2 on Azure](/azure/architecture/example-scenario/finance/swift-alliance-lite2-on-azure)|Deploy SWIFT Alliance Lite2 on Azure. Migrate an existing deployment from on-premises or create a new deployment.|Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub)||Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub-vsrx)||Networking|

### Syncier

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[GitOps for Azure Kubernetes Service](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks)||Containers|

### TmaxSoft

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](/azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe)||Mainframe|

### Unisys

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Unisys ClearPath Forward mainframe rehost to Azure using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)|Use virtualization technologies from Unisys and Microsoft Azure to migrate from an Unisys ClearPath Forward Libra (legacy Burroughs A Series/MCP) mainframe.|Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia and Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)||Mainframe|
|[Unisys mainframe migration with Asysco](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)||Mainframe|

## Related resources
- Scenarios featuring Microsoft on-prem technologies (the other new article)
- [Architecture for startups](/azure/architecture/guide/startups/startup-architecture)
- [Azure and Power Platform scenarios](/azure/architecture/solutions/power-platform-scenarios)
- [Azure and Microsoft 365 scenarios](/azure/architecture/solutions/microsoft-365-scenarios)
- [Azure and Dynamics 365 scenarios](/azure/architecture/solutions/dynamics-365-scenarios)
- [Azure for AWS professionals](/azure/architecture/aws-professional)
- [Azure for Google Cloud professionals](/azure/architecture/gcp-professional)
