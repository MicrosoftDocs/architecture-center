---
title: "Fusion: Governance Design Guide future proof"
description: Explanation Design guide to action the concepts within governance.
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: A Governance Design Guide for Enterprise MVP

Fusion provides a cloud agnostic approach to the creation of a cloud governance strategy. To learn more about that model, checkout the [overview section of Governance](../overview.md). This article demonstrates implementation of a cloud governance strategy that aligns to the specific use case below: Enterprise MVP for Governance. The concept of MVP or Minimally Viable Product, focuses on delivering just enough governance to safely allow for a limited amount of cloud adoption. As cloud adoption plans evolve and grow, so would governance requirements. In this type of model, a plan for scaling governance is crucial to avoid future blockers.

## Use Case: Enterprise MVP

The need for governance is personal and unique. Defining and implementing a governance strategy requires an understanding of the business risks and the business's tolerance for those risks. Both evolve over time, especially as new technical features are adopted. When risk is high and tolerance is low, the business may be willing to invest in the disciplines required to govern the cloud. Conversely, if risk is low and tolerance is high, it may be difficult to fund an enterprise scale cloud governance program.

This design guide focuses on a scenario that is closer to the latter case; The company has a relatively low risk tolerance. However, the budgeted efforts to adoption the cloud are also relatively low risk. The following are characteristics that were factored into the design of the cloud governance strategy and this design guide.

> [!NOTE]
> For readers that are familiar with the [Governance Design Guide for Future Proof](./future-proof.md), this design guide is based on some subtle changes to the use case. The company in this use case is larger, more geographically dispersed, more complex, and has many more assets in the digital estate. See the details below for more information. 

### Relevant Business Characteristics

* Sales and operations both span multiple geographic areas with global customers in multiple markets
* The business grew through acquisition and operates across three business units based on target customer base. Budgeting is a complex matrix across business unit and function.
* The business views most of IT as a capital drain or a cost center.

### Current State

* IT operates more than 20 privately-owned datacenters around the globe.
* Each datacenter is connected by a series of regional leased lines, creating a loosely-bound global WAN
* IT entered the cloud by migrating all end user email to Office 365, which has been complete for over 6 months.
* A few IT assets have been deployed to the cloud
* Multiple development teams are working in a dev/test capacity to learn about cloud native capabilities
* The BI team is experimenting with big data in the cloud
* The governance team has set a policy that customer's PII (Personally Identifiable Information) and financial data can not be hosted in the cloud, which limits mission critical applications in the current deployments.

### Future State

* The cloud adoption plan calls for 500% growth in cloud adoption this year
* The CIO and CFO have committed to terminating two datacenter leases within the next 36 months, by migrating more than 5,000 assets to the cloud
* Both App Dev and BI will likely release production solutions to the cloud in the next 24 months.
* The governance team's policy on PII and financial data will need to evolve for either of the future state visions to be realized.

### Objective

For the future state to be realized, PII and Financial Data will have to go to the cloud. For that to happen, the cloud will need a robust cloud governance strategy.
The business is not willing to invest in Cloud Governance today. However, Cloud Governance is likely to be a wise investment in the near future.
The objective of this design guide is to establish a common foundation for all deployments. That foundation will need to scale as new policies and governance disciplines are added.

## Corporate Policy

