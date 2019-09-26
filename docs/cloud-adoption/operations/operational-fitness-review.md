---
title: "Establish an operational fitness review"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Guidance on operational fundamentals
author: BrianBlanchard
ms.author: brblanch
ms.date: 09/20/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: operate
---

# Establish an operational fitness review

As your enterprise begins to operate workloads in Azure, the next step is to establish a process for *operational fitness review*. This process enumerates, implements, and iteratively reviews the *nonfunctional requirements* for these workloads. Nonfunctional requirements are related to the expected operational behavior of the service.

There are five essential categories of nonfunctional requirements, which are called the [pillars of software quality](../../guide/pillars.md):

- Scalability
- Availability
- Resiliency, including business continuity and disaster recovery
- Management
- Security

A process for operational fitness review ensures that your mission-critical workloads meet the expectations of your business with respect to the quality pillars.

Your enterprise should create a process for operational fitness review to fully understand the problems that result from running workloads in a production environment, determine how to remediate those problems, and resolve them. This article outlines a high-level process for operational fitness review that your enterprise can use to achieve this goal.

## Operational fitness at Microsoft

From the outset, the development of the Azure platform has been a continuous project undertaken by many teams across Microsoft. It's difficult to ensure quality and consistency for a project of such size and complexity. A robust process is needed to enumerate and implement fundamental nonfunctional requirements on a regular basis.

The processes that Microsoft follows form the basis for the processes outlined in this article.

## Understand the problem

As you learned in [Getting started](../../cloud-adoption/getting-started/index.md), the first step in an enterprise's digital transformation is to identify the business problems to be solved by adopting Azure. The next step is to determine a high-level solution to the problem, such as migrating a workload to the cloud or adapting an existing, on-premises service to include cloud functionality. Finally, the solution is designed and implemented.

During this process, the focus is often on the features of the service: the set of _functional_ requirements that you want the service to perform. For example, a product-delivery service requires features for determining the source and destination locations of the product, tracking the product during delivery, customer notifications, and others.

The _nonfunctional_ requirements, in contrast, relate to properties such as the service's [availability](../../checklist/availability.md), [resiliency](../../resiliency/index.md), and [scalability](../../checklist/scalability.md). These properties differ from the functional requirements because they don't directly affect the final function of any particular feature in the service. However, nonfunctional requirements do relate to the performance and continuity of the service.

Some nonfunctional requirements can be specified in terms of a service-level agreement (SLA). For service continuity, as an example, an availability requirement for the service can be expressed as a percentage: "Available 99.99% of the time". Other nonfunctional requirements might be more difficult to define and might change as production needs change. For example, a consumer-oriented service might face unanticipated throughput requirements after a surge of popularity.

