---
title: Architectural Considerations for Identity in a Multitenant Solution
description: Learn about multitenant identity architecture with authentication, authorization, SSO, federation, and tenant isolation strategies for secure solutions.
author: plagueho
ms.author: dascottr
ms.date: 12/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural considerations for identity in a multitenant solution

Identity is an important aspect of any multitenant solution. The identity components of your application are responsible for the following tasks:

- Verifying a user's identity, known as *authentication*

- Enforcing a user's permissions within the scope of a tenant, known as *authorization*

Your customers might also wish to authorize external applications to access their data or integrate with your solution. A user's identity determines what information a user or service can access. It's important that you consider your identity requirements to isolate your application and data between tenants.

> [!CAUTION]
> Authentication and authorization services within multitenant and software as a service (SaaS) applications are typically provided by an external identity provider (IdP). An IdP is usually an integral part of a managed identity platform.
>
> Building your own IdP is complex, expensive, and challenging to secure. It's considered an [antipattern](../approaches/identity.md#building-or-running-your-own-identity-system), and we don't recommend it.

Before you define a multitenant identity strategy, first consider the following high-level identity requirements for your service:

- Determine whether users or [workload identities](#workload-identities) access a single application or multiple applications within a product family. Some product families might include distinct applications that share the same identity infrastructure, such as point-of-sale systems and inventory management platforms.

- Consider whether your solution implements modern authentication and authorization standards, such as OAuth2 and OpenID Connect.

- Evaluate whether authentication is limited to UI-based applications or if API access also applies to tenants and third-party systems.

- Determine whether tenants need to federate with their own IdPs and if multiple IdPs must be supported for each tenant. For example, you might have tenants with Microsoft Entra ID, Auth0, and Active Directory Federation Services where each tenant federates with your solution. Identify which federation protocols their IdPs use because those protocols determine what your IdP must support.

- Review any applicable compliance requirements that they need to meet, such as the [General Data Protection Regulation (GDPR)](/compliance/regulatory/gdpr), that shape your identity strategy.

- Determine whether tenants require identity data to be stored in specific geographic regions to meet legal, compliance, or operational needs.

- Assess whether users access data from multiple tenants within the application. If they do, you might need to support seamless tenant switching or provide consolidated views across tenants for specific users. For example, users who sign into the Azure portal can easily switch between different Microsoft Entra ID directories and subscriptions that they have access to.

When you establish your high-level requirements, you can start to plan more specific details and requirements, such as user directory sources and sign-up and sign-in flows.

## Identity directory

For a multitenant solution to authenticate and authorize a user or service, it needs a place to store identity information. A *directory* can include authoritative records for each identity. Or it might contain references to external identities that are stored in the directory of another IdP.

When you design an identity system for your multitenant solution, you need to consider which of the following types of IdP that your tenants and customers might need:

- **Local IdP:** A local IdP allows users to sign themselves up for the service. Users provide a username, an email address, or an identifier, such as a rewards card number. They also provide a credential, like a password. The IdP stores both the user identifier and the credentials.

- **Social IdP:** A social IdP allows users to use an identity that they have on a social network or other public IdP, such as Facebook, Google, or a personal Microsoft account. Social IdPs are commonly used in business-to-consumer (B2C) SaaS solutions.

- **The tenant's Microsoft Entra ID directory:** In many business-to-business (B2B) SaaS solutions, tenants might already have their own Microsoft Entra ID directory, and they might want your solution to use their directory as the IdP for accessing your solution. This approach is possible when your solution is built as a [multitenant Microsoft Entra application](/entra/identity-platform/howto-convert-app-to-be-multi-tenant).

- **Federation with a tenant's IdP:** In some B2B SaaS solutions, tenants might have their own IdP, other than Microsoft Entra ID, and they might want your solution to federate with it. Federation enables single sign-on (SSO). It also enables tenants to manage the life cycle and security policies of their users independently of your solution.

You should consider if your tenants need to support multiple IdPs. For example, a single tenant might need to support local identities, social identities, and federated identities. This requirement is typical when companies use a solution intended for both their employees and contractors. They might use federation to grant employees access, while also allowing access for contractors or users who don't have accounts in the federated IdP.

### Store authentication and tenant authorization information

In a multitenant solution, you need to consider where to store several types of identity information, including the following types:

- Details about user and service accounts, including their names and other information that your tenants require.

- Information that's required to securely authenticate your users, including information for multifactor authentication (MFA).

- Tenant-specific information, such as tenant roles and permissions, for authorization.

> [!CAUTION]
> We don't recommend building authentication processes yourself. Modern IdPs provide these authentication services to your application, and they also include other important features, such as MFA and conditional access. [Building your own identity provider is an antipattern](../approaches/identity.md#building-or-running-your-own-identity-system). We don't recommend it.

Consider the following options for storing identity information:

- Store all identity and authorization information in the IdP directory, and share it between multiple tenants.

- Store user credentials in the IdP directory. Store authorization data in the application tier, alongside tenant information.

### Determine the number of identities for a user

Multitenant solutions often allow a user or workload identity to access application resources and data across multiple tenants. When this approach is required, consider the following factors:

- Decide whether to create a single user identity for each person or to create separate identities for each tenant-user combination.

  - Use a single identity for each person when possible. It simplifies account management for both the solution provider and users. Also, many of the intelligent threat protections that modern IdPs provide rely on each person having a single user account.  

  - Use multiple distinct identities in some scenarios. For example, if people use your system both for work and personal purposes, they might want to separate their user accounts. Or if your tenants have strict regulatory or geographical data storage requirements, they might require a person to have multiple identities so that they can comply with regulations or laws.

- Avoid storing credentials multiple times if you use per-tenant identities. Users should have their credentials stored against a single identity, and you should use features like guest identities to refer to the same user credentials from multiple tenants' identity records.

## Grant users access to tenant data

Consider how you plan to map users to a tenant. For example, during the sign-up process, you might provide a unique invitation code for users to enter when they access a tenant for the first time. In some solutions, the domain name of the user's sign-up email address can identify their associated tenant. Alternatively, you might use another attribute from the user's identity record to determine the tenant mapping. This association should then be stored based on immutable, unique identifiers for both the tenant and the user.

If your solution limits each user to accessing data for a single tenant, consider the following decisions:

- Determine how the IdP detects which tenant a user accesses.

- Explain how the IdP communicates the tenant identifier to the application. Typically, a tenant identifier claim is added to the token.

If a single user needs to be granted access to multiple tenants, consider the following decisions:

- The solution must support logic for identifying users and granting appropriate permissions across tenants. For example, a user might have administrative rights in one tenant but limited access in another tenant. For example, suppose a user signed up with a social identity and was then granted access to two tenants. Tenant A enriched the user's identity with more information. Should tenant B have access to the enriched information?

- A clear mechanism should allow users to switch between tenants. This approach ensures a smooth user experience and prevents accidental cross-tenant access.

- Workload identities, if you use them, must specify which tenant they're trying to access. This requirement might include embedding tenant-specific context in authentication requests.

- Consider whether tenant-specific information stored in a user's identity record could unintentionally leak between tenants. For example, if a user signs up with a social identity and gains access to two tenants, and Tenant A enriches the user profile, determine whether Tenant B should have access to that enriched information.

## User sign-up process for local identities or social identities

Some tenants might need to allow users to sign themselves up for an identity in your solution. Self-service sign-up might be required if you don't require federation with a tenant's IdP. If a self-sign up process is needed, then you should consider the following factors:

- Define which identity sources users are allowed to sign up from. For example, determine whether users can create a local identity and also use a social IdP.

- Specify whether your solution allows only specific email domains if local identities are used. For example, determine whether a tenant can restrict sign-ups to users with an `@contoso.com` email address.

- The user principal name (UPN) used for identifying local identities must be clearly established. Common UPNs include email addresses, usernames, phone numbers, or membership identifiers. Because UPNs can change, it's advisable to reference the underlying immutable unique identifier for authorization and auditing. An example is the object ID (OID) in Microsoft Entra ID.

- Verification of UPNs might be required to ensure their accuracy. This process could include validating ownership of an email address or phone number before granting access.  

- Some solutions might require tenant administrators to approve user sign-ups. This approval process allows for administrative control over who joins a tenant.  

- Decide whether tenants require a tenant-specific sign-up experience or URL. For example, determine if your tenants require a branded sign-up experience when users sign up, or the ability to intercept a sign-up request and perform extra validation before it proceeds.

### Tenant access for self sign-up users

If users can sign themselves up for an identity, define a process to grant them access to a tenant. The sign-up flow might include a manual access grant process or an automated process based on the information about the users, such as their email addresses. It's important to plan for this process and consider the following factors:

- Define how the sign-up flow determines that a user is granted access to a specific tenant.

- Define whether your solution automatically revokes user access to a tenant when appropriate. For example, when users leave an organization, there should be a manual or automated process in place to remove their access.

- Provide a user audit capability so that tenants can review which users have access to their environment and understand their assigned permissions.

## Automated account life cycle management

A common requirement for corporate or enterprise customers of a solution is a set of features that allows them to automate account onboarding and offboarding. Open protocols, such as [System for Cross-Domain Identity Management (SCIM)](/entra/architecture/sync-scim), provide an industry-standard approach to automation. This automated process usually includes the creation and removal of identity records and the management of tenant permissions. Consider the following factors when you implement automated account life cycle management in a multitenant solution:

- Determine whether your customers need to configure and manage an automated life cycle process for each tenant. For example, when a user is onboarded, you might need to create the identity within multiple tenants in your application, where each tenant has a different set of permissions. 

- Determine whether you need to implement SCIM or offer federation. Federation allows tenants to retain control over user management by keeping the source of truth within their own systems instead of managing local users in your solution.

## User authentication process

When a user signs into a multitenant application, your identity system authenticates the user. Consider the following factors when you plan your authentication process:

- Some tenants might require the ability to configure their own MFA policies. For example, if your tenants are in the financial services industry, they need to implement strict MFA policies, while a small online retailer might not have the same requirements.

- The option to define custom conditional access rules might be important for tenants. For example, different tenants might need to block sign-in attempts from specific geographic regions.

- Determine whether tenants need to customize the sign-in process individually. For example, your solution might need to show a customer's logo. Or it might need to retrieve user information, such as a rewards number, from another system and return it to the IdP to enrich the user profile.

- Some users might need to impersonate other users. For example, a support team member might wish to investigate a problem that another user has by impersonating their user account without having to authenticate as the user.  

- API access might be required for some users or external applications. These scenarios might include calling the solution's APIs directly, which bypasses standard user authentication flows.

## Workload identities

In most solutions, an identity often represents a user. Some multitenant systems also allow workload identities to be used by services and applications to gain access to your application resources. For example, your tenants might need to access an API that your solution provides so that they can automate their management tasks.

[Microsoft Entra supports workload identities](/entra/workload-id/workload-identities-overview), and other IdPs also commonly support them too.

Workload identities are similar to user identities, but usually they require different authentication methods, such as keys or certificates. Workload identities don't use MFA. Instead, workload identities usually require other security controls, such as regular key-rolling and certificate expiration.

If your tenants can enable workload identity access to your multitenant solution, then you should consider the following factors:

- Determine how workload identities are created and managed in each tenant.

- Decide how workload identity requests are scoped to the tenant.

- Evaluate if you need to limit the number of workload identities that each tenant creates.

- Determine if conditional access controls are required for workload identities in each tenant. For example, a tenant might want to limit a workload identity from being authenticated from outside a specific region.

- Identify which security controls you provide to tenants to ensure that workload identities remain secure. For example, automated key rolling, key expiration, certificate expiration, and sign-in risk monitoring help reduce the risk of workload identity misuse.

## Federate with an IdP for SSO

Tenants who already have their own user directories might want your solution to *federate* to their directories. Federation allows your solution to use the identities in their directory instead of managing another directory with distinct identities.

Federation is especially important when some tenants want to specify their own identity policies or to enable SSO experiences.

If you expect tenants to federate with your solution, consider the following factors:

- Consider the process for configuring the federation for a tenant. Determine if tenants configure federation themselves or if the process requires manual configuration and maintenance by your team.

- Define which federation protocols your solution supports.

- Establish processes that prevent federation misconfigurations from granting access to unintended tenants.

- Plan for whether a single tenant's IdP needs to be federated to more than one tenant in your solution. For example, if customers have both a training and a production tenant, they might need to federate the same IdP with each tenant.

## Authorization models

Decide on the authorization model that makes the most sense for your solution. Consider the following common authorization approaches:

- **Role-based authorization:** Users are assigned to roles. Some features of the application are restricted to specific roles. For example, a user in the administrator role can perform any action, while a user in a lower role might have a subset of permissions throughout the system.

- **Resource-based authorization:** Your solution provides a set of distinct resources, each of which has its own set of permissions. A specific user might be an administrator of one resource and have no access to another resource.

These models are distinct, and the approach that you select affects your implementation and the complexity of the authorization policies that you can implement.

### Entitlements and licensing

In some solutions, you might use [per-user licensing](pricing-models.md#per-user-pricing) as part of your commercial pricing model. In this scenario, you provide different tiers of user licenses that have different capabilities. For example, users with one license might be permitted to use a subset of the features of the application. The capabilities that specific users are allowed to access, based on their licenses, is sometimes called an *entitlement*.

We recommend that you track and enforce entitlements within your application code or a dedicated entitlements system, rather than relying on the identity system. This process is similar to authorization but occurs outside the identity management layer.

There are several reasons for this separation:

- **Complexity of licensing models:** Licensing rules are often complex and specific to the business model. For example, licenses might be per-seat, time-based (daily or monthly assignment), limit concurrent usage, or have specific reassignment rules. Identity providers are generally designed for user authentication and basic authorization, not for complex commercial licensing logic.

- **Independence:** Relying on identity provider features for license management can lock your solution into that provider or its constraints. If you support customers who use different identity providers, you would need to build a custom solution for them anyway.

A common pattern is to manage licenses within the application's database or a dedicated service. When a user signs in, the identity provider retrieves their entitlements and injects them into the authorization token as custom claims that can be checked by the application components at run time.

## Identity scale and authentication volume

As multitenant solutions grow, the number of users and sign-in requests that the solution needs to process increases. Evaluate these scalability considerations:

- Assess whether the user directory scales to support the required number of users.

- Evaluate whether the authentication process handles the expected number of sign-ins and sign-ups.

- Determine whether there are spikes that the authentication system can't handle. For example, at 9 AM Pacific Time, everyone in the western United States might start work and sign in to your solution, which creates a spike in sign-in requests. These scenarios are sometimes called *login storms*.

- Determine whether high load in parts of your solution affects the performance of the authentication process. For example, if authentication requires calling into an application-tier API, a surge in authentication requests could affect overall system performance.

- Define how your solution behaves if the IdP becomes unavailable. Consider whether a backup authentication service should be included to maintain business continuity.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

Other contributors:

- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Senior Customer Engineer
- [Sander van den Hoven](https://www.linkedin.com/in/azurehero) | Senior Partner Technology Strategist
- [Nick Ward](https://www.linkedin.com/in/nickward13) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Architectural approaches for identity in multitenant solutions](../approaches/identity.md)
