---
title: "Explainer: what is an Azure subscription?"
description: Explains Azure subscriptions, accounts, and offers
author: alexbuckgit
---

# Explainer: What is an Azure subscription?

In the [what is an Azure Active Directory tenant?](tenant-explainer.md) explainer article, you learned that digital identity for your organization is stored in an Azure Active Directory tenant. You also learned that Azure trusts Azure Active Directory to authenticate user requests to create, read, update, or delete a resource. 

We fundamentally understand why it's necessary to restrict access to these operations on a resource &mdash; to prevent unauthenticated and unauthorized users from accessing our resources. However, these resource operations have other properties that an organization would like to control, such as the number of resources a user or group of users is allowed to create, and, the cost to run those resources. 

Azure implements this control, and it is named a **subscription**. A subscription groups together users and the resources that have been created by those users. Each of those resources contributes to an [overall limit][subscription-service-limits] on that particular resource.

Organizations can use subscriptions to manage costs and creation of resource by users, teams, projects, or other factors. These strategies will be discussed in the intermediate and advanced adoption stage articles. 

## Next steps

* Now that you have learned about Azure subscriptions, learn more about [creating a subscription](subscription.md) before you create your first Azure resources..

<!-- Links -->
[azure-get-started]: https://azure.microsoft.com/en-us/get-started/
[azure-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-free-trial]: https://azure.microsoft.com/en-us/offers/ms-azr-0044p/
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[microsoft-account]: https://account.microsoft.com/account
[subscription-service-limits]: /azure/azure-subscription-service-limits
[docs-organizational-account]: https://docs.microsoft.com/en-us/azure/active-directory/sign-up-organization
