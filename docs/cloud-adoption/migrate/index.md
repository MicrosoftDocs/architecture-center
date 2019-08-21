---
title: "Cloud migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Cloud migration in the Cloud Adoption Framework
author: BrianBlanchard
ms.date: 04/04/2019
layout: LandingPage
ms.topic: landing-page
---

# Cloud migration in the Cloud Adoption Framework

Cloud migration is the process of moving existing digital assets to a cloud platform. Existing assets are replicated to the cloud with minimal modifications. Once an application or workload becomes operational in the cloud, users are transitioned from the existing solution to the cloud solution. Cloud migration is one way to effectively balance a cloud portfolio. This is often the fastest and most agile approach in the short term. Conversely, some benefits of the cloud may not be realized without additional future modification. Enterprises and mid-market customers use this approach to accelerate the pace of change, avoid planned capital expenditures, and reduce ongoing operational costs.

## Creating a balanced cloud portfolio

Any balanced technology portfolio has a mixture of assets in various states. Some applications are scheduled for retirement and given minimal support. Other applications or assets are supported in a maintenance state, but the features of those solutions are stable. For newer business processes, changing market conditions will likely spur ongoing feature enhancements or modernization. When opportunities to drive new revenue streams arise, new applications or assets are introduced into the environment. At each stage of an asset's lifecycle, the impact any investment has on revenue and profit will change. The later the lifecycle stage, the less likely a new feature or modernization effort will yield a strong return on investment.

The cloud provides various adoption mechanisms, each with similar degrees of investment and return. Building cloud-native applications can significantly reduce operating expenses. Once a cloud-native application is released, development of new features and solutions can iterate faster. Modernizing an application can yield similar benefits by removing legacy constraints associated with on-premises development models. Unfortunately, these two approaches are labor-intensive and depend on the size, skill, and experience of software development teams. Often, labor is misaligned&mdash;people with the skills and talent to modernize applications would rather build new applications. In a labor-constrained market, large-scale modernization projects can suffer from an employee satisfaction and talent issue. In a balanced portfolio, this approach should be reserved for applications that would receive significant feature enhancements if they remained on-premises.

## Cloud migration guides

To start down an adoption path, choose one of the following guides. Each guide provides a series of best practices based on a specific reference experience and customer feedback. Readers unfamiliar with the incremental approach of the Cloud Adoption Framework migration model should review the high-level migration theory introduction below before adopting either guide.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
    <li style="display: flex; flex-direction: column;">
        <a href="./azure-migration-guide/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
            <div class="cardSize" style="flex: 1 0 auto; display: flex;">
                <div class="cardPadding" style="display: flex;">
                    <div class="card">
                        <div class="cardText">
                            <h3>Azure migration guide</h3>
                            <p>A guide for a migration journey involving a single cloud adoption team and fewer than 1,000 virtual machines.</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li style="display: flex; flex-direction: column;">
        <a href="./expanded-scope/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
            <div class="cardSize" style="flex: 1 0 auto; display: flex;">
                <div class="cardPadding" style="display: flex;">
                    <div class="card">
                        <div class="cardText">
                            <h3>Expanded scope for cloud migration</h3>
                            <p>When the Azure migration guide is too basic for your scenario, the expanded scope scenario guides provide more intermediate guidance through the migration process.</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

<!-- markdownlint-enable MD033 -->

## Establishing an end state

An effective journey needs a target destination. Establish a rough vision of the end state before taking the first step. This infographic outlines a starting point consisting of existing applications, data, and infrastructure, which defines the digital estate. During the migration process, each asset is transitioned via one of the options on the right.

![Infographic of the migration options](../_images/migration/migration-options.png)

## Migration implementation

These articles outlines two journeys, each with a similar goal&mdash;to migrate a large percentage of existing assets to Azure. However, the business outcomes and current state will significantly influence the processes required to get there. Those subtle deviations result in two radically different approaches to reaching a similar end state.

![Cloud Adoption Framework migration model](../_images/operational-transformation-migrate.png)

To guide incremental execution during the transition to the end state, this model separates migration into two areas of focus.

**Migration preparation:** Establish a rough migration backlog based largely on the current state and desired outcomes.

- **Business outcomes:** The key business objectives driving this migration.
- **Digital estate estimate:** A rough estimate of the number and condition of workloads to be migrated.
- **Roles and responsibilities:** A clear definition of the team structure, separation of responsibilities, and access requirements.
- **Change management requirements:** The cadence, processes, and documentation required to review and approve changes.

These initial inputs shape the migration backlog. The output of the migration backlog is a prioritized list of applications to migrate to the cloud. That list shapes the execution of the cloud migration process. Over time, it will also grow to include much of the documentation needed to manage change.

**Migration process:** Each cloud migration activity is contained in one of the following processes, as it relates to the migration backlog.

- **Assess:** Evaluate an existing asset and establish a plan for migration of the asset.
- **Migrate:** Replicate the functionality of an asset in the cloud.
- **Optimize:** Balance the performance, cost, access, and operational capacity of a cloud asset.
- **Secure and manage:** Ensure a cloud asset is ready for ongoing operations.

The information gathered during development of a migration backlog determines the complexity and level of effort required within the cloud migration process during each iteration and for each release of functionality.

## Transition to the end state

The goal is a smooth and partly automated migration to the cloud. The migration process uses the tools provided by a cloud vendor to rapidly replicate and stage assets in the cloud. Once verified a simple network change reroutes users to the cloud solution. For many use cases, the technology to achieve this goal is largely available. There are example cases that demonstrate the speed at which 10,000 VMs can be replicated in Azure.

However, an incremental migration approach is still required. In most environments, the long list of VMs to be migrated must be decomposed into smaller units of work for a migration to be successful. There are many factors that limit the number of VMs that can be migrated in a given period. Outbound network speed is one of the few technical limits; most of the limits are imposed the business's ability to validate and adapt to change.

The incremental migration approach of the Cloud Adoption Framework helps build an incremental plan that reflects and documents technical and cultural limitations. The goal of this model is to maximize migration velocity while minimizing overhead from both IT and the business. Provided below are two examples of an incremental migration execution based on the migration backlog.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./azure-migration-guide/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Azure migration guide</h3>
                        <p><b>Narrative summary:</b> This customer is migrating fewer than 1,000 VMs. Fewer than ten applications supported are owned by an application owner not in the IT organization. The remaining applications, VMs, and associated data are owned and supported by members of the cloud adoption team. Members of the cloud adoption team have administrative access to the production environments in the existing datacenter.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./expanded-scope/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Complex scenario guide</h3>
                        <p><b>Narrative summary:</b> This customer's migration has complexity across the business, culture, and technology. This guide includes multiple specific complexity challenges and ways to overcome those challenges.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

<!-- markdownlint-enable MD033 -->

These two journeys represent two extremes of experience for customers who invest in cloud migration. Most companies reflect a combination of the two scenarios above. After reviewing the journeys, use the Cloud Adoption Framework migration model to start the migration conversation and modify the baseline journeys to more closely meet your needs.

## Next steps

Choose one of these journeys:

> [!div class="nextstepaction"]
> [Azure migration guide](./azure-migration-guide/index.md)
>
> [Expanded scope guide](./expanded-scope/index.md)
