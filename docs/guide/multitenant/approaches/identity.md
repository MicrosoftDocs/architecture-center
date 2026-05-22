---
title: Architectural Approaches for Identity in Multitenant Solutions
description: This article covers identity management strategies for multitenant solutions, including authentication, authorization, federation, and security considerations.
author: johndowns
ms.author: pnp
ms.date: 04/30/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for identity in multitenant solutions

Most multitenant solutions require an identity system. This article describes common components of identity, including authentication and authorization, and how you can use these components in a multitenant solution.

> [!NOTE]
> Before you start to build an identity system for a multitenant solution, see [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).

## Authentication

Authentication is the process that establishes a user's identity. When you build a multitenant solution, consider the various approaches for different aspects of the authentication process.

### Federation

You might need to federate with external identity providers (IdPs). You can use federation in the following scenarios:

- **Social sign-in.** Users can sign in with their account credentials from platforms like Google, Meta, GitHub, or Microsoft.

- **Tenant-specific directories.** Tenants can federate applications with their own IdPs so that they don't need to manage accounts in multiple locations.

For more information, see the [Federated identity pattern](../../../patterns/federated-identity.yml).

If you choose to support tenant-specific IdPs, ensure that you clarify which services and protocols your application supports. For example, determine whether to support the OpenID Connect protocol and the Security Assertion Markup Language (SAML) protocol, or whether to limit federation to Microsoft Entra ID instances.

When you implement an IdP, consider scaling and limits that might apply. For example, your IdP might be able to federate with only a limited number of other IdPs.

