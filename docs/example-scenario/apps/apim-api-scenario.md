---
title: Migrating a Monolithic Web Application to an API-based Architecture on Azure
description: An scenario based approach to use Azure API Management
author: begim
ms.date: 09/13/2018
---

# Migrating a Monolithic Web Application to an API-based Architecture on Azure

An e-commerce company in the travel industry is modernizing their legacy browser-based software stack. While their existing stack is mostly monolithic, some [SOAP-based HTTP services][soap] exist from a recent project. In the future, they are considering additional revenue streams from monetizing some of the internal Intellectual Property (IP) that's been built.

The goal of the project is address technical debt, improve ongoing maintenance and enable features to be delivered faster and with less regression.  The project will follow a stepped approach to avoid risk, with some steps running in parallel:

* The development team will modernize the application back-end, which is composed of relational databases hosted on VMs
* Their in-house development team will write new business functionality, which will be exposed over new HTTP APIs.
* A contracted development team will build a new browser-based UI, which will be hosted on the Azure Cloud.

The new applications features will be delivered in stages and will *gradually replace* the existing browser-based client-server UI functionality (hosted on-premises) that powers their e-commerce business today.

The management team does not want to unnecessarily modernize. They also want to maintain control of scope and costs.  To do this, they have made the decision to preserve their existing SOAP HTTP services. They also intend to limit changes to the existing UI as much as possible.

[Azure API Management (API-M)][apim] can be utilized to address many of the projects requirements and constraints.

## Architecture

![Sample scenario architecture][architecture-diagram]

The new UI will be hosted as Platform-as-a-Service on Azure, and will depend on both existing HTTP APIs and the new HTTP APIs.  These APIs will ship with a more carefully designed set of interfaces enabling better performance, easier integration, and future extensibility.

### Components and Security

1. The existing web application, hosted on-premises continues to directly consume the existing web services, also hosted on-premises.
2. The calls from the existing web app to the existing HTTP services are unchanged, these are internal calls within the corporate network.
3. Inbound calls are made from the cloud to the existing internal services:
    * The security team allow traffic from the Azure API-M instance to communicate, through the corporate firewall, with the existing on-premises services, [using secure transport (HTTPs/SSL)][apim-ssl].
    * The operations team will allow only inbound calls to the services from the API-M instance. This requirement is met by [white-listing the IP address of the API-M instance][apim-whitelist-ip] within the corporate network perimeter.
    * A new module is configured into the on-premise HTTP services request pipeline (to act upon ONLY those connections originating externally) that will check for and validate [a certificate which API-M will provide][apim-mutualcert-auth].
4. The new API:
    * Is surfaced only through the API-M instance, which will provide the API facade, the new API won't be accessed directly.
    * Is developed and published as an [Azure PaaS Web API App][azure-api-apps].
    * Is white-listed (via [Web App settings][azure-appservice-ip-restrict]) to accept only the [API-M VIP][apim-faq-vip].
    * Is hosted in Azure Web Apps with Secure Transport/SSL turned on.
    * Has Authorization turned on, [provided by the Azure App Service][azure-appservice-auth] using Azure Active Directory and OAuth2.
5. The new browser-based Web Application will depend on the Azure API-Management instance for *both* the existing HTTP API and the new API.

The API-M instance will be configured to map the legacy HTTP services to a new API contract. By doing this, the new Web UI is unaware it's integrating with a set of legacy services/APIs and new APIs. In the future, the project team plans to gradually port functionality to the new APIs and retire the original services. These changes will be handled within API-M configuration leaving the front-end UI unaffected and avoiding redevelopment work.

### Alternatives

* If the organization was planning to move their infrastructure entirely to Azure, including the VMs hosting the legacy applications, then API-M would still be a great option since it can facade any addressable HTTP endpoint.
* If the customer had decided to keep the existing endpoints private and not expose them publicly, their API Management instance could be linked to an [Azure Virtual Network (VNET)][azure-vnet]:
  * In an [Azure lift & shift scenario][azure-vm-lift-shift] linked to their deployed Azure Virtual Network, the customer could directly address the back-end service through private IP addresses.
  * In the on premises scenario, the API Management instance could reach back to the internal service privately via an [Azure VPN Gateway & Site-to-site IPSec VPN connection][azure-vpn] or [Express Route][azure-er] making this a [hybrid Azure - On-Premises scenario][azure-hybrid].
