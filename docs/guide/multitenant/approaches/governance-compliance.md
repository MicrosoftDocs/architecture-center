---
title: Architectural Approaches for Governance and Compliance in Multitenant Solutions
description: Learn about governance and compliance approaches for multitenant solutions, including data sovereignty, access control, and regulatory standards.
ai-usage: ai-assisted
author: johndowns
ms.author: pnp
ms.date: 08/10/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for governance and compliance in multitenant solutions

As your use of Azure matures, it's important to consider the governance of your cloud resources. Governance includes how tenants' data is stored and managed and how you organize your Azure resources. You might also need to follow regulatory, legal, or contractually mandated standards. This article provides information about how to consider governance and compliance in a multitenant solution. It also suggests some of the key Azure platform features that support these concerns.

## Key considerations and requirements

Consider the following key considerations and requirements.

### Resource isolation

Ensure that you configure your Azure resources to meet your tenants' isolation requirements. For more information, see [Azure resource organization in multitenant solutions](resource-organization.md).

### Data management

When you store data on behalf of your tenants, you might have requirements or obligations that you need to meet. From a tenant's perspective, they often expect ownership and control of their data. Consider how you isolate, store, access, and aggregate tenants' data. Uncover tenants' expectations and requirements that might affect how your solution works.

### Isolation

Review the [architectural approaches for storage and data in multitenant solutions](storage-data.md) to understand how to isolate tenants' data. Consider whether tenants have requirements to use their own data encryption keys.

Whichever isolation approaches you implement, be prepared for tenants to request an audit of their data. It's a good practice to document all of the data stores in which tenants' data might be kept. Common data sources include the following types of resources:

- Databases and storage accounts deployed as part of your solution
- Identity systems, which are often shared between tenants
- Logs
- Data warehouses

### Sovereignty

Understand whether there are any restrictions on the physical location for your tenants' data that's to be stored or processed. Your tenants might require you store their data in specific geographic locations. They might also require that you *don't* store their data in certain locations. Although these requirements are commonly based on legislation, they can also be based on cultural values and norms.

