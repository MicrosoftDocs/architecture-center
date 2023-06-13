# Offline Audio Dubbing

This guide outlines how to use AI tools in the Azure Cognitive Services to help automate the offline dubbing process and ensure a high-quality dubbed version of original input.

Dubbing is the process of placing a replacement track over the original audio/video and includes the speech-to-speech transformation from a source to a target speech stream. There are two types of dubbing. Realtime dubbing modifies the original audio/video track as the content. Offline dubbing refers to a postproduction process. The offline process enables human assistance to improve the overall outcome compared to real-time implementations. You can correct errors at each stage and add enough metadata to make the output more truthful to the original. You can leverage the same pipeline to provide subtitles for the videos.

## Architecture

The architecture shows a pipeline that performs human-assisted speech-to-speech dubbing in an offline mode. The successful completion of each module triggers the next. The speech-to-speech pipeline shows the required elements for generating an offline dubbed audio stream. It only uses the transcript of the spoken text to produce subtitles. Users may choose to enhance the subtitles to produce closed captioning as well.

 ![A picture containing text, diagram, screenshot, plan

Description automatically generated]

### Workflow

1. **Ingest video:** The open-source software FFmpeg divides the input video content into an audio stream and a video stream. The pipeline saves the audio stream as a WAV file in the “WAV File Container” (blob storage). FFmpeg merges the video stream later in the process.
1. **Speech-to-text module:** The speech-to-text module uses the audio file from the “WAV File Container” as the input. It uses Speech service to find the language(s) of the source audio and different speakers. It transcribes the audio and saves it in a text format. The text of the audio. The speech-to-text module stores the text file, a subtitle caption file, and a word-level timestamp file in the “STT Transcript Container.”
1. **Subtitle file production and filtering:** The speech-to-text module produces the subtitle file along with more notes to aid manual review of the content and correct errors produced by the speech-to-text module. The subtitle file includes text, timestamps and other metadata like speaker ID and language ID that enables the rest of the pipeline to function correctly. The pipeline stores the subtitle file in the “STT Transcript container” as a WebVTT file. It contains comments on the potential points for human verification added as notes. These notes don’t interfere with the ability to add this as a subtitle file to the final output video. After the STT module produces the subtitle file, the human editors could correct errors and also potentially add emotion tags to reflect the input audio.
1. **Translator module:** The translation of the text is independent of timestamps. The input subtitle text is compiled based on the speakers. The translator service only requires the text with its context to perform the mapping to the target language. The timing and placement of the audio is forwarded to the text-to-speech module in pipeline for proper representation of the source audio in the output. This input also includes language identification of the different segments. It enables the translation service to skip segments that don’t require translation. The translation module also potentially adds the ability to perform content filtering.
1. **Target subtitle file production:** This module is responsible for the reproduction of the subtitle file in the target language. This is done through replacement of the text in the transcribed input file and maintains the same timestamps and meta-data associated with the text. The metadata might also include hints for the human reviewer and correct the content to improve the quality of translated text. Like the speech-to-text output, the file is a WebVTT file stored on Azure Storage and includes notes that are added to highlight potential points for human editing in the text.
1. **Text-to-speech module:** The Speech service handles converting the transcribed text from the source audio to target speech track. This service leverages the Speech Synthesis Markup Language (SSML) to represent the conversion parameters of the target text. It fine tunes pitch, pronunciation, emotion, speech rate, pauses, and other parameters in the text-to-text process. This service enables multiple customizations, including the ability to use custom neural voices. It generates the output audio files (.wav files) which are saved in a blob store for further use.
1. **Timing adjustment and SSML file production:** The audio segments in the source and target languages might be of different length and the specifics for each language might differ. The pipeline adjusts the timing and positioning of the speech within the target output stream to be truthful to the source audio while sounding natural in the target language. It converts the output speech to an SSML file. It also matches the audio segments to the right speaker and provides the right tone and emotions. The pipeline produces one SSML file as output for the input audio. The SSML file is stored in Azure storage and includes highlighting segments that might be potential for human revision, both in placement and rate.
1. **Merge:** Using the open-source-software FFmpeg, the generated WAV file is added to the video stream to produce a final output. It is worth pointing out that the subtitles generated at distinct stages of this pipeline could be added to the video.
1. **Azure Storage:** The pipeline uses Azure storage to store and retrieve content as it is produced/processed. Intermediate files are editable to correct errors at each stage and the pipeline could be restarted from different modules to help improve the final output through human verification.
1. **Platform:** The platform components complete the pipeline, enabling security, access rights and logging. This is conducted using AAD and Key Vault to regulate access and keep secrets. App insights could be enabled to perform logging for debugging purposes.

