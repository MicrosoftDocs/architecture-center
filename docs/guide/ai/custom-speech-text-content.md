This two-part guide describes various approaches for efficiently implementing high-quality speech-aware applications. It focuses on extending and customizing the baseline model of speech-to-text functionality provided by the [Azure Cognitive Services Speech service](/azure/cognitive-services/speech-service/custom-speech-overview).

This article describes the problem space and decision-making process for designing your solution. The [second article] provides a use case for applying these instructions and recommended practices.

## The pre-built and custom AI spectrum

The pre-built and custom AI spectrum represents multiple AI model customization and development effort tiers, ranging from ready-to-use pre-built models to fully customized AI solutions.      

:::image type="complex" source="media/spectrum.png" alt-text="Diagram that shows the spectrum of customization tiers." lightbox="media/spectrum.png":::
Pre-built and pre-trained models are on the left side, customized pre-built models are in the middle, and customized models tailored to your scenario and data are on the right side.
:::image-end:::

From the left, [Azure Cognitive Services]() enables quick and low friction implementation of AI capabilities into applications through pre-trained models. Microsoft curates extensive datasets to train and build these baseline models. As a result, leveraging baseline models require no additional training data and are consumed via secured programmatic API calls. Azure Cognitive Services include:
- **Speech**: speech-to-text, text-to-speech, speech translation, and speaker recognition.
- **Language**: entity recognition, sentiment analysis, question answering, conversational language understanding, and translator.
- **Vision**: computer vision and Face API.
- **Decision**: anomaly detector, content moderator, and personalizer.
- **OpenAI Service**: advanced language models.

When the pre-built baseline models do not perform accurately enough on your data, they are extensible by customizing the pre-built models by adding additional training data relative to the problem domain. Examples of Cognitive Services that are customizable include [Custom Vision](), [Custom Translator](), [Custom Speech](), and [CLU](). Customizing models with these services requires additional effort in gathering adequate data to train and evaluate an acceptable custom model. Extending pre-built Cognitive Services models brings us to the center of the spectrum, where most of this document will be focused. 

Alternatively, when models and training data focus on a specific scenario and require a proprietary training dataset, [Azure Machine Learning]() provides custom solution resources, tooling, compute, and workflow guidance to support building entirely custom models. The AI spectrum describes this scenario on the far-right as tailored custom models. These models are built from scratch. The typical experience of developing a model using Azure Machine Learning ranges from using visual tooling such as [AutoML]() or programmatically via a [notebook]() experience. 

## The Azure Speech service

[Azure Speech service]() unifies speech-to-text, text-to-speech, speech translation, voice assistant, and speaker recognition functionality into a single cognitive services-based subscription offering. Speech-enabling an application is possible by integrating with Azure Speech Service via easy-to-use SDKs and APIs. 

The Azure speech-to-text service analyzes audio in real-time or batch to transcribe the spoken word into text. Out of the box, Azure speech to text utilizes a Universal Language Model as a baseline model that reflects commonly used spoken language. This baseline model is pre-trained with dialects and phonetics representing a variety of common domains. As a result, consuming the baseline model requires no additional configuration and works very well in most scenarios.

**The baseline model may not be sufficient if the audio contains ambient noise or includes a lot of industry and domain-specific jargon. In these cases, building a custom speech model makes sense by training with additional data associated with that specific domain.** 

Depending on the size of the custom domain, it may also make sense to train multiple models and compartmentalize a model for an individual application. For instance, Olympic commentators report on various events, each associated with its own vernacular. Because each Olympic event vocabulary differs significantly from others, building a custom model specific to an event increases accuracy by limiting the utterance data relative to that particular event. As a result, the model doesn’t need to sift through unrelated data to make a match.

There are three different approaches to implementing Azure speech-to-text:
1)	The **baseline model** applies when the audio is clear of ambient noise and the speech transcribed consists of commonly spoken language.
2)	A **custom model** augments the baseline model to include domain-specific vocabulary shared across all areas of the custom domain.
3)	**Multiple custom models** make sense when the custom domain has numerous areas, each with a specific vocabulary.

image

## Potential use cases 

Here are some generic scenarios and use cases where Custom Speech is helpful: 

- Speech Transcription for a specific domain – Medical Transcription, Call center transcription
- Live transcription as in an app or providing a captioning pipeline for live video streaming

## Microsoft SDKs and Open-Source Tools

Below are useful resources for working with speech-to-text.

- [Azure Speech SDK]
- [Speech Studio]
- [FFMpeg / SOX] 

## Design Considerations

This section looks at some design considerations for building a speech-based application.

### Baseline model vs. Custom model

Azure speech includes baseline models supporting various languages. These models are pre-trained with a vast amount of vocabulary and domains. However, customers may have a very specialized vocabulary that needs recognition. For these situations, baseline models may fall short. The best way to see if the base model will suffice is to analyze the transcription produced from the baseline model and compare it with a human-generated transcript for the same audio. Section 2 of the document details leveraging Speech Studio to compare the transcripts and obtain a word error rate (WER) score. If there are multiple incorrect word substitutions when evaluating the results, then training a custom model to recognize those words is recommended.

### 1 vs. Many Custom models

If the customer scenario determines that it can benefit from a custom model, the next question is how many models to build. One model is typically sufficient if the utterances are closely related to one area or domain. On the other hand, multiple models are best if the vocabulary is quite different across the domain areas. Regardless, this situation still requires a decent variety of training data. 

For example, the customer is responsible for providing the broadcast of Olympic events. Their requirements include the transcription of audio commentary for multiple events, including ice hockey, luge, snowboarding, alpine skiing, and more. Building a custom speech model for each event will improve accuracy because each event has unique terminology. However, each model must have diverse training data. It is too restrictive and not extensible to create a model for each commentator for each event. Instead, a more practical approach is to build a single model for each event but include audio from various commentators who have different accents, gender, age, etc.

