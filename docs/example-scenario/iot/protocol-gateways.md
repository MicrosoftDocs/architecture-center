---
title: Direct methods with protocol gateways
titleSuffix: Azure Example Scenarios
description: An implementation pattern for how to use direct methods with existing protocols using a protocol gateway.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Direct methods with protocol gateways

IoT applications benefit from the connectivity enforcement and request-response model of [direct methods](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods) commands. Protocol gateways allow connecting existing and diverse device populations to IoT solutions. Since a protocol gateway typically acts on behalf of devices to broker custom protocol communication between devices and the IoT Hub, you can abstract the direct methods model and serialize methods into device-compatible protocol messaging within a protocol gateway.

![A diagram illustrating the sequence of direct methods calls to use a protocol gateway to broker custom protocol communication from a device to the Azure IoT platform.](media/protocol-gateways.png)

1. The application invokes the direct method on behalf of the device in the protocol gateway.
2. In the method implementation, the gateway translates the method into a device specific protocol and sends the message to the device. The device is unaware of any changes to cloud implementation.
3. When the device completes the message and responds, the gateway translate the device-specific status to the method response.
4. The IoT Hub completes the direct method by populating a method result for the caller.

The [Azure Protocol Gateway](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) open-source project provides this capability natively for translating methods to MQTT messages, and is easily extensible. The MQTT adapter also demonstrates the programming model for other protocol adapters.
