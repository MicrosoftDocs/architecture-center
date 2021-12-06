---
title: Plan for capacity
description: Plan to meet capacity design requirements for performance efficiency. Understand options to reduce cost.
author: v-aangie
ms.date: 12/01/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
categories:
  - management-and-governance
ms.custom:
  - How are you ensuring you have sufficient Capacity?
  - article
---
# Plan for capacity

Azure offers many options to meet capacity requirements as your business grows. These options can also minimize cost.

## Scale out rather than scaling up

When using cloud technologies, it's generally easier, cheaper, and more effective to scale out than scaling up. Plan to scale your application tier by adding extra infrastructure to meet demand. Be sure to remove the resources when they are not needed. If you plan to scale up by increasing the resources allocated to your hosts, you will reach a limit where it becomes cost-prohibitive to scale any further. Scaling up also often requires downtime for your servers to reboot.

## Prepare infrastructure for large-scale events

Large-scale application design takes careful planning and possibly involves complex implementation. Work with your business and marketing teams to prepare for large-scale events. Knowing if there will be sudden spikes in traffic such as Superbowl, Black Friday, or Marketing pushes, can allow you to prepare your infrastructure ahead of time.

A fundamental design principle in Azure is to scale out by adding machines or service instances based on increased demand. Scaling out can be a better alternative to purchasing additional hardware, which may not be in your budget. Depending on your payment plan, you don't pay for idle VMs or need to reserve capacity in advance. A pay-as-you-go plan is usually ideal for applications that need to meet planned spikes in traffic.

> [!NOTE]
> Don't plan for capacity to meet the highest level of expected demand. An inappropriate or misconfigured service can impact cost. For example, building a multiregion service when the service levels don't require high-availability or geo-redundancy will increase cost without reasonable business justification.

## Choose the right resources

Right sizing your infrastructure to meet the needs of your applications can save you considerably as opposed to a "one size fits all" solution often employed with on-premises hardware. You can choose various options when you deploy Azure VMs to support workloads.

Each VM type has specific features and different combinations of CPU, memory, and disks. For example, the B-series VMs are ideal for workloads that don't need the full performance of the CPU continuously, like web servers, proof of concepts, small databases, and development build environments. The [B-Series](/azure/virtual-machines/sizes-b-series-burstable) offers a cost effective way to deploy these workloads that don't need the full performance of the CPU continuously and burst in their performance.

For a list of sizes and a description of the recommended use, see [sizes for virtual machines in Azure](/azure/virtual-machines/sizes).

Continually monitor workloads after migration to find out if your VMs aren't optimized or have frequent periods when they aren't used. If you discover this, it makes sense to either shut down the VMs or downscale them by using virtual machine scale sets. You can optimize a VM with Azure Automation, virtual machine scale sets, auto-shutdown, and scripted or third-party solutions. To learn more, see [Automate VM optimization](/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-costs#best-practice-automate-vm-optimization).

Along with choosing the right VMs, selecting the right storage type can save your organization significant cost every month. For a list of storage data types, access tiers, storage account types, and storage redundancy options, see [Select the right storage](/azure/cloud-adoption-framework/migrate/azure-best-practices/migrate-best-practices-costs#best-practice-select-the-right-storage).

## Use metrics to fine-tune scaling

It's often difficult to understand the relationship between metrics and capacity requirements, especially when an application is initially deployed. Provision a little extra capacity at the beginning, and then monitor and tune the *autoscaling* rules to bring the capacity closer to the actual load. *Autoscaling* enables you to run the right amount of resources to handle the load of your app. It adds resources (called scaling out) to handle an increase in load such as seasonal workloads and customer facing applications.

After configuring the autoscaling rules, monitor the performance of your application over time. Use the results of this monitoring to adjust the way in which the system scales if necessary.

[Azure Monitor autoscale](/azure/azure-monitor/platform/autoscale-overview) provides a common set of autoscaling functionality for virtual machine scale sets, Azure App Service, and Azure Cloud Service. Scaling can be performed on a schedule, or based on a runtime metric, such as CPU or memory usage. For example, you can scale out by one instance if average CPU usage is above 70%, and scale in by one instance if CPU usage falls below 50 percent.

The default autoscaling rules are set to know when it's time to execute an autoscaling action in order to prevent the system from reacting too quickly. To learn more, see [Autoscaling](../../best-practices/auto-scaling.md).

For a list of built-in metrics, see [Azure Monitor autoscaling common metrics](/azure/azure-monitor/platform/autoscale-common-metrics). You can also implement custom metrics by using [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor the performance of your live applications. Some Azure services use different scaling methods.

## Preemptively scaling based on trends

Preemptively scaling based on historical data can ensure your application has consistent performance, even though your metrics haven't yet indicated the need to scale. Schedule-based rules allow you to scale when you see time patterns in your load and want to scale before a possible load increase or decrease occurs. For example, you can set a trigger attribute to scale out to 10 instances on weekdays, and scale in to four (4) instances on Saturday and Sunday. If you can predict the load on the application, consider using scheduled autoscaling, which adds and removes instances to meet anticipated peaks in demand.

To learn more, see [Use Azure Monitor autoscale](../../best-practices/auto-scaling.md#use-azure-monitor-autoscale).

## Next steps

> [!div class="nextstepaction"]
> [Performance testing](./performance-test.md)

**Capacity planning:** When performance testing, the business must communicate any fluctuation in expected load. Load can be impacted by world events, such as political, economic, or weather changes; by marketing initiatives, such as sales or promotions; or, by seasonal events, such as holidays. You should test variations of load prior to events, including unexpected ones, to ensure that your application can scale. Additionally, you should ensure that all regions can adequately scale to support total load, should one region fail.
