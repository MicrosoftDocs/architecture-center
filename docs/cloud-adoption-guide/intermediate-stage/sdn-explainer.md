---
title: "Explainer: what is software defined networking?"
description: Explains how software defined networking in the cloud works
author: petertay
---

# Explainer: what is software defined networking?

In the foundational adoption stage, you learned about virtualization technology and how it's used to provide services to millions of customers in Azure. You were also introduced to the concept of a **virtual network** if you deployed an infrastructure-as-a-service virtual machine. Let's take a closer look at **software defined networking**, the technology that makes virtual networking possible.

A physical network that provides connectivity between computers requires a few fundamental pieces in order to function. Each computer needs a network interface controller (NIC) with a unique address. Each NIC is connected to centralized networking hardware that knows how to route communication between NIC addresses. The networking hardware maintains tables that index NIC addresses and network routes between them, and is only concerned with moving data between NICs. The technical term for this is the **control plane**. 

One of the problems with a physical network is that the arrangement of the network - also known as the **network topology** - is static. Any change to the network topology requires a physical change to the centralized networking hardware. For example, to move a NIC from one location on a route to another location on a route, the NIC has to be physically disconnected from one piece of centralized networking hardware and connected to a different piece of centralized networking hardware.

Recall from earlier that the networking hardware maintains a table of NIC address indexed to routes. The solution to this problem is to allow the centralized networking hardware to associate a set of virtual network addresses with a set of virtual routes in additional tables. The result is that the networking hardware can receive data from a first virtual address and send data along a virtual route to a second virtual address using the physical layer. 

This allows the physical layer to remain fixed while the virtual network can change dynamically. The centralized networking hardware can also host multiple virtual networks and transport data between virtual NICs in different virtual networks. The virtual network topology is easily changed by changing the values in the virtual network tables.

In reality software defined networks are more complex to ensure they are secure. For example, centralized networking hardware hosting virtual networks for two separate organizations must implement security features to ensure the two networks are inaccessible to each other. However, this is fundamentally how virtual networks work in Azure.

## Next steps

Now that you understand the basic functioning of Azure virtual networking, learn about how applications and workloads are isolated in Azure.