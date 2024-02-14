---
title: Solutions for the game development industry 
titleSuffix: Azure Architecture Center
description: Architectures and ideas for using Azure services to build solutions in the game development industry.
author: martinekuan
ms.author: pnp
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom: fcp 
keywords:
  - Azure
products:
- azure-speech
- azure-functions
- azure-cache-redis
- azure-kubernetes-service
categories:
- ai-machine-learning
- containers
- databases
---

# Solutions for the game development industry

There are 2 billion gamers in the world today. They play a broad range of games, on a broad range of devices. Game creators strive to continuously engage players, spark their imaginations, and inspire them. Microsoft tools and services can help you achieve these goals.

Build, scale, and operate your game on the global, reliable Azure cloud, and incorporate features like multiplayer, leaderboards, translation, and bots. The following video shows how Azure can help bring multiplayer matchmaking into your game.

<br>

> [!VIDEO https://www.youtube.com/embed/mPJUsxRBF4o]

For a video about building AI in gaming, see [Azure Cognitive Services for game development](https://youtu.be/dG57AYkWFB0).

## Architectures for game development

The following articles provide detailed analysis of architectures created and recommended for the game development industry.

### AI in games

| Architecture | Summary |
| ------- | ------- |
|[Image classification](/azure/architecture/example-scenario/ai/intelligent-apps-image-processing)|Use Azure services like the Computer Vision API and Azure Functions to process images. For example, you could classify telemetry data from game screenshots. |
|[Speech to text for gaming](/gaming/azure/reference-architectures/cognitive-speech-to-text?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Help bring everyone into the conversation by using the speech to text cognitive service provided by Azure.|

### Databases for gaming

| Architecture | Summary |
| ------- | ------- |
|[Gaming using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/gaming-using-cosmos-db)|Elastically scale your Azure Cosmos DB database to accommodate unpredictable bursts of traffic and deliver low-latency multiplayer experiences on a global scale.|

### Game streaming

| Architecture | Summary |
| ------- | ------- |
|[Unreal Pixel Streaming](/gaming/azure/reference-architectures/unreal-pixel-streaming-in-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy Unreal Engine's Pixel Streaming technology on Azure. You can use this Epic Games technology to stream remotely deployed interactive 3D applications through a browser.|
|[Deploy Unreal Pixel Streaming](/gaming/azure/reference-architectures/unreal-pixel-streaming-deploying?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy the Unreal Pixel Streaming package on an Azure GPU virtual machine or on multiple virtual machines. |
|[Unreal Pixel Streaming at scale](/gaming/azure/reference-architectures/unreal-pixel-streaming-at-scale?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy Unreal Engine's Pixel Streaming technology at scale on Azure.|

### Rendering

| Architecture | Summary |
| ------- | ------- |
|[3D video rendering](/azure/architecture/example-scenario/infrastructure/video-rendering)|Use Azure Batch to run large-scale 3D video rendering jobs.|
|[Digital image-based modeling](/azure/architecture/example-scenario/infrastructure/image-modeling)|Perform image-based modeling for your game's visual effects.|

## Related resources

- [Browse all our game development architectures](/azure/architecture/browse/?terms=game)
