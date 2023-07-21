APIs have become increasingly prominent in how companies and customers access services, both internally and externally. Internally, APIs are used to access line-of-business applications, home-built solutions, and 3rd-party integrations. Externally, more companies look to be productive and monetize their APIs. With this trend in mind, API Management becomes a central component to a standard approach of managing, governing, and publishing APIs to both internal and external audiences.

With the help of Azure Application Gateway, it's now possible to protect and restrict the access of APIs that are served through Azure API Management. This article describes a solution where you can manage both internal and external APIs through a single API Management instance. You can maintain a secure posture from being exposed directly through the internet, but instead it's accessed through an Application Gateway.

> [!NOTE]
> This architecture is used as the foundation of the [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) in the Cloud Adoption Framework.

## Architecture

:::image type="complex" source="./media/app-gateway-internal-api-management-function.png" alt-text="Diagram that shows the architecture of the API Management landing zone accelerator.":::
   This architectural diagram starts with an all-encompassing box that represents the scope of a subscription, a Private DNS zone where private domains will get resolved, and the scope of a virtual network names APIM-CS VNet. On top of the subscription is a box that indicates it's an on-premises workload. The box has a server icon within it. A pipe indicates a site-to-site connection, or Azure ExpressRoute connects to the API Management instance in the Azure subscription. Seven additional smaller boxes are inside the big box that shows the Azure subscription. Four of the boxes are on the top row, and three are on the bottom row. Each individual box represents a separate subnet, with an attached network security group. From the left most, there is a public IP address that is attached to Azure Application Gateway on the left-most box on the top row. Application Gateway also lives within one of the seven smaller boxes, with the subnet named App GW subnet. To the right is another box that contains the API Management instance, with the subnet named APIM subnet. Next to it is the third box on the top row, which contains a private endpoint for the Azure Functions instance in the subnet named PE subnet. The right-most box on the top row is the backend subnet that contains Azure Function Apps, the Azure App Service plan for the function, and the storage account that's associated with the Function App. On the bottom row, starting from the left, is a box that contains Azure Bastion in the Bastion subnet. The second box contains the management jumbox VM in the Jump Box Subnet. The last box on the bottom row is the DevOps Agent contained within the DevOps subnet. On the bottom right of the image, are three shared resources with their respective icons. From left to right, are the following boxes: key vault, application insights, and log analytics workspace. There are two sets of workflows. The first workflow is indicated in black circles, and the other workflow is indicated in blue circles, which will be explained in later sections. The black workflow indicates the access of APIs that are available externally. The flow starts from the user accessing the Public IP address. The arrow then points to the direction of the Application Gateway, from the Application Gateway to the private endpoint, and from the private endpoint to the Function App. The blue workflow starts from a server on-premises, with an arrow that points to the API Management instance, through a pipeline icon that indicates either a site-to-site connection or via ExpressRoute. The rest of the flow is the same as described above: from API Management to private endpoint, and from private endpoint to Azure Function.
:::image-end:::

