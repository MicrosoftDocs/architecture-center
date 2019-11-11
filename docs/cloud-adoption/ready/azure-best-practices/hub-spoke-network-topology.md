---
title: "Hub-and-spoke network topology"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Hub-and-spoke network topology
author: tracsman
ms.author: jonor
ms.date: 05/10/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: ready
manager: rossort
tags: azure-resource-manager
ms.custom: virtual-network
---

# Hub-and-spoke network topology

*Hub and spoke* is a networking model for more efficient management of common communication or security requirements. It also helps avoid Azure subscription limitations. This model addresses the following concerns:

- **Cost savings and management efficiency**. Centralizing services that can be shared by multiple workloads, such as network virtual appliances (NVAs) and DNS servers, in a single location allows IT to minimize redundant resources and management effort.
- **Overcoming subscriptions limits**. Large cloud-based workloads might require the use of more resources than are allowed in a single Azure subscription. (See [subscription limits][Limits].) Peering workload virtual networks from different subscriptions to a central hub can overcome these limits.
- **Separation of concerns**. You can deploy individual workloads between central IT teams and workload teams.

Smaller cloud estates might not benefit from the added structure and capabilities that this model offers. But larger cloud adoption efforts should consider implementing a hub-and-spoke networking architecture if they have any of the concerns listed previously.

