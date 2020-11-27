---
title: Use platform as a service (PaaS) options
titleSuffix: Azure Application Architecture Guide
description: When possible, choose platform as a service (PaaS) over infrastructure as a service (IaaS).
author: doodlemania2
ms.date: 08/30/2018
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.custom:
  - seojan19
  - guide
---

# Use platform as a service (PaaS) options

## When possible, use platform as a service (PaaS) rather than infrastructure as a service (IaaS)

IaaS is like having a box of parts. You can build anything, but you have to assemble it yourself. PaaS options are easier to configure and administer. You don't need to provision VMs, set up VNets, manage patches and updates, and all of the other overhead associated with running software on a VM.

For example, suppose your application needs a message queue. You could set up your own messaging service on a VM, using something like RabbitMQ. But Azure Service Bus already provides reliable messaging as service, and it's simpler to set up. Just create a Service Bus namespace (which can be done as part of a deployment script) and then call Service Bus using the client SDK.

Of course, your application may have specific requirements that make an IaaS approach more suitable. However, even if your application is based on IaaS, look for places where it may be natural to incorporate PaaS options. These include cache, queues, and data storage.

| Instead of running... | Consider using... |
|-----------------------|-------------|
| Active Directory | [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis) |
| Elasticsearch | [Azure Search](/azure/search/search-what-is-azure-search) |
| Hadoop | [HDInsight](/azure/hdinsight/hdinsight-overview) |
| IIS | [App Service](/azure/app-service/overview) |
| MongoDB | [Cosmos DB](/azure/cosmos-db/introduction) |
| Redis | [Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview) |
| SQL Server | [Azure SQL Database](/azure/sql-database/sql-database-technical-overview) |
| File share | [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) |

Please note that this is not meant to be an exhaustive list, but a subset of equivalent options.