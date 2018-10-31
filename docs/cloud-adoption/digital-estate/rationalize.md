---
title: "Enterprise Cloud Adoption: Why would I rationalize my digital estate prior to a cloud migration?"
description: Descriptions of commonly used tools for assessing on-prem infrastructure
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: Why would I rationalize my digital estate prior to a cloud migration?

Cloud Rationalization is the process of evaluating assets to determine the best approach to hosting the asset in the cloud.
Once an [approach](approach.md) has been determined and [inventory](inventory.md) has been aggregated, Cloud Rationalization can begin.

At one point in time, every enterprise deploys its first application to solve a critical business problem. Fast forward several years, that first application has likely multiplied. Today's business society has an application addiction. New opportunities to accelerate the business through technology constantly arise. The larger an enterprise, the less likely the IT organization is to understand the subtle similarities between applications. This leads to duplicated solutions. Eventually those business needs change again, often times leading to a drop in usage of the once needed applications.

In a traditional on-premise environment, all of these applications live on in perpetuity as a sunk cost of operating the IT infrastructure. The cost of continued support of those applications is often outweighed by the cost and time impact of rationalizing and terminating unused applications. Transformations empowered by the cloud change this equation.

Cost is a fundamental constraint in the architecture of any cloud based system. Investing in the transformation of unused apps is wasteful. It can be equally wasteful to invest in transformations that don't produce business outcomes or outcomes that can be consumed by the business. Prior to transforming the digital estate, it is wise to rationalize the inventory to reduce cost and better plan the future state.

## Suggested approach to rationalization

The article on [assessment approach](approach.md) discussed the different approaches to assessment, which drives the rationalization process. As mentioned in that article, ECA aligns to an Incremental Approach to assessment. The following guidance similarly aligns to an incremental approach.

Cloud rationalization equates to a decision between 8 Rs. [8 Rs of rationalization](8-rs-of-rationalization.md) describes each in detail. This decision decides the fate for an application based on the transformation journey being completed.

It is suggested that the [Transformation Journey](../transformation-journeys/overview.md) serve as a guide to rationalization. Limiting the number of options helps teams more quickly reach consensus, reducing analysis paralysis.

### First steps to all transformations

The first step of any rationalization effort is to evaluate candidates for Retirement. Understanding application road maps, monitoring asset utilization, and interviewing power users can quickly identify applications that are no longer used regularly. For the sake of a cloud empowered transformation, these assets are labeled as retired. They may still live on in the data center, but are removed from any transformation efforts.

The next step to rationalization is the evaluation of candidates for Replacement. Applications that should be replaced with a modern SaaS approach, like Office365 for email hosting, can produce significant efficiencies. For the sake of a cloud empowered transformation, these assets are labeled as replace. They may still live on in the data center until a later project can upgrade the assets, but they are removed from any of the current transformation efforts.

From this point forward guidance assumes that any assets being reviewed are not slated for retirement or replacement.

### [Operational Transformation](../transformation-journeys/operational-transformation/overview.md)

Operational transformation focuses heavily on creating operational efficiencies across IT and the business. This most commonly equates to a re-host, refactor, or reconfigure decision.

During initial assessment, the decision can be simplified to one question, **"Should this asset be re-hosted?"**. If the answer is yes, it is included in the migration backlog.

In the [Assess activities](../migration/execute/assess.md) of the [Migrate process](../migration/overview.md), this question becomes slightly more complex, but can still be simplified to a few questions:

* Re-host: Based on current configuration, is the asset compatible with a re-host deployment to the selected cloud provider?
* Remediate: If not compatible, does the cost to [remediate](../migration/execute/remediate.md) exceed the value of migrating the asset?
* Refactor: For some assets, such as databases, the cost of re-factoring the solution into a PaaS solution is so low that a refactoring is warranted during transformation.
* Reconfigure: In some cases, operational gains can be generated from a devops or container based deployment. Additionally, some models of containerized deployments could change the compatibility requirements of the chosen cloud provider. In either of those cases, a reconfigure option may be more appropriate than a simple re-host.

More details regarding refactor and reconfigure are available in the [Assess activities](../migration/execute/assess.md) of the [Migrate process](../migration/overview.md).

### [Incremental Transformation](../transformation-journeys/incremental-transformation.md)

During Incremental Transformations, customers and existing applications are the most common focus. In both the initial assessment and later validation activities, it is suggested that team members focus on deciding between Refactor, Re-architect, or Re-configure options. The primary driver of this decision is based on the ability to rapidly iterate & improve experiences based on the current architecture.

When possible a refactor approach will produce results more quickly, assuming incremental development options are possible with the current architecture. 

Some applications (especially older applications) are not compatible with the cloud. Others could be architected with a sufficient degree of complexity to prevent a continuous improvement approach. In these cases, the application may need to be re-architected to achieve the desired business outcomes.

In some cases, an application may benefit from a migration into a containerized solution, without re-architecting the solution. This re-configuration option has become more common in recent years.

### [Disruptive Transformation](../transformation-journeys/disruptive-transformation.md)

Disruptive transformations often start with data as a catalyst. New ways of delivering a product or service tend to be a common outcome. In these scenarios, the data within the digital estate is often most important. Some times, existing applications can be used to accelerate disruptive changes. Each (data & apps) should be assessed.

Data could results in Rebuild/Build, Re-host, or refactor options, similar to the [Assess activities](../migration/execute/assess.md) of the [Migrate process](../migration/overview.md).

Applications could result in refactor, re-architect, or Reconfigure options, like those seen in Incremental Transformations.

## Next steps

The output of a rationalization effort is a prioritized backlog of all assets to be impacted by the chosen transformation.

This backlog is now ready to serve as the foundation for [costing models of cloud services](calculate.md).

> [!div class="nextstepaction"]
> [Price calculations for cloud services](calculate.md)