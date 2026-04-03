In this scenario, an e-commerce company in the travel industry migrates a legacy web app by using Azure API Management. The company hosts the new UI as a platform as a service (PaaS) app on Azure. The new UI depends on both existing and new HTTP APIs. These APIs deploy with more effectively designed interfaces that improve performance, simplify integration, and allow future extensibility.

## Architecture

  :::image type="complex" source="./media/api-management-api-scenario-architecture.svg" border="false" lightbox="./media/api-management-api-scenario-architecture.svg" alt-text="Diagram that shows the steps to migrate a web app by using API Management.":::
      The diagram shows the flow between on-premises systems, the internet, and Azure services. On the left, within a box labeled on-premises, a globe icon represents existing HTTP services and APIs. In the same box, a browser window icon represents an existing browser-based web UI. A bidirectional arrow that connects these icons indicates communication between the existing browser-based web UI and the existing HTTP services and APIs. A building icon represents the on-premises datacenter. On the right, within a box labeled Azure, a cloud icon represents an API Management instance. A bidirectional arrow that passes through a lock icon connects this icon and the existing on-premises HTTPS services and APIs. The Azure box also contains a new API icon and a globe icon that represents the new browser-based web UI. A bidirectional arrow that passes through a lock icon connects the API Management instance and the new API. Another bidirectional arrow connects the API Management instance and the new browser-based web UI. Between the on-premises box and the Azure box, a cloud icon represents the internet. Arrows that pass through lock icons point from e-commerce user icons to the existing browser-based web UI and to the new browser-based web UI.
:::image-end:::

