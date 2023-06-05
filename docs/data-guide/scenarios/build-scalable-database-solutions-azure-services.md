---
title: Choose an Azure data storage system
description: Use Azure services to build scalable, resilient, affordable, highly available systems that can handle massive amounts of data.
author: nabilshams
ms.author: nasiddi
categories: azure
ms.date: 06/21/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - databases
  - storage
  - web
products:
  - azure-cosmos-db
  - azure-data-factory
  - azure-data-lake-storage
  - azure-table-storage
  - azure-web-apps
ms.custom:
  - fcp
  - guide
---

# Choose an Azure data storage system

Your data storage system is fundamental to your applications' success, and therefore to the success of your enterprise.

A well-architected data storage system is:

- Fast and easy to implement.
- Readily scalable to handle data growth.
- Responsive and performant.
- Highly available and resilient to failure.
- Affordable.

A crucial consideration is how well a design scales as data grows. Consider an application that generates 6 terabytes (TB) of data its first month, with data increasing at a 10 percent yearly rate. The following graph shows how that data accumulates over time:

:::image type="content" source="../images/build-scalable-database-solutions-azure-services-data-growth.svg" alt-text="A line graph showing terabytes created over time, from 6 T B after one month to 249 after three years. The 10 percent growth rate steepens the slope over time.":::

After three years, there's 249 TB of data. The 10 percent growth rate steepens the slope over time.

This example isn't atypical. Data grows both as you add customers, and as your customers add data. Data can also grow because of application enhancements. A well architected system handles such data growth gracefully, remaining responsive, resilient, and affordable.

## Design a data storage system

To design a data storage system on Azure, learn about how to use the many Azure services for various applications and objectives. Meeting data storage needs might require a mix of products. For example, you could keep rarely accessed data in low-cost services, and frequently accessed data in higher-cost services with faster access times.

The articles in the following table outline seven system architectures for web applications. These systems can handle massive amounts of data and are resilient to system failures. These architectures use [Azure Table storage](https://azure.microsoft.com/services/storage/tables), [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db), [Azure Data Factory](https://azure.microsoft.com/services/data-factory), and [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage).

These examples can help you design a data storage system that accommodates your applications. The following capability matrix provides links to the articles, and summarizes the benefits and drawbacks of each architecture:

| Architecture | Benefits | Drawbacks |
|---------|----------|-------|
|[Two-region web application with Table Storage failover](../../solution-ideas/articles/multi-region-web-app-azure-table-failover.yml)|Easy implementation, cost|Limited resiliency with only two Azure regions|
|[Multi-region web application with custom Storage Table replication](../../solution-ideas/articles/multi-region-web-app-multi-writes-azure-table.yml)|Resiliency|Implementation time and difficulty|
|[Multi-region web application with Azure Cosmos DB replication](../../solution-ideas/articles/multi-region-web-app-cosmos-db-replication.yml)|Resiliency, performance, scalability|Cost|
|[Optimized storage with logical data classification](../../solution-ideas/articles/optimized-storage-logical-data-classification.yml)|Resiliency, performance, scalability, cost|Implementation time, need to design logical data classification|
|[Optimized Storage – time based – multi writes](../../solution-ideas/articles/optimized-storage-time-based-multi-writes.yml)|Cost|Resiliency, performance, scalability, implementation time, need to design time-based data retention|
|[Optimized Storage – time based with Data Lake](../../solution-ideas/articles/optimized-storage-time-based-data-lake.yml)|Resiliency, performance, scalability|Implementation time, need to design time-based data retention|
|[Minimal storage – change feed to replicate data](../../solution-ideas/articles/minimal-storage-change-feed-replicate-data.yml)|Resiliency, performance, time-based data retention|Scalability, implementation time|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams) | Cloud Solution Architect - Digital and Application Innovation

## Next steps

- [Choose a data storage approach in Azure](/training/modules/choose-storage-approach-in-azure)
- [Developing with Azure Cosmos DB for Table and Azure Table storage](/azure/cosmos-db/table-support)

## Related resources

- [Understand data store models](../../guide/technology-choices/data-store-overview.md)
- [Choose a big data storage technology in Azure](../technology-choices/data-storage.md)
- [Select an Azure data store for your application](../../guide/technology-choices/data-store-decision-tree.md)
- [Criteria for choosing a data store](../../guide/technology-choices/data-store-considerations.md)
- [Time series data](time-series.yml)
