---
title: Hybrid HPC in Azure
description: Running hybrid HPC workloads in Azure and on-premises
author: Mike Warrington and Ben Hummerstone
ms.date: <publish or update date>
---
# Hybrid HPC in Azure

Introductory paragraph

## Potential use cases

You should consider this solution for the following use cases:

* 

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the components involved in a Hybrid HPC solution using CycleCloud][architecture]

## Architecture

This solution covers ###What does the solution cover###, the data flows through the solution as follows:

1. User submits job to the CycleCloud server
2. CycleCloud server decides where to place the job depending on submission criteria
  - 2a. CycleCloud submits the job to an Azure-based head node
  - 2b. CycleCloud submits the job to an on-premises head node
3. The job is queued for execution
  - 3a. CycleCloud detects a job in the queue and scales the number of execute nodes accordingly
  - 3b. The on-premises head node submits the job when space is available on the cluster
4. CycleCloud monitors the head nodes and job queues to gather usage metrics and determine when the job is completed

### Components

* List of components with links to documentation.

* [Resource Groups][resource-groups] is a logical container for Azure resources.

### Alternatives

* List of alternative options and why you might use them.

### Availability

### Scalability

For other scalability topics please see the  [scalability checklist][] available in the architecure center.

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