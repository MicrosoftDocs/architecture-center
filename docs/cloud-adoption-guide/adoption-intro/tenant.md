---
title: "Guidance: Azure AD tenant design"
description: Guidance for Azure tenant design as part of a foundational cloud adoption strategy
author: telmosampaio
---

# Guidance: Azure AD tenant design

An Azure AD tenant provides digital identity services and namespaces used for one or more [Azure subscriptions](subscription-explainer.md). If you are following the foundational adoption outline, you have already learned [how to get an Azure AD tenant][how-to-get-aad-tenant]. 

## Design considerations

- At the foundational adoption stage, you can begin with a single Azure AD tenant. If your organization has an existing Office 365 subscription or an Azure subscription, you already have an Azure AD tenant that you can use. If you do not have either or of these, you can learn more about [how to get an Azure AD tenant][how-to-get-aad-tenant]. 
- In the intermediate and advanced adoption stages, you will learn how to synchronize or federate on-premises directories with Azure AD. This will allow you to use on-premises digital identity in Azure AD. However, at the foundational stage, you will be adding new users that only have identity your single Azure AD tenant. You are be responsible for managing those identities. For example, you will have to on-board new Azure AD users, off-board Azure AD users that you no longer wish to have access to Azure resources, and other changes to user permissions.

## Next Steps

* Now that you have an Azure AD tenant, learn [how to add a user][azure-ad-add-user]. After you have added one or more new users to your Azure AD tenant, your next step is learning about [Azure subscriptions](subscription-explainer.md).

<!-- Links -->

[azure-ad-add-user]: /azure/active-directory/add-users-azure-active-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json
[docs-manage-azure-ad]: /azure/active-directory/active-directory-administer?toc=/azure/architecture/cloud-adoption-guide/toc.json
[docs-tenant]: /azure/active-directory/develop/active-directory-howto-tenant?toc=/azure/architecture/cloud-adoption-guide/toc.json
[docs-associate-subscription]: /azure/active-directory/active-directory-how-subscriptions-associated-directory?toc=/azure/architecture/cloud-adoption-guide/toc.json
[how-to-get-aad-tenant]: /azure/active-directory/develop/active-directory-howto-tenant?toc=/azure/architecture/cloud-adoption-guide/toc.json