---
title: Get started with Azure IoT solutions
titleSuffix: Azure Reference Architectures
description: Learn basic IoT concepts, how to get started building an Azure IoT solution, and how to optimize an IoT solution for production.
author: mcosner
manager: lizross
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: conceptual
ms.date: 03/14/2022
ms.author: mcosner
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-central
  - azure-iot-hub
---

# Get started with Azure IoT solutions

This guide discusses basic internet of things (IoT) concepts, describes how to get started with Azure IoT, and provides links to other articles about Azure IoT patterns and solutions.

[Azure IoT](https://azure.microsoft.com/overview/iot) is a collection of managed and platform services that connect and control IoT devices. Azure IoT supports a large range of devices, including industrial equipment, microcontrollers, and sensors. IoT devices communicate with cloud IoT and other services, which process device data to monitor and manage the devices.

For example, an industrial motor collects and sends temperature data to the cloud. Data analysis determines whether the motor is performing as expected. This information prioritizes a maintenance schedule for the motor.

## Learn about Azure IoT

You can learn about Azure IoT concepts in detail with a Learning Path that uses an Azure sandbox subscription. The five-hour learning path has eight training modules.

> [!div class="nextstepaction"]
> [Introduction to Azure IoT](/learn/paths/introduction-to-azure-iot)

## Design an IoT architecture

A standard IoT solution architecture consists of five basic elements.

- *Devices* are industrial equipment, sensors, and microcontrollers that connect with the cloud to send and receive data.
- *Provisioning* enables devices to take actions and communicate with the cloud.
- *Processing* analyzes data from devices to gather insights.
- *Business integration* takes actions based on insights from the device data. You can use services like [Power BI](https://powerbi.microsoft.com) to inspect and visualize data, or [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) or [Microsoft Power Automate](https://powerautomate.microsoft.com) to set up automated actions.
- *Security monitoring*. [Microsoft Defender for IoT](https://azure.microsoft.com/services/iot-defender) provides an end-to-end security solution for IoT workloads.

> [!div class="nextstepaction"]
> [Azure IoT reference architecture](../iot.yml)

## PaaS and aPaaS IoT solutions

You can create Azure IoT solutions by using individual platform as a service (PaaS) components, or an application platform as a service (aPaaS), [Azure IoT Central](https://azure.microsoft.com/services/iot-central).

- The PaaS cloud computing model delivers hardware and software tools that are tailored to specific tasks or job functions. The PaaS provides the underlying infrastructure as a service (IaaS), but you're responsible for scaling and configuration.

- An aPaaS provides a cloud environment to build, manage, and deliver applications. The aPaaS handles scaling and most configuration, but still requires developer input to build a finished solution.

Compare IoT Central (aPaaS) and Azure PaaS approaches for building and deploying IoT cloud solutions. The technologies and services you choose depend on your scenario's development, deployment, and management needs.

> [!div class="nextstepaction"]
> [Compare solution approaches](/azure/architecture/example-scenario/iot/iot-central-iot-hub-cheat-sheet)

## Start with Azure IoT Central

[Azure IoT Central](/azure/iot-central/core/overview-iot-central) is Microsoft's aPaaS IoT solution, recommended as a starting point for IoT solutions. IoT Central accelerates IoT solution assembly and operations by preassembling the PaaS services that enterprise level solutions need. The platform has all the necessary capabilities to connect, manage, and operate fleets of devices at scale.

IoT Central provides an out-of-the-box, ready-to-use user interface and API surface area. Iot Central simplifies device connectivity, operations, and management so businesses can spend their time, effort, and budget creating business value with IoT data.

> [!div class="nextstepaction"]
> [Azure IoT Central architecture](/azure/iot-central/core/concepts-architecture)

## IoT architecture patterns and guides

This section lists useful patterns and guides for building IoT solutions.

### Patterns

IoT architecture patterns are reusable building blocks that address key IoT solution areas. Patterns are generic and usable across different industry verticals. For examples of industry-specific IoT solutions, see [Industry specific Azure IoT solutions and scenarios](industrial-iot-hub-page.md).

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
- [Azure IoT Central](/azure/iot-central)
- [Azure IoT Hub](/azure/iot-hub)
- [Azure IoT Hub Device Provisioning Service](/azure/iot-dps)
- [Azure IoT Edge](/azure/iot-edge)
- [Azure Industrial IoT](/azure/industrial-iot)

