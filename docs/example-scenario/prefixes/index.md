---
title: Add IP Address spaces on Peered Virtual Networks in Azure
titleSuffix: Azure Example Scenarios
description: Your Description
author: randycampbell
ms.date: 02/01/2020
ms.topic: example-scenarios
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
    - fcp
---

# Add IP Address spaces on Peered Virtual Networks in Azure

In this example scenario we pursue a scenario where customers deploy a virtual networking architecture, such as a [Hub and Spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) model, and at some point in the future, this Hub virtual network needs additional IP Address spaces.  At this time, you can't add address ranges to, or delete address ranges from a virtual network's address space once a virtual network is peered with another virtual network. To add or remove address ranges, delete the peering, add or remove the address ranges, then re-create the peering manually.  To accommodate this scenario, we have developed two PowerShell scripts that can make this process much easier.

## Relevant Use Cases

The following use cases have been tested with these scripts:
• Single subscription scenarios where both hub and all spoke virtual networks are in the same subscription.
• Single Azure Active Directory tenant, different subscription scenarios where the hub virtual network is in one subscription and all other spoke virtual networks are in different subscriptions.

## Architecture

* Single Subscription

<insert PNG file>

* Multiple Subscriptions


