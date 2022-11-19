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
On this page, we describe some of the features of Front Door that are useful when working with multitenanted systems, and we link to guidance and examples for how to use Front Door in a multitenant solution.  It is important to note that Azure Front Door deployments can have two scenarios.  One scenario is where Azure Front Door is part of the application stamp and the second scenario is when it is outside of the application stamp.  The discussion in the guidance is geared towards the second scenario.

## Features of Front Door that support multi-tenancy
In this section we will consider few key features of Front Door that support multi-tenancy.  Specifically we will focus on various routing scenarios that Front Door allows for multi-tenancy.  We will also discuss configuring customs domains with BYO TLS certificates.  Finally we will look at isolation models that can be used with Front Door to support multi-tenancy
### Routing
A multitenant application can have one or more application stamps serving the tenants for scaling and other reasons.  The default URLs for these application stamps are not user friendly.  DNS records are the standard method to map these hard-to-remembers URLs to user friendly ones. While friendly URLs are a step in the right direction, challenges still exist  with routing traffic from a tenant user to the corresponding back-end stamp that is meant to serve the traffic for te tenant. We will more on how to overcome these challenges later in the article.
### Rules Engine
Rules engine is another feature that can help in using Azure Front Door in shared multitenant models to achieve the desired functionality and isolation.  Rules engine is a rule set that groups a combination of rules into a single set and allows you to customize how requests get processed at the edge, and how Azure Front Door handles those requests.  You can associate a Rule Set with multiple routes. The rules engine enables you to run small sections of logic within Front Door's request processing pipeline. You can use the rules engine to override the routing configuration for a request, or modify elements of a response.
### Custom domains
The default Front Door profile URL containing azurefd.net subdomain is not friendly for end users to remembers, not convenient, and not useful for branding purposes.  Fortunately Front Door allows associating a custom domain with the default host.  This will allow you to deliver content using a customer domain in the URL such as https://tenant1.app.contoso.com/photo.png.  In a multitenant application with shared Front Door scenario we specifically need the ability to configure multiple custom domains served by a single Front Door profile.
#### Wildcard domains
Azure Front Door provides support for mapping wildcard domains to front end hosts.  Wildcard domains simplify the configuration of traffic routing for each shared tenant's subdomain. Same routing rule can be specified for routing for multiple subdomains tenant1.app.contoso.com, tenant2.app.contoso.com, and tenant2.app.contoso.com by adding the wildcard domain *.app.contoso.com.  There is no additional complexity associated with onboarding of each subdomain to enable HTTPS and bind a certificate or the need to change Front Door configuration whenever a new subdomain is added.
#### Managed TLS certificates
Azure Front Door supports two types of domains, non-Azure validated domains and Azure pre-validated domains.  Azure Front Door supports both Azure managed certificate and Bring Your Own Certificates.  For Non-Azure validated domain, the Azure managed certificate is issued and managed by the Azure Front Door. For Azure pre-validated domain, the Azure managed certificate gets issued and is managed by the Azure service that validates the domain. Review [guidance on domain names](../considerations/domain-names.md), and be aware of CAA restrictions on your tenants' domain names.

## Example Scenarios

When working with a multitenant system using Front Door, you need to make a decision about the level of isolation that you want to use. The choice of isolation models you use depends on the following factors:

