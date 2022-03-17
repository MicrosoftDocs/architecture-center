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
|[High availability in Azure public MEC](../example-scenario/hybrid/multi-access-edge-compute-ha.yml)|Learn how to deploy workloads in active/standby mode to achieve high availability and disaster recovery in Azure public MEC.| Hybrid|
|[IoT and data analytics](../example-scenario/data/big-data-with-iot.yml)| Build solutions that integrate data from many IoT devices into a comprehensive data analysis architecture to improve and automate decision making.|Analytics|
|[N-tier application with Apache Cassandra](../reference-architectures/n-tier/n-tier-cassandra.yml)|Deploy Linux virtual machines and a virtual network configured for an N-tier architecture with Apache Cassandra in Microsoft Azure.| Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml) |Learn about non-relational databases that store data as key/value pairs, graphs, time series, objects, and other storage models, based on data requirements.|Databases|
|[Run Apache Cassandra on Azure VMs](../best-practices/cassandra.md)|Examine performance considerations for running Apache Cassandra on Azure virtual machines. Use these recommendations as a baseline to test against your workload.| Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)|Stream events by using fully managed Azure data services. Use open-source technologies like Kafka, Kubernetes, Cassandra, PostgreSQL, and Redis components.| Analytics|

#### Apache CouchDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable web application](../reference-architectures/app-service-web-app/scalable-web-app.yml) |Use the proven practices in this reference architecture to improve scalability and performance in an Azure App Service web application.|Web

#### Apache Hadoop

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Actuarial risk analysis and financial modeling](/azure/architecture/industries/finance/actuarial-risk-analysis-financial-model)|How an actuarial developer can move an existing solution plus supporting infrastructure to Azure.| Analytics|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub and integrate it with your applications for low-latency intelligence.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Harness the power of edge AI when disconnected from the internet and move your AI models to the edge with a solution architecture that includes Azure Stack Hub.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data too large or complex for traditional database systems.| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|Build and deploy a machine learning model to maximize the purchase rate of leads that are targeted by a marketing campaign using Microsoft Machine Learning Server.| Databases|
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)|Learn about Azure data transfer options like Import/Export, Data Box, Data Factory, and command line and graphical interface tools.| Databases|
|[Citizen AI with the Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)|Learn how to user Azure Machine Learning and Microsoft Power Platform to quickly create a machine learning (ML) proof of concept, and a production version.| AI|
|[Data considerations for microservices](/azure/architecture/microservices/design/data-considerations)|Learn about managing data in a microservices architecture. Data integrity and data consistency are critical challenges for microservices.| Microservices|
|[Extend your on-premises big data investments with HDInsight](../solution-ideas/articles/extend-your-on-premises-big-data-investments-with-hdinsight.yml)|Extend your on-premises big data investments to the cloud. Transform your business by using the advanced analytics capabilities of Azure HDInsight.| Analytics|
|[Extract actionable insights from IoT data](/azure/architecture/industries/manufacturing/extract-insights-iot-data)|Extract insights from IoT data with Azure services.| Analytics|
|[Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)|Learn about extract-transform-load (ETL) and extract-load-transform (ELT) data transformation pipelines, and how to use control flows and data flows.| Analytics|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|Extract, transform, and load (ETL) big data clusters on demand by using Azure HDInsight, Hadoop MapReduce, and Apache Spark.| Analytics|
|[Gaming using Azure Database for MySQL](../solution-ideas/articles/gaming-using-azure-database-for-mysql.yml)|Use Azure Database for MySQL for gaming solutions so that databases scale elastically with traffic bursts and deliver low-latency multi-player experiences.| Databases|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|Use Apache Hive Live Long And Process (LLAP) to perform fast, interactive SQL queries at scale, over structured or unstructured data.| Databases|
|[IoT analyze and optimize loops](../example-scenario/iot/analyze-optimize-loop.yml)|Learn about analyze and optimize loops, an IoT pattern for generating and applying optimization insights based on the entire business context.| IoT|
|[Leader Election pattern](/azure/architecture/patterns/leader-election)|Learn how use the Leader Election pattern to coordinate the actions performed by a collection of collaborating task instances in a distributed application.| Analytics|
|[Master data management with Azure and CluedIn](../reference-architectures/data/cluedin.yml)|Use CluedIn eventual connectivity data integration to blend data from many siloed data sources and prepare it for analytics and business operations.| Databases|
|[Materialized View pattern](/azure/architecture/patterns/materialized-view)|Generate prepopulated views over the data in one or more data stores when the data isn't ideally formatted for required query operations.| Databases|
|[Predict loan charge-offs with HDInsight Spark](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|By using Azure HDInsight, a lending institution can use machine learning to predict the likelihood of loans getting charged off.| Databases|
|[Predictive maintenance for industrial IoT](../solution-ideas/articles/iot-predictive-maintenance.yml)|Connect devices that use the Open Platform Communication Unified Architecture standard to the cloud, and use predictive maintenance to optimize production.| IoT|
|[Streaming using HDInsight](../solution-ideas/articles/streaming-using-hdinsight.yml)|Ingest and process millions of streaming events per second with Apache Kafka, Apache Storm, and Apache Spark Streaming.| Databases|

#### Apache HBase

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)|Bring your trained AI model to the edge with Azure Stack Hub and integrate it with your applications for low-latency intelligence.| AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)|Harness the power of edge AI when disconnected from the internet and move your AI models to the edge with a solution architecture that includes Azure Stack Hub.| AI|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|Learn about big data batch processing solutions to load, transform, and prepare data at rest for analytics and reporting.| Databases|
|[Big data architectures](../data-guide/big-data/index.yml)|Learn about big data architectures that handle the ingestion, processing, and analysis of data too large or complex for traditional database systems.| Databases|
|[Choose a big data storage technology](../data-guide/technology-choices/data-storage.md)|Compare big data storage technology options in Azure, including key selection criteria and a capability matrix.| Databases|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|Evaluate analytical data store options for big data in Azure, including key selection criteria and a capability matrix.| Analytics|
|[Data partitioning guidance](../best-practices/data-partitioning.yml)|View guidance for how to separate data partitions to be managed and accessed separately. Understand horizontal, vertical, and functional partitioning strategies. | Databases|
|[Non-relational data and NoSQL](../data-guide/big-data/non-relational-data.yml)|Learn about non-relational databases that store data as key/value pairs, graphs, time series, objects, and other storage models, based on data requirements.| Databases|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)|Use real-time processing solutions to capture data streams and generate reports or automated responses with minimal latency.| Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)|Analyze time series data like sensor data, stock prices, click stream data, or app telemetry for historical trends, real-time alerts, or predictive modeling.| Databases|

