---
title: Architectural considerations for identity
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

# Architectural considerations for identity

Identity is an important aspect of any multitenant solution. The identity components of your application are responsible for verifying who a user is (*authentication*) and enforcing the permissions that are granted to the user within the scope of a tenant (*authorization*). You might also need to provide authentication and authorization to external services as well. A user's identity determines what information a user or service will get access to it, so it's important that you consider your identity requirements so that you can isolate your application and data between tenants.

Before defining a multitenant identity strategy, you should first consider the high-level identity requirements of your service, including:

- Will user or service identities be used to access a single application, or by multiple applications or services within a suite?
- Are you planning on implementing modern authentication and authorization such as OAuth2 and OpenID Connect?
- Do your customers have specific compliance requirements that they need to meet, such as [GDPR](/compliance/regulatory/gdpr)?
- Do your customers require their identity information to be located within a specific geographic region?
- Do users of your solution require access to one tenant or multiple? Do they need to the ability to quickly switch between tenants, or view consolidated information from multiple tenants?

When you've established your high-level requirements, you can start to plan more specific details and requirements, such as user directory sources and sign-up/sign-in flows.

## Identity type

In a multitenant solution an identity often represents a user. However, many solutions also use identities internally and externally to allow authentication and authorization of services and applications. These are usually referred to as *service identities*.

Service identities are similar to user identities, but usually require different authentication methods, such as key or certificate-based and don't use multi-factor authentication (MFA). Instead, service identities usually require additional security controls such as regular key-rolling and certificate expiration.

## Identity directory

For a multitenant solution to authenticate and authorize a user or service, it needs a place to store identity information. A *directory* can include authoritative records for each identity, or it might contain references to external identities stored in another identity provider's directory.

When you design on an identity system for your multitenant solution, you need to consider how which of the following identity sources your tenants and customers require:

- **Local identity provider.** A local identity provider allows a user to sign themselves up to the service by providing a username, e-mail address or an identifier such as a rewards card number, and a credential like a password.
- **Social identity provider.** A social identity provider allows users to use an identity they have on a social network or other public identity provider, such as Facebook, Google, or a personal Microsoft account.
- **Federation with a customer's identity provider.** A tenant or customer might have their own identity directory and want your solution to federate with it. Federation enables single sign-on (SSO) experiences, and enables tenants to manage the lifecycle of their users independently of your solution.

Consider whether your tenants might require the use of multiple identity sources within a single tenant. For example, some customers might need to be able use both local identities and social identities in the same tenant.

### Sharing identities between tenants

In a multitenant solution, you need to consider where to store several types of identity information, including:

- Details about user and service accounts, including their names and credentials. This information is used for authentication of your users.
- Tenant-specific information, such as tenant roles and permissions. This information is used for authorization.

You should consider how your identity information in your multitenant solution will be stored.  Your options might include:

- Store all identity and authorization information in the IdP directory, and share it between multiple tenants.
- Store the user credentials in the IdP directory, and store the authorization information in the application tier alongside the tenant information.

## Account access to multiple tenants

It's common for multitenant solutions to allow a single user or service identity to access to the data of multiple tenants. Consider whether this is required for your solution. If it is, then you also need to consider the following decisions:

- Should an identity record be shared across multiple tenants (service-wide identity) or stored and managed within the context of a single tenant (per-tenant local identity)?
- How does your solution identify and grant permissions to a user who has access to multiple tenants? For example, could user be an administrator in a training tenant, and only have read-only access to a production tenant.
- How does a user switch between tenants?
- If you use service identities, how does a service identity specify the tenant it needs to access?
- Is there tenant specific information stored in the user identity record that could leak information between tenants? For example, suppose a user signed up with a social identity and was then granted access to two tenants. Tenant A enriched the user's identity with additional information. Should tenant B have access to the enriched information?

## User sign-up process for local identities or social identities

Consider whether your multitenant solution should allow users to sign themselves up for an identity in your solution. This might be required if you don't require tenant federation with a customer's identity source. If a self-sign up process is needed, then you should consider the following questions:

- Which identity sources are users allowed to sign up from? For example, can a user create a local identity as well as use a social identity provider?
- If only local identities are allowed, will only specific email domains be allowed? For example, can a tenant specify that only users who have an @contoso.com email address are permitted to sign-up?
- Is user verification required? For example, will an email or phone verification be used?
- What is the unique principal name (UPN) that should be used to uniquely identify each local identity? For example, email address, username, phone number and rewards card number are all common choices for unique principal names.
- Do tenant administrators need to approve sign-ups?
- Do customers require a tenant specific sign-up experience or URL? For example, do your customers require a branded sign-up experience when users sign up for their tenant, or do they require the ability to intercept a sign-up request and perform additional validation before it proceeds?

