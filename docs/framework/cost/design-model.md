---
title: Develop a cost model
description: Do cost modeling to map logical groups of cloud resources to an organization&apos;s hierarchy, and then estimate costs for those groups.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Develop a cost model

*Cost modeling* is an exercise where you create logical groups of cloud resources that are mapped to the organization's hierarchy and then estimate costs for those groups. The goal of cost modeling is to estimate the overall cost of the organization in the cloud.

1. [**Understand how your responsibilities align with your organization**](#organization-structure)

    Map the organization's needs to logical groupings offered by cloud services. This way the business leaders of the company get a clear view of the cloud services and how they're controlled.

2. [**Capture clear requirements**](design-capture-requirements.md)

    Start your planning with a careful enumeration of requirements. From the high-level requirements, narrow down each requirement before starting on the design of the solution.

3. [**Consider the cost constraints**](#cost-constraints)

    Evaluate the budget constraints on each business unit and determine the governance policies in Azure to lower cost by reducing wastage, overprovisioning, or expensive provisioning of resources.

4. [**Consider tradeoffs**](tradeoffs.md)

    Optimal design doesn't equate to a lowest-cost design.

    As requirements are prioritized, cost can be adjusted. Expect a series of tradeoffs in the areas that you want to optimize, such as security, scalability, resilience, and operability. If the cost to address the challenges in those areas is high, stakeholders will look for alternate options to reduce cost. There might be risky choices made in favor or a cheaper solution.

5. [**Derive functional requirements from high-level goals**](#functional-requirements)

    Break down the high-level goals into functional requirements for the components of the solution. Each requirement must be based on realistic metrics to estimate the actual cost of the workload.

6. [**Consider the billing model for Azure resources**](design-price.md)

    Azure services are offered with consumption-based price where you're charged for only what you use. There's also options for fixed price where you're charged for provisioned resources

    Most services are priced based on units of size, amount of data, or operations. Understand the meters that are used to track usage. For more information, see [Azure resources](design-resources.md).

At the end of this exercise, you should have identified the lower and upper limits on cost and set budgets for the workload. Azure allows you to create and manage budgets in Azure Cost Management. For information, see [Quickstart: Create a budget with an Azure Resource Manager template](/azure/cost-management-billing/costs/quick-create-budget-template?tabs=CLI).

|Have frequent and clear communication with the stakeholders|
|---|
|<p>In the initial stages, communication between stakeholders is vital. The overall team must  align on the requirements so that overall business goals are met. If not, the entire solution might be at risk. </p><p>For instance, the development team indicates that the resilience of a monthly batch-processing job is low. They might request the job to work as a single node without scaling capabilities. This request opposes the architect&apos;s recommendation to automatically scale out, and route requests to worker nodes. </p><p>This type of disagreement can introduce a point of failure into the system, risking the Service Level Agreement, and cause an increase in operational cost.</p>

## Organization structure

Map the organization's needs to logical groupings offered by cloud services. This way the business leaders of the company get a clear view of the cloud services and how they're controlled.

1. Understand how your workload fits into cost optimization across the portfolio of cloud workloads.

    If you are working on a workload that fits into a broader portfolio of workloads, see CAF to [get started guide to document foundational decisions](/azure/cloud-adoption-framework/get-started/cloud-concepts). That guide will help your team capture the broader portfolio view of business units, resources organizations, responsibilities, and a view of the long term portfolio.

    If cost optimization is being executed by a central team across the portfolio, see CAF to [get started managing enterprise costs](/azure/cloud-adoption-framework/get-started/manage-costs).

2. Encourage a culture of democratized cost optimization decisions.

    As a workload owner, you can have a measurable impact on cost optimization. There are other roles in the organization which can help improve cost management activities. To help embed the pillar of cost optimization into your organization beyond your workload team, see the CAF article: [Build a cost-conscious organization](/azure/cloud-adoption-framework/organize/cost-conscious-organization).

3. Reduce costs through shared cloud services and landing zones.

    If your workload has dependencies on shared assets like Active Directory, Network connectivity, security devices, or other services that are also used by other workloads, encourage your central IT organization to provide those services through a centrally managed landing zone to reduce duplicate costs. See the CAF article: [get started with centralized design &amp; configuration](/azure/cloud-adoption-framework/get-started/design-and-configuration) to get started with the development of landing zones.

4. Calculate the ROI by understanding what is included in each grouping and what isn't.

    **Which aspects of the hierarchy are covered by cloud services?**  
    ***

    Azure pricing model is based on expenses incurred for the service. Expenses include hardware, software, development, operations, security, and data center space to name a few. Evaluate the cost benefit of shifting away from owned technology infrastructure to leased technology solutions.

5. Identify scenarios where you can use shared cloud services to lower cost.

    **Can some services be shared by other consumers?**
    ***

    Identify areas where a service or an application environment can be shared with other business units.

    Identify resources that can be used as shared services and review their billing meters. Examples include a virtual network and its hybrid connectivity or a shared app service environment (ASE). If the meter data isn't able to be split across consumers, decide on custom solutions to allocate proportional costs. Move shared services to dedicated resources for consumers for cost reporting.

    > ![Task](../../_images/i-best-practices.svg)  Build chargeback reports per consumer to identify metered costs for shared cloud services. Aim for granular reports to understand which workload is consuming what amount of the shared cloud service.

### Next step

> [!div class="nextstepaction"]
> [Capture cost requirements](./design-capture-requirements.md)

## Cost constraints

Here are some considerations for determining the governance policies that can assist with cost management.

- What are the budget constraints set by the company for each business unit?
- What are policies for the budget alert levels and associated actions?
- Identify acceptable boundaries for scale, redundancy, and performance against cost.
- Assess the limits for security. Don't compromise on security. Premium cloud security features can drive the cost up. It&apos;s not necessary to overinvest. Instead use the cost profile to drive a realistic threat profile.
- Identify unrestricted resources. These resources typically need to scale and consume more cost to meet demand.

### Next step

> [!div class="nextstepaction"]
> [Consider tradeoffs](./tradeoffs.md)

## Functional requirements

Break down high-level goals into functional requirements. For each of those requirements, define metrics to calculate cost estimates accurately. Cloud services are priced based on performance, features, and locations. When defining these metrics, identify acceptable boundaries of performance, scale, resilience, and security. Start by expressing your goals in number of business transactions over time, breaking them down to fine-grain requirements.

**What resources are needed for a single transaction, and how many transactions are done per second, day, year?** 
***

> ![Task](../../_images/i-best-practices.svg) Start with a fixed cost of operations and a rough estimate of transaction volume to work out a cost-per-transaction to establish a baseline. Consider the difference between cost models based on fixed, static provisioning of services, more variable costs based upon autoscaling such as serverless technologies.

### Use T-shirt sizes for choosing SKUs

When choosing options for services, start with an abstract representation of size. For example, if you choose a T-shirt size approach, small, medium, large sizes, can represent an on-demand virtual machine instead of picking specific virtual machines or managed disks SKU sizes.

Abstract sizes give you an idea of the expected performance and cost requirements. It sets the tone for various consumption units that are used to measure compute resources for performance. Also, it helps in understanding the on-demand consumption model of the services.

For more information, see [Estimate the initial cost](./design-initial-estimate.md).

#### Next steps

> [!div class="nextstepaction"]
> [Estimate the initial cost](./design-initial-estimate.md)
