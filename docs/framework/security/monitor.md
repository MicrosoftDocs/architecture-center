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
> - Discover and remediate common risks to improve secure score in Azure Security Center.
> - Use an industry standard benchmark to evaluate the security posture by learning from external organizations.
> - Send logs and alerts to a central security log management for analysis.
> - Perform regular internal and external compliance audits, including regulatory compliance attestations.
> - Regularly test your security design and implementation using test cases based on real-world attacks.

## Security monitoring assessments
Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**What tools do you use to monitor security?**](monitor-tools.md)|Use Azure tools and services to monitor your security posture and also remediate incidents.|
|[**How do you discover common risks to resources used in the workload?**](monitor-resources.md)|Azure Security Center provides recommendations for resources that remediate common risks.|
|[**Have you centralized logs and alerts to SIEM and SOAR?**](monitor-logs-alerts.md)|Integrate logs from Azure resources and platform to a central location. This will help in statistical analysis and auditing.|
|[**How do you discover and remediate common risks in the Azure subscription that contains the resources for the workload?**](monitor-remediate.md)|Formally review Azure Security Center's Secure Score on a regular basis and take actions out of it.|
|[**How do you monitor and maintain your compliance of this workload?**](monitor-audit.md)|Activities related to enabling, acquiring, and storing audit logs for Azure services.|
|[**How is the security of the workload validated?**](monitor-test.md)|Test the defense of the workload by simulating real-world attacks. Use penetration testing to simulate one-time attack and red teams to simulate long-term persistent attack groups.|
|[**Are operational processes for incident response defined and tested?**](monitor-security-operations.md)|Guidance for the central SecOps team for monitoring security-related telemetry data and investigating security breaches.|

## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to these controls:
> - [Azure Security Benchmarks Logging and threat detection](/azure/security/benchmarks/security-controls-v2-logging-threat-detection).
> - [Azure Security Benchmarks Incident response](/azure/security/benchmarks/security-controls-v2-incident-response).
> - [Posture and Vulnerability Management](/azure/security/benchmarks/security-controls-v2-posture-vulnerability-management)

## Reference architecture

- [Hybrid Security Monitoring using Azure Security Center and Azure Sentinel](../../hybrid/hybrid-security-monitoring.yml)

  This reference architecture illustrates how to use Azure Security Center and Azure Sentinel to monitor the security configuration and telemetry of on-premises and Azure operating system workloads.

- [Azure security solutions for AWS](../../reference-architectures/aws/aws-azure-security-solutions.yml)

  This article provides AWS identity architects, administrators, and security analysts with immediate insights and detailed guidance for deploying several Microsoft security solutions.

## Next step
We recommend applying as many best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program. 

## Related link
> Go back to the main article: [Security](overview.md)