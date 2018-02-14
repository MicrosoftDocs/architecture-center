---
title: "Guidance: Azure subscription design"
description: Guidance for Azure subscription design in the intermediate phase of your cloud adoption strategy
author: alexbuckgit
---

# Guidance: Azure subscription design

In the foundational adoption phase, you learned some basic information about Azure subscriptions. You also created your first subscription. In the intermediate adoption phase, we'll discuss some important aspects of subscriptions, as well as considerations for using multiple subscriptions in your organization. 

## Administration and access control

Initially, Azure provided the Azure Service Model (now known as the classic deployment model). In this model, access controls for a subscription were minimal, and access to a subscription implied access to all the resources in the subscription. These limitations led organizations to create many subscriptions in order to limit access to only the appropriate personnel.

The Azure Resource Management deployment model (introduced in 2014) enables Role-Based Access Control (RBAC), which provides fine-grained control for assigning administrative privileges to Azure resources. In this model, the subscription is no longer required to serve as the primary security boundary. As a result, the proliferation of subscriptions that was common in the classic deployment model is no longer necessary.

> [!NOTE] 
> Because of its more robust security and billing capabilities, the Azure Resource Management deployment model should be used for all new Azure deployments. This guide focuses solely on deploying and managing Azure resources via this model.

## Scale and subscription limits

A subscription is a logical limit of scale. Every subscription has a defined set of [subscription limits][docs-subscription-limits] for the resources associated with a subscription. These limits include quotas for various Azure resource types. Organizations often create multiple Azure subscriptions in order to avoid these limits.

## Ownership and administration

Each Azure subscription is assigned to an account. The owner of this account is known as the Account Administrator (AA). The AA is authorized to access the [Azure Account Center][azure-account-center] to perform various management tasks. An AA can create new subscriptions, cancel subscriptions, change the billing information for a subscription, or [transfer a subscription][azure-transfer-subscription] to another account. Conceptually, the AA is the billing owner of the subscription. In RBAC, the AA isn't assigned a role.

Every subscription has a Service Administrator (SA) who can add, remove, and modify Azure resources in that subscription by using the [Azure portal][azure-portal]. The default Service Administrator of a new subscription is the Account Administrator, but the AA can [change the SA][azure-change-sa] in the Account Center.

A subscription is associated with exactly one [Azure AD tenant](tenant.md). Users, groups, and applications from that directory are assigned to roles that have permissions to manage resources in the Azure subscription. You learn more about managing roles and access later in this guide.

Subscriptions determine how resource usage is reported and billed. Each subscription can be configured separately for billing and payment. Additionally, you can tag resources and resource groups for more granular chargeback and 

## Multiple subscriptions

Organizations create multiple Azure subscriptions for a variety of reasons. While each additional Azure subscription does not incur a direct cost, it can increase the complexity of managing your Azure resources. Azure provides a number of capabilities to help larger enterprises and organizations manage deployments across multiple Azure subscriptions. The intermediate adoption stage discusses considerations for managing multiple Azure subscriptions. 

## Next steps

* You now understand Azure subscriptions, and you have created your Azure subscription. Your next step is learning about [resource management in Azure](resource-manager-explainer.md).


<!-- links -->
[azure-portal]: https://portal.azure.com
[azure-account-center]: https://account.azure.com/
[azure-change-sa]: /azure/billing/billing-add-change-azure-subscription-administrator
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[azure-transfer-subscription]: /azure/billing/billing-subscription-transfer

[docs-subscription-limits]: /azure/azure-subscription-service-limits


[azure-get-started]: https://azure.microsoft.com/en-us/get-started/
[azure-offers]: https://azure.microsoft.com/en-us/support/legal/offer-details/
[azure-free-trial]: https://azure.microsoft.com/en-us/offers/ms-azr-0044p/
[azure-change-subscription-offer]: /azure/billing/billing-how-to-switch-azure-offer
[microsoft-account]: https://account.microsoft.com/account
[subscription-service-limits]: /azure/azure-subscription-service-limits
[docs-organizational-account]: /azure/active-directory/sign-up-organization
