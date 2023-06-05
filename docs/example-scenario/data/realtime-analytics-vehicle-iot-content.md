[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution builds a real-time data ingestion/processing pipeline to ingest and process messages from IoT devices into a big data analytic platform in Azure. The architecture uses Azure Sphere and Azure IoT Hub to manage telematics messages, and Azure Stream Analytics processes the messages.

## Architecture

:::image type="content" border="false" source="media/architecture-realtime-analytics-vehicle-data-1.png" alt-text="Diagram showing vehicle data ingestion, processing, and visualization." lightbox="media/architecture-realtime-analytics-vehicle-data-1.png":::

*Download a [Visio file](https://arch-center.azureedge.net/architecture-realtime-analytics-vehicle-data.vsdx) of this architecture.*

### Dataflow

The data flows through the solution as follows:

1.  Telematics messages (speed, location, and so on) are sent by an Azure Sphere cellular-enabled device to Azure IoT Hub. In a greenfield scenario, the vehicle manufacturer might include a Sphere module in each vehicle at time of manufacture. In a brownfield scenario, the vehicle is retrofitted with an after-market telematics solution.

1. Azure Stream Analytics picks up the message in real time from Azure IoT Hub, processes the message based on the business logic and sends the data to the serving layer for storage.

1. Different databases are used depending on the data. Azure Cosmos DB stores the messages, while Azure SQL DB stores relational and transactional data, and acts as a data source for the presentation and action layer. Azure Synapse contains aggregated data and acts as the data source for Business Intelligence (BI) tools.

1. Web, mobile, BI, and mixed reality applications can be built on the serving layer. For example, you can expose serving layer data using APIs for third-party uses (for example, insurance companies, suppliers, and so on).

1. When a vehicle requires servicing at a dealer service center, an Azure Sphere device is connected to the vehicle's OBD-II port by a service technician.

1. The Azure Sphere application connects to the vehicle's OBD-II port and streams OBD-II data to Azure IoT Edge over MQTT. The Azure Sphere device is connected over Wi-Fi to the Azure IoT Edge device installed at the service center. The OBD-II data is streamed from Azure IoT Edge to Azure IoT Hub and processed in the same message processing pipeline.

    - With the latest 20.10 OS release, Azure Sphere can now connect securely to Azure IoT Edge using its own device certificates. Azure Sphere device certificate is unique to every device and is automatically renewed by Azure Sphere Security Service every 24 hours after the device passes the remote attestation and authentication process.

    - Azure Sphere communicates directly with the Azure Sphere Security Service and not through Azure IoT Edge. Azure Sphere Security Service is Microsoft's cloud-based service that communicates with Azure Sphere chips to enable maintenance, update, and control. Sometimes abbreviated AS3.

1. [General-purpose MQTT brokering](/azure/iot-edge/iot-edge-runtime?view=iotedge-2020-11#using-the-mqtt-broker) is now available in Azure IoT Edge. The Azure Sphere device will publish messages to the IoT Hub built-in MQTT topic (`devices/{sphere_deviceid}/messages/events/`).

    - Azure IoT Edge modules are containerized applications managed by IoT Edge and can run Azure services (such as Azure Stream Analytics), custom ML models or your own solution-specific code.

1. A service technician, wearing a HoloLens, can subscribe to the MQTT topic (`devices/{sphere_deviceid}/messages/events/`) and securely view OBD-II data using a HoloLens application containing an MQTT client. The HoloLens MQTT client must be [authorized to connect and subscribe](/azure/iot-edge/how-to-publish-subscribe?view=iotedge-2020-11#authorization) to the topic. By connecting the HoloLens directly to the IoT Edge gateway, the service technician can view the vehicle's data in near real-time, avoiding the latency of sending the data to the cloud and back. The service technician can also interact with the vehicle's OBD-II port (for example, clear "check engine"
    light) even when the service center is disconnected from the cloud.

### Components

- [Azure Sphere](https://azure.microsoft.com/services/azure-sphere) is a secure, high-level application platform with built-in communication and security features for internet-connected devices. It comprises a secured, connected, crossover microcontroller unit (MCU), a custom Linux-based operating system (OS), and a cloud-based security service that provides continuous, renewable security.

- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) provides MQTT brokering and runs intelligent edge applications on-premises to ensure low latency, lower bandwidth usage.

- [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) is in the ingestion layer and supports bi-directional communication back to devices, allowing Actions to be sent from the cloud or Azure IoT Edge to the device.

- [Azure Stream Analytics (ASA)](https://azure.microsoft.com/services/stream-analytics) provides real-time, serverless stream processing that can run the same queries in the cloud and on the edge. ASA on Azure IoT Edge can filter or aggregate data locally, enabling intelligent decisions about which data needs to be sent to the cloud for further processing or storage.

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db), [Azure SQL Database and Azure Synapse Analytics](https://azure.microsoft.com/services/azure-sql/) are in the Serving storage layer. Azure Stream Analytics can write messages directly to Azure Cosmos DB using an
    [output](/azure/stream-analytics/stream-analytics-define-outputs). Data can be aggregated and moved from Azure Cosmos DB and Azure SQL to Azure Synapse using [Azure Data Factory](/azure/data-factory/).

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) is a distributed system for storing and analyzing large datasets. Its use of massive parallel processing (MPP) makes it suitable for running high-performance analytics.

- [Azure Synapse Link for Azure Cosmos DB](/azure/cosmos-db/synapse-link) enables you to run near real-time analytics over operational data in Azure Cosmos DB, **without any performance or cost impact on your transactional workload**, by using the two analytics engines available from your Azure Synapse workspace: [SQL Serverless](/azure/synapse-analytics/sql/on-demand-workspace-overview) and [Spark Pools](/azure/synapse-analytics/spark/apache-spark-overview).

- [Microsoft Power BI](https://powerbi.microsoft.com/) is a suite of business analytics tools to analyze data and share insights. Power BI can query a semantic model stored in Analysis Services, or it can query Azure Synapse directly.

- [Azure App Services](https://azure.microsoft.com/services/app-service) can be used to build web and mobile applications. [Azure API Management](https://azure.microsoft.com/services/api-management) can be used to expose data to third parties, based on the data stored in the Serving Layer.

- [Microsoft HoloLens](https://www.microsoft.com/hololens) can be used by service technicians to view vehicle data (for example, service history, OBD-II data, part diagrams, and so on) holographically to aid in troubleshooting and repair.

### Alternatives

- [Synapse Link](/azure/cosmos-db/synapse-link) is the Microsoft preferred solution for analytics on top of Azure Cosmos DB data.

## Scenario details

Vehicle data ingestion, processing, and visualization are key capabilities needed to create connected car solutions. By capturing and analyzing this data, we can decipher valuable insights and create new solutions.

For example, with vehicles equipped with telematics devices, we can monitor the live location of vehicles, plan optimized routes, provide assistance to drivers, and support industries that consume or benefit from telematics data such as insurers. For vehicle manufacturers, diagnostic information can provide important information for vehicle servicing and warranties.

### Potential use cases

Imagine a car manufacturing company that wants to create a solution to:

- Securely send real-time data to the cloud from sensors and onboard computers installed in its vehicles.

- Create value-added services for its customers and dealers by analyzing vehicle location, and other sensor data (such as engine-related sensors and environment-related sensors).

- Store the data for additional downstream processing to provide actionable insights (For example, maintenance alerts for vehicle owners, accident information for insurance agencies, and so on).

- Allow dealer service technicians to interact with vehicles using a mixed reality application to aid in troubleshooting and repair (For example, using a HoloLens application to view real-time data and view/clear diagnostic codes available through a vehicle's
    [OBD-II](https://wikipedia.org/wiki/On-board_diagnostics) port, view repair procedures, or to view an exploded 3D parts diagram).

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Kevin Hilscher](https://ca.linkedin.com/in/kevinhilscher) | Principal Product Manager

## Next steps

- Review the [Sending OBD-II Data to HoloLens using MQTT and Azure Sphere GitHub repo](https://github.com/mixedrealityiot/OBD-II_MQTT_HoloLens/blob/master/README.md) for a prototype that demonstrates how to stream a vehicle's OBD-II data to Microsoft HoloLens using Azure Sphere and MQTT.

- Read about how [Mercedes-Benz USA has trimmed service and maintenance times with HoloLens 2](https://news.microsoft.com/transform/vroom-with-a-view-hololens-2-powers-faster-fixes-mercedes-benz-usa).

- Read about the [Azure Sphere cellular-enabled guardian device powered by AT&T](https://azure.microsoft.com/blog/attpowered-guardian-device-with-azure-sphere-enables-highly-secured-simple-and-scalable-connectivity-from-anywhere).

- Review [Publish and subscribe with Azure IoT Edge](/azure/iot-edge/how-to-publish-subscribe?view=iotedge-2020-11) to understand how to configure general-purpose MQTT brokering in IoT Edge.

- Review [Set up up Azure IoT Edge for Azure Sphere](/azure-sphere/app-development/setup-iot-edge) to learn how to use Azure Sphere Device Certificate for IoT Edge.

## Related resources

- Review the [Azure IoT Reference Architecture](../../reference-architectures/iot.yml) that shows a recommended architecture for IoT applications on Azure using PaaS (platform-as-a-service) components.

- Review the [Advanced analytics architecture](/azure/architecture/solution-ideas/articles/advanced-analytics-on-big-data) to get a peek on how different Azure components can help build a big data pipeline.

- Review the [Real-time analytics architecture](/azure/architecture/solution-ideas/articles/real-time-analytics) that includes a big data pipeline flow.
