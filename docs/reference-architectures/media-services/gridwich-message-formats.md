---
title: Gridwich message formats
titleSuffix: Azure Reference Architectures
description: Learn about the formats for Gridwich messages.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Resources: Message Formats for Gridwich Operations - Request/Response

## Overview

The document details the specific EventGrid events that form the Request/Response sequence for the different Gridwich operations.

Note that [Gridwich ACK](#m-ack) and [Gridwich Failure](#m-fail) are used differently from the others.  Specifically,

- ACK is sent back to a requester to indicate that the request has been received by Gridwich, but not necessarily processed.  e.g., really that a Request/ACK/Response sequence is being used.
- Failure - while each operation has one or more unique success response events, the Failure event is used by all to communicate request failure.

## Events Supported by Gridwich

#### General

- [Gridwich ACK](#m-ack)
- [Gridwich Failure](#m-fail)

#### [Publishing via AMS](#publishams)

- [Create Asset Locator](#createlocator)
- [Delete Asset Locator](#deletelocator)

#### Encoding - Initiate New Encode Job

- [Encode via AMS v2](#encodeviaamsv2)
- [Encode via AMS v3](#encodeviaamsv3)
- [Encode via CloudPort Workflow](#encodeviacp)
- [Encode via Flip](#encodeviaflip)

Note: the immediate response event from each encoder (aside from an ACK) will either be a [Failure](#m-fail) event or an [Encoding Dispatched](#encodedispatchedresponse) event; the latter indicating successful queuing of the job.  Further progress of that job will be handled by the [Encoding Progress Notification events](#encoderstatus) below.

#### [Encoding - Progress Notifications](#encoderstatus)

Note: all encoders use the same set of status Events.

- [Encoding Scheduled](#encoderstatusscheduled)
- [Encoding in Process](#encoderstatusprocessing)
- [Encoding Completed Successfully](#encoderstatussuccess)
- [Encoding Cancelled](#encoderstatuscancelled)

#### Blob Storage

- **Containers**

  - [Create Container](#createcontainer)
  - [Delete Container](#deletecontainer)
  - [Change Access/Visibility Level](#changecontaineraccess)

 **Blobs**

  - [Set Blob Metadata](#putblobmetadata)
  - [Copy Blob](#copyblob)
  - [Delete Blob](#deleteblob)
  - [Change Blob Access Tier](#changeblobtier)
  - [Get SAS URL for Blob](#getcontentsas)

- **Blob Notifications**

  - [Blob Created Notification](#statusblobcreated)
  - [Blob Deleted Notification](#statusblobdeleted)

#### Other

- [Analyze Blob (e.g. via MediaInfo)](#analyzeblob)
- [Roll Storage Keys](#rollkey)

## Event Grid Messages

**Note:** Details how these messages are consumed resides in the [Concepts: Request and Response Flow](gridwich-request-response-flow.md) document.

## General Notes

### Vocabulary

The descriptions of the specific Event content in the following sections, the JSON property values tend to be the usual string, number or boolean value types.  To assist in understanding the expectations around a particular property, some documentation *"short-hands"* are used, as follows.

If the description indicates that the content is "opaque", the content/format of the value should not be depended upon.

The specific string content types are:

- `GUID-string` - e.g. `"b621f33d-d01e-0002-7ae5-4008f006664e"`<br/>A 16-byte ID value, spelled out to 36 characters (32 hex digits, plus 4 dashes).  Note the lack of curly braces. The value may be upper or lower-case.  This format corresponds to the result of [``System.GUID.ToString("D")``](/dotnet/api/system.guid.tostring).
- `Topic-string` - e.g., `"/subscriptions/5edeadbe-ef64-4022-a3aa-133bfef1d7a2/resourceGroups/gws-shared-rg-sb/providers/Microsoft.EventGrid/topics/gws-gws-egt-sb"`<br/>A string of opaque content.
- `Subject-string` - e.g., `"/blobServices/default/containers/telestreamoutput/blobs/db08122195b66be71db9e54ae04c58df/503220533TAGHD23976fps16x990266772067587.mxf"`<br/>A string of opaque content.
- `EventType-string` - e.g., `"request.operation.requested"`<br/>In general, a string of the form:<br/> {"request"|"response"}.operation[.qualifier].
- `DataVersion-string` - e.g., `"1.0"`<br/>Versioning indicator used by message processors to distinguish different evolutions of the same operation.  Gridwich requires this field.  Which versions an individual EventGridHandler can process can be determined by examination of it's `HandlesEvent` method.
- `URL-string` - an absolute URL, commonly pointing to App Insights logs, etc.  Commonly, these case will show a SAS URL, due to authorization requirements of the target.
- `StorageURL-string` - an absolute URL, commonly pointing to a blob or container in Azure Storage.  Not usually a SAS URL.
- `StorageURL-SAS-string` - an absolute SAS URL, commonly pointing to a blob or container in Azure Storage.
- `OperationContextObject` - e.g. `{ "prodID": 10, "dc": "abc" }`<br/>An abitrary JSON object which is accepted on incoming requests and is echoed back as part of Gridwich response events.
- `Metadata-Dictionary` - a string-to-string JSON object/dictionary with the name/value pairs representing Azure Storge blob metadata.
- `Encoder-Context` - an opaque JSON object of properties specific to a particular encoder.

### Fidelity of Operation Context

Gridwich accepts a JSON OperationContext object as part of request messages.  In general, Gridwich "echoes" that same object back on response messages and does not concern itself with the specific internal structure or content of that context object.

The exception to that is that the response context object may have extra JSON properties compared to the request equivalent.   These "extra" properties are internal to Gridwich and their names always start with the tilde (`~`) character.  Thus, the request properties will always be present on response context object.

Also, like normal JSON, the response object properties may appear in an order different than those in the request object.

See [Gridwich Storage](gridwich-storage-service.md) and [Operation Context](gridwich-operations-sagas.md) for more information regarding Operation Context.

## <a id="m-ack"></a>Gridwich Generic ACK response

#### Gridwich -> Requester (uses [ResponseAcknowledgeDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseAcknowledgeDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "eventType": "request.blob.metadata.create"
    },
    "eventType": "response.acknowledge"
}
```

Note: The `data.eventType` string value will be the top-level `eventType` property from the Request Event being acknowledged.  For example, for a blob analysis request, it would be `"request.blob.analysis.create"`.

## <a id="m-fail"></a>Gridwich Generic Failure response

#### Gridwich -> Requester (uses [ResponseFailureDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseFailureDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "logEventId": 30001,
        "logEventMessage": "the message text for eventId 30001",
        "logRecordId": "GUID-string",
        "logRecordUrl": "URL-string", // AppInsight URL to the logRecordId
        "eventHandlerClassName": "string",
        "handlerId": "GUID-string"
    },
    "eventType": "response.failure"
}
```

Notes:

1. The Failure event does not include the original request `eventType` value.  It does, however include the Opration Context as well as the handler name which was processing the request.
1. The `log*` properties relate to the problem information recorded using the configured App Insights instance.
1. For a limited set of operations (e.g., only [Roll Storage Keys](#rollkey), at the time this was written), the failure event/object differs significantly from the above.  See the individual operation section below for more information.

## <a id="putblobmetadata"></a>Requester asks Gridwich to place some metadata onto a blob

#### Requester -> Gridwich (uses [RequestBlobMetadataCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobMetadataCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "blobMetadata": <Metadata-Dictionary>
    },
    "eventType": "request.blob.metadata.create"
}
```

Note: The `blobMetadata` is an object of string-valued properties representing all of the name/value pairs of the desired blob Metadata.

#### Gridwich -> Requester (uses [ResponseBlobMetadataSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobMetadataSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "blobMetadata": <Metadata-Dictionary>
    },
    "eventType": "response.blob.metadata.success"
}
```

Notes:

1. The `blobMetadata` is an object of string-valued properties representing all of the name/value pairs of the resulting blob Metadata.
1. To later retrieve the current metadata for a blob, see the [Analyze Blob](#analyzeblob) request.

## <a id="analyzeblob"></a>Requester asks Gridwich to perform an analysis of a blob, currently via MediaInfo

#### Requester -> Gridwich (uses [RequestBlobAnalysisCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobAnalysisCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "analyzerSpecificData": {
            "mediaInfo": {
                  "commandLineOptions": {
                    "Complete": "1",
                    "Output": "JSON"
                  }
            }
        }
    },
    "eventType": "request.blob.analysis.create"
}
```

#### Gridwich -> Requester (uses [ResponseBlobAnalysisSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobAnalysisSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "blobMetadata": <Metadata-Dictionary>,
        "analysisResults": <Analysis-Result-Object>
    },
    "eventType": "response.blob.analysis.success"
}
```

Notes:

1. The `analysisResults` object's content is not specified.  It is currently the output of MediaInfo.
1. The `blobMetadata` value is an object of string-valued properties representing all of the name/value pairs of the specified blob's Metadata.  i.e., a string->string dictionary.
1. As normal with Azure Storage, metadata item names (i.e., the keys in `blobMetadata`) must conform to `C#` identifier naming rules.  For more information, see the documentation for the Azure [SetBlobMetadata REST API](/rest/api/storageservices/set-blob-metadata) and the [`C#` naming rules](/dotnet/csharp/language-reference/language-specification/lexical-structure#identifiers).

## <a id="copyblob"></a>Requester asks Gridwich to copy a blob from a target location to a new destination

#### Requester -> Gridwich (uses [RequestBlobCopyDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobCopyDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "sourceUri": "StorageURL-string",
        "destinationUri": "StorageURL-string"
    },
    "eventType": "request.blob.copy"
}
```

#### Gridwich -> Requester (uses [ResponseBlobCopyScheduledDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobCopyScheduledDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "sourceUri": "URL-string",
        "blobMetadata": <Metadata-Dictionary>,
        "destinationUri": "StorageURL-string"
    },
    "eventType": "response.blob.copy.scheduled"
}
```

## <a id="statusblobcreated"></a> Gridwich tells Requester that a Blob was Created, from any source, could be a copy result, or an inbox arrival, or an encode result

#### Gridwich -> Requester (uses [ResponseBlobCreatedSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobCreatedSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "blobMetadata": <Metadata-Dictionary>
    },
    "eventType": "response.blob.created.success"
}
```

## <a id="deleteblob"></a>Requester ask Gridwich to delete a blob

#### Requester -> Gridwich (uses [RequestBlobDeleteDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobDeleteDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
    },
    "eventType": "request.blob.delete"
}
```

#### Gridwich -> Requester (uses [ResponseBlobDeleteScheduledDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobDeleteScheduledDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "blobMetadata": <Metadata-Dictionary>
    },
    "eventType": "response.blob.delete.scheduled"
}
```

## <a id="statusblobdeleted"></a>Gridwich informs Requester that a Blob was Deleted, from any source, could be an explicit request from Requester, or a result of internal operations

#### Gridwich -> Requester (uses [ResponseBlobDeleteSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobDeleteSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string"
    },
    "eventType": "response.blob.delete.success"
}
```

## <a id="getcontentsas"></a>Requester asks Gridwich to return a time-expiration SAS URL for Content

#### Requester -> Gridwich (uses [RequestBlobSasUrlCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobSasUrlCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "secToLive": 1200
    },
    "eventType": "request.blob.sas-url.create"
}
```

#### Gridwich -> Requester (uses [ResponseBlobSasUrlSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobSasUrlSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "sasUrl": "StorageURL-SAS-string"
    },
    "eventType": "response.blob.sas-url.success"
}
```

## <a id="encodeviacp"></a>Requester asks Gridwich to encode via CloudPort Workflow

#### Requester -> Gridwich (uses [RequestCloudPortEncodeCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestCloudPortEncodeCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
          "inputs": [
                {"blobUri": "StorageURL-string" }
          ],
          "outputContainer": "https://<storageaccountname>.blob.core.windows.net/<containername>/",
          "workflowName": "TestWorkflow2",
          "parameters": [ { "prop1": "value1" } ],
           "secToLive": 18000
  },
  "eventType": "request.encode.cloudport.create",
}
```

## <a id="encodeviaflip"></a>Requester asks Gridwich to Encode via Flip

#### Requester -> Gridwich (uses [RequestFlipEncodeCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestFlipEncodeCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
          "inputs": [
                {"blobUri": "StorageURL-string" }
          ],
          "outputContainer": "StorageURL-string", // of the Storage container
          "factoryName": "gws-dev-flip",
          "profiles": "h264",
          "parameters": [ { "prop1": "value1" } ],
           "secToLive": 18000
      },
      "eventType": "request.encode.flip.create"
}
```

#### Example

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": { "progId": 1234 },
          "inputs": [
            {
                "blobUri": "https://gws-sa1.blob.core.windows.net/Vid0001Container/input.mp4"
            }
          ],
          "outputContainer": "https://gws-sa22out.blob.core.windows.net/Out0004/",
          "factoryName": "gws-dev-flip",
          "profiles": "h264",
          "parameters": [ { "someProperty1": "someValue1" } ],
          "secToLive": 18000
      },
      "eventType": "request.encode.flip.create"
}
```

## <a id="encodeviaamsv2"></a>Requester asks Gridwich to Encode via AMS V2

#### Requester -> Gridwich (uses [RequestMediaServicesV2EncodeCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesV2EncodeCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
          "inputs": [
                { "blobUri": "StorageURL-string" }
          ],
          "outputContainer": "https://<storageaccountname>.blob.core.windows.net/<containername>/",
          "presetName": "SpriteOnlySetting" or "SpriteAndThumbnailSetting" or "ThumbnailOnlySetting",
          "thumbnailTimeSeconds": 01.234  // optional, if omitted and a thumbnail is requested,
                                          // will use "{Best}" to select the first non-blank
                                          // frame after the first scene change.
      },
      "eventType": "request.encode.mediaservicesv2.create"
}
```

## <a id="encodeviaamsv3"></a>Requester asks Gridwich to Encode an AMS V3 transform

#### Requester -> Gridwich (uses [RequestMediaServicesV3EncodeCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesV3EncodeCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "inputs": [
         { "blobUri": "https://<storageaccountname>.blob.core.windows.net/<containername>/<filname>" }
        ],
        "outputContainer": "https://<storageaccountname>.blob.core.windows.net/<containername>/",
        "transformName": "audio-mono-aac-video-mbr-no-bframes",
        "timeBasedEncode": {
          "startSeconds": 01.234,
          "endSeconds": 12.345
        }
    },
    "eventType": "request.encode.mediaservicesv3.create"
}
```

`transformName` is one of the [CustomTransforms](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.MediaServicesV3/src/Constants/CustomTransforms.cs)

* `audio-mono-aac-video-mbr-no-bframes`
* `audio-copy-video-mbr-no-bframes`
* `audio-copy-video-mbr`

 The start/end times are always relative to the start of the media file, regardless of the presentation start time.

## <a id="encodedispatchedresponse"></a>Gridwich Encoders Common Response for Successful dispatch of new Encode Request

#### Gridwich -> Requester (uses [ResponseEncodeDispatchedDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip Assigned Job name for Workflow instance, or AMS Job Id."
    },
    "eventType": "response.encode.<encodername>.dispatched"
}
```

currently, `<encodername>` will be one of `cloudport`, `flip`, `mediaservicesv2` or `mediaservicesv3`

## <a id="encoderstatus"></a>Gridwich Encoder Asynchronous Status Messages

There are 4 flavors of Events which all/any of the encoders generate during or at the end of an encoding:

- Scheduled
- Processing
- Success
- Cancelled

Note: in the case of an encode request failing, a Gridwich failure event is generated.

### <a id="encoderstatusscheduled"></a>Encoding Status - Scheduled

#### Gridwich -> Requester (uses [ResponseEncodeScheduledDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext":  <EncoderContext>,
        "workflowJobName": "CloudPort or Flip Assigned Job name for Workflow instance, or AMS Job Id."
    },
    "eventType": "response.encode.<encodername>.scheduled"
}
```

### <a id="encoderstatusprocessing"></a>Encoding Status - Processing

#### Gridwich -> Requester (uses [ResponseEncodeProcessingDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip Assigned Job name for Workflow instance, or AMS Job Id.",
        "currentStatus": "string",
        "percentComplete": 50,
    },
    "eventType": "response.encode.<encodername>.processing"
}
```

### <a id="encoderstatussuccess"></a>Encoding Status - Success

#### Gridwich -> Requester (uses [ResponseEncodeSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip Assigned Job name for Workflow instance, or AMS Job Id.",
        "outputs":[
            { "blobUri": "StorageURL-string" }
        ]
    },
    "eventType": "response.encode.<encodername>.success"
}
```

### <a id="encoderstatuscancelled"></a>Encoding Status - Cancelled

#### Gridwich -> Requester (uses [ResponseEncodeCanceledDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip Assigned Job name for Workflow instance, or AMS Job Id."
    },
    "eventType": "response.encode.<encodername>.canceled"
}
```

## <a id="changeblobtier"></a>Requester asks Gridwich to Change a blob's Storage tier

#### Requester -> Gridwich (uses [RequestBlobTierChangeDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBlobTierChangeDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "accessTier": "string",
        "rehydratePriority": "string"
    },
    "eventType": "request.blob.tier.change"
}
```

Where:

* `accessTier` is one of: `Hot`,`Cool` or `Archive`.
* `rehydratePriority` is one of: `Standard` or `High`.

#### Gridwich -> Requester (uses [ResponseBlobTierChangeSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBlobTierChangeSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "blobUri": "StorageURL-string",
        "accessTier": "string",
        "rehydratePriority": "string"
    },
    "eventType":"response.blob.tier.success"
}
```

## <a id="createcontainer"></a>Requester asks Gridwich to create a blob container, given a storage account and container name

#### Requester -> Gridwich (uses [RequestContainerCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestContainerCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string", // e.g. mySA1
        "containerName": "string"       // e.g. mycontainer
    },
    "eventType": "request.blob.container.create"
}
```

#### Gridwich -> Requester (uses [ResponseContainerCreatedSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseContainerCreatedSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string",
        "containerName": "string"
    },
    "eventType": "response.blob.container.create.success"
}
```

