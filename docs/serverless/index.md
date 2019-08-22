---
title: Overview of serverless applications in Azure | Microsoft Docs
description: This article is a starting point to explore serverless architectures in Azure. 
author: dsk-2015
ms.date: 07/26/2019
ms.author: pnp
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Building serverless applications on Azure

Serverless models abstract the underlying compute infrastructure. This allows developers to focus on business logic without needing extensive startup or maintenance cost to set up the solution. Serverless reduces the overall costs since you pay only for the duration the code was executed. This event-driven model is suitable for situations where some event triggers a defined action. For example, receiving an incoming device messages to store for later use, or a database update that needs some further processing.

## Explore the recommendations

To explore serverless technologies in Azure, start with a serverless reference solution developed and tested by Microsoft. This two-part solution describes a hypothetical drone delivery system. Drones send in-flight status to the cloud, which stores these messages for later use. A web application allows users to retrieve these messages to get the latest status of these devices. 

- The code for this solution is available to download from [GitHub](https://github.com/mspnp/serverless-reference-implementation/tree/v0.1.0).
- The article [Code walkthrough: Serverless application with Azure Functions](./code.md) walks you through this code, and explains why various choices were made.  

Once you get a feel for how this reference solution works, proceed to learning the best practices and recommendations for developing similar serverless solutions:

- For developing a serverless *event ingestion* solution, refer to the reference-based guidance at [Serverless event processing using Azure Functions](../reference-architectures/serverless/event-processing.md).
- For developing a serverless *web application*, refer to the reference-based guidance at [Serverless web application on Azure](../reference-architectures/serverless/web-app.md).
 
## Next steps

For in-depth discussion on developing serverless solutions on premises as well as in cloud, read [Serverless apps: Architecture, patterns, and Azure implementation](https://docs.microsoft.com/dotnet/standard/serverless-architecture/).




