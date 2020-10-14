---
title: Gridwich simple sync and async handlers
titleSuffix: Azure Example Scenarios
description: Learn about synchronous and asynchronous requests, request-response flows, and handlers.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Gridwich sync and async handlers

Gridwich request messages may be synchronous or asynchronous in nature.

## Sync handler

Some requests are easy to perform and fast to complete. The handler does the work synchronously and returns the success event, with its operation context, almost immediately after the acknowledgement is sent.

![handler_message_sync_flow diagram](media/request-response-sync-flow.png).

### Example sync request flow

The [ChangeBlobTierHandler](https://github.com/mspnp/gridwich/src/GridWich.SagaParticipants.Storage.AzureStorage/src/EventGridHandlers/ChangeBlobTierHandler.cs) is an example of a simple synchronous flow. The handler gets a Request data transfer object (DTO), calls and awaits a single service to do the work, and returns a Success or Failure response.

![event_dispatching_sync_example diagram](media/sync-example.png)

## Async handler

Some requests are long-running. For example, encoding media files can take hours. In these cases, the request handler evaluates the request, validates arguments, and initiates the long-running operation. The handler then returns a Scheduled response to confirm that the work activity has been requested to start.

![handler_message_async_flow diagram](media/request-response-sync-flow.png)

On completing the work activity, the request handler is responsible for providing a Success or Failure completed event for the work. The handler must retrieve the original operation context, while remaining stateless, and place it in the Completed event message payload.

### Example async request flow

The [BlobCopyHandler](https://github.com/mspnp/gridwich/src/GridWich.SagaParticipants.Storage.AzureStorage/src/EventGridHandlers/BlobCopyHandler.cs) is an example of a simple asynchronous flow. The handler gets a Request DTO, calls and awaits a single service to initiate the work, and publishes a Scheduled or Failure response.

![event_dispatching_async_example_scheduled diagram](media/async-example-scheduled.png)

To complete the long-running request flow, the [BlobCreatedHandler](https://github.com/mspnp/gridwich/src/GridWich.SagaParticipants.Storage.AzureStorage/src/EventGridHandlers/BlobCreatedHandler.cs) consumes the platform event `Microsoft.Storage.BlobCreated`, extracts the original operation context, and publishes a Success or Failure completion response.

![event_dispatching_async_example_success diagram](media/async-example-success.png)

## Related resources

For the complete request-response workflow, see [Gridwich operations request and response flow](gridwich-request-response-flow.md).
