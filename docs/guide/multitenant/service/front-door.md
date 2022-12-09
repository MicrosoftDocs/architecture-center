---
title: Azure Front Door considerations for multitenancy
titleSuffix: Azure Architecture Center
description: This article describes the features of Azure Front Door that are useful when you work with multitenanted systems, and it provides links to guidance for how to use Azure Front Door in a multitenant solution.
author: rajnemani
ms.author: ranema
ms.date: 11/08/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
 - azure
 - azure-front-door
categories:
 - networking
ms.category:
  - fcp
ms.custom:
  - guide
  - fcp
---

# Azure Front Door considerations for multitenancy

Azure Front Door is Microsoft's modern cloud CDN (content delivery network), which provides fast, reliable, and secure access between users and applications' static and dynamic web content across the globe. In this article, we describe some of the features of Azure Front Door that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Front Door in a multitenant solution.

In a multitenant solution where you follow the [Deployment Stamps](../approaches/overview.yml#deployment-stamps-pattern), you might choose to deploy Front Door in two different ways:

- Deploy a single Front Door profile, and use Front Door to route traffic to the appropriate stamp.
- Deploy a Front Door profile in each stamp. If you have ten stamps, you deploy ten instances of Front Door.

Front Door provides several features that are useful for multitenant solutions.

## Features of Front Door that support multitenancy

In this section, we consider several key features of Front Door that are useful for multitenant solutions. We discuss how Front Door helps to configure customs domains, including wildcard domains and TLS certificates. We also summarize how Front Door's routing capabilites can be used to support multitenancy.

### Custom domains

Front Door provides a default hostname for each endpoint that you create, such as `contoso.z01.azurefd.net`. For most solutions, you instead associate your own domain name with the Front Door endpoint. Custom domain names enable you to use your own branding and configure routing based on the hostname provided in a client's request.

In a multitenant solution, you might use tenant-specific domain names or subdomains, and configure Front Door to route the tenant's traffic to the correct origin group for that tenant's workload. For example, you might configure a custom domain name like `tenant1.app.contoso.com`. Front Door enables you to configure multiple custom domains on a single Front Door profile.

For more information, see [Add a custom domain to your Front Door](/azure/frontdoor/front-door-custom-domain).

#### Wildcard domains

Wildcard domains simplify the configuration of DNS records and Front Door traffic routing configuration when you use a shared stem domain and tenant-specific subdomains. For example, suppose your tenants access their application by using subdomains like `tenant1.app.contoso.com`, `tenant2.app.contoso.com`, and so forth, you can configure a wildcard domain, `*.app.contoso.com`, instead of configuring each tenant-specific domain individually.

Azure Front Door provides support for creating custom domains that use wildcards. You can then configure a route for requests that arrive on the wildcard domain. When you onboard a new tenant, you don't need to reconfigure your DNS servers, issue new TLS certificates, or update your Front Door profile's configuration.

Wildcard domains work well if you send all your traffic to a single origin group. But if you have separate stamps of your solution, then a single-level wildcard domain isn't sufficient. You either need to use multi-level stem domains, or supply extra configuration, such as by overriding the routes to use for each tenant's subdomain. For more information, see [Subdomains](../considerations/domain-names.yml#subdomains).

Additionally, Front Door does not issue managed TLS certificates for wildcard domains, so you need to purchase and supply your own certificate.

For more information, see [Wildcard domains](/azure/frontdoor/front-door-wildcard-domain?pivots=front-door-standard-premium).

### Managed TLS certificates

Acquiring and installing TLS certificates can be complex and error-prone. Additionally, TLS certificates expire after a period of time, usually one year, and need to be reissued and reinstalled to avoid disruption to application traffic. When you use Front Door's managed TLS certificates, Microsoft takes responsibility for issuing, installing, and renewing certificates for your custom domain.

Your origin application might be hosted on another Azure service that also provides managed TLS certificates, such as Azure App Service. Front Door transparently works with the other service to synchronize your TLS certificates.

If you allow your tenants to provide their own custom domains, and you want Front Door to issue certificates for these domain names, it's important that your tenants avoid configuring CAA (Certificate Authority Authorization) records on their DNS servers that might block Front Door from issuing certificates on their behalf. For more information, see [TLS/SSL certificates](../considerations/domain-names.yml#tlsssl-certificates).

For more information about TLS certificates, see [End-to-end TLS with Azure Front Door](/azure/frontdoor/end-to-end-tls).

### Routing

A multitenant application might have one or more application stamps serving the tenants. Stamps are frequently used to enable multi-region deployments, and to support scaling your solution to large numbers of tenants.

Front Door has a powerful set of routing capabilities, which can support a number of different multitenant architectures. You can use routing to distribute traffic among origins within a stamp, or to send traffic to the correct stamp for a specific tenant. Routing can be configured based on domain names and URL paths, and by using the rules engine you can further customize routing behavior.

For more information, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).

### Rules engine

The Front Door rules engine enables you customize how Front Door processes at the network edge. The rules engine enables you to run small blocks of logic within Front Door's request processing pipeline. You can use the rules engine to override the routing configuration for a request. The rules engine also enables you to modify elements of the request before it's sent to the origin, and to modify some parts of the response before it's returned to the client.

For more information, see [What is Rules Engine for Azure Front Door?](/azure/frontdoor/front-door-rules-engine).

## Configure Front Door for your solution

When you use Front Door as part of a multitenant solution, there are multiple aspects to the configuration. You need to make decisions based on your own solution's design and requirements, including the following factors:

- How many tenants do you have, or plan to grow to?
- Do you share your application tier between multiple tenants, do you deploy single-tenant application instances, or do you deploy many separate deployment stamps that are shared by multiple tenants?
- Do your tenants want to bring their own domain names?
- Will you use wildcard domains?
- Do you need to use your own TLS certificates, or will Microsoft manage your TLS certificates?
- Have you considered the [quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-front-door-standard-and-premium-tier-service-limits) that apply to Front Door, and do you understand which limits you'll approach as you grow? If you suspect that you are going to approach these limits, consider using multiple Front Door profiles, or whether you can change the way that you're using Front Door to avoid the limits.
- Do you, or your tenants, have requirements for IP address filtering, geo-blocking, or customizing WAF rules?

## Example scenarios

The following scenarios illustrate how different multitenant architectures can be configured in Front Door, and how the decisions you make can affect your DNS and TLS configuration.

### Scenario 1: Provider-managed wildcard domains, single stamp

Contoso is building a small multitenant solution. They deploy a single stamp in a single region, and that stamp serves all of their tenants. All requests are routed to the same application server. They made a business decision to use wildcard domains for all of their tenants, such as `tenant1.contoso.com`, `tenant2.contoso.com`, and so forth.

They deploy Front Door by using a configuration similar to the diagram below:

![Diagram showing Front Door configuration, with a single custom domain, route, and origin group, and a wildcard TLS certificate in Key Vault.](media/front-door/provider-managed-wildcard-domain-single-stamp.png)

##### DNS configuration

**One-time configuration:** Contoso configures two DNS entries:

- A wildcard TXT record for `*.contoso.com`, and sets it to the value specified by Front Door during the custom domain onboarding process.
- A wildcard CNAME record, `*.contoso.com`, which aliases to their Front Door endpoint, `contoso.z01.azurefd.net`.

**When a new tenant is onboarded:** No additional configuration is required.

##### TLS configuration

**One-time configuration:** Contoso purchases a wildcard TLS certificate, adds it to a key vault, and grants Front Door access to the vault.

**When a new tenant is onboarded:** No additional configuration is required.

##### Front Door configuration

**One-time configuration**: Contoso creates a Front Door profile and a single endpoint. They add one custom domain, with the name `*.contoso.com`, and they associate their wildcard TLS certificate with the custom domain resource. Then, they configure a single origin group, which contains a single origin for their application server. Finally, they configure a route to connect their custom domain to the origin group.

**When a new tenant is onboarded:** No additional configuration is required.

##### Benefits

- This configuration is relatively simple to configure, and provides customers with Contoso-branded URLs.
- The approach supports a very large number of tenants.
- When a new tenant is onboarded, Contoso doesn't need to make any changes to Front Door, DNS, or TLS certificates.

##### Drawbacks

- This approach doesn't easily scale beyond a single application stamp or region.
- Contoso has to purchase a wildcard TLS certificate.
- Contoso is responsible for renewing and installing the certificate when it expires.

### Scenario 2: Individual provider-managed domains, multiple stamps

Prosware is building a multitenant solution across multiple stamps, which are deployed into both Australia and Europe. All requests within a single region are served by the stamp in that region. Similarly to Contoso, Prosware made a business decision to use wildcard domains for all of their tenants, such as `tenant1.prosware.com`, `tenant2.prosware.com`, and so forth.

They deploy Front Door by using a configuration similar to the diagram below:

![Diagram showing Front Door configuration, with multiple custom domains, routes, and origin groups, and a wildcard TLS certificate in Key Vault](media/front-door/provider-managed-wildcard-domains-multiple-stamps.png)

##### DNS configuration

**One-time configuration:** Prosware configures two DNS entries:

- A wildcard TXT record for `*.prosware.com`, and sets it to the value specified by Front Door during the custom domain onboarding process.
- A wildcard CNAME record, `*.prosware.com`, which aliases to their Front Door endpoint, `prosware.z01.azurefd.net`.

**When a new tenant is onboarded:** No additional configuration is required.

##### TLS configuration

**One-time configuration:** Prosware purchases a wildcard TLS certificate, adds it to a key vault, and grants Front Door access to the vault.

**When a new tenant is onboarded:** No additional configuration is required.

##### Front Door configuration

**One-time configuration**: Prosware creates a Front Door profile and a single endpoint. They configure multiple origin groups one per application stamp/server in each region.

**When a new tenant is onboarded:** Prosware adds a custom domain resource to Front Door. They use the name `*.prosware.com`, and associate their wildcard TLS certificate with the custom domain resource. Then, they create a route to specify which origin group (stamp) that tenant's requests should be directed to. In the example diagram above, `tenant1.prosware.com` routes to the origin group in the Australia region, and `tenant2.prosware.com` routes to the origin group in Europe region.

##### Benefits

- When new tenants are onboarded, no DNS or TLS configuration changes are required.
- Prosware maintains single instance of Front Door to route traffic to multiple stamps across multiple regions.

##### Drawbacks

- This approach requires that Prosware reconfigures Front Door every time a new tenant is onboarded.
- Prosware has to pay attention to [Front Door quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-front-door-standard-and-premium-tier-service-limits), especially on the number of routes, custom domains, and the [composite routing limit](/azure/frontdoor/front-door-routing-limits).
- Prosware has to purchase a wildcard TLS certificate.
- Prosware is responsible for renewing and installing the certificate when it expires.

### Scenario 3: Provider-managed stamp-based wildcard subdomains

Fabrikam is building a multitenant solution. They deploy stamps in Australia and the United States. All requests within a single region will be served by the stamp in that region. They made a business decision to use stamp-based stem domains, such as `tenant1.australia.fabrikam.com`, `tenant2.australia.fabrikam.com`, `tenant3.us.fabrikam.com`, and so forth.

They deploy Front Door by using a configuration similar to the diagram below:

![Diagram showing Front Door configuration, with multiple custom stamp-based stem domains, routes, origin groups, and wildcard TLS certificate in Key Vault](media/front-door/provider-managed-wildcard-domains-multiple-stem-stamps.png)

#### DNS configuration

**One-time configuration:** Fabrikam configures two wildcard DNS entries for each stamp:

- A wildcard TXT record for each stamp, such as `*.australia.fabrikam.com` and `*.us.fabrikam.com`, and sets them to the values specified by Front Door during the custom domain onboarding process.
- A wildcard CNAME record for each stamp, such as `*.australia.fabrikam.com` and `*.us.fabrikam.com`, which both alias to their Front Door endpoint, `fabrikam.z01.azurefd.net`.

**When a new tenant is onboarded:** No additional configuration is required.

#### TLS configuration

**One-time configuration:** Fabrikam purchases a wildcard TLS certificate for each stamp, adds them to a key vault, and grants Front Door access to the vault.

**When a new tenant is onboarded:** No additional configuration is required.

#### Front Door configuration

**One-time configuration:** Fabrikam creates a Front Door profile and a single endpoint. They configure an origin group for each stamp. They create a custom domain using the wildcard for each stamp-based subdomain, including `*.australia.fabrikam.com` and `*.us.fabrikam.com`. They create a route for stamp's custom domain to send traffic to the appropriate origin group.

**When a new tenant is onboarded:** No additional configuration is required.

#### Benefits

- This approach enables Fabrikam to scale to large numbers of tenants across multiple stamps.
- When new tenants are onboarded, no DNS or TLS configuration changes are required.
- Fabrikam maintains single instance of Front Door to route traffic to multiple stamps across multiple regions.

#### Drawbacks

- Because URLs use a multipart stem domain structure, URLs can be more complex for users to work with.
- Fabrikam has to purchase mulitiple wildcard TLS certificates.
- Fabrikam is responsible for renewing and installing the TLS certificates when they expire.

### Scenario 4: Vanity domains

AdventureWorks is building a multitenant solution. They deploy stamps in multiple regions, such as Australia and the United States. All requests within a single region will be served by the stamp in that region. They made a business decision to allow their tenants to bring their own domain names. For example, tenant 1 might configure a custom domain name like `tenant1app.tenant1.com`.

They deploy Front Door by using a configuration similar to the diagram below:

![Diagram showing Front Door configuration, with multiple custom vanity domains, routes, and origin groups, and a combination of TLS certificates in Key Vault and Front door managed TLS certificates](media/front-door/provider-and-AFD-managed-vanity-domains-multiple-stamps.png)

#### DNS configuration

**One-time configuration:** None.

**When a new tenant is onboarded:** The tenant needs to create two records in their own DNS server:

- A TXT record for domain validation purposes. For example, tenant 1 needs to configure a TXT record named `tenant1app.tenant1.com` and sets it to the value specified by Front Door during the custom domain onboarding process.
- A CNAME record that is aliased to the AdventureWorks Front Door endpoint. For example, tenant 1 needs to configure a CNAME record named `tenant1app.tenant1.com` and map it to `adventureworks.z01.azurefd.net`.

#### TLS configuration

AdventureWorks and their tenants need to decide who issues TLS certificates:

- The easiest option is for Front Door to issue and manage the certificates, but tenants must ensure not to configure a CCA record in their DNS server because this might prevent Front Door's certification authority from issuing certificates.
- Alternately, tenants can provide their own certificate. They must work with AdventureWorks to upload the certificate to a key vault, and provide access to Front Door.

#### Front Door configuration

**One-time configuration:** Fabrikam creates a Front Door profile and a single endpoint. They configure an origin group for each stamp. They do not create custom domain resources or routes.

**When a new tenant is onboarded:** AdventureWorks adds a custom domain resource to Front Door. They use the tenant-provided domain name, and they associate the appropiate TLS certificate with the custom domain resource. Then, they create a route to specify which origin group (stamp) that tenant's requests should be directed to. In the example diagram above, `tenant1app.tenant1.com` routes to the origin group in the Australia region, and `tenant2app.tenant2.com` routes to the origin group in the US region.

#### Benefits

- Customers can provide their own domain names and Front Door transparently routes requests to the multitenant solution.
- AdventureWorks maintains single instance of Front Door to route traffic to multiple stamps across multiple regions.

#### Drawbacks

- This approach requires that AdventureWorks reconfigures Front Door every time a new tenant is onboarded.
- The approach also requires that tenants are involved within the onboarding process, including making DNS changes and potentially issuing TLS certificates.
- Tenants are in control of their DNS records, and changes to DNS records might render them unable to access the AdventureWorks solution.
- AventureWorks has to pay attention to [Front Door quotas and limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-front-door-standard-and-premium-tier-service-limits), especially on the number of routes, custom domains, and the [composite routing limit](/azure/frontdoor/front-door-routing-limits).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Raj Nemani](http://linkedin.com/in/rajnemani) | Partner Technology Strategist

Other contributors:

 * [John Downs](http://linkedin.com/in/john-downs) | Principal Customer Engineer, FastTrack for Azure
 * [Arsen Vladimirskiy](http://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Links to other relevant pages within our section.
