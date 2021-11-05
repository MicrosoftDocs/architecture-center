Large enterprises need to consider many factors when modernizing their existing monitoring solution. Enterprises can achieve centralized monitoring management across the board by using Azure Monitor features. This example scenario illustrates enterprise-level monitoring that uses Azure Monitor.

Enterprise teams have different workloads, such as Windows, Linux, SQL, identity-based workloads, virtual desktop infrastructure (VDI), containers, and web apps. These workloads can be running in any cloud providers, on-premises, or a combination. With such a vast array of workloads in different environments, cloud-based monitoring is complex.

Enterprise-level monitoring must also cover governance, operational best practices, effective cost management, and workspace security. Monitoring must provide enough flexibility to set up and manage team environments, and let teams manage themselves with some degree of control.

Other critical monitoring design factors include:

- How to spread Azure Log Analytics workspaces across different geographical regions or teams.
- Monitoring the workspaces themselves, as well as their workloads.
- How to charge back different teams to optimize overall costs.
- How to visualize and possibly archive collected data.
- Creating separate dashboards for operations, apps, and different teams.
- Giving leadership enough visibility into the right set of information.

## Potential use cases

This solution can help with the following use cases:

- Consolidated monitoring for different cloud and on-premises workloads.
- Monitoring for container, Azure SQL, and Azure Virtual Desktop workloads.
- Expanded monitoring scope, such as connecting Azure Monitor to Azure Sentinel.
- Hybrid and heterogenous cloud monitoring across networks, identity providers, operating systems, and other domains.

## Architecture

:::image type="content" source="media/enterprise-monitoring.png" alt-text="Architectural diagram that shows enterprise workspaces and monitoring capabilities." border="false" lightbox="media/enterprise-monitoring.png":::

- Different workloads across the enterprise have separate workspaces. Configuring different workspaces gives teams autonomy over their own data, and provides a separate cost overview per workspace.

  - Platform-as-a-service (PaaS) services like Azure Web Apps and Azure Functions Apps add configuration for Application Insights within their workspaces.

  - For identity, on-premises Active Directory and cloud identity providers each have their own workspaces.

  - Azure Kubernetes Service (AKS) and Azure Web Apps apps, Azure Virtual Desktop, Azure Pipelines, SQL workloads, and other PaaS services each have their own workspaces.

- Each workspace has its own set of configured alerts. Azure Logic Apps and Azure Automation provide advance alerting and remediation. You can use Logic Apps to configure integration with IT Service Management (ITSM) tools.

- A set of on-premises virtual machines (VMs) connects through Azure Arc, providing an end-to-end Azure management plane. You can also use Azure Arc to connect infrastructure-as-a-service (IaaS) resources that run in a third-party cloud.

- Custom logging captures information about third-party virtualized environments and collects custom application, software, or operating system logs.

- Log Analytics Workspace Insights provides comprehensive monitoring of all the workspaces. Log Analytics Workspace Insights has its own separate set of alerts.

- Log Analytics provides further integration by exporting workspace data for archiving or analytics. Archiving data to cool tier storage saves costs. You can use archived data for further analytics by creating datasets that feed into machine learning models.

- Azure Monitor connects to security information and event management (SIEM) tools like Azure Sentinel to create larger enterprise security datastores.

- Power BI and Azure Monitor Workbooks provide data visualization and dashboard capabilities.

### Components

This architecture includes the following components:

#### Azure Monitor components

