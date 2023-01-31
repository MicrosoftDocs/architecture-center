---
title: Solutions for the game development industry 
titleSuffix: Azure Architecture Center
description: Architectures and ideas for using Azure services to build solutions in the game development industry.
author: martinekuan
ms.author: architectures
ms.date: 07/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.custom: fcp 
keywords:
  - Azure
products:
- azure-speech-text
- azure-speech-translation
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
|[Content moderation](/gaming/azure/reference-architectures/cognitive-content-moderation?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Learn how to moderate content to maintain a civil, welcoming, and pleasurable experience among players.|
|[Customer service bot for gaming](/gaming/azure/reference-architectures/cognitive-css-bot?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Create a conversational assistant that's tailored to your game and that understands natural language. |
|[Image classification](/azure/architecture/example-scenario/ai/intelligent-apps-image-processing)|Use Azure services like the Computer Vision API and Azure Functions to process images. For example, you could classify telemetry data from game screenshots. |
|[Speech to text for gaming](/gaming/azure/reference-architectures/cognitive-speech-to-text?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Help bring everyone into the conversation by using the speech to text cognitive service provided by Azure.|
|[Text to speech for gaming](/gaming/azure/reference-architectures/cognitive-text-to-speech?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Help bring everyone into the conversation by converting text messages to audio by using text to speech.|
|[Text translation for gaming](/gaming/azure/reference-architectures/cognitive-text-translation?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Accommodate players in various languages by providing both the original message and a translation.|

### Analytics in games

| Architecture | Summary |
| ------- | ------- |
|[In-editor debugging telemetry](/gaming/azure/reference-architectures/analytics-in-editor-debugging?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Gather data from gameplay sessions and display it directly within the game engine.|
|[Non-real time analytics dashboard](/gaming/azure/reference-architectures/analytics-non-real-time-dashboard?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Create a game analytics pipeline to use when you track data that doesn't require real-time analysis.|

### Databases for gaming

| Architecture | Summary |
| ------- | ------- |
|[Gaming using Azure MySQL](/azure/architecture/solution-ideas/articles/gaming-using-azure-database-for-mysql)|Elastically scale your Azure Database for MySQL database to accommodate unpredictable bursts of traffic and deliver low-latency multiplayer experiences on a global scale.|
|[Gaming using Azure Cosmos DB](/azure/architecture/solution-ideas/articles/gaming-using-cosmos-db)|Elastically scale your Azure Cosmos DB database to accommodate unpredictable bursts of traffic and deliver low-latency multiplayer experiences on a global scale.|

### Game streaming

| Architecture | Summary |
| ------- | ------- |
|[Unreal Pixel Streaming](/gaming/azure/reference-architectures/unreal-pixel-streaming-in-azure?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy Unreal Engine's Pixel Streaming technology on Azure. You can use this Epic Games technology to stream remotely deployed interactive 3D applications through a browser.|
|[Deploy Unreal Pixel Streaming](/gaming/azure/reference-architectures/unreal-pixel-streaming-deploying?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy the Unreal Pixel Streaming package on an Azure GPU virtual machine or on multiple virtual machines. |
|[Unreal Pixel Streaming at scale](/gaming/azure/reference-architectures/unreal-pixel-streaming-at-scale?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Deploy Unreal Engine's Pixel Streaming technology at scale on Azure.|

### Leaderboards

| Architecture | Summary |
| ------- | ------- |
|[Leaderboard basics](/gaming/azure/reference-architectures/leaderboard?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Implement a leaderboard that suits your game design.|
|[Non-relational leaderboard](/gaming/azure/reference-architectures/leaderboard-non-relational?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Implement a gaming leaderboard that uses Azure Cache for Redis together with another database to improve data throughput and reduce database load.|
|[Relational leaderboard](/gaming/azure/reference-architectures/leaderboard-relational?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Enable a leaderboard in your large-scale game by using a relational database.|

### Matchmaking

| Architecture | Summary |
| ------- | ------- |
|[Multiplayer matchmaker](/gaming/azure/reference-architectures/multiplayer-matchmaker?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build a multiplayer matchmaker by using serverless Azure functions.|
|[Serverless matchmaker](/gaming/azure/reference-architectures/multiplayer-matchmaker-serverless?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build a serverless multiplayer matchmaker that uses Azure Traffic Manager, Azure Functions, and Azure Event Hubs.|

### Rendering

| Architecture | Summary |
| ------- | ------- |
|[3D video rendering](/azure/architecture/example-scenario/infrastructure/video-rendering)|Use Azure Batch to run large-scale 3D video rendering jobs.|
|[Digital image-based modeling](/azure/architecture/example-scenario/infrastructure/image-modeling)|Perform image-based modeling for your game's visual effects.|

### Scalable gaming servers

| Architecture | Summary |
| ------- | ------- |
|[Asynchronous multiplayer](/gaming/azure/reference-architectures/multiplayer-asynchronous?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build an asynchronous multiplayer by saving game state to a persistent database. |
|[Custom game server scaling](/gaming/azure/reference-architectures/multiplayer-custom-server-scaling?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Containerize your game server with Docker and build a reliable, automated deployment process for servers by using Azure Resource Manager templates, Azure Functions, and DevOps practices.|
|[Multiplayer backend reference architectures](/gaming/azure/reference-architectures/multiplayer?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Learn about a variety of multiplayer backend use cases and implementations that can help you create a cloud solution that works for your game.|
|[Multiplayer hosting with Azure Batch](/gaming/azure/reference-architectures/multiplayer-synchronous-batch?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build a scalable game server that's hosted on Azure Batch.|
|[Multiplayer hosting with Service Fabric](/gaming/azure/reference-architectures/multiplayer-synchronous?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build a scalable game server that's hosted on Azure Service Fabric.|
|[Multiplayer with Azure Container Instances](/gaming/azure/reference-architectures/multiplayer-synchronous-aci?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Learn about a multiplayer solution that automatically scales on demand and is billed per seconds of usage.|
|[Multiplayer with Azure Kubernetes Service](/gaming/azure/reference-architectures/multiplayer-synchronous-aks?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Manage containerized, dedicated game servers by using the Kubernetes orchestrator on Azure.|
|[Serverless asynchronous multiplayer](/gaming/azure/reference-architectures/multiplayer-asynchronous-serverless?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Build a serverless asynchronous multiplayer game on Azure.|

### Server hosting

| Architecture | Summary |
| ------- | ------- |
|[Basic game server hosting](/gaming/azure/reference-architectures/multiplayer-basic-game-server-hosting?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Set up a basic Azure back end that hosts a game server on either Windows or Linux.|
|[LAMP architectures for gaming](/gaming/azure/reference-architectures/general-purpose-lamp?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)|Learn how to  effectively and efficiently deploy an existing LAMP architecture on Azure.|

## Related resources

- [Browse all our game development architectures](/azure/architecture/browse/?terms=game)
