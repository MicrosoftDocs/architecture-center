---
title: Hybrid architecture design
description: Get an introductory overview of hybrid cloud technologies and how you can connect an on-premises environment to Azure in a way that works best for your organization.
author: claytonsiemens77
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/26/2022
ms.author: pnp
ms.custom:
  - e2e-hybrid
  - arb-hybrid
---

# Hybrid architecture design

Many organizations need a hybrid approach to analytics, automation, and services because their data is hosted both on-premises and in the cloud. Organizations often extend on-premises data solutions to the cloud. To connect environments, organizations start by [choosing a hybrid network architecture](../reference-architectures/hybrid-networking/index.yml).

## Learn about hybrid solutions

If you're new to Azure, the best place to start is Microsoft Learn. This free online platform provides interactive training for Microsoft products and more. The [Introduction to Azure hybrid cloud services](/training/modules/intro-to-azure-hybrid-services/) Learn module helps you build foundational knowledge and understand core concepts.

> [!div class="nextstepaction"]
> [Browse other hybrid solutions in Microsoft Learn training](/search/?terms=hybrid&category=Learn)

## Path to production

Explore some options for [connecting an on-premises network to Azure](../reference-architectures/hybrid-networking/index.yml):

- [Extend an on-premises network using VPN](/azure/expressroute/expressroute-howto-coexist-resource-manager)
- [Connect an on-premises network to Azure using ExpressRoute](../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)

## Best practices

When you adopt a hybrid model, you can choose from multiple solutions to confidently deliver hybrid workloads. See these documents for information on running Azure data services anywhere, modernizing applications anywhere, and managing your workloads anywhere:

- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Azure Arc hybrid management and deployment for Kubernetes clusters](arc-hybrid-kubernetes.yml)
- [Use Azure file shares](azure-file-share.yml)
- [Back up files](/azure/backup/backup-mabs-files-applications-azure-stack)
- [Monitor performance](hybrid-perf-monitoring.yml)
- [Enable virtual machine protection in Azure Site Recovery](/azure-stack/operator/protect-virtual-machines)

## Additional resources

The typical hybrid solution journey ranges from learning how to get started with a hybrid architecture to how to use Azure services in hybrid environments. However, you might also just be looking for additional reference and supporting material to help along the way for your specific situation. See these resources for general information on hybrid architectures:

- [Browse hybrid and multicloud architectures](../browse/index.yml?&azure_categories=hybrid)
- [Troubleshoot a hybrid VPN connection](../reference-architectures/hybrid-networking/troubleshoot-vpn.yml)

### Example solutions

Here are some example implementations to consider:

- [Cross-cloud scaling](/azure/adaptive-cloud/app-solutions/pattern-cross-cloud-scale)
- [Hybrid connections](/azure/app-service/app-service-hybrid-connections)
