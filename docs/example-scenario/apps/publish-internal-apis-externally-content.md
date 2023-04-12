In this scenario, an organization consolidates multiple APIs internally using Azure API Management deployed inside a Virtual Network.

## Architecture

![Diagram showing lifecycle of internal APIs that are consumed by external users.][architecture]

*Download a [Visio file](https://archcenter.blob.core.windows.net/cdn/architecture-publish-internal-apis-externally.vsdx) of this architecture.*

The preceding diagram covers a complete lifecycle of internal APIs that are consumed by the external users.

### Dataflow

The data flows as follows:

1. Developers check in code to a GitHub repository that's connected to a CI/CD pipeline agent that's installed on an Azure VM.
2. The agent pushes the build to the API application that's hosted on ILB ASE.
3. Azure API Management consumes the preceding APIs via HOST headers that are specified in API Management policy.
4. API Management uses the App Service Environment's DNS name for all the APIs.
5. Application Gateway exposes API Management's developer and API portal.
6. Azure Private DNS is used to route the traffic internally between ASE, API Management, and Application Gateway.
7. External users utilize the exposed developer portal to consume the APIs via Application Gateway's public IP.

### Components

- [Azure Virtual Network][vnet] enables Azure resources to securely communicate with each other, the internet, and on-premises networks.
- [Azure Private DNS][dns] allows domain names to be resolved in a virtual network without needing to add a custom DNS solution.
- [Azure API Management][apim] helps organizations publish APIs to external, partner, and internal developers to use their data and services.
- [Application Gateway][appgtwy] is a web traffic load balancer that helps you to manage traffic to your web applications.
- Internal Load Balancer [App Service Environment][ase] is an Azure App Service feature that provides a fully isolated and dedicated environment for securely running App Service apps at high scale.
- [Azure DevOps][devops] is a service for managing your development lifecycle and includes features for planning and project management, code management, build, and release.
- [Application Insights][appinsights] is an extensible Application Performance Management (APM) service for web developers on multiple platforms.
- [Azure Cosmos DB][cosmos-db] is Microsoft's globally distributed, multi-model database service.

### Alternatives

- In an [Azure lift and shift scenario][azure-vm-lift-shift] deployed into an Azure Virtual Network, back-end servers could be directly addressed through private IP addresses.
- If using on-premises resources, the API Management instance could reach back to the internal service privately via an [Azure VPN gateway and site-to-site IPSec VPN connection][azure-vpn] or [ExpressRoute][azure-er] making a [hybrid Azure and on-premises scenario][azure-hybrid].
- Existing or open-source DNS providers could be used instead of the Azure-based DNS Service.
- Internal APIs deployed outside of Azure can still benefit by exposing the APIs through API Management Service.

## Scenario details

In this scenario, an organization hosts multiple APIs using [Azure Application Service Environment][ase] (ILB ASE), and they want to consolidate these APIs internally by using [Azure API Management (APIM)][apim] deployed inside a Virtual Network. The internal API Management instance could also be exposed to external users to allow for utilization of the full potential of the APIs. This external exposure could be achieved using [Azure Application Gateway][appgtwy] forwarding requests to the internal API Management service, which in turn consumes the APIs deployed in the ASE.

- The web APIs are hosted over secured HTTPS protocol and will be using a [TLS Certificate][ssl].
- The Application Gateway also is configured over port 443 for secured and reliable outbound calls.
- The API Management service is configured to use custom domains using TLS certificates.
- Review the suggested [network configuration][ntwkcons] for App Service Environments
- There needs to be an explicit mention about [port 3443 allowing API Management][apim-port-nsg] to manage via the Azure portal or PowerShell.
- Leverage policies within APIM to add a HOST header for the API hosted on ASE. This ensures that the ASE's load balancer will properly forward the request.
- The API Management accepts ASE's DNS entry for all the apps hosted under App Service Environments. Add an [APIM policy][apim-policy] to explicitly set the HOST header to allow the ASE load balancer to differentiate between Apps under the App Service Environment.
- Consider [Integrating with Azure Application Insights][azure-apim-ai], which also surfaces metrics through [Azure Monitor][azure-mon] for monitoring.
- If you use CI/CD pipelines for deploying Internal APIs, consider [building your own Hosted Agent on a VM][hosted-agent] inside the Virtual Network.

## Potential use cases

- Synchronize customer address information internally after the customer makes a change.
- Attract developers to your platform by exposing unique data assets.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview)."

#### Availability

You can deploy Azure API Management service as a [Multi-Region deployment][apim-multiregion] for higher availability and also to reduce latencies. This feature is only available in Premium mode. The API Management service in this specific scenario consumes APIs from App Service Environments. You can also use APIM for APIs hosted on the internal on-premises infrastructure.

