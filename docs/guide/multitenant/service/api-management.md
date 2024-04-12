---
title: Use Azure API Management in a multitenant solution
description: Learn about the features of Azure API Management that are useful when you work in multitenant solutions.
author: johndowns
ms.author: jodowns
ms.date: 04/10/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure-api-management
categories:
 - integration
 - web
ms.category:
  - fcp
ms.custom:
  - guide
---

# Use Azure API Management in a multitenant solution

Azure API Management is a comprehensive API gateway and reverse proxy for APIs. It provides many features that are useful to API-focused applications, including caching, response mocking, and a developer portal. This article summarizes some of the key features of API Management that are particularly useful for multitenant solutions.

> [!NOTE]
> This article focuses on how you can use API Management when you have your own multitenant applications with APIs.
> 
> Another form of multitenancy is to provide API Management as a service to other teams. For example, an enterprise might have a shared API Management instance that multiple application teams deploy to and use. For this form of multitenancy, consider using [workspaces](/azure/api-management/workspaces-overview), which help you to share an API Management instance across multiple teams who might have different levels of access.

## Isolation models

Most commonly, API Management is deployed as a shared component, with a single instance serving requests for multiple tenants. However, there are multiple different ways you can deploy API Management depending on your needs, your [tenancy model](../considerations/tenancy-models.yml), and how you use [deployment stamps](../approaches/overview.yml#deployment-stamps-pattern).

| Consideration | Shared instance, single-tenant backends | Shared instance, sharded backends | Shared instance, multitenant backend | Instance per deployment stamp | Instance per tenant |
|-|-|-|-|-|
| Performance isolation | TODO | TODO | TODO | TODO | TODO |
| Deployment complexity | Low. Single instance to manage. | Medium. | Medium. | High. | TODO. |
| Operational complexity | Low. | Medium. | Medium. | High. | TODO. |
| Cost | TODO | TODO | TODO | TODO | TODO |
| Example scenario | TODO | TODO | TODO | TODO | TODO |

### Shared instance isolation models

It's common to share an API Management instance between multiple tenants, which helps to reduce cost as well as deployment and management complexity. The details of how you can share an API Management instance depend on how your tenants are assigned to backend applications.

#### Single-tenant backend application

You can deploy a single API Management instance and route 

- Maximum number of Tenants: Low
- Performance is impacted because a tenant lookup is required for each request.

#### Sharded tenant backend applications
- Maximum number of Tenants: Low
- Performance is impacted because a tenant lookup is still required for each request.

#### Multitenant backend application
  - Number of Tenants: High
  - Tenant lookup is not required, so no performance impact.

<!-- TODO
### Shared instance per stamp
- Number of Tenants: High
- Tenant lookup is performed outside of APIM (e.g., by a Gateway routing to deployment stamp), so minimal performance impact.
-->

### Instance per tenant
  - Number of Tenants: Medium, but run into limits with number of APIM instances.
  - Tenant lookup is not required, so no performance impact.

> [!TIP]
> If your only reason for deploying multiple instances is to support users in multiple geographic regions, consider whether the [multi-region deployment](#multi-region-deployments) capability in API Management might suit your needs instead.

## Features of API Management that support multitenancy

API Management enables flexibility through its use of [policies](/azure/api-management/api-management-howto-policies). By using policies, you can customize how requests are validated, routed, and processed. Many of the capabilities related to multitenant solutions are enabled by policies.

### Identify tenants on incoming requests

Consider how you'll identify tenants based on incoming requests. In a multitenant solution it's important to have a clear understanding of who is making each request so that you return the data for that specific tenant and nobody else.

API Management provides [subscriptions](/azure/api-management/api-management-subscriptions). Subscriptions enable you to authenticate requests with a unique *subscription key* that helps to identify the subscriber making the request. If you choose to use subscriptions, consider how you'll map the API Management subscriptions to your own tenant or customer identifiers. Subscriptions are tightly integrated into the developer portal. For most solutions, we recommend using subscriptions to identify tenants.

Alternatively, you can identify the tenant through other methods. Each of these methods may require additional work to extract the token, and then to map the request to the tenant. Here are some example custom approaches:

- **Use a custom component of the URL, such as a subdomain, path, or query string.** For example, in the URL `https://api.contoso.com/tenant1/products`, you might extract the first part of the path (`tenant1`) and treat it a tenant identifier, or in the URL `https://tenant1.contoso.com/products` you might extract the first part of the domain. To use this approach, consider parsing the path or query string from the `Context.Request.Url` property.
- **Use a request header.** For example, your client applications might add a custom `X-TenantID` header to requests. To use this approach, consider reading from the `Context.Request.Headers` collection.
- **Extract claims from a JSON web token (JWT).** For example, you might have a custom `tenantId` claim in the JWTs issued by your identity provider. To use this approach, use the [`validate-jwt` policy](/azure/api-management/validate-jwt-policy) and set the `output-token-variable-name` property so that your policy definition can read the values from the token.
- **Look up tenant identifiers dynamically.** You can communicate with an external database or service while the request is being processed. This approach enables you to create completely custom logic, to map a logical tenant identifier to a specific URL, or to obtain additional information about a tenant. To use this approach, use the [`send-request` policy](/azure/api-management/send-request-policy). However, this approach is likely to increase the latency of your requests. To mitigate this effect, it's a good idea to use caching to reduce the number of calls to the external API. The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach.

### Authenticate incoming requests

API requests made to the API Management gateway usually need to be authenticated. API Management provides several methods of authenticating incoming requests to the gateway, including OAuth 2.0 and [client certificates](/azure/api-management/api-management-howto-mutual-certificates-for-clients).

> [!NOTE]
> If you use a subscription key (API key), we recommend also using another method of authentication.
>
> On its own, a subscription key isn't a strong form of authentication, but the subscription key is be useful for many scenarios, such as for tracking individual customers' API usage.

- No credential - An API Management subscription key is used to authenticate the request. This can be used when you control the calling application and can trust the request. This method shouldn't be used for any API that provides access to sensitive information.
- Shared credential - All tenants share the same authentication credential such as a [client certificate](/azure/api-management/api-management-howto-mutual-certificates-for-clients). This should only be used when you control the calling application and can trust the request. This works when an API is only used by internal service-to-service communication. If the client isn't trusted, then it would be possible for the *subscription key* to be modified to change the request to a different tenant, putting tenant isolation at risk.
- Per-tenant credential - Each tenant provides a unique credential to access an API. This is best used with an OAuth2.0 method of authentication is available. It's possible to implement this method with client certificate authentication, but it's harder to scale this approach because complicated policies are required to uniquely identify each user.

### Route to tenant-specific backends

When you use API Management as a shared component, you might need to route incoming API requests to different tenant-specific backends. These backends might be in different deployment stamps, or they might be different applications within a single stamp. To customize the routing in a policy definition, use the [`set-backend-service` policy](/azure/api-management/set-backend-service-policy). You need to specify the new base URL that the request should be redirected to.

### Caching

API Management has a powerful cache feature, which can be used to cache entire HTTP responses or any other data that you wish to cache. The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach.

In a multitenant solution, it's important to ensure to carefully select your cache keys. If the cached data might be different for different tenants, ensure that you include the tenant identifier in the cache key.

### Custom domains

API Management enables you to use your own [custom domains](/azure/api-management/configure-custom-domain) for the API gateway and developer portal. In some tiers, you can configure wildcard domains or multiple custom domains.

You can also use API Management together with a service like [Azure Front Door](front-door.md). In this kind of configuration, it's common for Azure Front Door to handle custom domains and TLS certificates, and for it to communicate with API Management by using a single domain name.

### Rate limiting

It's common to apply quotas or rate limits in a multitenant solution. Rate limits help to mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), and they can be used to enforce quality of service and differentiate between different pricing tiers.

API Management provides capabilities to enforce tenant-specific rate limits. If you use tenant-specific subscriptions, consider using the [`quota` policy](/azure/api-management/quota-policy) to enforce a quota for each subscription. Alternatively, consider using the [`quota-by-key` policy](/azure/api-management/quota-by-key-policy) to enforce quotas by using any other rate limit key, such as a tenant identifier.

### Monetization

The API Management documentation [provides extensive guidance on monetizing APIs](/azure/api-management/monetization-support), including a sample implementation. The monetization approaches combine many of the features of API Management together to enable developers to publish an API, manage subscriptions, and charge based on different usage models.

### Multi-region deployments

API Management [supports multi-region deployments](/azure/api-management/api-management-howto-deploy-multi-region), which means that you can deploy a single logical API Management resource and have it shared across multiple Azure regions without needing to replicate configuration. This capability is especially helpful when you distribute or replicate your solution globally. You can effectively deploy a fleet of API Management instances across multiple regions, allowing for low latency request processing, and manage them as a single logical instance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [John Downs](http://linkedin.com/in/john-downs) | Principal Program Manager
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist, Global Partner Solutions

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [architectural approaches for integration in multitenant solutions](../approaches/integration.md).
