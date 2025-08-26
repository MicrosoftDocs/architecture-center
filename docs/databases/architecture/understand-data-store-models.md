---
title: Understanding data models
description: Learn the major Azure data store models, how they differ, and how to choose and combine them using comparative characteristics of relational and non-relational options.
author: claytonsiemens77
ms.author: csiemens
ms.topic: conceptual
ms.subservice: architecture-guide
ms.date: 08/21/2025
---

# Understanding data models

Modern solutions handle diverse data (transactions, events, documents, telemetry, binary assets, analytical facts). A single data store rarely satisfies all access patterns efficiently. Most production systems adopt *polyglot persistence*: selecting multiple storage models intentionally. This article centralizes the canonical definitions of the primary data store models available on Azure and provides comparative tables to speed model selection before you pick specific services.

Use this sequence:
1. Identify workload access patterns (point reads, aggregations, full‑text, similarity, time-window scans, object delivery).
2. Map patterns to storage models below.
3. Shortlist Azure services that implement those models.
4. Apply evaluation criteria (consistency, latency, scale, governance, cost).
5. Combine models only where access patterns or lifecycle clearly diverge.

## How to use this guide

Each model section includes a concise definition, typical workloads, data characteristics, example scenarios, and links to representative Azure services. Two comparative tables summarize non-relational model traits so you avoid duplicative re-reading. Specialized decision material (criteria catalog, governance, decision tree) lives in separate referenced articles.

## Classification overview

| Category | Primary purpose | Typical Azure services (examples) |
|----------|-----------------|------------------------------------|
| Relational (OLTP) | Strongly consistent transactional operations | Azure SQL Database, Azure Database for PostgreSQL, Azure Database for MySQL |
| Non-relational (document / key/value / column-family / graph) | Flexible schema or relationship-centric workloads | Azure Cosmos DB APIs, Azure Cache for Redis, Managed Cassandra, HBase |
| Time series | High-ingest timestamped metrics and events | Azure Data Explorer, Time Series Insights |
| Analytics / OLAP / MPP | Large-scale historical aggregation, BI | Microsoft Fabric (OneLake + Warehouse), Synapse, Azure Data Explorer, Analysis Services, Databricks |
| Object & file | Large binary or semi-structured file storage | Blob Storage, Data Lake Storage Gen2, Azure Files |
| Search & indexing | Full-text and multi-field relevance, secondary indexing | Azure AI Search |
| Vector | Semantic or ANN similarity |  Azure AI Search, Azure Cosmos DB variants |

> A single service may offer multiple models (multi-model). Prefer the best-fit model instead of forcing an awkward multi-model consolidation that complicates operations.

## Relational data stores

Relational database management systems organize data into normalized tables with schema-on-write, enforcing integrity and supporting ACID transactions and rich SQL queries.

**Use when** you require multi-row transactional consistency, complex joins, strong relational constraints, and mature tooling around reporting, administration, and governance.

**Constraints:** Horizontal scale generally requires sharding or partitioning; normalization can increase join cost for read-heavy denormalized views.

**Representative Azure services:** Azure SQL Database, Azure SQL Managed Instance, Azure Database for PostgreSQL, Azure Database for MySQL.

**Example scenarios:** Order management, inventory, financial ledger, billing, operational reporting.

## Non-relational data stores

Non-relational (NoSQL) databases optimize for flexible schemas, horizontal scale, and specific access or aggregation patterns. They typically relax some aspects of relational behavior (schema rigidity, transaction scope) for scalability or agility.

### Document data stores
Store semi-structured documents (often JSON) where each document contains an entity or aggregate. Per-document schema flexibility enables gradual evolution.

**Strengths:** Natural application object mapping, denormalized aggregates, multi-field indexing.  
**Considerations:** Document size growth, selective transactional scope, need for careful data shape design for high-scale queries.  
**Workloads:** Product catalogs, content management, profile stores.  
**Services:** Azure Cosmos DB (NoSQL / Mongo API).

### Column-family (wide-column) data stores
Organize sparse data into rows with dynamic columns grouped as column families for co-access. Column orientation improves scans over selected column sets.

