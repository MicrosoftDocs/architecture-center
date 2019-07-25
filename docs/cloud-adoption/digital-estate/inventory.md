---
title: "Gather inventory data for a digital estate"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: How to gather inventory for a digital estate.
author: BrianBlanchard
ms.author: brblanch
ms.date: 12/10/2018
ms.topic: guide
ms.service: cloud-adoption-framework
ms.subservice: plan
---

# Gather inventory data for a digital estate

Developing an inventory is the first step in [digital estate planning](index.md). In this process, a list of IT assets that support specific business functions are collected for later analysis and rationalization. This article assumes that a bottom-up approach to analysis is most appropriate for planning. For more information, see [Approaches to digital estate planning](./approach.md).

## Take inventory of a digital estate

The inventory that supports a digital estate changes depending on the desired digital transformation and corresponding transformation journey.

- **Cloud migration:**  We often recommend that during a cloud migration, you collect the inventory from scanning tools that create a centralized list of all VMs and servers. Some tools can also create network mappings and dependencies, which help define workload alignment.

- **Application innovation:** Inventory during a cloud-enabled application innovation effort begins with the customer. Mapping the customer experience from start to finish is a good place to begin. Aligning that map to applications, APIs, data, and other assets creates a detailed inventory for analysis.

- **Data innovation:** Cloud-enabled data innovation efforts focus on the product or service. An inventory also includes a mapping of the opportunities for disrupting the market, as well as the capabilities needed.

## Accuracy and completeness of an inventory

An inventory is rarely complete in its first iteration. We strongly recommend the cloud strategy team aligns stakeholders and power users to validate the inventory. When possible, use additional tools like network and dependency analysis to identify assets that are being sent traffic, but that are not in the inventory.

## Next steps

After an inventory is compiled and validated, it can be rationalized. Inventory rationalization is the next step to digital estate planning.

> [!div class="nextstepaction"]
> [Rationalize the digital estate](rationalize.md)
