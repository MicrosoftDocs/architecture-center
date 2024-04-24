---
title: Enterprise App Patterns
description: Learn about Enterprise App Patterns.
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


# Enterprise App Patterns

Enterprise App Patterns provides prescriptive guidance and reference implementations to help developers and architects modernize critical workloads on Azure. They build on the principles of the [Well-Architected Framework](/azure/well-architected/pillars) and guides you to build reliable, secure, cost-optimized, operationally excellent, and performant applications. Enterprise App Patterns consists of two

[![Diagram showing the principles of the Reliable Web App](../_images/eap-overview.svg)](../_images/eap-overview.svg#lightbox)

The Enterprise App Patterns aren't a set of architectures. The patterns help you define the architecture your business needs and provide the  guidance needed to maximize on the benefits of the cloud. The unique needs of your business and the characteristics of your existing web application are crucial in determining the most suitable architecture and network topology.

## Reliable Web App pattern

The Reliable Web App pattern aims provides essential guidance for migrating web application to the cloud. It assumes your organization has worked through Cloud Adoption Framework and established a [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/). The Reliable Web App pattern details implementation techniques for replatforming your web application to ensure a successful migration to your landing zone. These implementation techniques support three key objectives: minimal code changes, reliability design patterns, and managed services.

| Reliable Web App pattern objectives | Implementation techniques |
| --- | --- |
| <br>▪ Minimal code changes<br>▪ Improved reliability<br>▪ Adopt managed services<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Bicep (.NET) and Terraform (Java) deployment <br>▪ Telemetry, logging, monitoring |

>[!div class="nextstepaction"]
>[Reliable web app pattern for .NET](./reliable-web-app/dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable web app pattern for Java](./reliable-web-app/java/plan-implementation.yml)

## Modern web app pattern

The modern web app pattern provides guidance for modernizing web apps in the cloud. It is a follow-up to the reliable web app pattern and provides guidance for the next steps in optimizing applications for cloud environments. Whereas the reliable web app pattern focuses on moving applications from on-premises to the cloud with minimal code changes, the modern web app pattern focuses on guidance for subsequent transformations to more fully realize the value of running applications in the cloud and move towards a micro-service architecture. The modern web app pattern uses the strangler fig pattern to move separable pieces of the solution into stand-alone services that can be versioned and scaled independently. By revisiting application architecture, the modern web app pattern provides improved flexibility and value.

The overriding principles of the modern web app pattern are those articulated by the Well Architected Framework – resiliency, security, operational excellence, performance, and cost optimization. But the modern web app pattern goes beyond these original principles to derive additional subordinate principles specific to the process of transforming an existing application to be more service oriented.

### Principles and implementation techniques

| Modern web app pattern objectives | 

- Separation of concerns with independent versioning and scaling

- Asynchronous communication

- Fine-grained scalability

- Data autonomy

These principles are implemented with the following patterns:

- Strangler fig

- Queue-based load leveling

- Competing consumers

- Automatic horizontal scaling

- Health endpoint monitoring

- Containerized service deployment

Note that these principles and patterns are in addition to some articulated in the reliable web app pattern. Like the reliable web app pattern, the modern web app pattern adheres to principles of infrastructure as code, identity-centric security, and ingress security. Therefore, it also implements patterns familiar from the reliable web app: managed identities, private endpoints, secure secret management, and bicep deployment.

>[!div class="nextstepaction"]
>[Modern web app pattern for .NET](./modern-web-app/dotnet/plan-implementation.yml)
