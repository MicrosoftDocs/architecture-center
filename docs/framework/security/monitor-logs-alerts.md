---
title: Security alerts in Azure
description: Use security logs to view operations and raise alerts on anomalous activities in Microsoft Defender for Cloud.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
  - azure-sentinel
  - azure-monitor
categories:
  - security
subject:
  - security
  - monitoring
---

# Security logs and alerts using Azure services

Logs provide insight into the operations of a workload, the infrastructure, network communications, and so on. When suspicious activity is detected, use alerts as a way of detecting potential threats. As part of your defense-in-depth strategy and continuous monitoring, respond to the alerts to prevent security assurance from decaying over time.

## Key points

> [!div class="checklist"]
>
> - Configure central security log management.
> - Enable audit logging for Azure resources.
> - Collect security logs from operating systems.
> - Configure security log storage retention.
> - Enable alerts for anomalous activities.

## Use native services

- **Azure Monitor** provides observability across your entire environment. You automatically get platform metrics, activity logs, and diagnostics logs from most of your Azure resources with no configuration. The activity logs provide detailed diagnostic and auditing information.

- **Microsoft Defender for Cloud** generates notifications as security alerts by collecting, analyzings, and integrating log data from your Azure resources and the network. Alerts are available when you enable the Microsoft Defender plans. This will add to the overall cost.

- **Microsoft Sentinel** is a security information event management (SIEM) and security orchestration automated response (SOAR) solution. It's a single solution for alert detection, threat visibility, proactive hunting, and threat response.

Ideally use a combination of the preceding services to get a full view. For example, use Azure Monitor to collect information about the operating system running on Azure compute. If you're running your own compute, use Microsoft Defender for Cloud.

## Audit logging

An important aspect of monitoring is tracking operations. For example, you want to know who created, updated, deleted a resource. Or, get resource-specific information such as when an image was pulled from Azure Container Registry. That information is crucial for a Security Operations (SecOps) team in detecting the presence of adversaries, reacting to an alert of suspicious activity, or proactively hunting for anomalous events. They are also useful for security auditing and compliance and offline analysis.

On Azure, that information is emitted as [platform logs](/azure/azure-monitor/essentials/platform-logs-overview) by the resources and the platform on which they run. They are tracked by Azure Resource Manager as and when subscription-level events occur. Each resource emits logs specific to the service.

Consider storing your data for audit purposes or statistical analysis. You can retain data in your log analytics workspace and specify the data type. This example sets the retention for `SecurityEvents` to 730 days:

```http
PUT /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/Microsoft.OperationalInsights/workspaces/MyWorkspaceName/Tables/SecurityEvent?api-version=2017-04-26-preview {"properties":  {"retentionInDays": 730 } }
```

Retaining data in this manner can reduce your costs for data retention over time. For information about the type of data you can retain, see [security data types](/azure/azure-monitor/reference/tables/tables-category#security).

Another way is to send the logs to a storage account.

## Alerts

Security alerts are notifications that are generated when anomalous activity is detected on the resources used by the workload or the platform.

With the Microsoft Defender plans, Microsoft Defender for Cloud  analyzes log data and shows a list of alerts that's based on logs collected from resources within a scope. Alerts include context information such as severity, status, activity time. Defender for Cloud also provides a correlated view called **incidents**. Use this data to analyze what actions the attacker took, and what resources were affected. Have strategies to react to alerts as soon as they are generated. An option is to  handle alerts in Azure Functions.

Use the data to support these activities:

- Remediation of threats.
- Investigation of an incident.
- Proactive hunting activities.

For more information, see [Security alerts and incidents](/azure/security-center/security-center-alerts-overview).

## Centralize logs and alerts

Organizations typically follow one of three models when deploying logs: centralized, decentralized, or hybrid. The choice depends on organizational structures. For example, if each team owns their resource group, log data is segregated per resource. While access control to that data might be easy to set up, it's difficult to correlate logs. This might be challenging for the SecOps team who need a holistic view to analyze the data.

Consider a central view of log and data, when applicable. Some advantages include:

- The resources in the workload can share a common log workspace reducing duplication.
- Single point of observability with all log data makes it easier consume data for hunting activities, querying, and statistical evaluation.
- The integrated data can be fed into modern machine learning analytics platforms support ingestion of large amounts of information and can analyze large datasets quickly. In addition, these solutions can be tuned to significantly reduce the false positive alerts.

You can collect logs and alerts from various sources centrally in a Log Analytics Workspace, storage account, and Event Hubs. You can then review and query log data efficiently. In Azure Monitor, use the **diagnostic setting** on resources to route specific logs that are important for the organization. Logs vary by resource type. In Microsoft Defender for Cloud, take advantage of the continuous export feature to route alerts.

> [!NOTE]
> Platform logs are not available indefinitely. You'll need to keep them so that you can review them later for auditing purposes or offline analysis. Use Azure Storage Accounts for long-term/archival storage. In Azure Monitor, specify a retention period when you enable diagnostic setting for your resources.

Another way to see all data in a single view is to integrate logs and alerts into Security Information and Event Management (SIEM) solutions, such as Microsoft Sentinel. Other popular third-party choices are Splunk, QRadar, ArcSight. Microsoft Defender for Cloud and Azure Monitor supports all of those solutions.

Integrating more data can enrich alerts with additional context. However, collection is not detection. Make sure a high volume of low value data doesn't flow into those solutions.

If you don't have a reasonable expectation that the data will provide value, deprioritize integration of these events. For example, high volume of firewall denies events may create noise without actual actions.

That choice will help in rapid response and remediation by filtering out false positives, and elevate true positives, and so on. Also it will lower SIEM cost, false positives, and increase performance.

Other ways of log integration may involve a hybrid model that mixes centralized and decentralized (distributed among teams) approaches. For details, see [Important considerations for an access control strategy](/azure/azure-monitor/logs/design-logs-deployment#important-considerations-for-an-access-control-strategy).

## Next

Responding to alerts is an essential way to prevent security assurance decay, and designing for defense-in depth and least privilege strategies.

> [!div class="nextstepaction"]
> [Remediate security risks](monitor-remediate.md)

## Related links

For more information, see these articles:

- [How to get started with Azure Monitor and third-party SIEM integration](https://azure.microsoft.com/blog/use-azure-monitor-to-integrate-with-siem-tools/)
- [How to collect platform logs and metrics with Azure Monitor](/azure/azure-monitor/platform/diagnostic-settings)
- [Export alerts](/azure/security-center/security-center-alerts-overview#export-alerts)
- [Understand Microsoft Defender for Cloud data collection](/azure/security-center/security-center-enable-data-collection)

> Go back to the main article: [Monitor](monitor.md)
