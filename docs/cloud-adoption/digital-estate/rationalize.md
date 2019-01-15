---
title: Rationalize the digital estate
titleSuffix: Fusion
description: A process for evaluating digital assets to find the best way to host them in the cloud.
author: BrianBlanchard
ms.date: 12/10/2018
---

# Fusion: Rationalize the digital estate

Cloud rationalization is the process of evaluating assets to determine the best approach to hosting them in the cloud. Once an [approach](approach.md) has been determined and [inventory](inventory.md) has been aggregated, cloud rationalization can begin. The [5 Rs of rationalization](5-rs-of-rationalization.md) discusses the most common rationalization options.

## Traditional view of rationalization

It's easy to understand rationalization, when visualizing the traditional process of rationalization like a complex decision tree. Each asset in the digital estate is fed through a process that results in one of five answers (the 5 Rs). For small estates, this process works well. For larger estates, it's not very efficient and can lead to significant delays. Let's examine the process to see why. Then we'll present a more efficient model.

**Inventory**. A thorough inventory of assets, including applications, software, hardware, operating systems, and system performance metrics is required to complete a full rationalization using traditional models.

**Quantitative analysis**. In the decision tree, quantitative questions drive the first layer of decisions. Common questions: Is the asset in use today? If so, is it optimized and sized properly? What dependencies exist between assets? These questions are vital to classification of the inventory.

**Qualitative analysis**. The next set of decisions require human intelligence in the form of qualitative analysis. Often, these questions are unique to the solution and can only be answered by business stakeholders and power users. These decisions are where the process is generally delayed, slowing things down considerably. This analysis generally consumes 40&ndash;80 FTE hours per application. For guidance on building a list of qualitative analysis questions, see [Approaches to digital estate planning](approach.md).

**Rationalization decision**. In the hands of an experienced rationalization team, the qualitative and quantitative data creates clear decisions. Unfortunately, teams with a high degree of rationalization experience are expensive to hire or take months to train.

## Rationalization at enterprise scale

If this effort is time consuming and daunting for a 50-VM digital estate, imagine the effort required to drive business transformation in an environment with thousands of VMs and hundreds of applications. The human effort required can easily exceed 1,500 FTE hours and 9 months of planning.

While full rationalization is the end state and a great direction to move towards, it seldom produces a high ROI relative to the time and energy required.

When rationalization is essential to financial decisions, it is worth considering a professional services organization that specializes in cloud rationalization to accelerate the process. Even then, full rationalization can be a costly and time-consuming effort that could delay transformation or business outcomes.

The remainder of this article describes an alternative approach, known as incremental rationalization.

## Incremental rationalization

The complete rationalization of a large digital estate is prone to risk and can suffer delays associated with complexity. The assumption behind the incremental approach is that delayed decisions will stagger the load on the business to reduce the risk of roadblocks. Over time, this approach creates an organic model for developing the processes and experience required to make qualified rationalization decisions and do so more efficiently.

### Inventory: Reduce discovery data points

Very few organizations invest the time, energy, and expense to maintain an accurate, real-time inventory of the full digital estate. Loss, theft, refresh cycles, and employee on-boarding often justify detailed asset tracking of end-user devices. However, the return on investment (ROI) of maintaining an accurate server and application inventory in a traditional, on-premises datacenter is often low. Most IT organizations have other more pressing issues to address than tracking the usage of fixed assets in a datacenter.

In a Cloud Transformation, inventory directly correlates to operating costs. Accurate inventory data is required for proper planning. Unfortunately, current environmental scanning options can delay decisions by weeks or months, to scan and catalog the full inventory. Fortunately, there are a few tricks to accelerating data collection.

Agent-based scanning is the most frequently cited delay. The robust data required for a traditional rationalization often depends on data that can only be collected with an agent running on each asset. This dependency on agents often slows progress, as it can require feedback from security, operations, and administration functions.

In an incremental rationalization process, an agent-less solution could be used for an initial discovery to accelerate early decisions. Depending on the level of complexity in the environment, an agent-based solution may still be required, but it can be removed from the critical path to business change.

### Quantitative analysis: Streamline decisions

Regardless of the approach to inventory discovery, quantitative analysis can drive a number of initial decisions and assumptions. This is especially true when trying to identify the first workload or when the goal of rationalization is a high-level cost comparison. In an incremental rationalization process, the Cloud Strategy and Cloud Adoption teams limit the [5 Rs of Rationalization](5-rs-of-rationalization.md) to two concise decisions and only apply those quantitative factors, streamlining the analysis and reducing the amount of initial data required to drive change.

For example, if an organization is in the midst of an IaaS migration to the cloud, it can be assumed that most workloads will either be retired or rehosted.

### Qualitative analysis: Temporary assumptions

By reducing the number of potential outcomes, it’s easier to reach an initial decision about the future state of an asset. When the options are reduced, the number of questions asked of the business at this early stage is also reduced.

Continuing with the example above, if the options are limited to rehost or retire, there is really only one question to ask the business during initial rationalization &mdash; namely, whether to retire.

"Analysis suggests that there are no users actively leveraging this asset. Is that accurate or have we overlooked something?" Such a binary question is generally much easier to run through a qualitative analysis.

This streamlined approach produces baselines, financial plans, strategy, and direction. In later activities, each asset would go through further rationalization and qualitative analysis to evaluate other options. All assumptions made in this initial rationalization would be tested prior to implementation.

## Challenging assumptions

The outcome of the prior section is a rough rationalization loaded with assumptions. Next, it's time to challenge some of those assumptions.

