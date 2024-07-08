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

Enterprise Web App patterns provide a structured approach to guide developers and architects through the cloud journey, specifically focusing on web application. It divides into distinct phases, called web app patterns. Each represents a common business goals and step towards a more advanced web application. The web app patterns provide prescriptive architecture, code, and configuration guidance that align with the principles of the [Well-Architected Framework](/azure/well-architected/pillars).

These patterns serve as a roadmap to help you transform legacy web apps into cloud-optimized solutions that deliver greater business value. The guidance provided by the Enterprise Web App patterns is instrumental in ensuring a smooth and successful transition through the cloud journey.

[![Diagram showing the stages of the Enterprise Web App patterns](../_images/ewap-overview.svg)](../_images/ewap-overview.svg#lightbox)
*Figure 1. Overview of the Enterprise Web App patterns.*

## Reliable Web App pattern

The Reliable Web App pattern is designed for organizations that are transitioning their on-premises web applications to the cloud. This pattern provides detailed, prescriptive guidance on how to modify your web application’s architecture and code base to ensure success in the cloud.

Instead of undertaking a time-consuming rebuilding process, this pattern enables a swift adoption of the cloud. It does this by emphasizing the crucial changes that need to be made, rather than all possible changes. The focus is on updates that provide high value and require minimal code changes, allowing for a quick replatforming of your application.

This pattern assumes your organization has an established [landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) for the web app, providing a solid foundation for cloud deployment.

>[!div class="nextstepaction"]
>[Reliable Web App pattern for .NET](./reliable-web-app/dotnet/guidance.yml)

>[!div class="nextstepaction"]
>[Reliable Web App pattern for Java](./reliable-web-app/java/guidance.yml)

## Modern Web App pattern

The Modern Web App pattern is designed for organizations that already have a web application in the cloud and are seeking strategic modernizations to enhance performance and optimize costs. This pattern offers prescriptive guidance for targeted modernization of cloud-based web applications.

The focus of this pattern is on refactoring areas of high demand by gradually decoupling them into standalone services. This allows for independent versioning and scaling. This strategy not only optimizes performance in a cost-efficient way but also serves as a transitional step between monolithic and microservices architectures.

By facilitating independent development and flexible deployments, this pattern accelerates development cycles and boosts the overall performance of the application.

>[!div class="nextstepaction"]
>[Modern Web App pattern for .NET](./modern-web-app/dotnet/guidance.yml)
