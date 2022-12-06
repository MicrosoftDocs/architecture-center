[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates how to integrate Azure Kubernetes Service (AKS) and Azure API Management with mutual TLS (mTLS), with end-to-end encryption.

## Architecture

:::image type="content" source="../media/mutual-tls-deploy-aks-api-management.png" alt-text="[Diagram that shows an architecture for integrating AKS and API Management with mTLS." lightbox="../media/mutual-tls-deploy-aks-api-management.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mutual-tls-for-deploying-aks-and-apim.vsdx) of this architecture.*

### Dataflow

1. A user requests the application endpoint from the internet.
2. Azure Application Gateway receives traffic as HTTPS and presents a PFX certificate from Azure Key Vault.
3. Application Gateway uses private keys to decrypt traffic (SSL offload), performs web application firewall inspections, and re-encrypts traffic by using public keys (end-to-end encryption).
4. Application Gateway applies rules and backend settings based on the backend pool and sends traffic to the API Management backend pool over HTTPS.
5. API Management is deployed in internal virtual network mode (developer or premium tier only) with a private IP address. It receives traffic as HTTPS with custom domain PFX certificates. 
6. Azure Active Directory (Azure AD) provides authentication and applies API Management policies via OAuth and client certificate validation. To receive and verify client certificates over HTTP/2 in API Management, you need to enable **Negotiate client certificate** on the **Custom domains** blade in API Management.
7. API Management sends traffic via HTTPS to an ingress controller for an AKS private cluster.
8. The AKS ingress controller receives the HTTPS traffic and verifies the PEM server certificate and private key. Most enterprise-level ingress controllers support mTLS. Examples include NGINX and AGIC.
9. The ingress controller processes TLS secrets (Kubernetes Secrets) by using cert.pem and key.pem. The ingress controller decrypts traffic by using a private key (offloaded). For enhanced-security secret management that's based on requirements, CSI driver integration with AKS is available.
10. The ingress controller re-encrypts traffic by using private keys and sends traffic over HTTPS to AKS pods. Depending on your requirements, you can configure AKS ingress as HTTPS backend or passthrough.

### Components

* [Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) Azure Application Gateway is a web traffic load balancer that enables you to manage traffic to web applications
* [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service) offers fully managed Kubernetes clusters for deployment, scaling, and management of containerized applications.
* [Azure Container Registry](https://azure.microsoft.com/services/container-registry) is a managed, private Docker registry service on Azure. Use Container Registry to store private Docker images, which are deployed to the cluster.
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory). When AKS is integrated with Azure Active Directory, it allows you to use Azure AD users, groups, or service principals as subjects in Kubernetes RBAC to manage AKS resources securely.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed and intelligent relational database service built for the cloud. With SQL Database, you can create a highly available and high-performance data storage layer for modern cloud applications.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a fully managed NoSQL database service for building and modernizing scalable, high performance applications.
* [Azure API Management](https://azure.microsoft.com/en-us/products/api-management) Publish APIs to developers, partners, and employees securely and at scale.
* [Azure Private Endpoint](https://azure.microsoft.com/en-us/products/private-link) Private access to Azure PaaS services hosted on the Azure platform, keeping your data on the Microsoft network.
* [Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault) Safeguard and maintain control of keys and other secrets.
* [Microsoft Defender for Cloud](https://azure.microsoft.com/en-us/products/defender-for-cloud) Microsoft Defender for Cloud is a solution for cloud security posture management (CSPM) and cloud workload protection (CWP) that finds weak spots across your cloud configuration, helps strengthen the overall security posture of your environment, and can protect workloads across multicloud and hybrid environments from evolving threats.
* [Azure Monitor](https://azure.microsoft.com/en-us/products/monitor) Collect, analyze, and act on telemetry data from your Azure and on-premises environments. Azure Monitor helps you maximize performance and availability of your applications and proactively identify problems in seconds.
* [Log Analytics in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview) Log Analytics is a tool in the Azure portal that's used to edit and run log queries with data in Azure Monitor Logs.
* [Application Insights in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) Application Insights is an extension of Azure Monitor and provides Application Performance Monitoring (also known as “APM”) features.
* [Microsoft Sentinel](https://azure.microsoft.com/en-us/products/microsoft-sentinel) Microsoft Sentinel is a cloud-native security information and event manager (SIEM) platform that uses built-in AI to help analyze large volumes of data across an enterprise—fast.
* [Azure Bastion](https://azure.microsoft.com/en-us/products/azure-bastion) Azure Bastion is a fully managed service that provides more secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to virtual machines (VMs) without any exposure through public IP addresses. Provision the service directly in your local or peered virtual network to get support for all the VMs within it.
* [Azure Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources) Managed identities eliminate the need to manage credentials, such as certificates,secrets and keys
* [Azure Private DNS](https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone) Azure Private DNS provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution

## Scenario details

## Potential use cases

*Azure Kubernetes Service (AKS) integration with API Management and Application Gateway with mTLS. 
*End to end mutual TLS between Azure API management and Azure Kubernetes Service
*Highly secure deployment for customers (ex: financial sector) demanding end to end TLS

This approach can be used to manage the following scenarios:

* Integrate API Management with Azure Kubernetes Service
* Deploy API Management in internal mode and expose APIs using Application Gateway
* Configure mTLS and end to end encryption for maximum security and traffic over Https  
* Securely connect to Azure PaaS services over Private Endpoint
* Microsoft Defender for Cloud for Container security

## Next steps

* To learn about the AKS product roadmap, see [Azure Kubernetes Service Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).
* Learn more about Azure Kubernetes Service (AKS), see [Azure Kubernetes Service (AKS) documentation](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes).
* Azure Kubernetes Service learning path [AKS Learning](https://learn.microsoft.com/en-us/training/paths/intro-to-kubernetes-on-azure).  
* Learn about API management landing zone accelerator, see [Azure API Management on GitHub](https://github.com/Azure/apim-landing-zone-accelerator).
* Microsoft Defender for Cloud Blog [Microsoft Defender for Cloud on Blog](https://techcommunity.microsoft.com/t5/microsoft-defender-for-cloud/bg-p/MicrosoftDefenderCloudBlog).

## Related resources

* Follow the [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md).
* Explore API MAnagement learning path [Azure API Management training](https://learn.microsoft.com/en-us/training/modules/explore-api-management/).
