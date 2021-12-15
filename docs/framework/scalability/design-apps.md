---
title: Design scalable Azure applications
description: Review design considerations for scalable applications. Choose the right data storage and VM size, build with microservices, establish connection pooling, and more.
author: v-aangie
ms.date: 12/01/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you designing your applications to scale?
  - article
---

# Design scalable Azure applications

Application design is critical to handling scale as load increases. This article will give you insight on the most important topics. For more topics related to handling scale, see the [Design Azure applications for efficiency](/azure/architecture/framework/scalability/design-efficiency) article in the Performance efficiency pillar.

## Choose the right data storage

The overall design of the data tier can greatly affect an application's performance and scalability. The Azure storage platform is designed to be massively scalable to meet the data storage and performance needs of modern applications.

Data services in the Azure storage platform are:

- [Azure Blob](/azure/storage/blobs/storage-blobs-introduction) - A massively scalable object store for text and binary data. Includes support for big data analytics through Data Lake Storage Gen2.
- [Azure Files](/azure/storage/files/storage-files-introduction) - Managed file shares for cloud or on-premises deployments.
- [Azure Queue](/azure/storage/queues/storage-queues-introduction) - A messaging store for reliable messaging between application components.
- [Azure Tables](/azure/storage/tables/table-storage-overview) - A NoSQL store for schemaless storage of structured data.
- [Azure Disks](/azure/virtual-machines/managed-disks-overview) - Block-level storage volumes for Azure VMs.

