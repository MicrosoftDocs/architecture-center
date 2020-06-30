---
title: Commands with Connected Standby Devices
titleSuffix: Azure Example Scenarios
description: Provides an implementation pattern for how to use Cloud-to-Device commands with connected standby devices.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Commands with Connected Standby Devices

Remote command scenarios in IoT may involve **Connected Standby
Devices**. In these cases, a device remains in a low power, idle
condition when not in active. These devices can be transitioned to a
fully operational state when sent a wakeup signal, via mechanisms like
Short Message Service (SMS).

![A diagram illustrating how SMS messages or commands sent through the Azure IoT APIs can be used to ensure a device is awake and connected to the hub](media/connected-standby-devices.png)

| Component | Description |
| --- | --- |
| **SMS gateway** | Mobile provider's SMS Gateway used to send SMS wakeup messages to devices. Devices in turn connect to the Hub when they receive a wakeup message. |
| [**Service client SDK**](https://docs.microsoft.com/dotnet/api/microsoft.azure.devices.serviceclient?view=azure-dotnet) | Azure IoT APIs enabling applications services to send commands to devices. One instance of service client can send messages and invoke methods for multiple devices. |
| [**Device client SDK**](https://docs.microsoft.com/dotnet/api/microsoft.azure.devices.client.deviceclient?view=azure-dotnet) | Azure IoT APIs enabling a device can use to send events to and receive commands from an application. One instance of device client represents a single device connected to IoT Hub. |

## Example of Using Direct Methods to Ensure a Device Connected

Remote command scenarios generally require a device is connected to the
Hub before being sent commands. Mechanisms such as SMS Gateways (or
similar) can incur great expense when wake up messages are sent
needlessly. Therefore, it is desirable to determine whether a device is
already connected or needs to be sent a wake up before sending actual
commands to it.

An effective way to achieve this is to leverage the existing source of
truth as to the connected state of a device in the IoT Hub. Since
**direct methods** in Azure IoT require the target device is connected
to receive the method, the use of connection and method timeouts can be
used to achieve this:

```
    TimeSpan connTimeOut = FromSeconds(0); // Period to wait for device to connect.
    TimeSpan funcTimeOut = FromSeconds(30); // Period to wait for method to execute.

    while (true) {
        // Send the command via Direct Method. We'll initially use a timeout of zero
        // for the connection which can determine whether the device is connected to
        // the Hub or will need an SMS wakeup sent to it.
        
        var method = new CloudToDeviceMethod("RemoteCommand", funcTimeOut, connTimeOut);
        methodInvocation1.SetPayloadJson(CommandPayload);

        var response = await serviceClient.InvokeDeviceMethodAsync(deviceId, method);
        if (var == [DeviceNotConnected] && connTimeOut == 0) {
            // The device is not currently connected and needs an SMS wake-up. This
            // device should wake up within a period of < 30 seconds. Send the wake-up
            // and retry the method request with a 30 second timeout on waiting for
            // the device to connect.

            connTimeOut = FromSeconds(30); // Set a 30 second connection timeout.
            SendAsyncSMSWakeUpToDevice(); // Send SMS wake up through mobile gateway.
            continue; // Re-try with new connection timeout.
        } else {
            // The method either succeeded or failed.
            ActOnMethodResult(var);
            break;
        }
    }
```

> **Note:** An empty method can be used with a connection timeout of zero
to implement a simple ping if desiring to solely check connectivity.
Example: `var method = new CloudToDeviceMethod("Ping", 0, 0);`" 
