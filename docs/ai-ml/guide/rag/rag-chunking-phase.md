---
title: Develop a RAG Solution - Chunking Phase
description: Learn about the various chunking strategies like boundary based, custom code, and document analysis models. Also learn about how the document structure should influence your chunking strategy.
author: claytonsiemens77
ms.author: pnp
ms.date: 10/10/2025 
ms.topic: concept-article
ms.collection: ce-skilling-ai-copilot
ms.subservice: architecture-guide
---

# RAG chunking phase

After you gather your test documents and queries and perform a document analysis during the [preparation phase](./rag-preparation-phase.md), you move to the next phase, which is chunking. Chunking is where you break documents into appropriately sized chunks that each contain semantically relevant content. It's crucial to a successful retrieval-augmented generation (RAG) implementation. If you try to pass entire documents or oversized chunks, it's expensive, might overwhelm the token limits of the model, and doesn't produce the best results. Also, if you pass information to a language model that's irrelevant to the query, it can result in inaccurate or unrelated responses. You must use effective chunking and searching strategies to optimize the process, pass relevant information, and remove irrelevant information. This approach minimizes false positives and false negatives, and maximizes true positives and true negatives.

Chunks that are too small and don't contain sufficient context to address the query can result in poor outcomes. Relevant context that exists across multiple chunks might not be captured. The key is to implement effective chunking approaches for your specific document types and their specific structures and content. There are various chunking approaches to consider, each with their own cost implications and effectiveness, depending on the type and structure of the document that you apply them to.

This article describes various chunking approaches and examines how the structure of your documents can influence the chunking approach that you choose.

This article is part of a series. Read the [introduction](./rag-solution-design-and-evaluation-guide.md) before you continue.

## Understand chunking economics

When you determine your overall chunking strategy, consider your budget, quality, and throughput requirements for document collection. There are engineering costs for the design and implementation of each unique chunking implementation and per-document processing costs that differ depending on the approach. If your documents contain embedded or linked media, you must consider the economics of processing those elements. For chunking, this processing generally uses language models to generate descriptions of the media. Those descriptions are then chunked. An alternative approach for some media is to pass them as-is to a multimodal model at inferencing time. But this approach doesn't affect the chunking economics.

The following sections examine the economics of chunking images and the overall solution.

### Understand image chunking economics

A language model that generates a description of an image that you chunk incurs extra cost. For example, cloud-based services such as Azure OpenAI Service either charge on a per-transaction basis or on a prepaid provisioning basis. Larger images incur a larger cost. Through your document analysis, you determine which images are valuable to chunk and which images to ignore. From there, you need to understand the number and sizes of the images in your solution. You then weigh the value of chunking the image descriptions against the cost to generate those descriptions.

Use a service such as [Azure AI Vision](/azure/ai-services/computer-vision) to determine which images you want to process. You can classify images, tag images, or do logo detection. You can use the results and confidence indicators to determine whether the image adds meaningful, contextual value and should be processed. Calls to Vision might be less expensive than calls to language models, so this approach could result in cost savings. Experiment to determine what confidence levels and classifications or tags provide the best results for your data. Also consider the following alternatives:

- Build your own classifier model. If you take this approach, be sure you consider the costs to build, host, and maintain your own model.

- Use a language model to classify and tag images. This approach gives you more flexibility in your design but can be less predictable than using Vision. When possible, experiment with both approaches and compare the results.

Another cost optimization strategy is to cache by using the [Cache-Aside pattern](/azure/architecture/patterns/cache-aside). You can generate a key that you base on the hash of the image. As a first step, check to see if you have a cached result from a prior run or previously processed document. If you do, you can use that result. This approach eliminates the costs of calling a classifier or a language model. If there's no cache, when you call to the classifier or language model, you cache the result. Future calls for this image use the cache.

The following workflow integrates these cost optimization processes:

1. Check to see if the image processing is cached. If so, use the cached results.

1. Run your classifier to determine whether you should process the image. Cache the classification result. If your classification logic determines that the image adds value, proceed to the next step.

1. Generate the description for your image. Cache the result.

### Consider the economics of your overall solution

Consider the following factors when you assess the cost of your overall solution:

- **Number of unique chunking implementations:** Each unique implementation has engineering and maintenance costs. Consider the number of unique document types in your collection and the cost versus quality trade-offs of unique implementations for each.

