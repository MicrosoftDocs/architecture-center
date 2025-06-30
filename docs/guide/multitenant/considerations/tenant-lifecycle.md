---
title: Tenant Life Cycle Considerations in a Multitenant Solution
description: This article describes the different stages of a tenant life cycle, and considerations for each stage.
author: johndowns
ms.author: pnp
ms.date: 06/13/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Tenant life cycle considerations in a multitenant solution

When you design a multitenant architecture, you must account for each stage in a tenant's life cycle. This article provides guidance for technical decision-makers about the important considerations for each stage.

## Trial tenants

Many customers request or require trials before they commit to purchase a software as a service (SaaS) solution.

Trials introduce the following unique considerations:

- **Service requirements:** Decide whether trials should meet the same data security, performance, and service-level requirements as the data for full customers.

- **Infrastructure:** Determine whether to use the same infrastructure for trial tenants as for full customers or use dedicated infrastructure for trial tenants.
- **Migration:** Plan how to migrate data from a trial tenant to a paid tenant if a customer purchases your service after a trial.
- **Request process:** Define who can request a trial, how to prevent abuse of your solution, and whether to automate the trial creation or involve your team for each request.
- **Limits:** Set appropriate limits on trial customers, such as time limits, feature restrictions, or performance caps.

In some situations, a [freemium pricing model](pricing-models.md#freemium-pricing) can serve as an alternative to providing trials.

## Onboard new tenants

When you onboard a new tenant, consider the following factors:

- **Process:** Decide whether to make onboarding a self-service, automated, or manual process.

- **Data residency:** Determine whether the tenant has any specific requirements for data residency, such as compliance with data sovereignty regulations.
- **Compliance:** Identify compliance standards, such as PCI DSS, or HIPAA, that the tenant must meet.
- **Disaster recovery:** Confirm whether the tenant has specific disaster recovery requirements, such as a recovery time objective (RTO) or a recovery point objective (RPO). Determine whether these guarantees differ from the ones that you provide to other tenants.
- **Information:** Determine what information you need to fully onboard the tenant. For example, you might need their organization's legal name or their company logo to brand the application. You might also need the file size and format.
- **Billing:** Determine whether the platform provides different pricing options and billing models.
- **Environments:** Identify whether the tenant requires preproduction environments. Clarify whether the environment must be always available or can be provisioned on demand.

After you onboard tenants, they move into a business-as-usual state. However, several important life cycle events can still occur during this state.

## Update tenants' infrastructure

You will need to consider how you apply updates to your tenants' infrastructure. Different tenants might have updates applied at different times.

See [Updates](updates.md) for other considerations about updating tenants' deployments.

## Scale tenants' infrastructure

Consider whether your tenants might have seasonal business patterns, or otherwise change the level of consumption for your solution.

For example, if you provide a solution to retailers, you might expect that certain times of the year will be particularly busy in some geographic regions, and quiet at other times. Consider whether this seasonality affects the way you design and scale your solution. Be aware of how seasonality might affect [noisy neighbor issues](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), such as when a subset of tenants experience a sudden and unexpected increase in load that reduces the performance of other tenants. You can consider applying mitigations, which might include scaling individual tenants' infrastructure, moving tenants between deployments, and provisioning a sufficient level of capacity to handle spikes and troughs in traffic.

## Move tenants between infrastructure

You might need to move tenants between infrastructure for a number of reasons, such as:

- **Rebalancing:** You follow a [vertically partitioned approach](tenancy-models.yml#vertically-partitioned-deployments) to map your tenants to infrastructure, and you need to move a tenant to a different deployment in order to rebalance your load.
- **Upgrades:** A tenant upgrades their SKU or pricing tier, and they need to be moved to a single-tenant, dedicated deployment with higher isolation from other tenants.
- **Migrations:** A tenant requests their data be moved to a dedicated data store.
- **Region moves:** A tenant requires their data be moved to a new geographic region. This requirement might occur during a company acquisition, or when laws or geopolitical situations change.

Consider how you move your tenants' data, and how you redirect requests to the new set of infrastructure that hosts their instance. You should also consider whether moving a tenant might result in downtime, and make sure tenants are fully aware of the risk.

## Merge and split tenants

It's tempting to think of tenants or customers as static, unchanging entities. However, in reality, this often isn't true. For example:

- In business scenarios, companies might be acquired or merge, including companies located in different geographic regions.
- In business scenarios, companies might split or divest.
- In consumer scenarios, individual users might join or leave families.

Consider whether you need to provide capabilities to manage the merging and separation of data, user identities, and resources. Also, consider how data ownership affects your handling of merge and split operations. For example, consider a consumer photography application built for families to share photos with one another. Are the photos owned by the individual family members who contributed them, or by the family as a whole? If users leave the family, should their data be removed or remain in the family's data set? If users join another family, should their old photos move with them?

## Offboard tenants

It's also inevitable that tenants will occasionally need to be removed from your solution. In a multitenant solution, this brings along some important considerations, including the following:

- **Retention period:** How long should you maintain the customer data? Are there legal requirements to destroy data, after a certain period of time?
- **Reonboarding:** Should you provide the ability for customers to be reonboarded? Will their data still be available to them if they rejoin within the data retention period?
- **Rebalancing:** If you run shared infrastructure, do you need to rebalance the allocation of tenants to infrastructure?

## Deactivate and reactivate tenants

There are situations where a customer's account might need to be deactivated or reactivated. For example:

- The customer has requested deactivation. In a consumer system, a customer might opt to unsubscribe.
- The customer can't be billed, and you need to deactivate the subscription.

Deactivation is separate to offboarding in that it's intended to be a temporary state. However, after a period of time, you might choose to offboard a deactivated tenant.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [John Downs](https://linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices
- [Paolo Salvatori](https://linkedin.com/in/paolo-salvatori/) | Principal Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv/) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Consider the [pricing models](pricing-models.md) you will use for your solution.
