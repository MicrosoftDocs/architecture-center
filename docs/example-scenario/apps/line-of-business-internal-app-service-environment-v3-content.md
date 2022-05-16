For customers in segments tightly governed and restricted by compliance, having an isolated and dedicated environment is very important, especially for line of business applications. While security is front an center, these critical applications also require the ability to scale and perform under scenarios of high memory utilization or high requests per second. This solution provides an example for how customers are able to host line of business application using App Service Environments to ensure both security and performance can be addressed simultaneously. When deploying this solution, customers will have the flexibility to leverage existing resources in their [Azure Landing Zone](/azure/cloud-adoption-framework/ready/landing-zone/) (ie. Resources in the Hub VNet) if one exists or deploy this solution as a self-contained workload. 

## Architecture

![The entirety of this image is in the scope of a subscription and a private DNS Zone, denoted by a subscription icon and a a Private DNS zone icon in the top left corner. Below these icons two blocks side by side represent two virtual networks, with VNet peering between them. The block on the left represents the Hub VNet and the block on the right represents the Spoke VNet. Within the left box, there are three smaller boxes, each indicating a different subnet and its associated network security group. Starting from the top left is a Bastion instance within the Bastion subnet, and the top right being the Jumpbox VM residing in the Jumpbox subnet. On the bottom right is the third and last box in the Hub VNet, containing the CI/CD Agent server residing in the CI/CD subnet. The box on the right, representing the Spoke VNet, contains only one smaller box - the ASE subnet that has the App Service Environment v3 instance within. With a smaller box representing the App Service Environment, there is an App Service icon. On the bottom center of the image are shared resources that are also deployed as part of the process starting from left to right - Key Vault, Log Analytics Workspace, and Application Insights.](./media/architecture-line-of-business-internal-app-service-environment-v3.png)

_Download a [Visio file](https://arch-center.azureedge.net/architecture.vsdx) that contains this architecture diagram._

### Workflow
There are three flows that pertain to this architecture: Operations (items 1-3), Deployment (item 4) and User (item 5).

1. Operators or Administrators wanting to perform administration tasks on the CI/CD server would need to first connect to the Bastion Host.
2. Using the Bastion host, the operator or administrator can then RDP into the Jumpbox server.
3. From the Jumpbox server, the operator or administrator can RDP into the CI/CD server and perform the required tasks, such as agent upgrades, OS upgrades, etc.
4. Deployment of the solution is performed via the CI/CD Agent server. The agent on this server will interact with either an Azure DevOps pipeline or a GitHuv workflow when a new deployment is executed.  The agent will then deploy the App Service by connecting to the App Service Environment (ASE) over the VNet peering.
5. Users that want to connect to the deployed App Service will be able to do so over the company's network, using any existing Express Route or VPN if required, and/or over any applicable Azure VNet peering.

### Components

The solution uses the following Azure services:

- **[App Service Environment v3 (ASEv3)](/azure/app-service/environment/overview)** is a single tenant  service for customers that require high scale, network isolation and security, and/or high memory utilization. Apps are hosted in [App Service plans](/azure/app-service/overview-hosting-plans) created in ASEv3 with options of using different tiers within an Isolated v2 Service Plan. Compared to earlier version of ASE numerous improvements have been made including, but not limited to, network dependency, scale time, and the removal of the stamp fee. This solution uses an App Service Environment v3, configured for internal access. 
  
 - **[Azure Private DNS Zones](/azure/dns/private-dns-privatednszone)** allow users to manage and resolve domain names within a virtual network without needing to implement a custom DNS solution. A Private Azure DNS zone can be aligned to one or more virtual networks through [virtual network links](/azure/dns/private-dns-virtual-network-links). Due to the internal nature of the ASEv3 this reference architecture uses, a private DNS zone is required to resolve the domain names of applications hosted on the App Service Environment.

- **[Application Insights](/azure/azure-monitor/app/app-insights-overview)** is a feature of Azure Monitor that helps Developers detect anomalies, diagnose issues, and understand usage patterns with extensible application performance management and monitoring for live web apps. A variety of platforms including .NET, Node.js, Java, and Python are supported for apps that are hosted in Azure, on-prem, hybrid, or other public clouds. Application Insights is included as part of this reference architecture to monitor behaviors of the deployed application.

- **[Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)** is a feature of Azure Monitor that allows users to edit and run log queries with data in Azure Monitor Logs, optionally from within the Azure portal. Developers can run simple queries for a set of records or use Log Analytics to perform advanced analysis and visualize the results. Log Analytics is configured as part of this reference architecture to aggregate all the monitoring logs for additional analysis and reporting.

- **[Azure Virtual Machine](/azure/virtual-machines/windows/overview)** is an on-demand, scalable computing resource that can be used to host a number of different workloads. In this reference architecture, virtual machines are used to provide a management jumpbox server, and to provide a host for the DevOps Agent / GitHub Runner. 

- **[Azure Key Vault](/azure/key-vault/general/basic-concepts)** is a cloud service to securely store and access secrets ranging from API keys and passwords to certificates and cryptographic keys. While this reference architecture does not store secrets in Azure Key Vault, an Azure Key Vault is deployed as part of this architecture's infrastructure deployment to facilitate secret management for future code deployments. 

- **[Azure Bastion](/azure/bastion/bastion-overview)** is a Platform-as-a-Service service provisioned within the developer's virtual network which provides secure RDP/SSH connectivity to the developer's virtual machines over TLS from the Azure portal. With Azure Bastion, virtual machines no longer require a public IP address to connect via RDP/SSH. This reference architecture uses Azure Bastion to access the DevOps Agent / GitHub Runner server or the management jumpbox server. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).


