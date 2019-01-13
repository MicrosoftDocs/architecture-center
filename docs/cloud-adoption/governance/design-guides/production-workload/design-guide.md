---
title: "Fusion: Governance Design Guide Production Workload"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: A Governance Design Guide to Production Workload deployments

This article demonstrates implementation of a series of corporate policies related to the use case described as "Production Workload". The design guide establishes a governance position for enterprises that have already built a strong foundation in Azure. The company in this use is preparing to deploy production workloads onto that foundation. Those workloads support mission critical business processes and host protected data. As such, the business can now justify investing time and energy in cloud governance. While the business is interested in investing in governance, there is still a desire to reduce the cost of information system hosting. As such the business requires a means of tracking cloud spend against planned cloud costs. The risks, policies and business needs represented in the corporate policy and use case articles are to be implemented by the steps outlined in this article.

New readers should review the [Production Workload - Use Case](./use-case.md) and [Production Workload - Corporate Policy](./corporate-policy.md) prior to implementing the guidance in this article. Further, this design guide builds on the instructions in the [Future Proof Design Guide](../future-proof/design-guide.md). Validate that the steps to establish that foundation have been implemented prior to implementing this design guide.

## Use Case and Corporate Policy Summary

This design guide is based on a specific [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md) summarized as follows:

* [Use Case](./use-case.md) Summary: The company outlined in the Future Proof Use Case is now ready to deploy production workloads to Azure. This increases risk, which has triggered a desire to mature Cloud Governance.
* [Corporate Policy](./corporate-policy.md) Summary: A series of corporate policies have been developed to ensure data protection and avoid business interruptions. This design guide implements those policies.

![This design guide is a specific solution based on a specific use case and corporate policy.](../../../_images/governance/design-guide.png)

*This design guide is a specific solution based on a specific use case and corporate policy. This design guide is dependent upon the criteria set in each of those articles.*


> [!CAUTION]
> This article contains a highly opinionated design guide. The opinions in this guide DO NOT fit every situation. Caution should be exercised before implementing this guidance. Prior to implementation of this design guide, the reader should understand the Use Case and Corporate Policy which influenced the guidance in this document.

## Checklist for the Production Workload Design Guide

The following outlines the implementation choices included in this design guide.

### Implementation Checklist

This checklist provides a reference of the steps required to implement this design guide. Additional implementation details are provided in the following sections. At the end of this document, a section with alternative patterns is available to help refine these decisions.

1) Validate alignment with the [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md) that determined the following decisions
2) The 9 steps of the Future Proof design guide are a pre-requisite to this design guide. Ensure each has been implemented before continuing.
3) Subscription model: The **Archetype** pattern is still applicable.
4) Resource Grouping: The expanded use of Graph and Management Groups would elevate the grouping pattern to a **Complex Grouping** pattern. Which will require the addition of billing groups to the Management Group hierarchy.
5) Resource Tagging: Required addition of department to the tagging hierarchy would evolve the tagging pattern to an **Accounting** pattern.
6) Identity: The **Replication** pattern is still applicable
7) Software Defined Network: Incorporating Express Route for high speed, leased line connections evolves the networking pattern to a **Hybrid** SDN pattern.
8) Encryption: Since the encryption keys are to be generated on-prem, the **Hybrid** pattern is required
9) Log & Reporting: Requirements to leverage the existing operational management tools demand that this solution be evolved. Since that tool is cloud compatible the **Hybrid** pattern is an acceptable solution
10) Enforcement Automation: The application of Azure Management Groups to apply enforcement to management groups at scale evolves the enforcement approach to a **Consistent Enforcement** pattern

Beyond evolutions of the Future Proof Design Guide, the set of policies associated with this use case will require specific governance implementations as follows:

A) Policy Creation: A number of custom policies will be applied to all management groups which host mission critical applications. Another set will be applied to management groups which host protected data. All Management Groups will require configurations related to cost monitoring and tagging, which will require an update to the default policy applied to each management group.
B) Azure Cost Management Configuration: Specific configurations of Azure Cost Management will be implemented to fulfill cost related policy statements
C) Recurring Processes and Policy Audits: A series of recurring processes will be required to review the results of programmatic audits. During those processes some configurations that fall outside of the scope of Azure Policy will require additional manual verification via Azure Dashboard or Azure Monitor.

### Assumptions to validate

