---
title: "Gather inventory data for a digital estate"
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: How to gather inventory for a digital estate.
author: BrianBlanchard
ms.date: 12/10/2018
ms.topic: guide
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Gather inventory data for a digital estate

Developing an inventory is the first step in [digital estate planning](index.md). In this process, a list of IT assets that support specific business functions would be collected for later analysis and rationalization. This article assumes that a bottom-up approach to analysis is most appropriate for planning needs. For more information, see [Approaches to digital estate planning](./approach.md).

## Take inventory of a digital estate

The inventory supporting a digital estate changes depending on the desired digital transformation and corresponding transformation journey.

- **Cloud migration:** During a cloud migration, it is often advised that the inventory is collected from scanning tools that can create a centralized list of all VMs and servers. Some tools can also create network mappings and dependencies, which will help define workload alignment.

- **Application innovation:** Inventory during a cloud enabled, application innovation effort begins with the customer. Mapping the customer experience from start to finish is a good place to begin. Aligning that map to applications, APIs, data, and other assets will create a detailed inventory for analysis.

- **Data innovation:** Cloud-enabled data innovation efforts focus on the product or service. From there, an inventory includes a mapping of the opportunities to disrupt the market and the capabilities needed.

## Accuracy and completeness of an inventory

An inventory is seldom fully complete in its first iteration. It is highly advised that various members of the Cloud Strategy team align stakeholders and power users to validate the inventory. When possible, additional tools like network and dependency analysis can be used to identify assets that are being sent traffic, but are not in the inventory.

## Next steps

Once an inventory is compiled and validated, it can be rationalized. Inventory rationalization is the next step to digital estate planning.

> [!div class="nextstepaction"]
> [Rationalize the digital estate](rationalize.md)