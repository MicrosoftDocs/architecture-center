---
title: Transitioning Hub Networks to IPv6
description: Transition your hub networks to IPv6 following this guide.
author: bsteph
ms.author: bstephenson
ms.date: 10/25/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-network
  - azure-firewall
  - azure-expressroute
  - azure-dns
categories:
  - networking
---

# Transitioning Hub Networks with IPv6

The Hub and Spoke network pattern that is used in Azure centrally houses shared networking resources, like firewalls and network gateways that enable hybrid connectivity, in a single network.  It also maintains the subscription and network separation necessary to secure and manage Azure virtual networks with best practices.

You can read more about hub and spoke networking in the [Architecture Center](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli), and use resources in the [Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/azure-best-practices/hub-spoke-network-topology).

This section of the guide helps you transition your existing Hub virtual network to use IPv6.

## Hub IP Space Planning

Your hub network should already have the following subnets among others:

- GatewaySubnet – For your Azure ExpressRoute Gateways.
- FirewallSubnet – For your Azure Firewall service.
- FirewallManagementSubnet – If you're doing forced tunneling of internet traffic across your Network Gateway, you need to have a subnet for Firewall Management.  For more information on forced tunneling, see [Azure Firewall forced tunneling](/azure/firewall/forced-tunneling).

As discussed in IP address planning, you should assign the hub a /56 network space.  This space is more than sufficient for the above networks, and apply a significant amount of room for growth.  Individual subnets are assigned /64 subnet size, as required.

In order to add this IP range to your virtual network and subnet, you can follow the instructions to [Add IPv6 to a Virtual Network](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-to-virtual-network)

## Transitioning Resources

This section of the guide provides direction for how to transition specific resources located in your hub to use IPv6.

### ExpressRoute Network Gateway

To use IPv6 for hybrid connectivity between your on-premises networks and your Azure networks, you can use IPv6 for private peering on your ExpressRoute Gateway.

Enabling IPv6 for private peering requires:

- Updating your ExpressRoute circuit to use IPv6,
- Adding your IPv6 space to your Hub virtual network, using the /56 address block.
- Adding IPv6 space to your GatewaySubnet in the Hub, using a /64 address block.
- Enable IPv6 Connectivity on your Gateway, or deploy a new gateway.

The [Azure ExpressRoute: Add IPv6 support](/azure/expressroute/expressroute-howto-add-ipv6-portal) provides step by step guidance for performing these actions, and guidance for when you might need to create a new Gateway instead of enable the feature on an existing one.

> [!IMPORTANT]
> At the time of writing, VPN Network Gateways do not support IPv6.  You can continue to use your IPv4 VPN Gateway to send IPv4 traffic to Azure Firewall or another appliance, and then use IPv6 to communicate to the backend.

Once connected, your ExpressRoute gateway is able to advertise your Azure IPv6 address spaces to on-premises.

### Azure Firewall

> [!IMPORTANT]
> At time of writing, the Azure Firewall support of IPv6 is in Private Preview.  There could be changes between this and general availability.

To update your Azure Firewall to use IPv6, you need to update the private IP address block on its subnet, provide it with a new IPv6 public IP, and set up your IPv6 rules in the policy.

> [!WARNING]
>Only Azure Firewalls that use policies can be updated to use IPv6.  If you have a legacy firewall that uses local rules, you need to deploy out a new firewall.

To update the private IP address block, follow the instructions to [Add IPv6 to a virtual network](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#add-ipv6-to-virtual-network).

If you have already added an IPv6 address block to the virtual network, you can skip to step 7.  The IP addresses used should be based on your IP address assignment.

To add the IPv6 public IP, first you need to [Create IPv6 public IP address](/azure/virtual-network/ip-services/add-dual-stack-ipv6-vm-portal#create-ipv6-public-ip-address).  Once it is created, you can then [Add a public IP configuration to a firewall](/azure/virtual-network/ip-services/configure-public-ip-firewall#add-a-public-ip-configuration-to-a-firewall) to associate the public IP address with the Azure Firewall.

Once these two steps are done, then you can begin adding IPv6 rules to your policy, following your existing process for adding rules and collections.  As you do so, be aware that:

- For IPv6 rules, the source and destination type must be “IP address.”  Other source or destination types are currently not supported with IPv6 values.
- You can use IPv6 ranges or individual addresses.  For example, you can use `::/0` for any IPv6 address.
- Rule collections support a combination of IPv4 rules and IPv6 Rules.
- You can continue to use your existing rules, including those that use IP Groups.  However, you will not be able to IP Groups to manage your IPv6 address rules at this time.

### Private DNS Zones

If you have private DNS zones linked to your hub, you need to update them to resolve domain names to IPv6.  You need to add IPv6 IP resolution records as AAAA address record types.  These records can be new record sets, or updates to existing record sets.

For more information about updating record sets, see [Manage DNS records and record sets](/azure/dns/dns-operations-recordsets-portal#update-a-record) for more information.

## Next steps

- Plan for operating dual-stack workloads with [IPv6 for Azure Vnet](/azure/virtual-network/ip-services/ipv6-overview)
- Review [Limitations for IPv6](azure/virtual-network/ip-services/public-ip-addresses#limitations-for-ipv6) to understand more about limitations with services that use Public IPv6 Addresses
