---
title: Hybrid HPC in Azure
description: Running hybrid HPC workloads in Azure and on-premises
author: Mike Warrington and Ben Hummerstone
ms.date: <publish or update date>
---
# Hybrid HPC in Azure

Running High Performance Computing on Azure is also referred to as Big Compute, as it moves away from the traditional need for specialist hardware as a major investment.

This sample solution demonstrates how using CycleCloud can be used to orchestrate an IaaS HPC grid running on Azure, and how this could also be used to extend a grid running on-premises to Azure for on demand compute resources.

By using CycleCloud, the manual aspect of creating an IaaS grid in the cloud becomes an efficient process, which can also be used to faciliate a new grid for Disaster Recovery or failover purposes. It also means that organisations can build multiple grids and be confident there is no infrastructure drift taking place between deployments.

## Potential use cases

You should consider this solution for the following use cases:

* If you were previously manually building an HPC IaaS infrastructure or using an ARM template 
* Where an on-premises grid is to be extended into the cloud, taking advantage of Compute Node bursting
* A new grid is to be implemented entirely within Azure

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the components involved in a Hybrid HPC solution using CycleCloud][architecture]

## Architecture

This solution covers the workflow when using a head node running on Azure while a head node is also deployed on premises, the data flows through the solution as follows:

1. User submits job to the CycleCloud server
2. CycleCloud server decides where to place the job depending on submission criteria
  - 2a. CycleCloud submits the job to an Azure-based head node
  - 2b. CycleCloud submits the job to an on-premises head node
3. The job is queued for execution
  - 3a. CycleCloud detects a job in the queue and scales the number of execute nodes accordingly
  - 3b. The on-premises head node submits the job when space is available on the cluster
4. CycleCloud monitors the head nodes and job queues to gather usage metrics and determine when the job is completed

### Components

* [Resource Groups][resource-groups] is a logical container for Azure resources.
* [Virtual Networks][vnet] are used to for both the Head Node and Compute resources
* [Storage][storage] accounts are used for the synchronisation and data retention
* [Virtual Machine Scale Sets][vmss] are utilised by CycleCloud for compute resources

## CycleCloud
* Please use the following recipe to deploy CycleCloud which can then orchestrate your grid, you will be altering an ARM template to deploy CycleCloud:
  - CycleCloud Install: [Install][cycle-recipes]

* The installation consists of the following:
  - Installing the Azure CLI
  - Creating a service principal in your Azure Active Directory
  - Clone the CycleCloud repo
  - Create a resource group and VNET
  - Deploy CycleCloud using a modified ARM template, this will deploy a jumpbox and the CycleCloud server
  

### Alternatives

* If you are looking to transform current applications or develop anew as a Cloud Native app, then [Azure Batch][batch] could be more appropriate. The design principles for Azure Batch can be found [here][batch-arch]

### Availability

### Scalability

* CycleCloud can scale up or down on demand depending on the criteria you supply to .

### Security

For a deeper discussion on [security][] please see the relevant article in the architecure center.

### Resiliency

For a deeper discussion on [resiliency][] please see the relevant article in the architecure center.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic you expect to get:

* [Small][small-pricing]: describe what a small implementation is.
* [Medium][medium-pricing]: describe what a medium implementation is.
* [Large][large-pricing]: describe what a large implementation is.

* 

Your costing for deploying CycleCloud will depend on the VM sizes that are used for the compute and how long these are allocated and running

## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

<!-- links -->
[small-pricing]: https://azure.com/e/
[medium-pricing]: https://azure.com/e/
[large-pricing]: https://azure.com/e/
[architecture]: ./media/hybrid-hpc-ref-arch.png
[resource-groups]: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
[resiliency]: https://docs.microsoft.com/en-us/azure/architecture/resiliency/
[security]:
[scalability]: https://docs.microsoft.com/en-us/azure/architecture/checklist/scalability
[vmss]: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview
[vnet]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
[storage]: https://azure.microsoft.com/en-us/services/storage/
[batch]: https://azure.microsoft.com/en-us/services/batch/
[batch-arch]: https://azure.microsoft.com/en-gb/solutions/architecture/big-compute-with-azure-batch/
[compute-hpc]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-hpc
[compute-gpu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu
[compute-compute]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-compute
[compute-memory]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-memory
[compute-general]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-general
[compute-storage]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-storage
[compute-acu]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/acu
[compute=benchmark]: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/compute-benchmark-scores
[cycle-recipes]: https://github.com/CycleCloudCommunity/cyclecloud_arm



