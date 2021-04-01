---
title: Security logs and audits
description: Security logging and monitoring focuses on activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-monitor
ms.custom:
  - article
---

# Security audits 

To make sure that the security posture doesn’t degrade over time, have regular auditing that checks compliance with organizational standards. Enable, acquire, and store audit logs for Azure services.

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

## Review critical access

**Is access to the control plane and data plane of the application periodically reviewed?**
***

Regularly review roles that have high privileges. Set up a recurring review pattern to ensure that accounts are removed from permissions as roles change. Consider auditing at least twice a year.

As people in the organization and on the project change, make sure that only the right people have access to the application infrastructure. Auditing and reviewing the access control reduces the attack vector to the application. 

Azure control plane depends on Azure AD. You can conduct the review manually or through an automated process by using tools such as [Azure AD access reviews](/azure/active-directory/governance/create-access-review). These reviews are often centrally performed often as part of internal or external audit activities. 

## Enforce policy compliance

Make sure that the security team is auditing the environment to report on compliance with the security policy of the organization. Security teams may also enforce compliance with these policies. 

Enforce and audit industry, government, and internal corporate security policies. Policy monitoring checks that initial configurations are correct and that it continues to be compliant over time. 

For Azure, use Azure Policy to create and manage policies that enforce compliance.  Azure Policies are built on the Azure Resource Manager capabilities.  Azure Policy can also be assigned through Azure Blueprints. 
For more information, see [Tutorial: Create and manage policies to enforce compliance](/azure/governance/policy/tutorials/create-and-manage).

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

## Next steps
- [Security health modeling](monitor.md)
- [Security operations in Azure](monitor-security-operations.md)
- [Check for identity, network, data risks](monitor-identity-network.md)
- [Security tools](monitor-tools.md)
