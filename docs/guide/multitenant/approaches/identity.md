---
title: Architectural approaches for identity in multitenant solutions
description: This article describes the approaches for managing identities in a multitenant solution.
author: johndowns
ms.author: pnp
ms.date: 05/16/2025
ms.topic: conceptual
ms.subservice: architecture-guide
products:
  - azure
  - entra-id
  - entra-external-id
categories:
  - identity
ms.custom:
  - guide
  - arb-saas
---

# Architectural approaches for identity in multitenant solutions

Almost all multitenant solutions require an identity system. In this article, we discuss common components of identity, including both authentication and authorization, and we discuss how these components can be applied in a multitenant solution.

> [!NOTE]
> Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md) to learn more about the key requirements and decisions that you need to make, before you start to build an identity system for a multitenant solution.

## Authentication

Authentication is the process by which a user's identity is established. When you build a multitenant solution, there are special considerations and approaches for several aspects of the authentication process.

### Federation

You might need to federate with other identity providers (IdPs). Federation can be used to enable the following scenarios:

- Social login, such as by enabling users to use their Google, Facebook, GitHub, or personal Microsoft account.
- Tenant-specific directories, such as by enabling tenants to federate your application with their own identity providers, so they don't need to manage accounts in multiple places.

For general information about federation, see the [Federated Identity pattern](../../../patterns/federated-identity.yml).

If you choose to support tenant-specific identity providers, ensure you clarify which services and protocols you need to support. For example, will you support the OpenID Connect protocol and the Security Assertion Markup Language (SAML) protocol? Or, will you only support federating with Microsoft Entra instances?

When you implement any identity provider, consider any scale and limits that might apply. For example, your identity provider might be only able to federate with a limited number of other identity providers.

