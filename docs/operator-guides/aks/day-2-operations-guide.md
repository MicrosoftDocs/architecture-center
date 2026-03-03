---
title: AKS (Kubernetes) day-2 operations guide
description: Learn about Azure Kubernetes Services (AKS) day-2 operations, such as triage, patching, upgrading, and troubleshooting.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Azure Kubernetes Services (AKS) day-2 operations guide

After you release an Azure Kubernetes Service (AKS)-hosted application, prepare for *day-2 operations*. Day-2 operations include triage, ongoing maintenance of deployed assets, rolling out upgrades, and troubleshooting.

Day-2 operations help you:

- Keep up to date with your service-level agreement (SLA) or service-level objective (SLO) requirements.
- Troubleshoot customer support requests.
- Stay current with the latest platform features and security updates.
- Plan for future growth.

## Prerequisites

The Day-2 operations guide assumes that you deployed the [Azure Kubernetes Service (AKS) baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks) as an example of a production cluster.

## Contributors

*Microsoft maintains this article. The following contributors originally wrote it.*

Principal author:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

> [!div class="nextstepaction"]
> [Triage practices for AKS operations](./aks-triage-practices.md)

### Other articles in this series

- [Patch and upgrade AKS worker nodes](./aks-upgrade-practices.md)
- [Troubleshoot AKS networking](./troubleshoot-network-aks.md)
- [Monitoring Azure Kubernetes Service (AKS) with Azure Monitor](/azure/aks/monitor-aks?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [AKS troubleshooting](/azure/aks/troubleshooting?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
