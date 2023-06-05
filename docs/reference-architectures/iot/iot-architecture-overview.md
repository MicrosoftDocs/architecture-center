---
title: Get started with Azure IoT solutions
titleSuffix: Azure Reference Architectures
description: Learn basic IoT concepts, how to get started building an Azure IoT solution, and how to optimize an IoT solution for production.
author: falloutxay
manager: lizross
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: reference-architecture
ms.date: 11/21/2022
ms.author: ansyeo
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-hub
---

# Internet of things (IoT) architecture design

This guide discusses basic internet of things (IoT) concepts, describes how to get started with Azure IoT, and provides links to articles about Azure IoT patterns and solutions.

[Azure IoT](https://azure.microsoft.com/overview/iot) is a collection of managed and platform services that connect and control IoT devices. Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, and sensors. IoT devices communicate with cloud IoT and other services, which process device data to monitor and manage the devices.

For example, an industrial motor collects and sends temperature data to the cloud. Data analysis determines whether the motor is performing as expected. This information prioritizes a maintenance schedule for the motor.

## Learn about Azure IoT

You can learn about Azure IoT concepts in detail with a Learning Path that uses an Azure sandbox subscription. The five-hour learning path has eight training modules.

> [!div class="nextstepaction"]
> [Introduction to Azure IoT](/training/paths/introduction-to-azure-iot)

### Understand IoT solution architecture

A standard IoT solution architecture consists of five basic elements.

- *Devices* are industrial equipment, sensors, and microcontrollers that connect with the cloud to send and receive data.
- *Provisioning* enables devices to take actions and communicate with the cloud.
- *Processing* analyzes data from devices to gather insights.
- *Business integration* takes actions based on insights from device data. You can use services like [Power BI](https://powerbi.microsoft.com) to inspect and visualize data, or [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) or [Microsoft Power Automate](https://powerautomate.microsoft.com) to set up automated actions.
- *Security monitoring*. [Microsoft Defender for IoT](https://azure.microsoft.com/services/iot-defender) provides an end-to-end security solution for IoT workloads.

> [!div class="nextstepaction"]
> [Azure IoT reference architecture](../iot.yml)

## IoT architecture patterns and guides

This section lists useful patterns and guides for building IoT solutions. For industry-specific example solutions, see [Industry specific Azure IoT reference architectures](industry-iot-hub-page.md).

### Patterns

IoT architecture patterns are reusable building blocks that address key IoT solution areas. Patterns are generic and usable across different industry verticals. For examples of industry-specific IoT solutions, see [Industry specific Azure IoT solutions and scenarios](industry-iot-hub-page.md).

- [Real-time IoT updates](../../example-scenario/iot/real-time-iot-updates-cloud-apps.yml). Instead of traditional polling requests, clients can receive updates from devices in real time. Azure SignalR service sends real-time IoT data to clients like web pages and mobile apps.

- [Scale IoT solutions with deployment stamps](../../example-scenario/iot/application-stamps.yml). Stamps are discrete units of solution components that optimally support a defined number of devices. Deployment stamping supports scaling up the number of connected IoT devices by replicating stamps.

- [Azure IoT client SDK support for third-party token servers](../../guide/iot/azure-iot-client-sdk-support.yml). Azure IoT Hub supports shared access signature (SAS) token authentication in client SDKs. Learn what to do in each SDK to achieve third-party token server authentication.

- [Efficient Docker image deployment](../../example-scenario/iot/efficient-docker-image-deployment.yml). Edge devices are typically provisioned by deploying software container images. Use a reliable and resilient deployment capability for situations that have limited, intermittent, or low bandwidth.

- [IoT analytics with Azure Data Explorer](../../solution-ideas/articles/iot-azure-data-explorer.yml). Use Azure Data Explorer for near real-time IoT telemetry analytics on fast-flowing, high-volume streaming data from a wide variety of IoT devices.

- [IoT Edge data storage and processing](../../solution-ideas/articles/data-storage-edge.yml). Some IoT solutions need on-premises edge networks to provide computing and data collecting. See how to use edge devices in an IoT implementation to provide quick responses, high availability, and high bandwidth.

### Guides

IoT architectural guides provide insights into IoT concepts, architectures, and workstreams.

- [IoT solutions conceptual overview](../../example-scenario/iot/introduction-to-solutions.yml). This series provides an overview of the functional interactions between events, insights, and actions in Azure IoT solutions.

- [Computer vision with Azure IoT Edge](../../guide/iot-edge-vision/index.md). This series describes an end-to-end computer vision workload. Azure IoT Edge, Azure Machine Learning, Azure Storage, Azure App Services, and Power BI combine to deliver quality assurance and safety solutions.

- [Move an IoT solution from test to production](../../example-scenario/iot/iot-move-to-production.yml). Learn best practices and what to avoid when moving an IoT solution from a test environment to a production environment.

- [Azure industrial IoT analytics guidance](../../guide/iiot-guidance/iiot-architecture.yml). Industrial IoT (IIoT) is the application of IoT to the manufacturing industry. This article series describes an Azure IIoT analytics solution that uses PaaS components.

## Next steps

Azure IoT documentation:

- [Azure IoT](/azure/iot-fundamentals)
- [Azure IoT Hub](/azure/iot-hub)
- [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
- [Azure IoT Edge](/azure/iot-edge)
- [Azure Industrial IoT](/azure/industrial-iot)
