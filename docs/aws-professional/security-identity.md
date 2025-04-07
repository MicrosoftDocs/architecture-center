---
title: Security and identity with Azure and AWS
description: Get guidance for integrating security and identity services across Azure and AWS. Explore strong authentication and explicit trust validation, PIM, and more.
author: jerrymsft
ms.author: gerhoads
ms.date: 03/27/2025
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

Core identity services in both platforms form the foundation of identity and access management. These services include core authentication, authorization, and accounting (AAA) capabilities, and the ability organize cloud resources into logical structures. AWS professionals will find similar capabilities in Azure, but with some architectural differences in implementation.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra ID](/entra/identity/hybrid/connect/whatis-pta) | Centralized identity management service providing single sign-on (SSO), multi-factor authentication (MFA), and integration with various applications.|
| [AWS Organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html) | [Azure Management Groups](/azure/governance/management-groups/overview) | Hierarchical organization structure for managing multiple accounts/subscriptions with inherited policies |
| [AWS Single Sign-On](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra ID Single Sign-On](/entra/identity/enterprise-apps/what-is-single-sign-on) | Centralized access management enabling users to access multiple applications with single credentials |
| [AWS Directory Service](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/what_is.html) | [Microsoft Entra Directory Domain Services](/entra/identity/domain-services/overview) | Managed directory services providing domain join, group policy, LDAP, and Kerberos/NTLM authentication |

## Authentication and access control

