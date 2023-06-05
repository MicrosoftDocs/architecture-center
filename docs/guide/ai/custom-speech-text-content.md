This two-part guide describes various approaches for efficiently implementing high-quality speech-aware applications. It focuses on extending and customizing the baseline model of speech-to-text functionality that's provided by the [Azure Cognitive Services Speech service](/azure/cognitive-services/speech-service/custom-speech-overview).

This article describes the problem space and decision-making process for designing your solution. The second article, [Deploy a custom speech-to-text solution](custom-speech-text-deploy.yml), provides a use case for applying these instructions and recommended practices.

## The pre-built and custom AI spectrum

The pre-built and custom AI spectrum represents multiple AI model customization and development effort tiers, ranging from ready-to-use pre-built models to fully customized AI solutions.

:::image type="complex" source="media/spectrum.png" alt-text="Diagram that shows the spectrum of customization tiers." lightbox="media/spectrum.png":::
Pre-built and pre-trained models are on the left side, customized pre-built models are in the middle, and customized models tailored to your scenario and data are on the right side.
:::image-end:::

On the left side of the spectrum, [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) enables a quick and low-friction implementation of AI capabilities into applications via pre-trained models. Microsoft curates extensive datasets to train and build these baseline models. As a result, you can use baseline models with no additional training data. They're consumed via enhanced-security programmatic API calls. 

Cognitive Services includes:

- **Speech.** Speech-to-text, text-to-speech, speech translation, and speaker recognition
- **Language.** Entity recognition, sentiment analysis, question answering, conversational language understanding, and translator
- **Vision.** Computer vision and Face API
- **Decision.** Anomaly detector, content moderator, and Personalizer
- **OpenAI Service.** Advanced language models

When the pre-built baseline models don't perform accurately enough on your data, you can customize them by adding training data that's relative to the problem domain. This customization requires the extra effort of gathering adequate data to train and evaluate an acceptable model. Cognitive Services that are customizable include [Custom Vision](/azure/cognitive-services/custom-vision-service/overview), [Custom Translator](/azure/cognitive-services/translator/custom-translator/overview), [Custom Speech](/azure/cognitive-services/speech-service/custom-speech-overview), and [CLU](/azure/cognitive-services/language-service/conversational-language-understanding/overview). Extending pre-built Cognitive Services models is in the center of the spectrum. Most of this article is focused on that central area.

Alternatively, when models and training data focus on a specific scenario and require a proprietary training dataset, [Azure Machine Learning](/azure/machine-learning/overview-what-is-azure-machine-learning) provides custom solution resources, tools, compute, and workflow guidance to support building entirely custom models. This scenario appears on the right side of the spectrum. These models are built from scratch. Developing a model by using Azure Machine Learning typically ranges from using visual tools like [AutoML](/azure/machine-learning/concept-automated-ml) to programmatically developing the model by using [notebooks](/azure/machine-learning/samples-notebooks). 

## Azure Speech service

[Azure Speech service](/azure/cognitive-services/speech-service/overview) unifies speech-to-text, text-to-speech, speech translation, voice assistant, and speaker recognition functionality into a single subscription that's based on Cognitive Services. You can enable an application for speech by integrating with Speech service via easy-to-use SDKs and APIs.

The Azure speech-to-text service analyzes audio in real time or asynchronously to transcribe the spoken word into text. Out of the box, Azure speech-to-text uses a Universal Language Model as a baseline that reflects commonly used spoken language. This baseline model is pre-trained with dialects and phonetics that represent a variety of common domains. As a result, consuming the baseline model requires no extra configuration and works well in most scenarios.

Note, however, that the baseline model might not be sufficient if the audio contains ambient noise or includes a lot of industry and domain-specific jargon. In these cases, building a custom speech model makes sense. You do that by training with additional data that's associated with the specific domain.

Depending on the size of the custom domain, it might also make sense to train multiple models and compartmentalize a model for an individual application. For example, Olympics commentators report on various sports, each with its own jargon. Because each sport has a vocabulary that differs significantly from the others, building a custom model specific to a sport increases accuracy by limiting the utterance data relative to that particular sport. As a result, the model can learn from a precise and targeted set of data.