#### Apache Hive

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Batch processing](../data-guide/big-data/batch-processing.yml)|| Analytics|
|[Big data architectures](../data-guide/big-data/index.yml)|| Databases|
|[Campaign optimization with HDInsight Spark](../solution-ideas/articles/campaign-optimization-with-azure-hdinsight-spark-clusters.yml)|| Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)|Compare technology choices for big data batch processing in Azure, including key selection criteria and a capability matrix.| Analytics|
|[Choose an analytical data store](../data-guide/technology-choices/analytical-data-stores.md)|| Analytics|
|[Data warehousing in Microsoft Azure](../data-guide/relational-data/data-warehousing.yml)|Learn about data warehousing in Azure. A data warehouse is a repository of integrated data from disparate sources used for reporting and analysis of the data.| Databases|
|[Extract, transform, and load (ETL)](../data-guide/relational-data/etl.yml)|| Databases|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)|| Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)|| Databases|
|[Loan charge-off prediction with HDInsight Spark clusters](../solution-ideas/articles/loan-chargeoff-prediction-with-azure-hdinsight-spark-clusters.yml)|| Analytics|
|[Predictive aircraft engine monitoring](../solution-ideas/articles/aircraft-engine-monitoring-for-predictive-maintenance-in-aerospace.yml)|Demonstrates how to combine real-time aircraft data with analytics to create a solution for predictive aircraft engine monitoring and health.| Analytics|
|[Predictive insights with vehicle telematics](../solution-ideas/articles/predictive-insights-with-vehicle-telematics.yml)|| Analytics|
|[Predictive maintenance](../solution-ideas/articles/predictive-maintenance.yml)|Car dealerships, manufacturers, and insurance companies can use Microsoft Azure to gain predictive insights on vehicle health and driving habits.| Analytics|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)|| Analytics|
|[Scale AI and machine learning initiatives in regulated industries](../example-scenario/ai/scale-ai-and-machine-learning-in-regulated-industries.yml)|Learn about scaling Azure AI and machine learning environments that must comply with extensive security policies.| AI|

#### Apache JMeter

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)|Use simulated and actual applications and existing workloads to monitor the reaction of the solution infrastructure for scalability and performance.|Migration|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)|This article provides an overview of an implementation for a scalable cloud load testing pipeline.|Migration|
[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)|Details about the patterns and implementations used when the commercial software engineer team created the banking system cloud transformation solution.|Migration|
[Scalable cloud applications and SRE](../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)|Build scalable cloud applications by using performance modeling and other principles and practices of site reliability engineering (SRE).|Web|
|[Unified logging for microservices apps](../example-scenario/logging/unified-logging.yml)|Learn about logging, tracing, and monitoring for microservices apps and learn how to run synthetic logging for testing and create structured logs for analysis.|Microservices|

#### Apache Kafka
 
|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Anomaly detector process](../solution-ideas/articles/anomaly-detector-process.yml)|Learn about Anomaly Detector and see how anomaly detection models are selected with time-series data.|Analytics|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)|Deploy Astra Control Service with Azure NetApp Files for data protection, disaster recovery, and mobility for Azure Kubernetes Service (AKS) applications.|Containers|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)|Learn about asynchronous messaging options in Azure, including the different types of messages and the entities that participate in a messaging infrastructure.|Integration|
|[Automated guided vehicles fleet control](../example-scenario/iot/automated-guided-vehicles-fleet-control.yml)|This example architecture shows an end-to-end approach for an automotive original equipment manufacturer (OEM) and includes a reference architecture and several published supporting open-source libraries that can be reused.|Web|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)|Use interactive analytics in Azure Data Explorer. Examine structured, semi-structured, and unstructured data with improvised, interactive, and fast queries.|Analytics|
|[Azure Data Explorer monitoring](../solution-ideas/articles/monitor-azure-data-explorer.yml)|Use Azure Data Explorer in a hybrid monitoring solution that includes Microsoft Sentinel and Azure Monitor to ingest streamed and batched logs from diverse sources.|Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Containers|
|[Choose a real-time message ingestion technology](../data-guide/technology-choices/real-time-ingestion.md)|Choose an Azure message ingestion store to support message buffering, scale-out processing, reliable delivery, and queuing semantics.|Databases|
|[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)|Compare options for real-time message stream processing in Azure, with key selection criteria and a capability matrix.|Analytics|
|[Claim-Check pattern](../patterns/claim-check.yml)||Integration|
|[Data streaming with AKS](../solution-ideas/articles/data-streaming-scenario.yml)||Containers|
|[Extract actionable insights from IoT data](../industries/manufacturing/extract-insights-iot-data.yml)||Serverless|
|[Ingestion, ETL, and stream processing pipelines with Azure Databricks](../solution-ideas/articles/ingest-etl-stream-with-adb.yml)||Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)||Containers|
|[Integrate Event Hubs with Azure Functions](../serverless/event-hubs-functions/event-hubs-functions.yml)||Serverless|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)||Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)||Migration|
|[Mainframe and midrange data replication to Azure using Qlik](../example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik.yml)||Mainframe|
|[Partitioning in Event Hubs and Kafka](../reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka.yml)||Analytics|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)||Serverless|
|[Publisher-Subscriber pattern](../patterns/publisher-subscriber.yml)||Integration|
|[Rate Limiting pattern](../patterns/rate-limiting-pattern.yml)||Integration|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Databases|
|[Refactor mainframe applications with Advanced](../example-scenario/mainframe/refactor-mainframe-applications-advanced.yml)||Mainframe|
|[Scalable order processing](../example-scenario/data/ecommerce-order-processing.yml)||Databases|
|[Stream processing with fully managed open-source data engines](../example-scenario/data/open-source-data-engine-stream-processing.yml)||Analytics|
|[Time series data](../data-guide/scenarios/time-series.yml)||Databases|

