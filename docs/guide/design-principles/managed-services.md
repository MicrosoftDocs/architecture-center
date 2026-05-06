---
title: Use platform as a service (PaaS) options
description: "Understand the difference between infrastructure as a service (IaaS) and platform as a service (PaaS). Learn how to swap IaaS components for PaaS solutions."
author: johndowns
ms.author: pnp
ms.date: 10/05/2024
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Use platform as a service (PaaS) options

Infrastructure as a service (IaaS) and platform as a service (PaaS) are cloud service models.

IaaS offers access to computing resources like servers, storage, and networks. The IaaS provider hosts and manages this infrastructure. Customers use the internet to access the hardware and resources.

In contrast, PaaS provides a framework for developing and running apps. As with IaaS, the PaaS provider hosts and maintains the platform's servers, networks, storage, and other computing resources. But PaaS also includes tools, services, and systems that support the web application lifecycle. Developers use the platform to build apps without having to manage backups, security solutions, upgrades, and other administrative tasks.

## Advantages of PaaS over IaaS

When your workload doesn't require the control granted by IaaS, use PaaS instead. IaaS is like having a box of parts. You can build anything, but you have to assemble it yourself. PaaS options are easier to configure and administer. You don't need to set up virtual machines (VMs). You also don't have to handle all of the component's maintenance tasks, such as installing patches and updates.

Many PaaS solutions offer a native scaling option that allow you to configure how the service will scale in and out or up and down. While scaling is possible in IaaS, it often comes with added complexity, such as dealing with attached storage.

For example, suppose your application needs a message queue. You can set up your own messaging service on a virtual machine by using something like RabbitMQ. But Azure Service Bus provides a reliable messaging service, and it's simpler to maintain. You can create a Service Bus namespace as part of a deployment script. Then you can use a client SDK to call Service Bus.

## PaaS alternatives to IaaS solutions

Your application might have specific requirements that make IaaS a more suitable approach than PaaS. But you can still look for places to incorporate PaaS options. A few examples include caches, queues, and data storage. The following table provides other examples.

| Instead of running ... | Consider using ... |
|-----------------------|-------------|
| Active Directory | [Microsoft Entra ID](/entra/fundamentals/whatis) |
| Elasticsearch | [Azure AI Search](/azure/search/search-what-is-azure-search) |
| Hadoop | [Azure HDInsight](/azure/hdinsight/hdinsight-overview) |
| IIS | [Azure App Service](/azure/app-service/overview) |
| MongoDB | [Azure DocumentDB](/azure/documentdb/overview) |
| Redis | [Azure Managed Redis](/azure/redis/overview) |
| SQL Server | [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) |
| File share | [Azure Files](/azure/storage/files/storage-files-introduction) |

This list isn't exhaustive. There are many ways that you can exchange self-managed, IaaS technologies for related PaaS solutions.
