---
title: Build for business needs
titleSuffix: Azure Application Architecture Guide
description: Use these recommendations to design and build cloud applications that meet functional and nonfunctional business requirements for performance, availability, scalability, growth, and cost management.
author: martinekuan
ms.author: pnp
ms.date: 07/25/2023
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
products:
  - azure-cloud-services
  - azure-devops
categories: devops
ms.custom:
  - guide
---

# Build for business needs

Every design decision must be justified by a business requirement. This design principle might seem obvious, but is crucial to keep in mind when designing Azure applications.

Must your application support millions of users, or a few thousand? Are there large traffic bursts, or a steady workload? What level of application outage is acceptable? Ultimately, business requirements drive these design considerations.

The following recommendations help you design and build solutions to meet business requirements:

- **Define business objectives** such as recovery time objective (RTO), recovery point objective (RPO), and maximum tolerable outage (MTO). These numbers should inform decisions about the architecture.

  For example, suppose your business requires a very low RTO and a very low RPO. You might choose to use a zone-redundant architecture to meet these requirements. If your business can tolerate a higher RTO and RPO, adding redundancy might add extra cost for no business benefit.

- **Align technical and business needs**. In architecture, every decision comes with a trade-off. And often, cost, resilience and performance are at odds with each other. It’s crucial to find the right balance between your technical and business needs: to find the sweet spot that aligns with your risk tolerance and budget. Follow the [Design for self-healing guidance](self-healing.md) to design your solution to be resilient to many types of common failure modes. Consider whether you need to account for less likely situations, like a geographic area experiencing a major natural disaster that might affect all of the availability zones in the region. Mitigating these uncommon risks is generally more expensive and involves significant tradeoffs, so have a clear understanding of the business's tolerance for risk.

- **Document service level agreements (SLAs)** and service level objectives (SLOs), including availability and performance metrics. For example, a proposed solution might deliver 99.95% availability. Whether that SLO meets the SLA is a business decision.

- **Model applications** for your business domain. Analyze the business requirements, and use these requirements to model the solution. Consider using a domain-driven design (DDD) approach to create domain models that reflect your business processes and use cases.

- **Define functional and nonfunctional requirements**. Functional requirements determine whether an application performs its task. Nonfunctional requirements determine how well the application performs. Make sure you understand nonfunctional requirements like scalability, availability, and latency. These requirements influence design decisions and technology choices. Note that what often goes overlooked is cost. Specifying cost as a nonfunctional requirement helps to prioritize the cost factor in your decisions.

- **Decompose workloads**. Workload in this context means a discrete capability or computing task that can logically be separated from other tasks. Different workloads might have different requirements for availability, scalability, data consistency, and disaster recovery. Well-designed systems allow you to take action on opportunities for improvement. For this to work, applications should be decomposed into tunable building blocks. A common approach is tiering components by criticality. For example, Tier 1 components are essential so they have to be optimized regardless of cost. Tier 2 components are important but can be temporarily scaled down without major impact. Tier 3 components are nice-to-have so they can be low-cost. Defining tiers enables trade-offs between cost and other requirements. Infrastructure, languages, databases should all be tunable.


- **Plan for growth**. A solution might support current needs for number of users, transaction volume, and data storage, but it also needs to handle growth without major architectural changes. Also consider that your business model and business requirements might change over time. It's hard to evolve a solution for new use cases and scenarios if the application's service model and data models are too rigid. 

- **Align business model and cost**. The durability of a system depends on how well its costs are aligned to the business model. As an architect, you should think about revenue – and use that knowledge to inform your choices. Because growth at all costs leads to a trail of destruction. When designing and building systems, you should consider the revenue sources and profit levers. It’s important to find the dimension you’re going to make money over, then make sure the architecture follows the money. For example an e-commerce application can be architected so that when the number of orders go up, infrastructure and operation costs rise. If the system is architected well, you can start to exploit economies of scale. What’s important is that infrastructure costs have a measurable impact on the business.

- **Manage costs**. In a traditional on-premises application, you pay up front for hardware as a capital expenditure. In a cloud application, you pay for the resources you consume. Make sure that you understand your services' pricing model. Total costs might include network bandwidth usage, storage, IP addresses, and service consumption.

  Also consider operations costs. In the cloud, you don't have to manage hardware or infrastructure, but you still need to manage application DevOps, incident response, and disaster recovery. You should enforce cost guardrails ideally through using governance policies.


## Next steps

- [Domain Model](https://martinfowler.com/eaaCatalog/domainModel.html)
- [Azure pricing](https://azure.microsoft.com/pricing)

## Related resources

- [Design to scale out](scale-out.md)
- [Partition around limits](partition.md)
- [Design for evolution](design-for-evolution.md)
