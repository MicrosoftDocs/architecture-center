---
title: AKS (Kubernetes) day-2 operations guide
titleSuffix: Azure Architecture Center
description: Learn about Azure Kubernetes Services (AKS) day-2 operations, such as triage, patching, upgrading, and troubleshooting.
author: kevingbb
ms.date: 04/11/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-monitor
ms.custom:
  - e2e-aks
categories:
  - compute
---

# Azure Kubernetes Services (AKS) day-2 operations guide

After you release an Azure Kubernetes Service (AKS)-hosted application, prepare for *day-2 operations*. Day-2 operations include triage, ongoing maintenance of deployed assets, rolling out upgrades, and troubleshooting.

Day-2 operations help you:

- Keep up to date with your service-level agreement (SLA) or service-level objective (SLO) requirements.
- Troubleshoot customer support requests.
- Stay current with the latest platform features and security updates.
- Plan for future growth.

## Prerequisites

The Day-2 operations guide assumes that you've deployed the [Azure Kubernetes Service (AKS) baseline architecture](../../reference-architectures/containers/aks/secure-baseline-aks.yml) as an example of a production cluster.

## Next steps

- [Triage practices for AKS operations](/azure/architecture/operator-guides/aks/aks-triage-practices)
- [Patch and upgrade AKS worker nodes](/azure/architecture/operator-guides/aks/aks-upgrade-practices)
- [Monitoring Azure Kubernetes Service (AKS) with Azure Monitor](/azure/aks/monitor-aks?bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json&toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json)
- [AKS troubleshooting](/azure/aks/troubleshooting?bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json&toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json)
