---
title: Security monitoring in Azure
description: Security logging and monitoring are activities related to enabling, acquiring, and storing audit logs for Azure services.
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---
 
# Security monitoring in Azure

Health modeling refers to the activities that maintain the security posture of a workload through monitoring. These activities can highlight, if the current security practices are effective or are there new requirements. Health modeling can be categorized as follows:
## Checklist
> [!div class="checklist"]
> - Monitor the workload and the infrastructure in which it runs.
> - Conduct audits.
> - Enable, acquire, and store audit logs.
> - Update and patch security fixes.
> - Respond to incidents.
> - Simlulate attacks based on real incidents. 

## In this section
|Assessment|Description|
|---|---|
|[**How is security monitored in the application context?**](monitor-tools.md)|Use Azure tools and services to monitor your security posture and also remediate incidents.|
|[**Is access to the control plane and data plane of the application periodically reviewed?**](monitor-identity-network.md)|Monitor network conditions and identity-related risk events regularly.|
|[**Do you implement security practices and tools during the development lifecycle?**](monitor-audit.md)|Activities related to enabling, acquiring, and storing audit logs for Azure services.|
|[**Are operational processes for incident response defined and tested?**](monitor-security-operations.md)|Guidance for the central SecOps team for monitoring security-related telemetry data and investigating security breaches.|
|[**How is the security of the workload validated?**](monitor-test.md)|Test the defense of the workload by simulating real-world attacks. Use penetration testing to simulate one-time attack and red teams to simulate long-term persistent attack groups.|

## Azure security benchmark
The Azure Security Benchmark includes a collection of high-impact security recommendations. Use them to secure the services and processes you use to run the workload in Azure:

> ![Security Benchmark](../../_images/benchmark-security.svg) The questions in this section are aligned to:
> - The [Azure Security Benchmarks Logging and threat detection](/azure/security/benchmarks/security-controls-v2-logging-threat-detection).
> - The [Azure Security Benchmarks Incident response](/azure/security/benchmarks/security-controls-v2-incident-response).
> 

## Next steps
We recommend applying as many best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program. 

> [!div class="nextstepaction"]
> [ Optimize security investments](./governance.md?branch=master#prioritize-security-best-practices-investments)

Assign stakeholders to use [Secure Score](/azure/security-center/secure-score-security-controls) in Azure Security Center to monitor risk profile and continuously improve security posture. 

> [!div class="nextstepaction"]
> [Operationalize Azure Secure Score](./governance.md?branch=master#operationalize-azure-secure-score)

## Related link
> Go back to the main article: [Security](overview.md)
