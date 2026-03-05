---
title: Networking architecture design
description: Learn about sample architectures, solutions, and guides that can help you explore the various networking services in Azure.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: fcp
---

# Networking architecture design

This article provides information about sample architectures, solutions, and guides that can help you explore networking in Azure.

Designing and implementing Azure networking capabilities is a critical part of your cloud solution. You'll need to make networking design decisions to properly support your workloads and services.

Azure provides a wide range of networking tools and capabilities. These are just some of the key networking services available in Azure:

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Provision private networks, and optionally connect to on-premises datacenters.
- [Azure Virtual WAN](https://azure.microsoft.com/services/virtual-wan). Optimize and automate branch-to-branch connectivity.
- [Azure Private Link](https://azure.microsoft.com/services/private-link). Enable private access to services that are hosted on the Azure platform while keeping your data on the Microsoft network.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall). Provide protection for your Azure Virtual Network resources.
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway). Build highly secure, scalable, highly available web front ends.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute). Create a fast, reliable, and private connection to Azure.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer). Deliver high availability and network performance to your apps.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway). Establish high security cross-premises connectivity.

For information about more Azure networking services, see [Azure networking](https://azure.microsoft.com/product-categories/networking).

## Introduction to networking on Azure

If you're new to networking on Azure, the best way to learn more is with [Microsoft Learn training](/training/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here's a good introduction to Azure networking:

- [Explore Azure networking services](/training/modules/azure-networking-fundamentals)

And here's a comprehensive learning path:

- [Configure and manage virtual networks for Azure administrators](/training/paths/azure-administrator-manage-virtual-networks)

## Path to production

Consider these technologies and solutions as you plan and implement your deployment:

- [Azure Private Link in a hub-and-spoke network](../networking/guide/private-link-hub-spoke-network.md)
- [Recommendations for using availability zones and regions](/azure/well-architected/reliability/regions-availability-zones)
- [Virtual network connectivity options and spoke-to-spoke communication](../reference-architectures/hybrid-networking/virtual-network-peering.yml)
- [Use Azure ExpressRoute with Microsoft Power Platform](/power-platform/guidance/expressroute/overview?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

## Best practices

The [Azure Well-Architected Framework](/azure/well-architected/) is a set of guiding tenets, based on five pillars, that you can use to improve the quality of your architectures. These articles apply the pillars to the use of some Azure networking services:

- [Review of Azure Application Gateway](/azure/architecture/framework/services/networking/azure-application-gateway#securitysecurity)
- [Review of Azure Firewall](/azure/architecture/framework/services/networking/azure-firewall)

The [Cloud Adoption Framework](/azure/cloud-adoption-framework/) is a collection of documentation, implementation guidance, best practices, and tools that are designed to accelerate your cloud adoption. You might find these articles helpful as you plan and implement your networking solution:

- [Connectivity to other cloud providers](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers)
- [Connectivity to Oracle Cloud Infrastructure](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-other-providers-oci)

## Networking architectures

The following sections, organized by category, provide links to sample networking architectures.

### High availability

- [Deploy highly available NVAs](guide/network-virtual-appliance-high-availability.md)
- [Multi-tier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)

### Hybrid networking

- [Design a hybrid Domain Name System solution with Azure](../hybrid/hybrid-dns-infra.yml)
- [Hybrid availability and performance monitoring](../hybrid/hybrid-perf-monitoring.yml)
- [Implement a secure hybrid network](../reference-architectures/dmz/secure-vnet-dmz.yml)

### Hub-and-spoke topology

- [Hub-and-spoke network topology in Azure](../networking/architecture/hub-spoke.yml)
- [Hub-and-spoke network topology with Azure Virtual WAN](../networking/architecture/hub-spoke-virtual-wan-architecture.yml)

### Virtual WAN

- [Global transit network architecture and Virtual WAN](/azure/virtual-wan/virtual-wan-global-transit-network-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Interconnect with China using Azure Virtual WAN and Secure Hub](/azure/virtual-wan/interconnect-china?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Migrate to Azure Virtual WAN](/azure/virtual-wan/migrate-from-hub-spoke-topology?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [SD-WAN connectivity architecture with Azure Virtual WAN](/azure/virtual-wan/sd-wan-connectivity-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Virtual WAN network topology (Microsoft-managed)](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Virtual WAN architecture optimized for department-specific requirements](../networking/architecture/performance-security-optimized-vwan.yml)
- [Hub-and-spoke network topology with Azure Virtual WAN](../networking/architecture/hub-spoke-virtual-wan-architecture.yml)

### Multi-region networking

- [Multi-region load balancing with Azure Traffic Manager and Application Gateway](../high-availability/reference-architecture-traffic-manager-application-gateway.yml)

## Stay current with networking

Get the [latest updates on Azure networking products and features](https://azure.microsoft.com/blog/topics/networking).

## Additional resources

### Example solutions

These are some additional sample networking architectures:

- [Traditional Azure networking topology](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)
- [Network topology and connectivity for Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-network-topology-connectivity?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Private Link and DNS integration at scale](/azure/cloud-adoption-framework/ready/azure-best-practices/private-link-and-dns-integration-at-scale?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Trusted Internet Connection (TIC) 3.0 compliance for internet-facing applications](../example-scenario/security/trusted-internet-connections.yml)

### AWS or Google Cloud professionals

These articles provide service mapping and comparison between Azure and other cloud services. They can help you ramp up quickly on Azure.

- [Compare AWS and Azure networking options](../aws-professional/networking.md) 
- [Google Cloud to Azure services comparison - Networking](../gcp-professional/services.md#networking)
