---
title: "Balancing the portfolio"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Balancing the portfolio
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Balance the portfolio

Cloud adoption is a portfolio management effort, cleverly disguised as technical implementation. Like any portfolio management exercise, balance of the portfolio is a critical element to success. At a strategic level, this means balancing migration, innovation, and experimentation to get the most out of the cloud. When the cloud adoption effort leans too far in one direction or another, complexity finds its way into the migration effort. This article will guide the reader through approaches to achieve balance in the portfolio.

## General scope expansion

This topic is strategic in nature. As such, the approach taken in this article is equally strategic. To ground the strategy in data-driven decisions, this article assumes the reader has evaluated the existing [digital estate](../../digital-estate/index.md) (or is in the process of doing so). The objective of this approach is to aid in evaluating workloads to ensure proper balance across the portfolio through qualitative questions and portfolio refinement.

### Documenting business outcomes

Before balancing the portfolio, it is important to document and share the business outcomes driving the cloud migration effort. For a few examples of general business outcomes related to cloud migrations, see the [Cloud migration executive summary](../../getting-started/migrate.md).

The following table can help document and share desired business outcomes. It's important to note that most businesses are pursuing several outcomes at a time. The importance of this exercise is to clarify the outcomes that are most directly related to the cloud migration effort:

|Outcome  |Measured by  |Goal  |Time frame  |Priority for this effort  |
|---------|---------|---------|---------|---------|
|Reduce IT Costs     |Datacenter Budget         |Reduce by $2M         |12 months         |#1         |
|Datacenter Exit     |Exit from Datacenters         |2 Datacenters         |6 months         |#2         |
|Increase business agility     |Improve time to market  |Reduce deployment time by six months         |2 years         |#3        |
|Improve Customer Experience     |Customer Satisfaction (CSAT)         |10% improvement         |12 months         |#4         |

> [!IMPORTANT]
> The above table is a fictional example and should not used to set priorities. In many cases, this table could considered an antipattern by placing cost savings above customer experiences.

The above table could accurately represent the priorities of the cloud strategy team and the cloud adoption team overseeing a cloud migration. Due to short-term constraints, this team is placing a higher emphasis on IT cost reduction and prioritizing a datacenter exit as a means to achieve the desired IT cost reductions. However, by documenting the competing priorities in this table, the cloud adoption team is empowered to help the cloud strategy team identify opportunities to better align implementation of the overarching portfolio strategy.

### Move fast while maintaining balance

The guidance regarding [incremental rationalization of the digital estate](../../digital-estate/index.md) suggests an approach in which the rationalization starts with an unbalanced position. The cloud strategy team should evaluate every workload for compatibility with a rehost approach. Such an approach is suggested because it allows for the rapid evaluation of a complex digital estate based on quantitative data. Making such an initial assumption allows the cloud adoption team to engage quickly, reducing time to business outcomes. However, as stated in that article, qualitative questions will provide the necessary balance in the portfolio. This article documents the process for creating the promised balance.

### Importance of sunset and retire decisions

