---
title: Considerations in an IIoT analytics solution
titleSuffix: Azure Application Architecture Guide
description: Read about architectural considerations in an IIoT analytics solution. View discussions about performance, availability, and networking.
author: khilscher
ms.author: kehilsch
ms.date: 12/13/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
products:
  - azure-iot-edge
categories:
  - iot
ms.custom:
  - guide
---

# Architectural considerations in an IIoT analytics solution

The [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index) describes some key tenets of a good architectural design. Keeping in line with these tenets, this article describes the considerations in the reference [Azure Industrial IoT analytics solution](./iiot-architecture.yml) that improve its performance and resiliency.

## Performance considerations

### Azure PaaS services

All Azure PaaS services have an ability to scale up and/or out. Some services will do this automatically (for example, IoT Hub, Azure Functions in a Consumption Plan) while others can be scaled manually.

As you test your IIoT analytics solution, we recommend that you do the following:

- Understand how each service scales (and what the units of scale are).
- Collect performance metrics and establish baselines.
- Set up alerts when performance metrics exceed baselines.

All Azure PaaS services have a metrics blade that allows you to view service metrics, and configure conditions and alerts, which are collected and displayed in [Azure Monitor](/azure/azure-monitor/overview). We recommend enabling these features to ensure your solution performs as expected.

### IoT Edge

Azure IoT Edge gateway performance is impacted by the following:

- The number of edge modules running and their performance requirements
- The number of messages processed by modules and EdgeHub
- Edge modules requiring GPU processing
- Offline buffering of messages
- The gateway hardware
- The gateway operating system

We recommend real world testing and/or testing with simulated telemetry to understand the field gateway hardware requirements for Azure IoT Edge. Conduct your initial testing using virtual machine where CPU, RAM, disk can be easily adjusted. Once approximate hardware requirements are known, get your field gateway hardware and conduct your testing again using actual hardware.

You should also test to ensure the following:

- No messages are being lost between source (for example, historian) and destination (for example, Time Series Insights).
- Acceptable message latency exists between the source and the destination.
- Source timestamps are preserved.
- Data accuracy is maintained, especially when performing data transformations.

## Availability considerations

### IoT Edge

A single Azure IoT Edge field gateway can be a single point of failure between your SCADA, MES, or historian and Azure IoT Hub. A failure can cause gaps in data in your IIoT analytics solution. To prevent this, IoT Edge can integrate with your on-premise Kubernetes environment, using it as a resilient, highly available infrastructure layer. For more information, see [How to install IoT Edge on Kubernetes (Preview)](/azure/iot-edge/how-to-install-iot-edge-kubernetes).

## Network considerations

### IoT Edge and firewalls

To maintain compliance with standards such as ISA 95 and ISA 99, industrial equipment is often installed in a closed Process Control Network (PCN), behind firewalls, with no direct access to the Internet (see [Purdue networking model](https://en.wikipedia.org/wiki/Purdue_Enterprise_Reference_Architecture)).

There are three options to connect to equipment installed in a PCN:

1. Connect to a higher-level system, such as a historian, located outside of the PCN.

1. Deploy an Azure IoT Edge device or virtual machine in a DMZ between the PCN and the internet.
    1. The firewall between the DMZ and the PCN will need to allow inbound connections from the DMZ to the appropriate system or device in the PCN.
    1. There may be no internal DNS setup to resolve PCN names to IP addresses.

1. Deploy an Azure IoT Edge device or virtual machine in the PCN and configure IoT Edge to communicate with the Internet through a Proxy server.
    1. Additional IoT Edge setup and configuration are required. See [Configure an IoT Edge device to communicate through a proxy server](/azure/iot-edge/how-to-configure-proxy-support).
    1. The Proxy server may introduce a single point of failure and/or a performance bottleneck.
    1. There may be no DNS setup in the PCN to resolve external names to IP addresses.

Azure IoT Edge will also require:

- access to container registries, such as Docker Hub or Azure Container Registry, to download modules over HTTPS,
- access to DNS to resolve external FQDNs, and
- ability to communicate with Azure IoT Hub using MQTT, MQTT over WebSockets, AMQP, or AMQP over WebSockets.

For additional security, industrial firewalls can be configured to only allow traffic between IoT Edge and IoT Hub using [Service Tags](/azure/virtual-network/service-tags-overview#service-tags-on-premises). IP address prefixes of IoT Hub public endpoints are published periodically under the *AzureIoTHub* service tag. Firewall administrators can programmatically retrieve the current list of service tags, together with IP address range detail, and update their firewall configuration.

## Next steps

- For a more detailed discussion of the recommended architecture and implementation choices, download and read the [Microsoft Azure IoT Reference Architecture pdf](https://aka.ms/iotrefarchitecture).

- [Azure Industrial IoT components, tutorials, and source code](https://azure.github.io/Industrial-IoT/).

- For detailed documentation of the various Azure IoT services, see [Azure IoT Fundamentals](/azure/iot-fundamentals/).
