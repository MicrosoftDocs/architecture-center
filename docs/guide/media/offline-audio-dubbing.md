# Offline audio dubbing

This guide describes how the AI tools in Azure Cognitive Services can help you automate an offline dubbing process and ensure a high-quality dubbed version of original input.

*Dubbing* is the process of placing a replacement track over an original audio/video source. It includes speech-to-speech transformation from a source to a target speech stream. There are two types of dubbing. *Realtime dubbing* modifies the original audio/video track as the content. *Offline dubbing* refers to a postproduction process. The offline process enables human assistance to improve the overall outcome as compared that of to real-time implementations. You can correct errors at each stage and add enough metadata to make the output more truthful to the original. You can use the same pipeline to provide subtitles for the video track.

## Architecture

This architecture shows a pipeline that performs human-assisted speech-to-speech dubbing in offline mode. The successful completion of each module triggers the next one. The speech-to-speech pipeline shows the required elements for generating an offline dubbed audio stream. It only uses the transcript of the spoken text to produce subtitles. You can optionally enhance the subtitles to produce closed captioning as well.

:::image type="content" source="images/audio-dubbing-architecture.png " alt-text="Diagram that shows an architecture for human-assisted dubbing." lightbox="images/audio-dubbing-architecture.png":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/audio-dubbing.pptx) of this architecture.*
 
### Workflow

1. **Ingest video:** FFmpeg open-source software divides the input video content into an audio stream and a video stream. The pipeline saves the audio stream as a WAV file in *WAV file container* (blob storage). FFmpeg merges the video stream later in the process.
1. **Speech-to-text module:** The speech-to-text module uses the audio file from *WAV file container* as input. It uses Speech service to determine the language or languages of the source audio and individual speakers. It transcribes the audio and saves it in text format. The speech-to-text module stores the text file, a subtitle caption file, and a word-level timestamp file in *STT transcript container*.
1. **Subtitle file production and filtering:** The speech-to-text module produces the subtitle file along with notes to aid manual review of the content and correct errors introduced by the speech-to-text module. The subtitle file includes text, timestamps, and other metadata, like speaker ID and language ID, that enables the rest of the pipeline to function correctly. The pipeline stores the subtitle file in *STT transcript container* as a WebVTT file. It contains notes on potential points for human verification. These notes don't interfere with the ability to add the file as a subtitle file to the final output video. After the speech-to-text module produces the subtitle file, human editors can correct errors and optionally add emotion tags to reflect the input audio.
1. **Translator module:** The translation of the text is independent of timestamps. The input subtitle text is compiled based on the speakers. The translator service requires only the text with its context to perform the mapping to the target language. The timing and placement of the audio is forwarded to the text-to-speech module in the pipeline for proper representation of the source audio in the output. This input also includes language identification of the various segments. It enables the translation service to skip segments that don't require translation. The translation module can also add the ability to perform content filtering.
1. **Target subtitle file production:** This module is responsible for reproducing the subtitle file in the target language. It does this by replacing of the text in the transcribed input file. It maintains the timestamps and metadata that are associated with the text. The metadata might also include hints for the human reviewer and correct the content to improve the quality of translated text. Like the speech-to-text output, the file is a WebVTT file that's stored in Azure storage. It includes notes that highlight potential points for human editing.
1. **Text-to-speech module:** The Speech service converts the transcribed text from the source audio to the target speech track. The service uses Speech Synthesis Markup Language (SSML) to represent the conversion parameters of the target text. It fine-tunes pitch, pronunciation, emotion, speech rate, pauses, and other parameters in the text-to-text process. This service enables multiple customizations, including the ability to use custom neural voices. It generates the output audio files (WAV files) which are saved in blob storage for further use.
1. **Timing adjustment and SSML file production:** The audio segments in source and target languages might be of different lengths, and the specifics for each language might differ. The pipeline adjusts the timing and positioning of the speech within the target output stream to be truthful to the source audio but still sound natural in the target language. It converts the output speech to an SSML file. It also matches the audio segments to the right speaker and provides the right tone and emotions. The pipeline produces one SSML file as output for the input audio. The SSML file is stored in Azure storage. It highlights segments that might benefit from human revision, in both placement and rate.
1. **Merge:** FFmpeg adds the generated WAV file to the video stream to produce a final output. The subtitles that are generated at certain stages of this pipeline can be added to the video.
1. **Azure storage:** The pipeline uses Azure storage to store and retrieve content as it's produced and processed. Intermediate files are editable if you need to correct errors at any stage. The pipeline can be restarted from different modules to improve the final output through human verification.
1. **Platform:** The platform components complete the pipeline, enabling enhanced security, access rights, and logging. Azure Active Directory (Azure AD) and Azure Key Vault regulate access and store secrets. You can enable Application Insights to perform logging for debugging.

