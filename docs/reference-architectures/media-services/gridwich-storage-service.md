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

The Gridwich Azure Storage Service ([Gridwich.SagaParticipants.Storage.AzureStorage][StorageService]) provides blob and container operations for storage accounts that are configured for Gridwich. Example storage operations are **Create blob**, **Delete container**, **Copy blob**, or **Change storage tier**.

Gridwich exposes most of these operations to external systems within the `Storage.AzureStorage` saga participant. Other saga participants use the service for tasks like copying blobs between different containers or accounts when they set up encoding workflows.

This article describes how the Gridwich Azure Storage Service meets solution requirements and integrates with mechanisms like event handlers. Links point to the corresponding source code, which contains more extensive commentary on the containers, classes, and mechanisms.

## Azure Storage SDK

Gridwich uses classes from the Azure Storage SDK to interact with Azure Storage, rather than hand-crafting REST requests. In particular, within the storage provider, the SDK [BlobBasicClient][SDK_BlobClient] and [BlobContainerClient][SDK_ContainerClient] classes manage storage requests. This article applies to both blobs and containers, except where noted.

These SDK client classes currently allow only indirect access to the two HTTP headers Gridwich needs to manipulate, `x-ms-client-request-id` for operation context and *entity tag (ETag)* for object version.

The following diagram shows the structure between the various classes. The diagram indicates how one set of instances relate to each other. The arrows indicate "has a reference to."

![Instance Relationships](media/gridwich-storage.png)

Gridwich requires that the preceding mechanisms must work for both Azure Storage block blobs and containers. There are distinct classes and Storage Service operations for blobs and containers, so there's no ambiguity about whether a given storage operation relates to a blob or to a container.

