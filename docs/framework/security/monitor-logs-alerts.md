---
title: Security alerts in Azure
description: Remediate the common risks identified by Azure Security Center.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Security logs and alerts 

Logs provide insight into the operations of a workload, the infrastructure, network communications, and so on. When suspicious activity is detected, use alerts as a way of detecting potential threats. As part of your defense-in-depth strategy and continuous monitoring, respond to the alerts to prevent security assurance from decaying over time. 

## Key points

- Configure central security log management.
- Enable audit logging for Azure resources.
- Collect security logs from operating systems.
- Configure security log storage retention.
- Enable alerts for anomalous activities.
- Centralize anti-malware logging.
- Enable DNS query logging.
- Enable command-line audit logging.

## Use native services

- **Azure Monitor** provides observability across your entire environment. You automatically get platform metrics, activity logs, and diagnostics logs from most of your Azure resources with no configuration. The activity logs provide detailed diagnostic and auditing information.

- **Azure Security Center** generates notifications as security alerts by collecting, analyzings, and integrating log data from your Azure resources and the network. Alerts are available when you enable the Azure Defender plan. This will add to the overall cost.  

- **Azure Sentinel** is a security information event management (SIEM) and security orchestration automated response (SOAR) solution. It's a single solution for alert detection, threat visibility, proactive hunting, and threat response.

Ideally use a combination of the preceding services to get a full view. For example, use Azure Monitor to collect information about the operating system running on Azure compute. If you're running your own compute, use Azure Security Center. 

## Audit logging
An important aspect of monitoring is tracking operations. For example, you want to know who created, updated, deleted a resource. Or, get resource-specific information such as when an image was pulled from Azure Container Registry. That information is crucial for a Security Operations (SecOps) team in detecting the presence of adversaries, reacting to an alert of suspicious activity, or proactively hunting for anomalous events. They are also useful for security auditing and compliance and offline analysis.

On Azure, that information is emitted as [platform logs](/azure/azure-monitor/essentials/platform-logs-overview) by the resources and the platform on which they run. They are tracked by Azure Resource Manager as and when subscription-level events occur. Each resource emits logs specific to the service.

Consider sending your logs to a storage account for statistical analysis.

## Alerts
Security alerts are notifications that are generated when anomalous activity is detected on the resources used by the workload or the platform.

With the Azure Defender plan, Azure Security Center  analyzes log data and shows a list of alerts that's based on logs collected from resources within a scope. Alerts include context information such as severity, status, activity time. Security center also provides a correlated view called **incidents**. Use this data to analyze what actions the attacker took, and what resources were affected.

Use the data to support these activities:

- Remediation of threats.
- Investigation of an incident. 
- Proactive hunting activities.

For more information, see [Security alerts and incidents](/azure/security-center/security-center-alerts-overview).

## Centralize logs and alerts

A central view of log and data is recommended. Some advantages include:
- The resources in the workload can share a common log workspace reducing duplication.
- Single point of observability with all log data makes it easier consume data for hunting activities, querying, and statistical evaluation.
- The integrated data can be fed into modern machine learning analytics platforms support ingestion of large amounts of information and can analyze large datasets quickly. In addition, these solutions can be tuned to significantly reduce the false positive alerts.

You can collect logs and alerts from various sources centrally in a Log Analytics Workspace, storage account, and Event Hubs. You can then review and query log data efficiently. In Azure Monitor, use the **diagnostic setting** on resources to route specific logs that are important for the organization. Logs vary by resource type. In Azure Security Center, take advantage of the continuous export feature to route alerts.

> [!NOTE] Storage retention
>
> Platform logs are not available indefinitely. You'll need to keep them so that you can review them later for auditing purposes or offline analysis. Use Azure Storage Accounts for long-term/archival storage. In Azure Monitor, specify a retention period when you enable diagnostic setting for your resources.

Another way to see all data in a single view is to integrate logs and alerts into Security Information and Event Management (SIEM) solutions, such as Azure Sentinel. Other popular third-party choices are Splunk, QRadar, ArcSight. Azure Security Center and Azure Monitor supports all of those solutions.  

