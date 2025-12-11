---
title: Azure Resource Manager Considerations for Multitenancy
description: Learn how to use the features of Azure Resource Manager when you work with multitenant systems, and get links to guidance and examples.
author: johndowns
ms.author: pnp
ms.date: 06/11/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - devx-track-arm-template
  - arb-saas
---

# Multitenancy and Azure Resource Manager

Azure Resource Manager is the core resource management service for Azure. It creates, manages, and deletes every Azure resource, including virtual machines, storage accounts, and databases. When you build a multitenant solution, you often use Resource Manager to dynamically provision resources for each tenant. This article describes key features of Resource Manager that apply to multitenant solutions. It also includes links to guidance that can help you use Resource Manager.

## Features of Resource Manager that support multitenancy

### Infrastructure as code

Resource Manager provides tooling to support infrastructure as code (IaC). You should define IaC for all solutions in the cloud, but it's especially valuable for multitenant solutions. A multitenant solution often requires you to scale deployments and provision new resources when you onboard new tenants. Manual resource creation or configuration takes more time and creates more risk. A manual approach results in a less reliable deployment process overall.

Use [Bicep](/azure/azure-resource-manager/bicep) to deploy IaC from a deployment pipeline. Bicep is a language designed to deploy and manage Azure resources in a declarative way. You can also use [JSON Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates), Terraform, or other partner products that access the underlying Resource Manager APIs.

[Deployment stacks](/azure/azure-resource-manager/bicep/deployment-stacks) help you manage a set of resources as a single unit, even if they span across resource groups or subscriptions. Deployment stacks are helpful if you provision multiple tenant-specific resources in different places and need to manage their life cycle as one logical unit.

[Template specs](/azure/azure-resource-manager/templates/template-specs) help you provision new resources, deployment stamps, or environments from a single, well-parameterized template. Use template specs to create a central repository of templates that you use to deploy your tenant-specific infrastructure. Azure stores and manages these templates. You can reuse the template specs whenever you need to deploy infrastructure.

In some solutions, you might write custom code to dynamically provision or configure resources or to initiate a template deployment. You can use the [Azure SDKs](https://azure.microsoft.com/downloads) in your code to manage your Azure environment. Follow best practices for authenticating your application to Resource Manager. To avoid storing and managing credentials, use [managed identities](/entra/identity/managed-identities-azure-resources/).

### Azure role-based access control

[Azure role-based access control (Azure RBAC)](/azure/role-based-access-control) provides a fine-grained approach to manage access to your Azure resources. In a multitenant solution, evaluate whether resources require specific Azure RBAC policies. For example, some tenants might handle sensitive data, and you might need to apply Azure RBAC to grant access to certain individuals without including other people in your organization. Tenants might also request direct access to their Azure resources, such as during an audit. If you allow this access, finely scoped Azure RBAC permissions can enable you to grant access to a tenant's data without exposing other tenants' data.

### Tags

Use [tags](/azure/azure-resource-manager/management/tag-resources) to add custom metadata to your Azure resources, resource groups, and subscriptions. Consider tagging your tenant-specific resources with the tenant's identifier so that you can simplify resource management and [track and allocate Azure costs](../approaches/cost-management-allocation.md).

### Azure resource quotas

Resource Manager is the central service in Azure that enforces [limits and quotas](/azure/azure-resource-manager/management/azure-subscription-service-limits) across many other Azure services. Consider these quotas throughout your design process. All Azure resources have defined limits, including the number of requests allowed against Resource Manager within a certain time period. If you exceed this limit, [Resource Manager throttles the requests](/azure/azure-resource-manager/management/request-limits-and-throttling).

When you build a multitenant solution that performs automated deployments, you might reach these limits faster than other customers. Multitenant solutions that provision large amounts of infrastructure can also trigger these limits.

A *resource provider* manages each Azure service. The resource provider might also define its own limits. For example, the Azure Compute Resource Provider manages the provisioning of virtual machines, and it [defines limits on the number of allowed requests](/troubleshoot/azure/virtual-machines/troubleshooting-throttling-errors) within a short period. For more information, see [Resource provider limits](/azure/azure-resource-manager/management/request-limits-and-throttling#resource-provider-limits).

If you risk exceeding Resource Manager or resource provider limits, consider the following mitigations:

- Distribute your workload across multiple Azure subscriptions.

- Use multiple resource groups within each subscription.
- Send requests from different Microsoft Entra principals.
- Request extra quota allocations. To submit a quota allocation request, you typically [open a support case](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits). But some services provide APIs for these requests, such as [virtual machine reserved instances](/rest/api/reserved-vm-instances/quotaapi).

Choose mitigation strategies that directly address the specific limit that you encounter.

## Isolation models

In some multitenant solutions, you might deploy separate or dedicated resources for each tenant. Resource Manager provides several models that you can use to isolate resources, depending on your requirements and the reasons for isolation. For more information, see [Azure resource organization in multitenant solutions](../approaches/resource-organization.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributor:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Deployment and configuration approaches for multitenancy](../approaches/deployment-configuration.md)
