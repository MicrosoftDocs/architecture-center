---
title: Architectural approaches for identity
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

# Architectural approaches for identity

Almost all multitenant solutions require an identity system. In this article, we discuss common components of identity, including both authentication and authorization, and discuss how these can be applied in a multitenant solution.

> [!NOTE]
> Review [Architectural considerations for identity in a multitenant solution](../considerations/identity.md) to learn more about the key requirements and decisions you need to make before you start to build an identity system for a multitenant solution.

## Authentication

Authentication is the process by which a user's identity is established. When you build a multitenant solution, there are special considerations and approaches for several aspects of the authentication process.

### Federation

You might need to federate with other identity providers. Federation can be used to enable several scenarios, including:

- Social login, such as by enabling users to use a Google or personal Microsoft account.
- Tenant-speciifc directories, such as by enabling tenants to federate your application with their own identity providers so they don't need to manage accounts in multiple places.

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

### Claim enrichment and authentication flow customization
- Do you need to integrate your authentication processes with tenants' systems?
- e.g. retrieving a loyalty number from the tenant's API, or to trigger events in your tenant's system
- If this is per-tenant, need to manage it - e.g. common APIs that each tenant must implement, and we'll call it with payload X and you need to send payload Y



## Authorization

- There are several approaches for authorization, including:
  - Using AAD's features, like app roles and groups.
  - Building your own authorization system into your application and storing the rules in a database or similar.
- Talk about pros and cons of each. (Consider reusing some of the points here: https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/app-roles)
- Roles are generally assigned and managed by the customer, not you (the vendor of the multitenant system).
- Decide whether you use role-based authorization or resource-based authorization (https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/authorize) - this decision is probably worthy of its own section in a higher-level considerations page.

### Tenant/user relationship
- Should there be a 1:1 or 1:many relationship between user and tenant?
   - Org that needs multiple tenants - e.g. finance team tenant and a separate legal tenant. Should identities be consistent or separate?
   - User that needs to access multiple tenants (e.g. teacher at school A, parent at school B)
- This leads to considerations like - do you embed a tenant ID in a token, prompt the user to select a tenant during sign-in, or leave that entirely to the application to figure out. When to decide to do this

### API-based authorization

- RESTful API-based systems can use this.
- Can handle authorization by considering:
  - Request user identity (e.g. subject claim from token) - who is making the request
  - Request verb (e.g. GET, PUT, POST, DELETE) - what they're trying to do to the resource
  - Requested resource (e.g. api.contoso.com/tenants/tenantA/calendars/mycal, or tenanta.contoso.com/calendars/mycal) - what they're trying to access
  - Authorisation rules and permission list (e.g. "user X is allowed to read all data for tenant A")
- This turns the problem into mostly a string-matching exercise

## Management and automation
- Tenant lifecycle management
  - Onboarding new tenants to your identity platform - is there anything manual required (e.g. for establishing federation/trust, customising policies)?
  - Offboarding tenants - what data should you delete, and how? Do you need to maintain some data/logs for compliance purposes?
- User lifecycle management
  - Consider how users will be onboarded, and assigned roles. Will this all be achieved through federation? If you use local accounts, how do you keep this in sync - or do you even need to?
  - Can consider using SCIM to respond to changes in federated tenants. AAD implements this (https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/sync-scim). This can be useful for multitenant scenarios where you need to do some work on your side whenever a customer adds a new user. Similarly for when users are deleted. But it require a lot of work to integrate.

## Antipatterns to avoid

- **Building your own identity platform.** Follow the [Federated Identity pattern](https://docs.microsoft.com/azure/architecture/patterns/federated-identity).

## Next steps

Links to other relevant pages within our section.
