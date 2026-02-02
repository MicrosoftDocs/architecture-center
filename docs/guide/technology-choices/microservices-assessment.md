---
title: Microservices Assessment and Readiness 
description: Learn about the considerations to keep in mind when you move to a microservices architecture. Use this guide to assess your application's readiness.
author: ovaismehboob 
ms.author: ovmehboo
ms.date: 06/16/2025
ms.topic: concept-article
ms.reviewer: nasiddi
ms.subservice: architecture-guide
ms.custom: fcp
---

# Microservices assessment and readiness 

A microservices architecture can provide many benefits for your applications, including agility, scalability, and high availability. This architecture can also present challenges. When you build microservices-based applications or transform existing applications into a microservices architecture, you need to analyze and assess your current situation to identify areas that need improvement.

This article describes some considerations to keep in mind when you move to a microservices architecture. You can use this guide to assess the maturity of your application, infrastructure, DevOps, and development model.

## Understand business priorities

To evaluate a microservices architecture, you need to first understand the core priorities of your business. For example, core priorities might be related to agility, change adoption, or rapid development. You need to analyze whether your architecture is a good fit for your core priorities. Keep in mind that business priorities can change over time. For example, innovation is a top priority for startups. However, after a few years, the core priorities might be reliability and efficiency.

Consider the following priorities:

- Innovation, including fostering agility and experimentation
- Reliability, including ensuring high availability and fault tolerance
- Efficiency, including optimizing resources and productivity

Document the service-level objectives (SLOs) that align with various parts of your application to ensure an organizational commitment that can guide your assessment. 

## Record architectural decisions

A microservices architecture helps teams become autonomous. Teams can make their own decisions about technologies, methodologies, and infrastructure components. However, these choices should respect the formally agreed-upon principles known as shared governance. These principles express the agreement among teams about how to address the broader strategy for microservices.

Consider the following factors:

- Whether shared governance is in place to guide architecture decisions across teams

- Whether you maintain architecture decision records (ADRs) that include clear rationale, trade-offs, and status

- Whether you maintain an architecture journal to capture design explorations and evolving context

- Whether your team can easily access and search your ADRs and architecture journal

- Whether you have a technology evaluation framework to assess new tools and frameworks

- Whether you have established principles for technology selection and standardization

- Whether architectural decisions are reviewed and updated regularly as business and technical requirements evolve

## Assess team composition

You need to structure your team properly to avoid unnecessary communication across teams. Small, focused, cross-functional teams are the best fit for a microservices architecture. These adjustments often require a mindset change, which must precede team restructuring.

Consider the following factors:

- Whether your teams are divided based on subdomains and follow [domain-driven design (DDD) principles](/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)

- Whether your teams are cross-functional and have enough capacity to build and operate related microservices independently

- The amount of time that's spent in unplanned activities and tasks that aren't related to projects

- The amount of time that's spent in cross-team collaboration

- Whether you have a process for identifying and minimizing technical debt

- How teams learn lessons and how they communicate this experience

## Use the Twelve-Factor methodology

