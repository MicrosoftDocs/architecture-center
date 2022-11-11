---
title: Azure Active Directory B2C considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes different considerations and approaches for using Azure Active Directory B2C in a multitenant architecture. 
author: landonpierce
ms.author: landonpierce 
ms.date: 11/11/2022 
ms service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-active-directory-b2c
categories:
 - web 
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---
Azure Active Directory B2C (Azure AD B2C) provides business-to-consumer identity as a service. An identity solution for a multitenant application is typically one of the biggest considerations when designing your application. Your identity solution will serve as the gatekeeper to your application, ensuring your tenants stay within the boundaries that you define for them. In this article, we describe different considerations and approaches for using Azure AD B2C in a multitenant solution.

If you are brand new to this topic, please review the following recommended resources to assist in building some foundational knowledge required to understand the concept laid out in this document:

  - [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
  - [Identity Approaches](../approaches/identity#authorization)
  - [Identity Considerations](../considerations/identity)
  - [Tenancy Models](../considerations/tenancy-models)

> [!NOTE]
> In this article, we will be discussing two very closely named topics: application tenants and Azure AD B2C tenants.
>
> We use the term *application tenant* to refer to **your** tenants, which might be your customers or groups of users.
>
> Azure AD B2C (B2C) also includes the concept of a tenant to refer to individual directories, and it uses the term *multitenancy* to refer to interactions between multiple B2C tenants. Although the terms are the same, the concepts are not. When we refer to an Azure AD B2C tenant in this article, we disambiguate it by using the full term *B2C tenant*.

## Isolation Models

- When working with Azure AD B2C, you need to decide how you are going to isolate your user pools from different application tenants.
- You need to consider things like:
  - Is the user going to need to access more than one application tenant?
  - Do you need complex permissions and/or Role Based Access Control (RBAC?)
  - Do you need to federate logins to your customer's Identity Provider(s)? (SAML, Azure Active Directory, Social Logins, etc)
  - Do you have data residency requirements?
  - What are your user personas? (ie who is logging into your software?)

The following table summarizes the differences between the main tenancy models for Azure AD B2C: 

| Consideration | Shared B2C tenant | B2C tenant per application tenant | Vertically partitioned B2C tenant |
|-|-|-|-|
| **Data isolation** | Low | High | Medium |
| **Deployment complexity** | Low | High | Medium to High, depending on your partition strategy |
| [**Limits to consider**](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow#userconsumption-related-limits) | Requests per B2C tenant and per IP | Number of B2C tenants per subscription, Maximum number of directories for a single user | A combination of requests, number of B2C tenants per subscription, and number of directories for a single user, depending on your partition strategy |
| **Operational complexity** | Low | High | Medium to high, depending on your partition strategy |
| **Example scenario** | You do not have any strict data residency requirements | You need to support a high degree of separation between your application tenants| You need to meet data residency requirements or you'd like to enable custom federated identity providers for some or all of your application tenants |

### Shared B2C tenant

Using a single, shared B2C tenant is generally the easiest isolation model to manage if your requirements allow for it. There is only one tenant that you must maintain long term and comes with the lowest amount of overhead. A shared B2C tenant should be considered if the following apply to your scenario:

- You do not have data residency or data isolation requirements
- You only have local accounts or only have a small number of federated identity providers or social logins you'd like to support (ie you do not need to allow each of your customers to bring a custom identity provider)
- You are okay with your customers using a common login page
- Your end users need access to more than one application tenant under the same account
- Your application needs are within the Azure AD B2C service [limits](/azure/active-directory-b2c/service-limits?pivots=b2c-custom-policy#userconsumption-related-limits)

### B2C tenant per customer

Provisioning a B2C tenant per customer allows for more customization per tenant to be done, but comes at the cost of significantly increased overhead. You must consider how you will plan for and manage this type of deployment and upkeep long term. You will need a strategy to manage things such as policy deployments, key and certificate rotation, and more across a large number of tenants. Additionally, there are several service limits that you must keep in mind. Azure subscriptions have a default [limit](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow#azure-ad-b2c-configuration-limits) of 20 B2C tenants per subscription. If you have more than this, you will also need to consider an appropriate [subscription design pattern](/azure/cloud-adoption-framework/decision-guides/subscriptions/) to allow you to "load balance" your customers onto more than one subscription. Please also keep in mind that there are 2 important [Azure AD limits](/azure/active-directory/enterprise-users/directory-service-limits-restrictions) that apply as well: A single user can only create up to 200 directories, and can only belong to 500 directories.

Provisioning a B2C tenant per customer should be considered if the following apply to your scenario:

- You have very high data isolation requirements between application tenants
- You need to perform custom configuration for *every* application tenant 
- Your application is or can be "tenant aware" and knows which B2C tenant your users will need to sign into
- Your end users do not need access to more than one application tenant under the same account
- You have a strategy planned for deploying and [maintaining](#maintenance-overhead) a large number of B2C tenants long term
- You have a strategy planned for sharding your customers between one or more Azure subscriptions to work within the 20 B2C tenant limit per subscription

### Vertically partitioned B2C tenants

Provisioning vertically partitioned B2C tenants is a strategy designed to minimize the number of B2C tenants needed where possible. It is a "middle ground" between the other tenancy models that offers greater flexibility in customization between tenants where required, while offering a decreased level of overhead from provisioning a tenant per customer. A key note here is that, while you are minimizing the number of tenants and, thus, the overhead required to maintain them, the maintenance requirements are still higher than a single B2C tenant. As such, you will still need a strategy for deploying and maintaining multiple tenants across your environment.

If you are familiar with the [data sharding pattern](/azure/architecture/patterns/sharding), this strategy should appear familiar to you. To vertically partition your B2C tenants, you will need to figure out how to organize your customers into logical groupings. This grouping can be many different things: region, size, custom requirements, etc. For example, if you are grouping by size, you could choose to have most of your customers reside on a single B2C tenant, while having your largest customers reside on their own dedicated B2C tenant. Or, if you are aiming to solve your data residency requirements, you could choose to have one B2C tenant for each region you have customers in.

You should consider provisioning your B2C tenants using a vertically partitioned strategy if the following apply to your scenario:

- You have data residency requirements and/or need to separate your users by geography
- You need to enable your customers to bring their own custom federated identity provider via SAML or OpenID Connect
- Your application is or can be "tenant aware" and knows which B2C tenant your users will need to sign into
- You are concerned about your larger customers hitting one of the Azure AD B2C [limits](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow)
- You have a strategy planned for deploying and [maintaining](#maintenance-overhead) a medium to large number of B2C tenants long term
- You have a strategy planned for sharding your customers between one or more Azure subscriptions to work within the 20 B2C tenant limit per subscription if required

<!-- #### Implementation considerations

There are many ways to implement a vertically partitioned strategy. 

Discuss here the pros/cons of vertically partitioning B2C tenants based on regions, size of customers, or other factors. Application must be aware of which tenant to sign the user into or could also use [home realm discovery](https://github.com/azure-ad-b2c/samples/tree/master/policies/default-home-realm-discovery) to assist with this

Will probably want to call out federation scenarios here too. Call out home realm discovery and maybe b2c white paper here.  Also need to talk about *how* to do it.  -->

## Identity Federation

[Identity federation](/azure/active-directory-b2c/add-identity-provider) is the concept of establishing a trust between two identity providers for the purpose of allowing your users to sign in with a pre-existing account. In the case of Azure AD B2C, you would most often choose to do this to enable your users to login with their social or enterprise accounts instead of creating a separate [local account](/azure/active-directory-b2c/identity-provider-local) specific for your application. Each unique federated identity provider must be [configured](#user-journey-configuration) using either a user flow or a custom policy. When choosing an isolation model, keep in mind that there is a combined [limit](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow#azure-ad-b2c-configuration-limits) of either 200 user flows or custom policies allowed in a single B2C tenant. Additionally, if you are wanting to set up a federated identity provider using SAML, you must create a dedicated policy for each one. You cannot combine it in a larger policy file in the same way you can with OpenID Connect identity providers.

Additionally, something else to keep in mind, is that you can also use identity federation as a tool for managing multiple B2C tenants by federating the B2C tenants with each other. This allows your application to trust a single B2C tenant instead of it having to be aware that your customers are divided between *n* number of B2C tenants. This is most commonly used in the vertically partitioned isolation model.  

**Example**: You have customers in 3 distinct regions (Regions A, B, and C). You are employing a vertically partitioned B2C tenant strategy and are separating your customers into a B2C tenant per region. In this scenario, you would need *4* B2C tenants: one each for regions A, B, and C, and a fourth to act as a "funnel" tenant. The multitenant application would trust the funnel tenant as its identity provider, and the funnel tenant would establish a trust between each of the regional tenants as an identity provider. Upon a user being directed to the funnel tenant for login, the funnel tenant would be responsible for looking up which of the regional tenants the user belongs to, and directing them to it for login.

## Data Residency

When provisioning a B2C tenant, you will be asked to select a region for your tenant to be deployed to. This selection is important as this is the region that your customer data will reside in. If you have any specific data residency requirements for a subset of your customers, this is when you should consider using the vertically partitioned strategy.

## Authorization

Azure AD B2C is typically focused on the *authentication* of users. In order to perform *authorization*, there are extra considerations you must take into account. Generally speaking, you have 3 main options when it comes to *authorization*:

1. Keep the authorization logic entirely out of Azure AD B2C and implement it in the application itself.
   - The main benefit here is that you don't need to build it inside of your User Flows or Custom Policies, and don't need to host an additional REST API.
   - Another benefit of this approach is that the authorization information can be refreshed at will (eg. with every user request), whereas the other options emit authorization information as claims inside the application token. Today, this token only gets refreshed when the user signs out and back in or goes through some other user flow interactively; otherwise the token contents are not re-evaluated. 
   - The disadvantage is that if there are multiple applications that have the same authorization requirements, they have to re-implement the authorization logic across each application and cannot benefit from a central component which provides and maintains this as a service from a single place.

2. Use [custom user attributes](/azure/active-directory-b2c/user-flow-custom-attributes?pivots=b2c-user-flow) in Azure AD B2C to store the user's roles
     - These user attributes are easy to define and can simply be selected as Application Claims in the token, which makes them easy to use from [user flows](/azure/active-directory-b2c/user-flow-overview) (meaning you do not need to use [custom policies](/azure/active-directory-b2c/custom-policy-overview)).
     - In this case, you would need to create a user management application that is able to perform CRUD (Create, Read, Update, Delete) operations on these attributes via the [Microsoft Graph API](/graph/use-the-api), as they are not visible in the Azure portal.
     - You will also need to take care to never allow these user attributes to be modified by the end users themselves (e.g. through a profile edit user flow), otherwise a user could simply modify their own permissions.
     - You should consider prefixing the user attributes with the app name to avoid conflicts, e.g. App1_AppRoles and App2_AppRoles.
     - Also note that custom user attributes today do not allow *collections*. If there are multiple roles you must return, they must be returned as a single string using a separator. There is a [string length limit](/azure/active-directory-b2c/service-limits?pivots=b2c-user-flow#azure-ad-b2c-configuration-limits) of 250 characters for a single custom user attribute, so this wouldn't work well if you need a *lot* of different roles or permissions.  

3. Use an external, custom REST API to return authorization claims
      -   

Talk through pros/cons of the 2 main ways to do RBAC in B2C: App Roles and build-your-own. App roles being more basic and having a limit of (?) app roles per app. Building your own is much more complex.  

Link to identity approaches article here. [https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/identity#authorization)

Could link to Azure SaaS Dev Kit here maybe, as it has one of these built. Could also link to SaaS Starter Web App doc [https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app](https://learn.microsoft.com/en-us/azure/architecture/example-scenario/apps/saas-starter-web-app).  

Also may want to discuss how this applies to different isolation models. 
## Maintenance

Consider talking here about the maintenance overhead of b2c tenants. Rotating keys, certificates, etc. 

### Deployments & DevOps

Discuss here how a well configured DevOps pipeline should be used to manage this. Especially if configuring SSO per client. Will want to find or build other samples or resources to link here as well.

This is one, but we need to validate it as it's a bit old. [https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline](https://github.com/azure-ad-b2c/samples/tree/master/policies/devops-pipeline)

## Azure AD B2B vs Azure AD B2C

[Azure AD B2B collaboration](/azure/active-directory/external-identities/what-is-b2b) is a feature within Azure AD External Identities that allows you to invite guest users into your *organizational* Azure AD tenant for collaboration purposes. B2B collaboration is most often used when you need an external user, such as a vendor, to have access to resources within your Azure AD tenant.

Azure AD B2C is also grouped within Azure AD External Identities, but provides a different set of features. It is specifically intended for use by customers of your product. These users are managed inside a separate Azure AD B2C tenant.

In some scenarios, depending on your user personas, you could have a need for either Azure AD B2B, Azure AD B2C, or even both at the same time. For example, if you needed to authenticate staff users within your organization, users that work for a vendor, and customers all within the same app, you would need both Azure AD B2B and Azure AD B2C.

Here are some additional resources to review for more information on this subject:

- [Use Azure AD or Azure AD B2C](/architecture/guide/multitenant/approaches/identity#use-azure-ad-or-azure-ad-b2c)
- [Comparing External Identities feature sets](/azure/active-directory/external-identities/external-identities-overview#comparing-external-identities-feature-sets)
- [Woodgrove Demo](https://aka.ms/CIAMdemo) - An example application that uses Azure AD B2B and Azure AD B2C.

## Application Security 

Probably want to call out the B2C limitation of no web-api chaining here. Documented [here](https://github.com/AzureAD/microsoft-identity-web/wiki/b2c-limitations). Need to also document the workaround.  


## Contributors

TBD

## Next Steps

TBD