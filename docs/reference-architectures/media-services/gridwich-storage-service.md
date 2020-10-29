---
title: Gridwich Azure Storage Service and context
titleSuffix: Azure Reference Architectures
description: Learn about the characteristics of the Gridwich Azure Storage Service.
author: doodlemania2
ms.date: 10/30/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Gridwich Azure Storage Service

The Gridwich Azure Storage Service ([Gridwich.SagaParticipants.Storage.AzureStorage][StorageService]) provides blob and container operations for Azure Storage Accounts that are configured for Gridwich. Example storage operations are **Create blob**, **Delete container**, **Copy blob**, or **Change storage tier**.

Gridwich exposes most of these operations to external systems within the `Storage.AzureStorage` [saga participant](saga-orchestration.md#saga-participants). Other saga participants use the Storage Service for tasks like copying blobs between different containers or accounts when they set up encoding workflows.

This article describes how the Gridwich Azure Storage Service meets solution requirements and integrates with mechanisms like event handlers. Links point to the corresponding source code, which contains more extensive commentary on the containers, classes, and mechanisms.

## Azure Storage SDK

Gridwich uses classes from the Azure Storage SDK to interact with Azure Storage, rather than hand-crafting REST requests. Within the storage provider, the SDK [BlobBasicClient][SDK_BlobClient] and [BlobContainerClient][SDK_ContainerClient] classes manage storage requests. Gridwich storage mechanisms work for both Azure Storage block blobs and containers. This article applies to both blobs and containers, except where noted.

There are distinct classes and sets of Storage Service operations for blobs and containers, so there's no ambiguity about whether a given storage operation relates to a blob or to a container. The `BlobBasicClient` and `BlobContainerClient` provider classes dispense the two sets of functionality in units called *sleeves* . For more information about sleeves, see [Storage sleeves](#storage-sleeves).

The SDK client classes currently allow only indirect access to the two HTTP headers Gridwich needs to manipulate, `x-ms-client-request-id` for operation context and `ETag` for object version. The following diagram shows the structure between the various classes. The diagram indicates how one set of instances relate to each other. The arrows indicate "has a reference to."

![Diagram showing client object instance relationships between the Storage SDK classes.](media/gridwich-storage.png)

### Pipeline policy

The hook to manipulate the HTTP headers must be set as a pipeline policy instance when creating the client instance. The policy can only be set at client instance creation time, and can't be changed. The storage provider code using the client must be able to manipulate the values used for the header values during execution. The challenge is to make the storage provider and pipeline interact cleanly.

For the Gridwich pipeline policy, see [BlobClientPipelinePolicy class][Pipeline].

### Caching for performance and reuse

TCP connection establishment and authentication create overhead when an SDK client object instance sends its first request to Azure Storage. Multiple calls to the same blob in an external system request, for example **Get Metadata**, then **Delete blob**, compound the overhead.

To mitigate overhead, Gridwich maintains a cache of one client instance for each blob or container, depending on the [SDK classes][SDK_BlobClient] the operation context uses. Gridwich retains this client instance for the duration of an external system request. Gridwich can use the instance for multiple Azure Storage operations against the same blob or container within the request duration.

The Azure SDK-provided client classes require SDK client object instances to be specific to a single blob or container at creation time. The instances also aren't guaranteed safe for simultaneous use on different threads. Since an operation context represents a single request, Gridwich bases caching on the combination of blob or container name with operation context.

This instance reuse, combined with the Azure Storage SDK client structure, requires additional support code to balance efficiency and code clarity.

## Context argument

Almost all the Gridwich Storage Service operations require a special context argument of type [StorageClientProviderContext][SCPC]. This context argument fulfills the following requirements:

- Provides the external system with responses, which include the per-request unique JSON-based operation context value that the external system specified on the Gridwich request. For more information, see [Operation context](gridwich-architecture.md#operation-context).

- Allows Storage Service callers like Gridwich event handlers to control which responses are visible to the external system. This control prevents flooding the external system with irrelevant notification events. For more information, see [Context muting](#context-muting).

- Complies with Azure Storage conventions to ensure coherent requests and responses in an environment that allows a mix of parallel readers and writers. For example, supports [ETag tracking][ETag]. For more information, see [ETags](#etags-for-target-consistency).

### Operation context

Each request event payload to Gridwich must include a JSON object property named [operationContext](https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Requests/RequestBaseDTO.cs). Gridwich must return a corresponding *opaque operation context* as part of each response payload to the external system. This operation context JSON object persists through the lifetime of even very long-running requests. For more information about the operation context, see [Operation context](gridwich-architecture.md#operation-context).

### Storage context

The context for both the blob and container [storage types](#storage-sleeves) is the [StorageClientProviderContext][SCPC], which looks like:

```csharp
    string  ClientRequestID { get; }
    JObject ClientRequestIdAsJObject { get; }
    bool    IsMuted { get; set; }
    string  ETag { get; set; }
    bool    TrackingETag { get; set; }
```

The first two properties are different representations of the operation context from the [StorageClientProviderContext][SCPC] instance. The class has a variety of constructors, including a `copy` constructor. Additional methods include `ResetTo`, to allow in-place state duplication, and a static `CreateSafe` method to ensure that problematic initializations don't throw exceptions. The class also contains special handling for creating contexts based on GUIDs and empty strings.

The Azure Storage Notification [BlobCreated][NotifyC] and [BlobDeleted][NotifyD] handlers, which also process notifications from external agents, require the GUID form.

### Context muting

The `IsMuted` property controls whether the application expects notifications to be published back to the caller, for example to the external system. In a muted operation, resulting events aren't published.

An example is blob copies that an encoder executes to get blobs arranged in Azure Storage as input to an encoding task. The external system isn't concerned about these details, but only about the status of the encoding job and where it can retrieve the encoded outputs. To reflect these concerns, the encoder:

1. Creates a non-muted storage context based on the request operation context, for example `ctxNotMuted`.
1. Creates a muted storage context, for example `ctxMuted`, by either using the [context class][SCPC] copy constructor or making a new instance. Either one will have the same operation context value.  1. Specifies `ctxMuted` for storage operations involved in the encoding setup. The external system doesn't see any indication of these operations.
1. Specifies the `ctxNotMuted` context for storage operations that reflect encoding completion, for example copying an output file to a target container. Gridwich handlers publish these Azure Storage notification events to the external system.

The caller controls the ultimate visibility of operations. Both muted and non-muted operations are based on an equivalent `operationContext` value. The intent of context muting is to make it easier to perform issue diagnosis from event tracing logs, because it's possible to see the storage operations related to a request, regardless of operation muting status.

The [base Response DTO][ResponseBaseDTO] has a boolean property `DoNotPublish`, which event dispatching uses to dictate the final publish/no-publish decision. Event dispatching, in turn, sets the `DoNotPublish` property based on the `IsMuted` property of the context. In practice, muting Storage Service blob or container creation or deletion operations reflects to Azure Storage, which then sets the `clientRequestId` in the Storage Notification Events it presents to the two Gridwich handlers, [Created][NotifyC] and [Deleted][NotifyD]. Those two handlers set `DoNotPublish` to reflect the caller-requested muting.

## Storage sleeves

Gridwich requires that its storage mechanisms must work for both Azure Storage block blobs and containers. There are distinct classes and Storage Service operations for blobs and containers, so there's no ambiguity about whether a given storage operation relates to a blob or to a container.

The two sets of functionality are dispensed in units called *sleeves* by a pair of provider classes, one for [blobs][ProvB] and one for [containers][ProvC]. Sleeves contain instances of storage helper classes that are part of the Azure SDK.

### Sleeve structure

The *sleeve* is a container for the SDK Client object instance and a storage context. Storage provider functions reference the sleeve via the two properties `Client` and `Context`. There is a sleeve type for [blobs][SleeveB] and another for [containers][SleeveC], which have have `Client` properties of type [`BlobBaseClient`][SDK_BlobClient] and [`BlobContainerClient`][SDK_ContainerClient], respectively.

The general sleeve structure for blobs looks like:

```csharp
    BlobBaseClient Client { get; }
    BlobServiceClient Service { get; }
    StorageClientProviderContext Context { get; }
```

The `Service` property on the sleeve is a convenience. Some of the final encoder-related operations that use the [SDK BlobServiceClient class][SDK_ServiceClient] require Storage Account keys. This requirement led to adding a ServiceClient instance to the two existing sleeve types, rather than producing a separate provider.

### Sleeve usage

The storage providers return sleeves. Storage service code looks similar to the following sequences, with types spelled out for clarity:

```csharp
    public bool DeleteBlob(Uri sourceUri, StorageClientProviderContext context)
    {
        // . . .
        StorageBlobClientSleeve sleeve = _blobBaseClientProvider.GetBlobBaseClientForUri(sourceUri, context); // A

        BlobProperties propsIncludingMetadata = sleeve.Client.GetProperties(); // B
        sleeve.Context.TrackingETag = true;   // want to send ETag from GetProperties()
        var wasDeleted = sleeve.Client.DeleteBlob(); // C
        sleeve.Context.TrackingETag = false;
        var someResult = sleeve.Client.AnotherOperation(); // D
        // . . .
    }
```

## ETags for target consistency

Azure Storage uses the HTTP `ETag` header for request sequences that should have target consistency. An example is to ensure that a blob hasn't changed between **Retrieve Metadata** and **Update Metadata** storage requests.

Per standard HTTP usage, this header has an opaque value whose interpretation is that if the header value changes, then the underlying object has also changed. So if a request sends its current `ETag` value for the object, and it doesn't match the current Storage Service `ETag` value, the request immediately fails. If a request doesn't include an `ETag` value, the check is skipped and the request isn't blocked.

### ETags in the Storage Service

The `ETag` is an internal detail between the Gridwich Storage Service and Azure Storage. No other code needs to be aware of the `ETag`. The Storage Service uses the `ETag` for sequences like the **Get Blob Metadata**, **Delete Blob** operations for processing a `BlobDelete Event` request. Using the `ETag` ensures that the **Delete Blob** operation targets exactly the same version of the blob as the **Get Metadata** operation.

To use the `ETag`:

1. Send the **Get Metadata** request with a blank `ETag`.
1. Save the `ETag` value from the response.
1. Add the saved `ETag` value to the **Delete Blob** request.
1. If the two `ETag` values are different, the delete operation fails. The failure implies that some other operation changed the blob between steps 2 and 3. Repeat the process from step 1.

`ETag` is a parameter of constructors and a string property of the [StorageClientProviderContext class][SCPC]. Only the Gridwich-specific [HTTP pipeline policy][Pipeline] manipulates the `ETag` value.

### Control ETag use

The `TrackingETag` property controls whether to send the `ETag` value on the next request. The value `true` means to send an `ETag` if one is available.

An Azure Storage request with an `ETag` value that doesn't match the subject blob or container results in the operation failing. This failure is by design, because `ETag` is the standard HTTP way of expressing "the exact version that the request is targeting." Requests can include the `TrackingETag` property to state that the `ETags` must match, or not include the property to indicate that the `ETag` values don't matter.

The pipeline always retrieves an `ETag` value from an Azure Storage operation if one is present in that REST response. The pipeline always updates the context `ETag` property, if possible, as of the last operation. The `TrackingETag` flag controls only whether the next request from the same client instance sends the value of the `ETag` property. If the `ETag` value is null or empty, the current request sets no HTTP `ETag` value, regardless of the value of `TrackingETag`.

<!--
Why is this here - what is it referring to?
**Notes:**

1. The Gridwich Operation Context is auto-populated into the sleeve context at line A.  `TrackingETag` defaults to false.
1. After line B, sleeve.Context will contain both the `ETag` from line A and retains the same `ClientRequestID` value.
1. Line C will send both the `ETag` value (from Line B) and the same `ClientRequestId`.
1. After Line C, the context will have a new `ETag` value, as returned in the response of `Delete()`.
1. Line D will not send an `ETag` value on the request for `AnotherOpertion()`.
1. After Line D, the context will have a new `ETag` value, as returned in the response of `AnotherOperation()`.
1. Sleeve instances are "dispensed" by ClientProviders.  There is one provider for [Blobs][ProvB] and another for [Containers][ProvC].  The providers are created when the Storage Service is initialized and are available directly to Storage Service methods as above.  Caching of sleeve instances is performed internal to each of the two providers.
1. The Storage Service is currently set as "Transient" in the [Dependency Injection configuration][DIConfig], which implies that the sleeve-based caching will only be on a per-request basis anyway.  While Storage Service would be set to Transient or Scoped, it would likely falter if set as a Singleton due to the cache processing across multiple threads.  See [Storage Service and dependency injection](#storage-service-and-dependency-injection) for more information.
-->
## Alternatives

The following sections describe alternative storage approaches that aren't part of the current Gridwich solution.

### Gridwich AzureStorageManagement class

In conjunction with the sleeve `Service` member, an instance of an [SDK class][SDK_ServiceClient]), Gridwich also has the [AzureStorageManagement][StorMgmt] class. That class is used by the Storage Service `GetConnectionStringForAccount` method and the Telerek encoding `GetStoreByNameAsync` method to obtain storage account keys. The class is currently based on the Fluent framework, and should eventually be superseded with additions to the [SDK ServiceClient class][SDK_ServiceClient]. These additions will allow more focused information retrieval than the wide variety in the [Fluent IAzure interface][IAzure].

### Hide the pipeline policy via subclassing

Subclassing the SDK client types adds two simple properties to the client, one for each HTTP header value, to completely hide the interaction with the pipeline policy. But because of a deep [Moq](https://github.com/moq/moq4) bug, it's not possible to create unit tests via `mock` for these derived types. Gridwich uses `mock`, so didn't use this subclassing approach.

The Moq bug relates to its mishandling of cross-assembly subclassing in the presence of internal-scope virtual functions. The SDK client classes make use of internal-scope virtual functions involving internal-scope types invisible to normal outside users. When Moq tries to create a `mock` of the subclass, which is in one of the Gridwich assemblies, it fails at test execution time as it chokes on finding the internal-scope virtuals in the SDK client classes from which the Gridwich classes are derived. There is no workaround without changes in the Moq Castle proxy generation.

### Storage Service and dependency injection

Gridwich currently registers the Storage Service as a `Transient` dependency injection service. That is, each time dependency injection is asked for the service, it creates a new instance. The current code should also work correctly if the registration is changed to `Scoped`, implying one instance per request, for example the external system's request.

However, there will be issues if the registration is changed to `Singleton`, one instance across the Gridwich Function app. The Gridwich caching mechanism for sleeves and data byte ranges then won't distinguish between different requests. Also, the cache model isn't a check-out one, so the instance isn't removed from the cache while in use. Since the SDK client classes aren't guaranteed thread-safe, coordination would require a number of changes.

The net is that the Gridwich Storage Service, as is, shouldn't be changed to `Singleton` dependency injection registration. Gridwich follows this restriction in [dependency injection registration][StorageServiceDI] and includes a unit test ([CheckThatStorageServiceIsNotASingleton][SSTest]) to enforce it.

[StorageService]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage
[SCPC]: https://github.com/mspnp/gridwich/src/Gridwich.Core/src/Models/StorageClientProviderContext.cs "StorageClientProviderContext.cs"
[ResponseBaseDTO]: https://github.com/mspnp/gridwich/src/Gridwich.Core/src/DTO/Responses/ResponseBaseDTO.cs "ResponseBaseDTO.cs"
[Pipeline]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/BlobClientPipelinePolicy.cs "BlobClientPipelinePolicy.cs"
[SleeveB]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/StorageBlobClientSleeve.cs "StorageBlobClientSleeve.cs"
[SleeveC]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/StorageContainerClientSleeve.cs "StorageContainerClientSleeve.cs"
[ProvB]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/BlobBaseClientProvider.cs "BlobBaseClientProvider.cs"
[ProvC]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/BlobContainerClientProvider.cs "BlobContainerClientProvider.cs"
[NotifyD]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/EventGridHandlers/BlobDeletedHandler.cs "BlobDeletedHandler.cs"
[NotifyC]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/EventGridHandlers/BlobCreatedHandler.cs "BlobCreatedHandler.cs"
[JSONHelpers]: https://github.com/mspnp/gridwich/src/Gridwich.Core/src/Helpers/JSONHelpers.cs "JSONHelpers.cs"
[StorageServiceDI]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/StorageExtensions.cs "StorageExtension.cs"
[SSTest]: https://github.com/mspnp/gridwich/src/Gridwich.Host.FunctionApp/tests/Services/ServiceConfigurationTests.cs "ServiceConfigurationTests.cs"
[StorMgmt]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/Services/AzureStorageManagement.cs "AzureStorageManagement.cs"
[DIConfig]: https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/src/StorageExtensions.cs "Dependency Injection configuration"

[SDK_BlobClient]: /dotnet/api/azure.storage.blobs.specialized.blobbaseclient "Azure SDK - BlobBaseClient class"
[SDK_ContainerClient]: /dotnet/api/azure.storage.blobs.blobcontainerclient "Azure SDK - BlobContainerClient class"
[SDK_ServiceClient]: /dotnet/api/azure.storage.blobs.blobserviceclient "Azure SDK - BlobServiceClient class"
[IAzure]: /dotnet/api/microsoft.azure.management.fluent.iazure "Microsoft.Azure.Management.Fluent.IAzure"
[ETag]: /azure/storage/common/storage-concurrency#managing-concurrency-in-blob-storage "ETags and Blob Storage"