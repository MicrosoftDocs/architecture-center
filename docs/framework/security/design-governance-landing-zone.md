---
title: Azure landing zone
description: Security controls on a prepared infrastructure into which a workload can get deployed.
author: PageWriter-MSFT
ms.date: 03/05/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
product: 
  - azure-blueprints
  - azure-policy
azure-category: management-and-governance
ms.custom:
  - article
---

# Azure landing zone

A _landing zone_ refers to a prepared infrastructure into which a workload gets deployed. For example, a hub and spoke topology. It already has the compute, data sources, access controls, and networking components provisioned. When a workload lands on Azure, the required plumbing is ready; the workload needs to plug into it.

From a security perspective, there are several benefits. First, a landing zone offers isolation by creating segments. You can isolate assets at several layers from Azure enrollment down to a subscription that has the resources for the workload. This strategy of having resources within a boundary that is separate from other parts of the organization is an effective way of detecting and containing adversary movements.

Another benefit is consistent adoption of organizational policies. Policies govern which resources can be used and their usage limits. Policies also provide identity controls. Only authenticated and authorized entities are allowed access. This approach decouples the governance requirements from the workload requirements. It's crucial that a landing zone is handed over to the workload owner with the security guardrails deployed.

A well-architected landing zone supports the zero-trust principle. The landing zone is configured with least privileges that is in compliance with enterprise security. The workload requirements must align those requirements. For instance when design networking controls, support zero-trust by opening communication paths only when necessary and only to trusted entities.

The preceding examples are conceptually simple but the implementation can get complicated for an enterprise-scale deployment. This article provides links to articles in Cloud Adoption Framework (CAF) that describe the design considerations and best practices.

## Architecture
For information about an enterprise-scale reference architecture, see [Cloud Adoption Framework enterprise-scale landing zone architecture](/azure/cloud-adoption-framework/ready/enterprise-scale/architecture). The architecture provides considerations in these critical design areas:
- [Enterprise Agreement (EA) enrollment and Azure Active Directory tenants](/azure/cloud-adoption-framework/ready/enterprise-enrollment-and-azure-ad-tenants.md)
- [Identity and access management](/azure/cloud-adoption-framework/ready/identity-and-access-management.md)
- [Management group and subscription organization](/azure/cloud-adoption-framework/ready/management-group-and-subscription-organization.md)
- [Network topology and connectivity](/azure/cloud-adoption-framework/ready/network-topology-and-connectivity.md)
- [Management and monitoring](/azure/cloud-adoption-framework/ready/management-and-monitoring.md)
- [Business continuity and disaster recovery](/azure/cloud-adoption-framework/ready/business-continuity-and-disaster-recovery.md)
- [Security, governance, and compliance](/azure/cloud-adoption-framework/ready/security-governance-and-compliance.md)
- [Platform automation and DevOps](/azure/cloud-adoption-framework/ready/platform-automation-and-devops.md)

## Azure services
**How does the organization consistently deploy environments of this workload that follows organizational policies?**
***

Key Azure services that can help in creating a landing zone:

- [Azure Blueprints](/azure/governance/blueprints/overview) sketches a solution's design parameters based on an organization's standards, patterns, and requirements.
- [Azure Policy](/azure/governance/policy/overview) enforces organizational standards and to assess compliance at-scale.
- [Azure AD](/services/active-directory/) and [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) work in conjunction to provide identity and access controls.
- [Azure Monitor](/azure/active-directory/reports-monitoring/concept-activity-logs-azure-monitor) provides centralized operations for monitoring and viewing logs from all resources provisioned. 

## Next
Use management groups can manage resources across multiple subscriptions consistently and efficiently. 

> [!div class="nextstepaction"]
> [Management groups](design-management-groups.md)

> Back to the main article: [Governance](design-governance.md)