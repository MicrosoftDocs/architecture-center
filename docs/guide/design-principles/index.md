---
title: Design Principles for Azure Applications
description: Learn key design principles for Azure applications, including self-healing, redundancy, scaling, partitioning, and using managed services effectively.
author: claytonsiemens77
ms.author: pnp
ms.date: 09/25/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Design principles for Azure applications

The design principle articles in this section provide a foundation to help you build cloud applications that can withstand failures, scale with demand, and evolve with business needs. Whether you want to design a new system, modernize legacy applications, or plan for production workloads, these interconnected principles help you make informed decisions about reliability, performance, and maintainability. Together, they form a comprehensive approach to cloud-native application design that balances technical excellence with business value.

To make your application more scalable, resilient, and manageable, follow these design principles.

## Core principles

- [Design for self-healing](self-healing.md). Design your application to detect failures, respond gracefully, and recover automatically. In distributed systems, failures are inevitable. To isolate failures and maintain system availability, implement retry logic, health endpoint monitoring, circuit breakers, and bulkhead patterns.

- [Make all things redundant](redundancy.md). Build redundancy into your application to avoid single points of failure. Use load balancers, multiple instances, database replicas, and multi-zone or multi-region deployments. Design for the level of redundancy that matches your business requirements and risk tolerance.

- [Minimize coordination](minimize-coordination.yml). Minimize coordination between application services to achieve scalability. Use decoupled components that communicate asynchronously, embrace eventual consistency where appropriate, and apply domain events to synchronize state without tight coupling.

- [Design to scale out](scale-out.md). Design your application for horizontal scaling by adding or removing instances as demand changes. Avoid session stickiness, identify bottlenecks, decompose workloads by scaling requirements, and use autoscaling based on live metrics to handle variable loads efficiently.

- [Partition around limits](partition.md). Use partitioning to work around database, network, and compute limits. Partition data horizontally, vertically, or functionally, and design partition keys to avoid hotspots. Consider partitioning at multiple levels, including databases, queues, and compute resources.

## Operational principles

- [Design for operations](design-for-operations.md). Design your application to provide operations teams with the tools that they need for deployment, monitoring, and incident response. Implement comprehensive logging, distributed tracing, standardized metrics, and automate management tasks to enable effective operational oversight.

- [Use managed services](managed-services.md). Use platform as a service (PaaS) rather than infrastructure as a service (IaaS). Managed services reduce operational overhead, provide built-in scaling capabilities, and allow teams to focus on application logic rather than infrastructure maintenance.

- [Use an identity service](identity.md). Use a managed identity platform like Microsoft Entra ID instead of building or operating your own identity system. Managed solutions provide credential storage, authentication features, federation capabilities, and compliance with industry standards.

## Strategic principles

- [Design for evolution](design-for-evolution.md). Design for continuous innovation because all successful applications change over time. Enforce loose coupling, encapsulate domain knowledge, use asynchronous messaging, and expose well-defined APIs that include proper versioning to enable independent service evolution.

- [Build for the needs of business](build-for-business.md). Make design decisions based on business requirements. Define clear objectives like recovery time objectives (RTOs), document service-level agreements (SLAs) and service-level objectives (SLOs), model applications around business domains, and plan for growth while balancing functional and nonfunctional requirements.

- [Perform failure mode analysis for services](../../resiliency/failure-mode-analysis.md). Systematically identify potential failure points in your system and plan recovery strategies. To build reliability from the beginning, conduct failure mode analysis (FMA) during architecture and design phases. Rate each failure mode by risk and impact, then determine appropriate response and recovery mechanisms.

## Apply these principles

These principles work together to create resilient, scalable applications:

- **Start with business requirements** to understand what you're building and why.

- **Design for failure** by implementing self-healing capabilities and redundancy.
- **Plan for scale** through horizontal scaling, partitioning, and minimal coordination.
- **Use Azure services** to reduce operational complexity and focus on business logic.
- **Support operations** through proper monitoring, logging, and automation.
- **Build for change** to ensure that your application can evolve with business needs.
