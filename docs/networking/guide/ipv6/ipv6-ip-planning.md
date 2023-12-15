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

This guide outlines strategies for transitioning a IPv4 network environment in Azure to IPv6. Transitioning from IPv4 to IPv6 is a necessary evolution in internet technology. It involves updating virtual network infrastructures to support the IPv6 protocol. It's a move that is essential due to the near exhaustion of available IPv4 addresses. The IPv6 protocol not only provides a significantly larger pool of internet addresses to accommodate future growth but also offers enhanced security features (native IPSec), flow labeling, and simplified network configurations.


To understand more about the capabilities of IPv6 virtual networks, see [IPv6 for Azure Virtual Network](/azure/virtual-network/ip-services/ipv6-overview).

## Understand IPv6

Understanding IPv6 in Azure refers to comprehending how to integrate and manage the vastly larger and more complex IPv6 address space within Azure. Transitioning to IPv6 in Azure is crucial due to the exhaustion of IPv4 addresses and the need for enhanced connectivity and security features offered by IPv6. This transition requires you to understand dual stacking, address space size, IP address allocation, and IP addresses in Azure.

### Understand dual stacking

Dual stacking is a network configuration method that allows you to process both IPv4 and IPv6 traffic simultaneously. It's also known as having a dual-stack network. Azure Virtual Network allows you to dual stack virtual networks and subnets. You can assign a new IPv6 address block to a subnet with an existing IPv4 block. Services that have been transitioned to use IPv6 can continue to coexist with services that aren't yet transitioned.

### Understand IPv6 address space

One of IPv6’s most important features is its nearly unlimited IP address space.  This means that in IPv6, unlike in IPv4, there is no need to use the smallest possible subnet size for each network segment. IPv6 has such a large address space that it allows for over-allocation. For example, each IPv6 subnet in Azure has a fixed size of /64 and can accommodate more hosts than the entire IPv4 address space. Some of the practices that were necessary in IPv4 to conserve addresses are not applicable in IPv6.

For context:

| IP Version | Number of IP Addresses Contained |
|---|---|
| IPv4 | 4,294,967,296 |
| IPv6 | 340,282,366,920,938,463,463,374,607,431,768,211,456 |


When planning IP address allocation in IPv6, you should use the following guidelines:

- **Calculate fit.** To calculate the number of subnets of a certain size that can fit into a larger address block, you can use the formula 2^(X-Y). The X is the smaller address block size and Y is the larger block size.  For example, to determine how many /64 subnets can fit in to a /44 address block, we can use 2^(64-44), which is 1,048,576 subnets.
- **Design for over-allocation.** You could assign each private network segment a scope equivalent to the whole range of the private IPv4 space and be able to have exponentially more network segments than there are private IPv4 addresses.  In short, trying to optimize IP space allocation at the cost of other functions is an antipattern.
- **Design for ease of management.** IPv6 allows you to apply practices such as default sizing, and building context into network addresses.  You should err on the side of easy management and planning to avoid troubleshooting.

