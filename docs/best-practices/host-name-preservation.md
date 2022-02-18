---
title: Host name preservation best practice
titleSuffix: Azure Architecture Center
description: Learn why it's important to preserve the original HTTP host name between a reverse proxy and its backend web application, and how to configure this for the most common Azure services.
author: jelledruyts
ms.author: jelled
ms.date: 02/14/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: best-practice
products:
  - azure-api-management
  - azure-app-service
  - azure-application-gateway
  - azure-front-door
  - azure-spring-cloud
  - azure-web-application-firewall
categories:
  - networking
  - web
ms.custom:
  - best-practice
---

# Preserve the original HTTP host name between a reverse proxy and its backend web application

## Summary

We recommend preserving the original HTTP host name when using a reverse proxy in front of a web application. Having a different host name at the reverse proxy than the one which is provided to the backend application server can lead to cookies or redirect URLs not working properly. For example, session state can get lost, authentication can fail or backend URLs can inadvertently get exposed to end users. These issues can be avoided by preserving the host name of the initial request so that the application server sees the same domain as the web browser.

This guidance applies especially to applications hosted in Platform-as-a-Service (PaaS) offerings such as [Azure App Service](/azure/app-service/) and [Azure Spring Cloud](/azure/spring-cloud/), and provides [implementation guidance](#implementation-guidance-for-common-azure-services) specifically for [Azure Application Gateway](/azure/application-gateway/), [Azure Front Door](/azure/frontdoor/) and [Azure API Management](/azure/api-management/) as commonly used reverse proxy services.

> [!NOTE]
> Web API's are generally less sensitive to the issues caused by host name mismatches: they usually don't depend on cookies (except if you [use cookies to secure communications between a Single-Page App and its backend API](https://auth0.com/docs/manage-users/cookies/spa-authenticate-with-cookies) for example, in a pattern known as [Backend for Frontend](/azure/architecture/patterns/backends-for-frontends)), and they often don't return URLs back to themselves (except in certain API styles such as [OData](https://www.odata.org/) and [HATEOAS](https://en.wikipedia.org/wiki/HATEOAS)). In case your API implementation depends on cookies or generates absolute URLs, the guidance provided in this article applies as well.

In case you require end-to-end TLS/SSL (the connection between the reverse proxy and the backend service uses HTTPS), the backend service will also need a matching TLS certificate for the original host name. This adds operational complexity in deploying and renewing certificates, but many PaaS services offer free TLS certificates that are fully managed.

## Context

### The host of an HTTP request

In many cases, the application server or some component in the request pipeline wants to know which internet domain name was used by the browser to access it: this is the "host" of the request. It can be an IP address, but usually it's a name such as `contoso.com` (which the browser then resolves to an IP address through DNS). The host value is typically determined from the [host component of the request URI](https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2) which the browser sends to the application as the [`Host` HTTP header](https://datatracker.ietf.org/doc/html/rfc2616#section-14.23).

> [!IMPORTANT]
> Never use value of the "host" in a security mechanism. The value is provided by the browser or some other user agent and can easily be manipulated by an end user.

In some scenarios, especially when there is an HTTP reverse proxy in the request chain, the original host header can get changed before it reaches the application server. A reverse proxy terminates the client network session and sets up a new connection to the backend. In this new session they can either carry over the original host name of the client session, or set a new one. In the latter case, the proxy will often still send the original host value in other HTTP headers such as [`forwarded`](https://datatracker.ietf.org/doc/html/rfc7239#section-4) or [`X-Forwarded-Host`](https://developer.mozilla.org/docs/Web/HTTP/Headers/X-Forwarded-Host), which allows applications to determine the original host name - *if* they are specifically coded to understand these additional headers.

### Why web platforms use the host name

Multi-tenant PaaS services often require a registered and validated host name in order to route an incoming request to the appropriate tenant's backend server. This is because there's typically a shared pool of load balancers that accept incoming requests for *all* tenants, which commonly use the incoming host name to look up the correct backend for the customer tenant.

To make it easy to get started, these platforms typically provide a default domain which is pre-configured to route traffic to your deployed instance. In case of App Service, this default domain is `azurewebsites.net` and each web app you create gets its own subdomain, for example `contoso.azurewebsites.net`. Similarly, the default domain is `azuremicroservices.io` for Azure Spring Cloud and `azure-api.net` for Azure API Management.

For production deployments, you wouldn't use these default domains but instead provide your own domain to align with your organization or application's brand. For example, `contoso.com` could resolve behind the scenes to the `contoso.azurewebsites.net` web app on App Service, but this shouldn't be visible to an end user visiting that website. This custom `contoso.com` host name does have to be registered with the PaaS service however, so that the platform can identify the correct backend server that should respond to the request.

![Host-based routing in Azure App Service](images/host-name-preservation/platform-appservice.png)

### Why applications use the host name

One of the most common reasons that an application server wants to know the host name is to construct absolute URLs and to issue cookies for a specific domain. For example, when the application code needs to:

- Return an absolute rather than relative URL in its HTTP response (although generally websites do tend to render relative links where possible).
- Generate a URL to be used *outside of its HTTP response* where relative URLs can't be used, like emailing a link to the website to a user.
- Generate an absolute redirect URL for an external service, for example towards an authentication service such as Azure AD to indicate where it should return the user after they have successfully authenticated.
- Issue HTTP cookies that are restricted to a certain host as defined in the cookie's [`Domain` attribute](https://datatracker.ietf.org/doc/html/rfc6265#section-5.2.3).

This can all be achieved by adding the expected host name in the application's configuration, and using that statically defined value instead of the incoming host name on the request. However, this complicates application development and deployment, and a single installation of the application can in fact serve multiple hosts: for example, a single web app can be used for multiple *application tenants* which all have their own unique host names (for example, `tenant1.contoso.com` and `tenant2.contoso.com`).

Furthermore, sometimes the incoming host name is used by components outside of the application code, or middleware in the application server over which you don't have full control. Examples include:

- App Service allows you to [enforce HTTPS](/azure/app-service/configure-ssl-bindings#enforce-https) for your web app, which makes any insecure HTTP request get redirected to HTTPS. In this case the incoming host name is used to generate the absolute URL for the HTTP redirect's `Location` header.
- Azure Spring Cloud has a similar feature to [enforce HTTPS](/azure/spring-cloud/tutorial-custom-domain#enforce-https), which also uses the incoming host to generate the HTTPS URL.
- App Service has an ["ARR affinity" setting](/azure/app-service/configure-common#configure-general-settings) to enable sticky sessions, so that requests from the same browser instance are always served by the same backend server. This is performed by the App Service front-ends which add a cookie to the HTTP response; this cookie will have its `Domain` set to the incoming host.
- App Service provides [authentication and authorization capabilities](/azure/app-service/overview-authentication-authorization) to easily allow users to sign in and access data in APIs.
  - The incoming host name is used to construct the redirect URL to which the identity provider has to return the user after successful authentication.
  - At the same time, [enabling this feature by default also switches on HTTP-to-HTTPS redirection](/azure/app-service/overview-authentication-authorization#considerations-for-using-built-in-authentication), where again the incoming host name is used to generate the redirect location.

### Why you could be tempted to override the host name

Imagine you created a web application in App Service with a default domain of `contoso.azurewebsites.net` (the same logic applies equally to other services like Azure Spring Cloud), and you haven't configured a custom domain on App Service. If you now want to place a reverse proxy like Application Gateway (or any similar service) in front of this application, you would have the DNS record for `contoso.com` resolve to the IP address of Application Gateway. It therefore receives the request for `contoso.com` from the browser and is configured to forward that request to the IP address which `contoso.azurewebsites.net` resolves to: this is the final backend service for the requested host. In this case however, App Service doesn't know about the `contoso.com` custom domain and rejects all incoming requests for this host name, as it doesn't know to where it should route the request.

The "easy" way to make this configuration work is to override or rewrite the `Host` header of the HTTP request in Application Gateway and set it to the value of `contoso.azurewebsites.net`. This makes the outgoing request from Application Gateway seem like the original request was really intended for `contoso.azurewebsites.net` instead of `contoso.com`.

![Configuration with the host name overridden](images/host-name-preservation/configuration-host-overridden.png)

At this point App Service *does* recognize the host name, and it accepts the request without requiring a custom domain name to be configured. In fact, [Application Gateway makes it very easy to override the host header](/azure/application-gateway/configuration-http-settings#pick-host-name-from-back-end-address) with the host of the backend pool, and [Azure Front Door even does this by default](/azure/frontdoor/front-door-backend-pool#backend-host-header).

The problem with this "easy" solution, however, is that it can result in various issues when the original host name isn't seen by the app.

## Potential issues

### Incorrect absolute URLs

If the original host name is not preserved and the application server uses the incoming host name to generate absolute URLs, this may lead to the backend domain being disclosed to an end user. These absolute URLs could be generated by the application code, or as mentioned above by platform features such as the "HTTP to HTTPS redirection" support in App Service and Azure Spring Cloud.

![Issue with incorrect absolute URLs](images/host-name-preservation/issue-absolute-urls.png)

1. The browser sends a request for `contoso.com` to the reverse proxy.
2. The reverse proxy rewrites the host name to `contoso.azurewebsites.net` on the request to the backend web application (or a similar default domain for another service).
3. The application generates an absolute URL based on the incoming `contoso.azurewebsites.net` host name, for example `https://contoso.azurewebsites.net/`.
4. The browser follows this URL, which goes directly towards the backend service rather than back to the reverse proxy at `contoso.com`.

This may even pose a security risk in the common case where the reverse proxy also serves as a Web Application Firewall: the user is now given a URL that goes straight to the backend application and bypasses the reverse proxy. For this reason, it's important to ensure the backend web application only directly accepts network traffic from the reverse proxy (for example, using [access restrictions in App Service](/azure/app-service/app-service-ip-restrictions)). In that case, even if an incorrect absolute URL is generated, at least it doesn't work and cannot be used by a malicious user to bypass the firewall.

### Incorrect redirect URLs

A very common and more specific case of the scenario above is when absolute redirect URLs are generated, as required by identity services like Azure AD when using browser-based identity protocols such as OpenID Connect, OAuth 2.0 or SAML 2.0. These redirect URLs could be generated by the application server or middleware itself, or as mentioned above by platform features such as App Service's [authentication and authorization capabilities](/azure/app-service/overview-authentication-authorization).

![Issue with incorrect redirect URLs](images/host-name-preservation/issue-redirect-urls.png)

1. The browser sends a request for `contoso.com` to the reverse proxy.
2. The reverse proxy rewrites the host name to `contoso.azurewebsites.net` on the request to the backend web application (or a similar default domain for another service).
3. The application generates an absolute redirect URL based on the incoming `contoso.azurewebsites.net` host name, for example `https://contoso.azurewebsites.net/`.
4. The browser navigates to the identity provider to authenticate the user; the request includes the generated redirect URL to indicate where it should return the user after they have successfully authenticated.
5. Identity providers typically require redirect URLs to be registered upfront, so at this point the identity provider should reject the request since the provided redirect URL wasn't registered (it wasn't even supposed to be used). If for some reason the redirect URL *was* registered however, the identity provider would redirect the browser to the redirect URL that was specified in the authentication request, in this case `https://contoso.azurewebsites.net/`.
6. The browser follows this URL, which goes directly towards the backend service rather than back to the reverse proxy.

### Broken cookies

Another place where a host name mismatch can lead to issues is when the application server issues cookies and uses the incoming host name to construct the [`Domain` attribute of the cookie](https://datatracker.ietf.org/doc/html/rfc6265#section-5.2.3), which ensures that the cookie will only be used for that specific domain. These cookies could be generated by the application code, or as mentioned above by platform features such as App Service's ["ARR affinity" setting](/azure/app-service/configure-common#configure-general-settings).

![Issue with incorrect cookie domain](images/host-name-preservation/issue-cookies.png)

1. The browser sends a request for `contoso.com` to the reverse proxy.
2. The reverse proxy rewrites the host name to `contoso.azurewebsites.net` on the request to the backend web application (or a similar default domain for another service).
3. The application generates a cookie with a domain based on the incoming `contoso.azurewebsites.net` host name. The browser stores the cookie for this specific domain, rather than the `contoso.com` domain which the user is *actually* using.
4. The browser will not include the cookie on any subsequent request for `contoso.com`, as the cookie's `contoso.azurewebsites.net` domain doesn't match the domain of the request. The application will not receive the cookie it had issued before. As a consequence, the user may lose certain state that was supposed to be in the cookie, or certain features like ARR affinity won't actually work. Unfortunately, none of these issues generate an error or are directly visible by an end user, which makes them very difficult to troubleshoot.

## Implementation guidance for common Azure services

To avoid the potential issues discussed above, we recommend that the original host name is preserved in the call between the reverse proxy and the backend application server.

![Configuration with the host name preserved](images/host-name-preservation/configuration-host-preserved.png)

### Backend configuration

Many web hosting platforms require the allowed incoming host names to be explicitly configured. How to achieve this for the most common Azure services is covered below, and other platforms usually have similar ways of configuring custom domains.

When hosting the web application in App Service, you can [attach a custom domain name to the web app](/azure/app-service/app-service-web-tutorial-custom-domain) and avoid using the default `azurewebsites.net` host name towards the backend. Note that attaching a custom domain to the web app doesn't require you to change your DNS resolution: you can [verify the domain with a `TXT` record](/azure/app-service/manage-custom-dns-migrate-domain#create-domain-verification-record) without impacting your regular `CNAME` or `A` records (which would still resolve to the IP address of the reverse proxy). In case you require end-to-end TLS/SSL, you can [import an existing certificate](/azure/app-service/configure-ssl-certificate#import-a-certificate-from-key-vault) or use a [free managed certificate](/azure/app-service/configure-ssl-certificate#create-a-free-managed-certificate) for your custom domain.

Similarly, when using Azure Spring Cloud, you can [use a custom domain for your app](/azure/spring-cloud/tutorial-custom-domain) to avoid use of the `azuremicroservices.io` host name, and import an existing or self-signed certificate if you require end-to-end TLS/SSL.

If you have a reverse proxy in front of Azure API Management (which itself also acts as a reverse proxy), you can [configure a custom domain on your API Management instance](/azure/api-management/configure-custom-domain) to avoid use of the `azure-api.net` host name, and import an existing or free managed certificate if you require end-to-end TLS/SSL. As noted above however, API's are less sensitive to the issues caused by host name mismatches, so this may not be as important.

When you host your applications on other platforms such as Kubernetes or directly on Virtual Machines, there is no built-in functionality that depends on the incoming host name, so you are responsible for how the host name is used within the application server itself. The recommendation to preserve the host name typically still applies for any components in your application that depend on it, unless you specifically make your application aware of reverse proxies and respect the [`forwarded`](https://datatracker.ietf.org/doc/html/rfc7239#section-4) or [`X-Forwarded-Host`](https://developer.mozilla.org/docs/Web/HTTP/Headers/X-Forwarded-Host) headers for example.

### Reverse proxy configuration

When defining the backends within the reverse proxy, you can still use the "default" domain of the backend service, for example `https://contoso.azurewebsites.net/`. This URL is used by the reverse proxy to resolve the correct IP address for the backend service, and by using the platform's "default" domain this IP address is always guaranteed to be correct. You typically can't use the public-facing domain such as `contoso.com` because that should resolve to the IP address of the reverse proxy itself (unless you choose to apply more advanced DNS resolution techniques such as [Split-horizon DNS](/azure/dns/private-dns-scenarios#scenario-split-horizon-functionality)).

> [!IMPORTANT]
> If you have a next-generation firewall such as [Azure Firewall Premium](/azure/firewall/premium-features) in between the reverse proxy and the final backend, you may even be *required* to apply split-horizon DNS: such firewalls may check explicitly that the HTTP `Host` header resolves to the target IP address. In such cases, the original host name used by the browser should resolve to the IP address of the reverse proxy when accessed from the public internet, but from the point of view of the firewall that same host name should resolve to the IP address of the final backend service. For more information, see [Zero-trust network for web applications with Azure Firewall and Application Gateway](/azure/architecture/example-scenario/gateway/application-gateway-before-azure-firewall#azure-firewall-premium-and-name-resolution).

Most reverse proxies allow you to configure which host name is passed to the backend service. See below how to ensure the original host name of the incoming request is used for the most common Azure services.

> [!NOTE]
> In all cases, you *could* also choose to override the host name with an explicitly defined custom domain rather than take it from the incoming request. In case the application only uses a single domain that may work fine, but if the same application deployment accepts requests from multiple domains (for example, for multi-tenant scenarios) then you cannot statically define a single domain and you should take the host name from the incoming request (again, unless the application is explicitly coded to take additional HTTP headers into account). Therefore, the general recommendation is to not override the host name at all, and pass through the incoming host name unmodified to the backend.

#### Azure Application Gateway

In case you're using [Azure Application Gateway](/azure/application-gateway/) as the reverse proxy, you can ensure the original host name is preserved by disabling **Override with new host name** on the backend HTTP setting: this disables both [Pick host name from back-end address](/azure/application-gateway/configuration-http-settings#pick-host-name-from-back-end-address) and [Override with specific domain name](/azure/application-gateway/configuration-http-settings#host-name-override) (both of which would override the host name). On the [ARM properties for Application Gateway](/azure/templates/microsoft.network/applicationgateways), this corresponds to setting the `hostName` property to `null` and `pickHostNameFromBackendAddress` to `false`.

Because health probes are sent outside of the context of an incoming request, they cannot dynamically determine the correct host name. Instead, you have to create a custom health probe, disable **Pick host name from backend HTTP settings** and [explicitly specify the host name](/azure/application-gateway/application-gateway-probe-overview#custom-health-probe-settings). For this host name, you should also use an appropriate *custom* domain for consistency (although you *could* choose to use the default domain of the hosting platform here, as incorrect cookies or redirect URLs in the response are ignored by health probes anyway).

#### Azure Front Door

When using [Azure Front Door](/azure/frontdoor/), you can avoid overriding the host name by leaving the [Backend host header](/azure/frontdoor/front-door-backend-pool#backend-host-header) blank on the backend pool definition. On the [ARM definition of the backend pool](/azure/templates/microsoft.network/frontdoors), this corresponds to setting `backendHostHeader` to `null`.

In case you're using [Azure Front Door Standard/Premium](/azure/frontdoor/standard-premium/), you can preserve the host name by leaving the [Origin host header](/azure/frontdoor/standard-premium/concept-origin#origin-host-header) blank on the origin definition. On the [ARM definition of the origin](/azure/templates/microsoft.cdn/profiles/origingroups/origins#afdoriginproperties), this corresponds to setting `originHostHeader` to `null`.

#### Azure API Management

By default, [Azure API Management](/azure/api-management/) overrides the host name that is sent to the backend with the host component of the API's **Web service URL** (which corresponds to the `serviceUrl` value of the [ARM definition of the API](/azure/templates/microsoft.apimanagement/2021-08-01/service/apis)).

You can force API Management to use the host name of the incoming request instead by adding an `inbound` [Set HTTP header](/azure/api-management/api-management-transformation-policies#SetHTTPheader) policy as follows:

```xml
<inbound>
  <base />
  <set-header name="Host" exists-action="override">
    <value>@(context.Request.OriginalUrl.Host)</value>
  </set-header>
</inbound>
```

As noted above however, API's are less sensitive to the issues caused by host name mismatches, so this may not be as important.
