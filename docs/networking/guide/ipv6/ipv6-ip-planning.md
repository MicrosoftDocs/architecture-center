---
title: IP Space Planning for IPv6 Networks
description: Plan your IPv6 IP space in Azure with specific guidance.
author: bsteph
ms.author: bstephenson
ms.date: 10/25/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-network
categories:
  - networking
---

# IP space planning for IPv6 networks

Before you add IPv6 to your existing environment, ensure you're planning for your IPv6 network space.  This section gives an overview of how to plan, and of conceptual changes for IP address assignment for IPv6 networks.  This guide focuses on private network planning.  For guidance on planning your public IP address prefixes, see [Public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix).

In general, the IP space that is utilized within your Azure networks should be aligned with the overall IPv6 addressing plan for your company.  You should already have a plan for on-premises IPv6 use, so that you can allocate space between different locations without the overlapping.

These instructions are meant to be used in addition to the overall guide in [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

## Understand IPv6 in Azure

"Understanding IPv6 in Azure refers to comprehending how to integrate and manage the vastly larger and more complex IPv6 address space within Azure. Transitioning to IPv6 in Azure is crucial due to the exhaustion of IPv4 addresses and the need for enhanced connectivity and security features offered by IPv6. This transition requires you to understand dual stacking, address space size, IP address allocation, and IP addresses in Azure.

### Understand dual stacking

Dual stacking is a network configuration method that allows you to process both IPv4 and IPv6 traffic simultaneously. It's also known as having a dual-stack network. Azure Virtual Networks supports dual stacking virtual networks and subnets. You can assign a new IPv6 address block to a subnet with an existing IPv4 block. Services that have been transitioned to use IPv6 can continue to coexist with services that aren't yet transitioned.

### Understand IPv6 address space size

One of IPv6’s most important features is its nearly unlimited IP address space.  There are several practices, like allocating the minimum space needed for network segments, that simply don’t apply.

For context:

| IP Version | Number of IP Addresses Contained |
|---|---|
| IPv4 | 17,891,328 |
| IPv6 | 2,658,455,991,569,830,000,000,000,000,000,000,000 |

The increased size is such that it can be hard to fully appreciate.

As a result, when planning IP address allocation in IPv6, you should use the following guidelines:

- **Design for over-allocation.**  You could assign each private network segment a scope equivalent to the whole range of the private IPv4 space, and be able to have exponentially more network segments than there are private IPv4 addresses.  In short, trying to optimize IP space allocation at the cost of other functions is an antipattern.
- **Design for ease of management.** IPv6 allows you to apply practices such as default sizing, and building context in to network addresses.  You should err on the side of easy management and planning, to have to avoid troubleshooting.

These concepts will be applied in the next sections.

> [!NOTE]
> These guidelines apply for IPv6, but not for IPv4 environments.  When planning your IP space for IPv4 there are different guidelines to use.  See [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing) for general guidelines.

### Deciding Your IPv6 Address Scope

Many organizations have acquired a large volume of IPv6 addresses to be used for private networking.  As you're building your Azure IPv6 address plan, you should work with your organization’s IP address administrators to identify if there's already IP space available, and how you can use it in planning Azure.

If you do not have IPv6 space secured for your organization, you have two options.

The first option is to contact a registrar to request a continuous block general allocation or global addresses.  These IPv6 addresses can then be used to assign subnets, virtual networks, and regional supernets in Azure.  To have sufficient space for growth in multiple regions, you should plan to allocate a /36 space for Azure.  You can use global addresses both for private networks and for public endpoints, or you can allocate different ranges.

The second option is to plan to use IPs in the unique local address range.  This address range functions like the IPv4 private address range, such as the `10.0.0.0/8` address space. IPv6 reserves the `fc00::/7` address blocks for unique local addresses.  These addresses aren't globally reachable, even though they are a part of the IPv6 Global Unicast Address Range.  You can read more about this range assignment in the [Unique Local IPv6 Unicast Addresses](https://www.rfc-editor.org/rfc/rfc4193.html) memo.

### Understanding IPs assigned in Azure

In your Azure environment, there are three types of IPv6 addresses that can be assigned to your interface.  

> [!NOTE]
> These addresses function the same as their equivalents in IPv4, so there is no noticeable difference.
  
First are the private IP addresses attached to your network interfaces on your virtual network.  To enable IPv6, you apply IP ranges to your virtual networks and subnets.  When an address block is assigned to a subnet, network interfaces in the subnet receives a static or dynamic address based on your configuration.  You can see it in Azure portal, and you can also see it inside the virtual machine configuration.  In the operating system, this address is shown as the IPv6 Address.

In addition, you can apply public addresses to the interface.  These addresses need to be from an internet routed scope, and you need to create an IPv6 public address to assign it.  The operating system configuration doesn't show the configuration, but it can be seen in the Azure portal.  These public IPs can be used for inbound and outbound communication to the internet, when there's no default routing configured to direct traffic in another way.  Many customers use shared NVAs for public communication, and so not provide a global public address to their network interfaces.

> [!NOTE]
> Azure Public IPv6 addresses have no charge, unlike IPv5 addresses.  For more information on Public Ip pricing, see [IP Address Pricing](https://azure.microsoft.com/pricing/details/ip-addresses/).

Lastly are link-local addresses.  This address is used to communicate within the same link – the same local network segment. The IP is automatically assigned, and it comes from the `fe80::/10` space instead of from your subnet’s address blocks.  No configuration is needed, and you see an `fe80::/10` address assigned to your interface from within the operating system.

> [!TIP]
> For more information on other specialty address blocks, see [IANA IPv6 Special-Purpose Address Registry](https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml)

## Planning your IPv6 Addresses for Azure

Now that you understand some of the core concepts and have dedicated an IP address space for use in Azure, you're ready to continue your planning in to Azure allocation.  As discussed earlier, you should have a /36 address range available to allocate to Azure.  This scope allows you to dedicate the following:

| Scope | Size | Number of Instances |
|--|--|--|
| Azure Wide | /36 | 1 |
| Azure Region | /44 | 256 |
| Virtual Network | /56 | 4096 per region |
| Subnet | /64 | 256 per virtual network |

### Subnet Sizing in Azure

One significant difference between IPv6 networks and IPv4 networks in Azure is the minimum size of subnets.  IPv6 subnets in Azure have a minimum size of /64.  Each subnet contains 18,446,744,073,709,551,616 hosts, minus the hosts used for Azure management.  IPv6 subnets reserve the first four IP addresses for management, like IPv4 networks.

The reason for this minimum size is to maintain compatibility with network appliances outside of Azure; if the subnets were smaller, routing issues could occur.

This subnet size also allows organizations to plan their network conceptually, and not need to worry about resizing subnets due to exhaustion.

You can continue to use your existing subnet architecture and assign a /64 address block to each as part of your IPv6 transition.

### Azure Regional IP Space Planning

Like with IPv4, you can plan a supernet to be used for individual Azure regions. A supernet is a combination of several subnets so they share a single routing prefix. To assign and track supernets in Azure, you need to use an IP Address Management (IPAM) system.

Because IPv6 space is so large, you have more freedom in assigning ranges based off of semantic value.  You can associate numbers and segments to networking concepts, such as the environment (dev, prod, staging, etc) of a network, the business unit responsible, or other management concepts as needed.

For the regions that you're deployed in, you should plan to assign an IP space for that region to ensure that you do not overlap.  Assigning distinct IP addresses allows you to have active/active services in different regions and making assigning address blocks to individual networks easy as you complete your transition.

To start, you should plan to assign a /44 IPv6 address block for your region.  This scope provides space for the hub network and a substantial number of virtual networks of varying sizes.

In addition, it provides a clear address block for the region.  A scope of `fd00:db8:dec0::/44` covers the ranges from `fd00:db8:deca:0000::` to `fd00:db8:decf:ffff::`, meaning that there's a clear break where assigned.

To help visualize how this would work across multiple regions, refer to the following table:

| Network Scope | CIDR Range| First IP | Last IP |
| -- | -- | -- | -- |
| Azure Region 1 | `fd00:db8:dec0::/44` | fd00:db8:dec0:0000:0000:0000:0000:0000 | fd00:db8:decf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 2 | `fd00:db8:ded0::/44` | fd00:db8:ded0:0000:0000:0000:0000:0000 | fd00:db8:dedf:ffff:ffff:ffff:ffff:ffff |
| Azure Region 3 | `fd00:db8:def0::/44` | fd00:db8:def0:0000:0000:0000:0000:0000 | fd00:db8:deff:ffff:ffff:ffff:ffff:ffff |

> [!NOTE]
> In order to determine how many network spaces of a certain size can fit into a address block, you can use the formula of 2^(x-y), where X is the smaller address block’s size and Y is the larger blocks size.  For example, to determine how many /64 subnets can fit in to our /44 regional address allocation, we can use 2^(64-44), which is 1,048,576 subnets.

### Azure Virtual Network Space Planning

Next you need to assign your regional address space to the virtual networks in Azure.

Just like planning for your region, you want to plan for a uniform size for your virtual networks.  The address space available, and a focus on ease of management, should drive your assignment.

Using a /56 address block for each virtual network can streamline the process.  A scope of `fd00:db8:deca::/56` covers the ranges from `fd00:db8:deca:0000::` to `fd00:db8:decf:00ff::`.  It allows for the use of 4,096 virtual networks in your region, which is more than the number of peers supported by a single hub.

This size allows for 256 subnets to be created in a single virtual network.

As a result, your IP space can be visualized as:

![Diagram of Subnets at /64 size, Vnets at /56, and Region at /44, to show the size and scope of these network structures](media\network-segments.png)

### IPv4 Address Space Reuse Between Regions

Transitioning to IPv6 opens up new options for using your existing IPv4 address space.  As services begin to connect over the new IPv6 addresses, it doesn’t matter what the IPv4 addresses of the virtual network that the resources are in.  As a result, you can reuse IPv4 addresses in different spoke networks, giving you a larger effective IPv4 space.

Each region’s hub needs globally unique CIDR block for its address space, to allow the hubs to be peered using global peering or to connect to each other over other connections.  However, each spoke can then use the same ranges.  So long as IP addresses aren't reused in the same hub-spoke branch, and traffic between regions uses IPv6 addresses, there's no effective overlap.

This reuse can be helpful for organizations who have already deployed out many virtual networks in multiple regions, and are needing new IP space for new spoke networks.

## Configure Azure service to support IPv6

You can use the below table to find instructions for transitioning specific services to IPv6.

| Service | Transition Instructions |
|--|--|
| Express Route Gateway | [Azure ExpressRoute: Add IPv6 support](/azure/expressroute/expressroute-howto-add-ipv6-portal) |

## Next steps

- Continue your journey by [Transitioning Hub Networks to IPv6](ipv6-transition-hub.md)
- Read more about more generally guidance on how to [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing)
