---
title: Video-on-demand digital media
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: A basic video-on-demand solution that gives you the capability to stream recorded video content such as movies, news clips, sports segments, training videos, and customer support tutorials to any video-capable endpoint device, mobile application, or desktop browser. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.
ms.custom: acom-architecture, media, 'https://azure.microsoft.com/solutions/architecture/digital-media-video/'
ms.service: architecture-center
ms.category:
  - media
  - web
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media-video.png
---

# Video-on-demand digital media

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A basic video-on-demand solution that gives you the capability to stream recorded video content such as movies, news clips, sports segments, training videos, and customer support tutorials to any video-capable endpoint device, mobile application, or desktop browser. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.

This solution is built on the Azure managed services: [Blob Storage](https://azure.microsoft.com/services/storage/blobs), [Content Delivery Network](https://azure.microsoft.com/services/cdn) and [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/digital-media-video.png)
*Download an [SVG](../media/digital-media-video.svg) of this architecture.*

## Components

* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately.
* [Azure Encoder](https://azure.microsoft.com/services/media-services/encoding): Encoding jobs are one of the most common processing operations in Media Services. You create encoding jobs to convert media files from one encoding to another.
* [Azure streaming endpoint](https://azure.microsoft.com/services/media-services/live-on-demand): A streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player): Uses industry standards, such as HTML5 (MSE/EME), to provide a rich adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Multi-DRM content protection](https://azure.microsoft.com/services/media-services/content-protection): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption

## Next steps

* [Azure Media Services overview](/azure/media-services/latest/media-services-overview)
* [How to use Azure Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-portal)
* [How to encode an asset using Media Encoder](https://docs.microsoft.com/azure/media-services/media-services-rest-encode-asset)
* [How to manage streaming endpoints](https://docs.microsoft.com/azure/media-services/media-services-portal-manage-streaming-endpoints)
* [Using Azure Content Delivery Network](https://docs.microsoft.com/api/Redirect/documentation/articles/cdn-create-new-endpoint)
* [Develop video player applications](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-develop-video-players)
* [Deliver content securely](https://azure.microsoft.com/services/media-services/content-protection)