## <a id="deletecontainer"></a>Requester asks Gridwich to delete a blob container given a storage account and container name

#### Requester -> Gridwich (uses [RequestContainerDeleteDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestContainerDeleteDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string",
        "containerName": "string"
    },
    "eventType": "request.blob.container.delete"
}
```

#### Gridwich -> Requester (uses [ResponseContainerDeleteSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseContainerDeleteSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string",
        "containerName": "string"
    },
    "eventType": "response.blob.container.delete.success"
}
```

## <a id="changecontaineraccess"></a>Requester asks Gridwich to change the public access of a container given its name and an accessType

#### Requester -> Gridwich (uses [RequestContainerAccessChangeDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestContainerAccessChangeDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string",
        "containerName": "string",
        "accessType": "string"
    },
    "eventType": "request.blob.container.access.change"
}
```

Where `accessType` is one of `Blob`, `BlobContainer` or `None`.

#### Gridwich -> Requester (uses [ResponseContainerAccessChangeSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseContainerAccessChangeSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "storageAccountName": "string",
        "containerName": "string",
        "accessType": "string"
    },
    "eventType": "response.blob.container.access.change.success"
}
```

## <a id="publishams"></a>Requester asks Gridwich to publish content via Azure Media Services

### <a id="createlocator"></a>Create Asset Locator for Content

