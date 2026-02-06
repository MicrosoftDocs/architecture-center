---
title: Azure App Service and Azure Functions Considerations for Multitenancy
description: This article describes the features of Azure App Service and Azure Functions that are useful when you work with multitenant systems.
author: johndowns
ms.author: pnp
ms.date: 08/10/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
- arb-saas 
---
# Azure App Service and Azure Functions considerations for multitenancy

Azure App Service is a powerful web application-hosting platform. Azure Functions, built on top of the App Service infrastructure, enables you to easily build serverless and event-driven compute workloads. Both services are frequently used in multitenant solutions.

## Features of App Service and Azure Functions that support multitenancy

App Service and Azure Functions include many features that support multitenancy.

### Custom domain names

App Service enables you to use [wildcard Domain Name System (DNS) records](/azure/app-service/app-service-web-tutorial-custom-domain) and to add your own [wildcard Transport Layer Security (TLS) certificates](/azure/app-service/configure-ssl-certificate). When you use [tenant-specific subdomains](../considerations/domain-names.md#subdomains), wildcard DNS and TLS certificates enable you to easily scale your solution to a large number of tenants. This approach avoids the need for manual reconfiguration for each new tenant.

When you use [tenant-specific custom domain names](../considerations/domain-names.md#custom-domain-names), you might have a large number of custom domain names that need to be added to your app. Managing a large number of custom domain names can be challenging, especially when they require individual TLS certificates. App Service provides [managed TLS certificates](/azure/app-service/configure-ssl-certificate), which reduces the work required when you work with custom domains. However, there are [limits to consider](/azure/azure-resource-manager/management/azure-subscription-service-limits), such as how many custom domains can be applied to a single app.

### Integration with Azure Front Door

App Service and Azure Functions can integrate with [Azure Front Door](/azure/frontdoor/front-door-overview) to serve as the internet-facing component of your solution. Azure Front Door enables you to add a web application firewall (WAF) and edge caching, and it provides other performance optimizations. You can easily reconfigure your traffic flows to direct traffic to different back ends, based on changing business or technical requirements.

When you use Azure Front Door with a multitenant app, you can use it to manage your custom domain names and to terminate your TLS connections. Your App Service application is then configured with a single host name. All traffic flows through to that application, which helps you avoid managing custom domain names in multiple places.

:::image type="complex" border="false" source="media/app-service/host-front-door.png" alt-text="Diagram that shows requests coming into Azure Front Door by using various host names. The requests are passed to the App Service app using a single host name." lightbox="media/app-service/host-front-door.png":::
   The image shows Azure Front Door and App service. Three arrows point from three host names to Azure Front Door: invoices.fabrikam.com, payments.worldwideimporters.com, and pay.tailwind.com. An arrow labeled Host: contoso.azurewebsites.net points to App Service.
:::image-end:::

As in the previous example, [Azure Front Door can be configured to modify the request's `Host` header](/azure/frontdoor/origin?pivots=front-door-standard-premium#origin-host-header). The original `Host` header that the client sends is propagated through the `X-Forwarded-Host` header. Your application code can use this header to [map the request to the correct tenant](../considerations/map-requests.yml).

> [!WARNING]
> If your application sends cookies or redirection responses, you must account for specific considerations. Changes to the request's `Host` header can invalidate these responses. For more information, see [Host name preservation best practices](../../../best-practices/host-name-preservation.yml).

You can use [private endpoints](/azure/app-service/overview-private-endpoint) or App Service [access restrictions](/azure/app-service/app-service-ip-restrictions) to ensure that traffic flows through Azure Front Door before reaching your app.

For more information, see [Use Azure Front Door in a multitenant solution](./front-door.md).

### Authentication and authorization

App Service can [validate authentication tokens on behalf of your app](/azure/app-service/overview-authentication-authorization). When App Service receives a request, it checks to see whether each of the following conditions is met:

- The request contains a token.
- The token is valid.
- The request is authorized.

If any of the conditions aren't met, App Service can block the request, or it can redirect the user to your identity provider so that they can sign in.

If your tenants use Microsoft Entra ID as their identity system, you can configure App Service to use [the /common endpoint](/entra/identity-platform/howto-convert-app-to-be-multi-tenant) to validate user tokens. This configuration ensures that their tokens are validated and accepted, regardless of the user's Microsoft Entra tenant.

You can also integrate App Service with Microsoft Entra External ID for authentication of consumers.
### Access restrictions

You can restrict the traffic to your app by using [access restrictions](/azure/app-service/app-service-ip-restrictions). You can use these rules to specify the IP address ranges or the virtual networks that are allowed to connect to the app.

When you work with a multitenant solution, be aware of the maximum number of access restriction rules. For example, if you need to create an access restriction rule for every tenant, you might exceed the maximum number of rules that are allowed. If you need a larger number of rules, consider deploying a reverse proxy like [Azure Front Door](/azure/frontdoor/front-door-overview).

## Isolation models

When you work with a multitenant system that uses App Service or Azure Functions, determine the required level of isolation. For more information about selecting the best isolation model for your scenario, see [Tenancy models for a multitenant solution](../considerations/tenancy-models.md) and [Architectural approaches for compute in multitenant solutions](../approaches/compute.md).

When you work with App Service and Azure Functions, you should be aware of the following key concepts:

- In App Service, a [plan](/azure/app-service/overview-hosting-plans) represents your hosting infrastructure. An app represents a single application that runs on that infrastructure. You can deploy multiple apps to a single plan.

- In Azure Functions, your hosting and application are also separated, but you have [extra hosting options available](/azure/azure-functions/functions-scale) for *elastic hosting*, where Azure Functions manages scaling for you. This article refers to the hosting infrastructure as a *plan* because the principles discussed apply to both App Service and Azure Functions, regardless of the hosting model used.

The following table summarizes the differences between the main tenancy isolation models for App Service and Azure Functions.

| Consideration | Shared apps | Apps for each tenant with shared plans | Plans for each tenant |
|---|---|---|---|
| Configuration isolation | Low | Medium. App-level settings are dedicated to the tenant and plan-level settings are shared. | High. Each tenant can have their own configuration. |
| Performance isolation | Low | Low-medium. Potentially subject to noisy neighbor problems. | High |
| Deployment complexity | Low | Medium | High |
| Operational complexity | Low | High | High |
| Resource cost | Low | Low-high, depending on the application | High |
| Example scenario | Large multitenant solution that has a shared application tier | Migrate applications that aren't aware of tenancy into Azure while gaining some cost efficiency. | Single-tenant application tier |

### Shared apps

You might deploy a shared application on a single plan and use the shared application for all your tenants.

This deployment strategy tends to be the most cost-efficient option, and it requires the least operational overhead because there are fewer resources to manage. You can scale the overall plan based on load or demand, and all tenants that share the plan benefit from the increased capacity.

It's important to be aware of the [App Service quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits), such as the maximum number of custom domains that can be added to a single app and the maximum number of instances of a plan that can be provisioned.

To be able to use this model, your application code must be multitenancy-aware.

### Apps for each tenant with shared plans

You can also choose to share your plan between multiple tenants, but deploy separate apps for each tenant. This approach provides you with logical isolation between each tenant and provides the following advantages:

- **Cost efficiency:** By sharing your hosting infrastructure, you can generally reduce your overall costs for each tenant.

- **Separation of configuration:** Each tenant's app can have its own domain name, TLS certificate, access restrictions, and token authorization policies applied.

- **Separation of upgrades:** Each tenant's application binaries can be upgraded independently of other apps on the same plan.

However, because the plan's compute resources are shared, the apps might be subject to the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). Also, there are [limits to how many apps can be deployed to a single plan](/azure/azure-resource-manager/management/azure-subscription-service-limits).

> [!NOTE]
> Don't use [deployment slots](/azure/app-service/deploy-staging-slots) for different tenants. Slots don't provide resource isolation. They're designed for deployment scenarios when you need to have multiple versions of your app running for a short time, such as blue-green deployments and a canary rollout strategy.

### Plans for each tenant

The strongest level of isolation is to deploy a dedicated plan for a tenant. This dedicated plan ensures that the tenant has full use of all server resources allocated to that plan.

This approach enables you to scale your solution to provide performance isolation for each tenant and to avoid the [noisy neighbor problem](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml). However, it also has a higher cost because the resources aren't shared with multiple tenants. Also, you need to consider the [maximum number of plans](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-service-limits) that can be deployed into a single Azure resource group.

### Azure Functions Flex Consumption plan

Azure Functions includes the [Flex Consumption plan](/azure/azure-functions/flex-consumption-plan), which provides per-function scaling and supports [always ready instances](/azure/azure-functions/flex-consumption-plan#always-ready-instances) to reduce cold starts. Each function scales independently, except for HTTP, durable functions, and blob (Azure Event Grid) triggers. This scaling model can help you isolate tenant workloads when your tenancy model maps tenants to functions or function groups, and it can help you reduce the impact of a noisy tenant on other workloads.

Flex Consumption also supports [virtual network integration](/azure/azure-functions/flex-consumption-plan#virtual-network-integration) and private endpoints, which helps you apply the same network isolation practices that you use with App Service. These capabilities can simplify your network design and cost model for multitenant solutions that need serverless implementation with predictable isolation.

## Host APIs

You can host APIs on both App Service and Azure Functions. Your choice of platform depends on the specific feature set and scaling options that you need.

Regardless of the platform that you use to host your API, consider using [Azure API Management](/azure/api-management) in front of your API application. API Management provides many features that can be helpful for multitenant solutions:

- A centralized point for all [authentication](/azure/api-management/api-management-access-restriction-policies), which might include determining the tenant identifier from a token claim or other request metadata.

- [Routing requests to different API back ends](/azure/api-management/set-backend-service-policy), which might be based on the request's tenant identifier. This routing can be helpful when you host multiple [deployment stamps](../../../patterns/deployment-stamp.yml) with their own independent API applications, but you need to have a single API URL for all requests.

## Networking and multitenancy

### IP addresses

Many multitenant applications need to connect to tenants' on-premises networks to send data.

If you need to send outbound traffic from a known static IP address or from a set of known static IP addresses, consider using a NAT gateway. For more information about how to use a NAT gateway in multitenant solutions, see [Azure NAT Gateway considerations for multitenancy](./nat-gateway.md).

If you don't need a static outbound IP address but occasionally need to check the IP address that your application uses for outbound traffic, you can [query the current IP addresses of the App Service deployment](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors).

> [!IMPORTANT]
> When you integrate App Service with Azure NAT Gateway, all traffic to Azure Storage must use private endpoints or service endpoints. This configuration ensures that storage access continues to work when egress is routed through your virtual network. In a multitenant solution, make sure that your build, deployment, logging, and data paths that use Storage follow this pattern. For more information, see [Azure NAT Gateway integration](/azure/app-service/overview-nat-gateway-integration).

### Network security perimeter

The Azure [network security perimeter](/azure/private-link/network-security-perimeter-concepts) feature provides identity-based perimeters for platform services. Because App Service and Azure Functions run custom application code, network security perimeter enforcement can't be fully applied to all flows. If you need to communicate with platform as a service (PaaS) resources that are inside a network security perimeter, integrate your apps with a virtual network and reach those resources over [private endpoints](/azure/app-service/overview-private-endpoint). This approach aligns with multitenant isolation practices and reduces data exfiltration risk across tenants.

### Quotas

Because App Service is a multitenant service, you need to be mindful of how you use shared resources. Networking requires special attention because there are [limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-app-service-limits) that affect how your application can interact with both inbound and outbound network connections. These limits include Source Network Address Translation (SNAT) and Transmission Control Protocol (TCP) port limits.

If your application connects to a large number of databases or external services, then your app might be at risk of [SNAT port exhaustion](/azure/app-service/troubleshoot-intermittent-outbound-connection-errors). In general, SNAT port exhaustion suggests that your code isn't properly reusing TCP connections. Even in a multitenant environment, it's important to follow recommended practices for connection reuse to avoid reaching port limits.

However, in some multitenant solutions, the number of outbound connections to distinct IP addresses can result in SNAT port exhaustion, even when you follow good coding practices. In these scenarios, consider one of the following options:

- Deploy a NAT gateway to increase the number of SNAT ports that are available for your application to use. For more information, see [Azure NAT Gateway considerations for multitenancy](./nat-gateway.md).

- Use [service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) when you connect to Azure services to bypass load balancer limits.

Even with these controls in place, you might approach limits with a large number of tenants, so you should plan to scale to extra App Service plans or [deployment stamps](../../../patterns/deployment-stamp.yml).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Thiago Almeida](https://www.linkedin.com/in/thiagoalmeidaprofile) | Principal Program Manager, Azure Functions
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford/) | Senior Partner Solution Architect, Enterprise Partner Solutions
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Resources for architects and developers of multitenant solutions](../related-resources.md)
