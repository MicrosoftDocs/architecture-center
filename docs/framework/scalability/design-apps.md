---
title: Design scalable Azure applications
description: Describes the design considerations for scalable applications
author: v-aangie
ms.date: 11/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you designing your applications to scale?
  - article
---

# Design scalable Azure applications

Application design is critical to handling scale as load increases. <!--See Application Efficiency for additional topics....-->

## Choose the right database

The choice of database and the overall design of the data tier can greatly affect an application's performance and scalability. Database reads and writes involve a network call and storage I/O, both of which are expense operations. Choosing the right database service to store and retrieve data is therefore a critical decision and must be carefully considered to ensure application scalability. Azure has many first party database services that will fit most needs. In addition, there are third-party options that can be considered from [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace).

The first decision to consider is whether the application storage requirements fit a relational design (SQL) versus a key-value/document/graph design (NO-SQL). Some applications may have both a relational database and a NO-SQL database for different storage needs.

If an RDBMS is considered optimal, Azure offers several PaaS options that fully manage hosting and operations of the database. Azure SQL Database can host single databases or multiple databases (Azure SQL Database Managed Instance). The suite of offerings spans requirements that cross performance, scale, size, resiliency, disaster recovery, and migration compatibility. Azure offers the following PaaS relational database services:  

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [Azure Database for MariaDB](https://azure.microsoft.com/services/mariadb)

If the application requirements are best suited to a key/value format or document storage (i.e., JSON, XML, YAML, etc.), a NO-SQL solution should be considered first to optimize for performance, scale, and cost savings.

Azure provides two managed services that optimize for NO-SQL solutions: [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) and [Azure Cache for Redis](https://azure.microsoft.com/services/cache). For document and graph databases, Cosmos DB is a highly recommended first party service offering extreme scale and performance.

## Build with microservices

Building software with microservices is a software engineering technique to decompose software into isolated, fine grained, and loosely coupled modules that are independently deployed and versioned. Microservices refine and build on the "component" patterns from the 1990s and early 2000s such as COM (Component Object Model) for breaking up logic into interface exposed modules. With the internet taking center stage, component models were combined with web protocols and transitioned into Service-Oriented Architecture, and ultimately Web Services. Microservices is a type of web service that is optimized for high scale requirements. This is because microservices are designed to be independent with both deployment and versioning, and therefore can be scaled independently. When combined with an orchestration platform designed to execute and manage microservices such as Kubernetes or Service Fabric, individual services can be right sized, scaled up, scaled down, and dynamically configured to match user demand. Additionally, microservices can be built and run using cloud serverless platforms such as Azure Functions that can dynamically scale with a pay-per-use model.

To learn more about these topics, see [Building microservices on Azure](../../microservices/index.md).
For information about a reference architecture that uses microservices, see  [Microservices on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.md).

## Use dynamic service discovery for microservices applications

Service discovery is a process of figuring out how to connect to a service, and if done correctly, can lead to software that scales out as usage increases. Clients can use either client-side discovery or server-side discovery to determine the location of a service instance to send requests. Decomposing an application into microservices is a practice that can directly lead to native scalability given a service's ability to be scaled and updated individually. This level of decoupling is an architectural best practice. However, when many microservices are in play, managing, executing, and operationalizing the services becomes a bottleneck, leading to the incorporation of an orchestration platform like Kubernetes or Service Fabric. Both of these platforms provide built-in services for executing, scaling, and operating a microservices architecture; and one of those key services is discovery and finding where a particular service is running.

The client of the service should not need to know or care where the service executes or how many instances of the service are executing. It is the job of the orchestration platform to connect the client to the service through a decoupled discovery service, such as DNS, that major orchestration platforms all provide. An example of how this works is [Kubernetes](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/). Dynamic service discovery can make an application more scalable because each service can be scaled independently, without the client having knowledge of the individual instances.

To discover the network location of a service instance, use the [service registry pattern](https://microservices.io/patterns/service-registry.html).

## Connection pooling

Establishing connections to databases is typically an expensive operation that involves establishing an authenticated network connection to the remote database server. Pooling and reusing cached connections for new database operations is a common best practice for improving both application performance and scalability. In many cases, a default pool size might only consist of a small handful of connections that performs quickly in basic test scenarios, but become a bottleneck under scale when the pool is exhausted. Establishing a pool size that maps to the number of concurrent transactions supported on each application instance is a best practice. Each database and application platform will have slightly different requirements for the right way to set up and leverage the pool. Review [SQL Server Connection Pooling](/dotnet/framework/data/adonet/sql-server-connection-pooling) for a .NET code example using SQL Server and Azure Database. In all cases, testing is paramount to ensure a connection pool is properly established and working as designed under load.

## Data Locking

When using a relational database behind an Azure hosted application, the app owners must ensure an appropriate consistency and isolation level when making database connections to achieve maximum performance and scale out. Consistency and isolation are two of the ACID database properties. Consistency is all about ensuring a transaction can roll back to a state before the transaction started. Isolation is all about ensuring an executing transaction remains isolated from other executing transactions. The settings of these ACID properties can dramatically affect the number of users that can concurrently use a cloud web application in parallel, and therefore needs to be carefully considered across the various exposed web pages and/or APIs. Review An excellent detail summary of these concepts in respect to [Azure SQL Database](/azure/sql-database/saas-tenancy-app-design-patterns).

## Background jobs

Back in the 1990s and early 2000's, Enterprise Application Integration became a major topic for hooking systems together, creating and scheduling jobs and tasks. These platforms offered a series of connectors for working with common formats and protocols like EDI/X12/EDIFACT, SFTP, HL7, SWIFT, and SOAP; and managing long running processes that may span minutes/hours/days through workflow orchestration. Along with workflow, these integration tools solved app-to-app and business-to-business integration needs. Not surprisingly, these needs still exist in the cloud, but a scalable cloud native way of enabling these capabilities is paramount, and that's what the Logic Apps service enables in Azure. Logic Apps is a serverless consumption (pay-per-use) service that enables a vast set of out-of-the-box ready-to-use connectors and a long-running workflow engine to quickly enable cloud-native integration needs. Logic Apps is flexible enough for a plethora of sceneries like running tasks/jobs, advanced scheduling, and triggering. It includes many of the format and protocol capabilities that existed in Microsoft's enterprise EAI product called BizTalk Server, and has advanced hosting options to allow it run within enterprise restricted cloud environments. Logic Apps compliments and can be combined with all other Azure services, or it can be used independently.

Like all serverless services, [Logic Apps](/azure/logic-apps/logic-apps-overview) doesn't require VM instances to be purchased, enabled, and scaled up and down. Instead, Logic Apps scale automatically on serverless PaaS provided instances, and a consumer only pays based on usage.