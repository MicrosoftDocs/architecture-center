---
title: "Enterprise Cloud Adoption: Build a Virtual Datacenter (VDC)" 
description: Defining the approach to build a Virtual Datacenter (VDC)
author: BrianBlanchard
ms.date: 10/11/2018
---
# Enterprise Cloud Adoption: How To: Build a Virtual Datacenter (VDC)

The [Infrastructure section](../overview.md) of the [Enterprise Cloud Adoption framework](../../overview.md), clarifies the components required to migrate core infrastructure services to Azure. This section of the framework, expands on that topic by specifically guiding the reader through the process and associated considerations for building a Virtual Datacenter or VDC.

VDC is a term coined by Mark Ozur, Hatay Tuna, Callum Coffin, and Telmo Sampaio from the Azure Customer Advisory Team (AzureCAT), in the ebook "Azure Virtual Datacenter".

This approach to the creation and deployment of a Virtual Datacenter in Azure, is based on a set of core assumptions, outlined at the end of this document. When these assumptions prove accurate, this guide and associated accelerators can significant reduce the time required to build out the foundational elements of Azure. Even when the assumptions don't apply to the specific deployment scenario, this approach provides a logical way of thinking about complex, interconnected cloud based solutions.

## Guide

* Provide a summary of guidance and a link for each section of VDC, as distributed across markdown

## Assumptions

List out core assumptions here:

* Subscription design theories assume the Virtual Datacenter will be supporting a large number of assets that could benefit from shared resources in a hub/spoke model. If there is no risk of exceeding subscription limits & no security need for segmentation, then this model may be a bit too involved.
* Encryption theories assume that the data being stored in Azure warrants the extra cost of protection. If all data hosted in the cloud is publicly consumable data, then this guidance may not be required.
* AAD guidance assumes there are no dependencies on Kerberos or other legacy authentication mechanisms in the deployed solutions
* Add other assumptions here...

## Next steps

See more [guidance and examples](../overview.md#azure-examples-and-guidance) on how to use core infrastructure components in the Azure cloud.

> [!div class="nextstepaction"]
> [Azure Examples and Guidance](../overview.md#azure-examples-and-guidance)