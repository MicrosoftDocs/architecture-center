---
title: Monitor identity risk
description: Monitor identity-related risk events for warning on potentially compromised identities and remediate those risks.
author: PageWriter-MSFT
ms.date: 09/14/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitor identity risk

Monitor identity-related risk events on potentially compromised identities and remediate those risks.

Suppose an attacker gains access using a stolen identity. Even though the identity has low privileges, the attacker can use it to traverse laterally and gain access to more privileged identities. This way the attacker can control access to the target data or systems.

**How do you actively monitor for suspicious activities?**
***

Azure Active Directory (Azure AD) uses adaptive machine learning algorithms, heuristics, and known compromised credentials (username/password pairs) to detect suspicious actions that are related to your user accounts. These username/password pairs come from monitoring public and dark web and by working with security researchers, law enforcement, security teams at Microsoft, and others. 

Review the reported risk events by using,

- Azure AD reporting. For information, see [users at risk security report](/azure/active-directory/reports-monitoring/concept-user-at-risk) and the [risky sign-ins security report](/azure/active-directory/reports-monitoring/concept-risky-sign-ins).
- [Azure Active Directory Identity Protection](/azure/active-directory/active-directory-identityprotection).


Also, you can use the Identity Protection risk events API to gain programmatic access to security detections by using Microsoft Graph.

Remediate risks by manually addressing each reported account or by setting up a [user risk policy](/azure/active-directory/identity-protection/howto-user-risk-policy) to require a password change for high risk events. 

