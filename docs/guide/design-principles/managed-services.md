---
title: Use platform as a service (PaaS) options
titleSuffix: Azure Architecture Center
description: "Understand the difference between infrastructure as a service (IaaS) and platform as a service (PaaS). Learn how to swap IaaS components for PaaS solutions."
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.custom:
  - seojan19
  - guide
products:
  - azure
categories:
  - developer-tools
  - management-and-governance
---

# Use platform as a service (PaaS) options

Infrastructure as a service (IaaS) and platform as a service (PaaS) are cloud service models.

IaaS offers access to computing resources like servers, storage, and networks. The IaaS provider hosts and manages this infrastructure. Customers use the internet to access the hardware and resources.

In contrast, PaaS provides a framework for developing and running apps. As with IaaS, the PaaS provider hosts and maintains the platform's servers, networks, storage, and other computing resources. But PaaS also includes tools, services, and systems that support the web application lifecycle. Developers use the platform to build apps without having to manage backups, security solutions, upgrades, and other administrative tasks.

## Advantages of PaaS over IaaS

When it's possible, use PaaS instead of IaaS. IaaS is like having a box of parts. You can build anything, but you have to assemble it yourself. PaaS options are easier to configure and administer. You don't need to set up virtual machines (VMs) or virtual networks. You also don't have to handle maintenance tasks, such as installing patches and updates.

For example, suppose your application needs a message queue. You can set up your own messaging service on a VM by using something like RabbitMQ. But Azure Service Bus provides a reliable messaging service, and it's simpler to set up. You can create a Service Bus namespace as part of a deployment script. Then you can use a client SDK to call Service Bus.

## PaaS alternatives to IaaS solutions

Your application might have specific requirements that make IaaS a more suitable approach than PaaS. But you can still look for places to incorporate PaaS options. A few examples include caches, queues, and data storage. The following table provides other examples.

| Instead of running ... | Consider using ... |
|-----------------------|-------------|
| Active Directory | [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) |
| Elasticsearch | [Azure Cognitive Search](/azure/search/search-what-is-azure-search) |
| Hadoop | [Azure HDInsight](/azure/hdinsight/hdinsight-overview) |
| IIS | [Azure App Service](/azure/app-service/overview) |
| MongoDB | [Azure Cosmos DB](/azure/cosmos-db/introduction) |
| Redis | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |
| SQL Server | [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) |
| File share | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) |

This list isn't exhaustive. There are many ways that you can exchange IaaS technologies for related PaaS solutions.