The pipeline is aware of errors. This awareness is significant when the language or speaker changes. Context is the key to determining both the speech- to-text and the translation outputs. The key to getting the right output is understanding the context of the speech. You might need to check and correct the output text after each step. For certain use cases, the pipeline can perform automatic dubbing, but it's not optimized for real-time speech-to-speech dubbing. In offline mode, the full audio is processed before the pipeline continues. This enables each module to run for the full length of the audio and aligns with the module design.

### Components

- [Azure Cognitive Services](https://azure.microsoft.com/eproducts/cognitive-services) is a suite of cloud-based AI services that helps developers build cognitive intelligence into applications without having direct AI or data science skills or knowledge. The services are available through REST APIs and client library SDKs in popular development languages.
- [Azure Speech service](/azure/cognitive-services/speech-service/overview) unifies speech-to-text, text-to-speech, speech translation, voice assistant, and speaker recognition functionality into a single service-based subscription offering.
- [Azure translator service](/azure/cognitive-services/translator/translator-overview) is a cloud-based neural machine translation service that's part of the Cognitive Services family of REST APIs. You can use it with any operating system. Translator service enables many Microsoft products and services that are used by thousands of businesses worldwide to perform language translation and other language-related operations.

## Use cases

Audio dubbing is one of the most useful and widely used tools for media houses and OTT platforms. It helps increase global reach by adding relevance to the content for local audiences. Dubbing works best for offline processing but has applications for real-time dubbing.

### Offline dubbing

These are some use cases in which offline audio dubbing provides the most benefit:

- Reproduce films and other media in a different language.
- Raplace original on-set audio that isn't usable because of poor recording equipment, ambient noise, or inadequate performance by the subject.
- Implement content filtering to remove profanity or slang and pronunciation correction in applicable segments to adjust content for the target audience.
- Generate subtitles. The dubbing pipeline generates a transcript from the audio/video as a byproduct of the process. You can use this transcript to generate subtitles in the original or dubbed language. You can enhance the transcribed text to produce closed captioning for media.

These scenarios have traditionally presented difficult problems that required manual intervertion by trained employees. Given recent improvements in speech and language modeling, you can inject AI modules into these processes to make them more efficient and cost effective. 

### Real-time dubbing

You can implement real-time dubbing with this pipeline, but it doesn't allow human intervention for corrections. Also, longer audio files might require additional processing power and time, and which increases the cost of transcription. One way to handle this limitation is to divide the input into smaller segments of audio that are pushed through the pipeline as separate elements. However, this technique might present some problems:

- Dividing the input audio into smaller clips can disrupt context and reduce transcription quality in the target language. Default speaker ID tagging might yield inconsistent results, especially if you don't use custom models for speaker identification. Default tagging that's based on appearance order makes accurate speaker mapping difficult when audio is divided into fragments. You can resolve this challenge if the source audio has separate channels assigned to specific speakers.
- Timing is crucial to obtaining natural and synchronized output audio. You need to minimize latency in the production pipeline and measure it accurately. By identifying the delay caused by the pipeline and using sufficient buffer, you can ensure that the output consistently matches the pace of the input audio. You also need to account for potential pipeline failures and maintain output consistency accordingly.

Taking into account the previous points, you could use this pipeline to process real-time audio in scenarios where:

- Audio contains only one speaker speaking clearly in one language.
- There's no overlapping audio from multiple speakers, and there's a clear pause between any speaker or language changes.
- Different audio channels are produced for each speaker, and they can be processed independently.

## Design considerations

This section describes services and features in the audio dubbing pipeline, highlighting the factors to consider to generate high-quality output. Note that this guide's implementation uses base or universal models for all cognitive models. Nevertheless, custom models can enhance the output of each service and the overall solution.

### Speech-to-text

The performance of each module significantly influences the quality of the overall output. When the input quality deteriorates because of speech issues or background noise, errors can occur in subsequent modules, making it increasingly difficult and time-consuming to generate a high-quality output that's free of errors. However, you can take advantage of various features in Speech service to minimize this problem and ensure a high-quality output.

**Segment the audio properly**. Proper segmentation of the source audio is critical to the process of improving the overall solution. The speech-to-text module performs segmentation based on significant pauses, which is a coarse division of source audio. Additionally, the speech-to-text module divides longer segments of audio into segments that remain within the speech-to-text service. However, this segmentation introduces problems, like incorrect context and inappropriate speaker mapping.

**Extract timing information.** The process of dubbing involves a margin of timing misalignment that originates from the differences in how content is expressed in different languages. The speech-to-text produces timing information from the source audio, which is fundamental to the reproduction of correctly timed speech in the target language. Although it's not required in the translation of the text, the timing information needs to be passed on to the module that generate the SSML file. The granularity of the timing data remains at the segment level. And because the translation doesn't provide alignment information, the word-level timing isn't transferable to the target language. Therefore, modifications of the text input to accommodate context in translation need to be reversible.

**Present audio source as one stream.** The ability to distinguish speakers in the source audio is another important factor in producing correct dubbing targets. The process of partitioning an audio stream into homogeneous segments according to the identity of each speaker is called *diarization*. When different speaker segments aren't available as separate audio streams, the easiest way to perform consistent diairization is to present the audio source as one stream, as opposed to breaking it down into individual segments. If you present the audio in this way, the various speakers are indexed according to their order of appearance, which reduces the need to use custom speaker-identification models to identify speakers accurately.

**Consider combining models.** Custom models enable better speaker identification and appropriate labelling of the text produced by any specific speaker. In some cases, it might be best to mix two approaches, building speaker identification models for key speakers and diarizing the remaining speakers in order of their appearance by using the service. You can implement this method by using Azure speaker recognition to train speaker identification models for the key speakers. You would need to collect enough audio data for each key speaker. Use the text transcripts generated by Azure speech-to-text to identify speaker changes and segment the audio data into different speaker segments. Then post-process and refine the results as needed. This process might involve combining or splitting segments, adjusting segment boundaries, or correcting speaker identification errors. 

The implementation details might vary depending on your specific requirements and the characteristics of your audio data. Additionally, diarization systems can be computationally intensive, so you need to consider the processing speed of your speech-to-text model. You might need to use a model that's optimized for speed or use parallel-processing techniques to speed up the diarization process.

**Use the lexical text to reduce potential errors generated by the ITN.** Speech-to-text provides an array of formatting features to ensure that the transcribed text is legible and appropriate. Speech-to-text produces several representations of the input speech, each with different formatting. The recognized text obtained after disfluency removal, inverse text normalization (ITN), punctuation, capitalization, profanity filter, and so on, is called *display text*. The display text improves the readability of the text and uses pre-built models to define how to display different components. For example, the display format might include the use of capital letters for proper nouns or the insertion of commas to separate phrases. This format should be moved forward in the pipeline because it helps provide context in the translation and minimizes the need to re-format the text.

The words recognized by the service appear in a format known as the *lexical format*. The lexical format includes factors like the spelling of words and the use of homophones. The architecture uses this format to assess the extent of human intervention that's needed for correction on the speech-to-text output. This format represents the actual recognition of the speech-to-text service, and the formatting doesn't mask mismatched recognition. For example, the lexical format might represent the word "there" as "their" if the context suggests that it's the intended meaning.

**Filter profanity later in the pipeline**. Speech-to-text provides profanity fitering as an option. The architecture presented here doesn't use profanity filtering. You can enable profanity filtering via the [display formatting settings](/azure/cognitive-services/Speech-Service/display-text-format?pivots=programming-language-csharp). It's better to avoid using this filtering early in the pipeline because it might introduce some loss of context and result in mismatches as the pipeline proceeds. However, the filtering affects the display text and MaskedITN, not the lexical format in the speech-to-text output.

**Consider creating a joint-language model when you use a custom model.** Speech service provides a language identification feature. To use this feature, you need to define, beforehand, the locales that are relevant to the input audio. Language identification requires some context, and sometimes there's a lag in flagging a language change. If you use custom models, consider creating a joint-language model, where the model is trained with utterances from multiple languages. This approach is useful for handling speech from regions where it's common to use two different languages together, like Hinglish, which contains both Hindi and English.

**Ensure clear turn-taking and natural pauses between speakers.** Like language switching, user switching also works best when the speakers take turns and there's natural pause between speakers. If there are overlapping conversations or a short pause between speakers and the audio is bundled into one channel, the speech-to-text output might contain errors that require human intervention. Background speech that might not be the focus of the content but that affect the output quality can cause similar errors. Correcting these errors requires word-level timing to identify the appropriate offsets for various speakers.

### Translator service

The translator service provides features that you can use to generate higher-quality output.

**Maintain enough context.** The main point to consider when you use the translator service is how much context to present in order to produce a faithful translation. To help with accurate translation, consider bundling the text from the same speaker ID, within a meaningful timespan if the context is observed appropriately. Note that speech-to-text divides the input audio based on meaningful pauses, but, for longer monologues, the audio is divided at approximately 30 second segments. This segmentation might result in some loss of context. Also, overlapping speech from different speakers might disturb the context and produce a poor translation output. Therefore, human intervention is frequently indispensable during this step.

**Consider skipping segments in multilingual sources**. In some cases, input includes multiple languages and some segments don't require translation. For example, the source and target locales might match, or terminology or jargon might be used as is. To skip languages that you don't want to translate, each segment needs to define the source and target locales for the translator service. The service needs a configuration file that defines languages that shouldn't be translated. To reduce costs, consider filtering out segments that don't require translation so that you don't input them into the translator service.

**Filter caption profanity independently.** Like speech-to-text, the translator service enables you to filter profanity. Masking or marking content for profanity can make captions more appropriate to the target audience. However, removing content via profanity filtering might confuse the timing analysis and placement of the speech output by the service. It might also lead to misinterpretations of the context. You should consider independently producing the captions file that's filtered for profanity.

**Ensure accurate timing alignment in captions.** Although the speech-to-text output produces word-level timestamps, the translator service doesn't match the timestamps with alignment data. Therefore, the timestamps in the captions file in WebVTT format remain the same as the timestamps in the source file. This might present marginal misalignment in the presentation of captions because translating to a different language might reduce or increase the length of the content.

### Text-to-speech 

**Select appropriate voices.** Based on the type of content and the intended audience, the selection of a speaker voice can have a big influence on how well the content is received. The service provides [pre-built voices](/azure/cognitive-services/speech-service/language-support?tabs=stt-tts#prebuilt-neural-voices) in a range of languages in male and female voices. It also provides pre-built models that allow injection of emotions. Alternatively, you can use a custom neural voice that's available in two versions, Lite and Pro, for the target speech language. If you use the Pro version, you can add emotions to the voice to model the source speech input. In all cases, you need to define a voice for each speaker and for each language. Unless you check the speech-to-text output to ensure that there are no unidentified speakers, you need to define a default voice.

**Perform speech placement.** The placement of the target speech and the integration of it into one SSML file are key elements in the text-to-text module. The following sections describe these elements.

*Integrate SSML files accurately.* SSML enables you to customize text-to-text output with identifying details on audio formation, speakers, pauses, and timing placement of the target audio. You can use it to format text-to-text output attributes like pitch, pronunciation, rate, and emotion. For more information, see [Speech synthesis markup](/azure/cognitive-services/speech-service/speech-synthesis-markup).

The proper formation of the SSML file requires the timing information and the voice selection for a given segment. Therefore, everything needs to be returned to the correct segment of the source audio, and any change that's made along the pipeline should be snapped to these segments. Because the translation service doesn't produce timing information, the only source of timing details is the speech-to-text output. Additionally, the only elements that are transferable are the segment timing and the offsets that should be used to determine the duration of the target audio, in addition to the breaks and pauses in between. All this information should be carried forward to the remaining components in the pipeline, and the adjustment should be performed at the timing of the target audio as indicated previously.

Splitting the outputs by using the `voice` tag introduces a leading and trailing silence. You can define a value for the silence in the `voice` tag. In the following example, the gap between two speech segments equals 450 ms (300 ms trailing and 150 ms leading). You need to account for these gaps when you calculate the final placement of the output. Here's a sample SSML element that defines some of these details:

```xml
<speak version="1.0" xmlns=http://www.w3.org/2001/10/synthesis xml:lang="en-US">
         <voice name="en-US-JennyNeural">
         <mstts:silence type=" Leading-exact" value="100ms"/> <mstts:silence type="Sentenceboundary-exact" value="200ms"/> <mstts:silence type="Tailing-exact" value="300ms"/>
             If we're home schooling, the best we can do is roll with what each day brings and try to have fun along the way.
        </voice>
        <voice name="en-US-JennyNeural">
        <mstts:silence type=" Leading-exact" value="150ms"/> <mstts:silence type="Sentenceboundary-exact" value="250ms"/> <mstts:silence type="Tailing-exact" value="350ms"/>
            A good place to start is by trying out the slew of educational apps that help children stay happy and smash their schooling at the same time.
        </voice>
</speak>
```

**Generate separate SSML files for each speaker.** The formatting of the SSML file allows you to define relative times for different voice segments. The value must be a positive value. For example, this XML defines a break after the spoken text is produced:

```xml
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
    <voice name="en-US-JennyNeural">
        Welcome to Microsoft Cognitive Services <break time="100ms" /> Text-to-Speech API.
    </voice>
</speak>
```

When multiple speakers speak concurrently, this technique doesn't work. One option is to generate a separate SSML file for every speaker (or in combinations that don't overlap) and overlay these files after the audio is produced.

**Include background audio effects in a separate channel.** The background noise in the source audio doesn't propagate through this pipeline, so the composition of the SSML file won't include it in the final output. You need to present any applicable background sound effects in a separate channel. You then add it to the final text-to-text output by using external tools.

**Add emotions and styles manually to enhance voice synthesis.** Emotions and tones aren't detected in source audio, so they're not propagated through the pipeline and don't appear in the SSML file. You need to add these details manually. It's best to add them in the source WebVTT output and present them as information carried over in the WebVTT notes. The emotion and style details are added as notes like all the other information in the element and parsed when the SSML is produced. You can improve the synthesis of the voices either by presenting different models for different emotions or by using the Pro Custom Neural Voice capability.

### Timing placement and adjustment

Translating speech into different languages usually introduces a difference in the length of the content. You need to consider the placement and adjustment of the output speech to accommodate for this difference. Some of the ways to perform this adjustment are suggested here.

**Adjust the speech rate dynamically based on source and target language rates.** Matching the target speech to the duration of the source is a straightforward approach. This approach requires running the text-to-text once to determine the duration of the target text when it's converted to speech. The final rate used to produce the actual target audio reflects the ratio of the target text duration relative to the original source time for the same segment.

This approach is simple and produces a variable rate for each speech segment. The output sounds unnatural. The actual rate of the speaker in the source might change to present audible effects. You can improve the output by measuring the rate relative to a standard rate for the language and then adusting the rate to reflect the source. You don't try to fit it into the same time span. To make this adjustment, you use the average word and character count per minute for normal speech in the source language. These counts are compared to the output of speech-to-text and used to identify the rate of the source speaker in each segment. You then use this rate in the target language. The natural rate of speakers in the target language should be incorporated in the text-to-text module. You can also set limits on the rate to make sure that the produced audio output is within controlled limits. The following code implements this process: 

```csharp
internal static double GetRelativeTargetRate(PreProcessTTSInput input, IOrchestratorLogger<TestingFrameworkOrchestrator> logger)
        {
            string sourceLanguage = input.IdentifiedLocale.Split('-')[0];
            string targetLanguage = input.TargetLocale.Split('-')[0];
            double maxTargetRate = input.PreProcessingStepConfig.MaxSpeechRate;
            double minTargetRate = input.PreProcessingStepConfig.MinSpeechRate;
            if (SpeechRateLookup.Rate.ContainsKey(sourceLanguage) && SpeechRateLookup.Rate.ContainsKey(targetLanguage))
            {
                try
                {
                    // Look up values from static table
                    double sourceWordRate = SpeechRateLookup.Rate[sourceLanguage].WordRate;
                    double targetWordRate = SpeechRateLookup.Rate[targetLanguage].WordRate;

                    double sourceCharRate = SpeechRateLookup.Rate[sourceLanguage].CharRate;
                    double targetCharRate = SpeechRateLookup.Rate[targetLanguage].CharRate;
                    int sourceWordCount = input.LexicalText.Split(" ").Length;
                    int sourceCharCount = input.LexicalText.Length;
                    // Calculate the rate of the source segment relative to the nominal language rate
                    double sourceRelativeWordRate = ((sourceWordCount / input.Duration.TotalMinutes) / sourceWordRate);
                    double sourceRelativeCharRate = ((sourceCharCount / input.Duration.TotalMinutes) / sourceCharRate);
                    double sourceAverageRelativeRate = (sourceRelativeWordRate + sourceRelativeCharRate) / 2.0;
                    // Calculate the ratio between the target and source nominal rates
                    double averagedLanguageRateRatio = (((targetWordRate / sourceWordRate) + (targetCharRate / sourceCharRate)) / 2.0);
                    // Scale the target rate based on the source/target ratio and the relative rate of input with respect to the nominal source rate
                    double relativeTargetRate = sourceAverageRelativeRate / averagedLanguageRateRatio;
                    relativeTargetRate = Math.Min(relativeTargetRate, maxTargetRate);
                    relativeTargetRate = Math.Max(relativeTargetRate, minTargetRate);
                    return relativeTargetRate;
                }
                catch (DivideByZeroException exception)
                {
                    logger.LogError(exception.Message);
                    return 1.0;
                }
            }
            else
            {
                return 1.0;
            }
        }

```

**Adjust the pauses and timing to achieve natural-sounding text-to-speech output.** If the target language's speech duration is longer, use the pauses between speech segments in the original audio to accommodate the extra duration. Doing so might slightly reduce the pause between sentences, but it ensures a more natural speech rate.

Align the produced audio with the original one. You can do this at the beginning, middle, or end of the original audio. For this example, assume that you align the audio segment in the target output with the middle of the original audio span.

You can estimate the speech signal duration from the number of tokens or characters in the target language. Alternatively, make a first pass with the text-to-speech service to determine the exact duration. Because the audio is centered, distribute the difference between the target and source audio duration evenly across the two pauses before and after the original audio.

If the target audio doesn't overlap with any other audio in the target, placing it is straightforward. The new offset in the target audio is the original offset minus half the difference between the target and source audio duration, as shown here:

offsetti = offsetsi - (tti – tsi)/2

However, you may encounter situations where multiple audio segments in the target audio overlap. The goal of this process is to correct it, considering only the previous segment. Here are the different conditions for this overlap:

1. offsetti > offsett(i-1) \+ tt(i-1) : This implies that both segments fit within the pause assigned between them in the original audio with no issues.
2. offsetti = offsett(i-1) \+ tt(i-1) : This means that there will be no pause between two consecutive audios in the target language. Add a small offset (enough for one word in the language) to the offsetti (Dtt). This (Dtt) is to avoid continuous audio in the target audio that isn’t present in the original.
3. offsetti < offsett(i-1) \+ tt(i-1): This means that the two audios overlap. In this case there are two options
	1. offsets(i-1) \+ ts(i-1)< median \{offsets(i-1) \+ ts(i-1)\}"i: This reflects that this pause is shorter than the nominal pause in the video, in turn the translated text could be shifted accordingly. The assumption is that the longer pauses make up for this. Therefore offsetti = offsett(i-1) \+ tt(i-1) \+ Dtt
	2. offsets(i-1) \+ ts(i-1)> median \{offsets(i-1) \+ ts(i-1)\}"i: This reflects that this pause is longer than the nominal pause in the video, yet it is not fitting the translated audio. Thereon, the rate is used to adjust the segment to be more appropriately timed. The new rate is rateti = rateti \* (((offsett(i-1) \+ tt(i-1)) - offsetti)\+ tti\+ Dtt )/( tti).

This process might cause the last segment to run over the time of the original audio, particularly when the video ends at the end of the original audio, but the target audio is longer. You have two choices: let the audio run longer or add the full offset of the target audio to the pre-offset, making the last offsettn= offsetsn - (ttn – tsn). If this offset collides with the audio from the previous segment, then use the rate modification described above.

Remember, aligning to the middle suits dubbing in languages with longer text in the target compared to the original. If the target is always quicker than the original, it may be better to align the timing to the beginning of the original audio segments.

CODE\_PLACEHOLDER\_3

### Creating WebVTT files for captioning and human editing

Web Video Text Tracks Format (WebVTT) is a format for displaying timed text tracks, such as subtitles or captions. It’s used in adding text overlays to a video. This file presents the outputs of the pipeline for human consumption, as well as the captions file production. In the following, we will cover some considerations for leveraging the WebVTT along this pipeline.

**Include information in the Notes of the WebVTT file**. To anchor on the WebVTT file across the pipeline, the file itself should contain all the necessary information required for processing the different modules. In addition to the timing and textual information, it includes the Language ID, User ID, and the flag for human intervention as the associated details. To include these details in the WebVTT file and keep it compatible to be used as captions/subtitles file, use the ‘Notes’ section of each segment in the WebVTT file. The following is a suggested format for this:

CODE\_PLACEHOLDER\_4

**Ensure proper display of subtitles on different screen sizes.** The number of words and lines of text to display on screen is an important consideration for the use of captions file. These needs be handled per use case and should be performed during the production of the WebVTT file. Humans in the loop review these files and use the prompts to provide fixes. The file also contains certain metadata that other modules down the line need to function properly.

To make subtitles appear properly, longer segments (transcribed or translated results) need to be divided into multiple VTTCues, while preserving the Notes and other details so that they are still pointing to the right context and ensuring that the pipeline doesn’t interrupt the translation or the text-to-text placement of text.

When dividing the original text segment into multiple VTTCues, the timing for each division should also be considered. The word level timestamps produced during transcription could be utilized for this. Since the WebVTT file is open for modification, these could be updated manually, but it’s considerably difficult to maintain.

### Identify Human Intervention potential

The dubbing pipeline involves several important components: speech-to-text, translation, and text-to-speech. Errors can potentially occur in each of these modules, and they may propagate and become more pronounced throughout the pipeline. It is highly recommended to have human intervention to review and rectify the results to achieve an acceptable level of quality. You can save significant time by identifying and highlighting the specific sections that require intervention. The upcoming sections outline the various stages of the pipeline where issues in the output can be identified, requiring manual intervention.

#### Speech To Text

The output of speech-to-text could be affected by several aspects, including the audio itself and the background noise present, as well as the language model. It goes without saying that some audio content improves when using customization to the language model to better suit the input. There are multiple aspects based on which points of human intervention are possible:

**1. Identify transcription error:** The speech-to-text system may sometimes produce errors in transcribing identities. It provides multiple options for the final transcript, each with a confidence score. These scores help users determine the most accurate transcription from the available options. The n-best list contains the most probable hypotheses for a given speech input. The top hypothesis in this list has the highest score, indicating its likelihood of being the correct transcription. For instance, a score of 0.95 signifies 95% confidence in the accuracy of the top hypothesis. By comparing the scores and differences among the outputs, you can identify discrepancies that require human intervention. You need to consider the threshold and majority voting when selecting the n-best segments:

*Set a higher threshold for improved quality in the dubbing pipeline*. The threshold plays a crucial role in identifying potential errors in the n-best results. It determines the number of n-best results that are compared during the process. A higher threshold means more n-best results are returned for comparison, resulting in a higher overall quality of intervention. It's important to note that setting the threshold to zero limits the selection of candidates with higher confidence compared to the final transcription produced by the speech-to-text system.

*Balance recall and precision*: When using majority voting, you should select the lexical form for each candidate that falls within the threshold. Next, determine the insertions, deletions, and replacements in relation to the output phrase. These points of contention need to be considered for highlighting, but highlighting all of them prioritizes recall at the expense of lower precision. To enhance precision, you should order the insertions, deletions, and replacements based on a normalized average score. The count of these errors, relative to the total number of candidates minus one, will serve as a weight. You can set a threshold to calibrate the desired precision level. A weight of 0 will prioritize recall, indicating that the error is present in at least one candidate. Conversely, a weight of 1 will prioritize precision, implying that the error appears in all candidates. This pipeline requires a balanced approach between recall and precision, considering both aspects to achieve optimal results.

CODE\_PLACEHOLDER\_5

**2. Implement well-spaced language transition detection.** In language identification, detecting a transition from one language to another involves identifying multiple words. When the transition occurs within a certain number of tokens from the previous text, it is flagged. This assumption is based on the idea that well-spaced segments are more likely to be detected accurately. The aim is to avoid false negatives, where a language change occurs but the speech-to-text system fails to detect it before shifting back to the original language.

**3. Flag 'Unidentified' SpeakerIDs.** When using speech-to-text with diarization, you may encounter instances where the system labels certain SpeakerIDs as 'Unidentified.' This typically occurs when a speaker has a very short segment and cannot be easily identified. In such cases, it is advisable to flag these conditions for human editing, allowing for better accuracy and identification.

#### Translation

When evaluating the quality of translated output, one commonly used metric is the BLEU score. However, the BLEU score has its limitations. It relies on comparing the machine-translated output with human-generated reference translations to measure similarity. This metric does not consider important aspects such as fluency, grammar, and meaning preservation.

There is an alternative method you can employ to assess translation quality. It involves performing a bidirectional translation and comparing the results. First, the input segment is translated from the source language to the target language. Then, the translated output is reversed and translated back from the target language to the source language. This process generates two strings: the source segment (Si) and the expected value of the source (E(Si)). By comparing these two strings, you can figure out the number of insertions and deletions.

If the number of insertions and deletions exceeds a predefined threshold, the statement is flagged for further examination. If the number falls below the threshold, the segment Si is considered a well-translated match. In cases where differences are found, it may be beneficial to highlight them in the source language. This approach helps draw attention to specific terms that need correction, rather than showing that the entire segment requires human verification.

#### Text-to-speech

The text-to-speech highlighting is mostly associated with the changed rate and with shifts in placement that are beyond the gaps in the source audio. The locations where alterations of rate or placements as pointed out in the text-to-text section are highlighted for the user.

## Contributors

[Nayer Wanas](https://www.linkedin.com/in/nwanas/)

[Pratyush Mishra](https://www.linkedin.com/in/mishrapratyush/)

[Vivek Chettiar](https://www.linkedin.com/in/vivekchettiar/)

[Bernardo Chuecos Rincon](https://www.linkedin.com/in/bernardo-chuecos-rincon-171997177/)

## Next Steps

You can see a sample implementation for offline audio dubbing in the following GitHub repository: [Cognitive services utilities](https://github.com/microsoft/Cognitive_Service_Utilities/blob/main/README.md).

https://learn.microsoft.com/en-us/azure/cognitive-services/what-are-cognitive-services
