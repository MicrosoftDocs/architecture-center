This article provides an overview of deploying secure applications using the [App Service Environment][intro-to-app-svc-env]. To restrict application access from the internet, the [Azure Application Gateway][docs-appgw] service and [Azure Web Application Firewall][docs-waf] are used. This article also provides guidance about continuous integration and continuous deployment (CI/CD) for App Service Environments using Azure DevOps.

This scenario is commonly deployed in industries such as banking and insurance, where customers are conscious of platform-level security in addition to application level security. To demonstrate these concepts, we'll use an application that allows users to submit expense reports.

## Potential use cases

Consider this scenario for the following use cases:

- Building an Azure Web App where extra security is required.
- Providing dedicated tenancy, rather than shared tenant App Service Plans.
- Using Azure DevOps with an [internally load-balanced][create-ilb-ase](ILB) Application Service Environment.

## Architecture

![Diagram featuring the sample scenario architecture for Secure ILB App Service Environment Deployment.][architecture]

*Download a [Visio file][visio-download] of this architecture.*

### Dataflow

1. HTTP/HTTPS requests first hit the application gateway.
1. Optionally (not shown in the diagram), you can have Microsoft Entra authentication enabled for the Web App. After the traffic first hits the application gateway, the user would be prompted to supply credentials to authenticate with the application.
1. User requests flow through the internal load balancer (ILB) of the environment, which in turn routes the traffic to the Expenses Web App.
1. The user then proceeds to create an expense report.
1. As part of creating the expense report, the deployed API App is invoked to retrieve the user's manager name and email.
1. The created expense report is stored in Azure SQL Database.
1. To facilitate continuous deployment, code is checked into the Azure DevOps instance.
1. The build VM has the Azure DevOps Agent installed, allowing the build VM to pull the bits for the Web App to deploy to the App Service Environment (since the Build VM is deployed in a subnet inside the same virtual network).

### Components

- The [App Service Environment][intro-to-app-svc-env] provides a fully isolated, dedicated environment for securely running the application at high scale. In addition, because the App Service Environment and the workloads that run on it are behind a virtual network, it also provides an extra layer of security and isolation. The requirement of high scale and isolation drove the selection of ILB App Service Environment.
- This workload uses the [isolated App Service pricing tier][isolated-tier-pricing-and-ase-pricing], so the application runs in a private dedicated environment in an Azure datacenter using faster processors, solid-state drive (SSD) storage, and provides the maximum scale-out capabilities.
- Azure App Service [Web App][docs-webapps] and [API App][docs-apiapps] host web applications and RESTful APIs. These apps and APIs are hosted on the Isolated service plan, which also offers autoscaling, custom domains, and so on, but in a dedicated tier.
- Azure [Application Gateway][docs-appgw] is a web traffic load balancer operating at Layer 7 that manages traffic to the web application. It offers SSL offloading, which removes extra overhead from the web servers hosting the web app to decrypt traffic again.
- [Web Application Firewall][docs-waf] is a feature of Application Gateway. Enabling the web application firewall in the application gateway further enhances security. The web application firewall uses Open Worldwide Application Security Project (OWASP) rules to protect the web application against attacks such as cross-site scripting, session hijacks, and SQL injection.
- [Azure SQL Database][docs-sql-database] was selected because most of the data in this application is relational data, with some data as documents and Blobs.
- [Azure Networking][azure-networking] provides various networking capabilities in Azure, and the networks can be peered with other virtual networks in Azure. Connections can also be established with on-premises datacenters via ExpressRoute or site-to-site. In this case, a [service endpoint][sql-service-endpoint] is enabled on the virtual network to ensure the data is flowing only between the Azure virtual network and the SQL Database instance.
- [Azure DevOps][docs-azure-devops] is used to help teams collaborate during sprints, using features that support Agile Development, and to create build and release pipelines.
- An Azure build [VM][docs-azure-vm] was created so that the installed agent can pull down the respective build, and deploy the web app to the environment.

### Alternatives

An App Service Environment can run regular web apps on Windows or, as in this example, web apps deployed inside the environment that are each running as Linux containers. An App Service Environment was selected to host these single-instance containerized applications. There are alternatives available&mdash;review the considerations below when designing your solution.

- [Azure Container Apps][docs-container-apps]: is a serverless platform that allows you to maintain less infrastructure and save costs while running containerized applications. Instead of worrying about server configuration, container orchestration, and deployment details, Container Apps provides all the up-to-date server resources required to keep your applications stable and secure.
- [Azure Kubernetes Service (AKS)][docs-kubernetes-service] is an open-source project and an orchestration platform more suited to hosting complex multicontainer applications that typically use a microservices-based architecture. AKS is a managed Azure service that abstracts away the complexities of provisioning and configuring a Kubernetes cluster. However, significant knowledge of the Kubernetes platform is required to support and maintain it, so hosting a handful of single-instance containerized web applications might not be the best option.

