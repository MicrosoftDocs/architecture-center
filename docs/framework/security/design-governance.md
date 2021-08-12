---
title: Enforce governance to reduce risks
description: Security priorities around governance, risk, and compliance.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
categories: 
  - management-and-governance
  - security
ms.custom:
  - article
---

<!-- cSpell:ignore NIST -->

# Enforce governance to reduce risks

As part of overall design, prioritize where to invest the available resources; financial, people, and time. Constraints on those resources also affect the security implementation across the organization. Set organizational policies for operations, technologies, and configurations based on internal factors (business requirements, risks, asset evaluation) and external factors (benchmarks, regulatory standards, threat environment). 

## Checklist
**What considerations for compliance and governance did you make?**
***
> [!div class="checklist"]
> - Create a landing zone for the workload. The infrastructure must have appropriate controls and be repeatable with every deployment.
> - Enforce creation and deletion of services and their configuration through Azure Policies. 
> - Ensure consistency across the enterprise by applying policies, permissions, and tags across all subscriptions through careful implementation of root management group.
> - Understand regulatory requirements and operational data that may be used for audits. 
> - Continuously monitor and assess the compliance of your workload. Perform regular attestations to avoid fines.
> - Review and apply recommendations from Azure. 
> - Remediate basic vulnerabilites to keep the attacker costs high.

## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Are there any regulatory requirements for this workload?**](design-regulatory-compliance.md)|Understand all regulatory requirements. Check the Microsoft Trust Center for the latest information, news, and best practices in security, privacy, and compliance.|
|[**Is the organization using a landing zone for this workload?**](design-governance-landing-zone.md)|Consider the security controls placed on the infrastructure into which the workload will get deployed.|
|[Reference model: Segmentation](design-segmentation.md)|Reference model and strategies of how the functions and teams can be segmented.|
|[Management groups and permissions](design-management-groups.md)|Strategies using management groups to manage resources across multiple subscriptions consistently and efficiently.|
|[Regulatory compliance](design-regulatory-compliance.md)|Guidance on standards published by law, authorities, and regulators.|

## Azure security benchmark

The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to these controls:
>
> - [Governance and Strategy](/azure/security/benchmarks/security-controls-v2-governance-strategy)
> - [Posture and vulnerability management](/azure/security/benchmarks/security-controls-v2-posture-vulnerability-management) 

## Reference architecture

Here are some reference architectures related to governance:

[Cloud Adoption Framework enterprise-scale landing zone architecture](/azure/cloud-adoption-framework/ready/enterprise-scale/architecture)

## Next steps

We recommend that you review the practices and tools implemented as part of the development cycle.

> [!div class="nextstepaction"]
> [Application development](./design-apps-services.md)

## Related links
> Go back to the main article: [Security](overview.md)