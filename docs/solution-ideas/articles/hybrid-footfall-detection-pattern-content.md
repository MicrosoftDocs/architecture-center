[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The article provides an overview for implementing an AI-based footfall detection solution for analyzing visitor traffic in retail stores.

This retail analytics solution uses a [tiered](https://docs.microsoft.com/hybrid/app-solutions/pattern-tiered-data-analytics) approach to inferencing at the edge. By using the Custom Vision AI Dev Kit, only images with human faces are sent for analysis to a private Azure Stack Hub that runs Azure Cognitive Services. Anonymized, aggregated data is sent to Azure for aggregation across all stores and visualization in Power BI. Combining the edge and public cloud lets Contoso take advantage of modern AI technology while also remaining in compliance with their corporate policies and respecting their customers' privacy.

## Potential use cases

Contoso Stores would like to gain insights on how customers are receiving their current products in relation to store layout. They're unable to place staff in every section and it's inefficient to have a team of analysts review an entire store's camera footage. In addition, none of their stores have enough bandwidth to stream video from all their cameras to the cloud for analysis.

Contoso would like to find an unobtrusive, privacy-friendly way to determine their customers' demographics, loyalty, and reactions to store displays and products.

## Architecture

![Architecture diagram](../media/hybrid-footfall-detection-pattern.png)
_Download an [SVG](../media/hybrid-connectivity.svg) of this architecture._

### Data flow

1. The Custom Vision AI Dev Kit gets a configuration from IoT Hub, which installs the IoT Edge Runtime and an ML model.
2. If the model sees a person, it takes a picture and uploads it to Azure Stack Hub blob storage.
3. The blob service triggers an Azure Function on Azure Stack Hub.
4. The Azure Function calls a container with the Face API to get demographic and emotion data from the image.
5. The data is anonymized and sent to an Azure Event Hubs cluster.
6. The Event Hubs cluster pushes the data to Stream Analytics.
7. Stream Analytics aggregates the data and pushes it to Power BI.

### Components

This solution uses the following components:

| Layer                                                                                   | Component                                                                                                                               | Description                                                                                                                                                                                               |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| In-store hardware                                                                       | [Custom Vision AI Dev Kit](https://azure.github.io/Vision-AI-DevKit-Pages/)                                                             | Provides in-store filtering using a local ML model that only captures images of people for analysis. Securely provisioned and updated through IoT Hub.<br><br>                                            |
| Azure                                                                                   | [Azure Event Hubs](https://docs.microsoft.com/azure/event-hubs/)                                                                        | Azure Event Hubs provides a scalable platform for ingesting anonymized data that integrates neatly with Azure Stream Analytics.                                                                           |
|                                                                                         | [Azure Stream Analytics](https://docs.microsoft.com/azure/stream-analytics/)                                                            | An Azure Stream Analytics job aggregates the anonymized data and groups it into 15-second windows for visualization.                                                                                      |
|                                                                                         | [Microsoft Power BI](https://powerbi.microsoft.com/)                                                                                    | Power BI provides an easy-to-use dashboard interface for viewing the output from Azure Stream Analytics.                                                                                                  |
| [Azure Stack Hub](https://docs.microsoft.com/azure-stack/operator/azure-stack-overview) | [App Service](/azure-stack/operator/azure-stack-app-service-overview)                                                                   | The App Service resource provider (RP) provides a base for edge components, including hosting and management features for web apps/APIs and Functions.                                                    |
|                                                                                         | Azure Kubernetes Service [(AKS) Engine](https://github.com/Azure/aks-engine) cluster                                                    | The AKS RP with AKS-Engine cluster deployed into Azure Stack Hub provides a scalable, resilient engine to run the Face API container.                                                                     |
|                                                                                         | Azure Cognitive Services [Face API containers](https://docs.microsoft.com/azure/cognitive-services/face/face-how-to-install-containers) | The Azure Cognitive Services RP with Face API containers provides demographic, emotion, and unique visitor detection on Contoso's private network.                                                        |
|                                                                                         | [Blob Storage](https://docs.microsoft.com/azure-stack/user/azure-stack-storage-overview)                                                | Images captured from the AI Dev Kit are uploaded to Azure Stack Hub's blob storage.                                                                                                                       |
|                                                                                         | [Azure Functions](https://docs.microsoft.com/azure-stack/operator/azure-stack-app-service-overview)                                     | An Azure Function running on Azure Stack Hub receives input from blob storage and manages the interactions with the Face API. It emits anonymized data to an Event Hubs cluster located in Azure.<br><br> |

## Next steps

To learn more about the topics introduced in this article:

- See the [Tiered Data pattern](https://docs.microsoft.com/hybrid/app-solutions/pattern-tiered-data-analytics), which is leveraged by the footfall detection pattern.
- See the [Custom Vision AI Dev Kit](https://azure.github.io/Vision-AI-DevKit-Pages/) to learn more about using custom vision.
- See the [Azure Storage](https://docs.microsoft.com/azure/storage/) and [Azure Functions](https://docs.microsoft.com/azure/azure-functions/) documentation. This pattern makes heavy use of Azure Storage accounts and Azure Functions on both Azure and Azure Stack Hub.
- See [Hybrid application design considerations](https://docs.microsoft.com/hybrid/app-solutions/overview-app-design-considerations) to learn more about best practices and to get answers to additional questions.
- See the [Azure Stack family of products and solutions](https://docs.microsoft.com/azure-stack) to learn more about the entire portfolio of products and solutions.