#### Apache MapReduce

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Asynchronous messaging options](../guide/technology-choices/messaging.yml)||Integration|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
|[Choose a batch processing technology](../data-guide/technology-choices/batch-processing.md)||Analytics|
|[Extract, transform, and load (ETL) using HDInsight](../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)||Analytics|
|[Geode pattern](../patterns/geodes.yml)||Databases|
|[Minimize coordination](../guide/design-principles/minimize-coordination.yml)||Databases|

#### Apache NiFi

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](../guide/data/monitor-apache-nifi-monitofi.yml)||Analytics|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)||Analytics|
|[Helm-based deployments for Apache NiFi](../guide/data/helm-deployments-apache-nifi.yml)||Analytics|
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
|[Actuarial risk analysis and financial modeling](../industries/finance/actuarial-risk-analysis-financial-model.yml)||Analytics|
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
|[Batch processing](../data-guide/big-data/batch-processing.yml)||Databases|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases
|[Choose a data transfer technology](../data-guide/scenarios/data-transfer.md)||Databases|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Databases|

#### Apache Storm

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AI at the edge with Azure Stack Hub](../solution-ideas/articles/ai-at-the-edge.yml)||AI|
|[AI at the edge with Azure Stack Hub - disconnected](../solution-ideas/articles/ai-at-the-edge-disconnected.yml)||AI|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
[Choose a stream processing technology](../data-guide/technology-choices/stream-processing.md)||Analytics|
|[Interactive querying with HDInsight](../solution-ideas/articles/interactive-querying-with-hdinsight.yml)||Databases|
|[IoT using Azure Cosmos DB](../solution-ideas/articles/iot-using-cosmos-db.yml)||IoT|
|[Real time processing](../data-guide/big-data/real-time-processing.yml)||Databases|

#### Apache Zookeeper

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi on Azure](../example-scenario/data/azure-nifi.yml)||Analytics|
|[Helm-based deployments for Apache NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi)||Analytics|
|[Leader Election pattern](/azure/architecture/patterns/leader-election)||Analytics|
|[Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern)||Integration|

### BeeGFS

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)||Media|
|[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)||Compute|

### Chef

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Building blocks for autonomous-driving simulation environments](/azure/architecture/industries/automotive/building-blocks-autonomous-driving-simulation-environments)||Containers|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)||DevOps
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)||Management|

### CNCF

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)||Hybrid|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)||Containers|
|[Multi-cloud blockchain distributed ledger technology (DLT)](../example-scenario/blockchain/multi-cloud-blockchain.yml)||Blockchain|

### Elastic

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)||Containers|
|[Choose a search data store](../data-guide/technology-choices/search-options.md)||Databases|
|[Elastic Workplace Search on Azure](../solution-ideas/articles/elastic-workplace-search.yml)||Integration|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)||Containers|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)||Containers|
|[Monitoring and diagnostics guidance](../best-practices/monitoring.yml)||Management|
|[Processing free-form text for search](../data-guide/scenarios/search.yml)||Databases|

### GlusterFS

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)||Media|
|[SAP S/4HANA in Linux on Azure](../reference-architectures/sap/sap-s4hana.yml)||SAP|

### Grafana

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](/azure/architecture/guide/data/monitor-apache-nifi-monitofi)||Analytics|
|[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)||Analytics|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Migration|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)||Containers|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)||Containers|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)||Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)||DevOps|
|[Content Delivery Network analytics](../solution-ideas/articles/content-delivery-network-azure-data-explorer.yml)||Analytics|
|[Enterprise monitoring with Azure Monitor](../example-scenario/monitoring/enterprise-monitoring.yml)||DevOps|
|[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)||Analytics|
|[JMeter implementation for a load testing pipeline](../example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference.yml)||Migration|
|[Long-term security log retention with Azure Data Explorer](../example-scenario/security/security-log-retention-azure-data-explorer.yml)||Analytics|
|[Optimize administration of SQL Server instances in on-premises and multi-cloud environments by using Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)||Databases|
|[SAP workload automation using SUSE on Azure](../solution-ideas/articles/sap-workload-automation-suse.yml)||SAP|
|[Web application monitoring on Azure](../reference-architectures/app-service-web-app/app-monitoring.yml)||Web|

### InfluxDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Apache NiFi monitoring with MonitoFi](/azure/architecture/guide/data/monitor-apache-nifi-monitofi)||Analytics|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)||Microservices|

