---
title: "Fusion: What tools can help support monitoring and enforcement in Azure?"
description: Explanation of the tools that can facilitate monitoring and enforcement in Azure
author: BrianBlanchard
ms.date: 12/26/2018
---

# Fusion: What tools can help support monitoring and enforcement in Azure?

Monitoring tools provide visibility into the behavior and operations or your cloud-based resources. The reports and alerts generated from monitoring systems are critical for IT staff to detect and resolve performance issues, security vulnerabilities, or otherwise enforce policy standards. Monitoring systems are also critical in triggering automation remediation systems. These systems also provide the historical usage, access and security data needed to chart future policy goals in all of the five core [cloud governance disciplines](../overview.md).

Unlike the cloud-agnostic position used throughout Fusion, this article is Azure specific. The following is a list of Azure native tools that can help support the monitoring and policy enforcement goals for your cloud estate. 

|                         | [Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) | [Azure Cost Management](https://docs.microsoft.com/en-us/azure/cost-management/overview-cost-mgt)  | [Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/security-center-intro)  | [Azure Active Directory Reports](https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/overview-reports)  | [Compliance Manager](https://docs.microsoft.com/en-us/office365/securitycompliance/meet-data-protection-and-regulatory-reqs-using-microsoft-cloud)  |
|-------------------------|--------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------|
| Monitor resource performance                               | Yes | No  | No  | No  | No  |
| Monitor security health of networks and resources          | Yes | No  | Yes | No  | No  |
| Detect access issues                                       | Yes | No  | No  | Yes | No  |
| Detect security vulnerabilities                            | Yes | No  | No  | No  | Yes |
| Detect malicious activity                                  | Yes | No  | Yes | Yes | No  |
| Detect configuration drift                                 | Yes | No  | No  | No  | Yes |
| Detect policy non-compliance                               | Yes | No  | No  | No  | Yes |
| Monitor usage/costs                                        | Yes | Yes | No  | No  | No  |
| Trigger alerts                                             | Yes | No  | No  | No  | No  |
| Trigger automated remediation                              | Yes | No  | No  | No  | No  |
| Export historical log data                                 | Yes | No  | No  | Yes | No  |

Note this list represents a high-level list of monitoring requirements. See the specific toolchain pages for each of the five cloud governance disciplines for a more specific listing of how monitoring is used in each discipline:

* [Configuration management](../configuration-management/toolchain.md)
* [Cost management](../cost-management/toolchain.md)
* [Identity management](../identity-management/toolchain.md)
* [Resource management](../resource-management/toolchain.md)
* [Security management](../security-management/toolchain.md)