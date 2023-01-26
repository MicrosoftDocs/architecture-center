[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution is built on the Azure managed services: [Blob Storage](https://azure.microsoft.com/services/storage/blobs), [Content Delivery Network](https://azure.microsoft.com/services/cdn), and [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player) from [Azure Media Services](/azure/media-services/latest/media-services-overview). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture diagram shows the flow from the video files through Azure Blob Storage and Live Encoder to the streaming endpoint.](../media/digital-media-video.svg)

*Download a [Visio file](https://arch-center.azureedge.net/digital-media-video.vsdx) of this architecture.*

### Components

* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): Stores large amounts of unstructured data that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately. There are multiple options for uploading files to blob storage, including [AzCopy](/azure/storage/common/storage-use-azcopy-v10), Media Services [Azure portal, .NET SDK, or REST API](/azure/media-services/previous/media-services-portal-upload-files), [Azure CLI, Python](/azure/media-services/latest/asset-upload-media-how-to), or one of [several Azure blob storage tools/SDKs](/azure/storage/blobs/quickstart-storage-explorer).
* [Azure Media Services Encoder](/azure/media-services/latest/encode-concept): Encoding jobs are one of the most common processing operations in Media Services. You create encoding jobs to convert media files from one encoding to another.
* [Azure Media Services Streaming Endpoint](/azure/media-services/latest/encode-dynamic-packaging-concept): A streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player): Uses industry standards, such as HTML5 (MSE/EME), to provide a rich adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs. Also, see the [Azure Media Player documentation](/azure/media-services/azure-media-player/azure-media-player-overview).
* [Multi-DRM content protection](/azure/media-services/latest/drm-content-protection-concept): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES Clear Key encryption.

## Scenario details

A basic video-on-demand solution that gives you the capability to stream recorded video content to any video-capable endpoint device, mobile application, or desktop browser. This content might include movies, news clips, sports segments, training videos, and customer support tutorials. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.

You can also use other media players such as:

- [Video.js](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/video.js)
- [Shaka Player](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/shaka)
- [hls.js](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/hls.js)
- [dash.js](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/dash.js)
- [ExoPlayer](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/exoplayer)
- [AVPlayer](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/avplayer)
- [THEOplayer](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/THEOplayer)
- [NexPlayer](https://github.com/Azure-Samples/media-services-3rdparty-player-samples/blob/master/src/NexPlayer)

### Potential use cases

This solution applies to television, movie, and various online streaming services.

## Next steps

* To get started with Azure Media Services, visit the [Azure Media Services](/azure/media-services/latest/media-services-overview) documentation where you will find quickstarts, tutorials, and samples. 
* [Azure Media Player overview](/azure/media-services/azure-media-player/azure-media-player-overview)
* [How to use Azure Blob storage](/azure/storage/blobs/storage-quickstart-blobs-portal)
* [How to encode an asset using Media Encoder](/azure/media-services/latest/samples-overview)
* [How to manage streaming endpoints](/azure/media-services/latest/stream-streaming-endpoint-concept)
* [Using Azure Content Delivery Network](/azure/cdn/cdn-create-new-endpoint)
* [Playing your content with existing players](https://github.com/Azure-Samples/media-services-3rdparty-player-samples)
* [Deliver content securely](/azure/media-services/latest/drm-content-protection-concept)

## Related resources

* [Live stream digital media](/azure/architecture/solution-ideas/articles/digital-media-live-stream)
* [Gridwich cloud media system](/azure/architecture/reference-architectures/media-services/gridwich-architecture)
* [Instant broadcasting with serverless code](/azure/architecture/solution-ideas/articles/instant-broadcasting-on-serverless-architecture)
