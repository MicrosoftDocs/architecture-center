---
title: Microservices with AKS
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Microservices with AKS
ms.custom: acom-architecture, microservices, devops, kubernetes, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/microservices-with-aks/'
ms.service: architecture-center
ms.category:
  - containers
  - devops
  - developer-tools
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/microservices-with-aks.png
---

# Microservices with AKS

[!INCLUDE [header_file](../header.md)]

Use AKS to simplify the deployment and management of microservices based architecture. AKS streamlines horizontal scaling, self-healing, load balancing, secret management.

## Architecture

![Architecture Diagram](../media/microservices-with-aks.png)
*Download an [SVG](../media/microservices-with-aks.svg) of this architecture.*

## Data Flow

1. Developer uses IDE such as Visual Studio to commit changes to GitHub
1. GitHub triggers a new build on Azure DevOps
1. Azure DevOps packages microservices as containers and pushes them to the Azure Container Registry
1. Containers are deployed to AKS cluster
1. Users access services via apps and website
1. Azure Active Directory is used to secure access to the resources
1. Microservices use databases to store and retrieve information
1. Administrator accesses via a separate admin portal
