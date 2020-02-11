---
title: Real-time fraud detection
titleSuffix: Azure Example Scenarios
description: Detect fraudulent activity in real-time using Azure Event Hubs and Stream Analytics.
author: alexbuckgit
ms.date: 07/05/2018
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
social_image_url: /azure/architecture/example-scenario/data/media/architecture-fraud-detection.png
ms.custom: ai-ml
---

# Real-time fraud detection on Azure

This example scenario is relevant to organizations that need to analyze data in real time to detect fraudulent transactions or other anomalous activity.

Potential applications include identifying fraudulent credit card activity or mobile phone calls. Traditional online analytical systems might take hours to transform and analyze the data to identify anomalous activity.

By using fully managed Azure services such as Event Hubs and Stream Analytics, companies can eliminate the need to manage individual servers, while reducing costs and leveraging Microsoft's expertise in cloud-scale data ingestion and real-time analytics. This scenario specifically addresses the detection of fraudulent activity. If you have other needs for data analytics, you should review the list of available [Azure Analytics services][product-category].

This sample represents one part of a broader data processing architecture and strategy. Other options for this aspect of an overall architecture are discussed later in this article.

## Relevant use cases

Other relevant use cases include:

- Detecting fraudulent mobile-phone calls in telecommunications scenarios.
- Identifying fraudulent credit card transactions for banking institutions.
- Identifying fraudulent purchases in retail or e-commerce scenarios.

## Architecture

![Architecture overview of the Azure components of a real-time fraud detection scenario][architecture]

This scenario covers the back-end components of a real-time analytics pipeline. Data flows through the scenario as follows:

1. Mobile phone call metadata is sent from the source system to an Azure Event Hubs instance.
2. A Stream Analytics job is started, which receives data via the event hub source.
3. The Stream Analytics job runs a predefined query to transform the input stream and analyze it based on a fraudulent-transaction algorithm. This query uses a tumbling window to segment the stream into distinct temporal units.
4. The Stream Analytics job writes the transformed stream representing detected fraudulent calls to an output sink in Azure Blob storage.

### Components

- [Azure Event Hubs][docs-event-hubs] is a real-time streaming platform and event ingestion service, capable of receiving and processing millions of events per second. Event Hubs can process and store events, data, or telemetry produced by distributed software and devices. In this scenario, Event Hubs receives all phone call metadata to be analyzed for fraudulent activity.
- [Azure Stream Analytics][docs-stream-analytics] is an event-processing engine that can analyze high volumes of data streaming from devices and other data sources. It also supports extracting information from data streams to identify patterns and relationships. These patterns can trigger other downstream actions. In this scenario, Stream Analytics transforms the input stream from Event Hubs to identify fraudulent calls.
- [Blob storage](/azure/storage/blobs/storage-blobs-introduction) is used in this scenario to store the results of the Stream Analytics job.

## Considerations

### Alternatives

Many technology choices are available for real-time message ingestion, data storage, stream processing, storage of analytical data, and analytics and reporting. For an overview of these options, their capabilities, and key selection criteria, see [Big data architectures: Real-time processing](/azure/architecture/data-guide/technology-choices/real-time-ingestion) in the Azure Data Architecture Guide.

Additionally, more complex algorithms for fraud detection can be produced by various machine learning services in Azure. For an overview of these options, see [Technology choices for machine learning](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning) in the [Azure Data Architecture Guide](../../data-guide/index.md).

### Availability

Azure Monitor provides unified user interfaces for monitoring across various Azure services. For more information, see [Monitoring in Microsoft Azure](/azure/monitoring-and-diagnostics/monitoring-overview). Event Hubs and Stream Analytics are both integrated with Azure Monitor.

### Scalability

The components of this scenario are designed for hyperscale ingestion and massively parallel real-time analytics. Azure Event Hubs is highly scalable, capable of receiving and processing millions of events per second with low latency. Event Hubs can [automatically scale up](/azure/event-hubs/event-hubs-auto-inflate) the number of throughput units to meet usage needs. Azure Stream Analytics is capable of analyzing high volumes of streaming data from many sources. You can scale up Stream Analytics by increasing the number of [streaming units](/azure/stream-analytics/stream-analytics-streaming-unit-consumption) allocated to execute your streaming job.

For general guidance on designing scalable solutions, see the [scalability checklist][scalability] in the Azure Architecture Center.

### Security

Azure Event Hubs secures data through an [authentication and security model][docs-event-hubs-security-model] based on a combination of Shared Access Signature (SAS) tokens and event publishers. An event publisher defines a virtual endpoint for an event hub. The publisher can only be used to send messages to an event hub. It is not possible to receive messages from a publisher.

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

For general guidance on designing resilient solutions, see [Designing reliable Azure applications](../../framework/resiliency/app-design.md).

## Deploy the scenario

To deploy this scenario, you can follow this [step-by-step tutorial][tutorial] demonstrating how to manually deploy each component of the scenario. This tutorial also provides a .NET client application to generate sample phone call metadata and send that data to an event hub instance.

## Pricing

To explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected data volume.

We have provided three sample cost profiles based on amount of traffic you expect to get:

- [Small][small-pricing]: process one million events through one standard streaming unit per month.
- [Medium][medium-pricing]: process 100M events through five standard streaming units per month.
- [Large][large-pricing]: process 999 million events through 20 standard streaming units per month.

## Related resources

More complex fraud detection scenarios can benefit from a machine learning model. For scenarios built using Machine Learning Server, see [Fraud detection using Machine Learning Server][r-server-fraud-detection]. For other solution templates using Machine Learning Server, see [Data science scenarios and solution templates][docs-r-server-sample-solutions]. For an example solution using Azure Data Lake Analytics, see [Using Azure Data Lake and R for Fraud Detection][technet-fraud-detection].

<!-- links -->
[product-category]: https://azure.microsoft.com/product-categories/analytics/
[tutorial]: /azure/stream-analytics/stream-analytics-real-time-fraud-detection
[small-pricing]: https://azure.com/e/74149ec312c049ccba79bfb3cfa67606
[medium-pricing]: https://azure.com/e/4fc94f7376de484d8ae67a6958cae60a
[large-pricing]: https://azure.com/e/7da8804396f9428a984578700003ba42
[architecture]: ./media/architecture-fraud-detection.png
[docs-event-hubs]: /azure/event-hubs/event-hubs-what-is-event-hubs
[docs-event-hubs-security-model]: /azure/event-hubs/event-hubs-authentication-and-security-model-overview
[docs-stream-analytics]: /azure/stream-analytics/stream-analytics-introduction
[docs-r-server-sample-solutions]: /machine-learning-server/r/sample-solutions
[r-server-fraud-detection]: https://microsoft.github.io/r-server-fraud-detection/
[technet-fraud-detection]: https://blogs.technet.microsoft.com/machinelearning/2017/06/28/using-azure-data-lake-and-r-for-fraud-detection/
[scalability]: /azure/architecture/checklist/scalability
[security]: /azure/security/
