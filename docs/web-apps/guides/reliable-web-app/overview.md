---
title: Reliable Web App pattern
description: Learn about the Reliable Web App pattern.
author: stephen-sumner    
ms.author: ssumner
ms.reviewer: ssumner
ms.date: 04/15/2024
ms.topic: azure-guide
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

# Reliable Web App pattern

The Reliable Web App pattern aims to streamline the process of moving web applications to the cloud. It provides a systematic method for quickly adopting cloud technologies for on-premises web applications. Organizations migrating to the cloud should follow the Cloud Adoption Framework and establish a [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) for their web applications. The Reliable Web App pattern details strategies for replatforming your web application to ensure a successful migration to the cloud.

[![Diagram showing the principles of the Reliable Web App](../_images/eap-overview.svg)](../_images/eap-overview.svg#lightbox)

## Principles and implementation techniques

The [Well-Architected Framework](/azure/well-architected/pillars) establishes the overriding principles of the Reliable Web App pattern. The Reliable Web App pattern goes beyond these original principles to derive subordinate principles specific to the process of migrating web apps to the cloud. Within these principles, the Reliable Web App Pattern focuses on making minimal code changes, applying reliability design patterns, and using managed services. It helps you create a web app that is cost optimized, observable, and ingress secure using infrastructure as code and identity-centric security.

| Reliable Web App pattern principles | Implementation techniques |
| --- | --- |
| <br>▪ Minimal code changes<br>▪ Reliability design patterns<br>▪ Managed services<br>▪ Cost optimized<br>▪ Observable<br>▪ Ingress secure<br>▪ Infrastructure as code<br>▪ Identity-centric security|▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsized resources <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Bicep (.NET) and Terraform (Java) deployment <br>▪ Telemetry, logging, monitoring |

## Web app architecture

It's important to note that the Reliable Web App pattern isn't a one-size-fits-all set of services or a specific architecture. The unique needs of your business and the characteristics of your existing web application are crucial in determining the most suitable architecture and network topology.

## Next steps

There's Reliable Web App pattern guidance for .NET and Java web applications. Use the guidance and reference implementations to accelerate your move to Azure.

>[!div class="nextstepaction"]
>[Reliable Web App pattern for .NET](./dotnet/plan-implementation.yml)

>[!div class="nextstepaction"]
>[Reliable Web App pattern for Java](./java/plan-implementation.yml)