> [!NOTE]
> Requirements for resiliency are explored in more depth in [Designing reliable Azure applications](../../reliability/index.md#define-requirements). That article includes explanations of concepts like recovery-point objective (RPO), recovery-time objective (RTO), SLA, and others.

## Process for operational fitness review

The key to maintaining the performance and continuity of an enterprise's services is to implement a process for operational fitness review.

![An overview of the process for operational fitness review](_images/ofr-flow.png)

At a high level, the process has two phases. In the *prerequisites phase*, the requirements are established and mapped to supporting services. This phase occurs infrequently: perhaps annually or when new operations are introduced. The output of the prerequisites phase is used in the *flow phase*. The flow phase occurs more frequently: we recommend monthly.

### Prerequisites phase

The steps in this phase capture the requirements for conducting a regular review of the important services.

1. **Identify critical business operations**. Identify the enterprise's mission-critical business operations. Business operations are independent from any supporting service functionality. In other words, business operations represent the actual activities that the business needs to perform and that are supported by a set of IT services.

    The term *mission-critical* (or *business critical*) reflects a severe impact on the business if the operation is impeded. For example, an online retailer might have a business operation, such as "enable a customer to add an item to a shopping cart" or "process a credit card payment." If either of these operations fails, a customer can't complete the transaction and the enterprise fails to realize sales.

1. **Map operations to services**. Map the critical business operations to the services that support them. In the shopping-cart example, several services might be involved: an inventory stock-management service, a shopping-cart service, and others. To process a credit-card payment, an on-premises payment service might interact with a third-party, payment-processing service.

1. **Analyze service dependencies**. Most business operations require orchestration among multiple supporting services. It's important to understand the dependencies between the services and the flow of mission-critical transactions through these services.

    Also consider the dependencies between on-premises services and Azure services. In the shopping-cart example, the inventory stock-management service might be hosted on-premises and ingest data entered by employees from a physical warehouse. However, it might store data off-premises in an Azure service, such as [Azure Storage](/azure/storage/common/storage-introduction), or a database, such as [Azure Cosmos DB](/azure/cosmos-db/introduction).

An output from these activities is a set of *scorecard metrics* for service operations. The metrics are categorized in terms of nonfunctional criteria, such as availability, scalability, and disaster recovery. Scorecard metrics express the operational criteria that the service is expected to meet. These metrics can be expressed at any level of granularity that's appropriate for the service operation.

The scorecard should be expressed in simple terms to facilitate meaningful discussion between the business owners and engineering. For example, a scorecard metric for scalability could be expressed in green for meeting the defined criteria, yellow for failing to meet the defined criteria but actively implementing a planned remediation, or red for failing to meet the defined criteria with no plan or action.

It's important to emphasize that these metrics should directly reflect business needs.

### Service-review phase

The service-review phase is the core of the operational fitness review. It involves these steps:

1. **Measure service metrics**. Use the scorecard metrics to monitor the services, to ensure that the services meet the business expectations. In other words, service monitoring is essential. If you can't monitor a set of services with respect to the nonfunctional requirements, consider the corresponding scorecard metrics to be red. In this case, the first step for remediation is to implement the appropriate service monitoring. For example, if the business expects a service to operate with 99.99% availability, but there is no production telemetry in place to measure availability, assume that you're not meeting the requirement.

2. **Plan remediation**. For each service operation for which metrics fall below an acceptable threshold, determine the cost of remediating the service to bring operation to an acceptable level. If the cost of remediating the service is greater than the expected revenue generation of the service, move on to consider the intangible costs, such as customer experience. For example, if customers have difficulty placing a successful order by using the service, they might choose a competitor instead.

3. **Implement remediation**. After the business owners and engineering agree on a plan, implement it. Report the status of the implementation whenever your review scorecard metrics.

This process is iterative, and ideally your enterprise has a team dedicated to it. This team should meet regularly to review existing remediation projects, kick off the fundamental review of new workloads, and track the enterprise's overall scorecard. The team should also have the authority to hold remediation teams accountable if they're behind schedule or fail to meet metrics.

## Structure of the review team

The team responsible for operational fitness review is composed of the following roles:

- **Business owner**: Provides knowledge of the business to identify and prioritize each mission-critical business operation. This role also compares the mitigation cost to the business impact and drives the final decision on remediation.

- **Business advocate**: Breaks down business operations into discreet parts and maps those parts to services and infrastructure, whether on-premises or in the cloud. The role requires deep knowledge of the technology associated with each business operation.

- **Engineering owner**: Implements the services associated with the business operation. These individuals might participate in the design, implementation, and deployment of any solutions for nonfunctional requirement problems that are uncovered by the review team.

- **Service owner**. Operates the business's applications and services. These individuals collect logging and usage data for these applications and services. This data is used both to identify problems and to verify fixes after they're deployed.

## Review meeting

We recommend that your review team meet on a regular basis. For example, the team could meet monthly and then report status and metrics to senior leadership on a quarterly basis.

Adapt the details of the process and meeting to fit your specific needs. We recommend the following tasks as a starting point:

1. The business owner and business advocate enumerate and determine the nonfunctional requirements for each business operation, with input from the engineering and service owners. For business operations that have been identified previously, the priority is reviewed and verified. For new business operations, a priority is assigned in the existing list.

2. The engineering and service owners map the current state of business operations to the corresponding on-premises and cloud services. The mapping is a list of the components in each service, oriented as a dependency tree. After the list and dependency tree have been generated, the critical paths through the tree are determined.

3. The engineering and service owners review the current state of operational logging and monitoring for the services listed in the previous step. Robust logging and monitoring are critical: they identify service components that contribute to a failure to meet nonfunctional requirements. If sufficient logging and monitoring aren't in place, a plan must be created and implemented to put them in place.

4. Scorecard metrics are created for new business operations. The scorecard consists of the list of constituent components for each service identified in step 2. It's aligned with the nonfunctional requirements and includes a measure of how well each component meets the requirements.

5. For constituent components that fail to meet nonfunctional requirements, a high-level solution is designed and an engineering owner is assigned. At this point, the business owner and business advocate establish a budget for the remediation work, based on the expected revenue of the business operation.

6. Finally, a review is conducted of the ongoing remediation work. Each of the scorecard metrics for work in progress is reviewed against the expected criteria. For constituent components that meet metric criteria, the service owner presents logging and monitoring data to confirm that the criteria are met. For those constituent components that don't meet metric criteria, each engineering owner explains the problems that are preventing criteria from being met and presents any new designs for remediation.

## Recommended resources

- [Pillars of software quality](../../guide/pillars.md).
    This section of the Azure Application Architecture Guide describes the five pillars of software quality: scalability, availability, resiliency, management, and security.
- [Ten design principles for Azure applications](../../guide/design-principles/index.md).
    This section of the Azure Application Architecture Guide discusses a set of design principles to make your application more scalable, resilient, and manageable.
- [Designing resilient applications for Azure](../../resiliency/index.md).
    This guide starts with a definition of the term _resiliency_ and related concepts. Then, it describes a process for achieving resiliency by using a structured approach over the lifetime of an application, from design and implementation to deployment and operations.
- [Cloud design patterns](../../patterns/index.md).
    These design patterns are useful for engineering teams when building applications on the pillars of software quality.
