---
title: Azure Functions and security
description: Focuses on the Azure Functions service used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to service security.
author: v-stacywray
ms.date: 11/24/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-functions
categories:
  - compute
  - management-and-governance
---

# Azure Functions and security

[Azure Functions](/azure/azure-functions/functions-overview) is a cloud service available on-demand that provides all the continually updated infrastructure and resources needed to run your applications. Functions allow you to write less code, maintain less infrastructure, and save on costs. Instead of worrying about deploying and maintaining servers, the cloud infrastructure provides all the up-to-date resources needed to keep your applications securely running.

For more information related to network security, reference [Securing Azure Functions](/azure/azure-functions/security-concepts).

The following sections include a design consideration checklist and recommendations specific to Azure Functions, and security.

## Design consideration checklist

**Have you designed your workload and configured Azure Functions with security in mind?**
***

> [!div class="checklist"]
> - Evaluate if Azure Functions requires HTTP trigger.
> - Treat Azure Functions code just like any other code.
> - Use guidance available on [Securing Azure Functions](/azure/azure-functions/security-concepts).
> - Consider using [Azure Functions Proxy](/azure/azure-functions/functions-proxies) to act as a facade.

## Design consideration recommendations

The following table reflects design consideration recommendations and descriptions related to Azure Functions:

|Azure Functions Design Recommendations|Description|
|--------------------------------------|-----------|
|Evaluate if Azure Functions requires HTTP trigger.|Azure Functions supports multiple specific triggers and bindings. These include blob storage, Cosmos DB, Service Bus, and many more. If HTTP trigger is needed, then consider protecting that HTTP endpoint like any other web application. Common protection measures include keeping HTTP endpoint internal to specific Azure Virtual Networks by using [Private endpoint connections](/azure/azure-functions/functions-networking-options#private-endpoint-connections) or [service endpoints](/azure/azure-functions/functions-networking-options#use-service-endpoints). Consider using guidance available on [Azure Functions networking options](/azure/azure-functions/functions-networking-options) for more information. If Functions HTTP endpoint will be exposed to internet, then it's recommended to secure the endpoint behind a Web Application Firewall (WAF).|
|Treat Azure Functions code just like any other code.|Subject Azure Functions code to code scanning tools that are integrated with CI/CD pipeline.|
|Use guidance available on [Securing Azure Functions](/azure/azure-functions/security-concepts).|This guidance addresses key security concerns such as operations, deployment, and network security.|
|Consider using [Azure Functions Proxy](/azure/azure-functions/functions-proxies) to act as a facade.|Functions Proxy can inspect and modify incoming requests and responses.|

## Next step

> [!div class="nextstepaction"]
> [Azure Service Fabric and reliability](../service-fabric/reliability.md)
