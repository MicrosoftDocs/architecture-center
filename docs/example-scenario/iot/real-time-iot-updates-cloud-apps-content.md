Internet of Things (IoT) applications often need real-time data from IoT devices. For instance, some apps display telemetry or alert data that they obtain from devices. With traditional polling methods, these client apps ask the devices for state changes.

This guide outlines a way for clients like web pages or mobile apps to receive updates from devices in real time. Cloud apps no longer submit HTTP requests for up-to-date information. Instead, Azure SignalR Service pushes content to clients as soon as it's available. As a managed service, Azure SignalR Service simplifies the process of adding real-time communication to apps.

For example, a retailer might have a dashboard app that displays the current number of customers in a store. With this guide's solution, the app doesn't request the latest customer count. Instead, Azure SignalR Service feeds that information to the app when the total changes.

## Potential use cases

Besides the retail industry, other areas can also benefit from this solution:

- Any scenario in which servers push real-time data to clients for use in visualizations and applications.
- Rich and highly interactive apps like customized user interfaces and maps.

Specific examples that provide real-time data updates include:

- Fleet monitoring that maps vehicle location.
- Remote monitoring of temperature, pressure, and status for a manufacturing process.
- Drilling control systems that use telemetry like revolutions per minute, torque, and hook load to optimize processes.
- Alerting mechanisms.

## Architecture

:::image type="complex" source="./media/real-time-iot-updates-cloud-apps.png" alt-text="Architecture diagram showing how Azure SignalR Service keeps clients like web pages and mobile apps updated with real-time I O T data." border="false":::
   The diagram contains several boxes. A box in the lower right corner indicates that gray arrows represent data flow, and blue arrows, control flow. On the left, two boxes have the label Devices. A gray arrow points from the upper Device box to a box for Azure I O T Hub. Another gray arrow points from the other Device box to a box for Azure I O T Edge. A label above the Azure I O T Edge box reads Field gateway. A third gray arrow points from Azure I O T Edge to the Azure I O T Hub box. A fourth gray arrow points from Azure I O T Hub to a box for Azure Functions. A fifth gray arrow points from the Functions box to an Azure SignalR Service box. On the right is a large box that contains icons and labels for web and mobile apps. Above the large box is a label that reads Presentation and interaction. A gray arrow points from Azure SignalR Service to the large box. A bidirectional blue arrow connects the large box with the Azure SignalR Service box. Another bidirectional blue arrow connects the large box with the Functions box. Numbers in the diagram correspond with numbered steps in the document.
:::image-end:::

1. Web pages, mobile apps, and other clients request an Azure SignalR Service endpoint and token from Azure Functions, a serverless compute platform. Besides integrating data from various sources, Functions also manages Azure SignalR Service endpoints and information on client groups.

1. Clients use the endpoint and token to connect to Azure SignalR Service.

1. IoT devices send telemetry to Azure IoT Edge and Azure IoT Hub. IoT Edge sends processed IoT device telemetry to IoT Hub.

1. The telemetry triggers a function in Azure Functions. The function completes these tasks:

   - Runs any calculations that you program on the telemetry.
   - Transforms the data any way that you program.
   - Uses the managed service Azure SignalR Service to broadcast the data.

1. Azure SignalR Service supports several techniques that real-time applications use, such as WebSocket, a preferred transport protocol. But Azure SignalR Service uses techniques like server-sent events (SSE) and long polling when WebSocket isn't available. Azure SignalR Service automatically detects and initializes the appropriate transport protocol based on the features that the server and client support.

1. The Azure SignalR Service message goes out to a specific client or group of clients. The clients use the data to update apps.

## Considerations

Consider these points when you use this pattern:

- If your system has strict latency requirements, be aware of factors that can increase latency significantly:

  - In real-time scenarios, cloud application signaling may increase latency by up to 10 seconds.
  - Any data transformation steps that you add to the solution may increase latency.

- Azure SignalR Service defines seven tiers that accommodate a range of performance capacities. Determine your scenario's inbound and outbound capacity by understanding the factors that affect these values. Then select the tier that best meets your requirements. For more information, see [Performance guide for Azure SignalR Service](/azure/azure-signalr/signalr-concept-performance).

- Don't use this solution when you need to guarantee message delivery. Due to the variable nature of clients, Azure SignalR Service doesn't always provide business-critical reliability.

- When you're displaying real-time data in Power BI visuals, consider [Real-time streaming in Power BI](/power-bi/connect-data/service-real-time-streaming) as an alternative to this solution.

## Next steps

- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service/)
- [Tutorial: Azure SignalR Service authentication with Azure Functions](/azure/azure-signalr/signalr-tutorial-authenticate-azure-functions)
- [Build real-time apps with Azure Functions and Azure SignalR Service](/azure/azure-signalr/signalr-concept-azure-functions)
- [Visualize real-time sensor data from Azure IoT Hub using Power BI](/azure/iot-hub/iot-hub-live-data-visualization-in-power-bi)
- [Azure Stream Analytics solution patterns](/azure/stream-analytics/stream-analytics-solution-patterns)

## Related resources

To learn about related solutions, see this information:

### IoT architecture guides

- [IoT solutions conceptual overview](./introduction-to-solutions.yml)
- [IoT solution architecture](./devices-platform-application.yml)
- [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.yml)

### IoT patterns

- [IoT event routing](./event-routing.yml)
- [IoT measure and control loops](./measure-control-loop.yml)
- [IoT monitor and manage loops](./monitor-manage-loop.yml)

### IoT architectures

- [Azure IoT reference architecture](../../reference-architectures/iot.yml)
- [IoT and data analytics](../data/big-data-with-iot.yml)
- [Predictive maintenance with the intelligent IoT Edge](../predictive-maintenance/iot-predictive-maintenance.yml)
- [Project 15 Open Platform](../../solution-ideas/articles/project-15-iot-sustainability.yml)
