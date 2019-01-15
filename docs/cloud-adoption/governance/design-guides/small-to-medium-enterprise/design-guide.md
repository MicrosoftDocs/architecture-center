---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: A Governance Design Guide to future proof deployments

Fusion provides a cloud agnostic approach to the creation of a cloud governance strategy. To learn more about the model that this design guide is based on, checkout the [overview section of Governance](../../overview.md). This article demonstrates implementation of a cloud governance strategy that aligns to the specific use case below: Governance Future Proof. The concept of future proofing in this design guide focuses on embracing early stage ambiguity, while maintaining a future vision for a governance when it becomes necessary. This design guide attempts to deliver just enough governance preparation safely enable experimentation during cloud adoption. As cloud adoption plans evolve and grow, so would governance requirements.

In this type of model, a plan for scaling governance is crucial to avoid future blockers. If a future proof design for cloud governance is chosen by the reader, it should be done with a longer term vision. The [protected data design guide](../production-workload/design-guide.md) is one example of a future vision, allowing for production hosting of protected data in the cloud. For larger enterprises with extensive existing IT governance requirements on-prem, the series of design guides starting with the [Enterprise MVP design guide](../enterprise-mvp/design-guide.md) might be a more appropriate next step, or even a better starting point.

## Use Case and Corporate Policy Summary

This design guide is based on a specific [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md) summarized as follows:

* [Use Case](./use-case.md) Summary: The company in this use case could be classified as a medium sized business or a small enterprise. It could also be a business unit within a larger enterprise, that doesn't yet have the support of the centralized IT team. In this use case there is little to no budget to invest in cloud governance. IT policy is loosely defined but between policy and leadership sentiment, any protected data or mission critical solutions are blocked from being deployed to the cloud. However, fulfilling the future state in this use case will prompt the sentiment and policies to change overtime.
* [Corporate Policy](./corporate-policy.md) Summary: Given the low tolerance for cloud governance investment, the risks, policy statements, and processes in this corporate policy are very limited. The focus of this cloud governance corporate policy is future looking. In this grass roots effort, the team will attempt to avoid vendor lock-in and ensure deployments can be folded into a rich cloud governance program in the future.

![This design guide is a specific solution based on a specific use case and corporate policy.](../../../_images/governance/design-guide.png)

*This design guide is a specific solution based on a specific use case and corporate policy. This design guide is dependent upon the criteria set in each of those articles.*


> [!CAUTION]
> This article contains a highly opinionated design guide. The opinions in this guide DO NOT fit every situation. Caution should be exercised before implementing this guidance. Prior to implementation of this design guide, the reader should understand the [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md) which influenced the guidance in this document.

## Checklist for the Future Proof Design Guide

The following outlines the implementation choices included in this design guide.

### Implementation Checklist

This short checklist provides a quick reference of the steps required to implement this design guide. Additional implementation details are provided in the following sections. At the end of this document, a section with alternative patterns is available to help refine these decisions.

1) Validate alignment with the [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md) that determined the following decisions
2) Subscription model: The **Archetype** pattern for subscription modeling has been suggested for this use case
3) Resource Grouping: The **Deployment Grouping** pattern has been chosen for grouping resources
4) Resource Tagging: The **Classification** pattern best aligns with defined corporate policy statements
5) Identity: The **Replication** pattern is suggested for the proper level of hybrid identity
6) Software Defined Network: Limited governance investment and loose technical requirements would suggest a **Cloud Native** pattern to networking
7) Encryption: Limited governance investment and loose technical requirements would suggest a **Cloud Native** pattern to encryption
8) Log & Reporting: Limited governance investment and loose technical requirements would suggest a **Cloud Native** pattern to logging
9) Enforcement Automation: **Simple Enforcement** is the most appropriate pattern for policy enforcement at this time

### Assumptions to validate

