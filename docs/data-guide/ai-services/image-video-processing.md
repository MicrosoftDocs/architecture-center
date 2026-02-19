---
title: Azure AI Video Processing Guide
description: Learn about Foundry Tools for video processing and video generation. Understand and compare each service's capabilities and use cases.
author: ritesh-modi
ms.author: rimod
ms.date: 02/19/2026
ms.update-cycle: 180-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.collection: ce-skilling-ai-copilot
ms.custom: arb-aiml
---

# Choose an Azure AI image and video processing and generation technology

[Foundry Tools](/azure/ai-services/what-are-ai-services) help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models.

This article covers Foundry Tools that provide video and image processing capabilities, such as visual analysis and generation of images, object detection, image classification, and facial recognition, including:

- [Azure OpenAI in Microsoft Foundry models](#azure-openai-in-microsoft-foundry-models) provides access to OpenAI's powerful language models, including the latest generation of GPT models with vision and audio capabilities, Sora for video generation, DALL-E for image generation, and Audio API models such as Whisper for speech-to-text transcription and translation. Use Azure OpenAI in Microsoft Foundry models for image generation from natural language, broad nonspecific image analysis, or audio transcription and translation scenarios that don't require a dedicated speech service.

- [Azure Vision in Foundry tools](#azure-vision-in-foundry-tools) is part of Foundry Tools and provides advanced algorithms that process images and return information based on visual features. It includes optical character recognition (OCR), image analysis, and face detection capabilities.

- [Azure AI Custom Vision](#custom-vision) is an image recognition service that you can use to build, deploy, and improve your image identifier models for specific requirements that can't be met by other services.

- [Azure AI Content Understanding in Microsoft Foundry Tools](#azure-ai-content-understanding) is a Foundry Tool that uses generative AI to extract structured fields from images and video. Use Content Understanding when you need schema-defined extraction, scene segmentation, or RAG-ready video output.

- [Azure AI Video Indexer](#azure-ai-video-indexer) is a comprehensive AI solution that enables organizations to extract deep insights from video (live and uploaded) and audio content using advanced machine learning and generative AI models.

### Azure OpenAI in Microsoft Foundry models

[Azure OpenAI in Microsoft Foundry models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#azure-openai-in-microsoft-foundry-models) provides access to OpenAI's powerful language models, including the latest generation of GPT models with image, video, and audio capabilities. [Sora and Sora 2 video generation models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#video-generation-models), [DALL-E and GPT-image image generation models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#image-generation-models), [Whisper and GPT-4o audio models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-models) for speech-to-text and speech translation, and text-to-speech models are also available.

| Use Azure OpenAI in Microsoft Foundry models to | Don't use Azure OpenAI in Microsoft Foundry models to |
| :----------| :-------------|
| Generate images from natural language descriptions using DALL-E or GPT-image models. | Perform specific image processing like form extraction or domain-specialized detection. For these tasks, use [Document Intelligence](/azure/ai-services/document-intelligence/overview). |
| Perform broad, nonspecific analysis on images using vision-capable models like GPT-4o. | Extract structured fields from images using a schema you define. For schema-driven extraction, use [Azure AI Content Understanding](#azure-ai-content-understanding). |
| Transcribe speech to text or translate spoken audio using Whisper or GPT-4o transcription models. | Detect, recognize, or analyze human faces. For face-related tasks, use [Azure Vision](#azure-vision-in-foundry-tools). |
| Enable low-latency real-time voice conversations using GPT-4o Realtime audio models. | Perform high-volume speech transcription with advanced customization, speaker diarization, or custom vocabulary. For those scenarios, use [Azure Speech](/azure/ai-services/speech-service/overview). |
| Generate accessibility descriptions for images. | Use open-source image generation models. For open-source models, use Azure Machine Learning. |

#### Audio models

Azure OpenAI provides audio models through two interfaces: [GPT-4o audio models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#gpt-4o-audio-models) for real-time, low-latency speech-in, speech-out conversational interactions, and [Audio API models](/azure/ai-foundry/foundry-models/concepts/models-sold-directly-by-azure#audio-api) via the `/audio` endpoint for speech-to-text transcription (Whisper, GPT-4o transcription), speech translation, and text-to-speech.

### Azure Vision in Foundry Tools

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
| [Face detection and analysis](/azure/ai-services/computer-vision/concept-face-detection) | Identifies the regions of an image that contain a human face, typically by returning bounding-box coordinates that form a rectangle around the face. |
| [Find similar faces](/azure/ai-services/computer-vision/overview-identity#find-similar-faces) | Matches a target face with a set of candidate faces and identifies a smaller group of faces that closely resemble the target face. Useful for face search by image. |
| [Group faces](/azure/ai-services/computer-vision/overview-identity#group-faces) | Divides a set of unknown faces into several smaller groups based on similarity. |
| [Face identification](/azure/ai-services/computer-vision/overview-identity#identification) | Performs one-to-many matching of one face in an image to a set of faces in a secure repository. Match candidates are returned based on how closely their face data matches the query face. |
| [Face verification](/azure/ai-services/computer-vision/overview-identity#face-recognition-operations) | Performs one-to-one matching to confirm that a user is who they claim to be. |
| [Liveness detection](/azure/ai-services/computer-vision/overview-identity#liveness-detection) | An anti-spoofing feature that checks whether a user is physically present in front of the camera. Prevents spoofing attacks that use a printed photo, recorded video, or a 3D mask of the user's face. |

#### Use cases

The following table provides a list of possible use cases for Azure Vision.

| Use case | Description |
| :----------| :-------------|
| [Generate image alt text](/azure/ai-services/computer-vision/use-case-alt-text) | Use Image Analysis captioning models to auto-generate alt text descriptions for images. Alt text improves accessibility for blind and low-vision users, helps meet legal compliance requirements, and makes your website more discoverable through better SEO. Microsoft products like PowerPoint, Word, and Edge browser use this capability. |
| [Identity verification](/azure/ai-services/computer-vision/use-case-identity-verification) | Use Face to verify users are who they claim to be. Verification compares a probe image against an enrolled template (such as a government-issued ID) for access control scenarios. Benefits include seamless user experience and improved security over knowledge-based methods. |
| Face redaction | Redact or blur detected faces of people recorded in a video to protect their privacy. |
| Touchless access control | Use opt-in face identification for enhanced access control while reducing the hygiene and security risks from physical media sharing, loss, or theft. Facial recognition assists the check-in process with a human in the loop for check-ins in airports, stadiums, theme parks, buildings, reception kiosks at offices, hospitals, gyms, clubs, or schools. |

### Custom Vision

[Custom Vision](/azure/ai-services/custom-vision-service/overview) is an image recognition service that you can use to build, deploy, and improve your image identifier models. An image identifier applies labels to images according to their visual characteristics. Each label represents a classification or object. Use Custom Vision to specify your own labels and train custom models to detect them.

| Use Custom Vision to | Don't use Custom Vision to |
| :----------| :-------------|
| Recognize unusual objects and manufacturing defects that standard image analysis can't detect. | Perform basic object detection or face detection. Use [Azure Vision](#azure-vision-in-foundry-tools) instead. |
| Provide detailed custom classifications for specific business requirements. | Perform basic visual analysis. Use vision-capable models from [Azure OpenAI in Microsoft Foundry models](#azure-openai-in-microsoft-foundry-models) or open-source models in Azure Machine Learning instead. |
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

### Azure AI Content Understanding

[Azure AI Content Understanding](/azure/ai-services/content-understanding/overview) is a Foundry Tool that uses generative AI to extract structured fields from images and video. You define a schema that specifies what to extract, and Content Understanding applies generative models to produce structured JSON or RAG-ready Markdown output. It also provides confidence scores and grounding for each extracted value, enabling automated workflows with targeted human review.

| Use Azure AI Content Understanding to | Don't use Azure AI Content Understanding to |
| :----------| :-------------|
| Extract custom structured fields from images using a schema you define, such as detecting products, brands, or defects. | Perform standard image analysis such as object detection or OCR. Use [Azure Vision](#azure-vision-in-foundry-tools) for those tasks. |
| Generate RAG-ready output from video, including scene descriptions, transcripts, and key frames, for use in search indexes or chat agents. | Extract deep video insights such as celebrity identification, speaker enumeration, or sentiment analysis across long-form content. Use [Azure AI Video Indexer](#azure-ai-video-indexer) for those tasks. |
| Segment video into scenes and extract custom metadata per segment, such as brand presence or ad category. | |
| Generate face descriptions in images or video, such as facial expressions or celebrity identification (limited access). | |

#### Available Azure AI Content Understanding features

The following table provides a list of image and video features available in Azure AI Content Understanding.

| Feature | Description |
| :----------| :-------------|
| [Image field extraction](/azure/ai-services/content-understanding/image/overview) | Extracts custom structured fields from images based on a schema you define. Fields can be extracted directly, classified from a set of categories, or generated using a generative model. Useful for retail shelf analysis, manufacturing quality control, and chart-based business intelligence. |
| [Key frame extraction](/azure/ai-services/content-understanding/video/overview#content-extraction-capabilities) | Extracts representative key frames from each shot in a video. Ensures each segment has sufficient visual context for downstream field extraction. |
| [Shot detection](/azure/ai-services/content-understanding/video/overview#content-extraction-capabilities) | Identifies shot boundaries in a video based on visual cues, producing a list of timestamps for precise editing, repackaging, and segmentation. |
| [Scene segmentation](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Divides a video into logical scenes described in natural language. You define the segmentation logic, such as splitting a news broadcast by story topic, and the generative model creates matching segments. |
| [Video field extraction](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Generates custom structured fields per video segment based on a schema, such as brand logos, ad categories, or scene sentiment, using a generative model. |
| [Face description](/azure/ai-services/content-understanding/video/overview#face-description-fields) | Generates textual descriptions of faces in images or video, including facial hair, expressions, and celebrity identification. This is a limited-access feature that requires disabling face blurring in the analyzer configuration. |

#### Use cases for Azure AI Content Understanding

The following table provides a list of possible use cases for Azure AI Content Understanding applied to images and video.

| Use case | Description |
| :----------| :-------------|
| [RAG on video](/azure/ai-services/content-understanding/video/overview#prebuilt-video-analyzer-example) | Generate RAG-ready Markdown from video files, including inline transcripts, key frame thumbnails, and natural-language segment descriptions. Drop the output directly into a vector store to enable agent or search workflows without post-processing. |
| [Media asset management](/azure/ai-services/content-understanding/video/overview#why-use-content-understanding-for-video) | Tag video assets with scene-level metadata such as content category, brand presence, and key moments. Helps editors, producers, and marketing teams organize and retrieve content from large video libraries. |
| [Manufacturing quality control](/azure/ai-services/content-understanding/image/overview) | Analyze product images against a custom schema to detect defects, anomalies, or misalignments in production lines. |
| [Retail shelf analysis](/azure/ai-services/content-understanding/image/overview) | Extract structured data from shelf images to count products, detect misplacements, and monitor stock levels. |
| [Ad and brand analysis](/azure/ai-services/content-understanding/video/overview#field-extraction-and-segmentation) | Identify brand logos and ad categories in promotional video segments to assess brand exposure and compliance with branding guidelines. |

### Azure AI Video Indexer

[Azure AI Video Indexer](/azure/azure-video-indexer/video-indexer-overview) is a comprehensive AI solution that enables organizations to extract deep insights from video (live and uploaded) and audio content. It uses advanced machine learning and generative AI models and supports a wide range of capabilities including transcription, translation, object detection, and video summarization. Designed for flexibility, Video Indexer can be used in the cloud or deployed to edge locations via Azure Arc.

| Use Azure AI Video Indexer to | Don't use Azure AI Video Indexer to |
| :----------| :-------------|
| Extract insights from uploaded videos including transcription, translation, and content analysis. | Perform basic video analysis tasks like people counting and motion detection. [Azure Vision](#azure-vision-in-foundry-tools) is more cost-effective for these tasks. |
| Analyze live video streams in real time for retail, manufacturing, or safety scenarios. | Extract text from static images. For OCR on images, use [Azure Vision](#azure-vision-in-foundry-tools). |
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

#### Use cases for Cloud-based Video Indexer

The following table provides a list of possible use cases for Cloud-based Video Indexer.

| Use case | Description |
| :----------| :-------------|
| Deep search | Use the insights extracted from the video to enhance the search experience across a video library. For example, indexing spoken words and faces can enable the search experience of finding moments in a video where a person spoke certain words or when two people were seen together. Search based on such insights from videos is applicable to news agencies, educational institutes, broadcasters, entertainment content owners, enterprise line-of-business apps, and generally to any industry that has a video library that users need to search against. |
| Content creation | Create trailers, highlight reels, social media content, or news clips based on the insights Video Indexer extracts from your content. Keyframes, scene markers, and timestamps of people and label appearances simplify the creation process. |
| Accessibility | Make your content available for people with disabilities or distribute content to different regions that use different languages by using the transcription and translation that Video Indexer provides in multiple languages. |
| Monetization | Increase the value of videos. Industries that rely on ad revenue, such as news media and social media, can deliver relevant ads by using the extracted insights as additional signals to the ad server. |
| Content moderation | Use textual and visual content moderation models to keep your users safe from inappropriate content and validate that the content that you publish matches your organization's values. |
| Recommendations | Improve user engagement by highlighting the relevant video moments to users. By tagging each video with extra metadata, you can recommend the most relevant videos and highlight the parts that match user needs. |

#### Use cases for Video Indexer enabled by Azure Arc

The following table provides a list of possible use cases for Video Indexer enabled by Azure Arc.

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
