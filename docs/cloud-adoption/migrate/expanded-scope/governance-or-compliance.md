---
title: "Governance or compliance strategy"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Governance or compliance strategy
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: migrate
---

# Governance or compliance strategy

When governance or compliance is required throughout a migration effort, additional scope is required. The following guidance will expand the scope of the [Azure migration guide](../azure-migration-guide/index.md) to address different approaches to addressing governance or compliance requirements.

## General scope expansion

Prerequisite activities are affected the most when governance or compliance are required. Additional adjustments may be required during assessment, migration, and optimization.

## Suggested prerequisites

Configuration of the base Azure environment could change significantly when integrating governance or compliance requirements. To understand how prerequisites change, it's important to understand the nature of the requirements. Prior to beginning any migration that requires governance or compliance, an approach should be chosen and implemented in the cloud environment. The following are a few high-level approaches commonly seen during migrations:

**Common governance approach:** For most organizations, the [Cloud Adoption Framework governance model](../../governance/journeys/index.md) is a sufficient approach that consists of a minimum viable product (MVP) implementation, followed by targeted iterations of governance maturity to address tangible risks identified in the adoption plan. This approach provides the minimum tooling needed to establish consistent governance, so the team can understand the tools. It then expands on those tools to address common governance concerns.

**ISO 27001 Compliance blueprints:** For customer who are required to adhere to ISO compliance standards, the [ISO 27001 Shared Services blueprint samples](/azure/governance/blueprints/samples/iso27001-shared/index) can serve as a more effective MVP to produce richer governance constraints earlier in the iterative process. The [ISO 27001 App Service Environment/SQL Database Sample](/azure/governance/blueprints/samples/iso27001-ase-sql-workload) expands on the blueprint to map controls and deploy a common architecture for an application environment. As additional compliance blueprints are released, they will be referenced here as well.

**Virtual Datacenter:** A more robust governance starting point may be required. In such cases, consider the [Azure Virtual Datacenter (VDC)](../../../vdc/index.md). This approach is commonly suggested during enterprise-scale adoption efforts, and especially for efforts that exceed 10,000 assets. It is also the de facto choice for complex governance scenarios when any of the following are required: extensive third-party compliance requirements, deep domain expertise, or parity with mature IT governance policies and compliance requirements.

### Partnership option to complete prerequisites

**Microsoft Services:**
Microsoft Services provides solution offerings that can align to the Cloud Adoption Framework governance model, compliance blueprints, or Virtual Datacenter options to ensure the most appropriate governance or compliance model. Use the [Secure Cloud Insights (SCI)](https://download.microsoft.com/download/C/7/C/C7CEA89D-7BDB-4E08-B998-737C13107361/Secure_Cloud_Insights_Datasheet_EN_US.pdf) solution offering to establish a data-driven picture of a customer deployment in Azure and validate the customer´s Azure implementation maturity while identifying optimization of existing deployment architectures, remove governance security and availability risks. Based on customer insights, you should lead with the following approaches:

- **Cloud Foundation:** Establish the customer’s core Azure designs, patterns, and governance architecture with the [Hybrid Cloud Foundation (HCF)](https://download.microsoft.com/download/D/8/7/D872DFD0-1C46-4145-95E4-B5EAB2958B96/Hybrid_Cloud_Foundation_Datasheet_EN_US.pdf) solution offering. Map the customer’s requirements to the most appropriate reference architecture. Implement a minimum viable product consisting of Shared Services and IaaS workloads.
- **Cloud Modernization:** Use the [Cloud Modernization](https://download.microsoft.com/download/3/7/3/373F90E3-8568-44F3-B096-CD9C1CD28AB7/Cloud_Modernization_Datasheet_EN_US.pdf) solution offering as a comprehensive approach to move applications, data, and infrastructure to an enterprise-ready cloud, as well as to optimize and modernize once in the cloud.
- **Innovate with Cloud:** Engage customer through an innovative and unique [Cloud Center of Excellence (CCoE)](https://download.microsoft.com/download/F/8/B/F8BBE4BD-E5F8-4DFB-82F7-C0A4E17051BB/Cloud_Center_of_Excellence_Datasheet_EN_US.pdf) solution approach that builds a modern IT organization to enable agility at scale with DevOps while staying in control. Implements an agile approach to capture business requirements, reuse deployment packages aligned with security, compliance and service management policies, and maintains the Azure platform aligned with operational procedures.

## Assess process changes

During assessment, additional decisions are required to align to the required governance approach. The cloud governance team should provide all members of the cloud adoption team with any policy statements, architectural guidance, or governance/compliance requirements prior to the assessment of a workload.

### Suggested action during the assess process

Governance and compliance assessment requirements are too customer-specific to provide general guidance on the actual steps taken during assessment. However, it is advised that the process includes tasks and time allocations for "alignment to compliance/governance requirements". For additional understanding of these requirements, see the following links:

For a deeper understanding of governance, review the [Five Disciplines of Cloud Governance overview](/azure/architecture/cloud-adoption/governance/governance-disciplines). This section of the Cloud Adoption Framework also includes templates to document the policies, guidance, and requirements for each of the five sections:

- [Cost Management](/azure/architecture/cloud-adoption/governance/cost-management/template)
- [Security Baseline](/azure/architecture/cloud-adoption/governance/security-baseline/template)
- [Resource Consistency](/azure/architecture/cloud-adoption/governance/resource-consistency/template)
- [Identity Baseline](/azure/architecture/cloud-adoption/governance/identity-baseline/template)
- [Deployment Acceleration](/azure/architecture/cloud-adoption/governance/deployment-acceleration/template)

For guidance on developing governance guidance based on the Cloud Adoption Framework governance model, see [Implementing a cloud governance strategy](/azure/architecture/cloud-adoption/governance/corporate-policy).

## Optimize and promote process changes

During the optimization and promotion processes, it is advised that the cloud governance team invest time to test and validate adherence to governance and compliance standards. Additionally, this step is a good time to inject processes for the cloud governance team to curate templates that could provide additional [deployment acceleration](/azure/architecture/cloud-adoption/governance/deployment-acceleration) for future projects.

### Suggested action during the optimize and promote process

During this process, it is advised that the project plan includes time allocations for the cloud governance team to execute a compliance review for each workload planned for production promotion.

## Next steps

As the final item on the [expanded scope checklist](./index.md), the reader is advised to return to the checklist and reevaluate any additional scope requirements for the migration effort.

> [!div class="nextstepaction"]
> [Expanded scope checklist](./index.md)