**Strengths:** High write throughput, efficient retrieval of wide or sparse datasets, dynamic schema within families.  
**Considerations:** Up-front row key and column family design; secondary index support varies; query flexibility lower than relational.  
**Workloads:** IoT telemetry, time-series style tall data (when dedicated time series DB not chosen), personalization, analytics pre-aggregation.  
**Services:** Azure Cosmos DB for Cassandra API, HBase on HDInsight.

### Key/value data stores
Associate opaque values with unique keys; operations are simple (get/put/delete) and atomic per key.

**Strengths:** Extreme simplicity, low latency, linear scalability.  
**Considerations:** Limited query expressiveness; redesign needed for value-based lookups; large value overwrite cost.  
**Workloads:** Caching, sessions, feature flags, user profiles, recommendation lookups.  
**Services:** Azure Cache for Redis, Azure Cosmos DB Table / NoSQL APIs, Azure Table Storage.

### Graph data stores
Represent entities (nodes) and relationships (edges) with properties; optimized for traversals across many hops.

**Strengths:** Relationship-first querying patterns; efficient variable-depth traversals.  
**Considerations:** Overhead if relationships are shallow; requires careful modeling for performance; not ideal for bulk analytical scans.  
**Workloads:** Social networks, fraud rings, knowledge graphs, supply chain dependencies.  
**Services:** Azure Cosmos DB (Gremlin API), SQL Server graph features.

### Time series data stores
Manage high-ingest, append-only measurements indexed by time. Optimize for window aggregations and retention policies.

**Strengths:** Compression, windowed query performance, out-of-order ingestion handling.  
**Considerations:** Tag cardinality management, retention cost, downsampling strategy.  
**Workloads:** IoT sensor metrics, application telemetry, monitoring, industrial data.  
**Services:** Azure Data Explorer, Time Series Insights.

### Object data stores
Persist large binary or semi-structured objects with metadata (immutable or infrequently changing).

**Strengths:** Virtually unlimited scale, tiered cost, durability, parallel read capability.  
**Considerations:** Whole-object operations; metadata query limited; eventual listing behaviors.  
**Workloads:** Media assets, backups, data lake raw zones, log archives.  
**Services:** Azure Blob Storage, Data Lake Storage Gen2.

### Search and indexing data stores  <a id="search-and-indexing-data-stores"></a>
Provide inverted indexes or secondary indexes for rapid relevance ranking and multi-field filtering across semi-structured text.

**Strengths:** Full-text queries, scoring, linguistic analysis, fuzzy matching.  
**Considerations:** Eventual consistency of indexes; separate ingestion / indexing pipeline; cost of large index updates.  
**Workloads:** Site/product search, log search, metadata filtering, multi-attribute discovery.  
**Services:** Azure AI Search.

## Comparative characteristics (core non-relational models)  <a id="comparison-core-non-relational-models"></a>

| Aspect | Document | Column-family | Key/value | Graph |
|--------|----------|---------------|-----------|-------|
| Normalization | Denormalized | Denormalized | Denormalized | Normalized relationships |
| Schema approach | Schema on read | Column families defined; columns schema on read | Schema on read | Schema on read |
| Consistency (typical) | Tunable / per-item | Per-row / family | Per-key | Per-edge / traversal semantics |
| Atomicity scope | Document | Row (family/table impl-dependent) | Single key | Graph transaction (varies) |
| Locking / Concurrency | Optimistic (ETag) | Pessimistic or optimistic (impl) | Optimistic (key) | Optimistic (pattern) |
| Access pattern | Aggregate (entity) | Wide sparse aggregates | Point lookup by key | Relationship traversals |
| Indexing | Primary + secondary | Primary + limited secondary | Primary (key) | Primary + sometimes secondary |
| Data shape | Flexible hierarchical | Sparse tabular wide | Opaque value | Nodes & edges |
| Sparse / wide suitability | Yes / Yes | Yes / Yes | Yes / No | No / No |
| Typical datum size | Small–medium | Medium–large | Small | Small |
| Scale dimension | Partition count | Partition + column family width | Key space | Node/edge count |

## Comparative characteristics (specialized non-relational models)  <a id="comparison-specialized-non-relational-models"></a>

