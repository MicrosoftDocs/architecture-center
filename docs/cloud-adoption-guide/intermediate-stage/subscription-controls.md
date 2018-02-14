---
title: "Explainer: controls in Azure subscriptions"
description: Explains control mechanisms in Azure subscriptions 
author: alexbuckgit
---

# Explainer: controls in Azure subscriptions

In the foundational adoption stage, you learned [what an Azure subscription is](../adoption-intro/subscription-explainer.md) and you [created your first subscription](../adoption-intro/subscription.md). Subscriptions have other aspects your should consider as you move into the intermediate adoption stage.

Organizations can use subscriptions to control access to Azure resources and manage the associated costs and billing. In addition, Azure defines [subscription limits] (also known as quotas) for most resources &mdash; for example, the number of virtual networks allowed per subscription. Each limit has a default value and a maximum value. Limits can be increased above the default value by [contacting Azure support](/azure/azure-supportability/how-to-create-azure-support-request); maximum values are hard limits for a subscription. Approaching or exceeding any of these limits is one reason why an organization might require an additional subscription.

Azure also provides other ways to control access to Azure resources. *Role-based access control (RBAC)* and *Azure Policy* allow organizations to define rules and limit resource access within a subscription. These capabilities allow organizations to support multiple workloads within a single subscription while providing the security and governance required. You'll learn more about RBAC and policy later in this guide.

> [!NOTE] 
> Azure's original service model (now known as the "classic deployment model") didn't provide much control over  access to resources in a subscription &mdash; if a user was granted access to a subscription, that user could access any resource in that subscription. This limitation led organizations to create many subscriptions, so that only the appropriate personnel could access various Azure resources.  
> In 2014, Microsoft introduced the Azure Resource Management deployment model. This model enables fine-grained control of Azure resource access via RBAC. The model also provides mechanisms to track costs within a subscription. Because workloads with different access and cost control requirements can now reside in the same subscription, organizations need fewer subscriptions than before. All new Azure deployments should use the Azure Resource Management deployment model, and this guide is entirely based on this model.

## Next steps

* Now that you know the basics of controls and limits in Azure subscriptions, let's discuss the basics of [ownership and administration of an Azure subscription](subscription-ownership.md).
