---
title: Alerts in IoT Edge Vision
titleSuffix: Azure Architecture Center
description: Learn about the persistence of alerts in an Azure IoT Edge Vision solution. An alert is a response to an event that's triggered by the AI model.
author: MSKeith
ms.author: keith
ms.date: 10/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
products:
  - azure-iot-edge
ms.custom:
  - guide
---

# Alert persistence in Azure IoT Edge Vision

In the context of vision on edge, an alert is a response to an event triggered by the AI model. In other words, it is the inferencing results. The type of event is determined by the training imparted to the model. These events are separate from operational events raised by the processing pipeline and any event related to the health of the runtime.

## Types of alerts

Some of the common alerts types are:

* Image classification
* Movement detection
* Direction of movement
* Object detection
* Count of objects
* Total count of objects over period of time
* Average count of objects over period of time

Alerts are required to be monitored as they drive certain actions. They are critical to operations, being time sensitive in terms of processing, and are required to be logged for audit and further analysis.

## Persistence of alerts

The alerts need to persist locally on the edge where they are raised and then passed on to the cloud for further processing and storage. This ensures a quick local response and avoids losing critical alerts due to any transient failures.

Some options to achieve this persistence and cloud syncing are:

* Utilize built-in store and forward capability of IoT Edge runtime, which automatically gets synced with Azure IoT Hub after a lost connectivity.
* Persist alerts on host file system as log files, which can be synced periodically to a blob storage in the cloud.
* Utilize Azure Blob Edge module, which will sync this data to Azure Blob in cloud based on policies that can be configured.
* Use local database on IoT Edge, such as SQL Edge for storing data, and sync with Azure SQL DB using SQL Data Sync. Another lightweight database option is the SQLite.

The preferred option is to use the built-in store and forward capability of IoT Edge runtime. This is more suitable for the alerts due to its time sensitivity, typically small messages sizes, and ease of use.

## Next steps

Now you can proceed to work on the [User interface in Azure IoT Edge Vision](./user-interface.md) for your vision workload.
