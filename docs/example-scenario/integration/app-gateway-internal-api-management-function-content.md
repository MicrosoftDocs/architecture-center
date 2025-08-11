APIs play an increasingly central role in how companies and customers access services, both within organizations and across external channels. Internally, APIs provide access to line-of-business (LoB) applications, custom-built solutions, and non-Microsoft integrations. Externally, more companies aim to increase productivity and generate revenue through their APIs. As this trend grows, API Management has become a central component in a standardized approach to managing, governing, and publishing APIs for both internal and external audiences.

Azure Application Gateway serves as a security checkpoint for your APIs. Instead of allowing users to connect directly over the internet, you instead route all traffic through the Application Gateway. This setup adds extra access controls to help protect your APIs. With this approach, you can use a single API Management instance to support both internal APIs within your organization and external APIs outside your organization, while keeping any publicly exposed APIs secured behind the gateway.

> [!NOTE]
> This architecture is used as the foundation of the guidance for [Azure API Management in Azure landing zones](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) in the Cloud Adoption Framework.

## Architecture

:::image type="complex" source="./media/app-gateway-internal-api-management-function.svg" lightbox="./media/app-gateway-internal-api-management-function.svg" alt-text="The diagram shows a secure baseline architecture for API Management.":::
   A key icon at the top left represents the Azure subscription. A network interface icon labeled Public IP addresses connects with a rightward arrow to an icon that has two opposing arrows labeled Application Gateway. This gateway sits inside a rectangular area labeled Application Gateway subnet. A brick wall with a globe icon labeled Web Application Firewall policies connects to the Application Gateway, which indicates integrated traffic inspection. Below the Application Gateway subnet, there are three icons: a magnifying glass over a document for Log Analytics workspaces, a graph icon for App Insights, and a globe icon for azure-api.net. A rightward arrow from the Application Gateway leads to a cloud icon labeled API Management Premium, which sits inside a separate rectangular area labeled API Management subnet. A downward arrow from API Management connects to a signal tower icon labeled Private endpoint, which appears inside a third rectangular area labeled Private endpoint subnet. A rightward arrow from the private endpoint leads to a key-in-circle icon labeled Key vaults. Directional arrows throughout the diagram indicate the flow of traffic and secure connectivity between components.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/api-management-landing-zone-accelerator.vsdx) of this architecture.*

