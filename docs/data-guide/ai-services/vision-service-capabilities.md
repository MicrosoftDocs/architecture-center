---
title: Azure AI vision capabilities guide 
description: Learn about vision capabilities of Azure AI services. Learn which service to use for a specific use cases.
author: robbagby
ms.author: pnp
categories:
  - ai-machine-learning
  - analytics 
ms.collection: ce-skilling-ai-copilot
ms.date: 09/11/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - ai-services
  - azure-custom-vision
ms.custom:
  - analytics
  - guide
---

# Azure AI vision capabilities guide 

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. 

This article covers Azure AI services that offer vision capabilities. Azure AI Vision is one of the broadest categories in Azure AI services. You can use the APIs to incorporate vision features like image analysis, face detection, spatial analysis, and optical character recognition (OCR) in your applications, even if you have limited knowledge of machine learning.


## Services

The following services provide vision capabilities for Azure AI services:

- [Vision](#vision-service)

- [Custom Vision](#custom-vision-service)

- [Face](#face-service)


## How to choose a service

The following flow chart can help you choose a vision service for your specific use case:

:::image type="content" source="images/ai-services-vision-api.png" alt-text="Diagram that shows how to choose a vision service." lightbox="images/ai-services-vision-api.png" border="false":::


### Vision service

[Azure AI Vision service](/azure/ai-services/computer-vision/) provides advanced algorithms that process images and return information based on the visual features you're interested in. It provides four services: OCR, Face service, Image Analysis, and Spatial Analysis. 

#### Capabilities

The following table provides a list of capabilities available in Azure AI Vision service.

| Capability |Description|
|---|---|
| [Optical Character Recognition (OCR)](/azure/ai-services/computer-vision/overview-ocr)|The Optical Character Recognition (OCR) service extracts text from images. You can use the Read API to extract printed and handwritten text from photos and documents. It uses deep-learning-based models and works with text on various surfaces and backgrounds. These include business documents, invoices, receipts, posters, business cards, letters, and whiteboards. The OCR APIs support extracting printed text in [several languages](/azure/ai-services/computer-vision/language-support).|
|[Image Analysis](/azure/ai-services/computer-vision/overview-image-analysis)| The Image Analysis service extracts many visual features from images, such as objects, faces, adult content, and auto-generated text descriptions. With [Image Analysis 4.0](/azure/ai-services/computer-vision/how-to/model-customization) that's based on Florence foundational model, you can also create custom image identifier models using the latest technology from Azure. |
|[Video Analysis](/azure/ai-services/computer-vision/intro-to-spatial-analysis-public-preview)| Video Analysis includes video-related features like Spatial Analysis and Video Retrieval. Spatial Analysis analyzes the presence and movement of people on a video feed and produces events that other systems can respond to.  [Video Retrieval](/azure/ai-services/computer-vision/how-to/video-retrieval) lets you create an index of videos that you can search with natural language.|


#### Use cases

| Use case | Description |
|----------|-----------------|
| Describe an image.| Analyze an image, evaluate the objects that are detected, and generate a human-readable phrase or sentence that describes the image.|
| Tag visual features.| Apply tags that are based on a set of thousands of recognizable objects.|
| Categorize an image.| Categorize images based on their content.|
| Implement OCR.| Detect printed and handwritten text in images.|
| Detect image types.| For example, identify clip art images or line drawings.|
| Detect color schemes.| Identify the dominant foreground, background, and dominant and accent colors in an image.|
| Generate thumbnails.| Create small versions of images.|
| Moderate content.| Detect images that contain adult content or depict gory scenes.|
| Detect domain-specific content.| Use two specialized domain models: Celebrities from sports, entertainment, and business domains and landmarks; and Landmarks such as Taj Mahal and Statue of Liberty.|
| Detect objects.| Identify common objects and return the coordinates of a bounding box.|
| Detect brands.| Identify logos from an existing database of thousands of globally recognized product logos.|
| Detect faces.| Detect and analyze human faces in an image. You can determine the age of the subject and return a bounding box that specifies the locations of faces. The facial analysis capabilities of the Computer Vision service are a subset of the ones provided by the dedicated Face service.|


### Custom Vision service

[Azure AI Custom Vision service](https://azure.microsoft.com/products/ai-services/ai-custom-vision) is an image recognition service that lets you build, deploy, and improve your own image identifier models. An image identifier applies labels to images, according to their visual characteristics. Each label represents a classification or object. Custom Vision allows you to specify your own labels and train custom models to detect them.

The Custom Vision service uses a machine learning algorithm to analyze images for custom features. You submit sets of images that do and don't have the visual characteristics you're looking for. Then you label the images with your own labels (tags) at the time of submission. The algorithm trains to this data and calculates its own accuracy by testing itself on the same images. Once you've trained your model, you can test, retrain, and eventually use it in your image recognition app to classify images or detect objects. You can also export the model for offline use.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Custom Vision service.

| Capability | Description |
|----------|-----------------|
| Image classification. | Predict a category, or *class*, based on a set of inputs, which are called *features*. Calculate a probability score for each possible class and return a label that indicates the class that the object most likely belongs to. To use this model, you need data that consists of features and their labels.|
| Object detection. |  Get the coordinates of an object in an image. To use this model, you need data that consists of features and their labels |


#### Use cases

The following table provides a list of possible use cases for Azure AI Custom Vision service.

| Use case |  Description |
|----------|-----------------|
|[Use Custom Vision with an IoT device to report visual states](/azure/ai-services/custom-vision-service/iot-visual-alerts-tutorial)| use Custom Vision to train a device with a camera to detect visual states. You can run this detection scenario on an IoT device using an exported ONNX model. A visual state describes the content of an image: an empty room or a room with people, an empty driveway or a driveway with a truck, and so on. | 
|[Recognize Azure service logos in camera pictures](/azure/ai-services/custom-vision-service/logo-detector-mobile)| Analyze photos of Azure service logos and then deploy those services to the user's Azure account.|


### Face service

[Azure AI Face service](/azure/ai-services/computer-vision/overview-identity) provides AI algorithms that detect, recognize, and analyze human faces in images. Facial recognition software is important in many scenarios, such as identification, touchless access control, and automatic face blurring for privacy.


#### Capabilities

| Capability | Description | 
|----------|-------------|
|Detect faces.| Identify the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face.|
| Analyze faces.| Return information, such as facial landmarks (nose, eyes, eyebrows, lips, and more). You can use these facial landmarks as features to train a machine learning model that can infer information about people, like their perceived age or emotional state.|
| Recognize faces.| Train a machine learning model to identify known individuals from their facial features.|


#### Use cases

The following table provides a list of possible use cases for Azure AI Face service.

| Use case |  Description |
|----------|---------------|
|Verify user identity.| Verify a person against a trusted face image. This verification could be used to grant access to digital or physical properties such as a bank account, access to a building, and so on. In most cases, the trusted face image could come from a government-issued ID such as a passport or driver’s license, or it could come from an enrollment photo taken in person. During verification, liveness detection can play a critical role in verifying that the image comes from a real person, not a printed photo or mask. |
|Liveness detection.| Liveness detection is an anti-spoofing feature that checks whether a user is physically present in front of the camera. It's used to prevent spoofing attacks using a printed photo, recorded video, or a 3D mask of the user's face.|
|Touchless access control.| Compared to today’s methods like cards or tickets, opt-in face identification enables an enhanced access control experience while reducing the hygiene and security risks from card sharing, loss, or theft. Facial recognition assists the check-in process with a human in the loop for check-ins in airports, stadiums, theme parks, buildings, reception kiosks at offices, hospitals, gyms, clubs, or schools.|

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Kruti Mehta](https://www.linkedin.com/in/thekrutimehta/) | Azure Senior Fast-Track Engineer

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer
- [Brandon Cowen](https://www.linkedin.com/in/brandon-cowen-1658211b/) | Senior Cloud Solution Architect
- [Oscar Shimabukuro](https://www.linkedin.com/in/oscarshk/) | Senior Cloud Solution Architect
- [Manjit Singh](https://www.linkedin.com/in/manjit-singh-0b922332/) | Software Engineer
- [Christina Skarpathiotaki](https://www.linkedin.com/in/christinaskarpathiotaki/) | Senior Cloud Solution Architect
- [Nathan Widdup](https://www.linkedin.com/in/nwiddup/) | Azure Senior Fast-Track Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure AI Vision?](/azure/ai-services/computer-vision/overview)
- [Learning path: Develop natural language processing solutions with Azure AI Services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai)
- [Learning path: Microsoft Azure AI Fundamentals: Computer Vision](/training/paths/explore-computer-vision-microsoft-azure/)
- [Learning path: Create computer vision solutions with Azure AI Vision](/training/paths/create-computer-vision-solutions-azure-ai/)
- [Learning path: Create an image recognition solution with Azure IoT Edge and Azure AI services](/training/modules/create-image-recognition-solution-iot-edge-cognitive-services/)

## Related resources

- [Azure AI Language capabilities guide](language-service-capabilities.md)
- [Azure AI Speech capabilities guide](speech-service-capabilities.md)
