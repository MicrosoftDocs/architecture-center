<!-- cSpell:ignore KEDA deadletter autoscaler -->
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a variation of a [serverless](https://azure.microsoft.com/solutions/serverless/) event-driven architecture running on Azure Kubernetes with KEDA scaler that ingests a stream of data, processes the data, and then writes the results to a back-end database.

To learn more about the basic concepts, considerations, and approaches for serverless event processing, consult the [Serverless event processing](https://docs.microsoft.com/azure/architecture/reference-architectures/serverless/event-processing) reference architecture.

## Potential use cases

A popular use case for implementing an end-to-end event stream processing pattern includes the Event Hubs streaming ingestion service to receive and process events per second using a de-batching and transformation logic implemented with highly scalable, event hub-triggered functions.

## Architecture

![Diagram showing the data flow described in this article](../media/serverless-event-processing-aks-diagram.png)

- Azure Kubernetes Service (AKS) with the KEDA scaler is used to autoscale Azure Functions containers based on the number of events needing to be processed.
- Events arrive at the Input Event Hub.
- The De-batching and Filtering Azure Function is triggered to handle the event. This step filters out unwanted events and de-batches the received events before submitting to the Output Event Hub.
- If the De-batching and Filtering Azure Function fails to store the event successfully, the event is submitted to the Deadletter Event Hub 1.
- Events arriving at the Output Event Hub trigger the Transforming Azure Function. This Azure Function transforms the event into a message for the Cosmos DB.
- The event is stored in a Cosmos DB database.

### Components

- [Resource Groups](https://docs.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal) is a logical container for Azure resources, used to organize everything related to this project in the Azure console.
- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) (AKS) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance.
- [KEDA](https://keda.sh/) is an event driven autoscaler used to scale containers in the Kubernetes cluster based on the number of events needing to be processed.
- [Event Hub](https://azure.microsoft.com/services/event-hubs/) ingests the data stream. Event Hubs is designed for high-throughput data streaming scenarios.
- [Azure Functions](https://azure.microsoft.com/services/functions/) is a serverless compute option. It uses an event-driven model, where a piece of code (a *function*) is invoked by a trigger.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a multi-model database service that is available in a serverless, consumption-based mode. For this scenario, the event-processing function stores JSON records, using the [Cosmos DB SQL API](https://docs.microsoft.com/azure/cosmos-db/introduction).

> [!NOTE]
> For IoT scenarios, we recommend [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub/). IoT Hub has a built-in endpoint that's compatible with the Azure Event Hubs API, so you can use either service in this architecture with no major changes in the backend processing. For more information, see [Connecting IoT Devices to Azure: IoT Hub and Event Hubs](https://docs.microsoft.com/azure/iot-hub/iot-hub-compare-event-hubs).

## Next steps

- [Serverless event processing](serverless-event-processing-simple.yml) is a reference architecture detailing a typical architecture of this type, with code samples and discussion of important considerations.
- [Monitoring serverless event processing](monitoring-serverless-event-processing.yml) provides an overview and guidance on monitoring serverless event-driven architectures like this one.
- [De-batching and filtering in serverless event processing with Event Hubs](serverless-event-processing-filtering.yml) describes in more detail how these portions of the architecture work.
- [Private link scenario in event stream processing](serverless-event-processing-private-link.yml) is a solution idea for implementing a similar architecture in a VNet with private endpoints, in order to enhance security.

## Related resources

- [Introduction to Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/intro-kubernetes)
- [Azure Event Hubs documentation](https://docs.microsoft.com/azure/event-hubs/)
- [Introduction to Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-overview)
- [Azure Functions documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Overview of Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction)
- [Choose an API in Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/choose-api)
