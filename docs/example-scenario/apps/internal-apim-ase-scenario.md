---
title: Publishing internal APIs to external consumers
titleSuffix: Azure Example Scenarios
description: Use Azure API Management, to modernize and expose intranet legacy web APIs.
author: ssarwa
ms.date: 03/12/2019
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fasttrack-new
social_image_url: ./media/architecture-internal-apim-ase-scenario.jpg
---

# Publishing internal APIs to external consumers

In this scenario an organization has hosted multiple APIs using an [App Service Environments][ase] and would like to consolidate these APIs internally using [Azure API Management (APIM)][apim] deployed into a Virtual Network. The internal API Management instance could also be exposed to external users to allow for utilization of the full potential of the APIs. This external exposure could be achieved using an [Application Gateways][appgtwy] forwarding requests to the internal API Management service which in turn consumes the apis deployed in the ASE.

This example demonstrates how to configure an API Management Service deployed into a vnet which consumes APIs hosted in an App Service Environments on a secured private VNET and assumes
- The development team will modernize the APIs back end, which is hosted on WebApps in App Service Environments internally
- The API Management service is maintained by Administrator/s within the Organizations

## Architecture

![Architecture diagram][architecture]

The above scenario covers a complete lifecycle of Internal APIs getting consumed by the External Users. Here's how the data flows: 
1. Developers checks in there code in Github repository connected to CI/ CD pipeline Agent installed on Azure VM in its subnet
2. Agent pushes the builds to API Apps hosted on ILB ASE
3. API Management consumes the above APIs via HOST Headers specified in API Management policy
4. API Management uses App Service Environment's DNS name for all the APIs
5. Application Gateway exposes API Management's developer and API portal
6. Azure Private DNS is used to route the traffic internally between ASE, API Management and Application Gateway
7. External Users uses exposed Dev Portal to consume the APIs via Application Gateway's Public IP

### Components

- [Azure Virtual Network][vnet] enables Azure resources to securely communicate with each other, the internet, and on-premises networks.
- [Azure Private DNS][dns] Azure DNS provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without your needing to add a custom DNS solution.
- [Azure API Management][apim] helps organizations publish APIs to external, partner, and internal developers to unlock the potential of their data and services.
- [Application Gateway][appgtwy] Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to your web applications.
- Internal Load Balancer [App Service Environment][ase] is an Azure App Service feature that provides a fully isolated and dedicated environment for securely running App Service apps at high scale.
- [Azure DevOps][devops] is a service for managing your development life cycle end-to-end &mdash; from planning and project management, to code management, and continuing to build and release.
- [Application Insights][appinsights] is a first-party, extensible Application Performance Management (APM) service for web developers on multiple platforms.
- [Azure Cosmos DB][cosmosdb] is Microsoft's globally distributed, multi-model database service.


### Alternatives

- In an [Azure lift and shift scenario][azure-vm-lift-shift] deployed into an Azure Virtual Network, the customer could directly address their back-end servers through private IP addresses.
- In the on-premises scenario, the API Management instance could reach back to the internal service privately via an [Azure VPN gateway and site-to-site IPSec VPN connection][azure-vpn] or [ExpressRoute][azure-er] making this a [hybrid Azure and on-premises scenario][azure-hybrid].
- Customer could make use of their own DNS settings instead of using Azure based DNS Service.
- Customer could deploy the Internal APIs outside Azure's environment and could still benefit by feeding the APIs to API Management Service. 

## Considerations

- The web apis are hosted over secured HTTPs protocol and will be using an [SSL Certificate][ssl].
- The Application Gateway also is configured over port 443 for secured and reliable outbound calls.
- The API Management service is configured to use custom domains using SSL certificates.
- Consider the [Network configuration][ntwkcons] for App Service Environments
- There needs to be a explicit mention about [port 3443 allowing API Management][apim-port-nsg] to manage via Portal or PowerShell.
- Leverage policies within APIM to add a HOST header for the API hosted on ASE to ensure that the ASE's load balancer would properly forward the request.
- The API Management accepts ASE's DNS entry for all the apps hosted under App Service Environments. Add an [APIM policy][apim-policy] to explicitly set the HOST Header to allow the ASE load balancer to differentiate between Apps under the App Service Environment.
- Consider [Integrating with Azure Application Insights][azure-apim-ai], which also surfaces metrics through [Azure Monitor][azure-mon] for monitoring.
- If using CI/CD pipelines for deploying Internal APIs, consider [build your own Hosted Agent on a VM][hosted-agent] in the VNET

### Availability

