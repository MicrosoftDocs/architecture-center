---
title: "Cloud migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Introduction to Cloud Migration content
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Cloud migration in the Microsoft Cloud Adoption Framework for Azure

Cloud migration is the process of moving existing digital assets into a cloud platform. In this approach, existing assets are replicated to the cloud with minimal modifications. When an application or workload is operational in the cloud, users are transitioned from the existing solution to the cloud solution. Cloud migration is one means of effectively balancing a cloud portfolio. This is often the fastest and most agile approach in the short-term. Conversely, some of the benefits of the cloud may not be realized through this approach without additional future modification. Enterprises and mid-market customers use this approach to accelerate the pace of change, avoid planned capital expenditures, and reduce ongoing operational costs.

## Cloud migration guidance

The guidance in this section of the Cloud Adoption Framework is designed for two purposes:

- Provide actionable migration guides that represent common experiences that customers often encounter. Each guide encapsulates the process and tools needed to be successful in a cloud migration effort. By necessity, the design guidance is specific to Azure. All other recommendations in these guides could be applied as part of a cloud-agnostic or multicloud approach.
- Help readers create personalized migration plans that can meet a variety of business needs, including migration to multiple public clouds, through detailed guidance on the development of processes, role and responsibilities, and change management controls.

This content is intended for the cloud adoption team. It is also relevant to cloud architects that need to develop a strong foundation in cloud migration.

## Intended Audience

The guidance in the Cloud Adoption Framework affects the business, technology, and culture of enterprises. This section significantly affects application owners, change management personnel (such as PMO and agile management personnel) finance and line-of-business leaders, and the cloud adoption team. There are various dependencies on these personas that will require facilitation by the cloud architects using this guidance. Facilitation with these teams may be a one-time effort, but in some cases, it will result in recurring interactions with these other personas.

The Cloud Architect serves as the thought leader and facilitator to bring these audiences together. The content in this collection of guides is designed to help the Cloud Architect facilitate the right conversation, with the right audience, to drive necessary decisions. Business transformation that is empowered by the cloud depends on the Cloud Architect role to help guide decisions throughout the business and IT.

**Cloud Architect specialization in this section:** Each section of the Cloud Adoption Framework represents a different specialization or variant of the Cloud Architect role. This section is designed for cloud architects with subject matter expertise regarding the existing on-premises environment and how that affects migration options.

**Separation of Duties:** In many enterprises, separation of duties exists to limit access to production systems or segments of the corporate environment. In such a case, the process of migration becomes more complex. In some cases, those roles and responsibilities may require multiple cloud architects to span the entire migration process.

**Partnership options** Across each of these processes, teams will be learning new skills and approaches to technical execution. Expanding technical skills amongst the existing team members is one option during execution. Hiring additional staff another. Partnering with third parties can often provide significant acceleration and risk reductions. [Partnership options](./migration-considerations/assess/partnership-options.md) can help guide decisions to choose the best partnership option.

## Next steps

For readers who wish to follow this guide from beginning to end, this content will aid in developing a robust cloud migration strategy. The guidance walks the reader through the theory and implementation of such a strategy.

As a first step, it is advised that readers work through the [Azure migration guide](./azure-migration-guide/index.md) to understand the standard set of tools and approaches needed to migration in a common use case. Afterwards, the baseline guidance can be expanded to fit the readers needs through the [complex migration scenarios](./expanded-scope/index.md), [migration best practices](./azure-best-practices/index.md), and [migration considerations](./migration-considerations/index.md).

> [!div class="nextstepaction"]
> [Azure migration guide](./azure-migration-guide/index.md)
