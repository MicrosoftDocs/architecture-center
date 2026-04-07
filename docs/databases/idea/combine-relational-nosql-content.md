[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a polyglot persistence architecture that uses Azure Cosmos DB and Azure SQL Database together. 

Each database is selected based on its characteristics to handle specific workload types: 

* **Azure SQL Database** manages structured, transactional data that requires relational integrity
* **Azure Cosmos DB** handles high-volume, schema-flexible, or globally distributed data that requires low-latency access

A domain-driven microservices approach allows each service to use the database that matches its data characteristics.

## Architecture

:::image type="complex" source="_images/combine-relational-nosql/solution-diagram.svg" border="false" lightbox="_images/combine-relational-nosql/solution-diagram.svg" alt-text="Diagram that shows a polyglot persistence architecture where domain-driven microservices use Azure Cosmos DB or Azure SQL Database by data requirements.":::
Diagram of an e-commerce polyglot persistence architecture. Users access the system through web and mobile clients, which connect to an Azure API Management gateway. The gateway routes requests to a microservices layer containing seven domain-driven services connected by bidirectional arrows: User Profile, User Session, ProductCatalog, Shopping Cart, Order Management, Inventory, and Payments. Each microservice connects to a dedicated database chosen by data requirements. The first four services use Azure Cosmos DB: Profile, Session State, Product Catalog, and Shopping Cart. Azure Cosmos DB is selected for flexible schemas, elastic scaling, and millisecond latency. The last three services use Azure SQL Database: Order Management, Inventory, and Payment. Azure SQL Database is selected for ACID compliance, relational queries, and transactional integrity.
:::image-end:::

### Dataflow

1. Users and client applications connect to the system through Azure API Management, which provides a unified gateway for all backend microservices.
1. API Management routes requests to the appropriate domain-driven microservices. Each microservice owns its data store independently.
1. Microservices that handle flexible-schema, high-volume, or globally distributed workloads, such as user profiles, session state, product catalogs, and shopping carts, use Azure Cosmos DB. Azure Cosmos DB stores this data as JSON documents, provides single-digit millisecond response times, and scales horizontally.
1. Microservices that handle structured, transactional workloads, such as order management, inventory, and payments, use Azure SQL Database. Azure SQL Database provides full ACID compliance, complex query support, and relational integrity for these operations.
1. Some microservices communicate with each other to fulfill cross-domain data requirements. For example, the shopping cart service queries the user session service for session context, and both the inventory and order management services interact with the product catalog service for product information. These inter-service calls use service APIs rather than directly accessing another service's database, which preserves data ownership boundaries.

### Components

- [Azure API Management](/azure/well-architected/service-guides/azure-api-management) is a management platform for APIs. In this architecture, it provides a unified entry point that routes client requests to the appropriate domain microservices.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multi-model database that enables your applications to elastically and independently scale throughput and storage. In this architecture, it stores data for workloads that require flexible schemas, low-latency access, horizontal scalability, or global distribution. Examples include user profiles, session state, product catalogs, and shopping carts.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed relational database engine based on the latest stable version of Microsoft SQL Server. In this architecture, it stores structured, transactional data for workloads that require ACID compliance, relational integrity, and complex query support. Examples include order management, inventory tracking, and payment processing.

## Scenario details

Applications often handle diverse data workloads with different characteristics. Some data is structured and transactional, requiring relational integrity and complex queries. Other data is semi-structured, rapidly evolving, or high-volume, requiring flexible schemas and horizontal scalability. A single database technology isn't designed to handle all of these requirements efficiently.

A polyglot persistence strategy assigns each data workload to the database technology that best matches its requirements. Domain-driven microservices enforce this separation, allowing each service to independently manage its own data store. This approach provides several advantages:

- **Independent scalability.** Each database scales according to its workload. Azure Cosmos DB handles read/write bursts of millions of operations per second with guaranteed low latency. Azure SQL Database efficiently processes complex transactional queries and scales predictably.
- **Appropriate data modeling.** Azure SQL Database provides fixed schemas, foreign keys, and joins for data that has well-defined relationships. Azure Cosmos DB provides schema-agnostic storage with automatic indexing for data that evolves frequently.
- **Global data distribution.** Azure Cosmos DB provides automatic multi-region replication with a 99.999% read availability service level agreement (SLA) for workloads that require low-latency data access worldwide. Azure SQL Database provides geo-replication for read scenarios.
- **Optimized cost allocation.** Each service uses its own pricing model. Azure SQL Database offers predictable pricing for steady transactional workloads. Azure Cosmos DB offers pay-per-request throughput for highly dynamic or spiky workloads. Segregating tasks avoids over-provisioning a single system.
- **Shared capacity for multi-tenant workloads.** Both services support shared capacity deployment models. Azure SQL Database provides elastic pools for consolidating databases across tenants. Azure Cosmos DB provides fleet pools for efficient multitenant resource sharing. These options maintain isolation while reducing per-tenant costs.

### Potential use cases

This architecture is appropriate for applications that handle multiple data workload types with different consistency, scalability, and schema requirements:

- **SaaS platforms.** Multitenant applications that store per-tenant relational data in Azure SQL Database and shared, globally replicated metadata or user session content in Azure Cosmos DB.
- **E-commerce and retail.** Applications that use Azure SQL Database for customer accounts, orders, and inventory, and Azure Cosmos DB for product catalogs, personalization, and real-time session data.
- **Healthcare and IoT.** Systems that ingest high-volume metrics or sensor data into Azure Cosmos DB and store aggregated results, reference data, or final reports in Azure SQL Database.
- **Financial services.** Payment and trading platforms that use Azure SQL Database for transactional integrity over financial records and Azure Cosmos DB for globally distributed, low-latency access to portfolio or operational data.
- **AI-enhanced applications.** Solutions that use Azure SQL Database for relational records of transactions and agreements, and Azure Cosmos DB for storing AI-generated metadata, chat sessions, or contextual artifacts that require flexible schema and fast access.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Azure Cosmos DB provides a [99.999% availability SLA](/azure/cosmos-db/high-availability) for multi-region configurations, which helps ensure that globally distributed workloads remain accessible during regional outages.
- Azure SQL Database supports [active geo-replication](/azure/azure-sql/database/active-geo-replication-overview) and [failover groups](/azure/azure-sql/database/failover-group-sql-db) for high availability and disaster recovery.
- Design each microservice to degrade gracefully if either database becomes temporarily unavailable. Service isolation provided by independent data ownership limits the blast radius of component failures.

### Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for both services.
- Azure SQL Database offers [serverless](/azure/azure-sql/database/serverless-tier-overview) and [provisioned](/azure/azure-sql/database/service-tiers-sql-database-vcore) compute tiers. Choose serverless for intermittent, unpredictable transactional workloads. Alternatively, choose provisioned for steady workloads.
- Azure Cosmos DB offers [provisioned throughput](/azure/cosmos-db/set-throughput) and [serverless](/azure/cosmos-db/throughput-serverless) modes. Use serverless for development and low-traffic workloads, and provisioned throughput with autoscale for production workloads with variable demand.
- Avoid over-provisioning by segregating workloads by data characteristics. Placing high-volume NoSQL reads in Azure Cosmos DB and complex transactional queries in Azure SQL Database allows each service to operate within its optimal cost profile.

## Related content

- [Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview)
