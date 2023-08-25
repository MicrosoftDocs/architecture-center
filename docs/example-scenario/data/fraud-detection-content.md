This example scenario is relevant to organizations that need to analyze data in real time to detect fraudulent transactions or other anomalous activity. Also, see [Detect mobile bank fraud](/azure/architecture/guide/ai/bank-fraud-solution).

## Architecture

![Architecture overview of the Azure components of a real-time fraud detection scenario][architecture]

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/architecture-fraud-detection.vsdx) of this architecture.*

### Dataflow

This scenario covers the back-end components of a real-time analytics pipeline. Data flows through the scenario as follows:

1. Mobile phone call metadata is sent from the source system to an Azure Event Hubs instance.
2. A Stream Analytics job is started. It receives data via the event hub source.
3. The Stream Analytics job runs a predefined query to transform the input stream and analyze it based on a fraudulent-transaction algorithm. This query uses a tumbling window to segment the stream into distinct temporal units.
4. The Stream Analytics job writes the transformed stream representing detected fraudulent calls to an output sink in Azure Blob storage.

### Components

- [Azure Event Hubs](https://azure.microsoft.com/products/event-hubs) is a real-time streaming platform and event ingestion service, capable of receiving and processing millions of events per second. Event Hubs can process and store events, data, or telemetry that's produced by distributed software and devices. In this scenario, Event Hubs receives all phone call metadata to be analyzed for fraudulent activity.
- [Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics) is an event-processing engine that can analyze high volumes of data that streams from devices and other data sources. It also supports extracting information from data streams to identify patterns and relationships. These patterns can trigger other downstream actions. In this scenario, Stream Analytics transforms the input stream from Event Hubs to identify fraudulent calls.
- [Blob storage](https://azure.microsoft.com/products/storage/blobs) is used in this scenario to store the results of the Stream Analytics job.

### Alternatives

Many technology choices are available for real-time message ingestion, data storage, stream processing, storage of analytical data, and analytics and reporting. For an overview of these options, their capabilities, and key selection criteria, see [Big data architectures: Real-time processing](../../data-guide/technology-choices/real-time-ingestion.md) in the Azure Data Architecture Guide.

Algorithms for fraud detection that are more complex can be produced by various machine learning services in Azure. For an overview of these options, see [Technology choices for machine learning](../../data-guide/technology-choices/data-science-and-machine-learning.md) in the [Azure Data Architecture Guide](../../data-guide/index.md).

For scenarios that are built by using Machine Learning Server, see [Fraud detection using Machine Learning Server][r-server-fraud-detection]. For other solution templates that use Machine Learning Server, see [Data science scenarios and solution templates][docs-r-server-sample-solutions].

## Scenario details

Potential applications include identifying fraudulent credit card activity or fraudulent mobile phone calls. Traditional online analytical systems might take hours to transform and analyze the data to identify anomalous activity.

By using fully managed Azure services such as Event Hubs and Stream Analytics, companies can eliminate the need to manage individual servers, while reducing costs and using Microsoft's expertise in cloud-scale data ingestion and real-time analytics. This scenario specifically addresses the detection of fraudulent activity. If you have other needs for data analytics, you should review the list of available [Azure Analytics services][product-category].

This sample represents one part of a broader data processing architecture and strategy. Other options for this aspect of an overall architecture are discussed later in this article.

### Potential use cases

Other relevant use cases include:

- Detecting fraudulent mobile-phone calls in telecommunications scenarios.
- Identifying fraudulent credit card transactions for banking institutions.
- Identifying fraudulent purchases in retail or e-commerce scenarios.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

Azure Monitor provides unified user interfaces for monitoring across various Azure services. For more information, see [Monitoring in Microsoft Azure](/azure/monitoring-and-diagnostics/monitoring-overview). Event Hubs and Stream Analytics are both integrated with Azure Monitor.

### Scalability

The components of this scenario are designed for hyperscale ingestion and massively parallel real-time analytics. Azure Event Hubs is highly scalable, capable of receiving and processing millions of events per second with low latency. Event Hubs can [automatically scale up](/azure/event-hubs/event-hubs-auto-inflate) the number of throughput units to meet usage needs. Azure Stream Analytics is capable of analyzing high volumes of streaming data from many sources. You can scale up Stream Analytics by increasing the number of [streaming units](/azure/stream-analytics/stream-analytics-streaming-unit-consumption) allocated to execute your streaming job.

For general guidance on designing scalable solutions, see the [performance efficiency checklist][scalability] in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Azure Event Hubs secures data through an [authentication and security model][docs-event-hubs-security-model] that's based on a combination of Shared Access Signature (SAS) tokens and event publishers. An event publisher defines a virtual endpoint for an event hub. The publisher can only be used to send messages to an event hub. It's not possible to receive messages from a publisher.

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

For general guidance on designing resilient solutions, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all the services are pre-configured in the cost calculator. To see how the pricing changes for your use case, change the appropriate variables to match your expected data volume.

We have provided three sample cost profiles that are based on the amount of traffic you expect to get:

- [Small][small-pricing]: process one million events through one standard streaming unit per month.
- [Medium][medium-pricing]: process 100M events through five standard streaming units per month.
- [Large][large-pricing]: process 999 million events through 20 standard streaming units per month.

## Deploy this scenario

To deploy this scenario, you can follow this [step-by-step tutorial][tutorial] that demonstrates how to manually deploy each component of the scenario. This tutorial also provides a .NET client application to generate sample phone call metadata and send that data to an event hub instance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Alex Buck](https://www.linkedin.com/in/alex-buck-0161575) | Senior Content Developer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Event Hubs — A big data streaming platform and event ingestion service][docs-event-hubs]
- [Welcome to Azure Stream Analytics][docs-stream-analytics]
- [Introduction to Azure Blob storage](/azure/storage/blobs/storage-blobs-introduction)

## Related resources

- [Detect mobile bank fraud](/azure/architecture/guide/ai/bank-fraud-solution)
- [Integrate Event Hubs with serverless functions on Azure](/azure/architecture/serverless/event-hubs-functions/event-hubs-functions)
- [Serverless event processing](/azure/architecture/reference-architectures/serverless/event-processing)
- [Stream processing with Azure Stream Analytics](/azure/architecture/reference-architectures/data/stream-processing-stream-analytics)

<!-- links -->
[product-category]: https://azure.microsoft.com/product-categories/analytics
[tutorial]: /azure/stream-analytics/stream-analytics-real-time-fraud-detection
[small-pricing]: https://azure.com/e/74149ec312c049ccba79bfb3cfa67606
[medium-pricing]: https://azure.com/e/4fc94f7376de484d8ae67a6958cae60a
[large-pricing]: https://azure.com/e/7da8804396f9428a984578700003ba42
[architecture]: ./media/architecture-fraud-detection-new.svg
[docs-event-hubs]: /azure/event-hubs/event-hubs-what-is-event-hubs
[docs-event-hubs-security-model]: /azure/event-hubs/event-hubs-authentication-and-security-model-overview
[docs-stream-analytics]: /azure/stream-analytics/stream-analytics-introduction
[docs-r-server-sample-solutions]: /machine-learning-server/r/sample-solutions
[r-server-fraud-detection]: https://microsoft.github.io/r-server-fraud-detection
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[security]: /azure/security
