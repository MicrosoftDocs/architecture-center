---
title: Microservices Assessment and Readiness 
description: Learn about the considerations to keep in mind when you move to a microservices architecture. Use this guide to assess your application's readiness.
author: ovaismehboob 
ms.author: ovmehboo
ms.date: 06/16/2025
ms.topic: conceptual
ms.reviewer: nasiddi
ms.subservice: architecture-guide
ms.custom: fcp
---

# Microservices assessment and readiness 

A microservices architecture can provide many benefits for your applications, including agility, scalability, and high availability. This architecture can also present challenges. When you build microservices-based applications or transform existing applications into a microservices architecture, you need to analyze and assess your current situation to identify areas that need improvement.

This article describes some considerations to keep in mind when you move to a microservices architecture. You can use this guide to assess the maturity of your application, infrastructure, DevOps, and development model.

## Understand business priorities

To evaluate a microservices architecture, you need to first understand the core priorities of your business. Core priorities might be related to agility, change adoption, or rapid development, for example. You need to analyze whether your architecture is a good fit for your core priorities. Keep in mind that business priorities can change over time. For example, innovation is a top priority for startups, but after a few years, the core priorities might be reliability and efficiency.

Consider the following priorities:

- Innovation, including fostering agility and experimentation
- Reliability, including ensuring high availability and fault tolerance
- Efficiency, including optimizing resources and productivity

Document the service-level objectives (SLOs) that align with various parts of your application to ensure an organizational commitment that can guide your assessment. 

## Record architectural decisions

A microservices architecture helps teams become autonomous. Teams can make their own decisions about technologies, methodologies, and infrastructure components. However, these choices should respect the formally agreed-upon principles known as shared governance. These principles express the agreement among teams about how to address the broader strategy for microservices.

Consider the following factors:

- Whether shared governance is in place to guide architecture decisions across teams

- Whether you maintain architecture decision records (ADRs) with clear rationale, trade-offs, and status

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

- How much time is spent in unplanned activities and tasks that aren't related to projects

- How much time is spent in cross-team collaboration

- Whether you have a process for identifying and minimizing technical debt

- How teams learn lessons and how they communicate this experience

## Use the Twelve-Factor methodology

