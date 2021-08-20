---
title: Authentication with Azure AD
description: Review the authentication considerations when you're using Azure Active Directory (Azure AD) for a workload.
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
  - azure-kubernetes-service
ms.custom:
  - article
---

# Authentication with Azure AD

Authentication is a process that grants or denies access to a system by verifying the accessor's identity. Use a managed identity service for all resources to simplify overall management (such as password policies) and minimize the risk of oversights or human errors. Azure Active Directory (Azure AD) is the one-stop-shop for identity and access management service for Azure.

## Key points

- Use Managed Identities to access resources in Azure.
- Keep the cloud and on-premises directories synchronized, except for high-privilege accounts.
- Preferably use passwordless methods or opt for modern password methods.
- Enable Azure AD conditional access based on key security attributes when authenticating all users, especially for high-privilege accounts.

## Use identity-based authentication

**How is the application authenticated when communicating with Azure platform services?**
***

Authenticate with identity services instead of cryptographic keys. On Azure, Managed Identities eliminate the need to store credentials that might be leaked inadvertently. When Managed Identity is enabled for an Azure resource, it's assigned an identity that you can use to obtain Azure AD tokens. For more information, see [Azure AD-managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources).

For example, an Azure Kubernetes Service (AKS) cluster needs to pull images from  Azure Container Registry (ACR). To access the image, the cluster needs to know the ACR credentials. The recommended way is to enable Managed Identities during cluster configuration. That configuration assigns an identity to the cluster and allows it to obtain Azure AD tokens. 

This approach is secure because Azure handles the management of the underlying credentials for you. 

- The identity is tied to the lifecycle of the resource, in the example the AKS cluster. When the resource is deleted, Azure automatically deletes the identity.
- Azure AD manages the timely rotation of secrets for you.

> [!TIP]
> Here are the resources for the preceding example:
>
> ![GitHub logo](../../_images/github.svg) [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline).
>
> The design considerations are described in [Azure Kubernetes Service (AKS) production baseline](../../reference-architectures/containers/aks/secure-baseline-aks.yml).


**What kind of authentication is required by application APIs?**
***

Don't assume that API URLs used by a workload are hidden and can't get exposed to attackers. For example, JavaScript code on a website can be viewed. A mobile application can be decompiled and inspected. Even for internal APIs used only on the backend, a requirement of  authentication can increase the difficulty of lateral movement if an attacker gets network access. Typical mechanisms include API keys, authorization tokens, IP restrictions. 

Managed Identity can help an API be more secure because it replaces the use of human-managed service principals and can request authorization tokens.

**How is user authentication handled in the application?**
***
Don't use custom implementations to manage user credentials. Instead, use Azure AD or other managed identity providers such as Microsoft account Azure B2C. Managed identity providers provide additional security features such as modern password protections, multi-factor authentication (MFA), and resets. In general, passwordless protections are preferred. Also, modern protocols like OAuth 2.0 use token-based authentication with limited timespan.

**Are authentication tokens cached securely and encrypted when sharing across web servers?**
***
Application code should first try to get OAuth access tokens silently from a cache before attempting to acquire a token from the identity provider, to optimize performance and maximize availability. Tokens should be stored securely and handled as any other credentials. When there's a need to share tokens across application servers (instead of each server acquiring and caching their own) encryption should be used. 

For information, see [Acquire and cache tokens](/azure/active-directory/develop/msal-acquire-cache-tokens).

## Choose a system with cross-platform support

