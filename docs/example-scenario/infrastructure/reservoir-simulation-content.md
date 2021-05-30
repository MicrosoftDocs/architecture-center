
<!-- cSpell:ignore azurehpc Norne LAPACK Slurm -->



*Reservoir simulation* uses data-intensive computer models to predict complex flows of fluids such as oil, water, and gas beneath the earth's surface. This example sets up reservoir simulation software on an Azure high-performance computing (HPC) infrastructure. Azure makes it possible to run this type of workload with maximum performance, scalability, and cost efficiency.

The architecture in this example supports OPM Flow, a popular open-source oil and gas reservoir simulation package from the Open Porous Media (OPM) initiative. The OPM Flow software runs on Azure HPC virtual machines (VMs) that deliver performance near or better than current on-premises infrastructures.

Users connect to a Linux head node VM to submit models to the HPC resources through PBS Pro 19.1 job-scheduling software. The HPC resources run OPM Flow and send calculated results to a file share. In this example, the file share is a 4-terabyte (TB) network file system (NFS) space on the head node VM. Depending on your model and your input and output (I/O) requirements, you can use other [storage](#storage) options.

A Windows Azure VM running OPM ResInsight, an open-source visualization tool, accesses the file share to [model and visualize][model] the calculated results. Users can connect to the VM via remote desktop protocol (RDP) to view the visualizations.

Using an Azure VM spares the expense of a high-end visualization workstation. The OPM applications benefit from HPC hardware and a shared storage location for the input and output files.

## Relevant use cases

- Do 3D reservoir modeling and visualization of seismic data.

- Test INTERSECT, a high-resolution reservoir simulator from Schlumberger. You can see a [sample INTERSECT implementation][intersect] on GitHub.

- Test Nexus by Landmark-Halliburton using a similar setup on Azure.

## Architecture

![Architecture diagram][architecture]

This diagram offers a high-level overview of the architecture used in the example. The workflow is as follows:

1. Users sign in to the head node via SSH to prepare their models for the compute resources.

2. PBS Pro 19.1 runs on the head node and schedules the jobs on the compute nodes.

3. OPM Flow runs on the compute nodes. The compute VMs are deployed as a [virtual machine scale set][vmss], a group of identical VMs that scale to meet the demands of the compute tasks.

4. OPM Flow sends calculated results to a file share on the head node. A [premium disk][disk] is connected to the head node and set up as an NFS server for the compute nodes and the visualization VM.

5. OPM ResInsight running on a Standard-NV6 Windows VM displays 3D visualizations of results. Users can access the visualization VM through RDP.

## Considerations

This example uses the HB-series of [high-performance VMs][vm-size]. The HB-series is optimized for applications driven by memory bandwidth, such as computational fluid dynamics (CFD), and the Standard_HB120rs_v2 VM is the latest in the series. For Intel-based hardware, the [Standard_HC44rs][hc-series] VM is an option.

To test this OPM Flow architecture on Azure, the [GitHub example implementation][opm-flow] installs the Norne case, an open-benchmark case of a real Norwegian Sea oil field. To run this test case, you must:

- Use Azure Key Vault for storing keys and secrets, a requirement of the GitHub setup scripts.

- Install the Linear Algebra PACKage (LAPACK) libraries on all the compute nodes. The GitHub installation scripts include this step.

- Install HP Remote Graphics Software (RGS) on any computer you want to use as a receiver for the visualizations. In this example, a user connects to the visualization VM to run ResInsight and view the Norne case.

### Job scheduler

Compute-intensive workloads benefit from HPC orchestration software that can deploy and manage the HPC compute and storage infrastructure. The example architecture includes two ways to deploy compute: the [azurehpc][azurehpc] framework or [Azure CycleCloud][azure-cyclecloud].

Azure CycleCloud is a tool for creating, managing, operating, and optimizing HPC and big compute clusters on Azure. You can use it to dynamically provision Azure HPC clusters and orchestrate data and jobs for hybrid and cloud workflows. Azure CycleCloud also supports several workload managers for your HPC workloads on Azure, such as Grid Engine, HPC Pack, HTCondor, LSF, PBS Pro, Slurm, and Symphony.

### Network

This example workload deploys the VMs within different subnets. For additional security, you can define [network security groups][nsg] for each subnet. For example, you can set security rules that allow or deny network traffic to or from the various nodes. If you don't need this level of security, you don't need separate subnets for this implementation.

### Storage

[Data storage](../../topics/high-performance-computing.md#storage) and access needs vary widely, depending on workload scale. Azure supports several approaches for managing the speed and capacity of HPC applications. The [azurehpc][azurehpc] GitHub repository includes example Azure HPC scripts.

The following approaches are common in the oil and gas industry. Choose the solution best suited to your unique I/O and capacity requirements.

- For **low-scale workloads** like the current example, consider running NFS on the head node, using a storage-optimized [Lsv2-series VM][lsv2] with large ephemeral disks, or D-series VMs with Azure Premium Storage, depending on your requirements. This solution suits workloads with 500 cores or fewer, throughput of up to 1.5 gigabytes per second (GiB/s), and up to 19 TB RAM and 100 TB storage.

- **Medium to large-scale read-intensive workloads:** Consider using [Avere vFXT for Azure][avere-vfxt] (6 to 24 nodes). This solution works for workloads of up to 50,000 cores, throughput up to 2 GiB/s for writes and up to 14 GiB/s for reads, a cache of up to 192 TB, and a file server of up to 2 petabytes (PB).

- **Balanced or write-intensive medium-scale workloads:** Consider using [Azure NetApps Files][azure-naf] for workloads of up to 4,000 cores, with a throughput up to 6.5 GiB/s, storage up to 100 TB/volume, and a maximize file size of 12 TB.

- **Large-scale workloads:** Use an orchestrated parallel file service, such as Lustre or BeeGFS. This approach works for up to 50,000 cores, with read/write rates up to 50 GiB/s, and 500 TB storage. For even larger clusters, a bare-metal approach may be more cost-effective. For example, Cray ClusterStor is a managed HPC storage solution with the flexibility to support larger elastic clusters on the fly.

## Deployment

Get an [example implementation of this OPM Flow architecture][opm-flow] on GitHub.

## Next steps

- Read the [HPC: Oil and Gas in Azure][blog] blog.
- Get an overview of [Avere vFXT for Azure][avere-vfxt].
- Review the [Azure Storage performance and scalability checklist][checklist].
- Explore an example workload for [computer-aided engineering (CAE) on Azure][cae].
- Learn about [HPC on Azure][hpc].

<!-- links -->

[architecture]: ./media/architecture-hpc-reservoir-simulation.png
[azurehpc]: https://github.com/Azure/azurehpc/tree/master/examples
[azure-cyclecloud]: /azure/cyclecloud/overview
[avere-vfxt]: /azure/avere-vfxt/avere-vfxt-overview
[azure-naf]: /azure/azure-netapp-files/azure-netapp-files-introduction
[blog]: https://techcommunity.microsoft.com/t5/azurecat/high-performance-computing-hpc-oil-and-gas-in-azure/ba-p/824926
[cae]: ../apps/hpc-saas.yml
[checklist]: /azure/storage/common/storage-performance-checklist
[disk]: /azure/virtual-machines/windows/disks-types#premium-ssd
[hc-series]: /azure/virtual-machines/hc-series
[hpc]: https://azure.microsoft.com/solutions/high-performance-computing
[intersect]: https://github.com/Azure/azurehpc/tree/master/tutorials/oil_and_gas_intersect
[nsg]: /azure/virtual-network/security-overview
[lsv2]: /azure/virtual-machines/windows/sizes-storage
[model]: https://techcommunity.microsoft.com/t5/azurecat/remote-visualization-in-azure/ba-p/745184
[opm-flow]: https://github.com/Azure/azurehpc/tree/master/tutorials/oil_and_gas_opm
[vmss]: /azure/virtual-machine-scale-sets/overview
[vm-size]: /azure/virtual-machines/sizes-hpc