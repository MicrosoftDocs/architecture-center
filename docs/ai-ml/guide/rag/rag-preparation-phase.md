---
title: Develop a RAG Solution - Preparation Phase
description: Learn how to analyze and gather representative content such as documents, images, videos, and audio files and develop test queries to validate your RAG solution.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/10/2025
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# RAG preparation phase

The first phase of retrieval-augmented generation (RAG) development and experimentation is the preparation phase. During this phase, you define the business domain for your solution. After you define the domain, you gather documents and multimedia content, analyze the content, and gather sample questions that are pertinent to the domain. You do these steps in parallel because they're interrelated. For example, content analysis helps you determine which test documents, media files, and test queries you should gather. The questions that you ask must be answerable by content in the documents and multimedia, and the content must answer the relevant questions.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.md).

## Determine the solution domain

The first step in this process is to clearly define the business requirements for the solution or use case. These requirements help you determine what kind of questions the solution should answer and what source data or documents help answer those questions. In later phases, the solution domain helps inform your embedding model strategy.

## Analyze content

The goal of content analysis is to gather enough information about your content collection to help you understand:

- **The different classifications of content.** For example, you might have product specifications, quarterly reports, car insurance contracts, health insurance contracts, training videos, or instructional audio recordings.

- **The different types of content and formats.** For example, you might have PDFs, Markdown files, HTML files, DOCX files, MP4 videos, MP3 audio files, JPEG images, or PowerPoint presentations.

- **The security constraints.** For example, you might require authentication and authorization to access the content depending on whether it's publicly available.

- **The structure and characteristics of the content.** For example, the length of documents might vary, videos might have different durations and resolutions, audio files might contain speech or background music, or content might have subject breaks, contextually relevant images, or tabular data.

The following sections describe how this information helps you choose your loading and chunking strategies.

### Understand content classifications

It's important to understand the different content classifications to help determine the number of test items that you need. This part of the analysis should identify high-level classifications, such as insurance or finance. It should also identify subclassifications, such as health insurance documents, car insurance documents, product demonstration videos, or customer service audio recordings. Determine whether these subclassifications have different structures, formats, or content characteristics.

The goal is to understand all of the different content variants that you have. You don't want to overrepresent or underrepresent a specific content classification in your experimentation.

### Content types and formats

When you understand the different file formats in your collection, it helps you determine the number and breakdown of test content. For example, if you have PDF and Open XML document types for quarterly reports, you need test content for each of the formats. If you also have video presentations and audio recordings of the same content, include them in your testing. When you know your content types, you can better understand your technical requirements for loading and processing your content. The technical requirements include specific libraries that can process the file formats, transcription services for audio and video content, and computer vision models for image analysis.

### Security constraints

You need to understand your security constraints to determine your loading and processing strategies. For example, it's crucial to identify whether some or all of your content requires authentication, authorization, or network visibility. If the content is within a secure perimeter, ensure that your code can access it, or implement a process to securely replicate the content to a location where your processing code can access it.

Documents sometimes reference or embed images, videos, or audio that are important to the context. That media might also be subject to similar access controls as the primary document itself. If the media requires authentication or network line of sight, you must make sure that your code can access the media or that you have a process in place to access and replicate the content. Also, consider privacy and compliance requirements when processing audio and video content that might contain personal data or sensitive conversations.

If your workload requires that different users only have access to distinct content or content segments, ensure that you understand how to retain those access permissions in your chunking solution.

### Content structure and characteristics

You need to understand the structure and characteristics of your content, including layout, format, duration, and the types of information contained within. This understanding helps you make the following determinations:

- Whether the content requires preprocessing to clean up noise, extract media, transcribe audio, extract frames from video, reformat content, or annotate items to ignore

- Whether you want to ignore or exclude parts of the content

- What parts of the content you want to capture and process

- How you want to chunk or segment the content

- How you want to handle images, tables, charts, video clips, audio segments, and other embedded media

The following sections list categorized questions that you can use to help you make some of these determinations.

#### Determine the items that you can ignore

Some structural elements might not add meaning to the document and can safely be ignored when chunking. In some situations, these elements can add valuable context and improve the relevancy of queries to your index, but not all. Ask the following questions about common document features to see whether they add relevancy or should be ignored.

- Does the document contain a table of contents?

- Are there headers or footers?

- Are there copyrights or disclaimers?

- Are there footnotes or endnotes?

- Are there watermarks?

- Are there annotations or comments?

#### Determine your document preprocessing requirements

The following questions about the structure of the document can help you decide whether you need to preprocess the document to make it easier to process. They also help you choose a chunking strategy.

- Are there multicolumn data or multicolumn paragraphs? You don't want to parse multicolumn content the same way as single-column content.

