---
title: "CAF: Security Baseline tools in Azure"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Explanation of the tools that can facilitate improved Security Baseline in Azure
author: BrianBlanchard
---

# Security Baseline tools in Azure

[Security Baseline](overview.md) is one of the [Five Disciplines of Cloud Governance](../governance-disciplines.md). This discipline focuses on ways of establishing policies that protect the network, assets, and most importantly the data that will reside on a Cloud Provider's solution. Within the five disciplines of Cloud Governance, Security Baseline includes classification of the digital estate and data. It also includes documentation of risks, business tolerance, and mitigation strategies associated with the security of the data, assets, and network. From a technical perspective, this also includes involvement in decisions regarding [encryption](../../decision-guides/encryption/overview.md), [network requirements](../../decision-guides/software-defined-network/overview.md), [hybrid identity strategies](../../decision-guides/identity/overview.md), and tools to [automate enforcement](../../decision-guides/policy-enforcement/overview.md) of security policies across [resource groups](../../decision-guides/resource-consistency/overview.md).

The following is a list of Azure tools that can help mature the policies and processes that support Security Baseline.

|                                                            | [Azure portal](https://azure.microsoft.com/features/azure-portal) / [Resource Manager](/azure/azure-resource-manager/resource-group-overview)  | [Azure Key Vault](/azure/key-vault)  | [Azure AD](/azure/active-directory/fundamentals/active-directory-whatis) | [Azure Policy](/azure/governance/policy/overview) | [Azure Security Center](/azure/security-center/security-center-intro) | [Azure Monitor](/azure/azure-monitor/overview) |
|------------------------------------------------------------|---------------------------------|-----------------|----------|--------------|-----------------------|---------------|
| Apply access controls to resources and resource creation   | Yes                             | No              | Yes      | No           | No                    | No            |
| Secure virtual networks                                    | Yes                             | No              | No       | Yes          | No                    | No            |
| Encrypt virtual drives                                     | No                              | Yes             | No       | No           | No                    | No            |
| Encrypt PaaS storage and databases                         | No                              | Yes             | No       | No           | No                    | No            |
| Manage hybrid identity services                            | No                              | No              | Yes      | No           | No                    | No            |
| Restrict allowed types of resource                         | No                              | No              | No       | Yes          | No                    | No            |
| Enforce geo-regional restrictions                          | No                              | No              | No       | Yes          | No                    | No            |
| Monitor security health of networks and resources          | No                              | No              | No       | No           | Yes                   | Yes           |
| Detect malicious activity                                  | No                              | No              | No       | No           | Yes                   | Yes           |
| Preemptively detect vulnerabilities                        | No                              | No              | No       | No           | Yes                   | No            |
| Configure backup and disaster recovery                     | Yes                             | No              | No       | No           | No                    | No            |

For a complete list of Azure security tools and services, see [Security services and technologies available on Azure](/azure/security/azure-security-services-technologies).

It is also extremely common for customers to use third-party tools for facilitating Security Baseline activities. For more information, see the article [Integrate security solutions in Azure Security Center](/azure/security-center/security-center-partner-integration).

In addition to security tools, the [Microsoft Trust Center](https://www.microsoft.com/trustcenter/guidance/risk-assessment) contains extensive guidance, reports, and related documentation that can help you perform risk assessments as part of your migration planning process.