### Jenkins

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)||Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Migration|
|[Big data architectures](../data-guide/big-data/index.yml)||Databases|
|[Building blocks for autonomous-driving simulation environments](/azure/architecture/industries/automotive/building-blocks-autonomous-driving-simulation-environments)||Compute|
|[CI/CD pipeline for container-based workloads](../example-scenario/apps/devops-with-aks.yml)||Containers|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)||DevOps|
|[Design a CI/CD pipeline using Azure DevOps](../example-scenario/apps/devops-dotnet-webapp.yml)||DevOps|
|[DevSecOps with a rolling main branching strategy](../solution-ideas/articles/devsecops-rolling-branch.yml)||DevOps|
|[DevTest Image Factory](../solution-ideas/articles/dev-test-image-factory.yml)||DevOps|
|[End-to-end governance in Azure](../example-scenario/governance/end-to-end-governance-in-azure.yml)||Management|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](../solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview.yml)||DevOps|
|[Java CI/CD using Jenkins and Azure Web Apps](../solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps.yml)||DevOps|
|[MLOps for Python with Azure Machine Learning](../reference-architectures/ai/mlops-python.yml)||AI|
|[Run a Jenkins server on Azure](../example-scenario/apps/jenkins.yml)||DevOps|

### Jupyter

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Automating diagnostic Jupyter Notebook execution](../example-scenario/data/automating-diagnostic-jupyter-notebook.yml)||DevOps|
[Azure Data Explorer interactive analytics](../solution-ideas/articles/interactive-azure-data-explorer.yml)||Analytics|
[Azure Machine Learning decision guide for optimal tool selection](../example-scenario/mlops/aml-decision-tree.yml)||AI|
[Choose a data analytics and reporting technology](../data-guide/technology-choices/analysis-visualizations-reporting.md)||Databases|
[Citizen AI with the Power Platform](../example-scenario/ai/citizen-ai-power-platform.yml)||AI|
[Data analysis in Azure Industrial IoT analytics solution](/azure/architecture/guide/iiot-guidance/iiot-data)||IoT|
[DevOps for quantum computing](/azure/architecture/guide/quantum/devops-for-quantum-computing)||DevOps|
[IoT analytics with Azure Data Explorer](../solution-ideas/articles/iot-azure-data-explorer.yml)||Analytics|
[Machine learning operations (MLOps) framework to upscale machine learning lifecycle with Azure Machine Learning](../example-scenario/mlops/mlops-technical-paper.yml)||AI|
[Many models machine learning with Spark](../example-scenario/ai/many-models-machine-learning-azure-spark.yml)||AI|
[Precision medicine pipeline with genomics](../example-scenario/precision-medicine/genomic-analysis-reporting.yml)||Analytics|
[Tune hyperparameters for ML models in Python](../reference-architectures/ai/training-python-models.yml)||AI|

### KEDA

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Functions in a hybrid environment](/azure/architecture/hybrid/azure-functions-hybrid)||Serverless|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)||Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)||Containers|
|[Integrate Event Hubs with Azure Functions](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)||Serverless|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)||Serverless|

### Kubernetes

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Advanced Azure Kubernetes Service (AKS) microservices architecture](../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)||Continers|
|[Application data protection for AKS workloads on Azure NetApp Files](../example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files.yml)||Containers|
|[Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)||Hybrid|
|[Azure Kubernetes in event stream processing](../solution-ideas/articles/serverless-event-processing-aks.yml)||Containers|
|[Banking system cloud transformation on Azure](../example-scenario/banking/banking-system-cloud-transformation.yml)||Containers|
|[Baseline architecture for an AKS cluster](../reference-architectures/containers/aks/secure-baseline-aks.yml)||Containers|
|[Big data analytics on confidential computing](../example-scenario/confidential/data-analytics-containers-spark-kubernetes-azure-sql.yml)||Analytics|
|[Build a CI/CD pipeline for microservices on Kubernetes](/azure/architecture/microservices/ci-cd-kubernetes)||Microservices|
|[Build CNCF projects by using Azure Kubernetes Service](../example-scenario/apps/build-cncf-incubated-graduated-projects-aks.yml)||Containers|
|[Choose a bare-metal Kubernetes at the edge platform option](/azure/architecture/operator-guides/aks/choose-bare-metal-kubernetes)||Containers|
|[Choose a Kubernetes at the edge compute option](/azure/architecture/operator-guides/aks/choose-kubernetes-edge-compute-option)||Containers|
|[Choose an Azure multiparty computing service](/azure/architecture/guide/technology-choices/multiparty-computing-service)||Blockchain|
|[Container CI/CD using Jenkins and Kubernetes on AKS](../solution-ideas/articles/container-cicd-using-jenkins-and-kubernetes-on-azure-container-service.yml)||DevOps|
|[Container orchestration for microservices](/azure/architecture/microservices/design/orchestration)||Microservices|
|[Create a CI/CD pipeline for AI apps using Azure Pipelines, Docker, and Kubernetes](/azure/architecture/data-science-process/ci-cd-flask)||AI|
|[Employee retention with Databricks and Kubernetes](../example-scenario/ai/employee-retention-databricks-kubernetes.yml)||Analytics|
|[GitOps for Azure Kubernetes Service](../example-scenario/gitops-aks/gitops-blueprint-aks.yml)||Containers|
|[Helm-based deployments for Apache NiFi](/azure/architecture/guide/data/helm-deployments-apache-nifi)||Analytics|
|[Instant IoT data streaming with AKS](../solution-ideas/articles/aks-iot-data-streaming.yml)||Containers|
|[Microservices architecture on AKS](../reference-architectures/containers/aks-microservices/aks-microservices.yml)||Containers|
|[Microservices with AKS and Azure DevOps](../solution-ideas/articles/microservices-with-aks.yml)||Containers|
|[Patterns and implementations for a banking cloud transformation](../example-scenario/banking/patterns-and-implementations.yml)||Serverless|
|[Secure DevOps for AKS](../solution-ideas/articles/secure-devops-for-kubernetes.yml)||Containers|
|[Use Application Gateway Ingress Controller (AGIC) with a multi-tenant Azure Kubernetes Service](../example-scenario/aks-agic/aks-agic.yml)||Containers|
|[Use Azure Firewall to help protect an AKS cluster](../example-scenario/aks-firewall/aks-firewall.yml)||Containers|

