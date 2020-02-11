---
title: Provisioning cloud resources to optimize cost
description: Describes guidance on how to provision your cloud resources to minimize cost.
author: david-stanford
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Provisioning cloud resources to optimize cost

Governance is usually thought of in terms of compliance and security, components of Azure governance can also be laid down as a foundational scaffold to assist with Cloud cost management. This work will benefit your ongoing cost review process and will offer a level of protection for newly introduced resources.

More specifically, plans for the different cloud services that will be made available to the various solutions stakeholders via a corporate self-service catalog or directly from the Azure portal itself to follow a "T-shirt size" approach. This way you can open on-demand consumption of cloud services while enforcing proven solutions that comply with expected performance and costs requirements. For example, solution stakeholders will choose a T-shirt size for on-demand Virtual Machine resources in the x-small, small, medium, large, x-large range instead of allowing them to pick specific virtual machine or managed disks SKU sizes.

T-shirt size-based offerings are one option, however organizations that would like a more open model for building cloud solutions while keeping cost savings in mind, should explore Azure Policy. Policies can set rules on management groups, subscriptions, and resources groups that control which clouds service resource SKU size, replication features, and locations are allowed. Identify which Azure built-in policies can aid in cost savings and build new Azure custom policies for additional control requirements. For more information, visit [here](/azure/governance/management-groups/create?toc=%2Fazure%2Fbilling%2FTOC.json).

In this way, developers can be enabled to self-service their resource creation, while preventing expensive resources from being provisioned and ensuring compliance against other identified cost boundaries. This eliminates the need for manual resource approval and speeds up the total provisioning time.

In addition, the enforcement of a resource tagging strategy can make it easier to link incurred costs back to an owner, an application, a business department or a project initiative, even if the costs span multiple resources, locations, and subscriptions. Tagging in Azure is available at the resource group and single-resource (atomic unit) scope. Consider that tags are not inheritable, therefore when tagging resource groups, each single resource won't inherit those tags. This will become apparent when reviewing raw invoices or via cost analysis tooling in the Azure portal which allows for filtering options based on tagging. When filtering, if the tag was assigned on a per-resource basis then you would be able to get more granular reporting on which Azure resource belongs to which tag. On the other hand, when assigning tags at the resource group scope, additional efforts would be needed to map single resource to a specific tag as you would have to look for the parent resource group and obtain the tagging info there. Finally, it's important to understand a few limitations that [not all Azure resources can be tagged](/azure/azure-resource-manager/tag-support) and not all taggable resources in Azure flow into the cost analysis tool in Azure. Identifying the clouds services meters that cannot be tagged or viewed in the cost analysis tool in Azure portal is an early step to consider.

Microsoft provides guidance on building out your governance needs and controls with the [Enterprise Scaffold](/azure/cloud-adoption-framework/reference/azure-scaffold). This pivotal exercise, in conjunction with good review processes, enables your business to implement the controls and strategies that are relevant to your organization. It also helps you to structure your Azure tenancy and Subscriptions according to your business needs.

## Iterative capacity planning

One of the largest benefits of cloud computing is its rapid adaptability to changes in capacity. Having a good understanding of capacity requirements allows organizations to allocate resources with minimal overhead and grow/shrink on demand.

## Autoscaling policies

For certain application, capacity requirements may swing over time. Autoscaling policies allow for less error-prone operations and cost savings through robust automation.

## Right-sizing your resources

Certain infrastructure resources are delivered to customers as fix-sized building blocks. Ensuring that these building blocks are adequately sized is important to meet capacity demand as well as to eliminate waste.

## Choosing services that match business requirements

Any architecture planning starts with a careful enumeration of requirements. Architecting a Cloud solution is no different. As with any technology system, requirements are in place to ensure that the needs of the stakeholders are addressed and it is vital to remember that optimal design does not equal the lowest cost design.

Cost is another requirement lever that can be adjusted as other requirements dictate, resulting in a scenario of complex tradeoffs between the areas that architects are seeking to optimize for: such as security, scalability, resilience, and operability. A solution architecture could perfectly address the challenges of these areas, however if the solution costs too much, the business will quickly look for alternate options to reduce cost. In some cases, the cost of not meeting expectations, internal or external, will outweigh the solution cost and the architecture is accepted, whereas in others the risk may be accepted in favor of a cheaper solution architecture.

It is also important to remember that designing the application to meet business requirements of scalability, resilience, recoverability and more, is still the responsibility of the customer, and is not handed off to the cloud vendor.

Communication between stakeholders is vital in these scenarios. The overall team must be clear on **and aligned on** the requirements. If not, then this potentially risks the success of the overall solution, not just from a cost perspective. If the requirements are not shared amongst all members, then there is a potential that the solution may not meet the intended business goals. For example, members of the development team believe that the resilience requirements of a monthly batch processing job are low, so design it to work as a single node without scaling capabilities. However, the architecture team had considered that component to be vital, and requires the ability to automatically scale out, and route requests to worker nodes. This lack of clarity potentially introduces a point of failure into the system, putting at risk the Service Level Agreement of the solution and would likely cause an increase in operational cost once the component is rearchitected.

### Compliance and regulatory requirements

