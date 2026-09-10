---
title: Get Started with Azure Hybrid and Adaptive Cloud Architecture
description: Learn how to plan an Azure hybrid and adaptive cloud architecture across Azure, datacenters, edge locations, and other clouds.
author: neilbird
ms.author: nebird
ms.date: 08/24/2026
ms.topic: concept-article
ms.subservice: category-get-started
ms.category:
  - hybrid
  - management-and-governance
  - networking
ms.custom:
  - arb-hybrid
ai-usage: ai-assisted
---

# Get started with Azure hybrid and adaptive cloud architecture

Hybrid architecture combines services in Azure with infrastructure and workloads in datacenters, at edge locations, and in other clouds. An [adaptive cloud approach](https://azure.microsoft.com/solutions/adaptive-cloud) extends Azure management and governance across these distributed environments. Together, these approaches let you place workloads and data where business and technical requirements dictate.

You can manage supported connected resources through an Azure-hosted control plane. Azure Local disconnected operations instead provides a local control plane with a supported subset of Azure capabilities for environments that can't connect to Azure.

This guide introduces the main architecture patterns and provides a path for planning a hybrid solution. After you establish your requirements, see [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml) to compare services and operating models.

## Hybrid and adaptive cloud concepts

The following diagram shows Azure services across hybrid and distributed environments. Hybrid architectures can use the patterns separately or together. Choose services by workload role and operating location.

:::image type="complex" source="./images/hybrid-choices.svg" lightbox="./images/hybrid-choices.svg" alt-text="Diagram that shows Azure hybrid services by workload role and operating location." border="false":::
   The diagram organizes Azure hybrid services into four columns below a banner that says Services and resources. The Azure-hosted services column covers IaaS, PaaS, SaaS, compute, data, networking, and AI that run in Azure regions. The Azure Arc column covers management of servers, Kubernetes, VMware vSphere, System Center Virtual Machine Manager, SQL Server, and data services across datacenters, edge sites, and other clouds. The edge and IoT services column includes Azure IoT Operations, which processes industrial data on Azure Arc-enabled Kubernetes, and Azure IoT Edge, which runs container modules on device-oriented hardware. The Azure Local column shows your own validated hardware that runs VMs, AKS clusters, Foundry Local (preview), and other supported Azure services in connected and disconnected operating modes.
:::image-end:::

- **Connect to services in Azure.** Run cloud services in Azure regions and connect users, systems, and networks by using [Azure ExpressRoute](/azure/expressroute/expressroute-introduction) for private connectivity or [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) for encrypted internet tunnels between your locations and Azure virtual networks. Workloads and platform services are in Azure, and users or systems access their data planes across the connection. Services include Azure IaaS, PaaS, SaaS, and compute, data, networking, and AI services that run in Azure regions.

- **Extend Azure management to existing infrastructure.** [Azure Arc](/azure/azure-arc/overview)-enabled resources use Azure Resource Manager to manage and govern supported resources outside Azure. You can apply Azure management, governance, security, and deployment practices to distributed infrastructure, while workloads continue to run in their non-Azure locations. Azure Arc can manage supported servers, Kubernetes clusters, VMware vSphere and System Center Virtual Machine Manager, and SQL Server and data services that run in datacenters, edge sites, and other clouds.

- **Operate across edge locations or device hardware.** For new industrial and operational technology (OT) edge-connected solutions, use [Azure IoT Operations](/azure/iot-operations/overview-iot-operations) to process industrial data on edge Kubernetes. For device-focused workloads on constrained or purpose-built hardware, use [Azure IoT Edge](/azure/iot-edge/about-iot-edge) with IoT Hub to deploy and manage containerized modules on device-oriented hardware.

- **Run workloads on Azure Local.** [Azure Local](/azure/azure-local/overview) is the infrastructure foundation for [Microsoft Sovereign Private Cloud](/azure/azure-sovereign-clouds/private/overview/sovereign-private-cloud), a portfolio for sovereign, regulated, and disconnected environments. After you deploy Azure Local, you can run workloads and selected Azure services like virtual machines (VMs), Azure Kubernetes Service (AKS), and selected Azure Arc-enabled services on your own validated hardware in on-premises or edge locations. Azure Local connected deployments use an Azure-hosted control plane, while disconnected operations provide a local control plane for supported scenarios that can't connect to Azure. For AI inference that requires local control or low latency, evaluate [Foundry Local on Azure Local](/azure/azure-sovereign-clouds/private/foundry-local/overview), which is in preview.

These patterns include a [control plane and a data plane](/azure/azure-resource-manager/management/control-plane-and-data-plane). The control plane manages resource configuration and lifecycle. The data plane is where applications process and store business data. Control-plane integration doesn't mean that application data must move to Azure, but management metadata, monitoring data, identity dependencies, and service-specific traffic might cross location or jurisdiction boundaries. Review these flows for each service that you use.

Treat portability and provider dependency as workload-level design decisions. Decide where cloud-neutral designs are necessary and where the capabilities of cloud-specific managed services justify tighter coupling. Document these decisions so that stakeholders understand the tradeoffs among portability, delivery speed, operational complexity, and cost.

## Move from concepts to design

Take the following steps in sequence to develop your architecture:

1. Define a hybrid and multicloud strategy to align the initiative with business outcomes and organizational readiness.
1. Evaluate Azure hybrid options based on workload and data placement, sovereignty, connectivity, infrastructure, ownership, cost, and operational requirements. See [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml) for a decision tree that compares candidate approaches.
1. [Choose a hybrid network architecture](../reference-architectures/hybrid-networking/hybrid-connectivity-options.md) after you identify which of your workloads and management planes need connectivity to Azure.
1. Apply the [Azure Well-Architected Framework](/azure/well-architected/what-is-well-architected-framework) to each workload, including workloads that run outside Azure regions.
1. Use an applicable reference architecture, such as the [Azure Local baseline reference architecture](azure-local-baseline.yml) or [Azure Arc hybrid management and deployment for Kubernetes clusters](arc-hybrid-kubernetes.yml), to develop the implementation design.

## Next step

- For foundational training, see [Introduction to Azure hybrid cloud services](/training/modules/intro-to-azure-hybrid-services/).

## Related resources

- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Connect an on-premises network to Azure](../reference-architectures/hybrid-networking/hybrid-connectivity-options.md)
- [Hybrid and multicloud architectures browser](../browse/index.yml?azure_categories=hybrid)
