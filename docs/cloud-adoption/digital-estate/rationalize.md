---
title: "Rationalize the digital estate"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Evaluate your digital assets to determine how best to host them in the cloud.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
ms.custom: governance
---

# Rationalize the digital estate

Cloud rationalization is the process of evaluating assets to determine the best approach to hosting them in the cloud. After you've determined an [approach](approach.md) and aggregated an [inventory](inventory.md), cloud rationalization can begin. [Cloud rationalization](rationalize.md) discusses the most common rationalization options.

## Traditional view of rationalization

It's easy to understand rationalization when you visualize the traditional process of rationalization as a complex decision tree. Each asset in the digital estate is fed through a process that results in one of five answers (the five Rs). For small estates, this process works well. For larger estates, it's inefficient and can lead to significant delays. Let's examine the process to see why. Then we'll present a more efficient model.

**Inventory:** A thorough inventory of assets, including applications, software, hardware, operating systems, and system performance metrics, is required for completing a full rationalization by using traditional models.

**Quantitative analysis:** In the decision tree, quantitative questions drive the first layer of decisions. Common questions include the following: Is the asset in use today? If so, is it optimized and sized properly? What dependencies exist between assets? These questions are vital to the classification of the inventory.

**Qualitative analysis:** The next set of decisions requires human intelligence in the form of qualitative analysis. Often, the questions that come up here are unique to the solution and can only be answered by business stakeholders and power users. These decisions typically delay the process, slowing things down considerably. This analysis generally consumes 40 to 80 FTE hours per application.

For guidance about building a list of qualitative analysis questions, see [Approaches to digital estate planning](approach.md).

**Rationalization decision:** In the hands of an experienced rationalization team, the qualitative and quantitative data creates clear decisions. Unfortunately, teams with a high degree of rationalization experience are expensive to hire or take months to train.

## Rationalization at enterprise scale

If this effort is time consuming and daunting for a 50-VM digital estate, imagine the effort that's required to drive business transformation in an environment with thousands of VMs and hundreds of applications. The human effort required can easily exceed 1,500 FTE hours and nine months of planning.

While full rationalization is the end state and a great direction to move in, it seldom produces a high ROI (return on investment) relative to the time and energy that's required.

When rationalization is essential to financial decisions, it's worth considering a professional services organization that specializes in cloud rationalization to accelerate the process. Even then, full rationalization can be a costly and time-consuming effort that delays transformation or business outcomes.

The rest of this article describes an alternative approach, known as incremental rationalization.

## Incremental rationalization

The complete rationalization of a large digital estate is prone to risk and can suffer delays because of its complexity. The assumption behind the incremental approach is that delayed decisions stagger the load on the business to reduce the risk of roadblocks. Over time, this approach creates an organic model for developing the processes and experience required to make qualified rationalization decisions more efficiently.

### Inventory: Reduce discovery data points

Few organizations invest the time, energy, and expense in maintaining an accurate, real-time inventory of the full digital estate. Loss, theft, refresh cycles, and employee on-boarding often justify detailed asset tracking of end-user devices. However, the ROI of maintaining an accurate server and application inventory in a traditional, on-premises datacenter is often low. Most IT organizations have other more pressing issues to address than tracking the usage of fixed assets in a datacenter.

In a cloud transformation, inventory directly correlates to operating costs. Accurate inventory data is required for proper planning. Unfortunately, current environmental scanning options can delay decisions by weeks or months. Fortunately, a few tricks can accelerate data collection.

Agent-based scanning is the most frequently cited delay. The robust data that's required for a traditional rationalization can often only be collected with an agent running on each asset. This dependency on agents often slows progress, because it can require feedback from security, operations, and administration functions.

In an incremental rationalization process, an agent-less solution could be used for an initial discovery to accelerate early decisions. Depending on the level of complexity in the environment, an agent-based solution might still be required. However, it can be removed from the critical path to business change.

### Quantitative analysis: Streamline decisions

Regardless of the approach to inventory discovery, quantitative analysis can drive initial decisions and assumptions. This is especially true when trying to identify the first workload or when the goal of rationalization is a high-level cost comparison. In an incremental rationalization process, the cloud strategy team and the cloud adoption teams limit the [five Rs of rationalization](5-rs-of-rationalization.md) to two concise decisions and only apply those quantitative factors. This streamlines the analysis and reduces the amount of initial data that's required to drive change.

For example, if an organization is in the midst of an IaaS migration to the cloud, you can assume that most workloads will either be retired or rehosted.

### Qualitative analysis: Temporary assumptions

By reducing the number of potential outcomes, it’s easier to reach an initial decision about the future state of an asset. When you reduce the options, you also reduce the number of questions asked of the business at this early stage.

For example, if the options are limited to rehosting or retiring, the business needs to answer only one question during initial rationalization, which is whether to retire the asset.

"Analysis suggests that no users are actively using this asset. Is that accurate, or have we overlooked something?" Such a binary question is typically much easier to run through qualitative analysis.

This streamlined approach produces baselines, financial plans, strategy, and direction. In later activities, each asset goes through further rationalization and qualitative analysis to evaluate other options. All assumptions that you make in this initial rationalization are tested before

## Challenge assumptions

The outcome of the prior section is a rough rationalization that's full of assumptions. Next, it's time to challenge some of those assumptions.

### Retire assets

