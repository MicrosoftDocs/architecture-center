---
title: Virtual Machines and cost optimization
description: Focuses on the Virtual Machine service used in the Compute solution to provide best-practice and configuration recommendations related to cost optimization.
author: v-stacywray
ms.date: 11/15/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - virtual-machines
categories:
  - compute
  - management-and-governance
---

# Virtual Machines and cost optimization

[Virtual Machines](/azure/virtual-machines/) are an on-demand, scalable computing resource that gives you the flexibility of virtualization without having to buy and maintain physical hardware to run it.

For more information about how virtual machines support cost optimization for your workloads, reference [Availability options for Azure Virtual Machines](/azure/virtual-machines/availability).

The following sections include a configuration checklist and recommendations specific to Virtual Machines and cost optimization.

## Checklist

**Have you configured Virtual Machines with cost optimization in mind?**
***
> [!div class="checklist"]
> - Shut down VM instances which aren't in use.
> - Use Spot VMs when appropriate.
> - Consider using Burstable (B) series VM sizes for VMs that are idle most of the time and have high usage for a certain period of time.
> - Use [Zone to Zone disaster recovery](/azure/site-recovery/azure-to-azure-how-to-enable-zone-to-zone-disaster-recovery) for virtual machines.
> - Review SKUs that could benefit from Reserved Instances for one year, three years, or more.

## Configuration recommendations

Explore the following table of recommendations to optimize your Virtual Machine configuration for service cost:

|Virtual Machine Recommendation|Description|
|------------------------------|-----------|
|Shut down VM instances which aren't in use.|Use the Start and Stop VMs during off-hours feature of virtual machines to minimize waste. Many configuration options exist to schedule start and stop times. The feature is suitable as a low-cost automation option. Azure Advisor evaluates virtual machines based on CPU and network usage over a time period. Advisor recommends actions like shut down or resize instances.|
|Use Spot VMs when appropriate.|Spot VMs are ideal for workloads that can be interrupted, such as highly parallel batch processing jobs. These VMs take advantage of the surplus capacity in Azure at a lower cost. They're also well suited for experimenting, developing, and testing large-scale solutions.|
|Consider using Burstable (B) series VM sizes for VMs that are idle most of the time and have high usage for a certain period of time.|The B-series VMs are ideal for workloads that don't need the full performance of the CPU continuously such as web servers, proof of concepts, small databases, and development build environments.|
|Use [Zone to Zone disaster recovery](/azure/site-recovery/azure-to-azure-how-to-enable-zone-to-zone-disaster-recovery) for virtual machines.| Replicate, failover, and failback your business-critical virtual machines within the same region with zones. Ideal for those customers that have complicated networking infrastructure and want to avoid the cost, and complexity of recreating infrastructure in a secondary region. For more information about regions, reference [Products available by region](https://azure.microsoft.com/global-infrastructure/services/).|
|Review SKUs that could benefit from Reserved Instances for one year, three years, or more.|Purchasing reserved instances is a way to reduce Azure costs for workloads with stable usage. Make sure you manage usage. If usage is too low, then you're paying for resources that aren't used. Keep RI instances simple and keep management overhead low to prevent increasing cost.|

## Next step

> [!div class="nextstepaction"]
> [Virtual machines and operational excellence](./operational-excellence.md)
