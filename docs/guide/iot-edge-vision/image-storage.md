---
title: Image storage in IoT Edge vision AI
titleSuffix: Azure Architecture Center
description: Learn about image storage and management in an Azure IoT Edge vision AI solution. See an image storage workflow that uses an IoT Edge blob storage module.
author: MSKeith
ms.author: keith
ms.date: 02/16/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: iot
products:
  - azure-iot-edge
  - azure-blob-storage
ms.custom:
  - guide
  - fcp
---

# Image storage in Azure IoT Edge vision AI

Image storage and management are important functions in Azure IoT Edge computer vision solutions.

Image storage requirements include:

- Fast storage to avoid pipeline bottlenecks and data loss
- Storage and labeling at the edge and in the cloud
- Easy retrieval of stored raw images for labeling
- Categorization of images for easy retrieval
- Naming and tagging to link images with inferred metadata

You can combine Blob Storage, Azure IoT Hub, and IoT Edge in several different ways to store image data. For example:

- Use an [Azure IoT Edge blob storage module](/azure/iot-edge/how-to-store-data-blob) to automatically sync images to Azure Blob Storage via policy.
- Store images to a local host file system, and upload them to Blob Storage by using a custom module.
- Use a local database to store images, and sync them to the cloud database.

## Example storage workflow

The following steps describe a typical workflow that uses an IoT Edge blob storage module.

1. The IoT Edge blob module stores raw data locally after ingestion, with time stamping and sequence numbering to uniquely identify the image files.
1. A policy set on the IoT Edge blob module automatically uploads the image data to Azure Blob Storage, with ordering.
1. To conserve space, the IoT Edge device automatically deletes the local data after a certain time span. The device also has the *retain while uploading* option set, to ensure all images sync to the cloud before deletion.
1. Local categorization or labeling uses a module that reads images into a user interface. The label data associates to the image URI, along with coordinates and category.
1. A local database stores the image metadata, and syncs to the cloud by using telemetry messages. Local storage supports easy lookup for the user interface.
1. During a scoring run, the machine learning model detects matching patterns and generates events of interest.

   - The model sends this metadata to the cloud via telemetry that refers to the image URI.
   - Optionally, the model also stores this metadata in the local database for the edge user interface.
   - The images themselves continue to store in the IoT Edge blob module and sync to Azure Blob Storage.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Keith Hill](https://www.linkedin.com/in/keith-hill-072060102/) | Senior PM Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!div class="nextstepaction"]
> [User interface and scenarios in Azure IoT Edge vision AI](./user-interface.md)