Azure API Management service could be deployed as a [Multi-Region deployment][apim-multiregion] for higher availability and also to reduce latencies. This feature is only available in Premium Mode though. Please note that, the API Management service in this specific scenario consumes APIs from App Service Environments. One could also use APIM for APIs hosted on the internal on-premises infrastructure.

App Service Environments could make use of [Traffic Manager][ase-trafficmanager] profiles to distribute the traffic hosted on App Service Environments for higher scale and availability.

### Scalability

API Management instances could be [scaled out][apim-scale] depending upon a number of factors like number and rate of concurrent connections, the kind and number of configured policies, request and response sizes, and back-end latencies on the APIs. Scaling out instance options are available in Basic, Standard and Premium Tiers but are bound by an upper scale limit in tiers below premium. The instances are generally referred to as Units and can be scaled up to a max of 2 units in Basic tier, 4 units in Standard tier and any number of units in the Premium tier. [Auto Scaling][apim-autoscale] options are also available to enable scale out based on rules.

App Service Environments are designed for scale with limits based on the pricing tier and the apps hosted under the App Service Environments can be [configured to scale out (number of instances) or scale up (instance size)][ase-scale] depending upon the requirements of the application. 

Azure Application Gateway auto scaling is available as a part of the Zone redundant SKU in all public Azure regions. See the [public preview feature][appgtwy-scale] regarding App gateway Auto scaling.

### Security

Since the above example scenario is hosted completely on an internal network, API Management and ASE are already deployed on [secured infrastructure (Azure VNET)][vnet-security]. Application Gateways can be [integrated with Azure Security Center][appgtwy-asc] to provide a seamless way to prevent, detect, and respond to threats to the environment.
- For general guidance on designing secure solutions, see the [Azure Security Documentation][security]

### Resiliency

This example scenario though talks more about configuration, the APIs hosted on the App Service Environments should be resilient enough to handle errors in the requests which eventually is managed by the API Management service and Application Gateway. Consider [Retry and Circuit breaker patterns][api-pattern] in the API design. 
- For general guidance on designing resilient solutions, see [Designing resilient applications for Azure][resiliency].

## Deployment scenario

### Prereqs and assumptions
1. Custom Domain Name purchased.
2. An SSL certificates (we used a wild card one from Azure Certificates Service) to use one for all our custom domains. You could also procure an self signed certificate for Dev Test scenarios.
3. This specific deployment uses the domain name contoso.org and a wild card SSL certificate for the domain.
4. The deployment is using the resource names and address spaces mentioned in the deployment section which can be configured. 

### Deployment and putting the pieces together  