So there are three approaches to implementing Azure speech-to-text:

- The **baseline model** is appropriate when the audio is clear of ambient noise and the transcribed speech consists of commonly spoken language.
- A **custom model** augments the baseline model to include domain-specific vocabulary that's shared across all areas of the custom domain.
- **Multiple custom models** make sense when the custom domain has numerous areas, each with a specific vocabulary.

:::image type="content" source="media/three-approaches.png" alt-text="Diagram that summarizes the three approaches to implementing Azure speech-to-text." lightbox="media/three-approaches.png":::

## Potential use cases

Here are some generic scenarios and use cases in which custom speech-to-text is helpful: 

- Speech transcription for a specific domain, like medical transcription or call center transcription
- Live transcription, as in an app or to provide captions for live video streaming

## Microsoft SDKs and open-source tools

When you're working with speech-to-text, you might find these resources helpful:

- [Azure Speech SDK](/azure/cognitive-services/speech-service/speech-sdk)
- [Speech Studio](https://speech.microsoft.com/portal)
- [FFMpeg](https://ffmpeg.org) / [SOX](http://sox.sourceforge.net)

## Design considerations

This section describes some design considerations for building a speech-based application.

### Baseline model vs. custom model

Azure Speech includes baseline models that support various languages. These models are pre-trained with a vast amount of vocabulary and domains. However, you might have a specialized vocabulary that needs recognition. In these situations, baseline models might fall short. The best way to determine if the base model will suffice is to analyze the transcription that's produced from the baseline model and compare it to a human-generated transcript for the same audio. The [deployment article](custom-speech-text-deploy.yml) in this guide describes using Speech Studio to compare the transcripts and obtain a word error rate (WER) score. If there are multiple incorrect word substitutions in the results, we recommend that you train a custom model to recognize those words.

### One vs. many custom models

If your scenario will benefit from a custom model, you next need to determine how many models to build. One model is typically sufficient if the utterances are closely related to one area or domain. However, multiple models are best if the vocabulary is significantly different across the domain areas. In this scenario, you also need a variety of training data.

Let's return to Olympics example. Say you need to include the transcription of audio commentary for multiple sports, including ice hockey, luge, snowboarding, alpine skiing, and more. Building a custom speech model for each sport will improve accuracy because each sport has unique terminology. However, each model must have diverse training data. It's too restrictive and inextensible to create a model for each commentator for each sport. A more practical approach is to build a single model for each sport but include audio from a group of that includes commentators with different accents, of both genders, and of various ages. All domain-specific phrases related to the sport as captured by the diverse commentators reside in the same model. 

You also need to consider which languages and locales to support. It might make sense to create these models by locale.

### Acoustic and language model adaptation

Azure Speech provides three options for training a custom model:

**Language model adaptation** is the most commonly used customization. A language model helps to train how certain words are used together in a particular context or a specific domain. Building a language model is also relatively easy and fast. First, train the model by supplying a variety of utterances and phrases for the particular domain. For example, if the goal is to generate transcription for alpine skiing, collect human-generated transcripts of multiple skiing events. Clean and combine them to create one training data file with about 50 thousand phrases and sentences. For more details about the data requirements for custom language model training, see [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio-and-human-labeled-transcript-data).

**Pronunciation model customization** is also one of the most commonly used customizations. A pronunciation model helps the custom model recognize uncommon words that don't have a standard pronunciation. For example, some of the terminology in alpine skiing borrows from other languages, like the terms *schuss* and *mogul*. These words are excellent candidates for training with a pronunciation dataset. For more details about improving recognition by using a pronunciation file, see [Pronunciation data for training](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#pronunciation-data-for-training). For details about building a custom model by using Speech Studio, see [What is Custom Speech?](/azure/cognitive-services/speech-service/custom-speech-overview). 

**Acoustic model adaptation** provides phonetic training on the pronunciation of certain words so that Azure Speech can properly recognize them. To build an acoustic model, you need audio samples and accompanying human-generated transcripts. If the recognition language matches common locales, like en-US, using the current baseline model should be sufficient. Baseline models have diverse training that uses the voices of native and non-native English speakers to cover a vast amount of English vocabulary. Therefore, building an acoustic model adaptation on the en-US base model might not provide much improvement. Training a custom acoustic model also takes a bit more time. For more information about the data requirements for custom acoustic training, see [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio-and-human-labeled-transcript-data).

The final custom model can include datasets that use a combination of all three of the customizations described in this section. 

### Training a custom model

There are two approaches to training a custom model:

- Train with numerous examples of phrases and utterances from the domain. For example, include transcripts of cleaned and normalized alpine skiing event audio and human-generated transcripts of previous events. Be sure that the transcripts include the terms used in alpine skiing and multiple examples of how commentators pronounce them. If you follow this process, the resulting custom model should be able to recognize domain-specific words and phrases.

- Train with specific data that focuses on problem areas. This approach works well when there isn't much training data, for example, if new slang terms are used during alpine skiing events and need to be included in the model. This type of training uses the following approach:
    - Use Speech Studio to generate a transcription and compare it with human-generated transcriptions.
    - Identify problem areas from patterns in what the commentators say. Identify:
       - The contexts within which the problem word or utterance is applied.
       - Different inflections and pronunciations of the word or utterance.
       - Any unique commentator-specific applications of the word or utterance.
       
Training a custom model with specific data can be time-consuming. Steps include carefully analyzing the transcription gaps, manually adding training phrases, and repeating this process multiple times. However, in the end, this approach provides focused training for the problem areas that were previously incorrectly transcribed. And it's possible to iteratively build this model by selectively training on critical areas and then proceeding down the list in order of importance. Another benefit is that the dataset size will include a few hundred utterances rather than a few thousand, even after many iterations of building the training data. 

### After you build your model

After you build your model, keep the following recommendations in mind:

-	**Be aware of the difference between lexical text and display text.** Speech Studio produces WER based on lexical text. However, what the user sees is the  display text with punctuation, capitalization, and numerical words represented as numbers. Following is an example of lexical text versus display text.

    **Lexical text:** the speed is great and the time is even better fifty seven oh six three seconds for the german

    **Display text:** The speed is great. And that time is even better. 57063 seconds for the German. 

    What's expected (implied) is: The speed is great. And that time is even better. **57.063** seconds for the German

    The custom model has a low WER rate, but that doesn't mean that user-perceived error rate (errors in display text) is low. This problem occurs mainly in alphanumeric input because different applications can have alternative ways of representing the input. You shouldn't rely only on the WER. You also need to review the final recognition result. 
 
    When display text seems wrong, review the detailed recognition result from the SDK, which includes lexical text, in which everything is spelled out. If the lexical text is correct, the recognition is accurate. You can then resolve inaccuracies in the display text (the final recognized result) by adding post-processing rules.

-	**Manage datasets, models, and their versions.** In Speech Studio, when you create projects, datasets, and models, there are only two fields: name and description. When you build datasets and models iteratively, you need to follow a good naming and versioning scheme to make it easy to identify the contents of a dataset and which model reflects which version of the dataset. For more details about this recommendation, see [Deploy a custom speech-to-text solution](custom-speech-text-deploy.yml).

> [!div class="nextstepaction"]
> [Go to part two of this guide: deployment](custom-speech-text-deploy.yml)

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
- [Deploy a custom speech-to-text solution](custom-speech-text-deploy.yml)

## Related resources

- [Artificial intelligence (AI) architecture design](../../data-guide/big-data/ai-overview.md)
- [Use a speech-to-text transcription pipeline to analyze recorded conversations](../../example-scenario/ai/speech-to-text-transcription-analytics.yml)
- [Speech services](../../solution-ideas/articles/speech-services.yml)
- [Control IoT devices with a voice assistant app](../../solution-ideas/articles/iot-controlling-devices-with-voice-assistant.yml)

