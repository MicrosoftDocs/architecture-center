---
title: Types of vision API services
description: Learn about using Cognitive Service for Vision to understand and analyze images and video. Learn which service to use for a specific use case.
author: kruti-m
ms.author: krmeht
categories: 
  - ai-machine-learning
  - analytics 
ms.date: 06/01/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
ms.custom:
  - analytics
  - guide
---

# Types of vision API services

Azure Cognitive Service for Vision is one of the broadest categories in Cognitive Services. You can use the APIs to incorporate vision features like image analysis, face detection, spatial analysis, and optical character recognition (OCR) in your applications, even if you have limited knowledge of machine learning.

## Services

Here are some broad categories of vision APIs:

- [Computer Vision](/azure/cognitive-services/computer-vision/overview) provides advanced algorithms that process images and return information based on the visual features you're interested in. It provides four services: OCR, Face service, Image Analysis, and Spatial Analysis. Form Recognizer is an advanced version of OCR.
- [Custom Vision](/azure/cognitive-services/Custom-Vision-Service/overview) is an image recognition service that you can use to build, deploy, and improve your own image identifier models.
- [Face service](/azure/cognitive-services/computer-vision/overview-identity) provides AI algorithms that detect, recognize, and analyze human faces in images.

## How to choose a service

The following flow chart can help you choose a vision service for your specific use case:

:::image type="content" source="images/cognitive-services-vision-api.png" alt-text="Diagram that shows how to choose a vision service." lightbox="images/cognitive-services-vision-api.png" border="false":::

## Common use cases

- **Computer Vision**
   - **Describe an image.** Analyze an image, evaluate the objects that are detected, and generate a human-readable phrase or sentence that describes the image.
   - **Tag visual features.** Apply tags that are based on a set of thousands of recognizable objects.
   - **Categorize an image.** Categorize images based on their content.
   - **Implement OCR.** Detect printed and handwritten text in images.
   - **Detect image types.** For example, identify clip art images or line drawings.
   - **Detect image color schemes.** Identify the dominant foreground, background, and dominant and accent colors in an image.
   - **Generate thumbnails.** Create small versions of images.
   - **Moderate content.** Detect images that contain adult content or depict gory scenes.
   - **Detect domain-specific content.** Use two specialized domain models:
      - **Celebrities.** Identify thousands of well-known celebrities from the worlds of sports, entertainment, and business.
      - **Landmarks.** Identify famous landmarks, like the Taj Mahal and the Statue of Liberty.
   - **Detect objects.** Identify common objects and return the coordinates of a bounding box.
   - **Detect brands.** Identify logos from an existing database of thousands of globally recognized product logos.
   - **Detect faces.** Detect and analyze human faces in an image. You can determine the age of the subject and return a bounding box that specifies the locations of faces. The facial analysis capabilities of the Computer Vision service are a subset of the ones provided by the dedicated Face service.

- **Custom Vision**
    - **Classify images.** Predict a category, or *class*, based on set of inputs, which are called *features*. Calculate a probability score for each possible class and a label that indicates the class that the object most likely belongs to. To use this model, you need data that consists of features and their labels.
    - **Detect objects.** Get the coordinates of an object in an image. To use this model, you need data that consists of features and their labels.

- **Face services**
    - **Detect faces.** Identify the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face.
    - **Analyze faces.** Return information, such as facial landmarks (nose, eyes, eyebrows, lips, and more). You can use these facial landmarks as features to train a machine learning model that can infer information about people, like their perceived age or emotional state.
    - **Recognize faces.** Train a machine learning model to identify known individuals from their facial features.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ashish Chahuan](https://www.linkedin.com/in/a69171115/) | Senior Cloud Solution Architect
- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta) | Azure Senior Fast-Track Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect 
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332) | Software Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup) | Azure Senior Fast-Track Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps

- [What is Computer Vision?](/azure/cognitive-services/computer-vision/overview)
- [Vision APIs blog post](https://techcommunity.microsoft.com/t5/fasttrack-for-azure/azure-cognitive-services-vision-api-s-azure-ai-applied-services/ba-p/3506727)
- [Learning path: Create a Language Understanding solution with Azure Cognitive Services](/training/paths/create-language-solution-azure-cognitive-services/)
- [Learning path: Provision and manage Azure Cognitive Services](/training/paths/provision-manage-azure-cognitive-services)
- [Learning path: Explore computer vision](/training/paths/explore-computer-vision-microsoft-azure/)
- [Learning path: Create computer vision solutions with Azure Cognitive Services](/training/paths/create-computer-vision-solutions-azure-cognitive-services/)
- [Learning path: Create an image recognition solution with Azure IoT Edge and Azure Cognitive Services](/training/modules/create-image-recognition-solution-iot-edge-cognitive-services/)

## Related resources

- [Types of decision APIs and Applied AI Services](decision-applied-ai.md)
- [Types of language API services](language-api.md)
- [Types of speech API services](speech-api.md)
