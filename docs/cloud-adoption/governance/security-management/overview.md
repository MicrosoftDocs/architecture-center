---
title: "Fusion: How can a company add Security Management discipline to their Cloud Governance execution?"
description: Explanation of the concept Resource management in relation to cloud governance
author: BrianBlanchard
ms.date: 12/17/2018
---

# Fusion: How can a company add Security Management discipline to their Cloud Governance execution?

In the [Intro to Cloud Governance](../overview.md), Security Management is one of the five disciplines to Cloud Governance. This discipline focuses on ways of establishing policies that protect the network, assets, and most importantly the data that will reside on a Cloud Provider's solution. Within the five disciplines of Cloud Governance, Security management includes classification of the digital estate and data. It also includes documentation of risks, business tolerance, and mitigation strategies associated with the security of the data, assets, and network. From a technical perspective, this also includes involvement in decisions regarding [encryption](../../infrastructure/encryption/overview.md), [network requirements](../../infrastructure/software-defined-networks/overview.md), [hybrid identity strategies](../../infrastructure/identity/overview.md), and tools to [automate enforcement](../../infrastructure/policy-enforcement/overview.md) of security policies across [resource groups](../../infrastructure/resource-grouping/overview.md).

This article outlines the Security Management process that a company experiences during the planning, building, adopting, and operating phases of implementing a cloud solution. It's impossible for any one document to account for all of the requirements of any business. As such, each section of this article outlines suggested minimum and potential activities. The objective of these activities is to help you build a [Policy MVP](../policy-compliance/overview.md), but establish a framework for [Incremental Policy](../policy-compliance/overview.md) evolution. The Cloud Governance Team should decide how much to invest in these activities to improve the Security Management position.

> [!CAUTION]
> Neither the minimum or potential activities outlined in this article are aligned to specific corporate policies or third party compliance requirements. This guidance is designed to help facilitate the conversations that will lead to alignment of both requirements with a Cloud Governance Model.

![Four phases of adoption](../../_images/adoption-phases.png)

*Figure 1. Adoption phases of the incremental approach to cloud governance*

## Planning and readiness

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Plan process](../../transformation-journeys/operational-transformation/plan.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Evaluate your [Security Management Tool Chain](toolchain.md) options.
* Develop a draft Architecture Guidelines document and distribute to key stakeholders.
* Educate and involve the people and teams impacted by the development of Architecture Guidelines.
* Add prioritized security tasks to your [migration backlog](../../migration/plan/migration-backlog.md).

**Potential activities**

* Define a data classification schema.
* Conduct a [digital estate](../../digital-estate/overview.md) planning process to inventory the current IT assets powering your business processes and supporting operations. 
* Conduct a [policy review](../../governance/policy-compliance/what-is-a-cloud-policy-review.md) to begin the process of modernizing existing corporate IT security policies, and define MVP policies addressing known risks.
* Determine whether your security management policy includes a [Cloud Native](cloud-native-policy.md) policy.
* Review your cloud platform's security guidelines. For Azure these can be found in the [Microsoft Service Trust Platform](https://www.microsoft.com/en-us/trustcenter/stp/default.aspx).
* Determine whether your security management policy includes a [Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl/). 
* Evaluate network, data, and asset-related business risks based on the next one to three releases, and gauge your organization's tolerance for those risks.
* Review Microsoft's [top trends in cybersecurity](https://www.microsoft.com/en-us/security/operations/security-intelligence-report) report to get an overview of the current security landscape.
* Consider developing a [Security DevOps](https://www.microsoft.com/en-us/securityengineering/devsecops) role in your organization.

## Build and pre-deployment

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Build process](../../transformation-journeys/operational-transformation/build.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Implement your [Security Management Tool Chain](toolchain.md) by rolling out in a pre-deployment phase.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Implement security tasks on your prioritized migration backlog.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption.

**Potential activities**

* Determine your organization's [encryption](../../infrastructure/encryption/overview.md) strategy for cloud-hosted data.
* Evaluate your cloud deployment's [identity](../../infrastructure/identity/overview.md) strategy. Determine how your cloud-based identity solution will co-exist or integrate with on-premises identity providers. 
* Determine network boundary policies for your [Software Defined Networking (SDN)](../../infrastructure/software-defined-networks/overview.md) design to ensure secure virtualized networking capabilities.
* Evaluate your organization's [least privilege access](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/roles-delegate-by-task) policies, and use task-based roles to provide access to specific resources.
* Apply security and monitoring mechanisms to for all cloud services and virtual machines.
* Automate [security policies](../../infrastructure/policy-enforcement/overview.md) where possible.
* Review your security management policy and determine if you need to modify your plans according to best practices guidance such as those outlined in the [Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl/).

## Adopt and migrate

While not directly aligned, this phase of governance maturity most closely maps to the activities outlined in the [Migrate process](../../transformation-journeys/operational-transformation/migrate.md) for the [Operational Transformation Journey](../../transformation-journeys/operational-transformation/overview.md).

**Minimum suggested activities**

* Migrate your [Security Management Tool Chain](toolchain.md) from pre-deployment to production.
* Update the Architecture Guidelines document and distribute to key stakeholders.
* Develop educational materials and documentation, awareness communications, incentives and other programs to help drive user adoption

**Potential activities**

* Review the latest security management and threat information to identify any new business risks.
* Gauge your organization's tolerance to handle new security risks that may arise.
* Identify deviations from policy, and enforce corrections.
* Adjust security and access control automation to ensure maximum policy compliance.  
* Validate that the best practices defined during the Build / Pre-deployment phases are properly executed. 
* Review your least privilege access polices and adjust access controls to maximize security. 
* Test your Security Management Tool Chain against your workloads to identify and resolve any vulnerabilities.

## Operate and post-implementation

Once the transformation is complete, governance and operations must live on for the natural lifecycle of an application or workload. This phase of governance maturity focuses on the activities that commonly come after the solution is implemented and the transformation cycle begins to stabilize.

**Minimum suggested activities**

* Validate and/or refine your [Security Management Tool Chain](toolchain.md).
* Customize notifications and reports to alert you of potential security issues.
* Refine the Architecture Guidelines to guide future adoption processes.
* Communicate and continually re-educate the impacted people and teams on a periodic basis to ensure on-going adherence to Architecture Guidelines.

**Potential activities**

* Discover patterns and behavior for your workloads and configure your monitoring and reporting tools to identify and notify you of any abnormal activity, access or resource usage.
* Continuously update your monitoring and reporting policies to detect the latest vulnerabilities, exploits, and attacks.
* Have procedures in place to quickly stop unauthorized access and disable resources that may have been compromised by an attacker.
* Regularly review the latest security best practices and apply recommendations to your security policy, automation, and monitoring capabilities where possible.
  
## Next steps

Now that you understand the concept of cloud security governance, move on to learn more about [what security and best practices guidance Microsoft provides](azure-security-guidance.md) for Azure.

> [!div class="nextstepaction"]
> [Learn about security guidance for Azure](azure-security-guidance.md)
> [Introduction to Azure Security](https://docs.microsoft.com/en-us/azure/security/azure-security)
> [Learn about logging, reporting, and monitoring](../../infrastructure/logs-and-reporting/overview.md)
