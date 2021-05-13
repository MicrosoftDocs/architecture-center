# Cloud Application Signaling Pattern

## Motivations
Some Internet of Things (IoT) applications need to visualize and action on real-time telemetry/alerts from IoT devices. Rather than traditional polling methods, which involves clients asking for state changes, real-time functionality can be achieved when a content is pushed to connected clients instantly as it becomes available.

## Architecture

In an IoT solution, telemetry and alerts can be consumed in near real-time by pushing updates to connected clients. For example, a web page or mobile application. Clients can be updated without the need to poll the server.

![Architecture diagram showing the data flow for cloud application signaling pattern](media/cloud-application-signaling.png)

1.  IoT devices send telemetry data to IoT Hub. 
2.  Azure Functions is a serverless compute which is used to integrate the telemetry data from IoT Hub to Azure SignalR. Azure SignalR Service is a managed service that simplifies adding real-time communications to customers' web applications. SignalR provides an abstraction over several techniques used for building real-time applications. WebSocket is the optimal transport, but other techniques like Server-Sent Events (SSE) and Long Polling are used when other options aren't available. SignalR automatically detects and initializes the appropriate transport based on the features supported on the server and client. Any transformation or calculations can be programmed on Azure Functions. Azure Functions is also used to manage the SignalR endpoint(s) and the group information of client (web/mobile apps). 
3.  Clients get the SignalR endpoint and token from Azure Functions.
4.  Clients set up a connection with SignalR Service.
5.  The Azure Functions can broadcast telemetry, send telemetry to a group or a specific client via SignalR Service based on customer needs. The client (web/mobile apps) will then update the application based on the data in the SignalR message. 

## Characteristics

Here are some considerations when using this pattern.
-   Low latency requirements: Understand the maximum latency requirement from the data ingestion to the application. The cloud application signal pattern may apply to near real-time scenarios of up to 10 seconds. Any extra data transformation and/or layers may impact latency.
-   Performance: Understand the inbound and outbound messages in the scenario and select the right tiers to scale the solution based on requirements. For more information, see [Performance considerations](/azure/azure-signalr/signalr-concept-performance). 

When to use this pattern:
-   Any scenario that requires pushing data from server to client in real-time. Sending data for real-time functionality like visualization and/or applications. 
-   Need flexibility for client applications. As compared to only visualization using Power BI Streaming Datasets, this pattern enables a multitude of clients and enables other scenarios like updating maps and customized UI. 

When not to use this pattern:
-   This pattern is used for real-time functionality of a **cloud-based** application. If the scenario calls for low latency and reliability, an on-premises based solution design may be considered. 
-   When required to visualize on Power BI, the [streaming data](/power-bi/connect-data/service-real-time-streaming) could be an option.


## Use cases
-   Fleet monitoring: Real-time location tracking of vehicles on maps.
-   Real-time remote monitoring of critical process: Monitoring critical telemetry data like operational status, temperature, and pressure in process manufacturing. 
-   Real-time monitoring of drilling conditions: Viewing critical telemetry data like revolutions, power, and angle to optimize process. 
-   Real-time notifications: Pushing real-time alerts based on the events received. 

## See also

-   [Azure SignalR](https://azure.microsoft.com/services/signalr-service/)
-   [Real time IoT data with SignalR](https://anthonychu.ca/post/end-to-end-realtime-python-iot-azure-functions-signalr-iothub/)
-   [Broadcast Real-time Updates from Cosmos DB with SignalR Service and Azure Functions](https://anthonychu.ca/post/cosmosdb-real-time-azure-functions-signalr-service/)
-   [Visualizing real time IoT data using Power BI](/azure/iot-hub/iot-hub-live-data-visualization-in-power-bi)
-   [Azure Stream Analytics patterns](/azure/stream-analytics/stream-analytics-solution-patterns)
