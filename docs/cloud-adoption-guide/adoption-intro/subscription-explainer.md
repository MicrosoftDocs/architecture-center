---
title: Explainer - What is an Azure subscription?
description: Explanation of Azure subscriptions
author: abuck
---

# Explainer: What is an Azure subscription?

An individual or organization that adopts Azure begins by [creating an Azure subscription][azure-get-started]. An Azure **subscription** is an agreement with Microsoft that provides access to the numerous PaaS, IaaS, and other services available in Microsoft Azure, along with access to the [Azure management portal][azure-portal]. A subscription is the starting point for using Azure.

When you create an Azure subscription, you associate it with an **account** &mdash; either a [Microsoft account](https://account.microsoft.com/account) for personal use, or a [work or school account](https://docs.microsoft.com/en-us/azure/active-directory/sign-up-organization) created by your organization. The owner of this account is assigned as the owner of the Azure subscription and is responsible for managing it and paying for Azure resources deployed in the subscription.

A subscription also represents a [specific offer][azure-offers] from Microsoft. Some subscriptions, such as Pay-As-You-Go subscriptions, are intended for running production workloads. Other subscriptions, such as Free Trial offers and Dev/Test subscriptions, provide discounted rates to support learning about Azure or the initial development of an application. Each offer has different terms and some have special benefits. If necessary, you can [change your subscription to a different offer][azure-change-subscription-offer].

Every Azure resource you deploy belongs to an Azure subscription. Subscriptions act as a logical boundary of scale, administration, and billing for these resources. The subscription defines limits on how many cloud resources a subscription can consume, who is responsible for administering the subscription, and who is responsible for paying for the resources used by the subscription.

## Next steps

<!-- Links -->
[azure-get-started]: https://azure.microsoft.com/en-us/get-started/
[azure-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-portal]: https://portal.azure.com