[![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://deploy.azure.com/?repository=https://github.com/ssarwa/API-Management-ASE-AppGateway)

The components deployed using the above ARM template needs to be further configured as below

1. VNET with the following configurations: 
   * Name: ase-internal-vnet
   * Address space for VNET: 10.0.0.0/16
   * 4 Subnets
     * backendSubnet for DNS Service: 10.0.0.0/24
     * apimsubnet for Internal API Management Service: 10.0.1.0/28
     * asesubnet for ILB ASE: 10.0.2.0/24
     * VMSubnet for Test VMs and Internal DevOps Hosted Agent VM: 10.0.3.0/24
2. Private DNS service (Public Preview) since adding a DNS service requires the VNET to be empty.
   * Refer this for [deployment guidelines][dnsguide] 
3. App Service Environment with Internal Load Balancer (ILB) option: aseinternal (DNS: aseinternal.contoso.org). Once the Dpeloyment is complete, upload the wild card cert for the ILB
4. App Service Plan with ASE as location
5. An API Apps (App Services for simplicity) - srasprest (URL: https://srasprest.contoso.org) – ASP.NET MVC based web API. After the deployment, configure
   * web app to use the SSL certificate
   * Application Insights to the above apps: api-insights
   * Create a Cosmos DB service for web APIs hosted internal to VNET: noderestapidb
   * Create DNS entries on the Private DNS zone created
   * You could make use of Azure DevOps Pipelines to configure the agents on Virtual Machines to deploy the code for Web App on internal Network
   * For testing the API App internally, create a test VM within the VNET subnet
6. Creates API Management service: apim-internal
7. Configures the service to connect to intern VNET on Subnet: apimsubnet. After the deployment is compelte, perform the below additional steps
   * Configure custom domains for APIM Services using SSL Cert
     * API portal (api.contoso.org)
     * Dev Portal (portal.contoso.org)
     * In the APIs section, configure the ASE Apps using ASE’s DNS name added Policy for HOST Header for the Webapp
     * Use the above created test VM to test the API Management service internal on the Virtual Network
> *Note: the testing the APIM APIs from Azure portal will still NOT work as we don’t have api.contoso.org not be able to publicly resolve*

8. Configures Application Gateway (WAF V1) to access the APU service: apim-gateway on Port 80. Add SSL Certs to the App Gateway and corresponding Health probes and Http settings. Also configure the Rules and Listeners to use SSL Cert

Once the above steps are successfully completed, Configure the DNS entries in Godaddy CNAME entries of api.contoso.org and portal.contoso.org with App Gateway’s public DNS name: ase-appgtwy.westus.cloudapp.azure.com and verify if you are able to reach the Dev Portal from Public and are able to test the APIM services APIs using Azure Portal

*Note that it is not a good practice to use same URL for Internal and External Devs for the APIM services (currently in the above demo, both URLs are same). If we want to choose to have different URLs for internal and external devs, we could make use of App Gateway WAF v2 which supports http redirection and much more.*

## Pricing

API Management is offered in four tiers: developer, basic, standard, and premium. You can find detailed guidance on the difference in these tiers at the [Azure API Management pricing guidance here.][apim-pricing]

Customers can scale API Management by adding and removing units. Each unit has capacity that depends on its tier.

> [!NOTE]
> The Developer tier can be used for evaluation of the API Management features. The Developer tier should not be used for production.

To view projected costs and customize to your deployment needs, you can modify the number of scale units and App Service instances in the [Azure Pricing Calculator][pricing-calculator].

Similarly, the [App Service Environments pricing guidance is provided here][ase-pricing]

Application Gateway pricing can be be [configured here][appgtwy-pricing] depending upon the required tier and resources 

## Related resources

Check out the related scenario on [Migrating legacy web APIs to API Management][related-scenario]

<!-- links -->

[architecture]: ./media/architecture-internal-apim-ase-scenario.jpg
[dns]: https://docs.microsoft.com/en-us/azure/dns/private-dns-overview
[ase]: https://docs.microsoft.com/en-us/azure/app-service/environment/intro
[apim]: https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts
[appgtwy]: https://docs.microsoft.com/en-us/azure/application-gateway/overview
[ssl]: https://docs.microsoft.com/en-us/azure/app-service/web-sites-purchase-ssl-web-site
[ntwkcons]: https://docs.microsoft.com/en-us/azure/app-service/environment/network-info
[apim-port-nsg]: https://docs.microsoft.com/en-us/azure/api-management/api-management-using-with-vnet#a-namenetwork-configuration-issues-acommon-network-configuration-issues
[apim-policy]: https://docs.microsoft.com/en-us/azure/api-management/api-management-transformation-policies#SetHTTPheader
[hosted-agent]: https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops
[vnet]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
[devops]: https://docs.microsoft.com/en-us/azure/devops/index?view=azure-devops&viewFallbackFrom=vsts
[appinsights]: https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
[cosmosdb]: https://docs.microsoft.com/en-us/azure/cosmos-db/introduction
[dnsguide]: https://docs.microsoft.com/en-us/azure/dns/private-dns-getstarted-cli
[related-scenario]: https://docs.microsoft.com/en-us/azure/architecture/example-scenario/apps/apim-api-scenario
[apim-pricing]: https://azure.microsoft.com/pricing/details/api-management/
[pricing-calculator]: https://azure.com/e/0e916a861fac464db61342d378cc0bd6
[azure-er]: https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction
[azure-mon]: https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/monitoring-overview
[ase-pricing]: https://azure.microsoft.com/en-us/pricing/details/app-service/windows/
[appgtwy-pricing]: https://azure.microsoft.com/en-us/pricing/details/application-gateway/
[availability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/availability
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[security]: https://docs.microsoft.com/en-us/azure/security/
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/resiliency/index
[azure-vpn]: https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[azure-hybrid]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/
[azure-vm-lift-shift]: https://azure.microsoft.com/en-us/resources/azure-virtual-datacenter-lift-and-shift-guide/
[azure-apim-ai]: https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-app-insights
[apim-multiregion]: https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-deploy-multi-region
[ase-trafficmanager]: https://docs.microsoft.com/en-us/azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale
[apim-scale]: https://docs.microsoft.com/en-us/azure/api-management/upgrade-and-scale
[apim-autoscale]: https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-autoscale
[ase-scale]: https://docs.microsoft.com/en-us/azure/app-service/environment/app-service-web-scale-a-web-app-in-an-app-service-environment
[vnet-security]: https://docs.microsoft.com/en-us/azure/security/azure-network-security
[appgtwy-asc]: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-integration-security-center
[appgtwy-scale]: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-autoscaling-zone-redundant
[api-pattern]: https://azure.microsoft.com/en-us/blog/using-the-retry-pattern-to-make-your-cloud-application-more-resilient/