The above checklist assumes the following. Should these assumptions prove false, see the section on [Assumptions and Additional Considerations](#assumptions-and-additional-considerations) at the end of this article for more details on each.

[Todo: Summarize Assumptions]

The assumptions above can not generally be addressed by a Cloud Governance Team in isolation. Before implementing the design guide, review and prepare for each of these assumptions.

## Detailed Design Guidance supporting each point on the Implementation Checklist

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will Production Workload deployments, easing governance adoption down the road.
> [!CAUTION]
> The following design guide contains extremely specific guidance based on the Use Case and Corporate Policies established for this synthesized customer scenario. Each section contains one or more links to personalize the Design Guidance to align to a specific use case.


[Todo: Detailed Guidance]



Notes:
Create a budget in the Azure portal
View cost optimization recommendations to view potential usage inefficiencies
Act on a recommendation to resize a virtual machine to a more cost-effective option
Assign access to Cost Management data based on scope...
Build your skills with Microsoft Learn
****** Multi-Cloud with Cloudyn

Automatic provisioning is off by default. To set Security Center to install automatic provisioning by default, set it to On.
https://docs.microsoft.com/en-us/azure/security-center/security-center-policy-definitions
OS security configurations https://docs.microsoft.com/en-us/azure/security-center/security-center-customize-os-security-config
Management Group level configuration https://docs.microsoft.com/en-us/azure/security-center/security-center-management-groups
****** Multi-Cloud Monitor security across on-premises and cloud workloads

Backup policy https://docs.microsoft.com/en-us/azure/backup/backup-azure-arm-userestapi-createorupdatepolicy

Azure dashboards
Azure Monitor Enable two or more Azure VMs by using Azure Policy. Through this method, the required dependencies of existing and new VMs are installed and properly configured. Non-compliant VMs are reported, so you can decide whether to enable them and how you want to remediate them.


## Alternative Patterns

If any of the patterns selected in this design guide don't align to the reader's requirements, alternatives to each pattern is available in the list of links below.

* Subscription model: Alternatives to the **Archetype** pattern are available [here](../../../infrastructure/subscriptions/overview.md)
* Resource Grouping: Alternatives to the **Deployment Grouping** pattern are available [here](../../../infrastructure/resource-grouping/overview.md)
* Resource Tagging: Alternatives to the **Classification** pattern are available [here](../../../infrastructure/resource-tagging/overview.md)
* Identity: Alternatives to the **Replication** pattern are available [here](../../../infrastructure/identity/overview.md)
* Software Defined Network: Alternatives to the **Cloud Native** pattern are available [here](../../../infrastructure/software-defined-networks/overview.md)
* Encryption: Alternatives to the **Cloud Native** pattern are available [here](../../../infrastructure/encryption/overview.md)
* Log & Reporting: Alternatives to the **Cloud Native** pattern are available [here](../../../infrastructure/logs-and-reporting/overview.md)
* Enforcement Automation: Alternatives to the **Simple Enforcement** pattern are available [here](../../../infrastructure/policy-enforcement/overview.md)

## Assumptions and Additional Considerations

There are a number of assumptions and considerations embedded in this opinionated guidance. Each should be considered before. The following list outlines data points and tasks that generally don't fall into the domain of the Cloud Governance Team. While members of this team may have those skills, it is unlikely the team will be empowered to execute the following without additional team member support.


[Todo: Detailed Assumptions]

## Conclusion

The decisions above are one example of ways to implement the required policies, in order to reduce risk and promote readiness for the future integration of a robust governance strategy. This design guide is derived from a synthesized customer scenario for demonstration purposes. To learn more about the decisions that informed this design guide, see the articles that outline this scenarios [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md).


## References

### This Design Guide (Production Workloads)

The corporate policy in this article supports the [Production Workload Governance Design Guide](./design-guide.md). The design guide and the policies in this document are means of supporting the business needs and risks outlined in the [Production Workload - Use Case](./use-case.md)

### Future Proof Governance Design Guide

This use case and the subsequent corporate policies and design guides are an evolution of the Future Proof Design Guide. Prior to implementation, it is highly suggested that the reader become familiar with that guidance.

**[Future Proof Use Case](../future-proof/use-case.md)**: The use case that drives the Future Proof design guide.
**[Future Proof Corporate Policy](../future-proof/corporate-policy.md)** A series of policy statements built on the defined use case.
**[Future Proof Design Guide](../future-proof/design-guide.md)** Design guidance to implement the Future Proof Design Guide.

### Modify this Design Guide

It is unlikely this use case will align perfect with any reader's specific use case. This guide is meant to serve as a starting point to build a custom design guide that fits the reader's scenario. The following two series of articles can aid in modifying this design guide.

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk-driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](#use-case:-future-proof) and [Corporate Policy](#corporate-policy) that influenced this guidance. 









