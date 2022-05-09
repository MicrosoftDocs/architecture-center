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

## Key considerations and requirements

### Authentication in multitenant systems

#### Federation
 - Applies particularly to B2B solutions, but also to B2C solutions when you use social identities.
 - e.g. if you customer is an enterprise and they bring their own identities for SSO, you need to federate to their directory
 - Which types of directories will you support? Your tenants might be in AAD, or in Okta/Auth0/Ping (or some other weird and wonderful IdP). Clarify which protocols you'll support.
 - Be careful around limits and scale. If you have hundred of tenants, will you be able to federate with each one?
    - AAD B2C limits it to 200. 
    - **Q: Will the common endpoint work around this for federating to AAD tenants?**
    - Can you shard - this is very complex.
    - **Q: Can we find any large B2C customers/case studies who use multiple B2C tenants for sharding/federating, and spread their load across them?**
 - You can often combine both, and allow both local and federated accounts. You might even provide federation as a value-add (e.g. in a higher product tier).

#### SSO
- Will you support SSO?
- Will this apply when a user authenticates using their home tenant identity?
- Will this apply when a user switches between tenants?

#### Sign-in risk
- Do you need to support different identity/risk policies for different tenants, e.g. based on tenant settings, product tiers, etc?
- If you federate to your customers' IdPs, presumably your customers will also have their own sign-in risk mitigations (e.g. they might require MFA before your solution ever sees the authentication request).

#### Claim enrichment and authentication flow customization
- Do you need to integrate your authentication processes with tenants' systems?
- e.g. retrieving a loyalty number from the tenant's API, or to trigger events in your tenant's system
- If this is per-tenant, need to manage it - e.g. common APIs that each tenant must implement, and we'll call it with payload X and you need to send payload Y

#### Impersonation
- Extremely dangerous
- Use cases - call centre support person (user B) needs to assume user A's identity to help troubleshoot an issue
- [B2C sample to show this](https://github.com/azure-ad-b2c/samples/tree/master/policies/impersonation).

### Authorization in multitenant systems

#### Tenant/user relationship
- Should there be a 1:1 or 1:many relationship between user and tenant?
   - Org that needs multiple tenants - e.g. finance team tenant and a separate legal tenant. Should identities be consistent or separate?
   - User that needs to access multiple tenants (e.g. teacher at school A, parent at school B)
- This leads to considerations like - do you embed a tenant ID in a token, prompt the user to select a tenant during sign-in, or leave that entirely to the application to figure out. When to decide to do this

#### Tenant token trust and validation
- Do all tenants trust all tokens issued by your IdP?
- Will you allow tenant A to different policies than tenant B? e.g. IP address requirements, MFA policies, trusted devices, token lifetimes, which identity platform they signed into, etc?
- How will your application handle this if a user has a token that was valid with tenant A but isn't valid for tenant B? Can the user token be upgraded? Be careful of login loops.

#### Authorization approaches
- There are several approaches for authorization, including:
  - Using AAD's features, like app roles and groups.
  - Building your own authorization system into your application and storing the rules in a database or similar.
- Talk about pros and cons of each. (Consider reusing some of the points here: https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/app-roles)
- Roles are generally assigned and managed by the customer, not you (the vendor of the multitenant system).
- Decide whether you use role-based authorization or resource-based authorization (https://docs.microsoft.com/en-us/azure/architecture/multitenant-identity/authorize) - this decision is probably worthy of its own section in a higher-level considerations page.

#### Application-side autborization
- Can tenants manage their own users' authorization rules, e.g. by using a self-service console?
- Or, does everybody in the tenant have the same access?

#### Delegation
- e.g. I'm building a SaaS calendar system, and I want my users to be able to give their assistants access to it
- Effectively just an AuthZ problem

### Auditing and reporting
 - for billing, auditing
 - broken down by tenant/user?
 - Do you provide access to tenants?

### Management and automation
- Tenant lifecycle management
  - Onboarding new tenants to your identity platform - is there anything manual required (e.g. for establishing federation/trust, customising policies)?
  - Offboarding tenants - what data should you delete, and how? Do you need to maintain some data/logs for compliance purposes?
- User lifecycle management
  - Consider how users will be onboarded, and assigned roles. Will this all be achieved through federation? If you use local accounts, how do you keep this in sync - or do you even need to?
  - Can consider using SCIM to respond to changes in federated tenants. AAD implements this (https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/sync-scim). This can be useful for multitenant scenarios where you need to do some work on your side whenever a customer adds a new user. Similarly for when users are deleted. But it require a lot of work to integrate.

### Entitlements and licensing
- Do you have different user license types for different users? How will you enforce this, e.g. assign licenses to users?
- Is this handled by the authZ system?

## Approaches and patterns to consider

### Federated Identity pattern

- [Federated Identity pattern](https://docs.microsoft.com/azure/architecture/patterns/federated-identity)

### API-based authorization

- RESTful API-based systems can use this.
- Can handle authorization by considering:
  - Request user identity (e.g. subject claim from token) - who is making the request
  - Request verb (e.g. GET, PUT, POST, DELETE) - what they're trying to do to the resource
  - Requested resource (e.g. api.contoso.com/tenants/tenantA/calendars/mycal, or tenanta.contoso.com/calendars/mycal) - what they're trying to access
  - Authorisation rules and permission list (e.g. "user X is allowed to read all data for tenant A")
- This turns the problem into mostly a string-matching exercise

## Antipatterns to avoid

- **Building your own identity platform.** Follow the [Federated Identity pattern](https://docs.microsoft.com/azure/architecture/patterns/federated-identity).

## Next steps

Links to other relevant pages within our section.
