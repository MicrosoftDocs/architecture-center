
This article presents a solution for gauging public opinion in tweets. The goal is to create a transformation pipeline that outputs clusters of comments and trending subjects. 

*Apache™, [Apache NiFi](https://nifi.apache.org), [Apache Hadoop](https://hadoop.apache.org), [Apache Hive](https://hive.apache.org), and [Apache Airflow](https://airflow.apache.org) are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/nifi-sentiment-analysis-face-recognition-pipeline.svg" alt-text="Architecture diagram of a pipeline. Components include services for ingestion, data transformation, storage, analytics, AI, and data presentation." lightbox="./media/nifi-sentiment-analysis-face-recognition-pipeline.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1951768-nifi-sentiment-analysis-face-recognition-diagrams.pptx) of this diagram.*

### Ingestion pipeline

The Twitter ingestion pipeline consists of four stages.

#### Collect and ingest data

The following components ingest tweets:

- Hadoop Distributed File System (HDFS) (1)
- Azure Synapse Analytics via Azure Data Factory (4)
- Azure Blob Storage (4)
- Azure Cosmos DB (4)

#### Process data

During data processing:

- The JSON file that contains tweet data is transformed into CSV format (2).
- Apache Hive and Azure Synapse Analytics tables are created (2).
- Sentiment analysis runs on the tweets (2).
- Azure Cognitive Services processes images and identifies human faces (2).

#### Store data

The following components store data:

- HDFS and Hive (3)
- Azure Synapse Analytics (3)
- Blob Storage (3)
- Azure Cosmos DB (7)

#### Visualize data

Power BI dashboards display data from the following sources:

- Hive (5)
- Azure Synapse Analytics (6)
- Azure Cosmos DB (8)

### Dataflow

:::image type="content" source="./media/nifi-sentiment-analysis-face-recognition-dataflow.svg" alt-text="Architecture diagram that shows the flow of data from Twitter, through image processing and sentiment analysis, and into storage." lightbox="./media/nifi-sentiment-analysis-face-recognition-dataflow.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1951768-nifi-sentiment-analysis-face-recognition-diagrams.pptx) of this diagram.*

The solution's dataflow contains three main parts.

#### Ingest tweets

The file with the tweet data, which is in JSON format, is transformed into CSV format. Attributes are extracted from the JSON data to use as variables for the CSV composition.

#### Process images

Sentiment analysis runs on tweets that contain images. After the images are collected, face detection processes run on the images. Any human faces that are recognized are stored in HDInsight.

#### Run sentiment analysis

A Natural Language Toolkit (NLTK) algorithm runs on the ingested messages. Sentiment analysis runs on the text in the tweets. The results are stored in CSV format in a Hive table, and the JSON data is stored in Azure Cosmos DB.

### Components

:::image type="content" source="./media/nifi-sentiment-analysis-face-recognition-components.svg" alt-text="Architecture diagram that shows the components in the ingestion, storage, and processing layers of the solution." lightbox="./media/nifi-sentiment-analysis-face-recognition-components.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1951768-nifi-sentiment-analysis-face-recognition-diagrams.pptx) of this diagram.*

- [Data Factory](https://azure.microsoft.com/services/data-factory) provides batch transformation services for various sources and sinks. As a key component of big data processing, Data Factory helps to simplify extract-transform-load (ETL) workloads. Data Factory also handles the complexities and scale challenges of big data integration.

- [Nifi](https://nifi.apache.org) automates the flow of data among software systems. NiFi offers security features, an extensible architecture, and a flexible scaling model. It handles multiple sources and multiple sinks with different types of processors. NiFi functionality includes:

  - Running streaming transformations.
  - Connecting decoupled systems in the cloud.
  - Moving data in and out of Azure Storage and other data stores.
  - Integrating edge-to-cloud and hybrid-cloud applications with Azure services.
  - Providing robust data provenance capabilities.

- [HDInsight](https://azure.microsoft.com/services/hdinsight) is a Hadoop platform for data and analytics for on-premises environments. HDInsight can securely ingest, store, and process data in real time and in batches. HDInsight is built on Hortonworks Data Platform (HDP), an open-source framework for distributed storage and processing of large data sets that come from multiple sources.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is an analytics service for data warehouses and big data systems. It centralizes data in the cloud for easy access.

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database for modern app development. By providing single-digit millisecond response times and automatic and instant scalability, Azure Cosmos DB guarantees speed at any scale. Its SLA-backed availability and enterprise-grade security provide business continuity.

- [Cognitive Services](https://azure.microsoft.com/services/cognitive-services) consists of cloud-based services that provide AI functionality. The REST APIs and client library SDKs help you build cognitive intelligence into apps even if you don't have AI or data science skills.

- [Power BI](https://powerbi.microsoft.com) is a business analytics service that's part of Microsoft Power Platform. Power BI provides interactive visualizations and business intelligence capabilities. Its easy-to-use interface makes it possible for users to create their own reports and dashboards.

### Alternatives

You can substitute alternatives for most solution components. For example:

- Instead of an HDInsight cluster, you can use a Cloudera cluster.
- You can use Azure Databricks instead of Data Factory. Azure Databricks can transform and store data, but you can also use it as an orchestrator. Another alternative is to use both services. Many solutions that use Data Factory also make use of Azure Databricks.
- Instead of Nifi, you can use Apache Airflow as a workflow tool that runs ETL scripts.
- For your main file repository, you can use Elasticsearch in place of Azure Cosmos DB.
- For dashboard services, you can use Kibana instead of Power BI.

## Scenario details

Branding is important to companies, because a company's value depends on the market's image of that company. As your company moves to make predictive, data-driven decisions, rather than reactive decisions, you need to monitor and understand what's happening in real time. To gain a competitive advantage, you need to use social media analysis to identify and understand public opinion. Along with identifying sentiment in tweets, you might also choose to recognize faces and images.

This solution gauges public opinion in tweets. A transformation pipeline outputs clusters of comments and trending subjects. The pipeline delivers value by seamlessly integrating open-source solutions like Apache NiFi and Azure HDInsight with Azure sentiment analysis and face recognition services. The solution applies to a broad range of industries—monitoring social networks isn't limited to one sector.

### Potential use cases

This solution is ideal for any area that monitors branding on social networks, including:

- Marketing
- Communications
- Politics
- Media and entertainment
- Real estate and facilities
- Food service (travel and hospitality)
- Fashion
- Retail

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

Depending on the processing tools and number of sources that you use, you might be able to streamline the solution's transformations and visualizations. If possible, consider using a basic pipeline with one sink. Instead of using multiple sources and multiple dashboards, feed that pipeline into a single dashboard.

This example uses as many services as possible. Through this approach, you can compare the performance and experiences that you have with Power BI across various sources and data types.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

In production environments, evaluate your recovery time objective (RTO) and recovery point objective (RPO). All disaster recovery decisions and scenarios depend on those evaluations.

In most cases, you need a high availability service for each tool. For effective disaster recovery, it's important to reduce your RTO. But if you have high availability, you can avoid disaster scenarios. For instance, you might create services in another region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Aim for a strong security posture by using an identity-based system and native Azure tools. For external components, use external authentication tools like Kerberos to ensure a robust and secure workload.

### Cost optimization

For information about creating a cost-effective workload, review [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Centralize the monitoring logs from all services. The solution uses external tools and tools that are native to Azure. To achieve a holistic view of all systems, integrate monitoring data from all tools.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Because the solution uses multiple sources, consider compression as part of the process. Also consider the file formats that you use. Configure Azure Cosmos DB to achieve a tradeoff between latency and consistency levels. But monitor and evaluate Azure Cosmos DB performance throughout the process to prevent that component from becoming a bottleneck. To decrease latency, consider partitioning data by location or moving data sources close to where you use them.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Jose Mendez](https://www.linkedin.com/in/jos%C3%A9-m%C3%A9ndez-de-la-serna-946985aa) | Senior Cloud Solution Architect
- [Katie Novotny](https://www.linkedin.com/in/katie-novotny) | Senior Cloud Solution Architect

## Next steps

- [What is Azure Data Factory?](/azure/data-factory/introduction)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [Introduction to Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction)
- [What is dedicated SQL pool (formerly SQL DW) in Azure Synapse Analytics?](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Create and consume Cognitive Services](/training/modules/create-manage-cognitive-services)
- [Analyze text with the Language service](/training/modules/analyze-text-with-text-analytics-service)
- [Detect and analyze faces with the Face service](/training/modules/detect-analyze-faces)

## Related resources

- [Extract, transform, and load (ETL) using HDInsight](../../solution-ideas/articles/extract-transform-and-load-using-hdinsight.yml)
- [Knowledge mining for customer feedback](../../solution-ideas/articles/customer-feedback-and-analytics.yml)
- [Apache NiFi on Azure](../data/azure-nifi.yml)