| Aspect | Time series | Object (blob) | Search / indexing |
|--------|------------|---------------|-------------------|
| Normalization | Normalized | Denormalized | Denormalized |
| Schema | Schema on read (tags) | Opaque value + metadata | Schema on write (index mapping) |
| Atomicity scope | N/A (append) | Object | Per document/index operation |
| Access pattern | Time-slice scans, window agg | Whole-object ops | Text queries + filters |
| Indexing | Time + optional secondary | Key (path) only | Inverted + optional facets |
| Data shape | Tabular (timestamp, tags, value) | Binary/blob with metadata | Tokenized text + structured fields |
| Write profile | High-rate append | Bulk / infrequent updates | Batch or streaming index |
| Read profile | Aggregated ranges | Whole or partial downloads | Ranked result sets |
| Growth driver | Event rate * retention | Object count & size | Indexed doc volume |
| Consistency tolerance | Eventual for late data | Read-after-write per object | Eventual for new docs |

## Choosing among models (heuristics)

| Need | Prefer |
|------|-------|
| Strict multi-entity transactions | Relational |
| Evolving aggregate shape, JSON-centric APIs | Document |
| Extreme low-latency key lookups / caching | Key/value |
| Wide, sparse, write-heavy telemetry | Column-family or Time series |
| Deep relationship traversal | Graph |
| Massive historical analytical scans | Analytics / OLAP |
| Large unstructured binaries or lake zones | Object |
| Full-text relevance and filtering | Search & indexing |
| High-ingest timestamp metrics with window queries | Time series |
| Rapid similarity (semantic / vector) | (See vector search guide) |

## Combining models and avoiding pitfalls

Use more than one model when:
- Access patterns diverge (point lookup vs wide analytical scan vs full-text relevance).
- Lifecycle and retention differ (immutable raw vs curated structured).
- Latency vs throughput requirements conflict.

Avoid premature fragmentation:
- Keep to one service if performance, scale, and governance objectives are still met.
- Centralize shared classification logic; do not duplicate transformation pipelines across stores without necessity.

Common anti-patterns:
- Shared database used by multiple microservices (coupling).
- “Just add another model” without operational maturity (monitoring, backups).
- Overusing a search index as a primary data store.

## When to re-evaluate your model choice

| Signal | Possible Action |
|--------|-----------------|
| Increasing ad-hoc joins on a document store | Introduce relational read model |
| High CPU on search index due to analytical aggregations | Offload to analytics engine |
| Large denormalized documents causing partial update contention | Re-shape aggregates or split |
| Time-window queries slow on column-family store | Adopt purpose-built time series DB |
| Point lookup latency rising with graph traversal depth | Add derived materialized views |

## Next steps

- Model selection criteria: [Criteria for choosing a data store](./data-store-considerations.md)
- Flow-based entry: [Data store decision tree](./data-store-decision-tree.md)
- Governance & landing zone: [Choose an Azure data service](./data-options.md)
- Big data storage considerations: [Choose a data storage technology](../../data-guide/technology-choices/data-storage.md)

## Related resources

- Cloud adoption data service requirements: [Cloud Adoption Framework data options](/azure/cloud-adoption-framework/ready/considerations/data-options)
- Storage options overview: [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options)
- Analytics architectures: [Big data architectures](../../databases/guide/big-data-architectures.md)
- Relational vs NoSQL concepts: [Relational vs NoSQL data](/dotnet/architecture/cloud-native/relational-vs-nosql-data)

<!-- Legacy anchor aliases (from consolidated sources) -->
<a id="columnar-data-stores"></a>
<a id="column-family-databases"></a>
<a id="key/value-data-stores"></a>
<a id="key-value-data-stores"></a>
<a id="document-data-stores"></a>
<a id="graph-data-stores"></a>
<a id="time-series-data-stores"></a>
<a id="object-data-stores"></a>
<a id="external-index-data-stores"></a>
<a id="search-engine-databases"></a>
<a id="typical-requirements"></a>
<a id="data-analytics"></a>
<a id="shared-files"></a>

<!-- Notes for maintainers:
- Keep model definitions concise; expand deep operational guidance elsewhere.
- Update comparative tables if adding new service capabilities (add column notes, not full list duplication).
-->
