---
title: Regulatory compliance
description: Security enforcement through standards published by law, authorities, and regulators.
author: PageWriter-MSFT
ms.date: 10/29/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Regulatory compliance
Cloud architectures can have challenges when strictly applying standards to workloads. This article provides some   security recommendations for adhering to standards.

## Gather regulatory requirements

**What do the law, authorities, and regulators require?**
***
Governments and regulatory organizations frequently publish standards to help define good security practices so that organizations can avoid negligence. The purpose and scope of these standards and regulations vary, but the security requirements can influence the design for data protection and retention, data privacy, and system security.

Noncompliance can lead to fines or other business impact. Work with your regulators and carefully review the standards to understand both the intent and the literal wording. Start by answering these questions:

- What are the regulatory requirements for the solution?
- How is compliance measured?
- Who approves that solution meets the requirements?
- Are there processes for obtaining attestations?

## Use the Microsoft Trust Center

Outdated security practices won’t sufficiently protect cloud workloads. Keep checking the [Microsoft Trust Center](https://www.microsoft.com/trust-center) for the latest information, news, and best practices in security, privacy, and compliance. 

- **Data governance**. Focus on protecting information in cloud services, mobile devices, workstations, or collaboration platforms. Build the security strategy by classifying and labeling information. Use strong access control and encryption technology. 
- **Compliance offerings**. Microsoft offers a comprehensive set of compliance offerings to help your organization comply with national, regional, and industry-specific requirements governing the collection and use of data. For information, see [Compliance offerings](/microsoft-365/compliance/offering-home).
- **Compliance score**. Use [Microsoft Compliance Score](/microsoft-365/compliance/compliance-manager) to assess your data protection controls on an ongoing basis. Act on the recommendations to make progress toward compliance. 
- **Audit reports**. Use audit reports to stay current on the latest privacy, security, and compliance-related information for Microsoft’s cloud services. See [Audit Reports](https://servicetrust.microsoft.com/ViewPage/MSComplianceGuide).
- **Shared responsibility**. The workload can be hosted on Software as a Service (SaaS), Platform as a Service (PaaS), Infrastructure as a Service (IaaS), or in an on-premises datacenter. Have a clear understanding about the portions of the architecture for which you are responsible versus Azure. Whatever the hosting model, the following responsibilities are always retained by you:
    - Data
    - Endpoints
    - Account
    - Access management

    For more information, see [Shared responsibility in the cloud](/azure/security/fundamentals/shared-responsibility).


## Next steps
- [Applications and services](design-apps-services.md)
- [Application classification](design-apps-considerations.md)
- [Application threat analysis](design-threat-model.md)