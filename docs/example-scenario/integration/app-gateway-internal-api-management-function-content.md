APIs play an increasingly central role in how companies and customers access services, both within organizations and across external channels. Internally, APIs provide access to line-of-business (LoB) applications, custom-built solutions, and non-Microsoft integrations. Externally, more companies aim to increase productivity and generate revenue through their APIs. As this trend grows, API Management becomes a central component in a standardized approach to managing, governing, and publishing APIs for both internal and external audiences.

Azure Application Gateway serves as a security checkpoint for your APIs. Instead of allowing users to connect directly over the internet, you route all traffic through the Application Gateway. This setup adds extra access controls to help protect your APIs. With this approach, you can use a single API Management instance to support both internal APIs within your organization and external APIs outside your organization, while keeping any publicly exposed APIs secured behind the gateway.

> [!NOTE]
> This architecture is used as the foundation of the guidance for [Azure API Management in Azure landing zones](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) in the Cloud Adoption Framework.

## Architecture

:::image type="complex" source="./media/app-gateway-internal-api-management-function.svg" lightbox="./media/app-gateway-internal-api-management-function.svg" alt-text="Diagram that shows the architecture of the API Management in a landing zone.":::
   This architectural diagram starts with an all-encompassing box that represents the scope of a subscription, a Private DNS zone where private domains will get resolved, and the scope of a virtual network named APIM-CS virtual network. On top of the subscription is a box that indicates it's an on-premises workload. The box has a server icon within it. A pipe indicates a site-to-site connection, or Azure ExpressRoute connects to the API Management instance in the Azure subscription. Three smaller boxes are inside the big box that shows the Azure subscription. Each individual box represents a separate subnet, with an attached network security group. From the left most, there's a public IP address that's attached to Application Gateway on the left-most box on the top row. Application Gateway also lives within one of the three smaller boxes, with the subnet named Application Gateway subnet. To the right is another box that contains the API Management instance, with the subnet named API Management subnet. Next to it's the third box on the top row, which contains a private endpoint in the subnet named PE subnet. From left to right, are the following boxes: key vault, application insights, and log analytics workspace. There are two sets of workflows. The first workflow is indicated in black circles, and the other workflow is indicated in blue circles, which will be explained in later sections. The black workflow indicates the access of APIs that are available externally. The flow starts from the user accessing the Public IP address. The arrow then points to the direction of the Application Gateway, from the Application Gateway to the private endpoint, and from the private endpoint to the Function App. The blue workflow starts from a server on-premises, with an arrow that points to the API Management instance, through a pipeline icon that indicates either a site-to-site connection or via ExpressRoute. The rest of the flow is the same as described previously: from API Management to private endpoint, and from private endpoint to Azure Function.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/api-management-landing-zone-accelerator.vsdx) of this architecture.*

