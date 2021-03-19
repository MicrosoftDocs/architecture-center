---
title: Logs and alerts
description: Security logging and monitoring focuses on activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
  - azure-policy
azure-category: management-and-governance
ms.custom:
  - article
---

# Logs and alerts


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


You can use Azure Monitor to collect information about the operating system running on Azure compute. If your are running your own compute, use Azure Security Center. For more information, see [Understand Azure Security Center data collection](/azure/security-center/security-center-enable-data-collection).

Within Azure Monitor, create Log Analytics Workspace to store logs. You can also review logs and perform queries on log data. Set the retention period according to your organization's compliance regulations. Use Azure Storage Accounts for long-term/archival storage. 

## Prioritize alert and log integration

Ensure that you are integrating critical security alerts and logs into SIEMs without introducing a high volume of low value data. Doing so can increase SIEM cost, false positives, and lower performance.

Use the data to support these activities:

- Alerts. Use existing tools or data required for generating custom alerts.
- Investigation of an incident. For example, required for common queries.
- Proactive hunting activities.

Integrating more data can allow you to enrich alerts with additional context that enable rapid response and remediation (filter false positives, and elevate true positives, and so on.), but collection is not detection. If you don’t have a reasonable expectation that the data will provide value (for example, high volume of firewall denies events), you may deprioritize integration of these events.