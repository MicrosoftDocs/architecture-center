---
title: "Enterprise Cloud Adoption: Software Defined Networks" 
description: Discussion of Software Defined Networks as a core service in Azure migrations
author: rotycenh
ms.date: 10/26/2018
---

# Enterprise Cloud Adoption: Software Defined Networks

Software Defined Networks (SDN) provide virtualized networking functionality
equivalent to the physical routers, firewalls, and other networking hardware you
would find in an on-premises network. This allows organizations to easily
configure and deploy network structures and capabilities that support their
specific needs using virtual resources. SDN is critical to creating secure
networks on a public cloud platform.

## Choosing the right SDN architectures

\*Reviewers note: This table is a working list of questions to help readers pick
the right architecture for their migration. Eventually this is intended to be
more of a decision list diagram or something similar.\*

There are many ways to structure virtual networks, and the design decisions you
make will depend on a combination of the workload requirements. When planning
your migration, which architecture, or combination of architectures consider the
following questions to help determine what's right for your organization:

| Question                                                                                                                                                   | Cloud Native | Hybrid | VDC |
|------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|--------|-----|
| Does your workload require integration with on-premises applications?                                                                                      | No           | Yes    | Yes |
| Does your workload require authentication services not supported through cloud identity services, or need direct access to on-premises domain controllers? | No           | Yes    | Yes |
| Will you need to deploy and manage a large number of VMs and workloads?                                                                                    | No           | No     | Yes |
| Will you need to provide central governance while delegating control over resources to individual workload teams?                                          | No           | No     | Yes |

## Azure Virtual Networks

On Azure, the core SDN capability is provided by [Azure Virtual
Network](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview),
which acts as a cloud analog to physical on-premises networks. Virtual networks
also act as the default isolation boundary between resources on the platform.

A virtual network is inaccessible from all other networks by default. Resources
hosted within a virtual network cannot communicate with other virtual networks,
external data centers, or the internet unless they are explicitly allowed to
through a network policy. Rules and policies defined for the virtual network are
inherited by all resources hosted within the virtual network.

Traffic inside a virtual network can be secured and managed through a
combinations of network security groups
([NSGs](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview)),
user defined routes
([UDR](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)),
and network virtual appliances
([NVA](https://azure.microsoft.com/en-us/solutions/network-appliances/)) or VMs
serving as firewalls or other security devices. This combination of virtual
devices and rules creates isolation boundaries and protects application
deployments within the virtual network's boundaries, much as would be done using
hardware devices within a physical data center.

Virtual networks allow the management of IP addresses for VM's or other
resources, the definition of subnets, implementation of access control policies,
and the creation of entire network infrastructures, with the same structural
ability of traditional physical networks.

Virtual networks can be connected to other Azure virtual networks using the
[virtual network
peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)
mechanism. They can also be connected to on-premises or other external networks
using [ExpressRoute](https://azure.microsoft.com/en-us/services/expressroute/)
or [VPN connections](https://azure.microsoft.com/en-us/services/vpn-gateway/).

\*Note: there are many potential virtual network architectures. The following
list is not definitive and will grow over time.\*

### Cloud Native

![Simple cloud native virtual network with a single VM and Public IP
address](../_images/infra-sdn-figure1.png)

*Figure 1. Simple cloud native virtual network with a single VM and Public IP
address.*

A cloud native virtual network has no dependencies on your organization's
on-premises or other non-cloud resources to support the required workloads. All
required resources are provisioned either in the virtual network itself or using
managed PaaS offerings.

This is the default configuration for a newly created virtual network. By
default resources connected to the virtual network have outbound connectivity
(although this can be controlled using NSGs ). Connections with other virtual
networks are possible through peering.

To provide inbound access to any of the VMs or devices connected to the network,
you will need to provision Public IP resources and set the appropriate NSG rules
to allow that traffic. Within the network, subnets, firewalls, load balancers,
and routing rules can all be configured to manage traffic.

By default, identity and authentication services for a cloud native workload are
either provided by Azure Active Directory or devices provisioned within the
virtual network.

Note that any single virtual network and connected resources can only exists
within a single subscription, and is bound by [subscription
limits](https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits)

### Hybrid Cloud

![Example hybrid virtual network containing a DMZ and n-tier
application](../_images/infra-sdn-figure2.png)

*Figure 2. Example hybrid virtual network containing a DMZ and n-tier
application.*

The hybrid cloud network architecture allows azure-hosted virtual networks to
access your on-premises resources and services and vice versa. A hybrid cloud
uses either an ExpressRoute circuit or Azure VPN to connect your virtual network
with your organization's existing non-Azure based IT assets.

As with a basic cloud native virtual network, a hybrid virtual network is
isolated by default. Adding the on-premises connectivity only grants access to
and from the on-premises network. Any other inbound traffic targeting resources
in the virtual network need to be provisioned through NSG rules and Public IPs.
The connection can be secured using virtual firewalls and routing rules to limit
access and specify exactly what services can be accessed between the two
networks.

In addition to giving Azure resources access to on-premises applications and
data, a hybrid network allows access to on-premises directory and identity
services. This can provide Azure resources access to authentication technologies
that may not be available through Azure Active Directory or AAD Connect.

For an example of how to implement a secure hybrid virtual network see [this
example at the Azure Architecture
Center](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-hybrid).

### Virtual Data Center - Enterprise scale trusted network extension

![Example hub and spoke structure of a virtual data center, including
connection to on-premises network](../_images/infra-sdn-figure3.png)

*Figure 3. Example hub and spoke structure of a virtual data center, including
connection to on-premises network.*

The [Virtual Data Center
(VDC)](https://docs.microsoft.com/en-us/azure/architecture/vdc/) is an approach
designed to assist enterprises in deploying large number of workloads and
services to the Azure public cloud platform while still preserving key aspects
of your existing security, policy compliance, and general IT governance
practices.

The VDC network architecture is built around a hub and spoke model composed of
multiple virtual networks. The central hub virtual network contains the main
networking, policy, and monitoring resources for the VDC instance. As with
hybrid clouds, the hub hosts a connection to on-premises or other external
networks (via ExpressRoute or VPN) and contains the central routing and firewall
capabilities that manage traffic coming from workloads to external networks and
vice versa.

Workload spokes are separate virtual networks that, aside from network peering
with the hub network, are isolated by default. All traffic travelling to the
spoke from outside the VDC and form the spoke to the outside world are forced to
travel through the hub where central security rules and access policies are
applied. Much of the control over the spoke networks and connected workload
resources can be delegated to the workload teams themselves, while critical
security and access controls can be maintained through the central hub.

A single hub can connect to many spokes, and each hub and spoke virtual network
exist in separate subscriptions, mitigating some of the subscription level
limits that can affect large cloud migrations.

Note that the VDC networking architecture is just a part of the overall virtual
data center concept, which includes integrating your enterprise's existing
governance, access control, and security policies into your cloud migration. See
the [Azure Virtual Datacenter
E-book](https://azure.microsoft.com/en-us/resources/azure-virtual-datacenter/)
for more information on the broader concepts behind VDC.