The table in the [documenting business outcomes](#documenting-business-outcomes) section above misses a key outcome that would support the number one objective of reducing IT costs. When IT costs reductions rank anywhere in the list of business outcomes, it is important to consider the potential to sunset or retire workloads. In some scenarios, cost savings can come from NOT migrating workloads that don't warrant a short-term investment. Some customers have reported cost savings in excess of 20% total cost reductions by retiring underutilized workloads.

To balance the portfolio, better reflecting sunset and retire decisions, the cloud strategy team and the cloud adoption team are encouraged to ask the following questions of each workload within assess and migrate processes:

- Has the workload been used by end users in the past six months?
- Is end-user traffic consistent or growing?
- Will this workload be required by the business 12 months from now?

If the answer to any of these questions is "No", then the workload could be a candidate for retirement. If retirement potential is confirmed with the app owner, then it may not make sense to migrate the workload. This prompts for a few qualification questions:

- Can a retirement plan or sunset plan be established for this workload?
- Can this workload be retired prior to the datacenter exit?

If the answer to both of these questions is "Yes", then it would be wise to consider _not_ migrating the workload. This approach would help meet the objectives of reducing costs and exiting the datacenter.

If the answer to either question is "No", it may be wise to establish a plan for hosting the workload until it can be retired. This plan could include moving the assets to a lower-cost datacenter or alternative datacenter, which would also accomplish the objectives of reducing costs and exiting one datacenter.

## Suggested prerequisites

The prerequisites specified in the baseline guide should still be sufficient for addressing this complexity topic. However, the asset inventory and digital estate should be highlighted and bolded amongst those prerequisites, as that data will drive the following activities.

## Assess process changes

Balancing the portfolio requires additional qualitative analysis during the assess process, which will help drive simple portfolio rationalization.

### Suggested action during the assess process

Based on the data from the table in the [documenting business outcomes](#documenting-business-outcomes) section above, there is a likely risk of the portfolio leaning too far into a migration-focused execution model. If customer experience was top priority, an innovation heavy portfolio would be more likely. Neither is right or wrong, but leaning too far in one direction commonly results in diminishing returns, adds unnecessary complexity, and increases execution time related to cloud adoption efforts.

To reduce complexity, it is advised that the reader follow a traditional approach to portfolio rationalization, but in an iterative model. The following steps outline a qualitative model to such an approach:

- The cloud strategy team maintains a prioritized backlog of workloads to be migrated.
- The cloud strategy team and the cloud adoption team host a release planning meeting prior to the completion of each release.
- In the release planning meeting, the teams agree on the top 5 to 10 workloads in the prioritized backlog.
- Outside of the release planning meeting, the cloud adoption team asks the following questions of application owners and subject matter experts:
  - Could this application be replaced with a platform as a service (PaaS) equivalent?
  - Is this application a third-party application?
  - Has budget been approved to invest in ongoing development of the application in the next 12 months?
  - Would additional development of this application improve the customer experience? Create a competitive differentiator? Drive additional revenue for the business?
  - Will the data within this workload contribute to a downstream innovation related to BI, Machine Learning, IoT, or related technologies?
  - Is the workload compatible with modern application platforms like Azure App Service?
- The answers to the above questions and any other required qualitative analysis would then influence adjustments to the prioritized backlog. These adjustments may include:
  - If a workload could be replaced with a PaaS solution, it may be removed from the migration backlog entirely. At minimum, additional due diligence to decide between rehost and replace would be added as a task, temporarily reducing that workload's priority from the migration backlog.
  - If a workload is undergoing development advancement (or should be), then it may best fit into a refactor/rearchitect/rebuild model. Since innovation and migration require different technical skills, it is often advised that applications, which align to a refactor/rearchitect/rebuild approach be managed through an innovation backlog, as opposed to a migration backlog.
  - If a workload is part of a downstream innovation, then it may make sense to refactor the data platform, but leave the application layers as a rehost candidate. Minor refactoring of a workload's data platform can often be addressed in a migration or an innovation backlog. This rationalization outcome may result in more detailed work items in the backlog, but otherwise no change to priorities.
  - If a workload isn't strategic but is compatible with modern, cloud-based application hosting platforms, then it may be wise to perform minor refactoring on the application to deploy it as a modern app. This can contribute to the overall savings by reducing the overall IaaS and OS licensing requirements of the cloud migration.
  - If a workload is a third-party application and that workload's data isn't planned for use in a downstream innovation, then it may be best to leave as a rehost option on the backlog.

These questions should not be the extent of the qualitative analysis completed for each workload, but they are intended to guide a conversation that helps address the complexity of an imbalanced portfolio.

## Migrate process changes

During migration, portfolio balancing activities can have a negative impact on migration velocity (Speed at which assets are migrated). The following guidance will expand on why and how to align work to avoid interruptions to the migration effort.

### Suggested action during the migrate process

Portfolio rationalization requires diversity of technical effort. It is tempting for cloud adoption teams to match that portfolio diversity within migration efforts. Business stakeholders of ask for a single cloud adoption team to address the entire migration backlog. This is seldom an advisable approach, in many cases this can be counter productive.

It is advised that these diverse efforts are segmented across two or more cloud adoption teams. Using a two team model as an example mode of execution, Team 1 is the Migration Team and Team 2 is the Innovation Team. For larger efforts, these teams could be further segmented to address other approaches like Replace/PaaS efforts or Minor Refactoring. The following outlines the skills and roles needed to Rehost, Refactor, or Minor Refactoring:

**Rehost:** Rehost requires team members to implement infrastructure focused changes. Generally using a tool like Azure Site Recovery to migrate VMs or other assets to Azure. This work aligns well to datacenter admins or IT implementors. The cloud migration team is well structured to deliver this work at high scale. This is the fastest approach to migrate existing assets in most scenarios.

**Refactor:** Refactor requires team members to modify source code, change the architecture of an application, or adopt new cloud services. Generally this effort would use development tools like Visual Studio and deployment pipeline tools like Azure DevOps to redeploy modernized applications to Azure. This work aligns well to application development roles or DevOps pipeline development roles. Cloud Innovation Team is best structured to deliver this work. It can take longer to replace existing assets with cloud assets in this approach, but the apps can take advantage of cloud-native features.

**Minor Refactoring:** Some applications can be modernized with minor refactoring at the data or application level. This work requires team members to deploy data to cloud-based data platforms or to make minor configuration changes to the application. This may require limited support for data or application development subject matter experts. However, this work is similar to the work conducted by IT implementors when deploying third-party apps. This work could easily align with the cloud migration team or the cloud strategy team. While this effort is not nearly as fast as a rehost migration, it takes less time to execute than refactor efforts.

During migration, it is recommended that efforts are segmented in the three ways listed above, and that those efforts are executed by the appropriate team in the appropriate iteration. While it is advised that the portfolio be diversified, it is also advised that efforts stay very focused and segregated.

## Optimize and promote process changes

No additional changes are required during Optimize and promote processes within the Migration effort.

## Secure and manage process changes

No additional changes are required during Secure and manage processes within the Migration effort.

## Next steps

Return to the [expanded scope checklist](./index.md) to ensure your migration method is fully aligned.

> [!div class="nextstepaction"]
> [Expanded scope checklist](./index.md)
