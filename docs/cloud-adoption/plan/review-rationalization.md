---
title: "Review rationalization decisions"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Review rationalization decisions
author: BrianBlanchard
ms.author: brblanch
ms.date: 07/01/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Review rationalization decisions

During initial strategy and planning phases, it is suggested that an [incremental rationalization](../digital-estate/rationalize.md#incremental-rationalization) approach is applied to the digital estate rationalization. However, this approach embeds a number of assumptions into the resultant decisions. In this phase of planning, it is advised that the cloud strategy and cloud adoption teams review those decisions, in light of expanded workload documentation. This is also a good time to involve business stakeholders and the executive sponsor in future state decisions.

> [!IMPORTANT]
> Further validation of the rationalization decisions will occur during the assessment phase of migration. This validation focuses on business review of the rationalization to align resources appropriately.

To validate rationalization decisions, use the following questions to facilitate a conversation with the business. The questions below are grouped by the likely rationalization alignment.

## Innovate indicators

If the joint review of the following questions results in a yes answer to these questions, then the workload may be a better candidate for innovation. Innovate candidates wouldn't be migrated via a shift/lift or modernize model. Instead the business logic and/or data structures would be re-created as a new or rearchitected application. This approach can be more labor intensive and time consuming but for workloads that represent significant business returns the investment is justified.

- Do the applications in this workload create market differentiation?
- Is there an investment (proposed or approved) aimed at improving the experiences associated with the applications in this workload?
- Does the data in this workload enable new product or service offerings?
- Is there an investment (proposed or approved) aimed at leveraging the data associated with this workload?
- Can the impact of the market differentiation or new offerings be quantified? If so, does that return justify the increased cost of innovation during cloud adoption?

The following two questions aid in factoring in high-level technical scenarios into the rationalization review. Answering yes to either could identify ways of accounting for or reducing the cost burdens associated with innovation:

- Will the data structures or business logic be changed during the course of cloud adoption?
- Is an existing deployment pipeline used to deploy this workload to production?

If the answer to any of the above is yes, the team should evaluate inclusion of this workload as an innovate candidate. At a minimum, the team should flag this workload for architecture review to identify modernization opportunities.

## Migrate indicators

Migration is a faster and more cost effective means of adopting the cloud, but doesn't take advantage of opportunities to innovate. Before investing in innovation, the following questions can help determine if a migration model could be more applicable for this workload.

- Is the source code supporting this application stable? Is it expected to remain stable & unchanged during the time frame of this release cycle?
- Does this workload support production business processes today? Will it throughout the course of this release cycle?
- Is it a priority to improve stability and performance of this workload, as a result of this cloud adoption effort?
- Is cost reduction associated with this workload an objective during this adoption effort?
- Is the goal to reduce operational complexity for this workload during this adoption effort?
- Is innovation constrained by the current architecture or IT operation processes today?

If the answer to any of these questions is yes, then a migrate model should be considered for each workload. This is true, even if the workload is a candidate for innovation.

Business returns can be hindered by operational complexity, costs, performance, or stability challenges. The cloud can be leveraged as a means of quickly producing improvements related to each of those challenges. When applicable, it is suggested that you leverage the migration approach to stabilize the workload first. Then expand on innovation opportunities in the stable, agile cloud environment. The migrate-then-innovate approach provides short-term returns and reduces the cost required to drive long-term change.

> [!IMPORTANT]
> Migrate models include incremental modernization. Leveraging platform as a service (PaaS) architectures is a common aspect of migration activities. As is minor configuration changes to leverage those platform services. The boundary for migration is defined as a material change to the business logic or supporting business structures, which would be considered an innovation effort.

## Update the project plan

The skills required for a migrate effort are different from the skills required for an innovate effort. During cloud adoption plan implementation, it is suggested that migrate and innovate efforts be assigned to different teams, with their own iteration, release, and planning cadences. Assigning separate teams provides the process flexibility to maintain one cloud adoption plan while accounting for innovation and migration efforts.

When managing the cloud adoption plan in Azure DevOps, this change would be reflected by changing the parent work item (or epic) from Cloud migration to Cloud innovation. This subtle change will ensure all participants in the cloud adoption plan can quickly track the required effort and changes to remediation efforts. This will also help align proper assignments to the relevant cloud adoption team.

For large complex adoption plans with multiple distinct projects, it may be wise to also update the iteration path. Changing the area path will make the workload visible only to the team assigned to that area path. This can make it easier on the cloud adoption team by reducing the number of visible tasks, but it will add complexity for the project management processes. 

## Next steps

[Define iterations and releases](./iteration-paths.md) to begin planning work.

> [!div class="nextstepaction"]
> [Define iterations and releases](./iteration-paths.md) to begin planning work.
