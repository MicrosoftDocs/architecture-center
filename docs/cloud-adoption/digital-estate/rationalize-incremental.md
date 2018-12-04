---
title: "Enterprise Cloud Adoption: How can cloud rationalization align to business drivers?"
description: Descriptions of an approach to aligning application future state with business drivers
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: How can cloud rationalization align to business drivers?

This article focuses specifically on aligning the 5 Rs of rationalization to business drivers in a faster, incremental approach to rationalization. It is assumed that the reader has reviewed the article on [traditional rationalization](rationalize.md) to gain a general understanding of rationalization.

## Incremental Rationalization: Reduce Risk & Complexity

As outlined in [traditional rationalization](rationalize.md) the complete rationalization of a large digital estate is prone to risk and can suffers delays associated with complexity. Each of which could delay tangible business change. This article will discuss an alternative approach to traditional rationalization referred to as Incremental Rationalization. The base assumption for this model, is that delayed decisions will stagger the load on the business to reduce the risk of roadblocks. Over time, this approach creates an organic model for developing the processes and experience required to make qualified rationalization decisions and do so more efficiently.

**Inventory - Reduce Discovery Data Points:** Very few organizations invest the time, energy, and expense to maintain an accurate, real-time inventory of the full digital estate. Loss, theft, refresh cycles, and employee on-boarding often justify detailed asset tracking of end user devices. However, the return on investment (ROI) of maintaining an accurate server and application inventory in a traditional, on-prem DataCenter is often low. Most IT organizations have other more pressing issues to address that produce greater returns than tracking the usage of fixed assets in a DataCenter.

In a Cloud Transformation, inventory has a direct correlation on operating costs. Accurate inventory data is required for proper planning. Unfortunately, current environmental scanning options can delay decisions by weeks or months, to scan and catalog the full inventory. Fortunately, there are a few tricks to accelerating data collection.

Agent-based scanning is the most frequently sited delay. The robust data required for a traditional rationalization is often dependent on data that can only be collected with an agent running on each asset. The dependency on agents often slows progress as it can require feedback from security, operations, and adminstration functions. In an Incremental Rationalization process, an Agent-less solution could be used for an initial discovery to accelerate early decisions. Depending on the level of complexity in the environment, an agent-based solution may still be required, but it can be removed from the critical path to business change.

**Quantitative Analysis - Streamline Decisions:** Regardless of the approach to inventory discovery above, quantitative analysis can drive a number of initial decisions and assumptions. This is especially true when attempting to identify the first workload or when the goal of rationalization is a high level cost comparison. In an incremental rationalization process, the Cloud Strategy and Cloud Adoption Teams limit the [5 Rs of Rationalization](5-rs-of-rationalization.md) to two concise decisions and only apply those quantitative factors, streamlining the analysis and reducing the amount of initial data required to drive change. 

For instance: If an organization is in the midst of an IaaS migration to the cloud, an assumption can be made that most workloads will either be Retired or Rehosted.

**Qualitative Analysis - Temporary Assumptions:** The next wave of decisions require human intelligence in the form of qualitative analysis. Often times, these questions are unique to the solution and can only be answered by business stakeholders and/or power users. These decisions are where the process is generally delayed, slowing things down considerably. This analysis generally consumed 40-80 FTE hours per application. For guidance on building a list of Qualitative analysis questions, see the article on [Approach](approach.md) or the specific rationalization target in the article on the [5 Rs of Rationalization](5-rs-of-rationalization.md).

By reducing the number of potential outcomes, as mentioned in Quantitative Analysis paragraph above, it’s easier to get to an initial decision regarding the future state of an asset. When the options are reduced, the number of questions asked of the business at this early stage, is also reduced. 

Continuing with the example above regarding an IaaS migration to the cloud, if the options are reduced to rehost or retire, there is really only one question to ask the business during initial rationalization. "Analysis suggests that there are no users actively leveraging this asset. Is that accurate or have we overlooked something?" Such a binary question is generally much easier to run through a qualitative analysis.

> [!NOTE]
> This streamlined approach produces baselines, financial plans, strategy, & direction. In later activities, like the Assess & Architect phases of a migration process, each asset would go through further rationalization and qualitative analysis to evaluate other options. All assumptions made in this initial rationalization would be tested prior to implementation, see the next section of this article for more guidance.

## Incremental Rationalization: Challenging Assumptions

The outcome of the prior section is a rough rationalization loaded with assumptions. Next, its time to challenge some of those assumptions.

**Retire:** In a traditional on-prem environment, hosting small, unused assets seldom generates a significant impact on annual costs. With a few exceptions, the cost savings associated with pruning and retiring those assets is outweighed by the FTE effort required to analyze and retire the actual asset.

However, when moving to a cloud accounting model, retiring assets can produce significant savings in annual operating costs and up-front migration efforts.

It is not uncommon for organizations to retire 20%+ of their digital estate after the completion of a quantitative analysis. Additional qualitative analysis is suggested before deciding on such an action. Once confirmed, the retirement of those assets can produce the first ROI victory in the cloud migration. In many cases, this is one of the biggest cost saving factor. As such, it is suggested that the Cloud Strategy Team oversee the validation and retirement of assets in parallel to the Build Phase of the migration process to allow for an early financial win.

