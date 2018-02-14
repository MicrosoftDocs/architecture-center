---
title: "Explainer: what is an Azure Active Directory tenant?"
description: Explains the internal functioning of Azure Active Directory to provide identity as a service (IDaaS) in Azure
author: petertay
---

# Explainer: what is an Azure Active Directory tenant?

In the [how does Azure work?](azure-explainer.md) explainer article, you learned that Azure is a collection of servers and networking hardware running virtualized hardware and software on behalf of users. You also learned that some of these servers run a distributed orchestration application to manage creating, reading, updating, and deleting Azure resources.

Of course, Azure doesn't allow just anyone to perform one of these operations on a resource. Azure restricts access to these operations using a trusted digital identity service called **Azure Active Directory** (Azure AD). Azure AD stores user name, passwords, profile data, and other information. Azure AD users are segmented into **tenants**. A tenant is a logical construct that represents a secure, dedicated instance of Azure AD typically associated with an organization.

In order to create a tenant, Azure requires a **privileged account**. This privileged account is associated with either an Azure account or an enterprise agreement. Both of these are billing constructs and are not stored in Azure AD &mdash; these accounts are stored in a highly secure billing database. 

Once the tenant has been created, a **tenant ID** is generated for the tenant and saved in a highly secure internal Azure AD database. A privileged account owner can then log in to an Azure portal and add users to the newly created Azure AD tenant. 

Most enterprises already have at least one identity management service, typically Active Directory Domain Services (AD DS). Azure AD is capable of synchronizing or federating user identity from AD DS, so enterprises do not need to manage identity separately in the two environments. This will be described in more detail in the intermediate and advanced adoption stage articles for digital identity.

## Next steps

* Now that you have learned about Azure AD tenants, the first step in the foundational adoption stage is to learn [how to get an Azure Active Directory tenant][how-to-get-aad-tenant]. Then review the [design guidance for Azure AD tenants](tenant.md).

<!-- Links -->
[how-to-get-aad-tenant]: /azure/active-directory/develop/active-directory-howto-tenant?toc=/azure/architecture/cloud-adoption-guide/toc.json
