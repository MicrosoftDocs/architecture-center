---
title: Machine Learning model training with AKS
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Machine Learning with AKS
ms.custom: acom-architecture, chat, signalr service, interactive-diagram, devops, microservices, ai-ml, 'https://azure.microsoft.com/solutions/architecture/machine-learning-with-aks/'
ms.service: architecture-center
ms.category:
  - ai-machine-learning
  - containers
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/machine-learning-with-aks.png
---

# Machine Learning model training with AKS

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Training of models using large datasets is a complex and resource intensive task. Use familiar tools such as TensorFlow and Kubeflow to simplify training of Machine Learning models. Your ML models will run in AKS clusters backed by GPU enabled VMs.

## Architecture

![Architecture diagram](../media/machine-learning-with-aks.png)
*Download an [SVG](../media/machine-learning-with-aks.svg) of this architecture.*

## Data Flow

1. Package ML model into a container and publish to ACR
1. Azure Blob storage hosts training data sets and trained model
1. Use Kubeflow to deploy training job to AKS, distributed training job to AKS includes Parameter servers and Worker nodes
1. Serve production model using Kubeflow, promoting a consistent environment across test, control and production
1. AKS supports GPU enabled VM
1. Developer can build features querying the model running in AKS cluster
