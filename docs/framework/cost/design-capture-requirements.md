---
title: Capture cost requirements for an Azure
description: Learn to enumerate cost requirements and considerations, and how to align costs with business goals.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Capture cost requirements

Start your planning with a careful enumeration of requirements. Make sure the needs of the stakeholders are addressed. For strong alignment with business goals, those areas must be defined by the stakeholders and shouldn't be collected from a vendor.

 Capture requirements at these levels:
- Business workflow
- Compliance and regulatory
- Security
- Availability

**What do you aim to achieve by building your architecture in the cloud?** 
***

Here are some common answers.
- Take advantage of features only available in the cloud, such as intelligent security systems, regions footprint, or resiliency features.
- Use the on-demand nature of the cloud to meet peak or seasonal requirements, then releasing that cost investment when it is no longer needed.
- Consolidate physical systems.
- Retire on-premises infrastructure.
- Reduce hardware or data center management costs.
- Increase performance or processing capabilities, through services like big data and machine learning.
- Meet regulatory considerations, including taking advantage of certified infrastructure.

Narrow down each requirement before you start the design of the workload. Expect the requirements to change over time as the solution is deployed and optimized.

## Landing zone
Consider the cost implications of the geographic region to which the landing zone is deployed.

The landing zone consists of the subscription and resource group, in which your cloud infrastructure components exist. This zone impacts the overall cost. Consider the tradeoffs. For example, there are additional costs for network ingress and egress for cross-zonal traffic. For more information, see [Azure regions](design-regions.md) and [Azure resources](design-resources.md).

For information about landing zone for the entire organization, see [CAF: Implement landing zone best practices](/azure/cloud-adoption-framework/get-started/manage-costs#step-4-implement-landing-zone-best-practices).

## Security
Security is one of the most important aspects of any architecture. Security measures protect the valuable data of the organization. It provides confidentiality, integrity, and availability assurances against attacks and misuse of the systems.

Factor in the cost of security controls, such as authentication, MFA, conditional access, information protection, JIT/PIM, and premium Azure AD features. Those options will drive up the cost.

For security considerations, see the [Security Pillar](../security/overview.md).

## Business continuity

**Does the application have a Service Level Agreement that it must meet?** 
***

Factor in the cost when you create high availability and disaster recovery strategies.

Overall Service Level Agreement (SLA), Recovery Time Objective (RTO), and Recovery Point Objective (RPO) may drive towards expensive design choices in order to support higher availability requirements. For example, a choice might be to host the application across regions, which is costlier than single region but supports high availability.

If your service SLAs, RTOs and RPOs allow, then consider cheaper options. For instance, pre-build automation scripts and packages that would redeploy the disaster recovery components of the solution from the ground-up in case a disaster occurs. Alternatively, use Azure platform-managed replication. Both options can lower cost because fewer cloud services are pre-deployed and managed, reducing wastage.

In general, if the cost of high availability exceeds the cost of application downtime, then you could be over engineering the high availability strategy. Conversely, if the cost of high availability is less than the cost of a reasonable period of downtime, you may need to invest more.

Suppose the downtime costs are relatively low, you can save by using recovery from your backup and disaster recovery processes. If the downtime is likely to cost a significant amount per hour, then invest more in the high availability and disaster recovery of the service. It's a three-way tradeoff between cost of service provision, the availability requirements, and the organization's response to risk.

## Application lifespan

**Does your service run seasonally or follow long-term patterns?**
***

For long running applications, consider using [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) if you can commit to one-year or three-year term. VM reservations can reduce cost by 60% or more when compared to pay-as-you-go prices.

Reservation is still an operational expense with all the corresponding benefits. Monitor the cost on workloads that have been running in the cloud for an extended period to forecast the reserved instance sizes that are needed. For information about optimization, see [Reserved instances](./optimize-checklist.md).

If your application runs intermittently, consider using Azure Functions in a consumption plan so you only pay for compute resources you use.

## Automation opportunities

**Is it a business requirement to have the service be available 24x7?**  
***

You may not have a business goal to leave the service running all the time. Doing so will incur a consistent cost. Can you save by shutting down the service or scaling it down outside normal business hours? If you can,
- Azure has a rich set of APIs, SDKs, and automation technology that utilizes DevOps and traditional automation principles. Those technologies ensure that the workload is available at an appropriate level of scale as needed.
- Repurpose some compute and data resources for other tasks that run out of regular business hours. See the [Compute Resource Consolidation](../../patterns/compute-resource-consolidation.md) pattern and consider containers or elastic pools for more compute and data cost flexibility.

## Budget for staff education
Keep the technical staff up to date in cloud management skills so that the invested services are optimally used.

- Consider using resources such as [FastTrack for Azure](https://azure.microsoft.com/programs/azure-fasttrack/partners/) and [Microsoft Learn](/learn/) to onboard the staff. Those resources provide engineering investments at no cost to customers.
- Identify training requirements and costs for cloud migration projects, application development, and architecture refinement.
- Invest in key areas, such as identity management, security configuration, systems monitoring, and automation.
- Give the staff access to training and relevant announcements. This way, they can be aware of new cloud capabilities and updates.
- Provide opportunities to get real-world experience of customers across the globe through conferences, specific cloud training, and passing dedicated Microsoft Exams (AZ, MS, MB, etc.).

## Standardization
Ensure that your cloud environments are integrated into any IT operations processes. Those operations include user or application access provisioning, incident response, and disaster recovery. That  mapping may uncover areas where additional cloud cost is needed.

## Next step
> [!div class="nextstepaction"]
> [Determine the cost constraints](./design-model.md#cost-constraints)