#### Requester -> Gridwich (uses [RequestMediaServicesLocatorCreateDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesLocatorCreateDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "containerUri": "",

        "streamingPolicyName": "clearStreamingOnly",
        "contentKeyPolicyName": null,
    or
        "streamingPolicyName": "cencDrmStreaming",
        "contentKeyPolicyName": "cencDrmKey",
    or
        "streamingPolicyName": "multiDrmStreaming",
        "contentKeyPolicyName": "multiDrmKey",

        "timeBasedfilter":{
            "startSeconds": 01.234,
            "endSeconds": 12.345,
        },
        "generateAudioFilters": true
    },
    "eventType": "request.mediaservices.locator.create"
}
```

The start/end times are always relative to the start of the media file, regardless of the presentation start time.

| Streaming Policy      | DRM Technologies                                       |
|-----------------------|--------------------------------------------------------|
| cencDrmStreaming      | Microsoft PlayReady + Google Widevine                  |
| multiDrmStreaming     | Microsoft PlayReady + Google Widevine + Apple FairPlay |

#### Gridwich -> Requester (uses [ResponseMediaServicesLocatorCreateSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseMediaServicesLocatorCreateSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "locatorName": "someNameSetByGridwich",
        "cencKeyId": "someKeyId for PlayReady and Widevine encryption",
        "cbcsKeyId": "someKeyId for FairPlay encryption",
        "dashUri": "someUri which ends with manifest(format=mpd-time . . .)",
        "hlsUri": "someUri which ends with manifest(format=m3u8-aapl . . .)"
    },
    "eventType": "response.mediaservices.locator.create.success"
}
```

