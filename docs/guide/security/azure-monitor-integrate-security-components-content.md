**Use Azure monitoring to integrate security components**

Microsoft provides a wide range of security solutions to help your
company monitor, protect, and defend your business and valued
information. These solutions are in different Microsoft services, and
when they work integrated, they offer a better security posture for your
environment.

Microsoft has many documents and architecture references regarding IT
Security that is available. For example, you may dive into details about
Microsoft Zero Trust concepts, understand how Microsoft 365 Defender
services work to protect your Office environment, or get an architecture
reference with different Microsoft Azure Cloud security services. You
can find a compilation of various Microsoft Cloud Security architecture
references in this link.

[Microsoft Cybersecurity Reference Architectures - Security
documentation \| Microsoft
Docs](https://docs.microsoft.com/en-us/security/cybersecurity-reference-architecture/mcra)

This series of five documents presents a different approach compared
with the existent architecture reference. It is a logical and organized
way to understand Microsoft security solutions available on Microsoft
Azure public cloud and Microsoft 365 services and how to integrate them.
This series uses simple diagrams as architecture references with as
little information as possible to explain how Microsoft security
services work together.

This first document introduces understanding what you will learn when
you complete this series and how to use the diagrams offered with those
documents.

We will start with the final Architecture reference for this series so
that you may understand the whole picture. However, each piece of it
will be explained throughout the other documents.

:::image type="content" alt-text="Image alt text." source="images/azure-monitor-integrate-security-components-architecture.png" lightbox="images/azure-monitor-integrate-security-components-architecture.png":::

Let's understand in a nutshell how this diagram was built and its
content.

To make the architecture more comprehensive, it was considered on top of
the architecture a ubiquitous hybrid IT environment with three layers
that you may find in many companies:

-   Azure public cloud services

-   on-premises (your Datacenter)

-   Office 365 subscription with standard office services.

At the bottom of the diagram was considered a layer representing some of
the most known attacks techniques according to Mitre Att&ck matrix
([MITRE ATT&CK®](https://attack.mitre.org/) ) and its tactics (in blue
text). From a threat perspective, malicious actors have evolved with new
technologies and scenarios, especially public and hybrid clouds. In the
**second document** of this series, we will explore how you may use this
architecture reference with a different set of tactics and techniques or
with varying methodologies like Cyber kill chain. ([Cyber Kill Chain® \|
Lockheed
Martin](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html))

Between the Customer environment and the Threats, we will explore the
defense in depth that you may build with Microsoft cloud security
services. Those layers contain **Azure security services, Microsoft 365
Defender Services, and Azure Monitor services** and will be explored in
detail in the **third document** of this series. We will show how to
protect Azure services, like Virtual Machines, Storage, Network,
Application, Database, and other Azure services.

We will also cover security for the Microsoft 365 services, like Office
365, Teams, OneDrive, and others through Microsoft 365 Defender
services, which will be explored in detail in the **fourth document** of
this series.

In the **fifth document (and last)**, we will explain the relationship
and integration between Azure Security and Microsoft 365 Defender
services, how it works, and how it may be accomplished through Microsoft
Sentinel and Log Analytics, which is represented in the left of the
diagram. It is called in this series as "core monitoring services", as
the services depicted in the graph may work with comprehensive services
of Azure and Microsoft 365.

**Next steps**

To get all details regarding this Architecture reference, you may review
those other documents part of this series.

-   Part 2 - Business IT environment VS Attackers \<link\>

-   Part 3 - Building the first layer of defense with Azure Security
    services \<link\>

-   Part 4 - Building the second layer of defense with Microsoft 365
    Defender services \<link\>

-   Part 5 - Integration between Azure and Microsoft 365 Defender
    services \<link\>

**Related resources**

This document refers to some services, technologies and terminologies.
You may find more information related to it in the links below.

-   Microsoft Azure public cloud: [Public Cloud vs Private Cloud vs
    Hybrid Cloud \| Microsoft
    Azure](https://azure.microsoft.com/en-us/overview/what-are-private-public-hybrid-clouds/)

-   Azure Security services: [Overview of the Azure Security Benchmark
    v3 \| Microsoft
    Docs](https://docs.microsoft.com/en-us/security/benchmark/azure/overview)

-   Microsoft Zero Trust: [Zero Trust Model - Modern Security
    Architecture \| Microsoft
    Security](https://www.microsoft.com/en-us/security/business/zero-trust)

-   Microsoft office 365: [Microsoft 365 - Subscription for Office Apps
    \| Microsoft 365](https://www.microsoft.com/en-us/microsoft-365)

-   Microsoft 365 Defender: [Microsoft 365 Defender - Threat Protection
    \| Microsoft
    Security](https://www.microsoft.com/en-us/security/business/threat-protection/microsoft-365-defender)

-   Mitre Att&ck: [MITRE ATT&CK®](https://attack.mitre.org/)

-   Cyber kill chain: [Cyber Kill Chain® \| Lockheed
    Martin](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html)

-   Microsoft Sentinel: [What is Microsoft Sentinel? \| Microsoft
    Docs](https://docs.microsoft.com/en-us/azure/sentinel/overview)

-   Azure Log Analytics: [Overview of Log Analytics in Azure Monitor -
    Azure Monitor \| Microsoft
    Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)
