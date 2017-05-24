---
title: Core concepts
description: Describes core concepts for applying email policies and configurations.
author: jeffgilb
ms.service: guidance
ms.topic: article
ms.date: 05/24/2017
ms.author: pnp

pnp.series.title: Best Practices
---

# Core concepts

All the security measures in the world do not matter if users who experience unnecessary friction when trying to get their work done bypass your organizational security policies. This is where Azure AD single-sign on (SSO) comes in and attempts to minimize the burden on users. This way users can remain productive while still conforming to the access control policies of the organization. 

## Single sign-on authentication

The following diagram illustrates a typical SSO authentication flow:

![End user single sign-on experience](./images/email/typical-authentication-flow.png)

To begin authentication, the client submits credentials (such as username and password) and/or any SSO artifacts obtained in the past to Azure AD. A SSO artifact can be a session token for browser or a refresh token for rich applications. 

Azure AD verifies the credentials and/or SSO artifact and evaluates all applicable policies. Then it issues an access token for the resource provider (Exchange Online in the above diagram). Azure AD also issues an SSO artifact, as part of the response to allow the client to achieve SSO in future requests. 

The client stores the SSO artifact and submits the access token as a proof of identity to the resource provider. After Exchange Online verifies the access token and performs necessary checks, it grants the client access to the email messages.

### Single sign-on refresh tokens

SSO can be achieved in a variety of ways. For example, cookies from an identity provider can be used as the SSO artifact to store the sign-in state for a user within a browser. Then future attempts to sign in silently (without any prompts for credentials) to applications using the same identity provider are possible. 

When a user authenticates with Azure AD, a SSO session is established with the user’s browser and Azure AD. The SSO token, in the form of a cookie, represents this session. Azure AD uses two kinds of SSO session tokens: persistent and non-persistent. Persistent session tokens are stored as persistent cookies by browsers when the "Keep me signed in" checkbox is selected during sign in. Non-persistent session tokens are stored as session cookies, and are destroyed when the browser is closed. 

