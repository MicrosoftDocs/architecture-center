---
title: Speech-to-text conversion 
titleSuffix: Azure reference architectures
description: This article describes the recommended way to upload audio files and convert the speech content to text.
author: dsk-2015
ms.date: 03/25/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.category:
  - ai-machine-learning
---

# Speech transcription with Azure Cognitive Services

Customer care centers are an integral part of the success of most businesses. You can improve the efficiency of your call centers by using speech AI. Speech recognition and the analysis of high volumes of recorded customer calls can provide businesses with valuable information about current trends, product shortcomings, and successes. Enterprise solutions that use the Speech APIs of Azure Cognitive Services can be implemented to consume and process such high volumes of discrete data.

This reference architecture shows how to build an audio ingestion and *speech-to-text* transcription pipeline for such customer care centers. This pipeline processes batches of recorded audio files, and stores the transcribed text files in Azure Blob Storage. This architecture does not implement real-time speech processing.

This pipeline can later feed into the next phase of your Speech AI implementation, where transcribed text can be processed for recognizing and removing sensitive information, sentiment analysis, and so on.

The reference implementation for this architecture is available on [GitHub](https://github.com/mspnp/cognitive-services-reference-implementation).

## Architecture

![Audio files upload](./_images/audio-files-upload.png)

Businesses can implement this architecture with their Azure account, and allow the client applications access to the pipeline through REST APIs. The application goes through a three-step process to upload an audio file:

1. It authenticates with Azure AD. This is a required step for the first file upload.
2. It calls the REST API to get the SAS token required to access Azure Blob Storage.
3. It then uploads the audio files to a blob container.

The reference client application uses JavaScript to upload the files, as shown in [this example](https://docs.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-nodejs#upload-blobs-to-a-container). Once the file is uploaded, an Event Grid trigger is generated which invokes an Azure Function. The function processes the file using the Azure Cognitive Services Speech APIs. The transcribed text is stored in a separate blob container, ready for consumption into the next phase of the pipeline, that is speech analysis and storage in a database.

The architecture utilizes the following Azure services:

[**Azure Blob Storage**](https://docs.microsoft.com/azure/storage/blobs/) stores objects on the cloud. Blob storage is optimized for storing massive amounts of unstructured data, such as text or binary data. Since sensitive information might be saved in the blob, its access must be secured using authentication methods such as SAS keys.

[**Azure Event Grid**](https://docs.microsoft.com/azure/event-grid/) provides built-in support for efficient event-driven architectures on Azure. When the audio file upload is completed, the Event Grid triggers a [*Blob Created*](https://docs.microsoft.com/azure/event-grid/event-schema-blob-storage#microsoftstorageblobcreated-event) event for the transcription function.

[**Azure Functions**](https://docs.microsoft.com/azure/azure-functions/) provides the event-driven compute capabilities, without the overhead of building the infrastructure. The function in this reference architecture transcribes the speech audio files to text. It is a *serverless* model, meaning the [consumption plan](https://docs.microsoft.com/azure/azure-functions/functions-consumption-costs) is used to host this function.

[**Azure Cognitive Services**](https://docs.microsoft.com/azure/cognitive-services/) is a collection of APIs available to help developers build intelligent applications without the need for extensive AI or data science skills. The transcription function calls the [Cognitive Services Speech-to-text APIs](https://docs.microsoft.com/azure/cognitive-services/speech-service/index-speech-to-text). The output for a sample audio file transcription might look similar to the following metadata: `ResultId:19e70bee8b5348a6afb67817825a9586 Reason:RecognizedSpeech Recognized text:<Text for sample audio.>. Json:{"DisplayText":"Text for sample audio.","Duration":53700000,"Id":"28526a6304da4af1922fedd4edcdddbb","Offset":3900000,"RecognitionStatus":"Success"}`.

[**Azure API Management**](https://docs.microsoft.com/azure/api-management/api-management-key-concepts) provides secure access to REST APIs. Since only clients authenticated with the API Management are able to request a SAS token, this service provides an additional layer of security in this architecture.

[**Azure Active Directory**](https://docs.microsoft.com/azure/active-directory/) or Azure AD provides identity management and secured access to resources in Azure cloud. The client in this architecture first needs to authenticate with Azure AD to be able to access the REST API. The REST API creates the access token for the blob storage, using the Azure AD credentials of the business owner. The client is given the minimum access privileges required to upload the audio files, using [**Role-based Access Control**](https://docs.microsoft.com/azure/role-based-access-control/overview).

[**Azure Key Vault**](https://docs.microsoft.com/azure/key-vault/key-vault-overview) allows secure storage of secrets and keys. This reference architecture stores the account credentials and other secrets required to generate the SAS tokens in the Key Vault. Both the REST APIs and the speech transcription function access this vault to retrieve the secrets.

## Scalability considerations

### Azure Blob Storage

#### Scalability during upload

For high-performing and cost-effective scalable solution, this reference architecture uses the [Valet Key design pattern](https://docs.microsoft.com/azure/architecture/patterns/valet-key). The client application is responsible for the actual data upload. Access to the blob storage is restricted by requiring the SAS token. The client needs to first acquire this token using the REST API. The API in the reference implementation generates a [user delegate SAS token](https://docs.microsoft.com/rest/api/storageservices/create-user-delegation-sas), created using Azure Active Directory credentials of the business owner. For most scenarios, this is more secure and recommended over SAS tokens created using an account key. Read [Types of Shared Access Signatures](https://docs.microsoft.com/rest/api/storageservices/delegate-access-with-shared-access-signature#types-of-shared-access-signatures) for more information on the SAS tokens.

#### Scalability for file size

The reference architecture allows large audio files to be uploaded to the cloud, by dividing them into 4 KB chunks. *Chunking* is a common technique used to upload large blobs, as discussed in details in [this article](https://www.red-gate.com/simple-talk/cloud/platform-as-a-service/azure-blob-storage-part-4-uploading-large-blobs/). The maximum allowed file size that can be uploaded is dictated by the [maximum size limit of a blob](https://azure.microsoft.com/blog/general-availability-larger-block-blobs-in-azure-storage/), which can be up to 4.77 TB.

#### Scalability for storage

Azure Blob Storage can throttle service requests [per blob](https://docs.microsoft.com/azure/storage/blobs/scalability-targets) or [per storage account](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#storage-limits). The blob-level throttling limits may not be a concern in this scenario, since every uploaded file corresponds to a single blob. However, multiple clients uploading multiple files to a single storage account, may exceed its limits. If that is a possibility, consider using multiple storage accounts and partitioning the data objects across them. For a detailed list of scalability considerations for the blob, read the [Performance and scalability checklist for Blob storage](https://docs.microsoft.com/azure/storage/blobs/storage-performance-checklist).

### Event Grid

The function that transcribes the audio files is triggered when the upload is completed. This reference architecture uses Event Grid trigger instead of the Blob trigger, since the latter events might be missed as the number of blobs in a container increases significantly. Missing triggers negatively affects the application throughput and reliability. Read [Blob trigger alternatives](https://docs.microsoft.com/azure/azure-functions/functions-bindings-storage-blob-trigger?tabs=csharp#alternatives) for more information.

### Azure Cognitive Services

The Cognitive Services APIs may have request limits based on the subscription tier. Consider containerizing these APIs to avoid throttling large volume processing. Containers give you flexibility of deployment, whether on cloud or on-premises. Side-effects of new version roll-outs can also be mitigated by using containers. Read [Container support in Azure Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/cognitive-services-container-support) for more information.

## Security considerations

Many of the [security considerations for a serverless web applications](https://docs.microsoft.com/azure/architecture/reference-architectures/serverless/web-app#security-considerations) apply to this reference architecture. The following sections discuss the differences.

### Azure Active Directory

The audio files stored in the blob may contain sensitive customer data. If multiple clients are using this solution, it is important to restrict access to these files. This reference architecture uses SAS tokens to protect these files from outside attacks. These tokens, called the user delegate SAS tokens, are created using the service owner's Azure AD credentials.

A SAS token allows you to control the following:

- What resources clients can access, since it is created per resource.
- What permissions clients can have while accessing these resources, using [role-based access control](https://docs.microsoft.com/rest/api/storageservices/create-user-delegation-sas#assign-permissions-with-rbac). It is recommended to give minimal required permissions. The clients in this architecture have *Write-Only* access to the blobs. This prevents them from reading other clients' audio files, either accidentally or maliciously.
- When do the individual tokens expire. This limits the window of exposure to the token, hence limiting the possibility of unauthorized access to the resource. For larger files, the SAS token may expire before the upload is completed. The client can request multiple tokens for the same file. Since only authenticated clients can do so, multiple requests of these tokens do not affect overall security.

Read [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-sas-overview) for an in-depth discussion on SAS tokens. Also see [Create a user delegation SAS](https://docs.microsoft.com/rest/api/storageservices/create-user-delegation-sas) to learn more about a user delegate SAS token.

### API Management

In addition to restricting access to resources using SAS tokens, this reference architecture provides an additional layer of security using API Management. Clients need to authenticate with API Management before requesting the SAS tokens. API Management has [built-in access controls](https://docs.microsoft.com/azure/api-management/api-management-security-controls) for the REST API. This additional layer of security is recommended since the uploaded data may contain sensitive information.

When several clients upload in parallel, API Management serves multiple purposes such as:

- Enforce usage quotas and rate limits.
- Validate [OAuth 2.0](https://docs.microsoft.com/azure/api-management/api-management-howto-oauth2) tokens for authentication.
- Enable [CORS or cross-origin resource sharing](https://docs.microsoft.com/azure/api-management/api-management-cross-domain-policies#CORS).
- Cache responses.
- Monitor and log requests.

## Resiliency considerations

For an extremely large number of events, Event Grid may fail to trigger the function. Such missed events are typically added to a *dead letter container*. Consider making the architecture more resilient by having an additional *supervisor* function. This function can periodically wake up on a timer trigger. It then can find out and process missed events, either from the dead letter container, or by comparing the blobs between the *upload* and *transcribe* containers. This pattern is similar to the [Scheduler Agent Supervisor pattern](https://docs.microsoft.com/azure/architecture/patterns/scheduler-agent-supervisor). This reference architecture does not implement this pattern for simplicity. Read the [Event Grid message delivery and retry](https://docs.microsoft.com/azure/event-grid/delivery-and-retry) policies for more information on how Event Grid handles failures.

Another way to improve resiliency is to use [Azure Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/) instead of Event Grid. This model will sequentially process the file uploads. The client will signal the Service Bus when an upload is completed. The Service Bus will then invoke the function to transcribe the uploaded file. This model is more reliable, however it will also have less throughput than an event-based architecture. Carefully consider which architecture applies to your scenario and application.

## Deploy the solution

To deploy the reference implementation for this architecture, see [the GitHub readme](https://github.com/mspnp/cognitive-services-reference-implementation/blob/master/README.md).

## Next steps

The transcribed speech can be processed with built-in speech analysis features provided by Azure Cognitive Services. To explore, read [the documentation on Speech APIs](https://docs.microsoft.com/azure/cognitive-services/speech-service/).