### Lustre

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Digital image-based modeling on Azure](../example-scenario/infrastructure/image-modeling.yml)||Media|
[Run reservoir simulation software on Azure](../example-scenario/infrastructure/reservoir-simulation.yml)||Compute|
[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|

### MariaDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Core startup stack architecture](/azure/architecture/example-scenario/startups/core-startup-stack)||Startup|
|[Mainframe and midrange data replication to Azure using Qlik](/azure/architecture/example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik)||Mainframe|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)||Mainframe|
|[Modernize mainframe and midrange data](/azure/architecture/reference-architectures/migration/modernize-mainframe-data-to-azure)||Mainframe|
|[Replicate and sync mainframe data in Azure](/azure/architecture/reference-architectures/migration/sync-mainframe-data-with-azure)||Mainframe|
|[Scalable and secure WordPress on Azure](/azure/architecture/example-scenario/infrastructure/wordpress)||Web|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)||Databases|

### MLflow

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Azure Machine Learning decision guide for optimal tool selection](/azure/architecture/example-scenario/mlops/aml-decision-tree)||AI|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)||AI|
|[Determine customer lifetime value and churn with Azure AI services](/azure/architecture/example-scenario/ai/customer-lifecycle-churn)||AI|
|[Employee retention with Databricks and Kubernetes](/azure/architecture/example-scenario/ai/employee-retention-databricks-kubernetes)||Analytics|
|[Modern analytics architecture with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)||Analytics|
|[Orchestrate MLOps on Azure Databricks using Databricks Notebook](/azure/architecture/reference-architectures/ai/orchestrate-mlops-azure-databricks)||AI|
|[Population health management for healthcare](/azure/architecture/solution-ideas/articles/population-health-management-for-healthcare)||AI|

### Moodle

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files)||Storage|

### MySQL

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
[Build CNCF projects by using Azure Kubernetes Service](/azure/architecture/example-scenario/apps/build-cncf-incubated-graduated-projects-aks)||Containers|
[Build web and mobile applications with MySQL and Redis](/azure/architecture/solution-ideas/articles/webapps)||Web|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)||Databases|
|[Finance management apps with Azure DB for MySQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-mysql)||Databases|
| [Gaming using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/gaming-using-azure-database-for-mysql)||Databases|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|
|[IBM z/OS online transaction processing on Azure](/azure/architecture/example-scenario/mainframe/ibm-zos-online-transaction-processing-azure)||Mainframe|
|[Intelligent apps using Azure Database for MySQL](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-mysql)||Databases|
|[Java CI/CD using Jenkins and Azure Web Apps](/azure/architecture/solution-ideas/articles/java-cicd-using-jenkins-and-azure-web-apps)||DevOps|
|[Lift and shift to containers with AKS](/azure/architecture/solution-ideas/articles/migrate-existing-applications-with-aks)||Containers|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)||Mainframe|
|[Microservices with AKS](/azure/architecture/solution-ideas/articles/microservices-with-aks)||Containers|
|[Online transaction processing (OLTP)](/azure/architecture/data-guide/relational-data/online-transaction-processing)||Databases|
|[Retail and e-commerce using Azure MySQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-mysql)||Databases|
|[Scalable apps using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql)||Mobile|
|[Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)||Security|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)||Databases|

### PostgreSQL

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
|[Azure Database for PostgreSQL intelligent apps](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql)||Databases|
|[Build a telehealth system on Azure](/azure/architecture/example-scenario/apps/telehealth-system)||Databases|
|[Build cloud native applications](/azure/architecture/solution-ideas/articles/cloud-native-apps)||Containers|
|[Data cache](/azure/architecture/solution-ideas/articles/data-cache-with-redis-cache)||Databases|
|[Data streaming with AKS](/azure/architecture/solution-ideas/articles/data-streaming-scenario)||Containers|
|[Digital campaign management](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-postgresql)||Databases|
|[Finance management apps using Azure Database for PostgreSQL](/azure/architecture/solution-ideas/articles/finance-management-apps-using-azure-database-for-postgresql)||Databases|
|[Geospatial data processing and analytics](/azure/architecture/example-scenario/data/geospatial-data-processing-analytics-azure)||Analytics|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|
|[IBM z/OS online transaction processing on Azure](/azure/architecture/example-scenario/mainframe/ibm-zos-online-transaction-processing-azure)||Mainframe|
|[Integrate IBM mainframe and midrange message queues with Azure](/azure/architecture/example-scenario/mainframe/integrate-ibm-message-queues-azure)||Mainframe|
|[Azure Database for PostgreSQL intelligent apps](/azure/architecture/solution-ideas/articles/intelligent-apps-using-azure-database-for-postgresql)||Databases|
|[Mainframe file replication and sync on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication)||Mainframe|
|[Online transaction processing (OLTP)](/azure/architecture/data-guide/relational-data/online-transaction-processing)||Databases|
|[Oracle database migration: Refactor](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-refactor)||Migration|
|[Overview of Oracle database migration](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-overview)||Migration|
|[Retail and e-commerce using Azure PostgreSQL](/azure/architecture/solution-ideas/articles/retail-and-ecommerce-using-azure-database-for-postgresql)||Databases|
|[Scalable apps using Azure DB for PostgreSQL](/azure/architecture/solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-postgresql)||Mobile|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Understand data store models](/azure/architecture/guide/technology-choices/data-store-overview)||Databases|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](/azure/architecture/example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure)||Mainframe|

