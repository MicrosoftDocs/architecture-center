---
title: Use a suitable data store
titleSuffix: Azure Architecture Center
description: "Pick the storage technology that's the best fit for how you use your data. Learn about alternatives to relational databases. Consider polyglot persistence."
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.category:
  - storage
  - databases
ms.custom:
  - seojan19
  - guide
products:
  - azure
  - azure-cognitive-search
  - azure-cosmos-db
categories:
  - databases
  - storage
---

# Use the best data store for your data

In the past, many organizations stored all their data in large relational SQL databases. Relational databases are good at providing atomic, consistent, isolated, and durable (ACID) guarantees for transactions that involve relational data. But these databases come with costs:

- Queries can require expensive joins.
- You need to normalize the data and restructure it for schema on write.
- Lock contention can affect performance.

## Alternatives to relational databases

In a large solution, a single data store technology probably doesn't meet all your needs. Alternatives to relational databases include:

- Key/value stores
- Document databases
- Search engine databases
- Time series databases
- Column family databases
- Graph databases

Each has pros and cons, and different types of data fit more naturally into different data store types. Pick the storage technology that's the best fit for your data and how you use it.

For example, you might store a product catalog in a document database, such as Azure Cosmos DB, which supports a flexible schema. In that case, each product description is a self-contained document. For queries over the entire catalog, you might index the catalog and store the index in Azure Cognitive Search. Product inventory might go into a SQL database, because that data requires ACID guarantees.

## Recommendations

- Don't use a relational database for everything. Consider other data stores when it's appropriate. For information on common storage models, see [Understand data store models][data-store-overview].

- Remember that data includes more than just persisted application data. It also includes application logs, events, messages, and caches.

- Embrace *polyglot persistence*, or solutions that use a mix of data store technologies.

- Consider the type of data that you have. For example:

  - Put transactional data into a SQL database.
  - Store JSON documents in a document database.
  - Use a time series data base for telemetry.
  - Put application logs into Azure Cognitive Search.
  - Choose Azure Blob Storage for blobs.

- Prefer availability over (strong) consistency. The [CAP theorem][CAP theroem] implies that distributed systems have to make trade-offs between availability and consistency. You can never completely avoid network partitions, the other leg of the CAP theorem. But you can often achieve higher availability by adopting an [eventual consistency][Eventual consistency] model.

- Consider the skill set of your development team. There are advantages to using polyglot persistence, but it's possible to go overboard. Adopting a new data storage technology requires a new set of skills. To get the most out of the technology, the development team needs to understand how to:

  - Optimize queries.
  - Tune for performance.
  - Work with appropriate usage patterns.

  Consider these factors when you choose a storage technology.

- Use [compensating transactions][Compensating Transaction pattern]. A side effect of polyglot persistence is that a single transaction might write data to multiple stores. If something fails, use compensating transactions to undo any steps that already finished.

- Look at *bounded contexts*, a concept from domain-driven design. A bounded context is an explicit boundary around a domain model. A bounded context defines which parts of the domain the model applies to. Ideally, a bounded context maps to a subdomain of the business domain. The bounded contexts in your system are a natural place to consider polyglot persistence. For example, *products* might appear in the Product Catalog subdomain and the Product Inventory subdomain. But most likely, these two subdomains have different requirements for storing, updating, and querying products.

## Next steps

- [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options)
- [Architect storage infrastructure in Azure](/training/paths/architect-storage-infrastructure)
- [Store data in Azure](/training/paths/store-data-in-azure)

## Related resources

- [Azure Data Architecture Guide](../../data-guide/index.md)
- [Databases architecture design](../../data-guide/databases-architecture-design.yml)
- [Understand data store models](../technology-choices/data-store-overview.md)
- [Compensating Transaction pattern](../../patterns/compensating-transaction.yml)

[CAP theroem]: /previous-versions/msp-n-p/dn589800(v=pandp.10)#eventual-consistency
[Compensating Transaction pattern]: ../../patterns/compensating-transaction.yml
[data-store-overview]: ../technology-choices/data-store-overview.md
[Eventual consistency]: /previous-versions/msp-n-p/dn589800(v=pandp.10)#eventual-consistency
