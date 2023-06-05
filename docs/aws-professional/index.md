---
title: Azure for AWS professionals
description: Learn the basics of Microsoft Azure accounts, platform, and services, and key similarities and differences between the AWS and Azure platforms.
author: martinekuan
categories: azure
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories: 
  - analytics 
  - compute
  - developer-tools
  - devops
  - networking
  - web
products:
  - azure-cloud-services
  - azure-devops
  - azure-managed-applications
ms.custom:
  - fcp
---

<!-- cSpell:ignore lbrader CDNs -->

# Azure for AWS professionals

This series of articles helps Amazon Web Services (AWS) experts understand the basics of Microsoft Azure accounts, platform, and services. These articles also cover key similarities and differences between AWS and Azure.

These articles describe:

- How Azure organizes accounts and resources.
- How Azure structures available solutions.
- How the major Azure services differ from AWS services.

To quickly find the comparable services across the different technology categories, see [AWS to Azure services comparison](./services.md).

## Similarities and differences

Like AWS, Microsoft Azure builds on a core set of compute, storage, database, and networking services. In many cases, the platforms offer similar products and services. For example, both AWS and Azure can use Linux distributions and open-source software (OSS) technologies. Both platforms support building highly available solutions on Windows or Linux hosts.

While the capabilities of both platforms are similar, the resources that provide those capabilities are often organized differently. Azure and AWS built their capabilities independently over time, so the platforms have important implementation and design differences. Exact one-to-one correspondences between the services that you need to build a solution aren't always clear.

Sometimes, only one of the platforms offers a particular service. For a complete listing and charts of how services map between the platforms, see [AWS to Azure services comparison](./services.md).

Not all Azure products and services are available in all regions. For details, see [Products available by region](https://azure.microsoft.com/global-infrastructure/services). For Azure product and service uptime guarantees and downtime credit policies, see [Service-level agreements](https://azure.microsoft.com/support/legal/sla).

## Compare Azure and AWS core components

Many Azure and AWS core components have similar functionality. The following articles compare the platforms' capabilities in these core areas:

- [Azure and AWS accounts and subscriptions](./accounts.md)
- [Compute services on Azure and AWS](./compute.md)
- [Relational database technologies on Azure and AWS](./databases.md)
- [Messaging services on Azure and AWS](./messaging.md)
- [Networking on Azure and AWS](./networking.md)
- [Regions and zones on Azure and AWS](./regions-zones.md)
- [Resource management on Azure and AWS](./resources.md)
- [Multi-cloud security and identity with Azure and AWS](./security-identity.md)
- [Compare storage on Azure and AWS](./storage.md)