[Azure Monitor](https://azure.microsoft.com/services/monitor) collects, analyzes, and acts on telemetry data from cloud and on-premises environments. This solution uses the following Azure Monitor components and features:

- [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics) collects numeric data from monitored resources into a time series database. Metrics in Azure Monitor are lightweight and support near real-time scenarios, so they're useful for alerting and fast detection of issues.
- [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) collects and organizes log and performance data from monitored resources. You can consolidate data from multiple sources, including Azure [platform logs](/azure/azure-monitor/essentials/platform-logs-overview), into a single workspace. You can analyze the data by using a [sophisticated query language](/azure/azure-monitor/logs/log-query-overview) in Log Analytics.
- [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) can send data to both Azure Monitor Logs and Azure Monitor Metrics. The Azure Monitor agent uses [Data Collection Rules](/azure/azure-monitor/agents/data-collection-rule-overview) (DCR), which provide scalable configurations. The Azure Monitor agent doesn't require workspace keys to connect.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) monitors live applications on a wide variety of platforms across cloud, hybrid, and on-premises environments. Application Insights automatically detects performance anomalies, and includes powerful analytics tools to help you understand usage and diagnose issues.
- [Azure Virtual Desktop insights](/azure/virtual-desktop/azure-monitor) use Azure Monitor for Azure Virtual Desktop to help IT professionals understand their Azure Virtual Desktop environments.
- [Container insights](/azure/azure-monitor/containers/container-insights-overview) monitor the performance and health of Kubernetes clusters and other container-based workloads.
- [Network insights](/azure/azure-monitor/insights/network-insights-overview) provide a comprehensive view of health and metrics for all deployed network resources.
- [SQL insights (preview)](/azure/azure-monitor/insights/sql-insights-overview) monitor health and help you diagnose problems and tune performance for any product in the Azure SQL family.
- [VM Insights](/azure/azure-monitor/vm/vminsights-overview) monitor the performance and health of VMs and virtual machine scale sets, their running processes, and dependencies on other resources.
- [IT Service Management Connector](/azure/azure-monitor/alerts/itsmc-overview) (ITSMC) provides a bi-directional connection between Azure and supported ITSM tools to help you resolve ITSM work items faster.
- [Azure Monitor Workbooks](/azure/azure-monitor/visualize/workbooks-overview) provide a flexible canvas to analyze multiple Azure data sources and combine them into interactive visual reports.
- [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) creates and runs queries on Azure Monitor Logs data in [Log Analytics workspaces](/azure/azure-monitor/logs/quick-create-workspace). This solution uses the following Log Analytics features:
  - [Log Analytics agent](/azure/azure-monitor/agents/agents-overview#log-analytics-agent) collects monitoring data from cloud and on-premises operating systems and VM workloads, and sends it to a Log Analytics workspace.
  - [Azure Active Directory Monitoring](/azure/active-directory/reports-monitoring/overview-monitoring) routes Azure Active Directory (Azure AD) activity logs to a Log Analytics workspace.
  - [Log Analytics gateway](/azure/azure-monitor/agents/gateway) sends data to Azure Automation and Log Analytics workspaces for computers that can't directly connect to the internet.
  - [Service Map](/azure/azure-monitor/vm/service-map) uses the Log Analytics agent to automatically discover application components on Windows and Linux systems, and map the communication between services. 
  - [Alert Management](/azure/azure-monitor/insights/alert-management-solution) helps you analyze all the alerts in your Log Analytics workspaces.
  - [Log Analytics data export (preview)](/azure/azure-monitor/logs/logs-data-export) continuously exports data from selected tables in a Log Analytics workspace to an Azure storage account or Azure Event Hubs.
  - [Log Analytics Workspace Insights](/azure/azure-monitor/logs/log-analytics-workspace-insights-overview) provides comprehensive monitoring of all Log Analytics workspaces through a unified view of workspace usage, performance, health, agent, queries, and change logs.

#### Other components

In this solution, Azure Monitor supports or integrates with the following Azure services:

- [Azure Arc](https://azure.microsoft.com/services/azure-arc) simplifies governance and management by delivering a consistent multi-cloud and on-premises management platform.
- [Azure Automation](https://azure.microsoft.com/services/automation) delivers cloud-based automation, operating system updates, and configuration to support consistent management across environments. [Change Tracking](/azure/automation/change-tracking/overview) tracks changes in cloud and on-premises VMs to help you identify software issues, forwards the data to Azure Monitor Logs, and stores the data in a Log Analytics workspace.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends on-premises networks into the Microsoft cloud over private connections with the help of connectivity providers.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) provides secure, scalable, cost-effective cloud storage for big data analytics.
- [Azure Functions](https://azure.microsoft.com/services/functions) is a serverless solution that implements readily available code blocks called *functions* that run on demand and scale up automatically.
- [Azure Kubernetes Services (AKS)](https://azure.microsoft.com/services/kubernetes-service) is a fully managed Kubernetes service to easily deploy and manage containerized applications.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) evenly distributes incoming network traffic across backend resources or servers.
- [Azure Logic Apps](https://azure.microsoft.com/services/logic-apps) is a cloud-based platform for creating and running automated workflows that integrate apps, data, services, and systems.
- [Azure Resource Manager](https://azure.microsoft.com/features/resource-manager) provides a management layer and templates for creating, updating, and deleting resources in your Azure account.
- [Azure Security Center](https://azure.microsoft.com/services/security-center) is part of Microsoft Defender for Cloud, a unified infrastructure security management system.
- [Azure Sentinel](https://azure.microsoft.com/services/azure-sentinel) is a cloud-native, scalable, SIEM and security orchestration automated response (SOAR) solution.
- [Azure SQL](https://azure.microsoft.com/products/azure-sql) family of SQL database services provides a consistent, unified experience and a full range of deployment options, from edge to cloud.
- [Power BI](https://powerbi.microsoft.com/) is a collection of software services, apps, and connectors that turn your data sources into coherent, visually immersive, and interactive insights.

### Alternatives

You can use some monitoring alternatives along with or instead of Azure Monitor.

#### System Center Operations Manager

[System Center Operations Manager](/system-center/scom/welcome) offers flexible, cost-effective infrastructure monitoring. Operations Manager helps ensure the predictable performance and availability of important applications, and offers comprehensive monitoring for your private and public datacenters and clouds.

To maintain your existing Operations Manager investment and use the extended capabilities of Azure Monitor, you can integrate Operations Manager with your Log Analytics workspace. You can use Azure Monitor logs while continuing to use Operations Manager to:

- Monitor the health of your IT services.
- Maintain integration with your ITSM solutions for incident and problem management.
- Manage the lifecycle of agents deployed to on-premises and public cloud IaaS VMs.

For more information, see [Connect Operations Manager to Azure Monitor](/azure/azure-monitor/agents/om-agents).

#### Grafana

[Grafana](https://grafana.com) is an open and composable observability and data visualization platform. Grafana helps you query, visualize, alert on, and understand your data wherever it's stored. You can build flexible dashboards to explore and share any data.

## Considerations

The following considerations apply to this solution.

### Availability

[Azure availability zones](/azure/availability-zones/az-overview) protect applications and data from datacenter failures by relying on the availability of other zones in the region. Availability zones help provide resilience for Azure Monitor features like Application Insights that rely on a Log Analytics workspace. Workspaces linked to availability zones remain active and operational even if a specific datacenter isn't available.

See [Regions and Availability Zones in Azure](https://azure.microsoft.com/global-infrastructure/geographies/#geographies) for the Azure regions that support availability zones. Azure Monitor currently supports availability zones in regions East US 2 and West US 2.

Azure Monitor support for availability zones requires a Log Analytics workspace linked to an [Azure Monitor Logs dedicated cluster](/azure/azure-monitor/logs/logs-dedicated-clusters). Dedicated clusters are a deployment option that enables advanced capabilities for Azure Monitor Logs, including availability zones. Dedicated clusters created after October 2020 are enabled for availability zones by default in regions where Azure Monitor supports availability zones.

#### Logic Apps business continuity disaster recovery (BCDR) workflows

Logic Apps workflows help you integrate and orchestrate data between apps, cloud services, and on-premises systems by reducing how much code you write. When you plan for business continuity disaster recovery (BCDR), make sure to consider not just your logic apps, but the Azure resources you use with your logic apps. For BCDR guidance and strategies for automated logic apps workflows, see [Business continuity and disaster recovery for Azure Logic Apps](/azure/logic-apps/business-continuity-disaster-recovery-guidance).

### Operations

- Be sure to have a strategy for handling personal data. For more information, see [Guidance for personal data stored in Log Analytics and Application Insights](/azure/azure-monitor/logs/personal-data-mgmt).

- Ensure regulatory compliance with the following guidelines:

  - [Azure Security Baseline for Azure Monitor](/security/benchmark/azure/baselines/monitor-security-baseline?toc=/azure/azure-monitor/toc.json)
  - [Azure Policy Regulatory Compliance Controls for Azure Monitor](/azure/azure-monitor/security-controls-policy)

#### Costs

Consider the following operational best practices to help keep costs in check:

- Enable alerts only at times when data collection is high.
- Review Azure Monitor [monitoring solutions](/azure/azure-monitor/insights/solutions) before you implement them. For example, enabling Security Center to collect and audit security event data could exponentially increase data collection costs.
- Rationalize alert creation across the board. Consider creating a single alert instead of each workspace or team having the same alert.
- Group resources like alerts, Logic Apps, and workspaces in separate resource groups, and use tagging for identification.
- Use Log Analytics Workspace Insights for an overall view of costs across different workspaces.
- Use the Azure Monitor agent for granular data collection, to the level of collecting single Event IDs from System event logs. Fine-tuning data collection can provide cost efficiencies.
- Use Azure Monitor Data Export for data archival to low-cost storage.
- Follow best practices for telemetry data in Application Insights workspaces. For more information, see [Manage usage and costs for Application Insights](/azure/azure-monitor/app/pricing).

### Performance

The following performance considerations apply to this architecture:

#### Latency

Latency refers to the amount of time between data creation on the monitored system and its availability for analysis in Azure Monitor. The typical latency to ingest log data is between 20 seconds and three minutes.

To ensure minimal latency, place Azure Monitor workspaces, Logic Apps, and other related infrastructure in the same Azure region that hosts the workloads being monitored. However, there could still be latency issues. The specific latency for any data varies depending on various factors.

The total ingestion time for a particular set of data consists of the following time frames:

- Agent time: The time to discover an event, collect it, and send it to the Azure Monitor Logs ingestion point as a log record. In most cases, an agent handles this process. The network can introduce extra latency.
- Pipeline time: The time for the ingestion pipeline to process the log record. This time includes parsing the event properties and possibly adding calculated information.
- Indexing time: The time spent to ingest a log record into the Azure Monitor big data store.

For more information, see [Log data ingestion time in Azure Monitor](/azure/azure-monitor/logs/data-ingestion-time).

#### Log vs. metric alerts

Metric alerts check at regular intervals whether conditions in one or more metric time-series are true, and notify you when the evaluations are met. Metric alerts are stateful by default, sending notifications only when the state changes, for example to *fired* or *resolved*. Log alerts use a Log Analytics query to evaluate resource logs at a set frequency, and fire an alert based on the results.  Metric based alerts can be faster to send notifications than log alerts.

### Scalability

Azure Monitor has service limits per subscription for alerts, action groups, workspaces, and Application Insights. For more information, see [Azure Monitor service limits](/azure/azure-monitor/service-limits).

Review and be aware of [Azure subscription service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits), especially limits for [Logic Apps](/azure/logic-apps/logic-apps-limits-and-config?tabs=azure-portal) and [Azure Automation](/azure/azure-resource-manager/management/azure-subscription-service-limits#automation-limits).

### Security

This architecture follows a resource-context log model. Every log record an Azure resource emits is automatically associated with the resource. This model helps separate workspaces that collect and ingest from different app owners in an organization. You can use Azure role-based access control (RBAC) to lock down the resource group that hosts alerts and Logic Apps per team or app owner.

Log Analytics Workspace Insights forwards logs to a central workspace to give the central team an overview of all the workspaces' usage, cost, and performance. You align with your IT organization's operating model by using a single workspace to store collected data from all your resources. The central workspace respects scoping and RBAC based on the resources.

#### Access control

With Azure RBAC, you can grant users and groups only the amount of access they need to work with monitoring data in a workspace. For example, you can grant access to the team responsible for infrastructure services hosted on Azure VMs, and they'll have access to only the logs generated by the VMs.

The data a user has access to is determined by a combination of factors.

|Factor|Description|
|------|-----------|
|[Access mode](/azure/azure-monitor/logs/design-logs-deployment#access-mode)|Method the user uses to access the workspace. Defines the scope of the data available and the access control mode applied.|
|[Access control mode](/azure/azure-monitor/logs/design-logs-deployment#access-control-mode)|Setting on the workspace that defines whether permissions are applied at the workspace or resource level.|
|[Permissions](/azure/azure-monitor/logs/manage-access)|Permissions applied to individuals or groups for the workspace or resource. Defines what data the user will have access to.|
|[Table-level Azure RBAC](/azure/azure-monitor/logs/manage-access#table-level-azure-rbac)|Optional granular permissions that apply to all users regardless of their access mode or access control mode. Defines which data types a user can access.|

For more information, see [Access control overview](/azure/azure-monitor/logs/design-logs-deployment#access-control-overview).

#### Private Endpoint connectivity over ExpressRoute

You can use [Azure Private Link](/azure/private-link/private-link-overview) to securely link Azure PaaS resources to your virtual network with private endpoints. Azure Monitor is a constellation of different interconnected services that work together to monitor your workloads. An Azure Monitor Private Link Scope connects a private endpoint to a set of Azure Monitor resources, defining the boundaries of your monitoring network. For more information, see [Use Azure Private Link to connect networks to Azure Monitor](/azure/azure-monitor/logs/private-link-security).

#### Logic Apps integration service environment (ISE)

An integration service environment (ISE) environment uses dedicated storage and other resources that are kept separate from the global, multi-tenant Logic Apps service. For more information, see [Connect to Azure virtual networks from Azure Logic Apps using an integration service environment (ISE)](/azure/logic-apps/connect-virtual-network-vnet-isolated-environment).

#### Log Analytics gateway

The Log Analytics gateway sends data to Azure Automation and a Log Analytics workspace in Azure Monitor for computers that can't directly connect to the internet. For more information, see [Connect computers without internet access by using the Log Analytics gateway in Azure Monitor](/azure/azure-monitor/agents/gateway).

#### Azure Automation Hybrid Runbook Worker

Azure Automation runbooks that run in Azure might not have access to resources in other clouds or on-premises. You can use the Azure Automation Hybrid Runbook Worker to run runbooks directly on the machine that's hosting the role. You can run the runbook against resources in the environment to manage the local resources. For more information, see [Automation Hybrid Runbook Worker overview](/azure/automation/automation-hybrid-runbook-worker).

### Considerations checklist

> [!div class="checklist"]
> - Enable Azure Monitor solutions gradually, to minimize impact on environment and cost.
> - Refer to Azure service limits on all architectural components.
> - Set alerts on cost limits. Adding new solutions can increase the data collected multifold, thus increasing costs.
> - Use tagging across all the resource groups and resources to help drill down into costs if necessary.
> - Automate workspace deployment through infrastructure-as-code (IaC) for consistency.
> - Create workspaces in the same region as running workloads, to provide lower ingestion latency.
> - For on-premises machines with no internet connectivity, use Azure Arc over Log Analytics Gateway.
> - For on-premises machines with internet connectivity that are configured for Azure Arc, group VMs in separate resources per project, and create Data Collector Set rules.
> - Spread alerts across different resource groups to avoid hitting subscription limits of 800 deployments per resource group.
> - Rationalize alerts to use a single alert across different teams.
> - Review security requirements for network, user, and overall cloud services.
> - Create a separate resource group for each workspace to help apply role-based access control (RBAC) rules effectively.
> - Apply RBAC to user accounts and other objects for Log Analytics workspace access.
> - Use Azure Sentinel to ingest identity and security-related logs.
> - Monitor live applications with Application Insights to automatically detect performance anomalies.
> - Use Application Insights analytics tools to help diagnose issues and understand app usage.
> - Use Log Analytics Workspace Insights across the board to monitor and set alerts for the following measures:
>   - Ingestion latency
>   - Data ingestion volume
>   - Ingestion anomalies
>   - Agent health
> - Use the Azure Monitor agent to fine tune data collection.
> - Consider data archival to a cool storage tier. You can integrate cool data storage with data lake services.

## Pricing

- Azure Monitor includes functionality for collecting and analyzing log data. Azure Monitor bills by data ingestion, retention, and export. Other factors that can affect pricing include alerts, notifications, and SMS or voice calls. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor).

- The default pricing for [Application Insights](/azure/azure-monitor/app/pricing) and [Log Analytics](/services-hub/health/azure_pricing) is a Pay-As-You-Go model based on ingested data volume and, optionally, longer data retention. Log Analytics also has Commitment Tiers, which can save you as much as 30 percent compared to the Pay-As-You-Go price.

- Review [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps) and [Azure Automation pricing](https://azure.microsoft.com/pricing/details/automation).

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) for a deeper dive into pricing.

## Next steps

- [What is monitored by Azure Monitor?](/azure/azure-monitor/monitor-reference)
- [Azure Monitor data platform](/azure/azure-monitor/data-platform)
- [Overview of alerts in Microsoft Azure](/azure/azure-monitor/alerts/alerts-overview)
- [Azure Monitor best practices - Analyze and visualize data](/azure/azure-monitor/visualizations)
- [Azure Monitor Microsoft Learning path](/learn/paths/monitor-usage-performance-availability-resources-azure-monitor)

## Related resources

- [Microsoft Well-Architected Framework operational excellence](../../framework/devops/index.yml)
- [Monitoring for DevOps](../../framework/devops/monitoring.md)
- [Alerting](../../framework/devops/alerts.md)
- [Hybrid availability and performance monitoring](../../hybrid/hybrid-perf-monitoring.yml)
- [Web application monitoring on Azure](../../reference-architectures/app-service-web-app/app-monitoring.yml)