The pipeline is aware of errors. This awareness is significant in situations where the language or speaker changes. Context is the key to determining both the speech to text as well as the translation outputs. The key to getting the right output is understanding the context of the speech. You might need to check and correct the output text after each step. However, for certain use cases, the pipeline can perform automatic dubbing, but it is not optimized for real time speech to speech dubbing. The offline mode uses the full audio before proceeding with the pipeline. This enables each module to run for the full length of the audio. This aligns with the module design.

### Components

[Azure Cognitive Services](/azure/cognitive-services/what-are-cognitive-services): Azure Cognitive Services are cloud-based artificial intelligence (AI) services that help developers build cognitive intelligence into applications without having direct AI or data science skills or knowledge. They are available through REST APIs and client library SDKs in popular development languages.

[Azure Speech service](/azure/cognitive-services/speech-service/overview) unifies speech-to-text, text-to-speech, Speech Translation, Voice Assistant, and Speaker Recognition functionality into a single cognitive services-based subscription offering.

[Azure Translator Service](/azure/cognitive-services/translator/translator-overview) is a cloud-based neural machine translation service that is part of the Azure Cognitive Services family of REST APIs. You can use it with any operating system. Translator powers many Microsoft products and services used by thousands of businesses worldwide to perform language translation and other language-related operations. In this overview, you learn how Translator can enable you to build intelligent, multi-language solutions for your applications across all [supported languages](/azure/cognitive-services/translator/language-support).

## Use Cases

Audio dubbing is one of the most useful and widely used tools for media houses and OTT platforms. It helps increase global reach by adding relevance to the content for local audiences. Dubbing works best for offline processing but has applications for real time dubbing.

### Offline dubbing

The following are the potential use cases where offline audio dubbing benefits the most:

- Reproduce a film, documentary, etc., in a different language.
- When the original on-set audio is not usable (owing to poor recording equipment, ambient noise, or inadequate performance by the subject)
- Content filtering (to remove profanity or slang) and pronunciation correction in applicable segments to adjust the content as per target audience.
- The dubbing pipeline generates transcript from the Audio/Video as a by-product of the E2E process, which could be leveraged for providing subtitles in original or dubbed language. The transcribed text can be enhanced to produce closed captioning for media (prevalent on OTT platforms).

All these scenarios have traditionally been difficult problems, that required trained humans to conduct. With the improvements in the Speech and Language modeling, AI modules could be injected into this process to make it more efficient and cost effective. In the following sections, we will explain various services and elements that come into play when using base models and custom models for generating dubbed audio.

### Real time dubbing

Real-time dubbing is possible with this pipeline, but it doesn’t allow human intervention for any corrections. Additionally, lengthier audio files may require additional processing power and time, and thus accordingly increase the cost of transcription. One way to handle this limitation is to break down the input into smaller segments of audio that is pushed through the pipeline as separate elements till the end. However, this might present the following few issues:

- Segmenting the input audio into smaller clips can disrupt context and reduce transcription quality in the target language. Default speaker ID tagging may yield inconsistent results, especially without custom models for speaker identification. Default tagging based on appearance order makes accurate speaker mapping difficult when audio is divided into multiple fragments. However, this challenge can be overcome if the source audio has separate channels assigned to specific speakers.
- To achieve a natural and synchronized output audio, timing is crucial. It's important to minimize latency in the production pipeline and measure it accurately. By identifying the delay caused by the pipeline and using sufficient buffer, you can ensure that the output matches the pace of the input audio consistently. It's also essential to account for potential pipeline failures and maintain output consistency accordingly.

While being cognizant of the above-mentioned points, this pipeline could be used for processing real-time audio in a few scenarios where:

1. Audio contains only one speaker speaking clearly in one language.
2. There is no overlapping audio from multiple speakers, and there is a clear pause between any speaker or language changes.
3. Different audio channels are produced for each speaker which can be processed independently.

## Design Considerations

This section will explore the services and features involved in the audio dubbing pipeline, highlighting the factors to consider for generating high-quality output. It's important to note that the guide's implementation relies on base or universal models for all Cognitive models. Nevertheless, custom models can enhance the output of each service and the overall solution.

### Speech-**To**-Text (STT)

The performance of each module significantly influences the quality of the overall output. When the input quality deteriorates due to speech issues or background noise, errors can occur in subsequent modules, making it increasingly difficult and time-consuming to generate a high-quality output free of errors. However, you can take advantage of various features in Speech service to minimize this impact and ensure a high-quality output.

**Segment the audio properly**. Proper segmentation of the source audio is critical to the process of improving the E2E solution. The speech to text module performs segmentation based on significant pauses, which is a very coarse division of the source audio.  Additionally, the speech to text module divides longer segments of audio into segments that remain within the speech-to-text service. However, such segmentation introduces a few different issues like incorrect context, inappropriate speaker mapping.

**Extract timing information.** The process of dubbing involves a margin of timing misalignment originating from the obvious difference in how any content is expressed in a different language. The speech-to-text produces timing information from the source audio, which is fundamental to the reproduction of correctly timed speech in target language. Though it is not required in the translation of the text, the timing information needs to be passed on to the module generating the SSML file. Note that the granularity of the timing data will remain at the segment level. And since the translation doesn’t provide alignment information, the word level timing is not transferable to the target language. Therefore, modifications of the text input to accommodate context in translation need to be reversible.

**Present audio source as one stream.** The ability to distinguish speakers in the source audio is another paramount factor in producing correct dubbing targets. The process of partitioning an audio stream into homogeneous segments according to the identity of each speaker is called diarization. When different speaker segments aren’t available as separate audio streams, the easiest way to perform consistent diairization is to have the audio source presented as one stream, as opposed to breaking it down into individual segments. In this manner the different speakers are indexed according to their order of appearance, reducing the imminent need to use custom speaker identification models to identify speakers accurately.

**Consider mixing models.** Custom models enable better speaker identification as well as appropriate labelling of the text produced via any specific speaker. In some cases, it might be best to mix both approaches where speaker identification models are built for the key speakers and remaining speakers are diarized in order of their appearance using the service itself. This can be achieved by using Azure Speaker Recognition to train speaker identification models for the key speakers. Note that it requires collecting enough audio data for each key speaker. Use the text transcripts generated by Azure speech-to-text to identify speaker changes and segment the audio data into different speaker segments. Then post-process and refine the results as needed. This might involve combining or splitting segments, adjusting segment boundaries, or correcting speaker identification errors. Note that the exact implementation details may vary depending on your specific requirements and the characteristics of your audio data. Additionally, diarization systems can be computationally intensive, so it's important to consider the processing speed of your speech-to-text model. You may need to use a model that is optimized for speed or use parallel processing techniques to speed up the diarization process.

**Use the lexical text to reduce potential errors generated by the ITN.** Speech-to-text offers an array of formatting features to ensure that the transcribed text is legible and appropriate. The speech-to-text produces several representations of the incoming speech with respect to its formatting. The recognized text obtained after disfluency removal, inverse text normalization (ITN), punctuation, capitalization, profanity filter, etc. is called Display text. The display text helps with the readability of the text and uses pre-built models to define how to display different components. For example, the display format might include the use of capital letters for proper nouns or the insertion of commas to separate phrases. This format should be moved forward in the pipeline since it helps with context in the translation and minimizes the need to re-format the text.

