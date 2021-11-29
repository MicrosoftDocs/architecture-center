---
title: Azure Stack Hub and operational excellence
description: Focuses on the Azure Stack Hub service used in the Hybrid solution to provide best-practice, configuration recommendations, and design considerations related to operational excellence.
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

# Azure Stack Hub and operational excellence

[Azure Stack Hub](/azure-stack/operator/?view=azs-2102&preserve-view=true) is a hybrid cloud platform that lets you provide Azure services from your datacenter. It provides a way to run apps in an on-premises environment.

This service unlocks the following hybrid cloud use cases for customer-facing and internal line-of-business apps:

- *Edge and disconnected solutions*: Addresses latency and connectivity requirements by processing data locally.
- *Cloud apps that meet varied regulations*: Allows you to develop and deploy apps with full flexibility to meet regulatory or policy requirements.
- *Cloud app model on-premises*: Provides Azure services, containers, serverless, and microservice architectures to update and extend existing apps or build new ones.

For more information, reference [Azure Stack Hub overview](/azure-stack/operator/azure-stack-overview?view=azs-2102&preserve-view=true).

To understand how Azure Stack Hub supports operational excellence for your application workload, reference the following articles:

- [Monitor health and alerts in Azure Stack Hub](/azure-stack/operator/azure-stack-monitor-health?view=azs-2102&preserve-view=true)
- [Monitor Azure Stack Hub hardware components](/azure-stack/operator/azure-stack-hardware-monitoring?view=azs-2102&preserve-view=true)
- [Manage network resources in Azure Stack Hub](/azure-stack/operator/azure-stack-viewing-public-ip-address-consumption?view=azs-2102&preserve-view=true)

The following sections include design considerations, a configuration checklist, and recommended configuration options specific to Azure Stack Hub and operational excellence.

## Design considerations

Azure Stack Hub includes the following design considerations:

- Microsoft doesn't provide an SLA for Azure Stack Hub because Microsoft doesn't have control over customer datacenter reliability, people, and processes.
- Azure Stack Hub only supports a single Scale Unit (SU) within a single region, which consists of between four and 16 servers that use Hyper-V failover clustering. Each region serves as an independent Azure Stack Hub *stamp* with separate portal and API endpoints.
- Azure Stack Hub doesn't support Availability Zones because it consists of a single *region* or a single physical location. High availability to cope with outages of a single location should be implemented by using two Azure Stack Hub instances deployed in different physical locations.
- Apply general Azure configuration recommendations for all Azure Stack Hub services.

## Checklist

**Have you configured Azure Stack Hub with operational excellence in mind?**

> [!div class="checklist"]
> - Treat Azure Stack Hub as a scale unit and deploy multiple instances to remove Azure Stack Hub as a single point of failure for encompassed workloads.

## Configuration recommendations

Consider the following recommendation table to optimize your Azure Stack Hub configuration for operational excellence:

|Recommendation|Description|
|--------------|-----------|
|Treat Azure Stack Hub as a scale unit and deploy multiple instances to remove Azure Stack Hub as a single point of failure for encompassed workloads.|Deploy workloads in either an active-active or active-passive configuration across Azure Stack Hub stamps or Azure.|

## Next step

> [!div class="nextstepaction"]
> [Storage Accounts and reliability](../../storage/storage-accounts/reliability.md)
