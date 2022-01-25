# Microservices assessment and readiness 

A microservices architecture can provide many benefits for your applications, including agility, scalability, and high availability. Along with these benefits, it comes with its own challenges. that need proper understanding and experience to address them. When building microservices based applications or re-platforming existing applications into microservices architecture, adequate analysis, assessment and preparedness is essential for identifying key areas that need improvement.

This guide will help reader to understand some common factors that must be considered when building new applications or transforming existing applications into microservices architecture. You can use these factors to assess the maturity state of application, infrastructure, DevOps, development model, and others.  

Following are the factors that are important to consider while evaluating microservices application and organization readiness:
- Understand Business Priorities
- Record Architectural Decisions
- Team Composition
- Methodology selection
- Decomposition approach
- DevOps readiness
- Identify business areas that change frequently
- Infrastructure readiness 
- Assess Release Cycles
- Communication across services 
- Evaluate how services are exposed to clients
- Assess transactions handling
- Assess service development model
- Assess deployment approach
- Hosting platform capabilities
- Assess services monitoring
- Assess correlation token assignment 
- Evaluate the need of Microservices Chassis Framework 
- Assess Application Testing approach
- Assess Microservices Security

## Understanding Business Priorities
To start your discussion with customer for evaluating microservices architecture, you need to first understand the core priorities of the business. Core priorities may be related to agility, change adoption, rapid development and many other factors. Based on the core priorities you need to analyze whether your architecture is a right fit to support these priorities. Business priorities can change time to time, for example today innovation is one of the top priorities for startup but after few years their core priority may change and as a business, they put more emphasis on reliability and efficiency. 

Following are the topic you should discuss while understanding the core priorities of the business. 
- Innovation
- Reliability
- Efficiency 

You should document the expected SLAs aligned with different parts of the application to ensure the organization commitment that can serve as a guide to your assessment. 

## Record Architectural Decisions
Microservices architecture helps teams to become autonomous. That means teams can take decision on their own when it comes to technology, methodology, infrastructure components, and many other areas. Though the teams are empowered to make their own choices, but these choices should abide to the formally agreed-upon principles known as shared governance, and it expresses the teams' agreement on how to address the broader architecture strategy for microservices.

The following aspects are important when evaluating this factor: 
- Is shared governance in place?
- Do you track decisions with their trade-offs in architecture journal?
- Is your architecture journal easily accessible by your team?
- Is there any practice in place for evaluating tools, technologies, and frameworks? 

## Team Composition
It is critical for microservices to have the proper team structure in place to avoid unnecessary communication across teams. Microservices architecture encourages the formation of small, focused, and cross-functional teams and requires a mindset change, which must be preceded by team restructuring.

Following aspects are important when evaluating this factor:
- Are the teams split based on sub domains, following Domain Driven Design principles? 
- Are the teams cross-functional and have enough capacity to build and operate related microservice(s) independently?
- What time is spent in adhoc activities and how frequently your team spend time doing non-project related tasks?
- What time is spent in cross-team collaboration?
- Do you have a practice of identifying and minimizing technical debt?
- How the experience and lessons learned are communicated across teams?

## Methodology selection
The fundamental idea behind choosing microservices architecture is to deliver faster value and being adaptive to change by following agile practices. The Twelve-Factor app methodology provides guidelines for building maintainable and scalable applications by incorporating features that includes but not limited to immutability, ephemerality, declarative configuration, and automation. By incorporating these attributes and avoiding common pitfalls, loosely coupled and self-contained microservices can be created. 

## Decomposition approach
Transforming a monolithic application to a microservices architecture is a journey. To start the transformation journey, pick the least dependent services (known as edge services) that have less dependencies on other services and can easily be decomposed from the system as an independent service, where some approaches and patterns like strangler and anti-corruption layer are highly recommended to keep the monolithic application in a working state until all the services are decomposed into separate microservices. While segregating, knowing the principles of DDD (Domain Driven Design) would help teams to choose the component or services from monolithic application based on sub domains. 

For example, in the ecommerce system, we can have modules as cart module, product management module, order management module, pricing module, invoice generation module, and notification module. The transformation of the application can be started from the notification module since it has no dependency on other modules. However, other modules may be dependent on this module to send out notifications. Notification module can easily be decomposed into a separate microservice, and some changes will be needed in monolithic application to call the new notification service. Second pick will be the invoice generation which is called after the order is generated and decomposed into a separate service. Patterns such as strangler and anti-corruption can be used to support this transformation. 

