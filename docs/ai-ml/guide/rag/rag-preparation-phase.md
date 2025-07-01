---
title: Develop a RAG Solution - Preparation Phase
description: Learn about what to consider when you gather test documents and queries. Use this information to test and validate your chunking and prompt-engineering strategies.
author: claytonsiemens77
ms.author: pnp
ms.date: 12/15/2024
ms.topic: conceptual
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
ms.custom: arb-aiml
---

# RAG preparation phase

The first phase of Retrieval-Augmented Generation (RAG) development and experimentation is the preparation phase. During this phase, you define the business domain for your solution. After you define the domain, you gather documents, perform document analysis, and gather sample questions that are pertinent to the domain. You do these steps in parallel because they're interrelated. For example, document analysis helps you determine which test documents and test queries you should gather. The questions that you ask must be answerable by content in the documents, and the documents must answer the relevant questions.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.md).

## Determine the solution domain

The first step in this process is to clearly define the business requirements for the solution or use case. These requirements help you determine what kind of questions the solution should answer and what source data or documents help answer those questions. In later phases, the solution domain helps inform your embedding model strategy.

## Document analysis

The goal of document analysis is to gather enough information about your document collection to help you understand:

- The different classifications of documents. For example, you might have product specifications, quarterly reports, car insurance contracts, or health insurance contracts.

- The different types of documents. For example, you might have PDFs, Markdown files, HTML files, or DOCX files.

- The security constraints. For example, you might require authentication and authorization to access the documents depending on whether they're publicly accessible.

- The structure of the documents. For example, the length of documents might vary. Or they might have topic breaks, contextually relevant images, or tabular data.


The following sections describe how this information helps you choose your loading and chunking strategies.

### Classification of documents

You need to understand the different classifications of documents to help you determine the number of test documents that you need. This part of the analysis should tell you about the high-level classifications, such as insurance or finance. It should also tell you about subclassifications, such as health insurance documents or car insurance documents. You also want to know whether the subclassifications have different structures or content.

The goal is to understand all of the different document variants that you have. Then you can determine the number and breakdown of test documents that you need. You don't want to over or under represent a specific document classification in your experimentation.

### Document types

Understanding the different file formats in your collection helps you determine the number and breakdown of test documents. For example, if you have PDF and Open XML document types for quarterly reports, you need test documents for each of those document types. Understanding your document types also helps you understand your technical requirements for loading and chunking your documents. These technical requirements include specific libraries that can process those file formats.

### Security constraints

Understanding security constraints is crucial for determining your loading and chunking strategies. For example, you need to identify whether some or all of your documents require authentication, authorization, or network visibility. If the documents are within a secure perimeter, ensure that your code can access them or implement a process to securely replicate the documents to an accessible location for your processing code.

Documents sometimes reference multimedia like images or audio that are important to the context of the document. That media might also be subject to similar access controls as the document itself. If that media requires authentication or network line of sight, you need to make sure that your code can access the media or that you have a process in place that has access and can replicate the content.

If your workload requires that different users only have access to distinct documents or document segments, ensure that you understand how to retain those access permissions in your chunking solution.

### Document structure

You need to understand the structure of the document, including its layout and the types of content in the document. Understanding the structure and content of your documents helps you make the following determinations:

- Whether the document requires preprocessing to clean up noise, extract media, reformat content, or annotate items to ignore

- Whether you want to ignore or exclude content in the document

- What parts of the document that you want to capture

- How you want to chunk the document

- How you want to handle images, tables, charts, and other embedded media

The following sections list categorized questions that you can use to help you make some of these determinations.

#### Determine the items that you can ignore

Some structural elements might not add meaning to the document and can safely be ignored when chunking. In some situations, these elements can add valuable context and improve the relevancy of queries to your index, but not all. Ask the following questions about common document features to see whether they add relevancy or should be ignored.

- Does the document contain a table of contents?

- Are there headers or footers?

- Are there copyrights or disclaimers?

- Are there footnotes or endnotes?

- Are there watermarks?

- Are there annotations or comments?

#### Determine a preprocessing and chunking strategy

The following questions about the structure of the document can help you decide whether you need to preprocess the document to make it easier to process. They also help you choose a chunking strategy.

- Are there multicolumn data or multicolumn paragraphs? You don't want to parse multicolumn content the same way as single-column content.

- How is the document structured? For example, HTML files sometimes use tables that need to be differentiated from embedded tabular data.

- How many paragraphs are there? How long are the paragraphs? Are the paragraphs similar in length?

- What languages, language variants, or dialects are in the documents?

- Does the document contain Unicode characters?

- How are numbers formatted? Do they include commas or decimals? Are they consistent?

- Which parts of the document are uniform, and which parts aren't uniform?

- Is there a header structure where semantic meaning can be extracted?

- Are there bullets or meaningful indentations?

#### Determine your image processing requirements

Understanding the images in your document can help you choose an image processing strategy. You need to know what kind of images you have, whether they have sufficient resolution to process, and whether the image contains all the required information. The following questions help you understand your image processing requirements.

