---
title: Architectural approaches for governance and compliance in multitenant solutions
titleSuffix: Azure Architecture Center
description: This article describes approaches to consider for governance and compliance in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 3/13/2022
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

# Architectural approaches for governance and compliance in multitenant solutions

As your use of Azure matures, it's important to consider the governance of your cloud resources. Governance includes how tenants' data is stored and managed, and how you organize your Azure resources. You might also need to follow regulatory, legal, or contractually mandated standards. This article provides information about how to consider governance and compliance in a multitenant solution. It also suggests some of the key Azure platform features that support these concerns.

## Key considerations and requirements

### Resource isolation

Ensure you configure your Azure resources to meet your tenants' isolation requirements. See [Azure resource organization in multitenant solutions](resource-organization.yml) for guidance on isolating your Azure resources. 

### Data management

When you store data on behalf of your tenants, you might have requirements or obligations that you need to meet. From a tenant's perspective, they often expect ownership and control of their data. Consider how you isolate, store, access, and aggregate tenants' data. Uncover tenants' expectations and requirements that could affect how your solution works.

### Isolation

Review the [Architectural approaches for storage and data in multitenant solutions](storage-data.yml) to understand how to isolate tenants' data. Consider whether tenants have requirements to use their own data encryption keys.

Whichever isolation approaches you implement, be prepared for tenants to request an audit of their data. It's a good practice to document all of the data stores in which tenants' data might be kept. Common data sources include the following:

- Databases and storage accounts deployed as part of your solution.
- Identity systems, which are often shared between tenants.
- Logs.
- Data warehouses.

### Sovereignty

Understand whether there are any restrictions on the physical location for your tenants' data that's to be stored or processed. Your tenants might require you store their data in specific geographic locations. They might also require that you *don't* store their data in certain locations. Although these requirements are commonly based on legislation, they can also be based on cultural values and norms.

