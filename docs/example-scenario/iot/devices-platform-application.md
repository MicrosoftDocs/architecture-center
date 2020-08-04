---
title: Devices, IoT Platform, and Application
titleSuffix: Azure Example Scenarios
description: Understand the architecture of IoT solutions, and the topological relationship between devices, the Azure IoT platform, and applications.
author: wamachine
ms.date: 05/05/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# IoT solution architecture

Topologically, Azure IoT solutions are a collection of assets and components divided across *devices*, the *IoT platform*, and *applications*. [Events, insights, and actions](introduction-to-solutions.md) are data flow and processing pipelines that occur across these parts.

![A diagram showing the relationship between devices, the Azure IoT Platform, and an application](media/devices-platform-application.png)

## Devices, IoT platform, and applications

*Devices* are the physical or virtual things that connect to IoT applications, send events, and receive commands. The terms *thing* and *device* both mean a connected physical device in an IoT solution. 

An IoT device has one or more of the following characteristics:
- Possesses a unique *identity* that distinguishes it within the solution.
- Has *properties*, or a *state*, that applications can access.
- Sends *events* to the IoT platform for applications to act on.
- Receives *commands* from applications to execute.

The *IoT platform* is the collection of services that allow devices and applications to connect and communicate with each other. The IoT platform should at least:
- Broker secure *connectivity*, *authentication*, and *communication* between devices and trusted applications.
- Generate *contextual insights* on incoming events to determine the routing of events to endpoints.

*Applications* are the collection of scenario-specific services and components unique to a given IoT solution. IoT applications typically have:
- A mix of Azure or other services for compute, storage, and event endpoints, combined with unique application business logic.
- *Event* workflows to receive and process incoming device events.
- *Action* workflows to send commands to devices or other processes.

## Field and cloud edge gateways

IoT devices can connect to the IoT platform directly, or can connect to *edge gateways* that implement intelligent capabilities. *IoT edge gateways* enable functionality like:
- Aggregating or filtering device events before they're sent to the IoT platform
- Localized decision-making
- [Protocol and identity translation](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway) on behalf of devices

There are two types of edge gateways, *field* or [IoT Edge](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway), and *cloud* or [protocol](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) gateways.

![A diagram illustrating the flow of events, commands, and protocols as they are routed through a field or cloud edge gateway to the Azure IoT Platform.](media/field-edge-gateways.png) 

IoT Edge field gateways are located close to devices on-premises, and connect to the IoT platform to extend cloud capabilities into devices. IoT Edge devices act as communication enablers, local device control systems, and data processors for the cloud IoT platform. IoT Edge devices can run cloud workflows on-premises by using [Edge modules](https://docs.microsoft.com/azure/iot-edge/iot-edge-modules), and can communicate with devices even in offline scenarios.

Protocol cloud gateways extend device capabilities into the cloud by hosting device instances and enabling communication between devices and the IoT Hub. Cloud gateways can do protocol and identity translation to and from IoT Hub, and can execute additional logic on behalf of devices. Protocol gateways allow connecting existing and diverse device populations to IoT solutions.

## Direct methods with protocol gateways

IoT applications benefit from the connectivity enforcement and request-response model of [direct methods](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods) commands. Since a protocol gateway typically acts on behalf of devices to broker custom protocol communication between devices and the IoT Hub, you can abstract the direct methods model and serialize methods into device-compatible protocol messaging within a protocol gateway.

![A diagram illustrating the sequence of direct methods calls to use a protocol gateway to broker custom protocol communication from a device to the Azure IoT platform.](media/protocol-gateways.png)

1. The application invokes the direct method on behalf of the device in the protocol gateway.
2. In the method implementation, the gateway translates the method into a device specific protocol and sends the message to the device. The device is unaware of any changes to cloud implementation.
3. When the device completes the message and responds, the gateway translate the device-specific status to the method response.
4. The IoT Hub completes the direct method by populating a method result for the caller.

The [Azure Protocol Gateway](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) open-source project provides native capability for translating methods to MQTT messages, and is easily extensible. The MQTT adapter also demonstrates the programming model for other protocol adapters.
