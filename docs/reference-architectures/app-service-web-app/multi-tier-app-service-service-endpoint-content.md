Any web application that's developed and distributed among more than one layer is known as a multi-tier web application. The tiers divide the application into two or more components that may be separately developed and executed. To put it simply, a multi-tier web application is a front-end web application that calls one or more API applications behind it. This reference architecture showcases how to use service endpoints for secure communications between app services in a multi-tier environment.

## Architecture

:::image type="content" source="images/multi-tier-app-service-service-endpoint.png" lightbox="images/multi-tier-app-service-service-endpoint.png" alt-text="Architecture of a multi-tier app.":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1874703-PR-3830-multi-tier-app-service-service-endpoint.vsdx) of this architecture.*

### Workflow

Here's the traffic flow and basic configuration of the architecture:

1. Requests route from the internet to a front-end app.
1. The virtual network integration feature of App Service routes all outbound communications from the front-end apps to the integration subnet. For more information about virtual network integration, see [Integrate your app with an Azure virtual network](/azure/app-service/web-sites-integrate-with-vnet).
1. The API app has service endpoints that restrict inbound communications— they only allow communications from front-end apps on the integration subnet. For more information on service endpoints, see [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview).
1. The API app can't be accessed from the public internet. Only internal components, or components connected to the virtual network, can reach the API app.
1. A resource group is a container that holds related resources for an Azure solution. The resources can include virtual machines, virtual networks, storage accounts, web apps, databases, and database servers. It can be convenient to group resources that have the same lifecycle, so that you can easily deploy, update, and delete them as a group. For more information, see [What is a resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group).

### Components

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [Azure App Service](/azure/app-service/overview) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. The virtual network integration feature of App Service can give your app access to resources in or through a virtual network. For more information, see [Integrate your app with an Azure virtual network](/azure/app-service/web-sites-integrate-with-vnet).
- [Azure Private Link](https://azure.microsoft.com/services/private-link) provides private access to services hosted on the Azure platform, keeping your data on the Microsoft network.

### Alternatives

- You can deploy both the front-end app and the API app in the same Azure App Service Environment, and make the front-end app directly accessible to the internet by using an application gateway. For information about App Service Environments, see [Introduction to the App Service Environments](/azure/app-service/environment/intro).
- Another technique is to deploy the front-end app in the multitenant service and the API app in an App Service Environment. You can also host both the front-end app and the API app in the multitenant service.
- There are other ways to secure your web apps, such as:
  - App-assigned addresses
  - Access restrictions
  - Azure Private Link

For more information, see [App Service networking features](/azure/app-service/networking-features).

## Scenario details

By using service endpoints, you can control inbound access to your API app. You can specify that all accessors must be in subnets that you select. The restriction can be set on the API app or at the front-end site with allow and deny rules at the virtual network and subnet levels.

> [!Note]
> Although this article focuses on the use of service endpoints, other aspects of the architecture, such as Azure App Service and virtual network integration, are widely applicable.

### Potential use cases

This architecture may suit these use cases:

- Solutions with two services that require access restrictions
- Finance and healthcare applications that require private connections to a back-end API app

### Benefits

- This architecture provides a way to create a multi-tier web application that has a secure API back end. Traffic to your API app comes only from the subnet of the front-end web app.
- Service endpoints are more affordable, faster, and easier to set up when compared to App Service Environments. There's no way for an App Service web app to join a virtual network without the App Service Environment, which is expensive.
- Service endpoints work well at smaller scale, because you can easily enable service endpoints for the API app on the front-end integration subnet.
- Using Private Link adds complexity because there are two subnets. Also, the private connection is a top-level resource that adds management overhead.

## Considerations

Service endpoints protect the API apps from being accessed by anything other than front-end apps. However front-end apps aren't protected from other front-end apps.

### Availability

- A system can't be highly available unless it's reliable. For techniques to increase reliability, see [Reliability patterns](/azure/architecture/framework/resiliency/reliability-patterns).

### Scalability

- Performance efficiency is the ability of your workload to scale to meet the demands placed on it in an efficient manner. Be aware of performance efficiency patterns as you design and build your cloud application. For more information, see [Performance Efficiency patterns](/azure/architecture/framework/scalability/performance-efficiency-patterns).
- Learn about scaling a basic web app in [Scaling the App Service app](/azure/architecture/web-apps/architectures/basic-web-app#scaling-the-app-service-app). Review the other articles in the same section for ideas regarding other architectures.
- For more performance efficiency ideas, see [Performance efficiency checklist](/azure/architecture/framework/scalability/performance-efficiency).

### Cost optimization

Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

Some aspects that affect the cost of an implementation are:

- The scalability of the solution—how well it supports changes in demand.
- Whether the solution runs continuously or intermittently.
- The service tiers chosen.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - Dixit Arora | Senior Customer Engineer

## Next Steps

- [App Service documentation](/azure/app-service)
- [App Service networking features](/azure/app-service/networking-features)
- [Integrate your app with an Azure virtual network](/azure/app-service/web-sites-integrate-with-vnet)
- [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview)
- [Introduction to the App Service Environments](/azure/app-service/environment/intro)
- [Private link resource](/azure/private-link/private-endpoint-overview#private-link-resource)
- [App Service overview](/azure/app-service/overview)
- [Reliability patterns](/azure/architecture/framework/resiliency/reliability-patterns)
- [Performance Efficiency patterns](/azure/architecture/framework/scalability/performance-efficiency-patterns)

## Related Resources

- [Basic web application](../../web-apps/architectures/basic-web-app.yml)
- [Baseline zone-redundant web application](../../web-apps/architectures/baseline-zone-redundant.yml)
- [Multi-region active-passive web application](../../web-apps/architectures/multi-region.yml)
- [Web application monitoring on Azure](app-monitoring.yml)
- [Scalable web application](scalable-web-app.yml)