For robust applications capable of using modern authentication protocols, such as [OpenId Connect](http://openid.net/specs/openid-connect-core-1_0.html) and [OAuth 2.0](https://tools.ietf.org/html/rfc6749), SSO is enabled using refresh tokens as the SSO artifacts. This is in addition to earlier described SSO cookies. Refresh tokens are presented to an authorization server when an application requests a new access token. 

The refresh token contains claims as well as attributes about the kind of authentication methods used when authenticating users. For example, if a user has successfully authenticated using multiple methods (username & password and phone-based authentication), then a multi-factor authentication (MFA) claim will be present in the refresh token. Also, there may be additional claims that contain data such as MFA validity duration, etc. 

Refresh tokens allow the client to obtain a new access token, without needing to do a fresh interactive authentication. Refresh tokens have a much longer lifetime than access tokens and can be redeemed to obtain a new access and refresh token pair. The new obtained refresh tokens can then be continually used to fetch another set of access and refresh tokens. 

The client continues this SSO process until either the refresh token maximum inactive time setting expires, the refresh token max age expires, or the authentication and authorization policy requirements change. This change occurs during the time when the original refresh token was issued. Significant user attribute changes, for example a password reset, also requires a new authentication token to be generated. The client must do a fresh interactive authentication to continue further. This essentially signifies a break in the SSO process that the client has not experienced until now. 

### Conditional access

Azure AD, as an authorization server for your applications, determines whether to issue access tokens based on an evaluation of any conditional access policies applied to the resource that you’re trying to access. If policy requirements are met, then an access token and updated refresh token are issued. If the policy is not met, the user receives instructions on how to meet the policy and/or will be required to complete additional steps including multi-factor authentication (MFA).  Once MFA has been completed, the MFA claim will be added to the resulting refresh token.  

Claims in the refresh token get accumulated over time. Some of the claims have expiration timelines, after which they are no longer considered during authorization checks. This can sometimes cause unexpected results. For example, if a conditional access policy is configured so that MFA is required for authentication attempts coming from extranet locations, users might sometimes not receive the expected MFA prompt when accessing a resource from extranet. A possible reason for this is that the user could have previously performed MFA shortly before leaving the intranet. Therefore, they hav a valid MFA claim in their access token. This MFA claim satisfies the policy requirement and thus Azure AD does not prompt the user with an additional MFA request.

### Token lifetime policy

Beyond the expiration of individual claims in a token, tokens themselves have expiration times. As noted above, expired tokens are one reason why the SSO experience can be broken. You can set the lifetime of a token issued by Azure AD by using [token lifetime policies](https://docs.microsoft.com/azure/active-directory/active-directory-configurable-token-lifetimes). As can be inferred from above, defining the contours of an SSO session is harder to capture when it comes to rich apps as various factors that are seemingly disconnected can impact the lifetime of an SSO session.

>[!NOTE]
>Azure AD Global Administrators can control the validity and inactivity periods of refresh tokens, access token and claims using the settings described in the article [Configurable token lifetimes in Azure Active Directory](https://docs.microsoft.com/en-us/azure/active-directory/active-directory-configurable-token-lifetimes).
>

### Primary refresh tokens

So far, this article discusses how SSO works within the context of a single client. This is not enough to experience SSO within a single app. These days, users experience interactive workflows spanning multiple applications within the same suite of applications, such as Microsoft Office. This includes access across unrelated applications, including internally developed LOB applications. 

Traditionally domain joined Windows devices, using Windows Integrated Authentication (Kerberos), achieve a high degree of SSO experience across multiple applications and resources, including supported browsers such as Internet Explorer or Edge. There is an analogue for the Azure AD realm, in the form of a primary refresh token (PRT). 

This privileged PRT token is only available to a select set of client entities (such as platform system components) that can then allow brokered authentication access to other client applications, so that they can also offer a seamless SSO experience. 

For Office 365 users on [iOS](https://docs.microsoft.com/azure/active-directory/develop/active-directory-sso-ios) and [Android](https://docs.microsoft.com/azure/active-directory/develop/active-directory-sso-android) devices, additional work has been done to reduce the number of required authentications by leveraging authentication broker functionality. This functionality is built into the Microsoft Authenticator and Intune Company Portal apps.

>[!NOTE]
>The recommendations described in this document assume that one of the apps including an authentication broker (Microsoft Authenticator or Intune Company Portal app) has been deployed to your users' iOS or Android devices. 
>

## Multi-factor authentication (MFA) 

Multi-factor Authentication (MFA) provides a high level of trust about the subject of authentication, because the subject provided multiple proofs or pieces of evidence about the subject’s identity. The proofs can be pre-established secrets that only the subject and the authority are aware of or a physical entity that only the subject is expected to possess. MFA is typically performed in stages. First it establishes the identity using passwords, and then it require a different (less prone to malicious attacks) authentication method as the second factor, or vice versa.

Different authorities may have a slightly different interpretation of MFA, or strong authentication. For example, some authorities (or more specifically the admins configuring policy on those authorities) may choose to interpret the physical smartcard based authentication as MFA. This can happen even though strictly speaking smartcard authentication is a single stage authentication. 

The combination of requiring a physical smartcard and the requirement to enter a PIN (secret) to use smartcard can be interpreted as MFA. Yet some others may choose to be more lenient in terms of how often more onerous authentication methods are required to be performed. So it will consider normal authentications, that take place between stronger authentications, to be valid for resources that typically require strong authentication. For example, in some organizations it may be acceptable to require a user to do MFA every few hours or days depending on the sensitivity of resources they are protecting and as long as the physical location of the user attempting to access a resource, does not change.

Azure AD and ADFS use the MFA claim to indicate whether the authentication is performed with MFA. By default, Azure AD issues tokens with MFA claim when authentication is done with [Azure MFA](https://docs.microsoft.com/azure/multi-factor-authentication/multi-factor-authentication-get-started-cloud) or [Windows Hello for Business](https://technet.microsoft.com/en-us/itpro/windows/keep-secure/hello-identity-verification). In federation scenario, Azure AD honors the MFA claim from federated identity providers such as ADFS and carries over the MFA claim in the tokens. 

## Best practices

This section contains general security best practices that should be followed when implementing any of the secure email recommendations provided in later sections.

### Security and productivity trade-offs

There is a trade off to be made between security and productivity. To help understand these trade offs, the Security-Functionality-Usability/Ease of Use (SFU) security triad is widely used:

![Security and productivity trade-offs](./images/email/security-triad.png)

Based on the SFU triad model, the recommendations in this document are based on the following principles: 

* Know the audience - Be flexible by job function/security bar
* Apply security policy just in time and ensure it is meaningful

### Administrators versus users

We recommend creating security groups that contain all the users who have administrative accounts or are eligible to receive an administrative account/privileges on a temporary basis. These security groups should then be used to define conditional access policies specific to Azure AD and Office 365 administrators.  

Policy recommendations below consider the privileges associated with an account. [Office 365 administrator](https://support.office.com/en-us/article/About-Office-365-admin-roles-da585eea-f576-4f55-a1e0-87090b6aaa9d) roles have substantially more privileges relative to Exchange Online and Office 365. Thus, our policy recommendations for these accounts are more stringent than for regular user accounts. All the policies below that refer to Administrators are indicating that this is the recommended policy for Office 365 administrative accounts.

### Reduce the number of accounts with persistent admin access

Use Azure AD Privileged Identity Management to reduce the number of persistent administrative accounts. In addition, we recommend that Office 365 administrators have a separate user account for regular non-administrative use and only leverage their administrative account when necessary to complete a task associated with their job function.

## Next Steps
[Recommended policies](email-recommended-policies.md)