- How is the document structured? For example, HTML files sometimes use tables that need to be differentiated from embedded tabular data.

- How many paragraphs are there? How long are the paragraphs? Are the paragraphs similar in length?

- What languages, language variants, or dialects are in the documents?

- Does the document contain Unicode characters?

- How are numbers formatted? Do they include commas or decimals? Are they consistent?

- Which parts of the document are uniform, and which parts aren't?

- Is there a header structure where semantic meaning can be extracted?

- Are there bullets or meaningful indentations?

#### Determine your image preprocessing requirements

To determine your image preprocessing requirements, understand attributes of your images, like whether they have sufficient resolution to process, and whether the image contains all the required information. The following questions can help you determine the requirements.

- What resolution are the images?

- Is there text embedded in the images?

- Are there abstract images that don't add value? For example, icons might not add any semantic value. Adding a description for icons might be detrimental to your solution because the icon usually isn't relevant to the document's content.

- What's the relationship between the images and the surrounding text? Determine whether the images have standalone content or whether there's context around the image that you should use when you pass it to a language model. Captions are an example of surrounding text that might have valuable context that isn't included in the image.

- Is there rich textual representation, such as accessibility descriptions of the images?

#### Determine your video and audio preprocessing requirements

To determine your video and audio processing requirements, understand your multimedia content, whether it contains valuable information, and how to extract that information effectively. The following questions can help you determine the requirements.

- What are the quality characteristics of the media files? These characteristics include video resolution and framerate, audio quality and sample rate, and file compression and codec types.

- What type of content do the media files contain? Content types include spoken presentations, lectures, interviews, music, sound effects, and screen recordings.

- Do the video files contain visual information that's important for understanding? Examples of the information include presentation slides, demonstrations, charts, graphs, visualizations, text overlays, and captions.

- Are there transcripts or closed captions available for the audio and video content?

- What languages are spoken in the audio and video content?

- Do the media files have metadata or chapters that can help with segmentation?

- Is there background noise or music that might interfere with transcription?

- What's the relationship between multimedia content and accompanying text? Determine whether the media has standalone content or whether there's context in surrounding documents that you should use when processing the media.

#### Determine your table, chart, and other media-processing requirements

To determine how to process the information encapsulated in tables, charts, and other media, understand its characteristics. The following questions can help you understand your table, chart, and other media-processing requirements.

- Does the document have charts that include numbers?

- Does the document contain tables?

  - Are the tables complex, such as nested tables, or noncomplex?

  - Are there captions for the tables?

  - How long are the tables? Long tables might require repeating headers in chunks.

- Are there other types of embedded media, like videos or audio?

- Are there any mathematical equations or scientific notations in the document?

## Gather representative test content

In this step, gather content that best represents the content that you use in your solution. The content must address the defined use case and answer the questions that you gathered in the question-gathering parallel phase. The content includes documents, images, videos, audio files, and any other media types that are part of your content collection.

### Considerations

Consider the following areas when you evaluate potential representative test content:

- **Pertinence:** The content must meet the business requirements of the conversational application. For example, if you build a chat bot that helps customers do banking operations, the content must meet that requirement. The content should include documents about opening or closing bank accounts, instructional videos about banking procedures, or audio recordings of customer service interactions. The content must be able to address the test questions that you gather in the parallel step. If the content doesn't have information that's relevant to the questions, your solution can't produce a valid response.

- **Representation:** The content should represent the different types of content that your solution uses. For example, a car insurance document contains different information than a health or life insurance document, and a video demonstration might convey information differently than a written procedure. Suppose that the use case requires the solution to support all three of these insurance types across multiple media formats, but you only have car insurance documents. Your solution might run poorly for health and life insurance operations or might not use the rich information available in multimedia content. You should have at least two pieces of content for each variation and format.

- **Physical content quality:** The content needs to be in usable shape. Scanned images might not let you extract usable information, poor-quality audio recordings might not transcribe accurately, and low-resolution videos might not provide clear visual information.

- **Content quality:** The content must be high quality. Documents shouldn't contain misspellings or grammatical errors, audio should be clear and audible, and videos should have sufficient resolution and lighting. Language models and other AI services don't produce good results if you provide them with poor-quality content.

To successfully gather test content, you should be *qualitatively confident* that the test content completely and accurately represents your specific domain across all media types.

### Test content guidance

- Choose real content over synthetic content. Real content must go through a cleaning process to remove personal data, which is especially important for audio and video content that might contain voices, faces, or other identifying information.

- Consider selectively augmenting your content with synthetic data. This process helps you ensure that your content covers all kinds of scenarios, including predicted future scenarios. If you must use synthetic data, do your best to make it resemble real content as much as possible, including realistic audio quality, video characteristics, and visual elements.

