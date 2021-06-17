---
title: Cloud application signaling for IoT with Azure SignalR Service
description: Use Azure SignalR Service for cloud application signaling. This service sends real-time IoT data to clients like web pages and mobile apps.
author: falloutxAY
ms.author: ansyeo
ms.date: 06/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - iot
products:
  - azure-functions
  - azure-iot-edge
  - azure-iot-hub
  - azure-maps
  - azure-signalr-service
categories: iot
ms.custom:
  - fcp
  - guide
---

# Cloud application signaling pattern for IoT

Internet of Things (IoT) applications often work with real-time data from IoT devices. For instance, some apps display device telemetry or alerts. With traditional polling methods, these client apps ask the devices for state changes.

This guide outlines a way for clients like web pages or mobile apps to receive updates from devices in real time. With the signaling pattern that this guide presents, cloud apps no longer submit HTTP requests for up-to-date information. Instead, Azure SignalR Service pushes content to connected clients as soon as it's available.

As an example, a retailer might display the total number of customers in a store on a digital sign in real time. With this guide's solution, the sign doesn't have to request the latest customer count from data storage. Instead, the system feeds that information to the sign as soon as the total changes.

## Potential use cases

Besides the retail industry, other areas can also benefit from this solution:

- Any scenario that pushes data from servers to clients in real time for use in visualizations and applications.
- Rich and highly-interactive applications like maps and customized user interfaces that numerous clients use.

Specific examples that provide real-time data updates include:

- Fleet monitoring that tracks the current location of vehicles on maps.
- Remote process monitoring that displays up-to-date manufacturing telemetry like operational status, temperature, and pressure.
- Drilling control systems that use actual telemetry like revolutions, power, and angle to optimize drilling processes.
- Notification mechanisms that immediately send out alerts when certain events occur.

## Architecture

:::image type="complex" source="./media/cloud-application-signaling.png" alt-text="Architecture diagram showing how Azure SignalR Service keeps clients like web pages and mobile apps updated with real-time I O T data." border="false":::
   The diagram contains several boxes. A box in the lower right corner indicates that gray arrows represent data flow, and blue arrows, control flow. On the left, two boxes have the label Devices. A gray arrow points from the upper Device box to a box for Azure I O T Hub. Another gray arrow points from the other Device box to a box for Azure I O T Edge. A label above the Azure I O T Edge box reads Field gateway. A third gray arrow points from Azure I O T Edge to the Azure I O T Hub box. A fourth gray arrow points from Azure I O T Hub to a box for Azure Functions. A fifth gray arrow points from the Functions box to an Azure SignalR Service box. On the right is a large box that contains icons and labels for web and mobile apps. Above the large box is a label that reads Presentation and interaction. A gray arrow points from Azure SignalR Service to the large box. A bidirectional blue arrow connects the large box with the Azure SignalR Service box. Another bidirectional blue arrow connects the large box with the Functions box. Numbers in the diagram correspond with numbered steps in the document.
:::image-end:::

1. Web pages, mobile apps, and other clients request an Azure SignalR Service endpoint and token from Azure Functions. This serverless compute platform integrates data from various sources. But it also manages Azure SignalR Service endpoints and information on client groups.

1. Clients use the endpoint and token to connect to Azure SignalR Service. This managed service simplifies the process of adding real-time communication to web apps.

1. IoT devices send telemetry to Azure IoT Hub. Azure IoT Edge sends processed IoT device telemetry to IoT Hub.

1. The telemetry triggers a function in Azure Functions. The function:

   - Runs any calculations on the telemetry that you program.
   - Transforms the data any way that you program.
   - Uses the managed service Azure SignalR Service to broadcast the data.

1. Azure SignalR Service provides an abstraction over several techniques used for building real-time applications. WebSocket is the optimal transport protocol. But Azure SignalR Service uses techniques like server-sent events (SSE) and long polling when other options aren't available. Azure SignalR Service automatically detects and initializes the appropriate transport based on the features that the server and client support.

1. The Azure SignalR Service message goes out to a specific client or group of clients. The clients use the data to update apps.

## Considerations

Consider these points when you use this pattern:

- If your system has strict performance requirements, understand that many factors can contribute to latency between data ingestion points and the application layer. To ensure you don't exceed latency limits, keep these points in mind:

  - In real-time scenarios, cloud application signaling may increase latency by up to 10 seconds.
  - Any data transformation steps that you add to the solution may increase latency.

- Understand the factors that affect your scenario's inbound and outbound capacity. To accommodate a range of performance capacities, Azure SignalR Service defines seven tiers. Select the tier that best meets your requirements. For more information, see [Performance guide for Azure SignalR Service](/azure/azure-signalr/signalr-concept-performance).

- Don't use this solution when you need to guarantee message delivery.

- When you're displaying real-time data in Power BI visuals, consider [Real-time streaming in Power BI](/power-bi/connect-data/service-real-time-streaming) as an alternative to this solution.

## Next steps

- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service/)
- [Tutorial: Azure SignalR Service authentication with Azure Functions](/azure/azure-signalr/signalr-tutorial-authenticate-azure-functions)
- [Build real-time Apps with Azure Functions and Azure SignalR Service](/azure/azure-signalr/signalr-concept-azure-functions)
- [Visualize real-time sensor data from Azure IoT Hub using Power BI](/azure/iot-hub/iot-hub-live-data-visualization-in-power-bi)
- [Azure Stream Analytics solution patterns](/azure/stream-analytics/stream-analytics-solution-patterns)

## Related resources

To learn about related solutions, see this information:

### IoT architecture guides

- [IoT solutions conceptual overview](/azure/architecture/example-scenario/iot/introduction-to-solutions)
- [IoT solution architecture](/azure/architecture/example-scenario/iot/devices-platform-application)
- [Azure industrial IoT analytics guidance](/azure/architecture/guide/iiot-guidance/iiot-architecture)

### IoT patterns

- [IoT event routing](/azure/architecture/example-scenario/iot/event-routing)
- [IoT measure and control loops](/azure/architecture/example-scenario/iot/measure-control-loop)
- [IoT monitor and manage loops](/azure/architecture/example-scenario/iot/monitor-manage-loop)

### IoT architectures

- [Azure IoT reference architecture](/azure/architecture/reference-architectures/iot)
- [IoT and data analytics](/azure/architecture/example-scenario/data/big-data-with-iot)
- [Predictive maintenance with the intelligent IoT Edge](/azure/architecture/example-scenario/predictive-maintenance/iot-predictive-maintenance)
- [Project 15 Open Platform](/azure/architecture/solution-ideas/articles/project-15-iot-sustainability)