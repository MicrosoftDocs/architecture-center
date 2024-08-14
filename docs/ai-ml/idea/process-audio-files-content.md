[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides an example design of a pipeline that you can use to process audio files. The pipeline uses Azure AI services for speech to text and Azure OpenAI Service for analysis. The architecture consists of a static web application that provides an operational dashboard and three Azure functions that orchestrate and process the media files. You can use this solution for media workloads that require automated and scalable AI analysis.

## Architecture

:::image type="content" source="_images/podcast-abstract-architecture.svg" alt-text="Diagram that shows the architecture for processing audio files using Azure OpenAI for analysis." lightbox="_images/podcast-abstract-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/podcast-abstract-architecture.vsdx) of this architecture.*

### Workflow

1. The user goes to a web page that has a UI for uploading audio files.

1. The static web app contains code that uploads the audio file to Azure Blob Storage.

1. The user interacts with the web page, which triggers a function that uses an HTTP endpoint to initiate the transfer of the audio file to a designated container within the storage account.

1. After Blob Storage detects that a new file is uploaded, another function is invoked that converts the audio to text by using Azure AI Speech. The transcription results are stored in a text file format and uploaded to another container.

1. A third function uses generative AI to detect and process the transcriptions and generate summaries, search engine-optimized keywords, and translations.

### Components

- [Static Web Apps](https://azure.microsoft.com/products/app-service/static/) is a service that you can use to simplify hosting and deploying static web applications. Static Web Apps provides seamless integration with GitHub repositories for automatic deployment and continuous integration and continuous deployment (CI/CD) pipelines.

- [Azure Functions](https://azure.microsoft.com/products/functions/) is a serverless computing service that developers can use to run code without having to manage infrastructure.

- [Blob Storage](https://azure.microsoft.com/products/storage/blobs/) is a storage service that you can use to store large amounts of unstructured data, such as text or binary data.

- [AI services](https://azure.microsoft.com/products/ai-services/speech-to-text/) is a suite of cloud-based APIs and prebuilt AI models that offer capabilities such as speech recognition, natural language understanding, and computer vision.

- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service/) is a partnership between Microsoft Azure and OpenAI that provides access to OpenAI's models and technologies through the Azure platform.

## Scenario details

Podcasts are an effective medium to share your ideas, stories, and perspectives. Many organizations and individuals have discovered the power of using podcasts to connect and grow their audience. To reach an even wider audience, creators can use a podcast synopsis and content localization to make their content more accessible to speakers of other languages.

A podcast synopsis is a quick and easy way for creators to inform listeners what their podcast episode is about. A podcast synopsis can help listeners decide whether they want to tune in. A translated synopsis makes it easier for potential international listeners to discover the podcast and learn about what it offers.

Localization is the process of adapting your podcast content to a specific language and culture. Localization goes beyond translation and considers the nuances, preferences, and expectations of your target audience. Localization can help you connect with your listeners on a deeper level and increase their engagement and loyalty.

Producing and publishing content is difficult. AI can help you automate processes and scale your podcast production and distribution. You can use AI and AI infrastructure to transcribe your podcast audio, translate your synopsis, and generate voice-overs in various languages and accents.

This article describes how to use AI to create a podcast synopsis, localize the podcast into multiple languages, and automatically generate marketing and search engine optimization (SEO) keywords that help broaden your content audience. This solution illustrates how to use the power of GPT to automate a large part of this process with Speech and Azure OpenAI. You can use GPT to automatically transcribe audio into text, generate a synopsis in a particular style and tone, suggest catchy tag lines and SEO keywords, and translate the synopsis into multiple languages to reach a global audience, all in a matter of minutes.

### Web app

A [static web application](https://learn.microsoft.com/azure/static-web-apps/) exposes this application's functionality. The application is written by using the [React web library](https://react.dev/). You can use the React web library to upload audio files. After the audio files are processed, React generates viewable and downloadable results that include:

- A synopsis.
- A translated synopsis.
- An alternate title.
- SEO keywords.

### Storage

This solution uses a single Azure Storage account with multiple containers to store raw files (audio), transcriptions (text transcriptions of audio), and the Azure OpenAI results.

### Compute

This solution uses three Azure functions in a specific workflow to process audio files. All three functions are written in Python.

#### HTTP-triggered function

The static website consumes the first HTTP-triggered function. The function has a [Flask app framework](/samples/azure-samples/flask-app-on-azure-functions/azure-functions-python-create-flask-app/) and exposes two endpoints:

- *POST* operation to upload the audio file to Blob Storage
- *GET* operation to retrieve the results of the generated AI insights

#### Blob-triggered function for the raw files container

The second function is a blob-triggered function that has [bindings](/azure/azure-functions/functions-bindings-storage-blob-trigger) set to use the storage account's raw files container. The function triggers automatically when a file is uploaded to this container. This function also takes advantage of the [`ffmpeg`](https://ffmpeg.org/) CLI tool that's [mounted by using Azure Files](/azure/app-service/configure-connect-to-azure-storage) to convert audio files to WAV. [Speech](https://azure.microsoft.com/products/ai-services/ai-speech) uses the WAV format. After the file is converted to WAV file format, it's then passed to Speech. Speech creates a text transcription of the audio file. The text transcription is then uploaded to the transcriptions container within the storage account.

#### Blob-triggered function for the transcriptions container

The third and final function is a blob-triggered function that has bindings set to use storage account's transcriptions container. Any file that's uploaded to this container triggers the function to run. This final function composes a series of [prompts](/azure/ai-services/openai/concepts/prompt-engineering) in Azure OpenAI that summarize the transcription, generate tag lines and SEO keywords, and translate the transcript into non-English languages.

After the synopsis, SEO keywords, and translation are generated, the Azure OpenAI responses are uploaded to the *open-ai-results* container in the storage account.

### AI and machine learning

This solution uses two Azure AI workloads:

- Speech
- Azure OpenAI

The speech-to-text capabilities in Speech transcribe audio into text. Azure OpenAI GPT models process the text. The models use generative capabilities to generate tags, SEO keywords, summarization, and translation service. They use the transcription to perform text content-generation tasks.

### Potential use cases

The architectural framework is designed for media tasks that AI analyzes automatically. This framework is intended for media applications but can be used for broader applications, specifically for tasks that require text summarization of audio recordings and use AI-generated content for transcripts, summarizations, taglines, and synopses.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Kathy Lee](https://www.linkedin.com/in/kathy-lee-she-her-2235a41/) | Senior Cloud Solution Architect
- [Uffaz Nathaniel](https://www.linkedin.com/in/uffaz-nathaniel-85588935/) | Principal Software Engineer
- [Chew-Yean Yam](https://www.linkedin.com/in/cyyam/)| Principal Data Scientist

Other contributors:

- [Andy Beach](https://www.linkedin.com/in/andrewbeach/) | Chief Technical Officer (CTO), Media and Entertainment Worldwide
- [Simon Powell](https://www.linkedin.com/in/asbpowell/) | Principal Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Podcast synopsis generation sample](https://github.com/Azure-Samples/podcast-synopsis-generation-openai)
- [Automat podcast synopsis generation with Azure OpenAI GPT](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/automating-podcast-synopsis-generation-with-azure-openai-gpt/ba-p/3810308)
