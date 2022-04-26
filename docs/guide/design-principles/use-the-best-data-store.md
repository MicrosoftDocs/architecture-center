---
title: Use a suitable data store
titleSuffix: Azure Architecture Center
description: Pick the storage technology that's the best fit for your data and how it will be used within your Azure application architecture.
author: EdPrice-MSFT
ms.author: pnp
ms.date: 04/27/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
ms.category:
  - storage
  - databases
ms.custom:
  - seojan19
  - guide
---

# Use the best data store for your data

Many organizations used to store all their data in large relational SQL databases. Relational databases are very good at providing ACID guarantees for transactions that involve relational data. But these databases come with some costs:

- Queries can require expensive joins.
- You need to normalize the data and restructure it for schema on write.
- Lock contention can impact performance.

## Alternatives to relational databases

In any large solution, a single data store technology probably won't meet all your needs. Alternatives to relational databases include key/value stores, document databases, search engine databases, time series databases, column family databases, and graph databases. Each has pros and cons, and different types of data fit more naturally into different data store types. Pick the storage technology that's the best fit for your data and how you use it.

For example, you might store a product catalog in a document database, such as Azure Cosmos DB, which allows for a flexible schema. In that case, each product description is a self-contained document. For queries over the entire catalog, you might index the catalog and store the index in Azure Cognitive Search. Product inventory might go into a SQL database, because that data requires atomic, consistent, isolated, and durable (ACID) guarantees.

## Recommendations

- Don't use a relational database for everything. Consider other data stores when it's appropriate. For information on common storage models, see [Understand data store models][data-store-overview].

- Remember that data includes more than just persisted application data. It also includes application logs, events, messages, and caches.

- Embrace *polyglot persistence*, or solutions that use a mix of data store technologies. In any large solution, it's likely that a single technology won't fill all your needs.

- Consider the type of data. For example:

  - Put transactional data into a SQL database.
  - Store JSON documents in a document database.
  - Use a time series data base for telemetry.
  - Put application logs in Elasticsearch.
  - Choose Azure Blob Storage for blobs.

- Prefer availability over (strong) consistency. The [CAP theorem][CAP theroem] implies that distributed systems have to make trade-offs between availability and consistency. You can never completely avoid network partitions, the other leg of the CAP theorem. But you can often achieve higher availability by adopting an *eventual consistency* model.

- Consider the skill set of your development team. There are advantages to using polyglot persistence, but it's possible to go overboard. Adopting a new data storage technology requires a new set of skills. The development team needs to know how to:

  - Get the most out of the technology.
  - Optimize queries.
  - Tune for performance.
  - Work with appropriate usage patterns.

  Consider these factors when you choose a storage technology.

- Use compensating transactions. A side effect of polyglot persistence is that a single transaction might write data to multiple stores. If something fails, use compensating transactions to undo any steps that already finished.

- Look at bounded contexts. *Bounded context* is a term from domain driven design. A bounded context is an explicit boundary around a domain model, and defines which parts of the domain the model applies to. Ideally, a bounded context maps to a subdomain of the business domain. The bounded contexts in your system are a natural place to consider polyglot persistence. For example, "products" may appear in both the Product Catalog subdomain and the Product Inventory subdomain, but it's very likely that these two subdomains have different requirements for storing, updating, and querying products.

[data-store-overview]: ../technology-choices/data-store-overview.md
[CAP theroem]: https://wikipedia.org/wiki/CAP_theorem