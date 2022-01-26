---
title: Microservices assessment and readiness 
description: You this guide as a checklist of considerations to keep in mind when you move to a microservices architecture. 
author: ovaismehboob 
ms.author: ovmehboo
ms.date: 01/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-devops
  - azure-api-management
categories:
  - devops
ms.custom: fcp
---

# Microservices assessment and readiness 

A microservices architecture can provide many benefits for your applications, including agility, scalability, and high availability. Along with these benefits, this architecture presents challenges. When you build microservices-based applications or transform existing applications into a microservices architecture, you need to analyze, assess, and prepare for the change to identify areas that need improvement.

This guide will help you understand some considerations to keep in mind when you move to a microservices architecture. You can use this guide assess the maturity of your application, infrastructure, DevOps, development model, and more.  

These are some important considerations to take into account when you evaluate your application and organization for microservices readiness:
- Understand business priorities
- Record architectural decisions
- Assess team composition
- Use the Twelve-Factor methodology
- Understand the decomposition approach
- Assess DevOps readiness
- Identify business areas that change frequently
- Assess infrastructure readiness 
- Assess release cycles
- Assess communication across services 
- Evaluate how services are exposed to clients
- Assess transaction handling
- Assess your service development model
- Assess your deployment approach
- Assess your hosting platform 
- Assess services monitoring
- Assess correlation token assignment 
- Evaluate the need for a microservices chassis framework 
- Assess your approach to application testing 
- Assess microservices security

## Understand business priorities
To start evaluating a microservices architecture, you need to first understand the core priorities of your business. Core priorities might be related to agility, change adoption, rapid development, or other factors. You need to analyze whether your architecture is a good fit for your core priorities. Keep in mind that business priorities can change over time. For example, innovation is a top priority for startups, but after a few years the core priorities might be reliability and efficiency. 

Here are some priorities to consider:  
- Innovation
- Reliability
- Efficiency 

Document the SLAs that are aligned with various parts of your application to ensure an organizational commitment that can serve as a guide to your assessment. 

## Record architectural decisions
A microservices architecture helps teams become autonomous. Teams can make their own decisions about technologies, methodologies, infrastructure components, and other areas. However, these choices should respect the formally agreed-upon principles known as shared governance, which expresses the agreement among teams on how to address the broader strategy for microservices.

Consider these factors: 
- Is shared governance in place?
- Do you track decisions and their trade-offs in an architecture journal?
- Can your team easily access your architecture journal?
- Do you have a practice for evaluating tools, technologies, and frameworks? 

## Assess team composition
You need to have the proper team structure to avoid unnecessary communication across teams. A microservices architecture encourages the formation of small, focused, cross-functional teams and requires a mindset change, which must be preceded by team restructuring.

Consider these factors:
- Are your teams split based on subdomains, following [domain-driven design (DDD) principles](/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice)? 
- Are your teams cross-functional, with enough capacity to build and operate related microservices independently?
- How much time is spent in ad hoc activities and tasks that aren't related to projects?
- How much time is spent in cross-team collaboration?
- Do you have a practice for identifying and minimizing technical debt?
- How are lessons learned and experience communicated across teams?

