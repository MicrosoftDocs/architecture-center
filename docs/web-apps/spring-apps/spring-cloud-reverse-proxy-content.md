When you host your apps or microservices in [Azure Spring Apps](/azure/spring-cloud), you don't always want to publish them directly to the internet. You might want to expose them through a reverse proxy instead. This approach allows you to place a service in front of your apps. The service can define cross-cutting functionality like web application firewall (WAF) capabilities to help secure your apps, load balancing, routing, request filtering, and rate limiting.

When you deploy a common reverse proxy service like [Azure Application Gateway](/azure/application-gateway) or [Azure Front Door](/azure/frontdoor) in front of Azure Spring Apps, you should ensure your apps can be reached only through the reverse proxy. This safeguard helps to prevent malicious users from trying to bypass the WAF or circumvent throttling limits.

[Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable Azure DDOS Protection Standard on any perimeter virtual network.

This article describes how to enforce access restrictions so applications hosted in Azure Spring Apps are accessible only through a reverse proxy service. The recommended way to enforce these restrictions depends on how you deploy your Azure Spring Apps instance and which reverse proxy you use. The are different points to consider depending on whether you deploy within or outside of a virtual network. This article provides information about *four scenarios*.

- **[Deploy Azure Spring Apps within a virtual network](/azure/spring-cloud/how-to-deploy-in-azure-virtual-network)** and [access your apps privately from within the network](/azure/spring-cloud/access-app-virtual-network).

   - You have control over the virtual network in which your apps run. Use native Azure networking features like network security groups (NSGs) to lock down access to allow only your reverse proxy.

   - You can [expose your apps publicly to the internet by using Azure Application Gateway](/azure/spring-cloud/expose-apps-gateway) and then apply the appropriate access restrictions to lock it down. This approach is described in [**Scenario 1**](#scenario-1-use-application-gateway-as-the-reverse-proxy) later in this article.
  
   - You can't use Azure Front Door directly because it can't reach the Azure Spring Apps instance in your private virtual network. Azure Front Door can connect to backends only through a public IP address or via services that use a private endpoint. When you have a multi-region deployment of Azure Spring Apps and require global load balancing, you can still expose your Azure Spring Apps instances through Application Gateway. To achieve this scenario, you place Azure Front Door in front of Application Gateway. This approach is described in [**Scenario 2**](#scenario-2-use-both-azure-front-door-and-application-gateway-as-the-reverse-proxy) later in this article.

- **Deploy Azure Spring Apps outside a virtual network** and publish your apps to the internet directly, if you assign them an endpoint.

   - You don't control the network and you can't use NSGs to restrict access. Allowing only the reverse proxy to access your apps requires an approach within Azure Spring Apps itself.
   
   - Because your apps are publicly reachable, you can use Application Gateway or Azure Front Door as the reverse proxy. The Application Gateway approach is described in [**Scenario 3**](#scenario-3-use-application-gateway-with-spring-cloud-gateway) later in this article. The Azure Front Door approach is described in [**Scenario 4**](#scenario-4-use-azure-front-door-with-spring-cloud-gateway) later in this article.

   - You can use a combination of both approaches, as needed. If you use both Application Gateway and Azure Front Door, use the same access restrictions between the two reverse proxies that are used in [Scenario 2](#scenario-2-use-both-azure-front-door-and-application-gateway-as-the-reverse-proxy).

> [!NOTE]
> You can use other reverse proxy services instead of Application Gateway or Azure Front Door. For regional services that are based in an Azure virtual network, like Azure API Management, the guidance is similar to the guidance for Application Gateway. If you use non-Azure services, the guidance is similar to the guidance for Azure Front Door.

## Scenario comparison

The following table provides a brief comparison of the four reverse proxy configuration scenarios for Azure Spring Apps. For full details on each scenario, refer to the appropriate section of this article.

| Scenario | Deployment | Services | Configuration |
| --- | --- | --- | --- |
| [**1**](#scenario-1-use-application-gateway-as-the-reverse-proxy) | Inside virtual network | Application Gateway | - For each app you want to expose, assign it an endpoint and map the appropriate custom domain or domains to that app. <br> - For the back-end pool in Application Gateway, use the assigned endpoint of each app. <br> - In the service runtime subnet, add an NSG to allow traffic only from the Application Gateway subnet, the apps subnet, and the Azure load balancer. Block all other traffic. |
| [**2**](#scenario-2-use-both-azure-front-door-and-application-gateway-as-the-reverse-proxy) | Inside virtual network | Azure Front Door *and* Application Gateway | - Restrict access between Application Gateway and Azure Spring Apps by using the same approach described for Scenario 1. <br> - On the Application Gateway subnet, create an NSG to allow only traffic that has the `AzureFrontDoor.Backend` service tag. <br> - Create a custom WAF rule in Application Gateway to verify the `X-Azure-FDID` HTTP header contains your specific Azure Front Door instance ID. |
| [**3**](#scenario-3-use-application-gateway-with-spring-cloud-gateway) | Outside virtual network | Application Gateway *with* Spring Cloud Gateway | - Use Spring Cloud Gateway to expose your back-end apps. Only the Spring Cloud Gateway app requires an assigned endpoint. The custom domains of all back-end apps should be mapped to this single Spring Cloud Gateway app. <br> - For the back-end pool in Application Gateway, use the assigned endpoint of the Spring Cloud Gateway app. <br> - In Spring Cloud Gateway, set the `XForwarded Remote Addr` route predicate to the public IP address of Application Gateway. <br> - Optionally, in your Spring Framework apps, set the `server.forward-headers-strategy` application property to `FRAMEWORK`. |
| [**4**](#scenario-4-use-azure-front-door-with-spring-cloud-gateway) | Outside virtual network | Azure Front Door *with* Spring Cloud Gateway | - Use Spring Cloud Gateway to expose your back-end apps. Only the Spring Cloud Gateway app requires an assigned endpoint. The custom domains of all back-end apps should be mapped to this single Spring Cloud Gateway app. <br> - For the back-end pool or origin in Azure Front Door, use the assigned endpoint of the Spring Cloud Gateway app. <br> - In Spring Cloud Gateway, set the `XForwarded Remote Addr` route predicate to all outbound IP ranges of Azure Front Door, and keep this setting current. Set the `Header` route predicate to ensure that the `X-Azure-FDID` HTTP header contains your unique Azure Front Door ID. <br> - Optionally, in your Spring Framework apps, set the `server.forward-headers-strategy` application property to `FRAMEWORK`. |

> [!NOTE]
> After you set up your configuration, consider using [Azure Policy](/azure/governance/policy) or [resource locks](/azure/azure-resource-manager/management/lock-resources) to prevent accidental or malicious changes that might allow the reverse proxy to be bypassed and the application to be exposed directly. This safeguard applies only to the Azure resources (specifically, the NSGs) because configuration *within* Azure Spring Apps isn't visible to the Azure control plane.

## Deployment inside your virtual network

When Azure Spring Apps is deployed in a virtual network, it uses [two subnets](/azure/spring-cloud/how-to-deploy-in-azure-virtual-network#virtual-network-requirements):

- A service runtime subnet that contains the relevant network resources
- An apps subnet that hosts your code

Because the service runtime subnet contains the load balancer for connecting to your apps, you can define an NSG on this service runtime subnet to allow traffic from your reverse proxy only. When you block all other traffic, no one in the virtual network can access your apps without going through the reverse proxy.

> [!IMPORTANT]
> Restricting subnet access to only the reverse proxy might cause failures in features that depend on a direct connection from a client device to the app, such as [log streaming](/azure/spring-cloud/how-to-log-streaming). Consider adding NSG rules specifically for those client devices, and for only when specific direct access is required.

Each app that you want to expose through your reverse proxy should have an assigned endpoint so the reverse proxy can reach the app in the virtual network. For each app, you should also [map the custom domains](/azure/spring-cloud/tutorial-custom-domain#map-your-custom-domain-to-azure-spring-apps-app) it uses to avoid overriding the HTTP `Host` header in the reverse proxy and keep the original host name intact. This method avoids problems like broken cookies or redirect URLs that don't work properly. For more information, see [Host name preservation](../../best-practices/host-name-preservation.yml).

> [!NOTE]
> Alternatively (or, for defense in depth, possibly in addition to the NSG) you can follow the guidance for when you have [Azure Spring Apps deployed outside your virtual network](#deployment-outside-your-virtual-network). That section explaings how access restrictions are typically achieved by using Spring Cloud Gateway, which also affects the back-end apps because they no longer need an assigned endpoint or custom domain.

### Scenario 1: Use Application Gateway as the reverse proxy

Scenario 1 describes how to [expose your apps publicly to the internet by using Application Gateway](/azure/spring-cloud/expose-apps-gateway) and then apply the appropriate access restrictions to lock it down.

The following diagram depicts the architecture for Scenario 1:

:::image type="content" source="_images/application-gateway-reverse-proxy-virtual-network.png" alt-text="Diagram that shows the use of Azure Application Gateway with Azure Spring Apps in a virtual network." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/scenario1.vsdx) of this architecture.*

When Application Gateway sits in front of your Azure Spring Apps instance, you use the assigned endpoint of the Spring Cloud Gateway app as the back-end pool. An example endpoint is `myspringcloudservice-myapp.private.azuremicroservices.io`. The endpoint resolves to a private IP address in the service runtime subnet. Therefore, to restrict access, you can place an NSG on the service runtime subnet with the following inbound security rules (giving the Deny rule the lowest priority):

| Action | Source type | Source value | Protocol | Destination port ranges |
| --- | --- | --- | --- | --- |
| **Allow** | IP addresses | The private IP range of the Application Gateway subnet (for example, `10.1.2.0/24`). | `TCP` | `80, 443` (or other ports as appropriate) |
| **Allow** | IP addresses | The private IP range of the apps subnet in Azure Spring Apps (for example, `10.1.1.0/24`). | `TCP` | `*` |
| **Allow** | Service tag | `AzureLoadBalancer` | `Any` | `*` |
| **Deny** | Service tag | `Any` | `Any` | `*` |

The Scenario 1 configuration ensures the service runtime subnet allows traffic only from the following sources:

- The [dedicated](/azure/application-gateway/configuration-infrastructure#virtual-network-and-dedicated-subnet) Application Gateway subnet
- The apps subnet (Bidirectional communication between the two Azure Spring Apps subnets is required.)
- The Azure load balancer (which is a general Azure platform requirement)

All other traffic is blocked.

### Scenario 2: Use both Azure Front Door and Application Gateway as the reverse proxy

As previously noted, you can't place Azure Front Door directly in front of Azure Spring Apps because it can't reach into your private virtual network. ([Azure Front Door Standard or Premium can connect to private endpoints in a virtual network](/azure/frontdoor/private-link), but Azure Spring Apps doesn't currently offer private endpoint support.) If you still want to use Azure Front Door, such as to require global load balancing across multiple instances of Azure Spring Apps in different Azure regions, you can still expose your apps via Application Gateway. To achieve this scenario, you place Azure Front Door in front of Application Gateway.

The following diagram depicts the architecture for Scenario 2:

:::image type="content" source="_images/azure-front-door-application-gateway-reverse-proxy.png" alt-text="Diagram that shows the use of Azure Front Door and Azure Application Gateway with Azure Spring Apps in a virtual network." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/scenario2.vsdx) of this architecture.*

The Scenario 2 configuration implements access restrictions between Application Gateway and Azure Spring Apps in the same manner as [Scenario 1](#scenario-1-use-application-gateway-as-the-reverse-proxy). You place an NSG on the service runtime subnet with the appropriate rules.

In Scenario 2, you also have to ensure that Application Gateway accepts traffic coming only from your Azure Front Door instance. The Azure Front Door documentation explains [how to lock down access to a backend to allow only Azure Front Door traffic](/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door-). When the back end is Application Gateway, you can implement this restriction as follows:

- On the Application Gateway subnet, create an NSG to allow only traffic that has the `AzureFrontDoor.Backend` service tag (nothing except Azure Front Door can reach Application Gateway). Be sure to also include other required service tags, as described in [NSG restrictions for Application Gateway](/azure/application-gateway/configuration-infrastructure#network-security-groups).
- Create a [custom WAF rule in Application Gateway to verify the `X-Azure-FDID` HTTP header is set to your specific Azure Front Door instance ID](/azure/web-application-firewall/ag/create-custom-waf-rules#example-7). This method ensures that no other organization's Azure Front Door instances that use the same IP ranges can reach your Application Gateway instance.

## Deployment outside your virtual network

When you deploy Azure Spring Apps outside of a virtual network, you can't use native Azure networking features because you don't control the network. Instead, you have to apply the necessary access restrictions on the apps themselves to allow traffic only from the reverse proxy. If you have many apps, this approach can add complexity, and there's a risk that not every app can be configured appropriately.

### Use Spring Cloud Gateway to expose and help secure your apps

To remove the responsibility of access control from the developers of individual applications, you can apply cross-cutting restrictions by using [Spring Cloud Gateway](https://spring.io/projects/spring-cloud-gateway). Spring Cloud Gateway is a commonly used Spring project that you can deploy into Azure Spring Apps just like any other app. By using Spring Cloud Gateway, you can keep your own applications private within the Azure Spring Apps instance and ensure it can be accessed only through the shared Spring Cloud Gateway app. You then configure this app with the necessary access restrictions by using [route predicates](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#gateway-request-predicates-factories), which are a built-in feature of Spring Cloud Gateway. Route predicates can use different attributes of the incoming HTTP request to determine whether to route the request to the back-end application or reject it. The predicate can use attributes such as the client IP address, request method or path, HTTP headers, and so on.

> [!IMPORTANT]
> When you place Spring Cloud Gateway in front of your back-end apps in this manner, you have to [map all your custom domains to the Spring Cloud Gateway app](/azure/spring-cloud/tutorial-custom-domain#map-your-custom-domain-to-azure-spring-apps-app) rather than to the back-end apps. Otherwise, Azure Spring Apps won't route incoming traffic to your Spring Cloud Gateway first when a request comes in for any of those custom domains.
>
> This approach assumes that your reverse proxy doesn't override the HTTP `Host` header and keeps the original host name intact. For more information, see [Host name preservation ](../../best-practices/host-name-preservation.yml).

This pattern is commonly used. For the purposes of this article, we assume that you expose your applications through Spring Cloud Gateway. We expect that you use its route predicates to set up the necessary access restrictions to ensure that only requests from the reverse proxy are allowed. Even if you don't use Spring Cloud Gateway, the same general principles apply. However, you have to build your own request filtering capabilities into your apps based on the same `X-Forwarded-For` HTTP header that's discussed later in this article.

> [!NOTE]
> Spring Cloud Gateway is itself also a reverse proxy that provides services like routing, request filtering, and rate limiting. If this service provides all the features you need for your scenario, you might not need an additional reverse proxy like Application Gateway or Azure Front Door. The most common reasons to still consider using the other Azure services are for the WAF features that they both provide or for the global load balancing capabilities that Azure Front Door offers.

Describing how Spring Cloud Gateway works is outside the scope of this article. It's a highly flexible service that you can customize via code or configuration. To keep things simple, this article describes only a purely configuration-driven approach that doesn't require code changes. You can implement this approach by including the traditional [`application.properties` or `application.yml`](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config.files) file in the deployed Spring Cloud Gateway app. You can also implement the approach by using a [Config Server in Azure Spring Apps](/azure/spring-cloud/how-to-config-server) that externalizes the configuration file into a Git repository. In the following examples, we implement the `application.yml` approach with YAML syntax, but the equivalent `application.properties` syntax also works.

#### Route requests to your applications

By default, when your app in Azure Spring Apps doesn't have an endpoint assigned to it or a custom domain configured for it, it isn't reachable from the outside. When an app [registers itself with the Spring Cloud Service Registry](/azure/spring-cloud/how-to-service-registration), Spring Cloud Gateway can discover the app so it can use routing rules to forward traffic to the right destination app.

As a result, the only app that needs to have an endpoint assigned to it in Azure Spring Apps is your Spring Cloud Gateway app. This endpoint makes it reachable from the outside. You shouldn't assign an endpoint to any other apps. Otherwise, the apps can be reached directly rather than through Spring Cloud Gateway, which in turn allows the reverse proxy to be bypassed.

An easy way to expose all registered apps through Spring Cloud Gateway is by using the [DiscoveryClient route definition locator](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-discoveryclient-route-definition-locator) as follows:

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

Alternatively, you can selectively expose certain apps through Spring Cloud Gateway by defining app-specific routes:

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

With both the discovery locator approach and explicit route definitions, you can use route predicates to reject invalid requests. In this case, we use that functionality to block requests that don't come from the expected reverse proxy that sits in front of Azure Spring Apps.

#### Restrict access with the X-Forwarded-For HTTP header

When you deploy an app into Azure Spring Apps, the HTTP client or reverse proxy doesn't connect directly to the app. Network traffic goes through an internal ingress controller first.

> [!NOTE]
> This approach means that you have three or even four reverse proxies in the request pipeline before you reach your app in the scenarios that follow. These are the possible reverse proxies: Azure Front Door and/or Application Gateway, the ingress controller, and your Spring Cloud Gateway app.

Because of the extra service, the IP address of the *direct* network client is always an internal Azure Spring Apps component. The IP address is never the *logical* client like the reverse proxy that you're expecting to call your app. You can't use the client IP address for access restrictions. You also can't use Spring Cloud Gateway's built-in [`RemoteAddr` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-remoteaddr-route-predicate-factory) for request filtering because it uses the client IP address by default.

Fortunately, Azure Spring Apps always adds the logical client's IP address to the `X-Forwarded-For` HTTP header on the request into your app. The last (right-most) value of the `X-Forwarded-For` header always contains the IP address of the logical client.

To filter requests based on the `X-Forwarded-For` header, you can use the built-in [`XForwarded Remote Addr` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-xforwarded-remote-addr-route-predicate-factory). This predicate allows you to configure a list of the IP addresses or IP ranges of your reverse proxy that are allowed as the right-most value.

> [!NOTE]
> The `XForwarded Remote Addr` route predicate requires Spring Cloud Gateway version 3.1.1 or later. Version 3.1.1 is available in the [Spring Cloud 2021.0.1](https://github.com/spring-cloud/spring-cloud-release/wiki/Spring-Cloud-2021.0-Release-Notes#202101) release train. If you can't use make a few code changes to your Spring Cloud Gateway app to [modify the way the `RemoteAddr` route predicate determines the client IP address](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html#modifying-the-way-remote-addresses-are-resolved). You can achieve the same result as you would with the `XForwarded Remote Addr` route predicate. Configure the `RemoteAddr` route predicate to use `XForwardedRemoteAddressResolver` and configure the latter with a `maxTrustedIndex` value of `1`. This approach configures your Spring Cloud Gateway app to use the right-most value of the `X-Forwarded-For` header as the logical client IP address.

#### Configure your app to see the correct host name and request URL

When you use Spring Cloud Gateway, there's an important factor to consider. Spring Cloud Gateway sets the HTTP `Host` header on the outbound request to the internal IP address of your app instance, such as `Host: 10.2.1.15:1025`. The request's host name that your application code sees is no longer the original host name of the request that the browser sent, such as `contoso.com`. In some cases, this result can lead to problems like broken cookies or redirect URLs not working properly. For more information on these types of problems and how to configure a reverse proxy service like Application Gateway or Azure Front Door to avoid them, see [Host name preservation](../../best-practices/host-name-preservation.yml).

Spring Cloud Gateway does provide the original host name in the [`Forwarded` header](https://datatracker.ietf.org/doc/html/rfc7239). It also sets other headers like `X-Forwarded-Port`, `X-Forwarded-Proto`, and `X-Forwarded-Prefix` so your application can use them to reconstruct the original request URL. In Spring Framework applications, you can achieve this configuration automatically by setting the `server.forward-headers-strategy` setting to `FRAMEWORK` in your application properties. (Don't set this value to `NATIVE`. Otherwise, other headers are used that don't take the required `X-Forwarded-Prefix` header into account.) For more information, see [Running behind a front-end proxy server](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.webserver.use-behind-a-proxy-server). With this configuration, the [HttpServletRequest.getRequestURL](https://javaee.github.io/javaee-spec/javadocs/javax/servlet/http/HttpServletRequest.html#getRequestURL--) method takes all these headers into account and returns the exact request URL as sent by the browser.

> [!NOTE]
> You might be tempted to use the [`PreserveHostHeader` filter](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html#the-preservehostheader-gatewayfilter-factory) in Spring Cloud Gateway, which maintains the original host name on the outbound request. However, this approach doesn't work because that host name is already mapped as a custom domain on the Spring Cloud Gateway app. It can't be mapped a second time on the final back-end app. This configuration causes an `HTTP 404` error because the back-end app rejects the incoming request. It doesn't recognize the host name.

### Scenario 3: Use Application Gateway with Spring Cloud Gateway

Scenario 3 describes how to use Application Gateway as the reverse proxy for publicly reachable apps through a Spring Cloud Gateway endpoint. 

The following diagram depicts the architecture for Scenario 3:

:::image type="content" source="_images/application-gateway-reverse-proxy.png" alt-text="Diagram that shows the use of Azure Application Gateway with Azure Spring Apps outside of a virtual network." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/scenario3.vsdx) of this architecture.*

When Application Gateway sits in front of your Azure Spring Apps instance, you use the assigned endpoint of the Spring Cloud Gateway app as the back-end pool. An example endpoint is `myspringcloudservice-mygateway.azuremicroservices.io`. Because Azure Spring Apps is deployed outside of a virtual network, this URL resolves to a public IP address. [When the back-end pool is a public endpoint, Application Gateway uses its front-end public IP address to reach the back-end service.](/azure/application-gateway/how-application-gateway-works#how-an-application-gateway-routes-a-request)

To allow only requests from your Application Gateway instance to reach Spring Cloud Gateway, you can configure the `XForwarded Remote Addr` route predicate. Configure the predicate to allow only requests from the dedicated public IP address of your Application Gateway as shown in the following example:

```yaml
(...)
predicates:
- XForwardedRemoteAddr="20.103.252.85"
```

### Scenario 4: Use Azure Front Door with Spring Cloud Gateway

Scenario 4 describes how to use Azure Front Door as the reverse proxy for publicly reachable apps through a Spring Cloud Gateway endpoint.

The following diagram depicts the architecture for Scenario 4:

:::image type="content" source="_images/azure-front-door-reverse-proxy.png" alt-text="Diagram that shows the use of Azure Front Door with Azure Spring Apps outside of a virtual network." border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/scenario4.vsdx) of this architecture.*

Similar to Scenario 3, this configuration uses the public URL of the Spring Cloud Gateway app as the back-end pool or origin in Azure Front Door. An example endpoint is `https://myspringcloudservice-mygateway.azuremicroservices.io`.

Because Azure Front Door is a global service with many [edge locations](/azure/frontdoor/edge-locations-by-region), it uses many IP addresses to communicate with its back-end pool. The Azure Front Door documentation describes [how to lock down access to a backend to allow only Azure Front Door traffic](/azure/frontdoor/front-door-faq#how-do-i-lock-down-the-access-to-my-backend-to-only-azure-front-door-). However, in this scenario, you don't control the Azure network in which your apps are deployed. Unfortunately, you can't use the `AzureFrontDoor.Backend` service tag to get a complete list of outbound Azure Front Door IP addresses that's guaranteed to be current. Instead, you have to download [Azure IP ranges and service tags](https://www.microsoft.com/download/details.aspx?id=56519), find the `AzureFrontDoor.Backend` section, and copy all IP ranges from the `addressPrefixes` array into the `XForwarded Remote Addr` route predicate configuration.

> [!IMPORTANT]
> The IP ranges used by Azure Front Door can change. The authoritative [Azure IP ranges and service tags](https://www.microsoft.com/download/details.aspx?id=56519) file is published weekly and records any changes to IP ranges. To ensure your configuration stays current, verify the IP ranges weekly and update your configuration as needed (ideally, in an automated way). To avoid the maintenance overhead of this approach, you can deploy Azure Spring Apps in a virtual network with the other described scenarios by using an NSG with the `AzureFrontDoor.Backend` service tag.

Because the Azure Front Door IP ranges are shared with other organizations, you also have to ensure you lock down access to only your specific Azure Front Door instance, based on the `X-Azure-FDID` HTTP header that contains your unique `Front Door ID`. You can restrict the access by using the [`Header` route predicate](https://docs.spring.io/spring-cloud-gateway/docs/current/reference/html/#the-header-route-predicate-factory), which rejects a request unless a specified HTTP header has a certain value.

In this scenario, your Spring Cloud Gateway route predicate configuration might look like the following example:

```yaml
(...)
predicates:
- XForwardedRemoteAddr="13.73.248.16/29","20.21.37.40/29","20.36.120.104/29","20.37.64.104/29", ...(and many more)...
- Header="X-Azure-FDID", "e483e3cc-e7f3-4e0a-9eca-5f2a62bde229"
```

## Contributors

*Microsoft maintains this content. The following contributor developed the original content.*

Principal author:

- [Jelle Druyts](https://www.linkedin.com/in/jelle-druyts-0b76823/) | Principal Customer Engineer
 
*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Spring Apps reference architecture](/azure/spring-cloud/reference-architecture)
- [Customer responsibilities for running Azure Spring Apps in Azure Virtual Networks](/azure/spring-cloud/vnet-customer-responsibilities#azure-spring-apps-resource-requirements)

## Related resources

- [Host name preservation](../../best-practices/host-name-preservation.yml)
- [Load-balancing options](../../guide/technology-choices/load-balancing-overview.yml)
- [Microservices architecture style](../../guide/architecture-styles/microservices.yml)