- Make sure that the content can address the questions that you gather. Ensure that video content has clear visuals, audio content has clear speech, and multimedia content provides information that complements or supplements text-based content.

- Have at least two pieces of content for each content variant and format. For example, if you have instructional videos, include videos with different presenters, environments, or spoken language.

- Use language models, transcription services, computer vision models, and other tools to help you evaluate the quality of the content across all media types.

## Gather test queries

In this step, you gather test queries that you use to evaluate your chunks, your search solution, and your prompt engineering. Do this step while you gather the representative content. Gather the queries and determine how the representative content addresses those queries at the same time. By having both the sample queries and the parts of the sample content that address those queries, you can evaluate every stage of the RAG solution while you experiment with different strategies and approaches.

### Gather test query output

The output of this phase includes content from the [gather representative test queries](#gather-test-queries) step and the [gather representative test content](#gather-representative-test-content) step. The output is a collection that contains the following data:

- **Query:** The question, which represents a legitimate user's potential prompt.

- **Context:** A collection of the actual text in the documents that address the query. For each bit of context, you should include the page and the actual text.

- **Answer:** A valid response to the query. The response can be content that's directly from the documents, or it might be rephrased from one or more pieces of context.

### Create synthetic queries

It's often challenging for the subject matter experts (SMEs) for a particular domain to put together a comprehensive list of questions for the use case. One solution to this challenge is to generate synthetic questions from the representative test documents that you gather. The following steps describe a real-world approach to generating synthetic questions from representative documents:

1. **Chunk the documents.** Break down the documents into chunks. Don't use the chunking strategy for your overall solution. Use this one-off step that you use to generate synthetic queries. You can do the chunking manually if the number of documents is reasonable.
1. **Generate queries for each chunk.** For each chunk, generate queries either manually or by using a language model. When you use a language model, you usually start by generating two queries for each chunk. You can also use the language model to create the answer. The following example shows a prompt that generates questions and answers for a chunk.

    ```text
    Please read the following CONTEXT and generate two question and answer JSON objects in an array based on the CONTEXT provided. The questions should require deep reading comprehension, logical inference, deduction, and connecting ideas across the text. Avoid simplistic retrieval or pattern-matching questions. Instead, focus on questions that test the ability to reason about the text in complex ways, draw subtle conclusions, and combine multiple pieces of information to arrive at an answer. Ensure that the questions are relevant, specific, and cover the key points of the CONTEXT. Provide concise answers to each question, and directly quote the text from the provided context. Provide the array output in strict JSON format as shown in the output format. Ensure that the generated JSON is completely structurally correct, including proper nesting, comma placement, and quotation marks. There shouldn't be a comma after the last element in the array.

    Output format:
    [
      {
        "question": "Question 1",
        "answer": "Answer 1"
      },
      {
        "question": "Question 2",
        "answer": "Answer 2"
      }
    ]

    CONTEXT:
    ```

1. **Verify the output.** Verify that the questions are pertinent to the use case and that the answers address the question. A SME should review and validate the output.

### Unaddressed queries

It's important to gather queries that the documents don't address and the queries that they do address. When you test your solution, and especially when you test the language model, you need to determine how the solution should respond to queries that it doesn't have sufficient context to answer. To respond to queries that the solution can't address, the solution can:

- State that it doesn't know the answer.

- State that it doesn't know the answer and provide a link where the user might find more information.

### Gather test queries for multimedia content

Like with text, you should gather a diverse set of questions that involve using multimedia content to generate highly relevant answers. If you have images with graphs, tables, or screenshots, make sure that you have questions that cover all of the use cases. If you have videos with demonstrations, presentations, or visual information, include questions that require understanding the visual content. For audio content with spoken information, interviews, or presentations, ensure you have questions that test the system's ability to extract and reason about the spoken content.

If you determine in the content analysis step that the text before or after the multimedia is required to answer some questions, make sure that you have those questions in your test queries. Also consider questions that require combining information from multiple media types, such as questions that require understanding both written documents and related instructional videos.

### Gather test queries guidance

- Determine whether there's a system that contains real customer questions that you can use. For example, if you build a chat bot to answer customer questions, you might be able to use customer questions from your help desk, FAQs, or ticketing system.

- The customer or SME for the use case should act as a quality gate to determine whether the gathered documents, the associated test queries, and the answers to the queries from the documents are comprehensive, representative, and correct.

- Review the body of questions and answers periodically to ensure that they continue to accurately reflect the source documents.

## Next step

> [!div class="nextstepaction"]
> [Chunking phase](./rag-chunking-phase.md)

## Related resource

- [Get started with the chat by using your own data sample for Python](/azure/developer/python/get-started-app-chat-template)
