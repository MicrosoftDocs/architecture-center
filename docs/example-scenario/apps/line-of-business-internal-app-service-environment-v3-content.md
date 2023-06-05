For customers in segments that are tightly governed and restricted by compliance, it's important to have an isolated and dedicated environment, especially for line-of-business applications. While security is front and center, these critical applications also require the ability to scale and perform under scenarios of high memory utilization or high requests per second. This solution provides an example for how you can host line-of-business applications. You can use Azure App Service Environment to ensure that both security and performance can be addressed simultaneously. When deploying this solution, you'll have the flexibility to use existing resources in your [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone), which represents your resources in the hub VNet. Or, you can deploy this solution as a self-contained workload.

> [!NOTE]
> This article provides a deployable architecture that aligns to our [Landing zone accelerator for App Service](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator).

## Architecture

:::image type="complex" source="./media/architecture-line-of-business-internal-app-service-environment-v3.png" alt-text="Diagram that shows the architecture of the App Service Environment v3 landing zone accelerator.":::
   The entirety of this image is in the scope of a subscription and a private DNS Zone. It's denoted by a subscription icon and a Private DNS zone icon in the top-left corner. Below these icons, two blocks are side by side. They represent two virtual networks, with VNet peering between them. The block on the left represents the hub VNet, and the block on the right represents the spoke VNet. Within the left box, there are three smaller boxes. Each box indicates a different subnet and its associated network security group. Starting from the top left is an Azure Bastion instance within the Bastion subnet, and the top right is the jumpbox VM, which resides in the jumpbox subnet. On the bottom right is the third and last box in the hub VNet, which contains the CI/CD agent server that resides in the CI/CD subnet. The box on the right, which represents the spoke VNet, contains only one smaller box, the ASE subnet that has the App Service Environment v3 instance within it. A smaller box represents the App Service Environment. The App Service icon is inside that box. On the bottom center of the image, are shared resources that are also deployed as part of the process. Starting from the left to right, the shared resources include Azure Key Vault, Azure Log Analytics workspace, and Azure Application Insights.
:::image-end:::

