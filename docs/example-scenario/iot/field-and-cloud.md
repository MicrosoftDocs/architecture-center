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
translation](https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway)
on-behalf-of devices.

![A diagram illustrating the flow of events, commands, and protocols as they are routed through a field or cloud edge gateway to the Azure IoT Platform](media/field-edge-gateways.png) 

<table>
<thead>
    <tr>
        <th>Gateway Type</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td width=20%><a href="https://docs.microsoft.com/azure/iot-edge/iot-edge-as-gateway">Field Gateway <br> (IoT Edge)</a></td>
        <td><b>Extends cloud capabilities into Edge Devices:</b> Edge Devices act as a communication enabler, local device control system, and data processor for an IoT Hub. Some characteristics include:<br>
            <ul>
                <li>Specialized on-premises device that connect to IoT Platform.</li>
                <li>Can run cloud workflows on-premises using <a href="https://docs.microsoft.com/azure/iot-edge/iot-edge-modules">Edge Modules</a>.</li>
                <li>Can receive events from devices in offline scenarios.</li>
            </ul>
        </td>
    </tr>
        <tr>
        <td><a href="https://docs.microsoft.com/azure/iot-hub/iot-hub-protocol-gateway">Cloud Gateway<br>(Protocol Gateway)</a></td>
        <td><b>Extends device capabilities into the cloud:</b> Enable communication to and from devices with the IoT Platform. Some characteristics include:<br>
            <ul>
                <li>Can do protocol and identity translation to and from IoT Hub.</li>
                <li>Device instances are hosted in the cloud gateway.</li>
                <li>Gateway can execute additional logic on behalf of devices.</li>
            </ul>
        </td>
    </tr>
</tbody>
</table>