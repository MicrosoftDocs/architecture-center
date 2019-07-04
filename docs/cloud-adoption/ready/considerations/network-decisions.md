---
title: "Azure readiness networking design decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Azure readiness networking design decisions
author: BrianBlanchard
ms.author: brblanch
ms.date: 05/15/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Networking design decisions

As part of your cloud adoption preparations, design and implementation of Azure networking capabilities are critical to properly supporting your workloads and services to be hosted in the cloud. Azure networking products and services support a wide variety of networking capabilities. How you structure these services and the networking architectures you choose will depend on a combination of your organization's workload, governance, and connectivity requirements.

## Identify workload networking requirements

As part of your landing zone evaluation and preparation, you will want to identify the networking capabilities that your landing zone will need to support. This process involves assessing each of the applications and services that make up your workloads for connectivity network control requirements. Once you've identified and documented these requirements, you can create policies for your landing zone controlling the allowed networking resources and configuration based on your workload needs.

For each of the applications or services you will be deploying to your landing zone environment, use the following decision tree as a starting point when determining the appropriate networking tools or services to use.

![Azure networking services decision tree](../../_images/ready/network-decision-tree.png)

### Key questions

- **Will your workload require a virtual network?** Managed platform as a service (PaaS) resource types make use of underlying platform network capabilities that do not always require the creation of a virtual network. If your workloads do not require more advanced networking features, and you do not need to deploy IaaS resources, the default [native networking capabilities provided by PaaS resources](../../decision-guides/software-defined-network/paas-only.md) may meet your workload's connectivity and traffic management requirements.
- **Will your workload require connectivity between virtual networks and your on-premises datacenter?** Azure provides two solutions for establishing hybrid networking capabilities. [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) connects your on-premises networks to Azure through Site-to-Site VPNs in a similar way that you set up and connect to a remote branch office. VPN Gateway has a maximum bandwidth of 1.25 Gbps. [ExpressRoute](/azure/expressroute/expressroute-introduction) offers higher reliability and lower latency using a private connection between Azure and your on-premises infrastructure, with bandwidth options ranging from 50 Mbps to 100 Gbps.
- **Will you need to inspect and audit outgoing traffic using on-premises network devices?** For cloud-native workloads, [Azure Firewall](/azure/firewall/overview) or cloud-hosted third-party [Network Virtual Appliances (NVAs)](https://azure.microsoft.com/solutions/network-appliances/) can be used to inspect and audit traffic going to or coming from the public Internet. However, many enterprise IT security policies require Internet-bound outgoing traffic pass through centrally managed devices in their on-premises environment. [Forced tunneling](/azure/virtual-network/virtual-networks-udr-overview) supports these forced tunneling scenarios. Not all managed services support forced tunneling, although services like [App Service Environment](/azure/app-service/environment/intro), [API Management](/azure/api-management/api-management-key-concepts), [Azure Kubernetes Services](/azure/aks/intro-kubernetes), [Azure SQL Database managed instance](/azure/sql-database/sql-database-managed-instance-index), [Azure Databricks](/azure/azure-databricks/what-is-azure-databricks), and [Azure HDInsight](/azure/hdinsight/) will support this configuration when deployed inside a virtual network.
- **Will you need to connect multiple virtual networks together?** [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview) allows you to connect Azure virtual networks. Peering can support connections across subscriptions and regions. For scenarios where you are providing shared services across multiple subscriptions or managing large amounts of network peerings, you should consider adopting a [hub and spoke architecture](../../decision-guides/software-defined-network/hub-spoke.md), or using the [Azure vWAN services](/azure/virtual-wan/virtual-wan-about). VNet peering only provides connectivity between the two peered networks, and does not provide transitive connectivity across multiple peerings by default.
- **Will your workloads be accessible over the internet?** Azure provides services designed to help you manage and secure external access to your applications and services:
  - [Azure Firewall](/azure/firewall/overview).
  - [Network appliances](https://azure.microsoft.com/solutions/network-appliances/).
  - [Azure Front Door Service](/azure/frontdoor/front-door-overview).
  - [Application Gateway](/azure/application-gateway/).
  - [Traffic Manager](/azure/traffic-manager/traffic-manager-overview).
- **Will you need to support custom DNS management?** [Azure DNS](/azure/dns/dns-overview) is a hosting service for DNS domains that provides name resolution using Azure infrastructure. If your workloads require name resolution that goes beyond the features provided by Azure DNS, you may need to deploy additional solutions. If your workloads also require Active Directory services, consider using [Azure AD Domain Services](/azure/active-directory-domain-services/overview) to augment Azure DNS' capabilities. For additional capabilities, you can also [deploy custom IaaS virtual machines](/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances) to support your requirements.

## Common networking scenarios

Azure networking is composed of multiple products and services that provide different networking capabilities. As part of your networking design process, you can compare your workload requirements to the networking scenarios in the following table to identify the Azure tools or services you can use to provide these networking capabilities.

| **Scenario** | **Networking product or service** |
| --- | --- |
| Provide the networking infrastructure to connect everything from virtual machines to incoming VPN connections. | [Virtual Network](/azure/virtual-network) |
| Balance inbound and outbound connections and requests to your applications or services. | [Load Balancer](/azure/load-balancer) |
| Optimize delivery from application server farms while increasing application security with a web application firewall. | [Application Gateway](/azure/application-gateway) <br/>[Azure Front Door Service](/azure/frontdoor) |
| Securely use the internet to access Azure Virtual Networks with high-performance VPN gateways. | [VPN Gateway](/azure/vpn-gateway) |
| Ensure ultra-fast DNS responses and ultra-high availability for all your domain needs. | [Azure DNS](/azure/dns) |
| Accelerate the delivery of high-bandwidth content to customers worldwide&mdash;from applications and stored content to streaming video. | [Content Delivery Network](/azure/cdn) |
| Protect your Azure applications from the impacts of DDoS attacks. | [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview) |
| Distribute traffic optimally to services across global Azure regions, while providing high availability and responsiveness. | [Traffic Manager](/azure/traffic-manager)<br/>[Azure Front Door Service](/azure/frontdoor) |
| Add private network connectivity to access Microsoft cloud services from your corporate networks, as if they were on-premises residing in your own datacenter. | [ExpressRoute](/azure/expressroute) |
| Monitor and diagnose conditions at a network scenario level. | [Network Watcher](/azure/network-watcher) |
| Native firewalling capabilities with built-in high availability, unrestricted cloud scalability, and zero maintenance. | [Azure Firewall](/azure/firewall) |
| Connect business offices, retail locations, and sites securely with Virtual WAN, a unified wide-area network portal powered by Azure, and the Microsoft global network. | [Virtual WAN](/azure/virtual-wan) |
| Scalable, security-enhanced delivery point for global microservices-based web applications. | [Azure Front Door Service](/azure/frontdoor) |

## Choose a networking architecture

After identifying the Azure networking services you need to support your workloads, you will also need to design the architecture that will combine these services to provide your landing zone's cloud networking infrastructure. The Cloud Adoption Framework's [Software Defined Networking decision guide](../../decision-guides/software-defined-network/index.md) provides details on some of the most common networking architecture patterns used on Azure. The table below summarizes the primary scenarios these patterns support.

| **Scenario** | **Suggested Architecture**
| --- | --- |
| All of the Azure-hosted workloads deployed to your landing zone will be purely PaaS-based, will not require a virtual network, and are not part of a wider cloud adoption effort that will include IaaS resources. | [PaaS-only](../../decision-guides/software-defined-network/paas-only.md) |
| Your Azure-hosted workloads will deploy IaaS-based resources such as virtual machines or otherwise require a virtual network, but do not require connectivity to your on-premises environment. | [Cloud-native](../../decision-guides/software-defined-network/cloud-native.md) |
| Your Azure-hosted workloads require limited access to on-premises resources, but you are required need to treat cloud connections as untrusted. | [Cloud DMZ](../../decision-guides/software-defined-network/cloud-dmz.md) |
| Your Azure-hosted workloads require limited access to on-premises resources, and you plan to implement mature security policies and secure connectivity between the cloud and your on-premises environment. | [Hybrid](../../decision-guides/software-defined-network/hybrid.md) |
| You need to deploy and manage a large number of VMs and workloads, potentially exceeding [Azure subscription limits](/azure/azure-subscription-service-limits), need to share services across subscriptions, or you need a more segmented structure for role, application, or permission segregation. | [Hub and spoke](../../decision-guides/software-defined-network/hub-spoke.md) |
| You have many branch offices to connect to each other and to Azure. | [Virtual WAN](/azure/virtual-wan/virtual-wan-about) |

### Azure Virtual Datacenter

In addition to these architecture patterns, enterprise IT groups managing large cloud environments should consider consulting the [Azure Virtual Datacenter guidance](../../../vdc/index.md) when designing your Azure-based cloud infrastructure. Azure Virtual Datacenter provides a combined approach to networking, security, management, and infrastructure for organizations that meet the following criteria:

- Your enterprise is subject to regulatory compliance requirements that require centralized monitoring and audit capabilities.
- Your cloud estate will consist of over 10,000 IaaS VMs or an equivalent scale of PaaS services.
- You need to enable agile deployment capabilities for workloads in support of developer and operations teams, while maintaining common policy and governance compliance and central IT control over core services.
- Your industry depends on a complex platform that requires deep domain expertise (for example, finance, oil and gas, or manufacturing).
- Your existing IT governance policies require tighter parity with existing features, even during early stage adoption.

## Follow Azure networking best practices

As part of your networking design process, consult the following articles:

- **[Virtual network planning](/azure/virtual-network/virtual-network-vnet-plan-design-arm?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json)**. Learn how to plan for virtual networks based on your isolation, connectivity, and location requirements.
- **[Azure best practices for network security](/azure/security/azure-security-network-security-best-practices?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json)**. Discusses a collection of Azure best practices to enhance your network security.
- **[Best practices for networking when migrating workloads to Azure](/azure/migrate/migrate-best-practices-networking?toc=https://docs.microsoft.com/azure/architecture/toc.json&bc=https://docs.microsoft.com/azure/architecture/bread/toc.json)**. Provides additional guidance on how to implement Azure networking to support IaaS and PaaS based workloads.