The fundamental goal of choosing a microservices architecture is to deliver value faster and adapt to change by following agile practices. The [Twelve-Factor app methodology](/dotnet/architecture/cloud-native/definition#the-twelve-factor-application) provides guidelines for how to build maintainable and scalable applications. These guidelines promote attributes like immutability, ephemerality, declarative configuration, and automation. By incorporating these guidelines and avoiding common pitfalls, you can create loosely coupled, self-contained microservices. 

## Understand the decomposition approach

Transforming a monolithic application to a microservices architecture takes time. Start with edge services. Edge services have fewer dependencies on other services and can be easily separated from the system as independent services. We highly recommend patterns like [Strangler Fig](../../patterns/strangler-fig.md) and [Anti-Corruption Layer](../../patterns/anti-corruption-layer.yml) to keep the monolithic applications in a working state until all services are decomposed into separate microservices. During segregation, the principles of DDD can help teams choose components or services from the monolithic application based on subdomains. 

For example, an e-commerce system might have modules like cart, product management, order management, pricing, invoice generation, and notification. You decide to start the transformation of the application with the notification module because it doesn't have dependencies on other modules. However, other modules might depend on this module to send out notifications. You can make the notification module a separate microservice, but you also need to update the monolithic application to call the new notification service. You decide to transform the invoice generation module next. This module is called after an order is generated. You can use patterns like Strangler Fig and Anti-Corruption Layer to support this transformation.

Data synchronization, multiple writes to both monolithic and microservice interfaces, data ownership, schema decomposition, joins, volume of data, and data integrity might make data breakdown and migration difficult. There are several techniques that you can use, like keeping a shared database between microservices, decoupling databases from a group of services based on business capability or domain, and isolating databases from the services. An ideal solution is to decompose each database with each service. Some circumstances might make that approach impractical. In these cases, you can apply patterns like the [Materialized View pattern](/azure/architecture/patterns/materialized-view) and approaches such as [application modernization by using an API wrapper](/azure/app-modernization-guidance/expand/modernize-applications-using-an-api-wrapper) to abstract and modernize access to legacy or shared data.

## Assess DevOps readiness

When you move to a microservices architecture, it's important to assess your DevOps competence. A microservices architecture should facilitate agile development in applications to increase organizational agility. DevOps is one of the key practices that you should implement to achieve this competence.

When you evaluate your DevOps capability for a microservices architecture, consider the following points:

- Whether people in your organization know the fundamental practices and principles of DevOps

- Whether teams understand source control tools and how they integrate with continuous integration and continuous delivery (CI/CD) pipelines

- Whether you implement DevOps practices properly, including:

   - Following agile practices.

   - Implementing continuous integration.

   - Implementing continuous delivery where code changes are automatically built, tested, and prepared for release to production. This approach helps ensure that software can be confidently released at any time and with manual approval.

   - Implementing continuous deployment that extends continuous delivery by automatically deploying code changes to production after it passes all automated tests, without manual intervention.

   - Embedding continuous monitoring across all phases of DevOps and IT Ops to ensure the ongoing health, performance, and reliability of applications and infrastructure as they move from development to production and customer environments.

- Whether your build and deployment automation strategy aligns with your team's delivery objectives and operational requirements

- Whether you use feature flags and progressive exposure deployment strategies

- How configuration of staging and production environments is managed for the application

- Whether the tool chain has community support and a support model and provides proper channels and documentation

## Identify business areas that change frequently

A microservices architecture is flexible and adaptable. During assessment, drive a discussion in your organization to determine the areas that your colleagues expect to change frequently. Building microservices allows teams to quickly respond to changes that customers request and minimize regression testing efforts. In a monolithic application, a change in one module requires numerous levels of regression testing and reduces agility in new version releases. 

Consider the following factors:

- Whether the service is independently deployable

- Whether the service follows DDD principles

- Whether the service follows single responsibility, open-closed, Liskov substitution, interface segregation, and dependency inversion (SOLID) principles 

- Whether the database is private to the service

- Whether you build the service by using the supported microservices chassis framework

## Assess infrastructure readiness

When you shift to a microservices architecture, infrastructure readiness is a critical point to consider. Improper setup of the infrastructure or not using the appropriate services or components affects the application's performance, availability, and scalability. You might use all of the suggested methodologies and procedures to create an application. However, if the infrastructure is inadequate, the application might perform poorly and require extra maintenance. 

Consider the following factors when you evaluate your infrastructure readiness:

- Whether the infrastructure ensures the scalability of the deployed services

- Whether you have container infrastructure ready for microservices deployment

- Whether the infrastructure supports provisioning through scripts that can be automated via CI/CD

- Whether the deployment infrastructure offers a service-level agreement (SLA) for availability

- Whether you have a disaster recovery (DR) plan and routine drill schedules

- Whether the data is replicated to different regions for DR

- Whether you have a data backup plan

- Whether the deployment options are documented

- Whether the deployment infrastructure is monitored

- Whether the deployment infrastructure supports self-healing of services

## Assess release cycles

Microservices can adapt to change and take advantage of agile development to shorten release cycles and bring value to customers faster. Consider the following factors when you evaluate your release cycles:

- How often you build and release applications.

- How often your releases fail after deployment.

- How long it takes to recover or remediate problems after an outage.

- Whether you use semantic versioning for your applications.

- Whether you maintain different environments and propagate the same release in a sequence. For example, you release to staging first and then to production.

- Whether you use versioning for your APIs.

- Whether you follow proper [versioning guidelines](/azure/architecture/best-practices/api-design#implement-versioning) for APIs.

- When you change an API version.

- What your approach to handling API versioning is, including:

   - URI path versioning.
   - Query parameter versioning.
   - Content-type versioning.
   - Custom header versioning.

- Whether you have a practice in place for event versioning.

## Assess communication across services

Microservices are self-contained services that communicate with each other across process boundaries to address business scenarios. To achieve reliable and dependable communication, you need to select an appropriate communication protocol.

Consider the following factors:

- Whether you follow an API-first approach, where you design and maintain APIs as primary components of your system architecture.

- Whether you evaluate high-performance protocols, such as gRPC, HTTP/2, or asynchronous messaging like Kafka or NATS, for efficient service-to-service communication.

- Whether you have long-chain operations, where multiple services communicate in sequence over a synchronous communication protocol.

- Whether you use event streaming platforms for real-time data processing.

- Whether you plan to implement asynchronous communication anywhere in the system.

- Whether you plan to assess the message broker technology and its capabilities.

- Whether you understand the throughput of messages that services receive and process.

- Whether you use direct client-to-service communication.

- Whether you need to persist messages at the message-broker level.

- Whether you use the [Materialized View pattern](/azure/architecture/patterns/materialized-view) to address the chatty behavior of microservices.

- Whether you plan to implement Retry, Circuit Breaker, Exponential Backoff, or Jitter patterns for reliable communication. A common way to handle these features is to use the [Ambassador pattern](../../patterns/ambassador.yml).

- Whether you have defined domain events to facilitate communication between microservices.

## Evaluate how services are exposed to clients

An API gateway is one of the core components in a microservices architecture. Directly exposing services to the clients creates problems with manageability, control, and dependable communication. An API gateway serves as a proxy server that intercepts traffic and routes it to back-end services. If you need to filter traffic by IP address, authorization, or mock responses, you can filter it at the API gateway level without making any changes to the services.

Consider the following factors:

- Whether clients directly consume the services

- Whether an API gateway serves as a unified facade for all of the services

- Whether you implement the [Backends for Frontends (BFF) pattern](/azure/architecture/patterns/backends-for-frontends) for different client types

- Whether the API gateway can set up policies like quota limits, mock responses, and IP address filtering

- Whether you use multiple API gateways to address the needs of various types of clients, like mobile apps, web apps, and partners

- Whether your API gateway provides a portal where clients can discover and subscribe to services, like a developer portal in [Azure API Management](https://azure.microsoft.com/services/api-management)

- Whether your solution provides L7 load balancing or web application firewall (WAF) capabilities along with the API gateway
 
## Assess transaction handling

Distributed transactions help run multiple operations as a single unit of work. In a microservices architecture, the system is decomposed into numerous services. Multiple microservices address a single business use case as part of a single distributed transaction. In a distributed transaction, a command is an operation that starts when an event occurs. The event triggers an operation in the system. If the operation succeeds, it might trigger another command, which can then trigger another event. This process continues until all of the transactions are complete or rolled back, depending on whether the transaction succeeds.

Consider the following factors:

- The number of distributed transactions in the system

- How you handle distributed transactions, including the use of the [Saga pattern](/azure/architecture/reference-architectures/saga/saga) with orchestration or choreography

- Whether you use [event sourcing](/azure/architecture/patterns/event-sourcing) to maintain transaction history and state

- Whether you implement [Command Query Responsibility Segregation (CQRS) patterns](/azure/architecture/patterns/cqrs)

- How many transactions span multiple services

- Whether you follow an atomicity, consistency, isolation, and durability (ACID) transaction model or a basically available, soft state, and eventually consistent (BASE) transaction model to achieve data consistency and integrity

- Whether you use long-chaining operations for transactions that span multiple services

- Whether you implement compensation patterns in addition to Saga for transaction rollback

## Assess your service development model

One of the greatest benefits of microservices architectures is technology diversity. Microservices-based systems enable teams to develop services by using the technologies that they choose. In traditional application development, you might reuse existing code when you build new components, or create an internal development framework to reduce development effort. The use of multiple technologies can prevent code reuse. 

Consider the following factors:

- Whether you use a standardized service template to accelerate new service development and ensure consistency in architecture, deployment, and DevOps practices

- Whether you follow the Twelve-Factor app methodology and use a single code base for microservices to isolate dependencies and externalize configuration

- Whether you keep sensitive configuration in key vaults

- Whether you containerize your services

- Whether you know your data consistency requirements

## Assess your deployment approach

Your deployment approach is your method for releasing versions of your application across various deployment environments. Microservices-based systems provide the agility to release versions faster than you can for traditional applications. 

When you assess your deployment plan, consider the following factors:

- Whether you have a strategy for deploying your services

- Whether you use modern tools and technologies to deploy your services

- What kind of collaboration that teams require when you deploy services

- Whether you provision infrastructure by using infrastructure as code (IaC)

- Whether you follow immutable infrastructure principles

- Whether you use DevOps capabilities to automate deployments

- Whether you propagate the same builds to multiple environments, as suggested by the Twelve-Factor app methodology

## Assess your hosting platform

Scalability is one of the key advantages of microservices architectures. Microservices map to business domains, so you can scale each service independently. A monolithic application is deployed as a single unit on a hosting platform, so you need to scale it holistically. This approach results in downtime, deployment risk, and maintenance. Your monolithic application might be well designed and have components that address individual business domains. But because of a lack of process boundaries, the potential to violate the principles of single responsibility increases. Efforts to ensure the principles of single responsibility can result in code that lacks structure and is difficult to maintain. Because the application is composed and deployed as a single hosting process, scalability is difficult to achieve.

Microservices enable teams to choose the right hosting platform to support their scalability needs. Various hosting platforms can address these challenges by providing capabilities like autoscaling, elastic provisioning, higher availability, faster deployment, and easy monitoring.

Consider the following factors:

- Which hosting platform, like virtual machines, containers, or serverless platforms, you use to deploy your services

- Whether the hosting platform is scalable and supports autoscaling

- How long it takes to scale your hosting platform

- Whether you understand the SLAs that various hosting platforms provide

- Whether your hosting platform supports DR

## Assess services monitoring

Monitoring is an important element of a microservices-based application. Troubleshooting errors can be daunting because the application is divided into many services that run independently. If you use proper semantics to monitor your services, your teams can easily monitor, investigate, and respond to errors. 

Consider the following factors:

- Whether you monitor your deployed services

- Whether you have defined SLOs

- Whether you have a logging mechanism, and what tools you use

- Whether you have a distributed tracing infrastructure in place

- Whether you record exceptions

- Whether you maintain business error codes to quickly identify problems

- Whether you use health probes for services

- Whether you use semantic logging and implement key metrics, thresholds, and indicators

- Whether you mask sensitive data during logging

- Whether you monitor service dependencies and external integrations

## Assess correlation token assignment

In a microservices architecture, an application is composed of various microservices that are hosted independently and interact with each other to serve various business use cases. When an application interacts with back-end services to perform an operation, you can assign a unique number, known as a correlation token, to the request. We recommend that you consider using correlation tokens because they can help you troubleshoot errors. They help you determine the root cause of a problem, assess the impact, and determine an approach to remediate the problem.

You can use correlation tokens to retrieve the request trail by identifying which services contain the correlation token and which don't. The services that don't have the correlation token for that request failed. If a failure occurs, you can retry the transaction. To enforce idempotency, only services that don't have the correlation token serve the request.

For example, if you have a long chain of operations that includes many services, passing a correlation token to services can help you investigate problems easily if any of the services fail during a transaction. Each service usually has its own database. The correlation token is kept in the database record. If a transaction replays, services that have that specific correlation token in their databases ignore the request. Only services that don't have the token serve the request. 

Consider the following factors:

- At which stage you assign the correlation token

- Which component assigns the correlation token

- Whether you save correlation tokens in the service's database

- The format of correlation tokens

- Whether you log correlation tokens and other request information

## Evaluate the need for a microservices chassis framework

A microservices chassis framework is a base framework that provides capabilities for cross-cutting concerns like logging, exception handling, distributed tracing, security, and communication. When you use a chassis framework, you focus more on implementing the service boundary than on interacting with infrastructure functionality.

For example, say that you're building a cart management service. You want to validate the incoming token, write logs to the logging database, and communicate with another service by invoking that service's endpoint. If you use a microservices chassis framework, you can reduce development efforts. Dapr is one system that provides various building blocks for implementing cross-cutting concerns.

Consider the following factors:

- Whether you use a microservices chassis framework.

- Whether you use Dapr to interact with cross-cutting concerns.

- Whether your chassis framework is language agnostic.

- Whether your chassis framework is generic so that it can support all kinds of applications. A chassis framework shouldn't contain application-specific logic.

- Whether your chassis framework provides a mechanism to use the selected components or services as needed.

## Assess your approach to application testing

You typically test the application after development is complete and it's ready to roll out to user acceptance testing (UAT) and production environments. Consider testing earlier in the application development life cycle. This approach is known as shift-left testing. It increases the quality of applications because you do testing during each phase of the application development life cycle, including the design, development, and post-development phases.

For example, when you build an application, you start by designing an architecture. When you use the shift-left approach, you test the design for vulnerabilities by using tools like [Microsoft Threat Modeling](/azure/security/develop/threat-modeling-tool). When you start development, you can scan your source code by running tools like static application security testing (SAST) and by using other analyzers to uncover problems. After you deploy the application, you can use tools like dynamic application security testing (DAST) to test it while it's hosted. Functional testing, chaos testing, penetration testing, and other kinds of testing occur later.

Consider the following factors:

- Whether you write test plans that cover the entire development life cycle

- Whether you include testers in requirements meetings and in the entire application development life cycle

- Whether you use test-driven design or behavior-driven design

- Whether you test user stories and include acceptance criteria in your user stories

- Whether you test your design by using tools like Microsoft Threat Modeling

- Whether you write unit tests

- Whether you use static code analyzers or other tools to measure code quality

- Whether you use automated tools to test applications

- Whether you implement [secure DevOps](https://www.microsoft.com/securityengineering/devsecops) practices

- Whether you do integration testing, end-to-end application testing, load and performance testing, penetration testing, and chaos testing

## Assess microservices security

Service protection, secure access, and secure communication are among the most important considerations for a microservices architecture. For example, a microservices-based system that spans multiple services and uses token validation for each service isn't a viable solution. This type of system affects the agility of the overall system and might introduce implementation drift across services.

The API gateway and the application firewall usually handle security concerns. The gateway and firewall take incoming requests, validate tokens, and apply various filters and policies, like implementing OWASP Top 10 principles to intercept traffic. Finally, they send the request to the back-end microservices. This configuration helps developers focus on business needs instead of worrying about the cross-cutting concern of security.

Consider the following factors:

- Whether the service requires authentication and authorization and whether you implement [Zero Trust architecture principles](/azure/security/fundamentals/zero-trust)

- Whether you have a comprehensive secrets management strategy that includes key rotation, life cycle management, and auditing, beyond simply storing secrets in a key vault

- Whether you use an API gateway to validate tokens and incoming requests

- Whether you use Secure Sockets Layer (SSL) or mutual Transport Layer Security (mTLS) to provide security for service communication

- Whether you implement container and image security scanning

- Whether you implement network security policies to allow the required communication among services

- Whether you use firewalls, like L4 or L7, where applicable to provide more security for internal and external communications

- Whether you use security policies in API gateways to control traffic

- Whether you have runtime security monitoring to detect anomalous behavior

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Ovais Mehboob Ahmed Khan](https://www.linkedin.com/in/ovaismehboob/) | Senior Cloud Solution Architect - Cloud and AI Apps
- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams/) | Solution Engineer - Cloud and AI Apps

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microservices on Azure](https://azure.microsoft.com/solutions/microservice-applications)
- [Book: *Embracing Microservices Design*](https://www.amazon.com/Embracing-Microservices-Design-anti-patterns-architectural/dp/180181838X) 
- [Introduction to deployment patterns](/training/modules/introduction-to-deployment-patterns)
- [Design a microservices-oriented application](/dotnet/architecture/microservices/multi-container-microservice-net-applications/microservice-application-design)

## Related resources

- [Microservices architecture style](../../guide/architecture-styles/index.md)
- [Build microservices on Azure](../architecture-styles/microservices.md)
- [Microservices architecture on Azure Kubernetes Service](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Use domain analysis to model microservices](../../microservices/model/domain-analysis.md)
- [Use tactical DDD to design microservices](../../microservices/model/tactical-ddd.yml)
- [Design a microservices architecture](../../microservices/design/index.md)
