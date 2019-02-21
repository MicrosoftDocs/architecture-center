---
title: "CAF: Migration Customer Journeys Overview"
description: Explanation of Migration Customer Journeys Overview
author: BrianBlanchard
ms.date: 2/11/2019
layout: LandingPage
ms.topic: landing-page
---

# Actionable migration journeys

The migration journeys in this section illustrate the incremental approach of the CAF migration model. You can establish an agile migration platform that will evolve to meet the needs of any cloud migration scenario.

## Review and adopt cloud migration best practices

To start down an adoption path, choose one of the following journeys. Each journey outlines a series of best practices, based on a set of fictional customer experiences. For readers who are new to the incremental approach of the CAF migration model, it is advised that you review the high level migration theory introduction below, before adopting either best practice.

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./simple-path/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Simple Migration</h3>
                        <p>A migration journey involving fewer than 1,000 virtual machines and single cloud adoption team.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./large-enterprise/overview.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Complex Migration</h3>
                        <p>A migration journey for enterprises which exceed 1,000 virtual machines, have multiple adoption teams, and/or clear separation of duties.</p>
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

![Infographic of the migration options](../../_images/migration/migrate-options.png)

## Incremental Migration Model

This series of articles will outline two journeys, each with a similar end state: Migrate a large percentage of existing assets to Azure. However, the business outcomes and current state will heavily influence the processes required to get there. Those subtle deviations will result in two radically different approaches to reaching the a similar end state.

To guide incremental execution during the transition to the end state, this model breaks migration into two areas of focus.

**Migration Preparation**. Establish a rough migration backlog based largely on the current state and desired outcomes:

- Business Outcomes: The key business objectives that necessitate this migration
- Digital Estate Estimate: Establish a rough idea of the number and condition of assets to be migrated
- Roles and Responsibilities: Understanding of the team structure, separation of responsibilities, and access requirements
- Change Management Requirements: Define the cadence, processes, and documentation required to approve change management

These three initial inputs will shape the Migration Backlog. The output of the migration backlog will be a prioritized series of applications to be migrated to the cloud. That list of applications will shape the execution of the cloud migration process. Over time, it will also grow to include much of the documentation needed to manage change.

**Migration Process**. All activities related to cloud migration will fall into one of the following processes, as it relates to the Migration Backlog.

- Assess: Evaluate the existing asset and establish a plan for migration of the asset
- Migrate: Replicate the functionality of an asset in the cloud
- Optimize: Balance performance, cost, access, and operational capacity of the cloud asset
- Secure and Manage: Ensure the asset is ready for on-going operations

The questions asked during the development of a migration backlog will determine the complexity and level of effort required within the Cloud Migration Process during each iteration and each release of functionality.

## Transition to the end state

The desired goal is a smooth, semi-automated migration to the cloud. In such a scenario, the migration process would leverage the tools provided by a cloud vendor to rapidly replicate and stage assets in the cloud. Once verified a simple network change would re-route users to the cloud solution. For many use cases, the technology to reach this desired goal is largely available. There are tested cases that demonstrate the speed at which 10,000 VMs can be replicated into Azure.

Unfortunately, an **incremental migration** approach is still required. In most environments, the long list of VMs to be migrated has to be decomposed into smaller units of work for a migration to be successful. There are many factors that create limits to the number of VMs that can be migrated in a given period of time. Outbound Network speed is one of the few limiters that are technical in nature. Most of the limiters are based on the businesses ability to validate and consume change.

CAF's **incremental migration** approach empowers builds an incremental plan that documents and works within technical and cultural limiters. The goal of this model is to minimize overhead (from IT or the business), while maximizing migration velocity. Below are two examples of an incremental migration execution based on the migration backlog.

<!-- TODO: 
    Describe the paths, focusing on key differences
    Show an image of the decomposition of the Migration Backlog into Releases and or Iterations
    Describe the current state that suggested that path
     -->

<!-- TODO: 
**Simple Migration**: TODO:

This approach consists of fewer than 1,000 VMs. Less than 10 of the applications supported are owned by an application owner who is not a part of IT. The remainder of the applications, VMs, and associated data are owned and supported by members of the Cloud Adoption Team. Members of the cloud adoption team have administrative access to the production environments in the existing data center.

![Example of Incremental migration evolutions](../../_images/migration/incremental-migration-example.png)

-->

<!-- markdownlint-disable MD033 -->

<ul class="panelContent cardsZ">
<li style="display: flex; flex-direction: column;">
    <a href="./simple-migration/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Simple Migration</h3>
                        <p>A migration journey involving fewer than 1,000 virtual machines and single cloud adoption team.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="./complex-migration/index.md" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardText">
                        <h3>Complex Migration</h3>
                        <p>A migration journey for enterprises which exceed 1,000 virtual machines, have multiple adoption teams, and/or clear separation of duties.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

<!-- markdownlint-enable MD033 -->

These two journeys represent two extremes of experience for customers who invest in cloud migration. Most companies reflect a combination of the two scenarios above. After reviewing the journey, use the CAF migration model to start the migration conversation and modify the baseline journeys to more closely meet your needs.

## Next steps

Choose one of these journeys:

> [!div class="nextstepaction"]
> [Simple Migration](./simple-migration/index.md)
>
> [Complex Migration](./complex-migration/index.md)
