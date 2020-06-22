---
title: Lift and shift to containers with AKS
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Lift and shift to containers with AKS
ms.custom: acom-architecture, app-dev, devops, chat, signalr service, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/migrate-existing-applications-with-aks/'
ms.service: architecture-center
ms.category:
  - migration
  - containers
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/migrate-existing-applications-with-aks.png
---

# Lift and shift to containers with AKS

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Easily migrate existing application to container(s) and run within the Azure managed Kubernetes service (AKS). Control access via integration with Azure Active Directory and access SLA-backed Azure Services such as Azure Database for MySQL using OSBA (Open Service Broker for Azure) for your data needs.

## Architecture

![Architecture Diagram](../media/migrate-existing-applications-with-aks.png)
*Download an [SVG](../media/migrate-existing-applications-with-aks.svg) of this architecture.*

## Data Flow

1. User converts existing application to container(s) &amp; publishes container image(s)to the Azure Container Registry
1. Using Azure Portal or command line, user deploys containers to AKS cluster
1. Azure Active Directory is used to control access to AKS resources
1. Easily access SLA-backed Azure Services such as Azure Database for MySQL using OSBA (Open Service Broker for Azure)
1. Optionally, AKS can be deployed with a VNET virtual network
