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

Azure API Management is a comprehensive API gateway and reverse proxy for APIs. It provides many features that are useful to API-focused applications, including caching, response mocking, and a developer portal. This article summarizes some of the key features of Azure API Management that are particularly useful for multitenant solutions.

> [!NOTE]
> This article focuses on how you can use Azure API Management when you have your own multitenant applications with APIs.
> 
> Another form of multitenancy is to provide Azure API Management as a service to other teams. For example, an enterprise might have a shared API Management instance that multiple application teams deploy to and use. For this form of multitenancy, consider using [workspaces](/azure/api-management/workspaces-overview).

## Isolation models

Typically a shared component. But it's deployed to a region, so if you have a multi-region service you might need several instances distributed throughout the world, and then use something like Front Door
Can sit inside or outside of the stamps.

## Features of API Management that support multitenancy

Azure API Management enables flexibility through its use of [policies](/azure/api-management/api-management-howto-policies). By using policies, you can customize how requests are validated, routed, and processed. Many of the capabilities related to multitenant solutions are enabled by policies.

### Identify tenants on incoming requests

Consider how you'll identify tenants based on incoming requests. In a multitenant solution it's important to have a clear understanding of who is making each request so that you return the data for that specific tenant and nobody else.

Azure API Management provides [subscriptions](/azure/api-management/api-management-subscriptions). Subscriptions enable you to authenticate requests with a unique *subscription key* that helps to identify the subscriber making the request. If you choose to use subscriptions, consider how you'll map the API Management subscriptions to your own tenant or customer identifiers. Subscriptions are tightly integrated into the developer portal. For most solutions, we recommend using subscriptions to identify tenants.

Alternatively, you can identify the tenant through other methods. Each of these methods may require additional work to extract the token, and then to map the request to the tenant. Here are some example custom approaches:

- **Use a custom component of the URL, such as a subdomain, path, or query string.** For example, in the URL `https://api.contoso.com/tenant1/products`, you might extract the first part of the path (`tenant1`) and treat it a tenant identifier, or in the URL `https://tenant1.contoso.com/products` you might extract the first part of the domain. To use this approach, consider parsing the path or query string from the `Context.Request.Url` property.
- **Use a request header.** For example, your client applications might add a custom `X-TenantID` header to requests. To use this approach, consider reading from the `Context.Request.Headers` collection.
- **Extract claims from a JSON web token (JWT).** For example, you might have a custom `tenantId` claim in the JWTs issued by your identity provider. To use this approach, use the [`validate-jwt` policy](/azure/api-management/validate-jwt-policy) and set the `output-token-variable-name` property so that your policy definition can read the values from the token.
- **Look up tenant identifiers dynamically.** You can communicate with an external database or service while the request is being processed. This approach enables you to create completely custom logic, to map a logical tenant identifier to a specific URL, or to obtain additional information about a tenant. To use this approach, use the [`send-request` policy](/azure/api-management/send-request-policy). However, this approach is likely to increase the latency of your requests. To mitigate this effect, it's a good idea to use caching to reduce the number of calls to the external API. The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach.

### Authenticate incoming requests

API requests made to the Azure API Management gateway usually need to be authenticated. Azure API Management provides several methods of authenticating incoming requests to the gateway, including OAuth 2.0 and [client certificates](/azure/api-management/api-management-howto-mutual-certificates-for-clients).

> [!NOTE]
> We recommend using a subscription key (API key) as well as another method of authentication. On its own, a subscription key isn't a strong form of authentication, but use of the subscription key might be useful in certain scenarios, such as for tracking individual customers' API usage.

- No credential - An API Management subscription key is used to authenticate the request. This can be used when you control the calling application and can trust the request. This method shouldn't be used for any API that provides access to sensitive information.
- Shared credential - All tenants share the same authentication credential such as a [client certificate](/azure/api-management/api-management-howto-mutual-certificates-for-clients). This should only be used when you control the calling application and can trust the request. This works when an API is only used by internal service-to-service communication. If the client isn't trusted, then it would be possible for the *subscription key* to be modified to change the request to a different tenant, putting tenant isolation at risk.
- Per-tenant credential - Each tenant provides a unique credential to access an API. This is best used with an OAuth2.0 method of authentication is available. It's possible to implement this method with client certificate authentication, but it's harder to scale this approach because complicated policies are required to uniquely identify each user.

### Route to tenant-specific backends

When you use Azure API Management as a shared component, you might need to route incoming API requests to different tenant-specific backends. These backends might be in different deployment stamps, or they might be different applications within a single stamp.

TODO example diagram

To customize the routing in a policy definition, use the [`set-backend-service` policy](/azure/api-management/set-backend-service-policy). You need to specify the new base URL that the request should be redirected to.

### Caching

Azure API Management has a powerful cache feature, which can be used to cache entire HTTP responses or any other data that you wish to cache. The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach.

In a multitenant solution, it's important to ensure to carefully select your cache keys. If the cached data might be different for different tenants, ensure that you include the tenant identifier in the cache key.

### Custom domains

Azure API Management enables you to use your own [custom domains](/azure/api-management/configure-custom-domain) for the API gateway and developer portal. In some tiers, you can configure wildcard domains or multiple custom domains.

You can also use Azure API Management together with a service like [Azure Front Door](front-door.md). In this kind of configuration, it's common for Azure Front Door to handle custom domains and TLS certificates, and for it to communicate with Azure API Management by using a single domain name.

### Rate limiting

It's common to apply quotas or rate limits in a multitenant solution. Rate limits help to mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), and they can be used to enforce quality of service and differentiate between different pricing tiers.

Azure API Management provides capabilities to enforce tenant-specific rate limits. If you use tenant-specific subscriptions, consider using the [`quota` policy](/azure/api-management/quota-policy) to enforce a quota for each subscription. Alternatively, consider using the [`quota-by-key` policy](/azure/api-management/quota-by-key-policy) to enforce quotas by using any other rate limit key, such as a tenant identifier.

### Monetization

The Azure API Management documentation [provides extensive guidance on monetizing APIs](/azure/api-management/monetization-support), including a sample implementation. The monetization approaches combine many of the features of Azure API Management together to enable developers to publish an API, manage subscriptions, and charge based on different usage models.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [John Downs](http://linkedin.com/in/john-downs) | Principal Program Manager
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist, Global Partner Solutions

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

TODO

