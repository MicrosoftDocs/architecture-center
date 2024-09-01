[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution allows studios to leverage on-premises capacity to its fullest with the Azure FXT Edge Filer for NAS acceleration. When demand grows beyond on-premises capacity, burst render provides access to tens of thousands of cores using Azure Virtual Machine Scale Sets. An Express Route connection and HPC Cache minimize latency while studios securely manage storage in a single place without replication.

## Architecture

:::image type="content" border="false" source="../media/azure-batch-rendering.svg" alt-text="Diagram that shows HPC media rendering solution architecture." lightbox="../media/azure-batch-rendering.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-batch-rendering.vsdx) of this architecture.*

### Dataflow

1. Optimize access to NAS files and support remote artists with the Azure FXT Edge Filer connecting artists to low-latency storage.
1. Connecting on-premises storage resources to Azure via Azure Express Route providing a secure, private link to additional render cores.
1. Azure HPC Cache provides low-latency access to tens of thousands of compute cores with burst rendering.  Azure SDK support in HPC Cache enables automation for easy infrastructure management and cost efficiencies.
1. A virtual render farm is available in Azure using Virtual Machine Scale Sets that grow as you need it and provides capacity to meet fluctuating demand.

### Components

* [N-Series VMs](https://azure.microsoft.com/pricing/details/virtual-machines/linux): N-series virtual machines are ideal for compute and graphics-intensive workloads, helping customers to fuel innovation through scenarios like high-end remote visualization, deep learning, and predictive analytics.
* [H-Series VMs](https://azure.microsoft.com/pricing/details/virtual-machines/linux): The H-series is a new family specifically designed to handle high performance computing workloads such as financial risk modeling, seismic and reservoir simulation, molecular modeling, and genomic research.
* Effectively manage common workloads with ease while creating and optimizing HPC clusters with Microsoft [Azure CycleCloud](https://azure.microsoft.com/features/azure-cyclecloud).
* [Avere vFXT](https://azure.microsoft.com/services/storage/avere-vfxt): Faster, more accessible data storage for high-performance computing at the edge
* [Azure Batch](https://azure.microsoft.com/services/batch): Cloud-scale job scheduling and compute management

## Scenario details

### Potential use cases

Graphics designers, artists, and animation designers need high performance systems to make sure they deliver the best quality work and can accommodate change requests without waiting hours for the processing to finish. Areas that studios can see the benefits from high performance computing include:

* Animation and modeling.

* 3D Rendering.

* Compositing and color grading.

## Next steps

* [N-Series Virtual Machines Documentation](/azure/virtual-machines/linux/sizes-gpu)
* [H-Series Virtual Machines Documentation](/azure/virtual-machines/linux/sizes-hpc)
* [Azure CycleCloud Documentation](/azure/cyclecloud)
* [Avere vFXT Documentation](/azure/avere-vfxt)
* [Azure Batch Documentation](/azure/batch)
