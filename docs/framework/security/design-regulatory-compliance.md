---
title: Regulatory compliance
description: Understand how to meet regulatory compliance for Azure cloud architectures. Gather regulatory requirements. Use the Microsoft Trust Center.
author: PageWriter-MSFT
ms.date: 10/29/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
categories: 
  - management-and-governance
subject:
  - security
ms.custom:
  - article
---

# Regulatory compliance
A workload can have regulatory requirements. These requirements might need strict security measures that affect the overall architecture and the selection and configuration of specific PaaS and SaaS services. The requirements also have implications for how the workload should be operationalized.

## Key points
> [!div class="checklist"]
> - Make sure that all regulatory requirements are known and well understood. 
> - Periodically perform external and, or internal workload security audits.
> - Have compliance checks as part of the workload operations.
> - Use Microsoft Trust Center. 

## Review the requirements

Regulatory organizations frequently publish standards and updates to help define good security practices so that organizations can avoid negligence. The purpose and scope of these standards and regulations vary, but the security requirements can influence the design for data protection and retention, network access, and system security.

Knowing whether your cloud resources are in compliance with standards mandated by governments or industry organizations is essential in today's globalized world (such as GDPR).

For example, a workload that handles credit card transactions is subject to the Payment Card Industry (PCI) standard. One of the requirements prohibits access between the internet and any system component in the cardholder data environment. To provide a restrictive environment, you can choose to host the workload in different Azure compute options that supports bring your own VNet, remove any internet facing endpoints by using Private Endpoints as well as network security groups (NSGs) rules that define authorized inbound and outbound access, among other choices.

Noncompliance can lead to fines or other business impact. Work with your regulators and carefully review the standard to understand both the intent and the literal wording of each requirement. Here are some questions that may help you understand each requirement.

- How is compliance measured?
- Who approves that the workload meets the requirements?
- Are there processes for obtaining attestations?
- What are the documentation requirements?

### Suggested action

Use Azure Defender (Azure Security Center) to assess your current compliance score and to identify the gaps.

**Learn more**

[Tutorial: Improve your regulatory compliance](/azure/security-center/security-center-compliance-dashboard)

## Use the Microsoft Trust Center

Keep checking the [Microsoft Trust Center](https://www.microsoft.com/trust-center) for the latest information, news, and best practices in security, privacy, and compliance. 

- **Data governance**. Focus on protecting information in cloud services, mobile devices, workstations, or collaboration platforms. Build the security strategy by classifying and labeling information. Use strong access control and encryption technology. 
- **Compliance offerings**. Microsoft offers a comprehensive set of compliance offerings to help your organization follow national, regional, and industry-specific requirements governing the collection and use of data. For information, see [Compliance offerings](/microsoft-365/compliance/offering-home).
- **Compliance score**. Use [Microsoft Compliance Score](/microsoft-365/compliance/compliance-manager) to assess your data protection controls on an ongoing basis. Act on the recommendations to make progress toward compliance. 
- **Audit reports**. Use audit reports to stay current on the latest privacy, security, and compliance-related information for Microsoft's cloud services. See [Audit Reports](https://servicetrust.microsoft.com/ViewPage/MSComplianceGuide).
- **Shared responsibility**. The workload can be hosted on Software as a Service (SaaS), Platform as a Service (PaaS), Infrastructure as a Service (IaaS), or in an on-premises datacenter. Have a clear understanding about the portions of the architecture for which you are responsible versus Azure. Whatever the hosting model, the following responsibilities are always retained by you:
    - Data
    - Endpoints
    - Account
    - Access management

    For more information, see [Shared responsibility in the cloud](/azure/security/fundamentals/shared-responsibility).

## Operational considerations

Regulatory requirements may influence the workload operations. For example, there might be a requirement that operational data, such as application logs and metrics, remain within a certain geo-political region.

Consider automation of deployment and maintenance tasks. This will reduce security and compliance risk by limiting opportunity to introduce human errors during manual tasks.

## Next 
> [!div class="nextstepaction"]
> [Azure landing zone](design-governance-landing-zone.md)

## Related links

Azure maintains a compliance portfolio that covers US government, industry specific, and region/country standards. For more information, see [Azure compliance offerings](/azure/compliance/offerings/).

Monitor the compliance of the workload to check if the security controls are aligned to the regulatory requirements. For more information, see [Security audits](monitor-audit.md). 

> Go back to the main article: [Governance](design-governance.md)