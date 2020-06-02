---
title: Vision classifier model with Microsoft Custom Vision Cognitive Service
titleSuffix: Azure Solution Ideas
author: jocontr
ms.date: 04/27/2020
description: Create an image classifier with a solution architecture that includes Microsoft AirSim Drone simulator and Microsoft Custom Vision Cognitive Service.
ms.custom: AirSim, Custom Vision, Azure Cognitive Services, Search and Rescue Lab, 'https://azure.microsoft.com/solutions/architecture/vision-classifier-model-with-custom-vision/'
---
# Vision classifier model with Microsoft Custom Vision Cognitive Service

[!INCLUDE [header_file](../header.md)]

Azure Cognitive Services offers many possibilities for AI solutions. One of them is Custom Vision, which allows you to build, deploy, and improve your image classifiers. This architecture leverages this tool to classify images taken by a drone. It provides so a way for combining AI and IoT.

## Relevant use cases

Microsoft 'Search and Rescue Lab' suggests a hypothetical use case for Custom Vision. The lab explores how to find animals with this Cognitive Service and a drone–here replaced by Microsoft AirSim simulator. You can create with this simulator a dataset of pictures of the animals. You then use it to train a Custom Vision classifier model in Azure. Given a new picture of the animal set, this solution would identify the animal type.

## Architecture

![Diagram of the Search and Rescue Lab architecture to create an image classifier model. On the left, it's first created a dataset with Microsoft AirSim Drone Simulator. Then, the model is trained in Azure with Microsoft Custom Vision Cognitive Service. Finally, the model is exported in TensorFlow format to be used locally.](../media/DroneRescue.png)

## Data flow

1. AirSim creates a 3D-rendered environment. This simulation provides the training dataset.
1. The dataset is imported and tagged in a Custom Vision project. The cognitive service serves to train and test the model.
1. The model is exported into TensorFlow format. This allows you to use it locally.

## Components

* [Microsoft AirSim Drone simulator](https://github.com/microsoft/AirSim): It’s built on the [Unreal Engine](https://www.unrealengine.com/). Open-source and cross-platform, it’s been developed to help AI research. In this scenario, it serves to create the dataset of pictures that will be used to train the model.
* [Microsoft Custom Vision Cognitive Service](https://www.customvision.ai): Part of [Azure Cognitive Services]( https://azure.microsoft.com/services/cognitive-services/), it creates an image classifier model.

## Deploy the solution

To deploy this reference architecture, follow the steps described in the [GitHub repo of the 'Search and Rescue Lab'](https://github.com/Microsoft/DroneRescue).

## Next steps

[Learn more about Microsoft AirSim](https://github.com/microsoft/AirSim)
[Learn more about Microsoft Custom Vision Cognitive Service](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/)
[Learn more about Azure Cognitive Services](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/)

[!INCLUDE [js_include_file](../../_js/index.md)]
