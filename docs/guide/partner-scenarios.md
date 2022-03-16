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

apache note

## Scenarios featuring open-source technologies on Azure

### Apache

#### Apache Cassandra

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)| |Databases|
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|| Hybrid|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)| |Analytics|
|[N-tier application with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)|| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml) ||Databases|
|[Run Apache Cassandra on Azure VMs](../best-practices/cassandra.md)|| Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|| Analytics|

#### Apache CouchDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml) ||Web

#### Apache Hadoop

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](/azure/architecture/industries/finance/actuarial-risk-analysis-financial-model)|| Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|| Databases|
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|| Databases|
|[Citizen AI with the Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|| AI|
|[Data considerations for microservices](/azure/architecture/microservices/design/data-considerations)|| Microservices|
|[Extend your on-premises big data investments with HDInsight](../solution-ideas/articles/extend-your-on-premises-big-data-investments-with-hdinsight.yml)|| Analytics|
|[Extract actionable insights from IoT data](/azure/architecture/industries/manufacturing/extract-insights-iot-data)|| Analytics|
|[Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)|| Analytics|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|| Analytics|
|[Gaming using Azure Database for MySQL](../solution-ideas/articles/gaming-using-azure-database-for-mysql.yml)|| Databases|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|| Databases|
|[IoT analyze and optimize loops](../example-scenario/iot/analyze-optimize-loop.yml)|| IoT|
|[Leader Election pattern](/azure/architecture/patterns/leader-election)|| Analytics|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|| Databases|
|[Materialized View pattern](/azure/architecture/patterns/materialized-view)|| Databases|
|[Predict loan charge-offs with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|| Databases|
|[Predictive maintenance for industrial IoT](../solution-ideas/articles/iot-predictive-maintenance.yml)|| IoT|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)|| Databases|

#### Apache HBase

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|| Databases|
|[Choose a big data storage technology](../data-guide/technology-choices/data-storage.md)|| Databases|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|| Analytics|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|| Databases|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)|| Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|| Databases|

#### Apache Hive

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|| Analytics|
|[Big data architectures](../data-guide/big-data/index.yml)|| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|| Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|| Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|| Analytics|
|[Data warehousing in Microsoft Azure](../data-guide/relational-data/data-warehousing.yml)|| Databases|
|[Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)|| Databases|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|| Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|| Databases|
|[Loan charge-off prediction with HDInsight Spark clusters](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|| Analytics|
|[Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)|| Analytics|
|[Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)|| Analytics|
|[Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)|| Analytics|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)|| Analytics|
|[Scale AI and machine learning initiatives in regulated industries](../example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries.yml)|| AI|

#### Apache JMeter

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Migration|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)||Migration|
[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)||Migration|
[Scalable cloud applications and SRE](../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)||Web|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)||Microservices|

#### Apache Kafka
 
|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Anomaly detector process](../solution-ideas/articles/anomaly-detector-process.yml)||Analytics|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)||Containers|
|[Asynchronous messaging options](/azure/architecture/guide/technology-choices/messaging)||Integration|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)||Web|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)||Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)||Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Containers|
|[Choose a real-time message ingestion technology](../data-guide/technology-choices/real-time-ingestion.md)||Databases|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)||Analytics|
|[Claim-Check pattern](/azure/architecture/patterns/claim-check)||Integration|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)||Containers|
|[Extract actionable insights from IoT data](/azure/architecture/industries/manufacturing/extract-insights-iot-data)||Serverless|
|[Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)||Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)||Containers|
|[Integrate Event Hubs with Azure Functions](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)||Serverless|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)||Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)||Migration|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)||Mainframe|
|[Partitioning in Event Hubs and Kafka](../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)||Analytics|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations)||Serverless|
|[Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)||Integration|
|[Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern)||Integration|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Databases|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)||Mainframe|
|[Scalable order processing](../example-scenario/data/ecommerce-order-processing.yml)||Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)||Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)||Databases|

