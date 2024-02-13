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

The reliable web app pattern provides essential implementation guidance for web apps moving to the cloud. It defines how you should update (re-platform) your web app to be successful in the cloud. The reliable web app pattern focuses on minimal code changes, reliability design patterns, and managed services so you can rapidly adopt the cloud (*see figure 1*).

[![Diagram showing the principles of the reliable web app pattern](../_images/reliable-web-app-overview.svg)](../_images/reliable-web-app-overview.svg#lightbox)
*Figure 1. Overview of the reliable web app pattern.*

The reliable web app pattern builds on the principles of the Azure Well-Architected Framework. It focuses on several well-architected principles that are essential for the entire cloud adoption journey. The reliable web app pattern helps ensure web apps are cost optimized, observable, and ingress secure. The pattern also shows you how to implement infrastructure as code and identity-centric security. The following table lists the principles of the reliable web app pattern and how to implement those principles in your web app.

| Reliable web app pattern principles | Implementation techniques |
| --- | --- |
| *Core principles:*<br>▪ Minimal code changes<br>▪ Reliability design patterns<br>▪ Managed services<br><br>*Well Architected Framework principles:*<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Bicep deployment <br>▪ Telemetry, logging, monitoring |

## Next steps

There's specific implementation guidance for .NET and Java web apps. There's a reference implementation (sample web app) for both .NET and Java. The reference implementation has the reliable web app pattern applied. You should follow right guidance for your web app and use the reference implementation to expedite your progress.

>[!div class="nextstepaction"]
>[Reliable web app pattern for .NET](./dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable web app pattern for Java](./java/plan-implementation.yml)