- Does the document contain images?

- What resolution are the images?

- Is there text embedded in the images?

- Are there abstract images that don't add value? For example, icons might not add any semantic value. Adding a description for icons might be detrimental to your solution because the icon usually isn't relevant to the document's content.

- What's the relationship between the images and the surrounding text? Determine whether the images have standalone content or whether there's context around the image that you should use when you pass it to a language model. Captions are an example of surrounding text that might have valuable context that isn't included in the image.

- Is there rich textual representation, such as accessibility descriptions of the images?

#### Determine your table, chart, and other media-processing requirements

Understanding what information is encapsulated in tables, charts, and other media can help you decide how you want to process it. The following questions help you understand your table, chart, and other media-processing requirements.

- Does the document have charts that include numbers?

- Does the document contain tables?

  - Are the tables complex, such as nested tables, or noncomplex?

  - Are there captions for the tables?

  - How long are the tables? Long tables might require repeating headers in chunks.

- Are there other types of embedded media, like videos or audio?

- Are there any mathematical equations or scientific notations in the document?

## Gather representative test documents

In this step, gather documents that best represent the documents that you use in your solution. The documents must address the defined use case and answer the questions that you gathered in the question-gathering parallel phase.

### Considerations

Consider the following areas when you evaluate potential representative test documents:

- **Pertinence:** The documents must meet the business requirements of the conversational application. For example, if you build a chat bot that helps customers perform banking operations, the documents must meet that requirement. For example, the documents should show how to open or close a bank account. The documents must be able to address the test questions that you gather in the parallel step. If the documents don't have information that's relevant to the questions, your solution can't produce a valid response.

- **Representation:** The documents should represent the different types of documents that your solution uses. For example, a car insurance document contains different information than a health or life insurance document. Suppose that the use case requires the solution to support all three of these insurance types, but you only have car insurance documents. Your solution might perform poorly for health and life insurance operations. You should have at least two documents for each variation.

- **Physical document quality:** The documents need to be in usable shape. Scanned images, for example, might not let you extract usable information.

- **Document content quality:** The documents must have high-quality content. They shouldn't contain misspellings or grammatical errors. Language models don't perform well if you provide them with poor-quality content.

To successfully gather test documents, you should be *qualitatively confident* that the test documents fully and accurately represent your specific domain.

### Test document guidance

- Choose real documents over synthetic ones. Real documents must go through a cleaning process to remove personal data.

- Consider selectively augmenting your documents with synthetic data. This process helps you ensure that your documents cover all kinds of scenarios, including predicted future scenarios. If you must use synthetic data, do your best to make it resemble real data as much as possible.

- Make sure that the documents can address the questions that you gather.

- Have at least two documents for each document variant.

- Use language models or other tools to help you evaluate the quality of the documents.

## Gather test queries

In this step, you gather test queries that you use to evaluate your chunks, your search solution, and your prompt engineering. Do this step while you gather the representative documents. You should gather the queries and determine how the representative documents address those queries at the same time. By having both the sample queries and the parts of the sample documents that address those queries, you can evaluate every stage of the RAG solution while you experiment with different strategies and approaches.

### Gather test query output

The output of this phase includes content from the [gather representative test queries](#gather-test-queries) step and the [gather representative test documents](#gather-representative-test-documents) step. The output is a collection that contains the following data:

- **Query:** The question, which represents a legitimate user's potential prompt.

- **Context:** A collection of all the actual text in the documents that address the query. For each bit of context, you should include the page and the actual text.

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

1. **Verify the output.** Verify that the questions are pertinent to the use case and that the answers address the question. A SME should perform this verification.

### Unaddressed queries

It's important to gather queries that the documents don't address and the queries that they do address. When you test your solution, and especially when you test the language model, you need to determine how the solution should respond to queries that it doesn't have sufficient context to answer. To respond to queries that the solution can't address, the solution can:

- State that it doesn't know the answer.

- State that it doesn't know the answer and provide a link where the user might find more information.

### Gather test queries for embedded media

Like with text, you should gather a diverse set of questions that involve using the embedded media to generate highly relevant answers. If you have images with graphs, tables, or screenshots, make sure that you have questions that cover all of the use cases. If you determine in the [images portion of the document analysis step](#determine-your-image-processing-requirements) that the text before or after the image is required to answer some questions, make sure that you have those questions in your test queries.

### Gather test queries guidance

- Determine whether there's a system that contains real customer questions that you can use. For example, if you build a chat bot to answer customer questions, you might be able to use customer questions from your help desk, FAQs, or ticketing system.

- The customer or SME for the use case should act as a quality gate to determine whether the gathered documents, the associated test queries, and the answers to the queries from the documents are comprehensive, representative, and correct.

- Review the body of questions and answers periodically to ensure that they continue to accurately reflect the source documents.

## Next step

> [!div class="nextstepaction"]
> [Chunking phase](./rag-chunking-phase.md)

## Related resource

- [Get started with the chat by using your own data sample for Python](/azure/developer/python/get-started-app-chat-template)
