---
title: Azure security monitoring tools
description: Use security monitoring tools in Azure. Also get general security advice, such as detecting threats early and protecting resources against DDoS attacks.
author: v-aangie
ms.date: 09/20/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
  - azure-sentinel
  - m365-security-center
categories:
  - management-and-governance
subject:
  - security
  - monitoring
ms.custom:
  - article
---

# Azure security monitoring tools

The *leverage native control* security principle tells us to use native controls built into cloud services over external controls through third-party solutions. Native reduce the effort required to integrate external security tooling and update those integrations over time.

Azure provides several monitoring tools that observe the operations and detect anomalous behavior. These tools can detect threats at different levels and report issues. Addressing the issues early in the operational lifecycle will strengthen your overall security posture.

## Tools

|Service|Use case|
|---|---|
|[**Microsoft Defender for Cloud**](/azure/security-center/security-center-intro)| Strengthens the security posture of your data centers, and provides advanced threat protection across your workloads in the cloud (whether they're in Azure or not) and on-premises. Get a unified view into the infrastructure and resources provisioned for the workload. |
|[**Microsoft Sentinel**](/azure/sentinel/overview)|Use the native security information event management (SIEM) and security orchestration automated response (SOAR) solution on Azure. Receive intelligent security analytics and threat intelligence across the enterprise.|
|[**Azure DDoS Protection**](/azure/virtual-network/ddos-protection-overview)| Defend against distributed denial of service (DDoS) attacks.|
|[**Azure Rights Management (RMS)**](/azure/information-protection/what-is-azure-rms)| Protect files and emails across multiple devices.|
|[**Microsoft Information Protection (MIP)**](/information-protection/develop/overview)| Secure email, documents, and sensitive data that you share outside your company.|
|[**Azure Governance Visualizer**](https://github.com/microsoft/CloudAdoptionFramework/tree/master/govern/AzureGovernanceVisualizer)|Gain granular insight into policies, Azure role-based access control (Azure RBAC), Azure Blueprints, subscriptions, and more.|

## Microsoft Defender for Cloud

Enable Microsoft Defender for Cloud at the subscription level to monitor all resource provisioned in that scope. At no additional cost, it provides continuous observability into resources, reports issues, and recommends fixes. By regularly reviewing and fixing issues, you can improve the security posture, detect threats early, prevent breaches.

Beyond just observability, Defender for Cloud offers an advanced mode through its integration with **Microsoft Defender for Cloud**. When these plans are enabled, built-in policies, custom policies, and initiatives protect resources and block malicious actors. You can also monitor compliance with regulatory standards - such as NIST, Azure CIS, Azure Security Benchmark. For pricing details, see [Defender for Cloud pricing](https://azure.microsoft.com/pricing/details/azure-defender/).

## Microsoft Sentinel

Your organization might run workloads on multiple cloud platforms, and, or across cloud and on-premises, or managed by various teams within the organization. Having a centralized view of all data is recommended. To get that view you need security information event management (SIEM) and security orchestration automated response (SOAR) solutions. These solutions connect to all security sources, monitor them, and analyze the correlated data.

Microsoft Sentinel and is a native control that combines SIEM and SOAR capabilities. It analyzes events and logs from various connected sources. Based on the data sources and their alerts, Sentinel creates incidents, performs threat analysis for early detection. Through intelligent analytics and queries, you can be proactive with hunting activities. In case of incidents, you can automate workflows. Also, with workbook templates you can quickly gain insights through visualization.

## Azure DDoS Protection

A Distributed Denial of Service (DDoS) attack attempts to exhaust an application's resources, making the application unavailable to legitimate users. DDoS attacks can be targeted at any endpoint that is publicly reachable through the internet.

Every property in Azure is protected by Azure's infrastructure DDoS (Basic) Protection at no additional cost. The scale and capacity of the globally deployed Azure network provides defense against common network-layer attacks through always-on traffic monitoring and real-time mitigation. DDoS Protection Basic requires no user configuration or application changes. DDoS Protection Basic helps protect all Azure services, including PaaS services like Azure DNS.

Azure DDoS Protection Standard provides enhanced DDoS mitigation features to defend against DDoS attacks. It is automatically tuned to help protect your specific Azure resources in a virtual network. Protection is simple to enable on any new or existing virtual network, and it requires no application or resource changes. It has several advantages over the basic service, including logging, alerting, telemetry, SLA guarantee and cost protection.

Azure DDoS Protection Standard is designed for [services that are deployed in a virtual network](/azure/virtual-network/virtual-network-for-azure-services). For other services, the default DDoS Protection Basic service applies. To learn more about supported architectures, see [DDoS Protection reference architectures](/azure/ddos-protection/ddos-protection-reference-architectures).

## Azure Rights Management (RMS)

Your business may encounter challenges with protecting documents and emails. For example, file protection, collaboration, and sharing may be issues. You also might be experiencing problems regarding platform support or infrastructure.

[Azure Rights Management (RMS)](/azure/information-protection/what-is-azure-rms) is a cloud-based protection service that uses encryption, identity, and authorization policies to help secure files and emails across multiple devices, including phones, tablets, and PCs.

To learn more about how RMS can address these issues, see [Business problems solved by Azure Rights Management](/azure/information-protection/what-is-azure-rms#business-problems-solved-by-azure-rights-management).

## Microsoft Information Protection (MIP)

The *data classification* process categorizes data by sensitivity and business impact in order to identify risks. When data is classified, you can manage it in ways that protect sensitive or important data from theft or loss.

With proper *file protection*, you can analyze data flows to gain insight into your business, detect risky behaviors and take corrective measures, track access to documents, and more. The protection technology in AIP uses encryption, identity, and authorization policies. Protection stays with the documents and emails, independently of the location, regardless of whether they are inside or outside your organization, networks, file servers, and applications

[Azure Information Protection (AIP)](/azure/information-protection/what-is-information-protection) is part of Microsoft Information Protection (MIP) solution, and extends the labeling and classification functionality provided by Microsoft 365. For more information, see [this article about classification](/microsoft-365/compliance/data-classification-overview).

## Azure Governance Visualizer

Azure Governance Visualizer is a PowerShell script that iterates through an Azure tenant's management group hierarchy down to the subscription level. You can run the script either for your Tenant Root Group or any other Management Group. It captures data from the most relevant Azure governance capabilities such as Azure Policy, Azure role-based access control (Azure RBAC), and Azure Blueprints. From the collected data, the visualizer shows your hierarchy map, creates a tenant summary, and builds granular scope insights about your management groups and subscriptions.

The visualizer provides a holistic overview of your technical Azure Governance implementation by connecting the dots.

## Next

> [!div class="nextstepaction"]
> [Monitor workload resources in Microsoft Defender for Cloud](monitor-resources.md)

## Related links

For information on the Microsoft Defender for Cloud tools, see [Strengthen security posture](/azure/security-center/security-center-intro#strengthen-security-posture).

For frequently asked questions on Microsoft Defender for Cloud, see [FAQ - General Questions](/azure/security-center/faq-general).

For information on the Microsoft Sentinel tools that will help to meet these requirements, see [What is Microsoft Sentinel?](/azure/sentinel/overview#analytics)

For types of DDoS attacks that DDoS Protection Standard mitigates as well as more features, see [Azure DDoS Protection Standard overview](/azure/virtual-network/ddos-protection-overview).
