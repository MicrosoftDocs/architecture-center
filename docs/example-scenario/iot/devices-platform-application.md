---
title: Devices, IoT Platform, and Application
titleSuffix: Azure Example Scenarios
description: The topological relationship between devices, the Azure IoT Platform, and an application.
author: wamachine
ms.date: 05/05/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Devices, IoT Platform, and Application

Topologically, Azure IoT Solutions are a collection of assets and
components divided across
three parts: **Devices**, **IoT** **Platform**,
and **Application**. Conversely, **Events**, **Insights**,
and **Actions** are concepts representing data flow and processing
pipelines that takes place across these three parts. 


![A diagram showing the relationship between devices, the Azure IoT Platform, and an application](media/devices-platform-application.png)

<table>
<thead>
    <tr>
        <th>Solution Part</th>
        <th>Description</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td><b>Devices</b></td>
        <td>The physical (or virtual) "things" that connect to an IoT Application to send events and receive commands. Devices have one or more of the following characteristics:<br>
            <ul>
                <li>Possess a unique <b>Identity</b> that distinguishes it within the solution.</li>
                <li>Have <b>Properties</b>, or state, that are accessible to applications.</li>
                <li>Send <b>Events</b> to the IoT Platform for applications to act on.</li>
                <li>Receive <b>Commands</b> from applications to take action on.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>IoT Platform</b></td>
        <td>The collection of services that allow devices and applications to connect and communicate with one another.  The Azure IoT Platform should, at minimum, provide the following capabilities:
            <ul>
                <li><b>Broker</b> authentication, connectivity, and secure communication between devices and trusted applications. </li>
                <li>Generate contextual <b>Insights</b> on incoming events to determine the routing of events to desired endpoints.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><b>Application</b></td>
        <td>The collection of scenario-specific services and components unique to a given IoT Solution. IoT Applications will typically have the following characteristics: 
            <ul>
                <li>Composed of a mix of Azure (and/or other) services for compute, storage, and event endpoints, in combination with unique application business logic.</li>
                <li><b>Event</b> workflows to receive and process incoming device events. </li>
                <li><b>Action</b> workflows to send commands to devices or other processes. </li>
            </ul>
        </td>        
    </tr>
</tbody>
</table>
