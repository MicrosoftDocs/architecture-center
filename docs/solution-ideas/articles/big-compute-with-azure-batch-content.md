[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes a cloud-native application that uses Azure Batch. Batch provides compute resource allocation and management, application installation, resource autoscaling, and more.

## Architecture
[ ![Architecture diagram that shows a cloud-native application that uses Azure Batch.](../media/big-compute-with-azure-batch.svg)](../media/big-compute-with-azure-batch.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/big-compute-with-azure-batch.vsdx) of this architecture.*

### Dataflow

1. Upload input files and the applications to your Azure Storage account.
1. Create a Batch pool of compute nodes, a job to run the workload on the pool, and the tasks in the job.
1. Batch downloads input files and applications.
1. Batch monitors the task execution.
1. Batch uploads the task output.
1. Download the output files.

### Components

* [Azure Storage Accounts](https://azure.microsoft.com/services/storage): Massively scalable object storage for unstructured data.
* [Azure Batch](https://azure.microsoft.com/services/batch): Cloud-scale job scheduling and compute management.
* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines)
* [Azure Blob Storage](https://azure.microsoft.com/services/storage)

## Scenario details

Big compute and high performance computing (HPC) workloads are typically compute-intensive and can be run in parallel, taking advantage of the scale and flexibility of the cloud. The workloads are often run asynchronously using batch processing, with compute resources required to run the work and job scheduling required to specify the work.

This solution implements a cloud-native application with Azure Batch, which provides compute resource allocation and management, application installation, resource autoscaling, and job scheduling as a platform service. Batch also offers higher-level workload accelerators specifically for running R in parallel, AI training, and rendering workloads.

This solution is built on managed services including Virtual Machines, Storage, and Batch. These Azure services run in a high-availability environment, patched and supported, allowing you to focus on your solution.

### Potential use cases

This solution is ideal for the finance, media, entertainment, energy, and environment industries. It's optimized for the following scenarios:

* Financial risk Monte Carlo simulations (finance and portfolio)
* Image rendering
* Media transcoding
* File processing
* Engineering or scientific simulations (energy and environment)

## Next steps

* [Quickstart: Upload, download, and list blobs using the Azure portal](/azure/storage/blobs/storage-quickstart-blobs-portal)
* [Quickstart: Run your first Batch job in the Azure portal](/azure/batch/quick-create-portal)

The following links provide documentation on deploying and managing the Azure products listed in the solution architecture:

* [Batch documentation](/azure/batch)
* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines)
* [Azure Batch](https://azure.microsoft.com/services/batch)
* [Azure Blob Storage](https://azure.microsoft.com/services/storage)

## Related resources

- [High-performance computing (HPC) on Azure](../../topics/high-performance-computing.md)
- [Hybrid HPC in Azure with HPC Pack](../../solution-ideas/articles/hybrid-hpc-in-azure-with-hpc-pack.yml)
- [Batch processing](../../data-guide/big-data/batch-processing.yml)