App Service Environments could make use of [Traffic Manager][ase-trafficmanager] profiles to distribute the traffic hosted on App Service Environments for higher scale and availability.

#### Resiliency

Though this example scenario talks more about configuration, the APIs hosted on the App Service Environments should be resilient enough to handle errors in the requests, which are eventually managed by the API Management service and Application Gateway. Consider [Retry and Circuit breaker patterns][api-pattern] in the API design. For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Because the preceding example scenario is hosted completely on an internal network, API Management and ASE are already deployed on [secured infrastructure (Azure VNet)][vnet-security]. You can [integrate Application Gateways with Microsoft Defender for Cloud][appgtwy-asc] to provide a seamless way to prevent, detect, and respond to threats to the environment. For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

API Management is offered in four tiers: developer, basic, standard, and premium. You can find detailed guidance on the difference in these tiers at the [Azure API Management pricing guidance here.][apim-pricing]

Customers can scale API Management by adding and removing units. Each unit has capacity that depends on its tier.

> [!NOTE]
> You can use the Developer tier for evaluation of the API Management features. You shouldn't use the Developer tier for production.

To view projected costs and customize to your deployment needs, you can modify the number of scale units and App Service instances in the [Azure Pricing Calculator][pricing-calculator].

Similarly, you can find the [App Service Environments pricing guidance][ase-pricing].

You can configure [Application Gateway pricing][appgtwy-pricing] depending upon the required tier and resources.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

#### Scalability

You can [scale out][apim-scale] API Management instances depending upon a number of factors, like number and rate of concurrent connections, the kind and number of configured policies, request and response sizes, and back-end latencies on the APIs. Scaling out instance options are available in Basic, Standard, and Premium Tiers, but are bound by an upper scale limit in Basic and Standard tiers. The instances are referred to as Units and can be scaled up to a max of two units in Basic tier, four units in Standard tier and any number of units in the Premium tier. [Auto Scaling][apim-autoscale] options are also available to enable scale out based on rules.

App Service Environments are designed for scale with limits based on the pricing tier. You can configure the apps hosted under the App Service Environments to [scale out (number of instances) or scale up (instance size)][ase-scale] depending upon the requirements of the application.

Azure Application Gateway auto scaling is available as a part of the Zone redundant SKU in all global Azure regions. See the [public preview feature][appgtwy-scale] regarding App gateway Auto scaling.

## Deploy this scenario

### Prerequisites and assumptions

1. You need to purchase a custom domain name.
1. You need a TLS certificate (we used a wildcard certificate from Azure Certificates Service) to use one for all our custom domains. You can also procure a self-signed certificate for Dev Test scenarios.
1. This specific deployment uses the domain name contoso.org and a wildcard TLS certificate for the domain.
1. The deployment uses the resource names and address spaces mentioned in the Deployment section. You can configure the resource names and address spaces.

### Deployment and putting the pieces together

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fssarwa%2FAPI-Management-ASE-AppGateway%2Fmaster%2Fazuredeploy.json)

You need to further configure the components deployed using the preceding Resource Manager template as follows:

1. VNet with the following configurations:
   - Name: `ase-internal-vnet`
   - Address space for VNet: 10.0.0.0/16
   - Four Subnets
     - `backendSubnet` for DNS Service: 10.0.0.0/24
     - `apimsubnet` for Internal API Management Service: 10.0.1.0/28
     - `asesubnet` for ILB ASE: 10.0.2.0/24
     - VMSubnet for Test VMs and Internal DevOps Hosted Agent VM: 10.0.3.0/24
2. Private DNS service (Public Preview) since adding a DNS service requires the VNet to be empty.
   - Refer to the [deployment guidelines][dnsguide] for more information
3. App Service Environment with Internal Load Balancer (ILB) option: `aseinternal` (DNS: `aseinternal.contoso.org`). Once the Deployment is complete, upload the wild-card cert for the ILB
4. App Service Plan with ASE as location
5. An API App (App Services for simplicity) - `srasprest` (URL: `https://srasprest.contoso.org`) – ASP.NET MVC-based web API. After the deployment, configure:
   - Web app to use the TLS certificate
   - Application Insights to the preceding apps: api-insights
   - Create an Azure Cosmos DB service for web APIs hosted internal to VNet: `noderestapidb`
   - Create DNS entries on the Private DNS zone created
   - You can make use of Azure Pipelines to configure the agents on Virtual Machines to deploy the code for Web App on internal Network
   - For testing the API App internally, create a test VM within the VNet subnet
