---
title: HPC System and Big Compute Solutions 
description: Explore Big Compute solutions with Azure Batch. Use HPC cloud systems for cloud-native application and batch processing.
author: adamboeglin
ms.date: 10/29/2018
---
# HPC System and Big Compute Solutions 
Big compute and high performance computing (HPC) workloads are normally compute intensive and can be run in parallel, taking advantage of the scale and flexibility of the cloud. The workloads are often run asynchronously using batch processing, with compute resources required to run the work and job scheduling required to specify the work. Examples of Big Compute and HPC workloads include financial risk Monte Carlo simulations, image rendering, media transcoding, file processing, and engineering or scientific simulations.
This solution implements a cloud-native application with Azure Batch, which provides compute resource allocation and management, application installation, resource auto-scaling, and job scheduling as a platform service. Batch also offers higher level workload accelerators specifically for running R in parallel, AI training, and rendering workloads.
This solution is built on the Azure managed servicesVirtual Machines, Storage, and Batch. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution.

## Architecture
<img src="media/big-compute-with-azure-batch.svg" alt='architecture diagram' />

## Data Flow
1. Upload input files and the applications to your Azure Storage account.
1. Create a Batch pool of compute nodes, a job to run the workload on the pool, and the tasks in the job.
1. Batch downloads input files and applications.
1. Batch monitors task execution.
1. Batch uploads task output.
1. Download output files.

## Components
* [Storage](href="http://azure.microsoft.com/services/storage/): Massively scalable object storage for unstructured data.
* [Batch](href="http://azure.microsoft.com/services/batch/): Cloud-scale job scheduling and compute management.

## Next Steps
* [Quickstart: Upload, download, and list blobs using the Azure portal](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-portal)
* [Quickstart: Run your first Batch job in the Azure portal](https://docs.microsoft.com/azure/batch/quick-create-portal)