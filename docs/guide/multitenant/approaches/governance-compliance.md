---
title: Architectural approaches for governance and compliance in a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for governance and compliance in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 12/16/2021
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

<!-- TODO -->

## Key considerations and requirements

### Resource isolation

Ensure you configure your Azure resources to meet your tenants' isolation requirements. See [Azure resource organization in multitenant solutions](TODO) for guidance on isolating your Azure resources. 

### Compliance requirements

It's important that you understand whether you need to meet any compliance standards. This might occur in several situations, including:

- You, or any of your tenants, work within certain industries. For example, if any of your tenants work in the healthcare industry, you might need to comply with the HIPAA standard.
- You, or any of your tenants, are located in geographic or geopolitical regions that require compliance with local laws. For example, if any of your tenants are located in Europe, you might need to comply with GDPR.

> [!IMPORTANT]
> Compliance is a shared responsibility between Microsoft, you, and your tenants.
>
> Microsoft ensures that our services meet a specific set of compliance standards, and provides tools like [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) that help to verify your resources are configured according to those standards.
> 
> However, ultimately it is your responsibility to fully understand the compliance requirements that apply to your solution, and how to configure your Azure resources according to those standards. See [Azure compliance offerings](/azure/compliance/offerings/) for more detail.
> 
> This page doesn't provide specific guidance about how to become compliant with any particular standards. Instead, it provides some general guidance around how to consider compliance and governance in a multitenant solution.

If you have many different tenants that have different requirements, plan to comply with the most stringent standard. It's easier to follow one strict standard than to follow different standards for different tenants.

### Data management

When you store data on behalf of your tenants, you might have requirements or obligations that you need to meet.

#### Isolation

Review the [Architectural approaches for storage and data in multitenant solutions](storage-data.md) to understand how to isolate tenants' data. You should also consider whether your tenants have requirements for their own data encryption keys.

Whichever isolation approaches you consider, it's a good practice to document all of the data stores in which tenants' data might be kept. These can include the following locations:

- Databases and storage accounts deployed as part of your solution.
- Identity systems, which are often shared between tenants.
- Logs.
- Data warehouses.

Be prepared for tenants to request an audit of their data. Consider using [Azure Purview](https://azure.microsoft.com/services/purview/) to track and classify the data you store.

#### Sovereignty

Understand whether there are any restrictions on the physical location for your tenants' data to be stored or processed. Your tenants might require that their data be stored in specific geographic locations, or might require their data is not stored in other locations. Although these requirements are commonly based on legislation, they can also be based on cultural values and norms.

#### Tenants' access to data

Tenants sometimes request direct access to the data that you store on their behalf. For example, they might want to ingest their data into their own data lake.

Plan how you'll respond to these requests. Consider whether any of the tenants' data is stored in shared data stores, and if so, how you can avoid tenants accessing other data.

Avoid providing direct access to databases or storage accounts unless you have specifically designed for this requirement, such as by using the [Valet Key pattern](../../../patterns/valet-key.md). Consider creating an API or automated data export process for integration purposes.

#### Aggregation of data

Consider whether you need to combine or aggregate data from multiple tenants. For example, do you need to perform data analysis, or train machine learning models that could be applied to other tenants? Ensure your tenants understand the ways in which you use their data, even if it's in aggregated or anonymized forms.

### Access control

Consider whether your tenants' requirements restrict the personnel who can work with their data or resources. For example, suppose you build a SaaS solution used by many different customers. A government agency might require that only citizens of their country be provided with access to the infrastructure and data used to serve their requests. You could meet this requirement by using separate Azure resource groups, subscriptions, or management groups for sensitive customer workloads. You can apply tightly scoped Azure IAM role assignments for specific groups of users to work with these resources.

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
