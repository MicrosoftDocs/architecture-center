---
title: Plan for capacity
description: Describes the capacity design options for performance efficiency
author: v-aangie
ms.date: 11/13/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - How are you ensuring you have sufficient Capacity?
  - article
---

# Plan for capacity

Businesses should account for future growth when they plan capacity requirements to ensure that business needs are continually met. Choosing the right capacity can also minimize cost.

## Accelerate performance with Azure Content Delivery Networks

A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. The major advantages of using a CDN are lower latency and faster delivery of content to users.

CDNs typically are used to cache static objects loaded from Azure Blob storage, a web application, or any publicly accessible web server, by using the closest point of presence (POP) server. CDNs can also accelerate dynamic content, which cannot be cached, by leveraging various network and routing optimizations. For example, a CDN can route optimization to bypass Border Gateway Protocol (BGP).

[Azure Content Delivery Network](https://docs.microsoft.com/azure/cdn/) is a global CDN solution for delivering high-bandwidth content that is hosted in Azure or any other location. Billing rate may differ depending on the billing region based on the location of the source server delivering the content to the end user. The physical location of the client isn't the billing region. Any HTTP or HTTPS request that hits the CDN is a billable event, which includes all response types: success, failure, or other. Different responses may generate different traffic amounts.

> [!TIP]
> To lower costs, consider increasing the cache time to live (TTL) by caching resource files for a longer duration and setting the longest TTL possible on your content.

For an overview of Azure CDN, see [What is a content delivery network on Azure?](https://docs.microsoft.com/azure/cdn/cdn-overview)

To learn more about CDNs, see [General guidelines and good practices](https://docs.microsoft.com/azure/architecture/best-practices/cdn#general-guidelines-and-good-practices).

## Prepare infrastructure for large-scale events

Large-scale application design takes careful planning and possibly involves complex implementation. Work with your business and marketing teams to prepare for large-scale events. Knowing if there will be sudden spikes in traffic such as Superbowl, Black Friday, or Marketing pushes, can allow you to prepare your infrastructure ahead of time.

A fundamental design principle in Azure is to [scale-out](docs\framework\scalability\design-scale.md) by adding machines or service instances based on increased demand. Scaling out can be a better alternative to purchasing additional hardware, which may not be in your budget. Depending on your payment plan, you don't pay for idle VMs or need to reserve capacity in advance. A pay as you go plan is usually ideal for applications that need to meet planned spikes in traffic.

> [!NOTE]
> Don't plan for capacity to meet the highest level of expected demand. An inappropriate or misconfigured service can impact cost. For example, building a multiregion service when the service levels don't require high-availability or geo-redundancy will increase cost without reasonable business justification.

## Choosing the right resources

Right sizing your infrastructure to meet the needs of your applications can save you considerably as opposed to a "one size fits all" solution often employed with on-premises hardware. Identify the needs of your application and choose the resources that best fit those needs. You can choose various options when you deploy Azure VMs to support workloads. 

Each VM type has specific features and different combinations of CPU, memory, and disks. For example, the B-series VMs are ideal for workloads that don't need the full performance of the CPU continuously, like web servers, proof of concepts, small databases, and development build environments. The [B-Series](https://docs.microsoft.com/azure/virtual-machines/sizes-b-series-burstable) offers a cost effective way to deploy these workloads that don't need the full performance of the CPU continuously and burst in their performance.

For a list of sizes and a description of the recommended use, see [sizes for virtual machines in Azure](https://docs.microsoft.com/azure/virtual-machines/sizes).

If you discover over time that your VMs aren't optimized or have frequent periods when they aren't used, it makes sense to either shut them down or downscale them by using virtual machine scale sets. You can optimize a VM with Azure Automation, virtual machine scale sets, auto-shutdown, and scripted or third-party solutions. To learn more, see [Automate VM optimization](https://docs.microsoft.com/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-costs#best-practice-automate-vm-optimization).

Along with choosing the right VMs, selecting the right storage type can save your organization several thousands of dollars every month. File (storage) data is commonly migrated to the cloud to help alleviate operational and management challenges. For a list of storage data types, access tiers, storage account types, and storage redundancy options, see [Select the right storage](https://docs.microsoft.com/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-costs#best-practice-select-the-right-storage).

## Choosing metrics for scaling policies

Autoscaling rules that use a detection mechanism based on a measured trigger attribute (such as CPU usage or queue length) use an aggregated value over time, rather than instantaneous values, to trigger an autoscaling action. By default, the aggregate is an average of the values. This prevents the system from reacting too quickly, or causing rapid oscillation. To learn more, see [Autoscaling](https://docs.microsoft.com/azure/architecture/best-practices/auto-scaling).

Azure Monitor autoscale provides a common set of autoscaling functionality for virtual machine scale sets, Azure App Service, Azure Cloud Service, and API Management. Scaling can be performed on a schedule, or based on a runtime metric, such as CPU or memory usage. For example, you can set a trigger attribute to scale out by one instance if average CPU usage is above 70%, and scale in by one instance if CPU usage falls below 50%.

For a list of built-in metrics, see [Azure Monitor autoscaling common metrics](https://docs.microsoft.com/azure/azure-monitor/platform/autoscale-common-metrics). You can also implement custom metrics by using [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview) to monitor the performance of your live applications. Some Azure services use different scaling methods.

## Preemptively scaling based on trends

Preemptively scaling based on historical data can ensure your application has consistent performance, even though your metrics haven't yet indicated the need to scale. Schedule-based rules allow you to scale when you see time patterns in your load and want to scale before a possible load increase or decrease occurs. For example, you can set a trigger attribute to scale out to 10 instances on weekdays, and scale in to 4 instances on Saturday and Sunday. If you can predict the load on the application, consider using scheduled autoscaling, which adds and removes instances to meet anticipated peaks in demand.

To learn more, see [Use Azure Monitor autoscale](https://docs.microsoft.com/azure/architecture/best-practices/auto-scaling#use-azure-monitor-autoscale).

## Next step

>[!div class="nextstepaction"]
>[Performance testing]()