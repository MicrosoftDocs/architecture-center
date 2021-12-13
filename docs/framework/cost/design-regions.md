---
title: Cost impact of Azure regions
description: Explore cost strategies for selecting Azure regions. Examine tradeoffs, compliance and regulatory issues, and traffic costs across billing zones and regions.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Azure regions
Cost of an Azure service can vary between locations based on demand and local infrastructure costs. Consider all these geographical areas when choosing the location of your resources to estimate costs.

|Terminology|Description|
|---|---|
|Azure region|A set of datacenters deployed within a latency-defined perimeter and connected through a dedicated regional low-latency network. |
|Availability zone |A unique physical location within a region with independent power, network, and cooling to be tolerant to datacenter failures through redundancy and logical isolation of services.|
|Billing zone|A geographic collection of regions that is used for billing.|
|Location|A region or a zone within a region. Azure has datacenters all over the world and each datacenter is placed in a location. |
|Landing zone|The ultimate location of your cloud solution or the landing zone, typically consisting of logical containers such as a subscription and resource group, in which your cloud infrastructure components exist. |

The complete list of Azure geographies, regions, and locations, is shown in [Azure global infrastructure](https://azure.microsoft.com/global-infrastructure).

To see availability of a product by region, see [Products available by region](https://azure.microsoft.com/global-infrastructure/services/).

## Tradeoff
- Locating resources in a cheaper region should not negate the cost of network ingress and egress or by degraded application performance because of increased latency.
- An application hosted in a single region may cost less than an application hosted across regions because of replication costs or the need for extra nodes.

## Compliance and regulatory
Azure also offers differentiated cloud regions for specific security and compliance requirements.

**Does your solution need specific levels of security and compliance?**
***

If your solution needs to follow certain government regulations, the cost will be higher. Otherwise you can meet less rigid compliance, through [Azure Policy](/azure/governance/policy/overview), which is free.

Certain Azure regions are built specifically for high compliance and security needs. For example, with [Azure Government (USA)](/azure/azure-government/) you're given an isolated instance of Azure. [Azure Germany](https://azure.microsoft.com/global-infrastructure/germany/) has datacenters that meet privacy certifications. These specialized regions have higher cost.

Regulatory requirements can dictate restrictions on data residency. These requirements may impact your data replication options for resiliency and redundancy.

## Traffic across billing zones and regions
Cross-regional traffic and cross-zonal traffic incur additional costs.

**Is the application critical enough to have the footprint of the resources cross zones and,or cross regions?**
***

Bandwidth refers to data moving in and out of Azure datacenters. Inbound data transfers (data going into Azure datacenters) are free for most services. For outbound data transfers, (data going out of Azure datacenters) the data transfer pricing is based on billing zones. For more information, see [Bandwidth Pricing Details](https://azure.microsoft.com/pricing/details/bandwidth/?cdn=disable).

Suppose, you want to build a cost-effective solution by provisioning resources in locations that offer the lowest prices. The dependent resources and their users are located in different parts of the world. In this case, data transfer between locations will add cost if  there are meters tracking the volume of data moving across locations. Any savings from choosing the cheapest location could be offset by the additional cost of transferring data.
- The cross-regional and cross-zone additional costs do not apply to global services, such as Azure Active Directory.
- Not all Azure services support zones and not all regions in Azure support zones.

> ![Task](../../_images/i-best-practices.svg) Before choosing a location, consider how important is the application to justify the cost of having resources cross zones and/or cross regions. For non-mission critical applications such as, developer or test, consider keeping the solution and its dependencies in a single region or single zone to leverage the advantages of choosing the lower-cost region.
