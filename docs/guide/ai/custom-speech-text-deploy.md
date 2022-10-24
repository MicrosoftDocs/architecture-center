---
title: Deploy a custom speech-to-text solution
description: <Write a 100-160 character description that ends with a period and ideally starts with a call to action. This becomes the browse card description.>
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

This article is an implementation guide and case study that provides a sample deployment of the solution described in **Implement custom speech-to-text**:

> [!div class="nextstepaction"]
> [Go to part one of this guide](custom-speech-text.yml)

## Case study

This article is based on the following fictional case study: 

Contoso, Ltd., is a broadcast media company that airs broadcasts and commentary on Olympics events. As part of the broadcast agreement, Contoso provides event transcription for accessibility and data mining. 

Contoso wants to use the Azure Speech service to provide live subtitling and audio transcription for Olympics events. Contoso employs female and male commentators from around the world who speak with diverse accents. In addition, each individual sport has specific terminology that can make transcription difficult. This article describes the application development process for this scenario: providing subtitles for an application that needs to deliver accurate event transcription.

Contoso already has these required prerequisite components in place:
 
- Human-generated transcripts for previous Olympics events. The transcripts represent different sports and diverse commentators.
- An Azure Cognitive Service resource. You can create one on the [Azure portal](https://ms.portal.azure.com). 

## Develop a custom speech-based application

A speech-based application uses the Azure Speech SDK to connect to the Azure Speech service to generate text-based audio transcription. Speech service supports [various languages](/azure/cognitive-services/speech-service/language-support) and two fluency modes: conversational and dictation. To develop a custom speech-based application, you  generally need to complete these steps:

1.	Use the Azure Speech SDK, Speech CLI, or REST APIs to generate transcripts for spoken sentences and utterances.
2.	Compare the generated transcript with the human-generated transcript.
3.	If certain domain-specific words transcribe incorrectly, consider creating a custom speech model for that specific domain.
4.	Review various options for creating custom models. Decide whether one or many custom models will work better. 
5.	Collect training and testing data.
6.	Ensure the data is in an acceptable format.
7.	Train, test and evaluate, and deploy the model.
8.	Use the model endpoint in transcription calls.
9.	Operationalize your model building, evaluation, and deployment process.

Let's look more closely at these steps:

**1.	Use the Azure Speech SDK, Speech CLI, or REST APIs to generate transcripts for spoken sentences and utterances.**

```
ffmpeg.exe -i INPUT_FILE.avi -acodec pcm_s16le -ac 1 -ar 8000 OUTPUT_FILE.wav
```

Azure Speech provides [SDKs](/azure/cognitive-services/speech-service/speech-sdk), a [CLI interface](/azure/cognitive-services/Speech-Service/spx-overview), and [REST APIs](/azure/cognitive-services/speech-service/rest-speech-to-text) for generating transcripts for audio files or directly from microphone input. If you use a audio file, it needs to be in a [supported format](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio-data-for-testing). In this scenario, Contoso has previous event recordings (audio and video) in .avi files. Contoso can use tools like [FFmpeg](https://ffmpeg.org) to extract audio from the video files and save it in a format supported by the Azure Speech SDK, like .wav.

In the preceding code, we use the standard PCM audio codec, `pcm_s16le`, to extract audio in a single channel (mono) that has sampling rate of 8 KHz.

**2.	Compare the generated transcript with the human-generated transcript.**

To perform the comparison, Contoso samples commentary audio from multiple sports and uses [Speech Studio](https://speech.microsoft.com) to compare the human-generated transcript with the results transcribed by Azure Speech service. The Contoso human-generated transcripts are in a WebVTT format. To use these transcripts, Contoso cleans them up and generates a simple .txt file that has normalized text without the timestamp information.

For information about using Speech Studio to create and evaluate a dataset, see [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train).

 Speech Studio provides a side-by-side comparison of the human-generated transcript and the transcripts produced from the models selected for comparison. Test results include a word error rate (WER) for the models:

:::image type="content" source="./media/word-error-rate.png" alt-text="Screenshot that shows the WER in Speech Studio." lightbox="./media/word-error-rate.png":::

For more information about WER, see [Evaluate word error rate](/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data?pivots=speech-studio#evaluate-word-error-rate).

Based on these results, the custom model (**Olympic_Skiing_v6**) is better than the base model (**20211030**) for the dataset.

Note the **Insertion** and **Deletion** rates, which indicate that the audio file is relatively clean and has low background noise.

**3.	If certain domain-specific words transcribe incorrectly, consider creating a custom speech model for that specific domain.**

Based on the preceding screenshot, for the base model, **Model 1: 20211030**, about 10 percent of the words are being substituted. In Speech Studio, you can use the detailed comparison feature to identify domain-specific words that are missed. The following screenshot shows of one section of the comparison. The left column is the human-generated transcript, the middle column is Model 1, and the right column is Model 2:

:::image type="content" source="./media/example-comparison.png" alt-text="Screenshot that shows the comparison." lightbox="./media/example-comparison.png":::

Model 1 doesn't recognize domain-specific words like the names of the athletes "Katia Seizinger" and "Goggia." This scenario reveals areas in which a custom model might help with the recognition of domain-specific words and phrases.

**4.	Review various options for creating custom models. Decide whether one or many custom models will work better.**

By experimenting with various ways to build custom models, Contoso found that they could achieve better accuracy by using language and pronunciation model customization. (See [the first article in this guide.](custom-speech-text.yml#acoustic-and-language-model-adaptation)) Contoso also noted minor improvements when they included custom acoustic data when they built the custom model. However, the benefits weren't significant enough to make it worth maintaining and training for a custom acoustic model. 
 
Contoso found that creating separate custom language models for each sport (one model for alpine skiing, one model for luge, one model for snowboarding, and so on) provided better recognition results. They also noted that creating separate acoustic models based on the type of sport to augment the language models wasn't necessary.

**5.	Collect training and testing data.**

The [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train) article provides details about collecting the data needed for training a custom model. Contoso collected transcripts for various Olympics sports by diverse commentators to build one pronunciation file that all the custom models (one for each sport) share. The training data is kept separate from the actual test data. Because the data is kept separate, after a custom model is built, they can test it by using event audio whose transcripts weren't included in the training dataset. The training and testing data can come from the same commentator but not from the same sport.

**6.	Ensure the data is in an acceptable format.**

As described in [Training and testing datasets](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train), datasets that are used to create a custom model or to test the model need to be in a specific format. Contoso's data is in WebVTT files. They created some simple tools to produce text files that contain normalized text for language model adaptation.

**7.	Train, test and evaluate, and deploy the model.**

New event recordings are used to further test and evaluate the trained model. It can take a couple of iterations of testing and evaluation to fine-tune a model. Finally, when the model generates transcripts that have acceptable error rate, it's deployed (published) to be consumed from the SDK.

**8.	Use the model endpoint in your transcription calls.**

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

**9.	Operationalize your model building, evaluation, and deployment process.**

A process to keep deployed models up-to-date is essential to success, primarily since new base models are published regularly. The [Sample Commands section] of the document has some details on how scripting can be used to streamline and automate the entire process of creating datasets for training and testing, building and evaluating models, and publishing new models as needed.

## Sample commands

This section shows how [Speech CLI with PowerShell](/azure/cognitive-services/Speech-Service/spx-basics?tabs=windowsinstall%2Cpowershell) can be used to upload datasets, train custom models and run evaluations.

**1.	Setup key and region**

spx --% config @key --set SpeechSubscriptionKey
spx --% config @region --set SpeechServiceRegion

**2.	Create a speech studio project**

spx csr project create --name testcli2 --language "en-us" --description "new project 2" --output url '@my.project.txt'

**3.	Upload dataset**

Use spx csr dataset upload command to upload pronunciation (kind = pronunciation), plain text (kind=language) and evaluation data (kind=acoustic)


**3.1	Pronunciation file**

```
spx csr dataset upload –project '@my.project.txt' –name "cli_pronunciationModel" –kind Pronunciation –data ..\data\train\pronunciation.txt –output url '@my.dataset.pm.txt'

## get status

spx csr dataset status –dataset '@my.dataset.pm.txt' –wait
```

**3.2	Plain text (for language model adaptation)**

```
spx csr dataset upload –project '@my.project.txt' –name "cli_languageModel" –kind Language –data ..\data\train\languageModel.txt –output url '@my.dataset.lm.txt'
 
## get status

spx csr dataset status --dataset '@my.dataset.lm.txt' –wait
```

**3.3	Test data**

```
spx csr dataset upload --project '@my.project.txt' --name "evalDataset1" --kind Acoustic --data ..\data\test\EvalDataset1.zip --output url '@my.dataset.test1.txt'

## get status

spx csr dataset status --dataset '@my.dataset.test1.txt' –wait
```

**4.	Create a custom model**

**4.1	Combine the dataset ouputs into one file to use that as input**

Get-Content .\my.dataset.lm.txt -Raw | Add-Content -Path .\my.datasets.test.txt
Get-Content .\my.dataset.pm.txt -Raw | Add-Content -Path .\my.datasets.test.txt

**4.2	Create the custom model**

```
spx csr model create --project "@my.project.txt" --name "cli_model" --datasets "@my.datasets.test.txt" --output url "@my.model.txt"

# # get status
spx csr model status --model "my.model.txt" –wait
```
Note: when creating custom model, there is also an option to select the base model to use to do the adaptations on. If no base model is provided, then the last base model that lets do Language, Pronunciation and Acoustic model adaptation will be used. Scripts below provides a way to get a list of all the available base models and then search for the base model to use for adaptation.

**5.	Select a base model to use**

**5.1	Get a list of base models and output that in a json file**
```
spx csr model list --base models --output json baseModels.json
```
Note: The output json file needs to be fixed so it is well formed. Currently the output is a merge of paged results. To make it wellformed just add a parent node (say “baseModels”) .

**5.2	Read the required base model details**
```
function get-baseModel-Json{
	param($baseModelName, $baseModelLocale, $filePath)
	$baseModelJson = Get-Content $filePath -Raw | ConvertFrom-Json
	foreach ($values in $baseModelJson.baseModels)
	{
		foreach($modelJson in $values.values){
			if($modelJson.locale -eq $baseModelLocale -and $modelJson.displayName -eq $baseModelName) {
				return $modelJson
			}
		}
	}
}

$locale = "en-US"
$filePath = ".\baseModelsFixed.json"
$baseModelName = "20211030"

$bmJson = get-baseModel-Json -baseModelName $baseModelName -baseModelLocale $locale -filePath $filePath

Write-Host $bmJson
```
**6.	Evaluate the model**
```
spx csr evaluation create --project "@my.project.txt" --name evaluation1 --model1 "@my.model.txt" --model2 $bmJson.self --dataset '@my.dataset.test1.txt' --output url "@my.eval1.txt"
## wait for it to finish
spx csr evaluation status --evaluation "@my.eval1.txt" --wait
```

## Contributors

Principal author: Pratyush Mishra- Principal Engineering Manager https://www.linkedin.com/in/mishrapratyush/
Other Contributors: Rania Bayoumy- Senior Technical Program Manager https://www.linkedin.com/in/raniabayoumy/ 

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

