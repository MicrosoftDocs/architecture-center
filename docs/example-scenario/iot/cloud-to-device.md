---
title: Cloud to device commands
titleSuffix: Azure Example Scenarios
description: Learn about using cloud-to-device messages or direct methods to send commands to Azure IoT devices.
author: wamachine
ms.date: 08/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Cloud-to-device commands

There are two primary mechanisms for sending commands to an IoT device, *cloud-to-device messages* and *direct methods*.

- An application sends [cloud-to-device messages](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d) to a message queue on the IoT Hub for a device to read when it is connected. The device decides when to read the messages.

- With [direct methods](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods), the application calls a function directly on a device when it is connected. Specified methods are immediately invoked over a dedicated IoT endpoint for the device using a request-response pattern.

## Cloud-to-device messages

In the case of cloud-to-device messages, commands intended for a specific device are sent to the IoT Hub, which stores the message in a device-specific queue. The message is delivered to the device's queue regardless of whether the device is connected to the IoT Hub.

![A diagram showing how the IoT Hub stores messages on an internal message queue for each device, and the devices polling for these messages](media/cloud-to-device-message.png)

The following considerations apply when using cloud-to-device messages:

- Since the message queue effectively acts as a mailbox for the device, the device is responsible for polling its message queue for new messages whenever it is connected.
- Messages are always received by a device in a first-in-first-out fashion. This makes device-to-cloud messaging ideal for scenarios where a series of messages should be read and acted on sequentially.
- Messages have a configurable expiration, which means an unread message is eventually removed from the device's message queue.
- For stateful communication, an application can use a [feedback receiver](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d#receive-delivery-feedback) to monitor message delivery and acknowledgement. Use a single feedback receiver to monitor all message queues for all devices.

## Direct methods

Connected devices immediately execute direct methods when an application invokes them, using a request-response model. The application expects devices to implement specific functions and register them with the IoT Hub when they connect.

![A diagram showing how the IoT Hub invokes code directly on an individual device using direct methods](media/direct-method.png)

The following considerations apply when using direct methods:

- IoT Hub can call a direct method on a connected device over a direct channel, and the device is responsible for executing the function and returning an immediate result.
- Direct methods fail if the connection is broken between the IoT Hub and the device before the method completes. Applications can catch and handle failures to re-attempt the command.
- Since there is no queue, applications that require sequencing of direct methods need to manage the sequencing of the method calls, so completing the previous method calls the next method.
- Invoking direct methods from an application allows two timeouts to be set. One timeout specifies how long the IoT Hub should wait for a device to connect before giving up, and the other specifies how long the caller should wait for the method to complete and respond before giving up.

## See also
[Cloud-to-device communications guidance](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-c2d-guidance) provides scenario-based guidance about when to use cloud-to-device messages or direct methods.
