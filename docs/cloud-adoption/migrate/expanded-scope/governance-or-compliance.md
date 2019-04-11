---
title: "CAF: Governance or compliance strategy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Governance or compliance strategy
author: BrianBlanchard
ms.date: 4/4/2019
---

# Governance or compliance strategy

When governance or compliance are required throughout a migration effort, additional scope is required. The following guidance will expand the scope of the [baseline migration guide](../baseline-migration-guide/overview.md) to address different approaches to addressing governance or compliance requirements.

## General scope expansion

Prerequisite activities are affected the most when governance or compliance are required. Additional adjustments may be required during assessment, migration, and optimization.

## Suggested prerequisites

Configuration of the base Azure environment could change significantly when integrating governance or compliance requirements. To understand how prerequisites change it's important to understand the nature of the requirements. Prior to beginning any migration which requires governance or compliance, an approach should be chosen and implemented in the cloud environment. The following are a few high level approaches commonly seen during migrations:

**Common governance approach:** For most organizations, the [Cloud Adoption Framework governance model](../../governance/journeys/overview.md) is a sufficient approach which consists of a minimum viable product (MVP) implementation, followed by targeted iterations of governance maturity to address tangible risks identified in the adoption plan. This approach provides the minimum tooling needed to establish consistent governance, ensuring the team can understand the tools involved. It then expands on those tools to address additional commonly encountered governance concerns.

**ISO 27001 Compliance blueprints:** For customers who are required to adhere to ISO compliance standards, the [ISO 27001 Shared Services blueprint samples](/azure/governance/blueprints/samples/iso27001-shared/index) can serve as a more effective MVP, producing richer governance constraints earlier in the iterative process. The [ISO 27001 App Service Environment/SQL Database Sample](/azure/governance/blueprints/samples/iso27001-ase-sql-workload) expands on a sample Azure blueprint to map controls and deploy a common architecture for an application environment. As additional compliance blueprints are released, they will be referenced here as well.

**Virtual Datacenter:** A more robust governance starting point may be required. In such cases, consider the [Azure Virtual Datacenter (VDC)](../../../vdc/index.md). This approach is commonly suggested during enterprise-scale adoption efforts, and especially for efforts which exceed 10,000 assets. It is also the de facto choice for complex governance scenarios when any of the following are required: extensive third-party compliance requirements, deep domain expertise, or parity with mature IT governance policies and compliance requirements.

**Microsoft Services:**
Microsoft Services offers a number of solutions which can align to the Cloud Adoption Framework governance model, compliant blueprints, or Virtual Datacenter options to ensure the most appropriate governance or compliance model. Use the [Secure Cloud Insights (SCI)](https://aka.ms/SCIDatasheet) solution offering to establish a data-driven picture of your deployment in Azure and validate your Azure implementation maturity. Secure Cloud Insights also helps you identify opportunities to optimize your existing deployment architectures, and remove governance security and availability risks. Based on the  insights gained from this process, you can move forward with these additional service offerings:

- **Cloud Foundation:** Establish your core Azure designs, patterns, and governance architecture with the [Hybrid Cloud Foundation (HCF)](https://aka.ms/CloudFoundationDatasheet) solution offering. Map your requirements to the most appropriate reference architecture. Implement a minimum viable product consisting of Shared Services and IaaS Workload.
- **Cloud Modernization:** Use the [Cloud Modernization](https://aka.ms/CloudMoDatasheet) solution offering as a comprehensive approach to move applications, data and infrastructure to an enterprise-ready cloud, as well as to optimize and modernize once in the cloud.
- **Innovate with Cloud:** Establish an innovative and unique [Cloud Center of Excellence (CCoE)](https://aka.ms/CCoEDatasheet) solution approach which builds a modern IT organization, enabling agility at scale with DevOps while maintaining control. This offering implements an agile approach to capture business requirements, reuse deployment packages aligned with security, implement compliance and service management policies, and maintain the Azure platform aligned with operational procedures.

## Assess process changes

During assessment, additional decisions will be required to align to the required governance approach. The Cloud Governance Team should provide all members of the Cloud Adoption Team with any policy statements, architectural guidance, or governance/compliance requirements prior to the assessment of a workload.

### Suggested action during the assess process

Governance and Compliance assessment requirements are too specific to each organization to provide clear guidance on the actual steps taken during assessment. However, it is advised that the process include tasks and time allocations for "alignment to compliance/governance requirements".

For a deeper understanding of governance, review the [Five Disciplines of Cloud Governance overview](/azure/architecture/cloud-adoption/governance/governance-disciplines.md). This section of the Cloud Adoption Framework also includes templates to document the policies, guidance, and requirements for each of the five sections:

- [Cost Management](/azure/architecture/cloud-adoption/governance/cost-management/template.md)
- [Security Baseline](/azure/architecture/cloud-adoption/governance/security-baseline/template.md)
- [Resource Consistency](/azure/architecture/cloud-adoption/governance/resource-consistency/template.md)
- [Identity Baseline](/azure/architecture/cloud-adoption/governance/identity-baseline/template.md)
- [Deployment Acceleration](/azure/architecture/cloud-adoption/governance/deployment-acceleration/template.md)

For information on developing governance guidance based on the Cloud Adoption Framework governance model, see [Implementing a cloud governance strategy](/azure/architecture/cloud-adoption/governance/corporate-policy).

## Optimize and promote process changes

During the optimization and promotion processes, it is advised that the Cloud Governance Team invest time to test and validate adherence to governance and compliance standards. Additionally, this is a good time to inject processes for the Cloud Governance Team to curate templates which could provide additional [deployment acceleration](/azure/architecture/cloud-adoption/governance/deployment-acceleration/overview.md) for future projects.

### Suggested action during the optimize and promote process

During this process, it is advised that the project plan include time allocations for the Cloud Governance Team to execute a compliance review for each workload planned for production promotion.

## Next steps

As the final item on the [expanded scope checklist](./overview.md), you should return to the checklist and reevaluate any additional scope requirements for the migration effort.

> [!div class="nextstepaction"]
> [Expanded Scope Checklist](./overview.md)