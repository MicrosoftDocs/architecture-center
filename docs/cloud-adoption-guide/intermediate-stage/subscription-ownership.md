---
title: "Explainer: ownership and administration of Azure subscriptions"
description: Explains ownership and administration of Azure subscriptions
author: alexbuckgit
---

#Explainer: ownership and administration of Azure subscriptions

Now that you understand the fundamental controls in an Azure subscription, let's discuss how ownership and administration of your Azure subscription work.

## Subscription ownership and administration

When an Azure subscription is created, you associate it with an **account**. Typically, this account resides in your organization's [Azure AD tenant](..\adoption-intro\tenant.md). The owner of this account is known as the **Account Administrator (AA)**. The AA has billing ownership of the subscription &mdash; in other words, ensuring that payment is made for the Azure services consumed by that subscription. The AA can manage subscription details, such as the billing information and the [offer type][azure-change-subscription-offer], via the [Azure Account Center][azure-account-center].

A subscription also has a **Service Administrator (SA)**. The Service Administrator can add, remove, and modify Azure resources via the [Azure portal][azure-portal]. For a new subscription, the Account Administrator and the Service Administrator are the same account. The AA can [reassign the SA role][azure-change-sa] to another account, which is common when one person pays for the subscription and another person manages the resources in the subscription.

## TODO - Provide info or links for: 

- Change the billing information for a subscription
- Cancel a subscription
- [Transfer ownership of your subscription to a different account][azure-transfer-subscription]
- Create another subscription for your account
- [Subscription offer types][azure-available-offers]
- ?? <Relationship between subscription and tenant?>

## Next steps

* Now that you understand ownership and administration of Azure subscriptions, let's discuss reasons to [use multiple Azure subscriptions](subscription-multiple.md) and considerations for managing them.


******************************


<!-- links -->
[azure-account-center]: https://account.azure.com/
[azure-portal]: https://portal.azure.com
[azure-change-sa]: /azure/billing/billing-add-change-azure-subscription-administrator
[azure-available-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[azure-transfer-subscription]: /azure/billing/billing-subscription-transfer
