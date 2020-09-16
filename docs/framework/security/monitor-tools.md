---
title: Monitor tools in Azure | Microsoft Docs
description: Monitor your data in Azure
author: v-aangie
ms.date: 09/17/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
---

# Monitor tools

Security provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. Losing these assurances can negatively impact your business operations and revenue, as well as your organization’s reputation in the marketplace.

## Secure workloads to prevent, detect, and respond to threat

[Azure Security Center](https://docs.microsoft.com/azure/security-center/security-center-intro) helps you prevent, detect, and respond to threats with increased visibility into and control over the security of your resources. It provides integrated security monitoring and policy management across your subscriptions, helps detect threats that might otherwise go unnoticed, and works with a broad ecosystem of security solutions. Azure Security Center also strengthens the security posture of your data centers.

To strengthen security posture, you need to:

- Manage organization security policy and compliance.
- Continuously assess if new resources that are being deployed across your workloads are configured according to [security best practices](https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf).
- Continuously monitor the security status of your network.
- Optimize and improve security by configuring recommended controls.

For information on the Azure Security Center tools that will help to meet these requirements, see [Strengthen security posture](https://docs.microsoft.com/azure/security-center/security-center-intro#strengthen-security-posture).

For frequently asked questions on Azure Security Center, see [FAQ - General Questions](https://docs.microsoft.com/azure/security-center/faq-general).

## See and stop threats before they cause harm

Azure Sentinel delivers intelligent security analytics and threat intelligence across the enterprise, providing a single solution for alert detection, threat visibility, proactive hunting, and threat response.

Azure Sentinel's "birds-eye view" across the enterprise allows you to:

- Collect data at cloud scale.
- Detect previously undetected threats and minimize false positives.
- Investigate threats with artificial intelligence and hunt for suspicious activities at scale.
- Respond to incidents rapidly.

For information on the Azure Sentinel tools that will help to meet these requirements, see [What is Azure Sentinel?](https://docs.microsoft.com/azure/sentinel/overview#analytics)

## Protect resources against Distributed Denial of Service (DDoS) attacks

A DDoS attack attempts to exhaust an application's resources, making the application unavailable to legitimate users. DDoS attacks can be targeted at any endpoint that is publicly reachable through the internet.

Azure DDoS protection, combined with application design best practices, provide defense against DDoS attacks. The service tier that is used (Basic or Standard) determines the available features.

DDos attack protection features include:

- Always-on traffic monitoring which provides near real-time detection of a DDoS attack.
- Automatic configuration and tuning of your DDoS Protection settings using  intelligent traffic-profiling.
- Detailed reports generated in five-minute increments during an attack, and a complete summary after the attack ends (Standard service tier only).

For types of DDoS attacks that DDoS Protection Standard mitigates as well as more features, see [Azure DDoS Protection Standard overview](https://docs.microsoft.com/azure/virtual-network/ddos-protection-overview).

## Secure files and emails across multiple devices

Azure rights management (RMS) is a cloud-based protection service that uses encryption, identity, and authorization policies to help secure files and emails across multiple devices, including phones, tablets, and PCs.

Identify business requirements or problems that your organization might have in protecting documents and emails. For example, file protection, collaboration, and sharing may be issues. You also might be experiencing issues regarding platform support or infrastructure.

To learn more about how RMS can address these issues, see [Business problems solved by Azure Rights Management](https://docs.microsoft.com/azure/information-protection/what-is-azure-rms#business-problems-solved-by-azure-rights-management).