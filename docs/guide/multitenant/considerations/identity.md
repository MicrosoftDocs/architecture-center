---
title: Architectural Considerations for Identity in a Multitenant Solution
description: Learn multitenant identity architecture with authentication, authorization, SSO, federation, and tenant isolation strategies for secure solutions.
author: plagueho
ms.author: dascottr
ms.date: 05/30/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural considerations for identity in a multitenant solution

Identity is an important aspect of any multitenant solution. The identity components of your application are responsible for the following tasks:

- Verifying a user's identity, known as *authentication*.

- Enforcing a user's permissions within the scope of a tenant, known as *authorization*.

Your customers might also wish to authorize external applications to access their data or to integrate to your solution. A user's identity determines what information a user or service can access. It's important that you consider your identity requirements to isolate your application and data between tenants.

> [!CAUTION]
> Authentication and authorization services within multitenant and software as a service applications are typically provided by a non-Microsoft identity provider (IdP). An IdP is usually an integral part of an identity as a service platform.
>
> Building your own IdP is complex, expensive, and challenging to secure. It's considered an [antipattern](../approaches/identity.md#building-or-running-your-own-identity-system), and we don't recommend it.

Before you identify a multitenant identity strategy, first consider the following high-level identity requirements for your service:

- Determine whether users or [workload identities](#workload-identities) will access a single application or multiple applications within a product family. Some product families might include distinct applications that share the same identity infrastructure, such as point-of-sale systems and inventory management platforms.

- Consider whether your solution will implement modern authentication and authorization standards, such as OAuth2 and OpenID Connect.  

- Evaluate whether authentication is limited to UI-based applications or if API access will also be provided to tenants and non-Microsoft systems.

- Identify whether tenants will need to federate with their own IdPs. If so, assess whether multiple IdPs must be supported for each tenant. Protocol support affects your solution design, especially when supporting providers such as Microsoft Entra ID, Auth0, and Active Directory Federation Services.  

- Review any applicable compliance requirements, such as GDPR, that might shape your identity strategy.  

- Determine whether tenants require identity data to be stored in specific geographic regions in order to meet legal or operational needs.  

- Assess whether users need access to data from one or multiple tenants within the application. You might also need to support seamless tenant switching or provide consolidated views across tenants for certain users.

## Identity directory

For a multitenant solution to authenticate and authorize a user or service, it needs a place to store identity information. A *directory* can include authoritative records for each identity. Or it might contain references to external identities that are stored in the directory of another IDP.

When you design an identity system for your multitenant solution, you need to consider which of the following types of IdP that your tenants and customers might need:

- **Local IdP:** A local IdP allows users to sign themselves up to the service. Users provide a username, an email address, or an identifier, such as a rewards card number. They also provide a credential, like a password. The IdP stores both the user identifier and the credentials.

- **Social IdP:** A social IdP allows users to use an identity that they have on a social network or other public IdP, such as Facebook, Google, or a personal Microsoft account.

- **The tenant's Microsoft Entra ID directory:** Tenants might already have their own Microsoft Entra ID directory, and they might want your solution to use their directory as the IdP for accessing your solution. This approach is possible when your solution is built as a [multitenant Microsoft Entra application](/entra/identity-platform/howto-convert-app-to-be-multi-tenant).

- **Federation with a tenant's IdP:** Tenants might have their own IdP, other than Microsoft Entra ID, and they might want your solution to federate with it. Federation enables single sign-on (SSO). It also enables tenants to manage the life cycle and security policies of their users independently of your solution.

You should consider if your tenants need to support multiple IdPs. For example, you might need to support local identities, social identities, and federated identities all within a single tenant. This requirement is typical when companies use a solution intended for both their employees and contractors. They might use federation to grant employees access, while also allowing access for contractors or users who don't have accounts in the federated IDP.

### Store authentication and tenant authorization information

In a multitenant solution, you need to consider where to store several types of identity information, including the following types:

- Details about user and service accounts, including their names and other information that your tenants require.

- Information that's required to securely authenticate your users, including information that's required to provide multifactor authentication (MFA).

- Tenant-specific information, such as tenant roles and permissions. This information is used for authorization.

Consider the following options for storing identity information:

- Store all identity and authorization information in the IdP directory, and share it between multiple tenants.

- Store user credentials in the IdP directory. Store authorization data in the application tier, alongside tenant information.

### Determine the number of identities for a user

Multitenant solutions often allow a user or workload identity to access application resources across multiple tenants. When this approach is required, consider the following factors:

- A decision must be made between using a single identity for each person or creating separate identities for each tenant-user combination.  

  - Using a single identity for each person is typically recommended. It simplifies account management for both the solution provider and end users. It also enables modern threat protection capabilities that depend on a unified identity.  

  - In some cases, multiple distinct identities might be necessary. This might apply when users need to separate work and personal activity, or when tenants require isolation because of regulatory or geographic data requirements.  

- If the solution uses identities for each tenant, credentials shouldn't be stored redundantly. Instead, credentials should be tied to a single identity, and features such as guest accounts can be used to associate that identity with multiple tenant records.

## Grant users access to tenant data

Consider how users will be mapped to a tenant. For example, during the sign-up process, you might provide a unique invitation code for users to enter when they access a tenant for the first time. In some solutions, the domain name of the user's sign-up email address can be used to identify their associated tenant. Alternatively, you might use another attribute from the user's identity record to determine the tenant mapping. This association should then be stored based on immutable, unique identifiers for both the tenant and the user.

If your solution is designed so that a single user is only ever going to access the data for a single tenant, then consider the following decisions:

- The IdP must determine which tenant the user is trying to access. This is typically based on user input, such as the domain name or selection during sign-in.  

- The IdP needs to communicate the tenant identifier to the application. This communication is often done by including a tenant ID claim in the authentication token.  

When users require access to multiple tenants, several important considerations emerge:

- The solution must support logic for identifying users and assigning appropriate permissions across tenants. For example, a user might have administrative rights in one tenant but limited access in another.

- A clear mechanism should allow users to switch between tenants. This approach ensures a smooth user experience and prevents accidental cross-tenant access.

- Workload identities must specify which tenant they are authorized to access. This requirement might include embedding tenant-specific context in authentication requests or configuration metadata.

- The identity system must prevent tenant-specific data from being unintentionally shared across tenants. For instance, identity attributes enriched by one tenant should remain isolated from other tenants unless explicitly shared.

## User sign-up process for local identities or social identities

Some tenants might need to allow users to sign themselves up for an identity in your solution. Self-service sign-up might be required if you don't require federation with a tenant's IdP. If a self-sign up process is needed, then you should consider the following factors:

- Allowed identity sources for user sign-up should be defined. This might include support for local identities, social IdPs, or both.

- If only local identities are permitted, tenants might choose to restrict sign-up to specific email domains. For example, access could be limited to users that have verified corporate email addresses.  

- The user principal name (UPN) used for identifying local identities must be clearly established. Common UPNs include email addresses, usernames, phone numbers, or membership identifiers. Because UPNs can change, it's advisable to reference the underlying immutable unique identifier for authorization and auditing. An example is the object ID in Microsoft Entra ID.

- Verification of UPNs might be required to ensure their accuracy. This process could include validating ownership of an email address or phone number before granting access.  

- Some solutions might require tenant administrators to approve user sign-ups. This approval process allows for administrative control over who joins a tenant.  

- A tenant-specific sign-up experience or URL might be necessary. This could include displaying custom branding during sign-up or allowing tenants to intercept and validate sign-up requests before they proceed.

### Tenant access for self sign-up users

When users are allowed to sign themselves up for an identity, there usually needs to be a process for them to be granted access to a tenant. The sign-up flow might include an access grant process, or it could be automated, based on the information about the users, such as their email addresses. It's important to plan for this process and consider the following factors:

- The sign-up flow should include logic that determines which tenant a user should be granted access to. This mapping might rely on attributes such as domain, invitation tokens, or referral links.  

- Access revocation mechanisms must be in place to remove users who no longer require access to a tenant. This might include automated processes or administrative workflows that respond to events such as offboarding or access expiration.  

- A user audit capability is often needed so that tenants can review which users have access to their environment and understand their assigned permissions.

## Automated account life cycle management

A common requirement for corporate or enterprise customers of a solution is a set of features that allows them to automate account onboarding and off-boarding. Open protocols, such as [system for cross-domain identity management (SCIM)](/entra/architecture/sync-scim), provide an industry-standard approach to automation. This automated process usually includes not only creation and removal of identity records, but also management of tenant permissions. Consider the following questions when you implement automated account life cycle management in a multitenant solution:

- An automated user life cycle process might be required for each tenant. This could include creating and managing user identities across multiple tenants, each with its own set of permissions.  

- A decision should be made between implementing SCIM or offering federation. Federation allows tenants to retain control over user management by keeping the source of truth within their own systems instead of managing local users in your solution.

## User authentication process

When a user signs into a multitenant application, your identity system authenticates the user. Consider the following factors when you plan your authentication process:

- Tenants might require the ability to configure their own MFA policies. Requirements can vary widely across industries, with some needing stricter enforcement than others.

- The option to define custom conditional access (CA) rules might be important for tenants. These rules could address security needs such as restricting sign-ins from specific regions.

- Sign-in process customization can be necessary. This process might include displaying a tenant's branding or enriching user identity information with data from external systems.  

- Some users might need to impersonate other users. This functionality is often used by support personnel to investigate problems without requiring direct access to the user's credentials.  

- API access might be required for some users or external applications. These scenarios might include calling the solution's APIs directly, which bypasses standard user authentication flows.

## Workload identities

In most solutions, an identity often represents a user. Some multitenant systems also allow [workload identities](/entra/workload-id/workload-identities-overview) to be used by *services* and *applications*, to gain access to your application resources. For example, your tenants might need to access an API that your solution provides so that they can automate some of their management tasks.

Workload identities are similar to user identities, but usually they require different authentication methods, such as keys or certificates. Workload identities don't use MFA. Instead, workload identities usually require other security controls, such as regular key-rolling and certificate expiration.

If your tenants expect to be able to enable workload identity access to your multitenant solution, then you should consider the following factors:

- Workload identity creation and management should be clearly defined for each tenant. Consider how these identities will be provisioned, tracked, and maintained.  

- Requests made by workload identities need to be properly scoped so that each request aligns with the specific tenant's access boundaries.  

- It might be necessary to place limits on the number of workload identities that a tenant can create to avoid resource overuse or mismanagement.

- CA controls could be required for workload identities in each tenant. For example, a tenant might want to ensure that workload identities can only be authenticated from specific geographic regions.

- Security controls provided to tenants must be effective at protecting workload identities. These controls might include automated key rotation, expiration policies for keys and certificates, and active monitoring for potential sign-in risks.

## Federate with an IdP for SSO

Tenants who already have their own user directories might want your solution to *federate* to their directories. Federation allows your solution to use the identities in their directory instead of managing another directory with distinct identities.

Federation is especially important when some tenants want to specify their own identity policies, or to enable SSO experiences.

If you expect tenants to federate with your solution, consider the following factors:

- The process for configuring federation should be clearly defined. Consider whether tenants are able to set it up on their own or if it requires manual configuration and maintenance by your team.

- Supported federation protocols should be identified and consistently implemented across the solution.  

- Safeguards should be in place to prevent misconfigurations that could inadvertently grant access to the wrong tenant.  

- In some cases, a single tenant's IdP might need to be connected to multiple tenants within your solution. For instance, organizations that use separate training and production tenants might require access through the same IdP.

## Authorization models

Decide on the authorization model that makes the most sense for your solution. Consider the following two common authorization approaches:

- **Role-based authorization:** Users are assigned to roles. Some features of the application are restricted to specific roles. For example, a user in the administrator role can perform any action, while a user in a lower role might have a subset of permissions throughout the system.

- **Resource-based authorization:** Your solution provides a set of distinct resources, each of which has its own set of permissions. A specific user might be an administrator of one resource and have no access to another resource.

These models are distinct, and the approach that you select affects your implementation and the complexity of the authorization policies that you can implement.

### Entitlements and licensing

In some solutions, you might use [per-user licensing](pricing-models.md#per-user-pricing) as part of your commercial pricing model. In this scenario, you provide different tiers of user licenses with different capabilities. For example, users with one license might be permitted to use a subset of the features of the application. The capabilities that specific users are allowed to access, based on their licenses, is sometimes called an *entitlement*.

The application code or a dedicated entitlements system typically tracks and enforces entitlements instead of the identity system. This process is similar to authorization but occurs outside the identity management layer.

## Identity scale and authentication volume

As multitenant solutions grow, the number of users and sign-in requests that the solution needs to process increases. Consider the following factors:

- The user directory should be able to scale as the number of users increases.  

- The authentication system needs to handle growing volumes of sign-in and sign-up traffic as the solution expands.  

- Spikes in authentication activity can occur at predictable times. For example, a large number of users might sign in simultaneously at the start of the workday in a specific region. These surges are often known as *login storms*.  

- Dependencies between authentication and other services can affect performance under load. If authentication relies on other components such as an API layer, high traffic could cause delays or failures across the system.  

- The availability of the IdP becomes increasingly important. If the provider goes offline, a fallback authentication method can help maintain access and minimize disruption.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [Jelle Druyts](https://linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Senior Customer Engineer
- [Sander van den Hoven](https://linkedin.com/in/azurehero) | Senior Partner Technology Strategist
- [Nick Ward](https://linkedin.com/in/nickward13) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Architectural approaches for identity in multitenant solutions](../approaches/identity.md)