* It's possible to keep the API Management instance private by deploying the API Management instance in Internal mode. The deployment could then be used with an [Azure Application Gateway][azure-appgw] to enable public access for some APIs while others remain internal. For more information on [connecting API-M, in internal mode, to a VNET, see here.][apim-vnet-internal]

>[!NOTE] For general information on connecting API Management to a VNET, [see here.][apim-vnet]

### Availability & Scalability

Azure API Management can be:

* [Scaled out][apim-scaleout] by choosing a pricing tier and then adding units.
* Scaling also happen [automatically with auto scaling][apim-autoscale].
* [Deploying across multiple regions][apim-multi-regions] will enable fail over options and can be done in the [Premium tier][apim-pricing].
* Consider [Integrating with Azure Application Insights][azure-apim-ai], which also surfaces metrics through [Azure Monitor][azure-mon] for monitoring.

## Deployment

To get started, [create an Azure API Management instance in the portal.][apim-create]

Alternatively, you can choose from an existing Azure Resource Manager [quickstart template][azure-quickstart-templates-apim] that aligns to your specific use case.

## Pricing

API Management is offered in four tiers – developer, basic, standard, and premium.  You can find detailed guidance on the difference in these tiers at the [Azure API Management pricing guidance here.][apim-pricing]

Customers can scale API Management by adding and removing units. Each unit has capacity that depends on its tier.

> Note: The Developer tier can be used for evaluation of the API Management features, but should not be used for production.

To view projected costs and customize to your deployment needs, you can modify the number of scale units and App Service instances in the [Pricing Calculator][pricing-calculator].

## Related Resources

Check out the extensive Azure API Management [documentation and reference articles.][apim]

<!-- links -->
[apim-create]:/azure/api-management/get-started-create-service-instance
[apim-git]:/azure/api-management/api-management-configuration-repository-git
[apim-multi-regions]:/azure/api-management/api-management-howto-deploy-multi-region
[apim-autoscale]:/azure/api-management/api-management-howto-autoscale
[apim-scaleout]:/azure/api-management/upgrade-and-scale
[azure-apim-ai]:/azure/api-management/api-management-howto-app-insights
[azure-ai]:/azure/application-insights/
[azure-mon]:/azure/monitoring-and-diagnostics/monitoring-overview
[azure-appgw]:/azure/application-gateway/application-gateway-introduction
[apim-vnet-internal]:/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway
[apim-vnet]:/azure/api-management/api-management-using-with-vnet
[azure-hybrid]:/azure/architecture/reference-architectures/hybrid-networking/
[azure-er]:/azure/expressroute/expressroute-introduction
[azure-vpn]:/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[azure-vnet]:/azure/virtual-network/virtual-networks-overview
[azure-appservice-auth]:/azure/app-service/app-service-authentication-overview#identity-providers
[apim-faq-vip]:/azure/api-management/api-management-faq#is-the-api-management-gateway-ip-address-constant-can-i-use-it-in-firewall-rules
[azure-appservice-ip-restrict]:/azure/app-service/app-service-ip-restrictions
[azure-api-apps]:/azure/app-service/
[apim-ssl]:/azure/api-management/api-management-howto-manage-protocols-ciphers
[apim-mutualcert-auth]:/azure/api-management/api-management-howto-mutual-certificates
[apim-whitelist-ip]:/azure/api-management/api-management-faq#is-the-api-management-gateway-ip-address-constant-can-i-use-it-in-firewall-rules
[anti-corruption-layer-pattern]:/azure/architecture/patterns/anti-corruption-layer
[apim]:azure/api-management/api-management-key-concepts
[apim-api-design-guidance]:/azure/architecture/best-practices/api-design
[visualstudio-youtube-solid-design]:https://youtu.be/agkWYPUcLpg
[azure-vm-lift-shift]:https://azure.microsoft.com/en-gb/resources/azure-virtual-datacenter-lift-and-shift-guide/
[standard-pricing-calc]: https://azure.com/e/
[premium-pricing-calc]: https://azure.com/e/
[apim-pricing]:https://azure.microsoft.com/en-gb/pricing/details/api-management/
[azure-quickstart-templates-apim]:https://azure.microsoft.com/resources/templates/?term=API+Management&pageNumber=1
[soap]:https://en.wikipedia.org/wiki/SOAP
[architecture-diagram]: ./media/apim-api-scenario/architecture-apim-api-scenario.png
[pricing-calculator]: https://azure.com/e/0e916a861fac464db61342d378cc0bd6