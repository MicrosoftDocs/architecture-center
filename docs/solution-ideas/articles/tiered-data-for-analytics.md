---
title: Tier Applications & Data for Analytics
titleSuffix: Azure Solution Ideas
author: adamboeglin
ms.date: 12/16/2019
description: Tier applications and data with a solution architecture that includes Azure Stack. Optimize data analytics with a step-by-step flowchart and detailed instructions.
ms.custom: acom-architecture, analytics, application tier, data tier, tier architecture, tier data, tier application architecture, hybrid application, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/tiered-data-for-analytics/'
ms.service: architecture-center
ms.category:
  - analytics
  - databases
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/tiered-data-for-analytics.png
---

# Tier Applications & Data for Analytics

[!INCLUDE [header_file](../header.md)]

Easily tier data and applications on-premises and in Azure with architecture that supports greater efficiency in applications. Filter unnecessary data early in the process, easily bring cloud applications close to the data on-premises, and analyze large scale aggregate data from multiple locations in Azure for fleet-level insights.

## Architecture

![Architecture diagram](../media/tiered-data-for-analytics.png)
*Download an [SVG](../media/tiered-data-for-analytics.svg) of this architecture.*

## Data Flow

1. Data flows into a storage account.
1. Function on Azure Stack analyzes the data for anomalies or compliance.
1. Locally-relevant insights are displayed on the Azure Stack app.
1. Insights and anomalies are placed into a queue.
1. The bulk of the data is placed into an archive storage account.
1. Function sends data from queue to Azure Storage.
1. Globally-relevant and compliant insights are available in the global app.

## Components

* [Storage](https://azure.microsoft.com/services/storage): Durable, highly available, and massively scalable cloud storage
* [Azure Functions](https://azure.microsoft.com/services/functions): Process events with serverless code
* [Azure Stack](https://azure.microsoft.com/overview/azure-stack): Build and run innovative hybrid applications across cloud boundaries

## Next steps

* [Storage documentation](https://docs.microsoft.com/azure/storage)
* [Azure Functions documentation](https://docs.microsoft.com/azure/azure-functions)
* [Azure Stack documentation](https://docs.microsoft.com/azure/azure-stack/user/azure-stack-solution-staged-data-analytics)
