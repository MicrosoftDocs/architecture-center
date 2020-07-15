---
title: Azure Industrial IoT guidance
titleSuffix: Azure Application Architecture Guide
description: 
author: khilscher
ms.date: 07/17/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Azure Industrial IoT Analytics Guidance

This is a series of articles that show a recommended architecture for an Industrial IoT (IIoT) Analytics Solution on Azure using PaaS (platform-as-a-service) components.

An IIoT Analytics Solution can be used to build a variety of applications that provide:

- Asset monitoring
- Process dashboards
- OEE (overall equipment effectiveness)
- Predictive maintenance
- Forecasting

The IIoT Analytics Solution relies on real time and historical data from industrial devices and control systems located in discrete and process manufacturing facilities. These include PLCs (Programmable Logic Controller), industrial equipment, SCADA (Supervisory Control and Data Acquisition) systems, MES (Manufacturing Execution System) and Process Historians. This reference architecture includes guidance for connecting to all these systems.

A modern IIoT Analytics Solution goes beyond moving existing industrial processes and tools to the cloud. It involves transforming your operations processes, embracing PaaS services, and leveraging the power of machine learning and the intelligent edge to optimize industrial processes.

This architecture includes example personas to illustrate who would use the solution and how the solution would be used.

- **Plant Manager** - responsible for the entire operations, production and administrative tasks of the Plant.
- **Production Manager** - responsible for production of a certain number of components.
- **Process Engineer** - responsible for designing, implementing, controlling and optimizing industrial processes.
- **Operations Manager** - responsible for overall efficiency of operation in terms of Cost Reduction, Process Time, Process improvement, and so on.
- **Data Scientist** – responsible for building and training predictive Machine Learning models using historical industrial telemetry.

The following architecture diagram shows the core subsystems that comprise an IIoT analytics solution.