### Retiring assets

In a traditional on-premises environment, hosting small, unused assets seldom causes a significant impact on annual costs. With a few exceptions, the cost savings associated with pruning and retiring those assets is outweighed by the FTE effort required to analyze and retire the actual asset.

However, when moving to a cloud accounting model, retiring assets can produce significant savings in annual operating costs and up-front migration efforts.

It is not uncommon for organizations to retire 20% or more of their digital estate after completing a quantitative analysis. Further qualitative analysis is suggested before deciding on such an action. Once confirmed, the retirement of those assets can produce the first ROI victory in the cloud migration. In many cases, this is one of the biggest cost saving factors. As such, it's suggested that the Cloud Strategy team oversee the validation and retirement of assets, in parallel to the build phase of the migration process, to allow for an early financial win.

### Program adjustments

A company seldom embarks on just one transformation journey. The choice between cost reduction, market growth, and new revenue streams is rarely a binary decision. As such, it's suggested that the Cloud Strategy team work with IT to identify assets on parallel transformation efforts that are outside of the scope of the primary Transformation Journey.

In the IaaS Migration example used in this article:

- Ask the DevOps team to identify assets that are already part of a deployment automation and remove those from the core migration plan.

- Ask the Data and R&D teams to identify assets that are powering new revenue streams and remove them from the core migration plan.

This program-focused qualitative analysis can be executed quickly and will create alignment across multiple migration backlogs.

Some assets may still need to be treated like rehost assets for a period of time, phasing in later rationalization, after the initial migration.

## Selecting the first workload

Implementing the first workload is key to testing and learning. It is the first opportunity to demonstrate and build a growth mindset.

### Business criteria

Identify a workload that is supported by a member of the Cloud Strategy team’s business unit to ensure business transparency. Preferably chose one in which the team has a vested stake and strong motivation to move to the cloud.

### Technical criteria

Select a workload that has minimum dependencies and can be moved as a small group of assets. It's suggested that a workload with a defined testing path be selected to ease validation.

The first workload is often deployed in an experimental environment with no operational or governance capacity. It's very important to select a workload that does not interact with secure data.

### Qualitative analysis

The Cloud Adoption and Cloud Strategy teamss can work together to analyze this small workload. This creates a controlled opportunity to create and test qualitative analysis criteria. The smaller population creates an opportunity to survey the impacted users, to complete a detailed qualitative analysis in a week or less. For common qualitative analysis factors, see the specific rationalization target in the [5 Rs of Rationalization](5-rs-of-rationalization.md).

### Migration

In parallel to continued rationalization, the Cloud Adoption team can begin migrating the small workload to expand learning in the following key areas:

- Strengthen skills with the cloud provider’s platform.
- Define the core services (and Azure standards) needed to fit the long term vision.
- Better understand how operations may need to evolve later in the transformation.
- Understand any inherent business risks and the business' tolerance for those risks.
- Establish a baseline or minimally viable product (MVP) for governance based on the business' risk tolerance

## Release Planning

While the Cloud Adoption team is executing the migration or implementation of the first workload, the Cloud Strategy team can begin prioritizing the remaining applications/workloads.

### Power of Ten

The traditional approach to rationalization attempts to boil the ocean. Fortunately, a plan for every application is often not required to start a transformation journey. In an incremental model, the Power of Ten provides a good starting point. In this model, the cloud strategy team selects the first ten applications to be migrated. Those ten workloads should contain a mixture of simple and complex workloads.

### Building the first backlogs

The Cloud Adoption and Cloud Strategy teams can work together on the qualitative analysis for the first ten workloads. This creates the first prioritized migration backlog and the first prioritized release backlog. This approach allows the teams to iterate on the approach, and provides sufficient time to create an adequate process for qualitative analysis.

### Maturing the process

Once the two teams agree on the qualitative analysis criteria, assessment can become a task within each iteration. Reaching consensus on assessment criteria usually requires 2&ndash;3 releases.

Once the assessment is moved into the incremental execution processes of migration, the Cloud Adoption team can iterate on assessment and architecture faster. At this stage, the Cloud Strategy team is also abstracted, reducing the drain on their time. This also allows the Cloud Strategy team to focus on prioritizing the applications that are not yet in a specific release, thus ensuring tight alignment with changing market conditions.

Not all of the prioritized applications will be ready for migration. Sequencing is likely to change, as the team performs deeper qualitative analysis and discovers business events and dependencies that would prompt for re-prioritization of the backlog. Some releases may group together a small number of workloads. Others may just contain a single workload.

The Cloud Adoption team is likely to run iterations that don’t produce a complete workload migration. The smaller the workload, and the fewer dependencies, the more likely a workload is to fit into a single sprint or iteration. For this reason, it's suggested that the first few applications in the release backlog be small and contain few external dependencies.

## End state

Over time, the combination of the Cloud Adoption and the Cloud Strategy teams will complete a full rationalization of the inventory. However, this incremental approach allows the teams to get continually faster at the rationalization process. It also allows the Transformation Journey to yield tangible business results sooner, without as large of an upfront analysis effort.

In some cases, the financial model may be too tight to make a decision to act, without additional rationalization. In such cases, a more traditional approach to rationalization may be required.

## Next steps

The output of a rationalization effort is a prioritized backlog of all assets to be impacted by the chosen transformation. This backlog is now ready to serve as the foundation for costing models of cloud services.

> [!div class="nextstepaction"]
> [Align cost models with the digital estate](calculate.md)