> [!NOTE]
> The Azure Reference Architectures site contains example templates that you can use as the basis for implementing your own hub-and-spoke networks:
>
> - [Implement a hub-and-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
> - [Implement a hub-and-spoke network topology with shared services in Azure](/azure/architecture/reference-architectures/hybrid-networking/shared-services)

## Overview

![Examples of a hub-and-spoke network topology][1]

As shown in the diagram, Azure supports two types of hub-and-spoke design. It supports communication, shared resources, and centralized security policy ("VNet Hub" in the diagram), or a virtual WAN type ("Virtual WAN" in the diagram) for large-scale branch-to-branch and branch-to-Azure communications.

A hub is a central network zone that controls and inspects ingress or egress traffic between zones: internet, on-premises, and spokes. The hub-and-spoke topology gives your IT department an effective way to enforce security policies in a central location. It also reduces the potential for misconfiguration and exposure.

The hub often contains the common service components that the spokes consume. The following examples are common central services:

- The Windows Server Active Directory infrastructure, required for user authentication of third parties that gain access from untrusted networks before they get access to the workloads in the spoke. It includes the related Active Directory Federation Services (AD FS).
- A DNS service to resolve naming for the workload in the spokes, to access resources on-premises and on the internet if [Azure DNS][DNS] isn't used.
- A public key infrastructure (PKI), to implement single sign-on on workloads.
- Flow control of TCP and UDP traffic between the spoke network zones and the internet.
- Flow control between the spokes and on-premises.
- If needed, flow control between one spoke and another.

You can minimize redundancy, simplify management, and reduce overall cost by using the shared hub infrastructure to support multiple spokes.

The role of each spoke can be to host different types of workloads. The spokes also provide a modular approach for repeatable deployments of the same workloads. Examples are dev and test, user acceptance testing, preproduction, and production.

The spokes can also segregate and enable different groups within your organization. An example is Azure DevOps groups. Inside a spoke, it's possible to deploy a basic workload or complex multitier workloads with traffic control between the tiers.

## Subscription limits and multiple hubs

In Azure, every component, whatever the type, is deployed in an Azure subscription. The isolation of Azure components in different Azure subscriptions can satisfy the requirements of different lines of business, such as setting up differentiated levels of access and authorization.

A single hub-and-spoke implementation can scale up to a large number of spokes. But as with every IT system, there are platform limits. The hub deployment is bound to a specific Azure subscription, which has restrictions and limits. (An example is a maximum number of virtual network peerings. See [Azure subscription and service limits, quotas, and constraints][Limits] for details).

In cases where limits might be an issue, you can scale up the architecture further by extending the model from a single hub and spoke to a cluster of hubs and spokes. You can interconnect multiple hubs in one or more Azure regions by using virtual network peering, Azure ExpressRoute, a virtual WAN, or a site-to-site VPN.

![Cluster of hubs and spokes][2]

The introduction of multiple hubs increases the cost and management overhead of the system. This is only justified by scalability, system limits, or redundancy and regional replication for user performance or disaster recovery. In scenarios that require multiple hubs, all the hubs should strive to offer the same set of services for operational ease.

## Interconnection between spokes

It's possible to implement complex multitier workloads in a single spoke. You can implement multitier configurations by using subnets (one for every tier) in the same virtual network and by using network security groups to filter the flows.

An architect might want to deploy a multitier workload across multiple virtual networks. With virtual network peering, spokes can connect to other spokes in the same hub or in different hubs.

A typical example of this scenario is the case where application processing servers are in one spoke or virtual network. The database deploys in a different spoke or virtual network. In this case, it's easy to interconnect the spokes with virtual network peering and avoid transiting through the hub. The solution is to perform a careful architecture and security review to ensure that bypassing the hub doesn’t bypass important security or auditing points that might exist only in the hub.

![Spokes connecting to each other and a hub][3]

Spokes can also be interconnected to a spoke that acts as a hub. This approach creates a two-level hierarchy: the spoke in the higher level (level 0) becomes the hub of lower spokes (level 1) of the hierarchy. The spokes of a hub-and-spoke implementation are required to forward the traffic to the central hub so that the traffic can transit to its destination in either the on-premises network or the public internet. An architecture with two levels of hubs introduces complex routing that removes the benefits of a simple hub-and-spoke relationship.

<!-- images -->

[0]: ./images/network-redundant-equipment.png "Examples of component overlap"
[1]: ./images/network-hub-spoke-high-level.png "High-level example of hub and spoke"
[2]: ./images/network-hub-spokes-cluster.png "Cluster of hubs and spokes"
[3]: ./images/network-spoke-to-spoke.png "Spoke-to-spoke"
[4]: ./images/network-hub-spoke-block-level-diagram.png "Block-level diagram of the hub and spoke"
[5]: ./images/network-users-groups-subsciptions.png "Users, groups, subscriptions, and projects"
[6]: ./images/network-infrastructure-high-level.png "High-level infrastructure diagram"
[7]: ./images/network-highlevel-perimeter-networks.png "High-level infrastructure diagram"
[8]: ./images/network-vnet-peering-perimeter-neworks.png "Virtual network peering and perimeter networks"
[9]: ./images/network-high-level-diagram-monitoring.png "High-level diagram for monitoring"
[10]: ./images/network-high-level-workloads.png "High-level diagram for workload"

<!-- links -->

[Limits]: /azure/azure-subscription-service-limits
[Roles]: /azure/role-based-access-control/built-in-roles
[VNet]: /azure/virtual-network/virtual-networks-overview
[network-security-groups]: /azure/virtual-network/virtual-networks-nsg
[DNS]: /azure/dns/dns-overview
[PrivateDNS]: /azure/dns/private-dns-overview
[VNetPeering]: /azure/virtual-network/virtual-network-peering-overview
[user-defined-routes]: /azure/virtual-network/virtual-networks-udr-overview
[RBAC]: /azure/role-based-access-control/overview
[azure-ad]: /azure/active-directory/active-directory-whatis
[VPN]: /azure/vpn-gateway/vpn-gateway-about-vpngateways
[ExR]: /azure/expressroute/expressroute-introduction
[ExRD]: /azure/expressroute/expressroute-erdirect-about
[vWAN]: /azure/virtual-wan/virtual-wan-about
[NVA]: /azure/architecture/reference-architectures/dmz/nva-ha
[AzFW]: /azure/firewall/overview
[SubMgmt]: /azure/architecture/cloud-adoption/appendix/azure-scaffold
[RGMgmt]: /azure/azure-resource-manager/resource-group-overview
[DMZ]: /azure/best-practices-network-security
[ALB]: /azure/load-balancer/load-balancer-overview
[PIP]: /azure/virtual-network/resource-groups-networking#public-ip-address
[AFD]: /azure/frontdoor/front-door-overview
[AppGW]: /azure/application-gateway/application-gateway-introduction
[WAF]: /azure/application-gateway/application-gateway-web-application-firewall-overview
[Monitor]: /azure/monitoring-and-diagnostics/
[ActLog]: /azure/monitoring-and-diagnostics/monitoring-overview-activity-logs
[DiagLog]: /azure/monitoring-and-diagnostics/monitoring-overview-of-diagnostic-logs
[nsg-log]: /azure/virtual-network/virtual-network-nsg-manage-log
[OMS]: /azure/operations-management-suite/operations-management-suite-overview
[NPM]: /azure/log-analytics/log-analytics-network-performance-monitor
[NetWatch]: /azure/network-watcher/network-watcher-monitoring-overview
[WebApps]: /azure/app-service/
[HDI]: /azure/hdinsight/hdinsight-hadoop-introduction
[EventHubs]: /azure/event-hubs/event-hubs-what-is-event-hubs
[ServiceBus]: /azure/service-bus-messaging/service-bus-messaging-overview
[traffic-manager]: /azure/traffic-manager/traffic-manager-overview