In highly regulated industries, compliance requirements play an important part in architecture decisions. In the cloud, these decisions will usually have an impact on cost. For example, requiring that all data stores be encrypted can be achieved via the use of Azure Policy at no extra charge, however Azure regions built specifically for high compliance needs (e.g. Azure Germany or Azure Government (USA) have higher service costs.

Regulatory requirements can dictate restrictions on data residency, which impacts your data replication options for resiliency & redundancy. The ultimate location of your cloud solution known as the landing zone, typically consisting of logical containers such as a subscription and resource group, where your cloud infrastructure components exist. The Azure region that the landing zone is deployed in impacts the cost of these resources. Care should be taken that cost tradeoffs such as locating resources in a cheaper region, are not negated by the cost of network ingress and egress or by degraded application performance due to increased latency.

Understand your compliance and regulatory requirements and how both the cloud services and your architecture decisions support these, as both compliance and the effects of non-compliance remain the responsibility of your organization.

### Security requirements

- Authentication, MFA, conditional access, information protection, JIT/PIM (premium Azure AD features=\$)

### Availability, business continuity and disaster recovery requirements

- Availability requirements will have significant cost impact. For example, does the application have a given Service Level Agreement that it must meet?

- An application hosted in a single region may cost less than an application hosted across regions, due to replication costs or extra nodes being required. However, it may be that the overall Service Level Agreement, Recovery Time Objective (RTO), and Recovery Point Objective (RPO) drive towards more costly design choices that must support higher availability requirements.

If your service SLA, RTOs and RPOs allow for this, then it can be dramatically cheaper to consider options such as pre-building automation scripts and packages that would redeploy the DR components of the solution from the ground-up in the event of a disaster or – simply resort to using Azure platform-managed replication. Both options should yield cost savings against dual deployments as fewer cloud services need to be pre-deployed and managed, leading to less wastage. Which data/workloads

- RTO/RPO
- Availability sets
- Geo redundancy
- Azure backup
- Cost angle on these

You need to consider costings when defining your strategy for HA and DR and how the cost of downtime will impact your overall spend. In general, if the cost of HA exceeds the cost of downtime of the application you are probably over-engineering your HA strategy. If your cost of HA is less than the cost of a reasonable period of downtime for your service (given the current service levels, RPO, RTO and 9's SLA, then you may well need to invest more.

In summary, if downtime is likely to cost you \$1 per hour, you probably don't need to spend a large amount of money on HA and can resort to recovery from your backup and DR processes in the event of a major issue. However, if your downtime is likely to cost \$1 m per hour then you would more than likely be prepared to invest more in the HA and DR processing of the service, it's a three-way trade-off between cost of service provision, your availability requirements, and your organization's attitude to risk.

For strong alignment of business goals, start with your high-level requirements. In addition to traditional requirements, be sure to consider the unique opportunities afforded by cloud services. What are you aiming to achieve by building your architecture in the cloud?

Typical answers are:

- Taking advantage of features only available in the cloud, such as intelligent security systems, regions footprint, or resiliency features;

- Using the on-demand nature of the Cloud to meet peak or seasonal requirements, then releasing that cost investment when it is no longer needed;

- Consolidating physical systems;

- Retiring on-premises infrastructure;

- Reducing hardware or data center management costs;

- Increasing performance or processing capabilities, including services like big data and machine learning;

Meeting regulatory considerations, including taking advantage of certified infrastructure

Understand that requirements may vary over time as the solution is optimized once in the cloud. For example, one key differentiator of cloud architectures is the ability to scale dynamically, making it possible to realize cost savings through automatic scaling. Consider as part of the requirements for the components of the solution, the metrics that each resource exposes in Azure and build your alerts on baseline thresholds for each metric. This way the solution can be built to alert the admins on when the solution is utilizing its supporting cloud services at capacity thus allowing the admin to better fine-tune the solution's resources to target SKUs based on current load. Over time, the solution can be optimized to autoheal itself when alerts are triggered. Additional alerts can be set on allowed budgets for the different solutions either at the resource group or management groups scopes. This way, both cloud services performance and budget requirements can meet at a happy medium via alerting on metrics and budgets.

## Application lifespan and what should be automated

Does your service run seasonally or follow long-term patterns?

Some Azure services offer the concept of a 'reserved instances', that can be utilized to yield further cost savings on predictable VM sizes that will be utilized for the solution's components.

If these are available, consider purchasing Seasonal/one-off or long-term RIs. Reserved instances are purchased in one-year or three-year terms, with payment required for the full term up front. After purchase, the reservation is matched up to running instances of the same SKU size or same-family SKU sizes and hours from your reservation will be decremented accordingly.

While having a reservation expects you to do similar planning that you'd perform before a hardware purchase, it is still an operational expense with all the corresponding benefits. Consider purchasing reserved instances to fine-tune cost savings on solutions that have been running in the cloud for an extended period to more confidently forecast the reserved instance sizes that are needed.

## DevOps and deployment automation

In an on premises environment, we do not typically have the luxury of being able to access APIs to turn on/off, or scale up/down workloads, in the same way as we do in the cloud.

As we have a rich set of APIs, SDKs and automation technology that we can call upon, utilizing DevOps and even more classical automation principles enables us to ensure that the workload is available at an appropriate level of scale as needed.

You may not have to leave the service running all of the time, incurring a consistent cost, consider whether it is actually a business requirement to leave the service online permanently 24x7, or could we save cost by shutting down the service or scaling it down outside normal business hours?

If so, could we repurpose some compute / data resources for other tasks that run out of business hours? See the [Compute Resource Consolidation](/azure/architecture/patterns/compute-resource-consolidation) pattern and consider containers or elastic pools for more compute and data cost flexibility, more on this below.