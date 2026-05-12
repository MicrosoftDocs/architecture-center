[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article is the third in a four-part series that demonstrates how you can layer Microsoft security solutions to protect an enterprise environment against modern threats like ransomware.

[Map threats to your IT environment](map-threats-it-environment.yml) describes how to map ransomware attack paths across a hybrid environment by using the MITRE ATT&CK framework. It also helps you identify how attackers typically gain initial access, escalate privileges, move laterally, and affect critical assets.

[Build the first layer of defense by using Azure security services](azure-security-build-first-layer-defense.yml) focuses on the first layer of defense, before attackers breach your environment. It shows how foundational Azure security services and Zero Trust principles reduce the attack surface and prevent many attacks from the start.

This article builds on these foundational security approaches and introduces the second layer of defense. This layer applies detection and response mechanisms that you implement by using Microsoft Defender XDR.

Even in well-architected environments, some attacks bypass preventive controls. The purpose of a second layer of defense is to detect malicious activity early, correlate signals across domains, and enable rapid containment and response before an attack can escalate into a ransomware incident.

Defender XDR provides a unified detection and response layer that correlates security signals across identities, endpoints, email, cloud applications, and infrastructure to detect and contain advanced threats that bypass preventive controls.

## Architecture

This architecture illustrates a hybrid enterprise environment composed of on-premises infrastructure, Microsoft 365 services, Azure workloads, and user endpoints. Defender XDR sits logically above these layers and collects telemetry from Microsoft Defender for Endpoint, Microsoft Defender for Identity, Microsoft Defender for Office 365, Microsoft Defender for Cloud Apps, and Microsoft Defender Vulnerability Management. It correlates signals into unified incidents so that you can automate investigation and response actions. Integration with Microsoft Sentinel lets you use centralized security information and event management (SIEM) and security orchestration, automation, and response (SOAR) capabilities for extended analytics and orchestration.

:::image type="complex" border="false" source="./media/microsoft-defender-xdr-build-second-layer-defense.svg" alt-text="Diagram that shows the Defender XDR second layer of defense architecture." lightbox="./media/microsoft-defender-xdr-build-second-layer-defense.svg":::
   The diagram is organized as a large grid. Across the top, a banner labeled Microsoft Zero Trust pillars spans four vertical columns labeled network, infrastructure and endpoints, application and data, and identity. Along the left side, horizontal rows represent distinct environment layers. From top to bottom these rows are labeled on-premises, Microsoft 365 apps, Azure, Azure security services, Microsoft Purview, Defender XDR, and Microsoft Entra ID. A label on the far right identifies the top three rows as the customer environment and the fourth row as the Azure security benchmark. On the far left, a vertical rectangle labeled Microsoft Sentinel spans all rows to indicate its role as an overarching SIEM and SOAR service. The on-premises row contains icons for a firewall, Domain Name System (DNS), and virtual local area networks (VLANs) in the network column; servers and client endpoints in the infrastructure and endpoints column; application, file server, and database in the application and data column; and Active Directory Domain Services (AD DS) domain controller (DC) in the identity column.
   
    The M365 Apps row shows Office 365 Apps (excluding Teams and OneDrive) under Application and Data, labeled as step 1, and Entra Connect under Identity. The Azure row shows PIP, LBS, and VNET under Network; Servers, AKS, and VDI under Infrastructure and Endpoints; Web Apps, Azure Storage, and Database under Application and Data; and Microsoft Entra ID under Identity. The Azure Security Services row is the most detailed and spans all four columns under a Policy banner. Under Network, it includes WAF, DDoS protection, Private Link, NVA, NSG, VPN, Azure Firewall, and TLS/SSL. Under Infrastructure and Endpoints, it includes Bastion, Antimalware, Disk Encrypt, Key Vault, Default, MFA, RDP Short, Privileged Connect, App GW Cluster, and Cond Access. Under Application and Data, it includes FD WAF, API Management, App GW plus WAF, SAS Token, Private Endpoint, Vulnerability Assessment, Storage Firewall, Private Endpoint, and Encryption along with SQL Audit and Vulnerability Assessment. Under Identity, it includes MFA, RBAC, ID Protection, PIM, and Cond Access. Step 8 is labeled on a Logic Apps icon within the Infrastructure and Endpoints section of this row, and step 9 appears on the Microsoft Sentinel label on the left. The Microsoft Purview row spans the middle columns and contains Compliance Manager under Infrastructure and Endpoints, and Data Governance and MIP, DLP, and IRM under Application and Data and Identity respectively. The XDR row contains four Defender products spanning the columns: Defender for Endpoint labeled as step 4 under Infrastructure and Endpoints, Defender for Cloud Apps labeled as step 6 under Application and Data, Defender for Office 365 labeled as step 3 under Application and Data, and Defender for Identity labeled as step 5 under Identity. A label on the right reads "XDR" with step 7 indicating the unified correlation layer. The Microsoft Entra ID row spans the Identity column and contains Microsoft Entra ID Premium, marked with an asterisk. At the bottom of the diagram, a section labeled "MITRE ATT&CK Matrix Tactics and Techniques" is divided into four attack domain columns matching the top columns: Network Attacks, Infrastructure and Process Attacks, Application and Storage Attacks, and Identity Compromising. Each column lists specific MITRE ATT&CK technique IDs and names. Under Network Attacks are Discovery techniques Remote System Discovery T1018 and Remote Access Tool T1219, and Command and Control technique. Under Infrastructure and Process Attacks are techniques covering Privilege Escalation, Discovery, Defense Evasion, and Execution such as T1053, T1082, T1497, T1059, T1218, and T1055. Under Application and Storage Attacks, step 2 marks Initial Access via Phishing T1566, along with Command and Control via Ingress Tool Transfer T1105, and Defense Evasion via Obfuscated Files T1027 and Masquerading T1036. Under Identity Compromising are Persistence via Account Manipulation T1098, Defense Evasion via OS Credential Dumping T1003, and Privilege Escalation via Process Injection T1055. The ATT&CK logo appears in the lower left corner of this section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/<file-name>.vsdx) of this architecture.*

