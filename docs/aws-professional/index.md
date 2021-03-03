---
title: Azure for AWS professionals
description: Understand the basics of Microsoft Azure accounts, platform, and services. Also learn key similarities and differences between the AWS and Azure platforms. Take advantage of your AWS experience in Azure.
author: doodlemania2
ms.date: 03/15/2020
ms.topic: reference
ms.service: architecture-center
ms.subservice: cloud-fundamentals
ms.custom:
  - fcp
---

<!-- cSpell:ignore lbrader CDNs -->

# Azure for AWS Professionals

This article helps Amazon Web Services (AWS) experts understand the basics of Microsoft Azure accounts, platform, and services. It also covers key similarities and differences between the AWS and Azure platforms.

You'll learn:

- How accounts and resources are organized in Azure.
- How available solutions are structured in Azure.
- How the major Azure services differ from AWS services.

Azure and AWS built their capabilities independently over time so that each has important implementation and design differences.

## Overview

Like AWS, Microsoft Azure is built around a core set of compute, storage, database, and networking services. In many cases, both platforms offer a basic equivalence between the products and services they offer. Both AWS and Azure allow you to build highly available solutions based on Windows or Linux hosts. So, if you're used to development using Linux and OSS technology, both platforms can do the job.

While the capabilities of both platforms are similar, the resources that provide those capabilities are often organized differently. Exact one-to-one relationships between the services required to build a solution are not always clear. In other cases, a particular service might be offered on one platform, but not the other. See [charts of comparable Azure and AWS services](./services.md).

## Services

For a listing of how services map between platforms, see [AWS to Azure services comparison](./services.md).

Not all Azure products and services are available in all regions. Consult the [Products by Region](https://azure.microsoft.com/global-infrastructure/services) page for details. You can find the uptime guarantees and downtime credit policies for each Azure product or service on the [Service Level Agreements](https://azure.microsoft.com/support/legal/sla) page.

## Components

A number of core components on Azure and AWS have similar functionality.  To review the differences, visit the component page for the topic you're interested in:

- [Accounts](./accounts.md)
- [Compute](./compute.md)
- [Databases](./databases.md)
- [Messaging](./messaging.md)
- [Networking](./networking.md)
- [Regions and Zones](./regions-zones.md)
- [Resources](./resources.md)
- [Security & Identity](./security-identity.md)
- [Storage](./storage.md)
