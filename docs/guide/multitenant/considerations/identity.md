---
title: Architectural Considerations for Identity in a Multitenant Solution
description: Learn about multitenant identity architecture with authentication, authorization, SSO, federation, and tenant isolation strategies for secure solutions.
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

Before you define a multitenant identity strategy, first consider the following high-level identity requirements for your service:

- Determine whether users or [workload identities](#workload-identities) will access a single application or multiple applications within a product family. Some product families might include distinct applications that share the same identity infrastructure, such as point-of-sale systems and inventory management platforms.

- Consider whether your solution will implement modern authentication and authorization standards, such as OAuth2 and OpenID Connect.  

- Evaluate whether authentication is limited to UI-based applications or if API access will also be provided to tenants and non-Microsoft systems.

- Determine whether tenants will need to federate with their own IdPs and if multiple different identity providers need to be supported for each tenant. For example, you might have tenants with Microsoft Entra ID, Auth0, and Active Directory Federation Services where each tenant wants to federate with your solution. You also need to understand which federation protocols of your tenants' IdPs to support because the protocols influence the requirements for your own IdP.

- Review any applicable compliance requirements that they need to meet, such as [GDPR](/compliance/regulatory/gdpr), that might shape your identity strategy.  

- Determine whether tenants require identity data to be stored in specific geographic regions in order to meet legal or operational needs.  

- Assess whether users need access to data from one or multiple tenants within the application. You might also need to support seamless tenant switching or provide consolidated views across tenants for specific users.

- Determine if users of your solution require access to data from one tenant or from multiple tenants within your application. Also determine if users need the ability to quickly switch between tenants or to view consolidated information from multiple tenants. For example, users who have signed into the Azure portal can easily switch between different Microsoft Entra ID directories and subscriptions that they have access to.

When you establish your high-level requirements, you can start to plan more specific details and requirements, such as user directory sources and sign-up and sign-in flows.

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

- Decide whether to create a single user identity for each person or create separate identities for each tenant-user combination.

  - Using a single identity for each person is typically recommended. It simplifies account management for both the solution provider and end users. Also, many of the intelligent threat protections that modern IdP provides rely on each person having a single user account.  

  - In some scenarios, multiple distinct identities might be necessary. For example, if people use your system both for work and personal purposes, they might want to separate their user accounts. Or if your tenants have strict regulatory or geographical data storage requirements, they might require a person to have multiple identities so that they can comply with regulations or laws.

- If you use per-tenant identities, avoid storing credentials multiple times. Users should have their credentials stored against a single identity, and you should use features like guest identities to refer to the same user credentials from multiple tenants' identity records.

## Grant users access to tenant data

Consider how users will be mapped to a tenant. For example, during the sign-up process, you might provide a unique invitation code for users to enter when they access a tenant for the first time. In some solutions, the domain name of the user's sign-up email address can be used to identify their associated tenant. Alternatively, you might use another attribute from the user's identity record to determine the tenant mapping. This association should then be stored based on immutable, unique identifiers for both the tenant and the user.

If your solution is designed so that a single user is only ever going to access the data for a single tenant, then consider the following decisions:

- Determine how the IdP detects which tenant a user is accessing.

- Explain how the IdP communicates the tenant identifier to the application. Typically, a tenant identifier claim is added to the token.

If a single user needs to be granted access to multiple tenants, consider the following decisions:

- The solution must support logic for identifying users and assigning appropriate permissions across tenants. For example, a user might have administrative rights in one tenant but limited access in another.

- A clear mechanism should allow users to switch between tenants. This approach ensures a smooth user experience and prevents accidental cross-tenant access.

- Workload identities must specify which tenant they are authorized to access. This requirement might include embedding tenant-specific context in authentication requests or configuration metadata.

- Consider whether tenant-specific information stored in a user's identity record could unintentionally leak between tenants. For example, if a user signs up with a social identity and gains access to two tenants, and Tenant A enriches the user profile, determine whether Tenant B should have access to that enriched information.

## User sign-up process for local identities or social identities

Some tenants might need to allow users to sign themselves up for an identity in your solution. Self-service sign-up might be required if you don't require federation with a tenant's IdP. If a self-sign up process is needed, then you should consider the following factors:

- Define which identity sources users are allowed to sign up from. For example, determine whether users can create a local identity and also use a social identity provider.

- Specify whether only specific email domains will be allowed if local identities are used. For example, determine if a tenant can restrict sign-ups to users with an `@contoso.com` email address.

- The user principal name (UPN) used for identifying local identities must be clearly established. Common UPNs include email addresses, usernames, phone numbers, or membership identifiers. Because UPNs can change, it's advisable to reference the underlying immutable unique identifier for authorization and auditing. An example is the object ID in Microsoft Entra ID.

- Verification of UPNs might be required to ensure their accuracy. This process could include validating ownership of an email address or phone number before granting access.  

- Some solutions might require tenant administrators to approve user sign-ups. This approval process allows for administrative control over who joins a tenant.  

- Decide whether tenants require a tenant-specific sign-up experience or URL. For example, determine if your tenants require a branded sign-up experience when users sign up, or the ability to intercept a sign-up request and perform extra validation before it proceeds.

### Tenant access for self sign-up users

When users are allowed to sign themselves up for an identity, there usually needs to be a process for them to be granted access to a tenant. The sign-up flow might include an access grant process, or it could be automated, based on the information about the users, such as their email addresses. It's important to plan for this process and consider the following factors:

- Define how the sign-up flow will determine that a user should be granted access to a specific tenant.

- Define whether your solution will automatically revoke user access to a tenant when appropriate. For example, when users leave an organization, there should be a manual or automated process in place to remove their access.

- A user audit capability is often needed so that tenants can review which users have access to their environment and understand their assigned permissions.

## Automated account life cycle management

A common requirement for corporate or enterprise customers of a solution is a set of features that allows them to automate account onboarding and off-boarding. Open protocols, such as [system for cross-domain identity management (SCIM)](/entra/architecture/sync-scim), provide an industry-standard approach to automation. This automated process usually includes not only creation and removal of identity records, but also management of tenant permissions. Consider the following questions when you implement automated account life cycle management in a multitenant solution:

- An automated user life cycle process might be required for each tenant. For example, when a user is onboarded, you might need to create the identity within multiple tenants in your application, where each tenant has a different set of permissions.  

- A decision should be made between implementing SCIM or offering federation. Federation allows tenants to retain control over user management by keeping the source of truth within their own systems instead of managing local users in your solution.

## User authentication process

When a user signs into a multitenant application, your identity system authenticates the user. Consider the following factors when you plan your authentication process:

- Tenants might require the ability to configure their own MFA policies. For example, if your tenants are in the financial services industry, they need to implement strict MFA policies, while a small online retailer might not have the same requirements.

- The option to define custom conditional access (CA) rules might be important for tenants. For example, different tenants might need to block sign-in attempts from specific geographic regions.

- Determine whether tenants need to customize the sign-in process individually. For example, do you need to show a customer's logo? Or does user information, such as a rewards number, need to be retrieved from another system and returned to the identity provider to enrich the user profile?

- Some users might need to impersonate other users. For example, a support team member might wish to investigate a problem that another user has by impersonating their user account without having to authenticate as the user.  

- API access might be required for some users or external applications. These scenarios might include calling the solution's APIs directly, which bypasses standard user authentication flows.

## Workload identities

In most solutions, an identity often represents a user. Some multitenant systems also allow [workload identities](/entra/workload-id/workload-identities-overview) to be used by *services* and *applications*, to gain access to your application resources. For example, your tenants might need to access an API that your solution provides so that they can automate some of their management tasks.

Workload identities are similar to user identities, but usually they require different authentication methods, such as keys or certificates. Workload identities don't use MFA. Instead, workload identities usually require other security controls, such as regular key-rolling and certificate expiration.

If your tenants expect to be able to enable workload identity access to your multitenant solution, then you should consider the following factors:

- Determine how workload identities will be created and managed in each tenant.

- Decide how workload identity requests will be scoped to the tenant.

- Evaluate if you need to limit the number of workload identities that each tenant creates.

- Determine if CA controls are required for workload identities in each tenant. For example, a tenant might want to limit a workload identity from being authenticated from outside a specific region.

- Identify which security controls you will provide to tenants to ensure that workload identities remain secure. For example, automated key rolling, key expiration, certificate expiration, and sign-in risk monitoring are all methods of reducing the risk, where a workload identity might be misused.

## Federate with an IdP for SSO

Tenants who already have their own user directories might want your solution to *federate* to their directories. Federation allows your solution to use the identities in their directory instead of managing another directory with distinct identities.

Federation is especially important when some tenants want to specify their own identity policies, or to enable SSO experiences.

If you expect tenants to federate with your solution, consider the following factors:

- Consider the process for configuring the federation for a tenant. Determine if tenants can configure federation themselves or if the process requires manual configuration and maintenance by your team.

- Define which federation protocols your solution will support.

- Establish processes that prevent federation misconfigurations from granting access to unintended tenants.  

- Plan for whether a single tenant's IdP will need to be federated to more than one tenant in your solution. For example, if customers have both a training and a production tenant, they might need to federate the same IdP with each tenant.

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

- Assess whether the user directory will scale to support the required number of users.  

- Evaluate whether the authentication process will handle the expected number of sign-ins and sign-ups.

- Determine whether there will be spikes that the authentication system can't handle. For example, at 9am PST, everyone in the western United States might start work and sign in to your solution, which creates a spike in sign-in requests. These scenarios are sometimes called *login storms*.

- Determine whether high load in other parts of your solution can affect the performance of the authentication process. For example, if authentication requires calling into an application-tier API, a surge in authentication requests could affect overall system performance.

- Define how your solution will behave if the IdP becomes unavailable. Include whether a backup authentication service is in place to maintain business continuity when the IdP is unavailable.

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