Most cloud workloads adopt the *polyglot* persistence approach. Instead of using one data store service, a mix of technologies is used. Your application will most likely require more than one type of data store depending on your requirements. For examples of when to use these data storage types, see [Example scenarios](/azure/storage/common/storage-introduction#example-scenarios).

Each service is accessed through a storage account. To get started, see [Create a storage account](/azure/storage/common/storage-account-create?tabs=azure-portal).

## Database considerations

The choice of database can affect an application's performance and scalability. Database reads and writes involve a network call and storage I/O, both of which are expensive operations. Choosing the right database service to store and retrieve data is therefore a critical decision and must be considered to ensure application scalability. Azure has many database services that will fit most needs. In addition, there are third-party options that can be considered from [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace).

To help you choose a database type, determine if the application's storage requirements fit a relational design (SQL) versus a key-value/document/graph design (NoSQL). Some applications may have both a SQL and a NoSQL database for different storage needs. Use the [Azure data store decision tree](../../guide/technology-choices/data-store-decision-tree.md) to help you find the appropriate managed data storage solution.

### Why use a relational database?

Use a relational database when strong consistency guarantees are important — where all changes are atomic, and transactions always leave the data in a consistent state. However, a relational database generally can't scale out horizontally without sharding the data in some way. Implementing manual sharding can be a time consuming task. Also, the data in relational database must be normalized, which isn't appropriate for every data set.

If a relational database is considered optimal, Azure offers several PaaS options that fully manage hosting and operations of the database. Azure SQL Database can host single databases or multiple databases (Azure SQL Database Managed Instance). The suite of offerings spans requirements that cross performance, scale, size, resiliency, disaster recovery, and migration compatibility. Azure offers the following PaaS relational database services:

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [Azure Database for MariaDB](https://azure.microsoft.com/services/mariadb)

### Why use a NoSQL database?

Use a NoSQL database when application performance and availability are more important than strong consistency. NoSQL databases are ideal for handling large, unrelated, indeterminate, or rapidly changing data. NoSQL databases have trade-offs. For specifics, see [Some challenges with NoSQL databases](/azure/cosmos-db/relational-nosql#some-challenges-with-nosql-databases).

Azure provides two managed services that optimize for NoSQL solutions: [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) and [Azure Cache for Redis](https://azure.microsoft.com/services/cache). For document and graph databases, Cosmos DB offers extreme scale and performance.

For a detailed description of NoSQL and relational databases, see [Understanding the differences](/azure/cosmos-db/relational-nosql).

## Choose the right VM size

Choosing the wrong VM size can result in capacity issues as VMs approach their limits. It can also lead to unnecessary cost. To choose the right VM size, consider your workloads, number of CPUs, RAM capacity, disk size, and speed according to business requirements. For a snapshot of Azure VM sizes and their purpose, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes).

Azure offers the following categories of VM sizes, each designed to run different workloads. Click a category for details.

- [General-purpose](/azure/virtual-machines/sizes-general) - Provide balanced CPU-to-memory ratio. Ideal for testing and development, small to medium databases, and low to medium traffic web servers.
- [Memory optimized](/azure/virtual-machines/sizes-memory) - Offer a high memory-to-CPU ratio that is great for relational database servers, medium to large caches, and in-memory analytics.
- [Compute optimized](/azure/virtual-machines/sizes-compute) - Have a high CPU-to-memory ratio. These sizes are good for medium traffic web servers, network appliances, batch processes, and application servers.
- [GPU optimized](/azure/virtual-machines/sizes-gpu) - Available with single, multiple, or fractional GPUs. These sizes are designed for compute-intensive, graphics-intensive, and visualization workloads.
- [High performance compute](/azure/virtual-machines/sizes-hpc) - Designed to deliver leadership-class performance, scalability, and cost efficiency for a variety of real-world HPC workloads.
- [Storage optimized](/azure/virtual-machines/sizes-storage) - Offer high disk throughput and IO, and are ideal for Big Data, SQL, NoSQL databases, data warehousing, and large transactional databases. Examples include Cassandra, MongoDB, Cloudera, and Redis.

You can change the sizing requirements according to your needs and requirements.

## Build with microservices

Microservices are a popular architectural style for building applications that are resilient, highly scalable, independently deployable, and able to evolve quickly. A microservices architecture consists of a collection of small, autonomous services. Each service is self-contained and should implement a single business capability. Breaking up larger entities into small discrete pieces alone doesn't ensure sizing and scaling capabilities. Application logic needs to be written to control this.

One of the many benefits of microservices is that they can be scaled independently. This lets you scale out subsystems that require more resources, without scaling out the entire application. Another benefit is fault isolation. If an individual microservice becomes unavailable, it won't disrupt the entire application, as long as any upstream microservices are designed to handle faults correctly (for example, by implementing circuit breaking).

To learn more about the benefits of microservices, see [Benefits](../../microservices/index.md#benefits).

Building with microservices comes with challenges such as development and testing. Writing a small service that relies on other dependent services requires a different approach than writing a traditional monolithic or layered application. Existing tools are not always designed to work with service dependencies. Refactoring across service boundaries can be difficult. It is also challenging to test service dependencies, especially when the application is evolving quickly.

See [Challenges](../../microservices/index.md#challenges) for a list of possible drawbacks of a microservice architecture.

## Use dynamic service discovery for microservices applications

When there are many separate services or instances of services in play, they will need to receive instructions on who to contact and/or other configuration information. Hard coding this information is flawed, and this is where service discovery steps in. A service instance can spin up and dynamically discover the configuration information it needs to become functional without having that information hard coded.

When combined with an orchestration platform designed to execute and manage microservices such as Kubernetes or Service Fabric, individual services can be right sized, scaled up, scaled down, and dynamically configured to match user demand. Using an orchestrator such as Kubernetes or Service Fabric, you can pack a higher density of services onto a single host, which allows for more efficient utilization of resources. Both of these platforms provide built-in services for executing, scaling, and operating a microservices architecture; and one of those key services is discovery and finding where a particular service is running.

Kubernetes supports pod autoscaling and cluster autoscaling. To learn more, see [Autoscaling](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml#autoscaling). A Service Fabric architecture takes a different approach to scaling for stateless and stateful services. To learn more, see [Scaling considerations](../../reference-architectures/microservices/service-fabric.yml#scaling-services).

> [!TIP]
> When appropriate, decomposing an application into microservices is a level of decoupling that is an architectural best practice. A microservices architecture can also bring some challenges. The design patterns in [Design patterns for microservices](../../microservices/design/patterns.md) can help mitigate these challenges.

## Establish connection pooling

Establishing connections to databases is typically an expensive operation that involves establishing an authenticated network connection to the remote database server. This is especially true for applications that open new connections frequently. Use connection pooling to reduce connection latency by reusing existing connections and enable higher database throughput (transactions per second) on the server. By doing this, you avoid the expense of opening a new connection for each request.

### Pool size limits

Azure limits the number of network connections a virtual machine or AppService instance can make. Exceeding this limit would cause connections to be slowed down or terminated. With connection pooling, a fixed set of connections are established at the startup time and maintained. In many cases, a default pool size might only consist of a small handful of connections that performs quickly in basic test scenarios, but become a bottleneck under scale when the pool is exhausted. Establishing a pool size that maps to the number of concurrent transactions supported on each application instance is a best practice.

Each database and application platform will have slightly different requirements for the right way to set up and leverage the pool. See [SQL Server Connection Pooling](/dotnet/framework/data/adonet/sql-server-connection-pooling) for a .NET code example using SQL Server and Azure Database. In all cases, testing is paramount to ensure a connection pool is properly established and working as designed under load.

> [!TIP]
> Use a pool size that uses the same number of concurrent connections. Choose a size that can handle more than the existing connections so you can quickly handle a new request coming in.

### Integrated security

Integrated security is a singular unified solution to protect every service that a business runs through a set of common policies and configuration settings. In addition to reducing issues associated with scaling, provisioning, and managing (including higher costs and complexity), integrated security also increases control and overall security. However, there may be times when you may not want to use connection pooling for security reasons. For example, although connection pooling improves the performance of subsequent database requests for a single user, that user cannot take advantage of connections made by other users. It also results in at least one connection per user to the database server.

Measure your business' security requirements against the advantages and disadvantages of connection pooling. To learn more, see [Pool fragmentation](/dotnet/framework/data/adonet/sql-server-connection-pooling#pool-fragmentation.)

## Next steps

> [!div class="nextstepaction"]
> [Application efficiency](./design-efficiency.md)