Microsoft provides a wide range of security solutions to help your company monitor, protect, and defend your business and valued information. These solutions are in different Microsoft services. When they are integrated, they offer a better security posture for your environment.

Microsoft offers many documents and architecture references about IT security. For example, you may dive into details about Zero Trust concepts, understand how Microsoft 365 Defender services work to protect your Office environment, and get an architecture reference with various Microsoft Azure Cloud security services. You can find a compilation of various Microsoft cloud security architecture references on [Microsoft Cybersecurity Reference Architectures](/security/cybersecurity-reference-architecture/mcra).

This article is one of a series of five documents that presents a different approach, compared with the existent architecture references. This series presents a logical and organized way to understand and integrate the security solutions that are available from Microsoft Azure public cloud and Microsoft 365 services. This series uses diagrams as architecture references with as little information as possible to explain how Microsoft security services work together.

This article, the first in the series, introduces what you will learn by reading this series. It also describes how to use the diagrams that are offered by this series.

The following diagram is the final architecture reference for this series. This diagram presents the whole picture. This article explains in a nutshell the content of the architecture and how it was built. Each part of it is explained in more detail in the other articles in this series.

:::image type="content" alt-text="Image alt text." source="images/azure-monitor-integrate-security-components-architecture.png" lightbox="images/azure-monitor-integrate-security-components-architecture.png":::

To make the architecture more comprehensive, it was considered to be layered onto the architecture of a typical hybrid IT environment, which in many companies has three layers:

- Azure public cloud services
- On-premises services (your datacenter)
- An Office 365 subscription with standard office services

At the bottom of the diagram is a layer that represents some of the most familiar techniques of attack according to Mitre Att&ck matrix ([MITRE ATT&CK®](https://attack.mitre.org/)) and the tactics involved (in blue text). From a threat perspective, malicious actors have evolved with new technologies and scenarios, especially public and hybrid clouds. [Customer IT environment and the threats](./customer-it-environment-threats.yml), the second article in this series, explores how you can use this architectural reference with a different set of tactics and techniques or with varying methodologies, like [the Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html), a framework developed by Lockheed Martin.

Between the customer environment and the threats, this article series explores the defense in depth that you can build with Microsoft cloud security services. Those layers contain:

- Azure security services
- Microsoft 365 Defender Services
- Azure Monitor services

[Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml), the third article in this series, explores those services in detail. It describes how to protect Azure services, like virtual machines, storage, network, application, database, and other Azure services.

The series of articles also covers security for Microsoft 365 services, like Office 365, Teams, and OneDrive, provided by Microsoft 365 Defender services. [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml), the fourth article in this series, explores those services.

[Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml), the fifth article in this series, explains the relationship between Azure Security and Microsoft 365 Defender services and their integration. The article describes how integration works and how it may be accomplished through Microsoft Sentinel and Log Analytics, which are represented on the left side of the architecture diagram. This series calls these *It is called in this series as *core monitoring services*, because the services that are depicted in the graph may work with comprehensive services of Azure and Microsoft 365.

## Next steps

To get all details regarding this Architecture reference, see the other articles in this series:

- Part 2: [Customer IT environment and the threats](./customer-it-environment-threats.yml)
- Part 3: [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)
- Part 4: [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)

## Related resources

This document refers to some services, technologies, and terminologies. You may find more information in the following resources:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds/)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust)
- [Microsoft 365](https://www.microsoft.com/microsoft-365) subscription information
- [Microsoft 365 Defender](https://www.microsoft.com/security/business/threat-protection/microsoft-365-defender)
- [MITRE ATT&CK®](https://attack.mitre.org/)
- [The Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html) from Lockheed Martin
- [What is Microsoft Sentinel?](/azure/sentinel/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
