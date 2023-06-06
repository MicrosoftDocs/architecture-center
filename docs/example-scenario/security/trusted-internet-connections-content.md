Version 3.0 of the Trusted Internet Connection (TIC) takes TIC from on-premises data collection to a cloud-based approach that better supports modern applications and systems. It improves performance because you can directly access Azure applications. With TIC 2.0+, users accessed Azure applications via a TIC 2.0+ Managed Trusted Internet Protocol Service (MTIPS) device, which increased response time.

You can deliver TIC 3.0 compliance for your internet-facing Azure applications and services. This article provides solutions and resources to guide government organizations to TIC 3.0 compliance. It shows how to deploy the required assets and how to incorporate the solutions into existing systems.

Routing application traffic through a firewall and logging that traffic is the core functionality demonstrated in each solution. The firewall can be Azure Firewall, Azure Front Door with Web Application Firewall (WAF), Azure Application Gateway with WAF, or a third-party network virtual appliance (NVA). The firewall helps to secure the cloud perimeter and saves logs of each transaction. Independently of the firewall layer, the log collection and delivery solution requires a Log Analytics workspace, a registered application, and an event hub. The Log Analytics workspace sends logs to the event hub.  

Cloud Log Aggregation Warehouse (CLAW) is a Cybersecurity and Infrastructure Security Agency (CISA) managed service. In late 2022, CISA released TALON. TALON is a CISA managed service that uses Azure native capabilities. An instance of TALON runs in each Azure region. TALON connects to event hubs that are managed by government agencies to pull agency firewall and Azure Active Directory (Azure AD) logs into CISA CLAW.

For more information on CLAW, TIC 3.0, and MTIPS, see:

- [Trusted Internet Connections guidance](/azure/azure-government/compliance/compliance-tic)
- [TIC 3.0 core guidance documents | CISA](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents| CISA](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN | CISA](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS) | GSA](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)

## Potential use cases

TIC 3.0 compliance solutions are commonly used by federal organizations and gevernment agencies for their Azure-based web applications and API services. 

> [!NOTE] 
> Microsoft provides this information to Federal Civilian Executive Branch (FCEB) departments and agencies as part of a suggested configuration to facilitate participation in CISA's CLAW capability. The suggested configurations are maintained by Microsoft and are subject to change.

## Architecture

:::image type="content" source="media/tlc-architecture.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture." border="false" lightbox="media/tlc-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/TIC_3.0-AzureReferenceArchitecture.vsdx)  of this architecture.*

### Dataflow

1. Firewall
   - The firewall can be any Layer 3 or Layer 7 firewall. 
     - Layer 3 firewalls are Azure Firewall or third-party firewall also known as Network Virtual Appliance (NVA). 
     - Layer 7 firewalls are Application Gateway with a Web Application Firewall (WAF) or Azure Front Door with WAF. This article covers the Azure Firewall, Application Gateway with WAF, and Azure Front Door with WAF.
   - The firewall enforces policies, collects metrics, and logs connection transactions between web services and the users and services that access the web services.
1. Firewall logs
   - Azure Firewall, Application Gateway with WAF, and Azure Front Door with WAF sends logs to the Log Analytics workspace.
   - Third-party firewalls send logs in syslog format to the Log Analytics workspace via a syslog forwarder virtual machine.
1. Log Analytics workspace
   - The Log Analytics workspace is a repository for logs.
   - It can host a service that provides custom analysis of the network traffic data from the firewall.
1. Service Principal (Registered Application)
1. Event Hubs Standard
1. CISA TALON

### Components