The words recognized by the service are known as the lexical format. The lexical format includes factors such as the spelling of words and the use of homophones. The architecture uses this format to assess the extent of human intervention needed for correction on the STT output. This format represents the actual recognition of the speech-to-text  service, and the formatting doesn’t mask mismatched recognition. For example, the lexical format might represent the word "there" as "their" if the context suggests that it is the intended meaning.

**Filter profanity later in pipeline**. Speech-to-text has the option of providing profanity filtering. The architecture doesn’t use profanity filtering. You can enable profanity filtering through the [display formatting settings](/azure/cognitive-services/Speech-Service/display-text-format?pivots=programming-language-csharp). It is better to refrain from using this filtering early in the pipeline, since it might amount to some loss of context and result in mismatches as the pipeline proceeds. However, the filtering affects the “Display text” and “MaskedITN” and not the lexical format in the speech-to-text output.

**Consider building a joint language model when using custom model.** Speech service comes embedded with Language identification feature which requires defining the appropriate locales beforehand that are relevant to the input audio. Language identification requires some context, and sometimes there is a lag in flagging a language change. In cases when custom models are used, it is worth considering building a joint language model where the model is trained with utterances from multiple languages. This is helpful in handling speeches from certain regions where it is common to use two different languages together, such as Hinglish (that contains both Hindi and English).

**Ensure clear turn-taking and natural pauses between speakers.** Like language switching, user switching also works best when the speakers take turns and there is natural pause between the different speakers. If there are overlapping conversations or a short pause between speakers and the audio is bundled into one channel, then the speech to text output might contain errors and that requires human intervention to fix. Background speech can cause similar errors that might not be the focus but affect the output quality. Correcting these errors requires word level timing to identify the appropriate offsets for various speakers.

### Translator Service

Let us explore the features available with Translator service that can be utilized for generating a higher quality output.

**Maintain enough context.** The major point to consider when using the translation service is how much context is presented to maintain a faithful translation to the target language. To help with accurate translation, consider bundling the text from the same SpeakerID, within a meaningful timespan if the context is observed appropriately. Note that speech-to-text divides the input audio based on meaningful pauses, but in case of a longer monologue the audio is chunked at approximately 30 second segments, which might result in some loss of context. Also, overlapping speeches from different speakers might disturb the context and produce a poor translation output. Therefore, in many cases human intervention becomes indispensable at this step to ensure error-free output.

**Consider skipping segments in multilingual sources**. In some cases, the input may include multiple languages where a few segments do not require translation. For example, content where the source and target locales match or the terminology or jargon are used as is. To skip languages, you don’t want to translate, each segment needs to define the source and target locales for the translation service. It needs a configuration file that defines languages to avoid translation of segments. It’s beneficial to consider filtering out such segments and not channeling them into the translation service to ultimately reduce costs.

**Filter caption profanity independently.** Like speech-to-text, the translation service enables filtration of profanity in the output produced. Masking or marking the content for profanity will enable the captioning to be more appropriate to the audience selected. However, removing content owing to profanity filtering might confuse the timing analysis and placement of the output speech by the service, and additionally misinterpret the context. Thus, it might be worth considering producing the captions file with profanity filtration independently.

**Ensure accurate timing alignment in captions.** While the speech-to-text output does produce word level timestamps, the translation service doesn’t match the timestamps with alignment data. Therefore, the timestamps in the captions file in WebVTT format remain the same as the timestamps in the source file. This might present marginal misalignment in the presentation of captions, since translating to a different language might reduce or increase the content to match the meaning and context of source.

### Text-To-Speech (TTS)

