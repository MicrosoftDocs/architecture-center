---
title: Check for identity, network, data risks
description: Monitor identity-related risk events for warning on potentially compromised identities and remediate those risks.
author: PageWriter-MSFT
ms.date: 09/14/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-active-directory
  - azure-machine-learning
ms.custom:
  - article
---

# Check for identity, network, data risks

Along with identity-based access control, network-based access control is a top priority for protecting assets. 

Monitor identity-related risk events using adaptive machine learning algorithms, heuristics quickly before the attacker can gain deeper access into the system. Also, monitor all communications between [segments](design-network-segmentation.md) to detect potential security threats flowing over the wire. 

This article describes some considerations that can help monitor the workload for those risks.

## Key points
- View identity related risks in Azure Active Directory (Azure AD) reporting and Azure AD Identity Protection.
- Obfuscate personal information in application logs.
- Enable logs (including raw traffic) from your network devices. 
- Set alerts and gain access to real-time performance information at the packet level. 

## Review identity risks

Most security incidents take place after an attacker initially gains access using a stolen identity. 

Suppose an attacker gains access using a stolen identity. Even though the identity has low privileges, the attacker can use it to traverse laterally and gain access to more privileged identities. This way the attacker can control access to the target data or systems.

**Does the organization actively monitor identity-related risk events related to potentially compromised identities?**
***

Monitor identity-related risk events on potentially compromised identities and remediate those risks. 
Review the reported risk events in these ways:

- Azure AD reporting. For information, see [users at risk security report](/azure/active-directory/reports-monitoring/concept-user-at-risk) and the [risky sign-ins security report](/azure/active-directory/reports-monitoring/concept-risky-sign-ins).
- Use the reporting capabilities of [Azure Active Directory Identity Protection](/azure/active-directory/active-directory-identityprotection).
- Use the Identity Protection risk events API to get programmatic access to security detections by using Microsoft Graph. See [riskDetection](/graph/api/resources/riskdetection?view=graph-rest-1.0&preserve-view=true) and [riskyUser](/graph/api/resources/riskyuser?view=graph-rest-1.0&preserve-view=true) APIs.

Azure AD uses adaptive machine learning algorithms, heuristics, and known compromised credentials (username/password pairs) to detect suspicious actions that are related to your user accounts. These username/password pairs come from monitoring public and dark web and by working with security researchers, law enforcement, security teams at Microsoft, and others. 

Remediate risks by manually addressing each reported account or by setting up a [user risk policy](/azure/active-directory/identity-protection/howto-user-risk-policy) to require a password change for high risk events. 

## Mask personal information

**Is personal information detected and removed/obfuscated automatically?**
***

Be cautious when logging sensitive application information. Don't store  personal information such as contact information, payment information, and so on, in any application logs. Apply protective measures, such as obfuscation. Machine learning tools can help with this measure. For more information, see [PII Detection cognitive skill](/azure/search/cognitive-search-skill-pii-detection).


## Enable network visibility

One way to enable network visibility is by integrating network logs and analyzing the data to identify anomalies. Based on those insights, you can choose to set alerts or block traffic crossing segmentation boundaries.

**How do you monitor and diagnose conditions of the network?** 
***

Enable logs (including raw traffic) from your network devices. 

Integrate network logs into a security information and event management (SIEM) service, such as Azure Sentinel. Other popular choices include Splunk, QRadar, or ArcSight ESM.

Use machine learning analytics platforms that support ingestion of large amounts of information and can analyze large datasets quickly. Also, these solutions can be tuned to significantly reduce the false positive alerts. 

Here are some ways to integrate network logs:

- Security group logs – [flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-portal) and diagnostic logs
- [Web application firewall logs](/azure/application-gateway/application-gateway-diagnostics)
- [Virtual network taps](/azure/virtual-network/virtual-network-tap-overview)
- [Azure Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview)

## Proactive monitoring
**How do you gain access to real-time performance information at the packet level?** 
***

Take advantage of [packet capture](/azure/network-watcher/network-watcher-alert-triggered-packet-capture) to set alerts and gain access to real-time performance information at the packet level. 

Packet capture tracks traffic in and out of virtual machines. It gives you the capability to run proactive captures based on defined network anomalies including information about network intrusions. 

For an example, see [Scenario: Get alerts when VM is sending you more TCP segments than usual](/azure/network-watcher/network-watcher-alert-triggered-packet-capture#scenario).


## Next steps
- [Security health modeling](monitor.md)
- [Security operations in Azure](monitor-security-operations.md)
- [Security tools](monitor-tools.md)
- [Security logs and audits](monitor-audit.md)