[![Azure IIoT architecture diagram](./images/iiot-architecture.png)](./images/iiot-architecture.png#lightbox)

> [!NOTE]
> This architecture represents an ingestion-only pattern. No control commands are sent back to the industrial systems or devices.

The architecture consists of a number of subsystems and services and makes use of the [Azure Industrial IoT](https://github.com/Azure/Industrial-IoT/blob/master/docs/deploy/readme.md) components. Your own solution may not use all these services or may have additional services. This architecture also lists alternative service options, where applicable.

> [!IMPORTANT]
> This reference architecture includes some services marked as "Preview" or "Public Preview".  Preview services are governed by [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Industrial Systems and Devices

In process manufacturing, industrial equipment (e.g. flow monitors, pumps, etc.) is often geographically dispersed and must be monitored remotely. Remote Terminal Units (RTUs) connect remote equipment to a central SCADA system. RTUs work well in conditions where connectivity is intermittent, and no reliable continuous power supply exists.

In discrete manufacturing, industrial equipment (e.g. factory robots, conveyor systems, etc.) are connected and controlled by a PLC. One or more PLCs may be connected to a central SCADA system using protocols such as Modbus or other industrial protocols.

In some cases, the data from SCADA systems is forwarded and centralized in an MES or Historian software (also known as Process Historian or Operational Historian). These Historians are often located in IT controlled networks and have some access to the Internet.  

Frequently, industrial equipment and SCADA systems are in a closed Process Control Network (PCN), behind one or more firewalls, with no direct access to the Internet. Historians often contain industrial data from multiple facilities and are located outside of a PCN. Therefore, connecting to a Historian is often the path of least resistance, rather than connecting to a SCADA, MES or PLC. If a Historian is not available, then connecting to an MES or SCADA system would be the next logical choice.

The connection to the Historian, MES or SCADA system will depend on what protocols are available on that system. Many systems now include Industry 4.0 standards such as OPC UA. Older systems may only support legacy protocols such as Modbus, ODBC, or SOAP. If so, you will most likely require [Protocol Translation](https://docs.microsoft.com/samples/azure-samples/azure-iotedge-opc-flattener/azure-iot-edge-protocol-translation-sample/) software running on an Intelligent Edge device.

## Intelligent Edge

Intelligent edge devices perform some data processing on the device itself or on a field gateway. In most industrial scenarios, the industrial equipment cannot have additional software installed on it. Therefore, a field gateway is required to connect the industrial equipment to the cloud.

### Azure IoT Edge

To connect industrial equipment and systems to the cloud , we recommend using [Azure IoT Edge](https://docs.microsoft.com/azure/iot-edge/about-iot-edge) as the field gateway for:

- Protocol and identity translation;
- Edge processing and analytics; and
- Adhering to network security policies (ISA 95, ISA 99).

Azure IoT Edge is a free, [open source](https://github.com/Azure/iotedge) field gateway software that runs on a variety of [supported hardware](https://docs.microsoft.com/azure/iot-edge/support) devices or a virtual machine.

IoT Edge allows you run edge workloads as Docker container modules. The modules can be developed in several languages, with SDKs provided for Python, Node.js, C#, Java and C.  Prebuilt Azure IoT Edge modules from Microsoft and third-party partners are available from the [Azure IoT Edge Marketplace](https://azure.microsoft.com/blog/publish-your-azure-iot-edge-modules-in-azure-marketplace/).

Real time industrial data is encrypted and streamed through Azure IoT Edge to [Azure IoT Hub](https://docs.microsoft.com/azure/iot-hub/about-iot-hub) using AMQP 1.0 or MQTT 3.1.1 protocols.  IoT Edge can operate in offline or intermittent network conditions providing "store and forward" capabilities.

[![Azure IoT Edge device](./images/iot-edge.png)](./images/iot-edge.png#lightbox)

There are two system modules that are provided as part of IoT Edge runtime.

- The **EdgeAgent** module is responsible for pulling down the container orchestration specification (manifest) from the cloud so that it knows which modules to run.  Module configuration is provided as part of the [module twin](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-module-twins).
- The **EdgeHub** module manages the communication from the device to the Azure IoT Hub, as well as the inter-module communication.  Messages are routed from one module to the next using JSON configuration.

[Azure IoT Edge automatic deployments](https://azure.microsoft.com/blog/new-enhancements-for-azure-iot-edge-automatic-deployments/) can be used to specify a standing configuration for new or existing devices, providing a single location for deployment configuration across thousands of Azure IoT Edge devices.  

A number of third-party [IoT Edge gateway devices](https://catalog.azureiotsolutions.com/alldevices?filters={%2218%22:[%221%22]}) //TBD:LINK are available from the Azure Certified for IoT Device Catalog.

> [!IMPORTANT]
> Proper hardware sizing of an IoT Edge gateway is important to ensure edge module performance. See Performance Considerations later in this document.

## Gateway Patterns

There are [3 patterns for connecting your devices](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway) to Azure via an IoT Edge field gateway (or virtual machine):

1. **Transparent** - Devices already have the capability to send messages to the IoT Hub using AMQP or MQTT.  Instead of sending the messages directly to the IoT Hub, they instead send the messages to IoT Edge, which in turn passes them on to the IoT Hub.  Each device has an [identity](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-identity-registry) and [device twin](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-device-twins) in the Azure IoT Hub.

1. **Protocol Translation** - Also known as an opaque gateway pattern.  This pattern is often used to connect older brownfield equipment (e.g. Modbus) to Azure. Modules are deployed to Azure IoT Edge to perform the protocol conversion. Devices must provide a unique identifier to the gateway. 

1. **Identity Translation** - In this pattern, devices cannot communicate directly to the IoT Hub (e.g. OPC UA Pub/Sub, BLE devices). The gateway is smart enough to understand the protocol used by the downstream devices, provide them identity, and translate IoT Hub primitives.  Each device has an identity and device twin in the Azure IoT Hub.  

Although you can use any of these patterns in your IIoT Analytics Solution, your choice will be driven by which protocol is installed on your industrial systems. For example, if your SCADA system supports EtherNet/IP, you will need to use protocol translation software to convert EtherNet/IP to MQTT or AMQP. See the Connecting to Historians section for additional guidance.

IoT Edge gateways can be provisioned at scale using the [Azure IoT Hub Device Provisioning Service (DPS)](https://docs.microsoft.com/azure/iot-dps/about-iot-dps).  DPS is a helper service for IoT Hub that enables zero-touch, just-in-time provisioning to the right IoT Hub without requiring human intervention, enabling customers to provision millions of devices in a secure and scalable manner.

## OPC UA

[OPC UA](https://opcfoundation.org/about/opc-technologies/opc-ua/) is the successor to [OPC Classic](https://opcfoundation.org/about/opc-technologies/opc-classic/) (OPC DA, AE, HDA). The OPC UA standard is maintained by the [OPC Foundation](https://opcfoundation.org/). Microsoft has been a member of the OPC Foundation since 1996 and has supported OPC UA on Azure since 2016.

Industry and domain-specific Information Models can be created based on the OPC UA Data Model. The specifications of such Information Models ("Industry standard models" because they typically address a dedicated industry problem) are called Companion Specifications. The synergy of the OPC UA infrastructure to exchange such industry information models enables interoperability at the semantic level. OPC UA can utilize a number of transport protocols including MQTT, AMQP, and UADP.

Microsoft has developed open source [Azure Industrial IoT](https://github.com/Azure/Industrial-IoT/blob/master/docs/deploy/readme.md) components, based on OPC UA, which implement identity translation pattern:

- [OPC Twin](https://docs.microsoft.com/azure/iot-accelerators/overview-opc-twin) consists of microservices and an Azure IoT Edge module to connect the cloud and the factory network. OPC Twin provides discovery, registration, and synchronous remote control of industrial devices through REST APIs.
- [OPC Publisher](https://docs.microsoft.com/azure/iot-accelerators/overview-opc-publisher) is an Azure IoT Edge module that connects to existing OPC UA servers and publishes telemetry data from OPC UA servers in OPC UA PubSub format, in both JSON and binary.
- [OPC Vault](https://docs.microsoft.com/azure/iot-accelerators/overview-opc-vault) is a microservice that can configure, register, and manage certificate lifecycle for OPC UA server and client applications in the cloud.
- [Discovery Services](https://azure.github.io/Industrial-IoT/modules/discovery.html) is an Azure IoT Edge module that supports network scanning and OPC UA discovery.

The Microsoft Azure IIoT team has also developed a number of services, REST APIs, deployment scripts and configuration tools that you can integrate into your IIoT Analytics Solution. These are open source and available on [GitHub](https://azure.github.io/Industrial-IoT/).

## Edge Workloads

The ability to run custom or third-party modules at the edge is important. 

- If you want to respond to emergencies as quickly as possible, you can run anomaly detection or Machine Learning module in tight control loops at the edge. 
- If you want to reduce bandwidth costs and avoid transferring terabytes of raw data, you can clean and aggregate the data locally then only send the insights to the cloud for analysis.
- If you want to convert legacy industrial protocols, you can develop a custom module or purchase a third-party module to perform protocol translation. 
- If you want to quickly respond to an event on the factory floor, you can use an edge module to detect that event and another module respond to it. 

Microsoft, and our partners, have made available on the Azure Marketplace a number of edge modules which can be used in your IIoT Analytics Solution. 

Protocol and identity translation are the most common edge workloads used within an IIoT Analytics Solution. In the future, expect to see other workloads such as closed loop control using edge ML models.

## Connecting to Historians

A common pattern when developing an IIoT Analytics Solution is to connect to a Process Historian and stream real time data from the Historian to Azure IoT Hub. How will depend on which protocols are installed and accessible (not blocked by firewalls) on the Historian.

| Protocol Available on Historian | Options |
|----------------------------|---------------------------|
| OPC UA | <p>* Utilize Azure IoT Edge, along with OPC Publisher, OPC Twin and OPC Vault, to send OPC UA data over MQTT to IoT Hub. OPC Twin also has support for OPC UA HDA profile, useful for obtaining historical data.<br>* Utilize a third-party Azure IoT Edge OPC UA module to send OPC UA data over MQTT to IoT Hub.<p> |
| OPC DA | <p>* Use third-party software to convert OPC DA to OPC UA and send OPC UA data to IoT Hub over MQTT. Or use OPC Publisher, OPC Twin and OPC Vault to send OPC UA data over MQTT to IoT Hub. |
| Web Service | <p>* Utilize a custom Azure IoT Edge HTTP module to poll the web service.<br>* Utilize third-party software that supports HTTP to MQTT 3.1.1 or AMQP 1.0.<p> |
| MQTT 3.1.1 (Can publish MQTT messages) | <p>* Connect Historian directly to Azure IoT Hub using MQTT.<br>* Connect Historian to Azure IoT Edge as a leaf device. See Transparent Gateway pattern.<p> |
| Other | <p>* Utilize a custom Azure IoT Edge module.<br>* Utilize third-party software to convert to MQTT 3.1.1 or AMQP 1.0.<p> |

A number of Microsoft partners have developed protocol and identity translation modules or solutions that are available on the [Azure Marketplace](https://azuremarketplace.microsoft.com/).

Some Historian vendors also provide first-class capabilities to send data to Azure.

|Historian|Options|
|--------------|-----------------------|
|OSIsoft PI|[PI Integrator for Azure](https://techsupport.osisoft.com/Products/PI-Integrators/PI-Integrator-for-Microsoft-Azure/Overview)|
|Honeywell|[Uniformance Cloud Historian](https://www.honeywellprocess.com/news-and-events/Pages/pr-01082018-honeywell-debuts-cloud-historian-as-part-of-honeywell-connected-plant.aspx)|

Once real time data streaming has been established between your Historian and Azure IoT Hub, it is important to export your Historian's historical data and import it into your IIoT Analytics Solution. For guidance on how to accomplish this, see Historical Data Ingestion.

## Cloud Gateway

A cloud gateway provides a cloud hub for devices and field gateways to connect securely to the cloud and send data. It also provides device management capabilities. For the cloud gateway, we recommend Azure IoT Hub. IoT Hub is a hosted cloud service that ingests events from devices and IoT Edge gateways. IoT Hub provides secure connectivity, event ingestion, bidirectional communication, and device management. When IoT Hub is combined with the Azure Industrial IoT components, you can control your industrial devices using cloud-based REST APIs.

IoT Hub supports the following [protocols](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-protocols):

- MQTT 3.1.1;
- MQTT over WebSockets,
- AMQP 1.0,
- AMQP over WebSockets; and
- HTTPS.

If the industrial device or system supports any of these protocols, it can send directly to IoT Hub. In most industrial environments this is not permissible due to PCN firewalls and network security policies (ISA 95, ISA 99). In such cases, an Azure IoT Edge field gateway can be installed in a DMZ between the PCN and the Internet.

## Next steps

Continue reading more about this architecture with [Services in an IIoT analysis solution](./iiot-services.md).
