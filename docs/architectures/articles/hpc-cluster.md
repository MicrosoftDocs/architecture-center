---
title: HPC cluster deployed in the cloud
description: High performance computing (HPC) applications can scale to thousands of compute cores, extend on-premises big compute, or run as a 100% cloud native solution. This HPC solution including the head node, compute nodes, and storage nodes, runs in Azure with no hardware infrastructure to maintain.
author: adamboeglin
ms.date: 10/29/2018
---
# HPC cluster deployed in the cloud
High performance computing (HPC) applications can scale to thousands of compute cores, extend on-premises big compute, or run as a 100% cloud native solution. This HPC solution including the head node, compute nodes, and storage nodes, runs in Azure with no hardware infrastructure to maintain.
This solution is built on the Azure managed services: Virtual Machine Scale Sets, Virtual Network and Storage. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/hpc-cluster.svg" alt='architecture diagram' />

## Components
* [HPC head node](href="http://azure.microsoft.com/services/virtual-machines/): 
* [Virtual Machine Scale Sets](href="http://azure.microsoft.com/services/virtual-machine-scale-sets/): 
* [Virtual Network](http://azure.microsoft.com/services/virtual-network/) provides IP connectivity between the head node, compute nodes, and storage nodes.
* Azure [Storage](http://azure.microsoft.com/services/storage/) blobs store the disks backing the virtual machines and provides long-term storage of unstructured data and executable files used by the HPC application.
* [Azure Resource Manager templates](https://docs.microsoft.com/api/Redirecthref="http://azure.microsoft.com/documentation/articles/virtual-machines-windows-cli-deploy-templates/): Resource Manager templates or script files are used to deploy your application to the HPC environment.