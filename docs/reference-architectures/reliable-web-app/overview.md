---
title: Reliable web app pattern
description: Learn about the reliable web app pattern.
author: stephen-sumner    
ms.author: ssumner
ms.reviewer: ssumner
ms.date: 04/14/2022
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

The reliable web app pattern shows developers how to modify web applications that have recently migrated to the cloud. The pattern focuses on the minimal changes you should make to ensure the success of your web app in the cloud, and the implementation guidance follows the principles of the Well-Architected Framework (WAF).

[![Diagram showing the principles of the reliable web app pattern](images/reliable-web-app-overview.png)](images/reliable-web-app-overview.png)

## Why use the reliable web app pattern?

The reliable web app pattern details the essential steps you need take to ensure your web app is successful in the cloud. It reinforces general best practices but also highlights cloud principles that many developers are unaware of. It provides end-to-end implementation guidance with code examples and a reference implementation (sample web app) all in one place so you can rapidly adopt the guidance.

## How to use the reliable web app pattern

For each technology stack, there are two articles and a reference implementation (sample web app) you can deploy. *Plan the implementation* helps you align your architecture and business needs. *Apply the pattern* shows you how to make the required code and architecture changes. The reference implementation provides example code that you use and learn from. Use these three components as you need to ensure the success of your web app in the cloud.

## Next steps

The following table provides links to the implementation guidance and the Github repositories for your each technology stack.

| Technology stack | Implementation guidance | Reference implementation |
| --- | --- | --- |
| .NET | [Plan the implementation](./dotnet/pattern-overview.yml)<br><br>[Apply the pattern](./dotnet/apply-pattern.yml) | [.NET reference implementation](https://aka.ms/eap/rwa/dotnet) |
| Java | [Plan the implementation](./java/plan-implementation.yml)<br><br>[Apply the pattern](./java/apply-pattern.yml) | [Java reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java)