## Use the Twelve-Factor methodology 
The fundamental goal of choosing a microservices architecture is to deliver faster value and be adaptive to change by following agile practices. The [Twelve-Factor app methodology](/dotnet/architecture/cloud-native/definition#the-twelve-factor-application) provides guidelines for building maintainable and scalable applications. These guidelines promote attributes like immutability, ephemerality, declarative configuration, and automation. By incorporating these guidelines and avoiding common pitfalls, you can create loosely coupled, self-contained microservices. 

## Understand the decomposition approach
Transforming a monolithic application to a microservices architecture takes time. Start with edge services. Edge services are services that have less dependencies on other services and can be easily decomposed from the system as independent services. We highly recommend patterns like [Strangler Fig](/azure/architecture/patterns/strangler-fig) and [Anti-corruption Layer](/azure/architecture/patterns/anti-corruption-layer) to keep the monolithic application in a working state until all services are decomposed into separate microservices. During segregation, the principles of DDD can help teams choose components or services from the monolithic application based on subdomains. 

For example, in an e-commerce system, you might have these modules: cart, product management, order management, pricing, invoice generation, and notification. You can start the transformation of the application with the notification module because it doesn't have dependencies on other modules. However, other modules might depend on this module to send out notifications. The notification module can easily be decomposed into a separate microservice, but you'll need to make some changes in the monolithic application to call the new notification service. The second pick is the invoice generation module, which is called after an order is generated. You can use patterns like Strangler and Anti-corruption to support this transformation. 

Data synchronization, multi-writes to both monolithic and microservice interfaces, data ownership, schema decomposition, joins, volume of data, and data integrity might make data breakdown and migration difficult. There are several techniques that you can use, like keeping a shared database between microservices, decoupling databases from a group of services based on business capability or domain, or isolating databases from the services. The recommended solution is to decompose each database with each service. In many circumstances, that's not practical. In those cases, you can use patterns like the Database View pattern and the Database Wrapping Service pattern.

## Assess DevOps readiness
When you move to a microservices architecture, it's important to assess your DevOps competence. A microservices architecture is intended to facilitate agile development and embrace change in applications to increase organizational agility. DevOps is one of the key practices that you should implement to achieve this competence. 

When you evaluate your DevOps capability for a microservices architecture, keep these points in mind:
- Do people in your organization know the fundamental practices and principles of DevOps? 
- Are source control tools and their integration with CI/CD pipelines properly understood by teams?
- Are DevOps practices implemented properly?
   - Are agile practices followed?
   - Is continuous integration implemented?
   - Is continuous delivery implemented?
   - Is continuous deployment implemented?
   - Is continuous monitoring implemented?
   - Is [Infrastructure as Code (IaC)](/devops/deliver/what-is-infrastructure-as-code) in place?  
- Are the right tools used to support CI/CD? 
- How is configuration of staging and production environments managed for the application?
- Does the tool chain have community support and a support model and provide proper channels and documentation?

## Identify business areas that change frequently
A microservices architecture is flexible and adaptable. During assessment, drive a discussion in the organization to determine the areas that they think will change more frequently. Building microservices allows teams to respond to changes requested by customers quickly and minimize regression testing efforts. In a monolithic application, a change in one module requires numerous levels of regression testing and reduces agility in releasing new versions. 

Consider these factors:
- Is the service independently deployable?
- Does the service follow DDD principles?
- Does the service follow [SOLID](https://azure.microsoft.com/resources/cloud-solid-cloud-architecture-and-the-single-responsibility-principle) principles?
- Is the database private to the service?
- Is the service built using the supported Microservices Chassis pattern?

## Assess infrastructure readiness 
When you shift to a microservices architecture, infrastructure readiness is a critical point to consider. The application's performance, availability, and scalability will be affected if the infrastructure isn't properly set up or if the right services or components aren't used. Sometimes an application is created with all the suggested methodologies and procedures, but the infrastructure is inadequate. This results in poor performance and maintenance. 

Consider these factors when you evaluate your infrastructure readiness: 
- Does the infrastructure ensure the scalability of the services deployed?
- Does the infrastructure support provisioning through scripts that can be automated via CI/CD?
- Does the deployment infrastructure offer an SLA for availability? 
- Are a disaster recovery (DR) plan and routine drill schedules in place?
- Is the data replicated to different regions for DR?
- Is a proper data backup plan in place?
- Are the deployment options documented?
- Is the deployment infrastructure monitored?
- Does the deployment infrastructure support self-healing of services?

## Assess release cycles
Microservices are adaptive to change and embrace agile development to shorten release cycles and bring value to customers more quickly. Consider these factors when you evaluate your release cycles: 
- How often you build and release applications?
- How often do your releases fail after deployment?
- How long does it take to recover or remediate problems after an outage? 
- Do you use semantic versioning for your applications? 
- Do you maintain different environments and propagate the same release in a sequence (like first to staging and then to production)?
- Do you use versioning for your APIs?
- Do you follow proper versioning guidelines for APIs?
- When do you to change an API version?
- What's your approach for handling API versioning?
   - URI path versioning
   - Query parameter versioning
   - Content-type versioning
   - Custom header versioning
- Do you have a practice in place for event versioning?

## Assess communication across services 
Microservices are self-contained services that communicate with each other across process boundaries to address business scenarios. To get reliable and dependable communication, you need to select an appropriate communication protocol. 

Take these factors into consideration:
- Are you following an API-first approach, where APIs are treated as first-class citizens?
- Do you have long-chain operations, where multiple services communicate in sequence over a synchronous communication protocol?
- Have you considered asynchronous communication anywhere in the system?
- Have you assessed the message broker technology and its capabilities?
- Do you understand the throughput of messages received and processed by services?
- Do you use direct client-to-service communication?
- Do you need to persist messages at the message broker level?
- Are you using the [Materialized View pattern](/azure/architecture/patterns/materialized-view) to address the chatty behavior of microservices? 
- Have you implemented Retry, Circuit Breaker, Exponential Backoff, and Jitter for reliable communication? A common way to handle this is to use the [Ambassador pattern](/azure/architecture/patterns/ambassador).
- Do you have defined domain events to facilitate communication between microservices? 

## Evaluate how services are exposed to clients
An API gateway is one of the core components in a microservices architecture. Directly exposing services to the clients creates plenty of problems in terms of manageability, control, and dependable communication. An API gateway serves as a proxy server, intercepting traffic and routing it to back-end services. If you need to filter traffic by IP address, authorization, mock responses, and so on, you can do it at the API gateway level without making any changes to the services.

Evaluate the following considerations:
- Are the services directly consumed by clients?
- Is there an API gateway that acts as a facade for all the services?
- Can the API gateway set up policies like quota limits, mocking responses, and filtering IP of addresses?
- Are you using multiple API gateways to address the needs of different types of clients, like mobile apps, web apps, and partners?
- Does your API gateway provide a portal where clients can discover and subscribe to services, like a developer portal in [Azure API Management](https://azure.microsoft.com/services/api-management)?
- Does your solution provide L7 load balancing or Web Application Firewall (WAF) capabilities along with the API gateway?
 
## Assess transaction handling
Distributed transaction facilitates the execution of multiple operations as a single unit of work. In a microservices architecture, the system is decomposed into numerous services. A single business use case is addressed by multiple microservices as part of a single distributed transaction. In a distributed transaction, a command is an operation that initiates when an event occurs. The event alerts the system to perform some operation. If the operation succeeds, it might trigger another command, which can then trigger another event, and so on until all the transactions are completed or rolled back, depending on whether the transaction was successful or failed. 

Take the following considerations into account:
- How many distributed transactions exist in the system? 
- What's your approach to handling distributed transactions? Evaluate the use of [Saga pattern](/azure/architecture/reference-architectures/saga/saga) with orchestration or choreography.
- How many transactions span multiple services?
- Are you following ACID or BASE transaction models to achieve data consistency and integrity?
- Are you using long-chaining operations for transactions that span multiple services?

## Assess your service development model
One of the greatest benefits of microservices architectures is technology diversity. Microservices-based systems enable teams to develop services by using the technologies they choose. In traditional application development, you might reuse existing code when you build new components or create an internal development framework to reduce development effort. The use of multiple technologies can prevent code reuse. 

Consider these factors:  
- Do you use a service template to kickstart new service development?
- Do you follow the Twelve-Factor app methodology and use a single code base for microservices, isolating dependencies and externalizing configuration?
- Do you keep sensitive configuration secured in key vaults?
- Do you containerize your services?
- Do you know your data consistency requirements?

## Assess your deployment approach
Your deployment approach is your method for releasing versions of your application across various deployment environments. Microservices-based systems provide the agility to release versions faster than you can with traditional applications. 

When you assess your deployment plan, consider these factors:
- Do you have a strategy for deploying your services?
- Are you using modern tools and technologies to deploy your services?
- What kind of collaboration is required among teams when you deploy services?
- Do you provision infrastructure by using Infrastructure as Code (IaC)?
- Do you use DevOps capabilities to automate deployments?
- Do you propagate the same builds to multiple environments, as suggested by the Twelve-Factor app methodology? 

## Assess your hosting platform
Scalability is one of the key advantages of microservices architectures. That's because microservices are mapped to business domains, so each service can be scaled independently. A monolithic application is deployed as a single unit on a hosting platform and needs to be scaled holistically. That results in downtime, deployment risk, and maintenance. Your monolithic application might be well designed, with components addressing individual business domains. But because of a lack of process boundaries, the potential for violating the principles of single responsibility becomes more difficult. This eventually results in a spaghetti code. Because the application is composed and deployed as a single hosting process, scalability is difficult. 

Microservices enables teams to choose the right hosting platform to support their scalability needs. There are various hosting platforms available to address these challenges by providing capabilities like autoscaling, elastic provisioning, higher availability, faster deployment, and easy monitoring. 

Consider these factors: 
- What hosting platform do you use to deploy your services (virtual machines, containers, serverless)? 
- Is the hosting platform scalable? Does it support autoscaling?
- How long does it take to scale your hosting platform?
- Do you understand the SLAs provided by various hosting platforms?
- Does your hosting platform support disaster recovery?

## Assess services monitoring
Monitoring is an important element of a microservices-based application. Because the application is divided into a number of services that run independently, troubleshooting errors can be daunting. If you use proper semantics to monitor your services, your teams can to easily monitor, investigate, and respond to errors. 

Consider these factors:
- Do you monitor your deployed services?
- Do you have a logging mechanism in place? What tools do you use?
- Do you have a distributed tracing infrastructure in place?
- Do you record exceptions?
- Do you maintain business error codes for quick identification of problems?
- Do you use health probes for services?
- Do you use semantic logging? Have you implemented key metrics, thresholds, and indicators? 
- Do you mask sensitive data during logging?

## Assess correlation token assignment
In a microservices architecture, an application is composed of various microservices hosted independently, interacting with each other to serve various business use cases. When an application interacts with back-end services to perform an operation, you can assign a unique number, known as a correlation token, to that request. We recommend that you consider using correlation tokens, because they can help you troubleshoot errors. They help you determine the root cause of a problem, assess the impact, and determine an approach to remediate the problem. 

By using correlation tokens, you can retrieve the request trail by identifying which services contain the correlation token and which don't. The ones that don't have the correlation token for that request failed. In case of failure, you can later retry the same transaction. To enforce idempotency, only services that don't have the correlation token will serve the request. 

For example, if there's a long chain of operations that involves many services, passing the correlation token to services can help you investigate the issue easily if any of the services fails during the transaction. Each service usually has its own database. The correlation token is kept in the database record. In case of a transaction replay, services that have that particular correlation token in their databases ignore the request. Only services that don't have the token serve the request. 

Consider these factors:
- At which stage do you assign the correlation token?
- Which component assigns the correlation token?
- Do you save correlation tokens in service's database?
- What's the format of the correlation token?
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
Traditionally, testing is done after development is completed and the application is ready to roll out to UAT (user acceptance testing) and production environments. There's a shift in this approach, moving the testing early (left) in the application development lifecycle. Shift-left testing increases the quality of applications because testing is done during each phase of the application development lifecycle, including the design, development, and post-development phases. 

For example, when you build an application, you start by designing an architecture. The shift-left approach helps you test the design for vulnerabilities by using tools like [Microsoft Threat Modeling](/azure/security/develop/threat-modeling-tool). When you start development, you can scan your source code by running tools like SAST (static application security testing) and using other analyzers to uncover problems. After the application is deployed, you can use tools like dynamic application security testing (DAST) to test it while it's hosted. Functional testing, chaos testing, penetration testing, and other kinds of testing happen later. 

Consider these factors: 
- Do you write test plans that cover the entire development lifecycle?
- Do you include testers in requirements meetings and in the entire application development lifecycle?
- Do you use test-driven design or behavior-driven design?
- Do you test user stories? Do you include acceptance criteria in your user stories?
- Do you test your design by using tools like Microsoft Threat Modeling?
- Do you write unit tests? 
- Do you use static code analyzers or other tools to measure code quality?
- Do you have automated tools in place to test applications?  
- Do you implement [Secure DevOps](https://www.microsoft.com/securityengineering/devsecops) practices? 
- Do you do integration testing, end-to-end application testing, load/performance testing, penetration testing, and chaos testing?

## Assess microservices security 
Service protection, secure access, and secure communication are among of the most important considerations for a microservices architecture. For example, a microservices-based system that spans multiple services and uses token validation for each service isn't a viable solution. This system would affect the agility of the overall system and the potential of introducing implementation drift across services. 

Security concerns are usually handled by the API gateway and the application firewall. The gateway and firewall take incoming requests, validate tokens, apply various filters and policies, like implementing OWASP Top 10 principles to intercept traffic. Finally, they send the request to the back-end microservices. This configuration helps developers focus on business needs rather than cross-cutting concerns like security. 

Consider these factors: 
- Are authentication and authorization required for the service?
- Are you using an API gateway to validate tokens and incoming requests?
- Is SSL or mTLS used to provide security for the service's communication?
- Do you have network security policies in place to allow the required communication among services?
- Are you using firewalls (L4, L7) where applicable to provide security for internal and external communications?
- Do you use security policies in API Gateway to control traffic?

## Next steps
- [Microservices on Azure](https://azure.microsoft.com/solutions/microservice-applications)
- [Embrace Microservices Design – by Packt](https://www.amazon.com/Embracing-Microservices-Design-anti-patterns-architectural/dp/180181838X) 
- [Introduction to deployment patterns](/learn/modules/introduction-to-deployment-patterns)
- [Design a microservice-oriented application](/dotnet/architecture/microservices/multi-container-microservice-net-applications/microservice-application-design)

## Related resources
- [Microservices architecture style](/azure/architecture/guide/architecture-styles)
- [Build microservices on Azure](/azure/architecture/microservices)
- [Microservices architecture on Azure Kubernetes Service](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)
- [Microservices architecture on Azure Service Fabric](/azure/architecture/reference-architectures/microservices/service-fabric)