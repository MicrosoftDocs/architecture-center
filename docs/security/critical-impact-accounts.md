---
title: Administration
description: Secure administrator accounts in Azure
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---



# Administration

Administration is the practice of monitoring, maintaining, and operating
Information Technology (IT) systems to meet service levels required by the
business. It’s one of the most critical security areas because performing these
tasks requires privileged access to a broad set of systems and applications.
Attackers know that gaining access to an account with administrative privileges
can get them access to most or all of the data.

As an example, Microsoft makes significant investments in protection and
training of administrators for our cloud systems and IT systems:

![A screenshot of a cell phone Description automatically generated](_images\ms-protecting-ms.png)

Microsoft’s recommended core strategy for administrative privileges include:

1.  **Reduce risk exposure–** The principle of least privilege is best
    accomplished with modern controls that provide privileges on demand. This
    reduces risk by limiting administrative privileges exposure by:

    1.  **Scope** – *Just Enough Access (JEA)* provides only the required
        privileges for the administrative operation required (as opposed to
        direct and immediate privileges to many or all systems at a time.

    2.  **Time** – *Just in Time (JIT)* approaches provide the required
        privileged.

2.  **Mitigate the remaining risks** – Use a combination of preventive and
    detective controls:

    1.  Isolate administrator accounts from the most common risks (phishing and
        general web browsing).

    2.  Simplify and optimize administrator workflow.

    3.  Increase assurance of authentication decisions.

    4.  Identify anomalies from normal baseline behavior that can be blocked or
        investigated.

The best practices in these articles describe prioritized roadmaps for
protecting privileged access.

-   Securing Privileged Access (SPA) roadmap for administrators of on-premises
    Active Directory -  
    <https://aka.ms/SPARoadmap>

-   Guidance for securing administrators of Microsoft Azure Active Directory.  
    [AKA.MS/SECURITYSTEPS](https://aka.ms/securitysteps)

#### Minimize the number of critical impact admins

Limit the number of accounts with administrative privileges.

Each administrator account represents potential attack surface that an attacker
can target. Membership of the privileged groups grows naturally over time as
employees join or leave teams. Actively limit and manage the membership of those
accounts.

Here are some considerations for reducing attack surface risk and ensuring
business continuity if an administrator is unavailable:

-   Assign at least two accounts to the privileged group for business
    continuity.

-   When two or more accounts are required, provide justification for each
    member (including the original two).

-   Regularly review membership and justification for each member.

#### Managed Accounts for Admins

Make sure that all critical impact admins are managed in an enterprise
directory.

Remove any consumer accounts (such as Microsoft accounts like \@Hotmail.com,
\@live.com, \@outlook.com, etc.) from administrative roles. Consumer accounts
don’t provide sufficient security visibility and control to ensure compliance
with your organization’s policies and regulatory requirements.

#### Separate Accounts for Admins

Make sure that all critical impact admins use a separate account for
administrative tasks and another account for email, web browsing, and other
productivity tasks.

Create a separate administrative account for all users that have a role
requiring critical privileges. Block productivity tools like Office 365 email
(remove license). If possible, block arbitrary web browsing (with proxy and/or
application controls) while allowing exceptions for required for administrative
tasks.

Phishing and web browser attacks are most common attack vectors to compromise
accounts, including administrative accounts.

#### provide just-in-time privileges instead of permanent access

Do not provide permanent access for any critical impact accounts.

Grant privileges only when required by using one of these methods:

-   **Just-in-time -** Enable Azure AD Privileged Identity Management (PIM) or a
    third-party solution that requires an approval workflow to obtain privileges
    for critical impact accounts.

-   **Break glass –** For rarely used accounts, follow an emergency access
    process to gain access. This method is preferred for privileges that have
    little need for regular operational usage such as members of global admin
    accounts.

Permanent privileges increase business risk by increasing the time an attacker
can use the account. Temporary privileges force attackers either work within the
limited times the admin is already using the account or to initiate privilege
elevation.

#### Emergency Access (‘Break Glass’ Accounts)

Have a mechanism for obtaining administrative access

for circumstances when all means are unavailable.

Follow the instructions at [Managing emergency access administrative accounts in
Azure
AD](https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/directory-emergency-access)
and ensure that security operations monitors these accounts.

#### Admin Workstation Security

Ensure critical impact admins use a workstation with elevated security
protections and monitoring

Attack vectors that use browsing and email (like phishing) are cheap and common.
Isolate critical impact admins from these risks to prevent situations where a
compromised critical account is used to materially damage your business or
mission.

Choose the level of admin workstation security based on the options available at
<https://aka.ms/securedworkstation>

-   **Highly secure productivity device (Enhanced Security or Specialized
    workstation)**  
    Start by providing critical impact admins with a higher security workstation
    that still allows for general browsing and productivity tasks. Then,
    transition to Isolated workstations for critical impact admins and the IT
    staff supporting these users and their workstations.

-   **Privileged Access Workstation (Specialized or Secured Workstation)**  
    These configurations is ideal for critical impact admins as they heavily
    restrict access to phishing, browser, and productivity application attack
    vectors. These workstations don’t allow general internet browsing, only
    allow browser access to Azure portal and other administrative sites.

#### Critical Impact Admin dependencies – Account/Workstation

Choose the on-premises security dependencies for critical impact accounts and
their workstations with caution.

-   **User Accounts** – Choose where to host the critical impact accounts:

    -   *Native Azure AD Accounts -* Create Native Azure AD Accounts that are
        not synchronized with on-premises Active Directory.

    -   *Synchronize from On Premises Active Directory (Not Recommended see REF
        DON’T SYNCHRONIZE ON-PREMISES ADMIN ACCOUNTS TO CLOUD IDENTITY
        PROVIDERS)-* Leverage existing accounts hosted in the on premises active
        directory.

-   **Workstations** – Choose how to manage and secure the workstations used by
    critical admin accounts:

    -   *Native cloud management and security (Recommended) -* Join workstations
        to Azure AD & Manage/Patch them with Intune or other cloud services.
        Protect and monitor with Microsoft Defender ATP or another cloud service
        (not managed by on-premises accounts).

    -   *Manage with existing systems -* Join existing AD domain and leverage
        existing management/security controls.

To contain the risk from a major incident on-premises resources leaking into
cloud assets, eliminate or minimize the means of control that on-premises
resources have to critical impact accounts in the cloud. For example, attackers
who compromise the on-premises Active Directory can access and compromise
cloud-based assets that rely on those accounts like resources in Azure, Amazon
Web Services (AWS), ServiceNow, and so on. Attackers can also use workstations
joined to those on-premises domains to gain access to accounts and services
managed from them.

This is related to the “REF Don’t synchronize on-premises admin accounts” to
cloud identity providers guidance in the administration section that mitigates
the inverse risk of pivoting from cloud assets to on-premises assets.

#### Passwordless Or Multi-factor Authentication For Admins

Require all critical impact admins to use passwordless authentication or
multi-factor authentication (MFA).

Use one of these methods of authentication for Administrative accounts and all
critical accounts. The list is ordered by highest cost/difficulty to attack
(strongest/preferred options) to lowest cost/difficult to attack:

-   **Passwordless (such as Windows Hello)**  
    http://aka.ms/HelloForBusiness

-   **Passwordless (Authenticator App)**  
    https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-authentication-phone-sign-in

-   **Multifactor Authentication**  
    https://docs.microsoft.com/en-us/azure/active-directory/authentication/howto-mfa-userstates

Avoid relying on SMS Text Message-based MFA. This option is still stronger than
passwords but is weaker than other MFA options. Attack methods have evolved to
the point where passwords alone cannot reliably protect an account. This is well
documented in a Microsoft Ignite Session
<https://channel9.msdn.com/events/Ignite/Microsoft-Ignite-Orlando-2017/BRK3016>

#### Enforce Conditional Access for ADMINS (Zero Trust)

Support a Zero Trust strategy. Include measurement and enforcement of key
security attributes for authentication of accounts for all admins and other
critical impact accounts.

Configure [Conditional Access policy for Azure
management](https://docs.microsoft.com/en-us/azure/role-based-access-control/conditional-access-azure-management)
that meets your organization’s risk and operational needs.

-   Require Multifactor Authentication and/or connection from designated work
    network

-   Require Device **integrity with Microsoft Defender ATP** (Strong Assurance)

#### Avoid Granular and Custom Permissions

Avoid permissions that specifically reference individual resources or users.

Instead of assigning specific permissions for specific resources, use either of
these options:

-   Management Groups for enterprise wide permissions

-   Resource groups for permissions within subscriptions

Instead of granting permissions to specific users, assign access to groups in
Azure AD. Work with the identity team to create a group if a group doesn’t
exist. You can then add and remove group members externally to Azure and make
sur that permissions are current, while also using the group for other purposes,
such as mailing lists.

Specific permissions create unnecessary complexity because the underlying
purpose doesn’t apply to other similar resources. These permissions are
difficult to change without maintaining backward compatibility.

#### Use built-in roles

Use built-in roles for assigning permissions where possible.

Evaluate built-in roles designed to cover most common scenarios. Even through
custom roles are powerful, only use them for cases where built-in roles don’t
work. Customization leads to complexity that makes automation challenging and
fragile. These factors all negatively impact security.

#### Establish Lifecycle management for Critical impact accounts

Disable or delete administrative accounts when employees leave the organization
or move on to different roles.

See REF REGULARLY REVIEW CRITICAL ACCESS for more details

#### Simulate attack for Critical Impact Accounts

Simulate attacks against administrative users with current attack techniques to
educate them about vulnerable scenarios.

Make sure that staff who are a critical part of your defense have the knowledge
and skills to avoid and resist attacks.

To simulate realistic attack scenarios, use Office 365 Attack Simulator. Other
third-party options include.