- **Per-document cost of each implementation:** Some chunking approaches might result in better quality chunks but have a higher financial and temporal cost to generate those chunks. For example, using a prebuilt model in Azure AI Document Intelligence likely has a higher per-document cost than a pure text parsing implementation, but might result in better chunks.

- **Number of initial documents:** The number of initial documents that you need to process to launch your solution.

- **Number of incremental documents:** The number and rate of new documents that you must process for ongoing maintenance of the system.

## Understand loading and chunking

During chunking, you must first load the document into memory in some format. The chunking code then operates against the in-memory representation of the document. You can combine the loading code with chunking, or separate loading into its own phase. Choose an approach based on architectural constraints and your preferences. The following sections briefly explore both options and provide general recommendations.

### Separate loading and chunking

There are several reasons why you would choose to separate the loading and chunking phases. You might want to encapsulate logic in the loading code. You might want to persist the result of the loading code before chunking, especially when you experiment with various chunking permutations to save on processing time or cost. Lastly, you might want to run the loading and chunking code in separate processes for architectural reasons, such as process bulkheading or security segmentation that involves removing personal data.

#### Encapsulate logic in the loading code

You can choose to encapsulate preprocessing logic in the loading phase. This approach simplifies the chunking code because it doesn't require any preprocessing. Preprocessing can be as simple as removing or annotating parts of the document that you want to ignore in document analysis. For example, you might want to remove watermarks, headers, and footers. Or preprocessing can involve more complex tasks such as reformatting the document. For example, you can include the following preprocessing tasks in the loading phase:

- Remove or annotate items that you want to ignore.

- Replace image references with image descriptions. During this phase, you use a large language model to generate a description for an image and update the document with that description. If during document analysis, you find surrounding text that provides valuable context, you can pass the text and the image to the large language model.

- Download or copy images to file storage like Azure Data Lake Storage to be processed separately from the document text. If during document analysis, you find surrounding text that provides valuable context to the image, you can store this text along with the image in file storage.

- Reformat tables so that they're more easily processed.

- Define document structure based on headings, subheadings, and other structural elements. Use a tool like [Document Intelligence](/azure/ai-services/document-intelligence/overview) when practical to reduce development overhead. Or you can use a library like Python if you have sensitive data that you can't send to an external system.

#### Persist the result of the loading code

There are multiple reasons why you might choose to persist the result of the loading code. If you want the ability to inspect the documents after they're loaded and preprocessed, but before the chunking logic runs. Or you want to run different chunking logic against the same preprocessed code while it's in development or in production. Persisting the loaded code speeds up the process.

#### Run loading and chunking code in separate processes

When you separate the processes, it helps you run multiple chunking implementations against the same preprocessed code. You can also run loading and chunking code in different compute environments and on different hardware. This design helps you independently scale the compute that you use for loading and chunking.

#### Combine loading and chunking

In most cases, combining your loading and chunking code is a simpler implementation. Many preprocessing operations that you might consider doing in a separate loading phase can run during the chunking phase. For example, instead of replacing image URLs with a description in the loading phase, the chunking logic can make calls to the large language model to get a text description and chunk the description.

When you have document formats like HTML that contain tags with references to images, ensure that the reader or parser that the chunking code uses doesn't remove the tags. The chunking code must be able to identify image references.

#### Consider the chunking recommendations

Consider the following recommendations on whether to combine or separate your chunking logic.

- Start by combining your loading and chunking logic. Separate them when your solution requires it.

- Avoid converting documents to an intermediate format if you choose to separate the processes. This type of operation can result in data loss.

## Review the chunking approaches

This section provides an overview of common chunking approaches. You can use multiple approaches in implementation, such as combining the use of a language model to get a text representation of an image with many of the listed approaches.

A summarized decision-making matrix accompanies each approach. The matrix highlights the tools, associated costs, and more. The engineering effort and processing costs described here are subjective and included for relative comparison.

>[!IMPORTANT]
>Your chunking approach is a semipermanent choice in your overall solution design. Do a thorough comparison of the approaches to find the best fit for your use case and content type prior to choosing one to use in production. When you change chunking strategies, it can significantly affect downstream processes and require changes throughout the workflow.

### Fixed-size parsing, with overlap

This approach breaks down a document into chunks based on a fixed number of characters or tokens and allows overlap of characters between chunks. This approach has many of the same advantages and disadvantages as sentence-based parsing. One advantage of this approach over sentence-based parsing is the ability to obtain chunks with semantic meanings that span multiple sentences.

