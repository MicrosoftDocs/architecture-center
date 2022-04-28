Microsoft provides a wide range of security solutions to help your company monitor, protect, and defend your business and valued information. These solutions are in different Microsoft services. When they are integrated, they offer a better security posture for your environment.

Microsoft offers many documents and architecture references about IT security. For example, you may dive into details about Zero Trust concepts, understand how Microsoft 365 Defender services work to protect your Office environment, and get an architecture reference with various security services from Microsoft Azure Cloud. You can find a compilation of various security-oriented architecture references on [Microsoft Cybersecurity Reference Architectures](/security/cybersecurity-reference-architecture/mcra).


## Architectures in this series

This article is the first in a series of five articles that presents an approach that's different from those in existing architecture references. This series presents a logical and organized way to understand and integrate the security solutions that are available from Microsoft Azure public cloud and from Microsoft 365 services. 

This article introduces the concepts and details that are covered in the series. It briefly explains the content of the architecture and how it was built. Each part is explained in more detail in the other articles in this series.

This series explores the defense in depth that you can build, between your environment and the threats, with Microsoft cloud security services:

- Azure security services
- Microsoft 365 Defender Services
- Azure Monitor services

### Diagrams

This series uses diagrams as architecture references to explain how Microsoft security services work together. This article describes how to use the diagrams. The diagram in this article is the final architecture reference for this series, and it presents the whole picture. 

To make the architecture more comprehensive, it was designed to be layered onto the architecture of a typical hybrid IT environment, which in many companies has three layers:

- Azure public cloud services
- On-premises services (your datacenter)
- An Office 365 subscription with standard office services

:::image type="content" alt-text="Diagram of the complete and final architecture that is described in this series of five articles." source="images/azure-monitor-integrate-security-components-architecture.png" lightbox="images/azure-monitor-integrate-security-components-architecture.png":::

©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

At the bottom of the diagram is a layer that represents some of the most familiar techniques of attack according to MITRE ATT&CK matrix ([MITRE ATT&CK®](https://attack.mitre.org/)) and the tactics involved (in blue text). From a threat perspective, malicious actors have evolved with new technologies and scenarios, especially public and hybrid clouds. 

### Articles

In addition to this introductory article, this series includes the following articles:

- [Customer IT environment and the threats](./customer-it-environment-threats.yml)

  The second article in this series explores how you can use this architectural reference with a different set of tactics and techniques or with varying methodologies, like [the Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html), a framework developed by Lockheed Martin.


- [Building the first layer of defense with Azure Security services](./azure-security-build-first-layer-defense.yml)

  The third article in this series explores in detail the security services of Microsoft's cloud services. It describes how to protect Azure services, like virtual machines, storage, network, application, database, and other Azure services.

- [Build the second layer of defense with Microsoft 365 Defender Security services](./microsoft-365-defender-build-second-layer-defense.yml)

  The fourth article in this series explores security for Microsoft 365 services, like Office 365, Teams, and OneDrive, provided by Microsoft 365 Defender services.

- [Integration between Azure and Microsoft 365 Defender security services](./microsoft-365-defender-security-integrate-azure.yml)

  The fifth article in this series explains the relationship between Azure Security and Microsoft 365 Defender services and their integration. It describes how integration works and how integration may be accomplished through Microsoft Sentinel and Log Analytics, which are represented on the left side of the architecture diagram. This series calls these *core monitoring services*, because the services that are depicted in the graph may work with comprehensive services of Azure and Microsoft 365.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 * [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


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
