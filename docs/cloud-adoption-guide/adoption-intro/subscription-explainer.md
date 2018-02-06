---
title: "Explainer: what is an Azure subscription?"
description: Explains Azure subscriptions, accounts, and offers
author: abuck
---

# Explainer: What is an Azure subscription?

In the [what is an Azure Active Directory tenant?](tenant-explainer.md) explainer article, you learned that digital identity for your organization is stored in an Azure Active Directory tenant. You also learned that Azure trusts Azure Active Directory to authenticate user requests to create, read, update, or delete a resource. 

We fundamentally understand why it's necessary to restrict access to these operations on a resource - to prevent unauthenticated and unauthorized users from accessing our resources. But this is a binary operation, either authenticated user are authorized to access a resource or they aren't. Does this mean that authorized users within an organization can create an unlimited number of resources in Azure? 

You might expect that allowing all users to create resources without limits can lead to problems tracking and managing costs. However, Azure has a control to limit the number of resources and amount of money an organization spends on resources - named a **subscription**. A subscription groups together users and the resources that have been created by those users. Each of those resources contributes to an [overall limit][subscription-service-limits] on that particular resource. 

## Next steps

* Now that you have learned about Azure subscriptions, learn [how to create your an Azure subscription](subscription-how-to.md). Then review the [design guidance for Azure subscriptions](subscription.md).

<!-- Links -->
[azure-get-started]: https://azure.microsoft.com/en-us/get-started/
[azure-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-free-trial]: https://azure.microsoft.com/en-us/offers/ms-azr-0044p/
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[microsoft-account]: https://account.microsoft.com/account
[subscription-service-limits]: /azure/azure-subscription-service-limits
[docs-organizational-account]: https://docs.microsoft.com/en-us/azure/active-directory/sign-up-organization
