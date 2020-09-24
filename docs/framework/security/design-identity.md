---
title: Security with identity and access management (IAM) in Azure
description: Use Azure Active Directory (Azure AD) to grant access based on identity authentication and authorization.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Identity management

Most architectures have shared services that are hosted and accessed across networks. Those services share common infrastructure and users need to access resources and data from anywhere. For such architectures, relying on just network security controls isn't enough. 

Provide security assurance through _identity management_: the process of authenticating and authorizing [security principals](/windows/security/identity-protection/access-control/security-principals). Use identity management services to authenticate and grant permission to users, partners, customers, applications, services, and other entities. In Azure, use Azure Active Directory (AD), Azure AD B2B, Azure AD B2C.

**How are you implementing Zero-Trust in your design?**
*** 

- Support a single enterprise directory.
- Keep the cloud and on-premises directories synchronized, except for high-privilege accounts.
- Enforce and measure key security attributes when authenticating all users, especially for high-privilege accounts.
- Have a separate identity source for non-employees.
- Use passwordless and multi-factor authentication.
- Blocking legacy protocols and authentication methods.

The recommendations in this article can be implemented through the use of Azure AD. 

## Use a single enterprise directory

Have a single enterprise directory for managing identities of full-time employees and enterprise resources. For example, a single Azure AD directory instance can serve as the authoritative source for corporate and organizational accounts.

This single-source approach increases clarity and consistency for all roles in IT and Security teams. If changes are needed, teams only need to change the directory in one place. Another benefit is the ability to have single sign-on (SSO). By signing in just once using a single user account, you can grant access to all the applications and resources as per the business needs. Users don't have to manage multiple sets of usernames and passwords and you can provision or de-provision application access automatically. For more information, see [Single sign-on](https://azure.microsoft.com/documentation/videos/overview-of-single-sign-on/). 

The [Integrate on-premises Active Directory domains with Azure Active Directory](../../reference-architectures/identity/azure-ad.md) reference architecture integrates on-premises AD domains with Azure AD to provide cloud-based identity authentication.

## Use role-based access control (RBAC)
Use [Azure RBAC](/azure/role-based-access-control/overview) to control the level of access for users. Assign built-in roles to users, groups, service principals, and managed identities.

For more information, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

## Synchronize the hybrid identity systems

Keep your cloud identity synchronized with the existing identity systems to ensure consistency and reduce human errors. 

Consider using [Azure AD connect](/azure/active-directory/connect/active-directory-aadconnect) for synchronizing Azure AD with your existing on-premises directory. For migration projects, have a requirement to complete this task before an Azure migration and development projects begin.

> [!IMPORTANT]
> Don’t synchronize high-privilege accounts to an on-premises directory. If an attacker gets full control of on-premises assets, they can compromise a cloud account.  This strategy will limit the scope of an incident. For more information, see [Critical impact account dependencies](./critical-impact-accounts.md#critical-impact-admin-dependencies--accountworkstation).
>
>
> Synchronization is blocked by default in the default Azure AD Connect configuration. Make sure that you haven’t customized this configuration. For information about filtering in Azure AD, see [Azure AD Connect sync: Configure filtering](/azure/active-directory/hybrid/how-to-connect-sync-configure-filtering)

For more information, see [hybrid identity providers](/azure/active-directory/hybrid/whatis-hybrid-identity).

## Use a separate identity source for third-party accounts

Avoid hosting non-employee accounts in a corporate directory. 

Use cloud identity services that are designed to host third-party accounts. Grant the appropriate level of access to those external entities instead of the default permissions that are given to full-time employees. This differentiation can prevent and detect attacks from these vectors. Also, you reduce the onus of managing these identities internally.

For example, these capabilities natively integrate into the same Azure AD identity and permission model used by Azure and Microsoft 365.

- [Azure AD](/azure/active-directory/) – Employees and Enterprise Resources
- [Azure AD B2B](/azure/active-directory/b2b/) – Partners
- [Azure AD B2C](/azure/active-directory-b2c/) – Customers, citizens

## Use modern password protection

Adopt passwordless authentication and multi-factor authentication (MFA) over time. You can also reduce use of passwords through the use of [Managed Identities](/azure/active-directory/managed-identities-azure-resources/overview).

This recommendation should be enforced for high-privilege accounts, such as administrators. For more information, see [Passwordless Or multi-factor authentication for admins](./critical-impact-accounts.md#passwordless-or-multi-factor-authentication-for-admins). MFA adds a critical second layer of security through phone calls, text messages, and so on. For more information, see [What is Azure Multi-Factor Authentication](/azure/security/fundamentals/identity-management-overview#multi-factor-authentication).

- [Password Guidance](https://www.microsoft.com/research/publication/password-guidance/)
- [NIST guidance](https://pages.nist.gov/800-63-3/sp800-63b.html)

Cloud identity providers manage large volumes of logons and can detect anomalies effectively. They use various data sources to proactively notify companies if their users’ passwords have been found in other breaches. Also, they can validate any given sign-on appears legitimate and isn't coming from an unexpected or known-malicious host.

Synchronizing passwords to the cloud to support these checks also add resiliency during some attacks. You should be able to continue business operations when password hashes are synced to Azure AD. 

For information, see [Configure Azure AD Connect to synchronize password hashes](/azure/active-directory/connect/active-directory-aadconnectsync-implement-password-hash-synchronization).


## Disable legacy authentication methods

Don't use legacy protocols for internet-facing services. For Azure AD-based accounts, configure Conditional Access to block legacy protocols.

Legacy authentication methods aren't effective in deterring password spraying, dictionary, or brute force attacks. These protocols also lack other attack-counter measures, such as account lockouts or back-off timers. Services, running on Azure, which block legacy protocols have observed a 66% reduction in successful account compromises. 

Disabling legacy authentication can be challenging. Users might not want to move to new client software with modern authentication methods. Gradually phase out legacy authentication. Start by using metrics and logging from your authentication provider to determine the number of users who still authenticate with old clients. Next, disable any down-level protocols that aren't used, and set up conditional access for all users who aren’t using legacy protocols. Finally, give plenty of notice and guidance to users about upgrading before blocking legacy authentication for all users and on all services at a protocol level.

For more information, see:
- [What is Conditional Access?](/azure/active-directory/conditional-access/overview)
- [Manage access to Azure management with Conditional Access](/azure/role-based-access-control/conditional-access-azure-management)


## Use cross-platform credential management

Use a common identity provider, such as Azure Active Directory (AD), for authenticating all platforms (Windows, Linux, and others) and cloud services. Azure AD can authenticate on Windows, [Linux](/azure/virtual-machines/linux/login-using-aad), Azure, Microsoft 365, [Amazon Web Services (AWS)](/azure/active-directory/saas-apps/amazon-web-service-tutorial), [Google Services](/azure/active-directory/saas-apps/google-apps-tutorial), (remote access to) [legacy on-premises applications](/azure/active-directory/manage-apps/application-proxy), and third-party [Software as a Service providers](/azure/active-directory/saas-apps/tutorial-list).

## Related Links
[Five steps to securing your identity infrastructure](/azure/security/fundamentals/steps-secure-identity)

