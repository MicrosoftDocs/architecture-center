---
title: Architectural approaches for identity in multitenant solutions
titleSuffix: Azure Architecture Center
description: This article describes the approaches for managing identities in a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 05/08/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
  - azure-active-directory
  - azure-active-directory-b2c
categories:
  - identity
ms.category:
  - fcp
ms.custom:
  - guide
---

# Architectural approaches for identity in multitenant solutions

Almost all multitenant solutions require an identity system. In this article, we discuss common components of identity, including both authentication and authorization, and discuss how these can be applied in a multitenant solution.

> [!NOTE]
> Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md) to learn more about the key requirements and decisions you need to make before you start to build an identity system for a multitenant solution.

## Authentication

Authentication is the process by which a user's identity is established. When you build a multitenant solution, there are special considerations and approaches for several aspects of the authentication process.

### Federation

You might need to federate with other identity providers. Federation can be used to enable several scenarios, including:

- Social login, such as by enabling users to use a Google or personal Microsoft account.
- Tenant-specific directories, such as by enabling tenants to federate your application with their own identity providers so they don't need to manage accounts in multiple places.

For general information about federation, see the [Federated Identity pattern](../../../patterns/federated-identity.yml).

If you choose to support tenant-specific identity providers, ensure you clarify which services and protocols you need to support. For example, will you support the OpenID Connect protocol as well as the Security Assertion Markup Language (SAML) protocol? Or, will you only support federating with Azure Active Directory instances?

When you build your own identity provider, consider any scale and limits that might apply. For example, if you use Azure Active Directory (Azure AD) B2C as your own identity provider, you might need to deploy custom policies to federate with certain types of tenant identity providers. Azure AD B2C limits the number of custom policies that you can deploy, which might limit the number of tenant-specific identity providers that you can federate with.

You can also consider providing federation as a feature that only applies to customers at a higher [product tier](../considerations/pricing-models.md#feature--and-service-level-based-pricing).

### Single sign-on

Single sign-on experiences enable users to move between applications seamlessly, without being prompted to reauthenticate at each point.

When a user visits an application, the application directs them to an identity provider, which has access to their existing login session and issues a new token for the current application without requiring the user to interact with the login process. A federated identity model support single sign-on experiences by enabling users to use a single identity across multiple applications.

In a multitenant solution, you might also enable another form of single sign on. If a user is authorized to work with data for multiple tenants, you might need to provide a seamless experience when the user changes their context from one tenant to another. Consider whether you need to support seamless transitions between tenants, and if so, whether your identity provider needs to reissue tokens with specific tenant claims.

### Sign-in risk evaluation

Modern identity platforms support risk evaluation during the sign-in process. For example, if a user signs in from an unusual location or device, the authentication system might require additional identity checks, such as MFA, before allowing the sign-in request to proceed.

Consider whether your tenants might have different risk policies that need to be applied during the authentication process. For example, if you have some tenants in a highly regulated industry, they might have different risk profiles and requirements to tenants who work in less regulated environments. Or, you might choose to allow tenants at higher pricing tiers to specify more restrictive sign-in policies than tenants who purchase a lower tier of your service.

If you need to support different risk policies for each tenant, your authentication system needs to know which tenant the user is signing into so that the correct policies can be applied.

Alternatively, if you federate to tenants' own identity providers, then their own risky sign-in mitigation policies can be applied, and they can control the policies and controls that should be enforced.

### Impersonation

Impersonation enables a user to assume the identity of another user without using that user's credentials.

In general, impersonation is dangerous, and it can be difficult to implement and control. However, in some scenarios, impersonation is a requirement. For example, if you operate software as a service (SaaS), your helpdesk personnel might need to assume a user's identity so that they can sign in as the user and troubleshoot an issue.

Some identity platforms support impersonation, either as a built-in feature or through the use of custom code. For example, [Azure AD B2C provides a sample implementaton of an impersonation flow](https://github.com/azure-ad-b2c/samples/tree/master/policies/impersonation).

### Token enrichment and authentication flow customization

In a multitenant solution, you might need to integrate your authentication processes with tenants' systems. Integration can happen for several purposes, including injecting custom claims into a login token (*token enrichment*), or triggering events in a tenant's own systems.

Whenever you integrate with a tenant's system, it's a good practice to build a common integration approach instead of trying to build customized integration approaches for each tenant. For example, if your tenants need to enrich token claims, you might define an API that each tenant must implement, with a specific payload format. You can then agree to send a request to that tenant's API during each sign-in, and the tenant agrees to send a response with another specified payload format, which you then turn into a set of claims to add to the token.

## Authorization

Authorization is the process of determining what a user is allowed to do.

Authorization can be implemented in several places, including:

- **In your identity provider.** For example, if you use Azure AD as your identity provider, features like [app roles](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps) and [groups](/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal) can be used to enforce authorization rules.
- **In your application.** You can build your own authorization logic, and store information about what each user can do in a database or similar storage system.

In a multitenant solution, roles are generally assigned and managed by the tenant or customer, not by you as the vendor of the multitenant system.

For more information, see [Application roles](../../../multitenant-identity/app-roles.md).

### Add tenant identity and role information to tokens

Consider which part, or parts, of your solution should perform authorization requests, including determining whether a user is allowed to work with data from a specific tenant.

A common approach is for your identity system to embed a tenant identifier claim into a token. This enables your application to inspect the claim and verify that the user is working with the tenant that they are allowed to access. If you use the role-based security model, then you might choose to extend the token with information about the role a user has within the tenant.

However, if a single user is allowed to access multiple tenants, you might need to provide a way for your users to signal which tenant they plan to work with during the login process so that the token can include the correct tenant identifier claim and role for that tenant. You also need to consider how users can switch between tenants, which requires issuing a new token.

#### Application-based authorization

An alternative approach is to make the identity system agnostic to tenant identifiers and roles. Each user is identified using their credentials or a federation relationship, and tokens don't include a tenant identifier claim. A separate list or database contains which users have been granted access to each tenant. Then, the application tier can verify whether the specified user should be allowed to access the data for a specific tenant based on looking up that list.

## Next steps

Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md).
