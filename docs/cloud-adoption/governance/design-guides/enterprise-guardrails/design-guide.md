---
title: "Fusion: Governance Design Guide Enterprise Guardrails"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: A Governance Design Guide to Enterprise Guardrails deployments

This article demonstrates implementation of a series of corporate policies related to the use case described as "Enterprise Guardrails". The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company in this use is preparing to deploy production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business can now justify investing time and energy in cloud governance. While the business is interested in investing in governance, there is still a desire to reduce the cost of information system hosting. As such the business requires a means of tracking cloud spend against planned cloud costs. The risks, policies and business needs represented in the corporate policy and use case articles are to be implemented by the steps outlined in this article.

New readers should review the [Enterprise Guardrails - Use Case](./use-case.md) and [Enterprise Guardrails - Corporate Policy](./corporate-policy.md) prior to implementing the guidance in this article. Further, this design guide builds on the instructions in the [Enterprise MVP - Design Guide](../future-proof/design-guide.md). Validate that the steps to establish that foundation have been implemented prior to implementing this design guide.

## Use Case and Corporate Policy Summary

This design guide is an opinionated approach to implement the needs outlined in the use case and corporate policy summarized below.

* Use Case Summary: The company outlined in the Enterprise MVP Use Case is now ready to deploy production workloads to Azure. This increases risk, which has triggered a desire to mature Cloud Governance.
* Corporate Policy Summary: A series of corporate policies have been developed to ensure data protection and avoid business interruptions. This design guide implements those policies.

![This design guide is a specific solution based on a specific use case and corporate policy.](../../../_images/governance/design-guide.png)

*This design guide is a specific solution based on a specific use case and corporate policy. This design guide is dependent upon the criteria set in each of those articles.*


> [!CAUTION]
> This article contains a highly opinionated design guide. The opinions in this guide DO NOT fit every situation. Caution should be exercised before implementing this guidance. Prior to implementation of this design guide, the reader should understand the Use Case and Corporate Policy which influenced the guidance in this document.

## Checklist for the Enterprise Guardrails Design Guide

The following outlines the implementation choices included in this design guide.

### Implementation Checklist

This checklist provides a reference of the steps required to implement this design guide. Additional implementation details are provided in the following sections. At the end of this document, a section with alternative patterns is available to help refine these decisions.

1) Validate implementation of the [design guide for the Enterprise MVP Use Case](../enterprise-mvp/design-guide.md). If that design guide isn't fulling implemented, then aspects of this design guide may not function as expected.
2) Policy Creation: The detailed design guide section below outlines a number of Azure policy additions to be made to any blueprint and subsequent subscriptions which will host or access production workloads. Additional policies will need to be applied to all subscriptions.
3) Policy Audits: Once created, existing subscriptions which will be impacted by the changes will require an audit to validate compliance.
4) Policy Enforcement: Per subscription, decisions regarding explicit enforcement will need to be made before the policies can be added to the governing blueprints.
5) Recurring Processes: Some of the new corporate policy statements fall outside of the scope of Azure Policy. Enforcement of those policies will require additional processes. Included in these new processes are reporting requirements and continuous improvements of governance capabilities.

### Assumptions to validate

The above checklist assumes the following. Should these assumptions prove false, see the section on [Assumptions and Additional Considerations](#assumptions-and-additional-considerations) at the end of this article for more details on each.

[Todo: Summarize Assumptions]

The assumptions above can not generally be addressed by a Cloud Governance Team in isolation. Before implementing the design guide, review and prepare for each of these assumptions.

## Detailed Design Guidance supporting each point on the Implementation Checklist

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will Enterprise Guardrails deployments, easing governance adoption down the road.
> [!CAUTION]
> The following design guide contains extremely specific guidance based on the Use Case and Corporate Policies established for this synthesized customer scenario. Each section contains one or more links to personalize the Design Guidance to align to a specific use case.

[TODO Add detailed Policy Changes]
Automatic provisioning is off by default. To set Security Center to install automatic provisioning by default, set it to On.
https://docs.microsoft.com/en-us/azure/security-center/security-center-policy-definitions
OS security configurations https://docs.microsoft.com/en-us/azure/security-center/security-center-customize-os-security-config
Management Group level configuration https://docs.microsoft.com/en-us/azure/security-center/security-center-management-groups


Backup policy https://docs.microsoft.com/en-us/azure/backup/backup-azure-arm-userestapi-createorupdatepolicy

Azure dashboards
Azure Monitor Enable two or more Azure VMs by using Azure Policy. Through this method, the required dependencies of existing and new VMs are installed and properly configured. Non-compliant VMs are reported, so you can decide whether to enable them and how you want to remediate them.

## Assumptions and Additional Considerations

There are a number of assumptions and considerations embedded in this opinionated guidance. Each should be considered before. The following list outlines data points and tasks that generally don't fall into the domain of the Cloud Governance Team. While members of this team may have those skills, it is unlikely the team will be empowered to execute the following without additional team member support.

[Todo: Detailed Assumptions]

## Conclusion

The decisions above are one example of ways to implement the required policies, in order to reduce risk and promote readiness for the future integration of a robust governance strategy. This design guide is derived from a synthesized customer scenario for demonstration purposes. To learn more about the decisions that informed this design guide, see the articles that outline this scenarios [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md).

## References

### This Design Guide (production workloads)

The corporate policy in this article supports the [Enterprise Guardrails Governance Design Guide](./design-guide.md). The design guide and the policies in this document are means of supporting the business needs and risks outlined in the [Enterprise Guardrails - Use Case](./use-case.md)

### Enterprise MVP Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Enterprise MVP Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Enterprise MVP Use Case](../future-proof/use-case.md)**: The use case that drives the Enterprise MVP design guide.
**[Enterprise MVP Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Enterprise MVP Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Enterprise MVP Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](#use-case:-future-proof) and [Corporate Policy](#corporate-policy) that influenced this guidance. 









