---
title: Azure Resource Manager considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Resource Manager that are useful when you work with multitenanted systems, and it provides links to guidance and examples for how to use Azure Resource Manager in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 11/22/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - management-and-governance
 - security
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Multitenancy and Azure Resource Manager

Azure Resource Manager is the core resource management service for Azure. Every resource in Azure is created, managed, and eventually deleted through Resource Manager. When you build a multitenant solution, you often work with Resource Manager to dynamically provision resources for each tenant. On this page, we describe some of the features of Resource Manager that are relevant to multitenant solutions. We'll also provide links to guidance that can help you when you're planning to use Resource Manager.

## Features of Resource Manager that support multitenancy

### Infrastructure as code

Resource Manager provides tooling to support infrastructure as code, sometimes referred to as IaC. Infrastructure as code is important for all solutions in the cloud, but when working with multitenant solutions, it becomes particularly important. A multitenant solution often requires you to scale deployments and quickly provision new resources, as you onboard new tenants. If you manually create or configure resources, then you introduce extra risk and time to the process. It results in a less reliable deployment process overall.

When deploying your infrastructure as code from a deployment pipeline, we recommend you use [Bicep](/azure/azure-resource-manager/bicep), which is a language specifically designed to deploy and manage Azure resources in a declarative way. You can also use [JSON Azure Resource Manager templates](/azure/azure-resource-manager/templates) (ARM templates), Terraform, or other third-party products that access the underlying Resource Manager APIs.

[Template specs](/azure/azure-resource-manager/templates/template-specs) can be useful for provisioning new resources, deployment stamps, or environments from a single and well-parameterized template. By using template specs, you can create a central repository of the templates that you use to deploy your tenant-specific infrastructure. The templates are stored and managed within Azure itself, and you can reuse the template specs whenever you need to deploy from them.

In some solutions, you might choose to write custom code to dynamically provision or configure resources, or to initiate a template deployment. The [Azure SDKs](https://azure.microsoft.com/downloads) can be used from your own code, to manage your Azure environment. Ensure that you follow good practices around managing the authentication of your application to Resource Manager, and use [managed identities](/azure/active-directory/managed-identities-azure-resources) wherever possible, to avoid storing and managing credentials.

### Role-based access control

[Role-based access control](/azure/role-based-access-control) (Azure RBAC) provides you with a fine-grained approach to manage access to your Azure resources. In a multitenant solution, consider whether you have resources that should have specific Azure RBAC policies applied. For example, you might have some tenants with particularly sensitive data, and you might need to apply RBAC to grant access to those individuals, without including other people in your organization. Similarly, tenants might ask to access their Azure resources directly, such as during an audit. Should you choose to allow this, finely scoped RBAC permissions can enable you to grant access to a tenant's data, without providing access to another tenants' data.

### Tags

[Tags](/azure/azure-resource-manager/management/tag-resources) enable you to add custom metadata to your Azure resources, resource groups, and subscriptions. Consider tagging your tenant-specific resources with the tenant's identifier so that you can easily [track and allocate your Azure costs](../approaches/cost-management-allocation.md), and to simplify your resource management.

### Azure resource quotas

Resource Manager is one of the points in Azure that enforces [limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits). These quotas are important to consider throughout your design process. All Azure resources have limits that need to be adhered to, and these limits include the number of requests that can be made against Resource Manager, within a certain time period. If you exceed this limit, [Resource Manager throttles the requests](/azure/azure-resource-manager/management/request-limits-and-throttling).

When you build a multitenant solution that performs automated deployments, you might reach these limits faster than other customers. Similarly, multitenant solutions that provision large amounts of infrastructure can trigger the limits.

Every Azure service is managed by a *resource provider*, which may also define its own limits. For example, the Azure Compute Resource Provider manages the provisioning of virtual machines, and [it defines limits on the number of requests](/troubleshoot/azure/virtual-machines/troubleshooting-throttling-errors) that can be made in a short period. Some other resource provider limits are documented in [Resource provider limits](/azure/azure-resource-manager/management/request-limits-and-throttling#resource-provider-limits).

If you are at risk of exceeding the limits defined by Resource Manager or a resource provider, you can consider mitigations, such as the following:

- Shard your workload across subscriptions.
- Use multiple resource groups.
- Send requests from different Azure Active Directory (Azure AD) principals.
- Request additional quota allocations. In general, quota allocation requests are [submitted by opening a support case](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits), although some services provide APIs for these requests, such as for [virtual machine reserved instances](/rest/api/reserved-vm-instances/quotaapi).

The mitigations you select need to be appropriate for the specific limit you encounter.

## Isolation models

In some multitenant solutions, you might decide to deploy separate or dedicated resources for each tenant. Resource Manager provides several models that you can use to isolate resources, depending on your requirements and the reason you choose to isolate the resources.

### Shared resource groups

We recommend that you use resource groups to manage resources with the same lifecycle. In some multitenant systems, it makes sense to deploy resources for multiple tenants into a single resource group or a set of resource groups.

Be aware of the maximum number of resources of a given type that can be deployed into a single resource group, and other [resource group limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#resource-group-limits). You should also be aware of limits that apply to the Azure subscription.

### Resource groups per tenant

You might choose to deploy a resource group for each tenant. This can make sense when you need to manage all of the Azure resources for a specific tenant together as a unit, or when you need to use Azure RBAC to grant permissions to a specific tenant's resources.

Ensure you are aware of the maximum number of resource groups that can be created within a subscription, and other [subscription limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#subscription-limits).

### Subscriptions per tenant

In some scenarios, you might need to deploy dedicated Azure subscriptions for each tenant, or for a subset of your tenants. This is most commonly used when your tenants are enterprise customers with stringent isolation requirements.

You might also choose to create separate Azure subscriptions for the purposes of scaling, such as when you adopt the [Deployment Stamps pattern](../../../patterns/deployment-stamp.md). In this scenario, it's helpful to pre-create your subscriptions, submit any [quota allocation requests](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits) required, and deploy your resources.

Resource Manager provides [APIs and template support](/azure/cost-management-billing/manage/create-subscription) to create Azure subscriptions programmatically, where it depends on your commercial relationship with Microsoft or a Microsoft partner.

[Management groups](/azure/governance/management-groups) enable you to manage a set of subscriptions together. For example, you might create an Azure subscription for tenant A, another for tenant B, and so forth. You can group all of these subscriptions into a management group, which provides you with a convenient way to assign RBAC permissions and policies.

Make you are aware of the number of subscriptions that you can create. The maximum number of subscriptions might differ, depending on your commercial relationship with Microsoft or a Microsoft partner, such as if you have an [enterprise agreement](/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement?tabs=rest#limitations-of-azure-enterprise-subscription-creation-api).

### Azure AD tenants per tenant

It's also possible to create separate Azure AD tenants, such as to manage each of your own tenants in their own Azure AD tenant. Additionally, in some situations, it might make sense to keep your own organization's Azure AD tenant separate from the Azure AD tenant that you use to provision your own tenants' Azure resources.

In general, it's not advisable to create multiple Azure AD tenants. This approach requires additional management effort, and it introduces a significant amount of complexity to your deployment processes. Additionally, it's generally redundant because a single Azure AD tenant can be used by multiple separate subscriptions and Azure resources. Before you make an effort to deploy multiple Azure AD tenants, [consider whether there are other approaches that could achieve your purposes](https://azure.microsoft.com/resources/securing-azure-environments-with-azure-active-directory).

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
