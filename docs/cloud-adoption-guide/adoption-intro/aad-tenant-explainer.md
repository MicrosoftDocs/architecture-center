---
title: Explainer - What is an Azure Active Directory tenant?
description: Explains the internal functioning of Azure Active Directory to provide identity as a service (IDaaS) in Azure
author: petertay
---

# Explainer: What is an Azure Active Directory tenant?

In the [how does Azure work? explainer](azure-explainer.md), you learned that Azure is a collection of servers and networking hardware running virtualized hardware and software on behalf of  users. You also learned that some of these servers run a distributed orchestration application to manage the creation, modification, and deletion of Azure resources.

Azure doesn't allow just anyone to request a resource be created, modified, or deleted - it requires that users authenticate their digital identity and then determines if it is allowed to perform the request on the authenticated user's behalf. 

Azure trusts a Microsoft identity as a service (IDaaS) provider named **Azure Active Directory** (Azure AD) to authenticate digital identity. Azure AD users are segmented into **tenants**. A tenant is simply a secure, dedicated instance of Azure AD. 

In order to create a tenant, Azure requires a **privileged account**. This privieged account is associated with either an Azure account or an enterprise agreement. Both of these are billing constructs and are not stored in Azure AD - these accounts are stored in a higly secure billing database. 

Once the tenant has been created, a **tenant identifier** is generated for the tenant and saved in a highly secure internal Azure AD database. A priviliged account owner can then log in to an Azure portal to add users to the newly created Azure AD tenant. 

These users can then authenticate with Azure AD, and this allows them to send requests to Azure to create, modify, or delete resources. For example, if the request was to create a resource, Azure creates the resource and saves a unique identifier associated with the user along with the tenant ID in an internal database. This is how Azure knows which tenant owns which resource and which user requested 

Most enterprises already have at least one identity management service - typicaly Active Directory Domain Services (AD DS). Azure AD is capable of synchronizing or federating user identity from AD DS, so enterprises do not need to manage identity seperately in the two environments.

## Next steps

* Now that you have learned about Azure Active Directory tenants, the first step in the foundational adoption stage is to [create your first user in Azure AD](/azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json). 