You can also consider providing federation as a feature that only applies to customers at a higher [product tier](../considerations/pricing-models.md#feature--and-service-level-based-pricing).

### Single sign-on

Single sign-on experiences enable users to switch between applications seamlessly, without being prompted to reauthenticate at each point.

When users visit an application, the application directs them to an IdP. If the IdP sees they have an existing session, it issues a new token without requiring the users to interact with the login process. A federated identity model support single sign-on experiences, by enabling users to use a single identity across multiple applications.

In a multitenant solution, you might also enable another form of single sign-on. If users are authorized to work with data for multiple tenants, you might need to provide a seamless experience when the users change their context from one tenant to another. Consider whether you need to support seamless transitions between tenants, and if so, whether your identity provider needs to reissue tokens with specific tenant claims. For example, a user who signed into the Azure portal can switch between different Microsoft Entra directories, which causes reauthentication, and it reissues the token from the newly selected Microsoft Entra instance.

### Sign-in risk evaluation

Modern identity platforms support a risk evaluation during the sign-in process. For example, if a user signs in from an unusual location or device, the authentication system might require extra identity checks, such as multifactor authentication (MFA), before it allows the sign-in request to proceed.

Consider whether your tenants might have different risk policies that need to be applied during the authentication process. For example, if you have some tenants in a highly regulated industry, they might have different risk profiles and requirements to tenants who work in less regulated environments. Or, you might choose to allow tenants at higher pricing tiers to specify more restrictive sign-in policies than tenants who purchase a lower tier of your service.

If you need to support different risk policies for each tenant, your authentication system needs to know which tenant the user is signing into, so that it can apply the correct policies.

If your IdP includes these capabilities, consider using the IdP's native sign-in risk evaluation features. These features can be complex and error-prone to implement yourself.

Alternatively, if you federate to tenants' own identity providers, then their own risky sign-in mitigation policies can be applied, and they can control the policies and controls that should be enforced. However, it's important to avoid inadvertently adding unnecessary burden to the user, such as by requiring two MFA challenges - one from the user's home identity provider and one from your own. Ensure you understand how federation interacts with each of your tenants' identity providers and the policies they've applied.

### Impersonation

Impersonation enables a user to assume the identity of another user, without using that user's credentials.

In general, impersonation is dangerous, and it can be difficult to implement and control. However, in some scenarios, impersonation is a requirement. For example, if you operate software as a service (SaaS), your helpdesk personnel might need to assume a user's identity, so that they can sign in as the user and troubleshoot an issue.

If you choose to implement impersonation, consider how you audit its use. Ensure that your logs include both the actual user who performed the action and the identifier of the user they impersonated.

Some identity platforms support impersonation, either as a built-in feature or by using custom code. For example, [in Microsoft Entra External ID, you can add a custom claim](/entra/external-id/customers/concept-custom-extensions#token-issuance-start-event) for the impersonated user ID, or you can replace the subject identifier claim in the tokens that are issued.

## Authorization

Authorization is the process of determining what a user is allowed to do.

Authorization data can be stored in several places, including in the following locations:

- **In your identity provider.** For example, if you use Microsoft Entra ID as your identity provider, you can use features like [app roles](/entra/identity-platform/howto-add-app-roles-in-apps) and [groups](/entra/fundamentals/how-to-manage-groups) to store authorization information. Your application can then use the associated token claims to enforce your authorization rules.
- **In your application.** You can build your own authorization logic, and then store information about what each user can do in a database or similar storage system. You can then design fine-grained controls for role-based or resource-level authorization.

In most multitenant solutions, role and permission assignments are managed by the tenant or customer, not by you as the vendor of the multitenant system.

For more information, see [Application roles](../../../multitenant-identity/app-roles.md).

### Add tenant identity and role information to tokens

Consider which part, or parts, of your solution should perform authorization requests, including determining whether a user is allowed to work with data from a specific tenant.

A common approach is for your identity system to embed a tenant identifier claim into a token. This approach enables your application to inspect the claim and verify that the users are working with the tenant that they're allowed to access. If you use the role-based security model, then you might choose to extend the token with information about the role a user has within the tenant.

However, if a single user is allowed to access multiple tenants, you might need a way for your users to signal which tenant they plan to work with during the login process. After they select their active tenant, the IdP can include the correct tenant identifier claim and role for that tenant, within the token it issues. You also need to consider how users can switch between tenants, which requires issuing a new token.

#### Application-based authorization

An alternative approach is to make the identity system agnostic to tenant identifiers and roles. The users are identified using their credentials or a federation relationship, and tokens don't include a tenant identifier claim. A separate list or database contains which users have been granted access to each tenant. Then, the application tier can verify whether the specified user should be allowed to access the data for a specific tenant, based on looking up that list.

<a name='use-azure-ad-or-azure-ad-b2c'></a>
<a name='use-microsoft-entra-id-or-azure-ad-b2c'></a>

## Use Microsoft Entra ID or Microsoft Entra External ID

Microsoft provides Microsoft Entra ID and Microsoft Entra External ID, which are managed identity platforms that you can use within your own multitenant solution.

Many multitenant solutions are software as a service (SaaS). Your choice of whether to use Microsoft Entra ID or Microsoft Entra External ID depends, in part, on how you define your tenants or customer base.

- If your tenants or customers are organizations, they might already use Microsoft Entra ID for services like Microsoft 365, Microsoft Teams, or for their own Azure environments. You can create a [multitenant application](/entra/identity-platform/single-and-multi-tenant-apps) in your own Microsoft Entra directory to make your solution available to other Microsoft Entra directories. You can even list your solution in the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/azure-active-directory-apps) and make it easily accessible to organizations who use Microsoft Entra ID.
- If your tenants or customers don't use Microsoft Entra ID, or if they're individuals rather than organizations, then consider using Microsoft Entra External ID. Microsoft Entra External ID provides features to control how users sign up and sign in. For example, you can restrict access to your solution just to users that you've already invited, or you might allow for self-service sign-up. You can use [custom branding](/entra/external-id/customers/how-to-customize-branding-customers), and you can [invite users from your Microsoft Entra ID tenant as guests into the Microsoft External ID via guest access](/entra/external-id/b2b-quickstart-add-guest-users-portal), to enable your own staff to sign in. Microsoft Entra External ID also enables [federation with other identity providers](/entra/external-id/customers/concept-authentication-methods-customers).
- Some multitenant solutions are intended for both situations listed above. Some tenants might have their own Microsoft Entra tenants, and others might not. You can use Microsoft Entra External ID for this scenario, and use [federation to allow user sign-in from a tenant's Microsoft Entra directory](/entra/external-id/customers/concept-authentication-methods-customers).

> [!IMPORTANT]
> Azure AD B2C also supports many of the scenarios described in this article. However, as of May 1, 2025, it will no longer be available to purchase for new customers, so it is not recommended for new solutions. [Learn more in the Azure AD B2C FAQ](/azure/active-directory-b2c/faq#azure-ad-b2c-end-of-sale).

## Antipatterns to avoid

### Building or running your own identity system

Building a modern identity platform is complex. There are a range of protocols and standards to support, and it's easy to incorrectly implement a protocol and expose a security vulnerability. Standards and protocols change, and you also need to continually update your identity system to mitigate attacks and to support recent security features. It's also important to ensure that an identity system is resilient, because any downtime can have severe consequences for the rest of your solution. Additionally, in most situations, implementing an identity provider doesn't add a benefit to the business, and it's simply a necessary part of implementing a multitenant service. It's better to instead use a specialized identity system that's built, operated, and secured by experts.

When you run your own identity system, you need to store password hashes or other forms of credentials, which become a tempting target for attackers. Even hashing and salting passwords is often insufficient protection, because the computational power that's available to attackers can make it possible to compromise these forms of credentials.

When you run an identity system, you're also responsible for generating and distributing MFA or one-time password (OTP) codes. These requirements then mean you need a mechanism to distribute these codes, by using SMS or email. Furthermore, you're responsible for detecting both targeted and brute-force attacks, throttling sign-in attempts, auditing, and so on.

Instead of building or running your own identity system, it's a good practice to use an off-the-shelf service or component. For example, consider using Microsoft Entra ID or Microsoft Entra External ID, which are managed identity platforms. Managed identity platform vendors take responsibility to operate the infrastructure for their platforms, and typically to support the current identity and authentication standards.

### Failing to consider your tenants' requirements

Tenants often have strong opinions about how identity should be managed for the solutions they use. For example, many enterprise customers require federation with their own identity providers, to enable single sign-on experiences and to avoid managing multiple sets of credentials. Other tenants might require multifactor authentication, or other forms of protection around the sign-in processes. If you haven't designed for these requirements, it can be challenging to retrofit them later.

Ensure you understand your tenants' identity requirements, before you finalize the design of your identity system. Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md), to understand some specific requirements that often emerge.

### Conflating users and tenants

It's important to clearly consider how your solution defines a user and a tenant. In many situations, the relationship can be complex. For example, a tenant might contain multiple users, and a single user might join multiple tenants.

Ensure you have a clear process for tracking the tenant context, within your application and requests. In some situations, this process might require you to include a tenant identifier in every access token, and for you to validate the tenant identifier on each request. In other situations, you store the tenant authorization information separately from the user identities, and you use a more complex authorization system, to manage which users can perform which operations against which tenants.

Tracking the tenant context of a user or token is applicable to any [tenancy model](../considerations/tenancy-models.yml), because a user identity always has a tenant context within a multitenant solution. It's even a good practice to track tenant context when you deploy independent stamps for a single tenant, which future-proofs your codebase for other forms of multitenancy.

### Conflating role and resource authorization

It's important that you select an appropriate authorization model for your solution. Role-based security approaches can be simple to implement, but resource-based authorization provides more fine-grained control. Consider your tenants' requirements, and whether your tenants need to authorize some users to access specific parts of your solution, and not other parts.

### Failing to write audit logs

Audit logs are an important tool for understanding your environment and how users are implementing your system. By auditing every identity-related event, you can often determine whether your identity system is under attack, and you can review how your system is being used. Ensure you write and store audit logs within your identity system. Consider whether your solution's identity audit logs should be made available to tenants to review.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure
  
Other contributors:

- [Jelle Druyts](https://linkedin.com/in/jelle-druyts-0b76823) | Principal Customer Engineer, FastTrack for Azure
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Senior Customer Engineer
- [Sander van den Hoven](https://linkedin.com/in/azurehero) | Senior Partner Technology Strategist
- [Nick Ward](https://linkedin.com/in/nickward13) | Senior Cloud Solution Architect

## Next steps

Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).
