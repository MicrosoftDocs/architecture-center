---
title: Expose Azure Spring Cloud apps through a reverse proxy
description: Learn how to expose your Azure Spring Cloud apps securely using reverse proxy services such as Azure Application Gateway, Azure Front Door and Spring Cloud Gateway.
author: jelledruyts
ms.author: jelled
ms.date: 02/11/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-spring-cloud
  - azure-application-gateway
  - azure-front-door
categories:
  - web
  - networking
  - security
ms.custom: fcp
---

# Expose Azure Spring Cloud apps through a reverse proxy

When you host your apps or microservices in [Azure Spring Cloud](/azure/spring-cloud), you don't always want to publish them directly to the internet, but expose them through a reverse proxy instead. This allows you to place a service in front of your apps where you can define cross-cutting functionality such as Web Application Firewall (WAF) capabilities to secure your apps, load balancing, routing, request filtering, rate limiting, etc.

When you deploy a common reverse proxy service such as [Azure Application Gateway](/azure/application-gateway) or [Azure Front Door](/azure/frontdoor) in front of Azure Spring Cloud, you should ensure that your apps can *only* be reached through this reverse proxy: this prevents malicious users from attempting to bypass the Web Application Firewall or circumvent throttling limits, for example.

In this article, you will learn how to enforce access restrictions so that your Azure Spring Cloud apps are *only* accessible through your reverse proxy service. The way this can be achieved depends on how you have deployed your Azure Spring Cloud instance and which reverse proxy you use:

