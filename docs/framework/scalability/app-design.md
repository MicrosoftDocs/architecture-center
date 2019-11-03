---
title: Designing scalable Azure applications
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you designing your applications to scale? 
---

# Designing scalable Azure applications

Application design is critical to handling scale as load increases.

## Choosing the right database

The choice of database and the overall design of the data tier can greatly affect an application's performance and scalability. Database reads and writes involve a network call and storage IO, both of which are expense operations. Choosing the right database service to store and retrieve data is therefore a critical decision and must be carefully considered to ensure overall application scalability. Azure has many first party database services that will fit most needs. In addition, there are a series of third-party options that can be considered from Azure Marketplace.

The first decision to consider is whether the application storage requirements fit a relational design (SQL) vs a key-value/document/graph design (NO-SQL). Some applications may have both a relational database and a NO-SQL database for different storage needs.

If a relational RDBMS is considered optimal, Azure offers several PaaS options that fully manage hosting and operations of the database. Azure SQL Database has can host single databases or multiple databases (Azure SQL Database Managed Instance). The suite of offerings span requirements crossing performance, scale, size, resiliency, disaster recovery, and migration compatibility. Azure offers the following PaaS relational database services:  

- [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/services/postgresql)
- [Azure Database for MariaDB](https://azure.microsoft.com/services/mariadb)

If the application requirements fall into a format that better fits a key/value format or document storage (i.e JSON, XML, YAML, etc.), a NO-SQL should be considered as first option for performance, scale, and cost savings.

For key/value storage needs, Azure provides two managed services that optimize for this scenario. [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) and [Azure Cache for Redis](https://azure.microsoft.com/services/cache). For document and graph databases, Cosmos DB is a highly recommended first party service offering extreme scale and performance.

## Dynamic service discovery for microservices applications

Clients can use either client-side discovery or server-side discovery to determine the location of a service instance to send requests. Service discovery is a process of figuring out how to connect to a service, and if done correctly, can lead to software that scales out as usage increases. Decomposing an application into microservices is a practice that can directly lead to native scalability given a service's ability to be scaled and updated individually. This level of decoupling is an architectural best practice. However, when many microservices are in play, managing, executing, and operationalizing the services becomes a bottleneck, leading to the incorporation of an orchestration platform like Kubernetes or Service Fabric. Both of these platforms provide built-in services for executing, scaling, and operating a microservices architecture; and one of those key services is discovery and finding where a particular service is running.

The client of the service should not need to know or care where the service executes or how many instances of the service are executing. It is the job of the orchestration platform to connect the client to the service through a decoupled discovery service, such as DNS, that major orchestration platforms all provide. An example of how this works in [Kubernetes](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/). Dynamic service discovery can make an application more scalable, because each service can be scaled independently, without the client having knowledge of the individual instances.

Use the [service registry pattern](https://microservices.io/patterns/service-registry.html).

## Connection pooling

Establishing connections to databases is typically an expensive operation that involves establishing an authenticated network connection to the remote database server. Pooling and reusing cached connections for new database operations is a common best practice for improving both application performance and scalability. In many cases, a default pool size might only consist of a small handful of connections that performs quickly in basic test scenarios, but become a bottleneck under scale when the pool is exhausted. Establishing a pool size that maps to the number of concurrent transactions supported on each application instance is a best practice. Each database and application platform will have slightly different requirements for the right way to set up and leverage the pool. Review [SQL Server Connection Pooling](/dotnet/framework/data/adonet/sql-server-connection-pooling) for a .NET code example using SQL Server and Azure Database. In all cases, testing is paramount to ensure a connection pool is properly established and working as designed under load.

## Data Compression

A well known optimization best practice for scaling web applications is to use a compression strategy to compress and bundle web pages or api responses. The idea here is to shrink the results returned from a page or api back to the browser or client app. This optimizes network traffic and accelerating the web application. .NET has built in framework support for this technique with GZip compression. Review [Response compression in ASP.NET Core](/aspnet/core/performance/response-compression?view=aspnetcore-3.0) of using response compression with ASP.NET Core. The reason this can dramatically impact scale is the network optimization benefit means less socket processing for the web server reducing web server cpu utilization, shortening connections, and thus allowing the web server to handle more concurrent requests.

## Data Locking

When using a relational database behind an Azure hosted application, the app owners must ensure an appropriate consistency and isolation level when making database connections to achieve maximum performance and scale out. Consistency and isolation are two of the ACID database properties. Consistency is all about ensuring a transaction can roll back to a state before the transaction started. Isolation is all about ensuring an executing transaction remains isolated from other executing transactions. The settings of these ACID properties can dramatically affect the number of users that can concurrently use a cloud web application in parallel, and therefore needs to be carefully considered across the various exposed web pages and/or APIs. Review An excellent detail summary of these concepts in respect to [Azure SQL Database](/azure/sql-database/saas-tenancy-app-design-patterns).

## Asynchronous Programming

When an application calls a remote service leveraging a synchronous call, some of resources on the client (i.e caller thread, network socket, etc.) are blocked and unavailable for use elsewhere until the remote service invocation completes. This pattern is simple, but leads to obvious inefficiencies. Asynchronous programming is an alternative approach that enables a remote service to be executed without waiting and blocking resources on the client. This is a critical pattern for enabling cloud scalable software and is available in most modern programming languages and platforms.

There are many ways to inject asynchronous programming into an application design. In a simplest form, remote calls be asynchronously executed using built-in language constructs like "async/await" in .NET C#. Review a [language construct example](/dotnet/csharp/async). .NET has other built-in platform support for asynchronous programming with [task](/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap) and [event](/dotnet/standard/asynchronous-programming-patterns/event-based-asynchronous-pattern-eap) based asynchronous patters.

Asynchronous patterns are critical for cloud scale, and Azure enables the implementation of cloud patterns for async request/reply appropriate for long running worker type processing. These patterns simulate what a programming language like C# offers natively for request/response, but optimized for moving back-end processing out of a front end. Review the [asynchronous Request-Reply pattern](/azure/architecture/patterns/async-request-reply) for additional information.

## Microservices

Building software with microservices is a software engineering technique to decompose software into isolated, fine grained, and loosely coupled modules that are independently deployed and versioned. Microservices refine and build on the "component" patterns from the 1990s and early 2000s such as COM (Component Object Model) for breaking up logic into interface exposed modules. With the internet taking center stage, component models were combined with web protocols and transitioned into Service Oriented Architecture, and ultimately Web Services. Microservices is a type of web service that is optimized for high scale requirements. This is because microsevices are designed to be independent with both deployment and versioning, and therefore can be scaled independently. So when combined with an orchestration platform designed to execute and manage microservices such as Kubernetes or Service Fabric, individual services can be right sized, scaled up, scaled down, and dynamically configured to match user demand. Additionally, microservices can be built and run using cloud serverless platforms such as Azure Functions that can dynamically scale with a pay-per-use model. To learn more about these topics review [building microservices on Azure](/azure/architecture/microservices/).

## Queuing and batching requests

A variant to asynchronous programming discussed above, queuing services have long been used as a scalable mechanism to hand off processing work to a service. Called the Load Leveling pattern, highly scalable queuing services are natively supported in Azure. The queue is a storage buffer that sits between the caller and the processing service, takes requests, stores and queues the request, and provides services around the reliable delivery and management of the queued data. Queuing services have been in use for years with the likes of MSMQ (Microsoft Message Queue), MQSeries, and others; and cloud native  variants of queuing services have been part of Azure since its inception.

Using a queue is often the best way to hand off work to a processor service. The processor service receives work by listening on a queue and dequeuing messages. If items to be processed enter too quickly, the queuing service will keep them in the queue until the processing service has available resources and asks for a new work item (message). By leveraging the dynamic nature of Azure Functions, the processor service can easily autoscale on demand as the queue builds up to meet the intake pressure. Developing processor logic with Azure Functions to run task logic from a queue is a common, scalable, and cost effective way to using queuing between a client and a processor.  

Azure provides a few native first-party queueing services with Azure Storage Queues (simple queuing service based on Azure Storage) and Azure Service Bus (message broker service supporting transactions and reduced latency). Many other third-party options are also available through Marketplace. Review the [queue-based load leveling pattern](/azure/architecture/patterns/queue-based-load-leveling) to learn more.

## Session affinity

To design a system to be horizontally scalable, avoid designing a web application that assumes requests have instance affinity. Stateless, or non-affinity applications, allow the hosting platform (App Services, Kubernetes, Service Fabric, other) to dynamically add or remove compute instances based on service metrics. This is called autoscale and works differently depending on the service. A critical requirement for a web application or api to work in an autoscalable environment is a stateless nature where the application saves its state to an external data store allowing the app platform to load-balance and route requests across any of the clustered instances. This is advantageous for service self-healing, removing problematic compute instances, and enabling the latest platform innovation that leads to higher scale. For older applications running in App Services v1 platforms, avoid using the Application Request Routing (ARR) session affinity flag to force all requests back to the initial instance.

If the solution implements a long-running task, route requests to this task with queuing mechanisms discussed earlier.

## Autoscaling

Many of the compute offerings in Azure offer autoscale to ensure the right amount of resources are available mapping to service user demand. With autoscale, your service can scale out to new compute instances during busy periods and scale back in during silent periods. This is critical for both the service user experience as well as offering cost savings for the service implementor. The way it works is metrics are collected for the resource (i.e. cpu, memory utilization) and the application (requests queued, requests per second). Rules can then be created off those metrics and/or time schedules to add/remove instances depending on how the rule evaluates.

Many of the common Azure compute offerings support autoscale. An App Services App Plan allows autoscale rules to be set for scale-out and scale-in. Azure Kubernetes Service (AKS) offers two levels of autoscale. Firstly, AKS provides horizontal autoscale can be enabled on service containers to add more or less pod instances within the cluster. Secondly, AKS provides a cluster autoscale on the agent VM instances running an agent node-pool to add more ore remove VM instances dynamically. Service Fabric has similar offerings and virtual machine scale sets offers autoscale capabilities for true IaaS scenarios. In addition, Azure App Gateway and Azure API Management are PaaS offerings for ingress services that also enable autoscale. And lastly, Azure Functions, Azure Logic Apps, and App Services offer serverless pay-per-use consumption modeling that inherently provide autoscale.

Each service documents its autoscale capabilities. Review [Autoscale overview](/azure/azure-monitor/platform/autoscale-overview) for a general discussion on Azure platform autoscale.

## Background jobs

Back in the 1990s and early 2000's, Enterprise Application Integration became a major topic for hooking systems together, creating and scheduling jobs and tasks. These platforms offered a series of connectors for working with common formats and protocols like EDI/X12/EDIFACT, SFTP, HL7, SWIFT, and SOAP; and managing long running processes that may span minutes/hours/days through workflow orchestration. Along with workflow, these integration tools solved app-to-app and business-to-business integration needs. Not surprisingly, these needs still exist in the cloud, but a scalable cloud native way of enabling these capabilities is paramount, and that's what the Logic Apps service enables in Azure. Logic Apps is a serverless consumption  (pay-per-use) service that enables a vast set of out-of-the-box ready-to-use connectors and a long-running workflow engine to quickly enable cloud-native integration needs. Logic Apps is flexible enough for a plethora of sceneries like running tasks/jobs, advanced scheduling, and triggering. It includes many of the format and protocol capabilities that existed in Microsoft's enterprise EAI product called BizTalk Server, and has advanced hosting options to allow it run within enterprise restricted cloud environments. Logic Apps compliments and can be combined with all other Azure services, or it can be used independently.

Like all serverless services, [Logic Apps](/azure/logic-apps/logic-apps-overview) doesn't require VM instances to be purchased, enabled, and scaled up and down. Instead, Logic Apps scale automatically on serverless PaaS provided instances, and a consumer only pays based on usage.