The fundamental goal of choosing a microservices architecture is to deliver value faster and adapt to change by following agile practices. The [Twelve-Factor app methodology](/dotnet/architecture/cloud-native/definition#the-twelve-factor-application) provides guidelines for building maintainable and scalable applications. These guidelines promote attributes like immutability, ephemerality, declarative configuration, and automation. By incorporating these guidelines and avoiding common pitfalls, you can create loosely coupled, self-contained microservices. 

## Understand the decomposition approach

Transforming a monolithic application to a microservices architecture takes time. Start with edge services. Edge services have fewer dependencies on other services and can be easily separated from the system as independent services. We highly recommend patterns like [Strangler Fig](../../patterns/strangler-fig.md) and [Anti-corruption Layer](../../patterns/anti-corruption-layer.yml) to keep the monolithic applications in a working state until all services are decomposed into separate microservices. During segregation, the principles of DDD can help teams choose components or services from the monolithic application based on subdomains. 

For example, an e-commerce system might have modules like cart, product management, order management, pricing, invoice generation, and notification. You decide to start the transformation of the application with the notification module because it doesn't have dependencies on other modules. However, other modules might depend on this module to send out notifications. You can make the notification module a separate microservice, but you also need to update the monolithic application to call the new notification service. You decide to transform the invoice generation module next. This module is called after an order is generated. You can use patterns like Strangler Fig and Anti-corruption Layers to support this transformation.

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

- Whether the service follows SOLID principles

- Whether the database is private to the service

- Whether you build the service by using the supported microservices chassis framework

## Assess infrastructure readiness

When you shift to a microservices architecture, infrastructure readiness is a critical point to consider. Improper setup of the infrastructure or not using the appropriate services or components affect the application's performance, availability, and scalability. You might use all of the suggested methodologies and procedures to create an application, but if the infrastructure is inadequate, the application might perform poorly and require extra maintenance. 

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

- How often you build and release applications

- How often your releases fail after deployment

- How long it takes to recover or remediate problems after an outage

- Whether you use semantic versioning for your applications

- Whether you maintain different environments and propagate the same release in a sequence, for example, first to staging and then to production

- Whether you use versioning for your APIs

- Whether you follow proper [versioning guidelines](/azure/architecture/best-practices/api-design#implement-versioning) for APIs

- When you change an API version

- What your approach to handling API versioning is, including:

   - URI path versioning.
   - Query parameter versioning.
   - Content-type versioning.
   - Custom header versioning.

- Whether you have a practice in place for event versioning

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

- Whether you plan to implement Retry, Circuit Breaker, Exponential Backoff, and Jitter for reliable communication. A common way to handle these features is to use the [Ambassador pattern](../../patterns/ambassador.yml).

- Whether you have defined domain events to facilitate communication between microservices.

## Evaluate how services are exposed to clients

An API gateway is one of the core components in a microservices architecture. Directly exposing services to the clients creates problems with manageability, control, and dependable communication. An API gateway serves as a proxy server that intercepts traffic and routes it to back-end services. If you need to filter traffic by IP address, authorization, or mock responses, you can filter it at the API gateway level without making any changes to the services.

Consider the following factors:

- Whether clients directly consume the services

- Whether an API gateway acts as a facade for all of the services

- Whether you implement the [Backends for Frontends (BFF) pattern](/azure/architecture/patterns/backends-for-frontends) for different client types

- Whether the API gateway can set up policies like quota limits, mock responses, and IP address filtering

- Whether you use multiple API gateways to address the needs of various types of clients, like mobile apps, web apps, and partners

- Whether your API gateway provides a portal where clients can discover and subscribe to services, like a developer portal in [Azure API Management](https://azure.microsoft.com/services/api-management)

- Whether your solution provides L7 load balancing or web application firewall (WAF) capabilities along with the API gateway
 
## Assess transaction handling

Distributed transactions facilitate the execution of multiple operations as a single unit of work. In a microservices architecture, the system is decomposed into numerous services. A single business use case is addressed by multiple microservices as part of a single distributed transaction. In a distributed transaction, a command is an operation that starts when an event occurs. The event triggers an operation in the system. If the operation succeeds, it might trigger another command, which can then trigger another event, and so on until all the transactions are completed or rolled back, depending on whether the transaction succeeds. 

Take the following considerations into account:
- How many distributed transactions are there in the system? 
- What's your approach to handling distributed transactions? Evaluate the use of the [Saga pattern](/azure/architecture/reference-architectures/saga/saga) with orchestration or choreography.
- Have you considered [event sourcing](/azure/architecture/patterns/event-sourcing) for maintaining transaction history and state?
- Do you implement [Command Query Responsibility Segregation (CQRS) patterns](/azure/architecture/patterns/cqrs)?
- How many transactions span multiple services?
- Are you following an ACID or BASE transaction model to achieve data consistency and integrity?
- Are you using long-chaining operations for transactions that span multiple services?
- Do you have compensation patterns in place beyond Saga for transaction rollback?

## Assess your service development model

One of the greatest benefits of microservices architectures is technology diversity. Microservices-based systems enable teams to develop services by using the technologies that they choose. In traditional application development, you might reuse existing code when you build new components, or create an internal development framework to reduce development effort. The use of multiple technologies can prevent code reuse. 

Consider these factors:  
- Do you use a standardized service template to accelerate new service development and ensure consistency in architecture, deployment, and DevOps practices?
- Do you follow the Twelve-Factor app methodology and use a single code base for microservices, isolating dependencies and externalizing configuration?
- Do you keep sensitive configuration in key vaults?
- Do you containerize your services?
- Do you know your data consistency requirements?

## Assess your deployment approach

Your deployment approach is your method for releasing versions of your application across various deployment environments. Microservices-based systems provide the agility to release versions faster than you can with traditional applications. 

When you assess your deployment plan, consider these factors:
- Do you have a strategy for deploying your services?
- Are you using modern tools and technologies to deploy your services?
- What kind of collaboration is required among teams when you deploy services?
- Do you provision infrastructure by using Infrastructure as Code (IaC)?
- Do you follow immutable infrastructure principles?
- Do you use DevOps capabilities to automate deployments?
- Do you propagate the same builds to multiple environments, as suggested by the Twelve-Factor app methodology? 

## Assess your hosting platform

Scalability is one of the key advantages of microservices architectures. That's because microservices are mapped to business domains, so each service can be scaled independently. A monolithic application is deployed as a single unit on a hosting platform and needs to be scaled holistically. That results in downtime, deployment risk, and maintenance. Your monolithic application might be well designed, with components addressing individual business domains. But because of a lack of process boundaries, the potential for violating the principles of single responsibility becomes more difficult. This eventually results in spaghetti code. Because the application is composed and deployed as a single hosting process, scalability is difficult. 

Microservices enable teams to choose the right hosting platform to support their scalability needs. Various hosting platforms are available to address these challenges by providing capabilities like autoscaling, elastic provisioning, higher availability, faster deployment, and easy monitoring.

Consider these factors:

- What hosting platform do you use to deploy your services (virtual machines, containers, serverless)?
- Is the hosting platform scalable? Does it support autoscaling?
- How long does it take to scale your hosting platform?
- Do you understand the SLAs that various hosting platforms provide?
- Does your hosting platform support disaster recovery?

## Assess services monitoring

Monitoring is an important element of a microservices-based application. Because the application is divided into a number of services that run independently, troubleshooting errors can be daunting. If you use proper semantics to monitor your services, your teams can easily monitor, investigate, and respond to errors. 

Consider these factors:
- Do you monitor your deployed services?
- Do you have Service Level Objectives (SLOs) defined?
- Do you have a logging mechanism? What tools do you use?
- Do you have a distributed tracing infrastructure in place?
- Do you record exceptions?
- Do you maintain business error codes for quick identification of problems?
- Do you use health probes for services?
- Do you use semantic logging? Have you implemented key metrics, thresholds, and indicators?
- Do you mask sensitive data during logging?
- Do you monitor service dependencies and external integrations?

## Assess correlation token assignment

In a microservices architecture, an application is composed of various microservices that are hosted independently, interacting with each other to serve various business use cases. When an application interacts with backend services to perform an operation, you can assign a unique number, known as a correlation token, to the request. We recommend that you consider using correlation tokens, because they can help you troubleshoot errors. They help you determine the root cause of a problem, assess the impact, and determine an approach to remediate the problem.

You can use correlation tokens to retrieve the request trail by identifying which services contain the correlation token and which don't. The services that don't have the correlation token for that request failed. If a failure occurs, you can later retry the transaction. To enforce idempotency, only services that don't have the correlation token will serve the request.

For example, if you have a long chain of operations that involves many services, passing a correlation token to services can help you investigate issues easily if any of the services fails during a transaction. Each service usually has its own database. The correlation token is kept in the database record. In case of a transaction replay, services that have that particular correlation token in their databases ignore the request. Only services that don't have the token serve the request. 

Consider these factors:
- At which stage do you assign the correlation token?
- Which component assigns the correlation token?
- Do you save correlation tokens in the service's database?
- What's the format of correlation tokens?
- Do you log correlation tokens and other request information?

## Evaluate the need for a microservices chassis framework

A microservices chassis framework is a base framework that provides capabilities for cross-cutting concerns like logging, exception handling, distributed tracing, security, and communication. When you use a chassis framework, you focus more on implementing the service boundary than interacting with infrastructure functionality. 

For example, say you're building a cart management service. You want to validate the incoming token, write logs to the logging database, and communicate with another service by invoking that service's endpoint. If you use a microservices chassis framework, you can reduce development efforts.  Dapr is one system that provides various building blocks for implementing cross-cutting concerns. 

Consider these factors: 
- Do you use a microservices chassis framework?
- Do you use Dapr to interact with cross-cutting concerns?
- Is your chassis framework language agnostic?
- Is your chassis framework generic, so it supports all kinds of applications? A chassis framework shouldn't contain application-specific logic. 
- Does your chassis framework provide a mechanism to use the selected components or services as needed?

## Assess your approach to application testing

Traditionally, testing is done after development is completed and the application is ready to roll out to user acceptance testing (UAT) and production environments. There's currently a shift in this approach, moving the testing early (left) in the application development lifecycle. Shift-left testing increases the quality of applications because testing is done during each phase of the application development lifecycle, including the design, development, and post-development phases. 

For example, when you build an application, you start by designing an architecture. When you use the shift-left approach, you test the design for vulnerabilities by using tools like [Microsoft Threat Modeling](/azure/security/develop/threat-modeling-tool). When you start development, you can scan your source code by running tools like static application security testing (SAST) and using other analyzers to uncover problems. After you deploy the application, you can use tools like dynamic application security testing (DAST) to test it while it's hosted. Functional testing, chaos testing, penetration testing, and other kinds of testing happen later. 

Consider these factors: 
- Do you write test plans that cover the entire development lifecycle?
- Do you include testers in requirements meetings and in the entire application development lifecycle?
- Do you use test-driven design or behavior-driven design?
- Do you test user stories? Do you include acceptance criteria in your user stories?
- Do you test your design by using tools like Microsoft Threat Modeling?
- Do you write unit tests? 
- Do you use static code analyzers or other tools to measure code quality?
- Do you use automated tools to test applications?  
- Do you implement [Secure DevOps](https://www.microsoft.com/securityengineering/devsecops) practices? 
- Do you do integration testing, end-to-end application testing, load/performance testing, penetration testing, and chaos testing?

## Assess microservices security

Service protection, secure access, and secure communication are among the most important considerations for a microservices architecture. For example, a microservices-based system that spans multiple services and uses token validation for each service isn't a viable solution. This system would affect the agility of the overall system and the potential of introducing implementation drift across services. 

Security concerns are usually handled by the API gateway and the application firewall. The gateway and firewall take incoming requests, validate tokens, and apply various filters and policies, like implementing OWASP Top 10 principles to intercept traffic. Finally, they send the request to the backend microservices. This configuration helps developers focus on business needs rather than the cross-cutting concern of security.

Consider these factors:

- Are authentication and authorization required for the service?
Have you considered [zero-trust architecture principles](/azure/security/fundamentals/zero-trust)?
- Do you have a comprehensive secrets management strategy that includes key rotation, lifecycle management, and auditing—beyond simply storing secrets in a key vault?
- Are you using an API gateway to validate tokens and incoming requests?
- Are you using SSL or mTLS to provide security for service communication?
- Do you implement container and image security scanning?
- Do you have network security policies in place to allow the required communication among services?
- Are you using firewalls (L4, L7) where applicable to provide security for internal and external communications?
- Do you use security policies in API Gateway to control traffic?
- Do you have runtime security monitoring for detecting anomalous behavior?

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

- [Ovais Mehboob Ahmed Khan](https://www.linkedin.com/in/ovaismehboob/) | Senior Cloud Solution Architect - Cloud and AI Apps
- [Nabil Siddiqui](https://www.linkedin.com/in/nabilshams/) | Solution Engineer - Cloud and AI Apps

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
- [Microservices on Azure](https://azure.microsoft.com/solutions/microservice-applications)
- [Book: Embrace Microservices Design](https://www.amazon.com/Embracing-Microservices-Design-anti-patterns-architectural/dp/180181838X) 
- [Introduction to deployment patterns](/training/modules/introduction-to-deployment-patterns)
- [Design a microservices-oriented application](/dotnet/architecture/microservices/multi-container-microservice-net-applications/microservice-application-design)

## Related resources
- [Microservices architecture style](../../guide/architecture-styles/index.md)
- [Build microservices on Azure](../architecture-styles/microservices.md)
- [Microservices architecture on Azure Kubernetes Service](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Using domain analysis to model microservices](../../microservices/model/domain-analysis.md)
- [Using tactical DDD to design microservices](../../microservices/model/tactical-ddd.yml)
- [Design a microservices architecture](../../microservices/design/index.yml)