## Workflow

The following workflow corresponds to the architecture diagram:

1. A user interacts with email, applications, or endpoints that are protected by baseline preventive controls defined in the first layer of defense.
2. A phishing attempt or malicious payload bypasses preventive controls and reaches a user mailbox or endpoint.
3. Defender for Office 365 analyzes email content and detects suspicious links or attachments.
4. Defender for Endpoint monitors endpoint behavior and identifies malicious process execution or lateral movement activity.
5. Defender for Identity analyzes authentication traffic and detects abnormal Active Directory behavior, such as credential theft or privilege escalation.
6. Defender for Cloud Apps detects anomalous SaaS activity or risky OAuth application usage.
7. Defender XDR correlates all signals into a single incident representing the full attack chain.
8. Automated investigation and response actions are triggered to contain the threat, such as isolating devices, disabling accounts, or blocking malicious indicators.
9. Security teams investigate and remediate the incident using unified XDR workflows or forward data to Microsoft Sentinel for advanced analytics and orchestration.

## Components

- Defender XDR is a unified extended detection and response platform that correlates signals across multiple security domains. In this architecture, it provides centralized visibility, incident correlation, and automated response across the environment.

- Defender for Endpoint is an endpoint security platform that provides EDR, attack surface reduction, and vulnerability insights. In this architecture, it detects malicious behavior on user devices and servers and enforces containment actions during active attacks.

- Defender for Identity monitors on-premises Active Directory signals to detect identity-based attacks. In this architecture, it identifies lateral movement, credential theft, and privilege escalation attempts commonly used in ransomware campaigns.

- Defender for Office 365 protects email and collaboration workloads from phishing and malware. In this architecture, it detects and investigates malicious email-based initial access vectors.

