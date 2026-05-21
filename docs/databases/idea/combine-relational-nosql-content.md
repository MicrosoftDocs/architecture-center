[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Applications often handle diverse data workloads that have different characteristics. Structured, transactional data requires relational integrity and complex queries. Semistructured, rapidly changing, or high-volume data requires flexible schemas and horizontal scalability. Databases like Azure SQL Database and Azure Cosmos DB can support diverse workloads and multimodel requirements. However, in specific scenarios, organizations can achieve better outcomes by pairing SQL Database and Azure Cosmos DB through a polyglot persistence architecture.

Some workloads need the strict transactional guarantees and complex relational queries of a relational database, while other workloads need the flexible schemas and horizontal scalability of a NoSQL database. A polyglot approach assigns each workload to the platform that best fits its access pattern. It avoids using a platform for requirements that it isn't optimized for. For more information, see [Data considerations for microservices](../../microservices/design/data-considerations.md).

:::image type="complex" source="_images/combine-relational-nosql/scenario-diagram.svg" lightbox="_images/combine-relational-nosql/scenario-diagram.svg" alt-text="Diagram that shows a client calling an API proxy that routes to two APIs and separate NoSQL and relational databases.":::
   The diagram shows a client sending requests to an API proxy. The API proxy routes requests to two back-end services, named API 1 and API 2. API 1 connects to a NoSQL database, and API 2 connects to a relational database. API 1 and API 2 are also connected to each other with a bidirectional relationship that indicates interaction or synchronization between the two services. The overall flow shows a split data architecture in which one API path uses NoSQL storage and the other API path uses relational storage. In this flow, the proxy serves as the entry point for client requests.
:::image-end:::

This article describes a polyglot persistence approach that pairs SQL Database with Azure Cosmos DB so that you can configure each workload to use the database best suited to its requirements:

- SQL Database manages data that benefits from complex queries, relational integrity, and atomicity, consistency, isolation, and durability (ACID) transactions. SQL Database also supports multimodel capabilities like JSON, graph, spatial, and vector data, along with analytical workloads through columnstore indexes. Financial transaction records suit this database because they require consistent multiple-table transactions that span line items, inventory, and accounts.

- Azure Cosmos DB handles high-volume, schema-flexible, or globally distributed data that requires low-latency access and elastic scalability. E-commerce catalogs suit this database because their schemas evolve frequently and shoppers expect submillisecond reads regardless of region.

With a domain-driven microservices approach, each service uses the database that fits its data characteristics. Each microservice owns its private data store. This design prevents unintentional coupling between services and supports independent updates and deployments without coordinating changes across the system.

## Architecture

:::image type="complex" source="_images/combine-relational-nosql/solution-diagram.svg" border="false" lightbox="_images/combine-relational-nosql/solution-diagram.svg" alt-text="Diagram that shows a polyglot persistence architecture where domain-driven microservices use Azure Cosmos DB or SQL Database by data requirements.":::
   Diagram of an e-commerce polyglot persistence architecture. Users access the system through web and mobile clients, which connect to an Azure API Management gateway. The gateway routes requests to a microservices layer that contains seven domain-driven services connected by bidirectional arrows: User profile, user session, product catalog, shopping cart, order management, inventory, and payments. Each microservice connects to a dedicated database chosen by data requirements. The first four services use Azure Cosmos DB: profile, session state, product catalog, and shopping cart. Azure Cosmos DB is selected for flexible schemas, elastic scaling, and millisecond latency. The last three services use SQL Database: order management, inventory, and payment. SQL Database is selected for ACID compliance, relational queries, and transactional integrity.
:::image-end:::

### Data flow

The following data flow corresponds to the previous diagram:

1. Users and client applications connect to the system through Azure API Management, which provides a unified gateway for all back-end microservices.

1. API Management routes requests to the appropriate domain-driven microservices. Each microservice owns its data store independently.

1. Microservices that handle flexible-schema, high-volume, or globally distributed workloads, like user profiles, session state, product catalogs, and shopping carts, use Azure Cosmos DB. Azure Cosmos DB stores this data as JSON documents, provides single-digit millisecond response times, and scales horizontally.

1. Microservices that handle structured, transactional workloads, like order management, inventory, and payments, use SQL Database. SQL Database provides full ACID compliance, complex query support, and relational integrity for these operations.

1. Some microservices communicate with each other to fulfill cross-domain data requirements. For example, the shopping cart service queries the user session service for session context, and both the inventory and order management services interact with the product catalog service for product information. These calls between microservices use service APIs rather than directly accessing another service's database, which preserves data ownership boundaries.

### Components

- [API Management](/azure/well-architected/service-guides/azure-api-management) is a management platform and gateway for APIs that routes client requests to APIs, applies rate limits and caches responses, and handles authentication. In this architecture, it provides a unified entry point that routes client requests to the appropriate domain microservices.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multimodel database that enables applications to elastically and independently scale throughput and storage. In this architecture, it stores data for workloads that require flexible schemas, low-latency access, horizontal scalability, or global distribution. Examples include user profiles, session state, product catalogs, and shopping carts.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database) is a fully managed, cloud-first relational database engine that typically includes capabilities ahead of the latest public version of SQL Server. Beyond relational data, it supports multimodel workloads, including JSON, graph, spatial, and vector data within the same database. In this architecture, it handles workloads that require ACID compliance, relational integrity, and complex query support. Examples include order management, inventory tracking, and payment processing.

## Scenario details

