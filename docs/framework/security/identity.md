---
title: Identity and Access Management in Azure | Microsoft Docs
description: Manage access based on identity authentication and authorization 
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
---

# Identity and access management

In cloud-focused architecture, identity provides the basis of a large percentage
of security assurances. While legacy IT infrastructure often heavily relied on
firewalls and network security solutions at the internet egress points for
protection against outside threats, these controls are less effective in cloud
architectures with shared services being accessed across cloud provider networks
or the internet.

It is challenging or impossible to write concise firewall rules when you don’t
control the networks where these services are hosted, different cloud resources
spin up and down dynamically, cloud customers may share common infrastructure,
and employees and users expect to be able to access data and services from
anywhere. To enable all these capabilities, you must manage access based on
identity authentication and authorization controls in the cloud services to
protect data and resources and to decide which requests should be permitted.

Additionally, using a cloud-based identity solution like Azure AD offers
additional security features that legacy identity services cannot because they
can apply threat intelligence from their visibility into a large volume of
access requests and threats across many customers.

## Single enterprise directory

Establish a single enterprise directory for managing identities of full-time
employees and enterprise resources

A single authoritative source for identities increases clarity and consistency
for all roles in IT and Security. This reduces security risk from human errors
and automation failures resulting from complexity. By having a single
authoritative source, teams that need to make changes to the directory can do so
in one place and have confidence that their change will take effect everywhere.

For Azure, designate a single Azure Active Directory (Azure AD) instance
directory as the authoritative source for corporate/organizational accounts.

## Synchronize identity systems

Synchronize your cloud identity with your existing identity systems

Consistency of identities across cloud and on-premises will reduce human errors
and resulting security risk. Teams managing resources in both environment need
a consistent authoritative source to achieve security assurances.

