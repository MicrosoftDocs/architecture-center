---
title: Tenant Life Cycle Considerations in Multitenant Solutions
description: This article describes the different stages of a tenant life cycle and considerations for each stage, such as scaling and updates.
author: johndowns
ms.author: pnp
ms.date: 06/13/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Tenant life cycle considerations in multitenant solutions

When you design a multitenant architecture, you must account for each stage in a tenant's life cycle. This article provides guidance for technical decision-makers about the important considerations for each stage.

## Trial tenants

Many customers request or require trials before they commit to purchasing a software as a service (SaaS) solution.

Trials introduce the following unique considerations:

- **Service requirements:** Decide whether trials should meet the same data security, performance, and service-level requirements as the data for full customers.

- **Infrastructure:** Determine whether to host trial tenants on the same infrastructure as full customers or use dedicated infrastructure.
- **Migration:** Plan how to migrate data from a trial tenant to a paid tenant if a customer purchases your service after a trial.
- **Request process:** Define who can request a trial, how to prevent misuse of your solution, and whether to automate the trial creation or involve your team.
- **Limits:** Set appropriate limits on trial customers, such as time limits, feature restrictions, or performance caps.

In some situations, a [free pricing model that has limited functionality](pricing-models.md#freemium-pricing) can serve as an alternative to providing trials.

## Onboard new tenants

When you onboard a new tenant, consider the following factors:

- **Process:** Decide whether to make onboarding a self-service, automated, or manual process.

- **Data residency:** Determine whether the tenant has any specific requirements for data residency, such as compliance with data sovereignty regulations.
- **Compliance:** Identify compliance standards that the tenant must meet. These standards might include the Payment Card Industry Data Security Standard (PCI DSS) or the Health Insurance Portability and Accountability Act (HIPAA).
- **Disaster recovery:** Confirm whether the tenant has specific disaster recovery requirements, such as a recovery time objective (RTO) or a recovery point objective (RPO). Determine whether these guarantees differ from the ones that you provide to other tenants.
- **Information:** Define what information you need to fully onboard the tenant. For example, you might need their organization's legal name or their company logo, including the file size and format.
- **Billing:** Determine whether the platform provides different pricing options and billing models.
- **Environments:** Identify whether the tenant requires preproduction environments. Clarify whether the environment must be always available or can be provisioned on demand.

After you onboard tenants, they move into a business-as-usual state. But important life cycle events can still occur during this state.

## Update tenants' infrastructure

Consider how to apply updates to your tenants' infrastructure. Different tenants might receive updates at different times.

For more information, see [Considerations for updating a multitenant solution](updates.md).

## Scale tenants' infrastructure

Determine whether your tenants experience seasonal business patterns or other fluctuations in consumption for your solution.

For example, if you provide a solution to retailers, you might expect traffic spikes during certain times of the year in some geographic regions, while other periods remain quiet. Consider whether this seasonality affects the way that you design and scale your solution. Be aware of [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), where a sudden increase in load from one subset of tenants degrades performance for others.

Consider applying the following mitigations:

- Scale individual tenants' infrastructure.

- Move tenants between deployments.
- Provision a sufficient level of capacity to handle spikes and dips in traffic.

## Move tenants between infrastructure

You might need to move tenants between infrastructure for several reasons. Consider the following scenarios:

- **Rebalancing:** You follow a [vertically partitioned approach](tenancy-models.md#vertically-partitioned-deployments) to map your tenants to infrastructure, and you need to move a tenant to a different deployment to rebalance your load.

- **Upgrades:** A tenant upgrades their SKU or pricing tier and must move to a single-tenant, dedicated deployment that has higher isolation from other tenants.
- **Migrations:** A tenant requests to move their data to a dedicated data store.
- **Region moves:** A tenant requires their data to reside in a different geographic region. This requirement might occur during a company acquisition or because of changes in legal or geopolitical conditions.

Consider how you move your tenants' data and how you redirect requests to the new set of infrastructure that hosts their instance. Also consider whether moving a tenant might result in downtime, and make sure that tenants fully understand the risk.

## Merge and split tenants

It's easy to assume that tenants or customers remain static, but in reality, they often change. Consider the following scenarios:

- In business scenarios, companies might be acquired or merge, including companies located in different geographic regions.

- In business scenarios, companies might split or divest.
- In consumer scenarios, individual users might join or leave families.

Consider whether you need to provide capabilities to manage the merging and separation of data, user identities, and resources. Also consider how data ownership affects how you handle merge and split operations.

For example, in a consumer photo-sharing app for families, determine whether the photos belong to individual contributors or to the family as a whole. If a user leaves the family, consider whether you should remove their data or keep it in the family's data set. If a user joins another family, determine whether their old photos move with them.

## Offboard tenants

Sometimes you need to remove tenants from your solution. In a multitenant solution, offboarding introduces important considerations:

- **Retention period:** Determine how long to maintain the customer data. Identify any legal requirements that mandate data destruction after a specific period.

- **Reonboarding:** Decide whether to support reonboarding. Clarify whether the tenant's data remains available during the retention period.
- **Rebalancing:** If you run shared infrastructure, assess whether you need to rebalance tenant allocations after offboarding.

## Deactivate and reactivate tenants

You might need to deactivate or reactivate a customer's account. Consider the following examples:

- A customer requests deactivation. In a consumer system, a customer might choose to unsubscribe.

- A customer can't be billed, and you need to deactivate the subscription.

Deactivation differs from offboarding because it's intended to be a temporary state. However, after a period of time, you might choose to offboard a deactivated tenant.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- Consider the [pricing models](pricing-models.md) that you plan to use for your solution.
