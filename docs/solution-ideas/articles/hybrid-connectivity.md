---
title: Hybrid Connection
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 09/01/2020
description: Azure's Hybrid Connection is a foundational blueprint that is applicable to most Azure Stack Hub solutions, allowing you to establish connectivity for any application that involves communications between the Azure public cloud and on-premises Azure Stack Hub components.
ms.custom: acom-architecture, Hybrid Connection, Azure Hybrid Connection, Hybrid Network, Azure Hybrid Network, hybrid-infrastructure, interactive-diagram, networking, 'https://azure.microsoft.com/solutions/architecture/hybrid-connectivity/'
ms.service: architecture-center
ms.category:
  - hybrid
  - networking
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/hybrid-connectivity.png
---

# Hybrid Connection

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Stack Hub enables you to deploy Azure services on-premises or in the cloud with a consistent application logic, development paradigm, and operations methodology.

Hybrid cloud applications are a single system that has components running in both Azure and Azure Stack Hub. This solution blueprint is relevant to establishing connectivity for any application that involves communications between the Azure public cloud and on-premises Azure Stack Hub components. Hybrid connectivity is a foundational blueprint that will be applicable to most Azure Stack Hub solutions.

Note: This doesn't apply to Azure Stack Hub deployments that are disconnected from the public internet.

## Architecture

![Architecture diagram](../media/hybrid-connectivity.png)
*Download an [SVG](../media/hybrid-connectivity.svg) of this architecture.*

## Data Flow

1. Deploy a virtual network in Azure and Azure Stack Hub.
1. Deploy a virtual network gateway in Azure and Azure Stack Hub.
1. Deploy virtual machines in each virtual network.
1. Establish a VPN connection over the public internet between the network gateways.

## Components

* [Virtual Network](https://azure.microsoft.com/services/virtual-network): Provision private networks, optionally connect to on-premises datacenters.
* [Virtual Network Gateway](https://azure.microsoft.com/services/vpn-gateway): Learn how to configure VPN Gateway, a virtual private network gateway.
* [Virtual Machines](https://azure.microsoft.com/services/virtual-machines): Provision Windows and Linux virtual machines in seconds.
* [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack) is a hybrid cloud platform that lets you use Azure services on-premises.

## Next steps

* [Virtual Network](/azure/virtual-network)
* [VPN Gateway Documentation](/azure/vpn-gateway)
* [Virtual Machines Overview](https://azure.microsoft.com/services/virtual-machines)
* [Azure Stack Hub User Documentation](/azure/azure-stack/user)