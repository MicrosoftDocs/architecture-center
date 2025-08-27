> [!NOTE]
> [App Service Environment](/azure/app-service/environment/overview) version 3 is the main component of this architecture. Versions 1 and 2 [retired on August 31, 2024](https://azure.microsoft.com/updates/app-service-environment-v1-and-v2-retirement-announcement/).

[Availability zones](/azure/reliability/availability-zones-overview) are physically separated collections of datacenters in a given region. You can deploy resources across zones to ensure that outages limited to a zone don't affect the availability of your applications. This architecture describes how to improve the resiliency of an App Service Environment deployment by deploying it in a zone-redudant architecture. These zones aren't related to proximity. They can map to different physical locations for different subscriptions. The architecture assumes a single-subscription deployment.

Azure services that support availability zones can be zonal, zone-redundant, or both. You can deploy zonal services to a specific zone. You can automatically deploy zone-redundant services across zones. For more information, see [Availability zone support](/azure/reliability/availability-zones-service-support). App Service Environment supports [zone-redundant deployments](/azure/reliability/reliability-app-service-environment).

When you configure App Service Environment for zone redundancy, the platform automatically deploys instances of the Azure App Service plan in the maximum number of available zones in the selected region. At least two zones must be available in the region to enable zone redundancy. Therefore, the minimum App Service plan instance count is always two. The platform determines the number of zones available for an App Service Environment.

![GitHub logo](../../../_images/github.png) A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

## Architecture

:::image type="complex" source="../_images/app-service-environment-high-availability.svg" lightbox="../_images/app-service-environment-high-availability.svg" alt-text="Diagram that shows a reference architecture for high-availability deployment of App Service Environment." border="false":::
The diagram presents a structured layout of a Microsoft Azure network architecture enclosed within a dotted blue boundary labeled virtual network. An icon that represents the internet resides outside the virtual network. It connects to Application Gateway, which resides in its own subnet. This gateway points to the central subnet that contains a zone-redundant App Service Environment internal load balancer. Within this subnet, three stacked components are labeled web app, private API, and function. The web app environment points to three subnets. One subnet contains Azure Cache for Redis. Another contains a firewall with an arrow labeled outbound traffic pointing outward. The third subnet features several private endpoints connected to icons that represent Azure Service Bus, Azure Cosmos DB, SQL Server, and Azure Key Vault, which reside outside the virtual network. Private Domain Name System (DNS) zones outside the subnet connect to the private endpoints. A jumpbox virtual machine (VM) resides in its own subnet, connected via dashed lines to both the central subnet and an icon labeled GitHub Actions, which is positioned at the bottom of the diagram outside the virtual network. On the far right, an icon labeled Microsoft Entra ID stands alone.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/app-service-environment-high-availability.vsdx) of this architecture.*

![GitHub logo](../../../_images/github.png) A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

The resources in the App Service Environment subnets in this reference implementation match the resources in the [standard App Service Environment deployment architecture](./ase-standard-deployment.yml). This reference implementation uses the zone-redundant capabilities of App Service Environment v3 and Azure Cache for Redis to provide higher availability. The scope of this reference architecture is limited to a single region.

### Workflow

This section describes the nature of availability for services in this architecture. The following workflow corresponds to the previous diagram:

