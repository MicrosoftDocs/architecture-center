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

The reliable web app pattern offers a comprehensive guide for developers to optimize web applications that have recently transitioned to the cloud. This pattern concentrates on the minimal changes needed to introduce reliability and improve your web app's success in the cloud environment. It also builds on the overarching principles of the enterprise app patterns. The guidance adheres to the tenets of the Well-Architected Framework and focuses on low-cost, high-value changes to your web app. It also shows you how to let business needs drive the implementation specifics.

[![Diagram showing the principles of the reliable web app pattern](images/reliable-web-app-overview.png)](images/reliable-web-app-overview.png)

## Why use the reliable web app pattern?

The reliable web app pattern outlines crucial steps to ensure the effectiveness of your web app in the cloud. While reinforcing general best practices, it also emphasizes cloud-specific principles that might be unfamiliar to many developers. This pattern provides comprehensive implementation guidance, complete with code examples and a reference implementation (sample web app), allowing for rapid adoption and application of the guidance.

## How to use the reliable web app pattern

For each technology stack, there are two articles and a reference implementation (sample web app) available for deployment. Plan the Implementation assists you in aligning your architecture and business requirements. Apply the Pattern demonstrates how to execute the necessary code and architectural modifications. The Reference Implementation offers example code for you to utilize and learn from. Employ these three components as needed to ensure your web app's success in the cloud.

## Next steps

Use the following links to migrate and modernize your web apps in Azure.

| Guidance type | Reliable web app for .NET | Reliable web app for Java |
| --- | --- | --- |
| Plan the implementation | [Plan the implementation (.NET)](./dotnet/pattern-overview.yml) | [Plan the implementation (Java)](./java/plan-implementation.yml) |
| Apply the pattern | [Apply the pattern (.NET)](./dotnet/apply-pattern.yml) | [Apply the pattern (Java)](./java/apply-pattern.yml) |
| Reference implementation | [Reference implementation (.NET)](https://aka.ms/eap/rwa/dotnet) | [Reference implementation (Java)](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) |
