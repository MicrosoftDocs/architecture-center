---
title: Sagas and operations context in Gridwich
titleSuffix: Azure Example Scenarios
description: Understand the concepts and roles of sagas and opaque operations context in orchestrating Gridwich workflows.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Gridwich operations context and sagas

An external system might generate thousands of requests per day, per hour, or per second. With each request, the external system must provide an operation context, which persists through the lifetime of even very long-running requests.

Gridwich is a stateless request processing and work activity solution that responds with an opaque operation context, whether the activity is short- or long-running. If a request contains an operation context, like `{"id"="Op1001"}`, every response includes that operation context.

![request_and_response diagram](media/request-response.png)

## Sagas
The external system operates as a [saga orchestrator](https://microservices.io/patterns/data/saga.html) that chains a series of activities to build Gridwich workflows. Saga activities might or might not include user interactions or approvals. Gridwich assumes that the external system tracks failure or success for each operation it initiates. 

For example, the external system might run a quality control check saga that performs the following steps:

1. Get a notification of a new blob in the inbox storage account.
1. Request an analysis using MediaInfo.
1. Review the MediaInfo response, auto-approve the file, and start a copy into an intermediate account.
1. Get notified that the copy is complete.
1. Start a multi-bitrate encode using Azure Media Services V3 API encoder, request AAC audio for all tracks, and copy the video codec.
1. Publish the completed encode using DRM, and notify an operator that an asset is ready for review.

![workflow_quality_control diagram](media/quality-control-saga.png)

The operator reviews the asset and identifies the various audio track layouts, then starts the following saga:

 1. Start a copy into the longterm storage account.
 1. Get notified that the copy is complete.
 1. Begin an encode with TeleStream CloudPort to Mux the left and right stereo tracks, along with the video, into a new asset.
 1. Create a multi-bitrate asset using Azure Media Services V3 API encoder.
 1. Publish the asset with DRM, and notify an operator that an asset is ready for logging.

![workflow_logging diagram](media/logging-saga.png)

The operator reviews the contents, extracts metadata for the media asset management (MAM) system, and sets mark-in and mark-out points for one or more features, text-less sequences, or featurettes. The operator then begins the publication saga:

 1. Create a time-based filter for each sub-asset, and create a locator with that filter and DRM, using Azure Media Services Publishing V3 API.
 1. Simultaneously begin to create sprites for each sub-asset.
 1. After receiving successful responses from both processes, and begin a copy of the sprite files into the published asset.
 1. Receive the blob created for the copy, and complete the publication flow by updating the MAM system.

![workflow_publication diagram](media/publication-saga.png)

## Saga participants

Each of a set of saga participants contributes one or more work activities to the ecosystem. Each saga participant works independently of the other participants, and more than one saga participant might act on a single request.

The available saga participants are:

- Analysis.MediaInfo
- Encode.CloudPort
- Encode.Flip
- Encode.MediaServicesV2
- Encode.MediaServicesV3
- Publication.MediaServicesV3
- Storage.AzureStorage

Each of the saga participants must retain the operation context, but may implement it differently. For example:

- Short-running synchronous operations retain the operation context.
- Azure Storage provides an opaque string property called `ClientRequestId` for most operations.
- Azure Media Services V3 has a `Job.CorrelationData` property, or Azure Media Services V2 allows the `Task.Name` to be any string.
- Other cloud APIs offer similar concepts to an opaque operation context, and return them when signaling progress, completion, or failure.

## Alternatives

To call a new, asynchronous API that provides a opaque operation context, you could use a Durable Function to create a series of tasks within an operation, which would allow the operation context to be saved as a input or output to the operation. Durable functions have a built-in state store for long-running operations. Alternatively, the whole solution could use Durable Functions, regardless of the work activities, but this increases code complexity.

