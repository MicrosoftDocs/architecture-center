---
title: Claim-Check
description: Enable efficient processing of large messages [ TODO extend description? ]
keywords: design pattern, large message
ms.date: mm/dd/yyyy
pnp.series.title: Cloud Design Patterns
pnp.pattern.categories: [messaging]
---

# Claim-Check Pattern

[!INCLUDE [header](../_includes/header.md)]

Split a large message into a claim check and a payload, send the claim check into the messaging platform and store the payload into an external service. This allows large messages to be processed while it protects the message bus and the client from being jammed or slowed down by their presence. It also helps to reduce costs as storage is usually cheaper than resource units used by the messaging platform.

![Claim Check Pattern](_images_/claim-check.jpg)

This pattern is also known as "Reference Based Messaging", and it has been described originally in the famous "Enterprise Integration Pattern" book:

https://www.enterpriseintegrationpatterns.com/patterns/messaging/StoreInLibrary.html

## Context and problem

A messaging based architecture at some point needs to be able to send, receive and manipulate large messages. Such messages may contain anything, from images (eg: MRI scans that must be processed by a Deep Learning service), sounds (eg: call-center calls that needs to be transcribed and translated automatically), text documents, up to more generic binary data that can be of any size.

Sending such large messages to the message bus directly is not recommended as they will require more resources to be used, more bandwidth to be consumed and, in general, can slow down the entire solution as messaging platforms are usually fine-tuned to handle huge quantities of small messages. It's also worth to mention that messaging platform usually have some kind of limitations in the message size they can process, so the need to find a way to send messages bigger than the allowed size can surface any time.

## Solution

The solution is to store the message payload into an external service, like Azure Blob Store, Azure SQL or Azure Cosmos DB, get the reference to the stored payload and then send to the message bus only that reference, hence named "claim check". The clients interested in processing that specific message can use the obtained reference to retrieve the payload, if needed.

On Azure this pattern can be implemented in several ways and with different technologies, but there are two main categories in which any of the solution will fall into. In both the described cases, the receiver has the responsibility to read the Claim Check and then use it go retrieve the payload.

### Automatic Claim Check Generation

Solutions that falls into this category take advantage of Azure Event Grid to automate the Claim Check generation and to push it into the message bus to be used by clients.
Event Grid is an event routing service and as such tries to deliver events to a configurable amount of time up to 24 hours. After that, events are either discarded or dead lettered. If you need archival of event contents or replayability of event stream you can add an Event Grid subscription to Event Hubs or Storage Queues where messages can be retained for longer periods and archival of messages is supported. Fine tuning of Event Grid message delivery and retry, along with Dead Letter configuration, is described in detail here: [Manage Event Delivery](https://docs.microsoft.com/en-us/azure/event-grid/manage-event-delivery)

### Plugin Supported Claim Check Generation

This solution takes advantage of a very specific Service Bus plugin which makes the claim-check workflow easy to implement.

### Manual Claim Check Generation

In this category all duties related to payload management are a responsibility of the sender: it has to store the payload using the appropriate service, get or generate the claim check and send it to the message bus.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

- Make sure you consider deleting the blob storage data after consuming it in case you do not wish to keep the messages in blob storage. Though blob storage is relatively cheaper, it could cost some money in the long run.

- Claim and check would be the best practice for larger message sizes, but you may want to implement a check in your sender application to use this only when the message size is over the data limit of the message bus of your choice. The overhead/latency of storing a message in blob storage and getting notified to process it would be something that can be skipped for smaller messages in case your application produces variable length messages. This would result in a conditional claim check pattern.

- Lastly, there is another pattern that exists which is also used to handle large messages called - Split and Aggregate. Although used, this may not be recommended as best practice, but is worth mentioning here.

## When to use this pattern

This pattern should be used anytime a message must be sent to the message bus but its size cannot fit the supported message limit of the chosen technology. For example Event Hubs currently has a limit of 256KB (Basic Tier) while Event Grid supports only 64Kb messages.

## Examples

As mentioned before the pattern can be implemented just by relying on native Azure features, using plugins or by manually writing the code to store the payload and pass the payload location details to consumer application.

The samples are located here:

https://github.com/mspnp/cloud-design-patterns/claim-check

### Sample-1: Automatic Tag Generation, Queues as Message Bus

Technologies used: Azure Blob Storage, Azure Event Grid, Azure Functions, Azure Blob Queue, .NET Core 2.1

In this example we're using Blob Store to store data, but any service that supports Event Grid integration can be used too. A client just needs to drop the payload to be shared into the designated Azure Blob Store and Event Grid will automatically generate a Tag/Reference and send it to one of the supported message bus. In this sample the message bus is created using Azure Storage Queues. This allows a client application to poll the queue, get the message and then use the stored reference data to download the payload directly from Azure Blob Storage.
The same message, without the need to go through a message bus, can also be directly consumed via Azure Function, leveraging in this case the serverless nature of both Azure Event Grid and Azure Functions.

### Sample-2: Automatic Tag Generation, Event Hubs as Message Bus

Technologies used: Azure Blob Storage, Azure Event Grid, Azure Event Hub, .NET Core 2.1

Very similarly to the previous sample, a reference message is automatically generated by [Event Grid](https://azure.microsoft.com/en-us/services/event-grid/) as soon as a payload is dropped in the designated Azure Blob Storage. Here the message bus is implemented via Event Hub, so that a client can register itself to be notified each time there is a message in the bus.
Event Hub is also configured so that it [automatically archives](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-capture-overview) received messages that are then available as an AVRO file easily queryable using tools like Apache Spark, Apache Drill or any of the Avro libraries available.

### Sample-3: Plugin support, Service Bus as Message Bus

Technologies used: Azure Blob Storage, Azure Service Bus, .NET Core 2.1

This sample takes advantage of the [ServiceBus.AttachmentPlugin](https://www.nuget.org/packages/ServiceBus.AttachmentPlugin) which brings the claim check pattern implementation to Service Bus. The plugin is used to convert any message body into an attachment which gets stored in Azure Blob Storage on message send. Internally, service bus message is used to act as a notification queue which can subscribed on to read the message. On message receive, the plugin makes it possible to directly read the message data from blob storage in the consumer. You can then chose how you want to process the message further. The good thing about this approach is, it obscures the actual claim check workflow from the end user.

### Sample-4: Manual

Technologies used: Azure Blob Storage, Azure Event Hubs with Kafka, .NET Core 2.1

The reason this example uses Event Hubs with Kafka is to demonstrate the ease of using other Azure services like Azure Blob Storage, Azure functions etc. with a different messaging protocol like Kafka from your existing Kafka clients to implement the claim check messaging pattern.
This sample consists of a Kafka client which drops the payload in the designated Azure Blob Storage and creates a notification message with location details to be sent to the consumer. The notification message is sent using [Event Hubs with Kafka enabled](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create-kafka-enabled).  
The consumer is notified each time these is a message in the Event Hub and can access the payload using the location information in the message received.

## Next steps

The following information may be relevant when implementing this pattern:

- [Enterprise Integration Patterns: Claim Check](https://www.enterpriseintegrationpatterns.com/patterns/messaging/StoreInLibrary.html)

- [Large Service Bus messages using Claim Check Pattern](https://www.serverless360.com/blog/deal-with-large-service-bus-messages-using-claim-check-pattern)

- [Capture events through Azure Event Hubs in Azure Blob Storage or Azure Data Lake Storage](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-capture-overview)
