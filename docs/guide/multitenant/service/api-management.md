---
title: Use Azure API Management in a multitenant solution
description: Learn about the features of Azure API Management that are useful when you work in multitenant solutions.
author: johndowns
ms.author: jodowns
ms.date: 06/10/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure-api-management
categories:
 - integration
 - web
---

# Use Azure API Management in a multitenant solution

[Azure API Management](/azure/api-management/api-management-key-concepts) is a comprehensive API gateway and reverse proxy for APIs. It provides many features that are useful to API-focused applications, including caching, response mocking, and a developer portal. This article summarizes some of the key features of API Management that are particularly useful for multitenant solutions.

> [!NOTE]
> This article focuses on how you can use API Management when you have your own multitenant applications that host APIs, whether for internal or external use.
> 
> Another form of multitenancy is to provide the API Management gateway as a service to other teams. For example, an enterprise might have a shared API Management instance that multiple application teams deploy to and use. This article doesn't discuss this form of multitenancy. Consider using [workspaces](/azure/api-management/workspaces-overview), which help you to share an API Management instance across multiple teams who might have different levels of access.

## Isolation models

Most commonly, API Management is deployed as a shared component, with a single instance serving requests for multiple tenants. However, there are multiple different ways you can deploy API Management depending on your [tenancy model](../considerations/tenancy-models.yml). This article assumes you deploy your solution by using [deployment stamps](../approaches/overview.yml#deployment-stamps-pattern).

Typically, the way you use API Management is similar regardless of the isolation models. This section focuses on the differences in cost and complexity between the isolation models, and how each approach routes requests to your backend API applications.

| Consideration | Shared instance, single-tenant backends | Shared instance, shared multitenant backend | Instance per tenant |
|---|---|---|---|
| Number of tenants supported | Many | Almost unbounded | One per instance |
| Cost | Lower | Lower | Higher |
| Deployment complexity | Low. Single instance to manage for each stamp | Low. Single instance to manage for each stamp | High. Multiple instances to manage |
| Routing configuration complexity | Higher | Lower | Lower |
| Example scenario | Custom domain names per tenant | Large multitenant solution with a shared application tier | Tenant-specific deployment stamps |

### Shared instance isolation models

It's common to share an API Management instance between multiple tenants, which helps to reduce cost as well as deployment and management complexity. The details of how you can share an API Management instance depend on how your tenants are assigned to backend API applications.

#### Single-tenant backend application

If you deploy distinct backend applications for each tenant, you can deploy a single API Management instance and route traffic to the correct tenant backend for each request. This approach requires that you configure API Management with the backend hostnames for each tenant, or that you have another way to map an incoming request to the correct tenant's backend.

Because of the extra lookup required, this approach might not scale to large numbers of tenants sharing a single API Management instance. There might also be some performance overhead when looking up the tenant backend. However, the size of this performance overhead varies depending on how you design such a lookup.

#### Shared multitenant backend application

In scenarios where your tenants share a common backend application, API Management's routing process is simplified because all requests can be routed to a single backend. If you use wildcard domains or provider-issued domains, you might be able to achieve almost unbounded scale with this approach. Also, because requests don't need to be mapped to a tenant's backend, there's no performance impact from customized routing decisions.

### Instance per tenant

In some situations, you might deploy an instance of API Management for each tenant. This approach is only advisable if you have a small number of tenants, or if you have strict compliance requirements that restrict you from sharing any infrastructure between tenants. For example, if you deploy a dedicated virtual network for each tenant, you probably need to deploy a dedicated API Management instance for each tenant, too.

> [!TIP]
> If your only reason for deploying multiple instances is to support users in multiple geographic regions, consider whether the [multi-region deployment](#multi-region-deployments) capability in API Management might suit your needs instead.

When you deploy an instance of API Management, you need to consider the [service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#api-management-limits), including any limits that might apply to the number of API Management instances within an Azure subscription or region.

For single-tenant instances, there's typically minimal routing configuration because all requests can be routed to a single backend. In this scenario, there's no custom routing decisions required, and so there's no added performance impact. However, you typically incur a higher resource cost than if you were deploying a shared instance. If you need to deploy single-tenant instances, consider whether [self-hosted gateways](/azure/api-management/self-hosted-gateway-overview) might enable you to reuse tenant-specific compute resources that you already deploy.

## Features of API Management that support multitenancy

API Management enables flexibility through its use of [policies](/azure/api-management/api-management-howto-policies). By using policies, you can customize how requests are validated, routed, and processed. When you design a multitenant solution with API Management, you implement many of the capabilities by using policies.

### Identify tenants on incoming requests

Consider how you can identify the appropriate tenant within each incoming request. In a multitenant solution, it's important to have a clear understanding of who is making each request so that you return the data for that specific tenant and nobody else.

API Management provides [subscriptions](/azure/api-management/api-management-subscriptions). Subscriptions enable you to authenticate requests with a unique *subscription key* that helps to identify the subscriber making the request. If you choose to use subscriptions, consider how you can map the API Management subscriptions to your own tenant or customer identifiers. Subscriptions are tightly integrated into the developer portal. For most solutions, it's a good practice to use subscriptions to identify tenants.

Alternatively, you can identify the tenant through other methods. Here are some example custom approaches, each of which runs within a custom policy that you'd define:

- **Use a custom component of the URL, such as a subdomain, path, or query string.** For example, in the URL `https://api.contoso.com/tenant1/products`, you might extract the first part of the path (`tenant1`) and treat it a tenant identifier. Similarly, given the incoming URL `https://tenant1.contoso.com/products`, you might extract the first part of the domain (`tenant1`). To use this approach, consider parsing the path or query string from the `Context.Request.Url` property.
- **Use a request header.** For example, your client applications might add a custom `X-TenantID` header to requests. To use this approach, consider reading from the `Context.Request.Headers` collection.
- **Extract claims from a JSON web token (JWT).** For example, you might have a custom `tenantId` claim in a JWT issued by your identity provider. To use this approach, use the [`validate-jwt` policy](/azure/api-management/validate-jwt-policy) and set the `output-token-variable-name` property so that your policy definition can read the values from the token.
- **Look up tenant identifiers dynamically.** You can communicate with an external database or service while the request is being processed. This approach enables you to create custom tenant mapping logic, to map a logical tenant identifier to a specific URL, or to obtain additional information about a tenant. To use this approach, use the [`send-request` policy](/azure/api-management/send-request-policy). However, this approach is likely to increase the latency of your requests. To mitigate this effect, it's a good idea to use caching to reduce the number of calls to the external API. The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach. Be sure to invalidate your cache with each tenant added, removed, or moved that impacts backend lookup.

### Named values

API Management supports [named values](/azure/api-management/api-management-howto-properties), which are custom configuration settings that can be used throughout your policies. For example, you might use a named value to store a tenant's backend URL and then reuse that same value in several places within your policies. If you need to update the URL, you can update it in a single place.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set the names of your named values. If the settings might be different for different tenants, ensure that you include the tenant identifier in the name to reduce the chance that you'll accidentally or be manipulated into referring to the value when processing a request for another tenant. For example, a pattern like `tenantId-key:value` could be used once validated that `tenantId` is appropriate for this request.

### Authenticate incoming requests

API requests made to the API Management gateway usually need to be authenticated. API Management provides several methods of authenticating incoming requests to the gateway, including OAuth 2.0 and [client certificates](/azure/api-management/api-management-howto-mutual-certificates-for-clients). Consider which types of credentials you should support, and where credentials should be validated: by API Management, your backend applications, or in both places.

For more information, see [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview).

> [!NOTE]
> If you use a subscription key (API key), it's a good practice to also use another method of authentication.
>
> On its own, a subscription key isn't a strong form of authentication, but the subscription key is be useful for many scenarios, such as for tracking an individual tenant's API usage.

### Route to tenant-specific backends

When you use API Management as a shared component, you might need to route incoming API requests to different tenant-specific backends. These backends might be in different deployment stamps, or they might be different applications within a single stamp. To customize the routing in a policy definition, use the [`set-backend-service` policy](/azure/api-management/set-backend-service-policy). You need to specify the new base URL that the request should be redirected to.

### Cache responses or other data

API Management has a powerful cache feature, which can be used to cache entire HTTP responses or any other data. For example, you can also use the cache for tenant mappings if you use custom logic or if you look up the mapping from an external service.

The [`cache-store-value` policy](/azure/api-management/cache-store-value-policy) and [`cache-lookup-value` policy](/azure/api-management/cache-lookup-value-policy) policies can be used to implement a caching approach.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set your cache keys. If the cached data might be different for different tenants, ensure that you include the tenant identifier in the cache key to reduce the chance that you'll accidentally or be manipulated into referring to the value when processing a request for another tenant.

### Custom domains

API Management enables you to use your own [custom domains](/azure/api-management/configure-custom-domain) for the API gateway and developer portal. In some tiers, you can configure wildcard domains or multiple custom domains.

You can also use API Management together with a service like [Azure Front Door](front-door.md). In this kind of configuration, it's common for Azure Front Door to handle custom domains and transport layer security (TLS) certificates, and for it to communicate with API Management by using a single domain name. If the original URL from the client includes tenant information that you need to send to the API Management instance for later processing, consider using the `X-Forwarded-Host` request header, or use [Azure Front Door rules](front-door.md#rules-engine) to pass the information as an HTTP header.

### Rate limits

It's common to apply quotas or rate limits in a multitenant solution. Rate limits help to mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml), and they can be used to enforce quality of service and differentiate between different pricing tiers.

API Management provides capabilities to enforce tenant-specific rate limits. If you use tenant-specific subscriptions, consider using the [`quota` policy](/azure/api-management/quota-policy) to enforce a quota for each subscription. Alternatively, consider using the [`quota-by-key` policy](/azure/api-management/quota-by-key-policy) to enforce quotas by using any other rate limit key, such as a tenant identifier that you obtained from the request URL or a JWT.

### Monetization

The API Management documentation [provides extensive guidance on monetizing APIs](/azure/api-management/monetization-support), including a sample implementation. The monetization approaches combine many of the features of API Management together to enable developers to publish an API, manage subscriptions, and charge based on different usage models.

### Capacity management

An API Management instance supports a certain amount of [capacity](/azure/api-management/api-management-capacity), which represents the resources available to process your requests. When you use complex policies or deploy more APIs to the instance, more capacity is consumed. You can manage the capacity of an instance in several ways, including by purchasing more units. You can also dynamically scale the capacity of your instance.

Some multitenant instances might consume higher amounts of capacity than single-tenant instances, such as if you use many policies for routing requests to different tenant backends. Consider capacity planning carefully, and plan to scale your instance's capacity if you see your use increase. You should also consider testing the performance of your solution to understand your capacity needs ahead of time.

For more information about scaling API Management, see [Upgrade and scale an Azure API Management instance](/azure/api-management/upgrade-and-scale).

### Multi-region deployments

API Management [supports multi-region deployments](/azure/api-management/api-management-howto-deploy-multi-region), which means that you can deploy a single logical API Management resource across multiple Azure regions without needing to replicate its configuration onto separate resources. This capability is especially helpful when you distribute or replicate your solution globally. You can effectively deploy a fleet of API Management instances across multiple regions, allowing for low latency request processing, and manage them as a single logical instance.

However, if you need fully isolated API Management instances, you might also choose to deploy independent API Management resources into different regions. By following this approach, the management plane of the API Management instances is separated for each instance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [John Downs](https://linkedin.com/in/john-downs/) | Principal Software Engineer
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Partner Technology Strategist, Global Partner Solutions

Other contributor:

- [Arsen Vladimirskiy](https://linkedin.com/in/arsenv/) | Principal Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Review [architectural approaches for integration in multitenant solutions](../approaches/integration.md).

## Related resources

- [Architect multitenant solutions on Azure](../overview.md)
- [Checklist for architecting and building multitenant solutions on Azure](../checklist.md)
- [Tenancy models to consider for a multitenant solution](../considerations/tenancy-models.yml)
