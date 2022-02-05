Version 3.0 of the Trusted Internet Connection (TIC) takes TIC from on-premises data collection to a cloud-based approach that better supports modern applications and systems. It improves performance because users directly access Azure applications. With TIC 2.0+, users accessed Azure applications via a TIC 2.0+ Managed Trusted Internet Protocol Service (MTIPS) device, which slowed response.

You can deliver TIC 3.0 compliance for your internet-facing Azure applications and services. This article provides solutions and resources to guide government organizations to TIC 3.0 compliance. It shows how to deploy the required assets and how to incorporate the solutions into existing systems.

The common component for the solutions is an Azure Automation account that sends firewall traffic logs to a Cybersecurity and Infrastructure Security Agency (CISA) Cloud Log Aggregation Warehouse (CLAW).

> [!NOTE]
> As of Q1 2022, a CISA CLAW can reside only in an Amazon Web Services (AWS) S3 bucket. This means that all TIC 3.0 compliant logs collected from Azure are transmitted to a CISA-owned Amazon S3 bucket. The solutions described here support that storage destination. When there's an Azure-based storage option, the solutions will be updated to support that option.

For more information on CLAW, TIC 3.0, and MTIPS, see:

- [Trusted Internet Connections guidance](/azure/azure-government/compliance/compliance-tic)
- [TIC 3.0 core guidance documents | CISA](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents| CISA](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN | CISA](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS) | GSA](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)

## Potential use cases

Federal organizations and government agencies are the most likely implementers of TIC 3.0 compliance solutions for their Azure-based web applications and API services.

*Microsoft provides this information to Federal Civilian Executive Branch (FCEB) departments and agencies as part of a suggested configuration to facilitate participation in CISA’s CLAW capability. This suggested configuration is maintained by Microsoft and is subject to change.*

## Architecture

:::image type="content" source="media/trusted-internet-connections-architecture.png" alt-text="Diagram of T I C 3 point 0 compliance architecture with Azure firewall uploading logs to CLAW." border="false" lightbox="media/trusted-internet-connections-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1910857-trusted-internet-connections.vsdx) of this architecture.*

### Dataflow

1. Firewall
   - The firewall can be Azure Firewall or a third-party firewall. This article covers the Azure Firewall case. The Premium tier of Azure Firewall is often used instead of Standard because of its intrusion detection and prevention system (IDPS).
   - The firewall enforces policies, collects metrics, and logs connection transactions between web services and the users and services that access the web services.
1. Firewall logs
   - Azure Firewall sends logs to the Log Analytics workspace.
   - Third-party firewalls send logs in syslog format to the Log Analytics workspace.
1. Log Analytics workspace
   - The Log Analytics workspace is a repository for the logs.
   - It can host a service that provides custom analysis of the network traffic data from the firewall.
1. Azure Automation
   - Automation queries the Log Analytics workspace every 30 minutes for logs that were generated since the previous query, and then it uploads the logs to the CLAW. The logs can include:
     - Azure Firewall traffic logs and IDPS logs.
     - Azure Active Directory (Azure AD) access and sign-in logs.
     - Application Gateway logs.
     - Azure Load Balancer logs.
     - Network Security Group logs.
   - Automation uses its encrypted variables component  to store values that the runbook uses to connect to the Log Analytics workspace and the CLAW.
1. The CLAW can reside only in an AWS S3 bucket at CISA. You need to work with CISA to create a CLAW to use.
1. Azure AD is configured to send access and sign-in logs to the Log Analytics workspace. This is done by using diagnostic settings in Azure AD.
1. Application Gateway can send its own firewall logs to the Log Analytics workspace.
1. Azure Load Balancer can send its logs to the Log Analytics workspace.
1. A Network Security Group (NSG) can send its logs to the Log Analytics workspace.

### Components

- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) is a cloud-native, intelligent network firewall security service that provides threat protection for cloud workloads that run in Azure. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. There are two performance tiers, Standard, and Premium. Azure Firewall Premium includes all the functionality of Azure Firewall Standard and has additional features such as Transport Layer Security (TLS) inspection, and an intrusion detection and protection system (IDPS).
- Log Analytics is a tool in the Azure portal that's used to edit and run log queries against Azure Monitor Logs. For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).
- [Azure Monitor](https://azure.microsoft.com/services/monitor) is a comprehensive solution for collecting, analyzing, and acting on telemetry.
- [Azure Automation](https://azure.microsoft.com/services/automation) delivers cloud-based automation, operating system updates, and configuration to support consistent management across environments.
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) provides identity services, single sign-on, and multifactor authentication across Azure workloads.
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway) is an application delivery controller service. It operates at layer 7, the application layer, and has various load-balancing capabilities.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a layer 4 (TCP, UDP) load balancer.
- [Azure Functions](https://azure.microsoft.com/services/functions) is a serverless compute platform that you can use to build applications. With Functions, you can use triggers and bindings to react to changes in Azure services like Blob Storage and Azure Cosmos DB. Functions can run scheduled tasks, process data in real time, and process messaging queues.

### Alternatives

- Instead of using an Automation account to query the Log Analytics workspace and send logs to the CLAW, you can create a function in Azure Functions to perform the same task. Creating the function requires a software developer.
- You can separate log collection into areas of responsibility. For instance, Azure AD logs can be sent to a Log Analytics workspace managed by an identity team, and network logs can be sent to a different Log Analytics workspace managed by the network team. This technique requires multiple Automation accounts, one for each Log Analytics workspace.
- The architecture uses an Azure AD app registration to create a service principal and a corresponding secret. The runbook uses the identity provided by the service principal to authenticate access to the Log Analytics workspace. You can also use Azure managed identities to allow the Automation account to access the Log Analytics workspace. This approach eliminates the need to manage secrets.

## Considerations

- There are various solutions that you can deploy, depending on your current situation, as described in [Deploy an Azure Firewall solution](#deploy-an-azure-firewall-solution). Evaluate your current architecture to determine which solution provides your best approach to TIC 3.0 compliance.
- Contact your CISA representative to request a CLAW storage solution.
- Use the **Deploy to Azure** buttons in [Deploy an Azure Firewall solution](#deploy-an-azure-firewall-solution) to deploy one or more of the solutions to a test environment. That should help you become familiar with the process and the deployed resources.
- See [Trusted Internet Connection (TIC) 3.0 compliance for internet-facing applications](https://github.com/Azure/trusted-internet-connection) in GitHub for:
  - Additional information about achieving compliance.
  - ARM templates to simplify deployment.
  - Information to assist with integrating existing resources into the solution.

### Operational excellence

- [Azure Alerts](/azure/azure-monitor/alerts/alerts-overview) is built into the solution to notify you when an upload fails to deliver logs to the CLAW. It's up to you to determine the severity of alerts and how to respond.
- Use ARM templates to speed up the deployment of additional TIC 3.0 architectures for new applications.

### Performance

- [Azure Firewall](/azure/firewall/firewall-performance) performance scales as usage increases.
- Azure Firewall Premium allows more TCP connections than Standard and provides greater bandwidth.

### Reliability

- Azure Firewall Standard and Premium tiers integrate with availability zones to increase availability.
- Multi-region implementations that include load balancing services like Azure Front Door can improve reliability and resiliency.

### Security

- Registering an enterprise application creates a service principal. Use a naming scheme for service principals that indicates their purpose.
- Perform audits to determine the activity of service principals and the status of service principal owners.
- Azure Firewall has standard policies. Start with those and build organizational policies over time based on industry requirements, best practices, and government regulations.

## Deploy an Azure Firewall solution

The following solutions use Azure Firewall to manage the traffic into your Azure application environment. Select your solution based on the topology of your Azure environment. Organizations with an Azure Firewall and Log Analytics workspace should use the [Automation account only](#automation-account-only) solution.

- The [Complete](#complete) solution includes all resources and an app service to highlight the types of telemetry collected by the firewall.
- The [Network + Log Analytics + Automation](#network--log-analytics--automation-account) solution includes all Azure resources for the network, for logging, for automation, and for alerting. It doesn't include the app service that's in **Complete**.
- The [Log Analytics + Automation account](#log-analytics--automation-account) solution is appropriate if you already have virtual networks, firewalls, and route table/route server. It includes alerting.
- The [Automation account only](#automation-account-only) solution is appropriate if you already have networks and are using a centralized Log Analytics workspace. It includes alerting.

These sections apply to all four solutions:

- [Requirements for all solutions](#requirements-for-all-solutions)
- [Post-deployment tasks for all solutions](#post-deployment-tasks-for-all-solutions)

### Complete

The **Complete** solution deploys all resources to generate, collect, and deliver logs to the CLAW. It also includes an app service to highlight the types of telemetry collected by the firewall.

:::image type="content" source="media/trusted-internet-connections-complete.png" alt-text="Diagram of the complete solution that deploys all resources to generate, collect, and deliver logs to CLAW." border="false" lightbox="media/trusted-internet-connections-complete.png":::

 The solution includes:

- A virtual network with a subnet for the firewall and servers.
- A Log Analytics workspace.
- Azure Firewall with a network policy for internet access.
- Azure Firewall diagnostic settings that send logs to the Log Analytics workspace.
- A route table associated with AppSubnet to route the app service to the firewall for the logs it generates.
- An Automation account with a published runbook, schedule, and the AWSPowerShell module.
- An alert rule that sends an email if a job fails.

All resources are deployed to a single subscription and virtual network for simplicity. Resources could be deployed in any combination of resource groups or across multiple virtual networks.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure%2520Firewall%2FComplete%2Fazuredeploy.json)

### Network + Log Analytics + Automation account

This solution deploys all Azure resources for the network, for logging, and for automation. You can complete this setup, tailor firewall policies for your environment, and have external users connecting to your Azure application or service. Application traffic will be collected and sent to the CLAW.

:::image type="content" source="media/trusted-internet-connections-no-vm.png" alt-text="Diagram of a solution that deploys all Azure resources for networking, logging, and automation, but doesn't include a VM." border="false" lightbox="media/trusted-internet-connections-no-vm.png":::

 The solution includes:

- A virtual network with subnet for firewall and servers.
- A Log Analytics workspace.
- Azure Firewall with network policy for internet access.
- Azure Firewall diagnostic settings configured to send logs to the Log Analytics workspace.
- A route table to route servers to the firewall for internet access.
- An Automation account with a published runbook, schedule, and required AWSPowerShell module.
- An alert rule that sends an email if a job fails.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure%2520Firewall%2FNetwork%2520with%2520Log%2520Analytics%2520and%2520Automation%2Fazuredeploy.json)

### Log Analytics + Automation account

This is a good solution if you already have virtual networks, firewalls, and route table/route server. If your firewall gets traffic that's routed from a TIC 2.0+ MTIPS device to your application gateway in Azure, you can keep that solution in place while you confirm that the Azure Firewall logs are collected and uploaded to the CLAW. Then you can update your routing so that your external users no longer use the MTIPS device but are routed directly to the Azure Firewall.

The solution includes:

- A Log Analytics workspace.
- Azure Firewall diagnostic settings configured to send logs to the Log Analytics workspace.
- An Automation account with a published runbook linked to a schedule, and the required AWSPowerShell module.
- An alert rule that sends an email if a job fails.

:::image type="content" source="media/trusted-internet-connections-analytics-automation.png" alt-text="Diagram of a solution that includes log analytics, and an Automation account with published runbook, schedule, and required AWSPowerShell module." border="false" lightbox="media/trusted-internet-connections-analytics-automation.png":::

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure%2520Firewall%2FLog%2520Analytics%2520and%2520Automation%2520Account%2Fazuredeploy.json)

### Automation account only

This is a good solution if you already have networks and an Azure Firewall, and are using a centralized Log Analytics workspace.

[![Deploy to Azure](media/trusted-internet-connection-deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Ftrusted-internet-connection%2Fmain%2FArchitecture%2FAzure%2520Firewall%2FAutomation%2520Account%2520Only%2Fazuredeploy.json)

The solution includes:

- Azure Firewall diagnostic settings that are configured to send logs to the Log Analytics workspace.
- An Automation account with published runbook, schedule, and the required AWSPowerShell module.
- An alert rule that sends an email if a job fails.

:::image type="content" source="media/trusted-internet-connections-automation-only.png" alt-text="Diagram of a solution that includes an Automation account with published runbook, schedule, and required AWSPowerShell module." border="false" lightbox="media/trusted-internet-connections-automation-only.png":::

### Requirements for all solutions

For step-by-step details see [Prerequisite tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Prerequisite%20Tasks)

You need to do the following before deployment:

- Create a resource group.
- Register an application.
- Create a secret for a registered application.

You can deploy all of the Azure resources yourself, but to send log data to a CISA CLAW, you need to:

- Request CISA to provide an S3 bucket access key, a secret, the S3 bucket name, and a line of sight network connection.
- Collect a tenant ID.

### Post-deployment tasks for all solutions

For step-by-step details see [Post Deployment Tasks](https://github.com/Azure/trusted-internet-connection/tree/main/Architecture/Post%20Deployment%20Tasks).

The following tasks must be performed after deployment is complete. They are manual tasks—an ARM template can't do them.

- Register an application with the Reader role to the Log Analytics workspace.
- Link the schedule to the runbook.
- Update Automation account variables.

## Pricing

The cost of each solution scales down as resources increase. The pricing in [Azure pricing calculator example scenario](https://azure.com/e/72ac82bc9b8d4073bb730b65aa372bc5) is based on the default settings of the **Complete** solution. Altering the configuration can increase costs. With some plans, costs increase as the number of ingested logs increase.

> [!NOTE]
> Consult [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) for up-to-date pricing based on the resources deployed for the selected solution.

## Next steps

- [TIC 3.0 core guidance documents | CISA](https://www.cisa.gov/publication/tic-30-core-guidance-documents)
- [National Cybersecurity Protection System (NCPS) documents| CISA](https://www.cisa.gov/publication/national-cybersecurity-protection-system-documents)
- [EINSTEIN | CISA](https://www.cisa.gov/einstein)
- [Managed Trusted Internet Protocol Services (MTIPS) | GSA](https://www.gsa.gov/technology/technology-products-services/it-security/trusted-internet-connections-tics)
- [What is Azure Automation?](/azure/automation/overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [Azure Firewall documentation](/azure/firewall)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [Overview of alerts in Microsoft Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Application and service principal objects in Azure Active Directory](/azure/active-directory/develop/app-objects-and-service-principals)
- [Use the portal to create an Azure AD application and service principal that can access resources](/azure/active-directory/develop/howto-create-service-principal-portal)
- [Register an application with the Microsoft identity platform](/graph/auth-register-app-v2)
- [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal)
- [Schedule a runbook in the Azure portal](/azure/automation/manage-runbooks#schedule-a-runbook-in-the-azure-portal)
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