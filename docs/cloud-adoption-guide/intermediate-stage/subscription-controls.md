---
title: "Explainer: controls in Azure subscriptions"
description: Explains control mechanisms in Azure subscriptions 
author: alexbuckgit
---

# Explainer: controls in Azure subscriptions

In the foundational adoption stage, you learned [what an Azure subscription is](../adoption-intro/subscription-explainer.md) and you [created your first subscription](../adoption-intro/subscription.md). Subscriptions have other aspects your should consider as you move into the intermediate adoption stage.

Organizations can use subscriptions to control access to Azure resources and manage the associated costs and billing. In addition, Azure defines [subscription limits][subscription-service-limits] (also known as quotas) for most resources &mdash; for example, the number of virtual networks allowed per subscription. Each limit has a default value and a maximum value. Limits can be increased above the default value by [contacting Azure support](/azure/azure-supportability/how-to-create-azure-support-request); maximum values are hard limits for a subscription. Approaching or exceeding any of these limits is one reason why an organization might require an additional subscription.

Azure also provides other ways to control access to Azure resources. *Role-based access control (RBAC)* and *Azure Policy* allow organizations to define rules and limit resource access within a subscription. These capabilities allow organizations to support multiple workloads within a single subscription while providing the security and governance required. You'll learn more about RBAC and policy later in this guide.

> [!NOTE] 
> Prior to the introduction of the Azure Resource Manager deployment model in 2014, Azure had a different deployment model (now known as the "classic deployment model"). The classic deployment model lacked fine-grained control of resources in a subscription, which led organizations to create lots of subscriptions. You may encounter older guidance that is no longer relevant to the new deployment model.    

## Next steps

* Now that you know the basics of controls and limits in Azure subscriptions, let's discuss the basics of [ownership and administration of an Azure subscription](subscription-ownership.md).


<!-- Links -->
[subscription-service-limits]: /azure/azure-subscription-service-limits