- When you **[deploy your Azure Spring Cloud instance in a Virtual Network (VNet)](/azure/spring-cloud/how-to-deploy-in-azure-virtual-network)**, you can [access your apps privately from within the network](/azure/spring-cloud/access-app-virtual-network).
  - In this case, you have control over the VNet in which your apps run, and you can use native Azure networking features such as Network Security Groups (NSGs) to lock down access to just your reverse proxy.
  - You can [expose the apps publicly to the internet using Application Gateway](/azure/spring-cloud/expose-apps-gateway) and then apply the appropriate access restrictions to lock it down (**[scenario 1](#scenario-1-using-application-gateway-as-the-reverse-proxy)**).
  - You cannot use Front Door directly however, because it cannot reach the Azure Spring Cloud instance in your private VNet. If required (for example, when you have a multi-region deployment of Azure Spring Cloud and require global load balancing) you can still place Front Door in front of Application Gateway (**[scenario 2](#scenario-2-using-front-door-and-application-gateway-as-the-reverse-proxy)**).
- When you deploy **Azure Spring Cloud outside of a VNet**, your apps are published to the internet directly if you assign them an endpoint.
  - In this case, you don't control the network and you can't use NSGs to restrict access. Allowing only the reverse proxy to access your apps therefore requires an approach within Azure Spring Cloud itself.
  - Given that your apps are reachable publicly, you can use either Application Gateway (**[scenario 3](#scenario-3-using-application-gateway-as-the-reverse-proxy)**) or Front Door (**[scenario 4](#scenario-4-using-front-door-as-the-reverse-proxy)**) as the reverse proxy. You can even use a combination of both, if required, which would then use the same access restrictions between the two reverse proxies as in [scenario 2](#scenario-2-using-front-door-and-application-gateway-as-the-reverse-proxy).

> [!NOTE]
> You can of course use other reverse proxy services than Application Gateway or Front Door. For VNet-based regional services, the guidance will then be similar to Application Gateway. When using non-Azure services, the guidance will be similar to using Front Door.

## Configuration summary

For each scenario, you can find a short summary of how to configure it below. For full details on each scenario, please refer to the relevant section.

- **[Scenario 1: Application Gateway with Azure Spring Cloud deployed in your VNet](#scenario-1-using-application-gateway-as-the-reverse-proxy)**.
  - For each app you want to expose, assign it an endpoint and map the appropriate custom domain(s) to that app.
  - For the backend pool in Application Gateway, use the assigned endpoint of each app.
  - On the "service runtime" subnet, add an NSG which only allows traffic from the Application Gateway subnet, the "apps" subnet and the Azure load balancer, while all other traffic is blocked.
- **[Scenario 2: Front Door and Application Gateway with Azure Spring Cloud deployed in your VNet](#scenario-2-using-front-door-and-application-gateway-as-the-reverse-proxy).**
  - Restrict access between Application Gateway and Azure Spring Cloud exactly like in **scenario 1**.
  - Create an NSG on the Application Gateway subnet which allows only the `AzureFrontDoor.Backend` Service Tag.
  - Create a custom WAF rule in Application Gateway which verifies that the `X-Azure-FDID` HTTP header is set to your specific Front Door instance.
- **[Scenario 3: Application Gateway with Azure Spring Cloud deployed outside of your VNet](#scenario-3-using-application-gateway-as-the-reverse-proxy).**
  - In this scenario, we assume use of Spring Cloud Gateway to expose the backend apps. This means that only the Spring Cloud Gateway app needs an endpoint assigned, and the custom domain(s) of all backend apps should be mapped to this single Spring Cloud Gateway app.
  - For the backend pool in Application Gateway, use the assigned endpoint of the Spring Cloud Gateway app.
  - In Spring Cloud Gateway, set the `XForwarded Remote Addr` route predicate to the public IP address of Application Gateway.
  - Optionally, in your Spring Framework apps, set the `server.forward-headers-strategy` application property to `FRAMEWORK`.
- **[Scenario 4: Front Door with Azure Spring Cloud deployed outside of your VNet](#scenario-4-using-front-door-as-the-reverse-proxy).**
  - In this scenario, we assume use of Spring Cloud Gateway to expose the backend apps. This means that only the Spring Cloud Gateway app needs an endpoint assigned, and the custom domain(s) of all backend apps should be mapped to this single Spring Cloud Gateway app.
  - For the backend pool or origin in Front Door, use the assigned endpoint of the Spring Cloud Gateway app.
  - In Spring Cloud Gateway, set the `XForwarded Remote Addr` route predicate to all outbound IP ranges of Front Door (and keep this up to date) and set the `Header` route predicate to ensure the `X-Azure-FDID` HTTP header contains your unique `Front Door ID`.
  - Optionally, in your Spring Framework apps, set the `server.forward-headers-strategy` application property to `FRAMEWORK`.

## Azure Spring Cloud deployed in your Virtual Network

When Azure Spring Cloud is deployed in a VNet, it uses [two subnets](/azure/spring-cloud/how-to-deploy-in-azure-virtual-network#virtual-network-requirements): a "service runtime" subnet which contains the relevant network resources, and an "apps" subnet in which your code is hosted. Given that [the "service runtime" subnet contains the load balancer that you use to connect to the apps](/azure/spring-cloud/access-app-virtual-network#find-the-ip-for-your-application), you can define a Network Security Group (NSG) on this "service runtime" subnet to allow only traffic from your reverse proxy. By blocking all other traffic, nobody in the VNet can access your apps without going through the reverse proxy.

> [!IMPORTANT]
> Restricting subnet access to only the reverse proxy may break features that depend on a direct connection from a client device to the app, such as [log streaming](/azure/spring-cloud/how-to-log-streaming). Consider adding NSG rules specifically for those client devices, and only for the period of time during which that direct access is required.

Each app that you want to expose through your reverse proxy should have an endpoint assigned so that the reverse proxy can reach it in the VNet. For each app you should also [map the custom domain(s)](/azure/spring-cloud/tutorial-custom-domain#map-your-custom-domain-to-azure-spring-cloud-app) it uses, so that you can avoid overriding the HTTP `Host` header in the reverse proxy and keep the original host name intact. This avoids issues such as cookies being broken or redirect URLs not working properly: see the [Host name preservation best practice](../../best-practices/host-name-preservation.md) guidance for more information.

> [!NOTE]
> Alternatively (or, for defense in depth, perhaps even *in addition to* the NSG) you can follow the guidance for when you have [Azure Spring Cloud deployed outside of your Virtual Network](#azure-spring-cloud-deployed-outside-of-your-virtual-network). As explained in that section, access restrictions would then typically be achieved with Spring Cloud Gateway (which also has an impact on the backend apps as they no longer need an assigned endpoint or custom domain).

### Scenario 1: Using Application Gateway as the reverse proxy

![Using Application Gateway with Azure Spring Cloud in a VNet](_images/ra-scrp-scenario-appgw-private-asc.png)

When Application Gateway sits in front of your Azure Spring Cloud instance, you use the assigned endpoint of the Spring Cloud Gateway app as the backend pool (for example, `myspringcloudservice-myapp.private.azuremicroservices.io`). This resolves to a private IP address in the "service runtime" subnet. Therefore, to restrict access, you can place an NSG on the "service runtime" subnet with the following **inbound security rules** (with the "Deny" rule having the least priority):

| Action | Source Type | Source Value | Protocol | Destination Port Ranges |
| - | - | - | - | - |
| Allow | IP Addresses | The private IP range of the Application Gateway subnet (for example, `10.1.2.0/24`) | `TCP` | `80, 443` (or other ports as appropriate) |
| Allow | IP Addresses | The private IP range of the Azure Spring Cloud "apps" subnet (for example, `10.1.1.0/24`) | `TCP` | `*` |
| Allow | Service Tag | `AzureLoadBalancer` | `Any` | `*` |
| Deny | Service Tag | `VirtualNetwork` | `Any` | `*` |

This ensures that the "service runtime" subnet only allows traffic from the ([dedicated](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet)) Application Gateway subnet, the "apps" subnet (bidirectional communication between the two Azure Spring Cloud subnets is required) and the Azure load balancer (which is a general Azure platform requirement), while all other traffic is blocked.

### Scenario 2: Using Front Door and Application Gateway as the reverse proxy

As previously discussed, you cannot place Front Door directly in front of Azure Spring Cloud because it cannot reach into your private VNet. (Note that [Front Door Standard/Premium can connect to private endpoints in a VNet](/azure/frontdoor/standard-premium/concept-private-link), but Azure Spring Cloud does not offer private endpoint support today). If you still want to use Front Door, for example when you require global load balancing across multiple instances of Azure Spring Cloud in different Azure regions, you can expose them via Application Gateway first and then place Front Door in front of Application Gateway.

![Using Front Door and Application Gateway with Azure Spring Cloud in a VNet](_images/ra-scrp-scenario-afd-appgw-private-asc.png)

In this case, the access restrictions between Application Gateway and Azure Spring Cloud are exactly the same as with [scenario 1](#scenario-1-using-application-gateway-as-the-reverse-proxy): you place an NSG on the "service runtime" subnet with the appropriate rules.

On top of that, you now also have to ensure Application Gateway only accepts traffic coming from your Front Door instance. The Front Door documentation explains [how to lock down access to a backend to only Front Door](/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door-), and when the backend is Application Gateway this can be achieved as follows:

- Create an NSG on the Application Gateway subnet which allows only the `AzureFrontDoor.Backend` Service Tag (so that nothing except Front Door can reach Application Gateway). Take care to also include other required Service Tags as called out in the [NSG restrictions for Application Gateway](/azure/application-gateway/configuration-infrastructure#network-security-groups).
- Create a [custom WAF rule in Application Gateway which verifies that the `X-Azure-FDID` HTTP header is set to your specific Front Door instance](/azure/web-application-firewall/ag/create-custom-waf-rules#example-7) (so that no *other customer's* Front Door instances - which use the same IP ranges - can reach your Application Gateway).

## Azure Spring Cloud deployed outside of your Virtual Network

### Using Spring Cloud Gateway to expose and secure your apps

When you deploy Azure Spring Cloud outside of a VNet, you cannot use native Azure networking features as you don't control the network. This means you have to apply the necessary access restrictions on your apps themselves so that they allow only traffic from the reverse proxy. When you have many apps, this can add complexity, and there is a risk that not every app will be configured appropriately.

To remove this responsibility from the developers of the individual applications, you can instead apply these cross-cutting concerns using [Spring Cloud Gateway](https://spring.io/projects/spring-cloud-gateway), a commonly used Spring project that you can deploy into Azure Spring Cloud just like any other app. This allows you to keep your own applications private within the Azure Spring Cloud instance, and ensure they can only be accessed through the shared Spring Cloud Gateway app. This in turn is then configured with the necessary access restrictions by means of [route predicates](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#gateway-request-predicates-factories), which are a built-in feature of Spring Cloud Gateway. These route predicates can use different attributes of the incoming HTTP request (such as the client IP address, request method or path, HTTP headers, etc.) to determine whether or not to route the request to the actual application or reject it.

> [!IMPORTANT]
> When you place Spring Cloud Gateway in front of your "real" backend apps in this way, you have to [map all your custom domains to the Spring Cloud Gateway app itself](/azure/spring-cloud/tutorial-custom-domain#map-your-custom-domain-to-azure-spring-cloud-app), rather than to the actual backend apps. Otherwise, Azure Spring Cloud will not route incoming traffic to your Spring Cloud Gateway first when a request comes in for any of those custom domains.
> Note that this already assumes your reverse proxy does not override the HTTP `Host` header and keeps the original host name intact: see the [Host name preservation best practice](../../best-practices/host-name-preservation.md) guidance for more information.

As this is a very commonly used pattern, we will assume that you expose your actual applications through Spring Cloud Gateway, and use its route predicates to set up the necessary access restrictions for ensuring that only requests coming from the reverse proxy are allowed. However, even if you don't use Spring Cloud Gateway, the same general principles apply, but you will have to build your own request filtering capabilities into your apps - based on the same `X-Forwarded-For` HTTP header that we will discuss later.

> [!NOTE]
> Spring Cloud Gateway is itself also a reverse proxy which provides services such as routing, request filtering and rate limiting. If it has all the features you need for your specific scenario, you may not need an additional reverse proxy like Application Gateway or Front Door. The most common reasons to still consider these Azure services are for the Web Application Firewall features they both provide, or for the global load balancing capabilities that Front Door offers.

The details of how Spring Cloud Gateway works is outside the scope for this article, as it is a highly flexible service that you can customize via code or configuration. For simplicity, we will only cover a purely configuration-driven approach which doesn't require any code changes. This can be achieved either by including the traditional [`application.properties` or `application.yml`](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files) file in the deployed Spring Cloud Gateway app, or by using a [Config Server in Azure Spring Cloud](/azure/spring-cloud/how-to-config-server) which externalizes that configuration file into a Git repository. In the examples below, we will use the `application.yml` approach based on YAML syntax, but the equivalent `application.properties` syntax would work equally well.

#### Routing requests to your applications

By default, when your app in Azure Spring Cloud doesn't have an endpoint assigned or a custom domain configured, it isn't reachable from the outside. When an app [registers itself with the Spring Cloud Service Registry](/azure/spring-cloud/how-to-service-registration), it can be discovered by Spring Cloud Gateway so that it can use routing rules to forward traffic to the right destination app.

As a consequence, the only app that needs to have an endpoint assigned in Azure Spring Cloud is your Spring Cloud Gateway app so that it becomes reachable from the outside, but none of the other apps should have an endpoint assigned: this avoids that they can be reached directly without passing through Spring Cloud Gateway, which in turn prevents that the reverse proxy can be bypassed.

One easy way to simply expose *all* registered apps through Spring Cloud Gateway is by using the [DiscoveryClient route definition locator](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-discoveryclient-route-definition-locator) approach as follows:

```yaml
spring:
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          predicates:
          - Path="/"+serviceId+"/**" # Include the Path predicate to retain default behavior
          - (...)
```

Alternatively, you can *selectively* expose certain apps through Spring Cloud Gateway by defining app-specific routes as in the following example:

```yaml
spring:
  cloud:
    gateway:
      routes:
      - id: my_app1_route
        uri: lb://MY-APP1
        filters:
        - RewritePath=/myapp1(?<segment>/?.*), $\{segment}
        predicates:
        - (...)
```

Both with the discovery locator approach as well as with the explicit route definitions, you can use route predicates to reject invalid requests: in this case we will use that functionality to block requests that don't come from the expected reverse proxy that sits in front of Azure Spring Cloud.

#### Restricting access using the `X-Forwarded-For` HTTP header

When you deploy an app into Azure Spring Cloud, the HTTP client or reverse proxy does not connect directly to it, but network traffic goes through an internal ingress controller first.

> [!NOTE]
> In case you're counting, this does indeed mean that you have 3 or even 4 reverse proxies in the request pipeline before you reach your app in the scenarios below: Front Door and/or Application Gateway, the ingress controller, as well as your Spring Cloud Gateway app.

Because of this additional service, the IP address of the *direct* network client will always be an internal Azure Spring Cloud component and never the "logical" client such as the reverse proxy that you are expecting to call your app. This means that you cannot use the client IP address for access restrictions, and you therefore can't use Spring Cloud Gateway's built-in [`RemoteAddr` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-remoteaddr-route-predicate-factory) for request filtering - as this uses the client IP address by default.

Fortunately, Azure Spring Cloud always adds the "logical" client's IP address to the `X-Forwarded-For` HTTP header on the request into your app. This means that **the last (right-most) value of the `X-Forwarded-For` header will always contain the IP address of the logical client**.

To filter requests based on the `X-Forwarded-For` header, you can use the built-in [`XForwarded Remote Addr` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-xforwarded-remote-addr-route-predicate-factory), which allows you to configure a list of IP addresses or IP ranges of your reverse proxy which are allowed as the last (right-most) value.

> [!NOTE]
> This `XForwarded Remote Addr` route predicate requires Spring Cloud Gateway version 3.1.1 or later, which shipped in the [Spring Cloud 2021.0.1](https://github.com/spring-cloud/spring-cloud-release/wiki/Spring-Cloud-2021.0-Release-Notes#202101) release train. If you cannot use this version, you can alternatively make a few code changes to your Spring Cloud Gateway app to [modify the way the `RemoteAddr` route predicate determines the client IP address](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#modifying-the-way-remote-addresses-are-resolved). To achieve the same result as with the `XForwarded Remote Addr` route predicate, you can set it up to use the `XForwardedRemoteAddressResolver` and configure that with a `maxTrustedIndex` set to `1`: this will make it use the right-most value of the `X-Forwarded-For` header as the logical client IP address.

#### Configuring your app to see the correct host name and request URL

When you use Spring Cloud Gateway, there is one important factor you should take into account: it sets the HTTP `Host` header on the outbound request to the internal IP address of your app instance (for example, `Host: 10.2.1.15:1025`). This means that the request's host name that your application code will see is no longer the original host name of the request that the browser sent (for example, `contoso.com`). In some cases, this can lead to issues such as cookies being broken or redirect URLs not working properly. For more details on these types of issues and how to configure a reverse proxy service like Application Gateway or Front Door correctly to avoid them, see the [Host name preservation best practice](../../best-practices/host-name-preservation.md) guidance.

Spring Cloud Gateway does provide the original host name in the [`Forwarded` header](https://datatracker.ietf.org/doc/html/rfc7239) and sets additional headers such as `X-Forwarded-Port`, `X-Forwarded-Proto` and `X-Forwarded-Prefix`, so that your application can use these to reconstruct the original request URL. In Spring Framework applications, this can be achieved automatically by setting `server.forward-headers-strategy` to `FRAMEWORK` in your application properties (do not set it to `NATIVE` as this uses other headers, and doesn't take the required `X-Forwarded-Prefix` header into account). See [Running Behind a Front-end Proxy Server](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.webserver.use-behind-a-proxy-server) for more information. At that point, the [HttpServletRequest.getRequestURL()](https://javaee.github.io/javaee-spec/javadocs/javax/servlet/http/HttpServletRequest.html#getRequestURL--) method for example will take all these headers into account and return the exact request URL as sent by the browser.

> [!NOTE]
> You could be tempted to use the [`PreserveHostHeader` filter](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-preservehostheader-gatewayfilter-factory) in Spring Cloud Gateway, which would maintain the original host name on the outbound request. However, this wouldn't work as that host name is already mapped as a custom domain on the Spring Cloud Gateway app and it cannot be mapped a second time on the final backend app. This will result in an `HTTP 404` error as the backend app will reject the incoming request based on a host name it doesn't recognize.

### Scenario 3: Using Application Gateway as the reverse proxy

![Using Application Gateway with Azure Spring Cloud outside a VNet](_images/ra-scrp-scenario-appgw-public-asc.png)

When Application Gateway sits in front of your Azure Spring Cloud instance, you use the assigned endpoint of the Spring Cloud Gateway app as the backend pool (for example, `myspringcloudservice-mygateway.azuremicroservices.io`). Because Azure Spring Cloud is deployed outside a VNet, this URL resolves to a public IP address. [When the backend pool is a public endpoint, Application Gateway uses its frontend public IP address to reach the backend service](/azure/application-gateway/how-application-gateway-works#how-an-application-gateway-routes-a-request).

Therefore, to allow only requests from your Application Gateway instance to reach your Spring Cloud Gateway, you can configure the `XForwarded Remote Addr` route predicate to allow only requests from your Application Gateway's dedicated public IP address, as in the following example:

```yaml
(...)
predicates:
- XForwardedRemoteAddr="20.103.252.85"
```

### Scenario 4: Using Front Door as the reverse proxy

![Using Front Door with Azure Spring Cloud outside a VNet](_images/ra-scrp-scenario-afd-public-asc.png)

Similar to the previous scenario, you use the public URL of the Spring Cloud Gateway app as the backend pool or origin in Front Door (for example, `https://myspringcloudservice-mygateway.azuremicroservices.io`).

Because Front Door is a global service with many [edge locations](/azure/frontdoor/edge-locations-by-region), there are *many* IP addresses it uses to communicate with its backend pool. The Front Door documentation explains [how to lock down access to a backend to only Front Door](/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door-), but since you don't control the Azure network in which your apps are deployed in this scenario, you unfortunately cannot use the `AzureFrontDoor.Backend` Service Tag anywhere to have the complete list of outbound Front Door IP addresses that is guaranteed to be always up-to-date. Instead, you have to download the [Azure IP Ranges and Service Tags](https://www.microsoft.com/download/details.aspx?id=56519), look for the `AzureFrontDoor.Backend` section, and copy *all* IP ranges from the `addressPrefixes` array into the `XForwarded Remote Addr` route predicate configuration.

> [!IMPORTANT]
> The IP ranges that Front Door uses can change periodically. The authoritative [Azure IP Ranges and Service Tags](https://www.microsoft.com/download/details.aspx?id=56519) file is published weekly and in advance of any actual IP range changes. To ensure that your configuration is up to date, you should verify the IP ranges weekly and update when needed (ideally in an automated way). If you want to avoid the maintenance overhead of this approach, you can deploy Azure Spring Cloud in a VNet and use the alternative scenarios above by using an NSG with the `AzureFrontDoor.Backend` Service Tag.

Because the Front Door IP ranges are shared with other customers, you also have to ensure that you lock down access to only *your specific Front Door instance*, based on the `X-Azure-FDID` HTTP header which contains your unique `Front Door ID`. This can be achieved with the [`Header` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-header-route-predicate-factory), which rejects the request unless a specified HTTP header has a certain value.

In this scenario, your Spring Cloud Gateway's route predicate configuration can then look like the following example:

```yaml
(...)
predicates:
- XForwardedRemoteAddr="13.73.248.16/29","20.21.37.40/29","20.36.120.104/29","20.37.64.104/29", ...(and many more)...
- Header="X-Azure-FDID", "e483e3cc-e7f3-4e0a-9eca-5f2a62bde229"
```

## Next steps

<!--
- Bulleted list of third-party and other Docs and Microsoft links.
- Links shouldn't include en-us locale unless they don't work without it.
- Docs links should be site-relative, for example (/azure/feature/article-name).
- Don't include trailing slash in any links.
-->
- [Azure Spring Cloud reference architecture](/azure/spring-cloud/reference-architecture)
- [Customer responsibilities for running Azure Spring Cloud in VNET](/azure/spring-cloud/vnet-customer-responsibilities#azure-spring-cloud-resource-requirements)

## Related resources

<!--
- Links to related Azure Architecture Center articles.
- Links should be repo-relative, for example (../../solution-ideas/articles/article-name.yml).
-->
- [Host name preservation best practice](../../best-practices/host-name-preservation.md)
- [Load-balancing options](../../guide/technology-choices/load-balancing-overview.yml)
- [Microservices architecture style](../../guide/architecture-styles/microservices.md)
