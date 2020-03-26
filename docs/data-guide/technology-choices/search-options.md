---
title: Choosing a search data store
description: 
author: zoinerTejada
ms.date: 02/12/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Choosing a search data store in Azure

This article compares technology choices for search data stores in Azure. A search data store is used to create and store specialized indexes for performing searches on free-form text. The text that is indexed may reside in a separate data store, such as blob storage. An application submits a query to the search data store, and the result is a list of matching documents. For more information about this scenario, see [Processing free-form text for search](../scenarios/search.md).

<!-- markdownlint-disable MD026 -->

## What are your options when choosing a search data store?

<!-- markdownlint-enable MD026 -->

In Azure, all of the following data stores will meet the core requirements for search against free-form text data by providing a search index:

- [Azure Search](/azure/search/search-what-is-azure-search)
- [Elasticsearch](https://azuremarketplace.microsoft.com/marketplace/apps/elastic.elasticsearch?tab=Overview)
- [HDInsight with Solr](/azure/hdinsight/hdinsight-hadoop-solr-install-linux)
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

| Capability | Azure Search | Elasticsearch | HDInsight with Solr | SQL Database |
| --- | --- | --- | --- | --- |
| Is managed service | Yes | No | Yes | Yes |  
| REST API | Yes | Yes | Yes | No |
| Programmability | .NET | Java | Java | T-SQL |
| Document indexers for common file types (PDF, DOCX, TXT, and so on) | Yes | No | Yes | No |

### Manageability capabilities

| Capability | Azure Search | Elasticsearch | HDInsight with Solr | SQL Database |
| --- | --- | --- | --- | --- |
| Updateable schema | No | Yes | Yes | Yes |
| Supports scale out  | Yes | Yes | Yes | No |

### Analytic workload capabilities

| Capability | Azure Search | Elasticsearch | HDInsight with Solr | SQL Database |
| --- | --- | --- | --- | --- |
| Supports analytics beyond full text search | No | Yes | Yes | Yes |
| Part of a log analytics stack | No | Yes (ELK) |  No | No |
| Supports semantic search | Yes (find similar documents only) | Yes | Yes | Yes |

### Security capabilities

| Capability | Azure Search | Elasticsearch | HDInsight with Solr | SQL Database |
| --- | --- | --- | --- | --- |
| Row-level security | Partial (requires application query to filter by group id) | Partial (requires application query to filter by group id) | Yes | Yes |
| Transparent data encryption | No | No | No | Yes |  
| Restrict access to specific IP addresses | No | Yes | Yes | Yes |
| Restrict access to allow virtual network access only | No | Yes | Yes | Yes |  
| Active Directory authentication (integrated authentication) | No | No | No | Yes |

## See also

[Processing free-form text for search](../scenarios/search.md)
