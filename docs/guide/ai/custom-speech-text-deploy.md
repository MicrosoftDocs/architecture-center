---
title: Deploy a custom speech-to-text solution that uses AI
description: Deploy high-quality speech-aware applications that use AI. This article provides details about how to deploy the solution described in part one of this guide.
author: mishrapratyush
ms.author: pmishra
ms.date: 10/26/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-cognitive-services
  - azure-speech
  - azure-speech-text
  - azure-machine-learning
categories:
  - ai-machine-learning
---

# Deploy a custom speech-to-text solution

This article is an implementation guide and example scenario that provides a sample deployment of the solution described in **Implement custom speech-to-text**:

> [!div class="nextstepaction"]
> [Go to part one of this guide](custom-speech-text.yml)

## Architecture

:::image type="content" source="media/custom-speech-text.png" alt-text="Image alt text.":::

*Download a [Visio file](https://arch-center.azureedge.net/custom-speech-text.vsdx) of this architecture.*

### Workflow

1. Collect existing transcripts to use to train a custom speech model.
1. If the transcripts are in WebVTT or SRT format, clean the files so that they include only the text portions of the transcripts. 
1. To normalize the text, remove any punctuation, separate repeating words, and spell out any large numerical values. You can then combine these cleaned sentences in one file. 
1. After you create the training and test data, you can upload it to Speech Studio. Alternatively, you can use the data's publicly accessible URLs with Azure Speech API and the Speech CLI to create a dataset.
1. In Speech Studio or via the API or CLI, use the new dataset to train a custom speech model. 
1. Evaluate the newly trained model against the test dataset that you created.
1. If the new model performs appropriately, publish it for use in speech transcription. Otherwise, use Speech Studio to review the word error rate (WER) details and determine whether you need more data for training.
1. Include the scripts in CI/CD processes to take advantage of the ability of the API and CLI to help operationalize the model development evaluation and deployment process. 

## Scenario

This article is based on the following fictional scenario: 

Contoso, Ltd., is a broadcast media company that airs broadcasts and commentary on Olympics events. As part of the broadcast agreement, Contoso provides event transcription for accessibility and data mining. 

Contoso wants to use the Azure Speech service to provide live subtitling and audio transcription for Olympics events. Contoso employs female and male commentators from around the world who speak with diverse accents. In addition, each individual sport has specific terminology that can make transcription difficult. This article describes the application development process for this scenario: providing subtitles for an application that needs to deliver accurate event transcription.

Contoso already has these required prerequisite components in place:
 
- Human-generated transcripts for previous Olympics events. The transcripts represent different sports and diverse commentators.
- An Azure Cognitive Service resource. You can create one on the [Azure portal](https://ms.portal.azure.com). 

## Develop a custom speech-based application

A speech-based application uses the Azure Speech SDK to connect to the Azure Speech service to generate text-based audio transcription. Speech service supports [various languages](/azure/cognitive-services/speech-service/language-support) and two fluency modes: conversational and dictation. To develop a custom speech-based application, you  generally need to complete these steps:

1.	Use the Azure Speech SDK, Speech CLI, or REST API to generate transcripts for spoken sentences and utterances.
2.	Compare the generated transcript with the human-generated transcript.
3.	If certain domain-specific words transcribe incorrectly, consider creating a custom speech model for that specific domain.
4.	Review various options for creating custom models. Decide whether one or many custom models will work better. 
5.	Collect training and testing data.
6.	Ensure the data is in an acceptable format.
7.	Train, test and evaluate, and deploy the model.
8.	Use the model endpoint in transcription calls.
9.	Operationalize your model building, evaluation, and deployment process.

Let's look more closely at these steps:

**1.	Use the Azure Speech SDK, Speech CLI, or REST API to generate transcripts for spoken sentences and utterances**



Azure Speech provides [SDKs](/azure/cognitive-services/speech-service/speech-sdk), a [CLI interface](/azure/cognitive-services/Speech-Service/spx-overview), and a [REST API](/azure/cognitive-services/speech-service/rest-speech-to-text) for generating transcripts from audio files or directly from microphone input. If you use an audio file, it needs to be in a [supported format](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio-data-for-testing). In this scenario, Contoso has previous event recordings (audio and video) in .avi files. Contoso can use tools like [FFmpeg](https://ffmpeg.org) to extract audio from the video files and save it in a format supported by the Azure Speech SDK, like .wav.

In the following code, we use the standard PCM audio codec, `pcm_s16le`, to extract audio in a single channel (mono) that has sampling rate of 8 KHz.

```
ffmpeg.exe -i INPUT_FILE.avi -acodec pcm_s16le -ac 1 -ar 8000 OUTPUT_FILE.wav
```

**2.	Compare the generated transcript with the human-generated transcript**

To perform the comparison, Contoso samples commentary audio from multiple sports and uses [Speech Studio](https://speech.microsoft.com) to compare the human-generated transcript with the results transcribed by Azure Speech service. The Contoso human-generated transcripts are in a WebVTT format. To use these transcripts, Contoso cleans them up and generates a simple .txt file that has normalized text without the timestamp information.

For information about using Speech Studio to create and evaluate a dataset, see [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train).

 Speech Studio provides a side-by-side comparison of the human-generated transcript and the transcripts produced from the models selected for comparison. Test results include a WER for the models, as shown here:

|Model  |Error rate  |Insertion  |Substitution  |Deletion|
|---------|---------|---------|---------|-|
|Model 1: 20211030     |    14.69%     |6 (2.84%)         |22 (10.43%)         |3 (1.42%)|
| Model 2: Olympics_Skiing_v6    |6.16%         |3 (1.42%)         | 8 (3.79%)   | 2 (0.95%)    |

For more information about WER, see [Evaluate word error rate](/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data?pivots=speech-studio#evaluate-word-error-rate).

Based on these results, the custom model (**Olympics_Skiing_v6**) is better than the base model (**20211030**) for the dataset.

Note the **Insertion** and **Deletion** rates, which indicate that the audio file is relatively clean and has low background noise.

**3.	If certain domain-specific words transcribe incorrectly, consider creating a custom speech model for that specific domain**

Based on the results in the preceding table, for the base model, **Model 1: 20211030**, about 10 percent of the words are being substituted. In Speech Studio, you can use the detailed comparison feature to identify domain-specific words that are missed. The following table shows of one section of the comparison.


|Human-generated transcript  |Model 1  |Model 2  |
|---------|---------|---------|
|olympic champion to go back to back in the downhill since nineteen ninety eight the great katja seizinger of germany what ninety four and ninety eight     |   olympic champion to go back to back in the downhill since nineteen ninety eight the great **catch a sizing are** of germany what ninety four and ninety eight      |   olympic champion to go back to back in the downhill since nineteen ninety eight the great katja seizinger of germany what ninety four and ninety eight      |
|she has dethroned the olympic champion goggia|she has dethroned the olympic champion **georgia**|she has dethroned the olympic champion goggia|


Model 1 doesn't recognize domain-specific words like the names of the athletes "Katia Seizinger" and "Goggia." This scenario reveals areas in which a custom model might help with the recognition of domain-specific words and phrases.

**4.	Review various options for creating custom models. Decide whether one or many custom models will work better**

By experimenting with various ways to build custom models, Contoso found that they could achieve better accuracy by using language and pronunciation model customization. (See [the first article in this guide.](custom-speech-text.yml#acoustic-and-language-model-adaptation)) Contoso also noted minor improvements when they included custom acoustic data when they built the custom model. However, the benefits weren't significant enough to make it worth maintaining and training for a custom acoustic model. 
 
Contoso found that creating separate custom language models for each sport (one model for alpine skiing, one model for luge, one model for snowboarding, and so on) provided better recognition results. They also noted that creating separate acoustic models based on the type of sport to augment the language models wasn't necessary.

**5.	Collect training and testing data**

The [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train) article provides details about collecting the data needed for training a custom model. Contoso collected transcripts for various Olympics sports by diverse commentators to build one pronunciation file that all the custom models (one for each sport) share. The training data is kept separate from the actual test data. Because the data is kept separate, after a custom model is built, they can test it by using event audio whose transcripts weren't included in the training dataset. The training and testing data can come from the same commentator but not from the same sport.

**6.	Ensure the data is in an acceptable format**

As described in [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train), datasets that are used to create a custom model or to test the model need to be in a specific format. Contoso's data is in WebVTT files. They created some simple tools to produce text files that contain normalized text for language model adaptation.

**7.	Train, test and evaluate, and deploy the model**

New event recordings are used to further test and evaluate the trained model. It can take a couple of iterations of testing and evaluation to fine-tune a model. Finally, when the model generates transcripts that have acceptable error rate, it's deployed (published) to be consumed from the SDK.

**8.	Use the model endpoint in your transcription calls**

You need only a few lines of code to point to the deployed custom model: 

```csharp
String endpoint = "Endpoint ID from Speech Studio";
string locale = "en-US";
SpeechConfig config = SpeechConfig.FromSubscription(subscriptionKey: speechKey, region: region);
SourceLanguageConfig sourceLanguageConfig = SourceLanguageConfig.FromLanguage(locale, endPoint);
recognizer = new SpeechRecognizer(config, sourceLanguageConfig, audioInput);
```

Notes about the code:
 
- `endpoint` is the endpoint ID of the custom model that's deployed in step 7.
- `subscriptionKey` and `region` are the Azure Cognitive Services subscription key and region. You can get these values in the [Azure portal](https://portal.azure.com) by going to the resource group where the Cognitive Services resource was created and looking at its keys.

**9.	Operationalize your model building, evaluation, and deployment process**

You need a process to keep deployed models up-to-date, mainly because new base models are published regularly. The next section of this article provides details on how to use scripting to streamline and automate the entire process of creating datasets for training and testing, building and evaluating models, and publishing new models as needed.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

- [Pratyush Mishra](https://www.linkedin.com/in/mishrapratyush) | Principal Engineering Manager 

Other contributors: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer 
- [Rania Bayoumy](https://www.linkedin.com/in/raniabayoumy) | Senior Technical Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Custom Speech?](/azure/cognitive-services/speech-service/custom-speech-overview)
- [What is text-to-speech?](/azure/cognitive-services/speech-service/text-to-speech)
- [Train a Custom Speech model](/azure/cognitive-services/speech-service/how-to-custom-speech-train-model?pivots=speech-studio)
- [Implement custom speech-to-text](../../guide/ai/custom-speech-text.yml) 

## Related resources

- [Artificial intelligence (AI) architecture design](../../data-guide/big-data/ai-overview.md)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](../../example-scenario/ai/speech-to-text-transcription-analytics.yml)
- [Speech services](../../solution-ideas/articles/speech-services.yml)
- [Control IoT devices with a voice assistant app](../../solution-ideas/articles/iot-controlling-devices-with-voice-assistant.yml)
- [Implement custom speech-to-text](../../guide/ai/custom-speech-text.yml) 