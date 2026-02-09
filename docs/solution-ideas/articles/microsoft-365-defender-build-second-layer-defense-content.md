[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article is the third in a four-part series that demonstrates how Microsoft security solutions can be layered to protect an enterprise environment against modern threats such as ransomware.

In Article 1, we mapped ransomware attack paths across a hybrid environment using the MITRE ATT&CK framework, identifying how attackers typically gain initial access, escalate privileges, move laterally, and impact critical assets.

In Article 2, we focused on the first layer of defense (pre-breach), showing how foundational Azure security services and Zero Trust principles reduce attack surface and prevent many attacks from starting.

This article builds on those two foundations and introduces the second layer of defense: detection and response, implemented through Microsoft Defender XDR.

Even in well-architected environments, some attacks will bypass preventive controls. The purpose of this layer is to detect malicious activity early, correlate signals across domains, and enable rapid containment and response before an attack can escalate into a full ransomware incident.

Microsoft Defender XDR provides a unified detection and response layer that correlates security signals across identities, endpoints, email, cloud applications, and infrastructure to detect and contain advanced threats that bypass preventive controls.

## Architecture

The architecture illustrates a hybrid enterprise environment composed of on-premises infrastructure, Microsoft 365 services, Azure workloads, and user endpoints. Microsoft Defender XDR sits logically above these layers, collecting telemetry from Microsoft Defender for Endpoint, Defender for Identity, Defender for Office 365, Defender for Cloud Apps, and Defender Vulnerability Management. Signals are correlated into unified incidents, enabling automated investigation and response actions. Integration with Microsoft Sentinel enables centralized SIEM and SOAR capabilities for extended analytics and orchestration.

**((architecture diagram goes here))**

Download a Visio file of this architecture here.
(Link will be added after Visio submission to the AAC content team.)

## Workflow

The following workflow corresponds to the architecture diagram:

1. A user interacts with email, applications, or endpoints that are protected by baseline preventive controls defined in the first layer of defense.
2. A phishing attempt or malicious payload bypasses preventive controls and reaches a user mailbox or endpoint.
3. Microsoft Defender for Office 365 analyzes email content and detects suspicious links or attachments.
4. Microsoft Defender for Endpoint monitors endpoint behavior and identifies malicious process execution or lateral movement activity.
5. Microsoft Defender for Identity analyzes authentication traffic and detects abnormal Active Directory behavior, such as credential theft or privilege escalation.
6. Microsoft Defender for Cloud Apps detects anomalous SaaS activity or risky OAuth application usage.
7. Microsoft Defender XDR correlates all signals into a single incident representing the full attack chain.
8. Automated investigation and response actions are triggered to contain the threat, such as isolating devices, disabling accounts, or blocking malicious indicators.
9. Security teams investigate and remediate the incident using unified XDR workflows or forward data to Microsoft Sentinel for advanced analytics and orchestration.

## Components

- Microsoft Defender XDR is a unified extended detection and response platform that correlates signals across multiple security domains. In this architecture, it provides centralized visibility, incident correlation, and automated response across the environment.

- Microsoft Defender for Endpoint is an endpoint security platform that provides EDR, attack surface reduction, and vulnerability insights. In this architecture, it detects malicious behavior on user devices and servers and enforces containment actions during active attacks.

- Microsoft Defender for Identity monitors on-premises Active Directory signals to detect identity-based attacks. In this architecture, it identifies lateral movement, credential theft, and privilege escalation attempts commonly used in ransomware campaigns.

- Microsoft Defender for Office 365 protects email and collaboration workloads from phishing and malware. In this architecture, it detects and investigates malicious email-based initial access vectors.

- Microsoft Defender for Cloud Apps provides visibility and control over SaaS applications. In this architecture, it detects compromised cloud identities, anomalous application behavior, and data exfiltration attempts.

- Microsoft Defender Vulnerability Management continuously assesses endpoint vulnerabilities and misconfigurations. In this architecture, it helps reduce exploitable attack surface before and after compromise.

- Microsoft Sentinel is a cloud-native SIEM and SOAR solution. In this architecture, it optionally aggregates Defender XDR incidents for long-term retention, advanced hunting, and orchestration.

## Scenario details

This scenario focuses on detecting and responding to ransomware attacks that bypass preventive security controls.

In Article 1, ransomware threats were mapped across a hybrid enterprise environment using the MITRE ATT&CK framework. Article 2 addressed how foundational Azure security services and Zero Trust principles reduce the likelihood of those attacks succeeding.

This article assumes that some attacks will still succeed and focuses on minimizing their impact by:

- Detecting attacker behavior early
- Correlating signals across multiple security domains
- Reducing attacker dwell time
- Containing threats before widespread encryption or data exfiltration occurs

Microsoft Defender XDR is designed to identify behavioral patterns, not just known malware signatures, making it effective against modern ransomware operators who rely on living-off-the-land techniques and legitimate tools.

## Potential use cases

This architecture applies to multiple industries and scenarios, including:

- Finance – Detecting credential theft and lateral movement in regulated environments
- Healthcare – Protecting sensitive identities and data from ransomware disruption
- Manufacturing – Preventing operational impact from compromised endpoints
- Government – Detecting identity-based attacks and nation-state techniques
- Retail and e-commerce – Identifying phishing-driven account compromise
- Education – Monitoring high-volume identity and endpoint activity

## Additional considerations

**Microsoft Purview** plays a critical role in an organization’s overall data protection and governance strategy. Purview provides capabilities such as data discovery and classification, sensitivity labeling, data loss prevention (DLP), insider risk management, and audit across Microsoft 365, Azure, and multicloud environments. These capabilities are essential for protecting sensitive information and meeting regulatory and compliance requirements, especially in ransomware scenarios that involve data exfiltration and extortion. However, while Purview is represented in the architecture diagram to reflect its importance in a comprehensive security posture, data governance and compliance are not in scope for this article series, which focuses specifically on threat prevention, detection, and response.

**Microsoft Entra ID Premium and Conditional Access** are also foundational to identity protection in cloud-centric environments. Entra ID Premium enables advanced identity security capabilities such as risk-based Conditional Access, identity protection, privileged identity management (PIM), and continuous access evaluation for cloud and SaaS applications. These controls are primarily focused on cloud identities and access enforcement. In contrast, Microsoft Defender for Identity focuses on detecting identity-based threats in on-premises Active Directory, such as credential theft, lateral movement, and domain dominance techniques. Both Entra ID Premium and Defender for Identity appear in the architecture diagram to illustrate end-to-end identity coverage across hybrid environments; however, detailed identity governance and access policy design are intentionally out of scope for this article series, which concentrates on ransomware threat mapping and layered defense architecture.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Customer Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next Steps

- Review how to design and tune automated investigation and response in Microsoft Defender XDR
- Integrate Microsoft Defender XDR with Microsoft Sentinel for advanced SIEM and SOAR capabilities
- Validate detections by simulating ransomware attack paths identified in Article 1
- Continue to Part 4: Integrating Azure security services with Microsoft Defender XDR


## Related resources

- [Map threats to your IT environment](./map-threats-it-environment.yml)
- [Build the first layer of defense with Azure security services](./azure-security-build-first-layer-defense.yml)
- [Integrate Azure and Microsoft Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
