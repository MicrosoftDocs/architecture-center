---
title: Azure AD tenant design guide
description: Guidance for Azure tenant design as part of a foundational cloud adoption strategy
author: telmosampaio
---

# Azure AD tenant design guide

An Azure AD tenant provides a security boundary for identity services and namespace used for one or more [Azure subscriptions](subscription-explainer.md). You should maintain as few tenants as possible. However, there are specific scenarios where you may need more than one tenant. They are:

- **Resources in different Azure regions**. Azure provides four distinct types of cloud environments today: public, sovereign, government, and private. In the public cloud, you can use a single tenant to host services in any public region. However, to use sovereign and government clouds you need a specific tenant just for that cloud environment.

- **Applications that require management level access to Azure AD**. Certain applications may require access to Azure AD to create service principals and subscriptions. To avoid unnecessary changes to your production Azure AD tenant, do not test those applications in a production environment. Instead, consider using a separate Azure AD tenant to develop and test such applications.

- **Active Directory integration**. Azure AD uses a flat directory model. You can only have one domain, without a parent or child. And you can only synchronize accounts from a single Active Directory domain to an Azure AD tenant. If you have a multi-domain or multi-forest AD environment, you should consider whether you need to synchronize all domains. If so, you need to create different Azure AD tenants. TODO: validate this

- **Existing subscriptions**. The early stages of an organization's Azure adoption often leads different individuals to create different subscriptions, each using a Microsoft account instead of an organizational account. When using a Microsoft account to create a subscription, Azure creates a new tenant for you in the onmicrosoft.com namespace. To consolidate these subscriptions as your Azure adoption matures, you can [transfer a subscription][transfer] to a different tenant.

## Next Steps

* You now understand digital identity in Azure, and you have added a new user to your Azure AD tenant. The next step in the adoption process is to create a subscription.

[azure-ad]: azure/active-directory/active-directory-administer
[add-azure-ad]: /azure/active-directory/develop/active-directory-howto-tenant
[transfer]: /azure/active-directory/active-directory-how-subscriptions-associated-directory
