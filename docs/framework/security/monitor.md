---
title: Security health modeling in Azure
description: Security logging and monitoring are activities related to enabling, acquiring, and storing audit logs for Azure services. 
author: PageWriter-MSFT
ms.date: 11/03/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---
 
# Security health modeling

Health modeling refers to the activities that maintain the security posture of a workload through monitoring. These activities can highlight, if the current security practices are effective or are there new requirements. Health modeling can be categorized as follows:
## Key points
> [!div class="checklist"]
> - Monitor the workload and the infrastructure in which it runs.
> - Conduct audits.
> - Enable, acquire, and store audit logs.
> - Update and patch security fixes.
> - Respond to incidents.

## In this section
|Assessment|Description|
|---|---|
|[**How is security monitored in the application context?**](monitor-tools.md)|Use Azure tools and services to monitor your security posture and also remediate incidents.|
|[**Is access to the control plane and data plane of the application periodically reviewed?**](monitor-identity-network.md)|Monitor network conditions and identity-related risk events regularly.|
|[**Do you implement security practices and tools during the development lifecycle?**](monitor-audit.md)|Activities related to enabling, acquiring, and storing audit logs for Azure services.|
|[**Are operational processes for incident response defined and tested?**](monitor-security-operations.md)|Guidance for the central SecOps team for monitoring security-related telemetry data and investigating security breaches.|

## Next steps
We recommend applying as many as of the best practices as early as possible, and then working to retrofit any gaps over time as you mature your security program. 

> [!div class="nextstepaction"]
> [ Optimize security investments](./governance.md?branch=master#prioritize-security-best-practices-investments)

Assign stakeholders to use [Secure Score](/azure/security-center/secure-score-security-controls) in Azure Security Center to monitor risk profile and continuously improve security posture. 

> [!div class="nextstepaction"]
> [Operationalize Azure Secure Score](./governance.md?branch=master#operationalize-azure-secure-score)