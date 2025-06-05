In this scenario, an e-commerce company in the travel industry migrates a legacy web application by using Azure API Management. The new UI will be hosted as a platform as a service (PaaS) application on Azure, and it will depend on both existing and new HTTP APIs. These APIs will ship with a better-designed set of interfaces, which will enable better performance, easier integration, and future extensibility.

## Architecture

![Architecture diagram][architecture]

*[Download a Visio file][visio-download] of this architecture.*

### Workflow

1. The existing on-premises web application continues to directly consume the existing on-premises web services.
2. Calls from the existing web app to the existing HTTP services remain unchanged. These calls are internal to the corporate network.
3. Inbound calls are made from Azure to the existing internal services:
    - The security team allows traffic from the API Management instance to pass through the corporate firewall to the existing on-premises services [by using secure transport (HTTPS or SSL)][apim-ssl].
    - The operations team allows inbound calls to the services only from the API Management instance. It meets this requirement by [adding the IP address of the API Management instance to the allowlist][apim-allow-ip] within the corporate network perimeter.
    - A new module is configured into the on-premises request pipeline for HTTP services (to act on *only* connections that originate externally). The pipeline validates [a certificate that API Management provides][apim-mutualcert-auth].
4. The new API:
    - Is surfaced only through the API Management instance, which provides the API facade. The new API isn't accessed directly.
    - Is developed and published as an [Azure PaaS Web API app][azure-api-apps].
    - Is configured (via [settings for the Web Apps feature of Azure App Service][azure-appservice-ip-restrict]) to accept only the [API Management virtual IP (VIP)][apim-faq-vip].
    - Is hosted in Web Apps with secure transport (HTTPS or SSL) turned on.
    - Has authorization enabled, [provided by Azure App Service][azure-appservice-auth] via Microsoft Entra ID and Open Authorization (OAuth) 2.
5. The new browser-based web application depends on the Azure API Management instance for *both* the existing HTTP API and the new API.
6. The travel e-commerce company can now direct some users to the new UI (for preview or testing) while preserving the old UI and existing functionality side-by-side.

The API Management instance is configured to map the legacy HTTP services to a new API contract. In this configuration, the new Web UI is unaware of the integration with a set of legacy services/APIs and new APIs.

In the future, the project team will gradually port functionality to the new APIs and retire the original services. The team will handle these changes within API Management configuration, leaving the front-end UI unaffected and avoiding redevelopment work.

### Components

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) abstracts backend APIs as well as adding cross cutting functionality and discovery for developers and applications. In this scenario the recomposition of existing legacy backend APIs and the addition of new API functionality is made possible by using API Management as a [façade](/azure/architecture/patterns/strangler-fig) for the new client application to consume consistently and using modern standards. Because API Management façades both the existing and new APIs it's possible for the developers to modernize the legacy backends behind the API Management façade in an iterative way and with minimal to zero impact on the new front end development.
- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a turn-key Platform as a Service (PaaS) service for web hosting which provides out of the box features such as security, load balancing, autoscaling, and automated management. Azure App Service is a great choice for the new APIs being developed for this solution because it provides flexible turn-key hosting, enabling the DevOps team to focus on delivering features.

### Alternatives

- If the organization plans to move its infrastructure entirely to Azure, including the virtual machines (VMs) that host the legacy applications, API Management is still a great option because it can act as a facade for any addressable HTTP endpoint.
- If the organization had decided to keep the existing endpoints private and not expose them publicly, the organization's API Management instance could be linked to an [Azure Virtual Network][azure-vnet]:
  - When [API Management is linked to an Azure virtual network][apim-vnet-concepts], the organization could directly address the back-end service through private IP addresses.
  - In the on-premises scenario, the API Management instance could reach back to the internal service privately via an [Azure VPN Gateway and site-to-site Internet Protocol Security (IPsec) VPN connection][azure-vpn] or [Azure ExpressRoute][azure-er]. This scenario would then become a [hybrid of Azure and on-premises][azure-hybrid].
- The organization can keep the API Management instance private by deploying it in internal mode. The organization can then use deployment with [Azure Application Gateway][azure-appgw] to enable public access for some APIs while others remain internal. For more information, see [Integrate API Management in an internal virtual network with Application Gateway][apim-vnet-internal].
- The organization might decide to host its APIs on-premises. One reason for this change might be that the organization couldn't move downstream database dependencies that are in scope for this project to the cloud. If that's the case, the organization can still take advantage of API Management locally by using a [self-hosted gateway][apim-sh-gw].

  The self-hosted gateway is a containerized deployment of the API Management gateway that connects back to Azure on an outbound socket. The first prerequisite is that self-hosted gateways can't be deployed without a parent resource in Azure, which carries an additional charge. Second, the Premium tier of API Management is required.

## Scenario details

An e-commerce company in the travel industry is modernizing its legacy browser-based software stack. Although the existing stack is mostly monolithic, some [Simple Object Access Protocol (SOAP)-based HTTP services][soap] exist from a recent project. The company is considering the creation of additional revenue streams to monetize some of the internal intellectual property that it has developed.

Goals for the project include addressing technical debt, improving ongoing maintenance, and accelerating feature development with fewer regression bugs. The project will use an iterative process to avoid risk, with some steps performed in parallel:

- The development team will modernize the application's back end, which consists of relational databases hosted on VMs.
- The in-house development team will write new business functionality that will be exposed over new HTTP APIs.
- A contract development team will build a new browser-based UI, which will be hosted in Azure.