Authentication and access control services in both platforms provide essential security features for verifying user identities and managing resource access. These services handle multi-factor authentication, access reviews, external user management, and role-based permissions.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS Multi-Factor Authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html) | [Microsoft Entra MFA](/entra/identity/authentication/tutorial-enable-azure-mfa) | Additional security layer requiring multiple forms of verification for user sign-ins |
| [AWS IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html) | [Microsoft Entra Access Reviews](/entra/id-governance/access-reviews-overview) | Tools and services for reviewing and managing access permissions to resources |
| [AWS IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html) | [Microsoft Entra External ID](/entra/external-id/external-identities-overview) | External user access management platform for secure cross-organization collaboration e.g. SAML and OIDC |
| [AWS Resource Access Manager](https://docs.aws.amazon.com/ram/latest/userguide/what-is.html) | [Microsoft Entra Role Management](/entra/identity/role-based-access-control/custom-overview) and [Azure RBAC] (/azure/role-based-access-control/overview) | Services with the ability to share cloud resources within an organization. AWS is typically used to share cloud resources between accounts, when using Azure RBAC is often sufficient to achieve similar resource sharing.  |

## Identity governance

Managing identities and access is crucial for maintaining security and compliance. Both AWS and Azure offer solutions for identity governance, enabling organizations and workload teams to manage the lifecycle of identities, conduct access reviews, and control privileged access.

In AWS, managing identity lifecycle, access reviews, and privileged access requires a combination of several services. AWS Identity and Access Management (IAM) handles secure access to resources, while IAM Access Analyzer helps identify shared resources. AWS Organizations allows for centralized management of multiple accounts, and IAM Identity Center provides centralized access management. Additionally, AWS CloudTrail and AWS Config enable governance, compliance, and auditing of AWS resources. Together, these services can be tailored to meet specific organizational needs, ensuring compliance and security.

In Azure, **[Microsoft Entra identity governance](/entra/id-governance/identity-governance-overview)** offers an integrated solution for managing identity lifecycle, access reviews, and privileged access. It simplifies these processes with automated workflows, access certifications, and policy enforcement, providing a unified approach to identity governance.

## Privileged access management

AWS IAM temporary elevated access is an open source security solution that allows organizations to grant temporary elevated access to AWS resources via AWS IAM Identity Center. This approach ensures that users only have elevated privileges for a limited time and for specific tasks, reducing the risk of unauthorized access.

**[Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure)**: Azure's PIM provides just-in-time privileged access management. You use PIM to manage, control, and monitor access to important resources and critical permissions in your organization. PIM includes features such as role activation with approval workflows, time-bound access, and access reviews to ensure that privileged roles are only granted when necessary and are fully audited.


| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) | [Microsoft Entra privileged access audit](/entra/id-governance/privileged-identity-management/pim-how-to-use-audit-log) | Comprehensive audit logging for privileged access activities |
| [AWS IAM + 3rd party products or custom automation](https://docs.aws.amazon.com/singlesignon/latest/userguide/temporary-elevated-access.html) | [Microsoft Entra Just In Time Access](/entra/id-governance/privileged-identity-management/pim-configure) | Time-bound privileged role activation process |

## Hybrid identity

Both platforms provide solutions for managing hybrid identity scenarios, integrating cloud and on-premises resources.

| AWS service | Azure service | Description |
|------------|---------------|-------------|
| [AWS Directory Service AD Connector](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_ad_connector.html) | [Microsoft Entra Connect](/entra/identity/hybrid/connect/whatis-azure-ad-connect) | Directory synchronization tool for hybrid identity management |
| [AWS IAM SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml.html) | [Microsoft Entra Federation Services](/entra/identity/hybrid/connect/how-to-connect-fed-whatis) | Identity federation service for single sign-on |
| [AWS Managed Microsoft AD](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/directory_microsoft_ad.html) | [Microsoft Entra password sash synchronization](/entra/identity/hybrid/connect/whatis-phs) | Password synchronization between on-premises and cloud |


## Application and API user authentication and authorization

Both platforms provide identity services to secure application access and API authentication. These services manage user authentication, application permissions, and API access controls through identity-based mechanisms. The [Microsoft identity platform](/entra/identity-platform/) serves as Azure's unified framework for authentication and authorization across applications, APIs, and services, implementing standards like OAuth 2.0 and OpenID Connect (OIDC). AWS offers similar capabilities through [Amazon Cognito](https://aws.amazon.com/cognito/) as part of its identity suite.

### Core platform comparisons

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
|[Amazon Cognito](https://aws.amazon.com/cognito/) + [AWS Amplify Auth](https://aws.amazon.com/amplify/authentication/) + [AWS STS](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) |[Microsoft identity platform](/entra/identity-platform/v2-overview) | Comprehensive identity platform providing authentication, authorization, and user management for applications and APIs. Both implement OAuth 2.0 and OpenID Connect (OIDC) standards but with different architectural approaches. |

### Key architectural differences

- **AWS approach**: Distributed services that are composed together
- **Microsoft approach**: Unified platform with integrated components

### Developer SDK and libraries

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [AWS Amplify Authentication libraries](https://aws.amazon.com/amplify/authentication/) | [Microsoft Authentication Library (MSAL)](/entra/identity-platform/msal-overview) | Client libraries for implementing authentication flows. MSAL provides a unified SDK across multiple platforms and languages, while AWS offers separate implementations through Amplify. |
| [AWS SDK for JavaScript/Java/Python/etc.](https://aws.amazon.com/developer/tools/) | [MSAL JavaScript/Java/.NET/Python/etc.](/entra/identity-platform/msal-overview#msal-languages-and-frameworks) | Language-specific SDKs to implement authentication. Microsoft's approach offers a high level of consistency across programming languages. |

### OAuth 2.0 flow implementation

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [Amazon Cognito OAuth 2.0 grants](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-integrate-apps.html) | [Microsoft identity platform authentication flows](/entra/identity-platform/authentication-flows-app-scenarios) | Both support standard OAuth 2.0 flows including Authorization Code, Implicit, Client Credentials, and Device Code. |
| [Cognito User Pools authorization code flow](https://docs.aws.amazon.com/cognito/latest/developerguide/authentication.html) | [Microsoft identity platform authorization code flow](/entra/identity-platform/v2-oauth2-auth-code-flow) | Implementation of the secure redirect-based OAuth flow for web applications. |
| [Cognito User Pools PKCE support](https://docs.aws.amazon.com/cognito/latest/developerguide/using-pkce-in-authorization-code.html) | [Microsoft identity platform PKCE support](/entra/identity-platform/v2-oauth2-auth-code-flow#applications-that-support-the-auth-code-flow) | Enhanced security for public clients using Proof Key for Code Exchange. |
| [Cognito custom authentication flows](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-authentication-flow-methods.html) | [Microsoft identity platform custom policies](/entra/identity-platform/authentication-flows-app-scenarios) | Customization of authentication sequences, though implemented differently. |

### Identity provider integration

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [Cognito Identity Provider Federation](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-integrate-apps.html) | [Microsoft identity platform external identity providers](/entra/identity-platform/v2-overview) | Support for social and enterprise identity providers through OIDC and SAML protocols. |
| [Cognito User Pools social sign-in](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-integrate-apps.html) | [Microsoft identity platform social identity providers](/entra/external-id/customers/concept-authentication-methods-customers#social-identity-providers-facebook-google-and-apple) | Integration with providers like Google, Facebook, and Apple for consumer authentication. |
| [Cognito SAML federation](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-integrate-apps.html) | [Microsoft Entra ID SAML federation](/entra/architecture/auth-saml) | Enterprise identity federation through SAML 2.0. |

### Token services

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [AWS Security Token Service (STS)](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) | [Microsoft Entra token service](/entra/identity-platform/security-tokens) | Issues security tokens for application and service authentication. |
| [Cognito Token customization](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-tokens.html) | [Microsoft identity platform token configuration](/entra/identity-platform/access-tokens) | Customization of JWT tokens with claims and scopes. |
| [Cognito token validation](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-tokens-verifying-a-jwt.html) | [Microsoft identity platform token validation](/entra/identity-platform/access-tokens#validate-tokens) | Libraries and services for verifying token authenticity. |

### Application registration and security

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [Cognito App Client Configuration](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-client-apps.html) | [Microsoft Entra App Registrations](/entra/identity-platform/quickstart-register-app) | Registration and configuration of applications using the identity platform. |
| [AWS IAM Roles for Applications](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html) | [Microsoft Entra Workload ID](/entra/workload-id/) | Managed identities for application code resource access. |
| [Cognito Resource Servers](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-define-resource-servers.html) | [Microsoft Identity Platform API permissions](/entra/identity-platform/quickstart-register-app#add-credentials) | Configuration of protected resources and scopes. |

### Developer Experience

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [AWS Amplify CLI](https://docs.amplify.aws/cli/) | [Microsoft identity platform PowerShell/CLI](https://github.com/AzureAD/MSIdentityTools) | Command-line tools for identity configuration. |
| [AWS Cognito Console](https://console.aws.amazon.com/cognito/home) | [Microsoft Entra Admin Center](https://entra.microsoft.com/) | Management interfaces for identity services. |
| [Cognito Hosted UI](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-app-integration.html) | [Microsoft identity platform authentication library UI](/entra/identity-platform/msal-authentication-flows) | Pre-built user interfaces for authentication. |
| [AWS AppSync with Cognito](https://docs.aws.amazon.com/appsync/latest/devguide/security-authorization-use-cases.html) | [Microsoft Graph API with MSAL](/graph/sdks/sdks-overview) | Data access patterns with authentication. |

### Platform-specific features

| AWS Service | Microsoft Service | Description |
|-------------|------------------|-------------|
| [Cognito Identity Pools](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-identity.html) | No direct equivalent | AWS-specific approach for federating identities to AWS resources. |
| No direct equivalent | [Azure Web Apps Easy Auth](/azure/app-service/overview-authentication-authorization) | Platform-level authentication for web applications without code changes. |
| [Cognito User Pool Lambda Triggers](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools-working-with-aws-lambda-triggers.html) | [Microsoft pdentity platform B2C custom policies](/entra/identity-platform/v2-custom-policy-overview) | Extensibility mechanisms for authentication flows. |
| [AWS WAF with Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-waf.html) | [Microsoft Entra conditional access](/conditional-access/overview) | Security policies for access control. |

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

