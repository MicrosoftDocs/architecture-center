---
title: Considerations for an Azure industrial IIoT (IIoT) analytics solution
titleSuffix: Azure Application Architecture Guide
description: Read about architectural considerations in an IIoT analytics solution. View discussions about performance, availability, and networking.
author: khilscher
ms.author: kehilsch
ms.date: 04/27/2022
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

# Considerations in an Azure IIoT analytics solution

This article describes considerations for the [Azure Industrial IoT (IIoT) analytics solution](iiot-architecture.yml) in terms of the [Microsoft Azure Well-Architected Framework](/azure/architecture/framework/index). The framework describes key architectural design tenets that relate to the Azure IIoT analytics solution.

## Performance efficiency

All Azure platform-as-a-service (PaaS) components have an interface to view service metrics and configure conditions and alerts. [Azure Monitor](/azure/azure-monitor/overview) collects and displays metrics, conditions, and alerts in the Azure portal. Enable these features to ensure that your solution performs as you expect.

As you test your IIoT analytics solution, collect performance metrics and establish baselines. Set up alerts when performance metrics exceed baselines.

### IoT Edge gateway performance

The following considerations affect Azure IoT Edge gateway performance:

- The number of edge modules running, and their performance requirements
- The number of messages the edge hub and other modules process
- The number of edge modules that require graphics processing units (GPUs)
- The amount of offline message buffering
- Gateway hardware and operating system

Test with real world or simulated telemetry to understand IoT Edge field gateway hardware requirements. Test initially on virtual machines (VMs), where you can easily adjust CPU, RAM, and disk. Once you know the approximate hardware requirements, get your field gateway hardware, and do further testing with the actual hardware.

Run tests to ensure that the gateway:

- Doesn't lose messages between the source, such as a historian, and the destination, such as Azure Data Explorer.
- Has acceptable message latency between the source and the destination.
- Preserves source timestamps.
- Maintains data accuracy, especially during data transformations.

### Scalability considerations

All Azure PaaS services have the ability to scale up and/or out. Some services scale automatically, such as Azure IoT Hub, or Azure Functions in a Consumption Plan. You can scale other services manually.

When you design your IIoT analytics solution, make sure you understand how each service scales, including the units of scale.

## Reliability

IoT Edge devices can process some data on the device itself or on a field gateway. IoT Edge devices also provide [store and forward](https://wikipedia.org/wiki/Store_and_forward) capabilities for operation in offline or intermittent network conditions.

An IoT Edge field gateway can be a single point of failure between a SCADA, MES, or historian and Azure IoT Hub. A failure can cause gaps in your IIoT analytics data. To prevent data loss, IoT Edge can integrate with an on-premise Kubernetes environment, using it as a resilient, highly available infrastructure layer. For more information, see [How to install IoT Edge on Kubernetes (Preview)](/azure/iot-edge/how-to-install-iot-edge-kubernetes).

## Security

To comply with standards such as ISA 95 and ISA 99, industrial equipment is often in a closed Process Control Network (PCN) behind firewalls. The PCN has no direct access to the internet.

There are three options to connect to equipment installed in a PCN:

- Connect to a higher-level system, such as a historian, located outside of the PCN.

- [Deploy an IoT Edge device or VM in a DMZ](../../reference-architectures/dmz/secure-vnet-dmz.yml) between the PCN and the internet.

  - The firewall between the DMZ and the PCN must allow inbound connections from the DMZ to the appropriate system or device in the PCN.
  - There might be no internal DNS setup to resolve PCN names to IP addresses.

- Deploy an IoT Edge device or VM in the PCN and [configure IoT Edge to communicate with the internet through a proxy server](/azure/iot-edge/how-to-configure-proxy-support).

  - This option requires more IoT Edge setup and configuration.
  - The proxy server could introduce a single point of failure or a performance bottleneck.
  - There might be no DNS setup in the PCN to resolve external names to IP addresses.

IoT Edge also requires:

- Access to container registries, such as Docker Hub or Azure Container Registry, to download modules over HTTPS.
- Access to DNS to resolve external FQDNs.
- Ability to communicate with Azure IoT Hub by using MQTT, MQTT over WebSockets, AMQP, or AMQP over WebSockets.

For more security, industrial firewalls can use [Service Tags](/azure/virtual-network/service-tags-overview#service-tags-on-premises) to restrict traffic between IoT Edge and IoT Hub. IP address prefixes of IoT Hub public endpoints publish periodically under the *AzureIoTHub* service tag. Firewall administrators can retrieve the current service tag list, with IP address ranges, and update firewalls to accept only those tags.

## Next steps

- [Azure IoT documentation](/azure/iot-fundamentals)
- [Microsoft Azure IoT Reference Architecture (PDF)](https://aka.ms/iotrefarchitecture)
- [Azure Industrial IoT components, tutorials, and source code](https://azure.github.io/Industrial-IoT)
- [Understand IoT Edge automatic deployments for single devices or at scale](/azure/iot-edge/module-deployment-monitoring)

