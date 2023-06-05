---
title: Alerts in IoT Edge vision AI
titleSuffix: Azure Architecture Center
description: Learn about alerts and alert persistence in an Azure IoT Edge vision solution. An alert is a response to an event that's triggered by the AI model.
author: MSKeith
ms.author: keith
ms.date: 02/16/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: iot
products:
  - azure-iot-edge
ms.custom:
  - guide
  - fcp
---

# Alerts in Azure IoT Edge vision AI

In an artificial intelligence (AI) context, alerts are responses to triggering events from the AI model. The events are inferencing results based on the AI model's training.

Alerts must be monitored, because they drive certain actions. Alerts are time sensitive for processing, and must be logged for audit and further analysis. Alert events are different from operational or health events that the processing pipeline or runtime raise.

In vision AI, alerting typically occurs for triggering events related to:

- Image classification
- Movement detection or direction
- Object detection or count
- Average or total object count over time

## Alert persistence

Vision AI alerts should persist locally where they're raised, and pass on to the cloud for further processing and storage. Alert persistence enables quick local response, and prevents losing critical alerts due to transient network issues.

Options to achieve alert persistence and cloud syncing include:

- Use the built-in store and forward capability of the IoT Edge runtime, which automatically syncs with Azure IoT Hub after any lost connectivity.
- Persist alerts on the host file system as log files, and periodically sync the logs to blob storage in the cloud.
- Use an [Azure IoT Edge blob storage module](/azure/iot-edge/how-to-store-data-blob) to sync the data to Azure Blob Storage in the cloud, based on configurable policies.
- Use a local database such as [Azure SQL Edge](/azure/azure-sql-edge/overview) for storing data on IoT Edge, and sync with Azure SQL Database by using SQL Data Sync. Another lightweight database option is [SQLite](https://www.sqlite.org/index.html).

For alerts, the best option is the built-in store and forward capability of the IoT Edge runtime. This option is the most suitable because of its time sensitivity, typically small messages size, and ease of use. For more information, see [Understand extended offline capabilities for IoT Edge devices, modules, and child devices](/azure/iot-edge/offline-capabilities).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Keith Hill](https://www.linkedin.com/in/keith-hill-072060102/) | Senior PM Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next step

> [!div class="nextstepaction"]
> [Image storage and management in Azure IoT Edge Vision](./image-storage.md)

