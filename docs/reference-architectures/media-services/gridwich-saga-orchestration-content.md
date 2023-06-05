In the example implementation, the external system is a large media company's media asset management (MAM) and workflow orchestration system. The external system operates as a [saga orchestrator](https://microservices.io/patterns/data/saga.html) that chains a series of activities to build Gridwich workflows.

Saga activities might or might not include user interactions or approvals. Gridwich assumes that the external system tracks the failure or success of each operation it initiates.

## Saga participants

Each saga participant contributes one or more work activities to the ecosystem. Each participant works independently, and more than one saga participant might act on a single request.

For Gridwich, the available saga participants are:

- [Analysis.MediaInfo](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Analysis.MediaInfo/)
- [Encode.CloudPort](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.CloudPort/)
- [Encode.Flip](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.Flip/)
- [Encode.MediaServicesV3](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV3/)
- [Publication.MediaServicesV3](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Publication.MediaServicesV3/)
- [Storage.AzureStorage](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Storage.AzureStorage/)

## Example saga workflow

The external system might run a quality control check saga that does the following steps:

1. Gets a notification of a new blob in the inbox storage account.
1. Requests an analysis using MediaInfo.
1. Reviews the MediaInfo response, auto-approves the file, and starts a copy into an intermediate account.
1. Gets notified that the copy is complete.
1. Starts a multi-bitrate encoding by using Azure Media Services v3 API encoder, requests AAC audio for all tracks, and copies the video codec.
1. Publishes the completed asset using DRM, and notifies an operator that an asset is ready for review.

![Diagram showing a quality control check saga.](media/quality-control-saga.png)

The operator reviews the asset, identifies the various audio track layouts, and then starts a saga that:

 1. Starts a copy into the long-term storage account.
 1. Gets notified that the copy is complete.
 1. Begins encoding with TeleStream CloudPort to Mux the left and right stereo tracks, along with the video, into a new asset.
 1. Creates a multi-bitrate asset by using Azure Media Services v3 API encoder.
 1. Publishes the asset with DRM, and notifies the operator that an asset is ready for logging.

![Diagram showing an asset creation saga.](media/logging-saga.png)

The operator reviews the asset contents, extracts metadata for the MAM system, and sets mark-in and mark-out points for one or more features, text-less sequences, or featurettes. The operator then begins the publication saga, which:

 1. Uses the Azure Media Services Publishing v3 API to create a time-based filter for each subasset, and create a locator with that filter and DRM.
 1. Simultaneously begins to create sprites for each subasset.
 1. After receiving successful responses from both processes, begins a copy of the sprite files into the published asset.
 1. Receives the blob created for the copy, and completes the publication flow by updating the MAM system.

![Diagram showing an asset publication saga.](media/publication-saga.png)

## Components

- [Azure Event Grid](https://azure.microsoft.com/products/event-grid) allows a developer to easily build applications with event-based architectures.
- [Azure Blob storage](https://azure.microsoft.com/products/storage/blobs) is a service for storing any type of text or binary data, such as a document, media file, or application installer.
- [Azure Media Services v3 API](https://azure.microsoft.com/products/media-services) is a cloud-based platform that enables you to build solutions that achieve broadcast-quality video streaming, enhance accessibility and distribution, analyze content, and much more.

## Next steps

- [Azure Blob storage](/azure/storage/common/storage-quickstart-create-account)
- [Azure Event Grid](/azure/event-grid/overview)
- [Azure Media Services v3 API](/azure/media-services/latest/media-services-overview)
- [Saga](/azure/architecture/reference-architectures/saga/saga): Learn more about the Saga distributed transactions pattern.
- [Cloud-native data patterns](/dotnet/architecture/cloud-native/distributed-data): Explore cloud-native data patterns.
- [Azure Media Services as an Event Grid source](/azure/event-grid/event-schema-media-services?tabs=event-grid-event-schema): Familiarize yourself with the schemas and properties for Media Services events.

## Related resources

- [Understand Gridwich cloud media system](gridwich-architecture.yml)
- [Explore Gridwich project naming](gridwich-project-names.yml)
- [Set up Gridwich CI/CD pipeline](gridwich-cicd.yml)
