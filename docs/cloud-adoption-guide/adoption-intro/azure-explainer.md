---
title: Explainer - How does Azure work?
description: Explanation of the internal functioning of Azure
author: petertay
---
<!-->
prerequisites: none
<-->

# Explainer: How does Azure work?

Azure is Microsoft's public cloud platform. Azure offers a large collection of services including platform as a service (PaaS), infrastructure as a service (IaaS), database as a service (DBaaS), and many others. But what exactly is Azure, and how does it work?

Azure, as with all other cloud platforms, relies on a technology known as virtualization. The term virtualization refers to the fact that most computer hardware can be emulated in software. This is possible because most computer hardware is simply a set of instructions permanently or semi-permanently encoded in silicon. With the aid of an emulation layer that knows how to map software instructions to hardware instructions, virtual hardware can execute in software just as though it were the actual hardware itself.

Put simply, the cloud is a set of physical servers in a datacenter or multiple datacenters that are executing virtualized hardware on behalf of customers. So how does the cloud manage creating, starting, stopping, and deleting millions of pieces of virtualized hardware on behalf of millions of customers, all at the same time?

To understand this, we need to look at the architecture of the hardware in the datacenter.  Within each datacenter is a collection of servers sitting in server racks. Each server rack contains many server "blades" as well as a top-of-rack (TOR) network switch providing network connectivity and a power distribution unit (PDU) providing power. Racks are sometimes grouped together in larger units known as "clusters". 

Within each rack or cluster, most of the servers are designated to run these virtualized hardware instances on behalf of the user. However, a number of the servers run cloud management software known as a "fabric controller". The fabric controller is a distributed application responsible for many things, including allocating services, monitoring health of the server and the services running on it, and healing servers when they fail.

Each instance of the fabric controller is connected to another set of servers running cloud orchestration software, typically known as a "front end". The front end hosts the web services, RESTful APIs, and databases used for all functions the cloud performs. 

For example, the front end hosts the services that respond to customer requests to allocate a resource by validating the user and authorizing that they are allowed to allocate the resources, and if so, consulting a database to locate a server rack with capacity, and finally contacting the fabric controller on the rack with instructions and data to allocate the resource.

So the cloud really is just a very large collection of servers and networking hardware with a very large and complex set of distributed applications that orchestrate the configuration and operation of the virtualized hardware and software running within it.  

# Next steps

In the explainer above, you learned that the front end validates a user and authorizes they are allowed to perform the operation they have requested. Learn more about how validation and authorization work in the cloud by reading about enterprise digital identity in Azure.