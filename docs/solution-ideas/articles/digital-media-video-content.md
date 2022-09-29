[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution is built on the Azure managed services: [Blob Storage](https://azure.microsoft.com/services/storage/blobs), [Content Delivery Network](https://azure.microsoft.com/services/cdn), and [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player). These services run in a high-availability environment, patched and supported, allowing you to focus on your solution instead of the environment they run in.

## Architecture

![Architecture diagram shows the flow from the video files through Azure Blob Storage and Live Encoder to the streaming endpoint.](../media/digital-media-video.png)
*Download an [SVG](../media/digital-media-video.svg) of this architecture.*

### Components

* [Blob Storage](https://azure.microsoft.com/services/storage/blobs): Stores large amounts of unstructured data that can be accessed from anywhere in the world via HTTP or HTTPS. You can use Blob storage to expose data publicly to the world, or to store application data privately. There are multiple options for uploading files to blob storage, including [AzCopy](/azure/storage/common/storage-use-azcopy-v10), Media Services [Azure portal, .NET SDK, or REST API](/azure/media-services/previous/media-services-portal-upload-files), [Azure CLI, Python](/azure/media-services/latest/asset-upload-media-how-to), or one of [several Azure blob storage tools/SDKs](/azure/storage/blobs/quickstart-storage-explorer).
* [Azure Media Services Encoder](/azure/media-services/latest/encode-concept): Encoding jobs are one of the most common processing operations in Media Services. You create encoding jobs to convert media files from one encoding to another.
* [Azure Media Services Streaming Endpoint](/azure/media-services/previous/media-services-dynamic-packaging-overview): A streaming service that can deliver content directly to a client player application, or to a content delivery network (CDN) for further distribution.
* [Content Delivery Network](https://azure.microsoft.com/services/cdn): Provides secure, reliable content delivery with broad global reach and a rich feature set.
* [Azure Media Player](/azure/media-services/azure-media-player/azure-media-player-overview): Uses industry standards, such as HTML5 (MSE/EME), to provide a rich adaptive streaming experience. Regardless of the playback technology used, developers have a unified JavaScript interface to access APIs.
* [Multi-DRM content protection](/azure/media-services/previous/media-services-content-protection-overview): Delivers content securely using multi-DRM (PlayReady, Widevine, FairPlay Streaming) or AES clear key encryption

## Scenario details

A basic video-on-demand solution that gives you the capability to stream recorded video content to any video-capable endpoint device, mobile application, or desktop browser. This content might include movies, news clips, sports segments, training videos, and customer support tutorials. Video files are uploaded to Azure Blob storage, encoded to a multi-bitrate standard format, and then distributed via all major adaptive bit-rate streaming protocols (HLS, MPEG-DASH, Smooth) to the Azure Media Player client.

### Potential use cases

This solution applies to television, movie, and various online streaming services.

## Next steps

* [Azure Media Services overview](/azure/media-services)
* [How to use Azure Blob storage](/azure/storage/blobs/storage-quickstart-blobs-portal)
* [How to encode an asset using Media Encoder](/azure/media-services/latest/stream-files-tutorial-with-api)
* [How to manage streaming endpoints](/azure/media-services/latest/stream-streaming-endpoint-concept)
* [Using Azure Content Delivery Network](/azure/cdn/cdn-create-new-endpoint)
* [Playing your content with existing players](https://github.com/Azure-Samples/media-services-3rdparty-player-samples)
* [Deliver content securely](/azure/media-services/previous/media-services-content-protection-overview)