- Firewall (Select one type)
  - [Azure Firewall](https://learn.microsoft.com/en-us/azure/firewall/overview) is a cloud-native, intelligent network firewall security service that provides threat protection for cloud workloads that run in Azure. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. There are two performance tiers, Standard, and Premium. Azure Firewall Premium includes all the functionality of Azure Firewall Standard and has other features such as Transport Layer Security (TLS) inspection, and an intrusion detection and protection system (IDPS).
  - [Application Gateway](https://learn.microsoft.com/en-us/azure/application-gateway/overview) with [Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview) is a regional web traffic load balancer that enables you to manage traffic to your web applications. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities. 
  - [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview) with [Web Application Firewall](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview) is a global web traffic load balancer that enables you to manage traffic to your web applications. It includes Content Delivery Network (CDN) capabilities to speed up and modernize your applications. Web Application Firewall (WAF) provides centralized protection of your web applications from common exploits and vulnerabilities. 
  - Third-party Firewall is a Network Virtual Appliance (NVA) that runs on an Azure virtual machine using firewall services from non-Microsoft vendors. Microsoft supports a large ecosystem of third-party vendors running firewall services. 
- Logging and authentication (All required)
  - Log Analytics is a tool in the Azure portal that's used to edit and run log queries against Azure Monitor Logs. For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).
  - [Azure Monitor](https://azure.microsoft.com/services/monitor) is a comprehensive solution for collecting, analyzing, and acting on telemetry.
  - [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) provides identity services, single sign-on, and multifactor authentication across Azure workloads.
  - [Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals) (Registered Application) is an entity that defines the access policy and permissions for the user/application in the Azure AD tenant.
  - [Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) Standard is a modern big data streaming platform and event ingestion service.
  - CISA TALON is a CISA operated service running in Azure. TALON connects to the customer's Event Hubs, authenticates using a CISA supplied certificate associated with a customer's Service Principal, and collect the logs on behalf of the customer for CLAW consumption.

### Alternatives

A few alternatives exist for this solution:

- You can separate log collection into areas of responsibility. For instance, Azure AD logs can be sent to a Log Analytics workspace managed by an identity team, and network logs can be sent to a different Log Analytics workspace managed by the network team.
- This article defines each example using a single firewall option, but organizational requirements or architectures require two or more is acceptable. Should the architecture have an Azure Firewall then an Application Gateway with a WAF, that is acceptable. However many firewalls are used to secure the cloud perimeter, logs for each firewall must be collected and made available for the CISA TALON to collect.
- If your environment requires internet egress from Azure-based virtual machines, then you can use a Layer 3 based solution like Azure Firewall or a Third-party firewall to monitor and log the outbound traffic.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework).

- There are various solutions that you can deploy, depending on your current situation. Evaluate your current architecture to determine which solution provides your best approach to TIC 3.0 compliance.
- Contact your CISA representative to request CLAW access.
- Use the **Deploy to Azure** buttons to deploy one or more of the solutions to a test environment. That should help you become familiar with the process and the deployed resources.
- See [Trusted Internet Connection (TIC) 3.0 compliance for internet-facing applications](https://github.com/Azure/trusted-internet-connection), a complimentary article providing additional detail and dynamic content for TIC 3.0:
  - Additional information about achieving compliance.
  - ARM templates to simplify deployment.
  - Information to assist with integrating existing resources into the solution.
  - The types of logs collected per service layer includes Kusto queries to review logs collected by CISA. The queries can be leveraged for your organization's security requirements.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/devops/overview).

- [Azure Alerts](/azure/azure-monitor/alerts/alerts-overview) is built into the solution to notify you when an upload fails to deliver logs to the CLAW. It's up to you to determine the severity of alerts and how to respond.
- Use ARM templates to speed up the deployment of TIC 3.0 architectures for new applications.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](https://learn.microsoft.com/en-us/azure/architecture/framework/scalability/overview).

- [Azure Firewall](/azure/firewall/firewall-performance), [Application Gateway](/azure/application-gateway/application-gateway-faq#performance), [Azure Front Door](/azure/frontdoor/scenarios#performance-efficiency), and [Event Hubs](/azure/architecture/serverless/event-hubs-functions/performance-scale) performance scales as usage increases.
- Azure Firewall Premium allows more TCP connections than Standard and provides greater bandwidth.
- Application Gateway v2 automatically ensures that new instances are spread across fault domains and update domains. 
- Azure Front Door provides caching, compression, traffic acceleration, and TLS termination to improve performance.
- Event Hub standard and premium provide auto-inflate to scale up as load increases.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/overview).

- Azure Firewall Standard and Premium tiers integrate with availability zones to increase availability.
- Application Gateway v2 supports autoscaling and availability zones to increase reliability.
- Multi-region implementations that include load balancing services like Azure Front Door can improve reliability and resiliency.
- Event Hubs Standard and Premium provide Geo-disaster recovery pairing that allows the namespace to fail over to a secondary region.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/en-us/azure/architecture/framework/security/overview).

- Registering an enterprise application creates a service principal. Use a naming scheme for service principals that indicates their purpose.
- Perform audits to determine the activity of service principals and the status of service principal owners.
- Azure Firewall has standard policies. Web Application Firewalls (WAF) associated with Application Gateway and Azure Front Door has managed rule sets to secure your web service. Start with those and build organizational policies over time based on industry requirements, best practices, and government regulations.
- Event Hubs access is authorized using Azure Active Directory Managed Identities using a CISA provided certificate.

## Deploy an Azure Firewall solution

The following solution integrates Azure Firewall to manage the traffic into your Azure application environment. The solution includes all resources to generate, collect, and deliver logs to the CLAW. It also includes an app service to highlight the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connection-architecture-firewall.png" alt-text="Diagram of T I C 3 point 0 compliance architecture with Azure firewall uploading logs to CLAW." border="false" lightbox="media/trusted-internet-connection-architecture-firewall.png":::

 The solution includes:

- A virtual network with separate subnets for the firewall and servers.
- A Log Analytics workspace.
- Azure Firewall with a network policy for internet access.
- Azure Firewall diagnostic settings that send logs to the Log Analytics workspace.
- A route table associated with AppSubnet to route the app service to the firewall for the logs it generates.
- A registered application
- An Event Hubs
- An alert rule that sends an email if a job fails.

All resources are deployed to a single subscription and virtual network for simplicity. Resources could be deployed in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Firewall%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Gov](media/trusted-internet-connection-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Firewall%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks for all solutions

Up to now your environment is performing the firewall capabilities and logging connections. To be TIC 3.0 compliant for Network Telemetry collection, those logs must make it to CISA CLAW. The post-deployment steps finish the tasks towards compliance. These steps require coordination with CISA because you need a certificate from CISA to associate with your Service Principal. For step-by-step details, see [Post Deployment Tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

The following tasks must be performed after deployment is complete. They're manual tasks—an ARM template can't do them.

- Obtain a public key certificate from CISA. 
- Create a Service Principal (App Registration).
- Add the CISA-provided certificate to the App Registration.
- Assign the application with the Azure Event Hubs Data Receiver role to the Event Hubs Namespace.
- Activate Feed by sharing Azure Tenant ID, Application (client) ID, Event Hubs Namespace name, Event Hubs name, and Consumer group name with your CISA POC

## Deploy an Application Gateway with WAF solution

The following solution integrates an Application Gateway with Web Application Firewall (WAF) to manage the traffic into your Azure application environment. The solution includes all resources to generate, collect, and deliver logs to the CLAW. It also includes an app service to highlight the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connection-architecture-application-gateway.png" alt-text="Diagram of T I C 3 point 0 compliance architecture with Azure Application Gateway with Web Application Firewall uploading logs to CLAW." border="false" lightbox="media/trusted-internet-connection-architecture-application-gateway.png"::: 

The solution includes:

- A virtual network with separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Application Gateway v2 with Web Application Firewall with Bot and Microsoft managed policies.
- An Application Gateway v2 diagnostic settings that send logs to the Log Analytics workspace.
- A registered application
- An Event Hubs
- An alert rule that sends an email if a job fails.

All resources are deployed to a single subscription and virtual network for simplicity. Resources could be deployed in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Application-Gateway%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Gov](media/trusted-internet-connection-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Application-Gateway%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks for all solutions

Up to now your environment is performing the firewall capabilities and logging connections. To be TIC 3.0 compliant for Network Telemetry collection, those logs must make it to CISA CLAW. The post-deployment steps finish the tasks towards compliance. These steps require coordination with CISA because you need a certificate from CISA to associate with your Service Principal. For step-by-step details, see [Post Deployment Tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

The following tasks must be performed after deployment is complete. They're manual tasks—an ARM template can't do them.

- Obtain a public key certificate from CISA. 
- Create a Service Principal (App Registration).
- Add the CISA-provided certificate to the App Registration.
- Assign the application with the Azure Event Hubs Data Receiver role to the Event Hubs Namespace.
- Activate Feed by sharing Azure Tenant ID, Application (client) ID, Event Hubs Namespace name, Event Hubs name, and Consumer group name with your CISA POC

## Deploy an Azure Front Door with WAF solution

The following solution integrates an Azure Front Door with Web Application Firewall (WAF) to manage the traffic into your Azure application environment. The solution includes all resources to generate, collect, and deliver logs to the CLAW. It also includes an app service to highlight the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connection-architecture-front-door.png" alt-text="Diagram of T I C 3 point 0 compliance architecture with Azure Front Door with Web Application Firewall uploading logs to CLAW." border="false" lightbox="media/trusted-internet-connection-architecture-front-door.png":::

 The solution includes:

- A virtual network with separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Azure Front Door with Web Application Firewall with Bot and Microsoft managed policies.
- An Azure Front Door diagnostic settings that send logs to the Log Analytics workspace.
- A registered application
- An Event Hubs
- An alert rule that sends an email if a job fails.

All resources are deployed to a single subscription and virtual network for simplicity. Resources could be deployed in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Front-Door%2FComplete%2Fazuredeploy.json)

[![Deploy to Azure Gov](media/trusted-internet-connection-deploy-azure-government.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure-Front-Door%2FComplete%2Fazuredeploy.json)

### Post-deployment tasks for all solutions

Up to now your environment is performing the firewall capabilities and logging connections. To be TIC 3.0 compliant for Network Telemetry collection, those logs must make it to CISA CLAW. The post-deployment steps finish the tasks towards compliance. These steps require coordination with CISA because you need a certificate from CISA to associate with your Service Principal. For step-by-step details, see [Post Deployment Tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

The following tasks must be performed after deployment is complete. They're manual tasks—an ARM template can't do them.

- Obtain a public key certificate from CISA. 
- Create a Service Principal (App Registration).
- Add the CISA-provided certificate to the App Registration.
- Assign the application with the Azure Event Hubs Data Receiver role to the Event Hubs Namespace.
- Activate Feed by sharing Azure Tenant ID, Application (client) ID, Event Hubs Namespace name, Event Hubs name, and Consumer group name with your CISA POC

## Third-party Firewall (also known as Network Virtual Application)

> [!NOTE]
> This solution does not have a Deploy to Azure capability and is meant for guidance only.

The following solution defines how a Third-party firewall can be used to manage the traffic into your Azure application environment and support TIC 3.0 compliance. Third-party firewalls require use of a Syslog forwarder virtual machine with its agents registered with the Log Analytics workspace. The Third-party firewall is configured to export its logs in syslog format to the Syslog forwarder virtual machine and the agent is configured to send its logs to the Log Analytics workspace. Once the logs are in the Log Analytics workspace, they're sent to the Event Hubs and processed like the other solutions outlined in this article.

:::image type="content" source="media/trusted-internet-connection-architecture-nva.png" alt-text="Diagram of T I C 3 point 0 compliance architecture with Third-party Firewall uploading logs to CLAW." border="false" lightbox="media/trusted-internet-connection-architecture-nva.png":::

### Post-deployment tasks for all solutions

Up to now your environment is performing the firewall capabilities and logging connections. To be TIC 3.0 compliant for Network Telemetry collection, those logs must make it to CISA CLAW. The post-deployment steps finish the tasks towards compliance. These steps require coordination with CISA because you need a certificate from CISA to associate with your Service Principal. For step-by-step details, see [Post Deployment Tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post-Deployment-Tasks).

The following tasks must be performed after deployment is complete. They're manual tasks—an ARM template can't do them.

- Obtain a public key certificate from CISA. 
- Create a Service Principal (App Registration).
- Add the CISA-provided certificate to the App Registration.
- Assign the application with the Azure Event Hubs Data Receiver role to the Event Hubs Namespace.
- Activate Feed by sharing Azure Tenant ID, Application (client) ID, Event Hubs Namespace name, Event Hubs name, and Consumer group name with your CISA POC

## Pricing

The cost of each solution scales down as resources increase. The pricing in [Azure pricing calculator example](https://azure.com/e/2554c32b19c24b3d9f90d2a73683bd6a) scenario is based on the Azure Firewall solution. Altering the configuration can increase costs. With some plans, costs increase as the number of ingested logs increase.

> [!NOTE]
> Consult [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) for up-to-date pricing based on the resources deployed for the selected solution.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Paul Lizer](https://www.linkedin.com/in/paullizer) | Senior Cloud Solution Architect

## Next steps

- [TIC 3.0 core guidance documents | CISA](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents| CISA](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN | CISA](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS) | GSA](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)
- [Azure Trusted Internet Connection - Extended](https://github.com/Azure/trusted-internet-connection)
- [Federal App Innovation - TIC 3.0](https://github.com/microsoft/Federal-App-Innovation-Community/tree/main/topics/infrastructure/solutions/tic3.0)
- [What is Azure Firewall?](/azure/firewall/overview)
- [Azure Firewall documentation](/azure/firewall)
- [What is Azure Application Gateway | Microsoft Learn](https://learn.microsoft.com/en-us/azure/application-gateway/overview)
- [Azure Front Door | Microsoft Learn](https://learn.microsoft.com/en-us/azure/frontdoor/front-door-overview)
- [Introduction to Azure Web Application Firewall | Microsoft Learn](https://learn.microsoft.com/en-us/azure/web-application-firewall/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Azure Event Hubs? - a Big Data ingestion service - Azure Event Hubs | Microsoft Learn](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about)
- [Overview of alerts in Microsoft Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Application and service principal objects in Azure Active Directory](/azure/active-directory/develop/app-objects-and-service-principals)
- [Use the portal to create an Azure AD application and service principal that can access resources](/azure/active-directory/develop/howto-create-service-principal-portal)
- [Register an application with the Microsoft identity platform](/graph/auth-register-app-v2)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Create resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups)
- [How to find your Azure Active Directory tenant ID](/azure/active-directory/fundamentals/active-directory-how-to-find-tenant)
- [Collect Syslog data sources with Log Analytics agent](/azure/azure-monitor/agents/data-sources-syslog)
- [Parse text data in Azure Monitor logs](/azure/azure-monitor/logs/parse-text)
- [Introduction to flow logging for network security groups](/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)
- [Deploy and configure Azure Firewall using the Azure portal](/azure/firewall/tutorial-firewall-deploy-portal)

## Related resources

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Securely managed web applications](../apps/fully-managed-secure-apps.yml)
- [Secure and govern workloads with network level segmentation](../../reference-architectures/hybrid-networking/network-level-segmentation.yml)
- [Improved-security access to multitenant web apps from an on-premises network](access-multitenant-web-app-from-on-premises.yml)