The two sets of functionality are dispensed in units called *sleeves* by a pair of provider classes, one for blobs and one for containers. For details, see [Storage sleeves](#storage-sleeves).

## Pipeline policy

The hook to manipulate the HTTP headers must be set as a pipeline policy instance when creating the client instance. The policy can only be set at client instance creation time, and can't be changed. The storage provider code using the client must be able to manipulate the values used for the header values during execution. The challenge is to make the storage provider and pipeline interact cleanly.

For the Gridwich pipeline policy, see [BlobClientPipelinePolicy class][Pipeline].

### Performance and reuse accommodations

There is overhead related to TCP connection establishment and authentication when an SDK client object instance is created and sends its first request to Azure Storage. This overhead is compounded in some cases where a single external system request results in multiple calls to Azure Storage related to the same blob. For example, get metadata, then delete the blob. An additional wrinkle is that the SDK client object instances are specific to a single blob or container at creation time.

To mitigate the overhead, Gridwich maintains a cache of client instances. Gridwich creates one client instance for each blob or container, dictated by the design of the [SDK classes][SDK_BlobClient] used within an operation context. Gridwich retains this client instance for the duration of an external system request. Within that duration, Gridwich may use that same instance for multiple Azure Storage operations against the same blob or container.

The Azure SDK-provided client classes are such that an instance is specific to either a single blob or to a single container. The instances are also not guaranteed safe for simultaneous use on different threads. Since an operation context represents a single request, Gridwich bases caching on the combination of blob or container name with operation context.

This instance reuse, combined with the Azure Storage SDK client structure, requires some additional support code to balance efficiency and code clarity.

## Context argument

Almost all the Gridwich Storage Service operations require a special context argument of type [StorageClientProviderContext][SCPC]. This context argument fulfills the following requirements:

- Provides the external system with responses, which include the per-request unique JSON-based operation context value that the external system specified on the Gridwich request. For more information about operation context, see [Operation context](gridwich-architecture.md#operation-context).

- Allows Storage Service callers like Gridwich event handlers to control which responses are visible to the external system. This control prevents flooding the external system with irrelevant notification events.

- Complies with Azure Storage conventions to ensure coherent requests and responses in an environment that allows a mix of parallel readers and writers. For example, supports [ETag tracking][ETag]. For more information, see [ETags](#etags-for-content-changes).

### Storage context

The context for both the blob and container [storage types](#storage-sleeves) is the same [StorageClientProviderContext][SCPC], which looks like:

```csharp
    string  ClientRequestID { get; }
    JObject ClientRequestIdAsJObject { get; }
    bool    IsMuted { get; set; }
    string  ETag { get; set; }
    bool    TrackingETag { get; set; }
```

The first two properties are different representations of the operation context that was used to initialize the [StorageClientProviderContext][SCPC] instance. The class has a variety of constructors, including a `copy` constructor. Additional methods include `ResetTo`, to allow in-place state duplication, and a static `CreateSafe` method to ensure that problematic initializations don't throw exceptions. The class also contains special handling for creating contexts based on GUIDs and empty strings. The Azure Storage Notification handlers for blob [Created][NotifyC] and [Deleted][NotifyD], which also process notifications arising from external agents, require the GUID form.

### Context muting

The `IsMuted` property controls whether the application expects resulting notifications to be published back to the caller, for example to the external system. A muted operation differs from the unmuted equivalent in that resulting events are not published.

An example is blob copies that an encoder executes to get blobs arranged in Azure Storage as input to an encoding task. The external system isn't concerned about these details, but only about the status of the encoding job and where it can retrieve the encoded outputs. To reflect these concerns, the encoder:

1. Creates a non-muted storage context based on the request operation context, for example `ctxNotMuted`.
1. Creates a muted storage context, for example `ctxMuted`, by either using the [context class][SCPC] copy constructor or making a new instance. Either one will have the same operation context value.  1. Specifies `ctxMuted` for storage operations involved in the setup for encoding. The external system doesn't see any indication of these operations occurring.
1. Specifies the `ctxNotMuted` context for storage operations that reflect encoding completion, for example copying an output file to a target container. Gridwich handlers publish the resulting Azure Storage notification events to the external system.

The caller is in control of the ultimate visibility of operations. The underlying mechanism results in both muted and non-muted operations being based on an equivalent `operationContext` value. The intent of context muting is to make it easier to perform issue diagnosis from event tracing logs, because it's possible to see the storage operations related to a request, regardless of operation muting status.

The [base Response DTO][ResponseBaseDTO] has a boolean property `DoNotPublish`, which event dispatching uses to dictate the final publish/no-publish decision. Event dispatching, in turn, sets the `DoNotPublish` property based on the `IsMuted` property of the context. In practice, muting of Storage Service blob or container creation or deletion operations reflects to Azure Storage, which then sets the `clientRequestId` in the Storage Notification Events it presents to the two Gridwich handlers, [Created][NotifyC] and [Deleted][NotifyD]. Those two handlers set `DoNotPublish` to reflect the caller-requested muting.

## Storage sleeves

Gridwich requires that the preceding mechanisms must work for both Azure Storage block Blobs and Containers. There are distinct classes and Storage Service operations for blobs and containers, so there's no ambiguity about whether a given storage operation relates to a blob or to a container.

The two sets of functionality are dispensed in units called *sleeves* by a pair of provider classes, one for [blobs][ProvB] and one for [containers][ProvC]. Sleeves contain instances of storage helper classes that are part of the Azure SDK.

### Sleeve structure

The *sleeve* is a container for the SDK Client object instance and a storage context. Storage provider functions reference the sleeve via the two properties `Client` and `Context`. The general sleeve structure for blobs looks like:

```csharp
    BlobBaseClient Client { get; }
    BlobServiceClient Service { get; }
    StorageClientProviderContext Context { get; }
```

The `Service` property on the sleeve is a convenience. Some of the final encoder-related operations using the [SDK BlobServiceClient class][SDK_ServiceClient] require Storage account keys. This requirement led to adding a Service client instance to the two existing sleeve types, rather than producing a separate provider.

There is a sleeve type for [blobs][SleeveB] and another for [containers][SleeveC], which have have `Client` properties of type [`BlobBaseClient`][SDK_BlobClient] and [`BlobContainerClient`][SDK_ContainerClient], respectively.

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

## ETags for content changes

For request sequences that should employ target consistency, Azure Storage utilizes the HTTP ETag header. An example is to ensure a blob hasn't changed between "Retrieve Metadata" and "Update Metadata" storage requests.

Per standard HTTP usage, this header has an opaque value for which the interpretation is that if the header changes value, then the underlying object has as well. So a request sends what it thinks is the current ETag value for the object, and if the two ETags don't match, Azure Storage immediately fails the request. If no ETag value is sent on a request, that check is skipped and the request is not blocked.

### ETags in the Storage Service

For Gridwich, the ETag is an internal detail between the Storage Service and Azure Storage. No other code needs to be aware of the ETag. The Storage Service uses the ETag for sequences like the "Get Blob Metadata, Delete Blob" required in processing a BlobDelete Event request. Using the ETag ensures that the Delete Blob request targets exactly the same version of the blob as the Get Metadata request. Using the ETag involves:

1. Sending the Get Metadata request with a blank ETag
1. Saving the ETag value on the response
1. Adding the saved ETag value to the request to Delete the blob
1. A delete failure due to a different ETag implies that some other operation changed the blob between steps 2 and 3. Repeat the process from step 1.

Only the Gridwich-specific [HTTP pipeline policy][Pipeline] manipulates the ETag, aside from it being a parameter of constructors and a string property of the [StorageClientProviderContext class][SCPC].
### Control ETag use

The `TrackingETag` property controls whether to send the `ETag` value on the next request. The value `true` means to send an ETag if one is available.

With Azure Storage, a request including an `ETag` value that doesn't match that of the subject blob or container results in the operation failing. This failure is as intended, because ETag is the standard HTTP way of expressing "the exact version that the request is targeting." Requests have the option to include the `TrackingETag` to state "must match exactly," or not include the tag to indicate "don't care" intent.

The pipeline always retrieves an ETag value from an Azure Storage operation if one is present in that REST response. The `ETag` property of the context is always updated, if possible, as of the last operation. The `TrackingETag` flag controls only whether the value of the `ETag` property is sent on the next request from the same client instance. If the `ETag` value is null or empty, no HTTP ETag value will be set for the current request, regardless of the value of `TrackingETag`.

<!--
Why is this here - what is it referring to?
**Notes:**

1. The Gridwich Operation Context is auto-populated into the sleeve context at line A.  `TrackingETag` defaults to false.
1. After line B, sleeve.Context will contain both the ETag from line A and retains the same `ClientRequestID` value.
1. Line C will send both the `ETag` value (from Line B) and the same `ClientRequestId`.
1. After Line C, the context will have a new `ETag` value, as returned in the response of `Delete()`.
1. Line D will not send an ETag value on the request for `AnotherOpertion()`.
1. After Line D, the context will have a new `ETag` value, as returned in the response of `AnotherOperation()`.
1. Sleeve instances are "dispensed" by ClientProviders.  There is one provider for [Blobs][ProvB] and another for [Containers][ProvC].  The providers are created when the Storage Service is initialized and are available directly to Storage Service methods as above.  Caching of sleeve instances is performed internal to each of the two providers.
1. The Storage Service is currently set as "Transient" in the [Dependency Injection configuration][DIConfig], which implies that the sleeve-based caching will only be on a per-request basis anyway.  While Storage Service would be set to Transient or Scoped, it would likely falter if set as a Singleton due to the cache processing across multiple threads.  See [Storage Service and dependency injection](#storage-service-and-dependency-injection) for more information.
-->
## Alternatives

The following alternatives describe approaches that were already tried but aren't part of the current Gridwich solution.

### Gridwich AzureStorageManagement class

In conjunction with the sleeve `Service` member, an instance of an [SDK class][SDK_ServiceClient]), there is also the Gridwich [AzureStorageManagement][StorMgmt] class. That class is used by the Storage Service `GetConnectionStringForAccount` method and the Telerek encoding's `GetStoreByNameAsync` method to obtain storage account keys. The class is currently based on the Fluent framework and should eventually be superseded with additions to the [SDK ServiceClient class][SDK_ServiceClient], allowing for a more focused information retrieval than the wide variety in the [Fluent IAzure interface][IAzure].

### Hide the pipeline policy via subclassing

Subclassing the SDK client types adds two simple properties to the client, one for each HTTP header value, to completely hide the interaction with the pipeline policy. But because of a deep [Moq](https://github.com/moq/moq4) bug, it's not possible to create unit tests via `mock` for these derived types. Gridwich uses `mock`, so didn't use this subclassing approach.

The Moq bug relates to its mishandling of cross-assembly subclassing in the presence of internal-scope virtual functions. The SDK client classes make use of internal-scope virtual functions involving internal-scope types invisible to normal outside users. When Moq tries to create a `mock` of the subclass, which is in one of the Gridwich assemblies, it fails at test execution time as it chokes on finding the internal-scope virtuals in the SDK client classes from which the Gridwich classes are derived. There is no workaround without Moq changes in their Castle proxy generation.

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