You must choose the fixed size of the chunks and the amount of overlap. Because the results vary for different document types, it's best to use a tool like the Hugging Face chunk visualizer to do exploratory analysis. You can use tools like this to visualize how your documents are chunked based on your decisions. You should use bidirectional encoder representations from transformers (BERT) tokens instead of character counts when you use fixed-sized parsing. BERT tokens are based on meaningful units of language, so they preserve more semantic information than character counts.

**Tools:** [LangChain recursive text splitter](https://docs.langchain.com/oss/javascript/integrations/splitters/index#text-splitters), [Hugging Face chunk visualizer](https://huggingface.co/spaces/m-ric/chunk_visualizer)  
**Engineering effort:** Low  
**Processing cost:** Low  
**Use cases:** Unstructured documents written in prose or nonprose with complete or incomplete sentences. Your collection of documents contains a prohibitive number of different document types that require individual chunking strategies.  
**Examples:** User-generated content like open-ended feedback from surveys, forum posts, reviews, email messages, personal notes, research notes, and lists  

### Semantic chunking

This approach uses embeddings to group conceptually similar content across a document to create chunks. Semantic chunking can produce easily understandable chunks that closely align to the content's subjects. The logic for this approach can search a document or set of documents to find recurring information and create chunks that group the mentions or sections together. This approach can be more costly because it requires you to develop complex custom logic.

**Tools:** Custom implementation. Natural language processing (NLP) tools like spaCy can help with sentence-based parsing.  
**Engineering effort:** High  
**Processing cost:** High  
**Use cases:** Documents that have topical overlap throughout their sections  
**Examples:** Financial or healthcare-focused documentation  

### Custom code

This approach parses documents by using custom code to create chunks. The custom code approach works best for text-based documents where the structure is known or can be inferred. The custom code approach requires a high degree of control over chunk creation. You can use text parsing techniques like regular expressions to create chunks based on patterns within the document's structure. The goal is to create chunks that have similar size in length and chunks that have distinct content. Many programming languages provide support for regular expressions, and some have libraries or packages that provide more elegant string manipulation features.

**Tools:** [Python](https://docs.python.org/3/) ([re](https://docs.python.org/3/library/re.html), [regex](https://pypi.org/project/regex/), [BeautifulSoup](https://pypi.org/project/BeautifulSoup/), [lxml](https://pypi.org/project/lxml/), [html5lib](https://pypi.org/project/html5lib/), [marko](https://pypi.org/project/marko/)), [R](https://www.r-project.org/other-docs.html) ([stringr](https://cran.r-project.org/web/packages/stringr/index.html), [xml2](https://xml2.r-lib.org/reference/read_xml.html)), [Julia](https://docs.julialang.org/en/v1/) ([Gumbo.jl](https://github.com/JuliaWeb/Gumbo.jl))  
**Engineering effort:** Medium  
**Processing cost**: Low  
**Use cases:** Semi-structured documents where structure can be inferred  
**Examples:** Patent filings, research papers, insurance policies, scripts, and screenplays

### Language model augmentation

You can use language models to create chunks. For example, use a large language model, such as GPT-4, to generate textual representations of images or summaries of tables that become chunks. Language model augmentation is often used with other chunking approaches such as custom code.

If your document analysis determines that the text before or after the image helps [answer some requirement questions](./rag-preparation-phase.md#determine-your-image-preprocessing-requirements), pass this extra context to the language model. It's important to experiment to determine whether this extra context improves the performance of your solution.

If your chunking logic splits the image description into multiple chunks, include the image URL in each chunk to ensure that metadata is returned for all queries that the image serves. This step is crucial for scenarios where the user needs to access the source image through that URL or use raw images during inferencing time.

**Tools:** [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service), [OpenAI](https://platform.openai.com/docs/introduction)  
**Engineering effort:** Medium  
**Processing cost:** High  
**Use cases:** Images, tables  
**Examples:** Generate text representations of tables and images, summarize transcripts from meetings, speeches, interviews, or podcasts

### Document layout analysis

Document layout analysis libraries and services combine optical character recognition (OCR) capabilities with deep learning models to extract both the structure and text of documents. Structural elements can include headers, footers, titles, section headings, tables, and figures. The goal is to provide better semantic meaning to content that the documents contain.

Document layout analysis libraries and services expose a model that represents the structural and textual content of the document. You still have to write code that interacts with the model.

> [!NOTE]
> Document Intelligence is a cloud-based service that requires you to upload your document. You must ensure that your security and compliance regulations enable you to upload documents to such services.

**Tools:** [Document Intelligence document analysis models](/azure/ai-services/document-intelligence/overview#document-analysis-models), [Donut](https://github.com/clovaai/donut/), [Layout Parser](https://layout-parser.github.io/)  
**Engineering effort:** Medium  
**Processing cost:** Medium  
**Use cases:** Semi-structured documents  
**Examples:** News articles, web pages, and resumes

### Graph-based chunking

Graph-based chunking is an iterative approach that involves using a language model to find entities, like keywords, in documents and to build a graph based on their relationships. You can start with a simpler chunking strategy, like paragraph-based, to make the graph-building process more efficient. After you have your initial chunks, you can analyze each one to find entities and relationships and build your global graph structure. You can append the graph as you iterate through the chunks.

**Tools:** [Microsoft GraphRAG](https://microsoft.github.io/graphrag/), Neo4J  
**Engineering effort:** High  
**Processing cost:** High  
**Use cases:** Diverse statistical data  
**Examples:** Sports analytics, historical data, and any domain that requires unplanned quantitative queries across documents  

### Prebuilt model

Services such as Document Intelligence provide prebuilt models that you can use for various document types. Some models are trained for specific document types, such as the U.S. W-2 tax form, while others target a broader genre of document types such as invoices.

**Tools:** [Document Intelligence prebuilt models](/azure/ai-services/document-intelligence/overview#prebuilt-models), [Power Automate intelligent document processing](https://www.microsoft.com/power-platform/products/power-automate/topics/business-process/intelligent-document-processing), [LayoutLMv3](https://huggingface.co/microsoft/layoutlmv3-base)  
**Engineering effort:** Low  
**Processing cost:** Medium/High  
**Use cases:** Structured documents where a prebuilt model exists  
**Examples:** Invoices, receipts, health insurance cards, and W-2 forms  

### Custom model

For highly structured documents where no prebuilt model exists, you might have to build a custom model. This approach can be effective for images or documents that are highly structured, which makes using text parsing techniques difficult.

**Tools:** [Document Intelligence custom models](/azure/ai-services/document-intelligence/overview#custom-models), [Tesseract](https://github.com/tesseract-ocr/tessdoc)  
**Engineering effort:** High  
**Processing cost:** Medium/High  
**Use cases:** Structured documents where a prebuilt model doesn't exist  
**Examples:** Automotive repair and maintenance schedules, academic transcripts, records, technical manuals, operational procedures, and maintenance guidelines

### Sentence-based parsing

Sentence-based parsing is a straightforward approach that breaks text documents into chunks, which are composed of complete sentences. Use this approach as a fallback solution if none of the other approaches described here fit your use case. The advantages of this approach include its low implementation and processing costs and its applicability to any text-based document that contains prose or full sentences. One drawback of this approach is that each chunk might not capture the full context of an idea or meaning. Multiple sentences must often be taken together to capture the semantic meaning.

**Tools:** [spaCy sentence tokenizer](https://spacy.io/api/tokenizer), [LangChain recursive text splitter](https://docs.langchain.com/oss/javascript/integrations/splitters/index#text-splitters), [NLTK sentence tokenizer](https://www.nltk.org/api/nltk.tokenize.html)  
**Engineering effort:** Low  
**Processing cost:** Low  
**Use cases:** Unstructured documents written in prose or full sentences. Your collection of documents contains a prohibitive number of different document types, which require individual chunking strategies  
**Examples:** User-generated content like open-ended feedback from surveys, forum posts, reviews, email messages, novels, or essays

## Document structure

Documents vary in their type of structure. Some documents, like government forms, have a complex and well-known structure, such as a U.S. W-2 tax form. At the other end of the spectrum are unstructured documents like free-form notes. The degree of structure in a document type is a good starting point to determine an effective chunking approach. While there are no specific rules, this section provides you with some guidelines to follow.

:::image type="complex" source="./_images/chunking-approaches-by-document-structure.png" lightbox="_images/chunking-approaches-by-document-structure.png" alt-text="Diagram that shows chunking approaches by document structure." border="false":::
   The diagram shows document structure from high to low on the X axis. It ranges from (high) structured, semi-structured, inferred, and unstructured (low). The next line up shows examples with W-2 between high and structured. It shows an invoice between structured and semi-structured. It shows a web page between semi-structured and inferred. It shows European Union (EU) regulation between inferred and unstructured, and lastly, field notes between unstructured and low. Over the X axis are six chunking approaches. Each approach indicates where it's most effective. Prebuilt models are most effective for structured documents. Custom models are most effective for semi-structured documents. Document analysis models are most effective for semi-structured to inferred documents. Custom code is most effective for semi-structured to inferred documents. Boundary-based approaches are most effective for inferred to unstructured documents. Sentence-based approaches are most effective for unstructured documents.
:::image-end:::

### Structured documents

Structured documents, sometimes referred to as fixed-format documents, contain defined layouts. The data in these documents is located at fixed locations. For example, the date, or customer family name, is in the same location of every document that has the same fixed format.

Fixed-format documents might be scanned images of original documents that are hand-filled or have complex layout structures. This format makes them difficult to process by using a basic text parsing approach. A typical approach to processing complex document structures is to use machine learning models to extract data and apply semantic meaning to that data, when possible.

**Examples:** W-2 form and insurance card  
**Typical approaches:** Prebuilt models and custom models

### Semi-structured documents

Semi-structured documents don't have a fixed format or schema, like the W-2 form, but they provide consistency regarding format or schema. For example, invoices vary in layout, but they generally have a consistent schema. You can expect an invoice to have an *invoice number* and some form of *bill to* and *ship to* name and address, among other data. A web page might not have schema consistencies, but they have similar structural or layout elements, such as *body*, *title*, *H1*, and *p* that can add semantic meaning to the surrounding text.

Like structured documents, semi-structured documents that have complex layout structures are difficult to process by using text parsing. For these document types, machine learning models are a good approach. There are prebuilt models for certain domains that have consistent schemas like invoices, contracts, or health insurance documents. Consider building custom models for complex structures where no prebuilt model exists.

**Examples:** Invoices, receipts, web pages, and Markdown files  
**Typical approaches:** Document analysis models

### Inferred structure

Some documents have a structure but aren't written in markup. For these documents, the structure must be inferred. A good example is the following EU regulation document.

:::image type="complex" border="true" source="./_images/eu-regulation-example.png" lightbox="./_images/eu-regulation-example.png" alt-text="Diagram that shows an EU regulation as an example of a document with inferred structure." :::
   The diagram shows an EU regulation. It shows that there's a structure that can be inferred. There are paragraphs numbered 1, 2, and 3. A, b, c, and d are bullet points for 1. I, ii, iii, iv, v, and vi are bullet points for item a.
:::image-end:::

Because you can clearly understand the structure of the document, and there are no known models for it, you must write custom code. This document format might not warrant the effort to create a custom model, depending on the number of different documents of this type that you work with. For example, if your collection contains all EU regulations or U.S. state laws, a custom model might be a good approach. If you work with a single document, like the EU regulation in the example, custom code might be more cost effective.

**Examples:** Law documents, scripts, and manufacturing specifications  
**Typical approaches:** Custom code and custom models

### Unstructured documents

A good approach for documents that have little to no structure are sentence-based or fixed-size with overlap.

**Examples:** User-generated content like open-ended feedback from surveys, forum posts, reviews, email messages, personal notes, and research notes  
**Typical approaches:** Sentence-based or boundary-based with overlap

### Experimentation

This article describes the most suitable chunking approaches for each document type, but in practice, any of the approaches might be appropriate for any document type. For example, sentence-based parsing might be appropriate for highly structured documents, or a custom model might be appropriate for unstructured documents. Part of optimizing your RAG solution is to experiment with various chunking approaches. Consider the number of resources that you have, the technical skill of your resources, and the volume of documents that you need to process. To achieve an optimal chunking strategy, test each approach and observe the advantages and trade-offs to ensure that you choose the best approach for your use case.

## Next step

> [!div class="nextstepaction"]
> [Chunk enrichment phase](./rag-enrichment-phase.md)

## Related resources

- [Chunking large documents for vector search solutions in Azure AI Search](/azure/search/vector-search-how-to-chunk-documents)
- [Integrated data chunking and embedding in Azure AI Search](/azure/search/vector-search-integrated-vectorization)
