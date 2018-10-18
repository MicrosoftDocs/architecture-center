---
title: Hybrid HPC in Azure with HPC Pack 
description: Get a hybrid high performance computing solution built with Windows Server technology. Use Azure HPC Pack to create a hybrid HPC environment.
author: adamboeglin
ms.date: 10/18/2018
---
# Hybrid HPC in Azure with HPC Pack 
Microsoft HPC Pack is a free high performance computing (HPC) solution built on Microsoft Azure and Windows Server technologies. HPC Pack combines a comprehensive set of deployment, administration, job scheduling, and monitoring tools for your Windows and Linux HPC cluster environment, providing a flexible platform for developing and running HPC applications on premises and in Azure.
This solution shows the process for using HPC Pack to create a hybrid (on-premises and Azure) HPC environment.

## Architecture
<img src="media/hybrid-hpc-in-azure-with-hpc-pack.svg" alt='architecture diagram' />

## Data Flow
1. Log into on-premises head node
1. Add Azure compute nodes to the cluster
1. Start the compute nodes
1. Submit jobs to the cluster
1. HPC Pack sends jobs to on-premises and Azure nodes based upon the node group selected
1. Monitor job progress
1. Stop the compute nodes or configure auto-scaling

## Components
* [Virtual Machines](href="http://azure.microsoft.com/services/virtual-machines/): Create Linux and Windows virtual machines in seconds.
* [Microsoft HPC Pack](https://www.visualstudio.com/vs/): Free high performance computing (HPC) solution built on Microsoft Azure and Windows Server technologies.

## Next Steps
* [Create a Windows virtual machine with the Azure portal](https://docs.microsoft.com/azure/virtual-machines/windows/quick-create-portal)
* [Set up a hybrid high performance computing (HPC) cluster with Microsoft HPC Pack and on-demand Azure compute nodes](https://docs.microsoft.com/azure/cloud-services/cloud-services-setup-hybrid-hpcpack-cluster)