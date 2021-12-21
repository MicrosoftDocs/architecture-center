---
title: Measure usage to get Azure resource cost
description: Select Azure resources using cost strategies such as usage meters, allocated usage, subscription and offer types, or Azure Marketplace billing structures.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Azure resources 
Just like on-premises equipment, there are several elements that affect monthly costs when using Azure services.

## Usage meters for resources
Most services are priced based on units of size, amount of data, or operations. When you provision an Azure resource, Azure creates metered instances for that resource. The _meters_ track the resources' usage and generate a usage record that is used to calculate your bill.

For example, you provision a virtual machine in Azure. Some meters that track its usage include: Compute Hours, IP Address Hours, Data Transfer In, Data Transfer Out, Standard Managed Disk, Standard Managed Disk Operations, Standard IO-Disk, Standard IO-Block Blob Read, Standard IO-Block Blob Write, Standard IO-Block Blob Delete.

**How is the usage tracked for each resource in the workload?**  
***

For each Azure resource, have a clear understanding of the meters that track usage and the number of meters associated with the resource tier. The meters correlate to several billable units. Those units are charged to the account for each billing period. The rate per billable unit depends on the resource tier.

A resource tier impacts pricing because each tier offers levels of features such as performance or availability. For example, a Standard HDD hard disk is cheaper than a Premium SSD hard disk.

> ![Task](../../_images/i-best-practices.svg) Start with a lower resource tier then scale the resource up as needed. Growing a service with little to  no downtime is easier when compared to downscaling a service. Downscaling usually requires deprovisioning or downtime. In general, choose scaling out instead of scaling up.

As part of the requirements, consider the metrics for each resource  and build your alerts on baseline thresholds for each metric. The alerts can be used to fine-tune the resources. For more information, see [Respond to cost alert](monitor-alert.md).

## Allocated usage for the resource

Another way to look at pricing is the allocated usage.

Suppose, you de-allocate the virtual machine. You'll not be billed for Compute Hours, I/O reads or writes, and other compute meters because the virtual machine is not running and has no given compute resources. However, you'll be charged for storage costs for the disks.

Here are some considerations:
- The meters and pricing vary per product and often have different pricing tiers based on the location, size, or capacity of the resource.
- Cost for associated with infrastructure is kept low with commodity hardware.
- Failures cannot be prevented but the effects of failure can be minimized through design choices. The resiliency features are factored in the price of a service and its features.

Here are some examples:

### Azure Disk
Start with a small size in GB for a managed disk instead of pay-per-GB model. It's cost effective because cost is incurred on the allocated storage. 
### ExpressRoute
Start with a smaller bandwidth circuit and scale up as needed. 
### Compute infrastructure
Deploy an additional smaller instance of compute alongside a smaller unit in parallel. That approach is more cost effective in comparison to restarting an instance to scale up.

For details about how billing works, see [Azure Cost Management + Billing documentation](/azure/cost-management-billing/).

## Subscription and offer type

**What is the subscription and offer type in which resources are created?**  
***

Azure usage rates and billing periods can vary depending on the subscription and offer type. Some subscription types also include usage allowances or lower prices. For example, Azure [Dev/Test subscription](https://azure.microsoft.com/offers/ms-azr-0148p/) offers lower prices on Azure services such as specific VM sizes, PaaS web apps, and VM images with pre-installed software. Visual Studio subscribers obtain as part of their benefits access to [Azure subscriptions](https://azure.microsoft.com/offers/ms-azr-0063p/) with monthly allowances.

For information about the subscription offers, see [Microsoft Azure Offer Details](https://azure.microsoft.com/support/legal/offer-details/).

As you decide the offer type, consider the types that support [Azure Reservations](/azure/cost-management-billing/reservations/). With reservations, you prepay for reserved capacity at a discount. Reservations are suitable for workloads that have a long-term usage pattern. Combining the offer type with reservations can significantly lower the cost. For information about subscription and offer types that are eligible for reservations, see [Discounted subscription and offer types](/azure/cost-management-billing/reservations/prepare-buy-reservation#scope-reservations).

## Billing structure for services in Azure Marketplace

**Are you considering third-party services through Azure Marketplace?**  
***

Azure Marketplace offers both the Azure products and services from third-party vendors. Different billing structures apply to each of those categories. The billing structures can range from free, pay-as-you-go, one-time purchase fee, or a managed offering with support and licensing monthly costs.
