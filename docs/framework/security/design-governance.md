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

Before defining the policies, consider:
- How is the organization’s security monitored, audited, and reported? Is there mandatory reporting? 
- Are the existing security practices are working? 
- Are there new requirements? 
- Are there any requirements specific to industry, government, or regulatory requirements?

Designate group(s) (or individual roles) for central functions that affect shared services and applications. 

After the policies are set, continuously improve those standards incrementally. Make sure that the security posture doesn’t degrade over time by having auditing and monitoring compliance. For information about managing security standards of an organization, see [governance, risk, and compliance (GRC)](/azure/cloud-adoption-framework/migrate/azure-best-practices/governance-or-compliance).

## In this section
|Article|Description|
|---|---|
|[Reference model: Segmentation](design-segmentation.md)|Reference model and strategies of how the functions and teams can be segmented.|
|[Management groups and permissions](design-management-groups.md)|Strategies using management groups to manage resources across multiple subscriptions consistently and efficiently.|
|[Regulatory compliance](design-regulatory-compliance.md)|Guidance on standards published by law, authorities, and regulators.|