---
title: Gridwich media workflow example for a video on-demand system
titleSuffix: Azure Reference Architectures
description: Build a stateless action execution workflow to ingest, process, and deliver media assets. Gridwich is driven by an external saga orchestration system and uses two new methods, Terraform Sandwiches and Event Grid Sandwiches.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# The Gridwich project

A mass media and entertainment conglomerate had built and was maintaining an on-premises video streaming system to deliver marketing video assets like TV pilots to their business partners. The company wanted to replace their on-premises service with a cloud-based solution for ingesting, processing, and publishing video assets to partners. In producing the cloud-based solution, the Microsoft engineering team developed general best practices for processing and delivering media assets on Azure.

The generic Gridwich solution focuses on building a stateless action execution environment driven by an external [saga](gridwich-operations-sagas.md) workflow orchestration system. The pipeline covers media ingestion, processing, and fulfillment using two new methods: Terraform Sandwiches and Event Grid Sandwiches.

Gridwich uses Azure Media Services, Terraform, Azure Functions, Azure Event Grid, Azure Blob Storage, and Azure Logic Apps. The current example is media-specific, although the eventing framework is not. The Gridwich project is a sanitized and generalized media asset pipeline for internal reusability in future media projects. The project includes Terraform deployment.

The company's main goals, aside from being able to take advantage of Azure Cloud capacity, cost, and flexibility, were to:
- Ingest raw video files, process and publish them, and fulfill media requests.
- Significantly enhance both encoding and new intake and distribution capabilities at scale, and with a cleanly-architected approach.
- Implement [continuous integration and continuous delivery (CI/CD)](gridwich-cicd.md) for the media asset management (MAM) pipeline.

## Architecture

![Concepts_The_Gridwich_Project_overview_highlevel](media/gridwich-overview.png)

- The *Terraform Sandwich* starts from a multi-stage [Terraform](https://www.terraform.io/) pattern updated to support [infrastructure as code](/azure/devops/learn/what-is-infrastructure-as-code). The pattern is wholly managed and deployed by Terraform, even when not all the [Azure resources](https://terraform.io/docs/providers/azurerm/) can be created before the software artifacts are deployed.

- The *Event Grid Sandwich* abstracts away remote and long-running processes from the external saga workflow system, by sandwiching those operations between two [Event Grid handlers](gridwich-request-response-flow.md). This sandwich allows the external system to send a request event, monitor progress events, and wait for an eventual success or failure response that may arrive minutes or hours later.

## Components

- Azure Media Services
- Azure Functions
- Azure Event Grid
- Azure Blob Storage
- Azure Logic Apps
- Terraform

## Related resources

- [Terraform starter project for Azure Pipelines](https://github.com/microsoft/terraform-azure-devops-starter).
- Public [Terraform Sandwich sample](https://github.com/Azure-Samples/azure-functions-event-grid-terraform).
- [MediaInfoLib with AzStorage](https://github.com/Azure-Samples/functions-dotnet-core-mediainfo). Azure Functions and console samples using cross-platform .NET Core, to retrieve a report on a media file stored in Azure Storage.
- [AMS V2 REST API samples](https://github.com/Azure-Samples/media-services-v2-dotnet-core-restsharp-sample). A variety of Azure Media Services V2 REST API samples using RestSharp in .NET Core 3.1.
- [EGViewer Blazor](https://github.com/Azure-Samples/eventgrid-viewer-blazor). An EventGrid Viewer application, using Blazor and SignalR, with Azure Active Directory Authorization support.
- [AzFunction with MSI for AzStorage](https://github.com/Azure-Samples/functions-storage-managed-identity). Use Managed Identity between Azure Functions and Azure Storage.
- [AzFunction with EG and TF](https://github.com/Azure-Samples/azure-functions-event-grid-terraform). Subscribe an Azure Function to Event Grid Events via Terraform, using a Terraform Sandwich.
- [Handling Serverless KV Rotation](https://github.com/Azure-Samples/serverless-keyvault-secret-rotation-handling). Handle Key Vault secret rotation changes utilized by an Azure Function, using Event Grid and Logic Apps.
- [Updates to existing sample](https://github.com/Azure-Samples/media-services-v3-dotnet-core-functions-integration/tree/master/Encoding). Updates to media-services-v3-dotnet-core-functions-integration repo.
- [Updates to existing sample](https://github.com/NickDrouin/terraform-azure-pipelines-starter). Updates to terraform-azure-pipelines-starter repo.
- [Updates to existing repo](https://github.com/microsoft/vscode-dev-containers/tree/master/containers/azure-functions-dotnetcore-3.1). Updates to vscode-dev-containers repo, adding Azure Functions v3 and .NET Core 3.1 devcontainer.

