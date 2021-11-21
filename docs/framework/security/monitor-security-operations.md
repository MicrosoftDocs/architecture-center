---
title: Security Operations Center (SOC or SecOps) monitoring in Azure
description: Guidance for security operation team (SecOps) is to rapidly detect, prioritize, and triage potential attacks.
author: PageWriter-MSFT
ms.date: 11/03/2020
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
ms.custom:
  - article
---

# Security operations in Azure

The responsibility of the security operation team (also known as Security Operations Center (SOC), or SecOps) is to rapidly detect, prioritize, and triage potential attacks. These operations help eliminate false positives and focus on real attacks, reducing the mean time to remediate real incidents. Central SecOps team monitors security-related telemetry data and investigates security breaches. It's important that any communication, investigation, and hunting activities are aligned with the application team.

:::image type="content" source="./images/incident-response.png" alt-text="Conceptual art that shows collaborative approach to mitigate potential and realized risk.":::

Here are some general best practices for conducting security operations:

- Follow the NIST Cybersecurity Framework functions as part of operations.

  - **Detect** the presence of adversaries in the system.
  - **Respond** by quickly investigating whether it's an actual attack or a false alarm.
  - **Recover**  and restore the confidentiality, integrity, and availability of the workload during and after an attack.

    For information about the framework, see [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework).

- Acknowledge an alert quickly. A detected adversary must not be ignored while defenders are triaging false positives.
- Reduce the time to remediate a detected adversary. Reduce their opportunity time to conduct and attack and reach sensitive systems.
- Prioritize security investments into systems that have high intrinsic value. For example, administrator accounts.
- Proactively hunt for adversaries as your system matures.  This effort will reduce the time that a higher skilled adversary can operate in the environment. For example, skilled enough to evade reactive alerts.

For information about the metrics that the Microsoft's SOC team uses , see [Microsoft SOC](https://aka.ms/ITSOC).

## Tools

Here are some Azure tools that a SOC team can use investigate and remediate incidents.

|Tool|Purpose|
|---|---|
|[**Microsoft Sentinel**](/azure/sentinel/overview)|Centralized Security Information and Event Management (SIEM)  to get enterprise-wide visibility into logs.|
|[**Microsoft Defender for Cloud**](/azure/security-center/security-center-intro)|Alert generation. Use security playbook in response to an alert.|
|[**Azure Monitor**](/azure/azure-monitor/overview)|Event logs from application and Azure services.|
|[**Azure Network Security Group (NSG)**](/azure/virtual-network/network-security-groups-overview)|Visibility into network activities.|
|[**Azure Information Protection**](/azure/information-protection/what-is-information-protection)|Secure email, documents, and sensitive data that you share outside your company.|

Investigation practices should use native tools with deep knowledge of the asset type such as an Endpoint detection and response (EDR) solution, Identity tools, and Microsoft Sentinel.

For more information about monitoring tools, see [Security monitoring tools in Azure](monitor-tools.md).

## Assign incident notification contact

Security alerts need to reach the right people in your organization. Establish a  designated point of contact to receive Azure incident notifications from Microsoft, and, or Azure  Defender for Cloud. In most cases, such notifications indicate that your resource is compromised or attacking another customer. This enables your security operations team to rapidly respond to potential security risks and remediate them.

This enables your security operations team to rapidly respond to potential security risks and remediate them.

Ensure administrator contact information in the Azure enrollment portal includes contact information that will notify security operations directly or rapidly through an internal process.

**Learn more**

To learn more about establishing a designated point of contact to receive Azure incident  notifications from Microsoft, reference the following articles:

- [Update notification settings](/azure/cost-management-billing/manage/ea-portal-administration#update-notification-settings)
- [Configure email notifications for security alerts](/azure/security-center/security-center-provide-security-contact-details)

## Incident response

Is the organization effectively monitoring security posture across workloads, with a central SecOps team monitoring security-related telemetry data and investigating possible security breaches? Communication, investigation, and hunting activities need to be aligned with the application team(s).

**Are operational processes for incident response defined and tested?**
***
Actions executed during an incident and response investigation could impact application availability or performance. Define these processes and align them with the responsible (and in most cases central) SecOps team. The impact of such an investigation on the application has to be analyzed.

**Are there tools to help incident responders quickly understand the application and components to do an investigation?**
***
Incident responders are part of a central SecOps team and need to understand security insights of an application. Security playbook in Microsoft Sentinel can help to understand the security concepts and cover the typical investigation activities.

### Suggested action

Consider using Microsoft Defender for Cloud to monitor security-related events and get alerted automatically.

**Learn more**

[Security alerts and incidents in Microsoft Defender for Cloud](/azure/security-center/security-center-alerts-overview)

## Hybrid enterprise view

Security operations tooling and processes should be designed for attacks on cloud and on-premises assets. Attackers don't restrict their actions to a particular environment when targeting an organization. They attack resources on any platform using any method available. They can pivot between cloud and on-premises resources using identity or other means. This enterprise-wide view will enable SecOps to rapidly detect, respond, and recover from attacks, reducing organizational risk.

## Leverage native detections and controls

Use Azure security detections and controls instead of creating custom features for viewing and analyzing event logs. Azure services are updated with new features and have the ability to detect false positive with a higher accuracy rate.

Integrating logs from the network devices, and even raw network traffic itself, will provide greater visibility into potential security threats flowing over the wire.

To get a unified view across the enterprise, feed the logs collected through native detections (such as Azure Monitor) into a centralized security information and event management (SIEM) solution like Microsoft Sentinel. Avoid using generalized log analysis tools and queries. Within Azure Monitor, create Log Analytics Workspace to store logs. You can also review logs and perform queries on log data. These tools can offer high-quality alerts.

The modern machine learning-based analytics platforms support ingestion of extremely large amounts of information and can analyze large datasets very quickly. In addition, these solutions can be tuned to significantly reduce false positive alerts.

Examples of network logs that provide visibility include:

- Security group logs - flow logs and diagnostic logs
- Web application firewall logs
- Virtual network taps and their equivalents
- Azure Network Watcher

### Suggested actions

Integrate network device log information in advanced SIEM solutions or other analytics platforms.

### Learn more

[Enable enhanced network visibility](/azure/architecture/framework/security/design-network-segmentation#enable-enhanced-network-visibility)

## Next steps

- [Security health modeling](monitor.md)
- [Security tools](monitor-tools.md)
- [Security logs and audits](monitor-audit.md)
- [Check for identity, network, data risks](monitor-resources.md)