For more information about data residency and sovereignty, see the whitepaper [Enabling data residency and data protection in Microsoft Azure regions](https://azure.microsoft.com/mediahandler/files/resourcefiles/achieving-compliant-data-residency-and-security-with-azure/Enabling_Data_Residency_and_Data_Protection_in_Azure_Regions-2021.pdf).

### Tenant lifecycle

Plan how governance and compliance controls apply throughout each tenant's lifecycle. During onboarding, verify the tenant's sovereignty, audit, retention, and access control requirements before you place them into a shared environment or assign them to a deployment stamp. As tenants grow or their obligations change, you might need to migrate their workloads to a different region, move their tenant-specific subscriptions to a different management group, or assign them to a dedicated stamp that provides stronger isolation.

Offboarding also requires planning. Consider how you export tenant data, preserve audit evidence for the required retention period, revoke access, and securely delete data when contractual or regulatory obligations allow it.

### Tenants' access to data that you store

Tenants sometimes request direct access to the data that you store on their behalf. For example, they might want to ingest their data into their own data lake.

Plan how to respond to these requests. Consider whether any of the tenants' data is kept in shared data stores. If it is, plan how to prevent tenants from accessing other tenants' data.

Avoid providing direct access to databases or storage accounts unless you designed for this requirement, such as by using the [Valet Key pattern](../../../patterns/valet-key.yml). Consider creating an API or automated data export process for integration purposes.

For more information about integration with tenants' systems and external systems, see [Architectural approaches for tenant integration and data access](./integration.md).

### Your access to tenants' data

Consider whether your tenants' requirements restrict the personnel who can work with their data or resources. For example, suppose you build a software as a service (SaaS) solution that many different customers use. A government agency might require that only citizens of their country or region are allowed to access the infrastructure and data for their solution. You might meet this requirement by using separate Azure resource groups or subscriptions for sensitive customer workloads, and by organizing tenant-specific subscriptions under management groups for inherited policy and access control. Review all inherited Azure role-based access control (Azure RBAC) assignments from parent management groups and subscriptions to ensure that nonapproved administrators don't retain access to sensitive workloads. If the shared identity or resource hierarchy can't satisfy the personnel restriction, consider using a separate Microsoft Entra tenant, a separate management-group hierarchy with dedicated subscriptions, or a dedicated environment for those tenants.

### Aggregation of data from multiple tenants

Consider whether you need to combine or aggregate data from multiple tenants. For example, you might analyze the aggregated data, train machine learning models, or provide AI grounding data that can be applied to other tenants. Ensure that your tenants understand how you use their data. Include any use of aggregated or anonymized data.

### Compliance requirements

It's important that you understand whether you need to meet any compliance standards. Compliance requirements might be introduced in several scenarios, including:

- You, or any of your tenants, work within certain industries. For example, if any of your tenants work in the healthcare industry, you might need to comply with the HIPAA standard.

- You, or any of your tenants, are located in geographic or geopolitical regions that require compliance with local laws. For example, if any of your tenants are located in Europe, you might need to comply with the [General Data Protection Regulation (GDPR)](/compliance/regulatory/gdpr).

- You purchase a cyber insurance policy to mitigate the risk of breaches. Cyber insurance providers might require that you follow their standards and apply specific controls for your policy to be valid.

> [!IMPORTANT]
> Compliance is a shared responsibility between Microsoft, you, and your tenants.
>
> Microsoft ensures that our services meet a specific set of compliance standards and provides tools like [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) that help to verify your resources are configured according to those standards.
>
> It's your responsibility to understand the compliance requirements that apply to your solution and how to configure your Azure resources according to those standards. For more information, see [Azure compliance offerings](/azure/compliance/offerings).
>
> This article doesn't provide specific guidance about how to become compliant with any particular standards. Instead, it provides some general guidance about how to consider compliance and governance in a multitenant solution.

If different tenants need you to follow different compliance standards, consider whether you can apply a strict common baseline across your environment and then add tenant-specific or segment-specific controls where they're needed.

### Compliance evidence and reporting

Regardless of the isolation model that you choose, plan how you collect, retain, and present compliance evidence for each tenant. Tenants might request audit records, configuration evidence, data lineage details, or proof that you applied specific controls.

Consider using [Microsoft Purview](/purview/purview) to track and classify the data that you store. When tenants request access to their data, you can more easily determine which data sources you should include. Use tools like [Azure Policy](/azure/governance/policy/overview) and the [Defender for Cloud regulatory compliance dashboard](/azure/defender-for-cloud/regulatory-compliance-dashboard) to help verify that your Azure resources continue to meet your governance requirements. Use [Azure Advisor](/azure/advisor/advisor-overview) to identify recommendations across cost, performance, reliability, security, and operational excellence.

Your tenants might require that you demonstrate your compliance with specific standards. Use the [Service Trust Portal](https://servicetrust.microsoft.com) to download and review Microsoft's audit certificates, assessment reports, and other compliance documentation. Some multitenant solutions incorporate Microsoft 365 services such as Microsoft OneDrive, Microsoft SharePoint, and Microsoft Exchange Online. Use [Microsoft Purview portal](https://purview.microsoft.com) and [Microsoft Purview Compliance Manager](/purview/compliance-manager) to help you assess and manage your organization's compliance posture.

## Approaches and patterns to consider

As you design your multitenant solution, define compliance boundaries for groups of tenants that share governance and compliance requirements. A compliance boundary might span multiple deployment stamps or subscriptions, or it might map to dedicated resources for a specific tenant.

### Resource identification and querying

Use [resource tags](cost-management-allocation.md#allocate-costs-by-using-resource-tags) to track tenant-specific resources or resources shared within a [deployment stamp](overview.md#deployment-stamps-pattern). Store only non-sensitive, opaque identifiers in tags because [tags are plain text](/azure/azure-resource-manager/management/tag-resources#tag-usage-and-recommendations) and can surface in cost reports, deployment histories, and logs. 

Use [Azure Resource Graph](/azure/governance/resource-graph/overview) to query resource metadata, such as tags, across subscriptions and resource groups so that you can find resources associated with a specific tenant, stamp, or compliance boundary. You can also use Resource Graph to query recent changes to resource properties, but change data is retained for 14 days. If your audit requirements require longer retention, [export the results to a durable store](/azure/governance/resource-graph/changes/resource-graph-changes#data-retention). For durable audit evidence about control-plane operations, use [Azure Monitor activity logs](/azure/azure-monitor/essentials/activity-log) and configure appropriate retention or export.

### Access control

Use [Azure RBAC](/azure/role-based-access-control/overview) to restrict access to the Azure resources that constitute the multitenant solution. Follow the Azure RBAC [best practices](/azure/role-based-access-control/best-practices), such as applying role assignments to groups instead of users. Scope your role assignments so that they provide the minimum permissions necessary. Avoid long-standing access to resources by using just-in-time access and features like [Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-configure).

### Shared governance boundaries

At the shared end of the isolation spectrum, you apply a common governance baseline across many tenants. This approach often reduces governance cost and operational effort because you centralize policy definitions, compliance reporting, and access control processes. It's a good fit when tenants have similar regulatory requirements and can share the same operational controls.

However, shared governance boundaries increase operational coupling between tenants. Large compliance reporting workloads that you run in your own environment can create resource contention or delays for all tenants. Managed services such as Azure Policy and Defender for Cloud also evaluate resources asynchronously, so compliance reporting freshness can vary across large estates. Monitor shared governance operations carefully, schedule customer-hosted reporting jobs to reduce contention, and design reporting stores and automation to handle growth.

### Segmented governance boundaries

Many multitenant solutions need a middle ground between fully shared and fully dedicated governance. You can segment tenants by deployment stamp, subscription, region, or by organizing tenant-specific subscriptions under management groups based on their sovereignty, access, or audit requirements. This segmentation can complement a common baseline: apply controls that all tenants must meet across the environment, and then layer segment-specific policies or operational processes where tenants have different requirements.

The tradeoff is operational complexity. As the number of governance segments grows, you need stronger automation to keep role assignments, Azure Policy definitions, and monitoring settings consistent.

### Dedicated governance boundaries for sensitive tenants

At the dedicated end of the spectrum, isolate governance controls for specific tenants that have unusually strict compliance or sovereignty requirements. Place these tenants into dedicated subscriptions or stamps, and organize those subscriptions under dedicated management groups so that you can apply separate policies, access boundaries, and operational processes.

This approach provides stronger isolation and a clearer compliance boundary when the underlying subscriptions, stamps, or resources are dedicated, but it also increases cost and management overhead. Use it selectively for tenants whose contractual or regulatory requirements justify the extra complexity.

Use the [Deployment Stamps pattern](overview.md#deployment-stamps-pattern) when tenant-specific compliance requirements need separate deployment, configuration, or operational controls. For example, deploy stamps of your solution into multiple Azure regions, and assign tenants to stamps based on their data residency or sovereignty requirements. If a tenant has strict compliance requirements that your shared components can't meet, deploy a dedicated stamp for that tenant and configure the stamp according to those requirements.

## Antipatterns to avoid

- **Not understanding your tenants' compliance requirements.** It's important not to make assumptions about the compliance requirements that your tenants might impose. If you plan to grow your solution into new markets, be mindful of the regulatory environment that your tenants are likely to operate within.

- **Ignoring good practices.** If you don't have any immediate need to adhere to compliance standards, you should still follow good practices when you deploy your Azure resources. For example, isolate your resources, apply policies to verify resource configuration, and apply role assignments to groups instead of users. By following good practices, you make it simpler to follow compliance standards when you eventually need to. You also ensure that you're better protected against various security threats and risks.

- **Assuming there are no compliance requirements.** When you first launch a multitenant solution, you might not be aware of compliance requirements, or you might not need to follow any. As you grow, you likely need to provide evidence that you comply with various standards. Use [Defender for Cloud](/azure/defender-for-cloud/regulatory-compliance-dashboard) to monitor your compliance posture against a general baseline, such as the [CIS Microsoft Azure Foundations Benchmark](/azure/governance/policy/samples/cis-azure-2-0-0), even before any formal requirement is in place.

- **Not planning for management.** As you deploy your Azure resources, consider how you plan to manage them. If you need to make bulk updates to resources, ensure that you understand automation tools, such as the Azure CLI, Azure PowerShell, Resource Graph, and the Azure Resource Manager APIs.

- **Not using management groups.** Plan your subscription and management group hierarchy, including access control and Azure Policy resources at each scope. It can be difficult and disruptive to introduce or change these elements when your resources are used in a production environment.

- **Failing to plan your access control strategy.** Azure RBAC provides a high degree of control and flexibility in how you manage access to your resources. Ensure you use Microsoft Entra groups to avoid assigning permissions to individual users. Assign roles at scopes that provide an appropriate balance between security and flexibility. Use built-in role definitions wherever possible, and assign roles that provide the minimum permissions required.

- **Not using Azure Policy.** It's important to use Azure Policy to govern your Azure environment. After you plan and deploy policies, ensure you monitor the policy compliance and carefully review any violations or exceptions.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
- [Daphne Choong](https://www.linkedin.com/in/daphnecys) | Senior Partner Solution Architect, Enterprise Partner Solutions
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Customer Engineer, FastTrack for Azure
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Approaches for cost management and allocation](cost-management-allocation.md)
