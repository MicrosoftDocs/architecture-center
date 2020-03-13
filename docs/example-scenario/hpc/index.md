---
title: Run reservoir simulation software on Azure
titleSuffix: Azure Example Scenarios
description: Run OPM Flow reservoir simulation software and OPM ResInsight visualization software on Azure.
author: edprice
ms.date: 03/02/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Run reservoir simulation software on Azure

*Reservoir simulation* uses data-intensive computer models to predict complex flows of fluids such as oil, water, and gas beneath the earth's surface. This example sets up reservoir simulation software on Azure using an infrastructure for high-performance computing (HPC). Azure makes it possible to run this type of workload with maximum performance, scalability, and cost efficiency.

The architecture in this example is designed for a commonly used open source oil and gas software package—OPM Flow software from the Open Porous Media (OPM) initiative. The software runs on Azure HPC virtual machines (VMs) that deliver performance at levels near or better than current on-premises infrastructures.

This example also uses VMs to [model and visualize results][model], sparing the expense of a high-end visualization workstation.

OPM applications benefit from HPC hardware and a shared storage location for the input and output files. Using this example architecture, users connect to a VM that serves as the head node for the simulation software. The application runs through a job scheduler. Working in the application, users prepare a model to be analyzed and then submit a job to the HPC resources through the job scheduler.

This example creates a basic HPC cluster with a Linux head node running the reservoir simulation software, along with the PBS Pro 19.1 job-scheduling software. For this small cluster, the head node mounts a 4-terabyte (TB) NFS space as the HPC file share, but depending on your model and IO requirements, you can use other storage options. 

When the calculations are completed, the results are returned to a VM running Windows and OPM ResInsight, an open-source visualization tool. Users connect to the VM running ResInsight via remote desktop protocol (RDP).

## Relevant use cases

- Do 3D reservoir modeling and visualization of seismic data.

- Test INTERSECT, a high-resolution reservoir simulator from Schlumberger. (A [sample INTERSECT implementation][intersect] is included on GitHub.)

- Test Nexus by Landmark-Halliburton using a similar setup on Azure.

## Architecture

![Architecture diagram][./architecture-hpc-reservoir-simulation.png]

This diagram offers a high-level overview of the architecture used in the example. The workflow is as follows:

1. Users sign in to the head node via SSH to access the compute resources.

2. PBS Pro 19.1 runs on the head node and schedules the jobs on the compute nodes. The head node is an Azure HPC VM, such as a Standard\_HC44rs or Standard\_HC60rs, running the CentOS 7.6 Linux operating system.

3. OPM Flow runs on the compute nodes. These VMs are deployed as a [virtual machine scale set][vmss]—a group of identical VMs that scale to meet the demands of the compute tasks.

4. A [premium disk][disk] is connected to the head node and set up as an NFS server for the compute nodes and the visualizations.

5. Users can access a Windows desktop via RDP on the visualization VM, where OPM ResInsight runs on a Standard-NV6 VM and displays a 3D image of results.

## Considerations

To test OPM on Azure, the example setup installs the Norne case, an open benchmark case of a real Norwegian Sea oil field. To run the test case, you must:

- Use Azure Key Vault for storing keys and secrets, a requirement of the GitHub setup scripts.

- Install the Linear Algebra PACKage (LAPACK) libraries on all the compute nodes. The GitHub installation scripts include this step.

- Install HP RGS on the user's local computer as a receiver for the visualizations. In this example, a user connects to the viznode VM to run ResInsight and view the Norne case.

### Job scheduler

Compute-intensive workloads benefit from HPC orchestration software that can deploy and manage the HPC compute and storage infrastructure. The example architecture includes two ways to deploy compute—the [azurehpc][azurehpc] framework or [Azure CycleCloud][azure-cyclecloud].

Azure CycleCloud is a tool for creating, managing, operating, and optimizing HPC and big compute clusters on Azure. You can use it to dynamically provision Azure HPC clusters and orchestrate data and jobs for hybrid and cloud workflows. In addition, Azure CycleCloud supports several workload managers for managing your HPC workloads on Azure, such as Grid Engine, HPC Pack, HTCondor, LSF, PBS Pro, Slurm, and Symphony.

