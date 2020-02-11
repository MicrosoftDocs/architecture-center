---
title: Trade-offs for costs
description: Describes some of the trade-offs you may decide to make when optimizing a workload for cost.
author: david-stanford
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Trade-offs for costs

Just like your on-premises equipment costs, there are several elements that will affect your monthly costs when using Azure services. These should be taken into consideration when planning your architecture, planning the location of your resources and when estimating your costs:

## Cost versus value

Both TCO and ROI are key financial metrics that organizations may wish to quantify for their Cloud investment. In some cases, they are also looking to compare these metrics to existing on-premises equivalents.

It can be a challenge to get these figures accurate though, due to several reasons:

- On-premises TCO may not accurately account for ‘hidden' expenses, such as under-utilization of purchased hardware or network maintenance costs (labor & equipment failure).

- Cloud TCO may not accurately account for a drop in the organization's operational labor hours, due to the Cloud provider's infrastructure or platform management services being included in the cloud service pricing or the additional operational efficiencies of cloud tools. This is especially true at a smaller scale, where the Cloud provider's services do not result in the ability for the organization to reduce IT labor head count.

- ROI may not account accurately for new organizational benefits due to cloud capabilities, e.g. improved collaboration, reduced time to service customers, fast scaling with minimal or no downtime.

- ROI may not account for organizational business process re-engineering, which may be necessary to fully embrace cloud benefits. In some cases, this re-engineering may not occur at all, leaving an organization in a state where they are using new technology in old ways, therefore stifling the full benefits of their cloud investment.

It is worth examining the TCO and ROI in full, exploring all costs and potential benefits. For migration projects, the [Microsoft Azure Total Cost of Ownership Calculator](https://azure.microsoft.com/pricing/tco/calculator/) may assist, as it pre-populates some common cost but allows you to modify the cost assumptions.

## Location

Azure has datacenters all over the world and each datacenter is placed within a zone within a region or just a region. Usage costs vary between locations that offer Azure products, services, and resources based on popularity, demand, and local infrastructure costs. Azure also offers differentiated cloud regions for specific security and compliance requirements.

For example, you might want to build your Azure solution by provisioning resources in locations that offer the lowest prices, but this would require transferring data between locations if dependent resources and their users are in different parts of the world. If there are meters tracking the volume of data that moves between the resources you provision, any potential savings you make from choosing the cheapest location could be offset by the additional cost of transferring data between those resources.

A location can be thought of as a region or a zone within a region in Azure. Cross regional traffic and cross-zonal traffic incur additional costs on the solution. The cross regional or cross zone additional costs does not apply to services labeled as global services in Azure such as Azure Active Directory. In addition, not all Azure services support zones and not all regions in Azure support zones. Choosing a region or a zone within a region for an Azure service is an opt-in activity. Before opting in, consider how mission critical is the application to have footprint of its resources cross zones and/or cross regions. If its non-mission critical or dev/test, consider keeping the solution and its dependencies in a single region or single zone to leverage the advantages of choosing the lower-cost region.

## Marketplace

The Azure Marketplace offers both the Azure team's first-party products and services, as well as, services from third-party vendors. Different billing structures apply to each of these categories. The billing structures can range from free, PAYG, one-time purchase fee, or a managed offering with support and licensing monthly costs.

## Resource tiers

Costs are resource-specific, so the usage that a meter tracks and the number of meters associated with a resource depend on the resource type. The usage that a meter tracks correlates to several billable units. Those are charged to your account for each billing period, and the rate per billable unit depends on the resource type you are using. In some cases, there are also choices to be made about a resource type that impact the pricing, for example choosing to use a Standard HDD hard disk or a Premium SSD hard disk. Resource types will vary in features such as performance or availability, the design implications of which must be considered along with their cost. As a rule of thumb, start small for resources then scale the resource up as needed. For example, its more cost effective to start with a small size in GB for a managed disk as you are incurring costs on the allocated storage vs. pay-per-GB model. Likewise, with ExpressRoute circuits start with a smaller bandwidth circuit and scale up as needed. In Azure, it's easier to grow a service with little to no downtime vs. downscale a service, which usually requires deprovisioning or downtime.

The same applies to compute infrastructure, it's much easier to deploy an additional smaller instance of compute to work alongside a smaller unit in parallel than it is to restart an instance to scale it up, in general take the mentality of scale-out – not up.

## Subscription offer type

Azure usage rates and billing periods can differ between Enterprise, Web Direct, and Cloud Solution Provider (CSP) customers based on specific subscription types as described [here](https://azure.microsoft.com/support/legal/offer-details/). Some subscription types also include usage allowances or lower prices, which affect costs. For example, Azure [Dev/Test subscription](https://azure.microsoft.com/offers/ms-azr-0148p/) types offers lower prices on Azure services such as specific VM sizes, PaaS web apps and VM images with pre-installed software. On the other hand, Visual Studio subscribers obtain as part of their benefits access to [Azure subscriptions](https://azure.microsoft.com/offers/ms-azr-0063p/) with monthly allowances.