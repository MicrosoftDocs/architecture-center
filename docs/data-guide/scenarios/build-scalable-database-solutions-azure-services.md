---
title: Build a scalable system for massive data
description: Learn how to use Azure services to build scalable, resilient, and affordable high-available systems that handle massive amounts of data.
author: nabilshams
ms.author: nasiddi
categories: azure
ms.date: 09/14/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - databases
  - web
  - migration
  - storage
products:
  - azure-front-door
  - azure-app-service
  - azure-functions
  - azure-table-storage
  - azure-cosmos-db
ms.custom:
  - fcp
  - guide
---

# Build a scalable system for massive data

Your data storage system is fundamental to the success of your applications, and therefore to the success of your enterprise. When the storage system is well architected, response is quick, data storage capacity is easily adjusted as necessary, the system is resilient to failures, and it's affordable.

A crucial consideration is whether the design scales well as data grows. As an example of data growth, consider an application that generates 6 terabytes (TB) of data its first month, with the amount increasing every month at a 10 percent yearly rate. Here's a graph that shows how data accumulates over time:

:::image type="content" source="../images/build-scalable-database-solutions-azure-services-data-growth.svg" alt-text="A line graph of terabytes created over time, from 6 after one month to 249 after 3 years. The 10 percent growth rate steepens the slope over time.":::

After three years, there's 249 TB of data. If the system is well architected, it handles such data growth gracefully, remaining responsive, resilient, and affordable.

This example isn't extreme. If your customers are businesses, data grows both as you add customers and as your customers add data. It can also grow because of application enhancements.

Handling data growth may require a mix of storage products. For example, you may need to keep rarely accessed data in low-cost services, and frequently accessed data in higher-cost services with better access times.

To design such a system on Azure, you need to be familiar with the many Azure services and with how to use them for various types of applications and various objectives. The articles in this section provide seven system architectures for web applications that use massive amounts of data and that are resilient to system failures. They serve as examples that can help you design a storage system that properly accommodates your applications.

The architectures demonstrate the use of these Azure products: Azure Table Storage, Azure Cosmos DB, Azure Data Factory, and Azure Data Lake.

This capability matrix provides links to the articles and summarizes the benefits and risks of each architecture:

| Architecture | Benefits | Risks |
|---------|----------|-------|
|[Two-region web application with Table Storage failover](../../solution-ideas/articles/multi-region-web-app-azure-table-failover.yml)|Straightforward, low-cost implementation|Limited resiliency—only two Azure regions|
|[Multi-region web application with custom Storage Table replication](../../solution-ideas/articles/multi-region-web-app-multi-writes-azure-table.yml)|Resiliency|Implementation time and difficulty|
|[Multi-region web application with Cosmos DB replication](../../solution-ideas/articles/multi-region-web-app-cosmos-db-replication.yml)|Resiliency, performance, scalability|Storage costs|
|[Optimized storage with logical data classification](../../solution-ideas/articles/optimized-storage-logical-data-classification.yml)|Resiliency, performance, scalability, storage costs|Implementation time, need to design logical data classification|
|[Optimized Storage – time based – multi writes](../../solution-ideas/articles/optimized-storage-time-based-multi-writes.yml)|Storage costs|Limited resiliency, performance, limited scalability, implementation time, need to design time-based data retention|
| [Optimized Storage – time based with Data Lake](../../solution-ideas/articles/optimized-storage-time-based-data-lake.yml)|Resiliency, performance, scalability|Implementation time, need to design time-based data retention|
|[Minimal storage – change feed to replicate data](../../solution-ideas/articles/minimal-storage-change-feed-replicate-data.yml)|Resiliency, performance, time-based data retention|Limited scalability, implementation time|

## Next steps

Here are resources to help you design your storage solution and investigate its business aspects, including costs and service-level agreements.

### Design storage solutions

- [Build great solutions with the Microsoft Azure Well-Architected Framework](/learn/paths/azure-well-architected-framework)
- [Understand data store models](../../guide/technology-choices/data-store-overview.md)
- [Select an Azure data store for your application](../../guide/technology-choices/data-store-decision-tree.md)
- [Criteria for choosing a data store](../../guide/technology-choices/data-store-considerations.md)
- [Choose a data storage approach in Azure](/learn/modules/choose-storage-approach-in-azure)
- [Developing with Azure Cosmos DB Table API and Azure Table storage](/azure/cosmos-db/table-support)

### Azure service limits, cost, service level agreements (SLA), and regional availability

- [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits)
- [Azure pricing](https://azure.microsoft.com/pricing)
- [Service-level agreements](https://azure.microsoft.com/support/legal/sla)
- [Products available by region](https://azure.microsoft.com/global-infrastructure/services)