### Prometheus

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
|[Architecture of an AKS regulated cluster for PCI-DSS 3.2.1](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-ra-code-assets)||Containers|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)||Migration|
|[Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)||Containers|
|[Build CNCF projects by using Azure Kubernetes Service](/azure/architecture/example-scenario/apps/build-cncf-incubated-graduated-projects-aks)||Containers|
|[JMeter implementation for a load testing pipeline](/azure/architecture/example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference)||Migration|
|[Microservices architecture on AKS](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)||Containers|
|[Monitor a microservices app in AKS](/azure/architecture/microservices/logging-monitoring)||Containers|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)||SAP|

### PyTorch

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)||AI|
|[Machine learning in IoT Edge Vision](/azure/architecture/guide/iot-edge-vision/machine-learning)||IoT|
|[Real-time scoring of machine learning models](/azure/architecture/reference-architectures/ai/real-time-scoring-machine-learning-models)||AI|

### RabbitMQ

|Azrchitecture|Summary|Technology focus|
|--|--|--|
[Automated guided vehicles fleet control](/azure/architecture/example-scenario/iot/automated-guided-vehicles-fleet-control)||Web|
[Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)||Integration|
[Transactional Outbox pattern with Azure Cosmos DB](/azure/architecture/best-practices/transactional-outbox-cosmos)||Databases|

### Red Hat

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[AIX UNIX on-premises to Azure Linux migration](/azure/architecture/example-scenario/unix-migration/migrate-aix-azure-linux)||Mainframe|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)||Containers|
|[Container orchestration for microservices](/azure/architecture/microservices/design/orchestration)||Microservices|
|[JBoss deployment with Red Hat on Azure](/azure/architecture/solution-ideas/articles/jboss-deployment-red-hat)||Containers|
|[Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)||Compute|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub)||Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub-vsrx)||Networking|

### Redis

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)||Containers|
|[Build cloud native applications](/azure/architecture/solution-ideas/articles/cloud-native-apps)||Containers|
|[Build web and mobile applications](/azure/architecture/solution-ideas/articles/webapps) with MySQL and Redis||Web|
|[COVID-19 safe solutions with IoT Edge](/azure/architecture/solution-ideas/articles/cctv-iot-edge-for-covid-19-safe-environment-and-mask-detection)||IoT|
|[Data cache](/azure/architecture/solution-ideas/articles/data-cache-with-redis-cache)||Databases|
|[Data streaming with AKS](/azure/architecture/solution-ideas/articles/data-streaming-scenario)||Containers|
|[DevTest and DevOps for PaaS solutions](/azure/architecture/solution-ideas/articles/dev-test-paas)||DevOps|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)||Databases|
|[Messaging](/azure/architecture/solution-ideas/articles/messaging)||Databases|
|[Non-relational data and NoSQL](/azure/architecture/data-guide/big-data/non-relational-data)||Databases|
|[Personalized offers](/azure/architecture/solution-ideas/articles/personalized-offers)||AI|
|[Publisher-Subscriber pattern](/azure/architecture/patterns/publisher-subscriber)||Integration|
|[Rate Limiting pattern](/azure/architecture/patterns/rate-limiting-pattern)||Integration|
|[Re-engineer mainframe batch applications on Azure](/azure/architecture/example-scenario/mainframe/reengineer-mainframe-batch-apps-azure)||Mainframe|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[Scalable Sitecore marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-sitecore)||Web|
|[Scalable web apps with Azure Redis Cache](/azure/architecture/solution-ideas/articles/scalable-web-apps)||Web|
|[Scalable web application](/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)||Web|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|
|[Supply chain track and trace](/azure/architecture/solution-ideas/articles/supply-chain-track-and-trace)||IoT|

### SUSE

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[Run SAP HANA Large Instances](/azure/architecture/reference-architectures/sap/hana-large-instances)||SAP|
|[SAP deployment in Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||SAP|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)||SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|

### TensorFlow

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
|[Data science and machine learning with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-data-science-machine-learning)||AI|
|[Distributed training, deep learning models](/azure/architecture/reference-architectures/ai/training-deep-learning)||AI|
|[Machine learning in IoT Edge Vision](/azure/architecture/guide/iot-edge-vision/machine-learning)||IoT|
|[Real-time scoring of machine learning models](/azure/architecture/reference-architectures/ai/real-time-scoring-machine-learning-models)||AI|
|[Vision classifier model with Azure Custom Vision Cognitive Service](/azure/architecture/example-scenario/dronerescue/vision-classifier-model-with-custom-vision)||AI|

### Terraform

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Architectural approaches for the deployment and configuration of multitenant solutions](/azure/architecture/guide/multitenant/approaches/deployment-configuration)||Multitenancy|
|[Automated guided vehicles fleet control](/azure/architecture/example-scenario/iot/automated-guided-vehicles-fleet-control)||Web|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)||Migration|
|[Deployment Stamps pattern](/azure/architecture/patterns/deployment-stamp)||Networking|
|[Design a CI/CD pipeline using Azure DevOps](/azure/architecture/example-scenario/apps/devops-dotnet-webapp)||DevOps|
|[DevOps in a hybrid environment](/azure/architecture/solution-ideas/articles/devops-in-a-hybrid-environment)||DevOps|
|[DevSecOps in Azure](/azure/architecture/solution-ideas/articles/devsecops-in-azure)||DevOps|
|[DevTest and DevOps for PaaS solutions](/azure/architecture/solution-ideas/articles/dev-test-paas)||DevOps|
|[End-to-end governance in Azure](/azure/architecture/example-scenario/governance/end-to-end-governance-in-azure)||Management|
|[Gridwich cloud media system](/azure/architecture/reference-architectures/media-services/gridwich-architecture)||Media|
|[Gridwich CI/CD pipeline](/azure/architecture/reference-architectures/media-services/gridwich-cicd)||Media|
|[Gridwich keys and secrets management](/azure/architecture/reference-architectures/media-services/maintain-keys)||Media|
|[Gridwich Media Services setup and scaling](/azure/architecture/reference-architectures/media-services/media-services-setup-scale)||Media|
|[Gridwich pipeline-generated admin scripts](/azure/architecture/reference-architectures/media-services/run-admin-scripts)||Media
|[Gridwich variable flow](/azure/architecture/reference-architectures/media-services/variable-group-terraform-flow)||Media|
|[Immutable infrastructure CI/CD using Jenkins and Terraform on Azure](/azure/architecture/solution-ideas/articles/immutable-infrastructure-cicd-using-jenkins-and-terraform-on-azure-virtual-architecture-overview)||DevOps|
|[JMeter implementation for a load testing pipeline](/azure/architecture/example-scenario/banking/jmeter-load-testing-pipeline-implementation-reference)||Migration|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)||SAP|
|[Use Azure Firewall to help protect an AKS cluster](/azure/architecture/example-scenario/aks-firewall/aks-firewall)||Containers|
|[Virtual network integrated serverless microservices](/azure/architecture/example-scenario/integrated-multiservices/virtual-network-integration)||Security|

