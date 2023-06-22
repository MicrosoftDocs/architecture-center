[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article describes how to use Azure HPC Pack to create a hybrid high-performance computing (HPC) environment.

## Architecture

:::image type="content" border="false" source="../media/hybrid-hpc-in-azure-with-hpc-pack.svg" alt-text="Architecture diagram of Azure HPC Pack to create a hybrid high-performance computing (HPC) environment." lightbox="../media/hybrid-hpc-in-azure-with-hpc-pack.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/hybrid-hpc-in-azure-with-hpc-pack.vsdx) of this architecture.*

### Dataflow

1. Log in to an on-premises head node.
1. Add Azure compute nodes to the cluster.
1. Start the compute nodes.
1. Submit jobs to the cluster.
1. HPC Pack sends jobs to on-premises and Azure nodes, based upon the node group selected.
1. Monitor the job progress.
1. Stop the compute nodes or configure autoscaling.

### Components

* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines): Create Linux and Windows virtual machines in seconds.
* [Microsoft HPC Pack](/powershell/high-performance-computing/overview) : Free HPC solution built on Microsoft Azure and Windows Server technologies.

## Scenario details

Microsoft HPC Pack is a free HPC solution built on Microsoft Azure and Windows Server technologies. HPC Pack combines a comprehensive set of deployment, administration, job scheduling, and monitoring tools for your Windows and Linux HPC cluster environment, providing a flexible platform for developing and running HPC applications on premises and in Azure.

### Potential use cases

This solution shows the process for using HPC Pack to create a hybrid (on-premises and Azure) HPC environment.

The following link provides documentation on deploying and managing the Azure products that are included in this solution idea:

* [Documentation Home Page](/powershell/high-performance-computing/overview)

## Next steps

* [Create a Windows virtual machine with the Azure portal](/azure/virtual-machines/windows/quick-create-portal)
* [Set up a hybrid high-performance computing (HPC) cluster with Microsoft HPC Pack and on-demand Azure compute nodes](/azure/cloud-services/cloud-services-setup-hybrid-hpcpack-cluster)

## Related resources

- [High-performance computing (HPC) on Azure](../../topics/high-performance-computing.md)
- [HPC cluster deployed in the cloud](../../solution-ideas/articles/hpc-cluster.yml)
- [HPC system and big-compute solutions](../../solution-ideas/articles/big-compute-with-azure-batch.yml)
