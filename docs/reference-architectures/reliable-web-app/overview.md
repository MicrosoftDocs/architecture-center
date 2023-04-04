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

The reliable web app pattern details essential implementation guidance for migrating on-premises .NET and Java web apps to the cloud. It builds on the overarching principles of the enterprise app patterns and focuses on the minimal changes you need to make to ensure your web app is successful in the cloud. The implementation guidance shows you how to apply reliability design patterns to your code. It also details the essential changes you need to make to ensure your web app is secure, cost-optimized, high-performing, and operationally excellent.

[![Diagram showing the principles of the reliable web app pattern](images/reliable-web-app-overview.png)](images/reliable-web-app-overview.png)

**Why the reliable web app pattern?** It's not always clear what you need to do after you migrate a web to the cloud. You might not be aware of the implementation changes you could and should make to maximize your success. The reliable web app pattern solves this problem. The implementation guidance tells you what you should to migrate web apps to the cloud successfully and how to do it with code examples.

**How to implement the reliable web app pattern.** There's end-to-end implementation guidance for .NET and Java web apps transitioning to the cloud. It shows you how to plan the reliable web app implementation and then apply the pattern to your web app.The guidance includes sample web applications (reference implementations) that you can deploy and copy the code. You should deploy the web app and use the written guidance in parallel. Apply the implementation guidance to your web app and use the reference implementation as an example implementation you can copy.

## Next steps

Use the following table to find the implementation guidance and Github repositories for your technology stack.

| Technology stack | Implementation guidance | Reference implementation |
| --- | --- | --- |
| .NET | [Plan the implementation](./dotnet/pattern-overview.yml)<br><br>[Apply the pattern](./dotnet/apply-pattern.yml) | [.NET reference implementation](https://aka.ms/eap/rwa/dotnet) |
| Java | [Plan the implementation](./java/plan-implementation.yml)<br><br>[Apply the pattern](./java/apply-pattern.yml) | [Java reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) |

>[!div class="nextstepaction"]
>[Reliable web app for .NET](./dotnet/pattern-overview.yml)
>[!div class="nextstepaction"]
>[Reliable web app for Java](./java/plan-implementation.yml)
