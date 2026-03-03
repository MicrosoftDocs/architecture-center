---
title: Azure Kubernetes Service (AKS) operations triage
description: Learn about the five articles that describe the triage practices for AKS operations. Get an overview of the top-down triage approach.
author: francisnazareth
ms.author: fnazaret
ms.date: 01/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-aks
  - arb-containers
---

# Triage practices for AKS operations

A root-cause analysis for an Azure Kubernetes Service (AKS) cluster is often challenging. To simplify the process, consider triaging issues by using a top-down approach based on the cluster hierarchy. Start at the cluster level and drill down if necessary.

![Diagram that shows the hierarchy of AKS cluster components: Cluster, node pools, nodes, pods, and containers.](./images/kube-components.svg)

The following section provides an overview of a series about triage practices, which describes the top-down approach in detail. The articles provide examples that use a set of tools and dashboards. The articles describe how these examples highlight symptoms of problems.

Common problems that are addressed in this series include:

- Network and connectivity problems that are caused by improper configuration.
- Broken communication between the control plane and the node.
- Kubelet pressures that are caused by insufficient compute, memory, or storage resources.
- Domain Name System (DNS) resolution problems.
- Nodes that run out of disk input/output operations per second (IOPS).
- An admission control pipeline that blocks several requests to the API server.
- A cluster that doesn't have permissions to pull from the appropriate container registry.

This series isn't intended to resolve specific problems. For information about troubleshooting specific problems, see [AKS troubleshooting](/azure/aks/troubleshooting).

## The triage practices series

|Step|Description|
|---|---|
|[1. Evaluate AKS cluster health](aks-triage-cluster-health.md).|Check the overall health of the cluster and networking.|
|[2. Examine node and pod health](aks-triage-node-health.md). |Evaluate the health of the AKS worker nodes. |
|[3. Monitor workload deployments](aks-triage-deployment.md).|Ensure that all deployments and `DaemonSet` features are running.|
|[4. Validate admission controllers](aks-triage-controllers.md).|Check whether the admission controllers are working as expected.|
|[5. Verify the connection to the container registry](aks-triage-container-registry.md).|Verify the connection to the container registry.|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Kevin Harris](https://www.linkedin.com/in/kevbhar) | Principal Solution Specialist

Other contributors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Customer Engineer
- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Day-2 operations](https://dzone.com/articles/defining-day-2-operations)
- [AKS roadmap](https://aka.ms/aks/roadmap)
- [AKS resources](/azure/aks)