In the case of an Olympic event broadcast, creating models for each commentator is too restrictive and inextensible. Furthermore, training a single model for all events is less effective because each has a unique vocabulary. In this case, the recommended approach is to train a single model for each Olympic event. This way, all domain-specific phrases related to the event as captured by diverse commentators reside in the same model. In addition, it is essential to consider which languages and locales need to be supported; it may make sense to create these models by locale.

### Acoustic and language model adaptation

Azure speech provides three different options for training a custom model:

**Acoustic model adaptation** provides phonetic training on the pronunciation of certain words for Azure speech to properly recognize them. Building an acoustic model requires audio samples with accompanying human-generated transcripts. If the recognition language matches common locales like en-US, leveraging the current baseline model should be sufficient. Baseline models have diverse training using the voices of native and non-native English speakers to cover a vast amount of English vocabulary. Therefore, building an acoustic model adaptation on the en-US base model may not provide many benefits. Training a custom acoustic model also takes a bit more time. This [Azure documentation article]() offers more details about the data requirements for custom acoustic training. 

**Language model adaptation** is the most commonly used customization. A language model is helpful in training how certain words are used together in a particular context or a specific domain. Building a language model is also relatively easy and fast. First, train the model by supplying a variety of utterances and phrases for the particular domain. For example, if the scenario’s goal is to generate transcription for the Olympic alpine skiing event, then collect human-generated transcripts of multiple skiing events; clean and combine them to create one training data file with around 50K phrases and sentences. This [Azure documentation article] provides more details about the data requirements for custom language model training. 

**Pronunciation model customization** is also one of the most commonly used model customization approaches. A pronunciation model is used to help recognize uncommon words that do not have a standard pronunciation. For example, some of the terminology in alpine skiing borrows from other languages, such as the terms schuss and mogul. These words are excellent candidates for training using a pronunciation data set. This [Azure documentation article] provides more details about improving recognition using a pronunciation file, and this [Azure documentation article] offers details about building a custom model using Speech Studio. 

Note that the final custom model can include datasets using a combination of all three of the customizations above. 

### Training a custom model

There are two approaches to training a custom model:

1.	Train with numerous examples of phrases and utterances from the domain, including transcripts of cleaned and normalized alpine skiing event audio and human-generated transcripts of previous events. Ensure the transcripts include the terms used in alpine skiing with multiple examples of how commentators pronounce them. The resulting custom model will then have the ability to recognize domain-specific words and phrases.
2.	Train with specific data that focuses on the problem areas. This approach is suited well for situations where there isn’t a lot of training data. For example, new slang terms are used during alpine skiing events and need inclusion in the model. Training this type of model uses the following approach:
    - Use Speech Studio to generate a transcription and compare it with human-generated transcriptions.
    - Identify problem areas revealed as patterns based on what the commentators are saying.
       - Identify the contexts within which the problem word or utterance is applied.
       - Identify different inflections and pronunciations of the word or utterance.
       - Identify any unique commentator-specific applications of the word or utterance.
       
Training a custom model with specific data can be pretty time-consuming. Steps include carefully analyzing the transcription gaps, manually adding training phrases, and repeating this process multiple times. However, in the end, this approach provides focused training for the problem areas that were previously incorrectly transcribed. Furthermore, it is possible to iteratively build this model by selectively training on high and critical importance areas, then proceeding down the list in order of importance. As an added bonus, the dataset size will include a few hundred utterances versus a few thousand, even after many iterations of building the training data. 

### Limitations of Speech Studio

In developing custom models, certain limitations of Speech Studio may become apparent.

1.	**Speech Studio produces WER based on lexical text.** However, what the end user sees is the  display text with punctuations, capitalization and numerical words represented as numbers. Below is an example of lexical text versus display text:

    Lexical: the speed is great and the time is even better fifty seven oh six seconds for the german

    Display Text: The speed is great. And that time is even better. 57063 seconds for the German. 

    And what is expected (implied) is: The speed is great. And that time is even better. 57.063 seconds for the German

    Even though the custom model has a low WER rate, it doesn’t mean that user-perceived error (errors in display text) is low. This issue is primarily seen with alphanumeric input because different applications may have alternate ways of representing them. So, it is vital to not purely rely on the WER but also review the final recognition result produced. 
 
    When display text seems wrong, review the detailed recognition result received from the SDK which includes lexical text where everything is spelled out. If the lexical text is correct – that means the recognition is accurate. Inaccuracies in the display text (final recognized result) can then be solved by adding some post-processing rules.
2.	**Manage datasets, models, and their versions.** In Speech Studio, when creating projects, datasets, and models, there are only two fields – name and description. Therefore, once we start to build datasets and models iteratively, it is important to follow a good naming and versioning scheme to make it easy to identify the contents of a dataset and which model reflects which version of the dataset. More details on this are in the Sample Commands section of the document.

## Contributors

Principal author: 

Pratyush Mishra- Principal Engineering Manager https://www.linkedin.com/in/mishrapratyush/

Other Contributors: 

Mick Alberts 

Rania Bayoumy- Senior Technical Program Manager https://www.linkedin.com/in/raniabayoumy/ 

## Next steps

- Artificial intelligence (AI) architecture design
- What is Custom Speech?
- What is text-to-speech?
- Train a Custom Speech model
- Link to Deployment / Implementation guide

## Related resources

- Use a speech-to-text transcription pipeline to analyze recorded conversations
- Speech services
- Control IoT devices with a voice assistant app
- Link to Deployment / Implementation guide

