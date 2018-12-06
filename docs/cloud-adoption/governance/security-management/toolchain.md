---
title: "Fusion: What tools can help better manage security in Azure?"
description: Explanation of the tools that can facilitate improved security management in Azure
author: BrianBlanchard
ms.date: 12/5/2018
---

# Fusion: What tools can help better manage security management in Azure?

In the [Intro to Cloud Governance](../overview.md), Security Management is one of the Five Disciplines to Cloud Governance. This discipline focuses on ways of establishing policies that protect the network, assets, and most importantly the data that will reside on a Cloud Provider's solution. Within the Five Disciplines of Cloud Governance, Security management includes classification of the digital estate and data. It also includes documentation of risks, business tolerance, and mitigation strategies associated with the security of the data, assets, and network. From a technical perspective, this also includes involvement in decisions regarding [encryption](../../infrastructure/encryption/overview.md), [network requirements](../../infrastructure/software-defined-networks/overview.md), [hybrid identity strategies](../../infrastructure/identity/overview.md), and tools to [automate enforcement](../../infrastructure/policy-enforcement/overview.md) of security policies across [resource groups](../../infrastructure/resource-grouping/overview.md).

Unlike the cloud agnostic position throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help mature the policies and processes that support this governance discipline.

|  |Azure feature  |Azure Virtual Network  |Azure AD Auth  | Azure PowerShell |
|---------|---------|---------|---------|---------|
|Security risk assessment     | Cloud Service Trust Platform         | No         | Yes         | ? |
|Secure on-premises network resources    | Azure Application Proxy | Yes         | No         | Yes |
|Filter and route network traffic     | Network Security Groups         | Yes         | No         | Yes         |
|Secure passwords, connection strings, and other sensitive data     | Azure Key Vault        | No         | No       | Yes | 
|Azure Data Warehouse and SQL Database protection     | Transparent data encryption (TDE) and Azure SQL Firewall | Yes         | No         | Yes         |
|General data protection    | Data Encryption at Rest | No | No         | Yes         |
|SQL data security     | SQL Advanced Threat Protection | Yes | Yes | Yes |
|RAM/CPU storage     | Azure Virtual Machines (VM) | Yes | No | No |
|Identity authentication and conditional access    | Azure Active Directory and Role Based Access Control | No | Yes | Yes |
|Software Defined Networks     | Azure Virtual Networks | Yes | No | No |
|Storage service protection    | Storage Service Encryption (SSE) | No | Yes | No |
|VM disk protection   | Azure Disk Encryption | Yes | No | Yes |
|Database auditing and threat protection    | Azure SQL Database | No | Yes | No |
|VMBA threat detection alerts    | Azure Security Center | Yes | No | No |
|Third-party deployment    | Azure Active Directory Domain Services | No | Yes | No |
|Backup and disaster recovery    | Azure Site Recovery | Yes | No| Yes |

Aside from the Azure native tools mentioned above, it is extremely common for customers to leverage 3rd party tools for facilitating security management activities.

For a complete list of Azure security services, see [Security services and technologies available on Azure](https://docs.microsoft.com/en-us/azure/security/azure-security-services-technologies).
