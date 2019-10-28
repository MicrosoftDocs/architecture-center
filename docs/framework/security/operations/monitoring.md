---
title: monitoring
description: Detect, respond, and recover the system when it's attacked.
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How are you monitoring the security posture of your workload? 
---

# monitoring

Security operations maintain and restores the security assurances of the system
as live adversaries attack it. The tasks of security operations are
described well by the NIST Cybersecurity Framework functions of Detect, Respond,
and Recover.

-   **Detect** - Security operations must detect the presence of adversaries in
    the system, who are incented to stay hidden in most cases as this allows
    them to achieve their objectives unimpeded. This can take the form of
    reacting to an alert of suspicious activity or proactively hunting for
    anomalous events in the enterprise activity logs.

-   **Respond** – Upon detection of potential adversary action or campaign,
    security operations must rapidly investigate to identify whether it is an
    actual attack (true positive) or a false alarm (false positive) and then
    enumerate the scope and goal of the adversary operation.

-   **Recover** – The ultimate goal of security operations is to preserve or
    restore the security assurances (confidentiality, integrity, availability)
    of business services during and after an attack.

The most significant security risk most organizations face is from human attack
operators (of varying skill levels). This is because risk from
automated/repeated attacks have been mitigated significantly for most
organizations by signature and machine learning based approaches built into
anti-malware (though there are notable exceptions like Wannacrypt and NotPetya, which moved faster than these defenses).

While human attack operators are challenging to face because of their
adaptability (vs. automated/repeated logic), they are operating at the same
'human speed' as defenders, which help level the playing field.

Security Operations (sometimes referred to as a Security Operations Center
(SOC)) has a critical role to play in limiting the time and access an attacker
can get to valuable systems and data. Each minute that an attacker has in the
environment allows them to continue to conduct attack operations and access
sensitive/valuable systems.<!-- You have clear objectives and metrics related to security -->
[!include[6f9f761c-a641-4a4f-8d08-f4633d6c572b](../../../includes/aar_guidance/6f9f761c-a641-4a4f-8d08-f4633d6c572b.md)]

<!-- You take a hybrid enterprise view -->
[!include[fcf38a59-96f7-46d3-8d34-59abce36afbd](../../../includes/aar_guidance/fcf38a59-96f7-46d3-8d34-59abce36afbd.md)]

<!-- You prioritize alert and log integration -->
[!include[5ce44d51-656e-4c30-97f8-d66306197425](../../../includes/aar_guidance/5ce44d51-656e-4c30-97f8-d66306197425.md)]

<!-- correlating calls across systems (end-to-end tracing) -->
[!include[814ddc02-75cb-4873-97ba-79248fad892e](../../../includes/aar_guidance/814ddc02-75cb-4873-97ba-79248fad892e.md)]

<!-- Admin credential usage -->
[!include[62a2d031-ea56-4acf-b3c2-b939749564f0](../../../includes/aar_guidance/62a2d031-ea56-4acf-b3c2-b939749564f0.md)]

<!-- Actively monitor logs for suspicious activity -->
[!include[67934fd1-d3ef-4850-a632-ec5b18e90541](../../../includes/aar_guidance/67934fd1-d3ef-4850-a632-ec5b18e90541.md)]

<!-- Audit access log -->
[!include[02e4510e-5069-4569-ac53-c04431b986dd](../../../includes/aar_guidance/02e4510e-5069-4569-ac53-c04431b986dd.md)]

<!-- Understand who has access to what data -->
[!include[b649d9e0-78a5-4ffe-89a1-16700e0ba36d](../../../includes/aar_guidance/b649d9e0-78a5-4ffe-89a1-16700e0ba36d.md)]

<!-- Trace requests -->
[!include[00af55cf-b32d-49c5-9baf-84446d8f0dc1](../../../includes/aar_guidance/00af55cf-b32d-49c5-9baf-84446d8f0dc1.md)]

<!-- How do you collect and process data about resources (security event log, Windows firewall log, antimalware assessment)? -->
[!include[51b68716-7d41-43f3-820b-f3086e5425bd](../../../includes/aar_guidance/51b68716-7d41-43f3-820b-f3086e5425bd.md)]

<!-- You leverage native detection and controls -->
[!include[27a38978-7a94-431a-80dd-a69dc2215f54](../../../includes/aar_guidance/27a38978-7a94-431a-80dd-a69dc2215f54.md)]

<!-- You monitor identity risk -->
[!include[7f5f2838-cdd3-433e-8e73-1edd2ac47538](../../../includes/aar_guidance/7f5f2838-cdd3-433e-8e73-1edd2ac47538.md)]

<!-- Manage antimalware -->
[!include[f309d196-d72c-4e10-b247-189c88888b40](../../../includes/aar_guidance/f309d196-d72c-4e10-b247-189c88888b40.md)]

<!-- Workload hardening -->
[!include[aaec024a-38e5-408b-aeb6-21936d363537](../../../includes/aar_guidance/aaec024a-38e5-408b-aeb6-21936d363537.md)]

<!-- DNS Monitoring -->
[!include[a5ef014a-105b-4677-927f-796add134010](../../../includes/aar_guidance/a5ef014a-105b-4677-927f-796add134010.md)]

<!-- Threat response -->
[!include[757b2190-c991-4241-84ee-994b74489ba0](../../../includes/aar_guidance/757b2190-c991-4241-84ee-994b74489ba0.md)]

