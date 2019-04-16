---
title: "CAF: Cloud Migration"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Explanation of Cloud Migration Overview
author: BrianBlanchard
ms.date: 4/4/2019
layout: LandingPage
ms.topic: landing-page
---

# Cloud migration in the Cloud Adoption Framework

Cloud migration is the process of moving existing digital assets into a cloud platform. In this approach, existing assets are replicated to the cloud with minimal modifications. When an application or workload is operational in the cloud, users are transitioned from the existing solution to the cloud solution. Cloud migration is one means of effectively balancing a cloud portfolio. Often times, this is the fastest and most agile approach, short term. Conversely, some of the benefits of the cloud may not be realized through this approach without additional future modification. Enterprises and mid-market customers use this approach to accelerate the pace of change, avoid planned capital expenditures, and reduce ongoing operational costs.

## Creating a balanced cloud portfolio

In any balanced technology portfolio, there is a mixture of assets in various states. Some applications are slated for retirement, with minimal support. Other applications or assets are supported in a maintenance state, but the features associated with those solutions are stable. For newer processes within the business, changing market conditions will likely result in ongoing feature enhancements or modernization. When opportunities to drive new revenue streams present themselves, net new applications or assets are introduced into the environment. At each stage of an asset's lifecycle, the impact any investment has on revenue and profit will change. The later an asset is in its lifecycle, the less likely a company is to see a return from a new feature or modernization investment.

The cloud provides various adoption mechanisms, each with similar degrees of investment and return. Building cloud native applications can significantly reduce operating expenses. Once a cloud native application is released, new features and solutions can iterate faster. Modernizing an application can have similar yields, by removing legacy constraints associated with on-premises development models. Unfortunately, these two approaches are labor-intensive and have a strong dependency on the size, skill, and experience of software development teams. Sadly, there is commonly a labor misalignment. The people with the skills and talent to modernize applications would much rather be building new applications. In a labor constrained market, modernization projects at scale can suffer from an employee satisfaction and talent issue. In a balanced portfolio, this approach should be reserved for applications that would receive significant feature enhancements, if they remained on-premises.

## Cloud migration guides

To start down an adoption path, choose one of the following guides. Each guide outlines a series of best practices, based on a specific reference experience based on customer feedback. For readers who are new to the incremental approach of the Cloud Adoption Framework migration model, it is advised that you review the high-level migration theory introduction below, before adopting either guide.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./azure-migration-guide/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Azure migration guide</h3>
                        <p>A guide for a migration journey involving fewer than 1,000 virtual machines and a single cloud adoption team.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./expanded-scope/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Expanded scope for cloud migration</h3>
                        <p>If the Azure migration guidance is too basic, the expanded scope scenario guides provide more intermediate guidance through the migration process.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

<!-- markdownlint-enable MD033 -->

## Establishing an end state

A journey without a target destination is just wandering. It’s important to establish a rough vision of the end state before taking the first step. The infographic below outlines a starting point consisting of existing applications, data, and infrastructure, which defines the Digital Estate. During the migration process, those assets are transitioned into one of the options on the right.

![Infographic of the migration options](../_images/migration/migration-options.png)

## Incremental migration model

This series of articles will outline two journeys, each with a similar end state: Migrate a large percentage of existing assets to Azure. However, the business outcomes and current state will heavily influence the processes required to get there. Those subtle deviations will result in two radically different approaches to reaching the a similar end state.

![Cloud Adoption Framework migration model](../_images/operational-transformation-migrate.png)

To guide incremental execution during the transition to the end state, this model breaks migration into two areas of focus.

**Migration Preparation**. Establish a rough migration backlog based largely on the current state and desired outcomes:

- **Business outcomes:** The key business objectives that necessitate this migration.
- **Digital estate estimate:** Establishes a rough idea of the number and condition of workloads to be migrated.
- **Roles and responsibilities:** An understanding of the team structure, separation of responsibilities, and access requirements.
- **Change management requirements:** Defines the cadence, processes, and documentation required to approve change management.

