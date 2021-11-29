---
title: Azure Stack Hub and reliability
description: Focuses on the Azure Stack Hub service used in the Hybrid solution to provide best-practice, configuration recommendations, and design considerations related to Reliability.
author: v-stacywray
ms.date: 11/29/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-stack-hub
categories:
  - hybrid
  - management-and-governance
---

# Azure Stack Hub and reliability

[Azure Stack Hub](/azure-stack/operator/?view=azs-2102&preserve-view=true) is a hybrid cloud platform that lets you provide Azure services from your datacenter. It provides a way to run apps in an on-premises environment.

This service unlocks the following hybrid cloud use cases for customer-facing and internal line-of-business apps:

- *Edge and disconnected solutions*: Addresses latency and connectivity requirements by processing data locally.
- *Cloud apps that meet varied regulations*: Allows you to develop and deploy apps with full flexibility to meet regulatory or policy requirements.
- *Cloud app model on-premises*: Provides Azure services, containers, serverless, and microservice architectures to update and extend existing apps or build new ones.

For more information, reference [Azure Stack Hub overview](/azure-stack/operator/azure-stack-overview?view=azs-2102&preserve-view=true).

To understand how Azure Stack Hub supports resiliency for your application workload, reference the following articles:

- [Capacity planning for Azure Stack Hub overview](/azure-stack/operator/azure-stack-capacity-planning-overview?view=azs-2102&preserve-view=true)
- [Storage Spaces Direct cache and capacity tiers](/azure-stack/operator/azure-stack-capacity-planning-storage?view=azs-2102#storage-spaces-direct-cache-and-capacity-tiers&preserve-view=true)
- [Datacenter integration planning considerations for Azure Stack Hub integrated systems](/azure-stack/operator/azure-stack-datacenter-integration?view=azs-2102&preserve-view=true)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Stack Hub and reliability.

## Design considerations