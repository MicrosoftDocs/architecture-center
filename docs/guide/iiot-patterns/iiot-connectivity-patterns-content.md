An end-to-end connectivity solution makes your organization more resilient by helping to securely connect people, assets, workflow, and business processes. The key aspects around connectivity include:

- Devices like PLCs, sensors, equipment, and assembly lines.
- Systems like process historian, supervisory control and data acquisition (SCADA), manufacturing execution systems (MES), and industrial control systems/distributed control systems (ICS/DCS).
- Standards and data models like ISA 95, ISA 99, OPC Data Access (DA), OPC Unified Architecture (UA), and Modbus.
- Network and security like:
  - Purdue model, firewalls, proxies, network inspection, 5G, and long-range WAN (LoRaWAN®).
  - X.509 certificates and access policies.
- Edge gateways like:
  - Software only or a hardware and software solution.
  - Modular design, cloud based management plane, and offline support.
  - Layered edge processing, analytics, and machine learning.
- Cloud gateways like cloud connectivity, transport protocols, and device management and scale.

The following sections include common connectivity patterns for industrial solutions.

> [!NOTE]
> These patterns are for telemetry egress only. No control commands are sent back to the industrial systems or devices. These patterns are also focused on [Connected operations](/azure/architecture/framework/iot/iot-overview#connected-operations) scenarios. [Connected products](/azure/architecture/framework/iot/iot-overview#connected-products) scenarios will be added later.

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) for the following patterns.*

