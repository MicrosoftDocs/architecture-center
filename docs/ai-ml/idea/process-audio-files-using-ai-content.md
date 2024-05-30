[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides an example design of a pipeline for processing audio files by using Open AI. The pipeline uses Azure Cognitive Services for speech-to-text (STT) and Azure OpenAI for analysis. The architecture consists of a static web application that provides an operational dashboard and three Azure Functions that orchestrate and process the media files. This solution is designed for media workloads that need automated and scalable AI analysis.

# Architecture

:::image type="content" source="_images/podcast-abstract-architecture.svg" alt-text="Diagram that shows the architecture for processing audio files using Open AI for analysis." lightbox=""_images/podcast-abstract-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/podcast-abstract-architecture.vsdx) of this architecture.*

# Workflow

1. User navigates to a web page that has a UI for uploading audio files.

1. The Static Web App contains code that uploads the audio file to Azure Blob Storage.

1. An HTTP endpoint is triggered after interacting with the web page, which initiates the transfer of the audio file to a designated container within the storage account.

1. After detecting that a new file has been uploaded, another function is invoked that converts the audio to text using Azure Cognitive Services for Speech. The results of transcription are stored in a text file format and uploaded to another container.

1. Another function uses generative AI to detect and process the transcriptions and to generate summaries, SEO keywords, and translations.

### Web app

This application's functionality is described in [Static Web Apps](https://learn.microsoft.com/azure/static-web-apps/). The application is written by using the [React web library](https://react.dev/). The React web library lets users upload audio files. After processing the audio files, React generates viewable and downloadable results that include:

- Synopsis
- Translated synopsis
- Alternate title
- Search Engine Optimized (SEO) keywords

### Storage

This solution uses a single Azure storage account with multiple containers to store _raw-files_ (audio), _transcriptions_ (text transcription of audio) and Open AI _results_.

### Compute

This solution uses three Azure Functions in a specific workflow to process audio files. All three functions are written in Python.

#### HTTP-triggered function

The first function is an HTTP-triggered function that the static website consumes. It is a [Flask app](/samples/azure-samples/flask-app-on-azure-functions/azure-functions-python-create-flask-app/) under the hood and exposes two endpoints:

- _POST_ operation to upload the audio file to Blob Storage
- _GET_ operation to retrieve the results of the generated AI insights

#### Blob Triggered Function (raw-files container)

The second function is a Blob-triggered function that has [bindings](/azure/azure-functions/functions-bindings-storage-blob-trigger) set to use the storage account's *raw-files* container. The function triggers automatically when a file is uploaded to this container. This function also takes advantage of [ffmpeg](https://ffmpeg.org/)[mounted using Azure Files](/azure/app-service/configure-connect-to-azure-storage) to convert audio files to WAV, which is the format accepted by the [Azure Speech Service](/products/ai-services/ai-speech). Once the file is converted to WAV file format, it is then passed to Azure Speech Service to create a text transcription of an audio file. The text transcription is then uploaded to the *transcriptions* container within the storage account.

#### Blob Triggered Function (transcriptions container)

The third and final function is a Blob-triggered function that has bindings set to use storage account's *transcriptions* container. Any file that is uploaded to this container triggers the function to run. This function composes a series of [prompts](/azure/ai-services/openai/concepts/prompt-engineering) to Open AI to summarize the transcription, generate tag lines and SEO keywords, and translate into non-English languages.

Once complete, the final step uploads the Open AI responses to the *open-ai-results* container in the storage account.

### AI + Machine Learning

This solution uses two different Azure AI workloads:

- Azure Cognitive Services Speech Service
- Azure Open AI Service

You can use Azure Cognitive Services Speech Service to transcribe audio into text using its speech-to-text capabilities. Additionally, Open AI's GPT models are used to process text that relies on the generative capabilities to generate tags, SEO keywords, summarization, and translation. Service to perform text content generation tasks based on the transcription.

# Components

- [Static Web Application](/products/app-service/static/) is a service that simplifies the hosting and deployment of static web applications. Static Web Apps provides seamless integration with GitHub repositories for automatic deployment and continuous integration and continuous deployment (CI/CD) pipelines.

- [Azure Functions](/products/functions/) is a serverless computing service that developers can use to run code in response to events without having to manage infrastructure.

- [Blob Storage](/services/storage/blobs/) is a storage service designed to store large amounts of unstructured data such as text or binary data.

- [Azure Cognitive Services](/products/cognitive-services/speech-to-text/) is a suite of cloud-based APIs and pre-built AI models offering capabilities such as speech recognition, natural language understanding, and computer vision.

- [Azure Open AI](/products/cognitive-services/openai-service/) is a partnership between Microsoft Azure and OpenAI that offers access to OpenAI's models and technologies through the Azure platform.

# Scenario details

Podcasts have become a popular medium to share your ideas, stories, and insights with the world. Both large companies and individuals have discovered their power for connecting and growing an audience. But what if you want to reach a wider audience and make your content more accessible to people who speak different languages? That's where podcast synopsis and localization come in.

A podcast synopsis is a quick and easy way for creators to inform listeners what their podcast episode is about. It can help listeners decide if they want to tune in or not. When that synopsis is translated into other languages, it makes it easier for potential international listeners to discover the podcast and understand what it offers.

Localization is the process of adapting your podcast content to a specific language and culture. It goes beyond translation and considers the nuances, preferences, and expectations of your target audience. Localization can help you connect with your listeners on a deeper level and increase their engagement and loyalty.

But producing and publishing content is hard enough. How can someone create a podcast synopsis and localize it into multiple languages without spending too much time and money? The answer is AI and the infrastructure it takes to automate the processes required. Artificial intelligence can help you automate this process and allow you to scale your podcast production and distribution. AI can transcribe your podcast audio, translate your synopsis, and even generate voice-overs in different languages and accents.

This article demonstrates how to use AI to create a podcast synopsis and localize it into multiple languages and even automatically generate useful marketing and Search Engine Optimized (SEO) that help broaden the audience of your content. The solution illustrates how to automate a large part of this process with Azure Speech Services and Azure Open AI Service, using the power of GPT. GPT has many useful functions, including automatic transcription of the audio into text, generating a synopsis in a particular style and tone, suggesting catchy tag lines and SEO keywords, and translating the synopsis into multiple languages to reach a global audience, all in a matter of minutes.

# Potential use cases

The architectural framework is tailored for media workloads that AI analysis completed in an automated fashion. While it's primarily intended for media applications, there are potential broader applications. Specifically, it can be used for tasks that require text summarization of audio recordings and leveraging AI-generated content for transcripts, summarizations, taglines, and synopses.

# Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kathy Lee](https://www.linkedin.com/in/kathy-lee-she-her-2235a41/) | Senior Cloud Solution Architect
- [Uffaz Nathaniel](https://www.linkedin.com/in/uffaz-nathaniel-85588935/) | Principal Software Engineer
- [Chew-Yean Yam](https://www.linkedin.com/in/cyyam/)| Principal Data Scientist

Other contributors:

- [Andy Beach](https://www.linkedin.com/in/andrewbeach/) | CTO, Media and Entertainment Worldwide
- [Simon Powell](https://www.linkedin.com/in/asbpowell/) | Principal Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

# Next steps

- [Azure Samples](https://github.com/Azure-Samples/podcast-synopsis-generation-openai)
- [Techhub community blog post](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/automating-podcast-synopsis-generation-with-azure-openai-gpt/ba-p/3810308)


