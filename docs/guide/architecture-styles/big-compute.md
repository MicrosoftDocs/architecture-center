# Big compute architecture style

The term big compute describes large scale workloads that require a large number of cores, often numbering in the hundreds or thousands. Scenarios include media transcoding, image rendering, fluid dynamics, financial risk modeling, and engineering stress analysis, among others.

Here are some typical characteristics of big compute applications:

- They consist of individual tasks that run many times. 
- Each task is finite. It takes some input, does some processing, and produces output. The entire application runs for a finite amount of time (minutes to hours). A common pattern is to provision a large number of cores in a burst, and then spin down to zero once the application completes. 
- The application does not need to stay up 24/7. However, the system must handle node failures or application crashes.
- For some applications, tasks are independent and can run in parallel. In other cases, tasks are tightly coupled, meaning they must interact or exchange intermediate results. In that case, consider using high-speed networking technologies such as InfiniBand and remote direct memory access (RDMA). 
- Depending on your workload, you might use compute-intensive VM sizes (H-series or A8-A11 sizes).

## When to use this architecture

Compute intensive operations such as simulation and number crunching. <<RBC: Can we lose the bullet here? When there's only one item you don't really need it. In fact the style guide says to use bullets for two or more things.>>

## Benefits

- High performance with [embarrassingly parallel][embarrassingly-parallel] processing.
- You can provision VMs as needed to do work, and then tear them down. 

## Challenges

- Managing cost.
- Provisioning thousands of cores in a timely manner.

## Big compute using Azure Batch

Azure Batch is a managed service for running large-scale high-performance computing (HPC) applications.
Using Azure Batch, you configure a VM pool, and upload the applications and data files. Then the Batch service provisions the VMs, assign tasks to the VMs, runs the tasks, and monitors the progress. Batch can automatically scale out the VMs in response to the workload. Batch also provides job scheduling.

![](./images/big-compute-batch.png) 

## Big compute running on IaaS <<RBC: Do we need to define IaaS for this audience? I hate to do so in a heading, or to add a throw away sentence below just to define it.>>

You can use [Microsoft HPC Pack][hpc-pack] to administer a cluster of VMs, and schedule and monitor HPC jobs. With this approach, you must provision and manage the VMs and network infrastructure. Consider this approach if you have existing HPC workloads and want to move some or all to Azure. You can move the entire HPC cluster to Azure, or keep your HPC cluster on-premises but use Azure for burst capacity. For more information, see [Batch and HPC solutions for large-scale computing workloads][batch-hpc-solutions].

### HPC Pack deployed to Azure

In this scenario, the HPC cluster is created entirely within Azure.

![](./images/big-compute-iaas.png) 
 
The head node provides management and job scheduling services to the cluster.  For tightly coupled tasks, use an RDMA network that provides very high bandwidth, low latency communication between VMs. For more information see Deploy an HPC Pack 2016 cluster in Azure.<<RBC: Link?>>

### Burst an HPC cluster to Azure

In this scenario, an organization is running HPC Pack on-premises, and uses Azure VMs for burst capacity. The cluster head node is on-premises. ExpressRoute or VPN Gateway connects the on-premises network to the Azure VNet. <<RBC: The image should probably say "on-premises" since that's how it's consistently referred to.

![](./images/big-compute-hybrid.png) 


[batch-hpc-solutions]: /azure/batch/batch-hpc-solutions
[embarrassingly-parallel]: https://en.wikipedia.org/wiki/Embarrassingly_parallel
[hpc-pack]: https://technet.microsoft.com/library/cc514029

 
