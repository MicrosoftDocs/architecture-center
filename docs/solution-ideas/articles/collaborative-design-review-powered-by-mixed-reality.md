---
title: Design Review Powered by Mixed Reality
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: Too often, product designers waste time and money with inefficient design review-2D images lose essential detail and context, and physical prototypes are extremely expensive. With this mixed reality scenario, clients, designers, and on-site engineers can easily share and review designs as 3D holograms in the context of their environment, accelerating design decisions and reducing time to market.
ms.custom: acom-architecture, Azure Spatial Anchors, Azure Active Directory, Cosmos DB, Blob Storage, Web Service, Microsoft Hololens, interactive-diagram, 'https://azure.microsoft.com/solutions/architecture/collaborative-design-review-powered-by-mixed-reality/'
ms.service: architecture-center
ms.category:
  - mixed-reality
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media/collaborative-design-review-powered-by-mixed-reality.png
---

# Design Review Powered by Mixed Reality

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Businesses and teams across industries have to spend time and money on design reviews. 2D images lose essential detail and context, and physical prototypes are extremely expensive. With this mixed reality scenario, clients, designers, and onsite engineers can easily share and review designs as 3D holograms in the context of their environment, accelerating design decisions and reducing time to market.

## Architecture

![Architecture diagram](../media/collaborative-design-review-powered-by-mixed-reality.png)
*Download an [SVG](../media/collaborative-design-review-powered-by-mixed-reality.svg) of this architecture.*

## Data Flow

1. Users of the client application authenticate using their Azure Active Directory credentials from HoloLens or a mobile device.
1. Device 1 creates an anchor using Azure Spatial Anchors and gets back an anchor ID.
1. Device 1 sends the anchor ID to the app's web service to create a collaboration session. It also specifies which hologram is to be displayed via its ID in Azure Blob storage.
1. Session information, including a 6-digit code to join the session, is stored in Azure Cosmos DB. That code is returned to the client, allowing the user of that device to invite others to join.
1. Device 2 connects to the app's web service and enters the code to join the session (displayed on Device 1).
1. The web service retrieves the anchor ID for the session and the ID of the hologram associated to that session from Azure Cosmos DB.
1. The web service retrieves a SAS key to access the hologram associated to the session from Blob storage. It then returns the anchor ID and SAS key to Device 2.
1. Device 2 queries Azure Spatial Anchors to get coordinates for the anchor ID retrieved in step 6.
1. Device 2 fetches the hologram from Blob storage using the SAS key obtained from the app service.
1. Device 1 and Device 2 exchange state information over a peer-to-peer networking channel (or through a service relay of your choice).

## Components

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory): Synchronize on-premises directories and enable single sign-on
* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): REST-based object storage for unstructured data
* [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db): Globally distributed, multi-model database for any scale

## Next steps

* [Azure Active Directory documentation](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-access-create-new-tenant)
* [Blob Storage documentation](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-dotnet?tabs=windows)
* [Azure Cosmos DB documentation](https://docs.microsoft.com/azure/cosmos-db/create-sql-api-dotnet)
