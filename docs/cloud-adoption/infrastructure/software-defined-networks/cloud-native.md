---
title: "Fusion: Software Defined Networks - Cloud Native" 
description: Discussion of cloud native virtual networking services.
author: rotycenh
ms.date: 11/07/2018
---

# Fusion: Software Defined Networks - Cloud native

A cloud native virtual network has no dependencies on your organization's
on-premises or other non-cloud resources to support the cloud-hosted workloads.
All required resources are provisioned either in the virtual network itself or
using managed PaaS offerings.

A cloud native virtual network is the default
model when creating IaaS resources in a cloud platform, and access to it from
external sources like the web need to be explicitly provisioned. These virtual networks support the creation of subnets, routing rules, and virtual firewall and traffic management devices.  

**Cloud Native Assumptions:** Deploying a cloud native virtual network assumes the following:

- The workloads you deploy into the virtual network have no dependencies on applications or services only accessible from inside your on-premises network. Unless they provide endpoints accessible over the public internet, applications and services hosted internally on-premises are not usable by resources hosted on a cloud platform.

- Your workload's identity management and access control depends solely on the cloud platform or IaaS servers hosted in your cloud environment. You will not directly use identity services hosted on-premises or other external location.

- Your identity services do not need to support single sign-on (SSO) with on-premises directories.

> [!TIP]
> Cloud native virtual networks are the default when configuring networking in cloud platforms, and have no external dependencies. This makes them simple to deploy and configure. As a result, this architecture is often the best choice for experiments or other smaller, self-contained, or rapidly iterating deployments. Other issues your Cloud Adoption Team should consider when discussing a cloud native virtual networking architecture:
> - Existing workloads designed to run in an on-premises datacenter may need extensive modification to take advantage of cloud-based functionality such as storage or authentication services.
> - Cloud native networks are managed solely through the cloud platform management tools, and may lead to management and policy divergence from your existing IT standards as time goes on.

## Cloud Native Azure Networks

![Simple cloud native virtual network with a single VM and Public IP address](../../_images/infra-sdn-figure1.png)

A cloud native network is the default configuration for a newly created Azure
virtual networks. By default resources connected to the virtual network have
outbound connectivity (although this can be controlled using NSGs). Connections
with other virtual networks are possible through peering.

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

## Next steps

Learn about the [hybrid](hybrid.md) virtual network architecture.

> [!div class="nextstepaction"]
> [Hybrid](hybrid.md)