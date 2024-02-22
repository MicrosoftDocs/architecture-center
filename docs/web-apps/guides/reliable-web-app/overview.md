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

The reliable web app pattern aims to streamline the process of moving web applications to the cloud. It provides a systematic method for quickly adopting cloud technologies. The pattern details strategies for updating or replatforming your web application to ensure a successful transition to the cloud.

[![Diagram showing the principles of the reliable web app pattern](../_images/reliable-web-app-overview.svg)](../_images/reliable-web-app-overview.svg#lightbox)

## Principles and implementation techniques

Several key principles underpin the pattern. There are core principles and principles from the Azure Well-Architected Framework. The pattern focus on making minimal code changes, applying reliability design patterns, and using managed services. It helps you create a web app that is cost optimized, observable, and ingress secure using infrastructure as code and identity-centric security.

| Reliable web app pattern principles | Implementation techniques |
| --- | --- |
| <br>▪ Minimal code changes<br>▪ Reliability design patterns<br>▪ Managed services<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Bicep (.NET) and Terraform (Java) deployment <br>▪ Telemetry, logging, monitoring |

## Web app architecture

It's important to note that the reliable web app pattern isn't a one-size-fits-all set of services or a specific architecture. The unique needs of your business and the characteristics of your existing web application are crucial in determining the most suitable architecture and network topology.

## Next steps

There's reliable web app pattern guidance for .NET and Java web applications. Use the guidance and reference implementations to accelerate your move to Azure.

>[!div class="nextstepaction"]
>[Reliable web app pattern for .NET](./dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable web app pattern for Java](./java/plan-implementation.yml)
