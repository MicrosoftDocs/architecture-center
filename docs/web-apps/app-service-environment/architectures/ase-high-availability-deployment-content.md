> [!NOTE]
> [App Service Environment](/azure/app-service/environment/overview) is the main component of this architecture. App Service Environment version 3 is now available. Versions 1 and 2 will be [retired on August 31, 2024](https://azure.microsoft.com/updates/app-service-environment-v1-and-v2-retirement-announcement/).

[Availability zones](/azure/availability-zones/az-overview) are physically separated collections of datacenters in a given region. Deploying resources across zones ensures that outages that are limited to a zone don't affect the availability of your applications. This architecture shows how you can improve the resiliency of an App Service Environment deployment by deploying it in a zone-redudant architecture. These zones aren't related to proximity. They can map to different physical locations for different subscriptions. The architecture assumes a single-subscription deployment.

When you configure App Service Environment to be zone redundant, the platform automatically spreads the instances of the Azure App Service plan across three zones in the selected region. Therefore, the minimum App Service plan instance count is always three. 

Azure services that support availability zones can be zonal, zone-redundant, or both. Zonal services can be deployed to a specific zone. Zone-redundant services can be automatically deployed across zones. For detailed guidance and recommendations, see [Availability zone support](/azure/reliability/availability-zones-service-support). The previous version of App Service Environment (v2) supported only zonal deployments, but the current version (v3) supports zone-redundant deployments.

![GitHub logo](../../../_images/github.png) A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

## Architecture

![Diagram that shows a reference architecture for high-availability deployment of App Service Environment.](../_images/app-service-environment-high-availability.png)

*Download a [Visio file](https://arch-center.azureedge.net/app-service-environment-high-availability.vsdx) of this architecture.*

The resources in the App Service Environment subnets in this reference implementation are the same as the ones in the [standard App Service Environment deployment architecture](./ase-standard-deployment.yml). This reference implementation uses the zone-redundant capabilities of App Service Environment v3 and Azure Cache for Redis to provide higher availability. Note that the scope of this reference architecture is limited to a single region.

### Workflow

This section describes the nature of availability for services used in this architecture:

- [**App Service Environment v3**](/azure/app-service/environment/intro) can be configured for zone redundancy. You can only configure zone redundancy during creation of the App Service Environment and only in regions that support all App Service Environment v3 dependencies. Each App Service plan in a zone-redundant App Service Environment needs to have a minimum of three instances so that they can be spread across zones. The minimum charge is for nine instances. For more information,  see this [pricing guidance](/azure/app-service/environment/overview#pricing). For detailed guidance and recommendations, see [App Service Environment Support for Availability Zones](https://azure.github.io/AppService/2019/12/12/App-Service-Environment-Support-for-Availability-Zones.html).

- [**Azure Virtual Network**](https://azure.microsoft.com/products/virtual-network) contains all availability zones that are in a single region. The subnets in the virtual network also cross availability zones. For more information, see [the network requirements for App Service Environment](/azure/app-service/environment/networking#subnet-requirements).

- [**Application Gateway v2**](https://azure.microsoft.com/products/application-gateway) is zone-redundant. Like the virtual network, it spans multiple availability zones per region. Therefore, a single application gateway is sufficient for a highly available system, as shown in the reference architecture. The reference architecture uses the WAF SKU of Application Gateway, which provides increased protection against common threats and vulnerabilities, based on an implementation of the Core Rule Set (CRS) of the Open Web Application Security Project (OWASP). For more details, see [Scaling Application Gateway v2 and WAF v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

- [**Azure Firewall**](https://azure.microsoft.com/products/azure-firewall/) has built-in support for high availability. It can cross multiple zones without any additional configuration. 
 
  If you need to, you can also configure a specific availability zone when you deploy the firewall. See [Azure Firewall and Availability Zones](/azure/firewall/overview#availability-zones) for more information. (This configuration isn't used in the reference architecture.)

- [**Azure Active Directory**](https://azure.microsoft.com/products/active-directory/) is a highly available, highly redundant global service, spanning availability zones and regions. For more information, see [Advancing Azure Active Directory availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability/).

- [**Github Actions**](https://azure.microsoft.com/products/devops/pipelines) provides continuous integration and continuous deployment capabilities in this architecture. Because App Service Environment is in the virtual network, a virtual machine is used as a jumpbox in the virtual network to deploy apps in the App Service plans. The deployment builds the apps outside the virtual network. For enhanced security and seamless RDP/SSH connectivity, consider using [Azure Bastion](/azure/bastion/bastion-overview) for the jumpbox.

- [**Azure Cache for Redis**](https://azure.microsoft.com/products/cache/) is a zone-redundant service. A zone-redundant cache runs on VMs spread across multiple availability zones. This service provides higher resilience and availability.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

#### App Service Environment

You can deploy App Service Environment across availability zones to provide resiliency and reliability for your business-critical workloads. This configuration is also known as *zone redundancy*.

When you implement zone redundancy, the platform automatically spreads the instances of the App Service plan across three zones in the selected region. Therefore, the minimum App Service plan instance count is always three. If you specify a capacity larger than three, and the number of instances is divisible by three, the instances are spread evenly. Otherwise, any remaining instances are added to the remaining zone or spread across the remaining two zones. 

- You configure availability zones when you create your App Service Environment.
- All App Service plans created in that App Service Environment require a minimum of three instances. They will automatically be zone redundant.
- You can specify availability zones only when you create a new App Service Environment. You can't convert a pre-existing App Service Environment to use availability zones.
- Availability zones are supported only in a [subset of regions](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).

For more information, see [Migrate App Service Environment to availability zone support](/azure/reliability/migrate-app-service-environment).

### Resiliency

The applications that run in App Service Environment form the [backend pool](/azure/application-gateway/application-gateway-components#backend-pools) for Application Gateway. When a request to the application comes from the public internet, the gateway forwards the request to the application running in App Service Environment. This reference architecture implements [health checks](/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-3.1) within the main web frontend, `votingApp`. This health probe checks whether the web API and the Redis cache are healthy. You can see the code that implements this probe in [Startup.cs](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingWeb/Startup.cs):

```dotnetcli
            var uriBuilder = new UriBuilder(Configuration.GetValue<string>("ConnectionStrings:VotingDataAPIBaseUri"))
            {
                Path = "/health"
            };

            services.AddHealthChecks()
                .AddUrlGroup(uriBuilder.Uri, timeout: TimeSpan.FromSeconds(15))
                .AddRedis(Configuration.GetValue<string>("ConnectionStrings:RedisConnectionString"));
```

The following code shows how the [commands_ha.azcli](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/commands_ha.azcli) script configures the backend pools and the health probe for the application gateway:

```bash
# Generates parameters file for appgw script
cat <<EOF > appgwApps.parameters.json
[
{
    "name": "votapp",
    "routingPriority": 100,
    "hostName": "${APPGW_APP1_URL}",
    "backendAddresses": [
      {
        "fqdn": "${INTERNAL_APP1_URL}"
      }
    ],
    "certificate": {
      "data": "${CERT_DATA_1}",
      "password": "${PFX_PASSWORD}"
    },
    "probePath": "/health"
  }
]
```

If any of the components (the web frontend, the API, or the cache) fails in the health probe, Application Gateway routes the request to the other application from the backend pool. This makes sure that the request is always routed to the application in a completely available ASE subnet.

The health probe is also implemented in the standard reference implementation. There the gateway simply returns error if the health probe fails. However, in the highly available implementation, it improves the resiliency of the application and the quality of the user experience.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost considerations for the high availability architecture are mostly similar to the standard deployment.

The following differences can affect the cost:

- There's a minimum charge of nine App Service plan instances in a zone redundant App Service Environment. See [App Service Environment pricing](/azure/app-service/environment/overview#pricing) for more information.
- Azure Cache for Redis is also a zone redundant service. A zone-redundant cache runs on VMs spread across multiple Availability Zones to provide higher resilience and availability.

The tradeoff for high availability, resilient, and secure system will be increased cost. Evaluate the enterprise needs with respect to the pricing, using the [pricing calculator](https://azure.microsoft.com/pricing/calculator/).

### Deployment considerations

This reference implementation uses the same production level CI/CD pipeline used in the standard deployment, with just one jumpbox virtual machine. You may, however, decide to have one jumpbox across each of the three zones. This reference architecture simplifies by using just one jumpbox since it doesnt affect the actual availability of the app as the jumpbox is used only for deployment and testing purposes.

## Deploy this scenario

To deploy the reference implementation for this architecture, see the [GitHub readme](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/README.md), and follow the script for *high availability deployment*.

## Next steps

You can expand on the learnings demonstrated in this reference architecture, and horizontally scale your applications within the same region or across several regions, based on the expected peak load capacity. Replicating your applications on multiple regions may help mitigate the risks of wider geographical data center failures, such as due to earthquakes or other natural disasters. To learn more on horizontal scaling, read [Geo Distributed Scale with App Service Environments](/azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale). For a global and highly-available routing solution, consider using [Azure Front Door](/azure/frontdoor/front-door-overview).