For Azure, synchronize Azure AD with your existing authoritative on premises
Active Directory using [Azure AD connect](https://docs.microsoft.com/azure/active-directory/connect/active-directory-aadconnect).
This is also required for an Office 365 migration, so it is often already done
before Azure migration and development projects begin. Note that administrator
accounts should be excepted from synchronization as described in [Don’t synchronize on-premises admin accounts to cloud identity providers](/azure/architecture/security/identity#dont-synchronize-on-premises-admin-accounts-to-cloud-identity-providers) and 
[Critical impact account dependencies](/azure/architecture/security/critical-impact-accounts#critical-impact-admin-dependencies--accountworkstation).

## Use cloud provider identity source for third parties

Use cloud identity services designed to host non-employee accounts rather than
including vendors, partners, and customers in a corporate directory.

This reduces risk by granting the appropriate level of access to external
entities instead of the full default permissions given to full-time employees.
This least privilege approach and clear clearly differentiation of external
accounts from company staff makes it easier to prevent and detect attacks coming
in from these vectors. Additionally, management of these identities is done by
the external also increases productivity by parties, reducing ingeffort required
by company HR and IT teams.

For example, these capabilities natively integrate into the same Azure AD
identity and permission model used by Azure and Office 365

-   [Azure AD](https://docs.microsoft.com/azure/active-directory/) –
    Employees and Enterprise Resources

-   [Azure AD B2B](https://docs.microsoft.com/azure/active-directory/b2b/)
    – Partners

-   [Azure AD B2C](https://docs.microsoft.com/azure/active-directory-b2c/)
    – Customers/citizens

## Passwordless Or multi-factor authentication for admins

All users should be converted to use passwordless authentication or multi-factor
authentication (MFA) over time. The details of this recommendation are in the
administration section [Passwordless Or multi-factor authentication for admins](/azure/architecture/security/critical-impact-accounts#passwordless-or-multi-factor-authentication-for-admins) FOR
ADMINS. The same recommendation applies to all users, but should be applied first
and strongest to accounts with administrative privileges.

You can also reduce use of passwords by applications using [Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) to grant access to resources in Azure

## Block legacy authentication

Disable insecure legacy protocols for internet-facing services.

Legacy authentication methods are among the top attack vectors for cloud-hosted
services. Created before multifactor-authentication existed, legacy protocols
don’t support additional factors beyond passwords and are therefore prime
targets for password spraying, dictionary, or brute force attacks. As an example
nearly 100% of all password spray attacks against Office 365 customers use
legacy protocols. Additionally, these older protocols frequently lack other
attack countermeasures, such as account lockouts or back-off timers. Services
running on Microsoft’s cloud that block legacy protocols have observed a 66%
reduction in successful account compromises.

For Azure and other Azure AD-based accounts, configure Conditional Access to
block legacy protocols.

Disabling legacy authentication can be difficult, as some users may not want to
move to new client software that supports modern authentication methods.
However, moving away from legacy authentication can be done gradually. Start by
using metrics and logging from your authentication provider to determine the how
many users still authenticate with old clients. Next, disable any down-level
protocols that aren’t in use, and set up conditional access for all users who
aren’t using legacy protocols. Finally, give plenty of notice and guidance to
users on how to upgrade before blocking legacy authentication for all users on
all services at a protocol level.

## Don’t synchronize on-premises admin accounts to cloud identity providers

Don’t synchronize accounts with the highest privilege access to on premises
resources as you synchronize your enterprise identity systems with cloud
directories.

This mitigates the risk of an adversary pivoting to full control of on-premises
assets following a successful compromise of a cloud account. This helps contain
the scope of an incident from growing significantly.

For Azure, don’t synchronize accounts to Azure AD that have high privileges in
your existing Active Directory. This is blocked by default in the default Azure
AD Connect configuration, so you only need to confirm you haven’t customized
this configuration.

This is related to the [critical impact account dependencies](/azure/architecture/security/critical-impact-accounts#critical-impact-admin-dependencies--accountworkstation) guidance in
the administration section that mitigates the inverse risk of pivoting from on-premises to cloud assets.

## Use modern password protection offerings

Provide modern and effective protections for accounts that cannot go
passwordless ([Passwordless Or multi-factor authentication for admins](/azure/architecture/security/critical-impact-accounts#passwordless-or-multi-factor-authentication-for-admins)).

Legacy identity providers mostly checked to make sure passwords had a good mix
of character types and minimum length, but we have learned that these controls
in practice led to passwords with less entropy that could be cracked easier:

-   **Microsoft** -
    <https://www.microsoft.com/research/publication/password-guidance/>

-   **NIST** - https://pages.nist.gov/800-63-3/sp800-63b.html

Identity solutions today need to be able to respond to types of attacks that
didn't even exist one or two decades ago such as password sprays, breach replays
(also called *“credential stuffing*”) that test username/password pairs from
other sites’ breaches, and phishing man-in-the-middle attacks. Cloud identity
providers are uniquely positioned to offer protection against these attacks.
Since they handle such large volumes of signons, they can apply better anomaly
detection and use a variety of data sources to both proactively notify companies
if their users’ passwords have been found in other breaches, as well as validate
that any given sign in appears legitimate and is not coming from an unexpected
or known-malicious host.

Additionally, synchronizing passwords to the cloud to support these checks also
add resiliency during some attacks. Customers affected by (Not)Petya attacks
were able to continue business operations when password hashes were synced to
Azure AD (vs. near zero communications and IT services for customers affected
organizations that had not synchronized passwords).

For Azure, enable modern protections in Azure AD by

1.  [Configure Azure AD Connect to synchronize password hashes](https://docs.microsoft.com/azure/active-directory/connect/active-directory-aadconnectsync-implement-password-hash-synchronization)

1.  Choose whether to automatically remediate these issues or manually remediate
    them based on a report:

    1.  **Automatic Enforcement -** Automatically remediate high risk passwords
        with Conditional Access [leveraging Azure AD Identity Protection risk
        assessments](https://docs.microsoft.com/azure/active-directory/identity-protection/overview)

    2.  **Report & Manually Remediate -** View reports and manually remediate
        accounts

        -   **Azure AD reporting** - Risk events are part of Azure AD's security
            reports. For more information, see the [users at risk security report](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-user-at-risk)
            and the [risky sign-ins security report](https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-risky-sign-ins).

        -   **Azure AD Identity Protection** - Risk events are also part of the
            reporting capabilities of [Azure Active Directory Identity Protection](https://docs.microsoft.com/azure/active-directory/active-directory-identityprotection).

Use the Identity Protection risk events API to gain programmatic access to
security detections using Microsoft Graph.

## Use cross-platform credential management

Use a single identity provider for authenticating all platforms (Windows, Linux,
and others) and cloud services.

A single identity provider for all enterprise assets will simplify management
and security, minimizing the risk of oversights or human mistakes. Deploying
multiple identity solutions (or an incomplete solution) can result in
unenforceable password policies, passwords not reset after a breach,
proliferation of passwords (often stored insecurely), and former employees
retaining passwords after termination.

For example, Azure Active Directory can be used to authenticate Windows,
[Linux](https://docs.microsoft.com/azure/virtual-machines/linux/login-using-aad),
Azure, Office 365, [Amazon Web Services (AWS)](https://docs.microsoft.com/azure/active-directory/saas-apps/amazon-web-service-tutorial),
[Google Services](https://docs.microsoft.com/azure/active-directory/saas-apps/google-apps-tutorial),
(remote access to) [legacy on-premises applications](https://docs.microsoft.com/azure/active-directory/manage-apps/application-proxy),
and third-party [Software as a Service providers](https://docs.microsoft.com/azure/active-directory/saas-apps/tutorial-list).

## Enforce conditional access for users - Zero Trust

Authentication for all users should include measurement and enforcement of key
security attributes to support a Zero Trust strategy. The details of this
recommendation are in the administration section [Enforce conditional access for ADMINS (Zero Trust)](/azure/architecture/security/critical-impact-accounts#enforce-conditional-access-for-admins---zero-trust). The same recommendation applies to all users, but should be applied
first to accounts with administrative privileges.

You can also reduce use of passwords by applications using [Managed Identities](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)
to grant access to resources in Azure.

## Attack simulation for users

Regularly simulate attacks against users to educate and empower them.

People are a critical part of your defense, so ensure they have the knowledge
and skills to avoid and resist attacks will reduce your overall organizational
risk.

You can use [Office 365 Attack Simulation](https://docs.microsoft.com/office365/securitycompliance/attack-simulator)
capabilities or any number of third-party offerings.

## Implementing Identity best practices in Azure

Each of the recommendations from this section can be implemented using Azure Active Directory. See the below articles for more information about how to use these features. 

### Single Enterprise Directory 

https://docs.microsoft.com/azure/active-directory/hybrid/whatis-hybrid-identity

### Synchronize Identity Systems 

https://docs.microsoft.com/azure/active-directory/connect/active-directory-aadconnect 

### Use Cloud Provider Identity Source for Third Parties

https://docs.microsoft.com/azure/active-directory/hybrid/how-to-connect-fed-compatibility 

https://docs.microsoft.com/azure/active-directory/b2b/

https://docs.microsoft.com/azure/active-directory-b2c/

### Block Legacy Authentication 

### Don’t Synchronize On-Premises Admin Accounts to Cloud Identity Providers 

### Use Modern Password Protection Offerings 

*https://docs.microsoft.com/azure/active-directory/identity-protection/overview*

https://docs.microsoft.com/azure/active-directory/authentication/concept-password-ban-bad-on-premises

https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-user-at-risk

https://docs.microsoft.com/azure/active-directory/reports-monitoring/concept-risky-sign-ins

### Use Cross-Platform Credential Management

https://docs.microsoft.com/azure/virtual-machines/linux/login-using-aad