For more information about data residency and sovereignty, see the whitepaper [Enabling Data Residency and Data Protection in Microsoft Azure Regions](https://azure.microsoft.com/resources/achieving-compliant-data-residency-and-security-with-azure).

### Tenants' access to data that you store

Tenants sometimes request direct access to the data you store on their behalf. For example, they might want to ingest their data into their own data lake.

Plan how you'll respond to these requests. Consider whether any of the tenants' data is kept in shared data stores. If it is, plan how you'll avoid tenants accessing other tenants' data.

Avoid providing direct access to databases or storage accounts unless you designed for this requirement, such as by using the [Valet Key pattern](../../../patterns/valet-key.yml). Consider creating an API or automated data export process for integration purposes.

For more information about integration with tenants' systems, and external systems, see [Architectural approaches for tenant integration and data access](./integration.md).

### Your access to tenants' data

Consider whether your tenants' requirements restrict the personnel who can work with their data or resources. For example, suppose you build a SaaS solution that's used by many different customers. A government agency might require that only citizens of their country/region are allowed to access the infrastructure and data for their solution. You might meet this requirement by using separate Azure resource groups, subscriptions, or management groups for sensitive customer workloads. You can apply tightly scoped Azure role-based access controls (RBAC) role assignments for specific groups of users to work with these resources.

### Aggregation of data from multiple tenants

Consider whether you need to combine or aggregate data from multiple tenants. For example, do you analyze the aggregated data, or train machine learning models that could be applied to other tenants? Ensure your tenants understand the ways in which you use their data. Include any use of aggregated or anonymized data.

### Compliance requirements

It's important that you understand whether you need to meet any compliance standards. Compliance requirements might be introduced in several situations, including:

- You, or any of your tenants, work within certain industries. For example, if any of your tenants work in the [healthcare industry](../../../industries/healthcare.md), you might need to comply with the HIPAA standard.
- You, or any of your tenants, are located in geographic or geopolitical regions that require compliance with local laws. For example, if any of your tenants are located in Europe, you might need to comply with [General Data Protection Regulation (GDPR)](/compliance/regulatory/gdpr).
- You purchase a cyberinsurance policy to mitigate the risk of breaches. Cyberinsurance providers might require that you follow their standards and apply specific controls for your policy to be valid.

> [!IMPORTANT]
> Compliance is a shared responsibility between Microsoft, you, and your tenants.
>
> Microsoft ensures that our services meet a specific set of compliance standards, and provides tools like [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) that help to verify your resources are configured according to those standards.
> 
> However, ultimately it is your responsibility to fully understand the compliance requirements that apply to your solution, and how to configure your Azure resources according to those standards. See [Azure compliance offerings](/azure/compliance/offerings) for more detail.
> 
> This article doesn't provide specific guidance about how to become compliant with any particular standards. Instead, it provides some general guidance around how to consider compliance and governance in a multitenant solution.

If different tenants need you to follow different compliance standards, plan to comply with the most stringent standard across your entire environment. It's easier to follow one strict standard than to follow different standards for different tenants.

## Approaches and patterns to consider

### Resource tags

Use [resource tags](cost-management-allocation.yml#allocate-costs-by-using-resource-tags) to track the tenant identifier for tenant-specific resources, or the stamp identifier when you scale using the [Deployment Stamps pattern](#deployment-stamps-pattern). By using resource tags, you can quickly identify resources that are associated with specific tenants or stamps.

### Access control

Use [Azure RBAC](/azure/role-based-access-control/overview) to restrict access to the Azure resources that constitute the multitenant solution. Follow the RBAC [best practices](/azure/role-based-access-control/best-practices), such as applying role assignments to groups instead of users. Scope your role assignments so they provide the minimum permissions necessary. Avoid long-standing access to resources by using just-in-time access and features like [Azure Active Directory Privileged Access Management](/azure/active-directory/privileged-identity-management/pim-configure).

### Azure Resource Graph

[Azure Resource Graph](/azure/governance/resource-graph/overview) enables you to work with Azure resource metadata. By using Resource Graph, you can query across a large number of Azure resources, even if they're spread across multiple subscriptions. Resource Graph can query for the resources of a specific type, or to identify resources that have been configured in specific ways. It can also be used to track the history of a resource's configuration.

Resource Graph can be helpful to manage large Azure estates. For example, suppose you deploy tenant-specific Azure resources across multiple Azure subscriptions. By [applying tags to your resources](#resource-tags), you can use the Resource Graph API to find resources that are used by specific tenants or deployment stamps.

### Azure Purview

Consider using [Azure Purview](https://azure.microsoft.com/services/purview) to track and classify the data that you store. When tenants request access to their data, you can easily determine the data sources that you should include.

### Verify compliance with standards

Use tools like [Azure Policy](/azure/governance/policy/overview), [Microsoft Defender for Cloud's regulatory compliance portal](/azure/defender-for-cloud/regulatory-compliance-dashboard), and [Azure Advisor](https://azure.microsoft.com/services/advisor). These tools help you to configure your Azure resources to meet compliance requirements and to follow the recommended best practices.

### Generate compliance documentation

Your tenants might require that you demonstrate your compliance with specific standards. Use the [Service Trust Portal](https://servicetrust.microsoft.com) to generate compliance documentation that you can provide to your tenants or to third-party auditors.

Some multitenant solutions incorporate Microsoft 365 and use services like Microsoft OneDrive, Microsoft SharePoint, and Microsoft Exchange Online. The [Microsoft Purview compliance portal](https://compliance.microsoft.com) helps you understand how these services comply with regulatory standards.

### Deployment Stamps pattern

Consider following the [Deployment Stamps pattern](overview.yml#deployment-stamps-pattern) when you need to comply with tenant-specific requirements.

For example, you might deploy stamps of your solution into multiple Azure regions. Then, you can assign new tenants to stamps, based on the regions that they need to have their data located in.

Similarly, a new tenant might introduce strict compliance requirements that you can't meet within your existing solution components. You can consider deploying a dedicated stamp for that tenant, and then configure it according to their requirements.

## Antipatterns to avoid

- **Not understanding your tenants' compliance requirements.** It's important not to make assumptions about the compliance requirements that your tenants might impose. If you plan to grow your solution into new markets, be mindful of the regulatory environment that your tenants are likely to operate within.
- **Ignoring good practices.** If you don't have any immediate need to adhere to compliance standards, you should still follow good practices when you deploy your Azure resources. For example, isolate your resources, apply policies to verify resource configuration, and apply role assignments to groups instead of users. By following good practices, you make it simpler to follow compliance standards when you eventually need to do so.
- **Assuming there are no compliance requirements.** When you first launch a multitenant solution, you might not be aware of compliance requirements, or you might not need to follow any. As you grow, you'll likely need to provide evidence that you comply with various standards. Use [Microsoft Defender for Cloud](/azure/defender-for-cloud/regulatory-compliance-dashboard) to monitor your compliance posture, even before you have an explicit requirement to do so.
- **Not planning for management.** As you deploy your Azure resources, consider how you plan to manage them. If you need to make bulk updates to resources, ensure you have an understanding of automation tools, such as the Azure CLI, Azure PowerShell, Azure Resource Graph, and the Azure Resource Manager APIs.
- **Not using management groups.** Plan your subscription and management group hierarchy, including access control and Azure Policy resources at each scope. It can be difficult and disruptive to introduce or change these elements when your resources are used in a production environment.
- **Failing to plan your access control strategy.** Azure RBAC provides a high degree of control and flexibility in how you manage access to your resources. Ensure you use Azure AD groups to avoid assigning permissions to individual users. Assign roles at scopes that provide an appropriate balance between security and flexibility. Use built-in role definitions wherever possible, and assign roles that provide the minimum permissions required.
- **Not using Azure Policy.** It's important to use Azure Policy to govern your Azure environment. After you plan and deploy policies, ensure you monitor the policy compliance and carefully review any violations or exceptions.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [approaches for cost management and allocation](cost-management-allocation.yml).