Use a single identity provider for authentication on all platforms (operating systems, cloud providers, and third-party services.

Azure AD can be used to authenticate Windows, Linux, Azure, Office 365, other cloud providers, and third-party services as service providers. 

For example, improve the security of Linux virtual machines (VMs) in Azure with Azure AD integration. For details, see [Log in to a Linux virtual machine in Azure using Azure Active Directory authentication](/azure/virtual-machines/linux/login-using-aad).

## Centralize all identity systems

Keep your cloud identity synchronized with the existing identity systems to ensure consistency and reduce human errors. 

Consider using [Azure AD Connect](/azure/active-directory/connect/active-directory-aadconnect) for synchronizing Azure AD with your existing on-premises directory. For migration projects, have a requirement to complete this task before an Azure migration and development projects begin.

> [!IMPORTANT]
> Don't synchronize high-privilege accounts to an on-premises directory. If an attacker gets full control of on-premises assets, they can compromise a cloud account.  This strategy will limit the scope of an incident. For more information, see [Critical impact account dependencies](./critical-impact-accounts.md#critical-impact-admin-dependencies--accountworkstation).
>
>
> Synchronization is blocked by default in the default Azure AD Connect configuration. Make sure that you haven't customized this configuration. For information about filtering in Azure AD, see [Azure AD Connect sync: Configure filtering](/azure/active-directory/hybrid/how-to-connect-sync-configure-filtering).

For more information, see [hybrid identity providers](/azure/active-directory/hybrid/whatis-hybrid-identity).

> [!TIP]
> Here are the resources for the preceding example::
>
> The design considerations are described in [Integrate on-premises Active Directory domains with Azure AD](../../reference-architectures/identity/azure-ad.yml).

## Use passwordless authentication

Remove the use of passwords, when possible. Also, require the same set of credentials to sign in and access the resources on-premises or in the cloud. This requirement is crucial for accounts that require passwords, such as admin accounts. 

Here are some methods of authentication. The list is ordered by highest cost/difficulty to attack (strongest/preferred options) to lowest cost/difficult to attack: 
- Passwordless authentication. Some examples of this method include [Windows Hello](/windows/security/identity-protection/hello-for-business/hello-identity-verification) or [Authenticator App](/azure/active-directory/authentication/howto-authentication-phone-sign-in). 
- MFA. Although this method is more effective than passwords, we recommend that you avoid relying on SMS text message-based MFA. For more information, see [Enable per-user Azure Active Directory MFA to secure sign-in events](/azure/active-directory/authentication/howto-mfa-userstates).
- Managed Identities. See [Use identity-based authentication](#use-identity-based-authentication).

Those methods apply to all users, but should be applied first and strongest to accounts with administrative privileges. 

An implementation of this strategy is enabling single sign-on (SSO) to devices, apps, and services. By signing in once using a single user account, you can grant access to all the applications and resources as per the business needs. Users don't have to manage multiple sets of usernames and passwords and you can provision or de-provision application access automatically. For more information, see [Single sign-on](https://azure.microsoft.com/documentation/videos/overview-of-single-sign-on/). 

## Use modern password protection
Require modern protections through methods that reduce the use of passwords. Modern authentication protocols support strong controls such as MFA and should be used instead of legacy authentication methods. Use of legacy methods increases risk of credential exposure.

Modern authentication is a method of identity management that offers more secure user authentication and authorization. It's available for Office 365 hybrid deployments of Skype for Business server on-premises and Exchange server on-premises, and split-domain Skype for Business hybrids.

Modern authentication is an umbrella term for a combination of authentication and authorization methods between a client (for example, your laptop or your phone) and a server, as well as some security measures that rely on access policies that you may already be familiar with. It includes:

- *Authentication methods*: MFA; smart card authentication; client certificate-based authentication
- *Authorization methods*: Microsoft's implementation of Open Authorization (OAuth)
- *Conditional access policies*: Mobile Application Management (MAM) and Azure Active Directory (Azure AD) Conditional Access

Review workloads that do not leverage modern authentication protocols and convert where possible. In addition, standardize using modern authentication protocols for all future workloads.

For Azure, enable protections in Azure AD:

1.    Configure Azure AD Connect to synchronize password hashes. For information, see [Implement password hash synchronization with Azure AD Connect sync](/azure/active-directory/connect/active-directory-aadconnectsync-implement-password-hash-synchronization).

2.    Choose whether to automatically or manually remediate issues found in a report. For more information, see [Monitor identity risks](monitor-identity-network.md). 
    
For more information about supporting modern passwords in Azure AD, see the following articles:

- [What is Identity Protection?](/azure/active-directory/identity-protection/overview)
- [Enforce on-premises Azure AD Password Protection for Active Directory Domain Services](/azure/active-directory/authentication/concept-password-ban-bad-on-premises)
- [Users at risk security report](/azure/active-directory/reports-monitoring/concept-user-at-risk) 
- [Risky sign-ins security report](/azure/active-directory/reports-monitoring/concept-risky-sign-ins)

For more information about supporting modern passwords in Office 365, see the following article:

[What is modern authentication?](/microsoft-365/enterprise/hybrid-modern-auth-overview?view=o365-worldwide#what-is-modern-authentication)

## Enable conditional access

Modern cloud-based applications are typically accessible over the internet, making network location-based access inflexible and single-factor passwords a liability. Conditional access describes your authentication policy for an access decision. For example, if a user is connecting from an InTune managed corporate PC, they might not be challenged for MFA every time, but if the user suddenly connects from a different device in a different geography, MFA is required.

Grant access requests based on the requestors' trust level and the target resources' sensitivity.

**Are there any conditional access requirements for the application?**
***

Workloads can be exposed over public internet and location-based network controls are not applicable. To enable conditional access, understand what restrictions are required for the use case. For example, MFA is a necessity for remote access; IP-based filtering can be used to enable adhoc debugging (VPNs are preferred).

Configure Azure AD Conditional Access by setting up Access policy for Azure management based on your operational needs. For information, see [Manage access to Azure management with Conditional Access](/azure/role-based-access-control/conditional-access-azure-management).

Conditional access can be an effective in phasing out legacy authentication and associated protocols. The policies must be enforced for all admins and other critical impact accounts. Start by using metrics and logs to determine users who still authenticate with old clients. Next, disable any down-level protocols that aren't used, and set up conditional access for all users who aren't using legacy protocols. Finally, give notice and guidance to users about upgrading before blocking legacy authentication completely. For more information, see [Azure AD Conditional Access support for blocking legacy auth](https://techcommunity.microsoft.com/t5/Azure-Active-Directory-Identity/Azure-AD-Conditional-Access-support-for-blocking-legacy-auth-is/ba-p/245417).

### Suggested actions

Implement conditional access policies for this workload.

Learn more about [Azure AD Conditional Access](/azure/active-directory/conditional-access/).

## Next

Grant or deny access to a system by verifying the accessor's identity.

> [!div class="nextstepaction"]
> [Authorization](design-identity-authorization.md)


## Related links

> Back to the main article: [Azure identity and access management considerations](design-identity.md)
