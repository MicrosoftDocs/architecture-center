---
title: Domain Name Considerations in Multitenant Solutions
description: This article describes the considerations that you need to give to domain names when you build multitenant web applications.
author: johndowns
ms.author: pnp
ms.date: 06/13/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Domain name considerations in multitenant solutions

In many multitenant web applications, you can use a domain name to provide the following capabilities:

- To distinguish one tenant from another

- To help with routing requests to the correct infrastructure
- To provide a branded experience to your customers

You can use subdomains or custom domain names. This article provides guidance for technical decision-makers about domain name approaches and their trade-offs.

## Subdomains

You can assign each tenant a unique subdomain under a common shared domain name by using a format like `tenant.provider.com`.

Consider an example multitenant solution built by Contoso. Customers purchase Contoso's product to help manage their invoice generation. Contoso assigns all tenants their own subdomain under the `contoso.com` domain name. If Contoso uses regional deployments, they might assign subdomains under the `us.contoso.com` and `eu.contoso.com` domains.

This article refers to these regional domains as *stem domains*. Each customer gets their own subdomain under your stem domain. For example, Tailwind Toys might receive `tailwind.contoso.com`. If you use a regional deployment model, Adventure Works might receive `adventureworks.us.contoso.com`.

> [!NOTE]
> Many Azure services use this approach. For example, when you create an Azure storage account, Azure assigns a set of subdomains, such as `<your account name>.blob.core.windows.net`.

### Manage your domain namespace

When you create subdomains under your own domain name, you could have multiple customers with similar names. They share a single stem domain, so the first customer to claim a specific domain receives their preferred name. Subsequent customers have to use alternate subdomain names because full domain names must remain globally unique.

### Wildcard DNS

Use wildcard Domain Name System (DNS) entries to simplify the management of subdomains. Instead of creating DNS entries for `tailwind.contoso.com` or `adventureworks.contoso.com`, you could create a wildcard entry for `*.contoso.com`. Direct all subdomains to a single IP address by using an A record or to a canonical name by using a CNAME record. If you use regional stem domains, you might need multiple wildcard entries, such as `*.us.contoso.com` and `*.eu.contoso.com`.

> [!NOTE]
> Make sure that your web-tier services support wildcard DNS if you plan to use this feature. Many Azure services, including Azure Front Door and Azure App Service, support wildcard DNS entries.

### Subdomains based on multiple-part stem domains

Many multitenant solutions span multiple physical deployments. This approach is common when you need to comply with data residency requirements or improve performance by deploying resources geographically closer to the users.

Even within a single region, you might spread your tenants across independent deployments to support your scaling strategy. If you plan to use subdomains for each tenant, consider a multiple-part subdomain structure.

For example, Contoso publishes a multitenant application for its four customers. Adventure Works and Tailwind Traders are in the United States, and their data is stored on a shared US instance of the Contoso platform. Fabrikam and Worldwide Importers are in Europe, and their data is stored on a European instance.

The following diagram shows an example of Contoso using the single-stem domain **contoso.com** for all their customers.

:::image type="complex" source="media/domain-names/subdomains-single-stem.png" alt-text="Diagram that shows US and Europe deployments of a web app, with a single stem domain for each customer's subdomain." lightbox="media/domain-names/subdomains-single-stem.png" border="false":::
For web app 1, adventureworks.us.contoso.com and tailwind.us.contoso.com point to us.contoso.com, which points to web app 1. For web app 2, fabrikam.contoso.com and worldwideimporters.contoso.com point to eu.contoso.com, which points to web app 2.
:::image-end:::

Contoso can use the following DNS entries to support this configuration.

| Subdomain | CNAME to |
|-|-|
| `adventureworks.contoso.com` | `us.contoso.com` |
| `tailwind.contoso.com` | `us.contoso.com` |
| `fabrikam.contoso.com` | `eu.contoso.com` |
| `worldwideimporters.contoso.com` | `eu.contoso.com` |