### Network

This example workload deploys the VMs within different subnets. For additional security, you can define [network security groups][nsg] for each subnet. For example, you can set security rules that allow or deny inbound network traffic to—or outbound network traffic from—the various nodes.

If you don't need this level of security, separate subnets aren't required for this implementation.

### Storage 

[Data storage](https://docs.microsoft.com/azure/architecture/topics/high-performance-computing#storage) and access needs vary widely, depending on the scale of a workload, and Azure supports several approaches for managing the speed and capacity of HPC applications. The following approaches are commonly used the oil and gas industry. Choose the solution best suited to your unique IO and capacity requirements.

- **Low-scale workload.** Consider running NFS on the head node, as in this example, using a storage-optimized [Lsv2-series VM][lsv2] with large ephemeral disks, or use D-series VMs with Azure Premium Storage, depending on your requirements. This solution suits workloads with 500 cores or less, throughput of up to 1.5 gibibytes per second (GiB/s), and up to 19 TB RAM and 100 TB storage.

- **Medium to large-scale read-intensive workloads.** Consider using [Avere vFXT for Azure][avere-vfxt] (6 to 24 nodes). This solution works for workloads of up to 50,000 cores and require up to 2 GiB/s for writes and up to 14 GiB/s for reads, with a cache of up to 192 TB and a file server of up to 2 petabytes (PB).

- **Balanced or write-intensive medium-scale workloads.** Consider using [Azure NetApps Files][azure-naf] for workloads of up to 4,000 cores with a throughput of up to 6.5 GiB/s and storage of up to 100 TB/volume, with a maximize file size of 12 TB.

- **Large-scale workloads.** Use an orchestrated parallel file service, such as Lustre or BeeGFS. This approach works for up to 50,000 cores with read/write rates of up to 50 GiB/s and 500 TB storage. For even larger clusters, a bare-metal approach may be more cost-effective. For example, Cray ClusterStor is a managed HPC storage solution with the flexibility to support larger elastic clusters on the fly. The azurehpc repository includes [example Azure HPC scripts][azurehpc].

## Deployment

Get an example implementation of this [OPM FLOW architecture on GitHub][opm-flow].

## Next steps

- Read the [HPC: Oil and Gas in Azure][blog] blog.
- Get an overview of [Avere vFXT for Azure][avere-vfxt].
- Review the [Azure Storage performance and scalability checklist][checklist].
- Explore an example workload for [computer-aided engineering (CAE) on Azure][cae].
- Learn about [HPC on Azure][hpc]

<!-- links -->
[architecture]: ./architecture-hpc-reservoir-simulation.png
[azurehpc]: https://github.com/Azure/azurehpc/tree/master/examples
[azure-cyclecloud]: /azure/cyclecloud/overview
[avere-vfxt]: /azure/avere-vfxt/avere-vfxt-overview
[azure-naf]: /azure/azure-netapp-files/azure-netapp-files-introduction
[blog]: https://techcommunity.microsoft.com/t5/azurecat/high-performance-computing-hpc-oil-and-gas-in-azure/ba-p/824926
[cae]: /azure/architecture/example-scenario/apps/hpc-saas
[checklist]: /azure/storage/common/storage-performance-checklist
[data-storage]: /azure/architecture/topics/high-performance-computing#storage
[disk]: /azure/virtual-machines/windows/disks-types#premium-ssd
[hpc]: https://azure.microsoft.com/solutions/high-performance-computing/
[intersect]: https://github.com/Azure/azurehpc/tree/master/tutorials/oil_and_gas_intersect
[nsg]: /azure/virtual-network/security-overview
[lsv2]: /azure/virtual-machines/windows/sizes-storage
[model]: https://techcommunity.microsoft.com/t5/azurecat/remote-visualization-in-azure/ba-p/745184
[opm-flow]: https://github.com/Azure/azurehpc/tree/master/tutorials/oil_and_gas_opm
[vmss]: /azure/virtual-machine-scale-sets/overview
