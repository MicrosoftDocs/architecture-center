---
title: Alerts in IoT Edge Vision
titleSuffix: Azure Architecture Center
description: This article describes the persistence of alerts in an Azure IoT Edge Vision solution.
author: MSKeith
ms.date: 09/30/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Alerts persistence in Azure IoT Edge Vision

In the context of vision on edge, alerts is a response to an event that is triggered by the AI model (in other words, the inferencing results). The type of event is determined by the training imparted to the model. These events are separate from operational events raised by the processing pipeline and any related to the health of the runtime.

## Alert types

Some of the common alerts types are:

* Image classification
* Movement detection
* Direction of movement
* Object detection
* Count of objects
* Total Count of objects over period of time
* Average Count of objects over period of time

Alerts by their definition are required to be monitored as they drive certain actions. They are critical to operations, being time sensitive in terms of processing and required to be logged for audit and further analysis.

## Alerts persistence

The persistence of alerts needs to happen locally on the edge where it is raised and then passed on to the cloud for further processing and storage. This is to ensure quick response locally and avoid losing critical alerts due to any transient failures.

Some options to achieve this persistence and cloud syncing are:

* Utilize built-in store and forward capability of IoT Edge runtime, which automatically gets synced with Azure IoT Hub in case of losing connectivity
* Persist alerts on host file system as log files, which can be synced periodically to a blob storage in cloud
* Utilized Azure Blob Edge module, which will sync this data to Azure Blob in cloud based on policies that can be configured
* Use local database on IoT Edge, such as SQL Edge for storing data, sync with Azure SQL DB using SQL Data Sync.  Other lightweight database option is SQLite

The preferred option is to use the built-in store and forward capability of IoT Edge runtime. This is more suitable for the alerts due to its time sensitivity,typically small messages sizes, and ease of use.

## Next steps: 

Now you can proceed to work on the [User interface in Azure IoT Edge Vision](./iot-edge-user-interface.md) for this IoT Edge Vision solution.