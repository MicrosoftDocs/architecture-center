---
title: "CAF: Cloud Migration"
description: Introduction to Cloud Migration content
author: BrianBlanchard
ms.date: 4/4/2019
---

# Cloud migration in the Microsoft CAF for Azure

Cloud migration is the process of moving existing digital assets into a cloud platform. In this approach, existing assets are replicated to the cloud with minimal modifications. When an application or workload is operational in the cloud, users are transitioned from the existing solution to the cloud solution. Cloud migration is one means of effectively balancing a cloud portfolio. Often times, this is the fastest and most agile approach, short term. Conversely, some of the benefits of the cloud may not be realized through this approach without additional future modification. Enterprises and mid-market customers use this approach to accelerate the pace of change, avoid planned capital expenditures, and reduce on-going operational costs.

## Creating a balance cloud portfolio

In any balanced technology portfolio, there is a mixture of assets in various states. Some applications are slated for retirement, with minimal support. Other applications or assets are supported in a maintenance state, but the features associated with those solutions are stable. For newer processes within the business,  changing market conditions will likely result in on-going feature enhancements or modernization. When opportunities to drive new revenue streams present themselves, net new applications or assets are introduced into the environment. At each stage of an asset's lifecycle, the impact any investment has on revenue and profit will change. The later an asset is in its lifecycle, the less likely a company is to see a return from a new feature or modernization investment.

The cloud provides various adoption mechanisms, each with similar degrees of investment and return. Building cloud native applications can significantly reduce operating expenses. Once a cloud native application is released, new features and solutions can iterate faster. Modernizing an application can have similar yields, by removing legacy constraints associated with on-premise development models. Unfortunately, these two approaches are labor-intensive and have a strong dependency on the size, skill, and experience of software development teams. Sadly, there is commonly a labor misalignment. The people with the skills and talent to modernize applications would much rather be building new applications. In a labor constrained market, modernization projects at scale can suffer from an employee satisfaction and talent issue. In a balanced portfolio, this approach should be reserved for applications that would receive significant feature enhancements, if they remained on-prem.

## Cloud Migration Guidance

The guidance in this section of CAF is designed for two purposes:

* Provide actionable customer journeys that represent common experiences that customers often encounter. Each of these encapsulate the process and tools needed to be successful in a cloud migration effort. By necessity, the design guidance is specific to Azure. All other guidance in these journeys could be applied as part of a cloud-agnostic or multi-cloud approach.
* Help readers create personalized migration plans that can meet a variety of business needs, including migration to multiple public clouds, through detailed guidance on the development of processes, role & responsibilities, and change management controls.

This content is intended for the Cloud Adoption team. It is also relevant to cloud architects that need to develop a strong foundation in cloud migration.

## Audience

The content in the CAF affects the business, technology, and culture of enterprises. This section of the CAF will interact heavily with Application owners, Change management personnel (PMO, Agile management, etc...) Finance, and Line-Of-Business (LOB) leaders, and the Cloud Adoption Team. There are various co-dependencies on these personas which will require a facilitative approach by the Cloud Architects using this guidance. Facilitation with these teams may be a one-time effort, but in some cases, it will result in recurring interactions with these other personas.

The Cloud Architect serves as the thought leader and facilitator to bring these audiences together. The content in this collection of guides is designed to help the Cloud Architect facilitate the right conversation, with the right audience, to drive necessary decisions. Business transformation that is empowered by the cloud is dependent upon the Cloud Architect role to help guide decisions throughout the business and IT.

**Cloud Architect specialization in this section:** Each section of the CAF represents a different specialization or variant of the Cloud Architect role. This section of the CAF is designed for cloud architects with subject matter expertise regarding the existing on-premise environment and how that impacts migration options.

**Separation of Duties:** In many enterprises, separation of duties exist to limit access to production systems or segments of the corporate environment. In such a case, the process of migration becomes more complex. In some cases, those roles and responsibilities may require multiple cloud architects to span the entire migration process.

**Partnership options** Across each of these processes, teams will be learning new skills and approaches to technical execution. Expanding technical skills amongst the existing team members is one option during execution. Hiring additional staff another. Often times, partnering with third parties can provide significant acceleration and risk reductions. [Partnership options](./theory/migrate/partnership-options.md) can help guide decisions to choose the best partnership option.

## Using this guide

For readers who wish to follow this guide from beginning to end, this content will aid in developing a robust cloud migration strategy. The guidance walks the reader through the theory and implementation of such a strategy.

For a crash course on the theory and quick access to Azure implementation, get started with the [Overview of Actionable Migration Journeys](./journeys/overview.md). Through this guidance, the reader can start small and evolve their governance needs in parallel with cloud adoption efforts.

## Next steps

Review the Actionable Migration Journeys.

> [!div class="nextstepaction"]
> [Actionable Migration Journeys](./journeys/overview.md)
