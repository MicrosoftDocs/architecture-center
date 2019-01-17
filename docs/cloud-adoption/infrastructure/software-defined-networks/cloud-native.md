---
title: "Fusion: Software Defined Networks - Cloud native" 
description: Discussion of cloud native virtual networking services
author: rotycenh
ms.date: 12/28/2018
---

# Fusion: Software Defined Networks - Cloud native

A cloud native virtual network is the default model for creating IaaS resources in a cloud platform. Access to cloud native virtual networks from external sources, similar to the web, need to be explicitly provisioned. These types of virtual networks support the creation of subnets, routing rules, and virtual firewall and traffic management devices.  

A cloud native virtual network has no dependencies on your organization's on-premises or other non-cloud resources to support the cloud-hosted workloads. All required resources are provisioned either in the virtual network itself or by using managed PaaS offerings.

## Cloud native assumptions

Deploying a cloud native virtual network assumes the following:

- The workloads you deploy to the virtual network have no dependencies on applications or services that are accessible only from inside your on-premises network. Unless they provide endpoints accessible over the public Internet, applications and services hosted internally on-premises are not usable by resources hosted on a cloud platform.

- Your workload's identity management and access control depends solely on the cloud platform or IaaS servers hosted in your cloud environment. You will not directly use identity services hosted on-premises or other external location.

- Your identity services do not need to support single sign-on (SSO) with on-premises directories.

> [!TIP]
> Cloud native virtual networks are the default when you configure networking in cloud platforms, and have no external dependencies. This makes them simple to deploy and configure, and as a result this architecture is often the best choice for experiments or other smaller self-contained or rapidly iterating deployments.
>
> Additional issues your Cloud Adoption Team should consider when discussing a cloud native virtual networking architecture include:
> - Existing workloads designed to run in an on-premises datacenter may need extensive modification to take advantage of cloud-based functionality, such as storage or authentication services.
> - Cloud native networks are managed solely through the cloud platform management tools, and therefore may lead to management and policy divergence from your existing IT standards as time goes on.

## Cloud native Azure networks

![Simple cloud native virtual network with a single VM and Public IP address](../../_images/infra-sdn-figure1.png)

A cloud native network is the default configuration for newly created Azure
virtual networks. By default, resources connected to these virtual networks have
outbound connectivity (although this can be controlled using NSGs). Connections
with other virtual networks are possible through peering.

To provide inbound access to any of the VMs or devices connected to the network,
you will need to provision public IP resources and set the appropriate NSG rules
for allowing this traffic. Within the network, subnets, firewalls, load balancers,
and routing rules can all be configured to manage traffic.

By default, identity and authentication services for a cloud native workload are
either provided by Azure Active Directory or devices provisioned within the
virtual network.

Note that any single virtual network and connected resources can only exist
within a single subscription, and is bound by [subscription
limits](/azure/azure-subscription-service-limits).

## Next steps

Learn about the [hybrid](hybrid.md) virtual network architecture.

> [!div class="nextstepaction"]
> [Hybrid](hybrid.md)