### Umbraco

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Digital marketing using Azure DB for MySQL](/azure/architecture/solution-ideas/articles/digital-marketing-using-azure-database-for-mysql)||Databases|
|[Scalable Umbraco CMS web app](/azure/architecture/solution-ideas/articles/medium-umbraco-web-app)||Web|
|[Simple digital marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-smb)||Web|

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
|[IBM z/OS mainframe migration with Asysco](/azure/architecture/example-scenario/mainframe/asysco-zos-migration)||Mainframe|
|[Unisys mainframe migration with Asysco](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)||Mainframe|

### Astadia

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)||Mainframe|

### CluedIn

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Master Data Management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Migrate master data services to Azure with CluedIn and Azure Purview](/azure/architecture/reference-architectures/data/migrate-master-data-services-with-cluedin)||Databases|

### Confluent

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Banking system cloud transformation on Azure](/azure/architecture/example-scenario/banking/banking-system-cloud-transformation)||Migration|
|[Partitioning in Event Hubs and Kafka](/azure/architecture/reference-architectures/event-hubs/partitioning-in-event-hubs-and-kafka)||Analytics|
|[Real time processing](/azure/architecture/data-guide/big-data/real-time-processing)||Databases|

### Couchbase

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[High availability in Azure public MEC](/azure/architecture/example-scenario/hybrid/multi-access-edge-compute-ha)||Hybrid|

### Double-Take

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[SMB disaster recovery with Azure Site Recovery](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-azure-site-recovery)||Management|
|[SMB disaster recovery with Double-Take DR](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-double-take-dr)||Management|

### Episerver

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Scalable Episerver marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-episerver)||Web|

### Gremlin

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Build web and mobile applications](/azure/architecture/solution-ideas/articles/webapps)||Web|
|[Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)||Analytics|

### Initinite i

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[IBM System i (AS/400) to Azure using Infinite i](/azure/architecture/example-scenario/mainframe/ibm-system-i-azure-infinite-i)||Mainframe|

### LzLabs

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Use LzLabs Software Defined Mainframe (SDM) in an Azure VM deployment](/azure/architecture/example-scenario/mainframe/lzlabs-software-defined-mainframe-in-azure)||Mainframe|

### Micro Focus

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Micro Focus Enterprise Server on Azure VMs](/azure/architecture/example-scenario/mainframe/micro-focus-server)||Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia & Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)||Mainframe|


### MongoDB

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Advanced Azure Kubernetes Service (AKS) microservices architecture](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices-advanced)||Containers|
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Containers|
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
|[Application data protection for AKS workloads on Azure NetApp Files](/azure/architecture/example-scenario/file-storage/data-protection-kubernetes-astra-azure-netapp-files)||Storage|
|[SAP workload development and test settings](/azure/architecture/example-scenario/apps/sap-dev-test)||SAP|
|[Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery)||Storage|
|[FSLogix for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)||Hybrid|
|[General mainframe refactor to Azure](/azure/architecture/example-scenario/mainframe/general-mainframe-refactor)||Mainframe|
|[Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files)||Storage|
|[Multiple forests with AD DS and Azure AD](/azure/architecture/example-scenario/wvd/multi-forest)||Virtual Desktop|
|[Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)||Storage|
|[Refactor mainframe computer systems that run Adabas & Natural](/azure/architecture/example-scenario/mainframe/refactor-adabas-aks)||Mainframe|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[SAP deployment in Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||SAP|
|[SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAS on Azure architecture](/azure/architecture/guide/sas/sas-overview)||Compute|
|[SQL Server on Azure Virtual Machines with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files)||Storage|

### Oracle

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Master data management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Migrate IBM mainframe apps to Azure with TmaxSoft OpenFrame](/azure/architecture/solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe)||Mainframe|
|[Oracle database migration to Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-migration-to-azure)||Oracle|
|[Oracle database migration: Cross-cloud connectivity](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-cross-cloud)||Oracle|
|[Oracle database migration: Lift and shift](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-lift-shift)||Oracle|
|[Oracle database migration: Refactor](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-refactor)||Oracle|
 |[Oracle database migration: Rearchitect](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-rearchitect)||Oracle|
