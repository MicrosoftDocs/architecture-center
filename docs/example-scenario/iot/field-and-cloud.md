---
title: Field and cloud edge gateways
titleSuffix: Azure Example Scenarios
description: Learn about field or edge, and cloud or protocol gateways, and how they fit into the device, platform and application topology for IoT solutions.
author: wamachine
ms.date: 08/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Field and cloud Edge Gateways

Internet-of-things (IoT) devices can connect to the IoT platform directly, or they can be connected to *edge gateways* that implement intelligent capabilities outside the application. *IoT edge gateways* enable functionality like:
- Aggregating or filtering device events before they're sent to the IoT platform
- Localized decision-making
- [Protocol and identity translation](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway) on behalf of devices

There are two types of edge gateways: *field* and *cloud*.

![A diagram illustrating the flow of events, commands, and protocols as they are routed through a field or cloud edge gateway to the Azure IoT Platform.](media/field-edge-gateways.png) 

Field or [IoT Edge](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway) gateways are located close to devices on-premises, and extend cloud capabilities into devices. IoT Edge devices act as communication enablers, local device control systems, and data processors for an [IoT Hub]() in the cloud.

IoT Edge devices are specialized on-premises devices that connect to the IoT platform. IoT Edge devices can run cloud workflows on-premises by using [Edge modules](https://docs.microsoft.com/azure/iot-edge/iot-edge-modules), and can communicate with devices even in offline scenarios.

Cloud or [protocol gateways](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) extend device capabilities into the cloud by enabling communication between devices and the IoT platform. The cloud gateway hosts device instances. Cloud gateways can do protocol and identity translation to and from IoT Hub, and can execute additional logic on behalf of devices.
