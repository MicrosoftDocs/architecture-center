---
title: Security and identity with Azure and AWS
description: Get guidance for integrating security and identity services across Azure and AWS. Explore strong authentication and explicit trust validation, PIM, and more.
author: jerrymsft
ms.author: gerhoads
ms.date: 01/29/2025
ms.topic: conceptual
ms.subservice: architecture-guide
categories:
  - identity
products:
  - entra-id
ms.custom:
  - migration
  - aws-to-azure
---
# Azure Identity Management for AWS architects

This guide is intended for organizations using AWS that are migrating to Azure or adopting a multi-cloud strategy. It aims to help AWS architects understand Azure's identity management solutions by comparing them to familiar AWS services.

> [!TIP]
> If you're looking instead to extend Microsoft Entra ID into AWS, see [Microsoft Entra identity management and access management for AWS](/azure/architecture/reference-architectures/aws/aws-azure-ad-security)

## Core identity services

The core identity services form the foundation of identity and access management in both platforms. AWS professionals will find similar capabilities in Azure, though some architectural differences exist in implementation. These services offer core authentication, authorization, and accounting (AAA) capabilities as well the ability organize cloud resources into logical structures.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra ID](/entra/identity/hybrid/connect/whatis-pta) | Centralized identity management service providing single sign-on (SSO), multi-factor authentication (MFA), and integration with various applications.|
| [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html) | [Azure Management Groups](/azure/governance/management-groups/overview) | Hierarchical organization structure for managing multiple accounts/subscriptions with inherited policies |
| [AWS Single Sign-On](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra ID Single Sign-On](/entra/identity/enterprise-apps/what-is-single-sign-on) | Centralized access management enabling users to access multiple applications with single credentials |
| [AWS Directory Service](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html) | [Microsoft Entra Directory Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/overview) | Managed directory services providing domain join, group policy, LDAP, and Kerberos/NTLM authentication |

## Authentication and access control

Authentication and access control services in both platforms provide essential security features for verifying user identities and managing resource access. These services handle multi-factor authentication, access reviews, external user management, and role-based permissions.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS Multi-Factor Authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html) | [Microsoft Entra Verified ID](/entra/verified-id/introduction-to-verifiable-credentials-architecture) | Additional security layer requiring multiple forms of verification for user sign-ins |
| [AWS IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html) | [Microsoft Entra Access Reviews](/entra/id-governance/access-reviews-overview) | Tools and services for reviewing and managing access permissions to resources |
| [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra External ID](/entra/external-id/external-identities-overview) | External user access management platform for secure cross-organization collaboration e.g. SAML and OIDC |
| [AWS Resource Access Manager](https://docs.aws.amazon.com/ram/latest/userguide/what-is.html) | [Microsoft Entra Role Management](/entra/identity/role-based-access-control/custom-overview) | Fine-grained access control system for resource management through role assignments |

## Identity governance

Managing identities and access is crucial for maintaining security and compliance. Both AWS and Azure offer solutions for identity governance, enabling organizations and workload teams to manage the lifecycle of identities, conduct access reviews, and control privileged access.

In AWS, managing identity lifecycle, access reviews, and privileged access requires a combination of several services. AWS Identity and Access Management (IAM) handles secure access to resources, while IAM Access Analyzer helps identify shared resources. AWS Organizations allows for centralized management of multiple accounts, and IAM Identity Center provides centralized access management. Additionally, AWS CloudTrail and AWS Config enable governance, compliance, and auditing of AWS resources. Together, these services can be tailored to meet specific organizational needs, ensuring compliance and security.

In Azure, **[Microsoft Entra identity governance](/entra/id-governance/identity-governance-overview)** offers a integrated solution for managing identity lifecycle, access reviews, and privileged access. It simplifies these processes with automated workflows, access certifications, and policy enforcement, providing a unified approach to identity governance.

## Privileged access management

AWS IAM temporary elevated access is an open source security solution that allows organizations to grant temporary elevated access to AWS resources via AWS IAM Identity Center. This approach ensures that users only have elevated privileges for a limited time and for specific tasks, reducing the risk of unauthorized access.

**[Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure)**: Azure's PIM provides just-in-time privileged access management. You use PIM to manage, control, and monitor access to important resources and critical permissions in your organization. PIM includes features such as role activation with approval workflows, time-bound access, and access reviews to ensure that privileged roles are only granted when necessary and are fully audited.


| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | [Microsoft Entra privileged access audit](/entra/id-governance/privileged-identity-management/pim-how-to-use-audit-log) | Comprehensive audit logging for privileged access activities |
| [AWS IAM + custom automation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) | [Microsoft Entra Just In Time Access](/entra/id-governance/privileged-identity-management/pim-configure) | Time-bound privileged role activation process |

## Hybrid identity

Both platforms provide solutions for managing hybrid identity scenarios, integrating cloud and on-premises resources.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS Directory Service AD Connector](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_ad_connector.html) | [Microsoft Entra Connect](/entra/identity/hybrid/connect/whatis-azure-ad-connect) | Directory synchronization tool for hybrid identity management |
| [AWS IAM SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml.html) | [Microsoft Entra Federation Services](/entra/identity/hybrid/connect/how-to-connect-fed-whatis) | Identity federation service for single sign-on |
| [AWS Managed Microsoft AD](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_microsoft_ad.html) | [Microsoft Entra password sash synchronization](/entra/identity/hybrid/connect/whatis-phs) | Password synchronization between on-premises and cloud |


## Application access and API identity management

Both platforms provide identity services to secure application access and API authentication. These services manage user authentication, application permissions, and API access controls through identity-based mechanisms.

| AWS Service | Azure Service | Description |
|------------|---------------|-------------|
| [AWS Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html) | [Microsoft Entra External ID](/entra/external-id/external-identities-overview) | Identity management service for customer-facing applications and user authentication |
| [AWS IAM OIDC provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) | [Microsoft Entra App registrations](/entra/identity-platform/v2-protocols-oidc) | Application identity registration and OAuth/OIDC configuration for securing applications |
| [AWS Security Token Service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) | [Microsoft Entra Token Service](/entra/identity-platform/security-tokens) | Issues security tokens for application and service authentication |
| [AWS IAM Roles for Applications](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html) | [Microsoft Entra Workload ID](/entra/workload-id/workload-identities-overview) | Managed identities for applications to securely access platform resources |
| [AWS IAM authorization](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_controlling.html) | [Microsoft Entra OAuth 2.0](/entra/identity-platform/v2-oauth2-auth-code-flow) | Identity-based authorization for APIs using OAuth 2.0 and JWT tokens |


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Jerry Rhoads](https://www.linkedin.com/in/jerrymsft/) |
Principal Partner Solutions Architect

Other contributor:

- [Adam Cerini](https://www.linkedin.com/in/adamcerini/) | Director, Partner Technology Strategist

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Set up Microsoft Entra ID for your organization](/entra/)
* [Plan your Microsoft Entra ID deployment](/entra/architecture/deployment-plans)
* [Configure hybrid identity with Microsoft Entra Connect](/entra/identity/hybrid/connect/how-to-connect-install-roadmap)
* [Implement Microsoft Entra Privileged Identity Management](/entra/id-governance/privileged-identity-management/pim-deployment-plan)
* [Secure applications with the Microsoft identity platform](/entra/identity-platform/quickstart-register-app)

## Related resources

- [Compare AWS and Azure resource management](resources.md)
- [Compare AWS and Azure accounts](accounts.md)