Data synchronization, multi-writes to both monolithic and microservice interfaces, data ownership, schema decomposition, joins, volume of data, and data integrity may make data breakdown and migration difficult. There are several techniques that can be used, including keeping a shared database between microservices, decoupling databases from a group of services depending on business capability` or domain, or totally isolating databases from the services itself. The most favored solution is to keep the database per service. However, in many circumstances, it is not practical, and in these cases, you can use patterns like the Database View pattern and the Database Wrapping Service pattern.

## DevOps readiness
When analyzing microservices architecture, assessing DevOps competence is crucial. Microservices architecture is intended to facilitate agile development and embrace change in applications to increase organization agility, and DevOps is one of the key practices that should be implemented to achieve this competence. When evaluating DevOps capability for microservices architecture, keep the following points in mind:
- Does the organization know the fundamentals practices and principles of DevOps? 
- Are source control tools and their integration with CI/CD pipelines are properly understood by the teams?
- Are DevOps practices implemented properly?
   - Are agile practices followed?
   - Is continuous integration implemented?
   - Is continuous delivery implemented?
   - Is continuous deployment implemented?
   - Is continuous monitoring implemented?
   - Is Infrastructure as Code practice being in place?  
- Evaluate if the right tools are used that supports implementing CI/CD? 
- Evaluate, how the configuration of staging and production environments are managed for the application?
- Does the selected tool chain have a community support and a support model in place and provides proper channel and documentation?

## Identify business areas that change frequently
Microservices architecture is flexible and adaptable. While assessing, drive the discussion with organization on the areas they think will change more frequently. Building microservices will allow them to respond to the changes asked by customers quickly and minimizes regression testing efforts. Unlike, in monolithic application, change in one module requires numerous levels of regression testing and reduces agility to release new versions. 

Some of the areas you should consider while assessing are as follows:
- Is the service independently deployable?
- Does the service follow Domain Driven Design principles?
- Does the service follow SOLID principles?
- Is the database private to the service?
- Is the service built using the supported Microservices chassis pattern?

## Infrastructure readiness 
When shifting to a microservices architecture, infrastructure readiness is a critical point to consider. The application's performance, availability, and scalability will be impacted if the infrastructure isn't properly setup, or the right services or components aren't used. There are cases where an application is created using all suggested methodologies and procedures, yet the infrastructure is inadequate, resulting in poor performance and maintenance. 

Following factors must be considered when evaluating the infrastructure readiness in microservices architecture: 
- Does the infrastructure ensure the scalability of the services deployed?
- Does the infrastructure support provisioning  through scripts that can be automated using CI/CD?
- Does the deployment infrastructure offer SLA for availability? 
- Is there a Disaster Recovery (DR) plan and routine drill schedules are in place?
- Is the data replicated to different regions for DR environment?
- Is there a proper data backup plan in place?
- Are the deployment options documented?
- Does the deployment infrastructure is monitored?
- Does the deployment infrastructure support self-healing of services?


## Assess Release Cycles
Microservices are adaptive to changes and embraces agile development to shorten the release cycles and bring value to the customers in shorter time. The following aspects are important to evaluate this factor: 
- How often you build and release applications?
- How often your releases failed after deployment?
- How long does it take to recover or remediate issues after outage? 
- Do you follow semantic versioning for your applications? 
- Do you maintain different environment and propagate the same release in sequence such as first to staging and then production?
- Have you implemented versioning for your APIs?
- Do you follow proper versioning guidelines for APIs?
- What makes to change an API version?
- What is your approach for handling API versioning?
   - URI Path Versioning
   - Query Parameter Versioning
   - Content-Type Versioning
   - Custom Header Versioning
- Do you have a practice to perform event versioning?

## Communication across services 
Microservices are self-contained services that communicates with one another across process boundaries to address various business scenarios. Selecting the communication protocol is a critical factor for achieving reliable and dependable communication. 

Following aspects should be considered when assessing this factor:
- Are you following API first approach where APIs are treated as first-class citizens?
- Do you have long chain operations where multiple services are communicating in sequence over synchronous communication protocol?
- Have you considered asynchronous communication anywhere in the system?
- Assess the message broker technology and its capabilities to provide value to the business?
- Understand the throughput of messages received and processed by services?
- Do you have a direct client-to-service communication implemented?
- Do you have a need to persist messages at the message broker level?
- Are you using materialized view pattern to address the chatty behavior of microservices? 
- Have you implemented retry, circuit-breaker, exponential back-off and jittering for reliable communication? A common way to handle this is to use Ambassador pattern.
- Do you have defined domain events to facilitate communication between microservices? 

## Evaluate how services are exposed to clients
API gateway is one of the core components when developing microservices architecture. Directly exposing services to the clients creates plenty of issues in terms of manageability, control, and dependable communication. API Gateway serves as a proxy server, intercepting traffic and routing it to backend services. If you need to filter traffic by IP address, authorization, mock responses, and so on, you can do it at the API gateway level without making any changes to the services.

You should evaluate the following:
- Are the services directly consumed by clients?
- Is there any API gateway that acts as a facade for all the services?
- Is the API gateway capable of setting up policies such as quota limits, mocking responses, filtering IP addresses, and others?
- Are you using multiple API gateways to address the needs of different types of clients such as mobile apps, web apps, partners and others?
- Does API gateway provide a portal where clients can discover and subscribe to services, such as a developer portal in Azure API Management?
- Does your solution provide L7 load balancing or Web Application Firewall (WAF) capabilities along with API gateway?
 
## Assess Transactions handling
Distributed transaction facilitates the execution of multiple operations as a single unit of work. In Microservices architecture, the system is decomposed into numerous services, where a single business use case is addressed by invoking multiple microservices as part of a single distributed transaction. In a distributed transaction, a command is an operation that initiates when an event occurs. The event alerts the system to act and perform some operation. If that operation succeeds, it may trigger another command, which can then trigger another event, and so on until all the transactions are completed or rolled back, depending on whether the transaction was successful or failed. Let's look at some of the things to think about when considering this factor:
- How many distributed transactions exist in the system? 
- What is your approach to handling distributed transactions, evaluate the use of Saga pattern with orchestrator/choreography? 
- How many transactions span over multiple services?
- Are you following ACID or BASE transaction models to achieve consistency and integrity of data?
- Are you using long-chaining operation for transactions spanning to multiple services?

## Assess service development model
One of the greatest benefits of microservices architecture is technology diversity. Microservices based systems enable teams to develop services using the technology of choice to address specific use case. Unlike, in traditional application development where we reuse existing code while building new components or create internal development framework to reduce development effort is far challenging with microservices architecture. When building a service using the same technology, you can reuse the code but if that service is using a different technology, the code cannot be reused. 

Following are some important aspects to consider when evaluating this factor:  
- Do you have a practice of keeping a service template to kick start new service development?
- Do you follow the twelve-factor app methodology for single code base for microservices, isolating dependencies and externalizing configuration?
- Do you keep sensitive configuration secured using key vaults?
- Are you containerizing your services?
- Do you know your data consistency requirements?

## Assess deployment approach
Deployment approach is the method for releasing versions of your application across different deployment environments. Microservices based systems enable agility to release versions faster to the market as compared to traditional applications. When analyzing a deployment plan, the following factors should be considered:
- Do you follow deployment strategy for deploying your services?
- Are you using modern tools and technologies for deploying your services?
- What kind of collaboration is needed with other teams when you deploy your services?
- Do you have a practice of provisioning infrastructure using Infrastructure as Code (IaC)?
- Are you using DevOps capabilities to automate deployments?
- Do you propagate same builds to multiple environments as suggested by the twelve-factor app methodology? 

## Hosting platform capabilities
One of the key advantages of a microservices architecture is scalability. Since microservices are modelled towards business domains, where each service can be scaled independently. However, a monolithic application is deployed as a single unit on a hosting platform and needed to be scaled holistically that results in downtime, deployment risk, and maintenance. Although, at times these monolithic applications are well designed in the form of components addressing individual business domains but due to lack of process boundaries the potential of violating the principles of single responsibility becomes more difficult and eventually results in a spaghetti code and since the application is composed and deployed as a single hosting process, scalability is difficult. 

Microservices enables teams to choose the right hosting platform to support their scalability needs. There are various hosting platforms available today to address these challenges by providing capabilities such as auto-scaling, elastic provisioning, higher availability, faster deployment and easy monitoring. 

When discussing the platform capabilities with your customers, it’s important to consider following factors: 
- What is the hosting platform you have used to deploy your services (Virtual Machines, Containers, Serverless)? 
- Is the hosting platform scalable and support auto-scaling?
- How much time is required to scale the hosting platform?
- Understand the SLAs provided by different hosting platforms?
- Does the hosting platform support disaster recovery?

## Assess services monitoring
Monitoring is an important element of a microservices-based application. Since the application is divided into a number of services that run independently, troubleshooting errors becomes a daunting task. If you use proper semantics for monitoring your services, your teams will be able to easily monitor, investigate, and respond to errors. 

The following factors must be considered when evaluating this area:
- Do you maintain a practice of monitoring your services when it is deployed?
- Is there a proper logging mechanism in place and what tools you are using?
- Is there a distributed tracing infrastructure in place?
- Is there a practice of recording exceptions?
- Is there a practice of maintaining business error codes for quick identification of issues?
- Are health probes implemented for services?
- Are you following semantic logging, and have you implemented key metrics, thresholds, and indicators? 
- Are you masking sensitive data while logging?

## Assess correlation token assignment
In Microservices architecture, the application is composed of various microservices hosted independently, interacting with each other to serve different business use cases. When an application interacts with back-end services to perform an operation, assigning a unique number (also known as correlation token) to that request is an important factor to consider, which later helps in troubleshooting the error in case of failure. This helps in triaging the issue across microservices to determine the root cause, assess the impact and approach to remediate the issue. With correlation token the request trail can be retrieved by identifying which services contains the correlation token and which are failed by not having that correlation token for that request. Eventually, the same transaction can be re-tried in case of failure, and only those services will serve the request that don’t have the same correlation token to enforce idempotency. 

For example, if there is a long chain of operations where many services are involved, passing the correlation token to services help investigate the issue easily if any of the services fails during the transaction. Usually, each service has its own database, they keep the correlation token within the database record. In case of transaction replay, services that contains the same correlation token in their databases will ignore that request and only those services will serve that don’t have that correlation token. 

The following points should be considered when discussing correlation tokens:
- At which stage the correlation token is assigned?
- Which component is responsible for assigning the correlation token?
- Do you save correlation tokens in service’s database?
- What is the format of the correlation token?
- Do you log correlation token and other request information in logging solution?

## Evaluating the need of Microservices Chassis Framework 
The Microservices chassis framework is a base framework that provides capabilities of cross-cutting concerns such as logging, exception handling, distributed tracing, security, communication and others.  By implementing this approach you focus more on implementing the service boundary rather than making efforts for interacting with infrastructure functionalities. For example, you are building a cart management service where you want to validate the incoming token, write logs to the logging database and communicate to other service by invoking that service’s endpoint. The development efforts can be reduced if you have a Microservices chassis framework in place.  Dapr is one of the examples that provides various building blocks to implement cross-cutting concerns. While driving a discussion with your customer, following factors are important to consider evaluating this area: 
- Do you use microservices chassis framework in place?
- Are you using Dapr to interact with cross-cutting concerns?
- Your chassis framework is language agnostic?
- Chassis framework should not contain application specific logic. Is your chassis framework generic to support all kind of applications? 
- Is your chassis framework providing a mechanism to use the selected components or services as needed?

## Assess Application Testing approach
Traditionally, testing is done once the development is completed and the application is ready to roll out to UAT (User Acceptance Testing) and production environments. Today, there is a shift in this approach by shifting the testing left and adopting it early in the application development life cycle. Shift left testing increases the quality of the application by testing each phase that includes design, development and post development phases of application development life cycle. For instance, if you are building an application, you start with designing an architecture and shift left approach helps you to test the design with respect to vulnerabilities by using tools like Microsoft Threat modeling. When you start development, you can scan your source code by running tools like SAST (Static Application Security Testing) tools and using other analyzers to uncover issues. Once the application is deployed, tools like Dynamic Application Security Testing (DAST) can be used to test the applications while it is hosted. Functional testing, chaos testing, penetration testing and other kinds of testing will also come later in the stage in shift-left approach. 

The following aspects are important to consider when assessing this area: 
- Do you write test plan that cover the entire development life cycle?
- Do you include testers in requirements meetings and in the entire application development life cycle?
- Do you embrace test-driven design or behavior-driven design?
- Do you test user stories, and do you add acceptance criteria in your user stories?
- Do you test your design using tools like Microsoft Thread Modeling?
- Do you write unit tests? 
- Do you use static code analyzers or other tools to measure code quality?
- Do you have automated tools in place to test applications?  
- Have you implemented Secure DevOps practices? 
- Do you have a practice of doing integration testing, end-to-end application testing, load/performance testing, penetration testing and chaos testing?

## Assess Microservices Security 
When it comes to building microservices, some of the most important considerations are service protection, secure access and secure communication. For example,  microservices based system that spans over multiple services and implementing token validation for each service is not a viable solution, since it affects the agility of the overall system and the potential of introducing implementation drift across services. Security concerns are usually handled by the API gateway and the application firewall which takes the incoming request, validate the tokens, apply various filters and policies such as implementing OWASP Top 10 principles to intercept the traffic and then finally send it to the backend microservices. This helps developers to build services focusing on the business aspects rather than adding other cross-cutting concerns such as security as one of them. 

The following aspects are important to consider when assessing this area: 
- Is the service authentication and authorization required?
- Are you using API gateway to validate tokens and incoming requests?
- Are the services communication secured using SSL or MTLS protocols?
- Are the network security policies in place to allow the required communication among services?
- Are you securing internal/external communications by using firewalls (L4, L7) where applicable?
- Have you implemented security policies in API Gateway to control traffic?

## References
- [Embrace Microservices Design – by Packt](https://www.amazon.com/Embracing-Microservices-Design-anti-patterns-architectural/dp/180181838X) 