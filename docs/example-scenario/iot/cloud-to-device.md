---
title: Devices, IoT Platform, and Application
titleSuffix: Azure Example Scenarios
description: How to use message and method-based mechanisms in Azure IoT to send commands to devices.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# Cloud to device commands

There are two primary mechanisms with which to send commands to a
device, **cloud-to-device messages** and **direct methods**:

| Command Mechanism | Description |
| --- | ---|
|[**Cloud-to-device messages**](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d)   | This is best thought of as an application sending a message to a mailbox for a device to read when it is connected. Messages are sent to a message queue on the Hub for a device. The device decides when to read these messages.|
| [**Direct methods**](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-direct-methods) | This is best thought of as an application calling a function directly on a device when it is connected. Specified methods are immediately invoked over a dedicated IoT endpoint for the device using a request-response pattern.|

## Cloud-to-Device Messages

In the case of **cloud-to-device messages**, commands intended for a
specific device are sent to the IoT Hub which stores the message in
device specific queue. The message will be delivered to the device's
queue regardless of whether the device is connected to the Hub.

![A diagram showing how the IoT Hub stores messages on an internal message queue for each device, and the devices polling for these messages](media/cloud-to-device-message.png)

**Considerations when using Cloud-to-Device Messages**

-   Since the message queue effectively acts as a mailbox for the
    device, the device is responsible for polling its message queue for
    new messages whenever it is connected.

-   Messages are always received by a device in a first-in-first-out
    fashion. This makes device-to-cloud messaging ideal for scenarios
    where a series of messages should be read and acted on sequentially.

-   Messages have a configurable expiration, which means should a device
    never read the message it will eventually be removed the device's
    message queue.

-   For stateful communication, an application can use a [feedback
    receiver](https://docs.microsoft.com/azure/iot-hub/iot-hub-csharp-csharp-c2d#receive-delivery-feedback)
    to monitor the delivery and acknowledgement of messages to devices.
    A single feedback receiver should be used to monitor all message
    queues for all devices.

## Direct methods

**Direct methods** are executed immediately by a connected device
using a request-response model when invoked from an application. With
this mechanism, devices are expected to implement specific functions and
register them with the IoT Hub when they connect.

![A diagram showing how the IoT Hub invokes code directly on an individual device using direct methods](media/direct-method.png)

**Considerations when using Direct Methods**

-   When a device is connected to IoT Hub methods can be called on the
    device over a direct channel and the device is responsible for
    executing the function and return an immediate result.

-   Direct methods will fail if the connection is broken between the Hub
    and the device before the method completes. Applications can catch
    and handle failures to re-attempt the command.

-   Since there is no queue, applications requiring sequencing of direct
    methods need to manage the sequencing of method calls such that the
    next method is called once the previous method completes.

-   Invoking direct methods from an application allows two timeouts to
    be set. One specifies how long the Hub should wait for a device to
    connected before giving up, the other specifies how long the caller
    should wait for the method to complete and response before giving
    up.

> **Note:** [Cloud-to-device communications
guidance](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-c2d-guidance)
provides scenario-based guidance on where cloud-to-device messages and
direct methods might be most suitable. </aside>
