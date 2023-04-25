---
title: Azure Resource Manager considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Resource Manager that are useful when you work with multitenanted systems, and it provides links to guidance and examples for how to use Azure Resource Manager in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 02/28/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-resource-manager
categories:
 - management-and-governance
 - devops
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
  - devx-track-arm-template
---

# Multitenancy and Azure Resource Manager

Azure Resource Manager is the core resource management service for Azure. Every resource in Azure is created, managed, and eventually deleted through Resource Manager. When you build a multitenant solution, you often work with Resource Manager to dynamically provision resources for each tenant. On this page, we describe some of the features of Resource Manager that are relevant to multitenant solutions. We'll also provide links to guidance that can help you when you're planning to use Resource Manager.

## Features of Resource Manager that support multitenancy

### Infrastructure as code

Resource Manager provides tooling to support infrastructure as code, sometimes referred to as IaC. Infrastructure as code is important for all solutions in the cloud, but when working with multitenant solutions, it becomes particularly important. A multitenant solution often requires you to scale deployments, and to provision new resources as you onboard new tenants. If you manually create or configure resources, then you introduce extra risk and time to the process. It results in a less reliable deployment process overall.

When deploying your infrastructure as code from a deployment pipeline, we recommend you use [Bicep](/azure/azure-resource-manager/bicep), which is a language specifically designed to deploy and manage Azure resources in a declarative way. You can also use [JSON Azure Resource Manager templates](/azure/azure-resource-manager/templates) (ARM templates), Terraform, or other third-party products that access the underlying Resource Manager APIs.

[Template specs](/azure/azure-resource-manager/templates/template-specs) can be useful for provisioning new resources, deployment stamps, or environments from a single and well-parameterized template. By using template specs, you can create a central repository of the templates that you use to deploy your tenant-specific infrastructure. The templates are stored and managed within Azure itself, and you can reuse the template specs whenever you need to deploy from them.

In some solutions, you might choose to write custom code to dynamically provision or configure resources, or to initiate a template deployment. The [Azure SDKs](https://azure.microsoft.com/downloads) can be used from your own code, to manage your Azure environment. Ensure that you follow good practices around managing the authentication of your application to Resource Manager, and use [managed identities](/azure/active-directory/managed-identities-azure-resources) to avoid storing and managing credentials.

### Role-based access control

[Role-based access control](/azure/role-based-access-control) (Azure RBAC) provides you with a fine-grained approach to manage access to your Azure resources. In a multitenant solution, consider whether you have resources that should have specific Azure RBAC policies applied. For example, you might have some tenants with particularly sensitive data, and you might need to apply RBAC to grant access to certain individuals, without including other people in your organization. Similarly, tenants might ask to access their Azure resources directly, such as during an audit. Should you choose to allow this, finely scoped RBAC permissions can enable you to grant access to a tenant's data, without providing access to other tenants' data.

### Tags

[Tags](/azure/azure-resource-manager/management/tag-resources) enable you to add custom metadata to your Azure resources, resource groups, and subscriptions. Consider tagging your tenant-specific resources with the tenant's identifier so that you can easily [track and allocate your Azure costs](../approaches/cost-management-allocation.yml), and to simplify your resource management.

### Azure resource quotas

Resource Manager is one of the points in Azure that enforces [limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits). These quotas are important to consider throughout your design process. All Azure resources have limits that need to be adhered to, and these limits include the number of requests that can be made against Resource Manager within a certain time period. If you exceed this limit, [Resource Manager throttles the requests](/azure/azure-resource-manager/management/request-limits-and-throttling).

When you build a multitenant solution that performs automated deployments, you might reach these limits faster than other customers. Similarly, multitenant solutions that provision large amounts of infrastructure can trigger the limits.

Every Azure service is managed by a *resource provider*, which may also define its own limits. For example, the Azure Compute Resource Provider manages the provisioning of virtual machines, and [it defines limits on the number of requests](/troubleshoot/azure/virtual-machines/troubleshooting-throttling-errors) that can be made in a short period. Some other resource provider limits are documented in [Resource provider limits](/azure/azure-resource-manager/management/request-limits-and-throttling#resource-provider-limits).

If you are at risk of exceeding the limits defined by Resource Manager or a resource provider, consider the following mitigations:

- Shard your workload across multiple Azure subscriptions.
- Use multiple resource groups within subscriptions.
- Send requests from different Azure Active Directory (Azure AD) principals.
- Request additional quota allocations. In general, quota allocation requests are [submitted by opening a support case](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits), although some services provide APIs for these requests, such as for [virtual machine reserved instances](/rest/api/reserved-vm-instances/quotaapi).

The mitigations you select need to be appropriate for the specific limit you encounter.

## Isolation models

In some multitenant solutions, you might decide to deploy separate or dedicated resources for each tenant. Resource Manager provides several models that you can use to isolate resources, depending on your requirements and the reason you choose to isolate the resources. See [Azure resource organization in multitenant solutions](../approaches/resource-organization.yml) for guidance about how to isolate your Azure resources.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributor:

 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.yml).
