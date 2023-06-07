This article describes how to achieve Trusted Internet Connections (TIC) 3.0 compliance for internet-facing Azure applications and services. It provides solutions and resources to help government organizations meet TIC 3.0 compliance. It also describes how to deploy the required assets and how to incorporate the solutions into existing systems.

> [!NOTE] 
> Microsoft provides this information to Federal Civilian Executive Branch (FCEB) departments and agencies as part of a suggested configuration to facilitate participation in the Cybersecurity and Infrastructure Security Agency (CISA) Cloud Log Aggregation Warehouse (CLAW) capability. The suggested configurations are maintained by Microsoft and are subject to change.

## Architecture

:::image type="content" source="media/trusted-internet-connections.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture." border="false" lightbox="media/trusted-internet-connections.png":::

*Download a [Visio file](https://arch-center.azureedge.net/TIC_3.0-AzureReferenceArchitecture.vsdx)  of this architecture.*

### Dataflow

1. Firewall
   - The firewall can be any layer 3 or layer 7 firewall. 
     - Azure Firewall and some third-party firewalls, also known as Network Virtual Appliances (NVAs), are layer 3 firewalls. 
     - Azure Application Gateway with Web Application Firewall (WAF) and Azure Front Door with WAF are layer 7 firewalls. 
     - This article provides deployment solutions for Azure Firewall, Application Gateway with WAF, and Azure Front Door with WAF deployments.
   - The firewall enforces policies, collects metrics, and logs connection transactions between web services and the users and services that access the web services.
1. Firewall logs
   - Azure Firewall, Application Gateway with WAF, and Azure Front Door with WAF send logs to the Log Analytics workspace.
   - Third-party firewalls send logs in Syslog format to the Log Analytics workspace via a Syslog forwarder virtual machine.
1. Log Analytics workspace
   - The Log Analytics workspace is a repository for logs.
   - It can host a service that provides custom analysis of the network traffic data from the firewall.
1. Service principal (registered application)
1. Azure Event Hubs Standard
1. CISA TALON

### Components

- Firewall. Your architecture will use one or more of the following firewalls. (For more information, see the [Alternatives](#alternatives) section of this article.) 
  - [Azure Firewall](https://azure.microsoft.com/products/azure-firewall) is a cloud-native, intelligent network firewall security service that provides enhanced threat protection for cloud workloads that run on Azure. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. It's available in two performance tiers: Standard and Premium. Azure Firewall Premium includes all the functionality of Azure Firewall Standard and provides additional features like Transport Layer Security (TLS) inspection and an intrusion detection and prevention system (IDPS).
  - [Application Gateway](https://azure.microsoft.com/products/application-gateway/) with [WAF](/azure/web-application-firewall/overview) is a regional web traffic load balancer that enables you to manage traffic to your web applications. WAF provides enhanced centralized protection of your web applications from common exploits and vulnerabilities. 
  - [Azure Front Door](https://azure.microsoft.com/products/frontdoor/) with [WAF](/azure/web-application-firewall/overview) is a global web traffic load balancer that enables you to manage traffic to your web applications. It provides content delivery network (CDN) capabilities to speed up and modernize your applications. WAF provides enhanced centralized protection of your web applications from common exploits and vulnerabilities. 
  - A third-party firewall is an NVA that runs on an Azure virtual machine and uses firewall services from non-Microsoft vendors. Microsoft supports a large ecosystem of third-party vendors that provide firewall services. 
- Logging and authentication.
  - Log Analytics is a tool that's available in the Azure portal that you can use to edit and run log queries against Azure Monitor Logs. For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).
  - [Azure Monitor](https://azure.microsoft.com/services/monitor) is a comprehensive solution for collecting, analyzing, and acting on telemetry.
  - [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) provides identity services, single sign-on, and multifactor authentication across Azure workloads.
  - A [service principal](/azure/active-directory/develop/app-objects-and-service-principals) (registered application) is an entity that defines the access policy and permissions for a user or application in an Azure AD tenant.
  - [Event Hubs Standard](https://azure.microsoft.com/products/event-hubs) is a modern big data streaming platform and event ingestion service.
  - CISA TALON is a CISA-operated service that runs on Azure. TALON connects to your Event Hubs service, authenticates by using a CISA-supplied certificate that's associated with your service principal, and collects logs for CLAW consumption.

### Alternatives

There are a few alternatives that you can use in these solutions:

- You can separate log collection into areas of responsibility. For example, you can send Azure AD logs to a Log Analytics workspace that's managed by the identity team, and send network logs to a different Log Analytics workspace that's managed by the network team.
- The examples in this article each use a single firewall, but some organizational requirements or architectures require two or more. For example, an architecture can include an Azure Firewall instance and an Application Gateway instance with WAF. Logs for each firewall must be collected and made available for CISA TALON to collect.
- If your environment requires internet egress from Azure-based virtual machines, you can use a layer 3 solution like Azure Firewall or a third-party firewall to monitor and log the outbound traffic.

## Scenario details

TIC 3.0 moves TIC from on-premises data collection to a cloud-based approach that better supports modern applications and systems. It improves performance because you can directly access Azure applications. With TIC 2, you need to access Azure applications via a TIC 2 Managed Trusted Internet Protocol Service (MTIPS) device, which increases response time.

Routing application traffic through a firewall and logging that traffic is the core functionality demonstrated in the solutions presented here. The firewall can be Azure Firewall, Azure Front Door with WAF, Application Gateway with WAF, or a third-party NVA. The firewall helps to secure the cloud perimeter and saves logs of each transaction. Independently of the firewall layer, the log collection and delivery solution requires a Log Analytics workspace, a registered application, and an event hub. The Log Analytics workspace sends logs to the event hub.  

CLAW is a CISA managed service. In late 2022, CISA released TALON. TALON is a CISA managed service that uses Azure native capabilities. An instance of TALON runs in each Azure region. TALON connects to event hubs that are managed by government agencies to pull agency firewall and  Azure AD logs into CISA CLAW.

For more information on CLAW, TIC 3.0, and MTIPS, see:

- [Trusted Internet Connections guidance](/azure/azure-government/compliance/compliance-tic)
- [TIC 3.0 core guidance documents](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS)](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)

### Potential use cases

TIC 3.0 compliance solutions are commonly used by federal organizations and government agencies for their Azure-based web applications and API services.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

- Evaluate your current architecture to determine which of the solutions presented here provides the best approach to TIC 3.0 compliance.
- Contact your CISA representative to request access to CLAW.
- Use the **Deploy to Azure** buttons in this article to deploy one or more of the solutions in a test environment. Doing so should help you become familiar with the process and the deployed resources.
- See [TIC 3.0 compliance for internet-facing applications](https://github.com/Azure/trusted-internet-connection), a complimentary article that provides more  details and assets for TIC 3.0:
  - Additional information about achieving compliance.
  - ARM templates to simplify deployment.
  - Information to assist with integrating existing resources into the solution.
  - The types of logs collected for each service layer and Kusto queries for reviewing logs collected by CISA. You can use the queries for your organization's security requirements.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Azure Firewall Standard and Premium integrate with availability zones to increase availability.
- Application Gateway v2 supports autoscaling and availability zones to increase reliability.
- Multi-region implementations that include load balancing services like Azure Front Door can improve reliability and resiliency.
- Event Hubs Standard and Premium provide Geo-disaster recovery pairing that enables a namespace to fail over to a secondary region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- When you register an enterprise application, a service principal is created. Use a naming scheme for service principals that indicates the purpose of each one.
- Perform audits to determine the activity of service principals and the status of service principal owners.
- Azure Firewall has standard policies. WAFs associated with Application Gateway and Azure Front Door have managed rule sets to help secure your web service. Start with these rule sets and build organizational policies over time based on industry requirements, best practices, and government regulations.
- Event Hubs access is authorized via Azure AD managed identities and a certificate that's provided by CISA.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The cost of each solution scales down as the resources increase. The pricing in this [Azure pricing calculator example scenario](https://azure.com/e/2554c32b19c24b3d9f90d2a73683bd6a) is based on the Azure Firewall solution. If you change the configuration, costs might increase. With some plans, costs increase as the number of ingested logs increase.

> [!NOTE]
> Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to get up-to-date pricing that's based on the resources that are deployed for the selected solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) are built into the solutions to notify you when an upload fails to deliver logs to CLAW. You need to determine the severity of the alerts and how to respond.
- You can use ARM templates to speed up the deployment of TIC 3.0 architectures for new applications.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- [Azure Firewall](/azure/firewall/firewall-performance), [Application Gateway](/azure/application-gateway/application-gateway-faq#performance), [Azure Front Door](/azure/frontdoor/scenarios#performance-efficiency), and [Event Hubs](/azure/architecture/serverless/event-hubs-functions/performance-scale) performance scales as usage increases.
- Azure Firewall Premium allows more TCP connections than Standard and provides increased bandwidth.
- Application Gateway v2 automatically ensures that new instances are spread across fault domains and update domains. 
- Azure Front Door provides caching, compression, traffic acceleration, and TLS termination to improve performance.
- Event Hubs Standard and Premium provide auto-inflate to scale up as load increases.

## Deploy an Azure Firewall solution

The following solution uses Azure Firewall to manage traffic entering your Azure application environment. The solution includes all resources for generating, collecting, and delivering logs to CLAW. It also includes an app service to track the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connections-azure-firewall.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Azure Firewall uploads logs to CLAW." border="false" lightbox="media/trusted-internet-connections-azure-firewall.png":::

 The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- Azure Firewall with a network policy for internet access.
- Azure Firewall diagnostic settings that send logs to the Log Analytics workspace.
- A route table that's associated with the application resource group to route the app service to the firewall for the logs it generates.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

For the sake of simplicity, all resources are deployed to a single subscription and virtual network. You can deploy the resources in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connections-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Firewall%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Government](media/trusted-internet-connections-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Firewall%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks 

After deployment, your environment performs the firewall capabilities and logging connections. To meet compliance with TIC 3.0 policies for network telemetry collection, you need to ensure that the logs make it to CISA CLAW. The post-deployment steps finish the tasks to enable compliance. To complete these steps, you need to coordinate with CISA because CISA needs to supply a certificate to associate with your service principal. For step-by-step details, see [Post-deployment tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

You need to complete the following tasks after deployment. You need to perform these tasks manually. You can't complete them by using an ARM template.

- Obtain a public key certificate from CISA. 
- Create a service principal (application registration).
- Add the public key certificate to the application registration.
- Assign the application the Azure Event Hubs Data Receiver role at the Event Hubs namespace scope.
- Activate the feed by sending the Azure tenant ID, application (client) ID, event hub namespace name, event hub name, and consumer group name to CISA.

## Deploy a solution that uses Application Gateway with WAF

The following solution uses Application Gateway with WAF to manage traffic entering your Azure application environment. The solution includes all resources for generating, collecting, and delivering logs to CLAW. It also includes an app service to track the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connections-architecture-application-gateway.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Application Gateway with WAF uploads logs to CLAW." border="false" lightbox="media/trusted-internet-connections-architecture-application-gateway.png"::: 

The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Application Gateway v2 instance with WAF that's configured with bot and Microsoft managed policies.
- Application Gateway v2 diagnostic settings that send logs to the Log Analytics workspace.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

For the sake of simplicity, all resources are deployed to a single subscription and virtual network. You can deploy the resources in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connections-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Application-Gateway%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Government](media/trusted-internet-connections-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Application-Gateway%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks  

After deployment, your environment performs the firewall capabilities and logging connections. To meet compliance with TIC 3.0 policies for network telemetry collection, you need to ensure that the logs make it to CISA CLAW. The post-deployment steps finish the tasks to enable compliance. To complete these steps, you need to coordinate with CISA because CISA needs to supply a certificate to associate with your service principal. For step-by-step details, see [Post-deployment tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

You need to complete the following tasks after deployment. You need to perform these tasks manually. You can't complete them by using an ARM template.

- Obtain a public key certificate from CISA. 
- Create a service principal (application registration).
- Add the public key certificate to the application registration.
- Assign the application the Azure Event Hubs Data Receiver role at the Event Hubs namespace scope.
- Activate the feed by sending the Azure tenant ID, application (client) ID, event hub namespace name, event hub name, and consumer group name to CISA.

## Deploy a solution that uses Azure Front Door with WAF

The following solution uses Azure Front Door with WAF to manage traffic entering your Azure application environment. The solution includes all resources for generating, collecting, and delivering logs to CLAW. It also includes an app service to track the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connections-architecture-front-door.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Azure Front Door with WAF uploads logs to CLAW." border="false" lightbox="media/trusted-internet-connections-architecture-front-door.png":::

 The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Azure Front Door instance with WAF that's configured with bot and Microsoft managed policies.
- Azure Front Door diagnostic settings that send logs to the Log Analytics workspace.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

For the sake of simplicity, all resources are deployed to a single subscription and virtual network. You can deploy the resources in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connections-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Front-Door%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Government](media/trusted-internet-connections-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Front-Door%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks

After deployment, your environment performs the firewall capabilities and logging connections. To meet compliance with TIC 3.0 policies for network telemetry collection, you need to ensure that the logs make it to CISA CLAW. The post-deployment steps finish the tasks to enable compliance. To complete these steps, you need to coordinate with CISA because CISA needs to supply a certificate to associate with your service principal. For step-by-step details, see [Post-deployment tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

You need to complete the following tasks after deployment. You need to perform these tasks manually. You can't complete them by using an ARM template.

- Obtain a public key certificate from CISA. 
- Create a service principal (application registration).
- Add the public key certificate to the application registration.
- Assign the application the Azure Event Hubs Data Receiver role at the Event Hubs namespace scope.
- Activate the feed by sending the Azure tenant ID, application (client) ID, event hub namespace name, event hub name, and consumer group name to CISA.

## Third-party firewall (NVA) solution

> [!NOTE]
> Deployment resources aren't provided for this solution. It's intended only to provide guidance.

The following solution illustrates how you can use a third-party firewall to manage traffic entering your Azure application environment and implement TIC 3.0 compliance. Third-party firewalls require the use of a Syslog forwarder virtual machine. Its agents need to be registered with the Log Analytics workspace. The third-party firewall is configured to export its logs in Syslog format to the Syslog forwarder virtual machine. The agent is configured to send its logs to the Log Analytics workspace. After the logs are in the Log Analytics workspace, they're sent to Event Hubs and processed as they are in the other solutions described in this article.

:::image type="content" source="media/trusted-internet-connections-architecture-nva.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. A third-party firewall uploads logs to CLAW." border="false" lightbox="media/trusted-internet-connections-architecture-nva.png":::

### Post-deployment tasks

After deployment, your environment performs the firewall capabilities and logging connections. To meet compliance with TIC 3.0 policies for network telemetry collection, you need to ensure that the logs make it to CISA CLAW. The post-deployment steps finish the tasks to enable compliance. To complete these steps, you need to coordinate with CISA because CISA needs to supply a certificate to associate with your service principal. For step-by-step details, see [Post-deployment tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

You need to complete the following tasks after deployment. You need to perform these tasks manually. You can't complete them by using an ARM template.

- Obtain a public key certificate from CISA.
- Create a service principal (application registration).
- Add the public key certificate to the application registration.
- Assign the application the Azure Event Hubs Data Receiver role at the Event Hubs namespace scope.
- Activate the feed by sending the Azure tenant ID, application (client) ID, event hub namespace name, event hub name, and consumer group name to CISA.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Paul Lizer](https://www.linkedin.com/in/paullizer) | Senior Cloud Solution Architect

Other contributor:

* [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [TIC 3.0 core guidance documents](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS)](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)
- [Azure Trusted Internet Connection - Extended](https://github.com/Azure/trusted-internet-connection)
- [Federal App Innovation - TIC 3.0](https://github.com/microsoft/Federal-App-Innovation-Community/tree/main/topics/infrastructure/solutions/tic3.0)
- [What is Azure Firewall?](/azure/firewall/overview)
- [Azure Firewall documentation](/azure/firewall)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [Azure Front Door](/azure/frontdoor/front-door-overview)
- [Introduction to Azure WAF](/azure/web-application-firewall/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Azure Event Hubs?](/azure/event-hubs/event-hubs-about)
- [Overview of alerts in Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Application and service principal objects in Azure AD](/azure/active-directory/develop/app-objects-and-service-principals)
- [Use the portal to create an Azure AD application and service principal that can access resources](/azure/active-directory/develop/howto-create-service-principal-portal)
- [Register an application with the Microsoft identity platform](/graph/auth-register-app-v2)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Create resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups)
- [How to find your Azure AD tenant ID](/azure/active-directory/fundamentals/active-directory-how-to-find-tenant)
- [Collect Syslog data sources with the Log Analytics agent](/azure/azure-monitor/agents/data-sources-syslog)
- [Parse text data in Azure Monitor logs](/azure/azure-monitor/logs/parse-text)
- [Introduction to flow logging for network security groups](/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)
- [Deploy and configure Azure Firewall using the Azure portal](/azure/firewall/tutorial-firewall-deploy-portal)

## Related resources

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Securely managed web applications](../apps/fully-managed-secure-apps.yml)
- [Secure and govern workloads with network level segmentation](../../reference-architectures/hybrid-networking/network-level-segmentation.yml)
- [Improved-security access to multitenant web apps from an on-premises network](access-multitenant-web-app-from-on-premises.yml)