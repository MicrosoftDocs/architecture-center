---
title: Checklist - Optimize cost
description: Use these checklist considerations to help monitor and optimize workloads by using the right resources and sizes.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-advisor
ms.custom:
  - article
  - internal-intro
---

# Checklist - Optimize cost

Continue to monitor and optimize the workload by using the right resources and sizes. Use this checklist to optimize a workload.

- **Review the underutilized resources**. Evaluate CPU utilization and network throughput over time to check if the resources are used adequately. Azure Advisor identifies underutilized virtual machines. You can choose to decommission, resize, or shut down the machine to meet the cost requirements.

  - [Resize virtual machines](./optimize-vm.md#resize-virtual-machines)
  - [Shutdown the under utilized instances](./optimize-vm.md#shut-down-the-under-utilized-instances)

- **Continuously take action on the cost reviews**. Treat cost optimization as a process, rather than a point-in-time activity.  Use tooling in Azure that provides recommendations on usage or cost optimization. Review the cost management recommendations and take action. Make sure that all stakeholders are in agreement about the implementation and timing of the change.

  - **Recommended** tab in the [Azure portal](https://portal.azure.com/#blade/Microsoft_Azure_Reservations/CreateBlade/referrer/docs)
  - Recommendations in the [Cost Management Power BI app](https://appsource.microsoft.com/product/power-bi/costmanagement.azurecostmanagementapp)
  - Recommendations in [Azure Advisor](https://portal.azure.com/#blade/Microsoft_Azure_Expert/AdvisorMenuBlade/overview)
  - Recommendations using [Reservation REST APIs](/rest/api/consumption/reservationrecommendations/list)

- **Use reserved instances on long running workloads**. Reserve a prepaid capacity for a period, generally one or three years. With reserved instances, there's a significant discount when compared with pay-as-you-go pricing.

  - [Reserved instances](./optimize-reserved.md)

- **Use discount prices**. These methods of buying Azure resources can lower costs.

  - [Azure Hybrid Use Benefit](https://azure.microsoft.com/pricing/hybrid-benefit)
  - [Azure Reservations](https://azure.microsoft.com/reservations)

  There are also payment plans offered at a lower cost:

  - [Microsoft Azure Enterprise Agreement](/azure/cost-management-billing/manage/ea-portal-get-started)
  - [Enterprise Dev Test Subscription](https://azure.microsoft.com/offers/ms-azr-0148p/)
  - [Cloud Service Provider (Partner Program)](https://partner.microsoft.com/membership/cloud-solution-provider)

- **Have a scale-in and scale-out policy**. In a cost-optimized architecture, costs scale linearly with demand. Increasing customer base shouldn't require more investment in infrastructure. Conversely, if demand drops, scale-down of unused resources. Autoscale Azure resources when possible.

  - [Autoscale instances](./optimize-autoscale.md)

- **Reevaluate design choices**. Analyze the cost reports and forecast the capacity needs. You might need to change some design choices.

  - **Choose the right storage tier**. Consider using hot, cold, archive tier for storage account data. Storage accounts can provide automated tiering and lifecycle management. For more information, see [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options)

  - **Choose the right data store**. Instead of using one data store service, use a mix of data store depending on the type of data you need to store for each workload. For more information, see [Choose the right data store](../../guide/technology-choices/data-store-overview.md).

  - **Choose Spot VMs for low priority workloads**. Spot VMs are ideal for workloads that can be interrupted, such as highly parallel batch processing jobs.

    - [Spot VMs](./optimize-vm.md#spot-vms)

  - **Optimize data transfer**. Only deploy to multiple regions if your service levels require it for either availability or geo-distribution. Data going out of Azure datacenters can add cost because pricing is based on Billing Zones.

    - [Traffic across billing zones and regions](./design-regions.md#traffic-across-billing-zones-and-regions)

  - **Reduce load on servers**. Use Azure Content Delivery Network (CDN) and caching service to reduce load on front-end servers. Caching is suitable for servers that are continually rendering dynamic content that doesn't change frequently.

  - **Use managed services**. Measure the cost of maintaining infrastructure and replace it with Azure PaaS or SaaS services.

    - [Managed services](./design-paas.md)