#### Apache MapReduce

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Asynchronous messaging options](/azure/architecture/guide/technology-choices/messaging)||Integration|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)||Analytics|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)||Analytics|
|[Geode pattern](/azure/architecture/patterns/geodes)||Databases|
|[Minimize coordination](/azure/architecture/guide/design-principles/minimize-coordination)||Databases|

#### Apache NiFi

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](/azure/architecture/guide/data/monitor-apache-nifi-monitofi)||Analytics|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)||Analytics|
|[Helm-based deployments for Apache NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi)||Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)||Analytics|

#### Apache Oozie

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)||Databases|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
|[Choose a data pipeline orchestration technology](../data-guide/technology-choices/pipeline-orchestration-data-movement.md)||Databases|
|[Data warehousing in Microsoft Azure](../data-guide/relational-data/data-warehousing.yml)||Databases|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Databases|

#### Apache Solr

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)||Databases|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)||Databases|

#### Apache Spark

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](/azure/architecture/industries/finance/actuarial-risk-analysis-financial-model)||Analytics|
|[Advanced analytics](../solution-ideas/articles/advanced-analytics-on-big-data.yml)||Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)||AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)||AI|
|[Analytics end-to-end with Azure Synapse](../example-scenario/dataplate2e/data-platform-end-to-end.yml)||Analytics|
|[Batch processing](../data-guide/big-data/batch-processing.yml)||Databases|
|[Batch scoring of Spark on Azure Databricks](../reference-architectures/ai/batch-scoring-databricks.yml)||AI|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)||Databases|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
|[Build a content-based recommendation system](../example-scenario/ai/scalable-personalization-with-content-based-recommendation-system.yml)||Analytics|
|[Build cloud native applications](../solution-ideas/articles/cloud-native-apps.yml)||Containers|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)||Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)||Analytics|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)||Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)||Analytics|
|[Customer 360 with Azure Synapse and Dynamics 365 Customer Insights](../example-scenario/analytics/synapse-customer-insights.yml)||Analytics|
|[Data science and machine learning with Azure Databricks](../solution-ideas/articles/azure-databricks-data-science-machine-learning.yml)||AI|
|[Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)||Databases|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)||Analytics|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)||Analytics|
|[IoT using Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)||IoT|
|[Loan charge-off predictions with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)||Databases|
|[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)||AI|
|[Microsoft machine learning products](../data-guide/technology-choices/data-science-and-machine-learning.md)||AI|
|[Modern data warehouse for small and medium business](../example-scenario/data/small-medium-data-warehouse.yml)||Analytics|
|[Natural language processing technology](../data-guide/technology-choices/natural-language-processing.yml)||AI|
|[Observability patterns and metrics](/azure/architecture/databricks-monitoring/databricks-observability)||Databases|
|[Real-time analytics on big data architecture](../solution-ideas/articles/real-time-analytics.yml)||Analytics|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Analytics|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)||Analytics|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)||Databases|

#### Apache Sqoop

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Batch processing](../data-guide/big-data/batch-processing.yml) (Databases)
[Big data architectures](../data-guide/big-data/index.yml) (Databases)
[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md) (Databases)
[Real time processing](../data-guide/big-data/real-time-processing.yml) (Databases)

#### Apache Storm

[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml) (AI)
[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml) (AI)

[Big data architectures](../data-guide/big-data/index.yml) (Databases)

[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md) (Analytics)

[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml) (Databases)

[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml) (IoT)

[Real time processing](../data-guide/big-data/real-time-processing.yml) (Databases)

    -   Apache Zookeeper

[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml) (Analytics)

        -   [Helm-based deployments for Apache
            > NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi) (Analytics)

        -   [Leader Election
            > pattern](/azure/architecture/patterns/leader-election) (Analytics)

        -   [Rate Limiting
            > pattern](/azure/architecture/patterns/rate-limiting-pattern) (Integration)

## Scenarios featuring third-party technologies on Azure

## Related resources
