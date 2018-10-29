---
title: Bursting from AKS with ACI | Microsoft
description: Bursting from AKS with ACI
author: adamboeglin
ms.date: 10/29/2018
---
# Bursting from AKS with ACI | Microsoft
Use the ACI Connector to provision pods inside ACI that start in seconds. This enables AKS to run with just enough capacity for your average workload. As you run out of capacity inyour AKS cluster, scale out additional pods in ACI without any additional servers to manage.

## Architecture
<img src="media/scale-using-aks-with-aci.svg" alt='architecture diagram' />

## Data Flow
1. User registers container in Azure Container Registry
1. Container images are pulled from the Azure Container Registry
1. ACI connector, a Virtual Kubelet implementation, provisions pods inside ACI fromAKS when traffic comes in spikes.
1. AKS and ACI containers write to shared data store