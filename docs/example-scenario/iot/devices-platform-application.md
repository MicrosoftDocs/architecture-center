---
title: Devices, IoT Platform, and Application
titleSuffix: Azure Example Scenarios
description: The topological relationship between devices, the Azure IoT Platform, and an application.
author: mcosner
ms.date: 05/05/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
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

Solution Part | Description
--- | ---
Devices |  The physical (or virtual) "things" that connect to an IoT Application to send events and receive commands. Devices have one or more of the following characteristics: 
<br> | Possesses a unique **Identity** that distinguishes it with the solution.  
<br> | Has **Properties**, or state, that are accessible by applications.
<br> | Sends **Events** to the IoT Platform for applications to act on.
<br> | Receives **Commands** from applications to take action on.
IoT Platform | The collection of services that allow devices and applications to connect and communicate with one another.  The Azure IoT Platform will, at minimum, provide the following capabilities:
<br> | **Broker** authentication, connectivity, and secure communication between devices and trusted applications. 
<br> | Ability to execute in-place **Insights** on incoming events to route the events to desired endpoints. 
Application | The collection of scenario specific services and components unique to a given IoT Solution. IoT Applications will typically have the following characteristics: 
<br> | Composed of a mix of Azure (and/or other) services for compute, storage, and event endpoints, in combination with unique application business logic. 
<br> | Event workflows to receive and process incoming device events. 
<br> | Action workflows to send commands to devices or other processes. 
