---
title: Overview of the security pillar
description: Learn about the key architectural considerations and principles for security and how they apply to the Microsoft Azure Well-Architected Framework.
author: david-stanford
ms.date: 09/08/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products: 
  - azure
categories:
  - security
ms.custom:
  - overview
---

# Overview of the security pillar

Information Security has always been a complex subject, and it evolves quickly with the creative ideas and implementations of attackers and security researchers. The origin of security vulnerabilities started with identifying and exploiting common programming errors and unexpected edge cases. However over time, the attack surface that an attacker may explore and exploit has expanded well beyond that. Attackers now freely exploit vulnerabilities in system configurations, operational practices, and the social habits of the systems' users. As system complexity, connectedness, and the variety of users increase, attackers have more opportunities to identify unprotected edge cases and to "hack" systems into doing things they were not designed to do.

Security is one of the most important aspects of any architecture. It provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. Losing these assurances can negatively impact your business operations and revenue, as well as your organization's reputation in the marketplace. In the following series of articles, we'll discuss key architectural considerations and principles for security and how they apply to Azure.

To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

These are the topics we cover in the security pillar of the Microsoft Azure Well-Architected Framework

| Security Topic | Description |
|-------------------|-------------|
| [Role of security][role] | Security is one of the most important aspects of any architecture. Security provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. |
| [Security design principles][design] | These principles support these three key strategies and describe a securely architected system hosted on cloud or on-premises datacenters (or a combination of both). |
| [Types of attacks to resist][attacks] | An architecture built on good security practices should be resilient to attacks. It should both resist attacks and recover rapidly from disruption to the security assurances of confidentiality, integrity, and availability. |
| [Regulatory compliance][regulatory] | Governments and other organizations frequently publish standards to help define good security practices (due diligence) so that organizations can avoid being negligent in security. |
| [Reduce organizational risk][org-risk] | Much like physical safety, success in information security is defined more as an ongoing task of applying good security practices and principles and hygiene rather than a static absolute state. |
| [Administration][admin] | Administration is the practice of monitoring, maintaining, and operating Information Technology (IT) systems to meet service levels that the business requires. Administration introduces some of the highest impact security risks because performing these tasks requires privileged access to a very broad set of these systems and applications. |
| [Applications and services][app] | Applications and the data associated with them ultimately act as the primary store of business value on a cloud platform. |
| [Governance, risk, and compliance][compliance] | How is the organization's security going to be monitored, audited, and reported? What types of risks does the organization face while trying to protect identifiable information, Intellectual Property (IP), financial information? Are there specific industry, government, or regulatory requirements that dictate or provide recommendation on criteria that your organization's security controls must meet? |
| [Identity and access management][identity] | Identity provides the basis of a large percentage of security assurances. |
| [Info protection and storage][info] | Protecting data at rest is required to maintain confidentiality, integrity, and availability assurances across all workloads. |
| [Network security and containment][network] | Network security has been the traditional linchpin of enterprise security efforts. However, cloud computing has increased the requirement for network perimeters to be more porous and many attackers have mastered the art of attacks on identity system elements (which nearly always bypass network controls). |
| [Security Operations][sec-ops] | Security operations maintain and restores the security assurances of the system as live adversaries attack it. The tasks of security operations are described well by the NIST Cybersecurity Framework functions of Detect, Respond, and Recover. |

## Identity management

Consider using Azure Active Directory (Azure AD) to authenticate and authorize users. Azure AD is a fully managed identity and access management service. You can use it to create domains that exist purely on Azure, or integrate with your on-premises Active Directory identities. Azure AD also integrates with Office365, Dynamics CRM Online, and many third-party SaaS applications. For consumer-facing applications, Azure Active Directory B2C lets users authenticate with their existing social accounts such as Facebook, Google, or LinkedIn, or create a new user account that is managed by Azure AD.

If you want to integrate an on-premises Active Directory environment with an Azure network, several approaches are possible, depending on your requirements. For more information, see our [Identity Management][identity-ref-arch] reference architectures.

## Protecting your infrastructure

Control access to the Azure resources that you deploy. Every Azure subscription has a [trust relationship][ad-subscriptions] with an Azure AD tenant.
Use [Azure role-based access control (Azure RBAC)][rbac] to grant users within your organization the correct permissions to Azure resources. Grant access by assigning Azure roles to users or groups at a certain scope. The scope can be a subscription, a resource group, or a single resource. [Audit][resource-manager-auditing] all changes to infrastructure.

## Application security

In general, the security best practices for application development still apply in the cloud. These include things like using SSL everywhere, protecting against CSRF and XSS attacks, preventing SQL injection attacks, and so on.

Cloud applications often use managed services that have access keys. Never check these keys into source control. Consider storing application secrets in [Azure Key Vault](/azure/key-vault/general/overview).

## Data sovereignty and encryption

Make sure that your data remains in the correct geopolitical zone when using Azure data services. Azure's geo-replicated storage uses the concept of a [paired region][paired-region] in the same geopolitical region.

Use Key Vault to safeguard cryptographic keys and secrets. By using Key Vault, you can encrypt keys and secrets by using keys that are protected by hardware security modules (HSMs). Many Azure storage and DB services support data encryption at rest, including:

- [Azure Storage][storage-encryption]
- [Azure SQL Database][sql-db-encryption]
- [Azure Synapse Analytics][data-warehouse-encryption]
- [Cosmos DB][cosmos-db-encryption]

## Security resources

- [Azure Security Center][security-center] provides integrated security monitoring and policy management for your workload.
- [Azure Security Documentation][security-documentation]
- [Microsoft Trust Center][trust-center]

<!-- security links -->

[role]: ./role-of-security.md
[app]: ./design-apps-services.md
[compliance]: ./governance.md
[identity]: ./design-identity.md
[network]: ./network-security-containment.md
[design]: ./security-principles.md
[attacks]: ./architecture-type.md
[regulatory]: ./design-regulatory-compliance.md
[org-risk]: ./resilience.md
[admin]: ./critical-impact-accounts.md
[info]: ./storage-data-encryption.md
[sec-ops]: ./security-operations.md

<!-- links -->

[identity-ref-arch]: /azure/architecture/reference-architectures/identity/
[resiliency]: ../framework/resiliency/principles.md
[ad-subscriptions]: /azure/active-directory/active-directory-how-subscriptions-associated-directory
[data-warehouse-encryption]: /azure/data-lake-store/data-lake-store-security-overview#data-protection
[cosmos-db-encryption]: /azure/cosmos-db/database-security
[rbac]: /azure/role-based-access-control/overview
[paired-region]: /azure/best-practices-availability-paired-regions
[resource-manager-auditing]: /azure/azure-resource-manager/resource-group-audit
[security-center]: https://azure.microsoft.com/services/security-center
[security-documentation]: /azure/security
[sql-db-encryption]: /azure/sql-database/sql-database-always-encrypted-azure-key-vault
[storage-encryption]: /azure/storage/storage-service-encryption
[trust-center]: https://azure.microsoft.com/support/trust-center