|[Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files)||Storage|
|[Overview of Oracle database migration](/azure/architecture/example-scenario/oracle-migrate/oracle-migration-overview)||Oracle|
|[Refactor mainframe applications with Advanced](/azure/architecture/example-scenario/mainframe/refactor-mainframe-applications-advanced)||Mainframe|
|[Run Oracle databases on Azure](/azure/architecture/solution-ideas/articles/reference-architecture-for-oracle-database-on-azure)||Oracle|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/reference-architectures/sap/sap-netweaver)||SAP|
|[SAP deployment on Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||Oracle|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||Oracle|
|[Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)||Security|
|[SWIFT\'s Alliance Access in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-on-azure)||Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-vsrx-on-azure)||Networking|
|[SWIFT\'s Alliance Messaging Hub (AMH) with Alliance Connect Virtual](/azure/architecture/example-scenario/finance/swift-alliance-messaging-hub-vsrx)||Networking|

### Postman

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Design APIs for microservices](/azure/architecture/microservices/design/api-design)||Microservices|
|[Gridwich local development environment setup](/azure/architecture/reference-architectures/media-services/set-up-local-environment)||Media|
|[Unified logging for microservices apps](/azure/architecture/example-scenario/logging/unified-logging)||Microservices|

### Profisee

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Data governance with Profisee and Azure Purview](/azure/architecture/reference-architectures/data/profisee-master-data-management-purview)||Databases|
|[Master data management with Profisee and Azure Data Factory](/azure/architecture/reference-architectures/data/profisee-master-data-management-data-factory)||Databases|

### Qlik

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Mainframe and midrange data replication to Azure using Qlik](/azure/architecture/example-scenario/mainframe/mainframe-midrange-data-replication-azure-qlik)||Mainframe|

### Raincode

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe applications to Azure with Raincode compilers](/azure/architecture/reference-architectures/app-modernization/raincode-reference-architecture)||Mainframe|

### SAP

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Add a mobile front end to a legacy app](/azure/architecture/solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application)||Mobile|
|[Custom mobile workforce app](/azure/architecture/solution-ideas/articles/custom-mobile-workforce-app)||Mobile|
|[Development and test environments for SAP workloads on Azure](/azure/architecture/example-scenario/apps/sap-dev-test)||SAP|
|[Master data management with Azure and CluedIn](/azure/architecture/reference-architectures/data/cluedin)||Databases|
|[Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)||Networking|
|[Run SAP BW/4HANA with Linux VMs](/azure/architecture/reference-architectures/sap/run-sap-bw4hana-with-linux-virtual-machines)||SAP|
|[Run SAP HANA for Linux VMs in scale-up systems](/azure/architecture/reference-architectures/sap/run-sap-hana-for-linux-virtual-machines)||SAP|
|[Run SAP HANA Large Instances](/azure/architecture/reference-architectures/sap/hana-large-instances)||SAP|
|[Run SAP NetWeaver in Windows on Azure](/azure/architecture/reference-architectures/sap/sap-netweaver)||SAP|
|[SAP deployment on Azure using an Oracle database](/azure/architecture/example-scenario/apps/sap-production)||SAP|
|[SAP on Azure architecture design](/azure/architecture/reference-architectures/sap/sap-overview)||SAP|
|[SAP NetWeaver on SQL Server](/azure/architecture/solution-ideas/articles/sap-netweaver-on-sql-server)||SAP|
|[SAP S/4 HANA for Large Instances](/azure/architecture/solution-ideas/articles/sap-s4-hana-on-hli-with-ha-and-dr)||SAP|
|[SAP S/4HANA in Linux on Azure](/azure/architecture/reference-architectures/sap/sap-s4hana)||SAP|
|[SAP system on Oracle Database on Azure](/azure/architecture/example-scenario/apps/sap-on-oracle)||SAP|
|[SAP workload automation using SUSE on Azure](/azure/architecture/solution-ideas/articles/sap-workload-automation-suse)||SAP|

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
|[Migrate AIX workloads to Skytap on Azure](/azure/architecture/example-scenario/mainframe/migrate-aix-workloads-to-skytap)||Mainframe|
|[Migrate IBM i series to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap)||Mainframe|

### Software AG

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Refactor mainframe computer systems that run Adabas & Natural](/azure/architecture/example-scenario/mainframe/refactor-adabas-aks)||Mainframe|

### Stromasys

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[Stromasys Charon-SSP Solaris emulator on Azure VMs](/azure/architecture/solution-ideas/articles/solaris-azure)||Mainframe|


### SWIFT

|Azrchitecture|Summary|Technology focus|
|--|--|--|
|[SWIFT\'s Alliance Access in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-on-azure)||Networking|
|[SWIFT\'s Alliance Access with Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-alliance-access-vsrx-on-azure)||Networking|
|[SWIFT Alliance Cloud in Azure](/azure/architecture/example-scenario/finance/swift-alliance-cloud-on-azure)||Networking|
|[SWIFT Alliance Connect in Azure](/azure/architecture/example-scenario/finance/swift-on-azure-srx)||Security|
|[SWIFT Alliance Connect Virtual in Azure](/azure/architecture/example-scenario/finance/swift-on-azure-vsrx)||Security|
|[SWIFT Alliance Lite2 on Azure](/azure/architecture/example-scenario/finance/swift-alliance-lite2-on-azure)||Networking|
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
|[Unisys ClearPath Forward mainframe rehost to Azure using Unisys virtualization](/azure/architecture/example-scenario/mainframe/unisys-clearpath-forward-mainframe-rehost)||Mainframe|
|[Unisys Dorado mainframe migration to Azure with Astadia and Micro Focus](/azure/architecture/example-scenario/mainframe/migrate-unisys-dorado-mainframe-apps-with-astadia-micro-focus)||Mainframe|
|[Unisys mainframe migration with Asysco](/azure/architecture/reference-architectures/migration/unisys-mainframe-migration)||Mainframe|

## Related resources

- Link to other, similar lists:
- Scenarios featuring Microsoft on-prem technologies (the other new article)
- Architecture for startups
- Azure and Power Platform scenarios
- Azure and Microsoft 365 scenarios
- Azure and Dynamics 365 scenarios
- Azure for AWS professionals
- Azure for Google Cloud professionals
