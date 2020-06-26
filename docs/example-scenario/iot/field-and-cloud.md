---
title: Field and Cloud Edge Gateways
titleSuffix: Azure Example Scenarios
description: Introduction to Edge Gateways and how they fit into the device, platform and application topology.
author: wamachine
ms.date: 06/26/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Field and Cloud Edge Gateways
While devices can connect to the IoT Platform directly, they can also be
connected to **Edge Gateways** to implement intelligent capabilities
outside the application. This enables functionality such as aggregation,
or filtering, of device events before being sent to the IoT Platform,
localized decision-making, and [protocol and identity
translation](https://docs.microsoft.com/en-us/azure/iot-edge/iot-edge-as-gateway)
on-behalf-of devices.

+----------------------------------+----------------------------------+
| Gateway Type                     | Description                      |
+==================================+==================================+
| [**Field Gateway**(IoT           | **Extends cloud capabilities     |
| Edge)](http                      | into Edge Devices:** Edge        |
| s://docs.microsoft.com/en-us/azu | Devices act as a communication   |
| re/iot-edge/iot-edge-as-gateway) | enabler, local device control    |
|                                  | system, and data processor for   |
|                                  | an IoT Hub. Some characteristics |
|                                  | include:                         |
|                                  |                                  |
|                                  | -   Specialized on-premises      |
|                                  |     device that connect to IoT   |
|                                  |     Platform.                    |
|                                  |                                  |
|                                  | -   Can run cloud workflows      |
|                                  |     on-premises using [Edge      |
|                                  |     Modules](ht                  |
|                                  | tps://docs.microsoft.com/en-us/a |
|                                  | zure/iot-edge/iot-edge-modules). |
|                                  |                                  |
|                                  | -   Can receive events from      |
|                                  |     devices in offline           |
|                                  |     scenarios.                   |
+----------------------------------+----------------------------------+
| [**Cloud Gateway**(Protocol      | **Extends device capabilities    |
| Gateway)](https://               | into the cloud:** Enable         |
| docs.microsoft.com/en-us/azure/i | communication to and from        |
| ot-hub/iot-hub-protocol-gateway) | devices with the IoT Platform.   |
|                                  | Some characteristics include:    |
|                                  |                                  |
|                                  | -   Can do protocol and identity |
|                                  |     translation to and from IoT  |
|                                  |     Hub.                         |
|                                  |                                  |
|                                  | -   Device instances are hosted  |
|                                  |     in the cloud gateway.        |
|                                  |                                  |
|                                  | -   Gateway can execute          |
|                                  |     additional logic on behalf   |
|                                  |     of devices.                  |
+----------------------------------+----------------------------------+