### <a id="deletelocator"></a>Delete Asset Locator

#### Requester -> Gridwich (uses [RequestMediaServicesLocatorDeleteDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesLocatorDeleteDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "locatorName": "someName"
    },
    "eventType": "request.mediaservices.locator.delete"
}
```

Where `locatorName` is an opaque string generated by Gridwich.

#### Gridwich -> Requester (uses [ResponseMediaServicesLocatorDeleteSuccessDTO](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseMediaServicesLocatorDeleteSuccessDTO.cs))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "locatorName": "someName"
    },
    "eventType": "response.mediaservices.locator.delete.success"
}
```

## <a id="rollkey"></a>Requester ask Gridwich to rotate to a new Storage Key

**Note**: The *Rollkey* family of Events differs from all others in Gridwich in that:
- while the request accepts an `operationContext` value, none of the response events include it.
- the failure events:
  - are not of the normal Event type `response.failure` (see [above](#m-fail)), but are instead have a type value of `response.rollkey.storage.failure`.
  - do not include any of the normal failure event logging information `log*` data properties.
  - contain an additional data property named `error` which will contain error message text regarding the problem.  A normal Gridwich failure would carry that text on the `logEventMessage` data property.

While these differences may be removed at some future time, the points above reflect the current state of the Azure Logic App which is performing the RollKey operation.  The definition of the Logic App is contained within the [`infrastructure/terraform/keyroller/main.tf`](/infrastructure/terraform/keyroller/main.tf) Terraform file.

#### Requester -> Gridwich (see [infrastructure/terraform/keyroller/main.tf](/infrastructure/terraform/keyroller/main.tf))

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "account": "storageAccountName",
        "keyName": "key1"
    },
    "eventType": "request.rollkey.storage"
}
```

#### Gridwich -> Requester

On Success:

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "account": "storageAccountName",
        "keyName": "key1"
    },
    "eventType": "response.rollkey.storage.success"
}
```

On Failure:

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "1.0",
    "data": {
        "account": "storageAccountName1",
        "keyName": "key1",
        "error": "error message text"
    },
    "eventType": "response.rollkey.storage.failure"
}
```

where `keyName` corresponds to the name of the key as Azure Storage defines it in its ["Get Keys" operation](/rest/api/storagerp/srp_json_get_storage_account_keys).

**Note:** As mentioned above, failure results for this operation are not as complete as normal Gridwich failures.  See [Gridwich Generic Failure request](#m-fail) herein for more information.