This architecture assumes that the policies are in place from the [Azure landing zone reference implementation](https://github.com/Azure/Enterprise-Scale) and that the structure is driven downward from the management group.

### Workflow

#### Hybrid scenario (blue circles)

This scenario requires either a site-to-site VPN or an Azure ExpressRoute connection to your on-premises environment.

1. An on-premises application requires access to an internal API hosted via API Management.

1. API Management connects to the back-end APIs hosted on Azure Functions. This connection uses a private endpoint, which is available through the Azure Functions Premium plan.

1. The private endpoint securely accesses the internal API that's hosted on Azure Functions.

#### External access scenario (black circles)

1. An external application accesses a public IP address or a custom fully qualified domain name (FQDN), which is attached to Application Gateway.

1. Application Gateway serves as the web application firewall, which requires PFX certificates for Secure Sockets Layer (SSL) termination.

1. API Management connects to the back-end APIs, which are hosted on Azure Functions, through a private endpoint. This private endpoint is available with the Azure Functions Premium plan.

1. The private endpoint securely accesses the externally available API that's hosted on Azure Functions.

### Components

- **[API Management](/azure/well-architected/service-guides/api-management/reliability)** is a managed service that allows you to manage services across hybrid and multicloud environments. API Management acts as a facade to abstract the back-end architecture. It provides control and security for API observability and consumption by both internal and external users.

- **[Azure Defender for APIs](/azure/defender-for-cloud/defender-for-apis-deploy)** provides protection, detection, and response for your APIs throughout their life cycle. It helps you monitor your APIs, improve security, and respond quickly to threats by providing visibility, vulnerability management, and real-time threat detection.

- **[Azure Functions](/azure/well-architected/service-guides/azure-functions-security)** is a serverless solution that allows you to focus more on blocks of code that can be executed with minimal infrastructure management. Functions can be hosted in [various hosting plans](/azure/azure-functions/functions-scale), whereas this reference architecture uses the Premium plan. You can also use the flex consumption or Dedicated (App Service) plan as an alternative option.

- **[Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)** is a managed service that acts as a layer 7 load balancer and [web application firewall](/azure/web-application-firewall/ag/ag-overview). In this scenario, the Application Gateway protects the internal API Management instance, enabling the use of both internal and external modes. Application Gateway plays a crucial role in the architecture. API Management focuses on securing APIs, but Application Gateway adds complementary capabilities such as Web Application Firewall (WAF).

- **[Azure DNS](/azure/dns/dns-overview)** **[Private DNS zones](/azure/dns/private-dns-privatednszone)** allow you to manage and resolve domain names within a virtual network, without needing to implement a custom DNS solution. A Private DNS zone can be aligned to one or more virtual networks, through [virtual network links](/azure/dns/private-dns-virtual-network-links). Because the Azure Functions in this reference architecture are exposed via a private endpoint, a private DNS zone is required to ensure proper name resolution within the virtual network.

- **[Azure Monitor](/azure/azure-monitor/overview)** **[Application Insights](/azure/well-architected/service-guides/application-insights)** helps developers detect anomalies, diagnose issues, and understand usage patterns. Application Insights features extensible application performance management and monitoring for live web apps. Various platforms are supported, including .NET, Node.js, Java, and Python. It supports apps that are hosted in Azure, on-premises, in a hybrid environment, or in other public clouds. Application Insights is included as part of this reference architecture, to monitor the behaviors of the deployed application.

- **[Azure Monitor](/azure/azure-monitor/overview)** **[Log Analytics](/azure/well-architected/service-guides/azure-log-analytics)** allows you to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform advanced analysis. They can then visualize the results. Log Analytics is configured as part of this reference architecture, to aggregate all the platform resource logs for more analysis and reporting.

- **[Azure Key Vault](/azure/key-vault/general/overview)** is a cloud service that securely stores and accesses secrets, which range from API keys and passwords to certificates and cryptographic keys. This reference architecture uses Key Vault to store the SSL certificates that's used by the Application Gateway.

### Alternatives

For the back-end services that the API Management instance connects to, several alternatives are available, in addition to Azure Functions, which is used in this reference implementation:

- **[Azure App Service](/azure/app-service/overview)** is a fully managed HTTP-based service that builds, deploys, and scales web apps. .NET, .NET Core, Java, Ruby, Node.js, PHP, and Python are all supported. Applications can run and scale in either Windows or Linux-based environments.

- **[Azure Kubernetes Service](/azure/aks/intro-kubernetes)** provides fully managed Kubernetes clusters for an integrated continuous integration and continuous delivery (CI/CD) experience, governance, and security.

- **[Azure Logic Apps](/azure/logic-apps/logic-apps-overview)** is a cloud-based platform that creates and runs automated workflows. An example reference architecture can be found at [Basic enterprise integration on Azure](/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration).

- **[Azure Container Apps](/azure/container-apps/overview)** enables you to run microservices and containerized applications on a serverless platform.

For multiregion deployments, consider using **[Azure Front Door](/azure/frontdoor/front-door-overview)** to provide fast, reliable, and secure access between your users and your applications' static and dynamic web content.

To see more examples of how Application Gateway can protect APIs, see [Protect APIs by using Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Deploy at least three [scale units](/azure/api-management/upgrade-and-scale) of API Management that are spread over two availability zones for each region. This method maximizes your availability and performance.

- We recommend that ou use the Premium tier because it supports availability zones and multiregion deployments. This means that your services can continue to run even if one region or zone goes down. These features help protect your application during outages or disasters.

- From a disaster recovery standpoint when yous set up API Management, use a user-assigned managed identity instead of a system-assigned identity. This way, if you redeploy or remove the resource, your identity and its permissions (like access to Key Vault secrets) stay intact, making it easier to restore access. Also, automate your backups with Azure Pipelines and decide if you need to deploy your services in multiple regions for extra reliability.

- Virtual network peering provides great performance in a region, but it has a scalability limit of max 500 networks. If you require more workloads to be connected, use a [hub-spoke design](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) or [Azure vWAN](/azure/virtual-wan/virtual-wan-about).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- API Management [validation policies](/azure/api-management/validation-policies) are available to validate API requests and responses against an OpenAPI schema. These features aren't a replacement for a [Web Application Firewall](/azure/web-application-firewall/overview), but they can provide extra protection against some threats. Adding validation policies can have performance implications, so we recommend that you use performance load tests to assess their impact on API throughput.

- Azure [Defender for APIs](/azure/defender-for-cloud/defender-for-apis-deploy) provides full life cycle protection, detection, and response coverage for APIs that are published in API Management. One of the main capabilities is the ability to detect exploits of the Open Web Application Security Project (OWASP) API top 10 vulnerabilities through runtime observations of anomalies by using machine learning-based and rule-based detections.

- API Management [workspaces](/azure/api-management/workspaces-overview) help you organize and isolate your APIs. This approach makes it easier to control who can access and manage them. Each workspace can have its own set of permissions, so you can limit access to only the people or teams who need it. This separation reduces the risk of accidental changes or unauthorized access and supports a more secure API environment.

- [Apply named values with Key Vault secrets](/azure/api-management/api-management-howto-properties) to protect sensitive information in API Management policies.

- Use [Application Gateway for external access of an internal API Management instance](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway) to protect the API Management instance, defend against common web application exploits and vulnerabilities using WAF, and enable hybrid connectivity.

- Deploy the API Management gateway in a virtual network to support hybrid connectivity and increased security.

- Virtual network peering provides great performance in a region and enables private communication between virtual networks.

- When you use a WAF, you introduce a layer that inspects incoming traffic for malicious behavior. This protection helps block common threats such as SQL injection and cross-site scripting. Combined with distributed denial-of-service (DDoS) protection, Application Gateway helps prevent excessive traffic or connection floods from overwhelming the API Management instance. To review how Application Gateway can protect your APIs, see [Protect APIs with Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis).

- Using private endpoints for Azure Functions allows you to securely connect to your function apps over a private IP address within your virtual network. This setup prevents exposure of your functions to the public internet, which reduces the risk of unauthorized access. In this architecture, private endpoints ensure that only trusted resources within your network can access your Azure Functions.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- This deployment uses the [Premium plan](https://azure.microsoft.com/pricing/details/functions/) to support availability zone and virtual network capabilities. If you don't require dedicated instances, you can also use [Flex Consumption](/azure/azure-functions/flex-consumption-plan), which supports both network access and availability zones. Review the [price calculator](https://azure.com/e/802ca3c87e13413580e49bab4a9f67ea) for this deployment.

- For proof of concept or prototypes, we recommend that you use other tiers of API Management, such as Developer or Standard.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- API Management configurations should be represented as Azure Resource Manager templates, and you should adopt an infrastructure as code (IaC) approach.

- Use a CI/CD process to manage, version, and update API Management configurations.

- Create custom health probes to help validate the status of your API management instance. Use the URL `/status-0123456789abcdef` to create a common health endpoint for the API Management service in the app gateway.

- Certificates updated in the key vault are automatically rotated in API Management, which reflects the changes within four hours.

- Deploy at least two [scale units](/azure/api-management/upgrade-and-scale) of API Management that are spread over two availability zones in each region. This method maximizes availability and performance.

- If you use a DevOps tool, such as Azure DevOps or GitHub, then cloud-hosted agents or runners operate over the public internet. Because the API management in this architecture is set to an internal network, you need to use a DevOps agent that has access to the virtual network. The DevOps agent helps you deploy policies and other changes to the APIs in your architecture. You can use these [CI/CD templates](/azure/api-management/devops-api-development-templates) to break the process apart and to allow your development teams to deploy changes for each API. DevOps runners initiate the templates to handle these individual deployments.

## Deploy this scenario

This architecture is available on [GitHub](https://github.com/Azure/apim-landing-zone-accelerator). It contains all the necessary IaC files and the [deployment instructions](https://github.com/Azure/apim-landing-zone-accelerator/blob/main/scenarios/apim-baseline/bicep/README.md).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Pete Messina](https://www.linkedin.com/in/peter-messina-93512414/) | Senior Cloud Solution Architect
- [Anthony Nevico](https://www.linkedin.com/in/anthonynevico/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [API Management in Azure landing zones](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator)
- [API Management documentation](/azure/api-management/api-management-terminology)
- [Application Gateway documentation](/azure/application-gateway/overview)

## Related resources

- [Use API gateways in microservices](../../microservices/design/gateway.yml)
- [Hub-spoke network topology in Azure](../../networking/architecture/hub-spoke.yml)
- [Basic enterprise integration on Azure](../../reference-architectures/enterprise-integration/basic-enterprise-integration.yml)
- [Protect APIs with Application Gateway and API Management](../../web-apps/api-management/architectures/protect-apis.yml)