New application features will be delivered in stages. These features will gradually replace the existing browser-based client/server UI functionality (hosted on-premises) that now powers the company's e-commerce business.

Members of the management team don't want to modernize unnecessarily. They also want to maintain control of scope and costs. To do this, they've decided to preserve their existing SOAP HTTP services. They also intend to minimize changes to the existing UI. They can use [Azure API Management][apim] to address many of the project's requirements and constraints.

### Potential use cases

This scenario highlights modernizing legacy browser-based software stacks.

You can use this scenario to:

- See how your business can benefit from using the Azure ecosystem.
- Plan for migrating services to Azure.
- Learn how a shift to Azure would affect existing APIs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Consider deploying your Azure API Management instance with [Availability zones enabled][apim-ha]. The option to deploy API Management into Availability zones is only available in the Premium service tier.
- Availability zones can be used in conjunction with [additional gateway instances deployed to different regions][apim-multi-regions]. This improves service availability if one region goes offline. Multi-region deployment is also only available in the Premium service tier.
- Consider [Integrating with Azure Application Insights][azure-apim-ai], which also surfaces metrics through [Azure Monitor][azure-mon] for monitoring. For example, the capacity metric can be used to determine the overall load on the API Management resource and whether [additional scale-out units are required][apim-scaleout]. Tracking the resource capacity and health improves reliability.
- Ensure that downstream dependencies, for example the backend services hosting the APIs that API Management façades, are also resilient.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

API Management is offered in four tiers: Developer, Basic, Standard, and Premium. For detailed guidance on the differences in these tiers, see the [Azure API Management pricing guidance][apim-pricing].

You can scale API Management by adding and removing units. Each unit has capacity that depends on its tier.

> [!NOTE]
> You can use the Developer tier for evaluation of the API Management features. Don't use it for production.

To view projected costs and customize to your deployment needs, you can modify the number of scale units and App Service instances in the [Azure pricing calculator][pricing-calculator].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Ben Gimblett](https://uk.linkedin.com/in/benjamin-gimblett-0414992) | Senior Customer Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [Azure App Service overview](/azure/app-service/overview)
- [Azure API Management overview](/azure/api-management/api-management-key-concepts)

Learn modules:

- [Explore Azure App Service](/training/modules/introduction-to-azure-app-service/)
- [Deploy a website to Azure with Azure App Service](/training/paths/deploy-a-website-with-azure-app-service/)
- [Protect your APIs on Azure API Management](/training/modules/protect-apis-on-api-management/)

## Related resources

- [Architect scalable e-commerce web apps](../../web-apps/idea/scalable-ecommerce-web-app.yml)
- [Design great API developer experiences using API Management and GitHub](../../example-scenario/web/design-api-developer-experiences-management-github.yml)

<!-- links -->

[architecture]: ./media/architecture-apim-api-scenario.png
[apim-create]: /azure/api-management/get-started-create-service-instance
[apim-multi-regions]: /azure/api-management/api-management-howto-deploy-multi-region
[apim-ha]: /azure/api-management/high-availability
[apim-scaleout]: /azure/api-management/upgrade-and-scale
[azure-apim-ai]: /azure/api-management/api-management-howto-app-insights
[azure-mon]: /azure/monitoring-and-diagnostics/monitoring-overview
[azure-appgw]: /azure/application-gateway/application-gateway-introduction
[apim-vnet-internal]: /azure/api-management/api-management-howto-integrate-internal-vnet-appgateway
[apim-vnet]: /azure/api-management/api-management-using-with-vnet
[apim-vnet-concepts]: /azure/api-management/virtual-network-concepts
[azure-hybrid]: ../../reference-architectures/hybrid-networking/index.yml
[azure-er]: /azure/expressroute/expressroute-introduction
[azure-vpn]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[azure-vnet]: /azure/virtual-network/virtual-networks-overview
[azure-appservice-auth]: /azure/app-service/app-service-authentication-overview#identity-providers
[apim-faq-vip]: /azure/api-management/api-management-faq#how-can-i-secure-the-connection-between-the-api-management-gateway-and-my-back-end-services
[azure-appservice-ip-restrict]: /azure/app-service/app-service-ip-restrictions
[azure-api-apps]: /azure/app-service
[apim-ssl]: /azure/api-management/api-management-howto-manage-protocols-ciphers
[apim-mutualcert-auth]: /azure/api-management/api-management-howto-mutual-certificates
[apim-allow-ip]: /azure/api-management/api-management-faq#how-can-i-secure-the-connection-between-the-api-management-gateway-and-my-back-end-services
[apim]: /azure/api-management/api-management-key-concepts
[azure-vm-lift-shift]: https://azure.microsoft.com/resources/azure-virtual-datacenter-lift-and-shift-guide
[apim-pricing]: https://azure.microsoft.com/pricing/details/api-management
[azure-quickstart-templates-apim]: https://azure.microsoft.com/resources/templates/?term=API+Management&pageNumber=1
[soap]: https://en.wikipedia.org/wiki/SOAP
[pricing-calculator]: https://azure.com/e/0e916a861fac464db61342d378cc0bd6
[visio-download]: https://arch-center.azureedge.net/architecture-apim-api-scenario.vsdx
[apim-sh-gw]: /azure/api-management/self-hosted-gateway-overview
