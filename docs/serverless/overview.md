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

# Serverless with Azure

Serverless models abstract the underlying compute infrastructure. This allows developers to focus on business logic without needing extensive startup or maintenance cost to set up the solution. This is an event-driven model, most suited to situations where some event triggers a defined action, for example, collecting incoming device messages and storing them for later use. 

Microsoft Azure provides multiple ways of implementing serverless code:

- [Azure Functions](/azure/azure-functions/)
- [Azure Kubernetes Service](/azure/aks/)
- [Azure App Service](/azure/app-service/)


If you are new to serverless technologies in Azure, start with exploring a serverless reference solution developed and tested by Microsoft engineering team. The code for this solution is available to download from [Github](https://github.com/mspnp/serverless-reference-implementation). The article [Show me the code: Serverless application with Azure Functions](index.md) walks you through this code, and explains the reasons behind the various choices. This two-part solution describes a hypothetical drone delivery system, where drones send in-flight status to the cloud, which stores these messages for later use. A web application allows users to retrieve these messages to learn the latest status of these devices. 

Once you get a feel for how this reference solution works, proceed to learning the best practices and recommendations for developing similar serverless solutions:

- For developing a serverless *event ingestion* workflow, refer to the reference-based guidance at [Serverless event processing using Azure Functions](/azure/architecture/reference-architectures/serverless/event-processing/).
- For developing a serverless *web application* workflow, refer to the reference-based guidance at [Serverless web application on Azure](/azure/architecture/reference-architectures/serverless/web-app/).
 
 