This architecture assumes that the policies are in place from the [Azure landing zone reference implementation](https://github.com/Azure/Enterprise-Scale) and that the structure is driven downward from the management group.

### Workflow

- Public IP addresses are assigned to the Application Gateway, which serves as the entry point for external traffic.

- The Application Gateway is deployed in its own subnet and protected by Web Application Firewall (WAF) policies to inspect and filter incoming requests.

- Traffic is routed from the Application Gateway to API Management (Premium), which resides in a separate API Management subnet. The API Management instance is configured in internal mode, which prevents direct public access.

- Private endpoints are used to securely connect API Management to back-end services, such as Azure key vaults, which are hosted in a dedicated private endpoint subnet.

- Key vaults store sensitive information like secrets and certificates, accessible only through the private network.

- Log Analytics workspaces and Application Insights are integrated for centralized logging, monitoring, and telemetry.

- APIs are exposed through a custom domain, such as `azure-api.net`, via the Application Gateway.

### Components

- **[API Management](/azure/well-architected/service-guides/api-management/reliability)** is a managed service that allows you to manage services across hybrid and multicloud environments. In this architecture, API Management serves as a facade to abstract the back-end architecture. It provides control and security for API observability and consumption by both internal and external users.

- **[Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)** is a managed service that serves as a layer 7 load balancer and [web application firewall](/azure/web-application-firewall/ag/ag-overview). Application Gateway protects the internal API Management instance, which enables the use of both internal and external modes. In this architecture, API Management secures APIs, but Application Gateway adds complementary capabilities such as WAF.

- **[Private DNS zones](/azure/dns/private-dns-privatednszone)** are a feature of Azure DNS that allow you to manage and resolve domain names within a virtual network without needing to implement a custom DNS solution. A private DNS zone can be aligned to one or more virtual networks through [virtual network links](/azure/dns/private-dns-virtual-network-links). In this architecture, a private DNS zone is required to ensure proper name resolution within the virtual network.

- **[Application Insights](/azure/well-architected/service-guides/application-insights)** is an extensible application performance management service that helps developers detect anomalies, diagnose problems, and understand usage patterns. Application Insights features extensible application performance management and monitoring for live web apps. Various platforms are supported, including .NET, Node.js, Java, and Python. It supports apps that are hosted in Azure, on-premises, in a hybrid environment, or in other public clouds. In this architecture, Application Insights monitors the behaviors of the deployed application.

- **[Log Analytics](/azure/well-architected/service-guides/azure-log-analytics)** is a cloud-based data analysis tool that allows you to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform advanced analysis. They can then visualize the results. In this architecture, Log Analytics aggregates all the platform resource logs for more analysis and reporting.

- **[Azure Key Vault](/azure/key-vault/general/overview)** is a cloud service that securely stores and accesses secrets. These secrets range from API keys and passwords to certificates and cryptographic keys. In this architecture, Key Vault stores the Secure Socket Layer (SSL) certificates that Application Gateway uses.

### Alternatives

For the back-end services that the API Management instance connects to, several alternatives are available:

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

- We recommend that you use the Premium tier because it supports availability zones and multiregion deployments. This means that your services can continue to run even if one region or zone goes down. These features help protect your application during outages or disasters.

- From a disaster recovery standpoint when you set up API Management, use a user-assigned managed identity instead of a system-assigned identity. This way, if you redeploy or remove the resource, your identity and its permissions (like access to Key Vault secrets) stay intact, making it easier to restore access. Also, automate your backups with Azure Pipelines and decide if you need to deploy your services in multiple regions for extra reliability.

- Virtual network peering provides great performance in a region, but it has a scalability limit of max 500 networks. If you require more workloads to be connected, use a [hub-spoke design](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) or [Azure vWAN](/azure/virtual-wan/virtual-wan-about).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- API Management [validation policies](/azure/api-management/validation-policies) are available to validate API requests and responses against an OpenAPI schema. These features aren't a replacement for a [WAF](/azure/web-application-firewall/overview), but they can provide extra protection against some threats. Adding validation policies can have performance implications, so we recommend that you use performance load tests to assess their impact on API throughput.

- Azure [Defender for APIs](/azure/defender-for-cloud/defender-for-apis-deploy) provides full life cycle protection, detection, and response coverage for APIs that are published in API Management. One of the main capabilities is the ability to detect exploits of the Open Web Application Security Project (OWASP) API top 10 vulnerabilities through runtime observations of anomalies by using machine learning-based and rule-based detections.

- API Management [workspaces](/azure/api-management/workspaces-overview) help you organize and isolate your APIs. This approach makes it easier to control who can access and manage them. Each workspace can have its own set of permissions, so you can limit access to only the people or teams who need it. This separation reduces the risk of accidental changes or unauthorized access and supports a more secure API environment.

- [Apply named values with Key Vault secrets](/azure/api-management/api-management-howto-properties) to protect sensitive information in API Management policies.

- Use [Application Gateway for external access of an internal API Management instance](/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway) to protect the API Management instance, defend against common web application exploits and vulnerabilities using WAF, and enable hybrid connectivity.

- Deploy the API Management gateway in a virtual network to support hybrid connectivity and increased security.

- Virtual network peering provides great performance in a region and enables private communication between virtual networks.

- When you use a WAF, you introduce a layer that inspects incoming traffic for malicious behavior. This protection helps block common threats such as SQL injection and cross-site scripting. Application Gateway and distributed denial-of-service (DDoS) protection combined help prevent excessive traffic or connection floods from overwhelming the API Management instance. For more information, see [Protect APIs with Application Gateway and API Management](/azure/architecture/web-apps/api-management/architectures/protect-apis).

- Using private endpoints for Azure Functions allows you to securely connect to your function apps over a private IP address within your virtual network. This setup prevents exposure of your functions to the public internet, which reduces the risk of unauthorized access. In this architecture, private endpoints ensure that only trusted resources within your network can access your Azure Functions.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- This deployment uses the [Premium plan](https://azure.microsoft.com/pricing/details/functions/) to support availability zone and virtual network capabilities. If you don't require dedicated instances, you can also use [Flex Consumption](/azure/azure-functions/flex-consumption-plan), which supports both network access and availability zones. Review the [price calculator](https://azure.com/e/802ca3c87e13413580e49bab4a9f67ea) for this deployment.

- For proof of concept or prototypes, we recommend that you use other API Management tiers, such as Developer or Standard.

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
