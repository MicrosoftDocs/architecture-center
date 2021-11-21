---
title: Security operations in Azure | Microsoft Docs
description: "Get information about security operations in Azure. Detect, respond, and recover the system when it&apos;s attacked."
author: PageWriter-MSFT
ms.date: 07/09/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Security operations

Security operations maintain and restores the security assurances of the system as live adversaries attack it. The tasks of security operations are described well by the NIST Cybersecurity Framework functions of Detect, Respond, and Recover.

- **Detect:** Security operations must detect the presence of adversaries in the system, who are incented to stay hidden in most cases, because this allows them to achieve their objectives unimpeded. Examples include reacting to an alert of suspicious activity or proactively hunting for anomalous events in the enterprise activity logs.

- **Respond:** Upon detection of potential adversary action or campaign, security operations must rapidly investigate to identify whether it is an actual attack (true positive) or a false alarm (false positive) and then enumerate the scope and goal of the adversary operation.

- **Recover:** The ultimate goal of security operations is to preserve or restore the security assurances (confidentiality, integrity, availability)
    of business services during and after an attack.

The most significant security risk most organizations face is from human attack operators (of varying skill levels). This is because risk from automated/repeated attacks has been mitigated significantly for most organizations by signature and machine learning based approaches built into anti-malware (though there are notable exceptions like Wannacrypt and NotPetya, which moved faster than these defenses).

While human attack operators are challenging to face because of their adaptability (vs. automated/repeated logic), they are operating at the same
&quot;human speed&quot; as defenders, which help level the playing field.

Security Operations (sometimes referred to as a Security Operations Center (SOC)) has a critical role to play in limiting the time and access an attacker can get to valuable systems and data. Each minute that an attacker has in the environment allows them to continue to conduct attack operations and access sensitive/valuable systems.

## Objective and metrics

The metrics you measure will have a significant effect on the behaviors and outcomes of security operations. Focusing on the right measurements will help drive continuous improvement in the right areas that meaningfully reduce risk.

To ensure that security operations are effectively containing attackers access, the objectives should focus on

- Reducing **time to acknowledge** an alert to ensure that detected adversaries are not ignored while defenders are spending time investigating false positives.

- Reducing **time to remediate** a discovered adversary to reduce their opportunity time to conduct and attack and reach sensitive systems

- **Prioritizing** security investments into systems that have high intrinsic value (likely targets / high business impact) and access to many systems or sensitive systems (administrator accounts and sensitive users)

- Increase focus on **proactively hunting** for adversaries as your program matures and reactive incidents get under control. Focus on reducing the time that a higher-skilled adversary can operate in the environment (for example, skilled enough to evade reactive alerts).

For more information on how Microsoft&apos;s SOC uses these metrics, see https://aka.ms/ITSOC.

## Hybrid enterprise view

Security operations should ensure their tooling, processes, and analyst skillsets enable visibility across the full span of their hybrid estate.

Attackers don&apos;t restrict their actions to a particular environment when targeting an organization, they will attack resources on any platform using any method available. Enterprise organizations adopting cloud services like Azure and AWS are effectively operating a hybrid of cloud and on-premises assets.

Security operations tooling and processes should be designed for attacks on cloud and on-premises assets as well as attackers pivoting between cloud and on-premises resources using identity or other means. This enterprise-wide view will enable security operations teams to rapidly detect, respond, and recover from attacks, reducing organizational risk.

## Apply native detections and controls

When possible, use security detections and controls that are built into the cloud platform before you create custom detections using event logs from the cloud.

Cloud platforms evolve rapidly with new features, which can make maintaining detections challenging. Native controls are maintained by the cloud provider and are typically high quality (low false positive rate).

Because many organizations may use multiple cloud platforms and need a unified view across the enterprise, you should ensure these native detections and controls feed a centralize SIEM or other tool. We don&apos;t recommend trying to substitute generalized log analysis tools and queries instead of native detections and controls. These tools can offer numerous values for proactive hunting activities, but getting to a high-quality alert with these tools requires application of deep expertise and time that could be better spent on hunting and other activities.

To complement the broad visibility of a centralized SIEM (like Microsoft Sentinel, Splunk, or QRadar), you should use native detections and controls, as follows:

- Organizations using Azure should use Microsoft Defender for Cloud for alert generation on the Azure platform.

- Organizations should use native logging capabilities like Azure Monitor and AWS CloudTrail for pulling logs into a central view.

- Organizations using Azure should use Network Security Group (NSG)
    capabilities for visibility into network activities on the Azure platform.

- Investigation practices should use native tools with deep knowledge of the asset type, such as an Endpoint Detection and Response (EDR) solution, Identity tools, and Microsoft Sentinel.

## Prioritize alert and log integration

Ensure that you are integrating critical security alerts and logs into SIEMs without introducing a high volume of low value data.

Introducing too much low value data can increase SIEM cost, increase noise and false positives, and lower performance.

The data you collect should be focused on supporting one or more of these operations activities:

- **Alerts** (detections from existing tools or data required for generating custom alerts)

- **Investigation** of an incident (for example, required for common queries)

- Proactive **hunting** activities

Integrating more data can allow you to enrich alerts with more context that enables rapid response and remediation (filtering false positives, elevating true positives, and so on), but collection is not detection. If you don't have a reasonable expectation that the data will provide value (such as high volume of firewall denies events), you may deprioritize integration of these events.
