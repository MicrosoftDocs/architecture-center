---
title: Choose a search data store
description: Learn about the capabilities of search data stores in Azure and the key criteria for choosing one that best matches your needs.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products: 
  - azure-cognitive-search
---

# Choose a search data store in Azure

This article compares technology choices for search data stores in Azure. A search data store is used to create and store specialized indexes for performing searches on free-form text. The text that is indexed may reside in a separate data store, such as blob storage. An application submits a query to the search data store, and the result is a list of matching documents. For more information about this scenario, see [Processing free-form text for search](../scenarios/search.yml).

## What are your options when choosing a search data store?

In Azure, all of the following data stores will meet the core requirements for search against free-form text data by providing a search index:

- [Azure Cognitive Search](/azure/search/search-what-is-azure-search)
- [Elasticsearch](https://azuremarketplace.microsoft.com/marketplace/apps/elastic.elasticsearch?tab=Overview)
- [Azure SQL Database with full text search](/sql/relational-databases/search/full-text-search)

## Key selection criteria

For search scenarios, begin choosing the appropriate search data store for your needs by answering these questions:

- Do you want a managed service rather than managing your own servers?

- Can you specify your index schema at design time? If not, choose an option that supports updateable schemas.

- Do you need an index only for full-text search, or do you also need rapid aggregation of numeric data and other analytics? If you need functionality beyond full-text search, consider options that support additional analytics.

- Do you need a search index for log analytics, with support for log collection, aggregation, and visualizations on indexed data? If so, consider Elasticsearch, which is part of a log analytics stack.

- Do you need to index data in common document formats such as PDF, Word, PowerPoint, and Excel? If yes, choose an option that provides document indexers.

- Does your database have specific security needs? If yes, consider the security features listed below.

## Capability matrix

The following tables summarize the key differences in capabilities.

### General capabilities

| Capability | Cognitive Search | Elasticsearch | SQL Database |
| --- | --- | --- | --- |
| Is managed service | Yes | No | Yes |
| REST API | Yes | Yes | No |
| Programmability | .NET, Java, Python, JavaScript | Java | T-SQL |
| Document indexers for common file types (PDF, DOCX, TXT, and so on) | Yes | No | No |

### Manageability capabilities

| Capability | Cognitive Search | Elasticsearch | SQL Database |
| --- | --- | --- | --- |
| Updateable schema | Yes | Yes | Yes |
| Supports scale out  | Yes | Yes | No |

### Analytic workload capabilities

| Capability | Cognitive Search | Elasticsearch | SQL Database |
| --- | --- | --- | --- |
| Supports analytics beyond full text search | No | Yes | Yes |
| Part of a log analytics stack | No | Yes (ELK) | No |
| Supports semantic search | Yes (find similar documents only) | Yes | Yes |

### Security capabilities

| Capability | Cognitive Search | Elasticsearch | SQL Database |
| --- | --- | --- | --- |
| Row-level security | Partial (requires application query to filter by group id) | Partial (requires application query to filter by group id) | Yes |
| Transparent data encryption | No | No | Yes |
| Restrict access to specific IP addresses | Yes | Yes | Yes |
| Restrict access to allow virtual network access only | Yes | Yes | Yes |
| Active Directory authentication (integrated authentication) | No | No | Yes |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [What is Azure Cognitive Search?](/azure/search/search-what-is-azure-search)
- [Full-Text Search in SQL Server and Azure SQL Database](/sql/relational-databases/search/full-text-search)
- [Elastic Cloud (Elasticsearch Service)](https://azuremarketplace.microsoft.com/marketplace/apps/elastic.ec-azure-pp)

## Related resources

- [Process free-form text for search](../scenarios/search.yml)
- [Choose a search data store in Azure](../technology-choices/search-options.md)
- [Natural language processing technology](../technology-choices/natural-language-processing.yml)
