APIs have become increasingly prominent in how companies and customers access services both internally and externally. Internally, APIs are used to access line of business applications, home-built solutions, 3rd party integrations. Externally, more companies are looking to productive and monetize their APIs. With this in mind, API Management becomes a central component to a standardize approach of managing, governing, and publishing APIs to both internal and external audiences. With the help of Application Gateway, it is now possible to protect and restrict the access of APIs served through API Management. This article describes a solution where users are hoping to manage both internal and external APIs through a single API Management instance while maintaining a secure posture from being exposed directly through the internet but instead through an Application Gateway. 

## Architecture 
![This architectural diagram starts with an all-encompassing box that represents the scope of a subscription, a Private DNS zone where private domains will get resolved, and the scope of a virtual network names APIM-CS VNet. Seven additional smaller boxes reside within the big box, with four on the top row and three on the bottom row. Each individual box represents a separate subnet with an attached network security group. From the left most, there is a public IP address that is attached to the Application Gateway on the left most box on the top row. Application Gateway also lives within one of the seven smaller boxes with the subnet named App GW subnet. The to right is another box containing the API Management instance with the subnet names APIM subnet. Next to it is third box on the top row containing a private endpoint for the Azure Functions in the subnet names PE subnet. The right most box on the top row is the backend subnet containing Function Apps, the App Service Plan for the Function, and the storage account associated with the Function App. On the bottom row starting from the left is a box containing the Bastion in the Bastion subnet. The second box contains the management jumbox vm in the Jump Box Subnet and the last box on the bottom row is the DevOps Agent contained within the DevOps subnet.](./media/app-gateway-internal-api-management-function.png)

Download a [Visio file](../images/APIM.vsdx) that contains this architecture diagram.

### Workflow

### Components
The architecture leverages the following components:

