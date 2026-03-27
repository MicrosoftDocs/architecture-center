---
title: Azure AI Video Processing Guide
description: Learn about Foundry Tools for video processing and video generation. Understand and compare each service's capabilities and use cases.
author: hudua
ms.author: hudua
ms.date: 03/20/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI image and video processing and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) helps developers and organizations create AI-based, advanced, production-ready applications that align with responsible AI practices by using out-of-the-box, prebuilt, and customizable APIs and models.

This article describes video and image processing capabilities in Tools, such as visual analysis and generation of images, object detection, image classification, and facial recognition. The suite includes the following services:

- [Azure OpenAI in Foundry Models](#azure-openai) provides access to the following OpenAI language models:
   
   - The latest generation of GPT models that have vision and audio capabilities

   - DALL-E for image generation

   - Audio models for real-time voice conversations, audio generation, speech-to-text (STT) transcription, translation, and text-to-speech (TTS)
   
   Use Azure OpenAI for image generation from natural language, broad and nonspecific image analysis, or audio scenarios that don't require a dedicated speech service.

- [Azure Vision in Foundry Tools](#azure-vision) provides advanced algorithms that process images and return information based on visual features. It includes optical character recognition (OCR), image analysis, and face detection capabilities.

- [Microsoft Azure AI Custom Vision](#custom-vision) is an image recognition service that you can use to build, deploy, and improve your image identifier models for specific requirements that other services can't meet.

- [Azure Content Understanding in Foundry Tools](#azure-content-understanding) uses generative AI to extract structured fields from images and video. Use Azure Content Understanding when you need schema-defined extraction, scene segmentation, or retrieval-augmented generation (RAG)-ready video output.

- [Microsoft Azure AI Video Indexer](#video-indexer) is an AI solution that organizations can use to extract deep insights from video and audio content. It supports both live and uploaded sources by using advanced machine learning and generative AI models.

### Azure OpenAI

[Azure OpenAI](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#azure-openai-in-microsoft-foundry-models) provides access to OpenAI's powerful language models, including the latest generation of GPT models that have image, video, and audio capabilities. [DALL-E and GPT-image image generation models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#image-generation-models), and [audio models](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-models) for real-time voice conversations, audio generation and transcription, STT, speech translation, and TTS are also available.

| Use Azure OpenAI for these tasks | Don't use Azure OpenAI for these tasks |
| :----------| :-------------|
| Generate images from natural language descriptions by using DALL-E or GPT-image models. | Do specific image processing tasks, like form extraction or domain-specialized detection. Use [Azure Document Intelligence](/azure/ai-services/document-intelligence/overview) for these tasks. |
| Do broad, nonspecific analysis on images by using vision-capable models like GPT-4o. | Extract structured fields from images by using a schema that you define. For schema-driven extraction, use [Azure Content Understanding](#azure-content-understanding). |
| Transcribe STT or translate spoken audio by using Whisper or GPT-4o transcription models. | Detect, recognize, or analyze human faces. For face-related tasks, use [Azure Vision](#azure-vision). |
| Enable low-latency real-time voice conversations by using GPT-4o Realtime audio models. | Do high-volume speech transcription that needs advanced customization, speaker diarization, or custom vocabulary. For those scenarios, use [Azure Speech in Foundry Tools](/azure/ai-services/speech-service/overview). |
| Generate accessibility descriptions for images. | Use open-source image generation models. For open-source models, use Azure Machine Learning. |

#### Audio models

Azure OpenAI provides audio models through the following APIs:

- The [Realtime API](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-4o-audio-models) for low-latency, real-time voice conversations

- The [Chat Completions API with audio](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-4o-audio-models) for flexible audio generation and transcription in a single model call

- The [Audio API](/azure/foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-api) via the `/audio` endpoint for file-based STT transcription in Whisper and GPT-4o transcription models, speech translation, and TTS

### Azure Vision

[Azure Vision](/azure/ai-services/computer-vision/overview) is a service in Tools. It provides advanced algorithms that process images and return information based on the visual features that you specify. Azure Vision includes OCR, image analysis, and face detection capabilities.

| Use Azure Vision for these tasks | Don't use Azure Vision for these tasks |
| :----------| :-------------|
| Extract printed and handwritten text from images and documents by using OCR. | Do advanced video analysis like transcription, translation, or content summarization. For these tasks, use [Video Indexer](#video-indexer). |
| Analyze images to extract visual features like objects, faces, and automatically generated descriptions. | Moderate content for safety. For content moderation, use [Content Safety in Foundry Control Plane](/azure/ai-services/content-safety/overview). |
| Detect, recognize, and analyze human faces in images. | Do analysis that large, multimodal foundation models like GPT-4o already support. |

#### Available Azure Vision features

The following table provides a list of features available in Azure Vision.

| Feature | Description |
| :----------| :-------------|
| [OCR](/azure/ai-services/computer-vision/overview-ocr) | Extracts text from images. You can use the Read API to extract printed and handwritten text from photos and documents. It uses deep-learning-based models and works with text on various surfaces and backgrounds, including business documents, invoices, receipts, posters, business cards, letters, and whiteboards. |
| [Image Analysis](/azure/ai-services/computer-vision/overview-image-analysis) | Extracts many visual features from images, such as objects, faces, adult content, and automatically generated text descriptions. You can create custom image identifier models by using [Image Analysis 4.0](/azure/ai-services/computer-vision/overview) based on the Florence foundation model. |
| [Face detection and analysis](/azure/ai-services/computer-vision/concept-face-detection) | Identifies the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face. |
| [Find similar faces](/azure/ai-services/computer-vision/overview-identity#find-similar-faces) | Matches a target face with a set of candidate faces and identifies a smaller group of faces that closely resemble the target face. This capability is useful for face search by image. |
| [Group faces](/azure/ai-services/computer-vision/overview-identity#group-faces) | Divides a set of unknown faces into several smaller groups based on similarity. |
| [Face identification](/azure/ai-services/computer-vision/overview-identity#identification) | Does one-to-many matching of one face in an image to a set of faces in a secure repository. Match candidates are returned based on how closely their face data matches the query face. |
| [Face verification](/azure/ai-services/computer-vision/overview-identity#face-recognition-operations) | Does one-to-one matching to confirm that a user is who they claim to be. |
| [Liveness detection](/azure/ai-services/computer-vision/overview-identity#liveness-detection) | An anti-spoofing feature that checks whether a user is physically present in front of the camera. Prevents spoofing attacks that use a printed photo, recorded video, or a 3D mask of the user's face. |

#### Use cases for Azure Vision

The following table provides a list of possible use cases for Azure Vision.

| Use case | Description |
| :----------| :-------------|
| [Generate image alternative text (alt text)](/azure/ai-services/computer-vision/use-case-alt-text) | Use Image Analysis captioning models to automatically generate alt text descriptions for images. Alt text improves accessibility for users who are blind or have low vision, helps meet legal compliance requirements, and makes your website more discoverable through improved SEO. Microsoft products like PowerPoint, Word, and Edge use this capability. |
| [Identity verification](/azure/ai-services/computer-vision/use-case-identity-verification) | Use Azure Face to confirm that users are who they claim to be. Verification compares a probe image against an enrolled template, such as a government-issued ID, for access control scenarios. This approach helps improve user experience and security compared to knowledge-based methods. |
| [Face redaction](/azure/azure-video-indexer/face-redaction-with-api) | Redact or blur detected faces of people recorded in a video to protect their privacy. |
| [Touchless access control](/azure/ai-services/face/how-to/specify-recognition-model) | Use opt-in face identification for enhanced access control while reducing the maintenance and security risks from physical media sharing, loss, or theft. Facial recognition assists the check-in process with a human in the loop for check-ins in airports, stadiums, theme parks, buildings, reception kiosks at offices, hospitals, gyms, clubs, or schools. |

### Custom Vision

[Custom Vision](/azure/ai-services/custom-vision-service/overview) is an image recognition service that you can use to build, deploy, and improve your image identifier models. An image identifier applies labels to images based on their visual characteristics. Each label represents a classification or object. Use Custom Vision to specify your own labels and train custom models to detect them.

| Use Custom Vision for these tasks | Don't use Custom Vision for these tasks |
| :----------| :-------------|
| Recognize unusual objects and manufacturing defects that standard image analysis can't detect. | Do basic object detection or face detection. Use [Azure Vision](#azure-vision) instead. |
| Provide detailed custom classifications for specific business requirements. | Do basic visual analysis. Use vision-capable models from [Azure OpenAI](#azure-openai) or open-source models in Machine Learning instead. |
| Train models with your own labeled images for specialized scenarios. | |

Custom Vision uses a machine learning algorithm to analyze images for custom features. You submit sets of images with and without the visual characteristics that you want. You then label the images with your own labels, or *tags*, at the time of submission. The algorithm uses this data to train and calculates its own accuracy by testing itself on the same images. After you train your model, you can test, retrain, and eventually use the model in your image recognition app to classify images or detect objects. You can also export the model for offline use.

#### Available Custom Vision features

The following table provides a list of features available in Custom Vision.

| Feature | Description |
| :----------| :-------------|
| [Image classification](/azure/ai-services/custom-vision-service/getting-started-build-a-classifier) | Predict a category, or *class*, based on a set of inputs, which are called *features*. Calculate a probability score for each possible class and return a label that indicates the class that the object most likely belongs to. To use this model, you need data that consists of features and their labels. |
| [Object detection](/azure/ai-services/custom-vision-service/get-started-build-detector) | Get the coordinates of an object in an image. To use this model, you need data that consists of features and their labels. |

#### Use cases for Custom Vision

The following table provides a list of possible use cases for Custom Vision.

| Use case | Description |
| :----------| :-------------|
| [Use Custom Vision with an internet of things (IoT) device to report visual states](/azure/iot-edge/tutorial-deploy-custom-vision). | Use Custom Vision to train a device that has a camera to detect visual states. You can run this detection scenario on an IoT device by using an exported ONNX model. A visual state describes the content of an image, such as an empty room, a room with people, an empty driveway, or a driveway with a truck. |
| [Classify images and objects](/azure/ai-services/custom-vision-service/overview#classification-and-object-detection). | Analyze photos and scan for specific logos by training a custom model. |

### Azure Content Understanding

[Azure Content Understanding](/azure/ai-services/content-understanding/overview) is a service in Tools. It uses generative AI to extract structured fields from images and video. You define a schema that specifies what to extract, and Azure Content Understanding applies generative models to produce structured JSON or RAG-ready Markdown output. It also provides confidence scores and grounding for each extracted value, which supports automated workflows with targeted human review.

| Use Azure Content Understanding for these tasks | Don't use Azure Content Understanding for these tasks |
| :----------| :-------------|
| Extract custom structured fields from images by using a schema that you define, such as product, brand, or defect detection. | Do standard image analysis, such as object detection or OCR. Use [Azure Vision](#azure-vision) for these tasks. |
| Generate RAG-ready output from video, including scene descriptions, transcripts, and key frames, for use in search indexes or chat agents. | Extract deep video insights, such as celebrity identification, speaker enumeration, or sentiment analysis across long-form content. Use [Video Indexer](#video-indexer) for these tasks. |
| Segment video into scenes and extract custom metadata for each segment, such as brand presence or ad category. | |
| Generate face descriptions in images or video, such as facial expressions or celebrity identification. These features have limited access. | |

#### Available Azure Content Understanding features

The following table provides a list of image and video features available in Azure Content Understanding.

| Feature | Description |
| :----------| :-------------|
| [Image field extraction](/azure/ai-services/content-understanding/image/overview) | Extracts custom structured fields from images based on a schema that you define. You can extract fields directly, classify them from a set of categories, or generate them by using a generative model. This feature is useful for retail shelf analysis, manufacturing quality control, and chart-based business intelligence (BI). |
| [Key frame extraction](/azure/ai-services/content-understanding/video/overview#content-extraction-capabilities) | Extracts representative key frames from each shot in a video. Ensures that each segment has sufficient visual context for downstream field extraction. |
| [Shot detection](/azure/ai-services/content-understanding/video/overview#content-extraction-capabilities) | Identifies shot boundaries in a video based on visual cues. Produces a list of timestamps for precise editing, repackaging, and segmentation. |
| [Scene segmentation](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Divides a video into logical scenes described in natural language. You define the segmentation logic, such as splitting a news broadcast by story topic, and the generative model creates matching segments. |
| [Video field extraction](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Generates custom structured fields for each video segment based on a schema, such as brand logos, ad categories, or scene sentiment, by using a generative model. |
| [Face description](/azure/ai-services/content-understanding/video/overview#face-description-fields) | Generates textual descriptions of faces in images or video, including facial hair, expressions, and celebrity identification. Face description is a limited-access feature that requires you to turn off face blurring in the analyzer configuration. |

#### Use cases for Azure Content Understanding

The following table provides a list of possible use cases for Azure Content Understanding applied to images and video.

| Use case | Description |
| :----------| :-------------|
| [RAG on video](/azure/ai-services/content-understanding/video/overview#prebuilt-video-analyzer-example) | Generate RAG-ready Markdown from video files, including inline transcripts, key frame thumbnails, and natural-language segment descriptions. Place the output directly into a vector store to allow agent or search workflows without post-processing. |
| [Media asset management](/azure/ai-services/content-understanding/video/overview#why-use-content-understanding-for-video) | Tag video assets with scene-level metadata like content category, brand presence, and key moments. This approach helps editors, producers, and marketing teams organize and retrieve content from large video libraries. |
| [Manufacturing quality control](/azure/ai-services/content-understanding/image/overview) | Analyze product images against a custom schema to detect defects, anomalies, or misalignments in production lines. |
| [Retail shelf analysis](/azure/ai-services/content-understanding/image/overview) | Extract structured data from shelf images to count products, detect misplacements, and monitor stock levels. |
| [Ad and brand analysis](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Identify brand logos and ad categories in promotional video segments to assess brand exposure and compliance with branding guidelines. |

### Video Indexer

[Video Indexer](/azure/azure-video-indexer/video-indexer-overview) is an AI solution that organizations can use to extract deep insights from live and uploaded video and audio content. It uses advanced machine learning and generative AI models and supports a wide range of capabilities, including transcription, translation, object detection, and video summarization. Video Indexer is flexible. You can use it in the cloud or deploy it to edge locations via Azure Arc.

| Use Video Indexer for these tasks | Don't use Video Indexer for these tasks |
| :----------| :-------------|
| Extract insights from uploaded videos, including transcription, translation, and content analysis. | Do basic video analysis tasks like people counting and motion detection. [Azure Vision](#azure-vision) is a more cost-effective tool for these tasks. |
| Analyze live video streams in real time for retail, manufacturing, or safety scenarios. | Extract text from static images. For OCR on images, use [Azure Vision](#azure-vision). |
| Run video analysis on edge devices that have strict data residency or low-latency requirements by using Azure Arc. | |

#### Deployment options

Video Indexer provides the following deployment options.

| Option | Description |
| :----------| :-------------|
| [Cloud-based Video Indexer](/azure/azure-video-indexer/upload-index-media) | A cloud application built on Tools, including Azure Face, Azure Translator in Foundry Tools, Azure Vision, and Azure Speech. It analyzes video and audio content by running more than 30 AI models to generate detailed insights. |
| [Video Indexer enabled by Azure Arc](/azure/azure-video-indexer/arc/azure-video-indexer-enabled-by-arc-overview) | An Azure Arc extension that runs video and audio analysis and generative AI on edge devices. It supports both uploaded and live video streams, which allows real-time analysis directly at the data source. It suits industries that have strict data residency requirements or low-latency operational needs. |

#### Video models

The following table provides a list of video analysis features available in Video Indexer.

| Feature | Description |
| :----------| :-------------|
| [Face detection](/azure/azure-video-indexer/face-detection-insight) | Detects and groups faces that appear in a video. |
| [Account-based face identification](/azure/azure-video-indexer/customize-person-model-how-to) | Trains a model for a specific account and recognizes faces in videos based on the trained model. |
| [Observed people detection](/azure/azure-video-indexer/observed-matched-people-insight) | Detects observed people in videos and provides location information by using bounding boxes, with exact timestamps and confidence levels. Includes matched person, detected clothing, and featured clothing insights. |
| [Object detection](/azure/azure-video-indexer/object-detection-insight) | Detects and tracks unique objects so that it can recognize them if they return to the frame. |
| [OCR](/azure/azure-video-indexer/ocr-insight) | Extracts text from images like pictures, street signs, and products in media files to create insights. |
| [Labels identification](/azure/azure-video-indexer/labels-identification-insight) | Identifies visual objects and displayed actions. |
| [Scene segmentation](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight) | Determines when a scene changes in video based on visual cues. A scene depicts a single event composed of a series of consecutive shots. |
| [Shot detection](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight) | Determines when a shot changes in video based on visual cues. A shot is a series of frames taken from the same motion-picture camera. |
| [Key frame extraction](/azure/azure-video-indexer/scene-shot-keyframe-detection-insight#keyframe-editorial-shot-type-detection) | Detects stable key frames in a video. |
| [Slate detection](/azure/azure-video-indexer/clapper-board-insight) | Identifies movie post-production insights, including clapper board detection, digital patterns detection, and textless slate detection. |

#### Audio models

The following table provides a list of audio analysis features available in Video Indexer.

| Feature | Description |
| :----------| :-------------|
| [Audio transcription](/azure/azure-video-indexer/transcription-translation-lid-insight) | Converts STT in more than 50 languages and supports extensions. |
| [Automatic language detection](/azure/azure-video-indexer/language-support) | Identifies the dominant spoken language. |
| [Multiple-language speech identification](/azure/azure-video-indexer/transcription-translation-lid-insight) | Identifies the spoken language in different segments of audio, sends each segment to be transcribed, and combines them into one unified transcription. |
| [Closed captioning](/azure/azure-video-indexer/insights-overview) | Creates closed captioning in Web Video Text Tracks (WebVTT), Timed Text Markup Language (TTML), and SubRip Subtitle (SRT) formats. |
| [Two channel processing](/azure/azure-video-indexer/insights-overview) | Detects separate transcripts automatically and merges them into a single timeline. |
| [Noise reduction](/azure/azure-video-indexer/insights-overview) | Clears up telephony audio or noisy recordings based on Skype filters. |
| [Speaker enumeration](/azure/azure-video-indexer/insights-overview) | Maps and understands which speaker spoke which words and when. It can detect 16 speakers in a single audio file. |
| [Translation](/azure/azure-video-indexer/language-support) | Creates translations of the audio transcript in many different languages. |
| [Audio effects detection](/azure/azure-video-indexer/audio-effects-detection-insight) | Detects audio effects in nonspeech segments, including alarms or sirens, a dog barking, crowd reactions, loud impact sounds, laughter, breaking glass, and silence. |

#### Combined audio and video models

The following features analyze audio and video content.

| Feature | Description |
| :----------| :-------------|
| Keywords extraction | Extracts keywords from speech and visual text |
| Named entities extraction | Extracts brands, locations, and people from speech and visual text through natural language processing (NLP) |
| Topic inference | Extracts topics based on various keywords by using the International Press Telecommunications Council (IPTC), Wikipedia, and Video Indexer hierarchical topic ontology |
| Sentiment analysis | Identifies positive, negative, and neutral sentiments from speech and visual text |

For more information, see [Video Indexer overview](/azure/azure-video-indexer/video-indexer-overview).

#### Use cases for cloud-based Video Indexer

The following table provides a list of possible use cases for cloud-based Video Indexer.

| Use case | Description |
| :----------| :-------------|
| Deep search | Enhance the search experience across a video library by using the insights that Video Indexer extracts. For example, when you index spoken words and faces, users can find moments in a video when a person speaks specific words or when two people are seen together. These use cases apply to any industry that has a video library that users need to search, including news agencies, educational institutes, broadcasters, entertainment content owners, and enterprise line-of-business (LOB) apps. |
| Content creation | Create trailers, highlight reels, social media content, or news clips based on the insights that Video Indexer extracts from your content. Key frames, scene markers, and timestamps of people and label appearances simplify the creation process. |
| Accessibility | Make your content available for people with disabilities or distribute content to regions that use different languages by using the transcription and translation capabilities that Video Indexer provides. |
| Monetization | Increase the value of videos. Industries that rely on ad revenue, such as news media and social media, can deliver relevant ads by using the extracted insights as extra signals to the ad server. |
| Content moderation | Keep your users safe from inappropriate content and confirm that the content that you publish matches your organization's values by using textual and visual content moderation models. |
| Recommendations | Improve user engagement by highlighting the relevant video moments to users. By tagging each video with extra metadata, you can recommend the most relevant videos and highlight the parts that match users' needs. |

#### Use cases for Video Indexer enabled by Azure Arc

The following table provides a list of possible use cases for Video Indexer enabled by Azure Arc.

| Use case | Description |
| :----------| :-------------|
| Retail | Optimize store layouts and improve customer experience and safety. Monitor the number of customers in checkout lines in real time to optimize staffing and reduce wait times. |
| Manufacturing | Ensure quality control and worker safety through video analysis. Detect workers who aren't wearing protective gear with real-time detection of critical events. |
| Modern safety | Detect and identify security and safety problems before they cause a risk. |
| Data governance | Bring AI to the content. Use Video Indexer enabled by Arc when you can't move indexed content from on-premises to the cloud because of regulations, architecture decisions, or large data stores. |
| Pre-indexing | Index content before you upload it to the cloud. Presort your on-premises video or audio archive, and then only upload it for standard or advanced indexing in the cloud. |

## Related resources

- [Targeted language processing guide](targeted-language-processing.md)
- [Speech recognition and generation guide](speech-recognition-generation.md)
