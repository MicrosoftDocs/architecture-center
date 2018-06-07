---
title: "Explainer: how does Azure work?"
description: Explains the internal functioning of Azure
author: petertay
---

# Explainer: how does Azure work?

Azure is Microsoft's public cloud platform. Azure offers a large collection of services including platform as a service (PaaS), infrastructure as a service (IaaS), database as a service (DBaaS), and many others. But what exactly is Azure, and how does it work?

Azure, like other cloud platforms, relies on a technology known as **virtualization**. Most computer hardware can be emulated in software, because most computer hardware is simply a set of instructions permanently or semi-permanently encoded in silicon. Using an emulation layer that maps software instructions to hardware instructions, virtualized hardware can execute in software as if it were the actual hardware itself.

Essentially, the cloud is a set of physical servers in one or more datacenters that execute virtualized hardware on behalf of customers. So how does the cloud create, start, stop, and delete millions of instances of virtualized hardware for millions of customers simultaneously?

To understand this, let's look at the architecture of the hardware in the datacenter.  Within each datacenter is a collection of servers sitting in server racks. Each server rack contains many server **blades** as well as a network switch providing network connectivity and a power distribution unit (PDU) providing power. Racks are sometimes grouped together in larger units known as **clusters**. 

Within each rack or cluster, most of the servers are designated to run these virtualized hardware instances on behalf of the user. However, a number of the servers run cloud management software known as a fabric controller. The **fabric controller** is a distributed application with many responsibilities. It allocates services, monitors the health of the server and the services running on it, and heals servers when they fail.

Each instance of the fabric controller is connected to another set of servers running the software that send commands to the fabric controllers, known as an **orchestrator**. In addition to the command and control of the fabric controllers, the orchestrator stores information about resources (including resource usage for calculating cost), implements the controls for governing access to resources, and performs many other functions.

So, very simply, Azure is a huge collection of servers and networking hardware, along with a complex set of distributed applications that orchestrate the configuration and operation of the virtualized hardware and software on those servers. And it is this orchestration that makes Azure so powerful - users are no longer responsible for maintaining and upgrading hardware, Azure does all this behind the scenes. 

## Next steps

* Now that you understand how Azure works and how resources are managed, learn about [Azure resource access governance](governance-explainer.md).