[Availability zones](/azure/availability-zones/az-overview) are physically separated collections of datacenters within a given region. Replicating your deployments across multiple zones, ensures that local outages limited to a zone do not negatively impact the availability of your application. This architecture shows how you can improve the resiliency of an ASE deployment by deploying in multiple availability zones. These zones are not related to proximity. They can map to different physical locations for different subscriptions. This architecture assumes a single subscription deployment.

![GitHub logo](../../../_images/github.png) A reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/app-service-environments-ILB-deployments).

## Architecture

![Reference architecture for high availability ASE deployment](../_images/ha-ase-deployment.png)

The contents of the ASE subnets used in this reference implementation are the same as the ones in the standard ASE deployment architecture [described here](./ase-standard-deployment.yml). This reference implementation replicates the deployment in two ASE subnets. Each subnet has its own web app, API, and function instances running in their individual App Service plans. The Redis cache required by the applications are also replicated for better performance. Note that the scope of this reference architecture is limited to a single region.

### Workflow

The following section shows the nature of availability for services used in this architecture:

[**App Services Environments**](/azure/app-service/environment/intro) can be deployed to multiple availability zones, only in internal or ILB mode. This reference implementation deploys two ASE subnets, each one in a different availability zone. At the minimum, two availability zones are recommended for end-to-end resiliency of your application. All of the runtime ILB ASE resources will be located in the specified zone: the internal load balancer IP address of the ASE, the compute resources as well as the underlying file storage required by the ASE to run all the apps deployed on that ASE. For detailed guidance and recommendations, read [App Service Environment Support for Availability Zones](https://azure.github.io/AppService/2019/12/12/App-Service-Environment-Support-for-Availability-Zones.html).

[**Azure Virtual Network**](/azure/virtual-network/) or *Vnet* spans all availability zones limited to a single region. The subnets within the VNet also span across availability zones. This reference architecture creates a subnet for each ASE deployment created for an availability zone. For more information, read [the network requirements for App Service Environments](/azure/app-service/environment/network-info#ase-subnet-size).

[**Application Gateway**](/azure/application-gateway/overview) **v2** is *zone-redundant*. Like the virtual network, it spans multiple availability zones per region. This in turn means, a single application gateway is sufficient for a highly available system, as shown in this reference architecture. The v1 SKU does not support this. For more details, read [Autoscaling and Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant).

[**Azure Firewall**](/azure/firewall/overview) has built-in support for high availability. It can span across multiple zones without any additional configuration. This allows the usage of a single firewall for applications deployed in more than one zone, as done in this reference architecture. Although not used in this architecture, if necessary you can also configure a specific availability zone when deploying the firewall. Read [Azure Firewall and Availability Zones](/azure/firewall/overview#availability-zones) for more information.

[**Azure Active Directory**](/azure/active-directory/) is a highly available, highly redundant, global service, spanning availability zones as well as regions. Read [Advancing Azure Active Directory availability](https://azure.microsoft.com/blog/advancing-azure-active-directory-availability/) for more insights.

[**Azure Pipelines**](/azure/devops/pipelines/) supports [parallel processing of CI/CD activities](/azure/devops/pipelines/licensing/concurrent-jobs). Use this in the deployment phase, to simultaneously deploy the built applications to multiple ASE subnets, through multiple *jumpbox* VMs or Bastion subnets. This architecture uses two jumpbox virtual machines to help with the simultaneous deployment. Note the number of parallel jobs is tied to the pricing tier. The basic free tier of a Microsoft-hosted CI/CD allows up to 10 tasks to be parallelized, each running up to 6 hours.

[**Azure Cache for Redis**](/azure/azure-cache-for-redis/) is not a zone-aware service. This architecture creates two subnets to hold the Redis Cache, each pinned down to the availability zone of an ASE subnet. This is recommended since the closer the cache to the application, the better the app performance. Note that this is a *preview* feature, available only for the Premium tier.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

#### App Service Environments

App Service environments with ILB can be deployed to a specific availability zone. Availability zones are geographically separated self-sustained datacenters within the same region. If one datacenter goes down, and if your architecture supports it, applications deployed to other datacenters can ensure availability.

Make use of this feature by:

- deploying at least two such environments to two distinct zones, with applications duplicated in each ASE, and
- load-balancing the traffic upstream to the ASEs, using a [zone-redundant App Gateway](/azure/application-gateway/application-gateway-autoscaling-zone-redundant), as demonstrated in this reference architecture.

Some additional points to consider:

- An ILB ASE deployed to a zone ensures uptime for already deployed apps and resources used by them. However, app service plan scaling, app creation, and app deployment may still be affected by outages in other zones.
- An ARM template must be used for initial deployment of ILB ASE to an availability zone. Thereafter, it can be accessed through the portal or the command line. The *zones* property must be set to 1, 2, or 3 denoting the logical zones.
- Virtual network by default is zone-redundant, hence all zone-deployed ASE subnets can reside in the same virtual network.
- External-facing ASEs cannot be pinned to an availability zone.

For more details, read [App Service Environment Support for Availability Zones](https://azure.github.io/AppService/2019/12/12/App-Service-Environment-Support-for-Availability-Zones.html).

### Resiliency

The applications in both the ASE subnets form the [backend pool](/azure/application-gateway/application-gateway-components#backend-pools) for the Application Gateway. When a request to the application is made from the public internet, the gateway can choose either of the two application instances. Application Gateway by default monitors the health of the backend pool resources, as described in [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview). In the reference setup, a default health probe can only monitor the web frontend. Since this web frontend in turn uses other components, it might look healthy but still fail if the dependencies fail due to a partial failure of the datacenter in that zone. To avoid such failures, use a custom probe to control what application health really means. This reference architecture implements [Health Checks](/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-3.1) within the main web frontend, the *votingApp*. This health probe checks if the web API as well as the Redis cache are healthy. See the snippet that implements this probe in the [Startup.cs](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingWeb/Startup.cs):

```dotnetcli
            var uriBuilder = new UriBuilder(Configuration.GetValue<string>("ConnectionStrings:VotingDataAPIBaseUri"))
            {
                Path = "/health"
            };

            services.AddHealthChecks()
                .AddUrlGroup(uriBuilder.Uri, timeout: TimeSpan.FromSeconds(15))
                .AddRedis(Configuration.GetValue<string>("ConnectionStrings:RedisConnectionString"));
```

The following snippet shows how the [deploy_ha.sh](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/deployment/deploy_ha.sh) script configures the backend pools and the health probe for the App Gateway:

```bash
# Generates parameters file for appgw arm script
cat <<EOF > appgwApps.parameters.json
[
  { 
    "name": "votapp", 
    "hostName": "${APPGW_APP1_URL}", 
    "backendAddresses": [ 
      { 
        "fqdn": "${INTERNAL_APP1_URL1}" 
      },
      { 
        "fqdn": "${INTERNAL_APP1_URL2}" 
      } 
    ], 
    "certificate": { 
      "data": "${CERT_DATA_1}", 
      "password": "${PFX_PASSWORD}" 
    }, 
    "probePath": "/health" 
  },
...
```

If either of the components fail in this health probe, that is the web frontend, the API, or the cache, the Application Gateway will route the request to the other application from the backend pool. This makes sure that the request is always routed to the application in a completely available ASE subnet.

The health probe is also implemented in the standard reference implementation. There the gateway simply returns error if the health probe fails. However, in the highly available implementation, it improves the resiliency of the application and the quality of the user experience.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost considerations for the high availability architecture are mostly similar to the standard deployment.

The following differences can affect the cost:

- Multiple deployments of App Service environments.
- Multiple deployments of Azure Cache for Redis *Premium tier* instances. This reference architecture uses Premium tier, since:
  - Only Premium tier Redis Cache can be used from within the virtual network, and
  - Zonal pinning of Redis Cache, a public preview feature, is available only in the *Premium tier*.

The tradeoff for high availability, resilient, and secure system will be increased cost. Evaluate the enterprise needs with respect to the pricing, using the [pricing calculator](https://azure.microsoft.com/pricing/calculator/).

### Deployment considerations

This reference implementation extends the production level CI/CD pipeline used in the standard deployment, by using one jumpbox virtual machine per availability zone. This serves two purposes:

- Pins the virtual machines to the same availability zones used by the ASE resources, ensuring uptime in the deployment in case of a failure limited to one or two zones.
- It also helps parallelize the deployment, by using the virtual machines as a pool of [Azure Pipelines agents](/azure/devops/pipelines/agents/agents?tabs=browser#install).

The [azure-pipelines.yml](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/code/web-app-ri/VotingWeb/azure-pipelines.yml) file in this reference implementation illustrates this parallel deployment, by creating separate *deploy* stages for each zonal ASE.

## Deploy this scenario

To deploy the reference implementation for this architecture, see the [GitHub readme](https://github.com/mspnp/app-service-environments-ILB-deployments/blob/master/README.md), and follow the script for *high availability deployment*.

## Next steps

You can expand on the learnings demonstrated in this reference architecture, and horizontally scale your applications within the same region or across several regions, based on the expected peak load capacity. Replicating your applications on multiple regions may help mitigate the risks of wider geographical data center failures, such as due to earthquakes or other natural disasters. To learn more on horizontal scaling, read [Geo Distributed Scale with App Service Environments](/azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale). For a global and highly-available routing solution, consider using [Azure Front Door](/azure/frontdoor/front-door-overview).
