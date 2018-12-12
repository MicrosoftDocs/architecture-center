---
title: "Fusion: Subscriptions Design" 
description: Discussion of cloud platform subscriptions as a core service in Azure migrations
author: rotycenh
ms.date: 12/11/2018
---

# Fusion: Subscription design

All cloud platforms are based on a core ownership model that provides organizations with numerous billing and resource management options. The structure that the Azure migration model takes is differnet from other cloud providers because it includes various support options for organizational hierarchy and grouped subscription ownership. Regardless, there is generally one individual responsible for billing and another person who is assigned as a top-level owner for managing resources.

## Subscription decision guide

![Plotting subscription options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-subscriptions.png)

Jump to: [Subscriptions design and Azure Enterprise Agreements](#subscriptions-design-and-azure-enterprise-agreements) | [Subscription design patterns](#subscription-design-patterns) | [Management groups](#management-groups) | [Organization at the subscription level](#organization-at-the-subscription-level)

Subscription design is one of the top technical strategies organizations use to establish cloud migration planning. 

Subscription design ranges in complexity. Decisions around a design strategy have unique inflection points, as they typically involve both business and IT constraints. Before making technical decisions, IT architects and decision makers should work with the business stakeholders and/or your [cloud strategy team](../../culture-strategy/what-is-a-cloud-strategy-team.md) to understand the desired [cloud accounting approach](../../business-strategy/cloud-accounting.md), cost accounting practices within your business units, and global market needs for your organization as a whole. 

Additionally, technical entry points that are based upon digital estate size versus cloud provider subscription limits, isolation and segregation policies, and IT operational divisions usually have a large impact on subscription design. Deployment structure and automation also have a large impact on how you structure subscription design, so consider how [resource grouping](../resource-grouping/overview.md) decisions might influence your design choices.

## Subscriptions design and Azure Enterprise Agreements 

*Reviewers note: This document heavily repurposes subscription content from the existing [Azure enterprise scaffold](../../appendix/azure-scaffold.md). The correct location of this content within the overall Azure Fusion guidance is still under consideration.*

Azure subscriptions are based on the real work that happens when deploying, managing, and applying policy to resources. For small Azure deployments, a single subscription or a small collection of subscriptions may compose your entire cloud estate. However, large Azure deployments likely need to span multiple subscriptions to support your organizational structure and bypass [subscription quotas and limits](https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits). This can impose technical limits on the number of resources you can deploy to a single subscriptions. 

All Azure subscriptions are associated with at least one account, which is connected to billing and top-level access control for each subscription. A single account can own multiple subscriptions and can provide a base level of subscriptions organization.

Each Azure Enterprise Agreement provides a further ability to organize subscriptions, and accounts into hierarchies that reflect your organizational priorities. Your organizational enterprise enrollment defines the shape and use of Azure services within your company from a contractual point of view. Within each enterprise agreement, you can further subdivide the environment into departments, accounts, and subscriptions to match your organization's structure.

![hierarchy](../../_images/infra-subscriptions/agreement.png)

## Subscription design patterns

Every enterprise is different. Therefore, the Department/Account/Subscription hierarchy enabled throughout an Azure Enterprise Agreement allows for significant flexibility in how Azure is organized. Modeling your organization's hierarchy to reflect the needs of your company for billing, resource management, and resource access is the first, and most important, decision that you make when starting in the public cloud.

The following subscription patterns reflect a general increase subscription design complexity to support potential organizational priorities:

### Experimental and small-scale deployments

A single subscription per account may be sufficient for organizations that need to deploy a small number of cloud-hosted assets. This is often the first subscription pattern you implement when beginning your cloud migration process, allowing small-scale experimental or proof of concept deployments to explore the capabilities of a cloud platform.

However, there can be technical limitations to the number of resources that a single subscription will support. As the size of your cloud estate grows, you may likely want to also support organizing your resources to better organize policies and access control in a manner not supported with a single subscription.

### Application archetypes

As the size of an organization's cloud footprint grows, the use of multiple subscriptions becomes increasingly likely. In this scenario, subscriptions are generally organized along the applications or services they host, or more generally along the lines of application archetypes. In this approach, the subscriptions and accounts are all organized under a single department of which are owned and administered by central IT operations staff. 

Note that this pattern may lack a more complex hierarchy at the department and account levels.  

![application archetype pattern](../../_images/infra-subscriptions/application.png)

As you begin to deploy resources across multiple subscriptions, the [Azure Virtual Datacenter model](../virtual-datacenter/overview.md) can offer a useful approach for applying consistent centralized management, security, and policy control [across subscriptions](vdc-subscriptions.md). Simple deployments may not need the organization and management capabilities offered by the VDC model, but as your subscription design becomes more complex the VDC approach may more sense as a deployment strategy.

### Functional

This pattern groups subscriptions and accounts along functional lines, such as finance, sales, or IT support. 

![functional subscription pattern](../../_images/infra-subscriptions/functional.png)

### Business unit

This pattern groups subscriptions and accounts based on business unit, profit center, or similar organizational structure.

![business subscription pattern](../../_images/infra-subscriptions/business.png)

### Geographic patterns

For organizations with global operations, this pattern groups subscriptions and accounts on geographic region.  

![geographic subscription pattern](../../_images/infra-subscriptions/geographic.png)

### More complex patterns

Azure Enterprise Agreements are limited to the four-level enterprise/department/account/subscriptions hierarchy. However, you can combine combinations such as geographic region and business unit to reflect more complex billing and organizational structures within your company. In addition, your [resource grouping design](../resource-grouping/overview.md) can further extend the governance and organizational structfure of your subscription design.

Management groups, as discussed in the following section, can help support more complicated organizational structures.

## Management groups

In addition to the department and organization structure provided through Enterprise Agreements, [Azure management groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/index) offer additional flexibility for organizing policy, access control, and compliance across multiple subscriptions. Management groups can be nested up to six levels, allowing you to create a hierarchy that is separate from your billing hierarchy. This can be solely for efficient management of resources. 

Management groups can mirror your billing hierarchy, and often enterprises start that way. However, the power of management groups is when you use them to model your organization where related subscriptions &mdash. Regardless where they are in the billing hierarchy &mdash; they are grouped together and need common roles assigned as well as policies and initiatives. A few examples include:

* **Production/Non-Production**. Some enterprises create management groups to identify their production and non-production subscriptions. Management groups allow these customers to more easily manage roles and policies, for example: non-production subscription may allow developers "contributor" access, but in production, they have only "reader" access.

* **Internal Services/External Services**. Much like Production/Non-Production, enterprises often have different requirements, policies and roles for internal services vs external (customer facing) services.

## Organization at the subscription level

When deciding on your departments and accounts (or management groups), you primarily look at how you're dividing your Azure environment to match your organization. Subscriptions, however, are where the real work happens and your decisions here impact security, scalability and billing. Many organizations look at the following patterns as their guides:

* **Application/Service**: Subscriptions represent an application or a service (portfolio of applications)
* **Lifecycle**: Subscriptions represent a lifecycle of a service, such as Production or Development
* **Department**: Subscriptions represent departments in the organization

The first two patterns are the most commonly used and are both highly recommended. The lifecycle approach is appropriate for most organizations. In this case, the general recommendation is to use two base subscriptions. "Production" and "Non-Production," and then use resource groups to break out the environments further.

**Learn more**

-   For a general description of how Azure Subscriptions and Resource Groups are used to
    group and manage resources, see [Resource access management in
    Azure](../../getting-started/azure-resource-access.md).


## Next steps

Learn how [identity services](../identity/overview.md) are used for access control and management in the cloud.

> [!div class="nextstepaction"]
> [Identity](../identity/overview.md)

