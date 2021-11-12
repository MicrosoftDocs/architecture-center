---
title: Security patterns
titleSuffix: Cloud Design Patterns
description: Use these security patterns to help design and deploy applications in a way that protects them from attacks, restricts access, and protects sensitive data.
author: dragon119
ms.date: 06/23/2017
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - design-pattern
keywords:
  - design pattern
---

# Security patterns

Security provides confidentiality, integrity, and availability assurances against malicious attacks on information systems (and safety assurances for attacks on operational technology systems). Losing these assurances can negatively impact your business operations and revenue, as well as your organization's reputation in the marketplace. Maintaining security requires following well-established practices (security hygiene) and being vigilant to detect and rapidly remediate vulnerabilities and active attacks.

## Patterns

|                    Pattern                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Federated Identity](../../patterns/federated-identity.md) |                                                                                Delegate authentication to an external identity provider.                                                                                |
|         [Gatekeeper](../../patterns/gatekeeper.md)         | Protect applications and services by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. |
|          [Valet Key](../../patterns/valet-key.md)          |                                                        Use a token or key that provides clients with restricted direct access to a specific resource or service.                                                        |

## Key Security Resources

|                    Resource                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Azure Security Benchmarks](/azure/security/benchmarks/) |                                                                                Prescriptive best practices and recommendations to integrate into architectures for securing workloads, data, services, and enterprise environments on Azure.                                                                             |
|         [Microsoft Defender for Cloud](/azure/security-center/azure-defender)         | Native security controls to simplify integration of threat detection and monitoring in Azure architectures |
|          [Security Strategy Guidance](/azure/cloud-adoption-framework/strategy/define-security-strategy)          |                                                        Building and updating a security strategy for cloud adoption and modern threat environment                                                       |
|          [Security Roles and Responsibilities](/azure/cloud-adoption-framework/organize/cloud-security)          |                                                        Guidance on security roles and responsibilities including definitions of mission/outcome for each organizational function and how each should evolve with the adoption of cloud.           |
|          [Getting Started Guide for Security](/azure/cloud-adoption-framework/get-started/security)          |                                                        Guidance for planning and implementing security throughout cloud adoption         |

### Security Resiliency

Achieving security resilience requires a combination of preventive measures to block attacks, responsive measures detect and quickly remediate active attacks, and governance to ensure consistent application of best practices.

- **Security strategy** should include lessons learned described in [security strategy guidance](/azure/cloud-adoption-framework/strategy/define-security-strategy).
- **Azure security configurations** should align to the best practices and controls in the [Azure Security Benchmark (ASB)](/azure/security/benchmarks/). Security configurations for Azure services should align to the [Security baselines for Azure](/azure/security/benchmarks/security-baselines-overview) in the ASB.
- **Azure architectures** should integrate native security capabilities to protect and monitor workloads including [Microsoft Defender for Cloud](/azure/security-center/azure-defender), [Azure DDoS protection](/azure/ddos-protection/ddos-protection-overview), [Azure Firewall](/azure/firewall/), and [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/).

For a more detailed discussion, see the [Cybersecurity Resilience](https://microsoft.sharepoint.com/sites/globalsecurity) module in the CISO workshop.
