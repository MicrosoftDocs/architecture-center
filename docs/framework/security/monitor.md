---
title: Security monitoring in Azure
description: Security logging and monitoring are activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-security-center
  - azure-sentinel
  - azure-monitor
categories:
  - security
subject:
  - security
  - monitoring
ms.custom:
  - article
---

# Security monitoring and remediation in Azure

Regularly monitor resources to maintain the security posture and detect vulnerabilities. Detection can take the form of reacting to an alert of suspicious activity or proactively hunting for anomalous events in the enterprise activity logs. vigilantly responding to anomalies and alerts to prevent security assurance decay, and designing for defense in depth and least privilege strategies.

## Checklist

**How are you monitoring security-related events in this workload?**
***

> [!div class="checklist"]
> - Use native tools in Azure to monitor the workload resources and the infrastructure in which it runs.
> - Consider investing in a Security Operations Center (SOC), or SecOps team and incident response plan.
> - Monitor traffic, access requests, and application communication between segments.
> - Discover and remediate common risks to improve secure score in Microsoft Defender for Cloud.
> - Use an industry standard benchmark to evaluate the security posture by learning from external organizations.
> - Send logs and alerts to a central security log management for analysis.
> - Perform regular internal and external compliance audits, including regulatory compliance attestations.
> - Regularly test your security design and implementation using test cases based on real-world attacks.

## Azure security benchmark

The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to these controls:
> - [Azure Security Benchmarks Logging and threat detection](/azure/security/benchmarks/security-controls-v2-logging-threat-detection).
> - [Azure Security Benchmarks Incident response](/azure/security/benchmarks/security-controls-v2-incident-response).
> - [Posture and Vulnerability Management](/azure/security/benchmarks/security-controls-v2-posture-vulnerability-management)

## Reference architecture

- [Hybrid Security Monitoring using Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)

  This reference architecture illustrates how to use Microsoft Defender for Cloud and Microsoft Sentinel to monitor the security configuration and telemetry of on-premises and Azure operating system workloads.

- [Azure security solutions for AWS](../../reference-architectures/aws/aws-azure-security-solutions.yml)

  This article provides AWS identity architects, administrators, and security analysts with immediate insights and detailed guidance for deploying several Microsoft security solutions.

## Next step

We recommend applying as many best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program.

## Related link

> Go back to the main article: [Security](overview.md)
