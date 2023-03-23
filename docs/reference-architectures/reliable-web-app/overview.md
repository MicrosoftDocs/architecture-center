---
title: Reliable web app pattern
description: Learn about the principles of the reliable web app pattern.
author: stephen-sumner    
ms.author: ssumner
ms.reviewer: ssumner
ms.date: 03/31/2022
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

The reliable web app pattern details essential implementation guidance for migrating on-premises .NET and Java web apps to the cloud. It focuses on the minimal, low-cost, high-value changes you need to make to ensure your web app is successful in the cloud. These changes include business-driven architecture and code-level design patterns (Retry, Circuit breaker, and Cache aside). Every decision all align with the principles of the Well-Architected Framework (WAF) and 12 Factor Apps methodology.

[![Diagram showing the principles of the reliable web app pattern](images/reliable-web-app-overview.png)](images/reliable-web-app-overview.png)

## Why the reliable web app pattern?

It's not always clear how to migrate a web app to the cloud or you might not be aware of the implementation changes you could and should make. The reliable web app pattern resolves this ambiguity. It tells you what you should to migrate web apps to the cloud successfully and how to do it with code examples.

![Diagram showing GitHub icon.](../../_images/github.png) The code examples come from a companion sample application (reference implementations) that you can deploy. There's one for .NET and Java. These reference implementations apply the reliable web app pattern. For more information, see:

- [.NET reference implementation](https://aka.ms/eap/rwa/dotnet)
- [Java reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java)

**Minimal code changes** The reliable web app focuses on the fewest changes you need to make to implement WAF guidance. The minimal code changes the pattern outlines help webs take advantage of the cloud faster. This approach helps business meet objectives, reduce development costs, and shorten the time to market.

**Low-cost, high-value updates.** The reliable web app guidance shows you how to make updates to your web app without incurring significant expenses and provide significant benefits to meeting business drivers. When you focus on low-cost, high-value updates, you can maximize the benefits of the cloud migration while maximizing the return on investment.

**Cost-optimized environments.** The reliable web app pattern guides you to create and manage cost-optmized environments (development, test, production). The goal is to meet performance requirements without waste.

**Business-driven design.** The reliable web app pattern outline how you should approach the service level objective (SLO) for availability. An SLO for availability defines how available you want a web app to be for users. There's no universal SLO. Rather, your business needs should drive the SLO your web app needs to have.

## Next steps

The following reliable web app articles provide the implementation guidance you need to migrate .NET and Java web apps to the cloud.

>[!div class="nextstepaction"]
>[Reliable web app for .NET](./dotnet/pattern-overview.yml)
>[!div class="nextstepaction"]
>[Reliable web app for Java](./java/plan-implementation.yml)
