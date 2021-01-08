---
title: Azure Kubernetes Service (AKS) Day-2 Operations Guide
titleSuffix: Azure Architecture Center
description: Learn about day-2 AKS operations like triage, patching, and upgrading.
author: kevingbb
ms.date: 01/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice:
---


# Azure Kubernetes Services (AKS) Day-2 Operations Guide

After you release an Azure Kubernetes Service (AKS)-hosted application, prepare for *day-2 operations*. Day-2 operations include triage, ongoing maintenance of deployed assets, and rolling out upgrades.

Day-2 operations help you:

- Keep up to date with your service-level agreement (SLA) or service-level objective (SLO) requirements.
- Troubleshoot customer support requests.
- Stay current with the latest platform features and security updates.
- Plan for future growth. 

## Prerequisites

The Day-2 Operations Guide assumes that you've deployed the [Azure Kubernetes Service (AKS) Baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml) architecture as an example of a production cluster.

## In this guide

- [AKS cluster triage practices](aks-triage-practices.md)
- [Patching and upgrade processes](aks-upgrade-practices.md)
