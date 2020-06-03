---
title: Vision classifier model with Azure Custom Vision Cognitive Service
titleSuffix: Azure Example Scenarios
description: Create an image classifier with a solution architecture that includes Microsoft AirSim Drone simulator and Azure Custom Vision Cognitive Service.
author: jocontr
ms.date: 06/03/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
  - fcp
---

# Vision classifier model with Azure Custom Vision Cognitive Service

Azure Cognitive Services offers many possibilities for AI solutions. One of them is [Custom Vision](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/). It allows you to build, deploy, and improve your image classifiers. This architecture uses Custom Vision to classify images taken by a simulated drone. It provides a way to combine AI and IoT.

## Potential use case

Microsoft [**Search and Rescue Lab**](https://github.com/Microsoft/DroneRescue) suggests a hypothetical use case for Custom Vision. The lab explores how to find animals with Custom Vision and a drone. In the lab, a real-world drone is replaced by Microsoft AirSim simulated drone. Using the simulated drone, you create a dataset of pictures of the animals. You then use the dataset of pictures to train a Custom Vision classifier model in Azure. If you fly the drone and take new pictures of the animal, this solution identifies the type of animal in the new picture.

## Architecture

![Diagram of the Search and Rescue Lab architecture to create an image classifier model.](media/drone-rescue.png)

1. AirSim creates a 3D-rendered environment. This simulation provides pictures taken by the drone as the training dataset.
1. Import and tag the dataset in a Custom Vision project. The cognitive service trains and tests the model.
1. Export the model into TensorFlow format so you can use it locally.

## Components

* [Microsoft AirSim Drone simulator](https://github.com/microsoft/AirSim): Built on the [Unreal Engine](https://www.unrealengine.com/). It's open-source, cross-platform, and developed to help AI research. In this architecture, it creates the dataset of pictures used to train the model.
* [Azure Custom Vision Cognitive Service](https://www.customvision.ai): Part of [Azure Cognitive Services]( https://azure.microsoft.com/services/cognitive-services/). In this architecture, it creates an image classifier model.

## Next steps

To deploy this reference architecture, follow the steps described in the [GitHub repo of the **Search and Rescue Lab**](https://github.com/Microsoft/DroneRescue).

## Related resources

* [Learn more about Microsoft AirSim](https://github.com/microsoft/AirSim)
* [Learn more about Azure Custom Vision Cognitive Service](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/)
* [Learn more about Azure Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/)
