---
title: Media architecture design
description: Get an overview of Azure media technologies, guidance offerings, solution ideas, and reference architectures.
author: EdPrice-MSFT
ms.author: architectures
ms.date: 08/29/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-media-player
  - azure-media-services
  - azure-cdn
  - azure-content-protection
  - azure-encoding
categories:
  - media
---

# Media architecture design

Azure and Azure services can help you deliver high-quality video content to any device. Azure Media Services is a cloud-based platform that enables you to build solutions that achieve broadcast-quality video streaming, enhance accessibility and distribution, analyze content, and more. Gridwich, an event-processing framework for delivering media assets on Azure, was developed by Microsoft for a well-known entertainment conglomerate.

Use the following links to learn more about media services that are available on Azure: 

- [Azure Media Services](https://azure.microsoft.com/services/media-services). Encode, store, and stream video and audio at scale.
- [Azure Media Player](https://azure.microsoft.com/services/media-services/media-player). Use a single player for all your playback needs.
- [Azure Content Delivery Network](https://azure.microsoft.com/services/cdn). Deliver content on a fast, reliable network with global reach.
- [Azure Content Protection](https://azure.microsoft.com/services/media-services/content-protection). Use AES, PlayReady, Widevine, and FairPlay to deliver content with enhanced security.
- [Encoding](https://azure.microsoft.com/services/media-services/encoding). Implement studio-grade encoding at cloud scale.
- [Live and on-demand streaming](https://azure.microsoft.com/services/media-services/live-on-demand). Deliver content to virtually all devices, with scalable streaming.

## Path to production

Start with [Media Services terminology and concepts](/azure/media-services/latest/concepts-overview?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json) for a brief overview of Azure Media Services terminology and concepts.

## Best practices

The Azure Security Benchmark provides recommendations on how you can improve the security of your Azure solutions. For information that's specific to Azure Media Services, see [Azure security baseline for Azure Media Services](/security/benchmark/azure/baselines/media-services-security-baseline?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json).

## Media architectures and solutions

The following sections, organized by category, provide links to sample architectures and other articles.

### Gridwich media processing system

Gridwich is a stateless event-processing framework created by Microsoft. It embodies best practices for processing and delivering media assets on Azure. Gridwich pipelines ingest, process, store, and deliver media assets.

For more information, see the [Gridwich cloud media system](../../reference-architectures/media-services/gridwich-architecture.yml) architecture.

#### Gridwich concepts

- [Clean monolith architecture](../../reference-architectures/media-services/gridwich-clean-monolith.yml)
- [Saga orchestration](../../reference-architectures/media-services/gridwich-saga-orchestration.yml)
- [Project naming and namespaces](../../reference-architectures/media-services/gridwich-project-names.yml)
- [CI/CD pipeline](../../reference-architectures/media-services/gridwich-cicd.yml)
- [Content protection and DRM](../../reference-architectures/media-services/gridwich-content-protection-drm.yml)
- [Media Services setup and scaling](../../reference-architectures/media-services/media-services-setup-scale.yml)
- [Gridwich Azure Storage Service](../../reference-architectures/media-services/gridwich-storage-service.yml)
- [Logging](../../reference-architectures/media-services/gridwich-logging.yml)
- [Gridwich request-response messages](../../reference-architectures/media-services/gridwich-message-formats.yml)
- [Pipeline variables to Terraform flow](../../reference-architectures/media-services/variable-group-terraform-flow.yml)

#### Gridwhich procedures

- [Set up Azure DevOps](../../reference-architectures/media-services/set-up-azure-devops.yml)
- [Run Azure admin scripts](../../reference-architectures/media-services/run-admin-scripts.yml)
- [Set up a local development environment](../../reference-architectures/media-services/set-up-local-environment.yml)
- [Create a cloud environment](../../reference-architectures/media-services/create-delete-cloud-environment.yml)
- [Maintain and rotate keys](../../reference-architectures/media-services/maintain-keys.yml)
- [Test Media Services v3 encoding](../../reference-architectures/media-services/test-encoding.yml)

### Live streaming

- [Live streaming with Azure Media Services v3](/azure/media-services/latest/stream-live-streaming-concept?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Instant broadcasting with serverless code](../../solution-ideas/articles/instant-broadcasting-on-serverless-architecture.yml)
- [Live stream digital media](../../solution-ideas/articles/digital-media-live-stream.yml)

### Video on demand

- [High Availability with Media Services and Video on Demand (VOD)](/azure/media-services/latest/architecture-high-availability-encoding-concept?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Video-on-demand digital media](../../solution-ideas/articles/digital-media-video.yml)

## Stay current with media workloads on Azure

Get the latest updates on [Azure media services and features](https://azure.microsoft.com/updates/?category=media).

## Additional resources

### Example solutions

Here are some additional articles about Azure media solutions:

- [Encoding video and audio with Media Services](/azure/media-services/latest/encode-concept?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Monitor Media Services](/azure/media-services/latest/monitoring/monitor-media-services?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Content protection with dynamic encryption and key delivery](/azure/media-services/latest/drm-content-protection-concept?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

### AWS professionals

- [AWS to Azure services comparison - Media Services](../../aws-professional/services.md#miscellaneous)
