[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This templated risk analysis solution uses Azure HPC compute and GPU virtual machines (VMs) to expand on-premises TIBCO GridServer compute to Azure using Azure CycleCloud for auto-scaling integration. The job executes both on-premises and in the cloud by using Avere vFXT fast caching and native NFS access to market data available on-premises.

## Architecture

:::image type="content" border="false" source="../media/hpc-risk-analysis.svg" alt-text="Diagram showing a flowchart of risk analysis solution." lightbox="../media/hpc-risk-analysis.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/hpc-risk-analysis.vsdx) of this architecture.*

### Dataflow

1. Operations team uses Azure CycleCloud to configure and launch risk analysis grid in Azure.
1. Azure CycleCloud orchestrates VM creation and software configuration for TIBCO GridServer brokers and HPCCA, in-memory data cache, and Avere vFXT cache.
1. Quant (or scheduled batch) submits a risk analysis template workflow to the on-premises TIBCO GridServer director. Based on job policies and current on-premises use, the workflow is allowed to burst to Azure to expand on-premises grid capacity.
1. The TIBCO HPCCA detects the change in queue depth for each TIBCO broker and requests extra TIBCO engine capacity using the Azure CycleCloud Auto-Scaling API. Azure CycleCloud then autostarts engine nodes in Virtual Machine Scale Sets using the Azure H-series, HB-series, and HC-series VMs to optimize cost and performance and NC-series VMs to provide GPU capacity as required.
1. As soon as engine VMs join the Azure Grid, the brokers begin executing tasks to the new nodes.
1. Risk jobs pull artifacts from on-premises and Azure Blob storage as needed from NFS mounted Avere vFXT and/or via the fast in-memory cache.
1. As each task completes, results are returned to the submitter or driver and data is written back to the in-memory cache, or to NFS storage through the Avere vFXT, as required. Cached data is persisted either on-premises or in Azure Blob storage.
1. As task queues drain, the TIBCO HPCCA uses the Azure CycleCloud Auto-Scaling API to shrink the compute grid and reduce cost.

### Components

* [N-Series Virtual Machines](https://azure.microsoft.com/pricing/details/virtual-machines/linux): N-series virtual machines are ideal for compute and graphics-intensive workloads, helping customers to fuel innovation through scenarios like high-end remote visualization, deep learning, and predictive analytics.
* [H-Series Virtual Machines](https://azure.microsoft.com/pricing/details/virtual-machines/linux): The H-series is a new family specifically designed to handle high performance computing workloads such as financial risk modeling, seismic and reservoir simulation, molecular modeling, and genomic research.
* Effectively manage common workloads with ease while creating and optimizing HPC clusters with Microsoft [Azure CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud).
* [Avere vFXT](https://azure.microsoft.com/services/storage/avere-vfxt): Faster, more accessible data storage for high-performance computing at the edge
* [TIBCO GridServer](https://www.tibco.com/resources/datasheet/tibco-gridserver)&reg; is a market-leading infrastructure platform for grid and elastic computing-and the backbone of businesses operating in the world's most demanding markets. More than a million CPUs spread across a thousand global installations make up enterprise grids that are managed by GridServer.

## Next steps

* [N-Series Virtual Machines Documentation](/azure/virtual-machines/linux/sizes-gpu)
* [H-Series Virtual Machines Documentation](/azure/virtual-machines/linux/sizes-hpc)
* [Azure CycleCloud Documentation](/azure/cyclecloud)
* [Avere vFXT Documentation](/azure/avere-vfxt)
* [TIBCO GridServer Documentation](https://docs.tibco.com/products/tibco-datasynapse-gridserver-6-2-0)

## Related resources

- [High-performance computing (HPC) on Azure](../../topics/high-performance-computing.md)
- [Risk grid computing solution](../../industries/finance/risk-grid-banking-solution-guide.yml)
- [Risk grid computing in banking](../../industries/finance/risk-grid-banking-overview.yml)
- [Loan credit risk and default modeling](../../example-scenario/ai/loan-credit-risk-analyzer-default-modeling)