Other options for the data tier include:

- [Azure Cosmos DB](/azure/cosmos-db/introduction): If most of your data is in non-relational format, Azure Cosmos DB is a good alternative. This service provides a platform to run other data models such as MongoDB, Cassandra, Graph data, or simple table storage.

## Address TLS and DNS design decisions

The DNS settings for your App Service Environment's default domain suffix don't restrict your applications to only being accessible by those names. The custom domain suffix feature for an internal load balancer (ILB) App Service Environment allows you to use your own domain suffix to access the applications hosted in your App Service Environment.

A custom domain suffix defines a root domain used by the App Service Environment. For an ILB App Service Environment the default root domain is appserviceenvironment.net. Since an ILB App Service Environment is internal to a customer's virtual network, customers can use a root domain in addition to the default one that makes sense within their virtual network environment. For example, a hypothetical Contoso Corporation might use a default root domain of internal.contoso.com for apps that are intended to only be resolvable and accessible within Contoso's virtual network. An app in this virtual network could be reached by accessing APP-NAME.internal.contoso.com. The custom domain suffix is for the App Service Environment. This feature is different from a custom domain binding on an App Service. If the certificate used for the custom domain suffix contains a Subject Alternate Name (SAN) entry for *.scm.CUSTOM-DOMAIN, the scm site is also reachable from APP-NAME.scm.CUSTOM-DOMAIN. You can only access scm over custom domain using basic authentication. Single sign-on is only possible with the default root domain.

There are certain considerations when dealing with certificates on an ILB App Service Environment.

- Valid SSL/TLS certificate must be stored in an Azure Key Vault in .PFX format.
- Certificate must be less than 20 kb.
- Your certificate must be a wildcard certificate for the selected custom domain name.
- You need to configure a system assigned or user assigned managed identity for your App Service Environment. The managed identity is used to authenticate against the Azure Key Vault where the SSL/TLS certificate is stored.
- If you rotate your certificate in Azure Key Vault, the App Service Environment picks up the change within 24 hours.

### Network Access to Key Vault

- The key vault can be accessed publicly or through a private endpoint accessible from the subnet that the App Service Environment is deployed to.
- If you use public access, you can secure your key vault to only accept traffic from the outbound IP address of the App Service Environment.
- The App Service Environment uses the platform outbound IP address as the source address when accessing the key vault. You can find the IP address in the IP Addresses page in Azure portal.

### DNS Configuration

To access your applications in your App Service Environment using your custom domain suffix, you need to either configure your own DNS server or configure DNS in an Azure private DNS zone for your custom domain. For details on how to configure DNS for your custom domain suffix refer to the documentation [here][ase-dns-configuration].

### Secure Unique Default Hostname

The secure unique default hostname feature is a long-term solution to protect your resources from dangling DNS entries and subdomain takeover. If you have this feature enabled for your App Service resources, then no one outside of your organization would be able to recreate resources with the same default hostname. This means that malicious actors can no longer take advantage of your dangling DNS entries and takeover your subdomains. Refer to the announcement [here][secure-default-hostnames] for additional details.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Consider using [Geo Distributed Scale with App Service Environments][design-geo-distributed-ase] for greater resiliency and scalability.
- Review the [typical design patterns for resiliency](/azure/well-architected/reliability/design-patterns) and consider implementing these where appropriate.
- You can find several [recommended practices for App Service][resiliency-app-service] in the Azure Architecture Center.
- Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redudancy] storage for images and queues.

#### Availability

