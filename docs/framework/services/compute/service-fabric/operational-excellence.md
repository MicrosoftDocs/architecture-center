---
title: Azure Service Fabric and operational excellence
description: Focuses on the Azure Service Fabric used in the Compute solution to provide best-practice, configuration recommendations, and design considerations related to operational excellence.
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

# Azure Service Fabric and operational excellence

[Azure Service Fabric](/azure/service-fabric/service-fabric-overview) is a distributed systems platform that makes it easy to:

- Package
- Deploy
- Manage scalable and reliable microservices, and containers.

For more information about how Azure Service Fabric creates scalable and reliable production-ready workloads, reference the [Production readiness checklist](/azure/service-fabric/service-fabric-production-readiness-checklist).

The following section covers configuration recommendations, specific to Azure Service Fabric, and operational excellence.

## Checklist

**Have you configured Azure Service Fabric with operational excellence in mind?**
***

> [!div class="checklist"]
> - When using secrets such as connection strings and passwords in Service Fabric services, either retrieve secrets directly from Key Vault at runtime or use the [Service Fabric Secrets Store](/azure/service-fabric/service-fabric-application-secret-store).
> - Use durability level Silver (5 VMs) or greater for production scenarios.
> - For critical workloads, consider using Availability Zones for your Service Fabric clusters.
> - For production scenarios, use the Standard tier load balancer. The Basic SKU is free, but doesn't have an SLA.
> - Apply Network Security Groups (NSG) to restrict traffic flow between subnets and node types. Ensure that the [correct ports](/azure/service-fabric/service-fabric-best-practices-networking#cluster-networking) are opened for managing the cluster.
> - Review the [Service Fabric production readiness checklist](/azure/service-fabric/service-fabric-production-readiness-checklist).
> - When using the Service Fabric Secret Store to distribute secrets, use a separate data encipherment certificate to encrypt the values.
> - Don't use self-signed certificates for production scenarios. Either provision a certificate through your PKI or use a public certificate authority.
> - Deploy certificates by adding them to Azure Key Vault and referencing the URI in your deployment.
> - Create a process for monitoring the expiration date of certificates.
> - Enable Azure Active Directory integration for your cluster to ensure users can access Service Fabric Explorer using their AAD credentials. Don't distribute the cluster certificate among users to access Explorer.
> - Exclude the Service Fabric processes from Windows Defender to improve performance.
> - Keep the different node types and gateway services on different subnets.

## Configuration recommendations

Explore the following table of recommendations to optimize your Azure Service Fabric configuration for operational excellence:

|Azure Service Fabric Recommendation|Description|
|-----------------------------------|-----------|
|Use durability level Silver (5 VMs) or greater for production scenarios.|This level ensures the Azure infrastructure communicates with the Service Fabric controller on scheduling reboots, and so on.|
|Consider using Availability Zones for your Service Fabric clusters.|Deploy a primary NodeType (and by extension a virtual machine scale set) to each AZ, which ensures the Service Fabric system services are spread across zones.|
|Apply Network Security Groups (NSG) to restrict traffic flow between subnets and node types.|For example, you may have an API Management instance (one subnet), a frontend subnet (exposing a website directly), and a backend subnet (accessible only to frontend), each implemented on a different virtual machine scale set.|
|Use a separate data encipherment certificate to encrypt the values, when using the Service Fabric Secret Store to distribute secrets.|This certificate is deployed to the virtual machine scale set nodes to decrypt the secret values. When using this approach, ensure that secrets are inserted and encrypted at release time. Using this approach means that changing the secrets requires a deployment. Make sure your key-rotation process is fully automated to follow this process without downtime.|
|Create a process for monitoring the expiration date of certificates.|For example, Key Vault offers a feature that sends an email when `x%` of the certificate's lifespan has elapsed.|
|Exclude the Service Fabric processes from Windows Defender to improve performance.|By default, Windows Defender antivirus is installed on Windows Server 2016 and 2019. To reduce any performance impact and resource consumption overhead incurred by Windows Defender, and if your security policies allow you to exclude processes and paths for open-source software, you can [exclude](/azure/service-fabric/## Next step

> [!div class="nextstepaction"]
> [Azure Service Fabric and performance efficiency](./performance-efficiency.md)

