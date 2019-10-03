---
title: Network security for your workload
description: Describes security considerations to make when building out the network for your workload.
author: david-stanford
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Network security for your workload

## DDos Protection

Potential of smaller-scale attack that doesn't trip the platform-level protection.

Action:
Use Azure DDoS Protection to prevent volumetric attacks, protocol attacks, and resource (application)-layer attacks.

## How do you configure public IPs for which traffic is passed in, and how and where it's translated

Inability to provision VMs with private IP addresses for protection.

Action:
Use Azure Firewall for built-in high availability and unrestricted cloud scalability. Utilize Azure IP address to determine which traffic is passed in, and how and where it's translated on to the virtual network.

## Isolate network traffic

Inability to ensure VMs and communication between them remains private within a network boundary.

Action:
Use Azure Virtual Network to allow VMs to securely communicate with each other, the Internet, and on- premises networks.

## Traffic flow between tiers

Inability to define different access policies based on the workload types, and to control traffic flows between them.

Action:
Employ Azure Virtual Network Subnet to designate separate address spaces for different elements or “tiers” within the workload, define different access policies, and control traffic flows between the tiers.

## Security appliances and boundary policy enforcement

Inability to define communication paths between different tiers within a network boundary.

Action:
Use Azure Virtual Network User Defined Routes (UDR) to control next hop for traffic between Azure, on-premises, and Internet resources through virtual appliance, virtual network gateway, virtual network, or Internet.

## Firewalls, load balancers, and intrusion detection systems

Possibility of not being able to select comprehensive solutions for secure network boundaries.

Action:
Use Network Appliances from Azure Marketplace to deploy a variety of pre-configured network virtual appliances. Utilize Application Gateway WAF to detect and protect against common web attacks.

## Segmenting address space

Inability to allow or deny inbound network traffic to, or outbound network traffic from, within larger network space.

Action:
Use network security groups (NSGs) to allow or deny traffic to and from single IP address, to and from multiple IP addresses, or even to and from entire subnets.

## Routing

Inability to customize the routing configuration.

Action:
Employ Azure Virtual Network User Defined Routes (UDR) to customize the routing configuration for deployments.

## Forced tunneling

Potential of outbound connections from any VM increasing attack surface area leveraged by attackers.

Action:
Utilize forced tunneling to ensure that connections to the Internet go through corporate network security devices.

## Cross-site connectivity

Potential of access to company’s information assets on-premises.

Action:
Use Azure site-to-site VPN or ExpressRoute to set up cross- premises connectivity to on- premises networks.

## Global load balancing

Inability to make services available even when datacenters might become unavailable.

Action:
Utilize Azure Traffic Manager to load balance connections to services based on the location of the user and/or other criteria.

## Disable RDP/SSH Access

Potential for attackers to use brute force techniques to gain access and launch other attacks.

Action:
Disable RDP/SSH access to Azure Virtual Machines and use VPN/ExpressRoute to access these virtual machines for remote management.

## VPN connectivity

Inability to identify the issue and use the detailed logs for further investigation.

Action:
Use Network Watcher troubleshooter to diagnose most common VPN gateway and connections issues.