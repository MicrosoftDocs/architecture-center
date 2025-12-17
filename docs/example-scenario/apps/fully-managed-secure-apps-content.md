This article describes how to deploy secure applications by using the [App Service Environment][intro-to-app-svc-env]. This architecture uses [Azure Application Gateway][docs-appgw] and [Azure Web Application Firewall][docs-waf] to restrict application access from the internet. This article also explains how to integrate continuous integration and continuous deployment (CI/CD) with App Service Environments by using Azure DevOps.

Industries like banking and insurance often use this solution because customers value both platform-level and application-level security. To demonstrate these concepts, the following example application allows users to submit expense reports.

## Architecture

:::image type="complex" source="./media/fully-managed-secure-apps.svg" alt-text="Diagram that shows the example scenario architecture for a secure internal load balancer App Service Environment deployment." border="false" lightbox="./media/fully-managed-secure-apps.svg":::
This diagram begins with an employee that accesses the Azure virtual network from an on-premises environment by using the IP range 192.168.0.0/16. This connection routes through a gateway via either ExpressRoute or a site-to-site VPN, which links to the gateway subnet (10.0.255.224/27) within the Azure virtual network (10.0.0.0/16). The gateway subnet contains a VPN gateway. From the gateway subnet, traffic flows into the web tier subnet (10.0.1.0/24), which hosts an App Service Environment. This environment is connected through an internal load balancer. Next to this subnet is the CI/CD subnet (10.0.2.0/24), which includes an Azure DevOps agent. External customers access services over the public internet. Their traffic is first filtered through DDoS protection before reaching the Application Gateway subnet (10.0.3.0/24). This subnet contains an application gateway equipped with a web application firewall and a layer-7 load balancer. The App Service Environment connects to an external Azure SQL database via virtual network service endpoints. The Azure DevOps agent connects to an external Azure DevOps instance.
:::image-end:::

*Download a [Visio file][visio-download] of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. HTTP and HTTPS requests reach the application gateway.

1. Optionally, Microsoft Entra authentication is enabled for the web app. After the traffic reaches the application gateway, the user is prompted to supply credentials to authenticate with the application. The diagram doesn't show this step.
1. The user requests flow through the internal load balancer (ILB) of the environment, which routes the traffic to the expenses web app.
1. The user creates an expense report.
1. As part of creating the expense report, the deployed API app is invoked to retrieve the user's manager name and email.
1. The system stores the expense report in Azure SQL Database.
1. To facilitate continuous deployment, code is checked into the Azure DevOps instance.
1. The build virtual machine (VM) includes the Azure DevOps agent. This agent enables the build VM to pull the web app artifacts and use them to deploy the web app to the App Service Environment. The build VM resides in a subnet within the same virtual network as the App Service Environment.

### Components

- The [App Service Environment][intro-to-app-svc-env] provides a fully isolated, dedicated environment to securely run the application at high scale. Both the App Service Environment and its workloads reside behind a virtual network, so the setup adds an extra layer of security and isolation. This scenario uses an ILB App Service Environment to meet the need for high scale and isolation.

- This workload uses the [App Service Isolated pricing tier][isolated-tier-pricing-and-ase-pricing]. The application runs in a private dedicated environment in an Azure datacenter that uses faster processors and solid-state drive (SSD) storage, and provides the maximum scale-out capabilities.
- The [Web Apps][docs-webapps] and [API Apps][docs-apiapps] features of App Service host web applications and RESTful APIs. These apps and APIs are hosted on the Isolated service plan, which also provides autoscaling, custom domains, and other capabilities in a dedicated tier.
- [Application Gateway][docs-appgw] is a layer-7 web traffic load balancer that manages traffic to the web application. It provides Secure Sockets Layer (SSL) offloading, which removes the overhead of decrypting traffic from the web servers that host the application.
- [Web Application Firewall][docs-waf] is a feature of Application Gateway that enhances security. The web application firewall uses Open Worldwide Application Security Project (OWASP) rules to protect the web application against attacks, such as cross-site scripting, session hijacks, and SQL injection.
- [SQL Database][docs-sql-database] stores the application's data. Most of the data is relational, with some of the data stored as documents and blobs.
- [Azure Virtual Network][azure-networking] provides various networking capabilities in Azure. You can peer virtual networks together and establish connections with on-premises datacenters via ExpressRoute or a site-to-site virtual private network (VPN). This scenario enables a [service endpoint][sql-service-endpoint] on the virtual network to ensure that the data flows only between the Azure virtual network and the SQL Database instance.
- [Azure DevOps][docs-azure-devops] supports agile development by helping teams collaborate during sprints and by providing tools to create build and release pipelines.
- An Azure build [VM][docs-azure-vm] enables the installed agent to pull down the respective build and deploy the web app to the environment.

