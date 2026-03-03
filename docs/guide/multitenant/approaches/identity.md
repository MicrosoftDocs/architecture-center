---
title: Architectural Approaches for Identity in Multitenant Solutions
description: This article covers identity management strategies for multitenant solutions, including authentication, authorization, federation, and security considerations.
author: johndowns
ms.author: pnp
ms.date: 05/16/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-saas
---

# Architectural approaches for identity in multitenant solutions

Almost all multitenant solutions require an identity system. This article describes common components of identity, including authentication and authorization, and how you can apply these components in a multitenant solution.

> [!NOTE]
> Before you start to build an identity system for a multitenant solution, see [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).

## Authentication

Authentication is the process that establishes a user's identity. When you build a multitenant solution, consider the various approaches for different aspects of the authentication process.

### Federation

You might need to federate with external identity providers (IdPs). You can use federation to enable the following scenarios:

- Social login, which allows users to sign in with their Google, Facebook, GitHub, or personal Microsoft account

- Tenant-specific directories, which enable tenants to federate your application with their own IdPs so that they don't need to manage accounts in multiple places

For more information, see the [Federated Identity pattern](../../../patterns/federated-identity.yml).

If you choose to support tenant-specific IdPs, ensure that you clarify which services and protocols your application supports. For example, determine whether to support the OpenID Connect protocol and the Security Assertion Markup Language protocol, or whether to limit federation to Microsoft Entra ID instances.

When you implement an IdP, consider scale and limits that might apply. For example, your IdP might be able to federate with only a limited number of other IdPs.

