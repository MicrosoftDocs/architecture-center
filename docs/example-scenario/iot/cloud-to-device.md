---
title: Cloud-to-device commands
titleSuffix: Azure Example Scenarios
description: Learn about how applications can use cloud-to-device messaging or direct methods to send commands to IoT devices.
author: wamachine
ms.date: 08/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Cloud-to-device commands

Applications use two primary mechanisms to send commands to an IoT device, *cloud-to-device messaging* and *direct methods*.

- Applications send [cloud-to-device messages](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d)messages to device-specific message queues on the IoT Hub for the devices to read when they're connected. The devices decide when to read the messages.

- Applications invoke [direct methods](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods) directly on connected devices, using a request-response pattern over dedicated IoT device endpoints.

## Cloud-to-device messaging

Applications send cloud-to-device command messages for specific devices to Azure IoT Hub, which stores the messages in device-specific queues. IoT Hub delivers the messages to the devices' queues regardless of whether the devices are connected.

![A diagram showing how the IoT Hub stores messages on an internal message queue for each device, and the devices polling for these messages.](media/cloud-to-device-message.png)

The following considerations apply when using cloud-to-device messaging:

- Message queues effectively acts as mailboxes for devices, and devices are responsible for polling their message queues for new messages when they're connected.
- Devices receive messages in a first-in, first-out fashion, making cloud-to-device messaging ideal for reading and acting on messages sequentially.
- Messages have a configurable expiration, so unread messages can eventually be removed from the device's message queue.
- For stateful communication, applications can use a [feedback receiver](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d#receive-delivery-feedback) to monitor message delivery and acknowledgment. The application uses a single feedback receiver to monitor all message queues for all devices.

## Direct methods

Applications invoke direct methods directly on connected IoT devices, and expect the devices to execute the methods and register them with the IoT Hub. IoT Hub calls the direct methods on connected devices over direct channels, and devices are responsible for executing functions and returning immediate results.

![A diagram showing how the IoT Hub invokes code directly on an individual device using direct methods.](media/direct-method.png)

The following considerations apply when using direct methods:

- Direct methods fail if the connection is broken between the IoT Hub and the device before the method completes. Applications can catch and handle failures to re-attempt commands.
- Since there's no queue, applications that require sequencing of direct methods need to manage the sequencing of method calls, such that completing the previous method calls the next method.
- Invoking direct methods allows an application to set two timeouts. One timeout specifies how long the IoT Hub should wait for a device to connect before giving up, and the other specifies how long the caller should wait for the method to complete and respond before giving up.

### Direct methods with protocol gateways

IoT applications benefit from the connectivity enforcement and request-response model of direct methods. [Cloud or protocol gateways] allow for connecting pre-existing and diverse types of devices to IoT Hub by acting on behalf of devices to broker custom protocol communications. Protocol gateways can likewise abstract the direct methods model by serializing methods into device-compatible protocol messages.

![A diagram illustrating the sequence of direct methods calls to use a protocol gateway to broker custom protocol communication from a device to IoT Hub.](media/protocol-gateways.png)

1. The application invokes the direct method on behalf of the device in the protocol gateway.
2. In the method implementation, the gateway translates the method into a device-specific protocol and sends the message to the device. The device is unaware of any changes to cloud implementation.
3. When the device completes the message and responds, the gateway translate the device-specific status to the method response.
4. The IoT Hub completes the direct method by populating a method result for the caller.

## See also
- [Cloud-to-device communications guidance](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-c2d-guidance) provides scenario-based guidance about when to use cloud-to-device messages or direct methods.
- The [Azure Protocol Gateway](https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway) open-source project translates direct methods to MQTT messages natively, is easily extensible, and demonstrates the programming model for other protocol adapters.