### Alternatives

An App Service Environment can run regular web apps on Windows or, as in this example, web apps that run as Linux containers deployed inside the environment. This scenario uses an App Service Environment to host these single-instance containerized applications. Consider the following alternatives when you design your solution:

- [Azure Container Apps][docs-container-apps] is a serverless platform that reduces infrastructure overhead and saves cost while running containerized applications. It eliminates the need to manage server configuration, container orchestration, and deployment details. Container Apps provides all the up-to-date server resources required to keep your applications stable and secure.

- [Azure Kubernetes Service (AKS)][docs-kubernetes-service] is an open-source project and an orchestration platform designed to host complex multicontainer applications that typically use a microservices-based architecture. AKS is a managed Azure service that simplifies provisioning and configuring a Kubernetes cluster. You must have significant knowledge of the Kubernetes platform to support and maintain it, so hosting only a few single-instance containerized web applications might not be the best option.

Use the following alternative for the data tier:

- [Azure Cosmos DB](/azure/cosmos-db/introduction) is a good option if most of your data is in nonrelational format.

### Potential use cases

Consider this solution for the following use cases:

- Build an Azure web app that requires extra security.
- Provide dedicated tenancy rather than shared tenant App Service plans.
- Use Azure DevOps with an [internally load-balanced][create-ilb-ase] App Service Environment.

## Address TLS and DNS design decisions

The Domain Name System (DNS) settings for the default domain suffix of the App Service Environment don't restrict application reachability to those names. The custom domain suffix feature for an ILB App Service Environment allows you to use your own domain suffix to access the applications hosted in your App Service Environment.

A custom domain suffix defines a root domain that the App Service Environment uses. For an ILB App Service Environment, the default root domain is `appserviceenvironment.net`. An ILB App Service Environment is internal to a customer's virtual network, so customers can use a root domain in addition to the default domain that aligns with their virtual network environment. For example, Contoso Corporation might use a default root domain of `internal.contoso.com` for apps intended to be resolvable and reachable only within Contoso's virtual network. An app in this virtual network can be reached by accessing `APP-NAME.internal.contoso.com`.

The custom domain suffix applies to the App Service Environment. This feature differs from a custom domain binding on an individual App Service instance.

If the certificate used for the custom domain suffix contains a Subject Alternate Name (SAN) entry for `*.scm.CUSTOM-DOMAIN`, the Source Control Manager (SCM) site becomes reachable from `APP-NAME.scm.CUSTOM-DOMAIN`. You can only access SCM over custom domain by using basic authentication. Single sign-on is only available when you use the default root domain.

Consider the following factors when you manage certificates on an ILB App Service Environment:

- Store a valid SSL or Transport Layer Security (TLS) certificate in an Azure key vault in .PFX format.

- Ensure that the certificate is less than 20 KB.
- Use a wildcard certificate for the selected custom domain name.
- Configure a system-assigned or user-assigned managed identity for your App Service Environment. The managed identity authenticates against the Azure key vault where the SSL or TLS certificate resides.
- Expect the App Service Environment to apply certificate changes within 24 hours after rotation in a key vault.

### Network access to Azure Key Vault

- You can access the key vault publicly or through a private endpoint that's reachable from the subnet where the App Service Environment is deployed.

- If you use public access, you can secure your key vault to only accept traffic from the outbound IP address of the App Service Environment.
- The App Service Environment uses the platform outbound IP address as the source address when it accesses the key vault. You can find this IP address in the **IP Addresses** page in the Azure portal.

### DNS configuration

To access your applications in your App Service Environment by using your custom domain suffix, configure your own DNS server or configure DNS in an Azure private DNS zone for your custom domain. For more information, see [DNS configuration][ase-dns-configuration].

### Secure unique default hostname

The secure unique default hostname feature provides a long-term solution to protect your resources from dangling DNS entries and subdomain takeover. If you enable this feature for your App Service resources, no one outside your organization can recreate resources that have the same default hostname. This protection prevents malicious actors from exploiting dangling DNS entries and taking over subdomains. For more information, see [Secure unique default hostnames][secure-default-hostnames].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Consider using [geo-distributed scale with App Service Environments][design-geo-distributed-ase] for greater resiliency and scalability.

