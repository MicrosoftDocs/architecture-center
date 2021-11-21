---
title: Azure Service Fabric and performance efficiency
description: Focuses on the Azure Service Fabric used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to service performance efficiency.
author: v-stacywray
ms.date: 11/17/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-service-fabric
categories:
  - compute
  - management-and-governance
---

# Azure Service Fabric and performance efficiency

[Azure Service Fabric](/azure/service-fabric/service-fabric-overview) is a distributed systems platform that makes it easy to:

- Package
- Deploy
- Manage scalable and reliable microservices, and containers.

For more information about how Azure Service Fabric can reduce performance issues for your workload with Service Fabric performance counters, reference [Monitoring and diagnostic best practices for Azure Service Fabric](/azure/service-fabric/service-fabric-best-practices-monitoring).

The following section covers configuration recommendations, specific to Azure Service Fabric, and performance efficiency.

## Checklist

**Have you configured Azure Service Fabric with performance efficiency in mind?**
***

> [!div class="checklist"]
> - Exclude the Service Fabric processes from Windows Defender to improve performance.

## Configuration recommendation

Consider the following recommendation to optimize your Azure Service Fabric configuration for performance efficiency:

|Azure Service Fabric Recommendation|Description|
|-----------------------------------|-----------|
|Exclude the Service Fabric processes from Windows Defender to improve performance.|By default, Windows Defender antivirus is installed on Windows Server 2016 and 2019. To reduce any performance impact and resource consumption overhead incurred by Windows Defender, and if your security policies allow you to exclude processes and paths for open-source software, you can exclude the Service Fabric executables from Defender scans.|

## Next step

> [!div class="nextstepaction"]
> [Azure Virtual Machines and reliability](../virtual-machines/reliability.md)
