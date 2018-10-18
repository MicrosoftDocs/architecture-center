---
title: Machine Learning model training with AKS | Microsoft
description: Machine Learning with AKS
author: adamboeglin
ms.date: 10/18/2018
---
# Machine Learning model training with AKS | Microsoft
Training of models using large datasets is a complex and resource intensive task. Use familiar tools such as TensorFlow and Kubeflow to simplify training of Machine Learning models. Your ML models will run in AKS clusters backed by GPU enabled VMs.

## Architecture
<img src="media/machine-learning-with-aks.svg" alt='architecture diagram' />

## Data Flow
1. Data scientist builds ML Model (or uses a publicly available model).
1. Data scientist publishes model to a container. Container image is pushed to the Azure Container Registry.
1. Training dataset is loaded into Azure files and training job is deployed to AKS using Kubeflow.
1. Distributed training job to AKS includes Parameter servers and Worker nodes.
1. Trained model is stored in Azure files.
1. The data scientist introspects the training using TensorBoard deployed by Kubeflow. If all looks good, data scientist can serve the trained model using Kubeflow.