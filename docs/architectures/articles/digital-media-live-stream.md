---
title: Live streaming digital media
description: A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online. In this solution, video is captured by a video camera and sent to a channel input endpoint. The channel receives the live input stream and makes it available for streaming through a streaming endpoint to a web browser or mobile app. The channel also provides a preview monitoring endpoint to preview and validate your stream before further processing and delivery. The channel can also record and store the ingested content in order to be streamed later (video-on-demand).
author: adamboeglin
ms.date: 10/29/2018
---
# Live streaming digital media
A live streaming solution allows you to capture video in real-time and broadcast it to consumers in real time, such as streaming interviews, conferences, and sporting events online. In this solution, video is captured by a video camera and sent to a channel input endpoint. The channel receives the live input stream and makes it available for streaming through a streaming endpoint to a web browser or mobile app. The channel also provides a preview monitoring endpoint to preview and validate your stream before further processing and delivery. The channel can also record and store the ingested content in order to be streamed later (video-on-demand).
This solution is built on the Azure managed services: Media Services and Content Delivery Network. These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture
<img src="media/digital-media-live-stream.svg" alt='architecture diagram' />

## Components
* [Partner on-premises live encoder](https://docs.microsoft.com/api/Redirecthref="http://azure.microsoft.com/documentation/articles/media-services-live-encoders-overview/): Outputs the live source for ingest into the cloud as RTMP, MPEG-Transport Stream, or fragmented mp4 formats.
* Stores large amounts of unstructured data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. You can use [Blob storage](http://azure.microsoft.com/services/storage/blobs/) to expose data publicly to the world, or to store application data privately.
* [Media Services](href="http://azure.microsoft.com/services/media-services/): Provides the ability to ingest, encode, preview, store, and deliver your live streaming content. Channels, programs, and streaming endpoints handle the live streaming functions, including ingestion, formatting, DVR, security, scalability, and redundancy.
* [Azure streaming endpoint](href="http://azure.microsoft.com/services/media-services/live-on-demand/): Represents a streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](href="http://azure.microsoft.com/services/cdn/): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](href="http://azure.microsoft.com/services/media-services/media-player/): Uses industry standards such as HTML5 (MSE/EME) to provide an enriched adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Preview monitoring](https://docs.microsoft.com/api/Redirecthref="http://azure.microsoft.com/documentation/articles/web-sites-monitor/): Provides the ability to preview and validate a live stream before further processing and delivery.
* [Multi-DRM content protection](href="http://azure.microsoft.com/services/media-services/content-protection/): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption.

## Next Steps
* [Overview of live encoder](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-live-encoders-overview/)
* [How to use Azure Blob storage](https://docs.microsoft.com/api/Redirect/documentation/articles/storage-dotnet-how-to-use-blobs/)
* [Overview of live streaming](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-manage-channels-overview/)
* [How to manage streaming endpoints](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-manage-origins/)
* [Using Azure Content Delivery Network](https://docs.microsoft.com/api/Redirect/documentation/articles/cdn-create-new-endpoint/)
* [Develop video player applications](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [How to monitor apps in Azure App Service](https://docs.microsoft.com/api/Redirect/documentation/articles/media-services-develop-video-players/)
* [Deliver content securely](href="http://azure.microsoft.com/services/media-services/content-protection/)