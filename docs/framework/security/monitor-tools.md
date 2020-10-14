---
title: Monitor tools in Azure | Microsoft Docs
description: Monitor your data in Azure
author: v-aangie
ms.date: 09/20/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitor tools

Security provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. Losing these assurances can negatively impact your business operations and revenue, as well as your organization’s reputation in the marketplace.

Use this article to learn how to strengthen your security posture using the following monitor tools:

- [**Azure Security Center**](/azure/security-center/security-center-intro) - Prevent, detect, and respond to threats with increased visibility and control over the security of your resources.
- [**Azure Sentinel**](/azure/sentinel/overview) - Receive intelligent security analytics and threat intelligence across the enterprise.
- [**Azure DDoS Protection**](/azure/virtual-network/ddos-protection-overview) - Defend against DDoS attacks.
- [**Azure Rights Management (RMS)**](/azure/information-protection/what-is-azure-rms) - Protect files and emails across multiple devices.
- [**Azure Information Protection**](/azure/information-protection/what-is-information-protection) - Secure email, documents, and sensitive data that you share outside your company.

## Prevent, detect, and respond to threats

If your business has hybrid workloads, you may be experiencing weak security posture. For example, if you are deploying new resources across workloads, they may not be configured according to [security best practices](https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf). You may also need to continuously monitor the security status of the network in order to block unwanted connections that could potentially make it easier for an attacker to creep along your network.

[Azure Security Center](/azure/security-center/security-center-intro) strengthens the security posture of your data centers, and provides advanced threat protection across your hybrid workloads in the cloud (whether they're in Azure or not) as well as on-premises.

For information on the Azure Security Center tools, see [Strengthen security posture](/azure/security-center/security-center-intro#strengthen-security-posture).

For frequently asked questions on Azure Security Center, see [FAQ - General Questions](/azure/security-center/faq-general).

## Detect threats early

Your business may be experiencing increasingly sophisticated attacks, increasing volumes of alerts, and long resolution timeframes.

To combat these issues, [Azure Sentinel](/azure/sentinel/overview) uses intelligent security analytics and threat intelligence to provide a single solution for alert detection, threat visibility, [proactive hunting](https://techcommunity.microsoft.com/t5/microsoft-security-and/threat-hunting-simplified-with-microsoft-threat-protection/ba-p/1216909), and threat response.

Azure Sentinel's "birds-eye view" across the enterprise allows you to:

- Collect data at cloud scale.
- Detect previously undetected threats and minimize false positives.
- Investigate threats with artificial intelligence and hunt for suspicious activities at scale.
- Respond to incidents rapidly.

For information on the Azure Sentinel tools that will help to meet these requirements, see [What is Azure Sentinel?](/azure/sentinel/overview#analytics)

## Protect resources against DDoS attacks

A Distributed Denial of Service (DDoS) attack attempts to exhaust an application's resources, making the application unavailable to legitimate users. DDoS attacks can be targeted at any endpoint that is publicly reachable through the internet.

[Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview), combined with application design best practices, provide defense against DDoS attacks. The service tier that is used (Basic or Standard) determines the available features.

DDoS attack protection features include:

- Always-on traffic monitoring which provides near real-time detection of a DDoS attack.
- Automatic configuration and tuning of your DDoS Protection settings using  intelligent traffic-profiling.
- Detailed reports generated in five-minute increments during an attack, and a complete summary after the attack ends (Standard service tier only).

For types of DDoS attacks that DDoS Protection Standard mitigates as well as more features, see [Azure DDoS Protection Standard overview](/azure/virtual-network/ddos-protection-overview).

## Protect files and emails across multiple devices

Your business may encounter challenges with protecting documents and emails. For example, file protection, collaboration, and sharing may be issues. You also might be experiencing problems regarding platform support or infrastructure.

[Azure Rights Management (RMS)](/azure/information-protection/what-is-azure-rms) is a cloud-based protection service that uses encryption, identity, and authorization policies to help secure files and emails across multiple devices, including phones, tablets, and PCs.

To learn more about how RMS can address these issues, see [Business problems solved by Azure Rights Management](/azure/information-protection/what-is-azure-rms#business-problems-solved-by-azure-rights-management).

## Classify and protect documents and emails

Organizations that are weak on [*data classification*](/azure/cloud-adoption-framework/govern/policy-compliance/data-classification) and *file protection* might be more susceptible to data leakage or data misuse.

[Azure Information Protection (AIP)](/azure/information-protection/what-is-information-protection) is a cloud-based solution that enables organizations to classify and protect documents and emails by applying labels.

The *data classification* process categorizes data by sensitivity and business impact in order to identify risks. When data is classified, you can manage it in ways that protect sensitive or important data from theft or loss.

With proper *file protection*, you can analyze data flows to gain insight into your business, detect risky behaviors and take corrective measures, track access to documents, and more. The protection technology in AIP uses encryption, identity, and authorization policies. Protection stays with the documents and emails, independently of the location, regardless of whether they are inside or outside your organization, networks, file servers, and applications.