Also consider providing federation as a feature that only applies to customers at a higher [product tier](../considerations/pricing-models.md#feature--and-service-level-based-pricing).

### Single sign-on

Users can switch between applications without reauthentication by using single sign-on.

When users open an application, the application directs them to an IdP. If the IdP detects an existing session, it issues a new token automatically. The user doesn't need to sign in again. Federated identity supports single sign-on so that users can use a single identity across multiple applications.

In a multitenant solution, you might use another form of single sign-on. If users are authorized to access data across multiple tenants, they might need to change their context from one tenant to another. In some solutions, the IdP can silently issue a new token for the selected tenant if the user already has a valid session. In other solutions, the tenant change requires an interactive sign-in or a new session. Consider whether your solution needs to support tenant transitions without another sign-in prompt and whether your IdP should reissue tokens that have specific tenant claims. For example, when a user signs in to the Azure portal, they can switch between different Microsoft Entra ID directories. This transition requires reauthentication and generates a new token from the new Microsoft Entra ID instance.

### Multifactor authentication

Some tenants require users to continue to use a specific multifactor authentication provider for compliance or user-experience reasons. Microsoft Entra ID supports [external authentication methods](/entra/identity/authentication/concept-authentication-external-method-provider). These methods require that tenants use a non-Microsoft multifactor authentication provider, but Microsoft Entra ID is the identity control plane and evaluates Microsoft Entra Conditional Access policies and sign-in risk during sign-in. Consider whether your solution should support tenants that use their own multifactor authentication provider.

### Sign-in risk evaluation

Modern identity platforms support risk evaluation during the sign-in process. For example, if a user signs in from an unusual location or device, the authentication system might require extra identity checks, such as multifactor authentication, before the sign-in request can continue.

Your tenants might have different risk policies that need to be applied during authentication. For example, tenants in a highly regulated industry might have different risk profiles and requirements than tenants who work in less regulated environments. In another example, you might provide tenants who purchase a higher tier of your service with more granular controls over sign-in policies than lower-tier tenants.

If you need to support different risk policies for each tenant, your authentication system needs to know which tenant the user signs in to, so that it can apply the correct policies.

If your IdP includes these capabilities, you can use the IdP's native sign-in risk-evaluation features. It can be difficult to implement these features yourself.

If you federate to the tenants' IdPs, you can apply their risky sign-in mitigation policies so that they can configure enforcement policies and controls. For example, you can require two multifactor authentication challenges, one from the user's home IdP and another from your own, to make the sign-in process more difficult. Check how federation interacts with your tenants' IdPs and the policies that they have in place.

### Impersonation

A user performs impersonation when they assume another user's identity without that user's credentials.

Impersonation is dangerous and can be difficult to implement and control. However, in some scenarios, impersonation is required. For example, if you operate in a software as a service (SaaS) environment, your help desk personnel might need to assume a user's identity so that they can sign in as the user and troubleshoot a problem.

If you implement impersonation, consider how to audit its use. Your logs should capture the identifier of the impersonator and the identifier of the impersonated user.

Some identity platforms support impersonation, either as a built-in feature or by using custom code. For example, you can [add a custom claim in Microsoft Entra External ID](/entra/external-id/customers/concept-custom-extensions#token-issuance-start-event) for the impersonated user ID, or you can replace the subject identifier claim in the issued tokens.

## Authorization

Authorization determines what a user can do.

Authorization data can be stored in several places, including in the following locations:

- **Your IdP:** For example, if you use Microsoft Entra ID as your IdP, you can use features like [app roles](/entra/identity-platform/howto-add-app-roles-in-apps) and [groups](/entra/fundamentals/how-to-manage-groups) to store authorization information. Your application can use the associated token claims to enforce your authorization rules.

- **In your application:** You can build your own authorization logic and store information about what each user can do in a database or similar storage system. You can then design controls for role-based or resource-level authorization.

In most multitenant solutions, the customer or tenant manages role and permission assignments, and not the multitenant system vendor.

### Add tenant identity and role information to tokens

Determine which parts of your solution should handle authorization requests. Evaluate whether to grant access to data from a specific tenant.

A common approach is for your identity system to embed a tenant identifier claim into a token. Your application can then inspect the claim and verify the user's access restrictions. If you use role-based security, you might extend the token to include information about the user's role within the tenant.

If a single user has access to multiple tenants, you might need a way for your users to signal which tenant they plan to work with during the sign-in process. After the user selects their active tenant, the IdP can issue a token that includes the correct tenant identifier claim and role for that tenant. Consider how users can switch between tenants, which requires a new token.

#### Application-based authorization

Alternatively, make the identity system agnostic to tenant identifiers and roles. Users are identified through their credentials or a federation relationship, and tokens don't include a tenant identifier claim. A separate list or database maintains tenant access records. The application tier uses this list to verify whether the user is authorized to access the tenant data.

<a name='use-azure-ad-or-azure-ad-b2c'></a>
<a name='use-microsoft-entra-id-or-azure-ad-b2c'></a>

## Use Microsoft Entra ID or External ID

Microsoft Entra ID and External ID are managed identity platforms that you can use within your own multitenant solution.

Many multitenant solutions operate as SaaS. Your choice to use Microsoft Entra ID or External ID depends partly on how you define your tenants or customer base.

- If your tenants or customers are organizations, they might already use Microsoft Entra ID for services like Microsoft 365, Microsoft Teams, or for their own Azure environments. You can create a [multitenant application](/entra/identity-platform/single-and-multi-tenant-apps) in your own Microsoft Entra ID directory to make your solution available to other Microsoft Entra ID directories. You can also list your solution in [Microsoft Marketplace](/partner-center/marketplace-offers/plan-saas-offer) so that organizations that use Microsoft Entra ID can discover and acquire it.

- If your tenants or customers don't use Microsoft Entra ID, or if they're individuals instead of organizations, you can use External ID. External ID provides features to control how users sign up and sign in. For example, you can restrict access to your solution to only invited users, or you can turn on self-service sign-up. You can use [custom branding](/entra/external-id/customers/how-to-customize-branding-customers). To invite your own staff to sign in, use guest access to [add External ID users from your Microsoft Entra ID tenant](/entra/external-id/b2b-quickstart-add-guest-users-portal). External ID also supports [federation with other IdPs](/entra/external-id/customers/concept-authentication-methods-customers).

- Some multitenant solutions are intended for both previously listed scenarios. Some tenants might have their own Microsoft Entra ID tenants and other tenants might not. In this scenario, use External ID and federation so that users can sign in from a tenant's Microsoft Entra ID directory.

> [!IMPORTANT]
> Azure Active Directory B2C (Azure AD B2C) also supports many of the scenarios in this article. However, as of May 1, 2025, this product is no longer available to purchase for new customers, so we don't recommend it for new solutions. For more information, see [Azure AD B2C FAQ](/azure/active-directory-b2c/faq#azure-ad-b2c-end-of-sale).

## Antipatterns to avoid

### Self-administered identity systems

It's complex to build a modern identity platform. These platforms require support for a range of protocols and standards, and an incorrect implementation can introduce security vulnerabilities. You need to continually update your identity system to mitigate attacks, incorporate the latest security features, and respond to new and amended standards and protocols. Identity systems must be resilient, because any downtime can have serious consequences for the rest of your solution. In most scenarios, IdP implementation doesn't directly benefit the business, but IdP implementation is necessary in a multitenant service. It's better to use a specialized identity system that experts build, operate, and secure.

If you run your own identity system, you need to store password hashes or other credentials, which creates a vulnerability for cybercriminals. Password hashing and salting are often insufficient, because some cybercriminals can still compromise these credentials.

When you run an identity system, you're responsible for multifactor authentication generation and distribution, or for the distribution of one-time password codes. You also need a mechanism to send these codes via text message or email. You must also detect targeted and brute-force attacks, throttle sign-in attempts, and maintain audit logs.

It's best to use a prebuilt service or component. Consider managed identity platforms like Microsoft Entra ID or External ID. Platform vendors are responsible for infrastructure and operations, and these platforms typically support current identity and authentication standards.

### Failure to consider your tenants' requirements

Tenants often have strong identity-management preferences in the solutions that they use. For example, many enterprise customers require federation with their own IdPs, so that they can use single sign-on and manage only one set of credentials. Other tenants might require multifactor authentication or extra security measures for the sign-in process. Consider these requirements during design because it can be difficult to add them later.

Understand your tenants' identity requirements before you finalize your identity system design. For more information about specific requirements, see [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).

### User and tenant conflation

Consider how your solution defines a user and a tenant. In many scenarios, the relationship can be complex. For example, a tenant might contain multiple users, and a single user might join multiple tenants.

Ensure that you have a clear process for tracking tenant context within your application and requests. In some scenarios, this process requires you to include a tenant identifier in every access token and validate it on each request. In other cases, tenant authorization information and user identities are stored separately. This approach requires a more complex authorization system to manage which users can perform specific operations within each tenant.

You can track the tenant context of a user or token in any [tenancy model](../considerations/tenancy-models.md) because a user identity always has a tenant context within a multitenant solution. It's a good practice to track tenant context when you deploy independent stamps for a single tenant, which future-proofs your codebase for other forms of multitenancy.

### Role and resource authorization conflation

Choose an authorization model that fits your solution. Role-based security is straightforward to implement, but resource-based authorization provides more granular control. Evaluate your tenants' requirements and determine if they need to authorize some users to only access specific parts of your solution.

### Failure to write audit logs

Audit logs help you to understand your environment and how users implement your system. If you audit every identity-related event, you can often determine whether your identity system is under attack, and you can review how your system is being used. Write and store audit logs within your identity system. Consider whether your solution's identity audit logs should be made available for tenant review.

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

- [Architectural considerations for identity in a multitenant solution](../considerations/identity.md)