Integrating more data can enrich alerts with additional context. However, collection is not detection.
Make sure a high volume of low value data doesn't flow into those solutions. 

If you don’t have a reasonable expectation that the data will provide value, deprioritize integration of these events. For example, high volume of firewall denies events may create noise without actual actions.

That choice will help in rapid response and remediation by filtering out false positives, and elevate true positives, and so on. Also it will lower SIEM cost, false positives, and increase performance.

## Next steps
Responding to alerts is an essential way to prevent security assurance decay, and designing for defense-in depth and least privilege strategies.

> [!div class="nextstepaction"]
> [Remediate security risks](monitor-remediate.md)

## Related links

For more information, see these articles:

- [How to get started with Azure Monitor and third-party SIEM integration](https://azure.microsoft.com/blog/use-azure-monitor-to-integrate-with-siem-tools/)
- [How to collect platform logs and metrics with Azure Monitor](/azure/azure-monitor/platform/diagnostic-settings)
- [Export alerts](/azure/security-ce.nter/security-center-alerts-overview#export-alerts)
- [Understand Azure Security Center data collection](/azure/security-center/security-center-enable-data-collection)









Detection can take the form of reacting to an alert of suspicious activity or proactively hunting for anomalous events in the enterprise activity logs. 
vigilantly responding to anomalies and alerts to prevent security assurance decay, and designing for defense in depth and least privilege strategies. 
•	Design security controls that identify and allow expected traffic, access requests, and application communication between segments. Monitor the communication between segments to identify anomalies. It will help you set alerts or block traffic to mitigate the risk of attackers crossing segmentation boundaries. 
The modern machine learning analytics platforms supports ingestion of large amounts of information and can analyze large datasets very quickly. In addition, these solutions can be tuned to significantly reduce the false positive alerts. 

•	Reduce time to acknowledge an alert to ensure that detected attackers are not ignored while defenders are spending time investigating false positives. 

•	On Azure, use capabilities such as Azure Security Center for alert generation. 

Enable, acquire, and store audit logs for Azure services.
## Key points
> [!div class="checklist"]
> - Use approved time synchronization sources.
> - Configure central security log management.
> - Enable audit logging for Azure resources.
> - Collect security logs from operating systems.
> - Configure security log storage retention.
> - Monitor and review logs.
> - Enable alerts for anomalous activities.
> - Centralize anti-malware logging.
> - Enable DNS query logging.
> - Enable command-line audit logging.



## Use native logging through Azure Monitor

Use Azure Monitor to log application activity and feed into a Security Information and Event Management (SIEM). You can also use Azure Monitor to collect activity logs transmitted by Azure resources. Activity logs provide detailed diagnostic and auditing information. 

For more information, see these articles:

- [How to get started with Azure Monitor and third-party SIEM integration](https://azure.microsoft.com/blog/use-azure-monitor-to-integrate-with-siem-tools/)
- [How to collect platform logs and metrics with Azure Monitor](/azure/azure-monitor/platform/diagnostic-settings)


You can use Azure Monitor to collect information about the operating system running on Azure compute. If you're running your own compute, use Azure Security Center. For more information, see [Understand Azure Security Center data collection](/azure/security-center/security-center-enable-data-collection).

Within Azure Monitor, create Log Analytics Workspace to store logs. You can also review logs and perform queries on log data. Set the retention period according to your organization's compliance regulations. Use Azure Storage Accounts for long-term/archival storage. 

## Prioritize alert and log integration

Ensure that you are integrating critical security alerts and logs into SIEMs without introducing a high volume of low value data. Doing so can increase SIEM cost, false positives, and lower performance.

Use the data to support these activities:

- Alerts. Use existing tools or data required for generating custom alerts.
- Investigation of an incident. For example, required for common queries.
- Proactive hunting activities.

Integrating more data can allow you to enrich alerts with additional context that enable rapid response and remediation (filter false positives, and elevate true positives, and so on.), but collection is not detection. If you don’t have a reasonable expectation that the data will provide value (for example, high volume of firewall denies events), you may deprioritize integration of these events.




## Next steps
> [!div class="nextstepaction"]
> [Compliance monitoring](monitor-audit.md)