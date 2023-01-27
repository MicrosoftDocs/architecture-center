[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates how to integrate Azure Kubernetes Service (AKS) and Azure API Management via mutual TLS (mTLS) in an architecture that provides end-to-end encryption.

## Architecture

:::image type="content" source="../media/mutual-tls-deploy-aks-api-management.png" alt-text="Diagram that shows an architecture for integrating AKS and API Management via mTLS." lightbox="../media/mutual-tls-deploy-aks-api-management.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/mutual-tls-for-deploying-aks-and-api-management.vsdx) of this architecture.*


### Dataflow

1. A user makes a request to the application endpoint from the internet.
2. Azure Application Gateway receives traffic as HTTPS and presents a PFX certificate previously loaded from Azure Key Vault to the user.
3. Application Gateway uses private keys to decrypt traffic (SSL offload), performs web application firewall inspections, and re-encrypts traffic by using public keys (end-to-end encryption).
4. Application Gateway applies rules and backend settings based on the backend pool and sends traffic to the API Management backend pool over HTTPS.
5. API Management is deployed in internal virtual network mode (Developer or Premium tier only) with a private IP address. It receives traffic as HTTPS with custom domain PFX certificates. 
6. Azure Active Directory (Azure AD) provides authentication and applies API Management policies via OAuth and client certificate validation. To receive and verify client certificates over HTTP/2 in API Management, you need to enable **Negotiate client certificate** on the **Custom domains** blade in API Management.
7. API Management sends traffic via HTTPS to an ingress controller for an AKS private cluster.
8. The AKS ingress controller receives the HTTPS traffic and verifies the PEM server certificate and private key. Most enterprise-level ingress controllers support mTLS. Examples include NGINX and AGIC.
9. The ingress controller processes TLS secrets (Kubernetes Secrets) by using cert.pem and key.pem. The ingress controller decrypts traffic by using a private key (offloaded). For enhanced-security secret management that's based on requirements, CSI driver integration with AKS is available.
10. The ingress controller re-encrypts traffic by using private keys and sends traffic over HTTPS to AKS pods. Depending on your requirements, you can configure AKS ingress as HTTPS backend or passthrough.

### Components

* [Application Gateway](https://azure.microsoft.com/products/application-gateway). Application Gateway is a web traffic load balancer that you can use to manage traffic to web applications.
* [AKS](https://azure.microsoft.com/services/kubernetes-service). AKS provides fully managed Kubernetes clusters for deployment, scaling, and management of containerized applications.
* [Azure Container Registry](https://azure.microsoft.com/services/container-registry). Container Registry is a managed, private Docker registry service on Azure. You can use Container Registry to store private Docker images, which are deployed to the cluster.
* [Azure AD](https://azure.microsoft.com/services/active-directory). When AKS is integrated with Azure AD, you can use Azure AD users, groups, or service principals as subjects in Kubernetes RBAC to manage AKS resources.
   * [Managed identities](/azure/active-directory/managed-identities-azure-resources). Azure AD managed identities eliminate the need to manage credentials like certificates, secrets, and keys.
* [Azure SQL Database](https://azure.microsoft.com/services/sql-database). SQL Database is a fully managed and intelligent relational database service that's built for the cloud. You can use SQL Database to create a high-availability, high-performance data storage layer for your modern cloud applications.
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db). Azure Cosmos DB is a fully managed NoSQL database service for building and modernizing scalable, high-performance applications.
* [API Management](https://azure.microsoft.com/products/api-management). You can use API Management to publish APIs to your developers, partners, and employees.
* [Azure Private Link](https://azure.microsoft.com/products/private-link). Private Link provides access to PaaS services that are hosted on Azure, so you can keep your data on the Microsoft network.
* [Key Vault](https://azure.microsoft.com/products/key-vault). Key Vault can provide enhanced security for keys and other secrets.
* [Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud). Defender for Cloud is a solution for cloud security posture management and cloud workload protection. It finds weak spots across your cloud configuration, helps strengthen the security of your environment, and can protect workloads across multicloud and hybrid environments from evolving threats.
* [Azure Monitor](https://azure.microsoft.com/products/monitor). You can use Monitor to collect, analyze, and act on telemetry data from your Azure and on-premises environments. Monitor helps you maximize the performance and availability of your applications and proactively identify problems.
   * [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview). You can use Log Analytics to edit and run log queries with data in Azure Monitor logs.
   * [Application Insights](/azure/azure-monitor/app/app-insights-overview). Application Insights is an extension of Azure Monitor. It provides application performance monitoring.
* [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel). Microsoft Sentinel is a cloud-native security information and event manager platform that uses built-in AI to help you analyze large volumes of data.
* [Azure Bastion](https://azure.microsoft.com/products/azure-bastion). Azure Bastion is a fully managed service that provides RDP and SSH access to VMs without any exposure through public IP addresses. You can provision the service directly in your local or peered virtual network to get support for all VMs in that network.
* [Azure Private DNS](/azure/dns/private-dns-privatednszone). You can use Private DNS to manage and resolve domain names in a virtual network without adding a custom DNS solution.

## Scenario details

You can use this solution to integrate AKS and API Management via mTLS in an architecture that provides end-to-end encryption.

### Potential use cases

- AKS integration with API Management and Application Gateway, via mTLS. 
- End-to-end mTLS between API Management and AKS.
- High security deployments for organizations that need end-to-end TLS. For example, organizations in the financial sector can benefit from this solution.

You can use this approach to manage the following scenarios:

* Deploy API Management in internal mode and expose APIs by using Application Gateway.
* Configure mTLS and end-to-end encryption for high security and traffic over HTTPS.  
* Connect to Azure PaaS services by using an enhanced security private endpoint.
* Implement Defender for Containers security.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

 - [Saswat Mohanty](https://www.linkedin.com/in/saswat-mohanty-97511315a) | Senior Cloud Solution Architect
 
Other contributors: 

 - [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
 - [Arshad Azeem](https://www.linkedin.com/in/arshadazeem) | Senior Cloud Solution Architect
 - [Raj Penchala](https://www.linkedin.com/in/rajpenchala) | Principal Cloud Solution Architect 
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Application Gateway](/azure/application-gateway/overview)
- [AKS Roadmap](https://github.com/Azure/AKS/projects/1)
- [AKS documentation](/azure/aks/intro-kubernetes)
- [AKS learning path](/training/paths/intro-to-kubernetes-on-azure)  
- [API Management learning path](/training/modules/explore-api-management)
- [API Management landing zone accelerator](https://github.com/Azure/apim-landing-zone-accelerator)
- [Microsoft Defender for Cloud Blog](https://techcommunity.microsoft.com/t5/microsoft-defender-for-cloud/bg-p/MicrosoftDefenderCloudBlog)

## Related resources

- [AKS architecture design](../../reference-architectures/containers/aks-start-here.md)
- [AKS cluster best practices](/azure/aks/best-practices)
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
