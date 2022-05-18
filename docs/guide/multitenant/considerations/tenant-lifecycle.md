---
title: Tenant lifecycle considerations in a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes the different stages of a tenant lifecycle, and considerations for each stage.
author: johndowns
ms.author: jodowns
ms.date: 07/16/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - guide
---

# Tenant lifecycle considerations in a multitenant solution

When you're considering a multitenant architecture, it's important to consider all of the different stages in a tenant's lifecycle. On this page, we provide guidance for technical decision-makers about the stages of the lifecycle and the important considerations for each stage.

## Trial tenants

For SaaS solutions, consider that many customers request or require trials, before they commit to purchase a solution. Trials bring along the following unique considerations:

- Should the trial data be subject to the same data security, performance, and service-level requirements as the data for full customers?
- Should you use the same infrastructure for trial tenants as for full customers, or should you have dedicated infrastructure for trial tenants?
- If customers purchase your service after a trial, how will they migrate the data from their trial tenants into their paid tenants?
- Are there limits around who can request a trial? How can you prevent abuse of your solution?
- What limits do you want or need to place on trial customers, such as time limits, feature restrictions, or limitations around performance?

## Onboard new tenants

When onboarding a new tenant, consider the following:

- Will onboarding be a self-service, automated, or manual process?
- Does the customer have any specific requirements for data residency? For example, are there data sovereignty regulations in effect?
- Does the customer have to meet any compliance standards (such as PCI DSS, HIPAA, and so on)?
- Does the customer have any specific disaster recovery requirements, such as a recovery time objective (RTO) or a recovery point objective (RPO)? Are these different from the guarantees that you provide to other customers?
- What information do you require, to be able to fully onboard the customer?
- Does the platform provide different pricing options and billing models?
- Does the customer require pre-production environments? And are there set expectations on availability for that environment? Is it transient (on-demand) or always available?

Once tenants have been onboarded, they move into a 'business as usual' mode. However, there are still several important lifecycle events that can occur, even when they are in this mode.

## Update tenants' infrastructure

You will need to consider how you apply updates to your tenants' infrastructures. Different tenants may have updates applied at different times. See [Updates](updates.md) for other considerations about updating tenants' deployments.

## Scale tenants' infrastructure

Consider whether your tenants might have seasonal business patterns, or otherwise change the level of consumption for your solution. For example, if you provide a solution to retailers, you expect that certain times of the year will be particularly busy in some geographic regions, and quiet at other times. Consider whether this affects the way you design and scale your solution, and be aware of _noisy neighbor_ issues, when a subset of tenants scales unexpectedly and impacts the performance to other tenants. You can consider applying mitigations, which might include scaling individual tenants' infrastructures, moving tenants between deployments, and provisioning a sufficient level of capacity to handle spikes and troughs in traffic.

## Move tenants between infrastructures

You might need to move tenants between infrastructures for a number of reasons, including the following:

- You are vertically partitioning your customers and choose to rebalance your tenants across your infrastructures or deployments.
- Customers are upgrading a SKU or pricing tier, and they need to be moved to a single-tenant, dedicated deployment with higher isolation from other tenants.
- Customers request their data to be moved to a dedicated data store.
- Customers require their data be moved to a new geographic region. This might occur during company acquisitions, or when laws or geopolitical situations change.

Consider how you move your tenants' data, as well as redirect requests to the new set of infrastructure that hosts their instance. You should also consider whether moving a tenant will result in downtime, and make sure tenants are fully aware of this.

## Merge and split tenants

It's tempting to think of tenants or customers as static, unchanging entities. However, in reality, this often isn't true. For example:

- In business scenarios, companies might be acquired or merge, including companies located in different geographic regions.
- Similarly, in business scenarios, companies might split or divest.
- In consumer scenarios, individual users might join or leave families.

Consider whether you need to provide capabilities to manage the merging and separation of data, user identities, and resources. Also, consider how data ownership affects your handling of merge and split operations. For example, consider a consumer photography application built for families to share photos with one another. Are the photos owned by the individual family members who contributed them, or by the family as a whole? If users leave the family, should their data be removed or remain in the family's data set? If users join another family, should their old photos move with them?

## Offboard tenants

It's also inevitable that tenants will occasionally need be removed from your solution. In a multitenant solution, this brings along some important considerations, including the following:

- How long should you maintain the customer data? Are there legal requirements to destroy data, after a certain period of time?
- Should you provide the ability for customers to be re-onboarded?
- If you run shared infrastructure, do you need to rebalance the allocation of tenants to infrastructure?

## Deactivate and reactivate tenants

There are situations where a customer's account might need to be deactivated or reactivated. For example:

- The customer has requested deactivation. In a consumer system, a customer might opt to unsubscribe.
- The customer can't be billed, and you need to deactivate the subscription.

Deactivation is separate to offboarding in that it's intended to be a temporary state. However, after a period of time, you might choose to offboard a deactivated tenant.

## Next steps

Consider the [pricing models](pricing-models.md) you will use for your solution.
