---
title: Enterprise Web App Patterns
description: Learn about Enterprise Web App Patterns.
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
    - devops
products:
  - azure
categories:
  - web
---

# Enterprise Web App Patterns

Enterprise Web App patterns provide a structured approach to guide developers and architects through the cloud journey, specifically focusing on web application. It divides into two sub-patterns that align with the principles of the [Well-Architected Framework](/azure/well-architected/pillars). Each represents a step towards a more advanced, efficient, and intelligent web application. These patterns serve as a roadmap, providing prescriptive guidance to help you transform legacy web apps into cloud-optimized solutions that deliver greater business value.

[![Diagram showing the principles of the Reliable Web App](../_images/eap-overview.svg)](../_images/eap-overview.svg#lightbox)

## Reliable Web App pattern

The Reliable Web App pattern details implementation techniques for replatforming your web application to ensure a successful migration to the cloud. It assumes your organization has worked through Cloud Adoption Framework and established a [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/). The Reliable Web App pattern aims provides guidance for migrating web application to the cloud.

>[!div class="nextstepaction"]
>[Reliable web app pattern for .NET](./reliable-web-app/dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable web app pattern for Java](./reliable-web-app/java/plan-implementation.yml)

## Modern web app pattern

The modern web app pattern provides guidance for modernizing web apps in the cloud. It is a follow-up to the reliable web app pattern and provides guidance for the next steps in optimizing applications for cloud environments. Whereas the reliable web app pattern focuses on moving applications from on-premises to the cloud with minimal code changes, the modern web app pattern focuses on guidance for subsequent transformations to more fully realize the value of running applications in the cloud and move towards a micro-service architecture. The modern web app pattern uses the strangler fig pattern to move separable pieces of the solution into stand-alone services that can be versioned and scaled independently. By revisiting application architecture, the modern web app pattern provides improved flexibility and value.

### Why the Modern Web App pattern?

An important part of the modern web app pattern is dividing services according to domain boundaries.

- Dividing a monolithic solution into finer-grained services allows services to version and scale independently.
- A service-oriented architecture allows you to align members of the workload team to different services.
- When load increases, only the services that represent the performance bottleneck need to scale out.
- Decomposing the architecture allows you to choose the operating system choice per service

>[!div class="nextstepaction"]
>[Modern web app pattern for .NET](./modern-web-app/dotnet/plan-implementation.yml)
