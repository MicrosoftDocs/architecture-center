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

This article is an implementation guide and case study that provides a sample deployment for the associated article, Implement custom speech-to-text.[link to other article]

Contoso is a broadcast media company responsible for airing broadcasts and commentary on Olympic events. In addition, Contoso provides reliable event transcription both for accessibility and data mining purposes as part of the broadcast agreement. 

Contoso seeks to provide live subtitling and audio transcription for Olympic events using the Azure Speech service. However, it is important to note that Contoso employs diverse commentators worldwide, representing different genders and accents. In addition, each event has specific terminology that can make transcription difficult. This section describes the application development process of this scenario – providing subtitles for an application focused on delivering accurate event transcription to its users.

**Assumptions:**

Human-generated transcripts for various previous Olympic events from diverse commentators are available. And you have created an Azure Cognitive Service resource by going to portal.azure.com

## Custom Speech-based Application Development Process 

A speech-based application uses the Azure Speech SDK to connect to the Azure speech service to generate text-based audio transcription. There is support for [various languages](/azure/cognitive-services/speech-service/language-support) and two fluency modes, conversational and dictation. The development of a custom speech-based application generally takes the following steps:

1.	Use Azure Speech SDK/CLI/APIs to generate transcripts for spoken sentences and utterances
2.	Compare the quality of the generated transcript with the ground truth (human-generated transcript).
3.	If certain domain-specific words transcribe incorrectly, then look into building a custom speech model for that specific domain
4.	Review various custom model building options and decide if 1 or many custom models would be a better fit. 
5.	Collect training and testing data
6.	Massage the data in an acceptable format
7.	Train, test/evaluate, and deploy the model
8.	Use the model endpoint in transcription calls.
9.	Operationalize your model building, evaluating, and deployment process.

Let’s look into these steps in more detail:

**1.	Use Azure Speech SDK/CLI/APIs to generate transcripts for spoken sentences and utterances**

image

