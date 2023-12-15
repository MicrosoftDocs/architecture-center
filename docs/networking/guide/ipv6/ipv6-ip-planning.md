---
title: Conceptual planning for IPv6 networking
description: Plan your IPv6 IP space in Azure with specific guidance.
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

# Conceptual planning for IPv6 networking

This guide outlines strategies for transitioning a IPv4 network environment in Azure to IPv6. It's a necessary transition as the number of internet-connected devices expands and IPv4 addresses near exhaustion. It's a move that is essential due to the near exhaustion of available IPv4 addresses. The IPv6 protocol provides a larger pool of internet addresses to accommodate future growth but also offers enhanced security features (native IPSec), flow labeling, and simplified network configurations. To make the transition, you update networking to support the IPv6 protocol.

## Understand IPv6

IPv6 has a massive address space. Unlike in IPv4, there's no need to use the smallest possible subnet size for each network segment. IPv6 has such a large address space that it allows for over-allocation (*see table*).

| IP Version | Number of IP Addresses Contained |
|---|---|
| IPv4 | 4,294,967,296 |
| IPv6 | 340,282,366,920,938,463,463,374,607,431,768,211,456 |

### Understand dual stacking

Dual stacking means your network can process both IPv4 and IPv6 traffic simultaneously. Azure Virtual Network supports dual stacking. You can assign a new IPv6 address block to a subnet with an existing IPv4 block. Services using IPv6 can coexist with services using IPv4.

### Understand IPv6 in Azure

In your Azure environment, there are three types of IPv6 addresses that can be assigned to your interfaces. These addresses function the same as their equivalents in IPv4.
  
1. *Private IP addresses*: To enable IPv6 on private IP addresses, you apply an IPv6 address range to the virtual networks and its subnets. The network interfaces in subnets get a static or dynamic address based on your configuration. You can see the IP address assignment in Azure portal. You can also see it inside the virtual machine configuration, if you have them. In the operating system, this address is shown as the *IPv6 Address*.

1. *Public IP addresses*: You can apply public IPv6 addresses to network interfaces. Public IP addresses must be globally unique and routable on the internet. you need to generate a unique IPv6 address that can be used for public endpoints in Azure, such as load balancers or application gateways. You can use the New-AzPublicIpAddress cmdlet to create an IPv6 public address in PowerShell. 

    The operating system configuration doesn't show the public IP address, but you can see the public IP address in the Azure portal. You can use public IPv6 addresses for inbound and outbound communication to the internet, when there's no default routing configured to direct traffic in another way. Many customers use shared network virtual appliances (NVAs) for public communication and don't assign a public IP address to network interfaces. Azure Public IPv6 addresses have no charge, unlike IPv4 addresses.  For more information, see [IP Address Pricing](https://azure.microsoft.com/pricing/details/ip-addresses/).

1. *Link-local addresses*: Link-local addresses are a special type of private IP address. In IPv6, link-local addresses are automatically configured on all interfaces. They're used for communication within a single network segment and aren't routable on the internet. They come from the `fe80::/10` space instead of from your subnet’s address block. You can see the `fe80::/10` address assigned to your interface from within the operating system.

For more information on other specialty address blocks, see [IANA IPv6 Special-Purpose Address Registry](https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml).

## Acquire IPv6 addresses

If your organization already has IPv6 addresses, you can use them to use these benefits in your Azure environment. If not, you need to acquire new ones. Using existing addresses can be more cost-effective and efficient, but acquiring new ones ensures you have a sufficient and continuous block of addresses for your needs. It also reduces the chance of address conflicts. If you don't have IPv6 space secured for your organization, you can use global addresses or local addresses

### Use global addresses

Global addresses are public IP addresses that are unique across the internet. You can contact a registrar to request a continuous block of general allocation or global addresses. These IPv6 addresses can be used in subnets, virtual networks, and regional supernets in Azure. To have sufficient space for growth in multiple regions, you should plan to allocate a /36 space for your Azure environment. You can use global addresses both for private networks and for public endpoints, or you can allocate different ranges. Unique global addresses can't have IP address conflicts.

### Use local addresses

Local addresses are private IP addresses that are used within a virtual network. You can use IPs in the unique local address range. This address range functions like the IPv4 private address range, such as the `10.0.0.0/8` address space. IPv6 reserves the `fc00::/7` address blocks for unique local addresses. These addresses aren't globally reachable, even though they're a part of the IPv6 Global Unicast Address Range.

