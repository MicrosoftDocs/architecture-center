---
title: "Explainer: what is an Azure subscription?"
description: Explains the basic characteristics of an Azure subscription
author: alexbuckgit
---

# Explainer: what is an Azure subscription?

In the [what is an Azure Active Directory tenant?](tenant-explainer.md) explainer article, you learned that digital identity for your organization is stored in an Azure AD tenant. You also learned that Azure trusts Azure AD to authenticate users that send requests to create, read, update, or delete a resource. 

We understand why it's essential to restrict access to these operations: to prevent unauthenticated and unauthorized users from accessing our resources. Azure also sets upper limits on the total number of resources created and helps manage the cost of operating those resources. 

Azure implements this control, and it is known as a **subscription**. A subscription holds a group of Azure resources along with the users who create and manage those resources. Each resource in a subscription is constrained by an [upper limit][subscription-service-limits] defined for each type of resource.

Organizations can use subscriptions to manage costs and limit creation of resources by user, team, project, or other factors. These factors are discussed in the intermediate and advanced adoption stage articles. 

## Next steps

* Now that you have learned about Azure subscriptions, learn more about [creating a subscription](subscription.md) before you create your first Azure resources.

<!-- Links -->
[subscription-service-limits]: /azure/azure-subscription-service-limits
