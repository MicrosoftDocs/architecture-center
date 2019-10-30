---
title: Overview of the security pillar 
description: Describes the security pillar
author: david-stanford
ms.date: 10/21/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Overview of the security pillar

Description goes here, pending Tom or Mark.

These are the topics we cover in the security pillar of the Azure Architecture Framework

| Security Topic | Description |
|-------------------|-------------|
| [Role of security][role] | Security is one of the most important aspects of any architecture. Security provides confidentiality, integrity, and availability assurances against deliberate attacks and abuse of your valuable data and systems. |
| [Security design principles][design] | These principles support these three key strategies and describe a securely architected system hosted on cloud or on-premises datacenters (or a combination of both). |
| [Types of attacks to resist][attacks] | An architecture built on good security practices should be resilient to attacks. It should both resist attacks and recover rapidly from disruption to the security assurances of confidentiality, integrity, and availability. |
| [Regulatory compliance][regulatory] | Governments and other organizations frequently publish standards to help define good security practices (due diligence) so that organizations can avoid being negligent in security. |
| [Reduce organizational risk][org-risk] | Much like physical safety, success in information security is defined more as an ongoing task of applying good security practices and principles and hygiene rather than a static absolute state. |
| [Administration][admin] | Administration is the practice of monitoring, maintaining, and operating Information Technology (IT) systems to meet service levels that the business requires. Administration introduces some of the highest impact security risks because performing these tasks requires privileged access to a very broad set of these systems and applications. |
| [Applications and services][app] | Applications and the data associated with them ultimately act as the primary store of business value on a cloud platform. |
| [Governance, risk, and compliance][compliance] | How is the organization’s security going to be monitored, audited, and reported? What types of risks does the organization face while trying to protect identifiable information, Intellectual Property (IP), financial information? Are there specific industry, government, or regulatory requirements that dictate or provide recommendation on criteria that your organization’s security controls must meet? |
| [Identity and access management][identity] | Identity provides the basis of a large percentage of security assurances. |
| [Info protection and storage][info] | Protecting data at rest is required to maintain confidentiality, integrity, and availability assurances across all workloads. |
| [Network security and containment][network] | Network security has been the traditional lynchpin of enterprise security efforts. However, cloud computing has increased the requirement for network perimeters to be more porous and many attackers have mastered the art of attacks on identity system elements (which nearly always bypass network controls). |
| [Security Operations][identity] | Security operations maintain and restores the security assurances of the system as live adversaries attack it. The tasks of security operations are described well by the NIST Cybersecurity Framework functions of Detect, Respond, and Recover. |
| ... |  |

<!-- security links -->
[monitoring]: ./monitoring.md
[role]: ./role-of-security.md
[app]: ./application-services.md
[compliance]: ./governance.md
[identity]: ./identity-overview.md
[network]: ./network-overview.md
[design]: ./security/security-principles.md
[attacks]: ./security/architecture-type.md
[regulatory]: ./security/law-authority.md
[org-risk]: ./security/resilience.md
[admin]: ./admin-overview.md
[info]: ./infosec-overview.md