- **[API Management](https://docs.microsoft.com/en-us/azure/api-management/api-management-key-concepts)** a managed service that allows customers to manage across hybrid and multi-cloud. API management acts as a facade to abstract backend architecture and provides control and security for API observability and consumption for both internal and external users.

- **[Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-overview)** a serverless solution that allows the users to focus more on blocks of code to be executed with minimal infrastructure management. Functions can be hosted in [a variety of hosting plans](https://docs.microsoft.com/en-us/azure/azure-functions/functions-scale) whereas this reference architecture uses the premium plan due to the use of private endpoints.

- **[Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)** a managed service acting as a layer 7 load balancer and [web application firewall](https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview) in this use case the application gateway protects the internal APIM instance allowing for use of internal and external mode.

- **[Azure Private DNS Zones](https://docs.microsoft.com/en-us/azure/dns/private-dns-privatednszone)** allow users to manage and resolve domain names within a virtual network without needing to implement a custom DNS solution. A Private Azure DNS zone can be aligned to one or more virtual networks through [virtual network links](https://docs.microsoft.com/en-us/azure/dns/private-dns-virtual-network-links). Due to the Azure Functions being exposed over a private endpoint, this reference architecture uses, a private DNS zone is required.

- **[Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)** is a feature of Azure Monitor that helps Developers detect anomalies, diagnose issues, and understand usage patterns with extensible application performance management and monitoring for live web apps. A variety of platforms including .NET, Node.js, Java, and Python are supported for apps that are hosted in Azure, on-prem, hybrid, or other public clouds. Application Insights is included as part of this reference architecture to monitor behaviors of the deployed application.

- **[Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)** is a feature of Azure Monitor that allows users to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform advanced analysis and visualize the results. Log Analytics is configured as part of this reference architecture to aggregate all the monitoring logs for additional analysis and reporting.

- **[Azure Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)** is a computing resource that can be used to host a number of different workloads. In this reference architecture, virtual machines are used to provide a management jumpbox server, as well as a host for the DevOps Agent / GitHub Runner.

- **[Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts)** is a cloud service to securely store and access secrets, ranging from API keys and passwords to certificates and cryptographic keys. This reference architecture uses Azure Key Vault to store the SSL certificates used by the Application Gateway. 

- **[Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)** is a Platform-as-a-Service service provisioned within the developer's virtual network which provides secure RDP/SSH connectivity to the developer's virtual machines over TLS from the Azure portal. With Azure Bastion, virtual machines no longer require a public IP address to connect via RDP/SSH. This reference architecture uses Azure Bastion to access the DevOps Agent / GitHub Runner server or the management jump box server.

### Alternatives
For the backend services that the API Management instance connects to, there are several alternatives in addition to Azure Functions that is used in this reference implementation:

- [**Azure App Service**](https://docs.microsoft.com/en-us/azure/app-service/overview) is a fully managed HTTP-based service to build, deploy, and scale web apps. .NET, .NET Core, Java, Ruby, Node.js, PHP, and Python are all supported. Applications can run and scale in either Windows or Linux based environment. 
- [**Azure Kubernetes Service**](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) offers fully managed Kubernetes clusters for integrated continuous integration and continuous delivery (CI/CD) experience, governance, and security.
- [**Azure Logic Apps**](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) is a cloud based platform for creating and running automated workflows. 
- [**Azure Container Apps**](https://docs.microsoft.com/en-us/azure/container-apps/overview) enables you to run microservices and containerized applications on a serverless platform. 

For multi-region deployments, consider using [**Azure Front Door**](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview) to provide fast, reliable, and secure access between your users and your applications' static and dynamic web content. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).


### Reliability

- Deploy at least two scale units spread over two AZs per region to maximize availability and performance


### Security 

- API Management [validation policies](https://docs.microsoft.com/en-us/azure/api-management/validation-policies) are available to validate API requests and responses against an OpenAPI schema. These are not a replacement for a [Web Application Firewall](https://docs.microsoft.com/en-us/azure/web-application-firewall/overview) but can provide additional protection against some threats. Note that adding validation policies can have performance implications, so we recommend performance load tests to assess their impact on API throughput.
- Deploy a Web Application Firewall (WAF) in front of API Management to provide protection against common web application exploits and vulnerabilities.
- [Leverage named values with Key Vault secrets](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-properties?tabs=azure-portal) to protect sensitive information in APIM policies
- Use [Application Gateway for external access of an internal APIM instance](https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway) to protect APIM instance and enable hybrid connectivity
- Deploy the gateway in a VNet to supporting hybrid connectivity and increasing security
- VNet peering provides great performance in a region but has a scalability limit of max 500 networks, if you require more workloads to be connected, use a [hub spoke design ](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli) or [Azure vWAN](https://microsoft.sharepoint.com/:p:/t/MSUSFY22TSICertCommunity/EcUBpRDWPOhAjYwZ8H9pkr0BTw9X0wSTEGGQKgT5UBwXMg?e=gwvip9)

### Cost optimization
- Due to the need of availability zone and virtual network support, the Premium tier is selected following the [pricing for each region](https://azure.microsoft.com/en-gb/pricing/details/api-management/). 
- For proof of concept or prototypes, other tiers of APIM (Developer, Standard, etc.) are recommended. 

### Operational excellence 

- API Management configurations should be represented as ARM templates and an infrastructure-as-code mindset should be embraced.
- A CI/CD process should be leveraged to manage, version and update API Management configurations.
- The Uri `/status-0123456789abcdef` can be used as a common health endpoint for the APIM service.
- Client certificate negotiation is enabled is a per-gateway configuration.
- Certificates updated in the key vault are automatically rotated in API Management and is updated within 4 hours.

## Deployment

This architecture is available on [GitHub](https://github.com/Azure/apim-landing-zone-accelerator). It contains all the necessary infrastructure as code files and [instructions](https://github.com/Azure/apim-landing-zone-accelerator/blob/main/docs/README.md) on how to deploy.

## Next steps

* This same architecture is used as the foundation of the [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) in the Cloud Adoption Framework.
* [Use API Gateways in microservices](/azure/architecture/microservices/design/gateway)
* [CI/CD for API Management using Azure Resource Manager templates](/azure/api-management/devops-api-development-templates)
* [Intro to API Management](https://docs.microsoft.com/en-us/learn/modules/introduction-to-azure-api-management/)
* [Manage APIs with APIM](https://docs.microsoft.com/en-us/learn/modules/publish-manage-apis-with-azure-api-management/)
* [API Design eBook](https://azure.microsoft.com/mediahandler/files/resourcefiles/api-design/Azure_API-Design_Guide_eBook.pdf)
* [APIs and MicroServices eBook](https://azure.microsoft.com/mediahandler/files/resourcefiles/apis-microservices-ebook/Azure_API-Microservices_eBook.pdf)

## Related resources

* [Recommendations and Considerations](docs/README.md#enterprise-scale-architecture)
* [API Ops](https://github.com/Azure/apiops)
* [Azure API Management Documentation](https://docs.microsoft.com/en-us/azure/api-management/api-management-terminology)
* [Application Gateway Documentation](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
* [Azure API Management landing zone accelerator](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator)