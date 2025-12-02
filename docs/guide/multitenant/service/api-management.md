---
title: Use Azure API Management in a Multitenant Solution
description: Learn about Azure API Management features for multitenant solutions, including tenant isolation models, routing, authentication, caching, and rate limiting.
author: johndowns
ms.author: pnp
ms.date: 08/10/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Use Azure API Management in a multitenant solution

[Azure API Management](/azure/api-management/api-management-key-concepts) is a comprehensive API gateway and reverse proxy for APIs. It provides many features that are useful for API-focused applications, including caching, response mocking, and a developer portal. This article summarizes some of the key features of API Management that are useful for multitenant solutions.

> [!NOTE]
> This article focuses on how you can use API Management when you have your own multitenant applications that host APIs for internal or external use.
>
> Another form of multitenancy is to provide the API Management gateway as a service to other teams. For example, an organization might have a shared API Management instance that multiple application teams deploy to and use. This article doesn't discuss this form of multitenancy. Consider using [workspaces](/azure/api-management/workspaces-overview), which help you share an API Management instance across multiple teams who might have different levels of access.

## Isolation models

API Management is typically deployed as a shared component with a single instance that serves requests for multiple tenants. However, based on your [tenancy model](../considerations/tenancy-models.md), there are many ways that you can deploy API Management. This article assumes that you deploy your solution by using [deployment stamps](../approaches/overview.md#deployment-stamps-pattern).

Typically, the way API Management is used remains consistent across different isolation models. This section focuses on the differences in cost and complexity between the isolation models and how each approach routes requests to your back-end API applications.

| Consideration | Shared instance with single-tenant back ends | Shared instance with shared multitenant back end | Instance for each tenant |
|---|---|---|---|
| Number of supported tenants | Many | Almost unbounded | One for each instance |
| Cost | Lower | Lower | Higher |
| Deployment complexity | Low. Single instance to manage for each stamp. | Low. Single instance to manage for each stamp. | High. Multiple instances to manage. |
| Routing configuration complexity | Higher | Lower | Lower |
| Susceptibility to noisy-neighbor problems | Yes | Yes | No |
| Tenant-level network isolation | No | No | Yes |
| Example scenario | Custom domain names for each tenant | Large multitenant solution with a shared application tier | Tenant-specific deployment stamps |

### Shared instance isolation models

It's common to share an API Management instance between multiple tenants, which helps reduce cost and deployment and management complexity. The details of how you can share an API Management instance depend on how you assign tenants to back-end API applications.

#### Single-tenant back-end application

If you deploy distinct back-end applications for each tenant, then you can deploy a single API Management instance and route traffic to the correct tenant back end for each request. This approach requires you to configure API Management with the back-end hostnames for each tenant or to have another way to map an incoming request to the correct tenant's back end.

Because it requires an extra lookup, this approach might not scale to large numbers of tenants that share a single API Management instance. There might also be some performance overhead when you look up the tenant back end. However, the size of this performance overhead depends on how you design this lookup.

#### Shared multitenant back-end application

In scenarios where your tenants share a common back-end application, the API Management routing process is simplified because you can route all requests to a single back end. If you use wildcard domains or provider-issued domains, you might be able to achieve almost unbounded scale by using this approach. Also, because requests don't need to be mapped to a tenant's back end, there's no performance impact from customized routing decisions.

### Instance for each tenant

In some scenarios, you might deploy an instance of API Management for each tenant. We recommend this approach only if you have a few tenants or if you have strict compliance requirements that restrict you from sharing any infrastructure between tenants. For example, if you deploy a dedicated virtual network for each tenant, then you probably also need to deploy a dedicated API Management instance for each tenant.

> [!TIP]
> If your only reason for deploying multiple instances is to support users across different geographic regions, you might want to consider whether the [multiregion deployment](#multiregion-deployments) feature in API Management meets your requirements.

When you deploy an instance of API Management, you need to consider the [service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-api-management-limits), including any limits that might apply to the number of API Management instances within an Azure subscription or region.

Single-tenant instances typically have minimal routing configuration because you can route all requests to a single back end. This scenario doesn't require custom routing decisions, so there's no added performance impact. However, you typically incur a higher resource cost than if you deploy a shared instance. If you need to deploy single-tenant instances, consider whether [self-hosted gateways](/azure/api-management/self-hosted-gateway-overview) enable you to reuse tenant-specific compute resources that you already deploy.

## API Management features that support multitenancy

API Management uses [policies](/azure/api-management/api-management-howto-policies) to enable flexibility. You can customize how requests are validated, routed, and processed when you use policies. And when you design a multitenant solution with API Management, you use policies to implement many of its capabilities.

### Identify tenants on incoming requests

Consider how you can identify the appropriate tenant within each incoming request. In a multitenant solution, it's important to have a clear understanding of who is making each request so that you return the data for that specific tenant and nobody else.

API Management provides [subscriptions](/azure/api-management/api-management-subscriptions) that you can use to authenticate requests. These subscriptions use a unique *subscription key* that helps identify the subscriber who is making the request. If you choose to use subscriptions, consider how you can map the API Management subscriptions to your own tenant or customer identifiers. Subscriptions are tightly integrated into the developer portal. For most solutions, it's a good practice to use subscriptions to identify tenants.

Alternatively, you can identify the tenant by using other methods. The following example approaches run within a custom policy that you define:

- **Use a custom component of the URL, such as a subdomain, path, or query string.** For example, in the URL `https://api.contoso.com/tenant1/products`, you might extract the first part of the path, `tenant1`, and treat it as a tenant identifier. Similarly, given the incoming URL `https://tenant1.contoso.com/products`, you might extract the subdomain, `tenant1`. To use this approach, consider parsing the path or query string from the `Context.Request.Url` property.

- **Use a request header.** For example, your client applications might add a custom `TenantID` header to requests. To use this approach, consider reading from the `Context.Request.Headers` collection.

- **Extract claims from a JSON Web Token (JWT).** For example, you might have a custom `tenantId` claim in a JWT that your identity provider issues. To use this approach, use the [validate-jwt](/azure/api-management/validate-jwt-policy) policy and set the `output-token-variable-name` property so that your policy definition can read the values from the token.

- **Look up tenant identifiers dynamically.** You can communicate with an external database or service while the request is being processed. By taking this approach, you can create custom tenant mapping logic to map a logical tenant identifier to a specific URL or to obtain more information about a tenant. To apply this approach, use the [send-request](/azure/api-management/send-request-policy) policy.

   This approach is likely to increase the latency of your requests. To mitigate this effect, it's a good idea to use caching to reduce the number of calls to the external API. You can use the [cache-store-value](/azure/api-management/cache-store-value-policy) and [cache-lookup-value](/azure/api-management/cache-lookup-value-policy) policies to implement a caching approach. Be sure to invalidate your cache with each added, removed, or moved tenant that affects back-end lookup.

### Named values

API Management supports [named values](/azure/api-management/api-management-howto-properties), which are custom configuration settings that you can use throughout your policies. For example, you might use a named value to store a tenant's back-end URL and then reuse that same value in several places within your policies. If you need to update the URL, you can update it in a single place.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set the names of your named values. If the settings vary between tenants, make sure to include the tenant identifier in the name. For example, you can use a pattern like `tenantId-key:value` after you confirm that `tenantId` is suitable for the request.
>
> Include the identifier to reduce the chance of accidentally referring to or being manipulated into referring to another tenant's value when you process a request for another tenant.

### Authenticate incoming requests

API requests made to the API Management gateway usually need to be authenticated. API Management provides several methods of authenticating incoming requests to the gateway, including OAuth 2.0 and [client certificates](/azure/api-management/api-management-howto-mutual-certificates-for-clients). Consider the types of credentials that you should support and where they should be validated. For example, consider whether validation should happen in API Management, in your back-end applications, or in both places.

For more information, see [Authentication and authorization to APIs in API Management](/azure/api-management/authentication-authorization-overview).

> [!NOTE]
> If you use a subscription key or API key, it's a good practice to also use another method of authentication.
>
> A subscription key alone isn't a strong form of authentication. However, it's useful for other scenarios, such as for tracking an individual tenant's API usage.

### Route to tenant-specific back ends

When you use API Management as a shared component, you might need to route incoming API requests to different tenant-specific back ends. These back ends might be in different deployment stamps, or they might be different applications within a single stamp. To customize the routing in a policy definition, use the [set-backend-service](/azure/api-management/set-backend-service-policy) policy. You need to specify the new base URL that the request should be redirected to.

### Cache responses or other data

API Management has a powerful cache feature that you can use to cache entire HTTP responses or any other data. For example, you can use the cache for tenant mappings if you use custom logic or if you look up the mapping from an external service.

Use the [cache-store-value](/azure/api-management/cache-store-value-policy) and [cache-lookup-value](/azure/api-management/cache-lookup-value-policy) policies to implement a caching approach.

> [!WARNING]
> In a multitenant solution, it's important to be careful when you set your cache keys. If the cached data might vary between tenants, ensure that you include the tenant identifier in the cache key.
>
> Include the identifier to reduce the chance of accidentally referring to or being manipulated into referring to another tenant's value when you process a request for another tenant.

### Large language model APIs

Use the AI gateway features in API Management when your APIs call large language models. These features help you control cost, performance, and isolation in multitenant solutions.

#### Semantic caching

If your APIs sit in front of Azure OpenAI models, consider using semantic caching in API Management to reduce cost and latency for repeated or near-duplicate prompts.

For more information, see the following resources:

- [Enable semantic caching](/azure/api-management/azure-openai-enable-semantic-caching)
- [Cache responses to Azure OpenAI API requests](/azure/api-management/azure-openai-semantic-cache-store-policy)
- [Get cached responses of Azure OpenAI API requests](/azure/api-management/azure-openai-semantic-cache-lookup-policy)

You should partition the cache per tenant by using the `vary-by` element so prompts and answers are isolated to the tenant that they're intended for. Place the `lookup` policy in inbound processing and the `store` policy in outbound processing.

The following example shows how semantic cache entries are partitioned by subscription ID or key:

```xml
<!-- inbound -->
<azure-openai-semantic-cache-lookup
   score-threshold="0.05"
   embeddings-backend-id="embeddings-backend"
   embeddings-backend-auth="system-assigned">
   <vary-by>@(context.Subscription.Id)</vary-by>
   <!-- or: <vary-by>@(context.Subscription.Key)</vary-by> -->
</azure-openai-semantic-cache-lookup>

<!-- outbound -->
<azure-openai-semantic-cache-store duration="60" />
```

The following example partitions the semantic cache by tenant claim or header:

```xml
<!-- inbound; requires validate-jwt if using a claim -->
<azure-openai-semantic-cache-lookup
   score-threshold="0.05"
   embeddings-backend-id="embeddings-backend"
   embeddings-backend-auth="system-assigned">
   <vary-by>@(context.Principal?.Claims.GetValueOrDefault("tenantId", ""))</vary-by>
   <!-- Alternative using a custom header: -->
   <!-- <vary-by>@(context.Request.Headers.GetValueOrDefault("TenantID", ""))</vary-by> -->
</azure-openai-semantic-cache-lookup>

<!-- outbound -->
<azure-openai-semantic-cache-store duration="60" />
```

#### Token-based limits for large language models

Use token-based limits in the AI gateway to cap usage for each tenant, not only for individual requests. When you use Azure OpenAI back ends, use the [azure-openai-token-limit policy](/azure/api-management/azure-openai-token-limit-policy). For OpenAI-compatible back ends or the Azure AI Model Inference API, use the [llm-token-limit policy](/azure/api-management/llm-token-limit-policy). For more information, see [Token limit policy](/azure/api-management/genai-gateway-capabilities#token-limit-policy).

Select a key that's unique to the tenant, such as a subscription ID or tenant ID token claim, to ensure that limits effectively isolate each tenant. Token usage is tracked independently at each gateway, region, or workspace, and counters aren't aggregated across the entire instance.

The following example limits each tenant to 60,000 tokens per minute by subscription:

```xml
<azure-openai-token-limit
   counter-key="@(context.Subscription.Id)"
   tokens-per-minute="60000"
   estimate-prompt-tokens="false" />
```

The following example limits by tenant claim or header:

```xml
<!-- Using a tenant claim; requires validate-jwt earlier in the pipeline -->
<azure-openai-token-limit
   counter-key="@(context.Principal?.Claims.GetValueOrDefault(&quot;tenantId&quot;, &quot;&quot;))"
   tokens-per-minute="60000"
   estimate-prompt-tokens="false" />

<!-- Or using a custom header populated by your edge/CDN/gateway -->
<azure-openai-token-limit
   counter-key="@(context.Request.Headers.GetValueOrDefault(&quot;TenantID&quot;, &quot;&quot;))"
   tokens-per-minute="60000"
   estimate-prompt-tokens="false" />
```

> [!NOTE]
> Validate that the claim or header is present and non-empty before applying limits to avoid unintentionally collapsing many tenants under a single counter.

### Custom domains

Use API Management to configure your own [custom domains](/azure/api-management/configure-custom-domain) for the API gateway and developer portal. In some tiers, you can configure wildcard domains or multiple fully qualified domain names (FQDNs).

You can also use API Management together with a service like [Azure Front Door](front-door.md). In this kind of configuration, Azure Front Door frequently handles custom domains and Transport Layer Security (TLS) certificates and communicates with API Management by using a single domain name. If the original URL from the client includes tenant information that you need to send to the API Management instance for later processing, consider using the `X-Forwarded-Host` request header, or use [Azure Front Door rules](front-door.md#rules-engine) to pass the information as an HTTP header.

### Rate limits

It's common to apply quotas or rate limits in a multitenant solution. Rate limits can help you mitigate the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). You can also use rate limits to enforce quality of service and to differentiate between different pricing tiers.

Use API Management to enforce tenant-specific rate limits. If you use tenant-specific subscriptions, consider using the [quota](/azure/api-management/quota-policy) policy to enforce a quota for each subscription. Alternatively, consider using the [quota-by-key](/azure/api-management/quota-by-key-policy) policy to enforce quotas by using any other rate limit key, such as a tenant identifier that you obtain from the request URL or a JWT.

For more information, see [Token-based limits for large language models](#token-based-limits-for-large-language-models).

> [!IMPORTANT]
> The counter scope differs by policy and deployment topology:
>
> - The `rate-limit` and `rate-limit-by-key` policies maintain separate counters for each gateway replica. In multiregion or workspace gateway deployments, each regional or workspace gateway enforces its own counter.
>
> - The `azure-openai-token-limit` and `llm-token-limit` policies also track tokens for each gateway, region, or workspace and don't aggregate across the entire service instance.
>
> - The `quota` and `quota-by-key` policies are global at the service level and apply across regions for a specific instance.
>
> If you need a globally consistent per-tenant throttle, prefer quotas, enforce limits at an upstream edge that sees all traffic, or route a tenant to a single gateway or region.

### Monetization

The API Management documentation [provides extensive guidance about monetizing APIs](/azure/api-management/monetization-support), including a sample implementation. The monetization approaches combine many of the features of API Management so that developers can publish an API, manage subscriptions, and charge based on different usage models.

### Capacity management

An API Management instance supports a specific amount of [capacity](/azure/api-management/api-management-capacity), which represents the resources available to process your requests. When you use complex policies or deploy more APIs to the instance, you consume more capacity. You can manage the capacity of an instance in several ways, such as by purchasing more units. You can also dynamically scale the capacity of your instance.

Some multitenant instances might consume more capacity than single-tenant instances, like if you use many policies for routing requests to different tenant back ends. Consider capacity planning carefully, and plan to scale your instance's capacity if you see your usage increase. You should also test the performance of your solution to understand your capacity needs ahead of time.

For more information about scaling API Management, see [Upgrade and scale an API Management instance](/azure/api-management/upgrade-and-scale).

### Multiregion deployments

API Management [supports multiregion deployments](/azure/api-management/api-management-howto-deploy-multi-region), which means that you can deploy a single logical API Management resource across multiple Azure regions without needing to replicate its configuration onto separate resources. This capability is especially helpful when you distribute or replicate your solution globally. You can effectively deploy a fleet of API Management instances across multiple regions, which allows for low-latency request processing, and manage them as a single logical instance.

> [!IMPORTANT]
> Multiregion deployment is supported only in the Premium (classic) tier. It's not available in the Consumption, Developer, Basic, Standard, Basic v2, Standard v2, or Premium v2 (preview) tiers. If you're on v2 tiers and need to deploy across multiple regions, use a separate instance for each region, and use external routing (such as Azure Front Door) or consider self-hosted gateways.

However, if you need fully isolated API Management instances, you might also choose to deploy independent API Management resources into different regions. This approach separates the management plane for each API Management instance.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Senior Partner Solution Architect, Enterprise Partner Solutions

Other contributor:

- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resources

- [Architectural approaches for tenant integration and data access in multitenant solutions](../approaches/integration.md)
- [Architect multitenant solutions on Azure](../overview.md)
- [Checklist for architecting and building multitenant solutions on Azure](../checklist.md)
- [Tenancy models to consider for a multitenant solution](../considerations/tenancy-models.md)
