---
title: AKS triage - cluster health
titleSuffix: Azure Architecture Center
description: Learn to check the overall health of an Azure Kubernetes Service (AKS) cluster, as part of a triage step for AKS clusters.
author: kevingbb
ms.author: pnp
ms.date: 10/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
ms.custom:
  - e2e-aks
---

# Check the AKS cluster health

Start by checking the health of the overall cluster and networking.

_This article is part of a series. Read the introduction [here](aks-triage-practices.md)._

**Tools:**

**AKS Diagnostics**. In Azure portal, navigate to the AKS cluster resource. Select **Diagnose and solve problems**.

![AKS Diagnostics](images/aks-diagnostics.png)

**Diagnostics** shows a list of results from various test runs. If there are any issues found, **More info** can show you information about the underlying issue.

This image indicates that network and connectivity issues are caused by Azure CNI subnet configuration.

![AKS Diagnostics Results - Networking](images/aks-diagnostics-results.svg)

![AKS Diagnostics Results - Networking - Azure CNI](images/aks-diagnostics-network.svg)

To learn more about this feature, see [Azure Kubernetes Service Diagnostics overview](/azure/aks/concepts-diagnostics).

## Next steps

> [!div class="nextstepaction"]
> [Examine the node and pod health](aks-triage-node-health.md)