Also consider providing federation as a feature that only applies to customers at a higher [product tier](../considerations/pricing-models.md#feature--and-service-level-based-pricing).

### Single sign-on

Single sign-on enables users to switch between applications seamlessly without being prompted to reauthenticate at each point.

When users visit an application, the application directs them to an IdP. If the IdP detects an existing session, it issues a new token without requiring the users to interact with the sign-in process. A federated identity model supports single sign-on by enabling users to use a single identity across multiple applications.

In a multitenant solution, you might enable another form of single sign-on. If users are authorized to access data across multiple tenants, you might need to provide a seamless experience when the users change their context from one tenant to another. Consider whether your solution needs to support seamless transitions between tenants. If so, consider whether your IdP should reissue tokens with specific tenant claims. For example, when a user signs in to the Azure portal, they can switch between different Microsoft Entra ID directories. This transition triggers reauthentication and generates a new token from the newly selected Microsoft Entra ID instance.

### Sign-in risk evaluation

Modern identity platforms support a risk evaluation during the sign-in process. For example, if a user signs in from an unusual location or device, the authentication system might require extra identity checks, such as multifactor authentication (MFA), before it allows the sign-in request to proceed.

Consider whether your tenants might have different risk policies that need to be applied during the authentication process. For example, if you have some tenants in a highly regulated industry, they might have different risk profiles and requirements than tenants who work in less regulated environments. Or you might allow tenants at higher pricing tiers to specify more restrictive sign-in policies than tenants who purchase a lower tier of your service.

If you need to support different risk policies for each tenant, your authentication system needs to know which tenant the user is signing in to so that it can apply the correct policies.

If your IdP includes these capabilities, consider using the IdP's native sign-in risk evaluation features. These features can be complex and error-prone to implement yourself.

Alternatively, if you federate to the tenants' IdPs, their risky sign-in mitigation policies can be applied, which allows them to control enforcement policies and controls. For example, requiring two MFA challenges, one from the user's home IdP and another from your own, can make the sign-in process more difficult. Ensure that you understand how federation interacts with each of your tenant's IdPs and the policies that they have in place.

### Impersonation

Impersonation enables a user to assume the identity of another user without using that user's credentials.

Impersonation is generally dangerous and can be difficult to implement and control. However, in some scenarios, impersonation is required. For example, if you operate in a software as a service (SaaS) environment, your help desk personnel might need to assume a user's identity so that they can sign in as the user and troubleshoot a problem.

If you implement impersonation, consider how to audit its use. Ensure that your logs include both the user who performed the action and the identifier of the user that they impersonated.

Some identity platforms support impersonation, either as a built-in feature or by using custom code. For example, you can [add a custom claim in Microsoft Entra External ID](/entra/external-id/customers/concept-custom-extensions#token-issuance-start-event) for the impersonated user ID, or you can replace the subject identifier claim in the tokens that are issued.

## Authorization

Authorization is the process of determining what a user is allowed to do.

Authorization data can be stored in several places, including in the following locations:

- **In your IdP:** For example, if you use Microsoft Entra ID as your IdP, you can use features like [app roles](/entra/identity-platform/howto-add-app-roles-in-apps) and [groups](/entra/fundamentals/how-to-manage-groups) to store authorization information. Your application can then use the associated token claims to enforce your authorization rules.

- **In your application:** You can build your own authorization logic and then store information about what each user can do in a database or similar storage system. You can then design fine-grained controls for role-based or resource-level authorization.

In most multitenant solutions, the customer or tenant manages role and permission assignments, and not the vendor of the multitenant system.


### Add tenant identity and role information to tokens

Determine which parts of your solution should handle authorization requests. Evaluate whether to permit a user to access data from a specific tenant.

A common approach is for your identity system to embed a tenant identifier claim into a token. This approach enables your application to inspect the claim and verify that the users are working with the tenant that they're allowed to access. If you use the role-based security model, you might extend the token to include information about the user's role within the tenant.

However, if a single user is allowed to access multiple tenants, you might need a way for your users to signal which tenant they plan to work with during the sign-in process. After the user selects their active tenant, the IdP can issue a token that includes the correct tenant identifier claim and role for that tenant. You also need to consider how users can switch between tenants, which requires issuing a new token.

#### Application-based authorization

An alternative approach is to make the identity system agnostic to tenant identifiers and roles. Users are identified through their credentials or a federation relationship, and tokens don't include a tenant identifier claim. A separate list or database maintains records of which users are granted access to each tenant. The application tier then verifies whether a specified user is authorized to access data for a specific tenant based on that list.

<a name='use-azure-ad-or-azure-ad-b2c'></a>
<a name='use-microsoft-entra-id-or-azure-ad-b2c'></a>

## Use Microsoft Entra ID or External ID

Microsoft Entra ID and External ID are managed identity platforms that you can use within your own multitenant solution.

Many multitenant solutions operate as SaaS. Your choice to use Microsoft Entra ID or External ID depends partly on how you define your tenants or customer base.

- If your tenants or customers are organizations, they might already use Microsoft Entra ID for services like Microsoft 365, Microsoft Teams, or for their own Azure environments. You can create a [multitenant application](/entra/identity-platform/single-and-multi-tenant-apps) in your own Microsoft Entra ID directory to make your solution available to other Microsoft Entra ID directories. You can also list your solution in the [Microsoft Marketplace](https://marketplace.microsoft.com) and make it easily accessible to organizations that use Microsoft Entra ID.

- If your tenants or customers don't use Microsoft Entra ID, or if they're individuals instead of organizations, consider using External ID. External ID provides features to control how users sign up and sign in. For example, you can restrict access to your solution to only the users that you invite, or you can enable self-service sign-up. You can use [custom branding](/entra/external-id/customers/how-to-customize-branding-customers). To enable your own staff to sign in, you can [invite users from your Microsoft Entra ID tenant as guests into the External ID via guest access](/entra/external-id/b2b-quickstart-add-guest-users-portal). External ID also enables [federation with other IdPs](/entra/external-id/customers/concept-authentication-methods-customers).

- Some multitenant solutions are intended for both previously listed scenarios. Some tenants might have their own Microsoft Entra ID tenants and other tenants might not. You can use External ID for this scenario, and [use federation to allow user sign-in from a tenant's Microsoft Entra ID directory](/entra/external-id/customers/concept-authentication-methods-customers).

> [!IMPORTANT]
> Azure AD B2C also supports many of the scenarios in this article. However, as of May 1, 2025, it's no longer available to purchase for new customers, so we don't recommend it for new solutions. For more information, see [Azure AD B2C FAQ](/azure/active-directory-b2c/faq#azure-ad-b2c-end-of-sale).

## Antipatterns to avoid

### Building or running your own identity system

Building a modern identity platform is complex. It requires support for a range of protocols and standards, and an incorrect implementation can introduce security vulnerabilities. Because standards and protocols change, you need to continually update your identity system to mitigate attacks and incorporate the latest security features. It's also important to ensure that an identity system is resilient because any downtime can have serious consequences for the rest of your solution. In most scenarios, implementing an IdP doesn't directly benefit the business, but it's necessary for implementing a multitenant service. It's better to use a specialized identity system that experts build, operate, and secure.

When you run your own identity system, you need to store password hashes or other forms of credentials, which become a tempting target for attackers. Even hashing and salting passwords is often insufficient protection because attackers have enough computational power to potentially compromise these credentials.

When you run an identity system, you're responsible for generating and distributing MFA or one-time password codes. You need a mechanism to send these codes via SMS or email. You're also responsible for detecting targeted and brute-force attacks, throttling sign-in attempts, and maintaining audit logs.

Instead of building or managing your own identity system, it's best to use a prebuilt service or component. For example, consider managed identity platforms like Microsoft Entra ID or External ID. Vendors of these platforms are responsible for operating the infrastructure and typically ensure support for current identity and authentication standards.

### Failing to consider your tenants' requirements

Tenants often have strong preferences about how to manage identity in the solutions that they use. For example, many enterprise customers require federation with their own IdPs to enable single sign-on and avoid managing multiple sets of credentials. Other tenants might require MFA or extra security measures for the sign-in process. If you don't consider these requirements during design, adding them later can be difficult.

Ensure that you understand your tenants' identity requirements before you finalize the design of your identity system. For more information about specific requirements, see [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).

### Conflating users and tenants

It's important to clearly consider how your solution defines a user and a tenant. In many scenarios, the relationship can be complex. For example, a tenant might contain multiple users, and a single user might join multiple tenants.

Ensure that you have a clear process for tracking tenant context within your application and requests. In some scenarios, this process requires you to include a tenant identifier in every access token and validate it on each request. In other cases, tenant authorization information is stored separately from user identities. This approach requires a more complex authorization system to manage which users can perform specific operations within each tenant.

Tracking the tenant context of a user or token is applicable to any [tenancy model](../considerations/tenancy-models.md) because a user identity always has a tenant context within a multitenant solution. It's a good practice to track tenant context when you deploy independent stamps for a single tenant, which future-proofs your codebase for other forms of multitenancy.

### Conflating role and resource authorization

It's important to choose an authorization model that fits your solution. Role-based security is simple to implement, but resource-based authorization provides more fine-grained control. Evaluate your tenants' requirements and determine if they need to authorize some users to only access specific parts of your solution.

### Failing to write audit logs

Audit logs are an important tool for understanding your environment and how users implement your system. By auditing every identity-related event, you can often determine whether your identity system is under attack, and you can review how your system is being used. Ensure that you write and store audit logs within your identity system. Consider whether your solution's identity audit logs should be made available to tenants to review.

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
