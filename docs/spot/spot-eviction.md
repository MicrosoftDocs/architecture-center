---
title: Azure Virtual Machine Spot Eviction
description: Learn about Spot Eviction and how to architect for and handle eviction notices. 
author: ju-shim
ms.author: jushiman
ms.date: 05/04/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - power-platform
  - power-apps
categories:
  - integration
  - web
  - devops
---

# Azure Virtual Machine Spot Eviction

## Potential use cases

Something something something:

- One.
- Two.
- Tree.

## Architecture

Add a diagram here.

![Diagram of an Azure Virtual Desktop service architecture](images/windows-virtual-desktop.png)
_Download a [Visio file](https://arch-center.azureedge.net/wvdatscale.vsdx) of this architecture._

### Dataflow

This diagram shows a typical architectural setup for handling Azure Spot Eviction notices.

- Explain.
- Explain.
- Explain.

For more information about Azure Spot, see [Azure Spot](./windows-virtual-desktop-fslogix.yml)

### Components

Something.

#### Components Microsoft manages

Something.

#### Components you manage

Something.

## Personal and pooled desktops

Something.

## Windows servicing

Something.

## Relationships between key logical components

Something.

## Considerations

Something.

### Azure Spot Eviction limitations

Something. Update the following too.

For more information about Azure subscription limitations, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

### VM sizing

[Virtual machine sizing guidelines](/windows-server/remote/remote-desktop-services/virtual-machine-recs) lists the maximum suggested number of users per virtual central processing unit (vCPU) and minimum VM configurations for different workloads. This data helps estimate the VMs you need in your host pool.

Use simulation tools to test deployments with both stress tests and real-life usage simulations. Make sure the system is responsive and resilient enough to meet user needs, and remember to vary the load sizes when testing.

## Deploy this scenario

Use the [ARM templates](https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates) to automate the deployment of your Azure Virtual Desktop environment. These ARM templates support only Azure Resource Manager's Azure Virtual Desktop objects. These ARM templates don't support Azure Virtual Desktop (classic).

## Pricing

Something.

## Next steps

- One.
- Two.
- Three.

## Related resources

- One.
- Two.
