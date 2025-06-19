---
title: Use Azure API Management in a multitenant solution
description: Learn about the features of Azure API Management that are useful when you work in multitenant solutions.
author: johndowns
ms.author: pnp
ms.date: 07/24/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Use Azure API Management in a multitenant solution

[Azure API Management](/azure/api-management/api-management-key-concepts) is a comprehensive API gateway and reverse proxy for APIs. It provides many features, including caching, response mocking, and a developer portal, that are useful for API-focused applications. This article summarizes some of the key features of API Management that are useful for multitenant solutions.

> [!NOTE]
> This article focuses on how you can use API Management when you have your own multitenant applications that host APIs for internal or external use.
> 
> Another form of multitenancy is to provide the API Management gateway as a service to other teams. For example, an organization might have a shared API Management instance that multiple application teams deploy to and use. This article doesn't discuss this form of multitenancy. Consider using [workspaces](/azure/api-management/workspaces-overview), which help you share an API Management instance across multiple teams who might have different levels of access.

## Isolation models

API Management is typically deployed as a shared component with a single instance that serves requests for multiple tenants. However, based on your [tenancy model](../considerations/tenancy-models.md), there are many ways that you can deploy API Management. This article assumes that you deploy your solution by using [deployment stamps](../approaches/overview.yml#deployment-stamps-pattern).

Typically, the way you use API Management is similar, regardless of the isolation model. This section focuses on the differences in cost and complexity between the isolation models and how each approach routes requests to your back-end API applications.

| Consideration | Shared instance with single-tenant back ends | Shared instance with shared multitenant back end | Instance for each tenant |
|---|---|---|---|
| Number of supported tenants | Many | Almost unbounded | One for each instance |
| Cost | Lower | Lower | Higher |
| Deployment complexity | Low: Single instance to manage for each stamp | Low: Single instance to manage for each stamp | High: Multiple instances to manage |
| Routing configuration complexity | Higher | Lower | Lower |
| Susceptibility to noisy-neighbor problems | Yes | Yes | No |
| Tenant-level network isolation | No | No | Yes |
| Example scenario | Custom domain names for each tenant | Large multitenant solution with a shared application tier | Tenant-specific deployment stamps |

### Shared instance isolation models

It's common to share an API Management instance between multiple tenants, which helps reduce cost and deployment and management complexity. The details of how you can share an API Management instance depend on how you assign tenants to back-end API applications.

#### Single-tenant back-end application

If you deploy distinct back-end applications for each tenant, then you can deploy a single API Management instance and route traffic to the correct tenant back end for each request. This approach requires you to configure API Management with the back-end hostnames for each tenant or to have another way to map an incoming request to the correct tenant's back end.

Because it requires an extra lookup, this approach might not scale to large numbers of tenants that share a single API Management instance. There might also be some performance overhead when you look up the tenant back end. However, the size of this performance overhead depends on how you design such a lookup.

#### Shared multitenant back-end application

In scenarios where your tenants share a common back-end application, the API Management routing process is simplified because you can route all requests to a single back end. If you use wildcard domains or provider-issued domains, you might be able to achieve almost unbounded scale with this approach. Also, because requests don't need to be mapped to a tenant's back end, there's no performance impact from customized routing decisions.

### Instance for each tenant

In some situations, you might deploy an instance of API Management for each tenant. We recommend this approach only if you have a small number of tenants or if you have strict compliance requirements that restrict you from sharing any infrastructure between tenants. For example, if you deploy a dedicated virtual network for each tenant, then you probably also need to deploy a dedicated API Management instance for each tenant.

> [!TIP]
> If your only reason for deploying multiple instances is to support users across different geographic regions, you might want to consider whether the [multiregion deployment](#multiregion-deployments) feature in API Management meets your requirements.

When you deploy an instance of API Management, you need to consider the [service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#api-management-limits), including any limits that might apply to the number of API Management instances within an Azure subscription or region.

Single-tenant instances typically have minimal routing configuration because you can route all requests to a single back end. This scenario doesn't require custom routing decisions, so there's no added performance impact. However, you typically incur a higher resource cost than if you deploy a shared instance. If you need to deploy single-tenant instances, consider whether [self-hosted gateways](/azure/api-management/self-hosted-gateway-overview) enable you to reuse tenant-specific compute resources that you already deploy.

## API Management features that support multitenancy

API Management uses [policies](/azure/api-management/api-management-howto-policies) to enable flexibility. You can customize how requests are validated, routed, and processed when you use policies. And when you design a multitenant solution with API Management, you use policies to implement many of its capabilities.

### Identify tenants on incoming requests

Consider how you can identify the appropriate tenant within each incoming request. In a multitenant solution, it's important to have a clear understanding of who is making each request so that you return the data for that specific tenant and nobody else.

API Management provides [subscriptions](/azure/api-management/api-management-subscriptions) that you can use to authenticate requests. These subscriptions use a unique *subscription key* that helps identify the subscriber who is making the request. If you choose to use subscriptions, consider how you can map the API Management subscriptions to your own tenant or customer identifiers. Subscriptions are tightly integrated into the developer portal. For most solutions, it's a good practice to use subscriptions to identify tenants.

Alternatively, you can identify the tenant by using other methods. Here are some examples of approaches that run within a custom policy that you define:

- **Use a custom component of the URL, such as a subdomain, path, or query string.** For example, in the URL `https://api.contoso.com/tenant1/products`, you might extract the first part of the path, `tenant1`, and treat it as a tenant identifier. Similarly, given the incoming URL `https://tenant1.contoso.com/products`, you might extract the subdomain, `tenant1`. To use this approach, consider parsing the path or query string from the `Context.Request.Url` property.

- **Use a request header.** For example, your client applications might add a custom `TenantID` header to requests. To use this approach, consider reading from the `Context.Request.Headers` collection.

- **Extract claims from a JSON web token (JWT).** For example, you might have a custom `tenantId` claim in a JWT that's issued by your identity provider. To use this approach, use the [validate-jwt](/azure/api-management/validate-jwt-policy) policy and set the `output-token-variable-name` property so that your policy definition can read the values from the token.

- **Look up tenant identifiers dynamically.** You can communicate with an external database or service while the request is being processed. By taking this approach, you can create custom tenant mapping logic to map a logical tenant identifier to a specific URL or to obtain additional information about a tenant. To use this approach, use the [send-request](/azure/api-management/send-request-policy) policy. 

   This approach is likely to increase the latency of your requests. To mitigate this effect, it's a good idea to use caching to reduce the number of calls to the external API. You can use the [cache-store-value](/azure/api-management/cache-store-value-policy) and [cache-lookup-value](/azure/api-management/cache-lookup-value-policy) policies to implement a caching approach. Be sure to invalidate your cache with each added, removed, or moved tenant that impacts back-end lookup.

### Named values

API Management supports [named values](/azure/api-management/api-management-howto-properties), which are custom configuration settings that you can use throughout your policies. For example, you might use a named value to store a tenant's back-end URL and then reuse that same value in several places within your policies. If you need to update the URL, you can update it in a single place.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set the names of your named values. If the settings vary between tenants, make sure to include the tenant identifier in the name. For example, you can use a pattern like `tenantId-key:value` after you confirm that `tenantId` is suitable for the request. 
>
>Include the identifier to reduce the chance of accidentally referring to or being manipulated into referring to another tenant's value when you process a request for another tenant.

### Authenticate incoming requests

API requests made to the API Management gateway usually need to be authenticated. API Management provides several methods of authenticating incoming requests to the gateway, including OAuth 2.0 and [client certificates](/azure/api-management/api-management-howto-mutual-certificates-for-clients). Consider the types of credentials that you should support and where they should be validated. For example, consider whether validation should happen in API Management, in your back-end applications, or in both places.

For more information, see [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview).

> [!NOTE]
> If you use a subscription key or API key, it's a good practice to also use another method of authentication.
>
> A subscription key alone isn't a strong form of authentication, but it's useful for other scenarios, such as for tracking an individual tenant's API usage.

### Route to tenant-specific back ends

When you use API Management as a shared component, you might need to route incoming API requests to different tenant-specific back ends. These back ends might be in different deployment stamps, or they might be different applications within a single stamp. To customize the routing in a policy definition, use the [set-backend-service](/azure/api-management/set-backend-service-policy) policy. You need to specify the new base URL that the request should be redirected to.

### Cache responses or other data

API Management has a powerful cache feature that you can use to cache entire HTTP responses or any other data. For example, you can use the cache for tenant mappings if you use custom logic or if you look up the mapping from an external service.

Use the [cache-store-value](/azure/api-management/cache-store-value-policy) and [cache-lookup-value](/azure/api-management/cache-lookup-value-policy) policies to implement a caching approach.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set your cache keys. If the cached data might vary between tenants, ensure that you include the tenant identifier in the cache key. 
>
>Include the identifier to reduce the chance of accidentally referring to being manipulated into referring to another tenant's value when you process a request for another tenant.

### Custom domains

Use API Management to configure your own [custom domains](/azure/api-management/configure-custom-domain) for the API gateway and developer portal. In some tiers, you can configure wildcard domains or multiple fully qualified domain names (FQDNs).

You can also use API Management together with a service like [Azure Front Door](front-door.md). In this kind of configuration, Azure Front Door frequently handles custom domains and transport layer security (TLS) certificates and communicates with API Management by using a single domain name. If the original URL from the client includes tenant information that you need to send to the API Management instance for later processing, consider using the `X-Forwarded-Host` request header, or use [Azure Front Door rules](front-door.md#rules-engine) to pass the information as an HTTP header.

### Rate limits

It's common to apply quotas or rate limits in a multitenant solution. Rate limits can help you mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). You can also use rate limits to enforce quality of service and to differentiate between different pricing tiers.

Use API Management to enforce tenant-specific rate limits. If you use tenant-specific subscriptions, consider using the [quota](/azure/api-management/quota-policy) policy to enforce a quota for each subscription. Alternatively, consider using the [quota-by-key](/azure/api-management/quota-by-key-policy) policy to enforce quotas by using any other rate limit key, such as a tenant identifier that you obtained from the request URL or a JWT.

### Monetization

The API Management documentation [provides extensive guidance on monetizing APIs](/azure/api-management/monetization-support), including a sample implementation. The monetization approaches combine many of the features of API Management so that developers can publish an API, manage subscriptions, and charge based on different usage models.

### Capacity management

An API Management instance supports a certain amount of [capacity](/azure/api-management/api-management-capacity), which represents the resources available to process your requests. When you use complex policies or deploy more APIs to the instance, you consume more capacity. You can manage the capacity of an instance in several ways, such as by purchasing more units. You can also dynamically scale the capacity of your instance.

Some multitenant instances might consume more capacity than single-tenant instances, like if you use many policies for routing requests to different tenant back ends. Consider capacity planning carefully, and plan to scale your instance's capacity if you see your use increase. You should also test the performance of your solution to understand your capacity needs ahead of time.

For more information about scaling API Management, see [Upgrade and scale an Azure API Management instance](/azure/api-management/upgrade-and-scale).

### Multiregion deployments

API Management [supports multiregion deployments](/azure/api-management/api-management-howto-deploy-multi-region), which means that you can deploy a single logical API Management resource across multiple Azure regions without needing to replicate its configuration onto separate resources. This capability is especially helpful when you distribute or replicate your solution globally. You can effectively deploy a fleet of API Management instances across multiple regions, which allows for low-latency request processing, and manage them as a single logical instance.

However, if you need fully isolated API Management instances, you might also choose to deploy independent API Management resources into different regions. This approach separates the management plane for each API Management instance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [John Downs](https://linkedin.com/in/john-downs/) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist, Global Partner Solutions

Other contributor:

- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv/) | Principal Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review the [architectural approaches for integration in multitenant solutions](../approaches/integration.md).

## Related resources

- [Architect multitenant solutions on Azure](../overview.md)
- [Checklist for architecting and building multitenant solutions on Azure](../checklist.md)
- [Tenancy models to consider for a multitenant solution](../considerations/tenancy-models.md)