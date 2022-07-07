[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Speech Services is part of the Cognitive Services family of products and this service uses AI to work and process audio files. Some of the most common use cases for working with speech files involve the transcription of an audio file into a text file by relying on the Speech-to-text API. Furthermore, the previous use case can see its value amplified with the use of other Cognitive Services which can process the transcriptions and mine the data with APIs such as Text Analytics, Sentiment Analysis, Cognitive Search and Translation.

Several industries rely on supporting their customers over the phone such as Call Centers, Medical Response Units, Emergency Services Units, etc.

Traditionally, a Call Center will rely on agents who talk over the phone with customers and the agents need to handle two jobs at the same time: listening and speaking over the phone while at the same time taking notes for further analysis and documentation of a particular case. This makes the job not only harder for the agent, but also less efficient and furthermore, it could even impact negatively on the Call Centers most common KPIS such as AHT (Average Handling Time) and FCR (First Call Resolution).


## Architecture

![Architecture Diagram](../media/speech-services.png)
*Download an [SVG](../media/speech-services.svg) of this architecture.*

### Dataflow

1. The first step begins with the collection of data. Calls in a Call Center are usually recorded and it would be best to store those recordings in its raw state (.wav or .mp3 file formats) into a Blob Storage.
1. A function app is then used to issue a GET request to speech service endpoint to get the results transcribed. You can also use Queue Storage to start partitioning the files before issuing a GET request to speech service endpoint. For customization, you can use Custom Speech to build a custom model and deploy the model to an endpoint to get the results transcribed.
1. The transcribed results will generate an output as a .txt file which can be moved to Blob Storage using a POST request to the Speech Service Endpoint.
1. Queue storage is used to work with individual files before sending them to their final destination. Call Transcripts Blob is used to store the Call Transcripts in a .txt file format and Transcription Insights Blob that will store the Transcription Insights generated using Language Services to detect sentiment, language, and key phrases for insights.
1. Finally, the visualization stage can be served either via a web app or a dashboard in Power BI.


### Components

* [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs)
* [Speech service](https://azure.microsoft.com/en-us/services/cognitive-services/speech-services)
* [Cognitive Service for Language](https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview)
* [Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference?tabs=blob)
* [Azure Queue Storage](https://docs.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction)

## Next steps

To learn more about these services, see the following articles:

* [Azure Blob Storage](/azure/storage/blobs)
* [Speech service](https://docs.microsoft.com/en-us/azure/cognitive-services/Speech-Service/)
* [Train a Custom Speech model](https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/how-to-custom-speech-train-model?pivots=speech-studio)

## Related resource

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Speech-to-text conversion](../../reference-architectures/ai/speech-to-text-transcription-pipeline.yml)
  
