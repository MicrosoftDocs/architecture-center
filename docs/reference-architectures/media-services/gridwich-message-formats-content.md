

This article details the specific Event Grid events that form the request-response sequence for different Gridwich operations.

## Gridwich events

Gridwich Acknowledgment and Gridwich Failure are different from other Gridwich events. Specifically:

- [Gridwich Acknowledgment (ACK)](#m-ack) indicates that Gridwich has received, but not necessarily processed, the request in a Request-ACK-Response sequence.
- Each operation has one or more unique Success response events, but almost all operations use the same [Gridwich Failure](#m-fail) event to communicate failure.

**Publishing events**

- [Publish via Azure Media Services](#publishams)
- [Create asset locator](#createlocator)
- [Delete asset locator](#deletelocator)

**Encoding events**

- **Initiate new Encode job**

  - [Encode with Media Services V2](#encodeviaamsv2)
  - [Encode with Media Services V3](#encodeviaamsv3)
  - [Encode with CloudPort workflow](#encodeviacp)
  - [Encode with Flip](#encodeviaflip)

  The immediate response event from each encoder, aside from an ACK, is either a [Failure](#m-fail) or an [Encoding dispatched](#encodedispatchedresponse) event that indicates successful queuing of the job. The [Encoding progress notification events](#encoderstatus) handle further progress.

- **Encoding progress notifications**

  All encoders use the same set of [progress notification status events](#encoderstatus).

  - [Encoding scheduled](#encoderstatusscheduled)
  - [Encoding in process](#encoderstatusprocessing)
  - [Encoding completed successfully](#encoderstatussuccess)
  - [Encoding canceled](#encoderstatuscanceled)

**Blob and container storage events**

- **Containers**

  - [Create container](#createcontainer)
  - [Delete container](#deletecontainer)
  - [Change access or visibility level](#changecontaineraccess)

- **Blobs**

  - [Set blob metadata](#putblobmetadata)
  - [Copy blob](#copyblob)
  - [Delete blob](#deleteblob)
  - [Change blob access tier](#changeblobtier)
  - [Get blob SAS URL](#getcontentsas)
  - [Analyze blob](#analyzeblob), for example via MediaInfo

- **Blob notifications**

  - [Blob created](#statusblobcreated)
  - [Blob deleted](#statusblobdeleted)

**Storage keys**

- [Rotate storage keys](#rollkey)

## Operation context

Gridwich accepts a JSON `operationContext` object as part of request messages. In general, Gridwich echoes a corresponding object in response messages and isn't concerned with the specific internal structure or content of the context object.

The exception is that the response context object may have extra JSON properties compared to the request equivalent. These extra properties are internal to Gridwich, and their names always start with the tilde ~ character. The request properties are always present on the response context object.

As in normal JSON, the response object properties may appear in a different order than in the request object.

For more information about operation context, see [Operation context](gridwich-architecture.yml#operation-context) in the Gridwich Architecture article.

## Event Grid messages

For more information about request-response message flow, see [Request flow](gridwich-architecture.yml#request-flow).

In the following event descriptions, the JSON property values are the usual string, number, or boolean types. The descriptions use the following specific string content types. If the description includes "opaque," the content and format of the value are arbitrary.

- `GUID-string`, like `"b621f33d-d01e-0002-7ae5-4008f006664e"` is a 16-byte ID value spelled out to 36 characters (32 hex digits, plus 4 dashes). Note the lack of curly braces. The value is case-insensitive. This format corresponds to the result of [System.GUID.ToString("D")](/dotnet/api/system.guid.tostring).
- `Topic-string`, like `"/subscriptions/5edeadbe-ef64-4022-a3aa-133bfef1d7a2/resourceGroups/gws-shared-rg-sb/providers/Microsoft.EventGrid/topics/gws-gws-egt-sb"`, is a string of opaque content.
- `Subject-string`, like `"/blobServices/default/containers/telestreamoutput/blobs/db08122195b66be71db9e54ae04c58df/503220533TAGHD23976fps16x990266772067587.mxf"`, is a string of opaque content.
- `EventType-string`, like `"request.operation.requested"` is generally a string of the form: `{"request"|"response"}.operation[.qualifier]`.
- `DataVersion-string`, like `"1.0"`, is a versioning indicator that message processors use to distinguish different evolutions of the same operation. Gridwich requires this field. The `HandlesEvent` method determines which versions an individual Event Grid Handler can process.
- `URL-string` is an absolute URL that often points to Application Insights logs. These strings are usually a SAS URL, due to target authorization requirements.
- `StorageURL-string` is an absolute URL that often points to an Azure Storage Blob or container. This string isn't usually a SAS URL.
- `StorageURL-SAS-string` is an absolute SAS URL that often points to an Azure Storage Blob or container.
- `OperationContextObject`, like `{ "prodID": 10, "dc": "abc" }`, is an arbitrary JSON object that is accepted on incoming requests and echoed back as part of Gridwich response events.
- `Metadata-Dictionary` is a string-to-string JSON object dictionary with the name-value pairs representing Azure Storage Blob metadata.
- `Encoder-Context` is an opaque JSON object of properties specific to a particular encoder.

### <a id="m-ack"></a>Gridwich generic ACK response

**Gridwich** > **Requester**, uses [ResponseAcknowledgeDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseAcknowledgeDTO.cs).

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

The `data.eventType` string value is the top level `eventType` property from the Request event. For example, for a blob analysis request, the `data.eventType` string value is`request.blob.analysis.create`.

### <a id="m-fail"></a>Gridwich generic Failure response

**Gridwich** > **Requester**, uses [ResponseFailureDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseFailureDTO.cs).

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

The Failure event doesn't include the original request `eventType` value, but does include the operation context and the handler name that was processing the request. The `log*` properties relate to the problem information that the configured Application Insights instance recorded.

For a limited set of operations, the Failure event object differs significantly from the preceding message. For more information, see [Roll storage keys](#rollkey).

### <a id="putblobmetadata"></a>Requester asks Gridwich to place some metadata onto a blob

**Requester** > **Gridwich** uses [RequestBlobMetadataCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobMetadataCreateDTO.cs).

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

The `blobMetadata` is an object of string-valued properties representing all of the name-value pairs of the desired blob metadata.

**Gridwich** > **Requester** uses [ResponseBlobMetadataSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobMetadataSuccessDTO.cs).

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

To later retrieve the current metadata for a blob, see the [Analyze blob](#analyzeblob) request.

### <a id="analyzeblob"></a>Requester asks Gridwich to perform an analysis of a blob via MediaInfo

**Requester** > **Gridwich** uses [RequestBlobAnalysisCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobAnalysisCreateDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseBlobAnalysisSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobAnalysisSuccessDTO.cs).

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

The `analysisResults` object's content isn't specified. In the current project, it's the MediaInfo output.

The `blobMetadata` value is a string > string dictionary.object of string-valued properties representing all of the name-value pairs of the specified blob's metadata.

As usual with Azure Storage, metadata item names must conform to C# identifier naming rules. For more information, see the Azure [SetBlobMetadata REST API](/rest/api/storageservices/set-blob-metadata) and the [C# naming rules](/dotnet/csharp/language-reference/language-specification/lexical-structure#identifiers).

### <a id="copyblob"></a>Requester asks Gridwich to copy a blob to a new destination

**Requester** > **Gridwich** uses [RequestBlobCopyDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobCopyDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseBlobCopyScheduledDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobCopyScheduledDTO.cs).

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

### <a id="statusblobcreated"></a>Gridwich tells requester that it created a blob

Gridwich could have created the blob from any source, like a copy result, inbox arrival, or encode result.

**Gridwich** > **Requester**, uses [ResponseBlobCreatedSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobCreatedSuccessDTO.cs).

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

### <a id="deleteblob"></a>Requester asks Gridwich to delete a blob

**Requester** > **Gridwich** uses [RequestBlobDeleteDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobDeleteDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseBlobDeleteScheduledDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobDeleteScheduledDTO.cs).

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

### <a id="statusblobdeleted"></a>Gridwich informs requester that it deleted a blob

The blob deletion can come from any source, like an explicit request from a requester or a result of internal operations.

**Gridwich** > **Requester**, uses [ResponseBlobDeleteSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobDeleteSuccessDTO.cs).

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

### <a id="getcontentsas"></a>Requester asks Gridwich to return a time-expiration content SAS URL

**Requester** > **Gridwich** uses [RequestBlobSasUrlCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobSasUrlCreateDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseBlobSasUrlSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobSasUrlSuccessDTO.cs).

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

### <a id="encodeviacp"></a>Requester asks Gridwich to encode via CloudPort Workflow

**Requester** > **Gridwich**, uses [RequestCloudPortEncodeCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestCloudPortEncodeCreateDTO.cs).

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

### <a id="encodeviaflip"></a>Requester asks Gridwich to encode via Flip

**Requester** > **Gridwich**, uses [RequestFlipEncodeCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestFlipEncodeCreateDTO.cs).

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

#### Example of RequestFlipEncodeCreateDTO

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

### <a id="encodeviaamsv2"></a>Requester asks Gridwich to encode via Azure Media Services V2

**Requester** > **Gridwich**, uses [RequestMediaServicesV2EncodeCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesV2EncodeCreateDTO.cs)

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

### <a id="encodeviaamsv3"></a>Requester asks Gridwich to encode a Media Services V3 transform

**Requester** > **Gridwich**, uses [RequestMediaServicesV3EncodeCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesV3EncodeCreateDTO.cs)

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "inputs": [
         { "blobUri": "https://<storageaccountname>.blob.core.windows.net/<containername>/<filename>" }
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

The `transformName` property is one of the [CustomTransforms](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.SagaParticipants.Encode.MediaServicesV3/src/Constants/CustomTransforms.cs):

- `audio-mono-aac-video-mbr-no-bframes`
- `audio-copy-video-mbr-no-bframes`
- `audio-copy-video-mbr`

The start and end times are always relative to the start of the media file, regardless of the presentation start time.

### <a id="encodedispatchedresponse"></a>Gridwich encoders common request successful dispatch response

**Gridwich** > **Requester**, uses [ResponseEncodeDispatchedDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs).

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip assigned job name for workflow instance, or Media Services Job Id."
    },
    "eventType": "response.encode.<encodername>.dispatched"
}
```

The `<encodername>` is one of `cloudport`, `flip`, `mediaservicesv2`, or `mediaservicesv3`.

### <a id="encoderstatus"></a>Gridwich encoder asynchronous status messages

The Gridwich encoders generate four kinds of events during or at the end of encoding:

- Scheduled
- Processing
- Success
- Canceled

An encode request failure generates a Gridwich Failure event.

#### <a id="encoderstatusscheduled"></a>Encoding status scheduled

**Gridwich** > **Requester**, uses [ResponseEncodeScheduledDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs).

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext":  <EncoderContext>,
        "workflowJobName": "CloudPort or Flip assigned job name for workflow instance, or Media Services Job Id."
    },
    "eventType": "response.encode.<encodername>.scheduled"
}
```

#### <a id="encoderstatusprocessing"></a>Encoding status processing

**Gridwich** > **Requester**, uses [ResponseEncodeProcessingDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs).

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip assigned job name for workflow instance, or Media Services Job Id.",
        "currentStatus": "string",
        "percentComplete": 50,
    },
    "eventType": "response.encode.<encodername>.processing"
}
```

#### <a id="encoderstatussuccess"></a>Encoding status success

**Gridwich** > **Requester**, uses [ResponseEncodeSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs).

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip assigned job name for workflow instance, or Media Services Job Id.",
        "outputs":[
            { "blobUri": "StorageURL-string" }
        ]
    },
    "eventType": "response.encode.<encodername>.success"
}
```

#### <a id="encoderstatuscanceled"></a>Encoding status canceled

**Gridwich** > **Requester**, uses [ResponseEncodeCanceledDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseEncodeStatusBaseDTO.cs).

```json
{
    "id": "GUID-string",
    "topic": "Topic-string",
    "subject": "Subject-string",
    "dataVersion": "DataVersion-string",
    "data": {
        "operationContext": <OperationContextObject>,
        "encoderContext": <EncoderContext>,
        "workflowJobName": "CloudPort or Flip assigned job name for workflow instance, or Media Services Job Id."
    },
    "eventType": "response.encode.<encodername>.canceled"
}
```

### <a id="changeblobtier"></a>Requester asks Gridwich to change a blob's storage tier

**Requester** > **Gridwich** uses [RequestBlobTierChangeDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestBlobTierChangeDTO.cs).

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

- The `accessTier` property is `Hot`, `Cool`, or `Archive`.
- The `rehydratePriority` property is `Standard` or `High`.

**Gridwich** > **Requester** uses [ResponseBlobTierChangeSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseBlobTierChangeSuccessDTO.cs)

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

### <a id="createcontainer"></a>Requester asks Gridwich to create a blob container

The request provides the Storage Account and container name.

**Requester** > **Gridwich** uses [RequestContainerCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestContainerCreateDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseContainerCreatedSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseContainerCreatedSuccessDTO.cs).

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

### <a id="deletecontainer"></a>Requester asks Gridwich to delete a blob container

The request provides the Storage Account and container name.

**Requester** > **Gridwich** uses [RequestContainerDeleteDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestContainerDeleteDTO.cs).

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

 **Gridwich** > **Requester** uses [ResponseContainerDeleteSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseContainerDeleteSuccessDTO.cs).

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

### <a id="changecontaineraccess"></a>Requester asks Gridwich to change the public access of a container

The request provides the container name and an `accessType` of `Blob`, `BlobContainer`, or `None`.

**Requester** > **Gridwich** uses [RequestContainerAccessChangeDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestContainerAccessChangeDTO.cs).

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

**Gridwich** > **Requester** uses [ResponseContainerAccessChangeSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseContainerAccessChangeSuccessDTO.cs).

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

### <a id="publishams"></a>Requester asks Gridwich to publish content via Azure Media Services

The request is to create or delete a content asset locator.

#### <a id="createlocator"></a>Create content asset locator

**Requester** > **Gridwich** uses [RequestMediaServicesLocatorCreateDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesLocatorCreateDTO.cs).

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

The start and end times are always relative to the start of the media file, regardless of the presentation start time.

| Streaming policy      | DRM technologies                                       |
|-----------------------|--------------------------------------------------------|
| cencDrmStreaming      | Microsoft PlayReady + Google Widevine                  |
| multiDrmStreaming     | Microsoft PlayReady + Google Widevine + Apple FairPlay |

**Gridwich** > **Requester** uses [ResponseMediaServicesLocatorCreateSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseMediaServicesLocatorCreateSuccessDTO.cs).

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

#### <a id="deletelocator"></a>Delete asset locator

 **Requester** > **Gridwich** uses [RequestMediaServicesLocatorDeleteDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Requests/RequestMediaServicesLocatorDeleteDTO.cs).

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

The `locatorName` property is an opaque string generated by Gridwich.

**Gridwich** > **Requester** uses [ResponseMediaServicesLocatorDeleteSuccessDTO](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/DTO/Responses/ResponseMediaServicesLocatorDeleteSuccessDTO.cs).

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

### <a id="rollkey"></a>Requester asks Gridwich to rotate to a new storage key

The `Rollkey` event family differs from others in Gridwich in that, while the request accepts an `operationContext` value, none of the response events include it.

Failure events aren't of the normal [response.failure](#m-fail) event type, but instead have a type value of `response.rollkey.storage.failure`.

The `response.rollkey.storage.failure` failure events:
- Don't include any of the normal failure event logging information `log` data properties.
- Contain an additional data property named `error` that contains error message text. Other Gridwich failures carry that text on the `logEventMessage` data property.

These points reflect the current state of the Azure Logic App that performs the RollKey operation. The definition of the Logic App is in the [infrastructure/terraform/keyroller/main.tf](https://github.com/mspnp/gridwich/blob/main/infrastructure/terraform/keyroller/main.tf) Terraform file.

The `keyName` corresponds to the key name that Azure Storage defines in its [Get Keys](/rest/api/storagerp/srp_json_get_storage_account_keys) operation.

**Requester** > **Gridwich**

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

**Gridwich** > **Requester**

- Success:

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

- Failure:

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

  Failure results for this operation aren't as complete as [normal Gridwich failures](#m-fail).

## Next steps

Product documentation:

- [Gridwich cloud media system](gridwich-architecture.yml)
- [Azure Media Services v3 overview](/azure/media-services/latest/media-services-overview)
- [What is Azure Blob storage?](/azure/storage/blobs/storage-blobs-overview)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)

Microsoft Learn modules:

- [Explore Azure Storage services](/learn/modules/azure-storage-fundamentals)
- [Introduction to Azure Logic Apps](/learn/modules/intro-to-logic-apps)

## Related resources

- [Gridwich content protection and DRM](gridwich-content-protection-drm.yml)
- [Gridwich operations for Azure Storage](gridwich-storage-service.yml)
- [Logging in Gridwich](gridwich-logging.yml)
