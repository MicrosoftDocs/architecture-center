This article describes how to achieve Trusted Internet Connections (TIC) 3.0 compliance for internet-facing Azure applications and services. It provides solutions and resources to help government organizations meet TIC 3.0 compliance. It also describes how to deploy the required assets and how to incorporate the solutions into existing systems.

> [!NOTE] 
> Microsoft provides this information to Federal Civilian Executive Branch (FCEB) departments and agencies as part of a suggested configuration to facilitate participation in the Cybersecurity and Infrastructure Security Agency (CISA) Cloud Log Aggregation Warehouse (CLAW) capability. The suggested configurations are maintained by Microsoft and are subject to change.

## Architecture

:::image type="content" source="_images/trusted-internet-connections.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture." border="false" lightbox="_images/trusted-internet-connections.png":::

*Download a [Visio file](https://arch-center.azureedge.net/TIC_3.0-AzureReferenceArchitecture.vsdx)  of this architecture.*

### Dataflow

1. Firewall
   - The firewall can be any layer 3 or layer 7 firewall. 
     - Azure Firewall and some third-party firewalls, also known as Network Virtual Appliances (NVAs), are layer 3 firewalls. 
     - Azure Application Gateway with Web Application Firewall and Azure Front Door with Web Application Firewall are layer 7 firewalls. 
     - This article provides deployment solutions for Azure Firewall, Application Gateway with Web Application Firewall, and Azure Front Door with Web Application Firewall deployments.
   - The firewall enforces policies, collects metrics, and logs connection transactions between web services and the users and services that access the web services.
1. Firewall logs
   - Azure Firewall, Application Gateway with Web Application Firewall, and Azure Front Door with Web Application Firewall send logs to the Log Analytics workspace.
   - Third-party firewalls send logs in Syslog format to the Log Analytics workspace via a Syslog forwarder virtual machine.
1. Log Analytics workspace
   - The Log Analytics workspace is a repository for logs.
   - It can host a service that provides custom analysis of the network traffic data from the firewall.
1. Service principal (registered application)
1. Azure Event Hubs Standard
1. CISA TALON

### Components

- **Firewall:** Use one or more of the following firewalls in your architecture. For more information, see [Alternatives](#alternatives).

  - [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a network firewall security service that provides enhanced threat protection for cloud workloads that run on Azure. It's a stateful, managed firewall that has built-in high availability and unrestricted cloud scalability. It includes Standard and Premium performance tiers. Azure Firewall Premium includes the functionality of Azure Firewall Standard and provides extra features like Transport Layer Security (TLS) inspection and an intrusion detection and prevention system (IDPS). In this architecture, Azure Firewall can serve as a layer-3 firewall that enforces policies, inspects traffic, and logs transactions to support TIC 3.0 compliance.

  - [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) with [Web Application Firewall](/azure/web-application-firewall/overview) is a regional web traffic load balancer that includes a web application firewall. Web Application Firewall provides enhanced centralized protection of web applications. In this architecture, Application Gateway can manage and secure inbound web traffic, which protects applications from common exploits and logs traffic for compliance.

  - [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) with [Web Application Firewall](/azure/web-application-firewall/overview) is a global web traffic load balancer that includes content delivery network capabilities and integrated Web Application Firewall. In this architecture, Azure Front Door can accelerate and secure global application access while logging traffic for centralized analysis and compliance. Web Application Firewall provides enhanced centralized protection of your web applications from common exploits and vulnerabilities.

  - A non-Microsoft firewall is an NVA that runs on an Azure virtual machine and uses firewall services from partner vendors. Microsoft supports a large ecosystem of partner vendors that provide firewall services. In this architecture, a non-Microsoft firewall can provide customizable firewall services and export logs via Syslog to a forwarder virtual machine for ingestion into the Log Analytics workspace.

- **Logging and authentication:**

  - [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a centralized repository for collecting and analyzing log data. In this architecture, it stores firewall and identity logs, which enables custom queries and forwarding to Event Hubs for CISA CLAW ingestion.

  - [Azure Monitor](/azure/azure-monitor/overview) is a monitoring solution for collecting, analyzing, and acting on telemetry. In this architecture, Azure Monitor gathers performance and diagnostic data from network and identity components.

  - [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access service that provides identity features, single sign-on, and multifactor authentication across Azure workloads. In this architecture, it secures access to Azure resources and generates identity logs for compliance monitoring.

  - [Event Hubs Standard](/azure/well-architected/service-guides/event-hubs) is a big data streaming platform and event ingestion service. In this architecture, it receives logs from Log Analytics and streams them to CISA TALON for centralized analysis.

  - CISA TALON is a centralized log aggregation service operated by CISA that ingests telemetry data from cloud environments for cybersecurity monitoring and compliance. In this architecture, TALON authenticates by using a CISA-supplied certificate and collects logs from Event Hubs. It pulls the logs into the CLAW system to support TIC 3.0 compliance and centralized visibility.

### Alternatives

There are a few alternatives that you can use in these solutions:

- You can separate log collection into areas of responsibility. For example, you can send Microsoft Entra logs to a Log Analytics workspace that's managed by the identity team, and send network logs to a different Log Analytics workspace that's managed by the network team.
- The examples in this article each use a single firewall, but some organizational requirements or architectures require two or more. For example, an architecture can include an Azure Firewall instance and an Application Gateway instance with Web Application Firewall. Logs for each firewall must be collected and made available for CISA TALON to collect.
- If your environment requires internet egress from Azure-based virtual machines, you can use a layer 3 solution like Azure Firewall or a third-party firewall to monitor and log the outbound traffic.

## Scenario details

TIC 3.0 moves TIC from on-premises data collection to a cloud-based approach that better supports modern applications and systems. It improves performance because you can directly access Azure applications. With TIC 2.x, you need to access Azure applications via a TIC 2.x Managed Trusted Internet Protocol Service (MTIPS) device, which slows down the response.

Routing application traffic through a firewall and logging that traffic is the core functionality demonstrated in the solutions presented here. The firewall can be Azure Firewall, Azure Front Door with Web Application Firewall, Application Gateway with Web Application Firewall, or a third-party NVA. The firewall helps to secure the cloud perimeter and saves logs of each transaction. Independently of the firewall layer, the log collection and delivery solution requires a Log Analytics workspace, a registered application, and an event hub. The Log Analytics workspace sends logs to the event hub.  

CLAW is a CISA managed service. In late 2022, CISA released TALON. TALON is a CISA managed service that uses Azure native capabilities. An instance of TALON runs in each Azure region. TALON connects to event hubs that government agencies manage for pulling agency firewall and Microsoft Entra logs into CISA CLAW.

For more information on CLAW, TIC 3.0, and MTIPS, see:

- [Trusted Internet Connections guidance](/azure/azure-government/compliance/compliance-tic)
- [TIC 3.0 core guidance documents](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents](https://www.cisa.gov/resources-tools/resources/cybersecurity-publications)
- [EINSTEIN](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS)](https://www.gsa.gov/technology/it-contract-vehicles-and-purchasing-programs/information-technology-category/it-security/trusted-internet-connections-tic/mtips-features-and-price-structure)

### Potential use cases

TIC 3.0 compliance solutions are commonly used by federal organizations and government agencies for their Azure-based web applications and API services.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

- Evaluate your current architecture to determine which of the solutions presented here provides the best approach to TIC 3.0 compliance.
- Contact your CISA representative to request access to CLAW.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Azure Firewall Standard and Premium integrate with availability zones to increase availability.
- Application Gateway v2 supports autoscaling and availability zones to increase reliability.
- Multi-region implementations that include load balancing services like Azure Front Door can improve reliability and resiliency.
- Event Hubs Standard and Premium provide Geo-disaster recovery pairing that enables a namespace to fail over to a secondary region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- When you register an enterprise application, a service principal is created. Use a naming scheme for service principals that indicates the purpose of each one.
- Perform audits to determine the activity of service principals and the status of service principal owners.
- Azure Firewall has standard policies. web application firewalls (WAFs) associated with Application Gateway and Azure Front Door have managed rule sets to help secure your web service. Start with these rule sets and build organizational policies over time based on industry requirements, best practices, and government regulations.
- Event Hubs access is authorized via Microsoft Entra managed identities and a certificate that's provided by CISA.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of each solution scales down as the resources increase. The pricing in this [Azure pricing calculator example scenario](https://azure.com/e/2554c32b19c24b3d9f90d2a73683bd6a) is based on the Azure Firewall solution. If you change the configuration, costs might increase. With some plans, costs increase as the number of ingested logs increase.

> [!NOTE]
> Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to get up-to-date pricing that's based on the resources that are deployed for the selected solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) are built into the solutions to notify you when an upload fails to deliver logs to CLAW. You need to determine the severity of the alerts and how to respond.
- You can use Azure Resource Manager (ARM), Bicep, or Terraform templates to speed up the deployment of TIC 3.0 architectures for new applications.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- [Azure Firewall](/azure/firewall/firewall-performance), [Application Gateway](/azure/application-gateway/application-gateway-faq#performance), [Azure Front Door](/azure/frontdoor/scenarios#performance-efficiency), and [Event Hubs](/azure/architecture/serverless/event-hubs-functions/performance-scale) performance scales as usage increases.
- Azure Firewall Premium allows more TCP connections than Standard and provides increased bandwidth.
- Application Gateway v2 automatically ensures that new instances are spread across fault domains and update domains. 
- Azure Front Door provides caching, compression, traffic acceleration, and TLS termination to improve performance.
- Event Hubs Standard and Premium provide auto-inflate to scale up as load increases.

## Deploy an Azure Firewall solution

> [!NOTE]
>
> Deployment resources aren't provided for this solution. It's included only to provide guidance.

Deploying Azure Firewall within your network architecture allows you to effectively manage and secure traffic entering your Azure application environment. This solution provides comprehensive guidance for collecting, and delivering logs to the Cybersecurity and Infrastructure Security Agency (CISA) Cloud Log Aggregation Warehouse (CLAW), ensuring compliance with Trusted Internet Connections (TIC) 3.0 requirements. Deployment can be automated using ARM, Bicep, or Terraform templates streamlining the setup process and adhering to infrastructure-as-code best practices.

:::image type="content" source="_images/trusted-internet-connections-azure-firewall.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Azure Firewall uploads logs to CLAW." border="false" lightbox="_images/trusted-internet-connections-azure-firewall.png":::

 The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- Azure Firewall with a network policy for internet access.
- Azure Firewall diagnostic settings that send logs to the Log Analytics workspace.
- A route table that's associated with the application resource group to route the app service to the firewall for the logs it generates.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

## Deploy a solution that uses Application Gateway with WAF

> [!NOTE]
>
> Deployment resources aren't provided for this solution. It's included only to provide guidance.

Deploying Application Gateway with Web Application Firewall (WAF) within your network architecture allows you to effectively manage and secure web traffic entering your Azure application environment. This solution provides comprehensive guidance for collecting and delivering logs to the Cybersecurity and Infrastructure Security Agency (CISA) Cloud Log Aggregation Warehouse (CLAW), ensuring compliance with Trusted Internet Connections (TIC) 3.0 requirements. Deployment can be automated using ARM, Bicep, or Terraform templates, streamlining the setup process and adhering to infrastructure-as-code best practices.

:::image type="content" source="_images/trusted-internet-connections-architecture-application-gateway.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Application Gateway with WAF uploads logs to CLAW." border="false" lightbox="_images/trusted-internet-connections-architecture-application-gateway.png"::: 

The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Application Gateway v2 instance with WAF. The WAF is configured with bot and Microsoft managed policies.
- Application Gateway v2 diagnostic settings that send logs to the Log Analytics workspace.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

## Deploy a solution that uses Azure Front Door with WAF

> [!NOTE]
>
> Deployment resources aren't provided for this solution. It's included only to provide guidance.

The following solution uses Azure Front Door with WAF to manage and secure global web traffic entering your Azure application environment. This solution provides comprehensive guidance for generating, collecting, and delivering logs to the CISA Cloud Log Aggregation Warehouse (CLAW), ensuring compliance with Trusted Internet Connections (TIC) 3.0 requirements. Deployment can be automated using ARM, Bicep, or Terraform templates, streamlining the setup process and adhering to infrastructure-as-code best practices.

:::image type="content" source="_images/trusted-internet-connections-architecture-front-door.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. Azure Front Door with WAF uploads logs to CLAW." border="false" lightbox="_images/trusted-internet-connections-architecture-front-door.png":::

 The solution includes:

- A virtual network that has separate subnets for the firewall and servers.
- A Log Analytics workspace.
- An Azure Front Door instance with WAF. The WAF is configured with bot and Microsoft managed policies.
- Azure Front Door diagnostic settings that send logs to the Log Analytics workspace.
- A registered application.
- An event hub.
- An alert rule that sends an email if a job fails.

## Third-party firewall (NVA) solution

> [!NOTE]
> Deployment resources aren't provided for this solution. It's included only to provide guidance.

The following solution illustrates how you can use a third-party firewall to manage traffic entering your Azure application environment and implement TIC 3.0 compliance. Third-party firewalls require the use of a Syslog forwarder virtual machine. Its agents need to be registered with the Log Analytics workspace. The third-party firewall is configured to export its logs in Syslog format to the Syslog forwarder virtual machine. The agent is configured to send its logs to the Log Analytics workspace. After the logs are in the Log Analytics workspace, they're sent to Event Hubs and processed as they are in the other solutions described in this article.

:::image type="content" source="_images/trusted-internet-connections-architecture-nva.png" alt-text="Diagram that shows a TIC 3.0 compliance architecture. A third-party firewall uploads logs to CLAW." border="false" lightbox="_images/trusted-internet-connections-architecture-nva.png":::

## Post-deployment tasks

After deployment, your environment performs the firewall capabilities and logging connections. To meet compliance with TIC 3.0 policies for network telemetry collection, you need to ensure that the logs make it to CISA CLAW. The post-deployment steps finish the tasks to enable compliance. To complete these steps, you need to coordinate with CISA because CISA needs to supply a certificate to associate with your service principal.

You need to manually perform the following tasks after deployment. You can't complete them by using an ARM template.

- Obtain a public key certificate from CISA.
- Create a service principal (application registration).
- Add the public key certificate to the application registration.
- Assign the application the Azure Event Hubs Data Receiver role at the Event Hubs namespace scope.
- Activate the feed by sending the Azure tenant ID, application (client) ID, event hub namespace name, event hub name, and consumer group name to CISA.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Paul Lizer](https://www.linkedin.com/in/paullizer) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [TIC 3.0 core guidance documents](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents](https://www.cisa.gov/resources-tools/resources/cybersecurity-publications)
- [EINSTEIN](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS)](https://www.gsa.gov/technology/it-contract-vehicles-and-purchasing-programs/information-technology-category/it-security/trusted-internet-connections-tic/mtips-features-and-price-structure)
- [Azure Trusted Internet Connection - Extended](https://github.com/Azure/trusted-internet-connection)
- [Federal App Innovation - TIC 3.0](https://github.com/microsoft/Federal-App-Innovation-Community/tree/main/assets/topics/infrastructure/solutions/tic3.0)
- [What is Azure Firewall?](/azure/firewall/overview)
- [Azure Firewall documentation](/azure/firewall)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [Azure Front Door](/azure/frontdoor/front-door-overview)
- [Introduction to Azure WAF](/azure/web-application-firewall/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Azure Event Hubs?](/azure/event-hubs/event-hubs-about)
- [Overview of alerts in Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Application and service principal objects in Microsoft Entra ID](/entra/identity-platform/app-objects-and-service-principals)
- [Use the portal to create a Microsoft Entra application and service principal that can access resources](/entra/identity-platform/howto-create-service-principal-portal)
- [Register an application with the Microsoft identity platform](/graph/auth-register-app-v2)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Create resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups)
- [How to find your Microsoft Entra tenant ID](/azure/active-directory-b2c/tenant-management-read-tenant-name)
- [Collect Syslog data sources with the Log Analytics agent](/azure/azure-monitor/agents/data-sources-syslog)
- [Parse text data in Azure Monitor logs](/azure/azure-monitor/logs/parse-text)
- [Introduction to flow logging for network security groups](/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
- [What are managed identities for Azure resources?](/entra/identity/managed-identities-azure-resources/overview)
- [Deploy and configure Azure Firewall using the Azure portal](/azure/firewall/tutorial-firewall-deploy-portal)

## Related resources

- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Securely managed web applications](../../example-scenario/apps/fully-managed-secure-apps.yml)
- [Improved-security access to multitenant web apps from an on-premises network](../../web-apps/guides/networking/access-multitenant-web-app-from-on-premises.yml)
