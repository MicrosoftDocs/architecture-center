# Design for evolvable services

Evolvable services are the key to continuous innovation. 

All successful applications change over time, whether to fix bugs, add new features, bring in new technologies, or make existing systems more scalable and resilient. If all the parts of an application are tightly coupled, it becomes very hard to introduce changes into the system. A change in one part of the application may break another part, or cause changes to ripple throught the entire codebase.

This problem is not limited to monolithic applications. An application can be decomposed into services, but still exhibit the sort of tight coupling that leaves the system rigid and brittle. But when services are designed to evolve, teams can innovate and continuously deliver new features. 

## Recommendations

**Enforce high cohesion and loose coupling.** A service is cohesive if it provides a set of functionality that logically belongs together. Cohesion is that natural result of domain-driven design. Two services are loosely coupled if you can change one service without changing the other. 

**Encapsulate domain knowledge.** When a client consumes a service, the responsiblity for enforcing the business rules of the domain should not fall on the client. Instead, the service should encapsulate all of the domain knowledge that falls under its responsiblity. Otherwise, every client has to enforce the business rules, and you end up with domain knowledge spread across different parts of the application. 

**Use asynchronous messaging.** Asynchronous messaging is a way to decouple the message producer from the consumer. The producer does not depend on the consumer responding to the message or taking any particular action. With a pub/sub architecture, the producer may not even know who is consuming the message. New services can easily consume the messages without any modifications to the producer.

**Don't build domain knowledge into a gateway.** Gateways can be useful in a microservices architecture, for things like request routing, protocol translation, load balancing, or authentication. However, the gateway should be restricted to this sort of infrastructure functionality. It should not implement any domain-specific functionality, or encapsulate any domain knowledge. 

**Expose open interfaces.** Avoid creating custom translation layers that sit between services. Instead, a service should expose an interface that can be invoked by any other service in the application. The interface should use a well-known protocol. This might be REST over HTTP, although for inter-service communication you might use an RPC-based mechanism for performance reasons. Also think about you will version the API.

**Design and test against service contracts.** When services expose well-defined APIs, you can develop and test against those APIs. That way, you can develop and test an individual service without spinning up all of its dependent services. (Of course, you would still perform integration and load testing against the real services.)

**Abstract infrastructure away from domain logic.** Don't let domain logic get entangled with infrastructure-related functionality, such as messaging or persistence. Otherwise, changes in the domain logic will require updates to the infrastructure layers and vice versa. 

**Offload common tasks to a separate service.** For example, if serveral services need to authenticate requests, you could move this functionality into its own service. Then you could evolve the authentication service &mdash; for example, by adding a new authentication flow &mdash; without touching any of the services that use it.

**Deploy services independently.** When the DevOps team can deploy a single service independently of other services in the application, updates can happen more quickly and safely. Bug fixes and new features can be rolled out at a more regular cadance.