- How many tenants do you plan to have?
- Do you share your application tier between multiple tenants, do you deploy single-tenant application instances, or do you deploy separate deployment stamps for each tenant?
- Do your tenants want to use custom domains, want certificates issued or bring their own?
- How to do you plan to deploy Azure Front Door.  Note that It is possible to deploy a single shared Azure Front Door following the [Deployment Stamps](https://docs.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/overview#deployment-stamps-pattern) pattern as discussed below in detail. There are [limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) with each Front Door profile and if you suspect that you are going to approach these limits, consider using a new Front Door profile associated with it or change the way you're using Front Door to avoid the limits, if that's possible.  Also watch for tenant-specific requirements e.g. IP filtering, WAF rule customization.

The following discussion through example scenarios is meant to provide answers to the above questions

### Scenario 1: Provider-managed wildcard domains, single stamp
- **Context**: Contoso is building a small multitenant solution and has a single stamp in a single region that serves all of their tenants. All requests are routed to the same application server. They made a business decision to use wildcard domains for all of their tenants, such as tenant1.contoso.com, tenant2.contoso.com and so forth.
- **Diagram**: Diagram that illustrates the scenario.
- **DNS configuration**: Contoso configures one DNS entry - a wildcard CNAME record, *.contoso.com, which directs to their Front Door endpoint, contoso.z01.azurefd.net.
- **TLS configuration**: Contoso purchases a wildcard TLS certificate and add it to a key vault.
- **Front Door configuration**: They create a Front Door profile, and add one custom domain with the name *.contoso.com, and associate their wildcard TLS certificate with the custom domain resource. Then, they configure a single origin group, which contains a single origin for their application server. Finally, they configure a route to connect their custom domain to the origin group.
- **Benefits and drawbacks**: This configuration is relatively simple to configure, and provides customers with Contoso-branded URLs. It also supports a very high number of tenants, and when a new tenant is onboarded, they don't need to make any configuration changes in Front Door. However, this approach doesn't easily scale beyond a single application stamp or region. There is also additional cost to acquire a wildcard TLS certificate, and Contoso is responsible for renewing and installing those certificates when they expire.

### Scenario 2 (individual provider-managed domains, multiple stamps)
- **Context**: Prosware is building a multitenant solution and  has multiple stamps in multiple regions e.g. Australia, US, Europe. All requests with in a single region will be served by the stamp in that region. They made a business decision to use wildcard domains for all of their tenants, such as tenant1.prosware.com, tenant2.prosware.com and so forth.
- **Diagram**: Diagram that illustrates the scenario.
- **DNS configuration**: Prosware configures one DNS entry - a wildcard CNAME record, *.prosware.com, which directs to their Front Door endpoint, prosware.z01.azurefd.net.
- **TLS configuration**: Prosware purchases a wildcard TLS certificate and add it to a key vault.
- **Front Door configuration**: They create a Front Door profile, and add one custom domain with the name *.prosware.com, and associate their wildcard TLS certificate with the custom domain resource. Then, they configure multiple origin groups one per application stamp/server in each region. Finally, each tenant will be configured to have a route defined to the corresponding origin group. As an example, tenant1.prosware.com routes to the origin group in Australia region and tenant2.prosware.com routes to the origin group in Europe region etc. 
- **Benefits and drawbacks**: The benefits of this type of configuration include being able to use a single instance of Azure Frond Door to route traffic to multiple stamps/regions.  The downside is that it requires configuring routing for Azure Front Door each time a new tenant is on-boarded.  Another downside is that in this scenario, you have to pay attention to Azure Front Door subscription limits specifically for routes, custom domains, and the composite limit (need clarification here). Other downsides include the extra cost for wild card certificates and the need to renew the wildcard certificates and upload them to Key Vault before they expire.

### Scenario 3 (customer- and stamp-based, provider-managed subdomains)
- **Context**: Fabrikam is building a multitenant solution and  has multiple stamps in multiple regions e.g. Australia, US, Europe. All requests with in a single region will be served by the stamp in that region. They made a business decision to use stamp-based stem domains, e.g. tenant1.australia.fabrikam.com, tenant2.us.fabrikam.com, tenant3.europe.fabrikam.com, etc.  
- **Diagram**: Diagram that illustrates the scenario.
- **DNS configuration**: Fabrikam configures one DNS entry per stamp by mapping *.australia.fabrikam.com with CNAME to AFD-Profile-Name.z01.azurefd.net, and mapping *.us.fabrikam.com with CNAME to AFD-Profile-Name.z01.azurefd.net etc.    
- **TLS configuration**: Fabrikam purchases a wildcard TLS certificate for each stamp and add it to a key vault.
- **Front Door configuration**: The final Azure Front Door configuration will have one origin group per stamp.  Each stamp is configured with one custom domain with a matching wildcard certificate for the stamp/origin group, e.g. *.us.fabrikam.com custom domain will be mapped to the US origin group with one route per stamp.  As an example tenant2.us.fabrikam.com custom domain will be connected to the US origin group.  The configuration in this scenario scales very well as new tenants are on-boarded. 
- **Benefits and drawbacks**: Same benefits and drawbacks discussed in scenario 2 also exist here.  There is an additional drawback of having to deal with slightly complex URLs.

### Scenario 4 (vanity domains)
Here, the tenants of the multitenant solution want to use vanity domain names and don’t want to see solution vendor's branding anywhere.  Solution has multiple stamps in different regions, e.g. Australia, US, Europe.  The tenants will need to configure a DNS entry for their vanity domain and alias it to Azure Front Door profile, e.g. app.tenant1.com CNAME AFD-Profile-Name.z01.azurefd.net, customers.customer2.com CNAME AFD-Profile-Name.z01.azurefd.net.  For TLS configuration, the solution provider and the tenants need to decided on who issues the certificates.  If everyone agrees, the easiest rout is for Azure Front Door to issue and manage the certificates. But tenants must ensure not to configure a CCA record in their DNS server which will block Azure Front Door (Digicert) from issuing the certificates.  Alternately, tenants can provide their own certificate to the solution provided to be uploaded to KeyVault and configure it in Azure Front Door.  Azure Front Door configuration will have one custom domain per tenant, e.g. crm.tenant1.com, tenants.tenant2.com etc. The certificates are either Azure Front Door managed or a Bring-Your-Own certificates supplied by the tenant. 

- **Context**: AdventureWorks is building a multitenant solution and  has multiple stamps in multiple regions e.g. Australia, US, Europe. All requests with in a single region will be served by the stamp in that region. They made a business decision to allow tenants of the multitenant solution to use vanity domain names
- **Diagram**: Diagram that illustrates the scenario.
- **DNS configuration**: AdventureWorks configures one DNS entry for each vanity domain and alias it to Azure Front Door profile, e.g. crm.tenant1.com CNAME AFD-Profile-Name.z01.azurefd.net, tenants.tenant2.com CNAME AFD-Profile-Name.z01.azurefd.net.     
- **TLS configuration**: For TLS configuration, the solution provider and the tenants need to decided on who issues the certificates.  If everyone agrees, the easiest route is for Azure Front Door to issue and manage the certificates. But tenants must ensure not to configure a CCA record in their DNS server which will block Azure Front Door (Digicert) from issuing the certificates.  Alternately, tenants can provide their own certificate to the solution provider to be uploaded to KeyVault and configure it in Azure Front Door.  
- **Front Door configuration**: Azure Front Door configuration will have one custom domain per tenant, e.g. crm.tenant1.com, tenants.tenant2.com etc. The certificates are either Azure Front Door managed or BYO certificates supplied by the tenant. 
- **Benefits and drawbacks**:  Same benefits and drawbacks discussed in scenario 2 also exist here. 

## Next steps

Links to other relevant pages within our section.

## Related resources

If appropriate, include links to Microsoft videos, case studies, blog posts, etc.