If you use the unique local address range, then there's a chance that your IP addresses overlap with another organization.  If there's overlap, you can have challenges with integrating networks. For more information, see [the unique local IPv6 unicast addresses memo](https://www.rfc-editor.org/rfc/rfc4193.html).

## Transition to IPv6

You should align your plan for assigning IPv6 addresses to your Azure networks with your organization's IPv6 addressing plan. Your organization should already have a plan for on-premises IPv6 use, so that you can allocate space between different locations without the overlapping. If you don't have a plan, you should define one prior to starting implementation in Azure. For more information, see [Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

Some of the practices that were necessary in IPv4 to conserve addresses aren't applicable in IPv6. You should over allocate IPv6 addresses and use a standard block size for Azure, regions, virtual networks, and subnets (*see table*).

| Scope | Size | Number of Instances |
|--|--|--|
| Azure environment | /36 | 1 |
| Region | /44 | 256 |
| Virtual network | /56 | 4096 per region |
| Subnet | /64 | 256 per virtual network |

These recommendations apply to IPv6, not IPv4 environments. For more information on IPv4, see [Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

### Regions to IPv6

You should use a supernet and assign a /44 IPv6 address space to each Azure region. Like with IPv4, a supernet doesn't have a technical representation in Azure. Instead, you assign and track it in your IP Address Management system (IPAM). This table visualizes what the address blocks would look like for multiple regions:

| Network Scope | CIDR Range| First IP | Last IP |
| --- | --- | --- | --- |
| Azure Region 1 | `fd00:db8:dec0::/44` | fd00:db8:dec0:0000:0000:0000:0000:0000 | fd00:db8:decf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 2 | `fd00:db8:ded0::/44` | fd00:db8:ded0:0000:0000:0000:0000:0000 | fd00:db8:dedf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 3 | `fd00:db8:def0::/44` | fd00:db8:def0:0000:0000:0000:0000:0000 | fd00:db8:deff:ffff:ffff:ffff:ffff:ffff |

Once this IP address space is allocated to the region, you can deploy new networks and workloads by defining virtual networks and subnets from that IP space.

### Virtual networks to IPv6

You should assign a /56 IPv6 address space to each virtual network. This assignment facilitates networking management and streamlines the creation process. It allows you to create 4,096 virtual networks in a region and 256 subnets a single virtual network. 

![Diagram of Subnets at /64 size, Vnets at /56, and Region at /44, to show the size and scope of these network structures](./media/network-segments.png)

### Subnets to IPv6

You can continue to use your existing subnet architecture and assign a /64 address block to each subnet. This subnet size also allows organizations to plan their network conceptually. You don't need to worry about resizing subnets due to exhaustion. 

One significant difference between IPv6 networks and IPv4 networks in Azure is the minimum size of subnets. IPv6 subnets in Azure have a minimum size of /64. Each subnet contains 18,446,744,073,709,551,616 hosts, minus the hosts used for Azure management. IPv6 subnets reserve the first four IP addresses for management, like IPv4 networks. The reason for the IPv6 minimum subnet size is to maintain compatibility with network appliances outside of Azure. If the subnets were smaller, routing issues could occur.

To calculate the number of subnets of a certain size that can fit into a larger address block, you can use the formula 2^(X-Y). The X is the smaller address block size and Y is the larger block size.  For example, to determine how many /64 subnets can fit in to a /44 address block, you can use 2^(64-44). The answer is 1,048,576 subnets can fit in a /44 address block.

### Reuse IPv4 addresses

As you transition to IPv6 addresses, you can repurpose private IPv4 addresses in different virtual networks within your Azure environment. This transferability enables you to maintain active services while transitioning and effectively manage your IP space during the transition to IPv6. The reuse option gives you a larger effective IPv4 space. For any peered virtual network, you much ensure the IPv4 address ranges don't overlap.

## Configure Azure services to use IPv6

You can use the below table to find instructions for transitioning specific services to IPv6.

| Service | Transition Instructions |
|--|--|
| ExpressRoute Gateway | ExpressRoute Gateways can be transitioned using [Azure ExpressRoute: Add IPv6 support](/azure/expressroute/expressroute-howto-add-ipv6-portal) |
| Azure DNS Zones | New IPv6 records can be added with [Manage DNS records and record sets](/azure/dns/dns-operations-recordsets-portal#update-a-record) |

## Next steps

- Learn more about [IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview)
- Read more about more generally guidance on how to [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing)