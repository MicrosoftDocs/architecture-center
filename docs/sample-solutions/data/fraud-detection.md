---
title: Advanced analytics &mdash; Real-time fraud detection 
description: Proven solution for detecting fraudulent activity in real-time using Azure Event Hubs and Stream Analytics.
author: alexbuckgit
ms.date: 06/14/2018
---

# Real-time fraud detection on Azure

This sample solution is relevant to organizations that need to analyze data in real-time to detect fraudulent transactions or other anomalous activity.

Potential applications include identifying fraudulent credit card activity or mobile phone calls. Traditional online analytical systems might take hours to transform and analyze the data to identify anomalous activity. 

By using Azure services such as Event Hubs and Stream Analytics, companies can eliminate the undifferentiated heavy lifting of an on-premises or IaaS deployment, while reducing costs and leveraging Microsoft's expertise in cloud-scale data ingestion and real-time analytics. This scenario specifically addresses the detection of fraudulent activity; if you have other needs for data analytics, you should review the list of available [Azure Analytics services][product-category].

## Potential use cases

You should consider this solution for the following use cases:

* Detecting fraudulent mobile-phone calls in telecommunications scenarios.
* Identifying fraudulent credit card transactions for banking institutions.
* Identifying fraudulent purchases in retail or e-commerce scenarios.

## Architecture

The architecture of the sample solution is depicted below.

![Sample solution architecture for real-time fraud detection][architecture-diagram]

This solution covers the back-end components of a real-time analytics pipeline. The data flows through the solution as follows:

1. Mobile phone call metadata is sent from the source system to an Azure Event Hubs instance. 
2. A Stream Analytics job is started, which receives data via the event hub source.
3. The Stream Analytics job runs a predefined query to transform the input stream and analyze it based on a fraudulent-transaction algorithm. This query uses a tumbling window to segment the stream into distinct temporal units.
4. The Stream Analytics job writes the transformed stream representing detected fraudulent calls to an output sink in Azure Blob storage.

> [!NOTE]
> A [step-by-step tutorial][tutorial] demonstrating how to manually deploy each component of the solution is [available here][tutorial]. This tutorial also provides a .NET client application to generate sample phone call metadata and send that data to an event hub. 

### Components

* [Event Hubs][docs-event-hubs] receives all phone call metadata to be analyzed for fraudulent activity.
* [Stream Analytics][docs-stream-analytics] transforms the input stream from Event Hubs to identify fraudulent calls.
* [Blob storage][docs-blob-storage] stores the results of the Stream Analytics job.

### Alternatives

Many technology choices are available for real-time message ingestion, data storage, stream processing, storage of analytical data, and analytics and reporting. For an overview of these options, their capabilities, and key selection criteria, see [Big data architectures: Real-time processing](/azure/architecture/data-guide/technology-choices/real-time-ingestion) in the Azure Data Architecture Guide.

Additionally, more complex algorithms for fraud detection can be produced by various machine learning services in Azure. For an overview of these options, see [Technology choices for machine learning](/azure/architecture/data-guide/technology-choices/data-science-and-machine-learning) in the Azure Data Architecture Guide.

### Availability

Azure Monitor provides unified user interfaces for monitoring across various Azure services. For more information, see [Monitoring in Microsoft Azure](/azure/monitoring-and-diagnostics/monitoring-overview). Event Hubs and Stream Analytics are both integrated with Azure Monitor. 

For other availability considerations, see the [availability checklist][availability].

### Scalability

The components of this solution are designed for hyper-scale ingestion and massively parallel real-time analytics. Azure Event Hubs is highly scalable, capable of receiving and processing millions of events per second with low latency.  Event Hubs can [automatically scale up](/azure/event-hubs/event-hubs-auto-inflate) the number of throughput units to meet usage needs. Azure Stream Analytics is capable of analyzing high volumes of streaming data from many sources. You can scale up Stream Analytics by increasing the number of [streaming units](/azure/stream-analytics/stream-analytics-streaming-unit-consumption) allocated to execute your streaming job.

For general guidance on designing scalable solutions, see the [scalability checklist][scalability] available in the Azure Architecture Center.

### Security

For a deeper discussion on security, see the relevant article in the architecture center.

For general guidance on designing secure solutions, see the [Cloud Security Design Patterns][security] available in the Azure Architecture Center.

### Resiliency

For general guidance on designing resilient solutions, see the [Cloud Resiliency Design Patterns][resiliency] available in the Azure Architecture Center.

## Deploy the solution

To deploy this sample solution into your existing Azure subscription, perform the following steps.

1. Click the button below:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Farchitecture-center%2Fmaster%2Fsample-solutions%2Fadvanced-analytics%2Ffraud-detection%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Once the link has opened in the Azure portal, you must enter values for some of the settings:   
   * The **Resource group** name is already defined in the parameter file, so select **Create New** and enter `fraud-detection-solution` in the text box.
   * Select the region from the **Location** drop down box.
   * Do not edit the **Template Root Uri** or the **Parameter Root Uri** text boxes.
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button.
3. Wait for the deployment to complete.

## Pricing

To examine the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular scenario, change the appropriate variables to match your expected data volume.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: process one million events through one standard streaming unit per month.
* [Medium][medium-pricing]: process 100M events through five standard streaming units per month.
* [Large][large-pricing]: process 999 million events through 20 standard streaming units per month.

...

<!-- links -->
[product-category]: https://azure.microsoft.com/product-categories/analytics/
[tutorial]: /azure/stream-analytics/stream-analytics-real-time-fraud-detection
[small-pricing]: https://azure.com/e/74149ec312c049ccba79bfb3cfa67606
[medium-pricing]: https://azure.com/e/4fc94f7376de484d8ae67a6958cae60a
[large-pricing]: https://azure.com/e/7da8804396f9428a984578700003ba42
[architecture-diagram]: ./images/architecture-diagram-fraud-detection.png
[docs-event-hubs]: /azure/event-hubs/event-hubs-what-is-event-hubs
[docs-stream-analytics]: /azure/stream-analytics/stream-analytics-introduction
[docs-blob-storage]: /azure/storage/blobs/storage-blobs-introduction
[availability]: /azure/architecture/checklist/availability
[scalability]: /azure/architecture/checklist/scalability
[resiliency]: /azure/architecture/patterns/category/resiliency/
[security]: /azure/architecture/patterns/category/security