**Select appropriate voices.** Based on the type of content and the intended audience, the selection of speaker voice has a big impact on how well the content is received. The service enables using [pre-built voices](/azure/cognitive-services/speech-service/language-support?tabs=stt-tts#prebuilt-neural-voices) that consists of a wide range of languages, includes all genders, and also provides pre-built models that allow injection of some emotions. Alternatively, a custom neural voice available in two versions Lite and Pro, could be used for the target speech language (explained in Azure Speech Service section in Part I of this guide).  The Pro version enables adding emotions to the voice to model the source speech input. In all cases the voice needs to be defined for each speaker and for each language. Unless the speech-to-text output is corrected, for any segment where the speaker is not identified in the output, a default voice must need to be defined.

**Perform speech placement.** A key element in the text-to-text module is how to perform the placement of the target speech and how to integrate this into one SSML file. The following sections highlight these two aspects.

*Integrate SSML files accurately.* The Speech Synthesis Markup Language (SSML) enables the customization of the text-to-text output through identifying details on audio formation, speakers, pauses and timing placement of the target audio. It lets us format text-to-text output attributes like pitch, pronunciation, rate, emotions, etc. For more information, see [Speech synthesis markup](/azure/cognitive-services/speech-service/speech-synthesis-markup).

The proper formation of the SSML file requires the timing information as well as the voice selection for a given segment. Therefore, it is fundamental that everything is returned to the correct segment of the source audio, and any change that is made along the pipeline should be snapped to these segments. Since the translation service does not produce any timing information, the only source of timing details is the speech-to-text output itself. Additionally, the only element that is transferable is the segment timing and the offsets which should be used to determine the duration of the target audio, as well as the breaks and pauses in between. All this information should be carried forward to the remaining components in the pipeline and the adjustment should be performed at the timing of the target audio as indicated previously.

Splitting the different outputs using the voice tag introduces a leading and trailing silence. You can define the silence in the voice tag with an exact value. In the example shown below, the gap between two speech segments amounts to 450ms (300ms trailing, and 150ms leading). You need to account for these gaps when calculating the final placement of the output. The following is a sample SSML element defining some of these details.

CODE\_PLACEHOLDER\_0

**Generate separate SSML files for each speaker.** The formatting of the SSML file allows for defining relative times to different voice segments, and this must be a positive value. As an example, the XML segment shown below defines a break after the spoken text has been produced.

CODE\_PLACEHOLDER\_1

When multiple speakers speak concurrently, this doesn’t work. One option is to produce every speaker as a separate SSML file (or combinations that are not overlapping) and overlay these files after the audio is produced.

**Include background audio effects as a separate channel.** The background noise in the source audio doesn’t propagate through this pipeline, and hence the composition of the SSML file will not include this in the final output. Any applicable background sound effect must be presented as a separate channel. It is then added to the final text-to-text output through some external tools.

**Add emotions and styles manually to enhance voice synthesis.** The emotions and tones are not detected in the source audio, and in turn they are not propagated through the pipeline and are missing in the SSML file as well. This needs to be a manual effort and is best suited if performed at the source WebVTT output and presented as information carried over in the WebVTT notes. The emotions and styles details are added as Notes like all the other info into that element and parsed while producing the SSML. The synthesis of the voices is improved, either by presenting different models for different emotions or leveraging the Pro Custom Neural Voice capability.

### Timing Placement and Adjustment

Translating content into a different language usually induces a difference in the duration of speech between the source and target. The placement and adjustment of the output speech to accommodate for this difference thus needs to be considered. Some of the ways to perform this adjustment are suggested here.

**Adjust speech rate dynamically based on source and target language rates.** Fitting the target speech in the same duration for the source is a straightforward approach. This requires running the text-to-text once to determine the duration of the target text when converted to speech. The final rate used to produce the actual target audio reflects the ratio of the target text duration relative to the original source time for the same segment.

This approach is simple and produces a variable rate for each speech segment. The output is unnatural and marred with issues. The actual rate of speaker in the source might change to present audible effects. This same approach could be used to make sure that the rate is measured (relative to a standard rate for this language) and adjusting the rate as a reflection of the source irrespective of fitting it in the same time span. To do this, the average word/character count per minute for normal speech in the source language is used. This is compared to the output of speech-to-text and used to identify the rate of the source speaker in different segments. This rate is used directly in the target language. It might be worth mentioning that the natural rate of speakers in the target language should be incorporated in the text-to-text module. Note that you could set limits on the rate to make sure that the produced audio output is within controlled limits.

CODE\_PLACEHOLDER\_2

**Adjust the pauses and timing to achieve natural-sounding text-to-speech output.** If the target language's speech duration is longer, use the pauses between speech segments in the original audio to accommodate the extra duration. This may slightly reduce the pause between sentences, but it ensures a more natural speech rate.

Align the produced audio with the original one. You can do this at the beginning, middle, or end of the original audio. Here, let's assume you align the audio segment in the target output with the middle of the original audio span.

You can estimate the speech signal duration from the number of tokens or characters in the target language. Alternatively, make a first pass on the text-to-speech service to calculate the exact duration. Since the audio is centered, distribute the difference between the target and source audio duration evenly across the two pause slots before and after the original audio.

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

#### Speech To Text (STT)

The output of STT could be affected by several aspects, including the audio itself and the background noise present, as well as the language model. It goes without saying that some audio content improves when using customization to the language model to better suit the input. There are multiple aspects based on which points of human intervention are possible:

**1. Identify transcription error:** The speech-to-text system may sometimes produce errors in transcribing identities. It provides multiple options for the final transcript, each with a confidence score. These scores help users determine the most accurate transcription from the available options. The n-best list contains the most probable hypotheses for a given speech input. The top hypothesis in this list has the highest score, indicating its likelihood of being the correct transcription. For instance, a score of 0.95 signifies 95% confidence in the accuracy of the top hypothesis. By comparing the scores and differences among the outputs, you can identify discrepancies that require human intervention. You need to consider the threshold and majority voting when selecting the n-best segments:

*Set a higher threshold for improved quality in the dubbing pipeline*. The threshold plays a crucial role in identifying potential errors in the n-best results. It determines the number of n-best results that are compared during the process. A higher threshold means more n-best results are returned for comparison, resulting in a higher overall quality of intervention. It's important to note that setting the threshold to zero limits the selection of candidates with higher confidence compared to the final transcription produced by the STT system.

*Balance recall and precision*: When using majority voting, you should select the lexical form for each candidate that falls within the threshold. Next, determine the insertions, deletions, and replacements in relation to the output phrase. These points of contention need to be considered for highlighting, but highlighting all of them prioritizes recall at the expense of lower precision. To enhance precision, you should order the insertions, deletions, and replacements based on a normalized average score. The count of these errors, relative to the total number of candidates minus one, will serve as a weight. You can set a threshold to calibrate the desired precision level. A weight of 0 will prioritize recall, indicating that the error is present in at least one candidate. Conversely, a weight of 1 will prioritize precision, implying that the error appears in all candidates. This pipeline requires a balanced approach between recall and precision, considering both aspects to achieve optimal results.

CODE\_PLACEHOLDER\_5

**2. Implement well-spaced language transition detection.** In language identification, detecting a transition from one language to another involves identifying multiple words. When the transition occurs within a certain number of tokens from the previous text, it is flagged. This assumption is based on the idea that well-spaced segments are more likely to be detected accurately. The aim is to avoid false negatives, where a language change occurs but the speech-to-text (STT) system fails to detect it before shifting back to the original language.

**3. Flag 'Unidentified' SpeakerIDs.** When using STT with diarization, you may encounter instances where the system labels certain SpeakerIDs as 'Unidentified.' This typically occurs when a speaker has a very short segment and cannot be easily identified. In such cases, it is advisable to flag these conditions for human editing, allowing for better accuracy and identification.

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
