---
title: Explainer - How does Azure work?
description: Explains the internal functioning of Azure
author: petertay
---

# Explainer: How does Azure work?

Azure is Microsoft's public cloud platform. Azure offers a large collection of services including platform as a service (PaaS), infrastructure as a service (IaaS), database as a service (DBaaS), and many others. But what exactly is Azure, and how does it work?

Azure, like other cloud platforms, relies on a technology known as **virtualization**. Most computer hardware can be emulated in software, because most computer hardware is simply a set of instructions permanently or semi-permanently encoded in silicon. With the aid of an emulation layer that knows how to map software instructions to hardware instructions, virtualized hardware can execute in software as if it were the actual hardware itself.

Essentially, the cloud is a set of physical servers in one or more datacenters that execute virtualized hardware on behalf of customers. So how does the cloud manage creating, starting, stopping, and deleting millions of pieces of virtualized hardware on behalf of millions of customers, all at the same time?

To understand this, let's look at the architecture of the hardware in the datacenter.  Within each datacenter is a collection of servers sitting in server racks. Each server rack contains many server **blades** as well as a top-of-rack (TOR) network switch providing network connectivity and a power distribution unit (PDU) providing power. Racks are sometimes grouped together in larger units known as **clusters**. 

Within each rack or cluster, most of the servers are designated to run these virtualized hardware instances on behalf of the user. However, a number of the servers run cloud management software known as a fabric controller. The **fabric controller** is a distributed application with many responsibilities, such as allocating services, monitoring the health of the server and the services running on it, and healing servers when they fail.

Each instance of the fabric controller is connected to another set of servers running cloud orchestration software, typically known as a **front end**. The front end hosts the web services, RESTful APIs, and databases used for all functions the cloud performs. 

For example, the front end hosts the services that handle customer requests to allocate resources. First, the front end validates the user and verifies the user is authorized to allocate the requested resources. If so, the front end consults a database to locate a server rack with sufficient capacity, and then instructs the fabric controller on the rack to allocate the resource.

So the cloud is just a huge collection of servers and networking hardware, along with a complex set of distributed applications that orchestrate the configuration and operation of the virtualized hardware and software on those servers.  

## Next steps

* Now that you understand the internal functioning of Azure, the first step to adopting Azure is to [understand digital identity in Azure](tenant-explainer.md). You are then ready to [create your first user in Azure AD][docs-add-users-to-aad].

<!-- Links -->

[docs-add-users-to-aad]: /azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json
