---
title: Use Azure PaaS and SaaS services
description: Review the design choices for managed services in Azure. Find architecture areas where platform as a service (PaaS) is appropriate, such as caching and queues.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Managed services

Look for areas in the architecture where it may be natural to incorporate platform-as-a-service (PaaS) options. These include caching, queues, and data storage. PaaS reduces time and cost of managing servers, storage, networking, and other application infrastructure.

With PaaS, the infrastructure cost is included in the pricing model of the service. For example, you can provision a lower SKU virtual machine as a jumpbox. There are additional costs for storage and managing a separate server. You also need to configure a public IP on the virtual machine, which is not recommended. A managed service such as Azure Bastion takes into consideration all those costs and offers better security.

Azure provides a wide range of PaaS resources. Here are some examples of when you might consider PaaS options:

|Task|Use|
|---|---|
|Host a web server| [Azure App Service](/azure/app-service/) instead of setting up IIS servers.|
|Indexing and querying heterogenous data|[Azure Cognitive Search](/azure/search/search-what-is-azure-search) instead of ElasticSearch.|
|Host a database server|Azure offers many SQL and no-SQL options such as Azure SQL Database and Azure Cosmos DB.|
|Secure access to virtual machine|[Azure Bastion](/azure/bastion) instead of virtual machines as jump boxes.|
|Network security|[Azure Firewall](/azure/firewall/) instead of virtual network appliances.|

For more information, see [Use platform as a service (PaaS) options](../../guide/design-principles/managed-services.md).

**Reference architecture**

To see an implementation that provides better security and lowers cost through PaaS services, see [Network DMZ between Azure and an on-premises datacenter](../../reference-architectures/dmz/secure-vnet-dmz.yml).
