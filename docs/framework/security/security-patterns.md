---
title: Security patterns
titleSuffix: Cloud Design Patterns
description: Use these security patterns to help design and deploy applications in a way that protects them from attacks, restricts access, and protects sensitive data.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - seodec18
  - design-pattern
---

# Security patterns

Security provides confidentiality, integrity, and availability assurances against malicious attacks on information systems (and safety assurances for attacks on operational technology systems). Losing these assurances can negatively impact your business operations and revenue, as well as your organization’s reputation in the marketplace. Maintaining security requires following well-established practices (security hygiene) and being vigilant to detect and rapidly remediate vulnerabilities and active attacks. 

## Patterns

|                    Pattern                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Federated Identity](https://docs.microsoft.com/azure/architecture/patterns/federated-identity) |                                                                                Delegate authentication to an external identity provider.                                                                                |
|         [Gatekeeper](https://docs.microsoft.com/azure/architecture/patterns/gatekeeper)         | Protect applications and services by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. |
|          [Valet Key](https://docs.microsoft.com/azure/architecture/patterns/valet-key)          |                                                        Use a token or key that provides clients with restricted direct access to a specific resource or service.                                                        |

## Key Security Resources

|                    Resource                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Azure Security Benchmarks](https://docs.microsoft.com/azure/security/benchmarks/) |                                                                                Prescriptive best practices and recommendations to integrate into architectures for securing workloads, data, services, and enterprise environments on Azure.                                                                             |
|         [Azure Defender](https://docs.microsoft.com/azure/security-center/azure-defender)         | Native security controls to simplify integration of threat detection and monitoring in Azure architectures |
|          [Security Strategy Guidance](https://docs.microsoft.com/azure/cloud-adoption-framework/strategy/define-security-strategy)          |                                                        Building and updating a security strategy for cloud adoption and modern threat environment                                                       |
|          [Security Roles and Responsibilities](https://docs.microsoft.com/azure/cloud-adoption-framework/organize/cloud-security)          |                                                        Guidance on security roles and responsibilities including definitions of mission/outcome for each organizational function and how each should evolve with the adoption of cloud.           |
|          [Getting Started Guide for Security](https://docs.microsoft.com/azure/cloud-adoption-framework/get-started/security)          |                                                        Guidance for planning and implementing security throughout cloud adoption         |

### Security Resiliency

Achieving security resilience requires a combination of preventive measures to block attacks, responsive measures detect and quickly remediate active attacks, and governance to ensure consistent application of best practices.

- **Security strategy** should include lessons learned described in [security strategy guidance](https://docs.microsoft.com/azure/cloud-adoption-framework/strategy/define-security-strategy).
- **Azure security configurations** should align to the best practices and controls in the [Azure Security Benchmark (ASB)](https://docs.microsoft.com/azure/security/benchmarks/). Security configurations for Azure services should align to the [Security baselines for Azure](https://docs.microsoft.com/azure/security/benchmarks/security-baselines-overview) in the ASB.
- **Azure architectures** should integrate native security capabilities to protect and monitor workloads including [Azure Defender](https://docs.microsoft.com/azure/security-center/azure-defender), [Azure DDoS protection](https://docs.microsoft.com/azure/ddos-protection/ddos-protection-overview), [Azure Firewall](https://docs.microsoft.com/azure/firewall/), and [Azure Web Application Firewall (WAF)](https://docs.microsoft.com/azure/web-application-firewall/).

For a more detailed discussion, see the [Cybersecurity Resilience](/https://docs.microsoft.com/security/ciso-workshop/ciso-workshop-module-1#part-2-cybersecurity-resilience-1350) module in the CISO workshop.