*[Download a Visio file](https://arch-center.azureedge.net/api-management-api-scenario-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. The existing on-premises web app continues to directly consume the existing on-premises web services.

1. Calls from the existing web app to the existing HTTP services remain unchanged. These calls are internal to the corporate network.

1. API Management makes calls from Azure to the existing internal services.

    - The security team allows traffic from the API Management instance to pass through the corporate firewall to the existing on-premises services [by using secure transport protocols](/azure/api-management/api-management-howto-manage-protocols-ciphers) like Hypertext Transfer Protocol Secure (HTTPS) over Transport Layer Security (TLS).

    - The operations team allows inbound calls to the services only from the API Management instance. It meets this requirement by [adding the IP address of the API Management instance to the allow list](/azure/api-management/api-management-faq#how-can-i-secure-the-connection-between-the-api-management-gateway-and-my-backend-services) within the corporate network perimeter.

    - A new module in the on-premises request pipeline for Hypertext Transfer Protocol (HTTP) services acts only on connections that originate externally. The pipeline validates [a certificate that API Management provides](/azure/api-management/api-management-howto-mutual-certificates).

1. The new API has the following characteristics:

    - Only the API Management instance, which provides the API facade, surfaces the new API. You don't directly access the new API.

    - You develop and publish the new API as an [Azure PaaS web API app](/azure/app-service/overview).

    - You set up the new API by using the [settings for the Web Apps feature of Azure App Service](/azure/app-service/app-service-ip-restrictions) to accept only the [API Management virtual IP (VIP)](/azure/api-management/api-management-faq#how-can-i-secure-the-connection-between-the-api-management-gateway-and-my-backend-services).

    - Web Apps hosts the new API with secure transport protocols like HTTPS or TLS turned on.

    - [Azure App Service](/azure/app-service/overview-authentication-authorization#identity-providers) provides authorization capabilities via Microsoft Entra ID and Open Authorization (OAuth) 2.

1. The new browser-based web app depends on the API Management instance for both the existing HTTP API and the new API.

1. The travel e-commerce company can direct some users to the new UI for preview or testing while preserving the old UI and existing functionality side by side.

Set up the API Management instance to map the legacy HTTP services to a new API contract. In this configuration, the new web UI is unaware of the integration with a set of legacy services or APIs and new APIs.

In the future, the project team can gradually move functionality to the new APIs and retire the original services. The team handles these changes within the API Management configuration, leaving the front-end UI unaffected and avoiding redevelopment work.

### Components

- [API Management](/azure/well-architected/service-guides/azure-api-management) is a management platform and gateway for APIs across all environments. In this architecture, it serves as a [facade](../../patterns/strangler-fig.md) for the existing legacy APIs and the new APIs. The new client app consumes a single consistent interface, and the team can modernize legacy back ends incrementally behind that facade with minimal impact on front-end development.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a turnkey PaaS solution for web hosting that provides out-of-the-box features like security, load balancing, autoscaling, and automated management. In this architecture, App Service provides flexible turnkey hosting so that the DevOps team can focus on feature delivery.

### Alternatives

- If the organization plans to move its infrastructure, including the virtual machines (VMs) that host the legacy apps, entirely to Azure, API Management can serve as a facade for any addressable HTTP endpoint.

- If the organization keeps the existing endpoints private and doesn't expose them publicly, the organization's API Management instance can link to an [Azure virtual network](/azure/virtual-network/virtual-networks-overview).

  - When [API Management is linked to an Azure virtual network](/azure/api-management/virtual-network-concepts), the organization can directly address the back-end service through private IP addresses.

  - In the on-premises scenario, the API Management instance can connect to the internal service privately via [Azure VPN Gateway and a site-to-site Internet Protocol Security (IPsec) VPN connection](/azure/vpn-gateway/tutorial-site-to-site-portal) or [Azure ExpressRoute](/azure/expressroute/expressroute-introduction). This scenario then becomes a [hybrid of Azure and on-premises](../../reference-architectures/hybrid-networking/index.yml).

- The organization can keep the API Management instance private by deploying it in internal mode. The organization can then use deployment with [Azure Application Gateway](/azure/application-gateway/overview) to allow public access for some APIs while others remain internal. For more information, see [Integrate API Management in an internal virtual network by using Application Gateway](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway).

- The organization might decide to host its APIs on-premises. One reason for this change might be that the organization can't move downstream database dependencies that are in scope for this project to the cloud. In this scenario, the organization can take advantage of API Management locally by using a [self-hosted gateway](/azure/api-management/self-hosted-gateway-overview).

  The self-hosted gateway is a containerized deployment of the API Management gateway that connects to Azure on an outbound socket. To use self-hosted gateways, you must meet the following prerequisites:
     
     - You must deploy self-hosted gateways by using a parent resource in Azure, which adds extra cost. 
     
     - You must use the Premium tier of API Management.

## Scenario details

An e-commerce company in the travel industry wants to modernize its legacy, browser-based software stack. The existing stack is mostly monolithic, but some [Simple Object Access Protocol (SOAP)-based HTTP services](https://wikipedia.org/wiki/SOAP) exist from a recent project. The company considers the creation of extra revenue streams to monetize some of its internal intellectual property.

Goals for the project include addressing technical debt, ongoing maintenance improvements, and feature development acceleration with fewer regression bugs. The project uses an iterative process to avoid risk and does the following steps in parallel:

- The development team modernizes the app's back end, which consists of relational databases hosted on VMs.

- The in-house development team writes new business functionality and exposes it over new HTTP APIs.

- A contract development team builds a new browser-based UI, which Azure hosts.

The company delivers new app features in stages. These features gradually replace the existing browser-based client and server UI functionality hosted on-premises that power the company's e-commerce business.

Members of the management team don't want to modernize unnecessarily. They also want to maintain control of scope and costs. To achieve these goals, they decide to preserve their existing SOAP HTTP services. They also intend to minimize changes to the existing UI. They can use [API Management](/azure/api-management/api-management-key-concepts) to address many of the project's requirements and constraints.

### Potential use cases

This scenario highlights how to modernize legacy, browser-based software stacks.

You can use this scenario for the following tasks:

- See how your business can benefit from using the Azure ecosystem.
- Plan a service migration to Azure.
- Learn how a shift to Azure might affect existing APIs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Activate [availability zones](/azure/reliability/reliability-api-management) when you deploy your API Management instance. The option to deploy API Management into availability zones is only available in the Premium service tiers.

- Use availability zones that have [extra gateway instances deployed to different regions](/azure/api-management/api-management-howto-deploy-multi-region). This combination improves service availability if one region goes offline. Multiregion deployment is only available in the Premium service tier.

- Integrate with [Application Insights](/azure/api-management/api-management-howto-app-insights), which surfaces metrics through [Azure Monitor](/azure/azure-monitor/fundamentals/overview) for monitoring. For example, you can use the capacity metric to determine the overall load on the API Management resource and whether you need [more scale-out units](/azure/api-management/upgrade-and-scale). Track resource capacity and health to improve reliability.

- Ensure that downstream dependencies, such as the back-end services that host the APIs that API Management covers, are also resilient.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

API Management has eight tiers: 

- Consumption
- Developer
- Basic and Basic v2
- Standard and Standard v2
- Premium and Premium v2

For more information about the differences in these tiers, see [API Management pricing](https://azure.microsoft.com/pricing/details/api-management/).

You can scale API Management by adding and removing units. Each unit has capacity that depends on its tier.

> [!NOTE]
> You can use the Developer tier to evaluate API Management features. Don't use it for production.

To view projected costs for your deployment needs, you can modify the number of scale units and App Service instances in the [Azure pricing calculator](https://azure.com/e/0e916a861fac464db61342d378cc0bd6).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ben Gimblett](https://uk.linkedin.com/in/benjamin-gimblett-0414992) | Senior Customer Engineer

Other contributor:

- [Andrew Cardy](https://www.linkedin.com/in/andrewcardy/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [App Service overview](/azure/app-service/overview)
- [API Management overview](/azure/api-management/api-management-key-concepts)
- [Set up staging environments in App Service](/azure/app-service/deploy-staging-slots)
- [Transform and protect your API](/azure/api-management/transform-api)
- [Explore App Service](/training/modules/introduction-to-azure-app-service/)

## Related resource

- [Design great API developer experiences by using API Management and GitHub](../../example-scenario/web/design-api-developer-experiences-management-github.yml)
