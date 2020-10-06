---
title: Hybrid HPC in Azure with HPC Pack
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Get a hybrid high performance computing solution built with Windows Server technology. Use Azure HPC Pack to create a hybrid HPC environment.
ms.custom: acom-architecture, hybrid hpc, hpc pack, azure hpc pack, interactive-diagram, hybrid-infrastructure, hpc, 'https://azure.microsoft.com/solutions/architecture/hybrid-hpc-in-azure-with-hpc-pack/'
ms.service: architecture-center
ms.category:
  - compute
  - hybrid
  - management-and-governance
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/hybrid-hpc-in-azure-with-hpc-pack.png
---

# Hybrid HPC in Azure with HPC Pack

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Microsoft HPC Pack is a free high performance computing (HPC) solution built on Microsoft Azure and Windows Server technologies. HPC Pack combines a comprehensive set of deployment, administration, job scheduling, and monitoring tools for your Windows and Linux HPC cluster environment, providing a flexible platform for developing and running HPC applications on premises and in Azure.

This solution shows the process for using HPC Pack to create a hybrid (on-premises and Azure) HPC environment.

The links to the right provide documentation on deploying and managing the Azure products listed in the solution architecture above.

[Documentation Home Page](https://technet.microsoft.com/library/cc514029\(v=ws.11\).aspx)

[HPC Pack Azure Deployment Options](/azure/virtual-machines/windows/hpcpack-cluster-options)

## Architecture

![Architecture Diagram](../media/hybrid-hpc-in-azure-with-hpc-pack.png)
*Download an [SVG](../media/hybrid-hpc-in-azure-with-hpc-pack.svg) of this architecture.*

## Data Flow

1. Log into on-premises head node
1. Add Azure compute nodes to the cluster
1. Start the compute nodes
1. Submit jobs to the cluster
1. HPC Pack sends jobs to on-premises and Azure nodes based upon the node group selected
1. Monitor job progress
1. Stop the compute nodes or configure auto-scaling

## Components

* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines): Create Linux and Windows virtual machines in seconds.
* [Microsoft HPC Pack](https://www.visualstudio.com/vs): Free high performance computing (HPC) solution built on Microsoft Azure and Windows Server technologies.

## Next steps

* [Create a Windows virtual machine with the Azure portal](/azure/virtual-machines/windows/quick-create-portal)
* [Set up a hybrid high performance computing (HPC) cluster with Microsoft HPC Pack and on-demand Azure compute nodes](/azure/cloud-services/cloud-services-setup-hybrid-hpcpack-cluster)