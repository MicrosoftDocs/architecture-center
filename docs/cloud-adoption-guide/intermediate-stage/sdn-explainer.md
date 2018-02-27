---
title: "Explainer: what is software defined networking?"
description: Explains how software defined networking in the cloud works
author: petertay
---

# Explainer: what is software defined networking?

In the foundational adoption stage, you learned about virtualization technology and how it's used to provide services to millions of customers in Azure. If you deployed an infrastructure-as-a-service virtual machine you were also introduced to the concept of a **virtual network**. Let's take a closer look at **software defined networking**, the technology that makes virtual networking possible.

A physical network that provides connectivity between computers requires a few fundamental pieces in order to function. Each computer needs a network interface controller (NIC) with a unique address. Each of these NICs is physically connected to a switch using a network cable. The switch includes a table that indexes the address of each NIC with the physical connection to that NIC. The switch is interfaced with a router. The router represents the **local network** and has a NIC of its own that is connected to other routers. The router includes a route table that lists the routes other NICs in other local networks. 

One of the problems with a physical network is that the arrangement of the network - also known as the **network topology** - is static. Any change to the network topology requires a physical change. For example, to move a NIC from a first local network to a second local network, the NIC has to be physically disconnected from switch in the first network and connected to the switch in the second network. And, as the number of connected local networks grows, the complexity of the route table in each router also grows.

The solution to this problem is to abstract the function of the NICs, switches, and routers into software. Specialized hardware runs this software, using the underlying physical network to transport the network traffic received at the virtual layer. So, while the physical layer is static and difficult to change, multiple virtual networks can be defined at the software level.

The actual hardware and software that is used for virtual networking in Azure is of course much more complex for optimal security. However, the key takeaway here is that you can create and manage as many virtual networks as your organization requires, and these virtual networks function exactly as your on-premises networks.

## Next steps

Now that you understand the basic functioning of Azure virtual networking, learn about workload or application network isolation in Azure.  