---
title: Azure Service Fabric and security
description: Focuses on the Azure Service Fabric used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to service security.
author: v-stacywray
ms.date: 11/15/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-service-fabric
categories:
  - compute
  - management-and-governance
---

# Azure Service Fabric and security

[Azure Service Fabric](/azure/service-fabric/service-fabric-overview) is a distributed systems platform that makes it easy to:

- Package
- Deploy
- Manage scalable and reliable microservices, and containers.

For more information about how Azure Service Fabric creates a secure and reliable state, reference [Azure Service Fabric security](/azure/service-fabric/service-fabric-best-practices-security).

The following section covers configuration recommendations, specific to Azure Service Fabric, and security.

## Checklist

**Have you configured Azure Service Fabric with security in mind?**
***

> [!div class="checklist"]
> - Apply Network Security Groups (NSG) to restrict traffic flow between subnets and node types. Ensure that the [correct ports](/azure/service-fabric/service-fabric-best-practices-networking#cluster-networking) are opened for managing the cluster.

## Configuration recommendation

Consider the following recommendation to optimize your Azure Service Fabric configuration for security:

|Azure Service Fabric Recommendation|Description|
|-----------------------------------|-----------|
|Apply Network Security Groups (NSG) to restrict traffic flow between subnets and node types.|For example, you may have an API Management instance (one subnet), a frontend subnet (exposing a website directly), and a backend subnet (accessible only to frontend), each implemented on a different virtual machine scale set.|

## Next step

> [!div class="nextstepaction"]
> [Azure Service Fabric and operational excellence](./operational-excellence.md)
