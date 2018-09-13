---
title: Creating an API Facade with Azure API Management
description: An scenario based approach to use Azure API Management
author: begim
ms.date: 09/13/2018
---
# APIs

There is a large focus across industries on Digital Transformation. Often, organizations will want to focus on modernizing their applications to enable new scenarios for their end-users and enable more rapid (or agile) development of the application. A key part of that journey is reducing the accrued technical debt within those applications.

Monolithic Applications can be a main culprit from a technical debt perspective. They tend to evolve over time, becoming increasingly difficult to scale, operate and maintain. Valuable business logic can be inaccessible, and worse, duplicated across teams and applications through various stages of a project.

A popular mitigation is to decompose these monolithic applications and re-architect them into services (or microservices) which expose their functionality through interfaces for other parties to consume, almost always over HTTP, we call these HTTP interfaces [**APIs**][apim-api-design-guidance].

Two important benefits can be realised from breaking down chunks of tightly coupled or in-process business logic into **APIs**:

1. Across an organization common functionality is often duplicated within applications; exposing common business logic through well defined interfaces - following [SOLID design principles][visualstudio-youtube-solid-design] - allows for centralization and re-use of business processes, which can then evolve independently over time.

2. Business logic and processes represented by Services can be independently monitored and scaled horizontally or vertically, or both. The ability to scale "hot" parts of a system independently at a more granular level is often far more effective than trying to scale a monolith.

## Potential use cases

APIs can be consumed in either or both the following scenarios:

1. **Internal composition & agility**: Allow new & existing Line-of-Business (LoB) applications to discover & consume new and existing APIs maintained within their organization, or The Cloud. This can greatly improve Line-of-business productivity by surfacing easy to discover sources of data and core business functionality to those who need it.

    >Note: In this scenario each API should have an owner or team who is responsible for managing competing requirements *and* ensuring the service evolves over time **without breaking** existing consumers. The team responsible for an API should develop, maintain and support that API through to production. The most successful teams develop and manage their *internal APIs* as if they were building and maintaining *external APIs*.

2. **Monetization**: Developing new, or surfacing existing internal Services, with *externally facing APIs*, for consumption outside of the organization. Over time organizations develop significant business value and Intellectual Property, in some scenarios the ability to surface that functionality to third parties or partners through externally facing APIs can provide a valuable additional revenue stream.

It does not matter if the API is internal or external; defining and managing APIs requires careful thought and consideration. The API of a Service defines its contract to the outside world. Applications built against that Service take a dependency to the API which implies a real cost to change. Internal and external consumers of an API will be unwilling to bear the cost of accommodating frequent, breaking, changes.

This makes the work of a service and API developer much more challenging - not only do they need to ensure they develop a stable lasting contract (API) they may also need to ensure that other functional and non-functional requirements are developed in addition to the business logic being developed, for example:

* Security
* Insights & Analytics
* Versioning
* Developer experience
* Management
* Fair use

Whilst you can write these features into your services / APIs - [Azure API Management][apim] provides a turn-key solution covering these requirements and more, allowing developers to focus on what they know bes - delivering business value.

## Azure API-Management Scenario

A small but successful e-commerce company in the Travel Industry are modernizing their existing legacy browser based client-server software stack.

Whilst the existing stack is essentially monolithic some [SOAP based HTTP services][soap] exist from a recent modernization project.

Their industry is frequently adapting; they are looking for advantage over their competitors by developing and shipping features faster and more accurately. In the future they are considering additional revenue streams from monetizing some of the internal Intellectual Property (IP) that's been built.

The goal of the project is address technical debt, improve ongoing maintenance and enable features to be delivered faster and with less regression.

The project will follow a stepped approach to avoid risk, with some steps running in parallel:

* The development team will begin work modernizing the application back-end (these comprise of Relational Databases hosted on VMs)

* Their in house development team will start writing net new business functionality which will be exposed over new HTTP APIs.

* A near-sourced contract development team will build a new browser based UI experience to be hosted on the Azure Cloud. (The new UI is likely to follow a Single Page Application architecture). The new applications features will be delivered in stages and will *gradually replace* the existing browser based client-server UI functionality (hosted on-premises) that powers their e-commerce business today.

> The management team do not want to modernize unnecessarily and they are also keen to keep control of scope and costs, as part of this rationale they have made the decision to preserve their existing SOAP HTTP services. They also intend to limit changes to the existing UI as much as possible.

 The new UI, to be hosted as Platform-as-a-Service in Azure, will depend on both existing HTTP APIs **and** the new HTTP APIs which will ship with a more carefully designed set of interfaces - enabling better performance, easier integration and future extensibility.

The project team have therefore defined the following requirements and constraints.

### Scenario Requirements & Constraints

1. The existing UI application and the new UI functionality will need to co-exist for a period of time.
2. The existing HTTP services APIs will need to be preserved for the existing UI application which depends on them.
3. The existing HTTP API implementation was rushed and the team do not want to carry over this debt. The existing APIs will therefore require a [facade][anti-corruption-layer-pattern] for integration with the new Single Page Application UI.
4. The UI work will be undertaken in parallel, to avoid development bottlenecks the near-source team delivering the UI will need access to the APIs before they are fully developed.
5. The remote UI team will also need a way to discover the API functionality, learn the schemas and test. This will help ensure their integration development is more productive.
6. It is expected that several revisions will be required, as requirements are refined and discovered, during the course of the project. The API developers will need a way to manage this without disrupting the other teams working in parallel who depend on them.

