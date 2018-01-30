---
title: Azure tenant design guide
description: Guidance for Azure tenant design as part of a foundational cloud adoption strategy
author: telmosampaio
---

# Azure tenant design guide

An Azure AD tenant provides a security boundary for identity services and namespace used for one or more [Azure subscriptions][subscription]. Your practice should be to maintain as few tenants as necessary. However, there are specific scenarios where you may need more than one scenario. They are:

- **Resources in different Azure regions**. Azure provides four distinct types of cloud environments today: public, sovereign, government, and private. In the public cloud, you can use a single tenant to host services in any public region. However, to use sovereign and government clouds you need a specific tenant just for that cloud environment.

- **Applications that require management level access to Azure AD**. Certain applications may require access to Azure AD to create service principals and subscriptions. You do not want to test those applications in a production environment, to avoid unnecessary changes to Azure AD. For that reason, you should consider using a separate Azure AD tenant to develop and test such applications.

- **Active Directory integration**. Azure AD uses a flat directory model. You can only have one domain, without a parent or child. And you can only synchronized accounts from a single Active Directory domain to an Azure AD tenant. If you have a multi domain or multi forest AD environment, you should consider if there is a need to synchronize all domains, and if so, you need to create different Azure AD tenants TODO: validate this

- **Existing subscriptions**. When you create a new Azure subscription using a Microsoft account instead of an account from your own organization, Azure creates a tenant for you under the onmicrosoft.com namspace. IN a bottom-up and opportunistic scenario, yuou encounter different people in the organization creating their own subscroptions, which leads to multiple tenants. You want to avoid scenarios like this, but it is almost impossible to do so. THerefore, you can [transfer a subscriptiont][transfer] to a different tenant at ay point in time.

[azure-ad]: azure/active-directory/active-directory-administer
[add-azure-ad]: /azure/active-directory/develop/active-directory-howto-tenant
[subscription]: ./subscription.md
[trasnfer]: /azure/active-directory/active-directory-how-subscriptions-associated-directory