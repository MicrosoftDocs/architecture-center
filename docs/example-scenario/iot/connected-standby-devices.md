---
title: Commands with Connected Standby Devices
titleSuffix: Azure Example Scenarios
description: Provides an implementation pattern for how to use Cloud-to-Device commands with connected standby devices.
author: wamachine
ms.date: 06/29/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
### Commands to connected standby devices

IoT command scenarios may involve *connected standby devices* that are in a low-power, idle condition when not active. Mechanisms like mobile Short Message Service (SMS) can send wakeup signals to transition these devices to a fully operational state.

![A diagram illustrating how SMS messages or commands sent through the Azure IoT APIs can wake up a device and connect it to IoT Hub to receive commands.](media/connected-standby-devices.png)

1. The application sends commands to devices using the [service client SDK](https://docs.microsoft.com/dotnet/api/microsoft.azure.devices.serviceclient) APIs. One instance of service client can send messages and invoke methods for multiple devices. 
1. The application also sends SMS wakeup calls to standby devices via the mobile provider's SMS gateway.
1. On wakeup, standby devices use the [device client SDK](https://docs.microsoft.com/dotnet/api/microsoft.azure.devices.client.deviceclient) APIs to connect to IoT Hub and receive commands. One instance of device client represents a single device connected to IoT Hub.

#### Use direct methods to determine device connection status

Sending wakeup messages through SMS gateways can be costly. To avoid unnecessary expense, the direct methods connection and method timeouts can determine whether a device is already connected to the hub, and then send a wakeup if necessary before sending actual commands to the device.

```csharp
    TimeSpan connTimeOut = FromSeconds(0); // Period to wait for device to connect.
    TimeSpan funcTimeOut = FromSeconds(30); // Period to wait for method to execute.

    while (true) {
        // Send the command via direct method. Initially use a timeout of zero
        // for the connection, which determines whether the device is connected to
        // IoT Hub or needs an SMS wakeup sent to it.
        
        var method = new CloudToDeviceMethod("RemoteCommand", funcTimeOut, connTimeOut);
        methodInvocation1.SetPayloadJson(CommandPayload);

        var response = await serviceClient.InvokeDeviceMethodAsync(deviceId, method);
        if (var == [DeviceNotConnected] && connTimeOut == 0) {
            // The device is not currently connected and needs an SMS wakeup. This
            // device should wake up within a period of < 30 seconds. Send the wakeup
            // and retry the method request with a 30 second timeout on waiting for
            // the device to connect.

            connTimeOut = FromSeconds(30); // Set a 30 second connection timeout.
            SendAsyncSMSWakeUpToDevice(); // Send SMS wakeup through mobile gateway.
            continue; // Retry with new connection timeout.
        } else {
            // The method either succeeded or failed.
            ActOnMethodResult(var);
            break;
        }
    }
```

To simply check connectivity, use an empty method with a connection timeout of zero to implement a simple ping:
Example: `var method = new CloudToDeviceMethod("Ping", 0, 0);`