The above checklist assumes the following. Should these assumptions prove false, see the section on [Assumptions and Additional Considerations](#assumptions-and-additional-considerations) at the end of this article for more details on each.

* Business Characteristics: This business operates in one country. No plans or requirements to distribute billing across multiple business units have been identified.
* Data Classification and Criticality: This environment is not expected to host protected data or missions critical applications
* Identity Assumption: Active Directory is already synchronized with Azure Active Directory. If not, this effort is supported by a parallel identity team.
* Network Assumption: An Azure compatible VPN will be available for use if needed. If not, this effort is supported by a parallel networking team.

The assumptions above can not generally be addressed by a Cloud Governance Team in isolation. Before implementing the design guide, review and prepare for each of these assumptions.

## Detailed Design Guidance supporting each point on the Implementation Checklist

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will future proof deployments, easing governance adoption down the road.
> [!CAUTION]
> The following design guide contains extremely specific guidance based on the Use Case and Corporate Policies established for this synthesized customer scenario. Each section contains one or more links to personalize the Design Guidance to align to a specific use case.

### Subscription Model

The **Archetype** pattern has been chosen for Azure subscriptions. 

* Departments are not likely to be required given the current focus. Deployments are expected to be constrained within a single billing unit. At the stage of adoption, there may not even be an enterprise agreement to centralize billing. It's very likely that this level of adoption is being managed by a single "Pay as you go" Azure subscription.
* Regardless of the use of the EA Portal or the existence of an enterprise agreement, a subscription model should still be defined and agreed upon to minimize administrative overheard beyond just billing.
* In the **Archetype** patter, "Subscriptions" should be created for each application archetype.
* An application archetype is a means of grouping applications with similar needs. Common examples would include: Applications with protected data, Governed Apps (HIPAA, FedRamp, etc...), Low risk applications, Applications with on-prem dependencies, SAP or other Mainframes in Azure, Applications that extend on-prem SAP or mainframes, etc... These are unique per organization based on data classifications and the types of applications that power the business. Dependency mapping of the digital estate can aid in defining the application archetypes in an organization.
* A common naming convention should be agreed upon as part of the subscription design, based on the above two bullets.

### Resource Grouping

**Deployment grouping** has been chosen as a resource grouping pattern.

* Deployed assets should be a member of a Resource Group and Azure Management Group. Azure Policy should be applied to all resources.
* As part of the deployment process, an Azure Resource Management (ARM) template(s) for the resource group should be stored in source control.
* Each resource groups should align to a specific workload or application.
* Azure Management Group is likely to be extremely flat and may only require a single management group. This will serve as a future mechanism for updating governance designs, as corporate policy matures. If the use case is expected to include additional business units or billing units in the future, a management group hierarchy should be considered further to account for billing unit and/or application level hierarchies.
* Similarly, extensive Azure Policy implementation could exceed the teams time commitments and may not provide a great deal of value at this time. However, a simple default policy should be created and applied to each management group to enforce the small number of current cloud governance policy statements. This will serve as a mechanism for defining the implementation of specific governance requirements. Those implementations can then be applied across all deployed assets.

### Resource Tagging

The **Classification** pattern to tagging has been chosen as a model for resource tagging.

* Deployed assets should be tagged with the following values: Data Classification, Criticality, SLA, and Environment.
* These four values will drive governance, operations, and security decisions.
* If this design guide is being implemented for a business unit or team within a larger corporation, tagging should also include metadata for the billing unit.

### Identity Solution

In conjunction with Identity Admins, a **Replication** pattern for hybrid identity has been chosen.

* RBAC will be provided by Azure AD, leveraging the directory synchronization or "Same Sign-On" that was implemented during the Office 365 implementation
    * See [Reference Architecture for Azure AD Integration](/azure/architecture/reference-architectures/identity/adfs) for implementation guidance.
* The Azure AD tenant will also govern authentication and access for assets deployed to Azure.

### Software Defined Network

At this point, a **Cloud Native** pattern to networking has been chosen.

* Azure subscriptions may connect to an existing data center via VPN, but must follow all existing on-prem IT governance policies regarding connection of a demilitarized zone to protected resources.
    * See [VPN Reference Architecture](/azure/architecture/reference-architectures/hybrid-networking/vpn) for implementation guidance regarding VPN connectivity
    * Decisions regarding subnet, firewall, and routing are currently being deferred to each application/workload lead.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads.

### Encryption

At this point, a **Cloud Native** pattern to encryption is suggested but not required of any development team.

* No governance requirements have been set regarding the use of encryption, because mission critical and protected data are not permitted based in the use case.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads.

### Log & Reporting

At this point, a **Cloud Native** pattern to log and reporting is suggested but not required of any development team.

* No governance requirements have been set regarding the data to be collected for logging or reporting purposes.
* Additional analysis will be required prior to the release of any protected data or mission critical workloads.

### Enforcement Automation

At this point, the **Simple Enforcement** pattern to enforcement is required.

* Azure security center will be used to monitor security risks when configured.
* RBAC is required in all subscriptions to govern authentication enforcement.
* Azure Policy is to be applied to all Management Groups. However, the level of policies being enforced will be very limited.
* While Management Groups are being leveraged, the level of hierarchy, policy, and on-going management processes are expected to be much simpler than those seen with a Consistent Enforcement pattern. The protections provided at this stage are also much less reliable, as there are no processes in place to validate that all deployments adhere to this requirement.
* Prior to the deployment of protected data or missions critical workloads, an **On-going Enforcement** pattern will be implemented to ensure consistent application of Azure Policies with more robust implementation requirements.

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

* Use Case Assumption: The use case in this design guide is built on the assumption that this implementation serves a single business unit (or billing unit). The use case also assumes that the business unit serves customers in a single geo-political region. It is also assumed that there are no known future state plans to integrate other business units or geographies. These are not data points that the Cloud Governance Team is likely to be able to determine in isolation. There is likely a dependency on IT and business leadership. If these assumptions prove false, the team should consider the [Enterprise MVP Governance Design Guide](../enterprise-mvp/design-guide.md) as a potential starting point for governance implementation. While the implementation differences between the two are subtle, they can have a big impact later in the process.
* Protected data and mission critical application assumption: It is assumed that no protected data will be hosted in the cloud at this time. Additionally, it is assumed that no mission cricital apps will be hosted in the cloud at this time. Should either change, this design should be re-evaluated. If this assumption is false, see the design guide for [Production Workloads](../production-workload/design-guide.md) which shares a similar use case.
* Identity Assumption: It is assumed that the identity team has already configured an Identity integration with Azure AD that meets current IT governance policies. If that assumption is false, there is a dependency on system administrators with identity experience to configure that integration.
* Network Assumption: It is assumed that the networking team has implemented an Azure compatible VPN solution that confirms to existing IT governance policies. If that assumption is false, there is a dependency on system administrators and potential the Cloud Adoption Team(s).

## Conclusion

The 8 best practices above are one example of ways to design the base system, in order to reduce risk and promote readiness for the future integration of a robust governance strategy. This design guide is derived from a synthesized customer scenario for demonstration purposes. To learn more about the decisions that informed this design guide, see the articles that outline this scenarios [Use Case](./use-case.md) and [Corporate Policy](./corporate-policy.md).

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case](#use-case:-future-proof) and [Corporate Policy](#corporate-policy) that influenced this guidance. More than likely, this guide will require customization. To aid in customizing this guide and making relevant decisions, the following links may be of value:

**[Defining Corporate Policy](../../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../../governance-disciplines.md)