6. Create API Management service: `apim-internal`
7. Configure the service to connect to internal VNet on Subnet: `apimsubnet`. After the deployment is complete, perform the following additional steps:
   - Configure custom domains for APIM Services using TLS
     - API portal (api.contoso.org)
     - Dev Portal (portal.contoso.org)
     - In the APIs section, configure the ASE Apps using ASE's DNS name added Policy for HOST Header for the Web app
     - Use the preceding created test VM to test the API Management service internal on the Virtual Network

    > [!NOTE]
    > Testing the APIM APIs from the Azure portal won't work, because api.contoso.org isn't able to be publicly resolved.*

8. Configure the Application Gateway (WAF V1) to access the API service: apim-gateway on Port 80. Add TLS certs to the Application Gateway and corresponding health probes and http settings. Also configure the Rules and Listeners to use the TLS cert.

Once the preceding steps are successfully completed, configure the DNS entries in the web registrar CNAME entries of api.contoso.org and portal.contoso.org with the Application Gateway's public DNS name: `ase-appgtwy.westus.cloudapp.azure.com`. Verify that you're able to reach the Dev Portal from Public and that you're able to test the APIM services APIs using the Azure portal.

> [!NOTE]
> It's not a good practice to use the same URL for internal and external endpoints for the APIM services (though in this demo, both URLs are the same). If you choose to have different URLs for internal and external endpoints, you can make use of Application Gateway WAF v2, which supports http redirection and much more.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Srikant Sarwa](https://www.linkedin.com/in/srikant-sarwa-1889808/) | Senior Customer Engineer

Other contributors:

- [Shawn Kupfer](https://www.linkedin.com/in/shawn-kupfer-12422b4/) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Tutorial: Import and publish your first API](/azure/api-management/import-and-publish)
- [Tutorial: Create and publish a product](/azure/api-management/api-management-howto-add-products?tabs=azure-portal)
- [Tutorial: Publish multiple versions of your API](/azure/api-management/api-management-get-started-publish-versions)

## Related resources

[Migrate a web app using Azure API Management][related-scenario]

<!-- links -->

[architecture]: ./media/architecture-publish-internal-apis-externally-new.png
[dns]: /azure/dns/private-dns-overview
[ase]: /azure/app-service/environment/intro
[apim]: /azure/api-management/api-management-key-concepts
[appgtwy]: /azure/application-gateway/overview
[ssl]: /azure/app-service/web-sites-purchase-ssl-web-site
[ntwkcons]: /azure/app-service/environment/network-info
[apim-port-nsg]: /azure/api-management/api-management-using-with-vnet#-common-network-configuration-issues
[apim-policy]: /azure/api-management/api-management-transformation-policies#SetHTTPheader
[hosted-agent]: /azure/devops/pipelines/agents/v2-windows
[vnet]: /azure/virtual-network/virtual-networks-overview
[devops]: /azure/devops/index
[appinsights]: /azure/azure-monitor/app/app-insights-overview
[cosmos-db]: /azure/cosmos-db/introduction
[dnsguide]: /azure/dns/private-dns-getstarted-cli
[related-scenario]: ../../example-scenario/apps/apim-api-scenario.yml
[apim-pricing]: https://azure.microsoft.com/pricing/details/api-management
[pricing-calculator]: https://azure.com/e/0e916a861fac464db61342d378cc0bd6
[azure-er]: /azure/expressroute/expressroute-introduction
[azure-mon]: /azure/monitoring-and-diagnostics/monitoring-overview
[ase-pricing]: https://azure.microsoft.com/pricing/details/app-service/windows
[appgtwy-pricing]: https://azure.microsoft.com/pricing/details/application-gateway
[security]: /azure/security
[resiliency]: /azure/architecture/framework/resiliency/principles
[azure-vpn]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[azure-hybrid]: ../../reference-architectures/hybrid-networking/index.yml
[azure-vm-lift-shift]: https://azure.microsoft.com/resources/azure-virtual-datacenter-lift-and-shift-guide
[azure-apim-ai]: /azure/api-management/api-management-howto-app-insights
[apim-multiregion]: /azure/api-management/api-management-howto-deploy-multi-region
[ase-trafficmanager]: /azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale
[apim-scale]: /azure/api-management/upgrade-and-scale
[apim-autoscale]: /azure/api-management/api-management-howto-autoscale
[ase-scale]: /azure/app-service/environment/app-service-web-scale-a-web-app-in-an-app-service-environment
[vnet-security]: /azure/security/azure-network-security
[appgtwy-asc]: /azure/application-gateway/application-gateway-integration-security-center
[appgtwy-scale]: /azure/application-gateway/application-gateway-autoscaling-zone-redundant
[api-pattern]: https://azure.microsoft.com/blog/using-the-retry-pattern-to-make-your-cloud-application-more-resilient