These initial inputs will shape the migration backlog. The output of the migration backlog will be a prioritized series of applications to be migrated to the cloud. That list of applications will shape the execution of the cloud migration process. Over time, it will also grow to include much of the documentation needed to manage change.

**Migration process:**.All activities related to cloud migration will fall into one of the following processes, as it relates to the Migration Backlog.

- **Assess:** Evaluate the existing asset and establish a plan for migration of the asset.
- **Migrate:** Replicate the functionality of an asset in the cloud.
- **Optimize:** Balance performance, cost, access, and operational capacity of the cloud asset.
- **Secure and manage:** Ensure the asset is ready for ongoing operations.

The questions asked during the development of a migration backlog will determine the complexity and level of effort required within the Cloud Migration Process during each iteration and each release of functionality.

## Transition to the end state

The desired goal is a smooth, semi-automated migration to the cloud. In such a scenario, the migration process uses the tools provided by a cloud vendor to rapidly replicate and stage assets in the cloud. Once verified a simple network change would re-route users to the cloud solution. For many use cases, the technology to reach this desired goal is largely available. There are tested cases that demonstrate the speed at which 10,000 VMs can be replicated into Azure.

Unfortunately, an **incremental migration** approach is still required. In most environments, the long list of VMs to be migrated has to be decomposed into smaller units of work for a migration to be successful. There are many factors that create limits to the number of VMs that can be migrated in a given period of time. Outbound Network speed is one of the few limiters that are technical in nature. Most of the limiters are based on the businesses ability to validate and consume change.

CAF's **incremental migration** approach empowers builds an incremental plan that documents and works within technical and cultural limiters. The goal of this model is to minimize overhead (from IT or the business), while maximizing migration velocity. Below are two examples of an incremental migration execution based on the migration backlog.

<!-- TODO: 
    Describe the paths, focusing on key differences
    Show an image of the decomposition of the Migration Backlog into Releases and or Iterations
    Describe the current state that suggested that path
     -->

<!-- TODO: 
## Choosing the right journey

The following two journeys outline migration experiences aligned to the narrative of two fictional customers. Choose the journey that best aligns to your current objectives and constraints to establish a baseline for your own migration plan.

**Simple migration:** Rapid migration approach with little overhead.

Narrative Summary: This approach consists of fewer than 1,000 VMs. Less than 10 of the applications supported are owned by an application owner who is not a part of IT. The remainder of the applications, VMs, and associated data are owned and supported by members of the Cloud Adoption Team. Members of the cloud adoption team have administrative access to the production environments in the existing datacenter.

![Example of Incremental migration evolutions](../../_images/migration/incremental-migration-example.png)

**Complex migration:** Longer term migration with greater rigor in areas of change management, and deeper process controls

Narrative Summary: This approach consists of fewer than 10,000 VMs. Applications are supported by a number of business and IT Application Owners. Central IT has established governance best practices, but prioritizes innovation over control. Administrative access to production environments is dispersed across business units to create separation of responsibility.

![Example of Incremental migration evolutions](../../_images/migration/incremental-migration-example.png)

-->

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./azure-migration-guide/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Azure migration guide</h3>
                        <p>Narrative Summary: This customer's migration consists of fewer than 1,000 VMs. Less than 10 of the applications supported are owned by an application owner who is not a part of IT. The remainder of the applications, VMs, and associated data are owned and supported by members of the Cloud Adoption Team. Members of the cloud adoption team have administrative access to the production environments in the existing datacenter.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./expanded-scope/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Complex scenario guide</h3>
                        <p>Narrative Summary: This customer's migration includes complexity across the business, culture, and technology. This guide includes a number of specific complexity challenges and ways to overcome those challenges.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

<!-- markdownlint-enable MD033 -->

These two journeys represent two extremes of experience for customers who invest in cloud migration. Most companies reflect a combination of the two scenarios above. After reviewing the journey, use the Cloud Adoption Framework migration model to start the migration conversation and modify the baseline journeys to more closely meet your needs.

## Next steps

Choose one of these journeys:

> [!div class="nextstepaction"]
> [Azure migration guide](./azure-migration-guide/index.md)
>
> [Expanded scope guide](./expanded-scope/index.md)
