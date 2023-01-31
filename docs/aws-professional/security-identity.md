---
title: Security and identity with Azure and AWS
description: Get guidance for integrating security and identity services across Azure and AWS. Explore strong authentication and explicit trust validation, PIM, and more.
author: dougkl007
ms.date: 01/02/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: cloud-fundamentals
categories:
  - security
  - identity
products:
  - azure-active-directory
---
# Multicloud security and identity with Azure and Amazon Web Services (AWS)

Many organizations are finding themselves with a de facto multicloud strategy, even if that wasn't their deliberate strategic intention. In a multicloud environment, it's critical to ensure consistent security and identity experiences to avoid increased friction for developers, business initiatives and increased organizational risk from cyberattacks taking advantage of security gaps.

Driving security and identity consistency across clouds should include:

- Multicloud identity integration
- Strong authentication and explicit trust validation
- Cloud Platform Security (multicloud)
- Microsoft Defender for Cloud
- Privilege Identity Management (Azure)
- Consistent end-to-end identity management

## Multicloud identity integration

Customers using both Azure and AWS cloud platforms benefit from consolidating identity services between these two clouds using [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) and Single Sign-on (SSO) services. This model allows for a consolidated identity plane through which access to services in both clouds can be consistently accessed and governed.

This approach allows for the rich role-based access controls in Azure Active Directory to be enabled across the Identity & Access Management (IAM) services in AWS using rules to associate the user.userprincipalname and user.assignrole attributes from Azure AD into IAM permissions. This approach reduces the number of unique identities users and administrators are required to maintain across both clouds including a consolidation of the identity per account design that AWS employs. The [AWS IAM solution](https://aws.amazon.com/iam/features/?nc=sn&loc=2) allows for and specifically identifies Azure Active Directory as a federation and authentication source for their customers.

A complete walk-through of this integration can be found in the [Tutorial: Azure Active Directory single sign-on (SSO) integration with Amazon Web Services (AWS)](/azure/active-directory/saas-apps/amazon-web-service-tutorial).

## Strong authentication and explicit trust validation

Because many customers continue to support a hybrid identity model for Active Directory services, it's increasingly important for security engineering teams to implement strong authentication solutions and block legacy authentication methods associated primarily with on-premises and legacy Microsoft technologies.

A combination of multi-factor authentication (MFA) and conditional access (CA) policies enable enhanced security for common authentication scenarios for end users in your organization. While MFA itself provides an increase level of security to confirm authentications, additional controls can be applied using [CA controls to block legacy authentication](/azure/active-directory/conditional-access/howto-conditional-access-policy-block-legacy) to both Azure and AWS cloud environments. Strong authentication using only modern authentication clients is only possible with the combination of MFA and CA policies.

## Cloud Platform Security (multicloud)

Once a common identity has been established in your multicloud environment, the [Cloud Platform Security (CPS)](/cloud-app-security/tutorial-cloud-platform-security) service of [Microsoft Defender for Cloud Apps](/cloud-app-security) can be used to discover, monitor, assess, and protect those services. Using the Cloud Discovery dashboard, security operations personnel can review the apps and resources being used across AWS and Azure cloud platforms. Once services are reviewed and sanctioned for use, the services can then be managed as enterprise applications in Azure Active Directory to enable SAML, password-based, and linked Single Sign-On mode for the convenience of users.

CPS also provides for the ability to assess the cloud platforms connected for misconfigurations and compliance using vendor specific recommended security and configuration controls. This design enables organizations to maintain a single consolidated view of all cloud platform services and their compliance status.

CPS also provides access and session control policies to prevent and protect your environment from risky endpoints or users when data exfiltration or malicious files are introduced into those platforms.

## Microsoft Defender for Cloud

[Microsoft Defender for Cloud](/azure/defender-for-cloud) provides unified security management and threat protection across your hybrid and multicloud workloads, including workloads in Azure, Amazon Web Services (AWS), and Google Cloud Platform (GCP). Defender for Cloud helps you find and fix security vulnerabilities, apply access and application controls to block malicious activity, detect threats using analytics and intelligence, and respond quickly when under attack.

To [protect your AWS-based resources on Microsoft Defender for Cloud](/azure/defender-for-cloud/quickstart-onboard-aws?pivots=env-settings), you can connect an account with either the Classic cloud connectors experience or the Environment settings page (in preview), which is recommended.

## Privileged Identity Management (Azure)

To limit and control access for your highest privileged accounts in Azure AD, [Privileged Identity Management (PIM)](/azure/active-directory/privileged-identity-management) can be enabled to provide just-in-time access to services for Azure cloud services. Once deployed, PIM can be used to control and limit access using the assignment model for roles, eliminate persistent access for these privileged accounts, and provide additional discover and monitoring of users with these account types.

When combined with [Microsoft Sentinel](/azure/sentinel), workbooks and playbooks can be established to monitor and raise alerts to your security operations center personnel when there is lateral movement of accounts that have been compromised.

## Consistent end-to-end identity management

Ensure that all processes include an end-to-end view of all clouds as well as on-premises systems and that security and identity personnel are trained on these processes.

Using a single identity across Azure AD, AWS Accounts and on-premises services enable this end-to-end strategy and allows for greater security and protection of accounts for privileged and non-privileged accounts. Customers who are currently looking to reduce the burden of maintaining multiple identities in their multicloud strategy adopt Azure AD to provide consistent and strong control, auditing, and detection of anomalies and abuse of identities in their environment.

Continued growth of new capabilities across the Azure AD ecosystem helps you stay ahead of threats to your environment as a result of using identities as a common control plane in your multicloud environments.

## Next steps

- [Azure Active Directory B2B](/azure/active-directory/external-identities/what-is-b2b): enables access to your corporate applications from partner-managed identities.
- [Azure Active Directory B2C](/azure/active-directory-b2c/overview): service offering support for single sign-on and user management for consumer-facing applications.
- [Azure Active Directory Domain Services](/azure/active-directory-domain-services/overview): hosted domain controller service, allowing Active Directory compatible domain join and user management functionality.
- [Getting started with Microsoft Azure security](/azure/security)
- [Azure Identity Management and access control security best practices](/azure/security/azure-security-identity-management-best-practices)
