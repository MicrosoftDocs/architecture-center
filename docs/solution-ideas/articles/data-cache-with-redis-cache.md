---
title: Data cache
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: data cache, data cache with azure cache for redis, azure database, cosmos db
ms.custom: acom-architecture, data, 'https://azure.microsoft.com/solutions/architecture/data-cache-with-redis-cache/'
ms.service: architecture-center
ms.category:
  - databases
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/data-cache-with-redis-cache.png
---

# Data cache

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Cache for Redis perfectly complements Azure database services such as Cosmos DB. It provides a cost-effective solution to scale read and write throughput of your data tier. Store and share database query results, session states, static contents, and more using a common cache-aside pattern.

## Architecture

![Architecture Diagram](../media/data-cache-with-redis-cache.png)
*Download an [SVG](../media/data-cache-with-redis-cache.svg) of this architecture.*
