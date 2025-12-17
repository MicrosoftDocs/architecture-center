---
title: Build for business needs
description: Use these recommendations to design and build cloud applications that meet functional and nonfunctional business requirements for performance, availability, scalability, growth, and cost management.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/25/2023
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Build for business needs

Every design decision must be justified by a business requirement. This design principle might seem obvious, but is crucial to keep in mind when designing Azure applications.

Must your application support millions of users, or a few thousand? Are there large traffic bursts, or a steady workload? What level of application outage is acceptable? Ultimately, business requirements drive these design considerations.

The following recommendations help you design and build solutions to meet business requirements:

- **Define business objectives** such as recovery time objective (RTO), recovery point objective (RPO), and maximum tolerable outage (MTO). These numbers should inform decisions about the architecture.

  For example, suppose your business requires a very low RTO and a very low RPO. You might choose to use a zone-redundant architecture to meet these requirements. If your business can tolerate a higher RTO and RPO, adding redundancy might add extra cost for no business benefit.

- **Consider the failure risks you need to mitigate**. Follow the [Design for self-healing guidance](self-healing.md) to design your solution to be resilient to many types of common failure modes. Consider whether you need to account for less likely situations, like a geographic area experiencing a major natural disaster that might affect all of the availability zones in the region. Mitigating these uncommon risks is generally more expensive and involves significant tradeoffs, so have a clear understanding of the business's tolerance for risk.

- **Document service level agreements (SLAs)** and service level objectives (SLOs), including availability and performance metrics. For example, a proposed solution might deliver 99.95% availability. Whether that SLO meets the SLA is a business decision.

- **Model applications** for your business domain. Analyze the business requirements, and use these requirements to model the solution. Consider using a domain-driven design (DDD) approach to create domain models that reflect your business processes and use cases.

- **Define functional and nonfunctional requirements**. Functional requirements determine whether an application performs its task. Nonfunctional requirements determine how well the application performs. Make sure you understand nonfunctional requirements like scalability, availability, and latency. These requirements influence design decisions and technology choices.

- **Decompose workloads into discrete functionality**. A workload is a collection of application resources, data, and supporting infrastructure that function together to achieve defined business outcomes. A workload consists of components and also development and operational procedures. Workloads often can be decomposed into discrete functionality that aligns with user, data, or system flows and those flows can be attributed value and have non-functional requirements.

   Different user, data, or system flows often have different requirements for availability, scalability, data consistency, and disaster recovery. Well-designed systems allow you to optimize your design per flow. To achieve this, you must break down workloads into adjustable components. A typical strategy involves categorizing components based on their value. For example, Tier 1 components are crucial and should be optimized without regard to expense. Tier 2 components are significant but can be reduced temporarily with minimal consequences. Tier 3 components are optional; keep them cost-effective and easily manageable. Establishing a shared understanding of the value of flows helps everyone designing and evolving a workload keep a balance between cost and other non-functional requirements.

- **Plan for growth**. A solution might support current needs for number of users, transaction volume, and data storage, but it also needs to handle growth without major architectural changes. Also consider that your business model and business requirements might change over time. It's hard to evolve a solution for new use cases and scenarios if the application's service model and data models are too rigid.

- **Align business model and cost**. The longevity of a system is influenced by how effectively its costs align with the business model. As an architect, you must consider value drivers and use that insight to guide your decisions. You should identify the dimension in which your solution provides value (such as profitability), then make sure the architecture follows the value stream. This way, your architecture can maximize value to investment, yielding a return on investment (ROI) that is aligned to business expectations.

- **Manage costs**. In a traditional on-premises application, you pay up front for hardware as a capital expenditure. In a cloud application, you pay for the resources you consume. Make sure that you understand your services' pricing model. Total costs might include network bandwidth usage, storage, IP addresses, and service consumption.

  Also consider operations costs. In the cloud, you don't have to manage hardware or infrastructure, but you still need to manage application DevOps, incident response, and disaster recovery.

## Next steps

- [Domain Model](https://martinfowler.com/eaaCatalog/domainModel.html)
- [Azure pricing](https://azure.microsoft.com/pricing)

## Related resources

- [Design to scale out](scale-out.md)
- [Partition around limits](partition.md)
- [Design for evolution](design-for-evolution.md)
