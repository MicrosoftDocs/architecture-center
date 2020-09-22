---
title: Bursting from AKS with ACI
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Bursting from AKS with ACI
ms.custom: acom-architecture, devops, kubernetes, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/scale-using-aks-with-aci/'
ms.service: architecture-center
ms.category:
  - containers
  - devops
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/scale-using-aks-with-aci.png
---

# Bursting from AKS with ACI

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Use the AKS virtual node to provision pods inside ACI that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity in your AKS cluster, scale out additional pods in ACI without any additional servers to manage.

## Architecture

![Architecture Diagram](../media/scale-using-aks-with-aci.png)
*Download an [SVG](../media/scale-using-aks-with-aci.svg) of this architecture.*

## Data Flow

1. User registers container in Azure Container Registry
1. Container images are pulled from the Azure Container Registry
1. AKS virtual node, a Virtual Kubelet implementation, provisions pods inside ACI from AKS when traffic comes in spikes.
1. AKS and ACI containers write to shared data store