Each new onboarded customer requires a new subdomain. The number of subdomains increases with each customer.

Alternatively, Contoso could use deployment-specific or region-specific stem domains.

:::image type="complex" source="media/domain-names/subdomains-multiple-stem.png" alt-text="Diagram that shows US and EU deployments of a web app, with multiple-stem domains." lightbox="media/domain-names/subdomains-multiple-stem.png" border="false":::
For web app 1, adventureworks.us.contoso.com and tailwind.us.contoso.com point to us.contoso.com, which points to web app 1. For web app 2, fabrikam.eu.contoso.com and worldwideimporters.eu.contoso.com point to eu.contoso.com, which points to web app 2.
:::image-end:::

By using wildcard DNS, the DNS entries for this deployment might look like the following entries.

| Subdomain | CNAME to |
|-|-|
| `*.us.contoso.com` | `us.contoso.com` |
| `*.eu.contoso.com` | `eu.contoso.com` |

Contoso doesn't need to create subdomain records for every customer. Instead, a single wildcard DNS record for each geography's deployment allows new customers underneath that stem to automatically inherit the CNAME record.

Each approach has benefits and drawbacks. When you use a single-stem domain, you must create a DNS record for each tenant that you onboard, which increases operational overhead. However, you have more flexibility to move tenants between deployments. You can change the CNAME record to direct their traffic to another deployment. This change doesn't affect any other tenants.

Multiple-stem domains have a lower management overhead. You can reuse customer names across multiple regional stem domains because each stem domain effectively represents its own namespace.

## Custom domain names

You might want to enable your customers to bring their own domain names. Some customers see this feature as an important aspect of their branding. Customers might also require custom domain names to meet security requirements, especially if they need to supply their own Transport Layer Security (TLS) certificates. This approach might seem straightforward, but some hidden complexities require thoughtful consideration.

### Name resolution

Ultimately, each domain name must resolve to an IP address. As shown earlier, the name resolution process depends on whether you deploy a single instance or multiple instances of your solution.

To revisit the example, one of Contoso's customers, Fabrikam, requests to use `invoices.fabrikam.com` as their custom domain name to access Contoso's service. Contoso has multiple deployments of their multitenant platform, so they decide to use subdomains and CNAME records to achieve their routing requirements. Contoso and Fabrikam configure the following DNS records.

