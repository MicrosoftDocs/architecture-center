---
title: "Hub and spoke network topology"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Hub and spoke network topology
author: tracsman
ms.author: jonor
ms.date: 05/10/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
manager: rossort
tags: azure-resource-manager
ms.custom: virtual-network
---

# Hub and spoke network topology

*Hub and spoke* is a networking model for more efficient management of common communication or security requirements. It also helps avoid Azure subscription limitations. This model addresses the following concerns:

- **Cost savings and management efficiency**. Centralizing services that can be shared by multiple workloads, such as network virtual appliances (NVAs) and DNS servers, in a single location allows IT to minimize redundant resources and management effort across multiple workloads.
- **Overcoming subscriptions limits**. Large cloud-based workloads may require the use of more resources than are allowed within a single Azure subscription (see [subscription limits][Limits]). Peering workload virtual networks from different subscriptions to a central hub can overcome these limits.
- **Separation of concerns**. The ability to deploy individual workloads between central IT teams and workloads teams.

Smaller cloud estates may not benefit from the added structure and capabilities offered by this model. However, larger cloud adoption efforts affected by any of the issues listed above should consider implementing a hub and spoke networking architecture as discussed in this article.  

> [!NOTE]
> The Azure Reference Architectures site contains example templates you can use as the basis for implementing your own hub and spoke networks:
>
> - [Implement a hub and spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
> - [Implement a hub and spoke network topology with shared services in Azure](/azure/architecture/reference-architectures/hybrid-networking/shared-services)

## Overview

![1][1]

As shown, two types of hub and spoke design can be used in Azure. For communication, shared resources, and centralized security policy (VNet Hub in the diagram), or a Virtual WAN type (Virtual WAN in the diagram) for large scale branch-to-branch and branch-to-Azure communications.

A hub is a central network zone that controls and inspects ingress or egress traffic between different zones: internet, on-premises, and the spokes. The hub and spoke topology gives your IT department an effective way to enforce security policies in a central location. It also reduces the potential for misconfiguration and exposure.

The hub often contains the common service components consumed by the spokes. The following examples are common central services:

- The Windows Active Directory infrastructure, required for user authentication of third parties that access from untrusted networks before they get access to the workloads in the spoke. It includes the related Active Directory Federation Services (AD FS).
- A DNS service to resolve naming for the workload in the spokes, to access resources on-premises and on the internet if [Azure DNS][DNS] isn't used.
- A public key infrastructure (PKI), to implement single sign-on on workloads.
- Flow control of TCP and UDP traffic between the spoke network zones and the internet.
- Flow control between the spokes and on-premises.
- If needed, flow control between one spoke and another.

You can minimize redundancy, simplify management, and reduce overall cost by using the shared hub infrastructure to support multiple spokes.

The role of each spoke can be to host different types of workloads. The spokes also provide a modular approach for repeatable deployments of the same workloads. Examples are dev and test, user acceptance testing, preproduction, and production. The spokes can also segregate and enable different groups within your organization. An example is Azure DevOps groups. Inside a spoke, it's possible to deploy a basic workload or complex multitier workloads with traffic control between the tiers.

## Subscription limits and multiple hubs

In Azure, every component, whatever the type, is deployed in an Azure Subscription. The isolation of Azure components in different Azure subscriptions can satisfy the requirements of different LOBs, such as setting up differentiated levels of access and authorization.

A single hub and spoke implementation can scale up to a large number of spokes, although, as with every IT system, there are platform limits. The hub deployment is bound to a specific Azure subscription, which has restrictions and limits (for example, a max number of VNet peerings - see [Azure subscription and service limits, quotas, and constraints][Limits] for details). In cases where limits may be an issue, the architecture can scale up further by extending the model from a single hub-spokes to a cluster of hub and spokes. Multiple hubs in one or more Azure regions can be interconnected using VNet Peering, ExpressRoute, Virtual WAN, or site-to-site VPN.

![2][2]

The introduction of multiple hubs increases the cost and management overhead of the system. This is only justified by scalability, system limits, or redundancy and regional replication for end-user performance or disaster recovery. In scenarios requiring multiple hubs, all the hubs should strive to offer the same set of services for operational ease.

## Interconnection between spokes

Inside a single spoke, it is possible to implement complex multitier workloads. Multitier configurations can be implemented using subnets (one for every tier) in the same VNet and filtering the flows using network security groups.

An architect might want to deploy a multitier workload across multiple virtual networks. With virtual network peering, spokes can connect to other spokes in the same hub or different hubs. A typical example of this scenario is the case where application processing servers are in one spoke, or virtual network. The database deploys in a different spoke, or virtual network. In this case, it's easy to interconnect the spokes with virtual network peering and thereby avoid transiting through the hub. A careful architecture and security review should be performed to ensure that bypassing the hub doesn’t bypass important security or auditing points that might exist only in the hub.

![3][3]

Spokes can also be interconnected to a spoke that acts as a hub. This approach creates a two-level hierarchy: the spoke in the higher level (level 0) becomes the hub of lower spokes (level 1) of the hierarchy. The spokes of a hub and spoke implementation are required to forward the traffic to the central hub so that the traffic can transit to its destination in either the on-premises network or the public internet. An architecture with two levels of hubs introduces complex routing that removes the benefits of a simple hub-spoke relationship.

<!--Image References-->

[0]: ./images/network-redundant-equipment.png "Examples of component overlap"
[1]: ./images/network-hub-spoke-high-level.png "High-level example of hub and spoke"
[2]: ./images/network-hub-spokes-cluster.png "Cluster of hubs and spokes"
[3]: ./images/network-spoke-to-spoke.png "Spoke-to-spoke"
[4]: ./images/network-hub-spoke-block-level-diagram.png "Block level diagram of the hub and spoke"
[5]: ./images/network-users-groups-subsciptions.png "Users, groups, subscriptions, and projects"
[6]: ./images/network-infrastructure-high-level.png "High-level infrastructure diagram"
[7]: ./images/network-highlevel-perimeter-networks.png "High-level infrastructure diagram"
[8]: ./images/network-vnet-peering-perimeter-neworks.png "VNet Peering and perimeter networks"
[9]: ./images/network-high-level-diagram-monitoring.png "High-level diagram for Monitoring"
[10]: ./images/network-high-level-workloads.png "High-level diagram for Workload"

<!--Link References-->
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
[DDOS]: /azure/virtual-network/ddos-protection-overview
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