### Tenant access for self sign-up users

When users are allowed to sign themselves up for an identity, there usually needs to be a process for them to be granted access to a tenant. This might be part of the sign-up flow, or it could be automated based on the information about the user such as their email address. It's important to plan for this process and consider the following questions:

- How will the sign-up flow determine that a user should be granted access to a specific tenant?
- If a user should no longer have access to a tenant, will your solution automatically revoke their access? For example, when a user leaves an organization there needs to be a manual or automated process that removes their access from the tenant.
- Do you need to provide a way for tenants to audit the users who have access to their tenants, and their permissions?

## Automated account lifecycle management

A common requirement for corporate or enterprise customers of a solution to require features that allow them to automate account on-boarding and off-boarding. Open protocols such as System for Cross-domain Identity Management (SCIM) provide industry standard approach to automation. This automated process usually includes not only creation and removal of identity records, but also management of tenant permissions. There are specific considerations when implementing automated account lifecycle management in a multitenant solution:

- Do your customers need to configure and manage automated lifecycle process per tenant? For example, when a user is on-boarded you might need to create the identity within multiple tenants in your application, but each having a different set of permissions.
- Do you need to implement SCIM, or can you provide tenants federation instead to keep the source of truth for users under the control of the tenant instead of managing local users?

## User authentication process

When a user signs into a multitenant application, your identity system authenticates the user. You should consider the following questions when planning your authentication process:

- Do you need to enable tenants to configure specific multi-factor authentication (MFA) policies? For example, if one of your tenants is in the financial services industry, they need to implement strict MFA policies, while a small online retailer might not have the same requirements.
- Do you need to enable tenants to configure specific conditional access rules? For example, different tenants may need to block sign-in attempts from specific geographic regions.
- Do you need to customize the sign-in process for each tenant? For example, do you need to show a customer's logo? Or, does information about each user need to be extracted from another customer system, such as a rewards number, and returned to the identity provider to add to the user profile.
- Do your users need to impersonate other users? For example, a support team member may wish to investigate an issue another user is having by impersonating their user account without having to authenticate as the user.

## Service authentication process

Many multitenant systems also allow *service identities* to be used by *services* and *applications* to gain access to your application resources. For example, your customers might need to access an API provided by your solution so that they can automate some of their management tasks.

If your customers expect to be able to enable service identity access to your multitenant solution then you should consider the following questions:

- How will service identities will be created and managed in each tenant?
- How will service identity requests be scoped to the tenant?
- Do you need to limit the number of service identities created by each tenant?
- Do you need to provide conditional access controls on service identities for each tenant? For example, a tenant might want to limit a service identity from being authenticated from outside a specific region.
- What additional security controls will you provide to tenants to ensure service identities are kept secure? For example, automated key rolling, key expiration, certificate expiration and sign-in risk monitoring are all methods of reducing the risk a service identity is misused.

## Federating with an identity provider for single-sign on (SSO)

Customers who already have their own user directories may want your solution to use the identities in their directory, instead of managing another directory with distinct identities. This is called *federation*.

Federation is particularly important when some customers would like to specify their own identity policies, or enable single sign-on (SSO) experiences.

If you are expecting customers to federate with your solution, you should consider the following questions:

- What is the process for configuring the federation for a tenant? Can customers configure this themselves, or does it require manual configuration and maintenance by your staff?
- What processes are in place to ensure federation can't be misconfigured to grant access to another tenant?
- Will a customer's identity provider need to be federated to more than one tenant in your solution? For example, if a customer has both a training and production tenant, they might need to federate the same identity provider to both tenants.

## Identity scale and authentication volume

As multitenant solutions grow, the number of users and sign-ins requests that need to be processed by the solution will increase. You should consider the following questions:

- Will the user directory scale to the number of users required?
- Will the authentication process handle the expected number of sign-ins and sign-ups?
- Will there be spikes that the authentication system can't handle? For example, at 9am PST, everyone in the western United States region might start work and sign in to your solution, causing a spike in sign-in requests. These situations are sometimes called *login storms*.
- Can high load in other parts of your solution impact the performance of the authentication process? For example, if your authentication process requires calling into an application tier API, will high numbers of authentication requests cause problems for the rest of your solution?

## Next steps

Links to other relevant pages within our section.
