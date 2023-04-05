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

The reliable web app pattern provides essential implementation guidance for migrating on-premises .NET and Java web apps to the cloud. The pattern incorporates the principles of the enterprise app patterns. All the enterprise app patterns follow the principles of the Well-Architected Framework (WAF).

The reliable web app pattern focuses on the minimal code changes you need to make to ensure your web app is successful in the cloud. The focus is on the reliability design patterns you should adopt to meet your business needs. However, the articles provide essential implementation guidance for reliability, security, cost optimization, operations, and performance at the code and architecture level.

The articles shows you how to plan an implementation of the reliable web app pattern that meet your business goals. Then, it shows you how to apply the pattern to your web app. It also details the essential changes you need to make to ensure your web app is secure, cost-optimized, high-performing, and operationally excellent.

[![Diagram showing the principles of the reliable web app pattern](images/reliable-web-app-overview.png)](images/reliable-web-app-overview.png)

## Why?

It's not always clear what you need to do after you migrate a web to the cloud. You might not be aware of the implementation changes you could and should make to maximize your success. The reliable web app pattern solves this problem. The implementation guidance tells you what you should to migrate web apps to the cloud successfully and how to do it with code examples.

## How?

There's end-to-end implementation guidance for .NET and Java web apps transitioning to the cloud. It shows you how to plan the reliable web app implementation and then apply the pattern to your web app.The guidance includes sample web applications (reference implementations) that you can deploy and copy the code. You should deploy the web app and use the written guidance in parallel. Apply the implementation guidance to your web app and use the reference implementation as an example implementation you can copy.

## Next steps

Use the following table to find the implementation guidance and Github repositories for your technology stack.

| Technology stack | Implementation guidance | Reference implementation |
| --- | --- | --- |
| .NET | [Plan the implementation](./dotnet/pattern-overview.yml)<br><br>[Apply the pattern](./dotnet/apply-pattern.yml) | [.NET reference implementation](https://aka.ms/eap/rwa/dotnet) |
| Java | [Plan the implementation](./java/plan-implementation.yml)<br><br>[Apply the pattern](./java/apply-pattern.yml) | [Java reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java)
