---
title: Big Compute Architecture Style
description: Understand the benefits, challenges, and best practices of the Big Compute architecture style on Azure.
author: claytonsiemens77
ms.author: pnp
ms.date: 07/26/2022
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: fcp
---

# Big compute architecture style

The term *big compute* describes large-scale workloads that can require hundreds or thousands of cores. Use cases that require big compute include image rendering, fluid dynamics, financial risk modeling, oil exploration, drug design, and engineering stress analysis.

:::image type="complex" border="false" source="./images/big-compute-logical.png" alt-text="Diagram that illustrates a big compute architecture style." lightbox="./images/big-compute-logical.png":::
   In the diagram, an arrow that represents a job queue points from a client to a scheduler or coordinator. The job queue arrow then branches from the scheduler to one box that contains parallel tasks and to another box that contains tightly coupled tasks.
:::image-end:::

The following characteristics are common in big compute applications:

- The work can be split into discrete tasks that can run across many cores simultaneously.

- Each task is finite. It takes input, processes that input, and produces an output. The entire application can run for a few minutes to several days, but it runs for a finite amount of time. A common pattern is to provision a large number of cores in a burst and then reduce the number of cores to zero when the application completes.

- The application doesn't need to continuously run. However, the system must handle node failures or application crashes.

- For some applications, tasks are independent and can run in parallel. In other cases, tasks are tightly coupled, which means that they must interact or exchange intermediate results. In this case, consider using high-speed networking technologies such as InfiniBand and remote direct memory access (RDMA).

- Depending on your workload, you might use compute-intensive virtual machine (VM) sizes like H16r, H16mr, and A9.

## When to use this architecture

- Computationally intensive operations such as simulations and number crunching

- Simulations that are computationally intensive and must be split across CPUs in hundreds or thousands of computers

- Simulations that require too much memory for one computer and must be split across multiple computers

- Long-running computations that take too long to complete on a single computer

- Smaller computations that must run hundreds or thousands of times, such as Monte Carlo simulations

## Benefits

- High performance with [*embarrassingly parallel*][embarrassingly-parallel] processing

- The ability to use hundreds or thousands of computer cores to solve large problems faster

- Access to specialized high-performance hardware that uses dedicated high-speed InfiniBand networks

- The ability to provision and remove VMs as needed

## Challenges

- Managing the VM infrastructure

- Managing the volume of number crunching

- Provisioning thousands of cores in a timely manner

- For tightly coupled tasks, adding more cores can have diminishing returns. You might need to experiment to find the optimum number of cores.

## Big compute by using Azure Batch

[Azure Batch][batch] is a managed service for running large-scale, high-performance computing (HPC) applications.

Use Batch to configure a VM pool and upload the applications and data files. The Batch service provisions the VMs, assigns tasks to the VMs, runs the tasks, and monitors the progress. Batch can automatically scale out the VMs in response to the workload. Batch also provides job scheduling.

:::image type="complex" border="false" source="./images/big-compute-batch.png" alt-text="Diagram of a big compute architecture that uses Batch." lightbox="./images/big-compute-batch.png":::
   In the diagram, a dotted line surrounds icons that represent the VM pool. A double-sided arrow connects the VM pool with an icon that represents Batch. Another double-sided arrow connects the VM pool with an icon that represents storage.
:::image-end:::

## Big compute that runs on VMs

You can use [Microsoft HPC Pack][hpc-pack] to administer a cluster of VMs and schedule and monitor HPC jobs. If you use this approach, you must provision and manage the VMs and network infrastructure. Consider this approach if you have existing HPC workloads and want to move some or all of them to Azure. You can move the entire HPC cluster to Azure, or you can keep your HPC cluster on-premises and use Azure for burst capacity. For more information, see [HPC on Azure][batch-hpc-solutions].

### HPC Pack deployed to Azure

In this scenario, the HPC cluster is created entirely within Azure.

:::image type="complex" border="false" source="./images/big-compute-iaas.png" alt-text="Diagram that shows HPC Pack deployed to Azure." lightbox="./images/big-compute-iaas.png":::
   In this diagram, a box represents a virtual network. The virtual network contains icons that represent cluster nodes, an RDMA network, and the cluster head node. A double-sided arrow connects the virtual network box to storage outside of the virtual network.
:::image-end:::

The head node provides management and job scheduling services to the cluster. For tightly coupled tasks, use an RDMA network that provides high-bandwidth, low-latency communication between VMs. For more information, see [Overview of Microsoft HPC Pack 2019][deploy-hpc-azure].

### Burst an HPC cluster to Azure

In this scenario, you run HPC Pack on-premises and use Azure VMs for burst capacity. The cluster head node is on-premises. Azure ExpressRoute or Azure VPN Gateway connects the on-premises network to the Azure virtual network.

:::image type="complex" border="false" source="./images/big-compute-hybrid.png" alt-text="Diagram that shows a hybrid big compute cluster." lightbox="./images/big-compute-hybrid.png":::
   The diagram contains two boxes. One box represents the on-premises environment. It contains icons that represent cluster nodes and the cluster head node. The other box represents a virtual network. It contains cluster nodes. Double-sided arrows that represent Expressroute or VPN Gateway connect the on-premises box and the virtual network box. Another double-sided arrow connects the virtual network box to storage outside of the virtual network.
:::image-end:::

## Related resources

- [Choose an Azure compute service for your application](../technology-choices/compute-decision-tree.md)
- [HPC on Azure](../../topics/high-performance-computing.md)

<!-- links -->

[batch]: /azure/batch
[batch-hpc-solutions]: ../../topics/high-performance-computing.md
[deploy-hpc-azure]: /powershell/high-performance-computing/overview
[embarrassingly-parallel]: https://en.wikipedia.org/wiki/Embarrassingly_parallel
[hpc-pack]: /powershell/high-performance-computing/overview