- Defender for Cloud Apps provides visibility and control over SaaS applications. In this architecture, it detects compromised cloud identities, anomalous application behavior, and data exfiltration attempts.

- Defender Vulnerability Management continuously assesses endpoint vulnerabilities and misconfigurations. In this architecture, it helps reduce exploitable attack surface before and after compromise.

- Microsoft Sentinel is a cloud-native SIEM and SOAR solution. In this architecture, it optionally aggregates Defender XDR incidents for long-term retention, advanced hunting, and orchestration.

## Scenario details

This scenario focuses on detecting and responding to ransomware attacks that bypass preventive security controls.

In [Map threats to your IT environment](map-threats-it-environment.yml), ransomware threats were mapped across a hybrid enterprise environment using the MITRE ATT&CK framework. [Build the first layer of defense by using Azure security services](azure-security-build-first-layer-defense.yml) addressed how foundational Azure security services and Zero Trust principles reduce the likelihood of those attacks succeeding.

This article assumes that some attacks will still succeed and focuses on minimizing their impact by:

- Detecting attacker behavior early
- Correlating signals across multiple security domains
- Reducing attacker dwell time
- Containing threats before widespread encryption or data exfiltration occurs

Defender XDR is designed to identify behavioral patterns, not just known malware signatures, making it effective against modern ransomware operators who rely on living-off-the-land techniques and legitimate tools.

## Potential use cases

This architecture applies to multiple industries and scenarios, including:

- Finance – Detecting credential theft and lateral movement in regulated environments
- Healthcare – Protecting sensitive identities and data from ransomware disruption
- Manufacturing – Preventing operational impact from compromised endpoints
- Government – Detecting identity-based attacks and nation-state techniques
- Retail and e-commerce – Identifying phishing-driven account compromise
- Education – Monitoring high-volume identity and endpoint activity

## Additional considerations

**Microsoft Purview** plays a critical role in an organization’s overall data protection and governance strategy. Microsoft Purview provides capabilities such as data discovery and classification, sensitivity labeling, data loss prevention (DLP), insider risk management, and audit across Microsoft 365, Azure, and multicloud environments. These capabilities are essential for protecting sensitive information and meeting regulatory and compliance requirements, especially in ransomware scenarios that involve data exfiltration and extortion. However, while Microsoft Purview is represented in the architecture diagram to reflect its importance in a comprehensive security posture, data governance and compliance are not in scope for this article series, which focuses specifically on threat prevention, detection, and response.

**Microsoft Entra ID Premium and Conditional Access** is also foundational to identity protection in cloud-centric environments. Microsoft Entra ID Premium enables advanced identity security capabilities such as risk-based Conditional Access, identity protection, privileged identity management (PIM), and continuous access evaluation for cloud and SaaS applications. These controls are primarily focused on cloud identities and access enforcement. In contrast, Defender for Identity focuses on detecting identity-based threats in on-premises Active Directory, such as credential theft, lateral movement, and domain dominance techniques. Both Microsoft Entra ID Premium and Defender for Identity appear in the architecture diagram to illustrate end-to-end identity coverage across hybrid environments; however, detailed identity governance and access policy design are intentionally out of scope for this article series, which concentrates on ransomware threat mapping and layered defense architecture.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Customer Engineer

Other contributors:

- [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
- [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager

## Next steps

- Review how to design and tune automated investigation and response in Defender XDR
- Integrate Defender XDR with Microsoft Sentinel for advanced SIEM and SOAR capabilities
- Validate detections by simulating ransomware attack paths identified in [Map threats to your IT environment](map-threats-it-environment.yml)
- Continue to Part 4: Integrating Azure security services with Defender XDR


## Related resources

- [Map threats to your IT environment](./map-threats-it-environment.yml)
- [Build the first layer of defense with Azure security services](./azure-security-build-first-layer-defense.yml)
- [Integrate Azure and Defender XDR security services](./microsoft-365-defender-security-integrate-azure.yml)