This architecture assumes that the policies are in place from the [Azure landing zone accelerator](https://github.com/Azure/Enterprise-Scale) and that the structure is driven downward from the management group.

*Download a [Visio file](https://arch-center.azureedge.net/api-management-landing-zone-accelerator.vsdx) of this architecture.*

### Workflow

#### Hybrid scenario (blue circles)

This scenario requires a site-to-site or an Azure ExpressRoute connection to your on-premises environment.

1. An on-premises application requires access to an internal API that's served through Azure API Management.
2. API Management connects to the backend APIs that are hosted on Azure Functions. This connection is through a private endpoint, which is available through the Azure Functions Premium plan, and is hosted in its own subnet.
3. The private endpoint securely accesses the internal API that's hosted on Azure Functions.

#### External Access Scenario (black circles)

1. An external application accesses a public IP address or custom FQDN, which is attached to Azure Application Gateway.
2. Application Gateway acts as the web application firewall, which requires PFX certificates for SSL termination.
3. API Management connects to the backend APIs, which are hosted on Azure Functions, through a private endpoint. This endpoint is available through the Azure Functions Premium plan and is hosted in its own subnet.
4. The private endpoint securely accesses the externally available API that's hosted on Azure Functions.

### Components

The architecture uses the following components:

- **[Azure API Management](https://azure.microsoft.com/services/api-management)** is a managed service that allows you to manage services across hybrid and multi-cloud environments. API management acts as a facade to abstract the backend architecture, and it provides control and security for API observability and consumption for both internal and external users.

- **[Azure Functions](https://azure.microsoft.com/services/functions)** is a serverless solution that allows you to focus more on blocks of code that can be executed with minimal infrastructure management. Functions can be hosted in [various hosting plans](/azure/azure-functions/functions-scale), whereas this reference architecture uses the premium plan, due to the use of private endpoints.

- **[Azure Application Gateway](https://azure.microsoft.com/services/application-gateway)** is a managed service that acts as a layer 7 load balancer and [web application firewall](/azure/web-application-firewall/ag/ag-overview). In this scenario, the application gateway protects the internal APIM instance, which allows you to use the internal and external mode.

- **[Azure DNS](https://azure.microsoft.com/services/dns) [Private DNS zones](/azure/dns/private-dns-privatednszone)** allow you to manage and resolve domain names within a virtual network, without needing to implement a custom DNS solution. A Private DNS zone can be aligned to one or more virtual networks, through [virtual network links](/azure/dns/private-dns-virtual-network-links). Due to the Azure Functions being exposed over a private endpoint that this reference architecture uses, you must use a private DNS zone.

- **[Azure Monitor](https://azure.microsoft.com/services/monitor) [Application Insights](/azure/azure-monitor/app/app-insights-overview)** helps developers detect anomalies, diagnose issues, and understand usage patterns. Application Insights features extensible application performance management and monitoring for live web apps. Various platforms are supported, including .NET, Node.js, Java, and Python. It supports apps that are hosted in Azure, on-premises, in a hybrid environment, or in other public clouds. Application Insights is included as part of this reference architecture, to monitor the behaviors of the deployed application.

- **[Azure Monitor](https://azure.microsoft.com/services/monitor) [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)** allows you to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform advanced analysis. They can then visualize the results. Log Analytics is configured as part of this reference architecture, to aggregate all the monitoring logs for more analysis and reporting.

- **[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines)** is a computing resource that can be used to host many different workloads. In this reference architecture, virtual machines are used to provide a management jumpbox server, as well as a host for the DevOps agent or GitHub runner.

- **[Azure Key Vault](https://azure.microsoft.com/services/key-vault)** is a cloud service that securely stores and accesses secrets, which range from API keys and passwords to certificates and cryptographic keys. This reference architecture uses Azure Key Vault to store the SSL certificates that's used by the Application Gateway.

- **[Azure Bastion](https://azure.microsoft.com/services/azure-bastion)** is a platform-as-a-service that's provisioned within the developer's virtual network. It provides secure RDP/SSH connectivity to the developer's virtual machines over TLS, from the Azure portal. With Azure Bastion, virtual machines no longer require a public IP address to connect via RDP/SSH. This reference architecture uses Azure Bastion to access the DevOps agent or GitHub runner server or the management jump box server.

If you use a DevOps tool, such as Azure DevOps or GitHub, then cloud-hosted agents or runners operate over the public internet. Since the API management in this architecture is set to an internal network, you'll need to use a DevOps agent that has access to the VNet. The DevOps agent will help you deploy policies and other changes to the APIs in your architecture. These ![CI/CD templates](/azure/api-management/devops-api-development-templates) can be used to break the process apart and to allow your development teams to deploy changes, per API. They're executed by the DevOps runners.

### Alternatives

For the backend services that the API Management instance connects to, several alternatives are available, in addition to Azure Functions, which is used in this reference implementation:

- [**Azure App Service**](/azure/app-service/overview) is a fully managed HTTP-based service that builds, deploys, and scales web apps. .NET, .NET Core, Java, Ruby, Node.js, PHP, and Python are all supported. Applications can run and scale in either Windows or Linux-based environments. 
- [**Azure Kubernetes Service**](/azure/aks/intro-kubernetes) offers fully managed Kubernetes clusters for an integrated continuous integration and continuous delivery (CI/CD) experience, governance, and security.
- [**Azure Logic Apps**](/azure/logic-apps/logic-apps-overview) is a cloud-based platform that creates and runs automated workflows. An example reference architecture can be found at [Basic enterprise integration on Azure](/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration). 
- [**Azure Container Apps**](/azure/container-apps/overview) enables you to run microservices and containerized applications on a serverless platform. 

For multi-region deployments, consider using [**Azure Front Door**](/azure/frontdoor/front-door-overview) to provide fast, reliable, and secure access between your users and your applications' static and dynamic web content.

To see additional examples of how Application Gateway can protect APIs, refer to [Protect APIs with Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Deploy at least two [scale units](/azure/api-management/upgrade-and-scale) of API Management that are spread over two availability zones, per region. This method maximizes your availability and performance.
- VNet peering provides great performance in a region, but it has a scalability limit of max 500 networks. If you require more workloads to be connected, use a [hub spoke design ](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) or [Azure vWAN](/azure/virtual-wan/virtual-wan-about).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- API Management [validation policies](/azure/api-management/validation-policies) are available to validate API requests and responses against an OpenAPI schema. These features aren't a replacement for a [Web Application Firewall](/azure/web-application-firewall/overview), but they can provide additional protection against some threats. Adding validation policies can have performance implications, so we recommend you use performance load tests to assess their impact on API throughput.
- Deploy Azure Web Application Firewall (WAF) in front of API Management to provide protection against common web application exploits and vulnerabilities.
- [Apply named values with Key Vault secrets](/azure/api-management/api-management-howto-properties) to protect sensitive information in APIM policies.
- Use [Application Gateway for external access of an internal APIM instance](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway) to protect APIM instance and to enable hybrid connectivity.
- Deploy the API Management gateway in a VNet, to support hybrid connectivity and increased security.
- VNet peering provides great performance in a region, but it has a scalability limit of max 500 networks. If you require more workloads to be connected, use a [hub spoke design](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) or [Azure vWAN](/azure/virtual-wan/virtual-wan-about).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Due to the need of availability zone and virtual network support, we selected the Premium tier of API Management, following the [pricing for each region](https://azure.microsoft.com/pricing/details/api-management). Additionally, in this workload, Azure Functions is hosted on the [Premium plan](https://azure.microsoft.com/pricing/details/functions/), due to the need of VNet access. 
- For proof of concept or prototypes, we recommend you use other tiers of API Management (such as Developer or Standard). 

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- API Management configurations should be represented as ARM templates, and you should embrace an infrastructure-as-code mindset.
- Use a CI/CD process to manage, version, and update API Management configurations.
- Create custom health probes to help validate the status of your API management instance. Use the URL `/status-0123456789abcdef` to create a common health endpoint for the APIM service in the app gateway.
- Certificates updated in the key vault are automatically rotated in API Management, which is updated within 4 hours.
- Deploy at least two [scale units](/azure/api-management/upgrade-and-scale) of API Management that are spread over two availability zones, per region. This method maximizes availability and performance.

## Deploy this scenario

This architecture is available on [GitHub](https://github.com/Azure/apim-landing-zone-accelerator). It contains all the necessary infrastructure-as-code files and the [deployment instructions](https://github.com/Azure/apim-landing-zone-accelerator/blob/main/docs/README.md).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Pete Messina](https://www.linkedin.com/in/peter-messina-93512414/) | Senior Cloud Solution Architect
 - [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* This same architecture is used as the foundation of the [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) in the Cloud Adoption Framework.
* [CI/CD for API Management using Azure Resource Manager templates](/azure/api-management/devops-api-development-templates)
* [Intro to API Management](/training/modules/introduction-to-azure-api-management/)
* [Manage APIs with APIM](/training/modules/publish-manage-apis-with-azure-api-management/)
* [API Management Resources for getting started](https://azure.microsoft.com/services/api-management#documentation)

See these key resources:
* [Azure landing zone accelerator](https://github.com/Azure/Enterprise-Scale)
* [API Ops](https://github.com/Azure/apiops)
* [Azure API Management documentation](/azure/api-management/api-management-terminology)
* [Azure API Management key concepts](/azure/api-management/api-management-key-concepts)
* [Application Gateway documentation](/azure/application-gateway/overview)
* [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator)

Learn more about these key services:
* [Azure Functions overview](/azure/azure-functions/functions-overview)
* [Azure Private DNS zones](/azure/dns/private-dns-privatednszone)
* [Azure Application Insights overview](/azure/azure-monitor/app/app-insights-overview)
* [Azure Log Analytics overview](/azure/azure-monitor/logs/log-analytics-overview)
* [Azure Virtual Machines overview](/azure/virtual-machines/windows/overview)
* [Azure Key Vault concepts](/azure/key-vault/general/basic-concepts)
* [Azure Bastion overview](/azure/bastion/bastion-overview)

## Related resources

* [Use API Gateways in microservices](/azure/architecture/microservices/design/gateway)
* [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
* [Basic enterprise integration on Azure](/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration)
* [Protect APIs with Application Gateway and API Management](/azure/architecture/reference-architectures/apis/protect-apis)
