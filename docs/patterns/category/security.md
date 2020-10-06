---
title: Security patterns
titleSuffix: Cloud Design Patterns
description: Use these security patterns to help design and deploy applications in a way that protects them from attacks, restricts access, and protects sensitive data.
keywords: design pattern
author: dragon119
ms.date: 06/23/2017
ms.topic: design-pattern
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom: seodec18
---

# Security patterns

Security provides confidentiality, integrity, and availability assurances against malicious attacks on information systems (and safety assurances for attacks on operational technology systems). Losing these assurances can negatively impact your business operations and revenue, as well as your organization’s reputation in the marketplace. Maintaining security requires following well-established practices (security hygiene) and being vigilant to detect and rapidly remediate vulnerabilities and active attacks.

## Patterns

|                    Pattern                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Federated Identity](../federated-identity.md) |                                                                                Delegate authentication to an external identity provider.                                                                                |
|         [Gatekeeper](../gatekeeper.md)         | Protect applications and services by using a dedicated host instance that acts as a broker between clients and the application or service, validates and sanitizes requests, and passes requests and data between them. |
|          [Valet Key](../valet-key.md)          |                                                        Use a token or key that provides clients with restricted direct access to a specific resource or service.                                                        |

## Key Security Resources

|                    Resource                     |                                                                                                         Summary                                                                                                         |
|------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Azure Security Benchmarks](https://aka.ms/benchmarkdocs) |                                                                                Prescriptive best practices and recommendations to integrate into architectures for securing workloads, data, services, and enterprise environments on Azure.                                                                             |
|         [Azure Defender](/azure/security-center/azure-defender-dashboard)         | Native security controls to simplify integration of threat detection and monitoring in Azure architectures |
|          [Security Strategy Guidance](https://aka.ms/securitystrategy)          |                                                        Building and updating a security strategy for cloud adoption and modern threat environment                                                       |
|          [Security Roles and Responsibilities](https://aka.ms/securityroles)          |                                                        Guidance on security roles and responsibilities including definitions of mission/outcome for each organizational function and how each should evolve with the adoption of cloud.           |
|          [Getting Started Guide for Security](/azure/cloud-adoption-framework/get-started/security)          |                                                        Guidance for planning and implementing security throughout cloud adoption         |