Applications often handle diverse data workloads that have different characteristics. Structured, transactional data requires relational integrity and complex queries. Semistructured, rapidly evolving, or high-volume data requires flexible schemas and horizontal scalability. With a polyglot persistence approach, you can assign each workload to the specific database technology that best matches its requirements.

A polyglot persistence strategy assigns each data workload to the database technology that best matches its requirements. Domain-driven microservices enforce this separation, so each service can manage its own data store independently. This approach introduces challenges like [data redundancy across stores and eventual consistency between services](../../microservices/design/data-considerations.md#challenges). A polyglot architecture also increases operational complexity compared to a single database platform. Your team must develop and maintain expertise across both database technologies, which increases training and operational overhead.

The following advantages help offset those challenges:

- **Independent scalability:** Each database scales according to its workload. Azure Cosmos DB handles read/write bursts of millions of operations per second with guaranteed low latency. SQL Database provides both provisioned compute for steady workloads and serverless autoscaling, with scale-to-zero capabilities for unpredictable workloads.

- **Appropriate data modeling:** SQL Database provides relational schemas, foreign keys, and joins for data that has well-defined relationships. Azure Cosmos DB provides schema-agnostic storage with automatic indexing for data that evolves frequently.

- **Global data distribution:** Azure Cosmos DB provides automatic multiregion replication with a 99.999% read availability service-level agreement (SLA) for workloads that require low-latency data access worldwide. SQL Database provides geo-replication for multiregion read scenarios, and Hyperscale named replicas for read scale within a region.

- **Optimized cost allocation:** Each service uses its own pricing model. SQL Database provides predictable pricing for steady transactional workloads. Azure Cosmos DB provides pay-per-request throughput for highly dynamic or spiky workloads. Segregating tasks avoids overprovisioning a single system.

- **Shared capacity for multitenant workloads:** Both services support shared capacity deployment models. SQL Database provides elastic pools for consolidating databases across tenants. Azure Cosmos DB provides fleet pools for efficient multitenant resource sharing. These options maintain isolation while reducing per-tenant costs.

### When to use each service

SQL Database and Azure Cosmos DB have overlapping capabilities. Both services can store JSON and deliver low-latency responses when configured appropriately. The decision depends on which service's primary design strengths align with your workload's dominant access patterns:

- Choose Azure Cosmos DB when your workload primarily requires schema-flexible document storage, automatic multiregion distribution with guaranteed single-digit millisecond reads, or elastic horizontal scaling across partitions. Azure Cosmos DB optimizes for these characteristics as its native strengths.

- Choose SQL Database when your workload primarily requires enforced relational integrity across tables, multistatement ACID transactions, or complex joins and aggregations. These characteristics are native strengths of SQL Database and represent its optimized path.

When a workload's requirements don't clearly favor one service, evaluate the dominant access pattern rather than secondary capabilities. For example, SQL Database supports JSON storage, but a workload that consists primarily of schema-flexible JSON documents with high-write throughput better suits Azure Cosmos DB. For detailed selection criteria, see [Prepare to choose a data store in Azure](../../guide/technology-choices/data-stores-getting-started.md).

### Potential use cases

This architecture suits applications that handle multiple data workload types that have different consistency, scalability, and schema requirements:

- **E-commerce and retail:** Applications that use SQL Database for customer accounts, orders, and inventory, and Azure Cosmos DB for product catalogs, personalization, and real-time session data.

- **Software as a service (SaaS) platforms:** Multitenant applications that store per-tenant relational data in SQL Database and shared, globally replicated metadata or user session content in Azure Cosmos DB.

- **Healthcare and Internet of Things (IoT):** Systems that ingest high-volume metrics or sensor data into Azure Cosmos DB and store aggregated results, reference data, or final reports in SQL Database.

- **Financial services:** Payment and trading platforms that use SQL Database for transactional integrity over financial records and Azure Cosmos DB for globally distributed, low-latency access to portfolio or operational data.

- **AI-enhanced applications:** Solutions that use SQL Database for relational records of transactions and agreements, and Azure Cosmos DB for storing AI-generated metadata, chat sessions, or contextual artifacts that require flexible schema and fast access.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Avoid overprovisioning by separating workloads based on data characteristics. Placing high-volume NoSQL reads in Azure Cosmos DB and complex transactional queries in SQL Database lets each service operate within its optimal cost profile.

- SQL Database provides [provisioned](/azure/azure-sql/database/service-tiers-sql-database-vcore) and [serverless](/azure/azure-sql/database/serverless-tier-overview) compute tiers. Use provisioned compute for steady transactional workloads. Serverless can reduce costs for intermittent or unpredictable workloads, but cold-start latency can affect response times after periods of inactivity.

Azure Cosmos DB provides [provisioned throughput](/azure/cosmos-db/set-throughput) and [serverless](/azure/cosmos-db/throughput-serverless) modes. Use provisioned throughput in autoscale mode for production workloads that have variable demand. Serverless can reduce costs for development and low-traffic workloads, but cold-start latency can affect response times after periods of inactivity.

> [!TIP]
> To estimate the cost of the Azure resources for this solution idea, use the [preconfigured estimate in the Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/?shared-estimate=b699ade4c29b4af4b13699451c4bbcc5).

## Next steps

- [Azure Cosmos DB](/azure/cosmos-db/overview)
- [SQL Database](/azure/azure-sql/database/sql-database-paas-overview)

## Related content

- [Prepare to choose a data store in Azure](../../guide/technology-choices/data-stores-getting-started.md)
- [Data considerations for microservices](../../microservices/design/data-considerations.md)
- [Design a microservices architecture](../../microservices/design/index.md)
