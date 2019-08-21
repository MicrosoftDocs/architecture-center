---
title: "What is the Cloud Security Baseline"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: What is the Cloud Security Baseline?
author: BrianBlanchard
ms.author: brblanch
ms.date: 04/04/2019
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: govern
ms.custom: governance
---

<!-- markdownlint-disable MD026 -->

# What is the Cloud Security Baseline?

This is an introductory article on the general topic of a Cloud Security Baseline which builds on the [Five Disciplines of Cloud Governance](../governance-disciplines.md) to establish a governance framework. More detailed information about cloud security is available from [Azure's trusted cloud](https://azure.microsoft.com/overview/trusted-cloud). Approaches to improving your organizations security posture can be found in the [Cloud Security Service Catalog](https://www.microsoft.com/security/information-protection)

> [!NOTE]
> This article is not expected to provide enough context to allow the reader to implement a security strategy. It is for general awareness only.

## Cloud security

Cloud security is an extension of traditional information security practices. Traditional IT security would include policies and controls governing computer security, network security, data protection, information usage, and so forth. These same policies and controls are needed in the cloud. During any cloud transformation, it is imperative that the CISO be actively involved and understand the cloud landscape, to ensure legacy IT policies map to proper levels of control in the cloud.

At minimum, any cloud security strategy should consider the following topics:

- **Classify data.** Proper data classification to understand any data sources that are private, protected, or highly confidential. This will help manage risk during planning.
- **Plan for a hybrid cloud scenario.** Understanding how legacy, on-premises networks will connect to the cloud will help the CISO identify and remediate risks.
- **Plan for attacks and mistakes.** In the first few months of a transformation, mistakes will be made as the team learns. Start with low risk and highly restricted deployments to learn securely.
- **Prioritize privacy.** Throughout any transformation, the entire team should keep customer and employee privacy top of mind. Your data is safe in the cloud, but the team should be aware and extra cautious when dealing with sensitive data.

## Protecting data and privacy

For organizations throughout the world&mdash;whether governments, nonprofits, or businesses&mdash;cloud computing has become a key part of their ongoing IT strategy. Cloud services give organizations of all sizes access to virtually unlimited data storage while freeing them from the need to purchase, maintain, and update their own networks and computer systems. Microsoft and other cloud providers offer IT infrastructure, platform, and software as a service (SaaS), enabling customers to quickly scale up or down as needed and only paying for the computing power and storage they use.

However, as organizations continue to take advantage of the benefits of cloud services, such as increased choice, agility, and flexibility while boosting efficiency and lowering IT cost, they must consider how the introduction of cloud services affects their privacy, security, and compliance posture. Microsoft has worked to make their cloud offerings not only scalable, reliable, and manageable, but also to ensure our customers data is protected and used in a transparent manner.

Security is an essential component of strong data safeguards in all online computing environments. But security alone is not sufficient. Consumers’ and businesses’ willingness to use a particular cloud computing product also depends on their ability to trust that the privacy of their information will be protected, and that their data will only be used in a manner consistent with customer expectations. Learn more about Microsoft's approach to [Protecting data and privacy in the cloud](https://go.microsoft.com/fwlink/?LinkId=808242&clcid=0x409)

## Risk mitigation

The two greatest risks in any datacenter can be grouped into two sources: Aging systems and Human error. Protecting against these two risks is a minimum when defining an IT security strategy. The same is true in the cloud. The following are a few examples of controls that can be put in place to remediate risks and strengthen your Cloud Security strategy.

- **Legacy systems:** Many components in on-premises datacenter solutions consist of software, hardware, and processes that predate current security risks. When possible, remediate, replace, or retire these systems during a cloud transformation. Of course, that's not always feasible. If any legacy systems will remain in production in a hybrid solution, it is important that those systems have been inventoried and understood during virtual datacenter design. Doing so allows the design team to eliminate or control access to those systems from the cloud.
- **IT security processes and controls:** At a minimum, cloud design teams should be refreshed on existing IT security processes and controls to carry those forward into the cloud. In an ideal scenario, a member of the IT security team would be trained in cybersecurity and dedicated as a member of the design and implementation teams.
- **Monitoring and auditing:** When designing governance processes and tooling, ensure that monitoring and auditing solutions include security risks or violations.

> [!NOTE]
> **Technical debt disclosure:** This topic lacks actionable next steps. Addition articles will expand on this topic over time. More detailed information about Cloud Security is available from [Azure's Trusted Cloud](https://azure.microsoft.com/overview/trusted-cloud). Approaches to improving your organizations security posture can be found in the [Cloud Security Service Catalog](https://www.microsoft.com/security/information-protection)
