---
title: Live streaming digital media
titleSuffix: Azure Solution Ideas
author: doodlemania2
ms.date: 12/16/2019
description: A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online.
ms.custom: acom-architecture, media, 'https://azure.microsoft.com/solutions/architecture/digital-media-live-stream/'
ms.service: architecture-center
ms.category:
  - media
ms.subservice: solution-idea
social_image_url: /azure/architecture/solution-ideas/articles/media-live-stream.png
---

# Live streaming digital media

[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online. In this solution, video is captured by a video camera and sent to a channel input endpoint. The channel receives the live input stream and makes it available for streaming through a streaming endpoint to a web browser or mobile app. The channel also provides a preview monitoring endpoint to preview and validate your stream before further processing and delivery. The channel can also record and store the ingested content in order to be streamed later (video-on-demand).

This solution is built on the Azure managed services: [Media Services](https://azure.microsoft.com/services/media-services) and [Content Delivery Network](https://azure.microsoft.com/services/cdn). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture Diagram](../media/digital-media-live-stream.png)
*Download an [SVG](../media/digital-media-live-stream.svg) of this architecture.*

## Components

* [Partner on-premises live encoder](https://docs.microsoft.com/azure/media-services/latest/become-on-premises-encoder-partner): Outputs the live source for ingest into the cloud as RTMP, MPEG-Transport Stream, or fragmented mp4 formats.
* Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use [Blob storage](https://azure.microsoft.com/services/storage/blobs) to expose data publicly to the world, or to store application data privately.
* [Media Services](https://azure.microsoft.com/services/media-services): Provides the ability to ingest, encode, preview, store, and deliver your live streaming content. Channels, programs, and streaming endpoints handle the live streaming functions, including ingestion, formatting, DVR, security, scalability, and redundancy.
* [Azure streaming endpoint](https://azure.microsoft.com/services/media-services/live-on-demand): Represents a streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player): Uses industry standards such as HTML5 (MSE/EME) to provide an enriched adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Preview monitoring](https://docs.microsoft.com/api/Redirect/documentation/articles/web-sites-monitor): Provides the ability to preview and validate a live stream before further processing and delivery.
* [Multi-DRM content protection](https://azure.microsoft.com/services/media-services/content-protection): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption.

## Next steps

* [Overview of live encoder](https://docs.microsoft.com/azure/media-services/previous/media-services-live-encoders-overview)
* [How to use Azure Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-dotnet)
* [Overview of live streaming](https://docs.microsoft.com/azure/media-services/previous/media-services-manage-channels-overview)
* [Using Azure Content Delivery Network](https://docs.microsoft.com/azure/cdn/cdn-create-new-endpoint)
* [Azure Media Services documentation](https://docs.microsoft.com/azure/media-services/)
* [Media services content protection](https://azure.microsoft.com/services/media-services/content-protection)
