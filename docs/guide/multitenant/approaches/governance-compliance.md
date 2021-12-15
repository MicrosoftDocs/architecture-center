---
title: Architectural approaches for governance and compliance in a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for governance and compliance in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 12/09/2021
ms.topic: conceptual
ms.service: architecture-center
products:
 - azure
categories:
 - management-and-governance
 - security
ms.subservice: azure-guide
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural approaches for governance and compliance in a multitenant solution

Intro paragraph

## Key considerations and requirements

### Tenant isolation

Consider whether your tenants have requirements that might affect the level of isolation you can use for their data or resources. For example:

* Will you deploy any dedicated Azure resources for each tenant?
* If yes, how far do you need to go with isolation? Do your customers/tenants have requirements?
  * Do you need different RBAC role assignments for each tenant? e.g. certain people in your org can only work with certain tenants? Need to plan your role assignments accordingly. Use groups instead of individual users.

### Compliance requirements

It's important that you understand whether you have any compliance requirements that you need to meet.

When you, or any of your tenants, work within certain industries or in specific geographic regions you might be required to follow compliance standards. For example, if any of your tenants are in the healthcare industry, you might need to comply with the HIPAA standard. If any of your customers are located in Europe, you might need to comply with GDPR.

> [!IMPORTANT]
> Compliance is a shared responsibility between Microsoft, you, and your tenants.
>
> Microsoft ensures that our services meet a specific set of compliance standards, and provides tools like [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) that help to verify your resources are configured according to those standards.
> 
> However, ultimately it is your responsibility to fully understand the compliance requirements that apply to your solution, and how to configure your Azure resources according to those standards. See [Azure compliance offerings](/azure/compliance/offerings/) for more detail.
> 
> This page doesn't provide specific guidance about how to become compliant with any particular standards. Instead, it provides some general guidance around how to consider compliance and governance in a multitenant solution.

If you have many different tenants that have different requirements, you should plan to comply with the most stringent standard. It's usually more straightforward to follow one strict standard than to follow different standards for different tenants.

### Data sovereignty

Ensure you understand whether there are any geographical restrictions on where data should be stored or processed. Your tenants might require that their data be stored in specific geographic locations, or might require their data is not stored in other locations. While these requirements are often based on legislation, they can also be based on cultural values.

### Data management

* Ensure you review the [storage and data approaches](storage-data.md) to understand how to isolate tenants' data based on your isolation requirements, and for other important considerations.
* Consider tenants' encryption requirements, including [encryption at rest](/azure/security/fundamentals/encryption-atrest), and whether they need to maintain their own encryption keys.
* What happens if a tenant requests direct access to the data that you store for them? For example, if they want to ingest their data into their own data lake.
  * Consider whether their data is isolated sufficiently.
  * Could also offer to export their data in specific formats to mitigate risks of direct access to data.
* Consider whether you have any tenants concerned about having their data shared.
  * Remember to include shared systems like identity and data warehouses.
  * Consider using Purview to classify data.
* Consider whether you need to aggregate data across tenants, such as for analysis or to train ML models. Ensure you're clear with your tenants about how their data will be used, even in aggregate form.

## Approaches and patterns to consider

### Resource organization approaches

* Consider whether you need to isolate resources at different levels.
* Can use IAM to restrict access. Scope your role assignments appropriately. Use groups instead of users.
* Can use [resource tags](cost-management-allocation.md#allocate-costs-by-using-resource-tags) to track the tenant identifier for tenant-specific resources, or the stamp identifier when you scale using the [Deployment Stamps pattern](#deployment-stamps-pattern).

### Azure Resource Graph

* [Azure Resource Graph](/azure/governance/resource-graph/overview) enables you to query across a large number of Azure resources, even if they're in separate subscriptions.
* This can be helpful when you deploy tenant-specific resources and need to query for the number of resources of a specific type, or to identify resources configured in specific ways.
* When you use tags, you can use the Resource Graph API to query the resources used by specific tenants or stamps.

### Follow compliance standards

* Compliance with standards is a shared responsibility between you and Microsoft
* Use tools like Azure Policy, Microsoft Defender for Cloud's regulatory compliance portal, and Azure Advisor to ensure you're configuring your resources correctly

### Compliance requirements and documentation

* Use [Service Trust Portal](https://servicetrust.microsoft.com/) to generate Azure compliance documentation
* If you use Microsoft 365 as part of your solution, also review the [Microsoft 365 compliance center](https://compliance.microsoft.com). For example, this covers how PII is handled, especially if you use OneDrive, SharePoint, Exchange, etc as part of your solution.

### Deployment Stamps pattern

Consider using the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern) when you need to comply with tenant-specific requirements.

For example, if you deploy stamps of your solution into multiple Azure regions, you can assign new tenants to stamps based on the regions they need to have their data located in.

Similarly, if a tenant has strict compliance requirements that you can't meet in your existing stamps, you can consider deploying a dedicated stamp for the tenant to use, and configure it according to their requirements.

## Antipatterns to avoid

- **Not understanding your tenants' compliance requirements.** It's important not to make assumptions about the compliance requirements that your tenants might impose. If you plan to grow your solution into new markets, be mindful of the regulatory environment that your tenants are likely to operate within. Follow good practices when you deploy your Azure resources to minimize the impact of following new compliance standards.
- **Assuming there are no compliance requirements.** When you first launch a multitenant solution, you might not be aware of compliance requirements or you might not need to follow any. As you grow, you're likely to need to provide evidence that you comply with various standards. Use [Azure Defender for Cloud](TODO) to monitor your compliance posture, even before you need to.
- **Not planning for management.** As you deploy your Azure resources, consider how you plan to manage them. If you need to make bulk updates to resources, ensure you have an understanding of automation tools like Azure PowerShell, the Azure CLI, and the Resource Graph API.
- **Not using management groups.** Plan your subscription and management group hierarchy, including access control and Azure Policy resources at each scope. It can be challenging to change these elements when your resources are in use.
- **Not planning your access control effectively.** Azure's role-based access control (RBAC) system provides a high degree of control and flexibility in how you manage access to your resources. Ensure you use Azure AD groups to avoid assigning permissions to individual users. Assign roles at scopes that provide an appropriate balance between security and flexibility. Use built-in role definitions wherever possible, and assign roles that provide the minimum permissions required.
- **Not using Azure Policy.** It's important to use Azure Policy to govern your Azure environment. After you plan and deploy policies, ensure you monitor the policy compliance and carefully review any violations or exceptions.

## Next steps

Links to other relevant pages within our section.
