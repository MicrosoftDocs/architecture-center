---
title: Security design principles in Azure | Microsoft Docs
description: These principles support these three key strategies and describe a securely architected system hosted on cloud or on-premises datacenters (or a combination of both).
author: PageWriter-MSFT
ms.date: 07/15/2019
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Security design principles

These principles support these three key strategies and describe a securely architected system hosted on cloud or on-premises datacenters (or a combination of both). Application of these principles will dramatically increase the likelihood your security architecture will maintain assurances of confidentiality, integrity, and availability.

Each recommendation in this document includes a description of why it is recommended, which maps to one of more of these principles:

- **Align security priorities to mission:** Security resources are almost always limited, so prioritize efforts and assurances by aligning security strategy and technical controls to the business using classification of data and systems. Security resources should be focused first on people and assets (such as systems, data, and accounts) with intrinsic business value and those with administrative privileges over business critical assets.

- **Build a comprehensive strategy:** A security strategy should consider investments in culture, processes, and security controls across all system components. The strategy should also consider security for the full lifecycle of system components including the supply chain of software, hardware, and services.

- **Drive simplicity:** Complexity in systems leads to increased human confusion, errors, automation failures, and difficulty of recovering from an issue. Favor simple and consistent architectures and implementations.

- **Design for attackers:** Your security design and prioritization should be focused on the way attackers see your environment, which is often not the way IT and application teams see it. Inform your security design and test it with **penetration testing** to simulate one-time attacks. Use **red teams** to simulate long-term persistent attack groups. Design your enterprise segmentation strategy and other security controls to **contain** attacker lateral movement within your environment. Actively measure and reduce the potential **attack surface** that attackers target for exploitation of resources within the environment.

- **Use native controls:** Favor native security controls built into cloud services over external controls from third parties. Native security controls are maintained and supported by the service provider, eliminating or reducing effort required to integrate external security tooling and update those integrations over time.

- **Use identity as primary access control:** Access to resources in cloud architectures is primarily governed by identity-based authentication and authorization for access controls. Your account control strategy should rely on identity systems for controlling access rather than relying on network controls or direct use of cryptographic keys.

- **Accountability:** Designate clear ownership of assets and security responsibilities and ensure actions are traceable for nonrepudiation. You should also ensure entities have been granted the least privilege required (to a manageable level of granularity).

<a id="embrace-automation"></a>

- **Embrace automation:** Automation of tasks decreases the chance of human error that can create risk, so both IT operations and security best practices should be automated as much as possible to reduce human errors (while ensuring skilled humans govern and audit the automation).

- **Focus on information protection:** Intellectual property is frequently one of the biggest repositories of organizational value and this data should be protected anywhere it goes including cloud services, mobile devices, workstations, or collaboration platforms (without impeding collaboration that allows for business value creation). Your security strategy should be built around classifying information and assets to enable security prioritization, using strong access control and encryption technology, and meeting business needs like productivity, usability, and flexibility.

- **Design for resilience:** Your security strategy should assume that controls will fail and design accordingly. Making your security posture more resilient requires several approaches working together:

  - **Balanced investment:** Invest across core functions spanning the full [NIST Cybersecurity Framework lifecycle](https://www.nist.gov/cyberframework) (identify, protect, detect, respond, and recover) to ensure that attackers who successfully evade preventive controls lose access from detection, response, and recovery capabilities.

  - **Ongoing maintenance:** Maintain security controls and assurances to ensure that they don't decay over time with changes to the environment or neglect.

  - **Ongoing vigilance:** Ensure that anomalies and potential threats that could pose risks to the organizations are addressed in a timely manner.

  - **Defense in depth:** Consider additional controls in the design to mitigate risk to the organization in the event a primary security control fails. This design should consider how likely the primary control is to fail, the potential organizational risk if it does, and the effectiveness of the additional control (especially in the likely cases that would cause the primary control to fail).

  - **Least privilege:** This is a form of defense in depth to limit the damage that can be done by any one account. Accounts should be granted the least amount of privilege required to accomplish their assigned tasks. Restrict the access by permission level and by time. This helps mitigate the damage of an external attacker who gains access to the account and/or an internal employee who inadvertently or deliberately (for example, insider attack) compromises security assurances.

- **Baseline and benchmark:** To ensure your organization considers current thinking from outside sources, evaluate your strategy and configuration against external references (including compliance requirements). This helps to validate your approaches, minimize risk of inadvertent oversight, and the risk of punitive fines for noncompliance.

- **Drive continuous improvement:** Systems and existing practices should be regularly evaluated and improved to ensure they are and remain effective against attackers who continuously improve and the continuous digital transformation of the enterprise. This should include processes that proactively integrate learnings from real world attacks, realistic penetration testing and red team activities, and other sources as available.

- **Assume zero trust:** When evaluating access requests, all requesting users, devices, and applications should be considered untrusted until their integrity can be sufficiently validated. Access requests should be granted conditionally based on the requestor's trust level and the target resource's sensitivity. Reasonable attempts should be made to offer means to increase trust validation (for example, request multifactor authentication) and remediate known risks (change known-leaked password, remediate malware infection) to support productivity goals.

- **Educate and incentivize security:** The humans that are designing and operating the cloud workloads are part of the whole system. It is critical to ensure that these people are educated, informed, and incentivized to support the security assurance goals of the system. This is particularly important for people with accounts granted broad administrative privileges.