These recommendations apply to IPv6, not IPv4 environments. For more information on IPv4, see [Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

### Understand IPv6 address space scopes

Your organization might already have IPv6 addresses for private networking. You should work with your organization’s IP address administrators to identify if there's already IP space available, and how you can use it in planning Azure. If you do not have IPv6 space secured for your organization, you have two options to acquire the IPv6 addresses you need.

1. **Use global addresses.** You can contact a registrar to request a continuous block of general allocation or global addresses. You can use these IPv6 addresses in subnets, virtual networks, and regional supernets in Azure. To have sufficient space for growth in multiple regions, you should plan to allocate a /36 space for your Azure environment.  You can use global addresses both for private networks and for public endpoints, or you can allocate different ranges. Unique global addresses won't ever have IP address conflicts.

1. **Use local addresses.** You can use IPs in the unique local address range. This address range functions like the IPv4 private address range, such as the `10.0.0.0/8` address space. IPv6 reserves the `fc00::/7` address blocks for unique local addresses.  These addresses aren't globally reachable, even though they are a part of the IPv6 Global Unicast Address Range.

If you use the unique local address range, then there is a chance that your IP addresses will overlap with another organization.  If there is overlap, you can have challenges with integrating networks. For more information, see [the unique local IPv6 unicast addresses memo](https://www.rfc-editor.org/rfc/rfc4193.html).

### Understand IPs addresses in Azure

In your Azure environment, there are three types of IPv6 addresses that can be assigned to your interfaces. These addresses function the same as their equivalents in IPv4, so there is no noticeable difference.
  
1. **Private IP addresses**: There are private IP addresses attached to your network interfaces in Azure virtual networks.  To enable IPv6 on private IP addresses, you apply an IP range to the virtual networks and subnets.  When you assign an address block to a subnet, the network interfaces in the subnet receives a static or dynamic address based on your configuration. You can see the IP address assignment in Azure portal. You can also see it inside the virtual machine configuration, if you have them. In the operating system, this address is shown as the IPv6 Address.

1. **Public IP addresses**: You can apply public addresses to an interface. Public IP addresses must come from an internet routed scope, and you need to create an IPv6 public address to assign it. The operating system configuration doesn't show the public IP address, but you can see the public IP address in the Azure portal.  You can use public IPv6 addresses for inbound and outbound communication to the internet, when there's no default routing configured to direct traffic in another way. Many customers use shared network virtual appliances (NVAs) for public communication and don't assign a public IP address to network interfaces.

Azure Public IPv6 addresses have no charge, unlike IPv5 addresses.  For more information, see [IP Address Pricing](https://azure.microsoft.com/pricing/details/ip-addresses/).

1. **Link-local addresses**: Link local addresses communicate within the same local network segment (link). The link-local address is automatically assigned, and it comes from the `fe80::/10` space instead of from your subnet’s address block.  You don't need to configure local-link address. You can see the `fe80::/10` address assigned to your interface from within the operating system.

For more information on other specialty address blocks, see [IANA IPv6 Special-Purpose Address Registry](https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml).

## Transition to IPv6

You should align your plan for assigning IPv6 addresses to your Azure networks with your organization's IPv6 addressing plan.  Your organization should already have a plan for on-premises IPv6 use, so that you can allocate space between different locations without the overlapping. If you do not have a plan, you should define one prior to starting implementation in Azure. For more information, see [Plan for IP addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

You should have a /36 IPv6 address range available for your entire Azure environment. For each Azure region, use a /44 IPv6 address range and a /56 IPv6 address range for each virtual network. Each subnet should use a /64 IPv6 address range (*see table*).

| Scope | Size | Number of Instances |
|--|--|--|
| Azure Wide | /36 | 1 |
| Azure Region | /44 | 256 |
| Virtual Network | /56 | 4096 per region |
| Subnet | /64 | 256 per virtual network |

### Transition subnets to IPv6

You can continue to use your existing subnet architecture and assign a /64 address block to each as part of your IPv6 transition. This subnet size also allows organizations to plan their network conceptually. You don't need to worry about resizing subnets due to exhaustion. 

One significant difference between IPv6 networks and IPv4 networks in Azure is the minimum size of subnets. IPv6 subnets in Azure have a minimum size of /64. Each subnet contains 18,446,744,073,709,551,616 hosts, minus the hosts used for Azure management. IPv6 subnets reserve the first four IP addresses for management, like IPv4 networks. The reason for the IPv6 minimum subnet size is to maintain compatibility with network appliances outside of Azure. If the subnets were smaller, routing issues could occur.

### Transition regions to IPv6

You should assign a /44 IPv6 address space to each Azure region. Once this IP address space is allocated to the region, you will be able to easily deploy new networks and workloads by defining virtual networks and subnets from that IP space. Here are strategies to transitioning Azure regions to IPv6:

- *Use a supernet*: Like with IPv4, plan a supernet for individual Azure regions. This supernet does not have a technical representation in Azure. Instead, you assign and track it in your IP Address Management system (IPAM).
- *Use a /44 address block*: Using a unique /44 IPv6 address block to be allocated to each Azure region.  This allocation will not be done against a resource in Azure.  Instead, you will dedicate this space in your organization's IP Address Management (IPAM) system. This assignment provides a clear address block for the region.  This table visualizes what the address blocks would look like for multiple regions:

| Network Scope | CIDR Range| First IP | Last IP |
| -- | -- | -- | -- |
| Azure Region 1 | `fd00:db8:dec0::/44` | fd00:db8:dec0:0000:0000:0000:0000:0000 | fd00:db8:decf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 2 | `fd00:db8:ded0::/44` | fd00:db8:ded0:0000:0000:0000:0000:0000 | fd00:db8:dedf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 3 | `fd00:db8:def0::/44` | fd00:db8:def0:0000:0000:0000:0000:0000 | fd00:db8:deff:ffff:ffff:ffff:ffff:ffff |

### Transition virtual networks to IPv6

You should assign a /56 IPv6 address space to each virtual network within your regional address space in Azure. This assignment ensures efficient utilization of the vast IPv6 address space, facilitates ease of management, and allows for streamlined processes. Assign your regional address space to the virtual networks in Azure. Using a /56 address block for each virtual network can streamline the process. It allows for the use of 4,096 virtual networks in your region, which is more than the number of peers supported by a single hub. This size allows for 256 subnets to be created in a single virtual network. 

![Diagram of Subnets at /64 size, Vnets at /56, and Region at /44, to show the size and scope of these network structures](./media/network-segments.png)

### Reuse private IPv4 addresses

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