**Program Adjustments:** Seldom is a company embarking on just one transformation journey. The choice between cost reduction, market growth, and new revenue streams is seldom a binary decision. As such, it is suggested that the Cloud Strategy Team work with IT to identify assets that are on parallel transformation efforts that are outside of the scope of the primary Transformation Journey.

In the IaaS Migration example used in this article:

* Ask the DevOps team to identify assets that are already part of a deployment automation and remove those from the core migration plan.
* Ask the Data and R&D teams to identify assets that are powering new revenue streams and remove them from the core migration plan.

This program focused qualitative analysis can be executed quickly & will create alignment across multiple migration backlogs.

> [!NOTE]
> Some assets may still need to be treated like Re-host assets for a period of time, phasing in later rationalization, after the initial migration.

## Incremental Rationalization: Selecting the First Workload

Implementing the first workload is key to testing and learning. It is the first opportunity to demonstrate and build a growth mindset.

**Business Criteria:** Identify a workload that is supported by a member of the Cloud Strategy Team’s business unit to ensure business transparency. Preferably one in which the team has a vested stake and strong motivation to move to the cloud.

**Technical Criteria:** Select a workload that has minimum dependencies and can be moved as a small group of assets. It is suggested that a workload with a defined testing path be selected to ease validation.

> [!NOTE]
> The first workload is often deployed in an experimental environment with no operational or governance capacity. It is very important to select a workload that does not interact with secure data.

**Qualitative Analysis:** The Cloud Adoption Team and Cloud Strategy Team can work together on the analysis of this small workload. This creates a controlled opportunity to create and test qualitative analysis criteria. The smaller population creates an opportunity to survey the impacted users in an effort to complete a detailed qualitative analysis in a week or less. For common qualitative analysis factors see the specific rationalization target in the article on the [5 Rs of Rationalization](5-rs-of-rationalization.md).

**Migration:** In parallel to continued rationalization, the Cloud Adoption Team can begin migrating the small workload to expand learning in the following key areas:

* Strengthen skills with the cloud provider’s platform
* Define the Core services (& Azure Standards) needed to fit the long term vision
* Better understand how operations may need to evolve later in the transformation
* Understand any inherent business risks and the business' tolerance for those risks
* Establish a baseline or Minimally Viable Product (MVP) for governance based on the business' risk tolerance

## Incremental Rationalization: Release Planning

While the Cloud Adoption Team is executing the migration or implementation of the first workload, the Cloud Strategy Team can begin prioritizing the remaining applications/workloads.

**Power of Ten:** The traditional approach to rationalization attempts to boil the ocean. Fortunately, a plan for every application is often not required to start a transformation journey. In an incremental model, the Power of Ten provides a good starting point. In this model, the cloud strategy team selects the first 10 applications to be migrated. Those 10 workloads should contain a mixture of simple and complex workloads.

**Building the first backlogs:** The Cloud Adoption Team and Cloud Strategy Team can work together on the qualitative analysis for the first 10 workloads. This creates the first prioritized migration backlog and the first prioritized release backlog. This approach allows the teams to continue to iterate on the approach taken to provide sufficient time to create an adequate process for qualitative analysis.

**Maturing the process:** Once qualitative analysis criteria are agreed upon between the two teams, the process of assessment can become a task within each iteration. Reaching consensus on assessment criteria usually requires 2-3 releases.

Once the assessment is moved into the incremental execution processes of migration, the Cloud Adoption Team can iterate on assessment and architecture faster. At this stage, the Cloud Strategy Team is also abstracted, reducing the drain on their time. This also allows the Cloud Strategy Team to remain focused on prioritization of the applications that are not yet in a specific release, thus ensuring tight alignment with changing market conditions.

> [!NOTE]
> Not all ten of the prioritized applications will be ready for migration. Sequencing is likely to change, as the team performs deeper qualitative analysis and discovers business events and dependencies that would prompt for re-prioritization of the backlog.
> [!NOTE]
> Some releases may group together a small number of workloads. Others may just contain a single workload.
> [!NOTE]
> The Cloud Adoption Team is likely to run iterations that don’t produce a complete workload migration. The smaller the workload & the less dependencies, the more likely a workload is to fit into a single sprint or iteration. For this reason it is suggested that the first few applications in the release backlog be small and contain few external dependencies.

## Incremental Rationalization: End State

As time progresses, the combination of the Cloud Adoption Team and the Cloud Strategy Team will complete a full rationalization of the inventory. However, this incremental approach will allow the team to get continually faster at the rationalization process. It will also allow the Transformation Journey to yield tangible business results sooner, without as large of an upfront analysis effort.

> [!NOTE]
>In some cases, the financial model may be too tight to make a decision to act, without additional rationalization. In such cases, a more traditional approach to rationalization may be required. for guidance on traditional rationalization processes, see the article on [Traditional Rationalization](rationalize.md)

## Next steps

The output of a rationalization effort is a prioritized backlog of all assets to be impacted by the chosen transformation.

This backlog is now ready to serve as the foundation for [costing models of cloud services](calculate.md).

> [!div class="nextstepaction"]
> [Price calculations for cloud services](calculate.md)