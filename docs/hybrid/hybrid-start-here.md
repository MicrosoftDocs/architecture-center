---
title: Hybrid architecture design
description: Get an introductory overview of hybrid cloud technologies and how you can connect an on-premises environment to Azure in a way that works best for your organization.
author: martinekuan
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: reference-architecture
ms.date: 07/26/2022
ms.author: architectures
categories:
  - hybrid
  - management-and-governance
ms.custom:
  - fcp
  - reference-architecture
  - e2e-hybrid
products:
  - azure
---

# Hybrid architecture design

Many organizations need a hybrid approach to analytics, automation, and services because their data is hosted both on-premises and in the cloud. Organizations often [extend on-premises data solutions to the cloud](../data-guide/scenarios/hybrid-on-premises-and-cloud.md). To connect environments, organizations start by [choosing a hybrid network architecture](../reference-architectures/hybrid-networking/index.yml).

## Learn about hybrid solutions

If you're new to Azure, the best place to start is Microsoft Learn. This free online platform provides interactive training for Microsoft products and more. The [Introduction to Azure hybrid cloud services](/training/modules/intro-to-azure-hybrid-services/) Learn module helps you build foundational knowledge and understand core concepts.

> [!div class="nextstepaction"]
> [Browse other hybrid solutions in Microsoft Learn training](/search/?terms=hybrid&category=Learn)

## Path to production

Explore some options for [connecting an on-premises network to Azure](../reference-architectures/hybrid-networking/index.yml):

- [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)
- [Extend an on-premises network using ExpressRoute](../reference-architectures/hybrid-networking/expressroute.yml)
- [Connect an on-premises network to Azure using ExpressRoute](../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)

## Best practices

When you adopt a hybrid model, you can choose from multiple solutions to confidently deliver hybrid workloads. See these documents for information on running Azure data services anywhere, modernizing applications anywhere, and managing your workloads anywhere:

- [Azure Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](arc-hybrid-kubernetes.yml)
- [Run containers](hybrid-containers.yml)
- [Use Azure file shares](azure-file-share.yml)
- [Back up files](azure-stack-backup.yml)
- [Manage workloads](hybrid-server-os-mgmt.yml)
- [Monitor performance](hybrid-perf-monitoring.yml)
- [Disaster recovery for Azure Stack Hub VMs](azure-stack-vm-disaster-recovery.yml)

---

## Additional resources

The typical hybrid solution journey ranges from learning how to get started with a hybrid architecture to how to use Azure services in hybrid environments. However, you might also just be looking for additional reference and supporting material to help along the way for your specific situation. See these resources for general information on hybrid architectures:

- [Browse hybrid and multicloud architectures](../browse/index.yml?&azure_categories=hybrid)
- [Troubleshoot a hybrid VPN connection](../reference-architectures/hybrid-networking/troubleshoot-vpn.yml)

### Example solutions

Here are some example implementations to consider:

- [Cross-cloud scaling](../solution-ideas/articles/cross-cloud-scaling.yml)
- [Cross-platform chat](../solution-ideas/articles/cross-platform-chat.yml)
- [Hybrid connections](../solution-ideas/articles/hybrid-connectivity.yml)
- [Unlock legacy data with Azure Stack](../solution-ideas/articles/unlock-legacy-data.yml)