- Review the [typical design patterns for resiliency](/azure/well-architected/reliability/design-patterns) and implement them where appropriate.
- Consider using active [geo-replication][sql-geo-replication] for the data tier and [geo-redundant][storage-geo-redudancy] storage for images and queues.
- For more information, see the following resources:
  - [Enterprise web app patterns][docs-web-app-patterns]
  - [Reliability in App Service Environment][docs-reliability-ase]
  - [Configure App Service Environment for zone redundancy][docs-zone-redundancy-ase]

#### Availability

- Consider applying the [typical design patterns for availability](/azure/well-architected/reliability/design-patterns) when you build your cloud application.

- Review the availability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].
- For other availability considerations, see [Reliability guides by service](/azure/reliability/overview-reliability-guidance).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Review the security considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].

- Consider following the [Security Development Lifecycle][secure-development] process to help developers build more secure software and address security compliance requirements while reducing development cost.
- Use [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) and application-design best practices to improve protection against distributed denial-of-service (DDoS) attacks. Enable [DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on perimeter virtual networks.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Explore the cost of running this scenario. The following sample cost profiles are based on expected traffic. All services are preconfigured in the cost calculator.

- [Small deployment][small-pricing]: This pricing example represents the components for a minimum production-level instance that serves a few thousand users each month. The app uses a single small instance of an isolated web app. Each extra component scales to a Basic tier to minimize cost while ensuring service-level agreement (SLA) support and sufficient capacity to handle a production-level workload.

- [Medium deployment][medium-pricing]: This pricing example represents the components for a moderate-size deployment that serves approximately 100,000 users each month. A moderately sized single isolated App Service instance manages the traffic. The Application Gateway and SQL Database capacity increase to support the added workload.
- [Large deployment][large-pricing]: This pricing example represents the components for a high-scale application that serves millions of users each month and moves terabytes of data. This level of usage requires high-performance, isolated-tier web apps deployed in multiple regions and fronted by Azure Traffic Manager. The estimate includes Traffic Manager and extra Application Gateway and Virtual Network instances. The capacity of the SQL Database increases to support the added workload.

To see the pricing for your particular use case, change the appropriate variables to match your expected traffic.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Understand how [scale works][docs-azure-scale-ase] in App Service Environments.

- Review best practices for [cloud apps autoscale][design-best-practice-cloud-apps-autoscale].
- Understand the [typical design patterns for scalability](/azure/well-architected/performance-efficiency/design-patterns) when you build a cloud application.  
- Review the scalability considerations in the appropriate [App Service web application reference architecture][app-service-reference-architecture].

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- Nicholas McCollum | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Integrate your ILB App Service Environment with an Azure application gateway][integrate-ilb-ase-with-appgw]
- [Geo-distributed scale with App Service Environments][design-geo-distributed-ase]

## Related resources

- [App Service web application reference architecture][app-service-reference-architecture]
- [High-availability enterprise deployment via an App Service Environment](../../web-apps/app-service-environment/architectures/app-service-environment-high-availability-deployment.yml)

<!-- links -->

[intro-to-app-svc-env]: /azure/app-service/environment/overview
[isolated-tier-pricing-and-ase-pricing]: https://azure.microsoft.com/pricing/details/app-service/windows
[create-ilb-ase]: /azure/app-service/environment/creation
[azure-networking]: /azure/well-architected/service-guides/virtual-network
[sql-service-endpoint]: /azure/sql-database/sql-database-vnet-service-endpoint-rule-overview
[ase-dns-configuration]: /azure/app-service/environment/how-to-custom-domain-suffix?pivots=experience-azp#dns-configuration
[secure-default-hostnames]: https://techcommunity.microsoft.com/blog/appsonazureblog/secure-unique-default-hostnames-ga-on-app-service-web-apps-and-public-preview-on/4303571
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
[docs-azure-scale-ase]: /azure/app-service/environment/using#how-scale-works
[docs-kubernetes-service]: /azure/aks
[docs-container-apps]: /azure/container-apps
[docs-web-app-patterns]: /azure/architecture/web-apps/guides/enterprise-app-patterns/overview
[docs-reliability-ase]: /azure/reliability/reliability-app-service-environment
[docs-zone-redundancy-ase]: /azure/app-service/environment/configure-zone-redundancy-environment

[integrate-ilb-ase-with-appgw]: /azure/app-service/environment/integrate-with-application-gateway
[secure-development]: https://www.microsoft.com/SDL/process/design.aspx
[sql-geo-replication]: /azure/sql-database/sql-database-geo-replication-overview
[storage-geo-redudancy]: /azure/storage/common/storage-redundancy-grs
[visio-download]: https://arch-center.azureedge.net/fully-managed-secure-apps.vsdx
