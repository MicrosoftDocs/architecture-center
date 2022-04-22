[Industrial internet of things (IIoT)](/azure/industrial-iot/overview-what-is-industrial-iot) is the application of IoT technology to the manufacturing industry. This series of articles discusses a recommended architecture for an IIoT analytics solution that uses Azure [platform as a service (PaaS)](https://azure.microsoft.com/overview/what-is-paas) components.

IIoT goes beyond moving existing manufacturing processes and tools to the cloud. A modern IIoT analytics solution transforms operations, embraces PaaS services, and uses the power of machine learning (ML) and intelligent edge computing to optimize industrial processes.

IIoT analytics applications support the following business practices:

- Asset monitoring
- Process dashboards
- Overall equipment effectiveness (OEE)
- Predictive maintenance
- Forecasting

The following roles participate in IIoT analytics solutions:

- The *plant manager* is responsible for all manufacturing plant operations, production, and administrative tasks.
- A *production manager* is responsible for the production of a certain number of components.
- A *process engineer* designs, implements, controls, and optimizes industrial processes.
- An *operations manager* oversees overall operational efficiency in terms of cost reduction, process time, and process improvements.
- A *data scientist* builds and trains predictive ML models by using historical industrial telemetry.

The IIoT analytics architecture in these articles uses [Azure Industrial IoT](https://github.com/Azure/Industrial-IoT/blob/master/docs/deploy/readme.md) components. IIoT solutions might not always use all these services, and might use other services. The articles list some alternative service options where applicable.

## Architecture

An IIoT analytics architecture is an ingestion-only pattern that doesn't send control commands back to the industrial systems or devices. The following architectural diagram shows the core subsystems that form an IIoT analytics solution.

[![Azure IIoT architecture diagram.](./images/iiot-architecture.png)](./images/iiot-architecture.png#lightbox)

## Industrial systems and devices

An IIoT analytics solution relies on real-time and historical data from industrial devices and control systems in manufacturing facilities. These devices and control systems include:

- Industrial equipment
- Programmable Logic Controllers (PLCs)
- Supervisory Control and Data Acquisition (SCADA) systems
- Manufacturing Execution Systems (MESs)
- Process historians

Process manufacturing must often remotely monitor geographically dispersed industrial equipment. Remote Terminal Units (RTUs) connect remote equipment to central SCADA systems. RTUs work well in conditions where connectivity is intermittent and no reliable continuous power supply exists.

In discrete manufacturing, PLCs connect and control industrial equipment like factory robots and conveyor systems. Industrial protocols like Modbus connect one or more PLCs to a central SCADA system.

Sometimes, SCADA system data is forwarded and centralized in a MES or a historian program, also called a process historian or operational historian. Historians are often located in IT-controlled networks that have some internet access.

Industrial equipment and SCADA systems are often in closed Process Control Networks (PCNs) behind firewalls, with no direct internet access. Historians that contain industrial data from multiple facilities are located outside of PCNs. Connecting to a historian is often easier than connecting to a SCADA, MES, or PLC. If no historian is available, connecting to an MES or SCADA system is the next logical choice.

The connection to a historian, MES, or SCADA system depends on what protocols are available that aren't blocked by firewalls on that system. Many systems now support Industry 4.0 standards such as OPC UA. Older systems might support only legacy protocols like Modbus, ODBC, or SOAP. Older systems often require [protocol translation software](/samples/azure-samples/azure-iotedge-opc-flattener/azure-iot-edge-protocol-translation-sample) running on an edge device to connect to the cloud.

### OPC UA standard

The [OPC Foundation](https://opcfoundation.org) maintains the OPC UA standard. The [OPC UA](https://opcfoundation.org/about/opc-technologies/opc-ua) protocol is the successor to [OPC Classic](https://opcfoundation.org/about/opc-technologies/opc-classic), OPC DA, AE, or HDA. Microsoft is a member of the OPC Foundation and supports OPC UA on Azure.

OPC UA bases industry and domain-specific *information models* on the OPC UA *data model*. The OPC UA infrastructure can exchange these *companion specifications* to support interoperability at the semantic level. OPC UA can use several transport protocols, including MQTT, AMQP, and UADP.

## Intelligent edge devices

Intelligent edge devices process some data on the devices themselves or on a [field gateway](#field-gateways). Edge devices can operate in offline or intermittent network conditions, providing *store and forward* capabilities.

[![Azure IoT Edge device](./images/iot-edge.png)](./images/iot-edge.png#lightbox)

[Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) uses built-in, custom, or third-party modules in Docker containers to run cloud-native workloads directly on IoT devices.

You can develop custom IoT Edge modules in several languages, with SDKs for Python, Node.js, C#, Java, and C. You can also get prebuilt Microsoft and third-party IoT Edge modules from the [Azure IoT Edge Marketplace](https://azure.microsoft.com/blog/publish-your-azure-iot-edge-modules-in-azure-marketplace).

The [IoT Edge runtime](/azure/iot-edge/iot-edge-runtime) provides two system modules:

- The *IoT Edge agent* module pulls down the container orchestration specification manifest from the cloud, so IoT Edge knows which modules to run.  Module configuration is provided as part of the [module twin](/azure/iot-hub/iot-hub-devguide-module-twins).

- The *IoT Edge hub* module manages the communication from the device to [Azure IoT Hub](/azure/iot-hub/about-iot-hub), as well as inter-module communication. Messages route from one module to the next with JSON configuration. IoT Edge encrypts and streams real-time industrial data to IoT Hub by using AMQP 1.0 or MQTT 3.1.1 protocols.

Edge workloads can:

- Run anomaly detection or ML modules in tight control loops, to respond to emergencies as quickly as possible.
- Reduce bandwidth and costs by cleaning and aggregating data locally, and sending only insights to the cloud for further analysis.
- Quickly respond to factory floor events by using one module to detect events and another module to respond to them.
- Use a protocol translation module to convert legacy industrial protocols.

Protocol and identity translation are the most common edge workloads that IIoT analytics solutions use. The [Azure Marketplace](https://azuremarketplace.microsoft.com) has protocol and identity translation modules and solutions that Microsoft partners have developed.

## Field gateways

Most industrial equipment can't have software installed on it directly, so it needs a field gateway to connect to the cloud.

IoT Edge free, open source [field gateway software](https://github.com/Azure/iotedge) runs on a variety of [supported devices](/azure/iot-edge/support) or on a virtual machine (VM). To connect industrial equipment and systems to the cloud, you can use IoT Edge as the field gateway for:

- Protocol and identity translation.
- Edge processing and analytics.
- Adherance to network security policies like ISA 95 and ISA 99.

An IoT Edge field gateway or VM uses [three patterns](/azure/iot-edge/iot-edge-as-gateway) for connecting devices to Azure:

- *Transparent* devices already have the capability to send messages to IoT Hub using AMQP or MQTT. Instead of sending the messages directly to IoT Hub, they can send the messages to IoT Edge, which passes them on to IoT Hub. Each device has an [identity](/azure/iot-hub/iot-hub-devguide-identity-registry) and [device twin](/azure/iot-hub/iot-hub-devguide-device-twins) in Azure IoT Hub.

- The *protocol translation* pattern is also called an *opaque gateway* pattern, and connects older brownfield equipment protocols like Modbus to Azure. Deployed IoT Edge modules do the protocol conversion. Devices must provide a unique identifier to the gateway.

- The *identity translation* pattern is for devices like OPC UA PubSub or BLE that can't communicate directly to IoT Hub. The field gateway understands the protocol the downstream devices use, provides the devices with identity, and translates the IoT Hub primitives. Each device has an identity and device twin in Azure IoT Hub.

The protocols your industrial systems use determine which patterns to use in your IIoT analytics solution. For example, if your SCADA system supports ethernet/IP, you need to use protocol translation software to convert ethernet/IP to MQTT or AMQP.

You can provision IoT Edge gateways at scale by using the [Azure IoT Hub Device Provisioning Service (DPS)](/azure/iot-dps/about-iot-dps). DPS is an IoT Hub helper service that enables just-in-time provisioning to IoT Hub without human intervention. DPS can securely and scalably provision millions of devices.

[IoT Edge automatic deployments](https://azure.microsoft.com/blog/new-enhancements-for-azure-iot-edge-automatic-deployments) can specify a standing deployment configuration across thousands of IoT Edge devices.

Proper hardware sizing of an IoT Edge gateway is important to ensure good edge module performance. For more information, see [Performance considerations](iiot-considerations.md#performance-considerations).

Several third-party IoT Edge gateway devices are available from the [Azure Certified for IoT Device Catalog](https://catalog.azureiotsolutions.com/alldevices?filters={%2218%22:[%221%22]}).

## Azure Industrial IoT

Microsoft based the following open-source [Azure Industrial IoT](https://github.com/Azure/Industrial-IoT/blob/master/docs/deploy/readme.md) components on OPC UA to implement identity translation:

- [OPC Twin](https://github.com/Azure/azure-iiot-opc-twin-module) consists of microservices and an Azure IoT Edge module, which connect the cloud to a factory network. OPC Twin provides discovery, registration, and synchronous remote control of industrial devices through REST APIs.

- [OPC Publisher](/azure/industrial-iot/overview-what-is-opc-publisher) is an Azure IoT Edge module that publishes telemetry data from OPC UA servers in OPC UA PubSub format, in both JSON and binary.

- [OPC Vault](https://github.com/Azure/azure-iiot-opc-vault-service/blob/main/docs/opcvault-services-overview.md) is a cloud microservice that can configure, register, and manage certificate lifecycle for OPC UA server and client applications.

- [Discovery Services](https://azure.github.io/Industrial-IoT/modules/discovery.html) is an Azure IoT Edge module that supports network scanning and OPC UA discovery.

See the Microsoft Azure IIoT solution on [GitHub](https://azure.github.io/Industrial-IoT) for more open-source services, REST APIs, deployment scripts, and configuration tools you can integrate into IIoT analytics solutions.

## Historian connection

A common pattern in an IIoT analytics solution is to connect to a process historian, and stream real-time data from the historian to IoT Hub. The connection method depends on which protocols are installed that aren't blocked by firewalls on the historian.

| Historian protocol | Connection options |
|----------------------------|---------------------------|
| OPC UA |• Use Azure IoT Edge, along with OPC Publisher, OPC Twin, and OPC Vault, to send OPC UA data over MQTT to IoT Hub. OPC Twin also supports OPC UA HDA profile, which is useful for historical data.<br><br>• Use a third-party Azure IoT Edge OPC UA module to send OPC UA data over MQTT to IoT Hub.|
| OPC DA |• Use third-party software to convert OPC DA to OPC UA and send OPC UA data to IoT Hub over MQTT. Or use OPC Publisher, OPC Twin, and OPC Vault to send OPC UA data over MQTT to IoT Hub. |
| Web service |• Use a custom IoT Edge HTTP module to poll the web service.<br><br>• Use third-party software that supports HTTP to MQTT 3.1.1 or AMQP 1.0.<p> |
| MQTT 3.1.1 that can publish MQTT messages | • Connect the historian directly to IoT Hub using MQTT.<br><br>• Connect the historian to IoT Edge as a leaf device in the transparent gateway pattern.|
| Other |• Use a custom Azure IoT Edge module.<br><br>• Use third-party software to convert to MQTT 3.1.1 or AMQP 1.0.|

The following historian vendors also provide first-class capabilities to send data to Azure:

|Historian|Options|
|--------------|-----------------------|
|OSIsoft PI|[PI Integrator for Azure](https://techsupport.osisoft.com/Products/PI-Integrators/PI-Integrator-for-Microsoft-Azure/Overview)|
|Honeywell|[Uniformance Cloud Historian](https://www.honeywellprocess.com/en-US/online_campaigns/uniformance_cloud_historian/Pages/index.html)|

After you establish real-time data streaming between the historian and IoT Hub, export the historian's historical data and import it into the IIoT analytics solution. For more information, see [Historical data ingestion](iiot-services.md#historical-data-ingestion).

## Cloud gateway

A cloud gateway provides a cloud hub for devices and field gateways to connect securely to the cloud and send data. The cloud gateway also provides device management capabilities. Use [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) as a hosted cloud service to ingest events from devices and IoT Edge gateways. IoT Hub provides secure connectivity, event ingestion, bidirectional communication, and device management. IoT Hub uses cloud-based REST APIs to combine with Azure Industrial IoT components to control your industrial devices.

IoT Hub supports the following [protocols](/azure/iot-hub/iot-hub-devguide-protocols):

- MQTT 3.1.1
- MQTT over WebSockets
- AMQP 1.0
- AMQP over WebSockets
- HTTPS

An industrial device or system that supports any of the preceding protocols can send data directly to IoT Hub. Most industrial environments don't allow this direct connection, because of PCN firewalls and ISA 95 and ISA 99 network security policies. In these cases, you can install an IoT Edge field gateway in a [DMZ](../../reference-architectures/dmz/secure-vnet-dmz.yml) between the PCN and the internet.

## Next steps

> [!div class="nextstepaction"]
> [Services in an Azure Industrial IoT (IIoT) analytics solution](iiot-services.md)
