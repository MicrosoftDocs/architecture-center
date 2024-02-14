---
title: Reliable web app pattern
description: Learn about the reliable web app pattern.
author: stephen-sumner    
ms.author: ssumner
ms.reviewer: ssumner
ms.date: 04/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
    - web
    - developer-tools
    - databases
    - devops
products:
  - azure
  - azure-app-service
  - azure-cache-redis
categories:
  - web
---

# Reliable web app pattern

The reliable web app pattern aims to streamline the process of moving web applications to the cloud. It provides a systematic method for quickly adopting cloud technologies. This involves strategies for updating or 'replatforming' your web application, ensuring a successful transition to the cloud.

[![Diagram showing the principles of the reliable web app pattern](../_images/reliable-web-app-overview.svg)](../_images/reliable-web-app-overview.svg#lightbox)
*Figure 1. Reliable web app pattern overview.*

## Principles and implementation techniques

The pattern is underpinned by several key principles, divided into core principles and those derived from the Azure Well-Architected Framework. The core principles focus on making minimal code changes, applying reliability design patterns, and using managed services. The principles from the Well-Architected Framework emphasize cost optimization, observability, securing ingress points, employing infrastructure as code, and adopting identity-centric security measures.

| Reliable web app pattern principles | Implementation techniques |
| --- | --- |
| *Core principles:*<br>▪ Minimal code changes<br>▪ Reliability design patterns<br>▪ Managed services<br><br>*Well Architected Framework principles:*<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Bicep deployment <br>▪ Telemetry, logging, monitoring |

## Web app architecture

It's important to note that the reliable web app pattern is not a one-size-fits-all set of services or a specific architecture. The unique needs of your business and the characteristics of your existing web application are crucial in determining the most suitable architecture and network topology.

## Next steps

For practical application, the pattern provides specific guidance for .NET and Java web applications. There are reference implementations available for both platforms, which incorporate the reliable web app pattern. These serve as examples to accelerate the adoption process. To make the most of this guidance, choose the direction that best fits your web app's technology stack and follow the provided reference implementation to streamline your transition to the cloud.

>[!div class="nextstepaction"]
>[Reliable web app pattern for .NET](./dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable web app pattern for Java](./java/plan-implementation.yml)
