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

While protocol gateways provide a means of
connecting existing, and diverse populations of device to IoT solutions,
it can also be desirable for the application to benefit from the
connectivity enforcement and request-response model conferred by [direct
methods](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods).

Since a protocol gateway typically serves to broker custom protocol
communication between a device and the IoT Hub by acting on-behalf-of
the device, the direct method programming model can be abstracted from
the device by serializing methods into compatible protocol messaging
within the protocol gateway.

![A diagram illustrating the sequence of calls using direct methods to use a protocol gateway to broker custom protocol communication from a device to the Azure IoT Platform](media/protocol-gateways.png)

-   Implement the direct method on-behalf of the device in the protocol
    gateway.

-   In the method implementation, translate the method into device
    specific protocol and send message to device. The device will be unaware
    of any changes to cloud implementation.

-   When device completes message and responds, translate device
    specific status to method response.

-   Complete the direct method by populating a method result for the
    caller.

>**Note:** The [Azure Protocol
Gateway](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) open source project provides this capability natively for translating methods to MQTT messages, and is easily extensible. The MQTT adapter also demonstrates the programming model for other protocol adapters.
