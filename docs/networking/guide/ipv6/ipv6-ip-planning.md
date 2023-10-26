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

# IP Space Planning for IPv6 Networks

Before you add IPv6 to your existing environment, ensure you are planning for your IPv6 network space.  This section gives an overview of how to plan, and of conceptual changes for IP address assignment for IPv6 networks.  The focus of this is on private network planning.  For guidance on planning your public IP address prefixes, see [Public IP address prefix](https://learn.microsoft.com/azure/virtual-network/ip-services/public-ip-address-prefix).

In general, the IP space that is utilized within your Azure networks should be aligned with the overall IPv6 addressing plan for your company.    You should already have a plan for how IPv6 will be used in your on-prem environments, so that you can allocate space between different locations without the overlapping.

These instructions are meant to compliment the overall guide in [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing).

## IPv6 Address Space Concepts

### Shared IP Space

Azure Virtual Networks support the use of both IPv4 and IPv6 IP addresses in the same virtual networks and subnets.  This is often referred to having a dual-stack network, or dual-stacking.  Each subnet can be assigned an IPv6 address block as well as its existing IPv4 block.  This means that services that have been transitioned to use IPv6 can continue to coexist with services that are not yet transitioned.

This guide builds on planning your IPv6 addresses to networks that already are assigned IPv4 addresses.

### Planning for the Size of IPv6

One of IPv6’s most important features is its nearly unlimited IP address space.  This is something that is understood conceptually, but can be hard to architect with in practice.  There are several practices, like allocating the minimum space needed for network segments, that simply don’t apply.

For context:

| IP Version | Number of IP Addresses Contained |
|---|---|
| IPv4 | 17,891,328 |
| IPv6 | 2,658,455,991,569,830,000,000,000,000,000,000,000 |

The increased size is such that it can be hard to fully appreciate.

As a result, when planning IP address allocation in IPv6, you should use the following guidelines:

- **Design for over-allocation.**  You could assign each private network segment a scope equivalent to the whole range of the private IPv4 space, and be able to have exponentially more network segments than there are private IPv4 addresses.  In short, trying to optimize IP space allocation at the cost of other functions is an antipattern.
- **Design for ease of management.** IPv6 allows you to apply practices such as default sizing, and building context in to network addresses.  You should err on the side of easy management and planning, to have to avoid troubleshooting.

We will apply these to the concepts in the next section.

### Deciding Your IPv6 Address Scope

Many organizations have acquired a large volume of IPv6 addresses to be used for private networking.  As you are building your Azure IPv6 address plan, you should work with your organization’s IP address administrators to identify if there is already IP space available, and how you can use it in planning Azure.

If you do not have IPv6 space secured for your organization, you have two options.

The first option is to contact a registrar to request a continuous block general allocation or global addresses.  These IPv6 addresses can then be used to assign subnets, virtual networks, and regional supernets in Azure.  To have sufficient space for growth in multiple regions, you should plan to allocate a /36 space for Azure.  You can use global addresses both for private networks and for public endpoints, or you can allocate different ranges.

The second option is to plan to use IPs in the unique local address range.  This address range functions like the IPv4 private address range, such as the `10.0.0.0/8` address space. IPv6 reserves the `fc00::/7` address blocks for unique local addresses.  These addresses are not globally reachable, even though they are a part of the IPv6 Global Unicast Address Range.  You can read more about this range assignment in the [Unique Local IPv6 Unicast Addresses](https://www.rfc-editor.org/rfc/rfc4193.html) memo.

### Understanding IPs assigned in Azure

In your Azure environment, you will notice three types of IPv6 addresses that will be assigned to your interface.
  
First are the private IP addresses attached to your network interfaces on your virtual Network.  As part of this guide will apply IP ranges to your virtual networks and subnets.  When an address block is assigned to a subnet, network interfaces in the subnet will receive a static or dynamic address based on your configuration.  You will be able to see this in the Azure Portal, and you will also see it inside the virtual machine configuration, this will be what is presented as the IPv6 Address.

In addition, you can apply public addresses to the interface.  These will need to be from an internet routed scope.  You won’t see this in the operating system configuration itself, but will see it in the Azure Portal.  These public IPs can be used for inbound and outbound communication to the internet, when there is no default routing configured to direct traffic in another way.  Many customers will use shared NVAs for public communication, and so not provide a global public address to their network interfaces.

Lastly are link-local addresses.  This address is used to communicate within the same link – the same local network segment. The IP will be automatically assigned, and it will be pulled from the `fe80::/10` space instead of from your subnet’s address blocks.  No configuration is needed, but you will see an `fe80::/10` address assigned to your interface from within the operating system.

> [!TIP]
> For more information on other specialty address blocks, see [IANA IPv6 Special-Purpose Address Registry](https://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml)

## Planning your IPv6 Addresses for Azure

Now that you understand some of the core concepts and have dedicated an IP address space for use in Azure, you are ready to continue your planning in to Azure allocation.  As discussed above, you should have a /36 address range available to allocate to Azure.  This will allow you to dedicate up to 256 different regional deployments (see below), as well as have a clear border for your IP ranges.

### Subnet Sizing in Azure

One significant difference between IPv6 networks and IPv4 networks in Azure is the minimum size of subnets.  IPv6 subnets in Azure have a minimum size of /64.  This means that a given subnet will contain 18,446,744,073,709,551,616 hosts, minus the hosts used for Azure management.  The reason for this minimum size is to maintain compatibility with network appliances outside of Azure; if the subnets were smaller, routing issues could occur.

This subnet size also allows organizations to plan their network conceptually, and not need to worry about resizing subnets due to exhaustion.

You can continue to use your existing subnet architecture and assign a /64 address block to each as part of your IPv6 transition.

### Azure Regional IP Space Planning

Like with IPv4, you can plan a supernet to be used for individual Azure regions.  This supernet does not have a technical representation in Azure; there is no supernet resource in Azure to assign resources to.  Instead, you are assigning and tracking it in your IP Address Management system.

Because IPv6 space is so large, you have more freedom in assigning ranges based off of semantic value.  You can associate numbers and segments to networking concepts, such as the environment (dev, prod, staging, etc) of a network, the business unit responsible, or other management concepts as needed.

For the regions that you are deployed in, you should plan to assign an IP space for that region to ensure that you do not overlap.  This will allow you to have active/active services in different regions and making assigning address blocks to individual networks easy as you complete your transition.

To start, you should plan to assign a /44 IPv6 address block for your region.  This will provide space for the hub network (see below) and a substantial number of virtual networks of varying sizes.

> [!NOTE]
> In order to determine how many network spaces of a certain size can fit into a address block, you can use the formula of 2^(x-y), where X is the smaller address block’s size and Y is the larger blocks size.  For example, to determine how many /64 subnets can fit in to our /44 regional address allocation, we can use 2^(64-44), which is 1,048,576 subnets.

In addition, it provides a clear address block for the region.  A scope of `fd00:db8:deca::/48` covers the ranges from `fd00:db8:deca:0000::` to `fd00:db8:decf:ffff::`, meaning that there is a clear break where assigned.

### Azure Virtual Network Space Planning

Next you will need to assign your regional address space to the virtual networks in Azure.

Just like planning for your region, you will want to plan for a uniform size for your virtual networks.  The address space available, and a focus on ease of management, should drive your assignment.

Using a /56 address block for each virtual network can streamline the process.  A scope of `fd00:db8:deca::/56` covers the ranges from `fd00:db8:deca:0000::` to `fd00:db8:decf:00ff::`.  It allows for the use of 4,096 virtual networks in your region, which is significantly more than the number of peers supported by a single hub.
This size allows for 256 subnets to be created in a single virtual network.

As a result, your IP space can be visualized as:

![Diagram of Subnets at /64 size, Vnets at /56, and Region at /44, to show the size and scope of these network structures](media\network-segments.png)

### IPv4 Address Space Reuse Between Regions

Transitioning to IPv6 opens up new options for using your existing IPv4 address space.  As services begin to connect over the new IPv6 addresses, it doesn’t matter what the IPv4 addresses of the virtual network that the resources are in.  As a result, you can reuse IPv4 addresses in different spoke networks, giving you a much larger effective IP space.

Each region’s hub will still need a globally unique CIDR block for its address space.  This allows the hubs to be peered using global peering, or to connect to each other over other connections.  However, each spoke can then use the same ranges.  So long as IP addresses are not reused in the same hub-spoke topology, and traffic between regions uses IPv6 addresses, there will be no effective overlap.

This can be helpful for organizations who have already deployed out many virtual networks in multiple regions, and are needing new IP space for new spoke networks.

## Next steps

- Continue your journey by [Transitioning Hub Networks to IPv6](ipv6--transition-hub.md)
- Read more about more generally guidance on how to [Plan for IP Addressing](/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing)