Based on the [Enterprise MVP Use Case](#use-case:-future-proof), the following is a sample of a corporate policy synthesized from similar customer experiences. This corporate policy can serve as a foundation for personalizing and defining a more targeted governance policies. The landing page on the [five disciplines of cloud governance](../governance-disciplines.md) can aid in customizing this policy.

> [!NOTE]
> For readers that are familiar with the [Governance Design Guide for Future Proof](./future-proof.md), this design guide is based on subtle changes to the use case and corporate policy. The company in this use case is larger, more geographically dispersed, more complex, and has many more assets in the digital estate. See the details below to understand how those changes impact the use case's risk, tolerance, and policy statements.

## Business Risks

At this stage of cloud adoption, future compatibility represents the greatest risk from a governance perspective. A basic foundation for cloud adoption would help avoid costly rework and future adoption blockers. This business risk can be broken down tactically into a few technical risks:

* There is a risk that the application of governance to deployed assets could be difficult and costly.
* There is a risk that governance may not be properly applied across an application or workload, creating gaps in security.
* There is a risk of inconsistency with so many teams working in the cloud.
* There is a risk of costs not properly aligning to business units, teams, or other budgetary management units.
* There is a risk associated with multiple identities being used to manage various deployments, which could lead to security issues.
* There is a risk of not meeting SLAs to the business for various assets or workloads
* There is a risk of one of the teams deploying to the cloud accidentally violating security, sla, or cost assumptions.

In a real-world scenario, there are likely to be a few additional [business risks](../policy-compliance/understanding-business-risk.md) worth noting at this stage of adoption. The article on [understanding business risks](../policy-compliance/understanding-business-risk.md) can help capture relevant business risks.

## Tolerance Indictors

The current tolerance for risk is high and appetite for investing in cloud governance is low. As such, the tolerance indicators for the Future Proof policy act like a reminder. When/if the following indicators are observed, it would be wise to revisit the business's tolerance for risk.

* Inclusion of protected data in defined cloud adoption plans
* Inclusion of assets that have any dependency on protected data
* Inclusion of assets that support mission critical functionality
* Deployment of more than 1,000 assets to the cloud
* Monthly spend exceeding $10,000/month

The above indicators are based on the synthesized use case. Adjust accordingly to align with actual tolerance indicators. See the article on [metrics and tolerance indicators](../policy-compliance/risk-tolerance.md) for additional guidance.

## Policy Statements

The following policy statements would establish requirements to mitigate the defined risks. To understand options and better align the 5 disciplines of cloud governance, click on any of the policy statement headers to learn more about the specific governance discipline.

* [Configuration Management](../configuration-management/overview.md): Multiple
    * All assets must be grouped and tagged, in alignment with the Grouping and Tagging strategies defined in the design guide.
    * All assets must use an approved deployment model defined in the design guide.
* [Identity Management](../identity-management/overview.md): Multiple
    * All assets deployed to the cloud should be controlled using identities and roles approved by current governance policies.
    * All groups in the on-prem AD infrastructure which have elevated privileges should be mapped to an approved RBAC role
    * All authentication models in the cloud should be compatible with ticket-based and third-party multi-factor authentication  
* [Security Management](../security-management/overview.md): Multiple
    * Any asset deployed to the cloud must have an approved data classification
    * No assets identified with a protected level of data may be deployed to the cloud
    * Until minimum network security requirements can be validated and governed, cloud environments are seen as a demilitarized zone and should meet similar connection requirements
* [Cost Management](../cost-management/overview.md): For tracking purposes, all assets must be assigned to a billing unit.
* [Resource Management](../resource-management/overview.md): Since no mission critical workloads are deployed at this stage, there are no SLA, performance, or BCDR requirements to be governed.

## Monitoring and Enforcement

A budget has not been allocated to the on-going monitoring and enforcement of these governance policies. Initial education and limited involvement in deployment planning are the two primary opportunities to monitor adherence to policy statements.

The cloud governance team currently consists of two members of the existing governance team, who are interested in learning about the cloud and aiding in adoption efforts.

**Initial Eduction:** The "cloud governance team" is investing time to educate the cloud adoption teams on the design guides that support these policies.

**Deployment Planning:** Prior to deployment of any asset, the "cloud governance team" will review the design guide with the cloud adoption teams to validate alignment.

## Design Guide

Many of the risks above can be mitigated through the adoption of basic standards and a few simple policy statements.
Mitigating these risks early in the process will future proof deployments, easing governance adoption down the road.
> [!CAUTION]
> The following design guide contains extremely specific guidance based on the Use Case and Corporate Policies established for this synthesized customer scenario. Each section contains one or more links to personalize the Design Guidance to align to a specific use case.

1) [Subscription Model](../../infrastructure/subscriptions/overview): The **Complex** pattern has been chosen for Azure subscriptions. As need arises, a Department should be established for each major business unit in each operating geography. Within each of the Departments, Subscriptions should be created for each application archetype.
2) [Resource Grouping](../../infrastructure/resource-grouping/overview.md): **Complex grouping** has been chosen for cloud deployments. This means that assets being deployed should be a member of a Resource Group and Azure Management Group. As part of the deployment process, an Azure Resource Management (ARM) template(s) for the resource group should be stored in source control. The resource groups should align to the workload or application. The Azure Management Group should represent the hierarchy of billing responsibility through nested groups.
3) [Resource Tagging](../../infrastructure/resource-tagging/overview.md): An **Accounting** pattern to tagging has been chosen for all cloud deployments. This means that every asset being deployed to the cloud should be tagged with value for the following: Department/Billing Unit, Data Classification, Criticality, SLA, and Environment. These five values along with the Azure Management Group and Subscription associated with a deployed asset will drive governance, operations, and security decisions.
4) [Identity Solution](../../infrastructure/identity/overview.md): The team has chosen a **Directory Replication w/Federation** pattern for hybrid identity. As such, all RBAC will be provided by Azure AD, leveraging the federation or "Same Sign-On" that was implemented during the Office 365 implementation. When ticket or 3rd party multi-factor authentication is required, a VM hosting a replicated instance of AD will be deployed to the subscription. Later this model is likely to be expanded to a **Global Replication w/Federation** pattern to provide AD as a shared service.
5) [Software Defined Network](../../infrastructure/software-defined-networks/overview.md): At this point, a **Hybrid** pattern to networking has been chosen. Azure subscriptions may connect to an existing data center via VPN, in accordance with existing demilitarized zone policies. Decisions regarding subnet, firewall, and routing is currently being deferred to each application/workload lead. Prior to the adoption of protected data or mission critical workloads, IT will establish a Hub/Spoke or Global Hub/Spoke model with shared Express Route access to the WAN. At that point, additional networking requirements will be established for each subscription prior to connecting to shared services.
6) [Encryption](../../infrastructure/encryption/overview.md): At this point, a Cloud Native pattern to encryption is suggested but not required. No governance requirements have been set regarding the use of encryption, because mission critical and protected data are not permitted based on the use case. Additional analysis will be required prior to the release of any protected data.
7) [Log & Reporting](../../infrastructure/logs-and-reporting/overview.md): At this point, a **Centralized** pattern to log and reporting is provided. No governance requirements have been set regarding the data to be collected. Additional analysis will be required prior to the release of any protected data or mission critical workloads. Prior to support for protected data or mission critical workloads, the centralized logging tenant will be integrated into operational monitoring. Applications will be required to meet security and logging requirements associated with the use of that tenant, if the application is to be supported with a defined SLA.
8) [Enforcement Automation](../monitoring-enforcement/overview.md): At this point, the **Trust but Verify** pattern to enforcement is required. Azure security center will be used to monitor security risks. RBAC is required in all subscriptions to govern authentication enforcement. Prior to the deployment of protected data or missions critical workloads, an On-going Enforcement pattern will be implemented.

The 8 best practices above will reduce risk and promote readiness for the future integration of a robust governance strategy.

## Next steps

Before attempting to implement this design guide, validate alignment to the [Use Case]() and [Corporate Policy]() that influenced this guidance.
More than likely, this guide will require customization. To aid in customizing this guide and making relevant decisions, the following links may be of value:

**[Defining Corporate Policy](../policy-compliance/overview.md)**: Fusion Model to defining risk driven policies to govern the cloud.
**[Adjusting the 5 disciplines of cloud governance](../governance-disciplines.md)**: Fusion model to implementing those policies across the five disciplines that automate governance.

> [!div class="nextstepaction"]
> [Adjusting the 5 disciplines of cloud governance](../governance-disciplines.md)
