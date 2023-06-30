---
title: "High-performance computing (HPC) on Azure"
description: Learn about high-performance computing (HPC) on Azure, which uses many CPU or GPU-based computers to solve complex mathematical tasks.
author: SMBrook
ms.author: sibrook
ms.date: 08/08/2022
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
products: azure
categories: 
  - compute
  - storage
ms.category:
  - compute
  - storage
ms.custom:
  - fcp
---

<!-- cSpell:ignore fullheight neuro milliman hymans netapp gluster tibco cyclecloud hpcpack radioss ansys axioma alces slurm mdcs cntk -->

# High-performance computing (HPC) on Azure

## Introduction to HPC

<!-- markdownlint-disable MD034 -->

> [!VIDEO https://www.youtube.com/embed/rKURT32faJk]

<!-- markdownlint-enable MD034 -->

High-performance computing (HPC), also called "big compute", uses a large number of CPU or GPU-based computers to solve complex mathematical tasks.

Many industries use HPC to solve some of their most difficult problems.  These include workloads such as:

- Genomics
- Oil and gas simulations
- Finance
- Semiconductor design
- Engineering
- Weather modeling

### How is HPC different on the cloud?

One of the primary differences between an on-premises HPC system and one in the cloud is the ability for resources to dynamically be added and removed as they're needed.  Dynamic scaling removes compute capacity as a bottleneck and instead allow customers to right size their infrastructure for the requirements of their jobs.

The following articles provide more detail about this dynamic scaling capability.

- [Big Compute Architecture Style](../guide/architecture-styles/big-compute.yml)
- [Autoscaling best practices](../best-practices/auto-scaling.md)

## Implementation checklist

As you're looking to implement your own HPC solution on Azure, ensure you're reviewed the following topics:

> [!div class="checklist"]
>
> - Choose the appropriate [architecture](#infrastructure) based on your requirements
> - Know which [compute](#compute) options is right for your workload
> - Identify the right [storage](#storage) solution that meets your needs
> - Decide how you're going to [manage](#management) all your resources
> - Optimize your [application](#hpc-applications) for the cloud
> - [Secure](#security) your Infrastructure

## Infrastructure

There are many infrastructure components that are necessary to build an HPC system. Compute, storage, and networking provide the underlying components, no matter how you choose to manage your HPC workloads.

### Example HPC architectures

There are many different ways to design and implement your HPC architecture on Azure.  HPC applications can scale to thousands of compute cores, extend on-premises clusters, or run as a 100% cloud-native solution.

The following scenarios outline a few of the common ways HPC solutions are built.

<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <article class="card has-outline-hover is-relative is-fullheight">
            <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                <a class="is-undecorated is-full-height is-block"
                 href="/azure/architecture/example-scenario/apps/hpc-saas">
                 <img role="presentation" alt="Diagram shows example HPC architecture for computer-aided engineering services on Azure." src="../example-scenario/apps/media/architecture-hpc-saas.png">
                </a>
             </figure>
             <div class="card-content has-text-overflow-ellipsis">
                 <div class="has-padding-bottom-none">
                     <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Computer-aided engineering services on Azure</h3>
                 </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Provide a software-as-a-service (SaaS) platform for computer-aided engineering (CAE) on Azure.</p>
                    </div>
                </div>
            </article>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <article class="card has-outline-hover is-relative is-fullheight">
            <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
               <a class="is-undecorated is-full-height is-block"
                 href="/azure/architecture/example-scenario/infrastructure/hpc-cfd">
                 <img role="presentation" alt="Diagram shows example HPC architecture for computational fluid dynamics simulations on Azure." src="../example-scenario/infrastructure/media/architecture-hpc-cfd.svg">
                </a>
                </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Computational fluid dynamics (CFD) simulations on Azure</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Execute computational fluid dynamics (CFD) simulations on Azure.</p>
                    </div>
                </div>
            </article>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <article class="card has-outline-hover is-relative is-fullheight">
          <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
              <a class="is-undecorated is-full-height is-block"
              href="/azure/architecture/example-scenario/infrastructure/video-rendering">
                 <img role="presentation" alt="Diagram shows example HPC architecture for 3D video rendering on Azure." src="../example-scenario/infrastructure/media/architecture-video-rendering.svg">
            </a>
          </figure>
          <div class="card-content has-text-overflow-ellipsis">
             <div class="has-padding-bottom-none">
                   <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">3D video rendering on Azure</h3>
             </div>
             <div class="is-size-7 has-margin-top-small has-line-height-reset">
                   <p>Run native HPC workloads in Azure using the Azure Batch service</p>
             </div>
          </div>
       </article>
    </li>
</ul>

### Compute

Azure offers a range of sizes that are optimized for both CPU & GPU intensive workloads.

#### CPU-based virtual machines

- [Linux VMs](/azure/virtual-machines/linux/sizes-hpc)
- [Windows VMs](/azure/virtual-machines/windows/sizes-hpc)

#### GPU-enabled virtual machines

N-series VMs feature NVIDIA GPUs designed for compute-intensive or graphics-intensive applications including artificial intelligence (AI) learning and visualization.

- [Linux VMs](/azure/virtual-machines/linux/sizes-gpu)
- [Windows VMs](/azure/virtual-machines/windows/sizes-gpu)

### Storage

Large-scale Batch and HPC workloads have demands for data storage and access that exceed the capabilities of traditional cloud file systems. There are many solutions that manage both the speed and capacity needs of HPC applications on Azure:

- [Avere vFXT](https://azure.microsoft.com/services/storage/avere-vfxt) for faster, more accessible data storage for high-performance computing at the edge
- [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [GlusterFS](https://azure.microsoft.com/resources/implement-glusterfs-on-azure)
- [Storage Optimized Virtual Machines](/azure/virtual-machines/windows/sizes-storage)
- [Blob, table, and queue storage](/azure/storage/common/storage-introduction)
- [Azure SMB File storage](/azure/storage/files/storage-files-introduction)

For more information comparing Lustre, GlusterFS, and BeeGFS on Azure, review the [Parallel Files Systems on Azure](/archive/blogs/azurecat/azurecat-ebook-parallel-virtual-file-systems-on-microsoft-azure) e-book and the [Lustre on Azure](https://techcommunity.microsoft.com/t5/azurecat/lustre-on-azure/ba-p/1052536) blog.

### Networking

H16r, H16mr, A8, and A9 VMs can connect to a high throughput back-end RDMA network. This network can improve the performance of tightly coupled parallel applications running under Microsoft Message Passing Interface better known as MPI or Intel MPI.

- [RDMA Capable Instances](/azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances)
- [Virtual Network](/azure/virtual-network/virtual-networks-overview)
- [ExpressRoute](/azure/expressroute/expressroute-introduction)

## Management

### Do-it-yourself

Building an HPC system from scratch on Azure offers a significant amount of flexibility, but it is often very maintenance intensive.

1. Set up your own cluster environment in Azure virtual machines or [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).
2. Use Azure Resource Manager templates to deploy leading [workload managers](#workload-managers), infrastructure, and [applications](#hpc-applications).
3. Choose HPC and GPU [VM sizes](#compute) that include specialized hardware and network connections for MPI or GPU workloads.
4. Add [high-performance storage](#storage) for I/O-intensive workloads.

### Hybrid and cloud Bursting

If you have an existing on-premises HPC system that you'd like to connect to Azure, there are several resources to help get you started.

First, review the [Options for connecting an on-premises network to Azure](../reference-architectures/hybrid-networking/index.yml) article in the documentation.  From there, you can find additional information on these connectivity options:

<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/reference-architectures/hybrid-networking/vpn">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram showing how to connect an on-premises network to Azure using a VPN gateway." src="/azure/architecture/reference-architectures/hybrid-networking/images/vpn.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Connect an on-premises network to Azure using a VPN gateway</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>This reference architecture shows how to extend an on-premises network to Azure, using a site-to-site virtual private network (VPN).</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/reference-architectures/hybrid-networking/expressroute">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram showing how to connect an on-premises network to Azure using ExpressRoute." src="/azure/architecture/reference-architectures/hybrid-networking/images/expressroute.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Connect an on-premises network to Azure using ExpressRoute</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram showing how to connect an on-premises network to Azure using ExpressRoute with VPN failover." src="/azure/architecture/reference-architectures/hybrid-networking/images/expressroute-vpn-failover.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Connect an on-premises network to Azure using ExpressRoute with VPN failover</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Implement a highly available and secure site-to-site network architecture that spans an Azure virtual network and an on-premises network connected using ExpressRoute with VPN gateway failover.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>

Once network connectivity is securely established, you can start using cloud compute resources on-demand with the bursting capabilities of your existing [workload manager](#workload-managers).

### Marketplace solutions

There are many workload managers offered in the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace).

- [RogueWave CentOS-based HPC](https://azuremarketplace.microsoft.com/marketplace/apps/openlogic.centos-hpc)
- [SUSE Linux Enterprise Server for HPC](https://www.suse.com/products/server/hpc/)
- [TIBCO DataSynapse GridServer](https://azuremarketplace.microsoft.com/marketplace/apps/tibco-software.tibco_datasynapse_gridserver)
- [Azure Data Science VM for Windows and Linux](/azure/machine-learning/data-science-virtual-machine/overview)
- [D3View](https://azuremarketplace.microsoft.com/marketplace/apps/xfinityinc.d3view-v5?tab=Overview)
- [UberCloud](https://azuremarketplace.microsoft.com/marketplace/apps/ubercloud.ansys_182_test)

### Azure Batch

[Azure Batch](/azure/batch/batch-technical-overview) is a platform service for running large-scale parallel and HPC applications efficiently in the cloud. Azure Batch schedules compute-intensive work to run on a managed pool of virtual machines, and can automatically scale compute resources to meet the needs of your jobs.

SaaS providers or developers can use the Batch SDKs and tools to integrate HPC applications or container workloads with Azure, stage data to Azure, and build job execution pipelines.

In Azure Batch all the services are running on the Cloud, the image below shows how the architecture looks with Azure Batch, having the scalability and job schedule configurations running in the Cloud while the results and reports can be sent to your on-premises environment.

![Diagram shows example HPC architecture for Azure Batch.](images/cloud-native-job-scheduler-azure-batch.jpg)


### Azure CycleCloud

[Azure CycleCloud](/azure/cyclecloud) Provides the simplest way to manage HPC workloads using any scheduler (like Slurm, Grid Engine, HPC Pack, HTCondor, LSF, PBS Pro, or Symphony), on Azure

CycleCloud allows you to:

- Deploy full clusters and other resources, including scheduler, compute VMs, storage, networking, and cache
- Orchestrate job, data, and cloud workflows
- Give admins full control over which users can run jobs, as well as where and at what cost
- Customize and optimize clusters through advanced policy and governance features, including cost controls, Active Directory integration, monitoring, and reporting
- Use your current job scheduler and applications without modification
- Take advantage of built-in autoscaling and battle-tested reference architectures for a wide range of HPC workloads and industries

##### Hybrid / cloud bursting model
In this Hybrid example diagram, we can see clearly how these services are distributed between the cloud and the on-premises environment. Having the opportunity to run jobs in both workloads.
![Diagram shows example HPC architecture for CycleCloud on Azure in a Hybrid.](images/industry-standard-high-performance-computing-job-scheduler-hybrid-cloudbursting-model-azure-cyclecloud.jpg)

##### Cloud native model
The cloud native model example diagram below, shows how the workload in the cloud will handle everything while still conserving the connection to the on-premises environment.

![Diagram shows example HPC architecture for CycleCloud on Azure in Cloud native model
.](images/industry-standard-high-performance-computing-job-scheduler-cloud-native-model-azure-cyclecloud.jpg)

### Comparison chart

|Feature              |Azure Batch             |Azure CycleCloud     |
|---------------|------------------------|------------------------|
|Scheduler |Batch APIs and tools and command-line scripts in the Azure portal (Cloud Native).  |Use standard HPC schedulers such as Slurm, PBS Pro, LSF, Grid Engine, and HTCondor, or extend CycleCloud autoscaling plugins to work with your own scheduler.|
|Compute Resources |Software as a Service Nodes – Platform as a Service |Platform as a Service Software – Platform as a Service |
|Monitor Tools |Azure Monitor |Azure Monitor, Grafana |
|Customization |Custom image pools, Third Party images, Batch API access. |Use the comprehensive RESTful API to customize and extend functionality, deploy your own scheduler, and support into existing workload managers |
|Integration | Synapse Pipelines, Azure Data Factory, Azure CLI |Built-In CLI for Windows and Linux |
|User type |Developers |Classic HPC administrators and users |
|Work Type |Batch, Workflows |Tightly coupled (Message Passing Interface/MPI).|
|Windows Support |Yes |Varies, depending on scheduler choice |

### Workload managers

The following are examples of cluster and workload managers that can run in Azure infrastructure. Create stand-alone clusters in Azure VMs or burst to Azure VMs from an on-premises cluster.

- Alces Flight Compute
- [TIBCO DataSynapse GridServer](https://azure.microsoft.com/blog/tibco-datasynapse-comes-to-the-azure-marketplace)
- [Bright Cluster Manager](http://www.brightcomputing.com/technology-partners/microsoft)
- [IBM Spectrum Symphony and Symphony LSF](https://azure.microsoft.com/blog/ibm-and-microsoft-azure-support-spectrum-symphony-and-spectrum-lsf)
- [Altair PBS Works](https://www.altair.com/pbs-works)
- [Rescale](https://www.rescale.com/azure)
- [Altair Grid Engine](https://www.altair.com/grid-engine)
- [Microsoft HPC Pack](/powershell/high-performance-computing/overview?view=hpc19-ps&preserve-view=true)
  - [HPC Pack for Windows](/azure/virtual-machines/windows/hpcpack-cluster-options)
  - [HPC Pack for Linux](/azure/virtual-machines/linux/hpcpack-cluster-options)

#### Containers

Containers can also be used to manage some HPC workloads.  Services like the Azure Kubernetes Service (AKS) makes it simple to deploy a managed Kubernetes cluster in Azure.

- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes)
- [Container Registry](/azure/container-registry/container-registry-intro)

## Cost management

Managing your HPC cost on Azure can be done through a few different ways.  Ensure you've reviewed the [Azure purchasing options](https://azure.microsoft.com/pricing/purchase-options) to find the method that works best for your organization.

## Security

For an overview of security best practices on Azure, review the [Azure Security Documentation](/azure/security/azure-security).

In addition to the network configurations available in the [Cloud Bursting](#hybrid-and-cloud-bursting) section, you can implement a hub/spoke configuration to isolate your compute resources:

<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/reference-architectures/hybrid-networking/hub-spoke">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram showing how to implement a hub-spoke network topology in Azure." src="/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Implement a hub-spoke network topology in Azure</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>The hub is a virtual network (VNet) in Azure that acts as a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/reference-architectures/hybrid-networking/#hub-spoke-network-topology">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram showing how to implement a hub-spoke network topology with shared services in Azure." src="/azure/architecture/reference-architectures/hybrid-networking/images/shared-services.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Implement a hub-spoke network topology with shared services in Azure</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>This reference architecture builds on the hub-spoke reference architecture to include shared services in the hub that can be consumed by all spokes.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>

## HPC applications

Run custom or commercial HPC applications in Azure. Several examples in this section are benchmarked to scale efficiently with additional VMs or compute cores. Visit the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace) for ready-to-deploy solutions.

> [!NOTE]
> Check with the vendor of any commercial application for licensing or other restrictions for running in the cloud. Not all vendors offer pay-as-you-go licensing. You might need a licensing server in the cloud for your solution, or connect to an on-premises license server.

### Engineering applications

- [Altair RADIOSS](https://azure.microsoft.com/blog/availability-of-altair-radioss-rdma-on-microsoft-azure)
- [ANSYS CFD](https://azure.microsoft.com/blog/ansys-cfd-and-microsoft-azure-perform-the-best-hpc-scalability-in-the-cloud)
- [MATLAB Distributed Computing Server](/azure/virtual-machines/windows/matlab-mdcs-cluster)
- [StarCCM+](/archive/blogs/azurecat/run-star-ccm-in-an-azure-hpc-cluster)

### Graphics and rendering

- [Autodesk Maya, 3ds Max, and Arnold](/azure/batch/batch-rendering-service) on Azure Batch

### AI and deep learning

- [Microsoft Cognitive Toolkit](/cognitive-toolkit/cntk-on-azure)
- [Batch Shipyard recipes for deep learning](https://github.com/Azure/batch-shipyard/tree/master/recipes#deeplearning)

### MPI providers

- [Microsoft MPI](/message-passing-interface/microsoft-mpi)

## Remote visualization

Run GPU-powered virtual machines in Azure in the same region as the HPC output for the lowest latency, access, and to visualize remotely through Azure Virtual Desktop, Citrix, or VMware Horizon.

- [GPU-optimized virtual machine sizes](/azure/virtual-machines/sizes-gpu)
- [Configure GPU acceleration for Azure Virtual Desktop](/azure/virtual-desktop/configure-vm-gpu)

<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/example-scenario/infrastructure/linux-vdi-citrix">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram of an architecture for Linux virtual desktops with Citrix." src="../example-scenario/infrastructure/media/azure-citrix-sample-diagram.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Linux virtual desktops with Citrix</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Build a VDI environment for Linux desktops using Citrix on Azure.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-third has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="/azure/architecture/example-scenario/wvd/windows-virtual-desktop">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <figure class="image has-margin-right-none has-margin-left-none has-margin-top-none has-margin-bottom-none">
                        <img role="presentation" alt="Diagram of an architecture for Azure Virtual Desktops on Azure." src="../example-scenario/wvd/images/windows-virtual-desktop.png">
                    </figure>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Windows desktops using Azure Virtual Desktop on Azure</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Build a VDI environment for Windows desktops using Azure Virtual Desktop on Azure.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>

## Performance benchmarks

- [Compute benchmarks](/azure/virtual-machines/windows/compute-benchmark-scores)

## Customer stories

There are many customers who have seen great success by using Azure for their HPC workloads.  You can find a few of these customer case studies below:

- [AXA Global P&C](https://customers.microsoft.com/story/axa-global-p-and-c)
- [Axioma](https://customers.microsoft.com/story/772585-axioma-banking-and-capital-markets-azure-united-states)
- [d3View](https://customers.microsoft.com/story/big-data-solution-provider-adopts-new-cloud-gains-thou)
- [EFS](https://customers.microsoft.com/story/efs-professionalservices-azure)
- [Hymans Robertson](https://customers.microsoft.com/story/hymans-robertson)
- [MetLife](https://enterprise.microsoft.com/customer-story/industries/insurance/metlife)
- [Microsoft Research](https://customers.microsoft.com/doclink/fast-lmm-and-windows-azure-put-genetics-research-on-fa)
- [Milliman](https://customers.microsoft.com/story/actuarial-firm-works-to-transform-insurance-industry-w)
- [Mitsubishi UFJ Securities International](https://customers.microsoft.com/story/powering-risk-compute-grids-in-the-cloud)
- [NeuroInitiative](https://customers.microsoft.com/story/neuroinitiative-health-provider-azure)
- [Schlumberger](https://azure.microsoft.com/blog/big-compute-for-large-engineering-simulations)
- [Towers Watson](https://customers.microsoft.com/story/insurance-tech-provider-delivers-disruptive-solutions)

## Other important information

- Ensure your [vCPU quota](/azure/virtual-machines/linux/quotas) has been increased before attempting to run large-scale workloads.

## Next steps

For the latest announcements, see the following resources:

- [Microsoft HPC and Batch team blog](/archive/blogs/windowshpc)
- Visit the [Azure blog](https://azure.microsoft.com/blog/tag/hpc).

### Microsoft Batch Examples

These tutorials will provide you with details on running applications on Microsoft Batch:

- [Get started developing with Batch](/azure/batch/quick-run-dotnet)
- [Use Azure Batch code samples](https://github.com/Azure/azure-batch-samples)
- [Use low-priority VMs with Batch](/azure/batch/batch-low-pri-vms)
- [Run containerized HPC workloads with Batch Shipyard](https://github.com/Azure/batch-shipyard)
- [Run on-demand Spark jobs on Batch](https://github.com/Azure/aztk)
- [Use compute-intensive VMs in Batch pools](/azure/batch/batch-pool-compute-intensive-sizes)

## Related resources

- [Big compute architecture style](../guide/architecture-styles/big-compute.yml)
- [Hybrid HPC in Azure with HPC Pack](../solution-ideas/articles/hybrid-hpc-in-azure-with-hpc-pack.yml)
- [HPC cluster deployed in the cloud](../solution-ideas/articles/hpc-cluster.yml)
