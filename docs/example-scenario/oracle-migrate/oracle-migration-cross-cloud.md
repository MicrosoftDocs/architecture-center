---
title: Oracle database migration - Cross-cloud connectivity
titleSuffix: Azure Example Scenarios
description: Create a connection between your existing Oracle Database and your Azure applications.
author: amberz
ms.date: 06/12/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Oracle database migration - Cross-cloud connectivity

To support a [multi-cloud experience](/azure/virtual-machines/workloads/oracle/oracle-oci-overview), you can create a direct interconnection between Azure and Oracle Cloud Infrastructure (OCI) [ExpressRoute](https://azure.microsoft.com/services/expressroute/) and [FastConnect](https://www.oracle.com/cloud/networking/fastconnect.html). The connection between the services allows applications hosted on Azure to communicate with Oracle database hosted on OCI. You can expect low latency and high throughput by connecting an ExpressRoute circuit in Azure with a FastConnect circuit in OCI.

## Architecture

![An architecture diagram that shows teh Oracle cloud environment on the right and the Azure Virtual Machine environment on the left.](media/cross-cloud-connectivity.png)

1. Establish a connection between Azure ExpressRoute and OCI FastConnect.

1. Your Azure application can communicate with your OCI-hosted Oracle database.

## Components

* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) lets you migrate your business and important workloads to Azure to increase operational efficiencies.

* [Virtual Network](https://azure.microsoft.com/services/virtual-network/) is your private network in your Azure environment.

* [VPN Gateway](https://azure.microsoft.com/services/vpn-gateway/) connects your infrastructure to the cloud.

* [ExpressRoute](https://azure.microsoft.com/services/expressroute/) creates a faster private connection to Azure.

## Next steps

See [Set up a direct interconnection between Azure and Oracle Cloud Infrastructure](/azure/virtual-machines/workloads/oracle/configure-azure-oci-networking) for step-by-step configuration instructions. Refer to the **Important** alert at the beginning of the article. It shows a list of Oracle applications that Oracle has certified to run in Azure when using the Azure/Oracle Cloud interconnect solution.

> [!NOTE]
> If this migration path doesn't seem like the right one for your business needs, refer back to the [Migration decision tree](oracle-migration-overview.md#migration-decision-tree).
