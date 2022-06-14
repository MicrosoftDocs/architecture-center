An end-to-end connectivity solution helps securely connect people, assets, workflow, and business processes, which make your organization more resilient. The key aspects around connectivity include:

- Devices
  - PLCs, sensors, equipment, and assembly lines
- Systems
  - Process historian, supervisory control and data acquisition (SCADA), manufacturing execution systems (MES), and industrial control systems/distributed control systems (ICS/DCS)
- Standards and Data Models
  - ISA 95, ISA 99, OPC Data Access (DA), OPC Unified Architecture (UA), and Modbus
- Network and Security
  - Purdue model, firewalls, proxies, network inspection, 5G, and long range WAN (LoRaWAN)
    - X.509 certificates and access policies
- Edge Gateways
  - Software only or a hardware and software solution
  - Modular design, cloud based management plane, and offline support
  - Layered edge processing, analytics, and machine learning
- Cloud Gateways
  - Cloud connectivity, transport protocols, and device management and scale

The following sections include common connectivity patterns for industrial solutions.

> [!NOTE]
> These patterns are for telemetry egress only. No control commands are sent back to the industrial systems or devices. These patterns are also focused on [Connected operations](/azure/architecture/framework/iot/iot-overview#connected-operations) scenarios. [Connected products](/azure/architecture/framework/iot/iot-overview#connected-products) scenarios will be added later.

## OPC UA server and edge gateway

Connect to manufacturing machines by using OPC UA standards and an Azure IoT Edge gateway.

:::image type="content" source="images/edge-opcua.png" alt-text="Diagram that shows how to connect machines by using an OPC UA server and an IoT Edge gateway." lightbox="images/edge-opcua.png":::

- Dataflow
  1. Programmable logic controllers (PLCs) connect to industrial connectivity software or historian software using a switch or internal network connectivity.
  2. The OPC UA module connects to the OPC UA endpoint provided by the industrial connectivity software and sends the data to edgeHub.
  3. The edgeHub sends the data to Azure IoT Hub or Azure IoT Central by using advanced message queuing protocol (AMQP) or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:
  - You've already configured an OPC UA server or can configure it to connect with PLCs.
  - You can install IoT Edge at layer 3 and connect to the PLC via an OPC UA server.

- Considerations
  - [IoT Edge production checklist](/azure/iot-edge/production-checklist?view=iotedge-2018-06)
  - [OPC Publisher module configuration guide](https://github.com/Azure/Industrial-IoT/blob/main/docs/modules/publisher.md)
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - You can install an IoT Edge runtime on a Linux or Windows virtual machine (VM) and dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Deployment samples
  - [Connectivity with industrial assets by using OPC UA and IoT Edge for Linux on Windows (EFLOW)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/1_Connectivity)
  - [Connect OPC UA devices to Azure IoT Central by using custom modules](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway)

## Protocol translation and edge gateway

Connect to manufacturing machines over non-standard protocols by using an IoT Edge gateway.

:::image type="content" source="images/edge-protocoltranslation.png" alt-text="Diagram that shows machines connected by using a custom protocol translation module and an IoT Edge gateway." lightbox="images/edge-protocoltranslation.png":::

- Dataflow
  1. Connect devices that don't support OPC UA via a custom protocol translation module to the edgeHub.
  2. The edgeHub sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:
  - Your devices can't support an OPC UA data model.
  - You can install IoT Edge at layer 3 and connect to your devices.

- Considerations
  - [IoT Edge production checklist](/azure/iot-edge/production-checklist?view=iotedge-2018-06)
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - You can install IoT Edge runtime on a Linux or Windows VM and dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview).
  - See the [IoT Edge module marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules) for partner solutions.
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Deployment sample
  - [Connect modbus devices with an IoT Central application via an IoT Edge Gateway device](https://github.com/iot-for-all/iotc-modbus-iotedge-gateway)

## Cloud connector from industrial connectivity software or historian

Connect to manufacturing machines using a cloud connector component available in industrial connectivity software.

:::image type="content" source="images/historian-cloudconnector.png" alt-text="}Diagram that shows machines connected by using built-in cloud connectors from historian software." lightbox="images/historian-cloudconnector.png":::

- Dataflow
  1. Connect the PLCs to industrial connectivity software or historian software by using a switch or internal network connectivity.
  2. The industrial connectivity software uses AMQP or MQTT to send the data over a built-in cloud connector to IoT Hub or Azure IoT Central.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:
  - Industrial connectivity software or historian software is available and has a built-in cloud connector.
  - You don't require management, processing, and analytics functionality for the use case.
  - The connector can provide the data with same granularity as an edge gateway.

- Considerations
  - Another cost for cloud connectors along with licensing and tag based costing model for historians.
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Deployment Sample
  - [Connect PTC/Kepware's KEPServerEX to IoT Hub and IoT Edge](/samples/azure-samples/iot-hub-how-to-kepware-edge/azure-iot-edge-connect-ptc/)

- Resources
  - [Bring Industrial data into your Azure IoT solution with CloudRail](/shows/internet-of-things-show/bring-industrial-data-into-your-azure-iot-solution-with-cloudrail)

## Connecting to layer 2 and IoT Edge gateways

Connect to manufacturing machines in layer 2 of a Purdue model by using multiple IoT Edge gateways that are connected in a hierarchy.

:::image type="content" source="images/nested-edge.png" alt-text="Diagram that shows machines connected in layer 2 of a Purdue model by using hierarchical edge gateways." lightbox="images/nested-edge.png":::

- Dataflow
  1. Connect PLCs to the layer 2 edge gateway, which is the lower layer edge gateway.
  2. The layer 2 edge gateway sends the data to the layer 3 gateway, which is the parent device. The layer 3 gateway also has a local Docker registry and an API proxy module to support module deployment for the lower layer edge gateways.
  3. The layer 3 edgeHub sends the data to IoT Hub or Azure IoT Central using AMQP or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:

  - Layer 0~1 can only connect with the adjacent layer 2, as per the ISA95 and Purdue models.
  - You can install IoT Edge at layer 2 and connect to layer 0~1.

- Considerations
  - This configuration creates a complex deployment model and certificate configuration for security.
  - [Deploying hierarchy of IoT Edge Devices](/azure/iot-edge/tutorial-nested-iot-edge?view=iotedge-2020-11)
  - [IoT Edge production checklist](/azure/iot-edge/production-checklist?view=iotedge-2018-06)
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Deployment Sample
  - [Nested Edge Devices and Offline Dashboards Sample](https://github.com/Azure-Samples/iot-edge-for-iiot)

## Resilient edge gateway

Provide hardware resiliency for your IoT Edge gateway virtual machines.

:::image type="content" source="images/resilient-edge.png" alt-text="Diagram that shows how to use a pattern that makes edge gateways resilient to hardware failures by using Kubernetes." lightbox="images/resilient-edge.png":::

- Dataflow
  1. Connect PLCs to industrial connectivity software or historian software by using a switch or internal network connectivity.
  2. The industrial connectivity software provides an OPC UA endpoint that you connect to the OPC UA module to the OPC UA endpoint. Then, the OPC UA module sends the data to the edgeHub. The edge runtime runs on a VM that runs inside a kubernetes cluster.
  3. The edgeHub sends the data to IoT Hub or Azure IoT Central using AMQP or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:
  - A Kubernetes infrastructure and skill set is already available.
  - Horizontal scaling and hardware failure resiliency is critical.
  - IoT Edge VM snapshots aren't enough to meet the recovery time objective (RTO) and recovery point objective (RPO) needs. *RTO is the maximum time an application is unavailable after an incident, and RPO is the maximum duration of data loss during a disaster.*

- Considerations
  - This pattern is for hardware resiliency and is agnostic of data models, protocols, and industrial connectivity software.
  - [Kubernetes at the edge compute options](/azure/architecture/operator-guides/aks/choose-kubernetes-edge-compute-option)
  - [IoT Edge production checklist](/azure/iot-edge/production-checklist?view=iotedge-2018-06)
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Deployment Sample
  - [IoT Edge on Kubernetes with KubeVirt](https://github.com/Azure-Samples/IoT-Edge-K8s-KubeVirt-Deployment/)

## Scale to multiple factories and business units

Scale connectivity patterns to multiple factories and business units.

:::image type="content" source="images/scale-factories.png" alt-text="Diagram that shows how to scale machine connectivity patterns to multiple factories." lightbox="images/scale-factories.png":::

- Dataflow
  1. Multiple factories send the data to IoT Hub or Azure IoT Central.
  2. IoT Hub or Azure IoT Central uses routes, consumer groups, and data export to push the data to multiple business units and project specific resource groups.

- Use this pattern when:
  - You need to scale industrial IoT solution patterns across multiple factories.
  - Multiple business units and projects need access to Industrial Internet of Things (IIoT) data.
  - You enable [landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) cloud connectivity.
  - You need granular access control between operational technology (OT) and IT.

- Considerations
  - This pattern is for scaling cloud gateways and services, and for connecting multiple factories. It's agnostic of data models, protocols, and industrial connectivity software.
  - A dedicated subscription for a cloud gateway enables OT and networking teams to better manage cloud egress and connectivity.
  - A device provisioning service can help scale across multiple IoT Hubs and Azure IoT Central. Both of these services can use the device provisioning service underneath to provide an auto-scaling experience.
  - For scenarios where a hierarchy of edge gateways is needed, use IoT Hub directly.
  - You can push IIoT data to each business unit or project specific subscription via routes and consumer groups.
  - IIoT solutions are one of many enterprise solutions, and must integrate well with the overall [cloud operating model](/azure/cloud-adoption-framework/operating-model/compare) and [landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) of your enterprise.
  - [IoT Hub high availability and disaster recovery](/azure/iot-hub/iot-hub-ha-dr)

## Constrained devices and add-on sensors

Connect low power and low compute devices to manufacturing machines as extra sensors.

:::image type="content" source="images/direct-sdk.png" alt-text="Diagram that shows how to connect machines by using a cloud S D K and custom application." lightbox="images/direct-sdk.png":::

- Dataflow
  1. Constrained devices or add-on sensors send data to a custom application. You can use embedded code inside the sensor itself as the custom application.
  2. The custom application sends the data to IoT Hub or Azure IoT Central using AMQP, MQTT, or HTTPS.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

- Use this pattern when:
  - Working with constrained devices or add-on sensors in remote and off-site locations.
  - You don't require management, processing, and analytics functionality of an edge gateway for the use case.
  - You can allow data egress to go outside of the Purdue model.

- Considerations
  - This pattern requires more deployment and management of the custom application for sensor data collection.
  - There's no support for offline or edge analytics scenarios.
  - [Security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json)
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud Gateway options](#cloud-gateway-options).

- Resources
  - [IoT Hub SDKs and Samples](/azure/iot-hub/iot-hub-devguide-sdks)

## Cloud gateway options

Select a cloud gateway for connectivity.

**IoT Hub**

:::image type="content" source="images/cloudgw-iothub.png" alt-text="Diagram that shows how to connect to a cloud gateway by using IoT Hub." lightbox="images/cloudgw-iothub.png":::

- Dataflow
  1. The edge gateway sends data to an IoT Hub by using AMQP or MQTT.
  2. Azure Data Explorer pulls the data from IoT Hub by using streaming ingestion.

**Azure IoT Central**

:::image type="content" source="images/cloudgw-iotcentral.png" alt-text="Diagram that shows how to connect to a cloud gateway by using Azure IoT Central.":::

- Dataflow
  1. The edge gateway sends data to Azure IoT Central by using AMQP or MQTT.
  2. Azure IoT Central exports the data to Azure Data Explorer by using data export.

**Azure Event Hubs**

:::image type="content" source="images/cloudgw-eventhub.png" alt-text="{Diagram that shows how to connect to a cloud gateway by using Event Hubs.}":::

- Dataflow
  1. A custom application sends event hub messages using a language specific SDK.
  2. Azure Data Explorer pulls the data from Event Hubs by using streaming ingestion.

- Pattern use
  - Use IoT Hub or Azure IoT Central when you require device and edge management, two way communication, and messaging.
  - Use Azure IoT Central if you need a built-in dashboard and rules engine for alerts.
  - Use Event Hubs when you have cost constraints and only require messaging.

- Considerations
  - [IoT Hub vs. Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs)
  - [IoT Hub vs. Azure IoT Central](/azure/iot-fundamentals/iot-solution-apaas-paas#comparing-approaches)
  - [RPO and RTO options for IoT Hub](/azure/iot-hub/iot-hub-ha-dr#choose-the-right-hadr-option)
  - [HA/DR for IoT Central](/azure/iot-central/core/concepts-faq-scalability-availability) and [limitations](/azure/iot-central/core/concepts-faq-scalability-availability#limitations) around IoT Edge devices.
  - [Availability](/azure/event-hubs/event-hubs-availability-and-consistency?tabs=dotnet) and [Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr?tabs=portal) for Event Hubs.

- Deployment Samples
  - [Connect OPC UA devices with IoT Central](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway)
  - [Industrial IoT patterns with IoT Central](/azure/iot-central/core/concepts-iiot-architecture)
  - [Streaming at Scale with Event Hubs and Data Explorer](https://github.com/Azure-Samples/streaming-at-scale/tree/main/eventhubs-dataexplorer)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager

Other contributor:

- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

## Next steps

- Try the deployment sample for [Connectivity with Industrial Assets using OPC UA and Edge for Linux on Windows (EFLOW)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/1_Connectivity).

- Try the deployment sample for [Connecting OPC UA devices to IoT Central using custom modules](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway).

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.md)

- [Industrial IoT visibility patterns](./iiot-visibility-patterns.md)

- [Industrial IoT transparency patterns](./iiot-transparency-patterns.md)

- [Industrial IoT prediction patterns](./iiot-prediction-patterns.md)

- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)

- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