| Name | Record type | Value | Configured by |
|-|-|-|-|
| `invoices.fabrikam.com` | CNAME | `fabrikam.eu.contoso.com` | Fabrikam |
| `*.eu.contoso.com` | CNAME | `eu.contoso.com` | Contoso |
| `eu.contoso.com` | A | (Contoso's IP address) | Contoso |

From a name resolution perspective, this chain of records accurately resolves requests for `invoices.fabrikam.com` to the IP address of Contoso's European deployment.

### Host header resolution

Name resolution is only part of the problem. All web components within Contoso's European deployment must know how to handle requests that include Fabrikam's domain name in their `Host` request header. Depending on the specific web technologies that Contoso uses, each tenant's domain name might require further configuration, which adds extra operational overhead to tenant onboarding.

You can also rewrite host headers so that regardless of the incoming request's `Host` header, your web server sees a consistent header value. For example, Azure Front Door enables you to rewrite `Host` headers so that regardless of the request, your application server receives a single `Host` header. Azure Front Door propagates the original host header in the `X-Forwarded-Host` header so that your application can inspect it and then look up the tenant. However, rewriting a `Host` header can cause other problems. For more information, see [Host name preservation](../../../best-practices/host-name-preservation.yml).

### Domain validation

You must validate the ownership of custom domains before you onboard them. Otherwise, a customer could accidentally or maliciously claim a domain name, which is sometimes referred to as *parking* a domain name.

Consider Contoso's onboarding process for Adventure Works, who requested to use `invoices.adventureworks.com` as their custom domain name. Unfortunately, somebody made a typo when they tried to onboard the custom domain name, and they missed the *s*. So they set it up as `invoices.adventurework.com`. As a result, traffic fails to flow correctly for Adventure Works. But when another company named *Adventure Work* tries to add their custom domain to Contoso's platform, they're told that the domain name is already in use.

To prevent this problem, especially within a self-service or automated process, you can require a domain verification step. You might require the customer to create a CNAME record before the domain can be added. Alternatively, you might generate a random string and ask the customer to add a DNS TXT record that includes the string value. The domain name can't be added until the verification succeeds.

### Dangling DNS and subdomain takeover attacks

When you work with custom domain names, you expose your platform to a class of attacks called [*dangling DNS* or *subdomain takeover*](/azure/security/fundamentals/subdomain-takeover). These attacks occur when customers disassociate their custom domain name from your service, but they don't delete the record from their DNS server. This DNS entry then points to a nonexistent resource and is vulnerable to a takeover.

Consider how Fabrikam's relationship with Contoso might change if the following scenario occurs:

1. Fabrikam decides to no longer work with Contoso, so they terminate their business relationship.

1. Contoso offboards the Fabrikam tenant, and they disable `fabrikam.contoso.com`.
1. Fabrikam forgets to delete the CNAME record for `invoices.fabrikam.com`.
1. A malicious actor creates a new Contoso account and gives it the name `fabrikam`.
1. The attacker onboards the custom domain name `invoices.fabrikam.com` to their new tenant.
1. Contoso checks Fabrikam's DNS server during CNAME-based domain validation. They see that the DNS server returns a CNAME record for `invoices.fabrikam.com`, which points to `fabrikam.contoso.com`. Contoso considers the custom domain validation successful.
1. If Fabrikam employees try to access the site, requests appear to work. If the attacker sets up their Contoso tenant with Fabrikam's branding, employees might be fooled into accessing the site and providing sensitive data, which the attacker can then access.

Use the following strategies to protect against dangling DNS attacks:

- Require the CNAME record to be deleted *before* the domain name can be removed from the tenant's account.

- Prohibit the reuse of tenant identifiers. And require each tenant to create a TXT record with a name that matches the domain name and a randomly generated value that changes for each onboarding attempt.

## TLS certificates

TLS is an essential component of modern applications. It provides trust and security to your web applications. Carefully consider the ownership and management of TLS certificates for multitenant applications.

Typically, the owner of a domain name issues and renews its certificates. For example, Contoso issues and renews TLS certificates for `us.contoso.com` and a wildcard certificate for `*.contoso.com`. Similarly, Fabrikam manages records for the `fabrikam.com` domain, including `invoices.fabrikam.com`.

A domain owner can use the Certificate Authority Authorization (CAA) DNS record type. CAA records ensure that only specific authorities can create certificates for the domain.

If you allow customers to bring their own domains, consider whether you plan to issue certificates on their behalf or require them to bring their own. Each option has benefits and drawbacks:

- **If you issue a certificate for a customer**, you can handle the certificate renewal, so the customer doesn't need to maintain it. However, if the customers have CAA records on their domain names, they might need to authorize you to issue certificates on their behalf.

- **If customers issue and provide you with their own certificates**, you securely receive and manage the private keys. To avoid an interruption in their service, you might need to remind your customers to renew the certificate before it expires.

Several Azure services support automatic management of certificates for custom domains. For example, Azure Front Door and App Service provide certificates for custom domains, and they automatically handle the renewal process. This feature removes the burden of managing certificates from your operations team. However, you still need to consider ownership and authority. Confirm that CAA records are in place and configured correctly. Also ensure that your customers' domains allow the certificates that the platform manages.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Many services use Azure Front Door to manage domain names. For more information, see [Use Azure Front Door in a multitenant solution](../service/front-door.md).

Return to the [architectural considerations overview](overview.yml). Or review the [Azure Well-Architected Framework](/azure/well-architected/).
