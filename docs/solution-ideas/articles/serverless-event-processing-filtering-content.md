<!-- cSpell:ignore KEDA deadletter -->
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea shows a variation of a serverless event-driven architecture using Azure Event Hubs and Azure Functions to ingest and process a stream of data. Once de-batched and filtered, the results are written to a database for storage and future review.

To learn more about the basic concepts, considerations, and approaches for serverless event processing, consult the [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) reference architecture.

## Potential use cases

A popular use case for implementing an end-to-end event stream processing pattern includes the Event Hubs streaming ingestion service to receive and process events per second using a de-batching and transformation logic implemented with highly scalable, event hub&#8211;triggered functions.

## Architecture

![Diagram showing the data flow and key processing points in the architecture described in this article](../media/serverless-event-processing-filtering-diagram.png)

1. Events arrive at the Input Event Hub.
1. The De-batching and Filtering Azure Function is triggered to handle the event. This step filters out unwanted events and de-batches the received events before submitting them to the Output Event Hub.
1. If the De-batching and Filtering Azure Function fails to store the event successfully, the event is submitted to the Deadletter Event Hub 1.
1. Events arriving at the Output Event Hub trigger the Transforming Azure Function. This Azure Function transforms the event into a message for the Cosmos DB.
1. The event is stored in a Cosmos DB database.
1. If the Transforming Azure Function fails to store the event successfully, the event is saved to the Deadletter Event Hub 2.

### Components

- [Event Hubs](https://azure.microsoft.com/services/event-hubs/) ingests the data stream. Event Hubs is designed for high-throughput data streaming scenarios.
- [Azure Functions](https://azure.microsoft.com/services/functions/) is a serverless compute option. It uses an event-driven model, where a piece of code (a *function*) is invoked by a trigger.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a multi-model database service that is available in a serverless, consumption-based mode. For this scenario, the event-processing function stores JSON records, using the [Cosmos DB SQL API](/azure/cosmos-db/introduction).

## Next steps

- [Serverless event processing](../../reference-architectures/serverless/event-processing.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [Monitoring serverless event processing](../../serverless/guide/monitoring-serverless-event-processing.md) provides an overview and guidance on monitoring serverless event-driven architectures like this one.
- [Azure Kubernetes in event stream processing](./serverless-event-processing-aks.yml) describes a variation of a serverless event-driven architecture running on Azure Kubernetes with KEDA scaler.
- [Private link scenario in event stream processing](./serverless-event-processing-private-link.yml) is a solution idea for implementing a similar architecture in a virtual network (VNet) with private endpoints, in order to enhance security.

## Related resources

- [Azure Event Hubs documentation](/azure/event-hubs/)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)
- [Azure Functions documentation](/azure/azure-functions/)
- [Overview of Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Choose an API in Azure Cosmos DB](/azure/cosmos-db/choose-api)
