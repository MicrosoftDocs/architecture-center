---
title: Integrate security logs and alerts in Azure
description: Remediate the common risks identified by Azure Security Center.
author: PageWriter-MSFT
ms.date: 03/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
---

# Security logs and alerts 

PRIORITIZE ALERT AND LOG INTEGRATION
Ensure that you are integrating critical security alerts and logs into SIEMs without introducing a high volume of low value data. 
Introducing too much low value data can increase SIEM cost, increase noise and false positives, and lower performance. 
The data you collect should be focused on supporting one or more of these operations activities:
•	Alerts (detections from existing tools or data required for generating custom alerts)
•	Investigation of an incident (e.g. required for common queries)
•	Proactive hunting activities
Integrating more data can allow you to enrich alerts with additional context that enable rapid response and remediation (filter false positives, and elevate true positives, etc.), but collection is not detection. If you don’t have a reasonable expectation that the data will provide value (e.g. high volume of firewall deny events), you may deprioritize integration of these events. 

## Mask personal information

**Is personal information detected and removed/obfuscated automatically?**
***

Be cautious when logging sensitive application information. Don't store  personal information such as contact information, payment information, and so on, in any application logs. Apply protective measures, such as obfuscation. Machine learning tools can help with this measure. For more information, see [PII Detection cognitive skill](/azure/search/cognitive-search-skill-pii-detection).


## Next steps
> [!div class="nextstepaction"]
> [Compliance monitoring](monitor-audit.md)