_Download a [Visio file](https://arch-center.azureedge.net/app-service-environment-v3.vsdx) of this architecture._

### Workflow

There are three flows with callouts in this architecture: Operations (orange), Deployment (green) and User (purple).

#### Operations

1. Operators or administrators will want to perform administration tasks on the continuous integration/continuous deployment (CI/CD) server, or on the Kudu endpoint for the App Service Environment (ASE). First, they'll need to connect to the Azure Bastion host.
2. By using the Bastion host, the operator or administrator can then use Remote Desk Protocol (RDP) to access the jumpbox server.
3. From the jumpbox server, the operator or administrator can RDP into the CI/CD server and perform the required tasks, such as agent upgrades, OS upgrades, and so on. The operator or administrator can also connect from the jumpbox server to the Kudu endpoint of the ASE instance, to perform administrative tasks or to perform advanced troubleshooting.

#### Deployment

1. Deployment of the solution is performed via the CI/CD agent server. The DevOps agent on this server will connect with Azure Pipelines when a new deployment is executed.
2. The artifacts will then be deployed to the App Service by connecting to the App Service Environment (ASE) over the VNet peering.

#### User

1. Users can connect to the deployed App Service over the company's network. They can use Azure ExpressRoute or a VPN if needed, and/or over any applicable Azure VNet peering.

### Components

The solution uses the following Azure services:

- **[Azure App Service Environment v3 (ASEv3)](/azure/app-service/environment/overview)** is a feature of [Azure App Service](https://azure.microsoft.com/services/app-service) and is a single-tenant service for customers that require high scale, network isolation, security, and/or high memory utilization. Apps are hosted in [App Service plans](/azure/app-service/overview-hosting-plans) that are created in ASEv3, with options of using different tiers within an Isolated v2 service plan. Compared to an earlier version of ASE, numerous improvements have been made including, but not limited to, network dependency, scale time, and the removal of the stamp fee. This solution uses an App Service Environment v3 that's configured for internal access.
  
 - **[Azure Private DNS](https://azure.microsoft.com/services/dns)** allows you to manage and resolve domain names within a virtual network, without needing to implement a custom DNS solution. An [Azure Private DNS zone](/azure/dns/private-dns-privatednszone) can be aligned to one or more virtual networks through [virtual network links](/azure/dns/private-dns-virtual-network-links). Due to the internal nature of the ASEv3 that this reference architecture uses, a private DNS zone is required to resolve the domain names of applications that are hosted on the App Service Environment.

- **[Azure Application Insights](/azure/azure-monitor/app/app-insights-overview)** is a feature of [Azure Monitor](https://azure.microsoft.com/services/monitor) that helps developers detect anomalies, diagnose issues, and understand usage patterns. Application Insights features extensible application performance management and monitoring for live web apps. Various platforms are supported, including .NET, Node.js, Java, and Python. It supports apps that are hosted in Azure, on-premises, in a hybrid environment, or in other public clouds. Application Insights is included as part of this reference architecture, to monitor the behaviors of the deployed application.

- **[Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)** is a feature of [Azure Monitor](https://azure.microsoft.com/services/monitor) that allows you to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform an advanced analysis. They can then visualize the results. Log Analytics is configured as part of this reference architecture, to aggregate all the monitoring logs for analysis and reporting.

- **[Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines)** is an on-demand, scalable computing resource that can be used to host several different workloads. In this reference architecture, virtual machines are used to provide a management jumpbox server, and to provide a host for the DevOps agent or GitHub runner. 

- **[Azure Key Vault](https://azure.microsoft.com/services/key-vault)** is a cloud service that securely stores and accesses secrets, which range from API keys and passwords to certificates and cryptographic keys. An Azure Key Vault is deployed as part of this architecture's infrastructure, to facilitate secret management for future code deployments. 

- **[Azure Bastion](https://azure.microsoft.com/services/azure-bastion)** is a platform-as-a-service that's provisioned within the developer's virtual network. It provides secure RDP/SSH connectivity to the developer's virtual machines over TLS, from the Azure portal. With Azure Bastion, virtual machines no longer require a public IP address to connect via RDP/SSH. This reference architecture uses Azure Bastion to access the DevOps agent or GitHub runner server or the management jumpbox server. 

### Alternatives

Consider adding an [Azure Application Gateway](/azure/application-gateway/overview) before the App Service instance, to provide Web Application Firewall (WAF) functionality to protect web applications from common exploits and vulnerabilities.

A [self-hosted GitHub runner](https://docs.github.com/enterprise-server@3.5/actions/using-github-hosted-runners) can be used in place of the Azure DevOps self-hosted agent.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Consider your requirements for zone redundancy in this reference implementation, as well as the zone redundancy capabilities of any other Azure Services in your solution. ASEv3 supports zone redundancy by spreading instances to all three zones in the target region. This configuration can only be set at the time of the ASE creation, and it might not be available in all regions. See more information, see [Availability zone support for App Service Environment](/azure/app-service/environment/overview-zone-redundancy). This reference implementation implements zone redundancy, but you can change it by cloning this repo and setting the `zoneRedundant` property to `false`.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Employ the appropriate use of access restrictions, so that the app service is only reachable from valid locations. For example, if the app service is hosting APIs, and it's fronted by APIM, you can set up an access restriction so that the app service is only accessible from APIM.
- Since this reference implementation deploys an ASE into a virtual network (referred to as an internal ASE), all applications deployed to the ASE are inherently network-isolated, at the scope of the virtual network.
- Store application secrets (database credentials, API tokens, and private keys) in Azure Key Vault. Configure your App Service app to access them securely with a managed identity. Determine when to use [Azure Key Vault vs Azure App Configuration](/azure/architecture/solution-ideas/articles/appconfig-key-vault).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Although there's no stamp fee for an ASEv3 instance, there's a charge that's levied when no App Service Plans are configured within the ASEv3 instance. This charge is levied at the same rate as one instance of a Windows I1v2 instance, for the region in which the ASEv3 instance is deployed.
- When configured to be zone redundant, the charging model is adjusted to account for the underlying infrastructure that's deployed in this configuration. You might be liable for additional instances, as per [ASEv3 Pricing](/azure/app-service/environment/overview#pricing).
- For ASEv3 App Service plans (known as Isolated v2 App Service plans), use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract and receive significant savings off pay-as-you-go prices. For more information, see [How reservation discounts apply to Isolated v2 instances](/azure/cost-management-billing/reservations/reservation-discount-app-service#how-reservation-discounts-apply-to-isolated-v2-instances).

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Use Application Insights or another application performance management solution to monitor and learn how your application behaves in different environments.
    - There are two ways to enable [Application Insights](/azure/azure-monitor/app/app-insights-overview). For different environments, collect telemetry data into different Application Insights instances.
    - If your application has multiple components separated into different services, you might want to examine their behavior together. Collect their telemetry data into the same Application Insights instance, but label them with different cloud role names.
    - Export the Application Insights data to an [Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) workspace. We recommend you use a single workspace for the organization.
    - Include operational dashboards in application and feature design, to ensure the solution can be supported in production.
    - Implement health checks for your endpoints, and then use them for health probes, dependency checks, and availability tests.
- Consider using prefixes and suffixes with well-defined conventions, to uniquely identify every deployed resource. These naming conventions avoid conflicts, when you deploy solutions next to each other and improve the overall team agility and throughput.
- Depending on the network configuration, App Service might not be reachable from the public internet, and the use of public hosted agents won't work for deployments. Use [self-hosted agents](https://azure.github.io/AppService/2021/01/04/deploying-to-network-secured-sites.html) in that scenario.

## Deploy this scenario

To get started and better understand the specifics of this implementation, review the reference implementation resources, at [User Guide for Reference Implementation Deployment](https://github.com/Azure/appservice-landing-zone-accelerator/tree/docs-update/docs).

- We recommend that you clone this repo and modify the reference implementation resources to suit your requirements and your organization's specific landing zone guidelines.
- Before deploying, ensure that the service principal that's used to deploy the solution has the required permissions to create the resource types that we listed above.
- Consider the CI/CD service that you'll use to deploy the reference implementation. As this reference implementation is an internal ASE, you'll need a self-hosted agent to execute the deployment pipelines. You have the choice to use either a DevOps agent or a GitHub runner. Refer to the [user guide](https://github.com/Azure/appservice-landing-zone-accelerator/tree/docs-update/docs) on the specific configuration values that are required.
- Consider the region(s) to which you intend to deploy this reference implementation. Consult the [ASEv3 Regions list](/azure/app-service/environment/overview#regions) to ensure the selected region(s) are enabled for deployment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Pete Messina](https://www.linkedin.com/in/peter-messina-93512414/) | Senoir Cloud Solution Architect
 - [Nabeel Prior](https://www.linkedin.com/in/nabeelprior/) | Senior Cloud Solution Architect

 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

* [Security in Azure App Service](/azure/app-service/overview-security)
* [Networking for App Service](/azure/app-service/networking-features)
* [Landing zone accelerator for App Service](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator)

Learn more about these key services:
* [Azure App Service Environment v3 (ASEv3)](/azure/app-service/environment/overview)
* [Azure Private DNS Zones](/azure/dns/private-dns-privatednszone)
* [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview)
* [Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)
* [Azure Virtual Machines overview](/azure/virtual-machines/windows/overview)
* [Azure Key Vault concepts](/azure/key-vault/general/basic-concepts)
* [Azure Bastion](/azure/bastion/bastion-overview)

## Related resources

* [High availability enterprise deployment using App Services Environment](/azure/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment)
* [Enterprise deployment using App Service Environment](/azure/architecture/reference-architectures/enterprise-integration/ase-standard-deployment)
* [High availability enterprise deployment using App Service Environment](/azure/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment)
* [E-commerce website running in secured App Service Environment](/azure/architecture/solution-ideas/articles/ecommerce-website-running-in-secured-ase)