Azure speech provides [SDKs](/azure/cognitive-services/speech-service/speech-sdk?tabs=windows%2Cubuntu%2Cios-xcode%2Cmac-xcode%2Candroid-studio), [CLI interface](/azure/cognitive-services/Speech-Service/spx-overview), and [REST APIs](/azure/cognitive-services/speech-service/rest-speech-to-text) that are to be used to generate transcripts for a given audio file or directly from microphone input. If using audio file, then it needs to be in a [supported format](/azure/cognitive-services/speech-service/how-to-custom-speech-test-and-train#audio-data-for-testing). In this example, Contoso has previous event recordings (audio and video) in *.avi files. They can leverage tools like [FFmpeg](https://ffmpeg.org) to extract audio from the video files and save it in a format supported by the Azure Speech SDK, such as *.wav.

Here we are using the standard PCM audio codec - pcm_16le to extract audio in a single channel (mono) that has sampling rate of 8khz. 

**2.	Compare the quality of the generated transcript with the ground truth (human-generated) transcript.**

To perform the comparison, Contoso samples commentary audio from multiple events and leverages [Speech Studio](https://speech.microsoft.com) to help with comparing the ground truth with the transcribed results from the Azure Speech service. In Contoso’s case, the ground truth is in a WebVTT format. To be able to use these existing transcripts (WebVTT files), Contoso cleans them up and generates a simple txt file that has normalized text without the timestamp information. 

Refer to this [Azure documentation article] about using Speech Studio for creating and evaluating a dataset. 

Once a sample test completes in the Speech Studio, it produces detailed results, including Word Error Rate (WER) on different models. Speech Studio provides a side-by-side comparison of the ground truth and the transcripts produced from the models selected for comparison. The screenshot below shows WER for our sample file:

image

Refer to [this link](/azure/cognitive-services/speech-service/how-to-custom-speech-evaluate-data?pivots=speech-studio#evaluate-word-error-rate) which explains WER in more detail.

From the screenshot above, the custom model (Olympic_Skiing_v6) is doing better than the base model (20211030) for the dataset.

Observe the Insertion and Deletion rates (low error rates) that indicate that the audio file is relatively clean and has low background noise.

**3.	If certain domain-specific words transcribe incorrectly, then look into building a custom speech model for that specific domain**

From the above screenshot, for the base model – Model 1: 20211030, around 10% of words are getting substituted. In the speech studio, use the detailed comparison feature to identify domain-specific words that are getting missed. The screenshot below is an example of one section of the comparison. The left-most column is ground truth, the middle column is Model 1, and the right-most column is Model 2:

image 

The base models cannot recognize domain-specific words like the names of athletes “Katia Seizinger” and “Goggia.” This scenario shines a light on areas where a custom model may help with the recognition of domain-specific words and phrases

**4.	Review various custom model building options and decide if 1 or many custom models would be a better fit**

While experimenting with various ways to build custom model [link here to “Acoustic and language model adaptation” section from other document], Contoso’s found that better accuracy could be achieved from language and pronunciation model customization. In addition, minor improvements were observed by including custom acoustic data in building the custom model; however, the benefits weren’t significant enough to continue maintaining and training for a custom acoustic model. 
 
Contoso found that creating separate custom language models by event type (one model for alpine skiing, one model for luge, one model for snowboarding, etc.) gave better recognition results during the training and evaluation of a custom model. In addition, Contoso observed that creating separate acoustic models by event type to augment the language models was not necessary.

**5.	Collect training and testing data**

[Azure documentation article] share details about collecting the data needed for custom training a model. In Contoso’s case, they collect transcripts for various Olympic events by diverse commentators to build one pronunciation file that all the custom models (1 for each event type) share. The training data is kept separate from the actual test data. This way, once a custom model has been built, it can be tested by leveraging event audio whose transcripts were not included in the training dataset. The training and testing data can come from the same commentator but not the same event instance.

**6.	Massage the data in an acceptable format**

As mentioned in [Azure documentation articles], datasets used to create a custom model or to test the model need to be in a specific format. If the training data is in WebVTT file, then some simple tooling can be built to produce text files that contain normalized text for language model adaptation.

**7.	Train, test / evaluate, and deploy the model**

New event recordings are used to further test and evaluate the trained model. The process of testing/evaluating a model can take a couple of iterations to fine-tune the models. Finally, when the model generates transcripts with an acceptable error rate, it is deployed (published) to be consumed from the SDK.

**8.	Use the model endpoint in your transcription calls.**

Only a few lines of code are needed to point to the deployed custom model. Here is the code in c#. Note here that the endpoint is the Endpoint ID of the custom model that was deployed in step #7 above and subscriptionKey and region are the azure cognitive services subscription key and region. Subscription key and region can be fetched by going to [https://portal.azure.com] and then to the resource group where the cognitive services resource was created and looking at its keys.

String endpoint = "Endpoint ID from speech studio";
string locale = "en-US";
SpeechConfig config = SpeechConfig.FromSubscription(subscriptionKey: speechKey, region: region);
SourceLanguageConfig sourceLanguageConfig = SourceLanguageConfig.FromLanguage(locale, endPoint);
recognizer = new SpeechRecognizer(config, sourceLanguageConfig, audioInput);

**9.	Operationalize your model building, evaluating, and deployment process.**

A process to keep deployed models up-to-date is essential to success, primarily since new base models are published regularly. The [Sample Commands section] of the document has some details on how scripting can be used to streamline and automate the entire process of creating datasets for training and testing, building and evaluating models, and publishing new models as needed.

## Sample commands

This section shows how [Speech CLI with PowerShell](/azure/cognitive-services/Speech-Service/spx-basics?tabs=windowsinstall%2Cpowershell) can be used to upload datasets, train custom models and run evaluations.

**1.	Setup key and region**

spx --% config @key --set SpeechSubscriptionKey
spx --% config @region --set SpeechServiceRegion

**2.	Create a speech studio project**

spx csr project create --name testcli2 --language "en-us" --description "new project 2" --output url '@my.project.txt'

**3.	Upload dataset**

```
Use spx csr dataset upload command to upload pronunciation (kind = pronunciation), plain text (kind=language) and evaluation data (kind=acoustic)
```

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
Artificial intelligence (AI) architecture design
What is Custom Speech?
What is text-to-speech?
Train a Custom Speech model
Link to Deployment / Implementation guide

## Related resources
Related links from AAC
Use a speech-to-text transcription pipeline to analyze recorded conversations
Speech services
Control IoT devices with a voice assistant app
Link to Deployment / Implementation guide

