---
title: Architectural considerations for identity in a multitenant solution
titleSuffix: Azure Architecture Center
description: This article describes the considerations for managing identities in a multitenant solution.
author: plagueho
ms.author: dascottr
ms.date: 05/08/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-active-directory
categories:
  - identity
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Architectural considerations for identity in a multitenant solution

Identity is an important aspect of any multitenant solution. The identity components of your application are responsible for verifying who a user is (*authentication*) and enforcing the permissions that are granted to the user within the scope of a tenant (*authorization*). Your customers might also wish to authorize external applications to access their data or integrate to your solution. A user's identity determines what information a user or service will get access to. It is important that you consider your identity requirements to isolate your application and data between tenants.

> [!CAUTION]
> Authentication and authorization services within multitenant and SaaS applications are usually provided by a 3rd party identity provider (IdP). An identity provider is usually an integral part of an Identity as a Service (IDaaS) platform. Building your own IdP is complex, expensive and difficult to build securely. Building your own identity provider is [an antipattern](../approaches/identity.md#building-or-running-your-own-identity-system). We don't recommend it.

Before defining a multitenant identity strategy, you should first consider the high-level identity requirements of your service, including:

- Will user or [workload identities](#workload-identities) be used to access a single application or multiple applications within a product family? For example, a retail product family might have both a point-of-sale application and an inventory management application that share the same identity solution.
- Are you planning on implementing modern authentication and authorization such as OAuth2 and OpenID Connect?
- Does your solution just provide authentication to your UI based applications or will you also provide API access to your tenants and 3rd parties?
- Will tenants need to federate to their own IdP, and will multiple different identity providers need to be supported for each tenant? For example, you might have tenants with Azure AD, Auth0 and Active Directory Federation Services (ADFS) who each wish to federate with your solution. You also need to understand which protocols of your tenants' IdPs you'll support, because this influences the requirements for which solution you can use as your own IdP.
- Are there specific compliance requirements that they need to meet, such as [GDPR](/compliance/regulatory/gdpr)?
- Do your tenants require their identity information to be located within a specific geographic region?
- Do users of your solution require access to data from one tenant or multiple tenants within your application? Do they need to the ability to quickly switch between tenants or view consolidated information from multiple tenants? For example, a user who has signed into the Azure portal can easily switch between different Azure Active Directories and subscriptions that they have access to.

When you've established your high-level requirements, you can start to plan more specific details and requirements, such as user directory sources and sign-up/sign-in flows.

## Identity directory

For a multitenant solution to authenticate and authorize a user or service, it needs a place to store identity information. A *directory* can include authoritative records for each identity, or it might contain references to external identities stored in another identity provider's directory.

When you design an identity system for your multitenant solution, you need to consider which of the following types of IdP that your tenants and customers might need:

- **Local identity provider.** A local identity provider allows a user to sign themselves up to the service by providing a username, email address or an identifier such as a rewards card number, and a credential like a password, which is stored within the IdP.
- **Social identity provider.** A social identity provider allows users to use an identity they have on a social network or other public identity provider, such as Facebook, Google, or a personal Microsoft account.
- **Use the tenant's Azure AD or Microsoft 365 directory.** A tenant might already have their own Azure AD or Microsoft 365 directory, and want your solution to use their directory as the IdP for accessing your solution. This is possible when your solution is built as [a multitenant Azure AD application](/azure/active-directory/develop/howto-convert-app-to-be-multi-tenant).
- **Federation with a tenant's identity provider.** A tenant might have their own IdP other than Azure AD or Microsoft 365, and want your solution to federate with it. Federation enables single sign-on (SSO) experiences, and enables tenants to manage the lifecycle and security policies of their users independently of your solution.

You should consider if your tenants need to support multiple identity providers. For example, you might need to support local identities, social identities and federated identities within a single tenant. A common use case for this is in business-to-business applications that are federated, but also need to support granting access to private contractors or guest users who don't have an account in the federated tenant.

### Store authentication and tenant authorization information

In a multitenant solution, you need to consider where to store several types of identity information, including:

- Details about user and service accounts, including their names and other information required by your tenants.
- Information required to securely authenticate your users, including information required to provide multi-factor authentication (MFA).
- Tenant-specific information, such as tenant roles and permissions. This information is used for authorization.

> [!CAUTION]
> We don't recommend building authentication processes yourself. An identity provider that is part of an Identity as a Service (IDaaS) platform will provide these authentication services to your application as well as other important features such as MFA and conditional access. [Building your own identity provider is an antipattern](../approaches/identity.md#building-or-running-your-own-identity-system). We don't recommend it.

Options for storing identity information include the following:

- Store all identity and authorization information in the IdP directory, and share it between multiple tenants.
- Store the user credentials in the IdP directory, and store the authorization information in the application tier alongside the tenant information.

## Account access to multiple tenants

It's common for multitenant solutions to allow a single user or workload identity to access the application and data of multiple tenants. Consider whether this is required for your solution. If it is, then you also need to consider the following decisions:

- Does an identity record need to be used by multiple tenants (service-wide identity) or just a single tenant (per-tenant local identity)?
- How does your solution identify and grant permissions to a user who has access to multiple tenants? For example, could a user be an administrator in a training tenant, and have read-only access to a production tenant? Or, could you have separate tenants for different departments in an organization, but need to maintain consistent user identities across all of the tenants?
- How does a user switch between tenants?
- If you use workload identities, how does a workload identity specify the tenant it needs to access?
- Is there tenant specific information stored in the user identity record that could leak information between tenants? For example, suppose a user signed up with a social identity and was then granted access to two tenants. Tenant A enriched the user's identity with additional information. Should tenant B have access to the enriched information?
- How do users get mapped to a tenant? For example, during the sign-up process, you might use the domain name of the user's sign-up email address as a way to identify the tenant that they belong to. Or, you might use another attribute of the user's identity record to map the user to a tenant. You should then store the mapping based on the underlying immutable unique identifiers for both the tenant and the user.

## User sign-up process for local identities or social identities

Some tenants might need to allow users to sign themselves up for an identity in your solution. This might be required if you don't require federation with a tenant's identity provider. If a self-sign up process is needed, then you should consider the following questions:

- Which identity sources are users allowed to sign up from? For example, can a user create a local identity as well as use a social identity provider?
- If only local identities are allowed, will only specific email domains be allowed? For example, can a tenant specify that only users who have an @contoso.com email address are permitted to sign-up?
- What is the user principal name (UPN) that should be used to uniquely identify each local identity during the sign-in process? For example, email address, username, phone number and rewards card number are all common choices for UPNs. However, UPNs can change over time, so when you refer to the identity in your application's authorization rules or audit logs, it's a good practice to use the underlying immutable unique identifier of the identity, such as the object ID (OID) in Azure AD.
- Will a user be required to verify their UPN? For example, if the user's email address or phone number is used as a UPN, how will these be verified?
- Do tenant administrators need to approve sign-ups?
- Do tenants require a tenant specific sign-up experience or URL? For example, do your tenants require a branded sign-up experience when users sign up, or do they require the ability to intercept a sign-up request and perform additional validation before it proceeds?

### Tenant access for self sign-up users

When users are allowed to sign themselves up for an identity, there usually needs to be a process for them to be granted access to a tenant. This might be part of the sign-up flow, or it could be automated based on the information about the user such as their email address. It's important to plan for this process and consider the following questions:

- How will the sign-up flow determine that a user should be granted access to a specific tenant? For example, you might provide uses with a unique invitation code that they enter the first time they access a tenant, or you might require that a tenant's administrator approve the user's request to join the tenant.
- If a user should no longer have access to a tenant, will your solution automatically revoke their access? For example, when a user leaves an organization there needs to be a manual or automated process that removes their access from the tenant.
- Do you need to provide a way for tenants to audit the users who have access to their tenants and their permissions?

## Automated account lifecycle management

A common requirement for corporate or enterprise customers of a solution is a set of features that allows them to automate account onboarding and off-boarding. Open protocols such as [System for Cross-domain Identity Management (SCIM)](/azure/active-directory/fundamentals/sync-scim) provide industry standard approach to automation. This automated process usually includes not only creation and removal of identity records, but also management of tenant permissions. There are specific considerations when implementing automated account lifecycle management in a multitenant solution:

- Do your customers need to configure and manage automated lifecycle process per tenant? For example, when a user is onboarded you might need to create the identity within multiple tenants in your application, but each having a different set of permissions.
- Do you need to implement SCIM, or can you provide tenants federation instead to keep the source of truth for users under the control of the tenant instead of managing local users?

## User authentication process

When a user signs into a multitenant application, your identity system authenticates the user. You should consider the following when planning your authentication process:

- Do your tenants need to configure their own multi-factor authentication (MFA) policies? For example, if one of your tenants is in the financial services industry, they need to implement strict MFA policies, while a small online retailer might not have the same requirements.
- Do your tenants need to configure their own conditional access rules? For example, different tenants might need to block sign-in attempts from specific geographic regions.
- Do your tenants need to customize the sign-in process for each tenant? For example, do you need to show a customer's logo? Or, does information about each user need to be extracted from another system, such as a rewards number, and returned to the identity provider to add to the user profile?
- Do your users need to impersonate other users? For example, a support team member might wish to investigate an issue another user is having by impersonating their user account without having to authenticate as the user.
- Do your users need to gain access to the APIs for your solution? For example, users or 3rd party applications might need to directly call your APIs to extend your solution without a user interface to provide an authentication flow.

## Workload identities

In most solutions, an identity often represents a user. Some multitenant systems also allow [*workload identities*](/azure/active-directory/develop/workload-identities-overview) to be used by *services* and *applications* to gain access to your application resources. For example, your tenants might need to access an API provided by your solution so that they can automate some of their management tasks.

Workload identities are similar to user identities, but usually require different authentication methods, such as keys or certificates. Workload identities don't use MFA. Instead, workload identities usually require additional security controls such as regular key-rolling and certificate expiration.

If your tenants expect to be able to enable workload identity access to your multitenant solution then you should consider the following questions:

- How will workload identities will be created and managed in each tenant?
- How will workload identity requests be scoped to the tenant?
- Do you need to limit the number of workload identities created by each tenant?
- Do you need to provide conditional access controls on workload identities for each tenant? For example, a tenant might want to limit a workload identity from being authenticated from outside a specific region.
- What additional security controls will you provide to tenants to ensure workload identities are kept secure? For example, automated key rolling, key expiration, certificate expiration and sign-in risk monitoring are all methods of reducing the risk a workload identity is misused.

## Federate with an identity provider for single-sign on (SSO)

Tenants who already have their own user directories might want your solution to use the identities in their directory, instead of managing another directory with distinct identities. This is called *federation*.

Federation is particularly important when some tenants would like to specify their own identity policies, or enable single sign-on (SSO) experiences.

If you are expecting tenants to federate with your solution, you should consider the following questions:

- What is the process for configuring the federation for a tenant? Can a tenant configure this themselves, or does it require manual configuration and maintenance by your team?
- Which federation protocols will you support?
- What processes are in place to ensure federation can't be misconfigured to grant access to another tenant?
- Will a single tenant's identity provider need to be federated to more than one tenant in your solution? For example, if a customer has both a training and production tenant, they might need to federate the same identity provider to both tenants.

## Authorization models

Decide on the authorization model that makes the most sense for your solution. Two common authorization approaches are:

- **Role-based authorization.** Users are assigned to roles. Some features of the application are restricted to specific roles. For example, a user in the administrator role can perform any action, while a user in a lower role might have a subset of permissions throughout the system.
- **Resource-based authorization.** Your solution provides a set of distinct resources, each of which has its own set of permissions. A specific user might be an administrator of one resource and have no access to another resource.

These models are distinct, and the approach you select affects your implementation as well as the complexity of the authorization policies you can implement.

For more information, see [Role-based and resource-based authorization](../../../multitenant-identity/authorize.md).

### Entitlements and licensing

In some solutions, you might use [per-user licensing](pricing-models.md#per-user-pricing) as part of your commercial pricing model, and provide different tiers of user licenses with different capabilities. For example, users with one license might be permitted to use a subset of the features of the application. The capabilities that a specific user is allowed to access based on their license is sometimes called an *entitlement*.

Although tracking and enforcing entitlements is similar to authorization, it's ordinarily handled by the application code or by a dedicated entitlements system rather than managed by the identity system.

## Identity scale and authentication volume

As multitenant solutions grow, the number of users and sign-ins requests that need to be processed by the solution will increase. You should consider the following questions:

- Will the user directory scale to the number of users required?
- Will the authentication process handle the expected number of sign-ins and sign-ups?
- Will there be spikes that the authentication system can't handle? For example, at 9am PST, everyone in the western United States region might start work and sign in to your solution, causing a spike in sign-in requests. These situations are sometimes called *login storms*.
- Can high load in other parts of your solution impact the performance of the authentication process? For example, if your authentication process requires calling into an application tier API, will high numbers of authentication requests cause problems for the rest of your solution?
- What will happen if your IdP becomes unavailable? Is there a backup authentication service that can take over to provide business continuity while the IdP is unavailable?

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

 - [John Downs](http://linkedin.com/in/john-downs) | Senior Customer Engineer, FastTrack for Azure
 - [Daniel Scott-Raynsford](http://linkedin.com/in/dscottraynsford) | Partner Technology Strategist
 - [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
 
Other contributors:

 - [Jelle Druyts](http://linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
 - [Sander van den Hoven](http://linkedin.com/in/azurehero) | Senior Partner Technology Strategist
 - [Nick Ward](http://linkedin.com/in/nickward13) | Senior Cloud Solution Architect
 
## Next steps

Review [Architectural approaches for identity in multitenant solutions](../approaches/identity.md).