## Architecture

[Azure API Management (API-M)][apim] can be utilised to address many of the projects requirements and constraints.

![Sample scenario architecture][architecture-diagram]

### Components

1. The existing web application, hosted on-premises continues to directly consume the existing web services, also hosted on-premises.
2. The calls from the existing web app to the existing HTTP services are unchanged, these are internal calls within the corporate perimeter. The security team does not require any additional security for on-premises to on-premises dependencies.
3. Inbound calls to the existing internal services:
    * The security team allow traffic from the Azure API-M instance to communicate, through the corporate firewall, with the existing on-premises services, [using secure transport (HTTPs/SSL)][apim-ssl].
    * The security team instruct the operations team to allow only inbound calls to the services from the API-M instance. This requirement is met by [white-listing the IP address of the API-M instance][apim-whitelist-ip] within the corporate network perimeter.
    * The security team also request that a new module is configured into the on-premise HTTP services request pipeline (to act upon ONLY those connections originating externally) that will check for and validate a certificate which API-M will provide via a "x" request header. [The mutual certificate exchange enables API-M to authenticate with the on-premises services][apim-mutualcert-auth].
4. The new API:
    * Is surfaced only through the API-M instance, which will provide the API facade, the new API will not be accessed directly.
    * Is developed and published as an [Azure PaaS Web API App][azure-api-apps].
    * Is white-listed (via [Web App settings][azure-appservice-ip-restrict]) to accept only the [API-M VIP][apim-faq-vip].
    * Is hosted in Azure Web Apps with Secure Transport/SSL turned on.
    * Has Authorization turned on, [provided by the Azure App Service][azure-appservice-auth] using Azure Active Directory and OAuth2.
5. The new and improved browser based Web Application being developed by the Near-Sourced contract team will depend on the Azure API-Management instance for *both* the existing HTTP API and the new API. The API-M instance will be configured to map the legacy HTTP services to a new API contract which is consistent with the new HTTP APIs being developed. In this way the new Web UI is completely unaware it's integrating with a set of legacy services/APIs *and* new APIs. In the future the project team plan to gradually port functionality across to the new APIs and eventually retire the original services. These changes will be handled within API-M configuration leaving the front end UI unaffected and avoiding costly re-development work!

### Alternatives

1. If the organisation was planning to move their infrastructure entirely to Azure, including the VMs hosting the legacy applications, then API-M would still be a great option. API Management can facade any addressable HTTP endpoint.
2. Whether the legacy services stay on-premises or are moved to Azure VMs; had the customer decided to keep the existing service endpoints private and not expose them publicly, their API Management instance could be linked to an [Azure Virtual Network (VNET)][azure-vnet]:
    * In an [Azure lift & shift scenario, moving the existing on-premises VMs to Azure][azure-vm-lift-shift], the API Management instance, linked to their deployed Azure Virtual Network, could directly address the back-end service through private IP addresses.
    * In the on premises scenario, the API Management instance linked to their deployed Virtual Network could reach back to the internal service privately via an [Azure VPN Gateway & Site-to-site IPSec VPN connection][azure-vpn] or [Express Route][azure-er] - making this a [hybrid Azure - On-Premises scenario][azure-hybrid].
3. If a future requirement was made to keep the API Management instance private, this is possible by deploying the API Management instance in Internal mode. The deployment could then be used in conjunction with an [Azure Application Gateway][azure-appgw] to enable public access for some APIs whilst others remain internal. For more information on [connecting API-M, in internal mode, to a VNET, see here.][apim-vnet-internal]

> For general information on connecting API Management to a VNET, [see here.][apim-vnet]

### Availability, Scalability

Azure API Management can be:

* [Scaled out by choosing a pricing tier and then adding units][apim-scaleout].
* [Auto Scaled][apim-autoscale].
* [Deployed across multiple regions][apim-multi-regions] in the [Premium tier][apim-pricing].
* [Integrated with Azure Application Insights][azure-apim-ai], which also surfaces metrics through [Azure Monitor][azure-mon] for monitoring.

## Deployment

* Get started; [create an Azure API Management instance in the portal.][apim-create]
* [Deploy with an Azure Resource Manager Quick-Start Template.][azure-quickstart-templates-apim]

## Pricing

[Azure API Management pricing guidance here.][apim-pricing]

> Note: The Developer tier can be used for evaluation of the API Management features, but should not be used for production.

## Related Resources

Checkout the extensive Azure API Management [documentation and reference articles.][apim]

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
[azure-quickstart-templates-apim]:https://azure.microsoft.com/en-gb/resources/templates/?term=API+Management&pageNumber=1
[soap]:https://en.wikipedia.org/wiki/SOAP
[architecture-diagram]: ./media/apim-api-scenario/architecture-apim-api-scenario.png