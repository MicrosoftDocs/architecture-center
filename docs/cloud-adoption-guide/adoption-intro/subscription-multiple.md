---
title: Decision guide for adding multiple Azure subscriptions
description: Guidance for deciding when to add subscriptions to your Azure environment
author: alexbuckgit
---

# Using multiple subscriptions in Azure

## Getting started

Larger organizations choose to create multiple Azure subscriptions for a variety of reasons. This guide will assist you in deciding when to create an additional subscription in your Azure environment. You should first review the [Azure subscription design guide](./subscription.md) and choose a [subscription design pattern](./subscription-design.md) that fits your organization's needs.

## Considerations for using multiple Azure subscriptions

The first consideration for creating additional Azure subscriptions will depend on the subscription design pattern you've chosen for your organization. For example, with the sandbox pattern, you may only need a single subscription for all your development and testing needs. However, if you are using the continuous deployment pattern, at a minimum you'll need one subscription for your sandbox environment, another subscription for your dev/test environment, and a third subscription for your production environment.

While it's possible that your organization may only need the minimum number of subscriptions needed to support your chosen pattern, there are a number of other factors to consider when deciding whether to add a workload to an existing subscription or to create a new subscription. Although there is no direct cost associated with adding another subscription, it can increase the complexity of managing your Azure environment. Therefore, it's a good idea to minimize the number of subscriptions you have while taking into account the factors discussed here.

## Decision guidance

Create a new subscription if any of these factors apply when adding a new workload to Azure.

- Your additional workload is likely to cause the subscription to approach or exceed any of the maximum [service limits][docs-subscription-limits] for an Azure subscription.
- You require large-scale consumption or administrative isolation for a set of applications.
- You need to completely segregate different users for security or compliance reasons. For example, many governmental organizations disallow provisioning accounts or allowing access to foreign nationals for specific systems.
- Trust issues between different subscription owners require separate access and billing for subscriptions.
- Rigid financial or geopolitical controls may require separate financial arrangements for different subscriptions. For example, a large organization might have multiple subsidiaries or need to handle the accounting and billing of subscriptions in multiple countries differently.

<!-- links -->
[docs-subscription-limits]: /azure/azure-subscription-service-limits