### Reliability

- Consider your requirements for zone redundancy in this reference implementation, as well as the zone redundancy capabilities of any other Azure Services in your solution. ASEv3 supports zone redundancy by spreading instances to all three zones in the target region. This can only be set at the time of ASE creation, and may not be available in all regions. See [Availability zone support for App Service Environment](/azure/app-service/environment/overview-zone-redundancy) for more detail. This reference implementation does implement  zone redundancy, but this can be changed by cloning this repo and setting the `zoneRedundant` property to `false`.

### Security

- Employ the appropriate use of access restrictions so that the app service is only reachable from valid locations. For example, if the app service is hosting APIs, and is fronted by APIM, setup an access restriction so that the app service is only accessible from APIM.
- Since this reference implementation deploys an ASE into a virtual network (referred to as an internal ASE), all applications deployed to the ASE are inherently network-isolated at the scope of the virtual network.
- Store application secrets (database credentials, API tokens, private keys) in Azure Key Vault and configure your App Service app to access them securely with a Managed Identity. Determine when to use [Azure Key Vault vs Azure App Configuration](/azure/architecture/solution-ideas/articles/appconfig-key-vault) with the guidance in mind.

### Cost optimization

- While there is no stamp fee for an ASEv3 instance, there is a charge levied when there are no App Service Plans configured within the ASEv3 instance. This charge is levied at the same rate as one instance of a Windows I1v2 instance for the region in which the ASEv3 instance is deployed.
- When configured to be zone redundant, the charging model is adjusted to account for the underlying infrastructure deployed in this configuration, and you may therefore be liable for additional instances, as per [ASEv3 Pricing](/azure/app-service/environment/overview#pricing)
- Consider the option of reserved instance pricing for ASEv3 App Service Plans (aka Isolated v2 App Service Plans) as per [How reservation discounts apply to Isolated v2 instances](/azure/cost-management-billing/reservations/reservation-discount-app-service#how-reservation-discounts-apply-to-isolated-v2-instances)

### Operational excellence

- Use Application Insights or another Application Performance Management solution to monitor and learn how your application behaves in different environments.
    - Two ways to enable [Application Insights](/azure/azure-monitor/app/app-insights-overview) currently exist.
For different environments collect telemetry data into different Application Insights instances.
    - If your application has multiple components separated into different services but you would like to examine their behavior together, then collect their telemetry data into same Application Insights instance but label them with different cloud role names.
    - Export Application Insights data to an [Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) Workspace. A single Workspace for the organization is recommended.
    - Include operational dashboards in application and feature design to ensure the solution can be supported in production.
    - Implement health checks for your endpoints and use them for health probes, dependency checks and availability tests.
- Consider using prefixes and suffixes with well-defined conventions to uniquely identify every deployed resource. These naming conventions avoid conflicts when deploying solutions next to each other and improve overall team agility and throughput.
- Depending on the network configuration, App Services might not be reachable from the public internet and the use of public hosted agents will not work for deployments. Plan to use [self-hosted agents](https://azure.github.io/AppService/2021/01/04/deploying-to-network-secured-sites.html) in that scenario.


## Deploy this scenario

- Review the reference implementation resources at [LOB-ILB-ASEv3](https://github.com/Azure/appservice-landing-zone-accelerator/tree/docs-update/docs) to better understand the specifics of this implementation.
- It is recommended that you clone this repo and modify the reference implementation resources to suit your requirements and your organization's specific landing zone guidelines.
- Ensure that the service principal used to deploy the solution has the required permissions to create the resource types listed above.
- Consider the CI/CD service you will use for deploying the reference implementation. As this reference implementation is an internal ASE, a self-hosted agent is needed to execute the deployment pipelines.  As such there is a choice to use either a DevOps Agent or a GitHub Runner. Refer to the [user guide](https://github.com/Azure/appservice-landing-zone-accelerator/tree/docs-update/docs) on specific configuration values required for each.
- Consider the region(s) to which you intend deploying this reference implementation, and consult the [ASEv3 Regions list](/azure/app-service/environment/overview#regions) to ensure the selected region(s) are enabled for deployment.


## Next steps

* [Security in Azure App Service](/azure/app-service/overview-security)
* [Networking for App Service](/azure/app-service/networking-features)

## Related resources

* [High availability enterprise deployment using App Services Environment](docs/reference-architectures/enterprise-integration/ase-high-availability-deployment.yml)
* [Enterprise deployment using App Services Environment](docs/reference-architectures/enterprise-integration/ase-standard-deployment.yml)
* [Landing zone accelerator for App Service](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator)