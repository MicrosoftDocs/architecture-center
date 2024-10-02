This article kicks off a series focused on integrating security services into your IT environment to safeguard systems and resources, both on-premises and in the cloud. Microsoft offers a variety of security services designed to help organizations monitor and protect their systems and data. Throughout this series, you'll learn how to incorporate these services into your IT environment to enhance its overall security posture.

Microsoft provides extensive documentation and reference architectures on IT security. For instance, you can explore Zero Trust concepts, understand how Microsoft Defender XDR services protect your Office environment, and access architectural designs that utilize various security services from Microsoft Azure Cloud. You can find a compilation of various security-oriented reference architectures on [Microsoft Cybersecurity Reference Architectures](/security/cybersecurity-reference-architecture/mcra).

## Architectures in this series

This is the first article in a series of five that provides a structured and logical approach to understanding and integrating the security solutions available through Microsoft Azure public cloud and Microsoft 365 services. In this initial article, you'll find an overview of the series, with a brief explanation of the architecture's content and how it was developed. The subsequent articles will delve into each component in greater detail.

This series takes an in-depth look at the defense strategies you can build using these Microsoft cloud security services:

- Azure security services
- Microsoft Defender XDR Services
- Azure Monitor services, including Microsoft Sentinel and Log Analytics

### Diagrams

This series of articles uses architectural diagrams to explain how Microsoft security services work together. The diagram in this article is the final architecture reference for this series, and it presents the whole picture. 

To make the architecture more comprehensive, it was designed to be layered onto the architecture of a typical hybrid IT environment, which in many companies has three layers:

- On-premises services, such as a private Data Center
- Office 365 services that provide Microsoft Office apps
- Azure public cloud services, including servers, storage, and identity services

:::image type="content" alt-text="Diagram of the complete and final architecture that is described in this series of five articles." source="images/azure-monitor-integrate-security-components-architecture.png" lightbox="images/azure-monitor-integrate-security-components-architecture.png":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-monitor-integrate-security-components.vsdm) of this architecture.*

*©2021 The MITRE Corporation. This work is reproduced and distributed with the permission of The MITRE Corporation.*

At the bottom of the diagram is a layer that represents some of the most familiar techniques of attack according to MITRE ATT&CK matrix ([MITRE ATT&CK®](https://attack.mitre.org) and the tactics involved (in blue text). From a threat perspective, malicious actors have evolved with new technologies and scenarios, especially public and hybrid clouds. 


### Articles

In addition to this introductory article, this series includes the following articles:

- [Map threats to your IT environment](../../solution-ideas/articles/map-threats-it-environment.yml)

  The second article in this series explores how you can use this architectural reference with a different set of tactics and techniques or with varying methodologies, like [the Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html), a framework developed by Lockheed Martin.


- [Build the first layer of defense with Azure Security services](../../solution-ideas/articles/azure-security-build-first-layer-defense.yml)

  The third article in this series explores in detail the security services of Microsoft's cloud services. It describes how to protect Azure services, like virtual machines, storage, network, application, database, and other Azure services.

- [Build the second layer of defense with Microsoft Defender XDR Security services](../../solution-ideas/articles/microsoft-365-defender-build-second-layer-defense.yml)

  The fourth article in this series explores security for Microsoft 365 services, like Office 365, Teams, and OneDrive, provided by Microsoft Defender XDR services.

- [Integrate Azure and Microsoft Defender XDR security services](../../solution-ideas/articles/microsoft-365-defender-security-integrate-azure.yml)

  The fifth article in this series explains the relationship between Azure Security and Microsoft Defender XDR services and their integration. It describes how integration works and how you can accomplish it by using Microsoft Sentinel and Log Analytics, which are shown on the left side of the architecture diagram. This series calls these *core monitoring services*, because the services that are depicted in the graph can work with the comprehensive services of Azure and Microsoft 365.


## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

Other contributors: 

 * [Gary Moore](https://www.linkedin.com/in/gwmoore) | Programmer/Writer
 * [Andrew Nathan](https://www.linkedin.com/in/andrew-nathan) | Senior Customer Engineering Manager


## Next steps

This document refers to some services, technologies, and terminologies. You can find more information about them in the following resources:

- [What are public, private, and hybrid clouds?](https://azure.microsoft.com/overview/what-are-private-public-hybrid-clouds)
- [Overview of the Azure Security Benchmark (v3)](/security/benchmark/azure/overview)
- [Embrace proactive security with Zero Trust](https://www.microsoft.com/security/business/zero-trust)
- [Microsoft 365](https://www.microsoft.com/microsoft-365) subscription information
- [Microsoft Defender XDR](https://www.microsoft.com/security/business/threat-protection/microsoft-365-defender)
- [MITRE ATT&CK®](https://attack.mitre.org)
- [The Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html) from Lockheed Martin
- [What is Microsoft Sentinel?](/azure/sentinel/overview)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)

## Related resources

For more details about this reference architecture, see the other articles in this series:

- Part 2: [Map threats to your IT environment](../../solution-ideas/articles/map-threats-it-environment.yml)
- Part 3: [Build the first layer of defense with Azure Security services](../../solution-ideas/articles/azure-security-build-first-layer-defense.yml)
- Part 4: [Build the second layer of defense with Microsoft Defender XDR Security services](../../solution-ideas/articles/microsoft-365-defender-build-second-layer-defense.yml)
- Part 5: [Integrate Azure and Microsoft Defender XDR security services](../../solution-ideas/articles/microsoft-365-defender-security-integrate-azure.yml)