In a traditional on-premises environment, hosting small, unused assets seldom causes a significant impact on annual costs. With a few exceptions, FTE effort that's required to analyze and retire the actual asset outweighs the cost savings from pruning and retiring those assets.

However, when you move to a cloud accounting model, retiring assets can produce significant savings in annual operating costs and up-front migration efforts.

It's not uncommon for organizations to retire 20% or more of their digital estate after completing a quantitative analysis. We recommend doing further qualitative analysis before deciding on such an action. After it's confirmed, the retirement of those assets can produce the first ROI victory in the cloud migration. In many cases, this is one of the biggest cost-saving factors. As such, we recommend that the cloud strategy team oversee the validation and retirement of assets, in parallel with the build phase of the migration process, to allow for an early financial win.

### Program adjustments

A company seldom embarks on just one transformation journey. The choice between cost reduction, market growth, and new revenue streams is rarely a binary decision. As such, we recommend that the cloud strategy team work with IT to identify assets on parallel transformation efforts that are outside of the scope of the primary transformation journey.

In the IaaS migration example given in this article:

- Ask the DevOps team to identify assets that are already part of a deployment automation and remove those assets from the core migration plan.

- Ask the Data and R&D teams to identify assets that are powering new revenue streams and remove them from the core migration plan.

This program-focused qualitative analysis can be executed quickly and creates alignment across multiple migration backlogs.

You might still need to consider some assets as rehost assets for a while. You can phase in later rationalization after the initial migration.

## Select the first workload

Implementing the first workload is key to testing and learning. It's the first opportunity to demonstrate and build a growth mindset.

### Business criteria

To ensure business transparency, identify a workload that is supported by a member of the cloud strategy team’s business unit. Preferably choose one in which the team has a vested stake and strong motivation to move to the cloud.

### Technical criteria

Select a workload that has minimum dependencies and can be moved as a small group of assets. We recommend that you select a workload with a defined testing path to make validation easier.

The first workload is often deployed in an experimental environment with no operational or governance capacity. It's important to select a workload that doesn't interact with secure data.

### Qualitative analysis

The cloud adoption teams and the cloud strategy team can work together to analyze this small workload. This collaboration creates a controlled opportunity to create and test qualitative analysis criteria. The smaller population creates an opportunity to survey the affected users, and to complete a detailed qualitative analysis in a week or less. For common qualitative analysis factors, see the specific rationalization target in the [5 Rs of rationalization](5-rs-of-rationalization.md).

### Migration

In parallel with continued rationalization, the cloud adoption team can begin migrating the small workload to expand learning in the following key areas:

- Strengthen skills with the cloud provider’s platform.
- Define the core services (and Azure standards) needed to fit the long-term vision.
- Better understand how operations might need to change later in the transformation.
- Understand any inherent business risks and the business' tolerance for those risks.
- Establish a baseline or minimum viable product (MVP) for governance based on the business' risk tolerance.

## Release planning

While the cloud adoption team is executing the migration or implementation of the first workload, the cloud strategy team can begin prioritizing the remaining applications and workloads.

### Power of 10

The traditional approach to rationalization attempts to meet all foreseeable needs. Fortunately, a plan for every application is often not required to start a transformation journey. In an incremental model, the Power of 10 provides a good starting point. In this model, the cloud strategy team selects the first 10 applications to be migrated. Those ten workloads should contain a mixture of simple and complex workloads.

### Build the first backlogs

The cloud adoption teams and the cloud strategy team can work together on the qualitative analysis for the first 10 workloads. This effort creates the first prioritized migration backlog and the first prioritized release backlog. This method enables the teams to iterate on the approach and provides sufficient time to create an adequate process for qualitative analysis.

### Mature the process

After the two teams agree on the qualitative analysis criteria, assessment can become a task within each iteration. Reaching consensus on assessment criteria usually requires two to three releases.

After the assessment has moved into the incremental execution process of migration, the cloud adoption team can iterate faster on assessment and architecture. At this stage, the cloud strategy team is also abstracted, which reduces the drain on their time. This also enables the cloud strategy team to focus on prioritizing the applications that are not yet in a specific release, which ensures tight alignment with changing market conditions.

Not all of the prioritized applications will be ready for migration. Sequencing is likely to change as the team does deeper qualitative analysis and discovers business events and dependencies that might prompt reprioritization of the backlog. Some releases might group together a small number of workloads. Others might just contain a single workload.

The cloud adoption team is likely to run iterations that don’t produce a complete workload migration. The smaller the workload, and the fewer dependencies, the more likely a workload is to fit into a single sprint or iteration. For this reason, we recommend that the first few applications in the release backlog be small and contain few external dependencies.

## End state

Over time, the combination of the cloud adoption team and the cloud strategy team will complete a full rationalization of the inventory. However, this incremental approach enables the teams to get continually faster at the rationalization process. It also helps the transformation journey to yield tangible business results sooner, without as much upfront analysis effort.

In some cases, the financial model might be too tight to make a decision without additional rationalization. In such cases, you might need a more traditional approach to rationalization.

## Next steps

The output of a rationalization effort is a prioritized backlog of all assets that are affected by the chosen transformation. This backlog is now ready to serve as the foundation for costing models of cloud services.

> [!div class="nextstepaction"]
> [Align cost models with the digital estate](calculate.md)