- [App Service Environment v3](/azure/app-service/environment/overview) supports [zone redundancy](/azure/reliability/reliability-app-service-environment). You can configure zone redundancy at any time during the life cycle of an App Service Environment in the [regions that support zone redundancy](/azure/app-service/environment/overview#regions). Each App Service plan in a zone-redundant App Service Environment must include at least two instances to ensure deployment across two or more zones. You can combine zone-redundant and non-zone-redundant plans within the same App Service Environment. To configure a plan with only one instance, disable zone redundancy for that plan first. Zone redundancy doesn't incur extra charges. You pay only for the Isolated v2 instances in use. For more information, see [App Service Environment pricing](/azure/app-service/environment/overview#pricing) and [Reliability in App Service Environment](/azure/reliability/reliability-app-service-environment).

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) spans all availability zones within a single region. The subnets in the virtual network also extend across availability zones. For more information, see [Network requirements for App Service Environment](/azure/app-service/environment/networking#subnet-requirements) and [Reliability in Virtual Network](/azure/reliability/reliability-virtual-network).

- [Azure Application Gateway v2](https://azure.microsoft.com/products/application-gateway) is zone-redundant. Like the virtual network, it spans multiple availability zones in each region. Therefore, a single application gateway provides high availability, as shown in the reference architecture. The reference architecture uses the Web Application Firewall SKU of Application Gateway, which provides increased protection against common threats and vulnerabilities. This protection is based on an implementation of the Core Rule Set (CRS) of the Open Web Application Security Project (OWASP). For more information, see [Reliability in Application Gateway v2](/azure/reliability/reliability-application-gateway-v2).

- [Azure Firewall](https://azure.microsoft.com/products/azure-firewall/) includes built-in support for high availability. It can use multiple zones without extra configuration.

  You can also configure a specific availability zone when you deploy the firewall. For more information, see [Azure Firewall and availability zones](/azure/firewall/overview#availability-zones). The reference architecture doesn't use this configuration.

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory/) is a highly available, highly redundant global service that spans availability zones and regions. For more information, see [Advance Microsoft Entra ID availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability/).

- [GitHub Actions](https://azure.microsoft.com/products/devops/pipelines) provides continuous integration and continuous deployment (CI/CD) capabilities in this architecture. App Service Environment resides in the virtual network, so a virtual machine (VM) serves a jumpbox in the virtual network to deploy apps in the App Service plans. The action builds the apps outside the virtual network. For enhanced security and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) connectivity, consider using [Azure Bastion](/azure/bastion/bastion-overview) for the jumpbox.

- [Azure Cache for Redis](https://azure.microsoft.com/products/cache/) is a zone-redundant service. A zone-redundant cache runs on VMs deployed across multiple availability zones. This service provides higher resilience and availability.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Jump boxes

This reference implementation uses the same production-level CI/CD pipeline as the standard deployment, with only one jump box VM. But you can use one jump box for each of the three zones. This architecture uses only one jump box because the jump box doesn't affect the availability of the app. It supports deployment and testing.

#### App Service Environment

You can deploy App Service Environment across availability zones to provide resiliency and reliability for business-critical workloads. This configuration is also known as *zone redundancy*.

When you implement zone redundancy, the platform automatically deploys the instances of the App Service plan across two or more zones in the selected region. Therefore, the minimum App Service plan instance count is always two.

- You [configure availability zones](/azure/app-service/environment/configure-zone-redundancy-environment) when you create your App Service Environment or at any point in the life cycle of the environment.

- All App Service plans that you create in that App Service Environment require a minimum of two instances to enable zone redundancy. If the App Service Environment is zone redundant, you can selectively enable and disable zone redundancy for the individual App Service plans. To scale-in an App Service plan to a single instance, disable zone redundancy for that plan, then proceed with the scale-in operation.
- Only a [subset of regions](/azure/reliability/availability-zones-region-support) support availability zones.

For more information, see [Reliability in App Service](/azure/reliability/reliability-app-service-environment).

#### Resiliency

The applications that run in App Service Environment form the [back-end pool](/azure/application-gateway/application-gateway-components#backend-pools) for Application Gateway. When a request to the application comes from the public internet, the gateway forwards the request to the application that runs in App Service Environment. This reference architecture implements [health checks](/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-3.1) within the main web front end, `votingApp`. This health probe checks the health status of the web API and the Redis cache. The code in [Startup.cs](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingWeb/Startup.cs) implements this probe.

```csharp
var uriBuilder = new UriBuilder(Configuration.GetValue<string>("ConnectionEndpoints:VotingDataAPIBaseUri"))
{
    Path = "/health"
};

services.AddHealthChecks()
    .AddUrlGroup(uriBuilder.Uri, timeout: TimeSpan.FromSeconds(15))
    .AddRedis(Configuration.GetValue<string>("ConnectionEndpoints:RedisConnectionEndpoint"));
```

The following code shows how the [commands_ha.azcli](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/commands_ha.azcli) script configures the back-end pools and the health probe for the application gateway.

```bash
# Generates parameters file for Azure Application Gateway script
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
    "probePath": "/health"
  }
]
```

If any components, including the web front end, the API, or the cache, fail the health probe, Application Gateway routes the request to the other application in the back-end pool. This configuration ensures that the request always routes to the application in a completely available App Service Environment subnet.

The standard reference implementation also uses the health probe. In that implementation, the gateway returns an error if the health probe fails. But the highly available implementation improves the resiliency of the application and the quality of the user experience.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost considerations for the high availability architecture are similar to the standard deployment.

The following differences can affect the cost:

- Availability zone support doesn't incur extra charges. You pay only for the instances that you use. For more information, see [App Service Environment pricing](/azure/app-service/environment/overview#pricing).

- Azure Cache for Redis is a zone-redundant service. A zone-redundant cache runs on VMs deployed across multiple availability zones to provide higher resilience and availability. This configuration introduces extra charges associated with zone redundancy to support the data transfer between zones.

The trade-off for a highly available, resilient, and highly secure system includes increased cost for some Azure services. To evaluate your requirements and estimate costs, use the [pricing calculator](https://azure.microsoft.com/pricing/calculator/).

## Deploy this scenario

To deploy the reference implementation for this architecture, see the [GitHub readme](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/README.md). Use the script for high-availability deployment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Deep Bhattacharya](https://www.linkedin.com/in/deeplydiligent/) | Cloud Solution Architect
- [Suhas Rao](https://www.linkedin.com/in/suhasaraos/) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To modify this architecture, you can horizontally scale your applications within the same region or across several regions, based on the expected peak load capacity. Replicating your applications across multiple regions can help mitigate the risks of wider geographical datacenter failures, such as failures caused by earthquakes or other natural disasters.

- For more information about horizontal scaling, see [Geo-distributed scale with App Service Environments](/azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale).
- For a global and highly available routing solution, consider using [Azure Front Door](/azure/frontdoor/front-door-overview).
