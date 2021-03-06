---
title: Enforce governance to reduce risks
description: Security priorities around governance, risk, and compliance.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
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
>
> - Understand the regulatory requirements and the requirements on operational data that may be used for audits. 
> - 


Before defining the policies, consider:
- How is the organization’s security monitored, audited, and reported? Is there mandatory reporting? 
- Are the existing security practices are working? 
- Are there new requirements? 
- Are there any requirements specific to industry, government, or regulatory requirements?

Designate group(s) (or individual roles) for central functions that affect shared services and applications. 

After the policies are set, continuously improve those standards incrementally. Make sure that the security posture doesn’t degrade over time by having auditing and monitoring compliance. For information about managing security standards of an organization, see [governance, risk, and compliance (GRC)](/azure/cloud-adoption-framework/migrate/azure-best-practices/governance-or-compliance).

## In this section
Follow these questions to assess the workload at a deeper level. 
|Assessment|Description|
|---|---|
|[**Are there any regulatory requirements for this workload?**](design-regulatory-compliance.md)|Understand all regulatory requirements. Check the Microsoft Trust Center for the latest information, news, and best practices in security, privacy, and compliance.|
|[**Is the organization using a landing zone for this workload?**](design-governance-landing-zone.md)|Consider the security controls placed on the infrastructure into which the workload will get deployed.|
|[Reference model: Segmentation](design-segmentation.md)|Reference model and strategies of how the functions and teams can be segmented.|
|[Management groups and permissions](design-management-groups.md)|Strategies using management groups to manage resources across multiple subscriptions consistently and efficiently.|
|[Regulatory compliance](design-regulatory-compliance.md)|Guidance on standards published by law, authorities, and regulators.|