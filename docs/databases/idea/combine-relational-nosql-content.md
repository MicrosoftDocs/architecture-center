[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Applications often handle diverse data workloads with different characteristics. Some data is structured and transactional, requiring relational integrity and complex queries. Other data is semi-structured, rapidly changing, or high-volume, requiring flexible schemas and horizontal scalability. Databases such as Azure SQL Database and Azure Cosmos DB can each support diverse workloads and multi-model requirements. However, in specific scenarios, organizations can achieve better outcomes by integrating the strengths of both platforms through a polyglot persistence architecture. For background on polyglot persistence and data management principles in microservices, see [Data considerations for microservices](../../microservices/design/data-considerations.md).

:::image type="complex" source="_images/combine-relational-nosql/scenario-diagram.svg" alt-text="Diagram that shows a client calling an API proxy that routes to two APIs and separate NoSQL and relational databases.":::
The diagram shows a client sending requests to an API proxy. The API proxy routes requests to two backend services, named API 1 and API 2. API 1 connects to a NoSQL database, and API 2 connects to a relational database. API 1 and API 2 are also connected to each other with a bidirectional relationship that indicates interaction or synchronization between the two services. The overall flow shows a split data architecture in which one API path uses NoSQL storage and the other API path uses relational storage. In this flow, the proxy acts as the entry point for client requests.
:::image-end:::

This article describes a polyglot persistence approach that pairs Azure SQL Database with Azure Cosmos DB so each workload uses the database best suited to its requirements:

* **Azure SQL Database** manages data that benefits from relational integrity, ACID transactions, and complex queries. Azure SQL Database also supports multi-model capabilities such as JSON, graph, spatial, and vector data, along with analytical workloads through columnstore indexes.
* **Azure Cosmos DB** handles high-volume, schema-flexible, or globally distributed data that requires low-latency access and elastic scalability.

A domain-driven microservices approach allows each service to use the database that matches its data characteristics. Each microservice owns its private data store, which prevents unintentional coupling between services and preserves the agility of independent deployments.

## Architecture

:::image type="complex" source="_images/combine-relational-nosql/solution-diagram.svg" border="false" lightbox="_images/combine-relational-nosql/solution-diagram.svg" alt-text="Diagram that shows a polyglot persistence architecture where domain-driven microservices use Azure Cosmos DB or Azure SQL Database by data requirements.":::
Diagram of an e-commerce polyglot persistence architecture. Users access the system through web and mobile clients, which connect to an Azure API Management gateway. The gateway routes requests to a microservices layer containing seven domain-driven services connected by bidirectional arrows: User Profile, User Session, ProductCatalog, Shopping Cart, Order Management, Inventory, and Payments. Each microservice connects to a dedicated database chosen by data requirements. The first four services use Azure Cosmos DB: Profile, Session State, Product Catalog, and Shopping Cart. Azure Cosmos DB is selected for flexible schemas, elastic scaling, and millisecond latency. The last three services use Azure SQL Database: Order Management, Inventory, and Payment. Azure SQL Database is selected for ACID compliance, relational queries, and transactional integrity.
:::image-end:::

### Dataflow

1. Users and client applications connect to the system through Azure API Management, which provides a unified gateway for all backend microservices.
1. API Management routes requests to the appropriate domain-driven microservices. Each microservice owns its data store independently.
1. Microservices that handle flexible-schema, high-volume, or globally distributed workloads, such as user profiles, session state, product catalogs, and shopping carts, use Azure Cosmos DB. Azure Cosmos DB stores this data as JSON documents, provides single-digit millisecond response times, and scales horizontally.
1. Microservices that handle structured, transactional workloads, such as order management, inventory, and payments, use Azure SQL Database. Azure SQL Database provides full ACID compliance, complex query support, and relational integrity for these operations.
1. Some microservices communicate with each other to fulfill cross-domain data requirements. For example, the shopping cart service queries the user session service for session context, and both the inventory and order management services interact with the product catalog service for product information. These calls between microservices use service APIs rather than directly accessing another service's database, which preserves data ownership boundaries.

### Components

- [Azure API Management](/azure/well-architected/service-guides/azure-api-management) is a management platform and gateway for APIs that routes client requests to APIs, performs rate limiting and caching, and handles authentication. In this architecture, it provides a unified entry point that routes client requests to the appropriate domain microservices.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database that enables your applications to elastically and independently scale throughput and storage. In this architecture, it stores data for workloads that require flexible schemas, low-latency access, horizontal scalability, or global distribution. Examples include user profiles, session state, product catalogs, and shopping carts.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed, cloud-first relational database engine that typically includes capabilities ahead of the latest public version of SQL Server. Beyond relational data, it supports multi-model workloads including JSON, graph, spatial, and vector data within the same database. In this architecture, it handles workloads that require ACID compliance, relational integrity, and complex query support. Examples include order management, inventory tracking, and payment processing.

## Scenario details

Applications often handle diverse data workloads with different characteristics. Some data is structured and transactional, requiring relational integrity and complex queries. Other data is semi-structured, rapidly evolving, or high-volume, requiring flexible schemas and horizontal scalability. A single database technology might not handle all of these requirements optimally.

A polyglot persistence strategy assigns each data workload to the database technology that best matches its requirements. Domain-driven microservices enforce this separation, allowing each service to independently manage its own data store. This approach leads to many of the [challenges described in the microservices data considerations guide](../../microservices/design/data-considerations.md#challenges). These challenges include data redundancy across stores and eventual consistency between services. A polyglot architecture also increases operational complexity compared to a single database platform. Your team must develop and maintain expertise across both database technologies, which increases training and operational overhead.

The following advantages help offset those challenges:

- **Independent scalability.** Each database scales according to its workload. Azure Cosmos DB handles read/write bursts of millions of operations per second with guaranteed low latency. Azure SQL Database offers both provisioned compute (for steady workloads) and serverless autoscaling, with scale-to-zero capabilities (for unpredictable workloads).
- **Appropriate data modeling.** Azure SQL Database provides relational schemas, foreign keys, and joins for data that has well-defined relationships. Azure Cosmos DB provides schema-agnostic storage with automatic indexing for data that evolves frequently.
- **Global data distribution.** Azure Cosmos DB provides automatic multi-region replication with a 99.999% read availability service level agreement (SLA) for workloads that require low-latency data access worldwide. Azure SQL Database provides geo-replication for multi-region read scenarios, and Hyperscale named replicas for read scale within a region.
- **Optimized cost allocation.** Each service uses its own pricing model. Azure SQL Database offers predictable pricing for steady transactional workloads. Azure Cosmos DB offers pay-per-request throughput for highly dynamic or spiky workloads. Segregating tasks avoids over-provisioning a single system.
- **Shared capacity for multi-tenant workloads.** Both services support shared capacity deployment models. Azure SQL Database provides elastic pools for consolidating databases across tenants. Azure Cosmos DB provides fleet pools for efficient multitenant resource sharing. These options maintain isolation while reducing per-tenant costs.

### Potential use cases

This architecture is appropriate for applications that handle multiple data workload types with different consistency, scalability, and schema requirements:

- **E-commerce and retail.** Applications that use Azure SQL Database for customer accounts, orders, and inventory, and Azure Cosmos DB for product catalogs, personalization, and real-time session data.
- **SaaS platforms.** Multitenant applications that store per-tenant relational data in Azure SQL Database and shared, globally replicated metadata or user session content in Azure Cosmos DB.
- **Healthcare and IoT.** Systems that ingest high-volume metrics or sensor data into Azure Cosmos DB and store aggregated results, reference data, or final reports in Azure SQL Database.
- **Financial services.** Payment and trading platforms that use Azure SQL Database for transactional integrity over financial records and Azure Cosmos DB for globally distributed, low-latency access to portfolio or operational data.
- **AI-enhanced applications.** Solutions that use Azure SQL Database for relational records of transactions and agreements, and Azure Cosmos DB for storing AI-generated metadata, chat sessions, or contextual artifacts that require flexible schema and fast access.

## Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Avoid over-provisioning by segregating workloads by data characteristics. Placing high-volume NoSQL reads in Azure Cosmos DB and complex transactional queries in Azure SQL Database allows each service to operate within its optimal cost profile.
- Azure SQL Database offers [serverless](/azure/azure-sql/database/serverless-tier-overview) and [provisioned](/azure/azure-sql/database/service-tiers-sql-database-vcore) compute tiers. Choose serverless for intermittent, unpredictable transactional workloads. Alternatively, choose provisioned for steady workloads.
- Azure Cosmos DB offers [provisioned throughput](/azure/cosmos-db/set-throughput) and [serverless](/azure/cosmos-db/throughput-serverless) modes. Use provisioned throughput with autoscale for production workloads with variable demand. Serverless can reduce costs for development and low-traffic workloads, but cold start latency can affect response times after periods of inactivity.

> [!TIP]
> To estimate the cost of the Azure resources for this solution idea, use this [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/b699ade4c29b4af4b13699451c4bbcc5).

## Related content

- [Data considerations for microservices](../../microservices/design/data-considerations.md)
- [Design a microservices architecture](../../microservices/design/index.md)
- [Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