*LoRaWAN® is a registered trademark of the LoRa Alliance® in the United States and/or other countries. No endorsement by [LoRa Alliance®](https://lora-alliance.org) is implied by the use of these marks.*

## OPC UA server and an IoT Edge gateway

Connect to manufacturing machines by using OPC UA standards and an Azure IoT Edge gateway.

:::image type="content" source="images/edge-opcua.png" alt-text="Diagram that shows how to connect machines by using an OPC UA server and an IoT Edge gateway." lightbox="images/edge-opcua.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. Programmable logic controllers (PLCs) are connected to industrial connectivity software or historian software by using a switch or internal network connectivity.
  2. The OPC UA module connects to the OPC UA endpoint that's provided by the industrial connectivity software and sends the data to the edgeHub module.
  3. The edgeHub module sends the data to Azure IoT Hub or Azure IoT Central by using advanced message queuing protocol (AMQP) or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - You've already configured an OPC UA server or can configure it to connect with PLCs.
  - You can install IoT Edge at layer 3 and connect to the PLC via an OPC UA server.

### Considerations

  - To deploy an IoT Edge solution, see [Prepare to deploy your IoT Edge solution in production](/azure/iot-edge/production-checklist?view=iotedge-2018-06).
  - To configure your OPC publisher, see the [OPC publisher module configuration guide](https://github.com/Azure/Industrial-IoT/tree/main/docs/opc-publisher#configuring-opc-publisher).
  - For security considerations, see [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - You can install an IoT Edge runtime on a Linux or Windows virtual machine (VM) and dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Deploy this scenario

- Deployment samples:
  - [Connectivity with industrial assets by using OPC UA and IoT Edge for Linux on Windows (EFLOW)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/1_Connectivity)
  - [Connect OPC UA devices to Azure IoT Central by using custom modules](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway)

## Protocol translation and an IoT Edge gateway

Connect to manufacturing machines over non-standard protocols by using an IoT Edge gateway.

:::image type="content" source="images/edge-protocol-translation.png" alt-text="Diagram that shows machines connected by using a custom protocol translation module and an IoT Edge gateway." lightbox="images/edge-protocol-translation.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. Devices that don't support OPC UA are connected via a custom protocol translation module to the edgeHub module.
  2. The edgeHub module sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - Your devices can't support an OPC UA data model.
  - You can install IoT Edge at layer 3 and connect to your devices.

### Considerations

  - To deploy an IoT Edge solution, see [Prepare to deploy your IoT Edge solution in production](/azure/iot-edge/production-checklist?view=iotedge-2018-06).
  - For security considerations, see [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - You can install IoT Edge runtime on a Linux or Windows VM and dedicated hardware like [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/#overview).
  - For partner solutions, eee the [IoT Edge module marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Deploy this scenario

- Deployment sample:
  - [Connect modbus devices with an Azure IoT Central application via an IoT Edge gateway device](https://github.com/iot-for-all/iotc-modbus-iotedge-gateway)

## Cloud connector from industrial connectivity software or a historian

Connect to manufacturing machines by using a cloud connector component that's available in industrial connectivity software.

:::image type="content" source="images/historian-cloud-connector.png" alt-text="Diagram that shows machines connected by using built-in cloud connectors from historian software." lightbox="images/historian-cloud-connector.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. PLCs are connected to industrial connectivity software or historian software by using a switch or internal network connectivity.
  2. The industrial connectivity software uses AMQP or MQTT to send the data over a built-in cloud connector to IoT Hub or Azure IoT Central.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - Industrial connectivity software or historian software is available and has a built-in cloud connector.
  - You don't require management, processing, and analytics functionality for the use case.
  - The connector can provide the data with the same granularity as an edge gateway.

### Considerations

  - This method adds another cost for cloud connectors along with licensing and tag-based costing model for historians.
  - For security considerations, see [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Deploy this scenario

- Deployment sample:
  - [How to connect Kepware KEPServerEX to IoT Edge](/samples/azure-samples/iot-hub-how-to-kepware-edge/azure-iot-edge-connect-ptc)

### Resources

  - [Bring Industrial data into your Azure IoT solution with CloudRail](/shows/internet-of-things-show/bring-industrial-data-into-your-azure-iot-solution-with-cloudrail)

## Connect to layer 2 and IoT Edge gateways

Connect to manufacturing machines in layer 2 of a Purdue model by using multiple IoT Edge gateways that are connected in a hierarchy.

:::image type="content" source="images/nested-edge.png" alt-text="Diagram that shows machines connected in layer 2 of a Purdue model by using hierarchical edge gateways." lightbox="images/nested-edge.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. PLCs are connected to the layer 2 edge gateway, which is the lower layer edge gateway.
  2. The layer 2 edge gateway sends the data to the layer 3 gateway, which is the parent device. The layer 3 gateway also has a local Docker registry and an API proxy module to support module deployment for the lower layer edge gateways.
  3. The layer 3 edgeHub module sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - Layer 0~1 can only connect with the adjacent layer 2, in accordance with the ISA95 and Purdue models.
  - You can install IoT Edge at layer 2 and connect to layer 0~1.

### Considerations

  - This configuration creates a complex deployment model and certificate configuration for security.
  - To create an IoT Edge device hierarchy, see [Tutorial: Create a hierarchy of IoT Edge devices](/azure/iot-edge/tutorial-nested-iot-edge?view=iotedge-2020-11).
  - To deploy an IoT Edge solution, see [Prepare to deploy your IoT Edge solution in production](/azure/iot-edge/production-checklist?view=iotedge-2018-06).
  - For security considerations, see [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Deploy this scenario

- Deployment sample:
  - [Nested edge devices and offline dashboards sample](https://github.com/Azure-Samples/iot-edge-for-iiot)

## Resilient edge gateway

Provide hardware resiliency for your IoT Edge gateway VMs.

:::image type="content" source="images/resilient-edge.png" alt-text="Diagram that shows how to use a pattern that makes edge gateways resilient to hardware failures by using Kubernetes." lightbox="images/resilient-edge.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. PLCs are connected to industrial connectivity software or historian software by using a switch or internal network connectivity.
  2. The industrial connectivity software provides an OPC UA endpoint that you connect to the OPC UA module and the OPC UA endpoint. Then, the OPC UA module sends the data to the edgeHub module. The edge runtime runs on a VM that runs inside a Kubernetes cluster.
  3. The edgeHub module sends the data to IoT Hub or Azure IoT Central by using AMQP or MQTT.
  4. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - A Kubernetes infrastructure and skill set is already available.
  - Horizontal scaling and hardware failure resiliency is critical.
  - IoT Edge VM snapshots aren't enough to meet the recovery time objective (RTO) and recovery point objective (RPO) needs.

    > [!NOTE]
    > RTO is the maximum time an application is unavailable after an incident, and RPO is the maximum duration of data loss during a disaster.

### Considerations

  - This pattern is for hardware resiliency and is agnostic of data models, protocols, and industrial connectivity software.
  - For Kubernetes information, see [Choose a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md).
  - To deploy an IoT Edge solution, see [Prepare to deploy your IoT Edge solution in production](/azure/iot-edge/production-checklist?view=iotedge-2018-06).
  - For security considerations, see [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Deploy this scenario

- Deployment sample:
  - [IoT Edge on Kubernetes with KubeVirt](https://github.com/Azure-Samples/IoT-Edge-K8s-KubeVirt-Deployment)

## Scale to multiple factories and business units

Scale connectivity patterns to multiple factories and business units.

:::image type="content" source="images/scale-factories.png" alt-text="Diagram that shows how to scale machine connectivity patterns to multiple factories." lightbox="images/scale-factories.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. Multiple factories send the data to IoT Hub or Azure IoT Central.
  2. IoT Hub or Azure IoT Central uses routes, consumer groups, and data export to push the data to multiple business units and project specific resource groups.

### Potential use cases

- Use this pattern when:
  - You need to scale industrial IoT solution patterns across multiple factories.
  - Multiple business units and projects need access to Industrial Internet of Things (IIoT) data.
  - You enable [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) cloud connectivity.
  - You need granular access control between operational technology (OT) and IT.

### Considerations

  - This pattern is for scaling cloud gateways and services, and for connecting multiple factories. It's agnostic of data models, protocols, and industrial connectivity software.
  - A dedicated subscription for a cloud gateway enables OT and networking teams to better manage cloud egress and connectivity.
  - A device provisioning service can help scale across multiple IoT Hubs and Azure IoT Central. Both of these services can use the underlying device provisioning service to provide an auto-scaling experience.
  - For scenarios where a hierarchy of edge gateways is needed, use IoT Hub directly.
  - You can push IIoT data to each business unit or project-specific subscription via routes and consumer groups.
  - IIoT solutions are one of many enterprise solutions, and must integrate well with the overall [cloud operating model](/azure/cloud-adoption-framework/operating-model/compare) and [landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) of your enterprise.
  - [IoT Hub high availability and disaster recovery](/azure/iot-hub/iot-hub-ha-dr)

## Constrained devices and add-on sensors

Connect low-power and low-compute devices to manufacturing machines as extra sensors.

:::image type="content" source="images/direct-sdk.png" alt-text="Diagram that shows how to connect machines by using a cloud S D K and custom application." lightbox="images/direct-sdk.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

### Dataflow

  1. Constrained devices or add-on sensors send data to a custom application. You can use embedded code inside the sensor itself as the custom application.
  2. The custom application sends the data to IoT Hub or Azure IoT Central by using AMQP, MQTT, or HTTPS.
  3. IoT Hub or Azure IoT Central uses data connection or data export to send data to Azure Data Explorer.

### Potential use cases

- Use this pattern when:
  - You work with constrained devices or add-on sensors in remote and off-site locations.
  - You don't require management, processing, and analytics functionality of an edge gateway for the use case.
  - You can allow data egress to go outside of the Purdue model.

### Considerations

  - This pattern requires significant deployment and management of the custom application for sensor data collection.
  - There's no support for offline or edge analytics scenarios.
  - [Azure security baseline for IoT Hub](/security/benchmark/azure/baselines/iot-hub-security-baseline?toc=/azure/iot-hub/TOC.json).
  - To learn when to use IoT Hub instead of Azure IoT Central, see the [Cloud gateway options](#cloud-gateway-options).

### Resources

  - [IoT Hub SDKs and samples](/azure/iot-hub/iot-hub-devguide-sdks)

## Cloud gateway options

Select a cloud gateway for connectivity.

### IoT Hub

:::image type="content" source="images/cloud-gateway-iot-hub.png" alt-text="Diagram that shows how to connect to a cloud gateway by using IoT Hub." lightbox="images/cloud-gateway-iot-hub.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

#### Dataflow

  1. The edge gateway sends data to an IoT Hub by using AMQP or MQTT.
  2. Azure Data Explorer pulls the data from IoT Hub by using streaming ingestion.

### Azure IoT Central

:::image type="content" source="images/cloud-gateway-azure-iot-central.png" alt-text="Diagram that shows how to connect to a cloud gateway by using Azure IoT Central." lightbox="images/cloud-gateway-azure-iot-central.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

#### Dataflow

  1. The edge gateway sends data to Azure IoT Central by using AMQP or MQTT.
  2. Azure IoT Central exports the data to Azure Data Explorer by using data export.

### Azure Event Hubs

:::image type="content" source="images/cloud-gateway-azure-event-hubs.png" alt-text="Diagram that shows how to connect to a cloud gateway by using Event Hubs." lightbox="images/cloud-gateway-azure-event-hubs.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/iiot-connectivity-patterns.pptx) of this pattern.*

#### Dataflow

  1. A custom application sends event hub messages by using a language-specific SDK.
  2. Azure Data Explorer pulls the data from Event Hubs by using streaming ingestion.

#### Potential use cases

- Use this pattern when:
  - Use IoT Hub or Azure IoT Central when you require device and edge management, two way communication, and messaging.
  - Use Azure IoT Central if you need a built-in dashboard and rules engine for alerts.
  - Use Event Hubs when you have cost constraints and only require messaging.

#### Considerations

  - [Connecting IoT Devices to Azure: IoT Hub and Event Hubs](/azure/iot-hub/iot-hub-compare-event-hubs)
  - [IoT Hub vs. Azure IoT Central](/azure/iot-fundamentals/iot-solution-apaas-paas#comparing-approaches)
  - [RPO and RTO options for IoT Hub](/azure/iot-hub/iot-hub-ha-dr#choose-the-right-hadr-option)
  - Learn about [HA/DR for Azure IoT Central](/azure/iot-central/core/concepts-faq-scalability-availability) and [limitations](/azure/iot-central/core/concepts-faq-scalability-availability#limitations) around IoT Edge devices.
  - Learn about [availability](/azure/event-hubs/event-hubs-availability-and-consistency?tabs=dotnet) and [Geo-disaster recovery](/azure/event-hubs/event-hubs-geo-dr?tabs=portal) for Event Hubs.

#### Deploy this scenario

- Deployment samples:
  - [Connect OPC UA devices with Azure IoT Central](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway)
  - [Industrial IoT (IIoT) architecture patterns with Azure IoT Central](/azure/iot-central/core/concepts-iiot-architecture)
  - [Streaming at scale with Event Hubs and Azure Data Explorer](https://github.com/Azure-Samples/streaming-at-scale/tree/main/eventhubs-dataexplorer)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jomit Vaghela](https://www.linkedin.com/in/jomit) | Principal Program Manager

Other contributor:

- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Try the deployment sample for [Connectivity with Industrial Assets using OPC UA and Edge for Linux on Windows (EFLOW)](https://github.com/Azure-Samples/industrial-iot-patterns/tree/main/1_Connectivity).
- Try the deployment sample for [Connecting OPC UA devices to IoT Central using custom modules](https://github.com/iot-for-all/iotc-opcua-iotedge-gateway).

## Related resources

- [Industrial IoT patterns overview](./iiot-patterns-overview.yml)
- [Industrial IoT visibility patterns](./iiot-visibility-patterns.yml)
- [Industrial IoT transparency patterns](./iiot-transparency-patterns.yml)
- [Industrial IoT prediction patterns](./iiot-prediction-patterns.yml)
- [Solutions for the manufacturing industry](/azure/architecture/industries/manufacturing)
- [IoT Well-Architected Framework](/azure/architecture/framework/iot/iot-overview)
