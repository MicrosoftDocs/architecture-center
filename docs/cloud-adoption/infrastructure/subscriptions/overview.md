---
title: "Fusion: Subscriptions design" 
description: Discussion of cloud platform subscriptions as a core service in Azure migrations
author: rotycenh
ms.date: 12/31/2018
---

# Fusion: Subscription design

All cloud platforms are based on a core ownership model that provides organizations with numerous billing and resource management options. The structure that Azure uses is different from other cloud providers because it includes various support options for organizational hierarchy and grouped subscription ownership. Regardless, there is generally one individual responsible for billing and another who is assigned as the top-level owner for managing resources.

## Subscription decision guide

![Plotting subscription options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-subscriptions.png)

Jump to: [Subscriptions design and Azure Enterprise Agreements](#subscriptions-design-and-azure-enterprise-agreements) | [Subscription design patterns](#subscription-design-patterns) | [Management groups](#management-groups) | [Organization at the subscription level](#organization-at-the-subscription-level)

Subscription design is one of the most common strategies that companies use to establish a structure or organize assets during cloud adoption.

**Subscription hierarchy**: A *subscription* is a logical collection of Azure services (such as virtual machines, SQL DB, App Services, or containers). Each asset in Azure is deployed to a single subscription. Each subscription is then owned by one *account*. This account is a user account (or preferably a service account) that provides billing and administrative access across a subscription. For customers who have made a commitment to use a specific amount of Azure through an Enterprise Agreement (EA), another level of control called a *department* is added. In the EA portal, subscription, accounts, and departments can be used to create a hierarchy for billing and management purposes.

The complexity of subscription designs varies. Decisions regarding a design strategy have unique inflection points, as they typically involve both business and IT constraints. Before making technical decisions, IT architects and decision makers should work with the business stakeholders and the cloud strategy team to understand the desired cloud accounting approach, cost accounting practices within your business units, and global market needs for your organization.

**Inflection point**: The dashed line in the image above references an inflection point between simple and more complex patterns for subscription design. Additional technical decision points based on digital estate size versus Azure subscription limits, isolation and segregation policies, and IT operational divisions usually have a significant effect on subscription design.

**Other considerations**: An important thing to note when selecting a subscription design is that subscriptions aren’t the only way to group resources or deployments. Subscriptions were created in the early days of Azure, as such they have limitations related to previous Azure solutions like Azure Service Manager (ASM).

Deployment structure, automation, and new approaches to grouping resources can affect your structure subscription design. Before finalizing a subscription design, consider how [resource grouping](../resource-grouping/overview.md) decisions might influence your design choices. For example, a large multinational organization might initially consider a complex pattern for subscription management. However, that same company might realize greater benefits with a simpler business unit pattern by adding a management group hierarchy.

## Subscriptions design and Azure Enterprise agreements

All Azure subscriptions are associated with one account, which is connected to billing and top-level access control for each subscription. A single account can own multiple subscriptions and can provide a base level of subscriptions organization.

For small Azure deployments, a single subscription or a small collection of subscriptions may compose your entire cloud estate. However, large Azure deployments likely need to span multiple subscriptions to support your organizational structure and bypass [subscription quotas and limits](/azure/azure-subscription-service-limits).

Each Azure Enterprise Agreement provides a further ability to organize subscriptions, and accounts into hierarchies that reflect your organizational priorities. Your organizational enterprise enrollment defines the shape and use of Azure services within your company from a contractual point of view. Within each enterprise agreement, you can further subdivide the environment into departments, accounts, and subscriptions to match your organization's structure.

![hierarchy](../../_images/infra-subscriptions/agreement.png)

## Subscription design patterns

Every enterprise is different. Therefore, the department/account/subscription hierarchy enabled throughout an Azure Enterprise Agreement allows for significant flexibility in how Azure is organized. Modeling your organization's hierarchy to reflect the needs of your company for billing, resource management, and resource access is the first, and most important, decision that you make when starting in the public cloud.

The following subscription patterns reflect a general increase in subscription design complexity to support potential organizational priorities:

### Single subscription

A single subscription per account may suffice for organizations that need to deploy a small number of cloud-hosted assets. This is often the first subscription pattern you implement when beginning your cloud adoption process, allowing small-scale experimental or proof of concept deployments to explore the capabilities of a cloud platform.

However, there can be technical limitations to the number of resources that a single subscription will support. As the size of your cloud estate grows, you may likely want to also support organizing your resources to better organize policies and access control in a manner not supported with a single subscription.

### Application category pattern

As the size of an organization's cloud footprint grows, the use of multiple subscriptions becomes increasingly likely. In this scenario, subscriptions are generally created to support applications that have fundamental differences in business criticality, compliance requirements, access controls, or data protection needs. The subscriptions and accounts supporting these application categories are all organized under a single department which is owned and administered by central IT operations staff.

Each organization will choose to categorize applications differently, often separating subscriptions based on specific applications or services or along the lines of application archetypes. Workloads that might justify a separate subscription under this pattern include:

- Experimental or low-risk applications
- Applications with protected data
- Mission-critical workloads
- Applications subject to regulatory requirements (such as HIPAA or FedRAMP)
- Batch workloads
- Big data workloads such as Hadoop
- Containerized workloads using deployment orchestrators such as Kubernetes
- Analytics workloads

This pattern supports multiple accounts owners responsible for specific workloads. As it lacks a more complex structure at the department level of the enterprise agreement hierarchy, this pattern does not require an Azure Enterprise Agreement to implement.

![Application category pattern](../../_images/infra-subscriptions/application.png)

### Functional pattern

This pattern organizes subscriptions and accounts along functional lines, such as finance, sales, or IT support, using the Enterprise/Department/Account/subscription hierarchy provided to Azure enterprise agreement customers.

![Functional pattern](../../_images/infra-subscriptions/functional.png)

### Business unit pattern

This pattern groups subscriptions and accounts based on profit and loss category, business unit, division, profit center, or similar business structure using the Azure Enterprise Agreement hierarchy.

![Business unit pattern](../../_images/infra-subscriptions/business.png)

### Geographic pattern

For organizations with global operations, this pattern groups subscriptions and accounts based on geographic regions using the Azure Enterprise Agreement hierarchy.

![Geographic pattern](../../_images/infra-subscriptions/geographic.png)

### Mixed patterns

enterprise/department/account/subscriptions hierarchy. However, you can combine patterns such as geographic region and business unit to reflect more complex billing and organizational structures within your company. In addition, your [resource grouping design](../resource-grouping/overview.md) can further extend the governance and organizational structure of your subscription design.

Management groups, as discussed in the following section, can help support more complicated organizational structures.

Management groups, discussed in the following section, can help support more complicated organizational structures.

## Management groups

In addition to the department and organization structure provided through Enterprise Agreements, [Azure Management Groups](/azure/governance/management-groups/index) offer additional flexibility for organizing policy, access control, and compliance across multiple subscriptions. Management groups can be nested up to six levels, allowing you to create a hierarchy that is separate from your billing hierarchy. This can be solely for efficient management of resources.

Management groups can mirror your billing hierarchy, and often enterprises start that way. However, the power of management groups is when you use them to model your organization where related subscriptions &mdash; regardless of where they are in the billing hierarchy &mdash; are grouped together and need common roles assigned along with policies and initiatives.

Examples include:

- Production/non-production: Some enterprises create management groups to identify their production and non-production subscriptions. Management groups allow these customers to more easily manage roles and policies, for example: non-production subscription may allow developers "contributor" access, but in production, they have only "reader" access.
- Internal services/external services: Much like production/non-production, enterprises often have different requirements, policies and roles for internal services versus external customer-facing services.

## Organization at the subscription level

When determining your departments and accounts (or management groups), you will primarily need to decide how you're going to divide your Azure environment to match your organization. However, subscriptions are where the real work happens, and these decisions will impact security, scalability, and billing.

Consider the following patterns as guides:

- **Application/service**: Subscriptions represent an application or a service (portfolio of applications).

- **Lifecycle**: Subscriptions represent a lifecycle of a service, such as production or development.

- **Department**: Subscriptions represent departments in the organization.

The first two patterns are the most commonly used and are both highly recommended. The lifecycle approach is appropriate for most organizations. In this case, the general recommendation is to use two base subscriptions: production and non-production, and then use resource groups to break out the environments further.

For a general description of how Azure subscriptions and resource groups are used to group and manage resources, see [Resource access management in Azure](../../getting-started/azure-resource-access.md).

## Next steps

Learn how identity services are used for access control and management in the cloud.

> [!div class="nextstepaction"]
> [Identity](../identity/overview.md)
