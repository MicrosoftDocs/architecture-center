---
title: Optimize for performance
description: How to optimize for application performance reliability in Azure
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Optimize for performance

Improve the reliability of your workloads by implementing high availability, disaster recovery, backup, and monitoring on the Azure cloud.

## Service availability

All Azure services and SKUs are not available within every Azure region, so it's important to understand if the selected regions for the application offer all of the required capabilities. Service availability also varies across sovereign clouds, such as China ("Mooncake") or USGov, USNat, and USSec clouds. In situations where capabilities are missing, steps should be taken to ascertain if a roadmap exists to deliver required services. To learn more4, see [Azure Products by Region](https://azure.microsoft.com/global-infrastructure/services/).

Not all regions support Availability Zones today. When assessing the suitability of availability strategy in relation to targets, it's important to confirm if targeted regions also provide zonal support. Existing regions will expand to provide support for Availability Zones where possible.

### Preview services

If the application has taken a dependency on preview services or SKUs, then it's important to ensure that the level of support and committed SLAs align with expectations. It's also important that roadmap plans for preview services to go Generally Available (GA) are understood:

- Private Preview &mdash; SLAs do not apply and formal support is not generally provided.
- Public Preview &mdash; SLAs do not apply and formal support may be provided on a best-effort basis.

> [!NOTE]
> While there is a desire across Azure to achieve API/SDK uniformity for supported languages and runtimes, the reality is that capability deltas exist. For instance, not all CosmosDB APIs support the use of direct connect mode over TCP to bypass the platform HTTP gateway. It's important to ensure that APIs/SDKs for selected languages and runtimes provide all of the required capabilities.

## Capacity

A capacity model should describe the relationships between the utilization of various components as a ratio, to capture when and how application components should scale-out. For instance, scaling the number of Application Gateway v2 instances may put excess pressure on downstream components unless also scaled to a degree. When modelling capacity for critical system components it's recommended that an N+1 model be applied to ensure complete tolerance to transient faults, where n describes the capacity required to satisfy performance and availability requirements.

Considerations for required capacity:

**Is the required capacity (initial and future growth) within Azure service scale limits and quotas?**
***

Due to physical and logical resource constraints within the platform, Azure must apply limits and quotas to service scalability, which may be either hard or soft. The application should take a scale-unit approach to navigate within service limits, and where necessary consider multiple subscriptions which are often the boundary for such limits. It is highly recommended that a structured approach to scale be designed up-front rather than resorting to a 'spill and fill' model. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

**Is the required capacity (initial and future growth) available within targeted regions?**
***

While the promise of the cloud is infinite scale, the reality is that there are finite resources available. As a result, situations can occur where capacity can be constrained due to overall demand. If the application requires a large amount of capacity, or expects a significant increase in capacity, you should ensure that desired capacity is attainable within selected region(s). For applications leveraging a recovery or active-passive based disaster recovery strategy, you should also consider ensuring that suitable capacity exists in the secondary region(s). This is because a regional outage can lead to a significant increase in demand within a paired region. To help mitigate this, consider pre-provisioning resources within the secondary region. To learn more, see [Azure capacity](https://aka.ms/AzureCapacity).

## Scalability

Ensure that the application can scale within the port limits of the chosen application hosting platform. If an application is initiating many outbound TCP or UDP connections, it may exhaust all available ports leading to [SNAT port exhaustion](https://docs.microsoft.com/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust) and poor application performance. Long-running connections exacerbate this risk by occupying ports for sustained durations. 

Considerations for scalability:

**Are target data sizes and associated growth rates calculated per scenario or service?**
***

Scale limits and recovery options should be assessed in the context of target data sizes and growth rates to ensure suitable capacity exists.

**Are there any mitigation plans defined in case data size exceeds limits?**
***

Mitigation plans such as purging or archiving data can help the application to remain available in scenarios where data size exceeds expected limits.

## Throughput and latency

*Data latency* targets should be defined and measured for key application scenarios, as well as each individual component, to validate overall application performance and health. Latency targets are commonly defined as first byte in to last byte out.

*Data throughput* targets should be defined and measured for key application scenarios and each individual component, to validate overall application performance and health. Available throughput typically varies based on SKU, so defined targets should be used to inform the use of appropriate SKUs. Throughput targets are commonly defined in terms of IOPS, MB/s and Block Size.

Components or scenarios that are sensitive to *network latency* may indicate a need for co-locality within a single Availability Zone or even closer using Proximity Placement Groups with Accelerated Networking enabled.

It's also important to consider gateways when evaluating network latency. Gateways (ExpressRoute or VPN) should be sized accordingly to the expected cross-premises *network throughput*.

Gateways should be sized according to required throughput. Azure Virtual Network Gateways throughput varies based on SKU. Applications with stringent throughput requirements may require dedicated bandwidth to remove the risks associated with noisy neighbor scenarios. Also, autoscaling should be enabled based on throughput to mitigate common bottleneck situations.

## Elasticity

A scale-unit approach should be taken to ensure that each application component and the application as a whole can scale effectively in response to changing demand. A robust capacity model should be used to define when and how the application should scale.

Time to scale-in and scale-out can vary between Azure services and instance sizes. They should be assessed to determine if a certain amount of pre-scaling is required to handle scale requirements and expected traffic patterns, such as seasonal load variations. Take advantage of autoscaling using [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) to address unanticipated peak loads to help prevent application outages caused by overloading.

> [!NOTE]
> The scaling on any single component may have an impact on downstream application components and dependencies. Test autoscaling regularly to help inform and validate a capacity model describing when and how application components should scale.

## Next step

>[!div class="nextstepaction"]
>[Security optimization](/azure/architecture/framework/resiliency/optimize-security)

## Related links

- For information on regions and Availability Zones, see [Regions that support Availability Zones in Azure](https://docs.microsoft.com/azure/availability-zones/az-region).
- For information on SNAT, see [Managing SNAT port exhaustion](/azure/load-balancer/troubleshoot-outbound-connection#snatexhaust).
- For information on proximity placement groups, see [Co-locate resources for improved latency](/azure/virtual-machines/co-location).
-  For information on VPN gateway SKUs, see [(Gateway SKUs](/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku).

Go back to the main article: [Optimize](optimize-checklist.md)