---
title: Azure AI Video Processing Guide
description: Learn about Foundry Tools for video processing and video generation. Understand and compare each service's capabilities and use cases.
author: ritesh-modi
ms.author: rimod
ms.date: 02/05/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI image and video processing and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Foundry Tools that provide video and image processing capabilities, such as visual analysis and generation of images, object detection, image classification, and facial recognition, including:

- [Foundry Models](#foundry-models) provides access to OpenAI's powerful language models, including the latest generation of GPT models with vision capabilities and DALL-E for image generation. Use Foundry Models for image generation from natural language or for broad, nonspecific image analysis.

- [Azure Vision](#azure-vision) is part of Foundry Tools and provides advanced algorithms that process images and return information based on visual features. It includes optical character recognition (OCR), image analysis, and face detection capabilities.

- [Azure AI Custom Vision](#custom-vision) is an image recognition service that you can use to build, deploy, and improve your image identifier models for specific requirements that can't be met by other services.

- [Azure AI Face](#azure-ai-face) provides AI algorithms that detect, recognize, and analyze human faces in images for scenarios such as identification, touchless access control, and automatic face blurring for privacy.

- [Azure AI Video Indexer](#azure-ai-video-indexer) is a comprehensive AI solution that enables organizations to extract deep insights from video (live and uploaded) and audio content using advanced machine learning and generative AI models.

### Foundry Models

[Foundry Models](/azure/ai-foundry/model-inference/concepts/models) provides access to OpenAI's powerful language models, including the latest generation of [GPT models](/azure/ai-services/openai/concepts/models) with vision capabilities. These models support visual analysis and generation of images. [DALL-E](/azure/ai-services/openai/concepts/models#dall-e-models) and other image generation models are also available.

| Use Foundry Models to | Don't use Foundry Models to |
| :----------| :-------------|
| Generate images from natural language descriptions using DALL-E or other generative models. | Perform specific image processing like form extraction or domain-specialized detection. For these tasks, use [Document Intelligence](/azure/ai-services/document-intelligence/overview) or [Custom Vision](#custom-vision). |
| Perform broad, nonspecific analysis on images using vision-capable models like GPT-4o. | Detect, recognize, or analyze human faces. For face-related tasks, use [Azure AI Face](#azure-ai-face). |
| Generate accessibility descriptions for images. | Use open-source image generation models. For open-source models, use Azure Machine Learning. |

### Azure Vision

[Azure Vision](/azure/ai-services/computer-vision/overview) is part of Foundry Tools and provides advanced algorithms that process images and return information based on the visual features you're interested in. Azure Vision includes OCR, image analysis, and face detection capabilities.

| Use Azure Vision to | Don't use Azure Vision to |
| :----------| :-------------|
| Extract printed and handwritten text from images and documents using OCR. | Perform advanced video analysis like transcription, translation, or content summarization. For these tasks, use [Azure AI Video Indexer](#azure-ai-video-indexer). |
| Analyze images to extract visual features like objects, faces, and auto-generated descriptions. | Moderate content for safety. For content moderation, use [Azure AI Content Safety](/azure/ai-services/content-safety/overview). |
| Detect, recognize, and analyze human faces in images. | Perform analysis that large, multimodal foundation models like GPT-4o already support well. |

#### Available Azure Vision features

The following table provides a list of features available in Azure Vision.

| Feature | Description |
| :----------| :-------------|
| [Optical character recognition (OCR)](/azure/ai-services/computer-vision/overview-ocr) | Extracts text from images. You can use the Read API to extract printed and handwritten text from photos and documents. It uses deep-learning-based models and works with text on various surfaces and backgrounds including business documents, invoices, receipts, posters, business cards, letters, and whiteboards. |
| [Image Analysis](/azure/ai-services/computer-vision/overview-image-analysis) | Extracts many visual features from images, such as objects, faces, adult content, and auto-generated text descriptions. You can create custom image identifier models by using [Image Analysis 4.0](/azure/ai-services/computer-vision/how-to/model-customization) based on the Florence foundation model. |
| [Face](/azure/ai-services/computer-vision/overview-identity) | Provides AI algorithms that detect, recognize, and analyze human faces in images. Facial recognition software is important in scenarios such as identification, touchless access control, and face blurring for privacy. |

#### Getting started

Use [Vision Studio](https://portal.vision.cognitive.azure.com/) to quickly try out Azure Vision features in your web browser without writing code.

To build Azure Vision into your app, follow a quickstart:

- [Quickstart: Optical character recognition (OCR)](/azure/ai-services/computer-vision/quickstarts-sdk/client-library)
- [Quickstart: Image Analysis](/azure/ai-services/computer-vision/quickstarts-sdk/image-analysis-client-library)
- [Quickstart: Face](/azure/ai-services/computer-vision/quickstarts-sdk/identity-client-library)

### Custom Vision

[Custom Vision](/azure/ai-services/custom-vision-service/overview) is an image recognition service that you can use to build, deploy, and improve your image identifier models. An image identifier applies labels to images according to their visual characteristics. Each label represents a classification or object. Use Custom Vision to specify your own labels and train custom models to detect them.

| Use Custom Vision to | Don't use Custom Vision to |
| :----------| :-------------|
| Recognize unusual objects and manufacturing defects that standard image analysis can't detect. | Perform basic object detection or face detection. Use [Azure AI Face](#azure-ai-face) or [Azure Vision](#azure-vision) instead. |
| Provide detailed custom classifications for specific business requirements. | Perform basic visual analysis. Use vision-capable models from [Foundry Models](#foundry-models) or open-source models in Azure Machine Learning instead. |
| Train models with your own labeled images for specialized scenarios. | |

Custom Vision uses a machine learning algorithm to analyze images for custom features. You submit sets of images that do have and don't have the visual characteristics that you want. Then you label the images with your own labels, or *tags*, at the time of submission. The algorithm trains to this data and calculates its own accuracy by testing itself on the same images. After you train your model, you can test, retrain, and eventually use the model in your image recognition app to classify images or detect objects. You can also export the model for offline use.

#### Available Custom Vision features

The following table provides a list of features available in Custom Vision.

| Feature | Description |
| :----------| :-------------|
| [Image classification](/azure/ai-services/custom-vision-service/getting-started-build-a-classifier) | Predict a category, or *class*, based on a set of inputs, which are called *features*. Calculate a probability score for each possible class and return a label that indicates the class that the object most likely belongs to. To use this model, you need data that consists of features and their labels. |
| [Object detection](/azure/ai-services/custom-vision-service/get-started-build-detector) | Get the coordinates of an object in an image. To use this model, you need data that consists of features and their labels. |

#### Use cases

The following table provides a list of possible use cases for Custom Vision.

| Use case | Description |
| :----------| :-------------|
| [Use Custom Vision with an IoT device to report visual states](/azure/iot-edge/tutorial-deploy-custom-vision) | Use Custom Vision to train a device that has a camera to detect visual states. You can run this detection scenario on an IoT device by using an exported ONNX model. A visual state describes the content of an image, such as an empty room or a room with people or an empty driveway or a driveway with a truck. |
| [Classify images and objects](/azure/ai-services/custom-vision-service/overview#classification-and-object-detection) | Analyze photos and scan for specific logos by training a custom model. |

### Azure AI Face

[Azure AI Face](/azure/ai-services/computer-vision/overview-identity) provides AI algorithms that detect, recognize, and analyze human faces in images. Facial recognition software is important in various scenarios, such as identification, touchless access control, and automatic face blurring for privacy.

| Use Azure AI Face to | Don't use Azure AI Face to |
| :----------| :-------------|
| Check whether faces are live or spoofed using liveness detection. | Detect emotions in faces or perform other high-level reasoning about faces. Use multimodal language models for those tasks instead. |
| Identify, group, or find similar faces. | Perform general image analysis. Use [Azure Vision](#azure-vision) or [Foundry Models](#foundry-models) instead. |
| Verify a person against a trusted face image for identity confirmation. | |

#### Available Azure AI Face features

The following table provides a list of features available in Azure AI Face.

| Feature | Description |
| :----------| :-------------|
| [Face detection and analysis](/azure/ai-services/computer-vision/concept-face-detection) | Identify the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face. |
| [Find similar faces](/azure/ai-services/computer-vision/overview-identity#find-similar-faces) | The Find Similar operation matches a target face with a set of candidate faces. It identifies a smaller group of faces that closely resemble the target face. This functionality is useful for doing a face search by image. |
| [Group faces](/azure/ai-services/computer-vision/overview-identity#group-faces) | The Group operation divides a set of unknown faces into several smaller groups based on similarity. Each group is a disjoint proper subset of the original set of faces. It also returns a single `messyGroup` array that contains the face IDs for which no similarities were found. |
| [Identification](/azure/ai-services/computer-vision/overview-identity#identification) | Face identification can address one-to-many matching of one face in an image to a set of faces in a secure repository. Match candidates are returned based on how closely their face data matches the query face. |
| [Face recognition operations](/azure/ai-services/computer-vision/overview-identity#face-recognition-operations) | Modern enterprises and apps can use the Azure AI Face recognition technologies, including face verification (or one-to-one matching) and face identification (or one-to-many matching) to confirm that a user is who they claim to be. |
| [Liveness detection](/azure/ai-services/computer-vision/overview-identity#liveness-detection) | Liveness detection is an anti-spoofing feature that checks whether a user is physically present in front of the camera. It's used to prevent spoofing attacks that use a printed photo, recorded video, or a 3D mask of the user's face. |

#### Use cases

The following table provides a list of possible use cases for Azure AI Face.

| Use case | Description |
| :----------| :-------------|
| Verify user identity | Verify a person against a trusted face image. This verification can be used to grant access to digital or physical properties. In most scenarios, the trusted face image comes from a government-issued ID, such as a passport or driver's license, or from an enrollment photo taken in person. During verification, liveness detection can play a crucial role in verifying that the image comes from a real person and not a printed photo or mask. |
| Face redaction | Redact or blur detected faces of people recorded in a video to protect their privacy. |
| Touchless access control | Compared to methods like cards or tickets, opt-in face identification enables an enhanced access control experience while reducing the hygiene and security risks from physical media sharing, loss, or theft. Facial recognition assists the check-in process with a human in the loop for check-ins in airports, stadiums, theme parks, buildings, reception kiosks at offices, hospitals, gyms, clubs, or schools. |

### Azure AI Video Indexer

[Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) is a comprehensive AI solution that enables organizations to extract deep insights from video (live and uploaded) and audio content. It uses advanced machine learning and generative AI models and supports a wide range of capabilities including transcription, translation, object detection, and video summarization. Designed for flexibility, Video Indexer can be used in the cloud or deployed to edge locations via Azure Arc.

| Use Azure AI Video Indexer to | Don't use Azure AI Video Indexer to |
| :----------| :-------------|
| Extract insights from uploaded videos including transcription, translation, and content analysis. | Perform basic video analysis tasks like people counting and motion detection. [Azure Vision](#azure-vision) is more cost-effective for these tasks. |
| Analyze live video streams in real time for retail, manufacturing, or safety scenarios. | Extract text from static images. For OCR on images, use [Azure Vision](#azure-vision). |
| Run video analysis on edge devices with strict data residency or low-latency requirements using Azure Arc. | |

#### Deployment options

Video Indexer offers two deployment options:

| Option | Description |
| :----------| :-------------|
| [Cloud-based Video Indexer](/azure/azure-video-indexer/video-indexer-get-started) | A cloud application built on Azure AI services including Face, Translator, Azure Vision, and Speech. Analyzes video and audio content by running more than 30 AI models to generate rich insights. |
| [Video Indexer enabled by Azure Arc](/azure/azure-video-indexer/arc/azure-video-indexer-enabled-by-arc-overview) | An Azure Arc extension that runs video and audio analysis and generative AI on edge devices. Supports both uploaded and live video streams, enabling real-time analysis directly at the data source. Suited for industries with strict data residency requirements or low-latency operational needs. |

#### Video models

The following table provides a list of video analysis features available in Video Indexer.

| Feature | Description |
| :----------| :-------------|
| [Face detection](/azure/azure-video-indexer/face-detection) | Detects and groups faces appearing in the video. |
| [Celebrity identification](/azure/azure-video-indexer/celebrities-recognition) | Identifies over 1 million celebrities, such as world leaders, actors, artists, athletes, researchers, and business and tech leaders across the globe. |
| [Account-based face identification](/azure/azure-video-indexer/customize-person-model-with-website) | Trains a model for a specific account and recognizes faces in videos based on the trained model. |
| [Observed people detection](/azure/azure-video-indexer/observed-matched-people-insight) | Detects observed people in videos and provides location information using bounding boxes, with exact timestamps and confidence levels. Includes matched person, detected clothing, and featured clothing insights. |
| [Object detection](/azure/azure-video-indexer/object-detection) | Detects unique objects that are tracked so they're recognized if they return to the frame. |
| [OCR](/azure/azure-video-indexer/ocr) | Extracts text from images like pictures, street signs, and products in media files to create insights. |
| [Labels identification](/azure/azure-video-indexer/labels-identification) | Identifies visual objects and actions displayed. |
| [Scene segmentation](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight) | Determines when a scene changes in video based on visual cues. A scene depicts a single event composed of a series of consecutive shots. |
| [Shot detection](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight) | Determines when a shot changes in video based on visual cues. A shot is a series of frames taken from the same motion-picture camera. |
| [Keyframe extraction](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight#keyframe-editorial-shot-type-detection) | Detects stable keyframes in a video. |
| [Slate detection](/azure/azure-video-indexer/slate-detection-insight) | Identifies movie post-production insights including clapperboard detection, digital patterns detection, and textless slate detection. |

#### Audio models

The following table provides a list of audio analysis features available in Video Indexer.

| Feature | Description |
| :----------| :-------------|
| [Audio transcription](/azure/azure-video-indexer/transcription-translation-lid-insight) | Converts speech to text in over 50 languages and supports extensions. |
| [Automatic language detection](/azure/azure-video-indexer/language-support) | Identifies the dominant spoken language. |
| [Multilanguage speech identification](/azure/azure-video-indexer/transcription-translation-lid-insight) | Identifies the spoken language in different segments of audio, sends each segment to be transcribed, and combines them into one unified transcription. |
| [Closed captioning](/azure/azure-video-indexer/video-indexer-output-json-v2#insights) | Creates closed captioning in three formats: VTT, TTML, and SRT. |
| [Two channel processing](/azure/azure-video-indexer/video-indexer-output-json-v2) | Autodetects separate transcripts and merges them into a single timeline. |
| [Noise reduction](/azure/azure-video-indexer/video-indexer-output-json-v2) | Clears up telephony audio or noisy recordings (based on Skype filters). |
| [Speaker enumeration](/azure/azure-video-indexer/video-indexer-output-json-v2) | Maps and understands which speaker spoke which words and when. Sixteen speakers can be detected in a single audio file. |
| [Translation](/azure/azure-video-indexer/language-support) | Creates translations of the audio transcript in many different languages. |
| [Audio effects detection](/azure/azure-video-indexer/audio-effects-detection-insight) | Detects audio effects in nonspeech segments including alarm or siren, dog barking, crowd reactions, gunshot or explosion, laughter, breaking glass, and silence. |

#### Combined audio and video models

The following features analyze both audio and video content:

| Feature | Description |
| :----------| :-------------|
| Keywords extraction | Extracts keywords from speech and visual text. |
| Named entities extraction | Extracts brands, locations, and people from speech and visual text through natural language processing (NLP). |
| Topic inference | Extracts topics based on various keywords using IPTC, Wikipedia, and Video Indexer hierarchical topic ontology. |
| Sentiment analysis | Identifies positive, negative, and neutral sentiments from speech and visual text. |

For more information, see [Video Indexer documentation](/azure/azure-video-indexer/video-indexer-overview).

#### Use cases

**Cloud-based Video Indexer:**

| Use case | Description |
| :----------| :-------------|
| Deep search | Use the insights extracted from the video to enhance the search experience across a video library. For example, indexing spoken words and faces can enable the search experience of finding moments in a video where a person spoke certain words or when two people were seen together. Search based on such insights from videos is applicable to news agencies, educational institutes, broadcasters, entertainment content owners, enterprise line-of-business apps, and generally to any industry that has a video library that users need to search against. |
| Content creation | Create trailers, highlight reels, social media content, or news clips based on the insights Video Indexer extracts from your content. Keyframes, scene markers, and timestamps of people and label appearances simplify the creation process. |
| Accessibility | Make your content available for people with disabilities or distribute content to different regions that use different languages by using the transcription and translation that Video Indexer provides in multiple languages. |
| Monetization | Increase the value of videos. Industries that rely on ad revenue, such as news media and social media, can deliver relevant ads by using the extracted insights as additional signals to the ad server. |
| Content moderation | Use textual and visual content moderation models to keep your users safe from inappropriate content and validate that the content that you publish matches your organization's values. |
| Recommendations | Improve user engagement by highlighting the relevant video moments to users. By tagging each video with extra metadata, you can recommend the most relevant videos and highlight the parts that match user needs. |

**Video Indexer enabled by Azure Arc:**

| Use case | Description |
| :----------| :-------------|
| Retail | Optimize store layouts and improve customer experience and safety. Monitor the number of customers in checkout lines in real time to optimize staffing and reduce wait times. |
| Manufacturing | Ensure quality control and worker safety through video analysis. Detect workers who aren't wearing protective gear with real-time detection of critical events. |
| Modern safety | Detect and identify security and safety issues before they cause a risk. |
| Data governance | Bring AI to the content instead of vice versa. Use Video Indexer enabled by Arc when you can't move indexed content from on-premises to the cloud due to regulations, architecture decisions, or large data stores. |
| Pre-indexing | Index before uploading content to the cloud. Presort your on-premises video or audio archive, and then only upload it for standard or advanced indexing in the cloud. |

## Related resources

- [Targeted language processing guide](targeted-language-processing.md)
- [Speech recognition and generation guide](speech-recognition-generation.md)
