---
title: Overview of the scalability pillar 
description: Describes the scalability pillar
author: david-stanford
ms.date: 10/21/2019
ms.topic: overview
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Designing scalable Azure applications

*Scalability* is the ability of a system to handle increased load and is one of the [pillars of the Azure architecture framework](../index.md). Scalability tasks during the architecting phase include:

- **Partition workloads.** Design parts of the process to be discrete and decomposable. Minimize the size of each part. This allows the component parts to be distributed in a way that maximizes use of each compute unit. It also makes it easier to scale the application by adding instances of specific resources. For complex domains, consider adopting a [microservices architecture](../../guide/architecture-styles/microservices.md).
- **Design for scaling.** Scaling allows applications to react to variable load by increasing and decreasing the number of instances of roles, queues, and other services. However, the application must be designed with this in mind. For example, the application and the services it uses must be stateless to allow requests to be routed to any instance. Having stateless services also means that adding or removing an instance does not adversely impact current users.
- **Plan for growth with scale units.** For each resource, know the upper scaling limits, and use sharding or decomposition to go beyond those limits. Design the application so that it's easily scaled by adding one or more scale units. Determine the scale units for the system in terms of well-defined sets of resources. This makes applying scale-out operations easier and less prone to negative impact caused by a lack of resources in some part of the overall system. For example, adding *X* number of front-end VMs might require *Y* number of additional queues and *Z* number of storage accounts to handle the additional workload. So a scale unit could consist of *X* VM instances, *Y* queues, and *Z* storage accounts.
- **Avoid client affinity.** Where possible, ensure that the application doesn't require affinity. Requests can then be routed to any instance, and the number of instances is irrelevant. This also avoids the overhead of storing, retrieving, and maintaining state information for each user.
- **Take advantage of platform autoscaling features.** Use built-in autoscaling features when possible, rather than custom or third-party mechanisms. Use scheduled scaling rules, where possible, to ensure that resources are available without a startup delay, but add reactive autoscaling to the rules, where appropriate, to cope with unexpected changes in demand. For more information, see [Autoscaling guidance](../../best-practices/auto-scaling.md).  

  If your application isn't configured to scale out automatically as load increases, it's possible that your application's services will fail if they become saturated with user requests. For more information, see the following articles:

  - General: [Scalability checklist](../../checklist/scalability.md)
  - Azure App Service: [Scale instance count manually or automatically](/azure/monitoring-and-diagnostics/insights-how-to-scale/)
  - Cloud Services: [How to autoscale a Cloud Service](/azure/cloud-services/cloud-services-how-to-scale/)
  - Virtual machines: [Automatic scaling and virtual machine scale sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview/)

- **Offload intensive CPU/IO tasks as background tasks.** If a request to a service is expected to take a long time to run or may absorb considerable resources, offload the processing to a separate task. Use background jobs to execute these tasks. This strategy enables the service to continue receiving further requests and to remain responsive. For more information, see [Background jobs guidance](../../best-practices/background-jobs.md).
- **Distribute the workload for background tasks.** If there are many background tasks or if the tasks require considerable time or resources, spread the work across multiple compute units. For one possible solution, see the [Competing Consumers pattern](../../patterns/competing-consumers.md).
- **Consider moving toward a *shared-nothing* architecture.** This architecture uses independent, self-sufficient nodes that have no single point of contention (such as shared services or storage). In theory, such a system can scale almost indefinitely. Although a fully shared-nothing approach is usually not practical, it may provide opportunities to design for better scalability. Good examples of moving toward a shared-nothing architecture include partitioning data and avoiding the use of server-side session state and client affinity.
- **Design your application's storage requirements to fall within Azure Storage scalability and performance targets.** Azure Storage is designed to function within predefined scalability and performance targets, so design your application to use storage within those targets. If you exceed these targets, your application will experience storage throttling. To avoid throttling, provision additional storage accounts. If you run up against the storage account limit, provision additional Azure subscriptions and then provision additional storage accounts there. For more information, see [Azure Storage scalability and performance targets](/azure/storage/storage-scalability-targets/).
- **Select the right VM size for your application.** Measure the actual CPU, memory, disk, and I/O of your VMs in production, and verify that the VM size you've selected is sufficient. If not, your application may experience capacity issues as the VMs approach their limits. VM sizes are described in detail in [Sizes for virtual machines in Azure](/azure/virtual-machines/virtual-machines-windows-sizes/?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json).
