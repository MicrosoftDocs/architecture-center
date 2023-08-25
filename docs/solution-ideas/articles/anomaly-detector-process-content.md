This article presents an architecture for a near real-time implementation of an anomaly detection process.

## Architecture

![Diagram of the anomaly detector process architecture.](../media/anomaly-detector.svg)

*Download a [Visio file](https://arch-center.azureedge.net/anomaly-detector-process.vsdx) of this architecture.*

### Dataflow

1. Time-series data can come from multiple sources, such as Azure Database for MySQL, Blob storage, Event Hubs, Azure Cosmos DB, SQL Database, and Azure Database for PostgreSQL.
1. Data is ingested into compute from various storage sources to be monitored by Anomaly Detector.
1. Databricks helps aggregate, sample, and compute the raw data to generate the time with the detected results. Databricks is capable of processing stream and static data. Stream analytics and Azure Synapse can be alternatives based on the requirements.
1. The anomaly detector API detects anomalies and returns the results to compute.
1. The anomaly-related metadata is queued.
1. Application Insights picks the message from the message queue based on the anomaly-related metadata and sends an alert about the anomaly.
1. The results are stored in Azure Data Lake Service Gen2.
1. Web applications and Power BI can visualize the results of the anomaly detection.

### Components

Key technologies used to implement this architecture:

* [Service Bus](https://azure.microsoft.com/services/service-bus): Reliable cloud messaging as a service (MaaS) and simple hybrid integration.
* [Azure Databricks](https://azure.microsoft.com/services/databricks): Fast, easy, and collaborative Apache Spark–based analytics service.
* [Power BI](https://powerbi.microsoft.com): Interactive data visualization BI tools.
* [Storage Accounts](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage.
* [Cognitive Services](/azure/cognitive-services): Cloud-based services with REST APIs and client library SDKs available to help you build cognitive intelligence into your applications.
* [Logic Apps][logic-apps]: Serverless platform for building enterprise workflows that integrate applications, data, and services. In this architecture, the logic apps are triggered by HTTP requests.
* [Azure Data Lake Storage Gen2](https://azure.microsoft.com/services/storage/data-lake-storage): Azure Data Lake Storage Gen2 provides file system semantics, file-level security, and scale.
* [Application Insights](/azure/azure-monitor/app/app-insights-overview): Application Insights is a feature of Azure Monitor that provides extensible application performance management (APM) and monitoring for live web apps.

### Alternatives

* [Event Hubs with Kafka][event-hubs]: An alternative to running your own Kafka cluster. This Event Hubs feature provides an endpoint that is compatible with Kafka APIs.
* [Azure Synapse Analytics][synapse-analytics]: An analytics service that brings together enterprise data warehousing and big data analytics.
* [Azure Machine Learning](/azure/machine-learning): Build, train, deploy, and manage custom machine learning / anomaly detection models in a cloud-based environment.

## Scenario details

The Azure Cognitive Services Anomaly Detector API enables you to monitor and detect abnormalities in your time series data without having to know machine learning. The algorithms of the API adapt by automatically identifying and applying the best-fitting models to your time series data, regardless of industry, scenario, or data volume. They determine boundaries for anomaly detection, expected values, and anomalous data points. 

### Potential use cases

Some areas that anomaly detection helps monitor:

* Bank fraud (finance industry)
* Structural defects (manufacturing industry)
* Medical problems (healthcare industry)

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

Most of the components used in this example scenario are managed services that will automatically scale.

For general guidance on designing scalable solutions, see the [performance efficiency checklist][scalability] in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

[Managed identities for Azure resources][msi] are used to provide access to other resources internal to your account and then assigned to your Azure Functions. Allow those identities to access only requisite resources to ensure that nothing extra is exposed to your functions (and potentially to your customers).

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

All of the components in this scenario are managed, so at a regional level they're all resilient automatically.

For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, see the pre-filled calculator with all of the services. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic / data volumes.

We've provided three sample cost profiles based on the amount of traffic (we assume all images are 100 kb in size):

* [Example calculator][example-pricing]: this pricing example is a calculator with all services in this architecture, except Power BI and custom alerting solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Ashish Chauhan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Anomaly Detector API Documentation](/azure/cognitive-services/anomaly-detector)
* [Interactive demo](https://algoevaluation.azurewebsites.net/#/)
* [Detect and visualize anomalies in your data with the Anomaly Detector API - Demo on Jupyter Notebook](https://github.com/Azure-Samples/AnomalyDetector/tree/master/ipython-notebook)
* [Identify anomalies by routing data via IoT Hub to a built-in ML model in Azure Stream Analytics](/training/modules/data-anomaly-detection-using-azure-iot-hub)
* [Recipe: Predictive maintenance with the Cognitive Services for Big Data](/azure/cognitive-services/big-data/recipes/anomaly-detection)
* [Service Bus Documentation](/azure/service-bus)
* [Azure Databricks Documentation](/azure/azure-databricks)
* [Power BI Documentation](/power-bi)
* [Storage Documentation](/azure/storage)

## Related resources

* [Quality assurance](/azure/architecture/solution-ideas/articles/quality-assurance)
* [Supply chain track and trace](/azure/architecture/solution-ideas/articles/supply-chain-track-and-trace)
* [Introduction to predictive maintenance in manufacturing](/azure/architecture/industries/manufacturing/predictive-maintenance-overview)
* [Predictive maintenance solution](/azure/architecture/industries/manufacturing/predictive-maintenance-solution)
* [Predictive maintenance](/azure/architecture/solution-ideas/articles/predictive-maintenance)
* [Predictive maintenance with the intelligent IoT Edge](/azure/architecture/example-scenario/predictive-maintenance/iot-predictive-maintenance)
* [Stream processing with fully managed open-source data engines](/azure/architecture/example-scenario/data/open-source-data-engine-stream-processing)
* [Connected factory hierarchy service](/azure/architecture/solution-ideas/articles/connected-factory-hierarchy-service)
* [Connected factory signal pipeline](/azure/architecture/example-scenario/iot/connected-factory-signal-pipeline)

<!-- Links -->
[Event Grid]: https://azure.microsoft.com/services/event-grid
[synapse-analytics]: /azure/sql-data-warehouse
[event-hubs]: /azure/event-hubs/event-hubs-for-kafka-ecosystem-overview
[architecture]: ./media/architecture-intelligent-apps-image-processing.png
[example-pricing]: https://azure.com/e/48cc24e76c914ecf8fafec1fed0e0e14
[serverless]: /training/paths/create-serverless-applications
[cv-categories]: /azure/cognitive-services/computer-vision/category-taxonomy
[resiliency]: /azure/architecture/framework/resiliency/principles
[security]: /azure/security
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[functions-best-practices]: /azure/azure-functions/functions-best-practices
[msi]: /azure/app-service/app-service-managed-service-identity
[logic-apps]: /azure/logic-apps/logic-apps-overview
[logic-apps-connectors]: /azure/connectors/apis-list
