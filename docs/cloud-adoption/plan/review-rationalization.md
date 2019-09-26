---
title: "Review rationalization decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Review rationalization decisions
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Review rationalization decisions

During initial strategy and planning phases, we suggest you apply an [incremental rationalization](../digital-estate/rationalize.md#incremental-rationalization) approach to the digital estate. But this approach embeds some assumptions into the resulting decisions. We advise the cloud strategy team and the cloud adoption teams to review those decisions in light of expanded-workload documentation. This review is also a good time to involve business stakeholders and the executive sponsor in future state decisions.

> [!IMPORTANT]
> Further validation of the rationalization decisions will occur during the assessment phase of migration. This validation focuses on business review of the rationalization to align resources appropriately.

To validate rationalization decisions, use the following questions to facilitate a conversation with the business. The questions are grouped by the likely rationalization alignment.

## Innovation indicators

If the joint review of the following questions results in a "Yes" answer, a workload might be a better candidate for innovation. Such a workload wouldn't be migrated via a shift/lift or modernize model. Instead, the business logic or data structures would be recreated as a new or rearchitected application. This approach can be more labor-intensive and time-consuming. But for a workload that represents significant business returns, the investment is justified.

- Do the applications in this workload create market differentiation?
- Is there a proposed or approved investment aimed at improving the experiences associated with the applications in this workload?
- Does the data in this workload make new product or service offerings available?
- Is there a proposed or approved investment aimed at taking advantage of the data associated with this workload?
- Can the effect of the market differentiation or new offerings be quantified? If so, does that return justify the increased cost of innovation during cloud adoption?

The following two questions can help you include high-level technical scenarios in the rationalization review. Answering "Yes" to either could identify ways of accounting for or reducing the cost associated with innovation.

- Will the data structures or business logic change during the course of cloud adoption?
- Is an existing deployment pipeline used to deploy this workload to production?

If the answer to either question is "Yes," the team should consider including this workload as an innovation candidate. At a minimum, the team should flag this workload for architecture review to identify modernization opportunities.

## Migration indicators

Migration is a faster and cheaper way of adopting the cloud. But it doesn't take advantage of opportunities to innovate. Before you invest in innovation, answer the following questions. They can help you determine if a migration model is more applicable for a workload.

- Is the source code supporting this application stable? Do you expect it to remain stable and unchanged during the time frame of this release cycle?
- Does this workload support production business processes today? Will it do so throughout the course of this release cycle?
- Is it a priority that this cloud adoption effort improves the stability and performance of this workload?
- Is cost reduction associated with this workload an objective during this effort?
- Is reducing operational complexity for this workload a goal during this effort?
- Is innovation limited by the current architecture or IT operation processes?

If the answer to any of these questions is "Yes," you should consider a migration model for this workload. This recommendation is true even if the workload is a candidate for innovation.

Challenges in operational complexity, costs, performance, or stability can hinder business returns. You can use the cloud to quickly produce improvements related to those challenges. Where it's applicable, we suggest you use the migration approach to first stabilize the workload. Then expand on innovation opportunities in the stable, agile cloud environment. This approach provides short-term returns and reduces the cost required to drive long-term change.

> [!IMPORTANT]
> Migration models include incremental modernization. Using platform as a service (PaaS) architectures is a common aspect of migration activities. So too are minor configuration changes that use those platform services. The boundary for migration is defined as a material change to the business logic or supporting business structures. Such change is considered an innovation effort.

## Update the project plan

The skills required for a migration effort are different from the skills required for an innovation effort. During implementation of a cloud adoption plan, we suggest that you assign migration and innovation efforts to different teams. Each team has its own iteration, release, and planning cadences. Assigning separate teams provides the process flexibility to maintain one cloud adoption plan while accounting for innovation and migration efforts.

When you manage the cloud adoption plan in Azure DevOps, that management is reflected by changing the parent work item (or epic) from cloud migration to cloud innovation. This subtle change helps ensure all participants in the cloud adoption plan can quickly track the required effort and changes to remediation efforts. This tracking also helps align proper assignments to the relevant cloud adoption team.

For large, complex adoption plans with multiple distinct projects, consider updating the iteration path. Changing the area path makes the workload visible only to the team assigned to that area path. This change can make work easier for the cloud adoption team by reducing the number of visible tasks. But it adds complexity for the project management processes.

## Next steps

[Define iterations and releases](./iteration-paths.md) to begin planning work.

> [!div class="nextstepaction"]
> [Define iterations and releases](./iteration-paths.md) to begin planning work.
