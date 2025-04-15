---
title: Choose Azure AI image and video processing technology
description: Learn about vision capabilities of Azure AI services. Learn which service to use for a specific use cases.
author: ritesh-modi
ms.author: rimod
categories:
  - ai-machine-learning
  - analytics
ms.date: 03/20/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
products:
  - ai-services
ms.custom:
  - analytics
  - guide
  - arb-aiml
---

# Choose an Azure AI image and video processing technology

[Azure AI services](/azure/ai-services/what-are-ai-services) help developers and organizations create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Azure AI services that offer video and image processing capabilities, such as visual analysis and generation of images, object detection, image classification, and facial recognition.

## Services

The following services provide video and image processing capabilities for Azure AI services:

- [Azure OpenAI](#azure-openai)
    - **Use** Azure OpenAI for image generation from natural language using pre-trained generative imaging models. For example, on-demand generation of custom art.
    - **Use** Azure OpenAI when you need to perform non-specific, broad analysis on images. For example, generating accessibility descriptions.
    - **Don't use** Azure OpenAI if you want to use open source image generation models available in Azure Machine Learning.
    - **Don't use** Azure OpenAI if you need to perform specific types of image processing like forms extraction, face recognition, or domain-specialized image characteristic detection. For these scenarios, use or build AI solutions designed specifically trained for those purposes instead.

- [Azure AI Vision](#azure-ai-vision)
    - **Use** Vision service when you need basic optical character recognition (OCR), image analysis, or basic video analysis to detect motion and other events.
    - **Don't use** the Vision service for analysis that large, multi-modal, foundation models already support.
    - **Don't use** the Vision service to moderate content. Use the Content Safety service instead.

- [Azure AI Custom Vision](#azure-ai-custom-vision)
    - **Use** the service when you have specific requirements that the basic Vision service's image analysis can't provide. For example, it's good for recognizing unusual objects, manufacturing defects, or providing detailed custom classifications.
    - **Don't use** the service if you need basic object detection or face detection. Use Face or Vision services instead.
    - **Don't use** the service for basic visual analysis. Use vision capable models from Azure OpenAI or open-source models in Azure Machine Learning instead.

- [Azure AI Face](#azure-ai-face)
    - **Use** Face service when you need to check whether faces are live or spoofed/faked, or to identify, group, or find similar faces.
    - **Don't use** Face service to detect emotions in faces or perform other high-level reasoning about faces. Use multi-modal language models for those tasks instead.

- [Azure AI Video Indexer](#azure-ai-video-indexer)
    - **Use** Azure Video Indexer service for more advanced video analysis related tasks that the Vision service's basic video analysis can't provide.
    - **Don't use** Azure Video Indexer service for basic video analysis tasks like people counting and motion and event detection. The Vision service's basic video analysis is more cost effective for these tasks.

### Azure OpenAI

[Azure OpenAI](/azure/ai-services/openai/index) provides access to OpenAI's powerful language models, including the latest generation of [GPT models](/azure/ai-services/openai/concepts/models). These support visual analysis and generations of images, and [DALL-E](/azure/ai-services/openai/concepts/models#dall-e-models) supports image generation.

### Azure AI Vision

[Azure AI Vision](/azure/ai-services/computer-vision/) provides advanced algorithms that process images and return information based on the visual features you're interested in. It provides four services: OCR, Face service, image and spatial analysis.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Vision service.

| Capability |Description|
|---|---|
| [Optical Character Recognition (OCR)](/azure/ai-services/computer-vision/overview-ocr)|The Optical Character Recognition (OCR) service extracts text from images. You can use the Read API to extract printed and handwritten text from photos and documents. It uses deep-learning-based models and works with text on various surfaces and backgrounds. These include business documents, invoices, receipts, posters, business cards, letters, and whiteboards. The OCR APIs support extracting printed text in [Several languages](/azure/ai-services/computer-vision/language-support).|
|[Image Analysis](/azure/ai-services/computer-vision/overview-image-analysis)| The Image Analysis service extracts many visual features from images, such as objects, faces, and auto-generated text descriptions. With [Image Analysis 4.0](/azure/ai-services/computer-vision/how-to/model-customization) that's based on Florence foundation model, you can also create custom image identifier models. |
|[Video Analysis](/azure/ai-services/computer-vision/intro-to-spatial-analysis-public-preview)| Video Analysis includes video-related features like Spatial Analysis and Video Retrieval. Spatial Analysis analyzes the presence and movement of people on a video feed and produces events that other systems can respond to. |

### Azure AI Custom Vision

[Azure AI Custom Vision service](/azure/ai-services/custom-vision-service/overview) is an image recognition service that lets you build, deploy, and improve your own image identifier models. An image identifier applies labels to images, according to their visual characteristics. Each label represents a classification or object. Custom Vision allows you to specify your own labels and train custom models to detect them.

The Custom Vision service uses a machine learning algorithm to analyze images for custom features. You submit sets of images that do and don't have the visual characteristics you're looking for. Then you label the images with your own labels (tags) at the time of submission. The algorithm trains to this data and calculates its own accuracy by testing itself on the same images. Once you've trained your model, you can test, retrain, and eventually use it in your image recognition app to classify images or detect objects. You can also export the model for offline use.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Custom Vision service.

| Capability | Description |
|----------|-----------------|
| [Image classification](/azure/ai-services/custom-vision-service/getting-started-build-a-classifier) | Predict a category, or *class*, based on a set of inputs, which are called *features*. Calculate a probability score for each possible class and return a label that indicates the class that the object most likely belongs to. To use this model, you need data that consists of features and their labels.|
| [Object detection](/azure/ai-services/custom-vision-service/get-started-build-detector) |  Get the coordinates of an object in an image. To use this model, you need data that consists of features and their labels |

#### Use cases

The following table provides a list of possible use cases for Azure AI Custom Vision service.

| Use case |  Description |
|----------|-----------------|
|[Use Custom Vision with an IoT device to report visual states](/azure/ai-services/custom-vision-service/iot-visual-alerts-tutorial)| use Custom Vision to train a device with a camera to detect visual states. You can run this detection scenario on an IoT device using an exported ONNX model. A visual state describes the content of an image: an empty room or a room with people, an empty driveway or a driveway with a truck, and so on. |
|[Recognize logos in camera pictures](/azure/ai-services/custom-vision-service/logo-detector-mobile)| Analyze photos, looking for specific logos.|

### Azure AI Face

[Azure AI Face service](/azure/ai-services/computer-vision/overview-identity) provides AI algorithms that detect, recognize, and analyze human faces in images. Facial recognition software is important in many scenarios, such as identification, touchless access control, and automatic face blurring for privacy.

#### Capabilities

The following table provides a list of capabilities available in Azure AI Face service.

| Capability | Description |
|----------|-------------|
| [Face detection and analysis](/azure/ai-services/computer-vision/concept-face-detection)| Identify the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face.|
| [Find similar faces](/azure/ai-services/computer-vision/overview-identity#find-similar-faces)|The Find Similar operation does face matching between a target face and a set of candidate faces, finding a smaller set of faces that look similar to the target face. This is useful for doing a face search by image.|
| [Group faces](/azure/ai-services/computer-vision/overview-identity#group-faces)|The Group operation divides a set of unknown faces into several smaller groups based on similarity. Each group is a disjoint proper subset of the original set of faces. It also returns a single "messyGroup" array that contains the face IDs for which no similarities were found.|
| [Identification](/azure/ai-services/computer-vision/overview-identity#identification)|Face identification can address "one-to-many" matching of one face in an image to a set of faces in a secure repository. Match candidates are returned based on how closely their face data matches the query face. |
|[Face recognition operations](/azure/ai-services/computer-vision/overview-identity#face-recognition-operations)| Modern enterprises and apps can use the Face recognition technologies, including Face verification ("one-to-one" matching) and Face identification ("one-to-many" matching) to confirm that a user is who they claim to be.|
|[Liveness detection](/azure/ai-services/computer-vision/overview-identity#liveness-detection)| Liveness detection is an anti-spoofing feature that checks whether a user is physically present in front of the camera. It's used to prevent spoofing attacks using a printed photo, recorded video, or a 3D mask of the user's face.|
#### Use cases

The following table provides a list of possible use cases for Azure AI Face service.

| Use case |  Description |
|----------|---------------|
|Verify user identity.| Verify a person against a trusted face image. This verification could be used to grant access to digital or physical properties. In most cases, the trusted face image could come from a government-issued ID such as a passport or driver's license, or it could come from an enrollment photo taken in person. During verification, liveness detection can play a critical role in verifying that the image comes from a real person, not a printed photo or mask. |
|Face redaction | Redact or blur detected faces of people recorded in a video to protect their privacy.|
|Touchless access control.| Compared to methods like cards or tickets, opt-in face identification enables an enhanced access control experience while reducing the hygiene and security risks from physical media sharing, loss, or theft. Facial recognition assists the check-in process with a human in the loop for check-ins in airports, stadiums, theme parks, buildings, reception kiosks at offices, hospitals, gyms, clubs, or schools.|

### Azure AI Video Indexer

[Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) is a cloud application, part of Azure AI services, built on Azure AI services (such as the Face, Translator, Azure AI Vision, and Speech). It enables you to extract the insights from your videos using Azure AI Video Indexer video and audio models.

#### Capabilities

The following table provides a list of some of the capabilities available in Azure AI Video Indexer service.

| Capability | Description |
|----------|-------------|
| [Multi-language speech identification and transcription](/azure/ai-services/computer-vision/concept-face-detection)|  Identifies the spoken language in different segments from audio. It sends each segment of the media file to be transcribed and then combines the transcription back to one unified transcription. |
| [Face detection](/azure/ai-services/computer-vision/overview-identity#find-similar-faces)|Detects and groups faces appearing in the video.|
| [Celebrity identification](/azure/ai-services/computer-vision/overview-identity#group-faces)| Identifies over 1 million celebrities—like world leaders, actors, artists, athletes, researchers, business, and tech leaders across the globe. The data about these celebrities can also be found on various websites (IMDB, Wikipedia, and so on.)|
| [Account-based face identification](/azure/ai-services/computer-vision/overview-identity#identification)|Trains a model for a specific account. It then recognizes faces in the video based on the trained model.  |
| [Observed people tracking (preview)](/azure/ai-services/computer-vision/overview-identity#identification)|Detects observed people in videos and provides information such as the location of the person in the video frame (using bounding boxes) and the exact timestamp (start, end) and confidence when a person appears.  |
| [Audio transcription](/azure/ai-services/computer-vision/overview-identity#identification)| Converts speech to text over 50 languages and allows extensions. |
| [Language detection](/azure/ai-services/computer-vision/overview-identity#identification)|Identifies the dominant spoken language. |
| [Noise reduction](/azure/ai-services/computer-vision/overview-identity#identification)|Clears up telephony audio or noisy recordings (based on Skype filters). |
| [Translation](/azure/ai-services/computer-vision/overview-identity#identification)|Creates translations of the audio transcript to many different languages.  |

To review more capabilities of the Azure AI Video Indexer service, see the [Azure AI Video Indexer documentation](/azure/azure-video-indexer/video-indexer-overview).

#### Use cases

The following table provides a list of possible use cases for Azure AI Video Indexer service.

| Use case |  Description |
|----------|---------------|
|Deep search| Use the insights extracted from the video to enhance the search experience across a video library. For example, indexing spoken words and faces can enable the search experience of finding moments in a video where a person spoke certain words or when two people were seen together. Search based on such insights from videos is applicable to news agencies, educational institutes, broadcasters, entertainment content owners, enterprise LOB apps, and in general to any industry that has a video library that users need to search against.|
|Content creation| Create trailers, highlight reels, social media content, or news clips based on the insights Azure AI Video Indexer extracts from your content. Keyframes, scenes markers, and timestamps of the people and label appearances make the creation process smoother and easier, enabling you to easily get to the parts of the video you need when creating content.|
|Accessibility| Whether you want to make your content available for people with disabilities or if you want your content to be distributed to different regions using different languages, you can use the transcription and translation provided by Azure AI Video Indexer in multiple languages.|
|Monetization|Azure AI Video Indexer can help increase the value of videos. For example, industries that rely on ad revenue (news media, social media, and so on) can deliver relevant ads by using the extracted insights as additional signals to the ad server.|
|Content moderation|Use textual and visual content moderation models to keep your users safe from inappropriate content and validate that the content you publish matches your organization's values. You can automatically block certain videos or alert your users about the content.|
|Recommendations|Video insights can be used to improve user engagement by highlighting the relevant video moments to users. By tagging each video with additional metadata, you can recommend to users the most relevant videos and highlight the parts of the video that matches their needs.|

## Next steps

- [What is Azure AI Vision?](/azure/ai-services/computer-vision/overview)
- [Learning path: Develop natural language processing solutions with Azure AI Services](/training/paths/develop-language-solutions-azure-ai/)
- [Learning path: Get started with Azure AI Services](/training/paths/get-started-azure-ai)
- [Learning path: Microsoft Azure AI Fundamentals: Computer Vision](/training/paths/explore-computer-vision-microsoft-azure/)
- [Learning path: Create computer vision solutions with Azure AI Vision](/training/paths/create-computer-vision-solutions-azure-ai/)
- [Learning path: Create an image recognition solution with Azure IoT Edge and Azure AI services](/training/modules/create-image-recognition-solution-iot-edge-cognitive-services/)

## Related resources

- [Targeted language processing guide](targeted-language-processing.md)
- [Speech recognition and generation guide](speech-recognition-generation.md)
