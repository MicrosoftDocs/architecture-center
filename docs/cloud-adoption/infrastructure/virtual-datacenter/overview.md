---
title: "Enterprise Cloud Adoption: Build an Azure Virtual Datacenter (VDC)" 
description: Overview of the Azure Virtual Datacenter (VDC) deployment model
author: BrianBlanchard
ms.date: 10/11/2018
---
# Enterprise Cloud Adoption: Azure Virtual Datacenter (VDC) Model

The [Infrastructure section](../overview.md) of the [Enterprise Cloud Adoption framework](../../overview.md), clarifies the components required to migrate core infrastructure services to Azure. This section of the framework, expands on that topic by specifically guiding the reader through the process and associated considerations for building a Virtual Datacenter or VDC.

VDC is a term coined by Mark Ozur, Hatay Tuna, Callum Coffin, and Telmo Sampaio from the Azure Customer Advisory Team (AzureCAT), in the ebook "[Azure Virtual Datacenter](https://azure.microsoft.com/en-us/resources/azure-virtual-datacenter/)".

This approach to the creation and deployment of a Virtual Datacenter in Azure is based on a set of core assumptions, outlined at the end of this document. When these assumptions prove accurate, this guide and associated accelerators can significant reduce the time required to build out the foundational elements of Azure. Even when the assumptions don't apply to the specific deployment scenario, this approach provides a logical way of thinking about complex, interconnected cloud based solutions.

## Azure Virtual Datacenter structure

Provide a high-level summary of the VDC structure and components.

## VDC Infrastructure

The underlying infrastructure of a VDC serves to connect on-premises resources with the various subscriptions, external access requirements, and virtual network connectivity between central hub and spoke workload networks. The Azure Virtual Datacenter approach combines features of each infrastructure component to ensure isolation of resources and central governance produces a trusted cloud environment extension of your existing IT infrastructure.

- [Subscription Structure](../subscriptions/vdc-subscriptions.md)
- [Identity and Roles](../identity/vdc-identity.md)
- [Policy Enforcement](../policy-enforcement/vdc-policy-enforcement.md)
- [Resource Grouping](../resource-grouping/vdc-resource-grouping.md)
- [Naming and Tagging Standards](../resource-tagging/vdc-naming.md)
- [Encryption](../encryption/vdc-encryption.md)
- [Networking](../software-defined-networks/vdc-networking.md)
- [Reporting, Monitoring and Compliance](../logs-and-reporting/vdc-monitoring.md)

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