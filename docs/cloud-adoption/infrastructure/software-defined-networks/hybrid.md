---
title: "Fusion: Software Defined Networks - Hybrid network" 
description: Discussion of how hybrid networks allow your cloud virtual networks to connect to on-premises resources
author: rotycenh
ms.date: 12/29/2018
---

# Fusion: Software Defined Networks - Hybrid networks

The hybrid cloud network architecture allows virtual networks to access your on-premises resources and services and vice versa, using a virtual private network (VPN) or other connection to directly connect the networks.

As with a cloud native virtual network, a hybrid virtual network is isolated by default. Adding connectivity to the on-premises environment grants access to and from the on-premises network, although all other inbound traffic targeting resources
in the virtual network need to be explicitly allowed. You can secure the connection using virtual firewall devices and routing rules to limit access or you can specify exactly what services can be accessed between the two networks.

The [virtual datacenter (VDC) concept](vdc-networking.md) extends the hybrid cloud architecture by connecting your on-premises environment with multiple virtual networks in the cloud, while providing central management and access control mechanisms. This also enables you to support consistent policy and governance across your entire IT infrastructure.

## Hybrid assumptions

Deploying a hybrid virtual network assumes the following:

- Your infrastructure as a service (IaaS) workloads require access to storage, applications, and services hosted on your on-premises or third-party networks

- You need to migrate existing applications and services that depend on on-premises resources without extensive redevelopment

- Your on-premises or other external environments are able to provision external VPN or similar connectivity mechanism that the cloud network can connect to

- Your deployments do not require complicated a structure to bypass account and subscription resource limits

> [!TIP]
> Your Cloud Adoption Team should consider the following issues when looking at implementing a hybrid virtual networking architecture:
> - Connecting on-premises networks with cloud networks increases the complexity of your security requirements. Both networks need to be secured against external vulnerabilities and unauthorized access from both sides of the hybrid environment.
> - Scaling the number and size of workloads within a hybrid cloud environment can add significant complexity to routing and traffic management.
> - You will need to develop compatible management and access control policies to maintain consistent governance throughout your organization.

## Hybrid networks on Azure

![Example hybrid virtual network containing a DMZ and n-tier application](../../_images/infra-sdn-figure2.png)

Azure hybrid virtual networks use either an ExpressRoute circuit or Azure VPN
to connect your virtual network with your organization's existing non-Azure
hosted IT assets.

As it is with a basic cloud native virtual network, a hybrid virtual network is
isolated by default. Adding the on-premises connectivity only grants access to
and from the on-premises network. Inbound traffic targeting resources in the
virtual network can be implemented using network security group (NSG) rules and 
Public IPs. The connection can be secured using virtual firewalls and routing 
rules to limit access and specify exactly what services can be accessed between 
the two networks.

In addition to giving Azure resources access to on-premises applications and
data, a hybrid network allows access to on-premises directory and identity
services. This provides Azure resources access to authentication technologies
that may not be available through Azure Active Directory (Azure AD) or Azure
AD Connect.

For an example of how to implement a secure hybrid virtual network see [this
example at the Azure Architecture
Center](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-hybrid).

## Next steps

Learn about the [virtual datacenter](vdc-networking.md) architecture.

> [!div class="nextstepaction"]
> [Virtual Datacenter](vdc-networking.md)
