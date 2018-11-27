---
title: "Fusion: Subscriptions Design" 
description: Discussion of cloud platform subscriptions as a core service in Azure migrations
author: rotycenh
ms.date: 11/02/2018
---

# Fusion: Subscription Design

All cloud platforms have a core ownership model providing the main organization that billing and resource management is built around. The structure that this model takes differs between cloud providers, with various types of support for
organizational hierarchy and grouped subscription ownership, but there will generally be an individual responsible for billing and another assigned as a top-level owner for managing resources.

## Subscription Decision Guide

![Plotting Subscription options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-subscriptions.png)

Jump to: [Subscriptions design and Azure Enterprise Agreements](#subscriptions-design-and-azure-enterprise-agreements) | [Subscription design patterns](#subscription-design-patterns) | [Management groups](#management-groups) | [Organization at the subscription level](#organization-at-the-subscription-level)

Subscription design is one of the first fundamental technical strategies to establish as part of your cloud migration planning. 

Subscription design ranges in complexity, and the decisions around a design strategy have unique inflection points, as they involve both business and IT constraints. Before making technical decisions, IT architects and decision makers should work with the business stakeholders and/or your [cloud strategy team](../../culture-strategy/what-is-a-cloud-strategy-team.md) to understand the desired [cloud accounting approach](../../business-strategy/cloud-accounting.md), cost accounting practices within your business units, and global market needs for your organization as a whole. 

Additionally, technical inflection points based around digital estate size vs cloud provider subscription limits, isolation and segregation policies, and IT operational divisions will have a large impact on your subscription design. Deployment structure and automation will also have a large impact on how you structure subscription design, so consider how [resource grouping](../resource-grouping/overview.md) decisions will influence your design choices.

## Subscriptions design and Azure Enterprise Agreements 

*Reviewers note: This document heavily re-purposes subscription content from the existing [Azure enterprise scaffold](../../appendix/azure-scaffold.md). The correct location of this content within the overall Azure Fusion guidance is still under consideration *

Azure Subscriptions are where the real work happens when it comes to deploying, managing and applying policy to resources. For small Azure deployments, a single subscription or a small collection of subscriptions may compose your entire cloud estate. However, Large Azure deployments will need to span multiple subscriptions to support your organizational structure and bypass [subscription quotas and limits](https://docs.microsoft.com/en-us/azure/azure-subscription-service-limits) which impose technical limits on the number of resources you can deploy to a single subscriptions. 

All Azure subscriptions are associated with an account, which is tied to billing and top-level access control for a subscription. A single account can own multiple subscriptions and provides a base level of subscriptions organization.

An Azure Enterprise Agreement provides a further ability to organize subscriptions and accounts into hierarchies reflecting your organizational priorities. Your organizational enterprise enrollment defines the shape and use of Azure services within your company from a contractual point of view. Within the enterprise agreement, you can further subdivide the environment into departments, accounts, and finally, subscriptions to match your organization's structure.

![hierarchy](../../_images/infra-subscriptions/agreement.png)

## Subscription design patterns

Every enterprise is different, and the Department/Account/Subscription hierarchy enabled through an Azure Enterprise Agreement allows for significant flexibility in how Azure is organized within your company. Modeling your hierarchy to reflect the needs of your company for billing, resource management, and resource access is the first — and most important — decision you make when starting in the public cloud.

The following subscription patterns reflect a general increase subscription design complexity to support potential organizational priorities:

### Experimental / small-scale deployments

A single subscription per account can be sufficient for organizations that need to deploy a small number of cloud hosted assets. This is often the first subscription pattern you will implement when beginning your cloud migration process, allowing small-scale experimental or proof of concept deployments to explore the capabilities of a cloud platform.

However, as discussed previously, there are technical limitations to the number of resources that a single subscription will support. As the size of your cloud estate grows you will likely also want to support organizing your resources to better organize policies and access control in a manner not supported with a single subscription.

### Application archetypes

As the size of an organization's cloud footprint grows the use of multiple subscriptions becomes increasingly likely. In this scenario, subscriptions are generally organized along the applications or services they host, or more generally along the lines of application archetypes. In this approach, the subscriptions and accounts are all organized under a single department  of which are owned and administered by central IT operations staff. 

This pattern lacks a more complex hierarchy at the department and account levels.  

![application archetype pattern](../../_images/infra-subscriptions/application.png)

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

Azure Enterprise Agreements are limited to the four-level enterprise/department/account/subscriptions hierarchy. However, you can combine the use combinations such as geographic region and business unit to reflect more complex billing and organizational structures within your company. In addition, your [resource grouping design](../resource-grouping/overview.md) can further extend the governance and organizational structure of your subscription design.

Management groups, discussed in the following section, can help support more complicated organizational structures.

## Management groups

In addition to the department and organization structure provided through Enterprise Agreements, [Azure management groups](https://docs.microsoft.com/en-us/azure/governance/management-groups/index) offer additional flexibility for organizing policy, access control, and compliance across multiple subscriptions. Management groups can be nested up to six levels and allow you to create a hierarchy that is separate from your billing hierarchy, solely for efficient management of resources. 

Management groups can mirror your billing hierarchy and often enterprises start that way. However, the power of management groups is when you use them to model your organization where related subscriptions &mdash; regardless where they are in the billing hierarchy &mdash; are grouped together and need common roles assigned as well as policies and initiatives. A few examples:

* **Production/Non-Production**. Some enterprises create management groups to identify their production and non-production subscriptions. Management groups allow these customers to more easily manage roles and policies, for example: non-production subscription may allow developers "contributor" access, but in production, they have only "reader" access.
* **Internal Services/External Services**. Much like Production/Non-Production, enterprises often have different requirements, policies and roles for internal services vs external (customer facing) services.

## Organization at the subscription level

When deciding on your Departments and Accounts (or management groups), you are primarily looking at how you're dividing up your Azure environment to match your organization. Subscriptions, however, are where the real work happens and your decisions here impact security, scalability and billing.  Many organizations look at the following patterns as their guides:

* **Application/Service**: Subscriptions represent an application or a service (portfolio of applications)
* **Lifecycle**: Subscriptions represent a lifecycle of a service, such as Production or Development.
* **Department**: Subscriptions represent departments in the organization.

The first two patterns are the most commonly used, and both are highly recommended. The lifecycle approach is appropriate for most organizations. In this case, the general recommendation is to use two base subscriptions. "Production" and "Non-Production," and then use resource groups to break out the environments further.

**Learn more**

-   For a general description of how Azure Subscriptions and Resource Groups are used to
    group and manage resources, see [Resource access management in
    Azure](../../getting-started/azure-resource-access.md).


## Next steps

Learn how [identity services](../identity/overview.md) are used for access control and management in the cloud.

> [!div class="nextstepaction"]
> [Identity](../identity/overview.md)