- Consider applying the [typical design patterns for availability](/azure/well-architected/reliability/design-patterns) when building your cloud application.
- Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- For other considerations concerning availability, see the [availability checklist](../../checklist/resiliency-per-service.md) in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- Consider following a [secure development lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Explore the cost of running this scenario. All of the services are pre-configured in the cost calculator. To see how pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We've provided three sample cost profiles based on amount of traffic you expect to get:

- [Small][small-pricing]: This pricing example represents the components necessary for a minimum production-level instance serving a few thousand users per month. The app is using a single small instance of an isolated web app. Each of the other components is scaled to a Basic tier that will minimize cost but still ensure that there's service-level agreement (SLA) support and enough capacity to handle a production-level workload.
- [Medium][medium-pricing]: This pricing example represents the components needed for a moderate size deployment. Here we estimate approximately 100,000 users over the course of a month. The expected traffic is handled by a moderately sized single isolated App Service instance. Additionally, the capacity of the Application Gateway and Azure SQL Database are increased to support the added workload.
- [Large][large-pricing]: This pricing example represents an application meant for high scale, at the order of millions of users per month, moving terabytes of data. At this level of usage, high performance, isolated tier web apps deployed in multiple regions fronted by Traffic Manager are required. An additional Application Gateway and Virtual Network are added to the estimate. An Azure Traffic Manager is also included in the solution. The capacity of the Azure SQL Database is increased to support the additonal workload.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Understand how [scale works][docs-azure-scale-ase] in App Service Environments.
- Review best practices for [cloud apps autoscale][design-best-practice-cloud-apps-autoscale].
- When building a cloud application, be aware of the [typical design patterns for scalability](/azure/well-architected/performance-efficiency/design-patterns).
- Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Faisal Mustafa | Senior Customer Engineer

## Next steps

- [Integrate your ILB App Service Environment with the Azure application gateway][integrate-ilb-ase-with-appgw]
- [Geo distributed scale with App Service Environments][design-geo-distributed-ase]

## Related resources

- [App Service web application reference architecture][app-service-reference-architecture]
- [high-availability enterprise deployment using App Services Environment](/azure/architecture/web-apps/app-service-environment/architectures/ase-high-availability-deployment)

<!-- links -->

[intro-to-app-svc-env]: /azure/app-service/environment/overview
[create-wildcard-cert-letsencrypt]: /archive/blogs/mihansen/creating-wildcard-ssl-certificates-with-lets-encrypt
[ase-and-internally-issued-cert]: https://www.patrickob.com/2018/11/10/adding-ca-certs-to-the-trusted-root-store-for-web-apps-hosted-in-an-ase
[isolated-tier-pricing-and-ase-pricing]: https://azure.microsoft.com/pricing/details/app-service/windows
[bring-your-own-dns]: /azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#specify-dns-servers
[private-zones]: /azure/dns/private-dns-overview
[create-ilb-ase]: /azure/app-service/environment/creation
[azure-networking]: /azure/well-architected/service-guides/virtual-network
[sql-service-endpoint]: /azure/sql-database/sql-database-vnet-service-endpoint-rule-overview
[ase-dns-configuration]: /azure/app-service/environment/how-to-custom-domain-suffix?pivots=experience-azp#dns-configuration
[secure-default-hostnames]: https://techcommunity.microsoft.com/blog/appsonazureblog/secure-unique-default-hostnames-ga-on-app-service-web-apps-and-public-preview-on/4303571

[architecture]: ./media/fully-managed-secure-apps.svg
[small-pricing]: https://azure.com/e/9563539d508a4b68853a6b3c5168431e
[medium-pricing]: https://azure.com/e/c3fb0809853c4cbabdcecae279dafe1f
[large-pricing]: https://azure.com/e/42f54342044846e3bfb42f9f66847054
[app-service-reference-architecture]: /azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant
[design-geo-distributed-ase]: /azure/app-service/environment/app-service-app-service-environment-geo-distributed-scale
[design-best-practice-cloud-apps-autoscale]: ../../best-practices/auto-scaling.md

[docs-sql-database]: /azure/well-architected/service-guides/azure-sql-database-well-architected-framework
[docs-webapps]: /azure/well-architected/service-guides/app-service-web-apps
[docs-apiapps]: /azure/app-service/app-service-web-tutorial-rest-api
[docs-appgw]: /azure/well-architected/service-guides/azure-application-gateway
[docs-waf]: /azure/web-application-firewall/ag/ag-overview
[docs-azure-devops]: /azure/devops/user-guide/what-is-azure-devops
[docs-azure-vm]: /azure/well-architected/service-guides/virtual-machines
[docs-azure-scale-ase]: /azure/app-service/environment/overview
[docs-service-fabric]: /azure/service-fabric
[docs-kubernetes-service]: /azure/aks
[docs-container-apps]: /azure/container-apps

[integrate-ilb-ase-with-appgw]: /azure/app-service/environment/integrate-with-application-gateway
[pci-dss-blueprint]: /azure/security/blueprints/payment-processing-blueprint
[resiliency-app-service]: ../../checklist/resiliency-per-service.md#app-service
[resiliency]: /azure/architecture/framework/resiliency/principles
[secure-development]: https://www.microsoft.com/SDL/process/design.aspx
[sql-geo-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redudancy]: /azure/storage/common/storage-redundancy-grs
[visio-download]: https://arch-center.azureedge.net/fully-managed-secure-apps.vsdx
