---
title: High Performance Computing (HPC) on Azure
description: A guide to building running HPC workloads on Azure
author: adamboeglin
ms.date: 2/4/2019
layout: LandingPage
ms.topic: landing-page
---

# High Performance Computing (HPC) on Azure

## Introduction to HPC

> [!VIDEO https://www.youtube.com/embed/rKURT32faJk]

High Performance Computing (HPC), also called "Big Compute", uses a large number of CPU or GPU-based computers to solve complex mathematical tasks.

Many industries use HPC to solve some of their most difficult problems.  These include workloads such as:

- Genomics
- Oil & Gas Simulations
- Finance
- Semiconductor Design
- Engineering
- Weather modeling

### How is HPC different on the cloud

One of the primary differences between an on-premise HPC system and one in the cloud is the ability for resources to dynamically be added and removed as they're needed.  Dynamic scaling removes compute capacity as a bottleneck and instead allow customers to right size their infrastructure for the requirements of their jobs.

The following articles provide more detail about this dynamic scaling capability.

- [Big Compute Architecture Style](/azure/architecture/guide/architecture-styles/big-compute?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Autoscaling best practices](/azure/architecture/best-practices/auto-scaling?toc=/azure/architecture/topics/high-performance-computing/toc.json)

## Implementation Checklist

As you're looking to implement your own HPC solution on Azure, ensure you're reviewed the following topics:

> [!div class="checklist"]
> - Choose the appropriate [architecture](#infrastructure) based on your requirements
> - Know which [Compute](#compute) options is right for your workload
> - Identify the right [storage](#storage) solution that meets your needs
> - Decide how you're going to [manage](#management) all your resources
> - Optimize your [application](#hpc-applications) for the cloud
> - [Secure](#security) your Infrastructure

## Infrastructure

There are a number of infrastructure components necessary to build an HPC system.  Compute, Storage, and Networking provide the underlying components, no matter how you choose to manage your HPC workloads.

### Example HPC Architectures

There are a number of different ways to design and implement your HPC architecture on Azure.  HPC applications can scale to thousands of compute cores, extend on-premises clusters, or run as a 100% cloud native solution.

The following scenarios outline a few of the common ways HPC solutions are built.

<ul class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/example-scenario/apps/hpc-saas?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../example-scenario/apps/media/architecture-hpc-saas.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Computer-aided engineering services on Azure</h3>
                        <p>Provide a software-as-a-service (SaaS) platform for computer-aided engineering (CAE) on Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/example-scenario/infrastructure/hpc-cfd?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../example-scenario/infrastructure/media/architecture-hpc-cfd.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Computational fluid dynamics (CFD) simulations on Azure</h3>
                        <p>Execute computational fluid dynamics (CFD) simulations on Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/example-scenario/infrastructure/video-rendering?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../example-scenario/infrastructure/media/architecture-video-rendering.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>3D video rendering on Azure</h3>
                        <p>Run native HPC workloads in Azure using the Azure Batch service.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

### Compute

Azure offers a range of sizes that are optimized for both CPU & GPU intensive workloads.

#### CPU-based virtual machines
- [Linux VMs](https://docs.microsoft.com/azure/virtual-machines/linux/sizes-hpc?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Windows VM's](https://docs.microsoft.com/azure/virtual-machines/windows/sizes-hpc?toc=/azure/architecture/topics/high-performance-computing/toc.json) VMs
  
#### GPU-enabled virtual machines

N-series VMs feature NVIDIA GPUs designed for compute-intensive or graphics-intensive applications including artificial intelligence (AI) learning and visualization.

- [Linux VMs](https://docs.microsoft.com/azure/virtual-machines/linux/sizes-gpu?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Windows VMs](https://docs.microsoft.com/azure/virtual-machines/windows/sizes-gpu?toc=/azure/architecture/topics/high-performance-computing/toc.json)

### Storage

Large-scale Batch and HPC workloads have demands for data storage and access that exceed the capabilities of traditional cloud file systems.  There are a number of solutions to manage both the speed and capacity needs of HPC applications on Azure

- [Parallel virtual file systems on Azure](https://azure.microsoft.com/resources/parallel-virtual-file-systems-on-microsoft-azure/)
- [Avere](http://www.averesystems.com/about-us/about-avere) high-performance cloud storage solutions
- [BeeGFS](https://azure.microsoft.com/resources/implement-glusterfs-on-azure/en-us/)
- [Storage Optimized Virtual Machines](https://docs.microsoft.com/azure/virtual-machines/windows/sizes-storage?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Blob, table, and queue storage](https://docs.microsoft.com/azure/storage/storage-introduction?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Azure SMB File storage](https://docs.microsoft.com/azure/storage/storage-files-introduction?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Intel Cloud Edition Lustre](https://azuremarketplace.microsoft.com/marketplace/apps/intel.intel-cloud-edition-gs)

For more information comparing Lustre, GlusterFS, and BeeGFS on Azure, review the [Parallel Files Systems on Azure eBook](https://blogs.msdn.microsoft.com/azurecat/2018/06/11/azurecat-ebook-parallel-virtual-file-systems-on-microsoft-azure/)

### Networking

H16r, H16mr, A8, and A9 VMs can connect to a high throughput back-end RDMA network. This network can improve the performance of tightly coupled parallel applications running under Microsoft MPI or Intel MPI.

- [RDMA Capable Instances](https://docs.microsoft.com/azure/virtual-machines/windows/sizes-hpc#rdma-capable-instances?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Virtual Network](https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [ExpressRoute](https://docs.microsoft.com/azure/expressroute/expressroute-introduction?toc=/azure/architecture/topics/high-performance-computing/toc.json)

## Management

### Do-it-yourself

Building an HPC system from scratch on Azure offers a significant amount of flexibility, but is often very maintenance intensive.  

1. Set up your own cluster environment in Azure virtual machines or [virtual machine scale sets](https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview?toc=/azure/architecture/topics/high-performance-computing/toc.json).
2. Use Azure Resource Manager templates to deploy leading [workload managers](#workload-managers), infrastructure, and [applications](#hpc-applications).
3. Choose [HPC and GPU VM sizes](#hpc-and-gpu-sizes) that include specialized hardware and network connections for MPI or GPU workloads.
4. Add [high performance storage](#hpc-storage) for I/O-intensive workloads.

### Hybrid & Cloud Bursting

If you have an existing on-premise HPC system that you'd like to connect to Azure, there are a number of resources to help get you started.

First, review the [Options for connecting an on-premises network to Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking?toc=/azure/architecture/topics/high-performance-computing/toc.json) article in the documentation.  From there, you may want information on these connectivity options:

<ul class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/vpn?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/vpn.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Connect an on-premises network to Azure using a VPN gateway</h3>
                        <p>This reference architecture shows how to extend an on-premises network to Azure, using a site-to-site virtual private network (VPN).</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/vpn?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/vpn.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Connect an on-premises network to Azure using a VPN gateway</h3>
                        <p>This reference architecture shows how to extend an on-premises network to Azure, using a site-to-site virtual private network (VPN).</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/expressroute?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/expressroute.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Connect an on-premises network to Azure using ExpressRoute</h3>
                        <p>ExpressRoute connections use a private, dedicated connection through a third-party connectivity provider. The private connection extends your on-premises network into Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/expressroute-vpn-failover?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/expressroute-vpn-failover.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Connect an on-premises network to Azure using ExpressRoute with VPN failover</h3>
                        <p>Implement a highly available and secure site-to-site network architecture that spans an Azure virtual network and an on-premises network connected using ExpressRoute with VPN gateway failover.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

Once network connectivity is securely established, you can start using cloud compute resources on-demand with the bursting capabilities of your existing [workload manager](#workload-manager).

### Marketplace solutions

There are a number of workload managers offered in the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/).

- [RogueWave CentOS-based HPC](https://azuremarketplace.microsoft.com/marketplace/apps/RogueWave.CentOSbased73HPC?tab=Overview)
- [SUSE Linux Enterprise Server for HPC](https://azure.microsoft.com/marketplace/partners/suse/suselinuxenterpriseserver12optimizedforhighperformancecompute/)
- [TIBCO Grid Server Engine](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/tibco-software.gridserverlinuxengine?tab=Overview)
- [Azure Data Science VM for Windows and Linux](https://docs.microsoft.com/azure/machine-learning/machine-learning-data-science-virtual-machine-overview?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [D3View](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/xfinityinc.d3view-v5?tab=Overview)
- [UberCloud](https://azure.microsoft.com/search/marketplace/?q=ubercloud)

### Azure Batch

[Azure Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview?toc=/azure/architecture/topics/high-performance-computing/toc.json) is a platform service for running large-scale parallel and high-performance computing (HPC) applications efficiently in the cloud. Azure Batch schedules compute-intensive work to run on a managed pool of virtual machines, and can automatically scale compute resources to meet the needs of your jobs.

SaaS providers or developers can use the Batch SDKs and tools to integrate HPC applications or container workloads with Azure, stage data to Azure, and build job execution pipelines.

### Azure CycleCloud

[Azure CycleCloud](https://azure.microsoft.com/en-us/features/azure-cyclecloud/) Provides the simplest way to manage HPC workloads using any scheduler (like Slurm, Grid Engine, HPC Pack, HTCondor, LSF, PBS Pro, or Symphony), on Azure

CycleCloud allows you to:

- Deploy full clusters and other resources, including scheduler, compute VMs, storage, networking, and cache
- Orchestrate job, data, and cloud workflows
- Give admins full control over which users can run jobs, as well as where and at what cost
- Customize and optimize clusters through advanced policy and governance features, including cost controls, Active Directory integration, monitoring, and reporting
- Use your current job scheduler and applications without modification
- Take advantage of built-in autoscaling and battle-tested reference architectures for a wide range of HPC workloads and industries

### Workload managers

The following are examples of cluster and workload managers that can run in Azure infrastructure. Create stand-alone clusters in Azure VMs or burst to Azure VMs from an on-premises cluster.

- [Alces Flight Compute](https://azuremarketplace.microsoft.com/marketplace/apps/alces-flight-limited.alces-flight-compute-solo?tab=Overview)
- [TIBCO DataSynapse GridServer](https://azure.microsoft.com/blog/tibco-datasynapse-comes-to-the-azure-marketplace/) 
- [Bright Cluster Manager](http://www.brightcomputing.com/technology-partners/microsoft)
- [IBM Spectrum Symphony and Symphony LSF](https://azure.microsoft.com/blog/ibm-and-microsoft-azure-support-spectrum-symphony-and-spectrum-lsf/)
- [PBS Pro](http://pbspro.org)
- [Altair](http://www.altair.com/)
- [Rescale](https://www.rescale.com/azure/)
- [Microsoft HPC Pack](https://technet.microsoft.com/library/mt744885.aspx)
  - [HPC Pack for Windows](https://docs.microsoft.com/azure/virtual-machines/windows/hpcpack-cluster-options.md?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json)
  - [HPC Pack for Linux](https://docs.microsoft.com/azure/virtual-machines/linux/hpcpack-cluster-options.md?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

#### Containers

Containers can also be used to manage some HPC workloads.  Services like the Azure Kubernetes Service (AKS) makes it simple to deploy a managed Kubernetes cluster in Azure.

- [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Container Registry](https://docs.microsoft.com/azure/container-registry/container-registry-intro?toc=/azure/architecture/topics/high-performance-computing/toc.json)

## Cost Management

Managing your HPC cost on Azure can be done through a few different ways.  Ensure you've reviewed the [Azure purchasing options](https://azure.microsoft.com/en-us/pricing/purchase-options/) to find the method that works best for your organization.

[Low priority VMs](https://docs.microsoft.com/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-use-low-priority?toc=/azure/architecture/topics/high-performance-computing/toc.json) allow you to take advantage of our unutilized capacity at a significant cost savings.

## Security

For an overview of security best practices on Azure, review the [Azure Security Documentation](https://docs.microsoft.com/azure/security/azure-security?toc=/azure/architecture/topics/high-performance-computing/toc.json).  

In addition to the network configurations available in the [Cloud Bursting](#) section, you may want to implement a hub/spoke configuration to isolate your compute resources:

<ul class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/hub-spoke.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Implement a hub-spoke network topology in Azure</h3>
                        <p>The hub is a virtual network (VNet) in Azure that acts as a central point of connectivity to your on-premises network. The spokes are VNets that peer with the hub, and can be used to isolate workloads.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/reference-architectures/hybrid-networking/shared-services?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="/azure/architecture/reference-architectures/hybrid-networking/images/shared-services.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Implement a hub-spoke network topology with shared services in Azure</h3>
                        <p>This reference architecture builds on the hub-spoke reference architecture to include shared services in the hub that can be consumed by all spokes.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## HPC applications

Run custom or commercial HPC applications in Azure. Several examples in this section are benchmarked to scale efficiently with additional VMs or compute cores. Visit the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace) for ready-to-deploy solutions.

> [!NOTE]
> Check with the vendor of any commercial application for licensing or other restrictions for running in the cloud. Not all vendors offer pay-as-you-go licensing. You might need a licensing server in the cloud for your solution, or connect to an on-premises license server.

### Engineering applications

- [Altair RADIOSS](https://azure.microsoft.com/blog/availability-of-altair-radioss-rdma-on-microsoft-azure/)
- [ANSYS CFD](https://azure.microsoft.com/blog/ansys-cfd-and-microsoft-azure-perform-the-best-hpc-scalability-in-the-cloud/)
- [MATLAB Distributed Computing Server](https://docs.microsoft.com/azure/virtual-machines/windows/matlab-mdcs-cluster?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [StarCCM+](https://blogs.msdn.microsoft.com/azurecat/2017/07/07/run-star-ccm-in-an-azure-hpc-cluster/)
- [OpenFOAM](https://simulation.azure.com/casestudies/Team-182-ABB-UC-Final.pdf)

### Graphics and rendering

- [Autodesk Maya, 3ds Max, and Arnold](https://docs.microsoft.com/azure/batch/batch-rendering-service?toc=/azure/architecture/topics/high-performance-computing/toc.json) on Azure Batch

### AI and deep learning

- [Microsoft Cognitive Toolkit](https://docs.microsoft.com/cognitive-toolkit/cntk-on-azure)
- [Deep Learning VM](https://azuremarketplace.microsoft.com/marketplace/apps/microsoft-ads.dsvm-deep-learning)
- [Batch Shipyard recipes for deep learning](https://github.com/Azure/batch-shipyard/tree/master/recipes#deeplearning)

### MPI Providers

- [Microsoft MPI](https://docs.microsoft.com/message-passing-interface/microsoft-mpi)

## Remote Visualization

<ul class="panelContent cardsC">
<li style="display: flex; flex-direction: column;">
    <a href="/azure/architecture/example-scenario/infrastructure/linux-vdi-citrix?toc=/azure/architecture/topics/high-performance-computing/toc.json" style="display: flex; flex-direction: column; flex: 1 0 auto;">
        <div class="cardSize" style="flex: 1 0 auto; display: flex;">
            <div class="cardPadding" style="display: flex;">
                <div class="card">
                    <div class="cardImageOuter">
                        <div class="cardImage">
                            <img src="../../example-scenario/infrastructure/media/azure-citrix-sample-diagram.png" height="140px" />
                        </div>
                    </div>
                    <div class="cardText">
                        <h3>Linux virtual desktops with Citrix</h3>
                        <p>Build a VDI environment for Linux Desktops using Citrix on Azure.</p>
                    </div>
                </div>
            </div>
        </div>
    </a>
</li>
</ul>

## Performance Benchmarks

- [Compute Benchmarks](https://docs.microsoft.com/azure/virtual-machines/windows/compute-benchmark-scores?toc=/azure/architecture/topics/high-performance-computing/toc.json)

## Customer stories

There are a number of customers who have seen great success by using Azure for their HPC workloads.  You can find a few of these customer case studies below:

- [ANEO](https://customers.microsoft.com/story/it-provider-finds-highly-scalable-cloud-based-hpc-redu) 
- [AXA Global P&C](https://customers.microsoft.com/story/axa-global-p-and-c)
- [Axioma](https://customers.microsoft.com/story/axioma-delivers-fintechs-first-born-in-the-cloud-multi-asset-class-enterprise-risk-solution)
- [d3View](https://customers.microsoft.com/story/big-data-solution-provider-adopts-new-cloud-gains-thou)
- [EFS](https://customers.microsoft.com/story/efs-professionalservices-azure)
- [Hymans Robertson](https://customers.microsoft.com/story/hymans-robertson)
- [MetLife](https://enterprise.microsoft.com/en-us/customer-story/industries/insurance/metlife/)
- [Microsoft Research](https://customers.microsoft.com/doclink/fast-lmm-and-windows-azure-put-genetics-research-on-fa)
- [Milliman](https://customers.microsoft.com/story/actuarial-firm-works-to-transform-insurance-industry-w)
- [Mitsubishi UFJ Securities International](https://customers.microsoft.com/story/powering-risk-compute-grids-in-the-cloud)
- [NeuroInitiative](https://customers.microsoft.com/en-us/story/neuroinitiative-health-provider-azure)
- [Schlumberger](https://azure.microsoft.com/blog/big-compute-for-large-engineering-simulations)
- [Towers Watson](https://customers.microsoft.com/story/insurance-tech-provider-delivers-disruptive-solutions)

## Other Important Information

- Ensure your [vCPU quota](https://docs.microsoft.com/azure/virtual-machines/linux/quotas?toc=/azure/architecture/topics/high-performance-computing/toc.json) has been increased before attempting to run large-scale workloads.

## Next steps

For the latest announcements, see:
  - [Microsoft HPC and Batch team blog](http://blogs.technet.com/b/windowshpc/)
  - [Azure blog](https://azure.microsoft.com/blog/tag/hpc/).
- [Set up a Linux RDMA cluster to run MPI applications](https://docs.microsoft.com/azure/virtual-machines/linux/classic/rdma-cluster.md?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Set up a Windows RDMA cluster with Microsoft HPC Pack to run MPI applications](https://docs.microsoft.com/azure/virtual-machines/windows/classic/hpcpack-rdma-cluster.md?toc=/azure/architecture/topics/high-performance-computing/toc.json)

### Microsoft Batch Examples

These tutorials will provide you with details on running applications on Microsoft Batch

- [Get started developing with Batch](https://docs.microsoft.com/azure/batch/quick-run-dotnet?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Use Azure Batch code samples](https://github.com/Azure/azure-batch-samples)
- [Use low-priority VMs with Batch](https://docs.microsoft.com/azure/batch/batch-low-pri-vms?toc=/azure/architecture/topics/high-performance-computing/toc.json)
- [Run containerized HPC workloads with Batch Shipyard](https://github.com/Azure/batch-shipyard)
- [Run parallel R workloads on Batch](https://github.com/Azure/doAzureParallel)
- [Run on-demand Spark jobs on Batch](https://github.com/Azure/aztk)
- [Use compute-intensive VMs in Batch pools](https://docs.microsoft.com/azure/batch/batch-pool-compute-intensive-sizes?toc=/azure/architecture/topics/high-performance-computing/toc.json)